import { useEffect, useState } from "react";

const apiUrl = import.meta.env.VITE_API_URL || "http://localhost:4000/api";

const initialSignUp = {
  name: "",
  email: "",
  password: ""
};

const initialLogin = {
  email: "",
  password: ""
};

export default function App() {
  const [mode, setMode] = useState("signup");
  const [signUpForm, setSignUpForm] = useState(initialSignUp);
  const [loginForm, setLoginForm] = useState(initialLogin);
  const [message, setMessage] = useState("");
  const [token, setToken] = useState(localStorage.getItem("demo-jwt") || "");
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (token) {
      localStorage.setItem("demo-jwt", token);
      fetchCurrentUser(token);
    } else {
      localStorage.removeItem("demo-jwt");
      setUser(null);
    }
  }, [token]);

  async function submit(path, payload) {
    setLoading(true);
    setMessage("");

    try {
      const response = await fetch(`${apiUrl}${path}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(payload)
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || "Request failed");
      }

      setToken(data.token);
      setMessage(`Success! Logged in as ${data.user.name}.`);
    } catch (error) {
      setMessage(error.message);
    } finally {
      setLoading(false);
    }
  }

  async function fetchCurrentUser(activeToken = token) {
    if (!activeToken) {
      return;
    }

    try {
      const response = await fetch(`${apiUrl}/auth/me`, {
        headers: {
          Authorization: `Bearer ${activeToken}`
        }
      });
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || "Unable to fetch the current user.");
      }

      setUser(data.user);
    } catch (error) {
      setMessage(error.message);
      setToken("");
    }
  }

  function handleLogout() {
    setToken("");
    setMessage("Logged out.");
  }

  return (
    <div className="page-shell">
      <div className="card">
        <div className="hero">
          <span className="eyebrow">MERN Auth Demo</span>
          <h1>Login Flow Assignment</h1>
          <p>Use this tiny React client to verify signup, login, JWT persistence, and profile fetch.</p>
        </div>

        <div className="mode-switch">
          <button className={mode === "signup" ? "active" : ""} onClick={() => setMode("signup")}>
            Sign up
          </button>
          <button className={mode === "login" ? "active" : ""} onClick={() => setMode("login")}>
            Log in
          </button>
        </div>

        {message ? <div className="message">{message}</div> : null}

        {mode === "signup" ? (
          <form
            className="form"
            onSubmit={(event) => {
              event.preventDefault();
              submit("/auth/signup", signUpForm);
            }}
          >
            <label>
              Name
              <input
                value={signUpForm.name}
                onChange={(event) => setSignUpForm({ ...signUpForm, name: event.target.value })}
                placeholder="Jacob Joseph"
              />
            </label>

            <label>
              Email
              <input
                value={signUpForm.email}
                onChange={(event) => setSignUpForm({ ...signUpForm, email: event.target.value })}
                placeholder="jacob@gmail.com"
              />
            </label>

            <label>
              Password
              <input
                type="password"
                value={signUpForm.password}
                onChange={(event) => setSignUpForm({ ...signUpForm, password: event.target.value })}
                placeholder="password123"
              />
            </label>

            <button className="primary" disabled={loading}>
              {loading ? "Creating..." : "Create account"}
            </button>
          </form>
        ) : (
          <form
            className="form"
            onSubmit={(event) => {
              event.preventDefault();
              submit("/auth/login", loginForm);
            }}
          >
            <label>
              Email
              <input
                value={loginForm.email}
                onChange={(event) => setLoginForm({ ...loginForm, email: event.target.value })}
                placeholder="jacob@gmail.com"
              />
            </label>

            <label>
              Password
              <input
                type="password"
                value={loginForm.password}
                onChange={(event) => setLoginForm({ ...loginForm, password: event.target.value })}
                placeholder="password123"
              />
            </label>

            <button className="primary" disabled={loading}>
              {loading ? "Signing in..." : "Log in"}
            </button>
          </form>
        )}

        <div className="profile-panel">
          <div>
            <h2>Current session</h2>
            {user ? (
              <div className="session-details">
                <p><strong>Name:</strong> {user.name}</p>
                <p><strong>Email:</strong> {user.email}</p>
                <p><strong>ID:</strong> {user._id}</p>
              </div>
            ) : (
              <p>No active session.</p>
            )}
          </div>

          <div className="session-actions">
            <button onClick={() => fetchCurrentUser()} disabled={!token || loading}>
              Fetch /me
            </button>
            <button onClick={handleLogout} disabled={!token || loading}>
              Clear token
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
