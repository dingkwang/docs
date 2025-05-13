#include <iostream>
#include <cmath> // for std::abs

int main() {
    std::cout << "Hello, World!" << std::endl;
    float a = 1.0f;
    float b = 2.0f;
    float c = a + b;
    
    const float epsilon = 1e-6f;
    if (std::abs(c - 3.0f) < epsilon) {
        std::cout << "c is approximately 3.0f" << std::endl;
    }
    return 0;
} 
