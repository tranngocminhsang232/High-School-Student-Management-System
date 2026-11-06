const { validateEnrollment } = require("../enrollment");

const student = {
  studentId: "SV001",
  eligible: true,
  enrolledCourses: []
};

const courseSection = {
  courseId: "CS201",
  capacity: 40,
  enrolledCount: 39
};

describe("validateEnrollment", () => {
  test("EN01: sinh viên đủ điều kiện, lớp còn chỗ", () => {
    expect(validateEnrollment(student, courseSection)).toEqual({
      allowed: true,
      reason: "Đăng ký hợp lệ"
    });
  });

  test("EN02: sinh viên đã đăng ký môn", () => {
    const s = {
      ...student,
      enrolledCourses: ["CS201"]
    };
    expect(validateEnrollment(s, courseSection).allowed).toBe(false);
    expect(validateEnrollment(s, courseSection).reason).toBe(
      "Sinh viên đã đăng ký môn học"
    );
  });

  test("EN03: lớp đã đủ sĩ số", () => {
    const section = {
      ...courseSection,
      enrolledCount: 40
    };
    expect(validateEnrollment(student, section).allowed).toBe(false);
  });

  test("EN04: sinh viên chưa đủ điều kiện", () => {
    const s = { ...student, eligible: false };
    expect(validateEnrollment(s, courseSection).reason).toBe(
      "Sinh viên chưa đủ điều kiện"
    );
  });

  test("EN05: thiếu mã sinh viên", () => {
    const s = { ...student, studentId: "" };
    expect(() => validateEnrollment(s, courseSection)).toThrow(
      "Thông tin sinh viên không hợp lệ"
    );
  });

  test("EN06: sức chứa âm", () => {
    const section = { ...courseSection, capacity: -1 };
    expect(() => validateEnrollment(student, section)).toThrow(
      "Thông tin lớp học phần không hợp lệ"
    );
  });

  test("EN07: số lượng đăng ký vượt sức chứa", () => {
    const section = {
      ...courseSection,
      capacity: 40,
      enrolledCount: 41
    };
    expect(() => validateEnrollment(student, section)).toThrow(
      "Thông tin lớp học phần không hợp lệ"
    );
  });

  test("EN08: lớp còn đúng một chỗ", () => {
    const section = {
      ...courseSection,
      capacity: 40,
      enrolledCount: 39
    };
    expect(validateEnrollment(student, section).allowed).toBe(true);
  });

  test("EN09: danh sách môn đăng ký không phải mảng", () => {
    const s = { ...student, enrolledCourses: "CS201" };
    expect(() => validateEnrollment(s, courseSection)).toThrow(
      "Thông tin sinh viên không hợp lệ"
    );
  });
});
