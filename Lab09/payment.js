function validatePayment(amount) {
  return (
    typeof amount === "number" &&
    Number.isFinite(amount) &&
    amount > 0
  );
}

module.exports = { validatePayment };
