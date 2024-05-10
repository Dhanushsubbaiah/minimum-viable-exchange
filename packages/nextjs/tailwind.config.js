/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{js,ts,jsx,tsx}", "./components/**/*.{js,ts,jsx,tsx}", "./utils/**/*.{js,ts,jsx,tsx}"],
  plugins: [require("daisyui")],
  darkTheme: "dark",
  // DaisyUI theme colors
  daisyui: {
    themes: [
      {
        light: {
          primary: "#60a5fa",
          "primary-content": "#026262",
          secondary: "#f8fafc",
          "secondary-content": "#088484",
          accent: "#020617",
          "accent-content": "#E9FBFF",
          neutral: "#088484",
          "neutral-content": "#F0FCFF",
          "base-100": "#F0FCFF",
          "base-200": "#E1FAFF",
          "base-300": "#C8F5FF",
          "base-content": "#020617",
          info: "#026262",
          success: "#34EEB6",
          warning: "#FFCF72",
          error: "#FF8863",

          "--rounded-btn": "9999rem",

          ".tooltip": {
            "--tooltip-tail": "6px",
          },
          ".link": {
            textUnderlineOffset: "2px",
          },
          ".link:hover": {
            opacity: "80%",
          },
        },
      },
      {
        dark: {
          primary: "#0c4a6e",
          "primary-content": "#C8F5FF",
          secondary: "#0a0a0a",
          "secondary-content": "#E9FBFF",
          accent: "#f8fafc",
          "accent-content": "#0891b2",
          neutral: "#E9FBFF",
          "neutral-content": "#0077CC",
          "base-100": "#1f2937",
          "base-200": "#0891b2",
          "base-300": "#0284c7",
          "base-content": "#E9FBFF",
          info: "#C8F5FF",
          success: "#34EEB6",
          warning: "#FFCF72",
          error: "#FF8863",

          "--rounded-btn": "9999rem",

          ".tooltip": {
            "--tooltip-tail": "6px",
            "--tooltip-color": "oklch(var(--p))",
          },
          ".link": {
            textUnderlineOffset: "2px",
          },
          ".link:hover": {
            opacity: "80%",
          },
        },
      },
    ],
  },
  theme: {
    extend: {
      fontFamily: {
        "space-grotesk": ["Space Grotesk", "sans-serif"],
      },
      boxShadow: {
        center: "0 0 12px -2px rgb(0 0 0 / 0.05)",
      },
      animation: {
        "pulse-fast": "pulse 1s cubic-bezier(0.4, 0, 0.6, 1) infinite",
      },
    },
  },
};
