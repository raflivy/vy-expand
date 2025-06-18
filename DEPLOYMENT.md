# Deployment Guide untuk Vercel

## 🏠 Development Lokal

### Prasyarat

1. **Node.js** (versi 16+) - Download dari [nodejs.org](https://nodejs.org)
2. **PostgreSQL** database lokal atau cloud
3. **Git** (opsional)

### Setup Development

```bash
# 1. Clone/download project
git clone <repository-url>
cd expendphp

# 2. Install dependencies
npm install

# 3. Setup environment
cp .env.example .env
# Edit .env dengan database connection Anda

# 4. Setup database
npx prisma generate
npx prisma db push
node prisma/seed.js

# 5. Start development server
npm run dev
```

**⚠️ PENTING**:

- **Gunakan `npm run dev`**, BUKAN live server
- Live server hanya untuk static HTML, aplikasi ini butuh Node.js server
- Server akan berjalan di `http://localhost:3000`

### Database Development

Untuk development lokal, Anda bisa menggunakan:

1. **PostgreSQL lokal** (XAMPP/Laragon/manual install)
2. **Database cloud gratis** (Neon/Supabase)

#### Database Lokal (Laragon):

```env
DATABASE_URL="postgresql://root:@localhost:5432/expense_tracker?schema=public"
```

#### Database Cloud (Neon):

```env
DATABASE_URL="postgresql://user:pass@host.neon.tech:5432/db?sslmode=require"
```

---

## ☁️ Production Deployment

1. **Account Vercel** - Daftar di [vercel.com](https://vercel.com)
2. **Database PostgreSQL** - Gunakan salah satu:
   - [Neon](https://neon.tech) (Recommended - Free tier)
   - [Supabase](https://supabase.com)
   - [Railway](https://railway.app)
   - [PlanetScale](https://planetscale.com)

## Langkah Deployment

### 1. Persiapan Database

#### Menggunakan Neon (Recommended):

1. Buat account di [neon.tech](https://neon.tech)
2. Buat database baru
3. Copy connection string yang diberikan

#### Menggunakan Supabase:

1. Buat account di [supabase.com](https://supabase.com)
2. Buat project baru
3. Di Settings > Database, copy connection string

### 2. Deploy ke Vercel

#### Option 1: Via Vercel Dashboard

1. Login ke [vercel.com](https://vercel.com)
2. Klik "New Project"
3. Import repository ini (atau upload folder)
4. Set Environment Variables (lihat section di bawah)
5. Deploy

#### Option 2: Via Vercel CLI

```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy
vercel

# Set environment variables
vercel env add DATABASE_URL
vercel env add SESSION_SECRET
vercel env add ADMIN_PASSWORD_HASH

# Redeploy dengan environment variables
vercel --prod
```

### 3. Environment Variables

Di Vercel Dashboard > Project Settings > Environment Variables, tambahkan:

| Variable              | Value                        | Example                                               |
| --------------------- | ---------------------------- | ----------------------------------------------------- |
| `DATABASE_URL`        | PostgreSQL connection string | `postgresql://user:pass@host:5432/db?sslmode=require` |
| `SESSION_SECRET`      | Random secret key            | `your-super-secret-key-minimum-32-chars`              |
| `ADMIN_PASSWORD_HASH` | Bcrypt hash dari password    | `$2b$10$92IXUNpkjO0rOQ5byMi...`                       |

#### Generate Password Hash:

```bash
# Local terminal
node -e "console.log(require('bcryptjs').hashSync('your-password', 10))"
```

### 4. Database Setup

Setelah deploy pertama kali, setup database:

#### Manual Setup:

1. Install Prisma CLI: `npm install -g prisma`
2. Set DATABASE_URL di terminal:
   ```bash
   export DATABASE_URL="your-connection-string"
   ```
3. Push schema:
   ```bash
   prisma db push
   ```
4. Seed data:
   ```bash
   node prisma/seed.js
   ```

#### Menggunakan Vercel Functions:

1. Akses: `https://your-app.vercel.app/api/setup` (buat endpoint khusus)
2. Atau gunakan Prisma Studio: `prisma studio`

### 5. Domain Custom (Opsional)

1. Di Vercel Dashboard > Project > Settings > Domains
2. Tambahkan domain custom Anda
3. Update DNS records sesuai instruksi Vercel

## Configuration Files

### vercel.json

```json
{
  "version": 2,
  "builds": [
    {
      "src": "server.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "/server.js"
    },
    {
      "src": "/(.*)",
      "dest": "/public/$1"
    }
  ]
}
```

### package.json scripts

```json
{
  "scripts": {
    "build": "prisma generate",
    "postinstall": "prisma generate",
    "vercel-build": "prisma generate && prisma db push"
  }
}
```

## Troubleshooting

### Error: Database connection failed

- Pastikan DATABASE_URL benar
- Pastikan database online dan accessible
- Cek SSL/TLS settings (tambahkan `?sslmode=require`)

### Error: Prisma client not generated

- Pastikan `postinstall` script ada di package.json
- Redeploy ulang

### Error: Environment variables not set

- Cek di Vercel Dashboard > Settings > Environment Variables
- Pastikan semua required variables ada
- Redeploy setelah menambah env vars

### Error: Function timeout

- Vercel free tier memiliki timeout 10 detik
- Optimasi query database
- Pertimbangkan upgrade ke Pro plan

## Performance Tips

1. **Database Indexing**: Tambahkan index di Prisma schema
2. **Connection Pooling**: Gunakan connection pooling di DATABASE_URL
3. **Caching**: Implement caching untuk query yang sering digunakan
4. **Static Assets**: Pastikan static files di-serve dari CDN

## Monitoring

1. **Vercel Analytics**: Enable di project settings
2. **Database Monitoring**: Gunakan monitoring tools dari provider database
3. **Error Tracking**: Integrate dengan Sentry atau LogRocket

## Security

1. **Environment Variables**: Jangan commit .env files
2. **Session Secret**: Gunakan secret yang strong dan unique
3. **Database**: Enable SSL/TLS connection
4. **CORS**: Configure CORS jika diperlukan

## Contoh DATABASE_URL

```bash
# Neon
DATABASE_URL="postgresql://username:password@ep-cool-darkness-123456.us-east-2.aws.neon.tech/neondb?sslmode=require"

# Supabase
DATABASE_URL="postgresql://postgres:password@db.abcdefghijklmnop.supabase.co:5432/postgres?sslmode=require"

# Railway
DATABASE_URL="postgresql://postgres:password@containers-us-west-123.railway.app:5432/railway?sslmode=require"
```

## Support

Jika mengalami masalah:

1. Cek Vercel deployment logs
2. Cek database connection
3. Pastikan environment variables benar
4. Cek Prisma schema dan migration
