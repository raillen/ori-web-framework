import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";
import { resolve } from "node:path";

export default defineConfig({
  plugins: [svelte()],
  base: "/",
  build: {
    outDir: resolve(__dirname, "../public"),
    emptyOutDir: true,
    assetsDir: "assets",
  },
  server: {
    port: 5173,
    proxy: {
      "/api": "http://127.0.0.1:3461",
      "/healthz": "http://127.0.0.1:3461",
    },
  },
});
