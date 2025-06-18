# 🚀 Development Guide

## ⚠️ PENTING: Cara Menjalankan

```bash
# ✅ BENAR - Gunakan npm run dev
npm run dev

# ❌ SALAH - Jangan gunakan Live Server
# Live Server hanya untuk static HTML
```

## 🏗️ Arsitektur Aplikasi

```
Frontend (Browser)     Backend (Node.js)      Database (PostgreSQL)
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ HTML/CSS/JS     │───▶│ Express Server  │───▶│ Prisma ORM      │
│ Alpine.js       │◀───│ API Routes      │◀───│ Tables/Data     │
│ Tailwind CSS    │    │ Authentication  │    │ Categories      │
│ Chart.js        │    │ Session Mgmt    │    │ Sources         │
└─────────────────┘    └─────────────────┘    │ Expenses        │
                                              │ Budgets         │
                                              └─────────────────┘
```

## 🔧 Development Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Setup Database

### 2. Setup Database PostgreSQL

#### Option A: PostgreSQL Lokal dengan Laragon (Windows)

1. **Start PostgreSQL di Laragon:**

   - Buka Laragon
   - Klik "Start All" atau start PostgreSQL secara terpisah
   - PostgreSQL akan berjalan di port 5432

2. **Buat Database:**

   ```bash
   # Via HeidiSQL (sudah include di Laragon)
   # 1. Buka HeidiSQL dari Laragon
   # 2. Connect ke PostgreSQL (localhost:5432, user: root, password: kosong)
   # 3. Klik kanan > Create Database > "expense_tracker"

   # Atau via Command Line:
   psql -U root -h localhost -c "CREATE DATABASE expense_tracker;"
   ```

3. **Setup .env file:**
   ```env
   DATABASE_URL="postgresql://root:@localhost:5432/expense_tracker?schema=public"
   SESSION_SECRET="dev-secret-key-change-in-production-minimum-32-chars"
   ADMIN_PASSWORD_HASH="$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi"
   PORT=3000
   ```

#### Option B: PostgreSQL Manual Install (Windows)

1. **Download & Install PostgreSQL:**

   - Download dari [postgresql.org](https://www.postgresql.org/download/windows/)
   - Install dengan default settings
   - Remember username/password yang Anda set

2. **Buat Database:**

   ```bash
   # Via pgAdmin (GUI tool yang terinstall otomatis)
   # 1. Buka pgAdmin
   # 2. Login dengan credentials Anda
   # 3. Klik kanan Databases > Create > Database
   # 4. Nama: "expense_tracker"

   # Atau via Command Line:
   createdb -U postgres expense_tracker
   ```

3. **Setup .env file:**
   ```env
   DATABASE_URL="postgresql://postgres:yourpassword@localhost:5432/expense_tracker?schema=public"
   SESSION_SECRET="dev-secret-key-change-in-production-minimum-32-chars"
   ADMIN_PASSWORD_HASH="$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi"
   PORT=3000
   ```

#### Option C: Cloud Database (Mudah & Gratis)

**Neon.tech (Recommended):**

1. Daftar di [neon.tech](https://neon.tech)
2. Buat database baru (gratis)
3. Copy connection string yang diberikan

**Supabase:**

1. Daftar di [supabase.com](https://supabase.com)
2. Buat project baru
3. Di Settings > Database, copy connection string

**Railway:**

1. Daftar di [railway.app](https://railway.app)
2. Deploy PostgreSQL template
3. Copy connection string dari variables

```env
# Contoh untuk cloud database
DATABASE_URL="postgresql://username:password@hostname:5432/database?sslmode=require"
SESSION_SECRET="dev-secret-key-change-in-production-minimum-32-chars"
ADMIN_PASSWORD_HASH="$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi"
PORT=3000
```

#### Option B: Database Cloud (Neon)

1. Signup di [neon.tech](https://neon.tech)
2. Create database
3. Copy connection string

`.env`:

```env
DATABASE_URL="postgresql://user:pass@host.neon.tech:5432/db?sslmode=require"
SESSION_SECRET="dev-secret-key-change-in-production-minimum-32-chars"
ADMIN_PASSWORD_HASH="$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi"
PORT=3000
```

### 3. Initialize Database Schema

Setelah setup database, jalankan commands berikut:

```bash
# 1. Copy environment file
copy .env.example .env
# Edit .env dengan database URL Anda

# 2. Generate Prisma client
npx prisma generate

# 3. Push schema ke database
npx prisma db push

# 4. Seed data default (kategori & sumber dana)
node prisma/seed.js
```

**Verifikasi Database:**

```bash
# Cek koneksi database
npx prisma studio
# Buka browser ke http://localhost:5555 untuk melihat data
```

### 4. Start Development Server

```bash
npm run dev
```

**Akses**: `http://localhost:3000`  
**Login**: Password `password`

## 🐛 Troubleshooting Database

### Error: Database connection failed

```bash
# Cek apakah PostgreSQL berjalan
# Laragon: Start PostgreSQL service
# Manual: net start postgresql-x64-13

# Test koneksi manual
psql -U root -h localhost -d expense_tracker
# Atau
psql -U postgres -h localhost -d expense_tracker
```

### Error: Database does not exist

```bash
# Buat database manual
createdb -U root expense_tracker
# Atau
createdb -U postgres expense_tracker

# Atau via SQL
psql -U root -h localhost -c "CREATE DATABASE expense_tracker;"
```

### Error: Password authentication failed

```bash
# Cek username/password di .env
# Untuk Laragon default: user=root, password=kosong
# Untuk manual install: user=postgres, password=yang Anda set saat install
```

### Error: Port 5432 already in use

```bash
# Cek service yang menggunakan port 5432
netstat -ano | findstr :5432

# Stop service lain atau ubah port PostgreSQL
```

### Reset Database (jika perlu)

```bash
# Hapus dan buat ulang database
psql -U root -h localhost -c "DROP DATABASE IF EXISTS expense_tracker;"
psql -U root -h localhost -c "CREATE DATABASE expense_tracker;"

# Push schema ulang
npx prisma db push
node prisma/seed.js
```

## 🛠️ Development Tools

### VS Code Tasks

- **Start Development Server**: `Ctrl+Shift+P` → "Tasks: Run Task" → "Start Development Server"
- **Debug Mode**: `F5` → "Start Server" atau "Debug Server"

### Database Tools

```bash
# Prisma Studio (Database GUI)
npm run db:studio

# Reset database
npx prisma db push --force-reset

# View logs
npm run dev # Check terminal output
```

### Debugging

1. **Server Logs**: Check terminal yang menjalankan `npm run dev`
2. **Browser Console**: `F12` → Console tab
3. **Network Tab**: Monitor API calls
4. **VS Code Debugger**: `F5` untuk debug mode

## 📁 File Structure untuk Development

```
expendphp/
├── server.js              # 🚀 Main server (START HERE)
├── package.json           # 📦 Dependencies & scripts
├── .env                   # 🔐 Environment variables
├── prisma/
│   ├── schema.prisma      # 🗄️ Database schema
│   └── seed.js           # 🌱 Default data
├── public/               # 📱 Frontend files
│   ├── index.html        # 🏠 Main page
│   ├── js/
│   │   ├── app.js        # 🧠 Main application logic
│   │   └── utils.js      # 🔧 Utilities & notifications
│   ├── css/
│   │   └── custom.css    # 🎨 Custom styles
│   └── manifest.json     # 📱 PWA config
└── .vscode/              # ⚙️ VS Code settings
```

## 🔄 Development Workflow

### 1. Frontend Changes

- Edit files di `public/`
- Refresh browser untuk lihat perubahan
- Check console untuk errors

### 2. Backend Changes

- Edit `server.js` atau files di `prisma/`
- Server auto-restart dengan nodemon
- Check terminal logs

### 3. Database Changes

- Edit `prisma/schema.prisma`
- Run `npx prisma db push`
- Restart server jika perlu

## 🐛 Common Issues

### Port 3000 already in use

```bash
# Kill process di port 3000
npx kill-port 3000

# Atau ganti port di .env
PORT=3001
```

### Database connection failed

```bash
# Check PostgreSQL status di Laragon
# Atau check connection string di .env
```

### Prisma client not generated

```bash
npx prisma generate
```

### Live Server tidak bekerja

```
❌ Live Server hanya untuk static HTML
✅ Gunakan: npm run dev
```

## 📚 API Endpoints

```
GET    /                    # Frontend app
POST   /api/login          # Authentication
POST   /api/logout         # Logout
GET    /api/expenses       # Get expenses
POST   /api/expenses       # Create expense
PUT    /api/expenses/:id   # Update expense
DELETE /api/expenses/:id   # Delete expense
GET    /api/categories     # Get categories
POST   /api/categories     # Create category
GET    /api/sources        # Get sources
POST   /api/sources        # Create source
GET    /api/setup          # Setup database
```

## 🎯 Development Tips

1. **Auto-reload**: Server restart otomatis saat file berubah
2. **Database GUI**: Gunakan `npm run db:studio` untuk manage data
3. **Mobile Testing**: Buka `http://localhost:3000` di mobile browser
4. **API Testing**: Gunakan browser DevTools Network tab
5. **Debugging**: Set breakpoints di VS Code dan jalankan debug mode

## 🚀 Ready untuk Production?

Lihat [DEPLOYMENT.md](DEPLOYMENT.md) untuk deploy ke Vercel.

## 🚀 Quick Start Guide

### Step-by-Step Setup (Laragon + PostgreSQL)

```bash
# 1. Pastikan Laragon berjalan dan PostgreSQL aktif
# 2. Clone/download project ini
# 3. Buka terminal di folder project

# 4. Install dependencies
npm install

# 5. Copy environment file
copy .env.example .env

# 6. Test koneksi database
npm run db:test
# Jika error, ikuti troubleshooting di bawah

# 7. Setup database schema
npx prisma generate
npx prisma db push

# 8. Seed data default
node prisma/seed.js

# 9. Start development server
npm run dev

# 10. Buka browser: http://localhost:3000
# Login dengan password: password
```

### Verifikasi Setup

```bash
# Cek database dengan GUI
npm run db:studio
# Buka http://localhost:5555

# Test semua endpoint
curl http://localhost:3000/api/categories
curl http://localhost:3000/api/sources
```

## 🔐 Troubleshooting Ganti Password

### Masalah: Password baru tidak berfungsi

**Penyebab:** Backend tidak benar-benar mengupdate hash password di file .env

**Solusi:** Sudah diperbaiki! Sekarang fitur ganti password akan:

1. ✅ **Update file .env** dengan hash password baru
2. ✅ **Update environment variable** di memory
3. ✅ **Memberikan opsi restart server** untuk efek penuh

### Cara Test Ganti Password:

```bash
# 1. Start server
npm run dev

# 2. Login dengan password: "password"
# 3. Ke menu Laporan > Ganti Password
# 4. Isi form:
#    - Password Lama: password
#    - Password Baru: admin123
#    - Konfirmasi: admin123
# 5. Klik Simpan
# 6. Pilih "Yes" untuk restart server
# 7. Login dengan password baru: admin123
```

### Verifikasi Manual:

```bash
# Cek file .env apakah hash berubah
type .env

# Test password yang aktif
node scripts/test-password.js
```

### Backup Plan (jika masih error):

```bash
# Ganti password manual via script
node scripts/change-password.js admin123

# Restart server
npm run dev
```
