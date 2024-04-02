#!/bin/bash

# Exit codes
SUCCESS=0
INVALID_ARGUMENT_ERROR=1
EXIT_WITH_FAST_FAIL=2

INPUT_SOLUTION=$1
INPUT_FAIL_ON_REFORMAT_NEEDED=$2
INPUT_JB_CLEANUP_CODE_ARG=$3

echo ""
echo "--- --- ---"
echo "Alright GitHub Action Cleanup Code Command-Line Tool"
echo "Your setup:"
echo "- Solution: [${INPUT_SOLUTION}]"
echo "- Fail on re-format needed: [${INPUT_FAIL_ON_REFORMAT_NEEDED}]"
echo "- ReSharper CLI CleanupCode arguments: [${INPUT_JB_CLEANUP_CODE_ARG}]"
echo "--- --- ---"
echo ""

echo ""
echo "--- --- ---"
echo "Current working directory stuff:"
ls -F --color=auto --show-control-chars -a
echo "--- --- ---"
echo ""

if [ "${INPUT_FAIL_ON_REFORMAT_NEEDED}" != "yes" ] && [ "${INPUT_FAIL_ON_REFORMAT_NEEDED}" != "no" ]; then
  echo ""
  echo "--- --- ---"
  echo "INVALID ARGUMENT OF '-f' equals '${INPUT_FAIL_ON_REFORMAT_NEEDED}'"
  echo "Set 'yes' or 'no' or omit to use default equals 'no'"
  echo "--- --- ---"
  echo ""
  exit ${INVALID_ARGUMENT_ERROR}
fi

#
# Parse arguments and put them into an array to call command
# I'm at a loss for words to describe how I managed to nail this function
# Once again I understand why all Ops always looks stressed out
#
ARG_DELIMITER="--"
S=${INPUT_JB_CLEANUP_CODE_ARG}${ARG_DELIMITER}
COMMAND_ARG_ARRAY=()

while [[ $S ]]; do
  ITEM="${S%%"$ARG_DELIMITER"*}"
  if [ -n "${ITEM}" ]; then
    if [ "${ITEM:0-1}" == " " ]; then
      ITEM="${ITEM::-1}"
    fi
    COMMAND_ARG_ARRAY+=("--${ITEM}")
  fi
  S=${S#*"$ARG_DELIMITER"}
done

echo ""
echo "--- --- ---"
echo "Restore .NET tool (the JetBrains.ReSharper.GlobalTools)"
echo "--- --- ---"
echo ""

dotnet tool restore

echo ""
echo "--- --- ---"
echo "Let's get started, keep calm and wait, it may take few moments"
for arg in "${COMMAND_ARG_ARRAY[@]}"; do
  echo "Command argument: [${arg}]"
done
echo "--- --- ---"
echo ""

dotnet jb cleanupcode "${COMMAND_ARG_ARRAY[@]}" "${INPUT_SOLUTION}"

REFORMATTED_FILES=$(git diff --name-only)

if [ -z "${REFORMATTED_FILES}" ]; then
  echo ""
  echo "--- --- ---"
  echo "No files re-formatted, everything is clean, congratulation!"
  echo "--- --- ---"
  echo ""
  exit ${SUCCESS}
fi

if [ "${INPUT_FAIL_ON_REFORMAT_NEEDED}" = "yes" ]; then
  echo ""
  echo "--- --- ---"
  echo "Exit with re-formatted code needed fail status, down below is the diff of the re-formatted code that needs to be committed"
  echo "--- --- ---"
  echo ""
  git diff
  exit ${EXIT_WITH_FAST_FAIL}
fi

exit ${SUCCESS}