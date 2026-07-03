#!/bin/bash
#
# Copyright (c) nexB Inc. and others. All rights reserved.
# ScanCode is a trademark of nexB Inc.
# SPDX-License-Identifier: Apache-2.0
# See http://www.apache.org/licenses/LICENSE-2.0 for the license text.
# See https://github.com/nexB/scancode-toolkit for support or download.
# See https://aboutcode.org for more information about nexB OSS projects.
#

################################################################################
# ScanCode release build script for PyPI wheels.
# Build a wheel for the current Python version
################################################################################

set -e
# Un-comment to trace execution
#set -x

./configure --dev
venv/bin/scancode-reindex-licenses
venv/bin/scancode-reindex-package-patterns
venv/bin/scancode-train-gibberish-model

# NOTE: scancode-toolkit is a pure Python package, so `uv build` (using the
# hatchling build backend) always produces a single universal "py3-none-any"
# wheel. This replaces the previous setuptools-based build which forced a
# Python-version-specific tag (e.g. cp310) via `--python-tag`.
uv build --wheel

rm -rf build .eggs dist/*.egg-info src/scancode_toolkit*.egg-info src/scancode_toolkit_mini*.egg-info
cp pyproject.toml pyproject-main.toml
cp pyproject-mini.toml pyproject.toml

uv build --wheel

cp pyproject-main.toml pyproject.toml
rm pyproject-main.toml

venv/bin/twine check dist/*

set +e
set +x
