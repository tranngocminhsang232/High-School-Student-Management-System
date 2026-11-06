const { calculateRemaining } = require("../tuition");

describe("calculateRemaining", () => {
  test("TC01: tính tiền còn phải đóng", () => {
    expect(calculateRemaining(12000000, 5000000)).toBe(7000000);
  });

  test("TC02: đã đóng đủ", () => {
    expect(calculateRemaining(12000000, 12000000)).toBe(0);
  });

  test("TC03: chưa thanh toán", () => {
    expect(calculateRemaining(12000000, 0)).toBe(12000000);
  });

  test("TC04: học phí bằng 0", () => {
    expect(calculateRemaining(0, 0)).toBe(0);
  });

  test("TC05: tổng học phí âm", () => {
    expect(() => calculateRemaining(-100, 0)).toThrow(
      "Dữ liệu học phí không hợp lệ"
    );
  });

  test("TC06: thanh toán vượt học phí", () => {
    expect(() => calculateRemaining(1000, 1200)).toThrow(
      "Dữ liệu học phí không hợp lệ"
    );
  });

  test("TC07: NaN", () => {
    expect(() => calculateRemaining(NaN, 0)).toThrow(
      "Dữ liệu học phí không hợp lệ"
    );
  });

  test("TC08: Infinity", () => {
    expect(() => calculateRemaining(Infinity, 0)).toThrow(
      "Dữ liệu học phí không hợp lệ"
    );
  });

  test("TC09: dữ liệu là chuỗi", () => {
    expect(() => calculateRemaining("abc", 0)).toThrow(
      "Dữ liệu học phí không hợp lệ"
    );
  });
});
