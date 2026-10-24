const bcrypt = require("bcryptjs");

const users = [];
let nextId = 1;

async function register(username, password) {
    if (
        typeof username !== "string" ||
        typeof password !== "string"
    ) {
        throw new Error("Tên đăng nhập và mật khẩu phải là chuỗi");
    }

    const normalizedUsername = username.trim().toLowerCase();

    if (!normalizedUsername || !password) {
        throw new Error("Tên đăng nhập và mật khẩu là bắt buộc");
    }

    // ĐIỀU CHỈNH: Sửa thành >= 6 ký tự theo đúng yêu cầu
    if (password.length < 6) {
        throw new Error("Mật khẩu phải có ít nhất 6 ký tự");
    }

    const existed = users.some(
        user => user.username === normalizedUsername
    );

    if (existed) {
        throw new Error("Tên đăng nhập đã tồn tại");
    }

    const passwordHash = await bcrypt.hash(password, 10);

    const user = {
        id: nextId++,
        username: normalizedUsername,
        passwordHash
    };

    users.push(user);

    return {
        id: user.id,
        username: user.username
        // Không bao giờ trả về passwordHash
    };
}

async function login(username, password) {
    if (
        typeof username !== "string" ||
        typeof password !== "string" ||
        !username.trim() ||
        !password
    ) {
        throw new Error("Tên đăng nhập và mật khẩu là bắt buộc");
    }

    const normalizedUsername = username.trim().toLowerCase();

    const user = users.find(
        item => item.username === normalizedUsername
    );

    if (
        !user ||
        !(await bcrypt.compare(password, user.passwordHash))
    ) {
        throw new Error("Tên đăng nhập hoặc mật khẩu không đúng");
    }

    return {
        id: user.id,
        username: user.username
    };
}

module.exports = { register, login };