const express = require("express");
const authService = require("./services/authService");

const app = express();

app.use(express.json());

app.post("/api/auth/register", async (req, res) => {
  try {
    const { username, password } = req.body || {};

    const user = await authService.register(username, password);

    return res.status(201).json({
      message: "Đăng ký thành công",
      user
    });
  } catch (error) {
    const status = error.statusCode || 400;

    return res.status(status).json({
      message: error.message,
      code: error.code || "REGISTRATION_ERROR"
    });
  }
});

app.post("/api/auth/login", async (req, res) => {
  try {
    const { username, password } = req.body || {};

    const user = await authService.login(username, password);

    return res.status(200).json({
      message: "Đăng nhập thành công",
      user
    });
  } catch (error) {
    const status = error.statusCode || 400;

    return res.status(status).json({
      message: error.message,
      code: error.code || "LOGIN_ERROR"
    });
  }
});

module.exports = app;
