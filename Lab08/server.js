const app = require("./app");

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Authentication Service đang hoạt động trên cổng ${PORT}`);
});
