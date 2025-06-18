#!/bin/bash

echo "Installing dependencies..."
npm install

echo ""
echo "Setting up database..."
npx prisma generate
npx prisma db push

echo ""
echo "Seeding database with default data..."
node prisma/seed.js

echo ""
echo "Setup complete!"
echo ""
echo "To start the application:"
echo "npm run dev"
echo ""
echo "Then open http://localhost:3000 in your browser"
echo "Default password: admin123"
