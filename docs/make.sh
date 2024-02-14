#!/bin/bash

# Navigate to the script's directory
cd "$(dirname "$0")"

# Command file for Sphinx documentation

# Check if SPHINXBUILD is set, if not, default it to sphinx-build
if [ -z "$SPHINXBUILD" ]; then
    SPHINXBUILD=sphinx-build
fi
SOURCEDIR=source
BUILDDIR=build

# If no argument is provided, show help
if [ -z "$1" ]; then
    $SPHINXBUILD -M help $SOURCEDIR $BUILDDIR ${SPHINXOPTS} $O
    exit 0
fi

# Check if sphinx-build is available
if ! command -v $SPHINXBUILD &> /dev/null; then
    echo
    echo "The 'sphinx-build' command was not found. Make sure you have Sphinx"
    echo "installed, then set the SPHINXBUILD environment variable to point"
    echo "to the full path of the 'sphinx-build' executable. Alternatively, you"
    echo "may add the Sphinx directory to PATH."
    echo
    echo "If you don't have Sphinx installed, grab it from"
    echo "http://sphinx-doc.org/"
    exit 1
fi

# Run Sphinx build
$SPHINXBUILD -M "$1" $SOURCEDIR $BUILDDIR ${SPHINXOPTS} $O
