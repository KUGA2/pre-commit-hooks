#!/bin/sh
set -e # Exit on any error

help() {
  # Print the help message and exit
  _script_name=$(basename "$0")
  echo "Usage: $_script_name [-a <encoding>]... <file>..."
  echo ""
  echo "Checks the encoding of the specified files and prints an error if " \
    "the encoding is not allowed."
  echo ""
  echo "Options:"
  echo "  -a ENCODING  Specify an allowed encoding. May be specified" \
    " multiple times. If none is given, the default us-ascii is used."
  echo "  -h           Show this help message and exit."
  exit 1
}

# Parse the command-line arguments
while getopts "a:h" opt; do
  case $opt in
    a) allowed_encodings="$allowed_encodings $OPTARG" ;;
    h) help ;;
    \?) help ;;
  esac
done
shift $((OPTIND - 1))

# If no <file> argument is passed, print the help message and exit
if [ $# -eq 0 ]; then
  help
fi

# Remove the leading space from the allowed encodings
allowed_encodings="${allowed_encodings# }"

# If no -a arguments were passed, use the default allowed encodings
if [ -z "$allowed_encodings" ]; then
  allowed_encodings="us-ascii"
fi

echo "Allowed encodings: $allowed_encodings"

# Create the regex pattern for allowed encodings
allowed_encodings_pattern=$(echo "$allowed_encodings" | sed 's/ /|/g')
allowed_encodings_pattern="\\b($allowed_encodings_pattern)\\b"

# Initialize the error counter
error_count=0

# Loop through the remaining arguments (which are files being checked)
for file in "$@"
do
  encoding=$(file --brief --mime-encoding "$file")

  # Check if the file has an allowed encoding
  if ! echo "$encoding" | grep -E -q "$allowed_encodings_pattern"
  then
    echo "$file: error: File does not have an allowed encoding. Found " \
      "encoding: $encoding"
    error_count=$((error_count + 1))
  else
    echo "$file: success: File has an allowed encoding. Found encoding: " \
      "$encoding"
  fi
done

exit $error_count
