@echo off
echo ============================================
echo    EXPENSE TRACKER SETUP
echo ============================================
echo.

echo Checking Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js not found! Please install Node.js first.
    echo Download from: https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js found! Installing dependencies...
npm install
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies!
    pause
    exit /b 1
)

echo.
echo Checking if .env file exists...
if not exist .env (
    echo Creating .env file from example...
    copy .env.example .env
    echo.
    echo IMPORTANT: Please edit .env file and configure your database settings!
    echo Press any key to open .env file in notepad...
    pause >nul
    notepad .env
)

echo.
echo Setting up database...
echo Generating Prisma client...
npx prisma generate
if %errorlevel% neq 0 (
    echo ERROR: Failed to generate Prisma client!
    pause
    exit /b 1
)

echo Pushing database schema...
npx prisma db push
if %errorlevel% neq 0 (
    echo ERROR: Failed to push database schema!
    echo Please check your database connection in .env file.
    pause
    exit /b 1
)

echo Seeding database with default data...
node prisma/seed.js
if %errorlevel% neq 0 (
    echo WARNING: Failed to seed database. This might be normal if data already exists.
)

echo.
echo ============================================
echo    SETUP COMPLETE!
echo ============================================
echo.
echo To start the application, run:
echo    npm run dev
echo.
echo Then open: http://localhost:3000
echo Default password: admin123
echo.
echo For detailed instructions, see INSTALL.md
echo.
pause
