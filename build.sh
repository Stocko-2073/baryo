#!/bin/bash

echo "Building Baryo..."
swift build -c release

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "Run with: ./.build/release/Baryo"
    echo ""
    echo "To install globally:"
    echo "sudo cp ./.build/release/Baryo /usr/local/bin/"
else
    echo "❌ Build failed!"
    exit 1
fi