const bcrypt = require("bcryptjs");

// Generate hash untuk beberapa password umum
const passwords = ["admin123", "password", "123456", "admin"];

console.log("=== GENERATING NEW PASSWORD HASHES ===");

passwords.forEach((password) => {
  const hash = bcrypt.hashSync(password, 10);
  console.log(`\nPassword: "${password}"`);
  console.log(`Hash: "${hash}"`);

  // Test hash
  const isValid = bcrypt.compareSync(password, hash);
  console.log(`Test: ${isValid ? "✅ VALID" : "❌ INVALID"}`);
});
