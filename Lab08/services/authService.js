class AuthError extends Error {
  constructor(message, statusCode = 400, code = "AUTH_ERROR") {
    super(message);
    this.name = "AuthError";
    this.statusCode = statusCode;
    this.code = code;
  }
}

const users = [];

async function register(username, password) {
  if (
    !username ||
    !password ||
    typeof username !== "string" ||
    typeof password !== "string"
  ) {
    throw new AuthError(
      "Tên đăng nhập và mật khẩu không được để trống",
      400,
      "MISSING_CREDENTIALS"
    );
  }

  const normalizedUsername = username.trim();
  if (normalizedUsername.length === 0) {
    throw new AuthError(
      "Tên đăng nhập và mật khẩu không được để trống",
      400,
      "MISSING_CREDENTIALS"
    );
  }

  if (password.length < 6) {
    throw new AuthError(
      "Mật khẩu phải có ít nhất 6 ký tự",
      400,
      "INVALID_PASSWORD_LENGTH"
    );
  }

  const existingUser = users.find(
    (user) => user.username.toLowerCase() === normalizedUsername.toLowerCase()
  );

  if (existingUser) {
    throw new AuthError(
      "Tên đăng nhập đã tồn tại",
      409,
      "DUPLICATE_USERNAME"
    );
  }

  const passwordHash = `hashed_${password}`;

  const newUser = {
    id: users.length + 1,
    username: normalizedUsername,
    passwordHash,
    createdAt: new Date().toISOString()
  };

  users.push(newUser);

  const { passwordHash: _removed, ...safeUser } = newUser;
  return safeUser;
}

async function login(username, password) {
  if (
    !username ||
    !password ||
    typeof username !== "string" ||
    typeof password !== "string"
  ) {
    throw new AuthError(
      "Tên đăng nhập và mật khẩu không được để trống",
      400,
      "MISSING_CREDENTIALS"
    );
  }

  const normalizedUsername = username.trim();
  const expectedHash = `hashed_${password}`;

  const user = users.find(
    (u) =>
      u.username.toLowerCase() === normalizedUsername.toLowerCase() &&
      u.passwordHash === expectedHash
  );

  if (!user) {
    throw new AuthError(
      "Tên đăng nhập hoặc mật khẩu không chính xác",
      400,
      "INVALID_CREDENTIALS"
    );
  }

  const { passwordHash: _removed, ...safeUser } = user;
  return safeUser;
}

function resetUsers() {
  users.length = 0;
}

module.exports = {
  AuthError,
  register,
  login,
  resetUsers
};
