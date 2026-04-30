import dotenv from "dotenv";

dotenv.config();

export const env = {
  port: Number(process.env.PORT || 4000),
  mongoUri: process.env.MONGO_URI || "mongodb://127.0.0.1:27017/login-flow-assignment",
  jwtSecret: process.env.JWT_SECRET || "super-secret-demo-key",
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || "1d",
  clientOrigin: process.env.CLIENT_ORIGIN || "http://localhost:5173",
  defaultUserName: process.env.DEFAULT_USER_NAME || "",
  defaultUserEmail: process.env.DEFAULT_USER_EMAIL || "",
  defaultUserPassword: process.env.DEFAULT_USER_PASSWORD || ""
};
