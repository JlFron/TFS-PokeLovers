#!/bin/bash
echo "Corrigindo headers TR1..."

# Corrige includes
find . -name "*.h" -o -name "*.cpp" | xargs sed -i 's|boost/tr1/unordered_set.hpp|boost/unordered_set.hpp|g'
find . -name "*.h" -o -name "*.cpp" | xargs sed -i 's|boost/tr1/unordered_map.hpp|boost/unordered_map.hpp|g'

# Corrige typedef e uso do namespace
find . -name "*.h" -o -name "*.cpp" | xargs sed -i 's/std::tr1::unordered_set/boost::unordered_set/g'
find . -name "*.h" -o -name "*.cpp" | xargs sed -i 's/std::tr1::unordered_map/boost::unordered_map/g'

# Corrige o erro do chat.cpp se ainda existir
sed -i 's/return false;/return NULL;/g' chat.cpp

echo "Todas as correções TR1 aplicadas!"
