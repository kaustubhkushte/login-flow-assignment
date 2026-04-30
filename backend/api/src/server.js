import { connectDatabase } from "./config/db.js";
import { env } from "./config/env.js";
import { createApp } from "./app.js";
import { seedDefaultUser } from "./utils/seedDefaultUser.js";

const app = createApp();

async function start() {
  await connectDatabase(env.mongoUri);
  await seedDefaultUser();
  app.listen(env.port, () => {
    console.log(`Auth API listening on http://localhost:${env.port}`);
  });
}

start().catch((error) => {
  console.error("Failed to start API", error);
  process.exit(1);
});
