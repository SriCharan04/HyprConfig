#!/usr/bin/env python3
import re, sys, json, os

# Usage: make_diverse_sprite.py palette.json input.svg output.svg

if len(sys.argv) != 4:
    print("Usage: make_diverse_sprite.py PALETTE_JSON input.svg output.svg")
    sys.exit(1)

palette_json, inp_svg, out_svg = sys.argv[1:]

# Load your extracted palette (dark by default)
with open(os.path.expanduser(palette_json)) as f:
    data = json.load(f)
palette = data["colors"]["dark"]

# Define the placeholder keys you want to cycle through for diversity:
keys = [
    "primary",
    "primary_container",
    "secondary",
    "secondary_container",
    "tertiary",
    "tertiary_container",
    "error",
    "surface_variant",
    "outline"
]

# Prepare an iterator over placeholders
placeholders = [
    "{{colors.%s.default.hex}}" % k for k in keys
]

# Read the SVG in one string
with open(inp_svg) as f:
    svg = f.read()

# Function to replace each stop-color once, cycling placeholders
stop_index = 0
def replace_stop(match):
    global stop_index
    ph = placeholders[stop_index % len(placeholders)]
    stop_index += 1
    return f'stop-color:{ph}'

# Apply to both style="stop-color:…"
svg = re.sub(
    r'stop-color\s*:\s*#(?:[0-9A-Fa-f]{6})',
    replace_stop,
    svg
)

# Write out the transformed SVG
os.makedirs(os.path.dirname(out_svg), exist_ok=True)
with open(out_svg, "w") as f:
    f.write(svg)

print("Wrote diverse-stop SVG template to", out_svg)