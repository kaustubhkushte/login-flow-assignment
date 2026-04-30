import bcrypt from "bcryptjs";
import { env } from "../config/env.js";
import { User } from "../models/User.js";

function hasSeedConfiguration() {
  return Boolean(
    env.defaultUserName.trim() &&
    env.defaultUserEmail.trim() &&
    env.defaultUserPassword
  );
}

export async function seedDefaultUser() {
  if (!hasSeedConfiguration()) {
    console.log("Default user seed skipped: env values not fully configured.");
    return;
  }

  const email = env.defaultUserEmail.trim().toLowerCase();
  const existingUser = await User.findOne({ email });

  if (existingUser) {
    console.log(`Default user seed skipped: ${email} already exists.`);
    return;
  }

  const passwordHash = await bcrypt.hash(env.defaultUserPassword, 10);

  await User.create({
    name: env.defaultUserName.trim(),
    email,
    passwordHash
  });

  console.log(`Default user created: ${email}`);
}
