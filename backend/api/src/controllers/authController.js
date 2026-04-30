import bcrypt from "bcryptjs";
import { User } from "../models/User.js";
import { createToken } from "../utils/jwt.js";
import { toUserPayload } from "../utils/userPayload.js";

function validateEmail(email) {
  return /\S+@\S+\.\S+/.test(email);
}

function serializeAuthResponse(user) {
  return {
    token: createToken(user._id.toString()),
    user: toUserPayload(user)
  };
}

export async function signup(req, res) {
  const name = req.body.name?.trim() || "";
  const email = req.body.email?.trim().toLowerCase() || "";
  const password = req.body.password || "";

  const errors = [];

  if (!name) {
    errors.push({ field: "name", message: "Name is required." });
  }
  if (!email) {
    errors.push({ field: "email", message: "Email is required." });
  } else if (!validateEmail(email)) {
    errors.push({ field: "email", message: "Email address is invalid." });
  }
  if (!password) {
    errors.push({ field: "password", message: "Password is required." });
  } else if (password.length < 6) {
    errors.push({ field: "password", message: "Password must be at least 6 characters." });
  }

  if (errors.length) {
    return res.status(422).json({
      message: "Please correct the highlighted fields.",
      errors
    });
  }

  const existingUser = await User.findOne({ email });
  if (existingUser) {
    return res.status(409).json({
      message: "An account with this email already exists.",
      errors: [{ field: "email", message: "Email is already registered." }]
    });
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const user = await User.create({ name, email, passwordHash });

  return res.status(201).json(serializeAuthResponse(user));
}

export async function login(req, res) {
  const email = req.body.email?.trim().toLowerCase() || "";
  const password = req.body.password || "";

  if (!email || !password) {
    return res.status(422).json({
      message: "Email and password are required.",
      errors: [
        ...(!email ? [{ field: "email", message: "Email is required." }] : []),
        ...(!password ? [{ field: "password", message: "Password is required." }] : [])
      ]
    });
  }

  const user = await User.findOne({ email });
  if (!user) {
    return res.status(401).json({ message: "Invalid email or password." });
  }

  const passwordMatches = await bcrypt.compare(password, user.passwordHash);
  if (!passwordMatches) {
    return res.status(401).json({ message: "Invalid email or password." });
  }

  return res.status(200).json(serializeAuthResponse(user));
}

export async function me(req, res) {
  return res.status(200).json({
    user: toUserPayload(req.user)
  });
}
