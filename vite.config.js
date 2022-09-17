import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";
import { VitePWA } from "vite-plugin-pwa";

export default defineConfig({
  plugins: [
    elmPlugin(),
    VitePWA({
      registerType: "autoUpdate",
      devOptions: {
        enabled: true,
      },
      manifest: {
        name: "Tools",
        short_name: "Tools",
        icons: [
          {
            src: "/android-chrome-192x192.png",
            sizes: "192x192",
            type: "image/png",
          },
        ],
        theme_color: "#ffffff",
        background_color: "#ffffff",
        start_url: "https://workout.abuffseagull.dev",
        display: "standalone",
        orientation: "portrait",
      },
    }),
  ],
});
