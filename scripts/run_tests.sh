#!/bin/bash

# Recipe Finder App - Test Runner Script
# This script runs all tests and generates coverage reports

set -e

echo "🧪 Recipe Finder App - Running Test Suite"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

print_status "Flutter version:"
flutter --version

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean
flutter pub get

# Generate mocks if needed
print_status "Generating mocks..."
if [ -f "pubspec.yaml" ] && grep -q "mockito" pubspec.yaml; then
    flutter packages pub run build_runner build --delete-conflicting-outputs
    print_success "Mocks generated successfully"
fi

# Run unit tests
print_status "Running unit tests..."
if flutter test test/unit/ --reporter=expanded; then
    print_success "Unit tests passed ✅"
else
    print_error "Unit tests failed ❌"
    exit 1
fi

# Run widget tests
print_status "Running widget tests..."
if flutter test test/widget/ --reporter=expanded; then
    print_success "Widget tests passed ✅"
else
    print_error "Widget tests failed ❌"
    exit 1
fi

# Run all tests with coverage
print_status "Running all tests with coverage..."
if flutter test --coverage --reporter=expanded; then
    print_success "All tests passed with coverage ✅"
else
    print_error "Some tests failed ❌"
    exit 1
fi

# Check if lcov is installed for coverage report
if command -v lcov &> /dev/null; then
    print_status "Generating HTML coverage report..."
    
    # Remove unwanted files from coverage
    lcov --remove coverage/lcov.info \
        '*/test/*' \
        '*/lib/main.dart' \
        '*/lib/*/*.g.dart' \
        '*/lib/*/*.freezed.dart' \
        -o coverage/lcov_cleaned.info
    
    # Generate HTML report
    genhtml coverage/lcov_cleaned.info -o coverage/html --title "Recipe Finder App Coverage"
    
    print_success "Coverage report generated at coverage/html/index.html"
    
    # Extract coverage percentage
    COVERAGE=$(lcov --summary coverage/lcov_cleaned.info 2>&1 | grep "lines" | grep -o '[0-9.]*%' | head -1)
    
    if [ ! -z "$COVERAGE" ]; then
        print_status "Overall test coverage: $COVERAGE"
        
        # Check if coverage meets minimum requirement (70%)
        COVERAGE_NUM=$(echo $COVERAGE | sed 's/%//')
        if (( $(echo "$COVERAGE_NUM >= 70" | bc -l) )); then
            print_success "Coverage requirement met! ($COVERAGE >= 70%)"
        else
            print_warning "Coverage below requirement: $COVERAGE < 70%"
        fi
    fi
    
    # Open coverage report (macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_status "Opening coverage report in browser..."
        open coverage/html/index.html
    fi
else
    print_warning "lcov not found. Install with: brew install lcov (macOS) or apt-get install lcov (Linux)"
fi

# Test summary
echo ""
echo "📊 Test Summary"
echo "==============="
print_success "✅ Unit Tests: Passed"
print_success "✅ Widget Tests: Passed"
print_success "✅ Coverage Generated"

if [ ! -z "$COVERAGE" ]; then
    echo -e "${BLUE}📈 Coverage:${NC} $COVERAGE"
fi

echo ""
print_success "🎉 All tests completed successfully!"

# Optional: Run integration tests if they exist
if [ -d "test_driver" ] && [ -f "test_driver/app_test.dart" ]; then
    echo ""
    print_status "Integration tests found. Run separately with:"
    echo "flutter drive --target=test_driver/app.dart"
fi