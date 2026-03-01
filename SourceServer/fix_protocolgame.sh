#!/bin/bash

# Corrige a declaração da stringstream
sed -i 's/std::stringstream std::hex, s;/std::stringstream hexStream, s;/g' protocolgame.cpp

# Corrige o uso do hex manipulator
sed -i 's/std::hex << "0x" << std::std::hex/hexStream << "0x" << std::hex/g' protocolgame.cpp
sed -i 's/<< std::std::dec;/<< std::dec;/g' protocolgame.cpp

# Corrige o uso em s
sed -i 's/<< std::std::hex <</<< hexStream.str() <</g' protocolgame.cpp

# Corrige a chamada .str()
sed -i 's/std::hex\.str()/hexStream.str()/g' protocolgame.cpp

echo "Correções aplicadas no protocolgame.cpp"
