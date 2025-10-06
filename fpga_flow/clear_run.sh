rm -rf ./run*
rm -f processed_modules_index.txt
rm -f results.csv
rm -f latest
find . -type d -name "__pycache__" -exec rm -rf {} +
