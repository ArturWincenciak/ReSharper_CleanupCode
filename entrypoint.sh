#!/bin/bash

# Exit codes
SUCCESS=0
INVALID_ARGUMENT_ERROR=1
EXIT_WITH_FAST_FAIL=2

echo ""
echo "--- --- ---"
echo "Alright GitHub Action Cleanup Code Command-Line Tool"
echo "Default settings:"
echo "- Fail on re-format needed: '$INPUT_FAIL_ON_REFORMAT_NEEDED'"
echo "- Auto commit re-formatted code: '$AUTO_COMMIT'"
echo "- ReSharper CLI CleanupCode arguments: '$INPUT_JB_CLEANUPCODE_ARG'"
echo "- Commit message: '$INPUT_COMMIT_MESSAGE'"
echo "- Commit creator (git user) e-mail: '$INPUT_COMMIT_CREATOR_EMAIL'"
echo "- Commit creator (git user) name: '$INPUT_COMMIT_CREATOR_NAME'"
echo "--- --- ---"
echo ""

if [ "$INPUT_FAIL_ON_REFORMAT_NEEDED" != "yes" ] && [ "$INPUT_FAIL_ON_REFORMAT_NEEDED" != "no" ]
then
    echo ""
    echo "--- --- ---"
    echo "INVALID ARGUMENT OF '-f' equals '$INPUT_FAIL_ON_REFORMAT_NEEDED'"
    echo "Set 'yes' or 'no' or omit to use default equals 'no'"
    echo "--- --- ---"
    echo ""
    exit $INVALID_ARGUMENT_ERROR
fi

if [ "$AUTO_COMMIT" != "yes" ] && [ "$INPUT_AUTO_COMMIT" != "no" ]
then
    echo ""
    echo "--- --- ---"
    echo "INVALID ARGUMENT OF '-a' equals '$INPUT_AUTO_COMMIT'"
    echo "Set 'yes' or 'no' or omit to use default equals 'no'"
    echo "--- --- ---"
    echo ""
    exit $INVALID_ARGUMENT_ERROR
fi

echo ""
echo "--- --- ---"
echo "Your setup:"
echo "- fail on re-format needed: '$INPUT_FAIL_ON_REFORMAT_NEEDED'"
echo "- auto commit re-formatted code: '$INPUT_AUTO_COMMIT'"
if [ "$INPUT_FAIL_ON_REFORMAT_NEEDED" = "yes" ] && [ "$INPUT_AUTO_COMMIT" = "yes" ]
then
    echo "NOTICE: you have set that the execution will fast fail on re-format needed"
    echo "NOTICE: auto commit will not be executed because the execution will terminate with fail when re-format is needed"
    echo "NOTICE: if you want to auto commit execute call the script with '-f no -a yes' arguments"
fi
echo "--- --- ---"
echo ""

echo ""
echo "--- --- ---"
echo "Let's get started, keep calm and wait, it may take few moments"
echo "--- --- ---"
echo ""

dotnet tool restore
dotnet tool update --global JetBrains.ReSharper.GlobalTools
jb cleanupcode Blef.sln "$INPUT_JB_CLEANUP_CODE_ARG"

REFORMATTED_FILES=$(git diff --name-only)

if [ -z "$REFORMATTED_FILES" ]
then
    echo ""
    echo "--- --- ---"
    echo "No files re-formatted, everything is clean, congratulation!"
    echo "--- --- ---"
    echo ""
    exit $SUCCESS
fi

if [ "$INPUT_FAIL_ON_REFORMAT_NEEDED" = "yes" ]
then
    echo ""
    echo "--- --- ---"
    echo "Exit with re-formatted code needed fail status"
    echo "--- --- ---"
    echo ""
    exit $EXIT_WITH_FAST_FAIL
fi

if [ "$INPUT_AUTO_COMMIT" = "no" ]
then
    echo ""
    echo "--- --- ---"
    echo "There is re-formatted code but it will not be auto committed"
    echo "--- --- ---"
    echo ""
    exit $SUCCESS
fi

echo ""
echo "--- --- ---"
echo "There is re-formatted code to be committed"
echo "--- --- ---"
echo ""

git diff --name-only

echo ""
echo "--- --- ---"
echo "Git Diff"
echo "--- --- ---"
echo ""

git diff

echo ""
echo "--- --- ---"
echo "Add all changes to stage"
echo "--- --- ---"
echo ""

git add .

echo ""
echo "--- --- ---"
echo "Staged files to be committed"
echo "--- --- ---"
echo ""

git diff --staged --name-only

echo ""
echo "--- --- ---"
echo "Creating commit"
echo "--- --- ---"
echo ""

git config --global user.email "$INPUT_COMMIT_MESSAGE"
git config --global user.name "$INPUT_COMMIT_CREATOR_EMAIL"
git commit -m "$INPUT_COMMIT_CREATOR_NAME"

echo ""
echo "--- --- ---"
echo "Commit has been created"
echo "--- --- ---"
echo ""

git status

echo ""
echo "--- --- ---"
echo "Push the commit"
echo "--- --- ---"
echo ""

git push

echo ""
echo "--- --- ---"
echo "Commit has been pushed"
echo "--- --- ---"
echo ""

git status

echo ""
echo "--- --- ---"
echo "All re-formatted code has been committed and pushed with success"
echo "--- --- ---"
echo ""
exit $SUCCESS