#!/bin/bash
find . -name "*.h" -o -name "*.cpp" | xargs sed -i 's|boost/tr1/unordered_set.hpp|boost/unordered_set.hpp|g'
find . -name "*.h" -o -name "*.cpp" | xargs sed -i 's|boost/tr1/unordered_map.hpp|boost/unordered_map.hpp|g'
sed -i 's/return false;/return NULL;/g' chat.cpp
echo "Correções aplicadas!"
