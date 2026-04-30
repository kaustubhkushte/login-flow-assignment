import mongoose from "mongoose";
import request from "supertest";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { MongoMemoryServer } from "mongodb-memory-server";
import { createApp } from "../src/app.js";
import { connectDatabase, disconnectDatabase } from "../src/config/db.js";
import { User } from "../src/models/User.js";

const app = createApp();
let mongoServer;

describe("auth routes", () => {
  beforeAll(async () => {
    mongoServer = await MongoMemoryServer.create();
    await connectDatabase(mongoServer.getUri());
  });

  beforeEach(async () => {
    await User.deleteMany({});
  });

  afterAll(async () => {
    await disconnectDatabase();
    await mongoServer.stop();
    await mongoose.connection.close();
  });

  it("creates a user on signup", async () => {
    const response = await request(app).post("/api/auth/signup").send({
      name: "Jacob Joseph",
      email: "jacob@gmail.com",
      password: "password123"
    });

    expect(response.statusCode).toBe(201);
    expect(response.body.token).toBeTypeOf("string");
    expect(response.body.user.email).toBe("jacob@gmail.com");
  });

  it("rejects duplicate signup", async () => {
    await User.create({
      name: "Existing User",
      email: "jacob@gmail.com",
      passwordHash: "secret"
    });

    const response = await request(app).post("/api/auth/signup").send({
      name: "Jacob Joseph",
      email: "jacob@gmail.com",
      password: "password123"
    });

    expect(response.statusCode).toBe(409);
  });

  it("logs in an existing user", async () => {
    await request(app).post("/api/auth/signup").send({
      name: "Jacob Joseph",
      email: "jacob@gmail.com",
      password: "password123"
    });

    const response = await request(app).post("/api/auth/login").send({
      email: "jacob@gmail.com",
      password: "password123"
    });

    expect(response.statusCode).toBe(200);
    expect(response.body.token).toBeTypeOf("string");
  });

  it("rejects invalid credentials", async () => {
    const response = await request(app).post("/api/auth/login").send({
      email: "jacob@gmail.com",
      password: "wrongpass"
    });

    expect(response.statusCode).toBe(401);
  });

  it("rejects unauthenticated me requests", async () => {
    const response = await request(app).get("/api/auth/me");

    expect(response.statusCode).toBe(401);
  });

  it("returns the current user when authenticated", async () => {
    const signupResponse = await request(app).post("/api/auth/signup").send({
      name: "Jacob Joseph",
      email: "jacob@gmail.com",
      password: "password123"
    });

    const response = await request(app)
      .get("/api/auth/me")
      .set("Authorization", `Bearer ${signupResponse.body.token}`);

    expect(response.statusCode).toBe(200);
    expect(response.body.user.name).toBe("Jacob Joseph");
  });
});
