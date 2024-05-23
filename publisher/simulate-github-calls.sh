#!/bin/bash
set -e

#https://publish.obsidian.md/kaas-published/0-Slipbox/Default+Github+Action+Environment+Variables

#simulate required env parameters
export GITHUB_WORKSPACE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/.."
export GITHUB_RUN_ATTEMPT=$(($RANDOM % 5))
export GITHUB_RUN_ID=$(($RANDOM % 10000))

echo "#### simulated values:"
echo "GITHUB_WORKSPACE:     $GITHUB_WORKSPACE"
echo "GITHUB_RUN_ATTEMPT:   $GITHUB_RUN_ATTEMPT"
echo "GITHUB_RUN_ID:        $GITHUB_RUN_ID"

echo "going to launch ./auto_git2staging.sh"
bash ./auto_git2staging.sh

echo "going to launch ./auto_staging2prod.sh"
bash ./auto_staging2prod.sh

echo "bye!"
