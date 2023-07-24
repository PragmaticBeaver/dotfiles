module.exports = {
  env: {
    browser: true,
    es2021: true,
  },
  extends: [
    "eslint:recommended", 
    // "prettier", // Prettier & eslint-plugin-import
    // "plugin:import/recommended" // eslint-config-prettier
  ], 
  overrides: [
    {
      env: {
        node: true,
      },
      files: [".eslintrc.{js,cjs}"],
      parserOptions: {
        sourceType: "script",
      },
    },
  ],
  parserOptions: {
    ecmaVersion: "latest",
    sourceType: "module",
  },
  rules: {
    // "import/extensions": [2, { js: "never", mjs: "always" }], // disallow js and enforce mjs
  },
  globals: {
    // $: "readonly", // jQuery
  },
};
