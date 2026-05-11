#!/usr/bin/env node
//
// no-secrets: PreToolUse validator that blocks writes of obvious credentials.
//
// Reads the Claude Code hook JSON envelope from stdin, inspects the target
// file path and content, and exits 2 (block) if anything looks like a secret.
// Exit 0 otherwise. See ../README.md for the full contract.
//

let raw = '';
process.stdin.on('data', chunk => { raw += chunk; });
process.stdin.on('end', () => {
  let input;
  try {
    input = JSON.parse(raw);
  } catch {
    // Malformed envelope. Fail open: don't block on parser bugs, but make noise.
    process.stderr.write('no-secrets: could not parse hook input as JSON, allowing.\n');
    process.exit(0);
  }

  const filePath = input.tool_input?.file_path || '';
  // Write tool uses `content`; Edit/MultiEdit use `new_string`.
  const content = input.tool_input?.content
    || input.tool_input?.new_string
    || (input.tool_input?.edits || []).map(e => e.new_string || '').join('\n');

  const sensitiveNames = [
    /(^|\/)\.env(\.|$)/i,
    /credentials\.json$/i,
    /(^|\/)id_rsa$/,
    /(^|\/)id_ed25519$/,
    /\.pem$/i,
    /\.p12$/i,
    /\.pfx$/i,
    /\.key$/i,
    /(^|\/)\.npmrc$/,
    /(^|\/)\.netrc$/,
  ];

  for (const pattern of sensitiveNames) {
    if (pattern.test(filePath)) {
      process.stderr.write(
        `no-secrets: refusing to write "${filePath}". The file name suggests it holds credentials.\n` +
        `If this is intentional, edit the file outside the agent or relax the pattern in hooks/validators/no-secrets.js.\n`
      );
      process.exit(2);
    }
  }

  const secretPatterns = [
    { name: 'AWS access key',        re: /\bAKIA[0-9A-Z]{16}\b/ },
    { name: 'GitHub token',          re: /\bgh[pousr]_[A-Za-z0-9]{36,}\b/ },
    { name: 'Slack token',           re: /\bxox[abprs]-[A-Za-z0-9-]{10,}\b/ },
    { name: 'Google API key',        re: /\bAIza[0-9A-Za-z_\-]{35}\b/ },
    { name: 'PEM private key',       re: /-----BEGIN (RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----/ },
    { name: 'generic secret string', re: /(api[_-]?key|secret|token|password|passwd)\s*[:=]\s*['"][A-Za-z0-9_\-]{24,}['"]/i },
  ];

  for (const { name, re } of secretPatterns) {
    if (re.test(content)) {
      process.stderr.write(
        `no-secrets: refusing to write content that matches the shape of a ${name}.\n` +
        `If this is a false positive, narrow the pattern in hooks/validators/no-secrets.js.\n`
      );
      process.exit(2);
    }
  }

  process.exit(0);
});
