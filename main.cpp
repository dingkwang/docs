#include <iostream>
#include <cmath> // for std::abs

int main() {
    std::cout << "Hello, World!" << std::endl;
    float a = 1.0f;
    float b = 2.0f;
    float c = a + b;
    
    if (std::abs(c - 3.0f) < 1e-6) {
        std::cout << "c is exactly 3.0f" << std::endl;
    }
    return 0;
} 
