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
# ScanCode release build script for PyPI sdists
################################################################################

set -e
# Un-comment to trace execution
#set -x

./configure --dev
uv build --sdist

rm -rf build .eggs dist/*.egg-info src/scancode_toolkit*.egg-info src/scancode_toolkit_mini*.egg-info
cp pyproject.toml pyproject-main.toml
cp pyproject-mini.toml pyproject.toml

uv build --sdist

cp pyproject-main.toml pyproject.toml
rm pyproject-main.toml

venv/bin/twine check dist/*

set +e
set +x
