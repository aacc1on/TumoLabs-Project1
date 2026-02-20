#!/bin/bash

# Compatibility wrapper.
# The setup script is now fully self-healing and includes all fixes.

set -e

echo "================================"
echo "PurpleWire - Unified Setup"
echo "================================"
echo ""
echo "This helper now delegates to setup_purplewire_complete.sh"
echo "because all fixes are integrated into a single script."
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/setup_purplewire_complete.sh"
