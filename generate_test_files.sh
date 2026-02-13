#!/bin/bash

# PurpleWire - Marketing Test Files Generator
# Creates sample files to test auto-sort functionality

MARKETING="/src/purplewire/Marketing"

echo "================================================"
echo "PurpleWire - Marketing Test Files Generator"
echo "================================================"
echo ""

# Check if Marketing directory exists
if [ ! -d "$MARKETING" ]; then
    echo "❌ Error: $MARKETING directory not found!"
    echo "Please run setup_purplewire_complete.sh first"
    exit 1
fi

echo "Creating test files in: $MARKETING"
echo ""

# ========================================
# CREATE PDF FILES (→ Printable)
# ========================================
echo "1. PDF Files (→ Printable/):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

create_pdf() {
    local filename=$1
    echo "%PDF-1.4
1 0 obj
<<
/Type /Catalog
/Pages 2 0 R
>>
endobj
2 0 obj
<<
/Type /Pages
/Kids [3 0 R]
/Count 1
>>
endobj
3 0 obj
<<
/Type /Page
/Parent 2 0 R
/Resources <<
/Font <<
/F1 <<
/Type /Font
/Subtype /Type1
/BaseFont /Helvetica
>>
>>
>>
/MediaBox [0 0 612 792]
/Contents 4 0 R
>>
endobj
4 0 obj
<<
/Length 44
>>
stream
BT
/F1 12 Tf
100 700 Td
(Test PDF File) Tj
ET
endstream
endobj
xref
0 5
0000000000 65535 f
0000000009 00000 n
0000000058 00000 n
0000000115 00000 n
0000000315 00000 n
trailer
<<
/Size 5
/Root 1 0 R
>>
startxref
407
%%EOF" > "$MARKETING/$filename"
    
    if [ -f "$MARKETING/$filename" ]; then
        echo "  ✓ $filename"
    fi
}

create_pdf "Brochure_2024.pdf"
create_pdf "Product_Catalog.pdf"
create_pdf "Price_List.pdf"

# ========================================
# CREATE VECTOR FILES (→ Vector)
# ========================================
echo ""
echo "2. Vector Files (→ Vector/):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# SVG files
cat > "$MARKETING/Logo_PurpleWire.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
  <circle cx="50" cy="50" r="40" fill="#6B46C1" />
  <text x="50" y="55" font-family="Arial" font-size="14" fill="white" text-anchor="middle">PW</text>
</svg>
EOF
echo "  ✓ Logo_PurpleWire.svg"

cat > "$MARKETING/Icon_Marketing.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="50" height="50" xmlns="http://www.w3.org/2000/svg">
  <rect width="50" height="50" fill="#9333EA" />
</svg>
EOF
echo "  ✓ Icon_Marketing.svg"

# AI file (fake - just text)
echo "Adobe Illustrator Test File" > "$MARKETING/Design_Template.ai"
echo "  ✓ Design_Template.ai"

# CDR file (fake - just text)
echo "CorelDRAW Test File" > "$MARKETING/Banner_Design.cdr"
echo "  ✓ Banner_Design.cdr"

# ========================================
# CREATE IMAGE FILES (→ Image)
# ========================================
echo ""
echo "3. Image Files (→ Image/):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create minimal valid JPG (1x1 pixel red)
printf '\xff\xd8\xff\xe0\x00\x10\x4a\x46\x49\x46\x00\x01\x01\x01\x00\x48\x00\x48\x00\x00\xff\xdb\x00\x43\x00\x03\x02\x02\x02\x02\x02\x03\x02\x02\x02\x03\x03\x03\x03\x04\x06\x04\x04\x04\x04\x04\x08\x06\x06\x05\x06\x09\x08\x0a\x0a\x09\x08\x09\x09\x0a\x0c\x0f\x0c\x0a\x0b\x0e\x0b\x09\x09\x0d\x11\x0d\x0e\x0f\x10\x10\x11\x10\x0a\x0c\x12\x13\x12\x10\x13\x0f\x10\x10\x10\xff\xc9\x00\x0b\x08\x00\x01\x00\x01\x01\x01\x11\x00\xff\xcc\x00\x06\x00\x10\x10\x05\xff\xda\x00\x08\x01\x01\x00\x00\x3f\x00\xd2\xcf\x20\xff\xd9' > "$MARKETING/Photo_Product_1.jpg"
echo "  ✓ Photo_Product_1.jpg"

printf '\xff\xd8\xff\xe0\x00\x10\x4a\x46\x49\x46\x00\x01\x01\x01\x00\x48\x00\x48\x00\x00\xff\xdb\x00\x43\x00\x03\x02\x02\x02\x02\x02\x03\x02\x02\x02\x03\x03\x03\x03\x04\x06\x04\x04\x04\x04\x04\x08\x06\x06\x05\x06\x09\x08\x0a\x0a\x09\x08\x09\x09\x0a\x0c\x0f\x0c\x0a\x0b\x0e\x0b\x09\x09\x0d\x11\x0d\x0e\x0f\x10\x10\x11\x10\x0a\x0c\x12\x13\x12\x10\x13\x0f\x10\x10\x10\xff\xc9\x00\x0b\x08\x00\x01\x00\x01\x01\x01\x11\x00\xff\xcc\x00\x06\x00\x10\x10\x05\xff\xda\x00\x08\x01\x01\x00\x00\x3f\x00\xd2\xcf\x20\xff\xd9' > "$MARKETING/Team_Photo.jpg"
echo "  ✓ Team_Photo.jpg"

# GIF file (1x1 transparent pixel)
printf '\x47\x49\x46\x38\x39\x61\x01\x00\x01\x00\x80\x00\x00\xff\xff\xff\x00\x00\x00\x21\xf9\x04\x01\x00\x00\x00\x00\x2c\x00\x00\x00\x00\x01\x00\x01\x00\x00\x02\x02\x44\x01\x00\x3b' > "$MARKETING/Animation_Banner.gif"
echo "  ✓ Animation_Banner.gif"

# HEIC file (fake - just text with .heic extension)
echo "HEIC Test File" > "$MARKETING/Mobile_Photo.heic"
echo "  ✓ Mobile_Photo.heic"

# ========================================
# CREATE DOCUMENT FILES (→ Docs)
# ========================================
echo ""
echo "4. Document Files (→ Docs/):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create minimal valid DOCX
(cd /tmp && {
    mkdir -p docx_temp/{_rels,word/{_rels,}}
    
    # [Content_Types].xml
    cat > docx_temp/[Content_Types].xml << 'XMLEOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>
XMLEOF

    # _rels/.rels
    cat > docx_temp/_rels/.rels << 'XMLEOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
XMLEOF

    # word/document.xml
    cat > docx_temp/word/document.xml << 'XMLEOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:body>
<w:p><w:r><w:t>Marketing Strategy Document</w:t></w:r></w:p>
</w:body>
</w:document>
XMLEOF

    # Create DOCX
    cd docx_temp
    zip -q -r "$MARKETING/Marketing_Strategy.docx" *
    cd /tmp
    rm -rf docx_temp
})
echo "  ✓ Marketing_Strategy.docx"

# Create another DOCX with different name
(cd /tmp && {
    mkdir -p docx_temp2/{_rels,word/{_rels,}}
    
    cat > docx_temp2/[Content_Types].xml << 'XMLEOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>
XMLEOF

    cat > docx_temp2/_rels/.rels << 'XMLEOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
XMLEOF

    cat > docx_temp2/word/document.xml << 'XMLEOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:body>
<w:p><w:r><w:t>Campaign Plan 2024</w:t></w:r></w:p>
</w:body>
</w:document>
XMLEOF

    cd docx_temp2
    zip -q -r "$MARKETING/Campaign_Plan_2024.docx" *
    cd /tmp
    rm -rf docx_temp2
})
echo "  ✓ Campaign_Plan_2024.docx"

# DOC file (fake - just text)
echo "Microsoft Word 97-2003 Test File" > "$MARKETING/Press_Release.doc"
echo "  ✓ Press_Release.doc"

# ========================================
# SET PERMISSIONS
# ========================================
echo ""
echo "5. Setting permissions..."
chown -R root:employees "$MARKETING"
chmod -R 775 "$MARKETING"
echo "  ✓ All files owned by root:employees"

# ========================================
# SUMMARY
# ========================================
echo ""
echo "================================================"
echo "✓ TEST FILES CREATED!"
echo "================================================"
echo ""
echo "Files created in: $MARKETING"
echo ""

# Count files
total_files=$(find "$MARKETING" -maxdepth 1 -type f | wc -l)
echo "Total files in Marketing root: $total_files"
echo ""

# List files
echo "Current files in Marketing root:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ls -lh "$MARKETING" | grep -v "^d" | awk '{print "  ", $9, "(" $5 ")"}'
echo ""

echo "Expected auto-sort results:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Printable/ → 3 PDF files"
echo "  Vector/    → 4 vector files (SVG, AI, CDR)"
echo "  Image/     → 4 image files (JPG, GIF, HEIC)"
echo "  Docs/      → 3 document files (DOC, DOCX)"
echo ""

echo "To test auto-sort manually:"
echo "  sudo /usr/local/bin/sort-marketing"
echo ""
echo "Or wait 5 minutes for automatic sorting (cron job)"
echo ""

echo "To check results after sorting:"
echo "  ls -R $MARKETING"
echo ""