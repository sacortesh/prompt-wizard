# Prompt Wizard

An interactive CLI tool for structuring high-quality AI agent prompts using a proven 9-section methodology.

## Overview

Instead of writing prompts from scratch, **Prompt Wizard** guides you through a systematic Q&A flow covering:

1. **Core Objective** - What should the agent do?
2. **Scope** - What are inputs, outputs, and boundaries?
3. **Rules & Constraints** - Core tenets, taboos, and success metrics
4. **Technical Context** - Tools, APIs, model constraints, deployment
5. **Language & Localization** - Language support and regional requirements
6. **Persona & Style** - Voice, tone, and communication style
7. **Robustness** - Edge cases, guardrails, and fallback behaviors
8. **Self-Improvement** - How the agent should critique itself
9. **Evaluation** - Test cases and validation criteria

The tool generates a **structured markdown file** containing:
- A complete agent prompt with all 9 sections
- An evaluation suite with test cases
- A refinement loop template for continuous improvement

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/prompt-wizard.git
cd prompt-wizard

# Make the script executable
chmod +x prompt-wizard.sh

# Optionally add to PATH for global access
ln -s $(pwd)/prompt-wizard.sh /usr/local/bin/prompt-wizard
```

## Usage

### Basic Usage

```bash
./prompt-wizard.sh
```

This will launch an interactive wizard that:
- Presents each section with guiding questions
- Accepts multi-line input (press Enter twice or type `END` to finish)
- Generates a timestamped markdown file

### With Claude Refinement

```bash
./prompt-wizard.sh --refine-using-claude
```

This creates two files:
1. `agent-prompt-TIMESTAMP.md` - Your raw prompt
2. `agent-prompt-TIMESTAMP-refined.md` - Claude-polished version

**Note:** Requires [Claude CLI](https://github.com/anthropics/claude-code) with valid API key.

## Example Workflow

```bash
$ ./prompt-wizard.sh

╔═══════════════════════════════════════════════════════════════════════════╗
║                          🧙 PROMPT WIZARD 🧙                           ║
║              Structured Agent Prompt Design Tool                        ║
╚═══════════════════════════════════════════════════════════════════════════╝

Let's create a high-quality agent prompt together!
Answer the following 9 sections to design your AI agent.

═══════════════════════════════════════════
Section 1: Core Objective (Goal)
═══════════════════════════════════════════

❓ What is the core objective of this agent?
Example: 'A customer support bot that resolves issues in real-time'

> A code review assistant that analyzes pull requests and provides constructive feedback

[Output file created: agent-prompt-20260306_143025.md]
```

## Output Format

The generated markdown file includes:

```markdown
# Agent Prompt

## Core Objective
[Your goal]

## Scope
[Inputs, outputs, boundaries]

## Rules & Constraints
[Tenets, taboos, metrics]

## Technical Context
[Tools, APIs, model constraints]

## Language & Localization
[Language support, locale requirements]

## Persona & Style
[Voice and tone]

## Robustness
[Edge cases, guardrails, fallbacks]

## Self-Improvement
[Critique and iteration strategy]

---

# Evaluation Suite

## Test Cases & Validation Criteria
[Your test cases]

---

# Refinement Loop

To improve this prompt:
1. Run test cases
2. Identify failure modes
3. Update relevant sections
4. Re-validate
```

## Best Practices

### 1. Be Specific
- Instead of: "Handle errors"
- Use: "Log all API failures to CloudWatch, retry with exponential backoff, escalate to human after 3 failures"

### 2. Provide Examples
When describing persona or rules, include concrete examples of expected behavior.

### 3. Define Success Metrics
Each section should have measurable criteria where possible.

### 4. Test Iteratively
- Run your test cases against the prompt
- Document failure modes
- Update sections based on actual performance
- Re-test

### 5. Use the Refinement Loop
The generated template includes a meta-prompt for advanced refinement with Claude or other models.

## Tips

- **Multi-line Input**: The wizard supports flexible input. Press Enter twice to finish each section, or type `END` alone on a line.
- **Colors**: The wizard uses colors to distinguish questions, sections, and results. Works best in modern terminals.
- **Timestamps**: Files are named with `TIMESTAMP` for easy organization and version tracking.
- **No Overwrites**: Each run creates a new file, preserving your history.

## Examples

See the `examples/` directory for sample agent prompts created with Prompt Wizard:
- `customer-support-bot.md` - Customer service agent
- `code-review-assistant.md` - Code review bot
- `data-analyst.md` - Data analysis and visualization agent

(To be added with example outputs)

## Requirements

- **Bash 4.0+** (built-in on macOS and Linux)
- **Optional**: [Claude CLI](https://github.com/anthropics/claude-code) for `--refine-using-claude` flag

## Troubleshooting

### Q: The wizard exits prematurely
**A:** Make sure you're pressing Enter twice or typing `END` to finish multi-line input.

### Q: Claude refinement fails
**A:** Check that:
1. Claude CLI is installed: `command -v claude`
2. Your API key is configured
3. Your account has usage available

### Q: Special characters break the output
**A:** The script handles most special characters. If you encounter issues with backticks or backslashes, try escaping them manually.

## Contributing

Contributions are welcome! Areas for improvement:
- Additional question templates for specialized agent types
- Export formats (YAML, JSON)
- Integration with prompt validation tools
- Example library expansion

## License

MIT

## Author

Created with ❤️ for better AI agent design.
