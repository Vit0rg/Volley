const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'patch.lua');
const content = fs.readFileSync(filePath, 'utf8');
const lines = content.split('\n');

// Find all markers with their line numbers (0-indexed)
const markers = [];
for (let i = 0; i < lines.length; i++) {
  const match = lines[i].match(/^--\[\[\s*(src\/.+\.lua)\s*\]\]--$/);
  if (match) {
    markers.push({ line: i, path: match[1] });
  }
}

console.log(`Found ${markers.length} markers`);

// Extract sections
for (let i = 0; i < markers.length; i++) {
  const current = markers[i];
  const next = markers[i + 1];

  // Content starts at line after marker
  const startLine = current.line + 1;
  // Content ends at line before next marker (or end of file)
  const endLine = next ? next.line : lines.length;

  // Extract lines, trim trailing empty lines but keep leading structure
  const sectionLines = lines.slice(startLine, endLine);

  // Remove trailing empty lines
  while (sectionLines.length > 0 && sectionLines[sectionLines.length - 1].trim() === '') {
    sectionLines.pop();
  }

  const sectionContent = sectionLines.join('\n');

  // Write to file
  const outputPath = path.join(__dirname, current.path);
  const outputDir = path.dirname(outputPath);

  fs.mkdirSync(outputDir, { recursive: true });
  fs.writeFileSync(outputPath, sectionContent + '\n', 'utf8');

  console.log(`Wrote ${current.path} (${sectionLines.length} lines)`);
}

console.log(`Done! Extracted ${markers.length} files.`);
