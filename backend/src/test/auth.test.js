const request = require("supertest");
const app = require("../app"); // Trỏ ra ngoài thư mục gốc để lấy app.js

describe("API Đăng ký / Đăng nhập", () => {
  const username = `student_${Date.now()}_${Math.random().toString(36).slice(2, 8)}`;
  const password = "Student@123"; // 11 ký tự, thỏa mãn >= 6

  test("Đăng ký tài khoản thành công", async () => {
    const response = await request(app)
      .post("/api/auth/register")
      .send({ username, password });
    
    expect(response.status).toBe(201);
    expect(response.body.user.username).toBe(username);
    expect(response.body.user.passwordHash).toBeUndefined();
  });

  test("Không cho đăng ký trùng tên", async () => {
    const response = await request(app)
      .post("/api/auth/register")
      .send({ username, password });
    expect(response.status).toBe(409);
  });

  test("Đăng nhập thành công", async () => {
    const response = await request(app)
      .post("/api/auth/login")
      .send({ username, password });
    expect(response.status).toBe(200);
    expect(response.body.message).toBe("Đăng nhập thành công");
  });

  test("Từ chối mật khẩu sai", async () => {
    const response = await request(app)
      .post("/api/auth/login")
      .send({ username, password: "WrongPass123" });
    expect(response.status).toBe(401);
  });

  test("Từ chối mật khẩu quá ngắn", async () => {
    const response = await request(app)
      .post("/api/auth/register")
      .send({ username: `short_${Date.now()}`, password: "123" }); // 3 ký tự < 6
    expect(response.status).toBe(400);
  });

  test("Từ chối tên đăng nhập chỉ chứa khoảng trắng", async () => {
    const response = await request(app)
      .post("/api/auth/register")
      .send({ username: "   ", password });
    expect(response.status).toBe(400);
  });

  test("Từ chối khi thiếu mật khẩu", async () => {
    const response = await request(app)
      .post("/api/auth/register")
      .send({ username: `missing_${Date.now()}` });
    expect(response.status).toBe(400);
  });
});