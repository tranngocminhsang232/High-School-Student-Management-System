function calculateRemaining(totalAmount, paidAmount) {
  if (
    typeof totalAmount !== "number" ||
    typeof paidAmount !== "number" ||
    !Number.isFinite(totalAmount) ||
    !Number.isFinite(paidAmount) ||
    totalAmount < 0 ||
    paidAmount < 0 ||
    paidAmount > totalAmount
  ) {
    throw new Error("Dữ liệu học phí không hợp lệ");
  }
  return totalAmount - paidAmount;
}

module.exports = { calculateRemaining };
