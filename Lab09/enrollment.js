function validateEnrollment(student, courseSection) {
  if (
    !student ||
    typeof student.studentId !== "string" ||
    student.studentId.trim() === "" ||
    typeof student.eligible !== "boolean" ||
    !Array.isArray(student.enrolledCourses)
  ) {
    throw new Error("Thông tin sinh viên không hợp lệ");
  }
  if (
    !courseSection ||
    typeof courseSection.courseId !== "string" ||
    courseSection.courseId.trim() === "" ||
    !Number.isInteger(courseSection.capacity) ||
    !Number.isInteger(courseSection.enrolledCount) ||
    courseSection.capacity < 0 ||
    courseSection.enrolledCount < 0 ||
    courseSection.enrolledCount > courseSection.capacity
  ) {
    throw new Error("Thông tin lớp học phần không hợp lệ");
  }
  if (!student.eligible) {
    return {
      allowed: false,
      reason: "Sinh viên chưa đủ điều kiện"
    };
  }
  if (student.enrolledCourses.includes(courseSection.courseId)) {
    return {
      allowed: false,
      reason: "Sinh viên đã đăng ký môn học"
    };
  }
  if (courseSection.enrolledCount >= courseSection.capacity) {
    return {
      allowed: false,
      reason: "Lớp học phần đã đủ sĩ số"
    };
  }
  return {
    allowed: true,
    reason: "Đăng ký hợp lệ"
  };
}

module.exports = { validateEnrollment };
