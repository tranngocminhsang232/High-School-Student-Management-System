const { validatePayment } = require("../payment");

describe("validatePayment", () => {
  test("PAY01: chấp nhận số tiền hợp lệ", () => {
    expect(validatePayment(500000)).toBe(true);
  });

  test("PAY02: chấp nhận số tiền nhỏ nhất là 1", () => {
    expect(validatePayment(1)).toBe(true);
  });

  test("PAY03: từ chối số tiền bằng 0", () => {
    expect(validatePayment(0)).toBe(false);
  });

  test("PAY04: từ chối số tiền âm", () => {
    expect(validatePayment(-100)).toBe(false);
  });

  test("PAY05: từ chối chuỗi", () => {
    expect(validatePayment("500000")).toBe(false);
  });

  test("PAY06: từ chối NaN", () => {
    expect(validatePayment(NaN)).toBe(false);
  });

  test("PAY07: từ chối Infinity", () => {
    expect(validatePayment(Infinity)).toBe(false);
  });

  test("PAY08: từ chối null", () => {
    expect(validatePayment(null)).toBe(false);
  });
});
