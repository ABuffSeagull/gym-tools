import { Elm } from "./src/Main.elm";

if (process.env.NODE_ENV === "development") {
  const ElmDebugTransform = await import("elm-debug-transformer");

  ElmDebugTransform.register({
    simple_mode: true,
  });
}

const app = Elm.Main.init({ node: document.querySelector("#app") });
