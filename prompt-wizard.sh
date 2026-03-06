#!/bin/bash

# Prompt Wizard - Interactive CLI tool for structuring high-quality AI agent prompts
# Usage: ./prompt-wizard.sh [--refine <file>] [--refine-using-claude]

set -e

# Color definitions
COLOR_BLUE='\033[0;34m'
COLOR_CYAN='\033[0;36m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_BOLD='\033[1m'
COLOR_RESET='\033[0m'

# Parse command-line arguments
REFINE_WITH_CLAUDE=false
REFINE_FILE=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --refine-using-claude|-refine-using-claude)
      REFINE_WITH_CLAUDE=true
      shift
      ;;
    --refine)
      REFINE_FILE="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--refine <file>] [--refine-using-claude]"
      exit 1
      ;;
  esac
done

# Function to print colored headers
print_header() {
  local section_num=$1
  local section_title=$2
  echo "" >&2
  echo -e "${COLOR_BOLD}${COLOR_BLUE}═══════════════════════════════════════${COLOR_RESET}" >&2
  echo -e "${COLOR_BOLD}${COLOR_BLUE}Section $section_num: $section_title${COLOR_RESET}" >&2
  echo -e "${COLOR_BOLD}${COLOR_BLUE}═══════════════════════════════════════${COLOR_RESET}" >&2
  echo "" >&2
}

# Function to print questions
print_question() {
  echo -e "${COLOR_CYAN}❓ $1${COLOR_RESET}" >&2
  echo "" >&2
}

# Function to read multi-line input
read_multiline() {
  local prompt="$1"
  local existing="$2"
  echo -e "${COLOR_YELLOW}$prompt${COLOR_RESET}" >&2

  if [[ -n "$existing" ]]; then
    echo "(Existing content shown below)" >&2
    echo "" >&2
    echo -e "${COLOR_CYAN}$existing${COLOR_RESET}" >&2
    echo "" >&2
    echo "(Type 'KEEP' to keep, enter new content to replace, or empty line to skip)" >&2
  else
    echo "(Type content line by line, empty line to finish, or 'END' to skip)" >&2
  fi
  echo "" >&2

  local input=""
  local is_first_line=true

  while IFS= read -r line; do
    # Handle KEEP for existing content
    if [[ "$line" == "KEEP" ]] && [[ "$is_first_line" == true ]] && [[ -n "$existing" ]]; then
      echo -n "$existing"
      return
    fi

    # Handle END/skip
    if [[ -z "$line" ]] && [[ "$is_first_line" == true ]]; then
      if [[ -n "$existing" ]]; then
        echo -n "$existing"
      fi
      return
    fi

    is_first_line=false

    # Collect content until empty line
    if [[ -z "$line" ]]; then
      # Empty line ends input
      break
    fi

    input+="$line"$'\n'
  done

  # Return input without trailing newline
  echo -n "${input%$'\n'}"
}

# Function to escape special characters for markdown
escape_markdown() {
  local text="$1"
  # Escape backticks and backslashes
  text="${text//\\/\\\\}"
  text="${text//\`/\\\`}"
  echo "$text"
}

# Function to extract section from markdown file
extract_section() {
  local file="$1"
  local section_name="$2"

  if ! grep -q "^## $section_name" "$file"; then
    return
  fi

  # Extract section between headers and trim blank lines from start/end
  sed -n "/^## $section_name/,/^## /p" "$file" | \
    sed '1d;$d' | \
    sed -e :a -e '/^\s*$/{$d; N; ba' -e '   }' | \
    sed -e '1{/^[[:space:]]*$/d;}'
}

# Function to load existing prompt file
load_existing_prompt() {
  local file="$1"

  if [[ ! -f "$file" ]]; then
    echo "Error: File not found: $file" >&2
    exit 1
  fi

  echo "Loading existing prompt..." >&2
  GOAL=$(extract_section "$file" "Core Objective")
  SCOPE=$(extract_section "$file" "Scope")
  RULES=$(extract_section "$file" "Rules & Constraints")
  TECH=$(extract_section "$file" "Technical Context")
  LANGUAGE=$(extract_section "$file" "Language & Localization")
  PERSONA=$(extract_section "$file" "Persona & Style")
  ROBUSTNESS=$(extract_section "$file" "Robustness")
  SELF_IMPROVE=$(extract_section "$file" "Self-Improvement")
  EVAL=$(extract_section "$file" "Test Cases & Validation Criteria")
}

# Welcome message
echo -e "${COLOR_GREEN}${COLOR_BOLD}" >&2
cat << 'EOF' >&2
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║                          🧙 PROMPT WIZARD 🧙                           ║
║                                                                           ║
║              Structured Agent Prompt Design Tool                        ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${COLOR_RESET}" >&2

if [[ -n "$REFINE_FILE" ]]; then
  load_existing_prompt "$REFINE_FILE"
  echo "Refining existing prompt: $REFINE_FILE" >&2
  echo "You can skip sections by leaving them empty or typing 'KEEP' to keep existing content." >&2
  echo "" >&2
else
  echo "Let's create a high-quality agent prompt together!" >&2
  echo "Answer the following 9 sections to design your AI agent." >&2
  echo "" >&2
fi

# ============================================================================
# SECTION 1: GOAL
# ============================================================================

print_header "1" "Core Objective (Goal)"
print_question "What is the core objective of this agent?"
echo "Example: 'A customer support bot that resolves issues in real-time'" >&2
echo "" >&2

GOAL=$(read_multiline "Enter the goal of your agent:" "$GOAL")

# ============================================================================
# SECTION 2: SCOPE
# ============================================================================

print_header "2" "Scope"
print_question "What are the inputs, outputs, and boundaries?"
echo "Example:" >&2
echo "  - Inputs: Customer messages, order history" >&2
echo "  - Outputs: Solutions, status updates" >&2
echo "  - Boundaries: No refunds > \$500, no access to PII" >&2
echo "" >&2

SCOPE=$(read_multiline "Describe the scope:" "$SCOPE")

# ============================================================================
# SECTION 3: RULES & CONSTRAINTS
# ============================================================================

print_header "3" "Rules & Constraints"
print_question "What are the core tenets, any taboos, and success metrics?"
echo "Example:" >&2
echo "  - Tenets: Customer-first, data privacy, efficiency" >&2
echo "  - Taboos: No making promises about refunds, no guarantees" >&2
echo "  - Metrics: Response time < 2s, satisfaction > 95%" >&2
echo "" >&2

RULES=$(read_multiline "Enter rules and constraints:" "$RULES")

# ============================================================================
# SECTION 4: TECH
# ============================================================================

print_header "4" "Technical Context"
print_question "What tools/APIs will it use? Model constraints? Deployment context?"
echo "Example:" >&2
echo "  - Tools: REST API for orders, Stripe integration" >&2
echo "  - Model: GPT-4, max tokens 2048" >&2
echo "  - Deployment: Lambda, 30s timeout" >&2
echo "" >&2

TECH=$(read_multiline "Enter technical context:" "$TECH")

# ============================================================================
# SECTION 5: LANGUAGE
# ============================================================================

print_header "5" "Language & Localization"
print_question "What input/output languages? Any locale requirements?"
echo "Example: English and Spanish, US and EU timezone handling, GDPR compliant" >&2
echo "" >&2

LANGUAGE=$(read_multiline "Enter language and localization requirements:" "$LANGUAGE")

# ============================================================================
# SECTION 6: PERSONA
# ============================================================================

print_header "6" "Persona & Style"
print_question "What voice/style should it use?"
echo "Example:" >&2
echo "  - Professional but friendly" >&2
echo "  - Concise but thorough" >&2
echo "  - Use first person, avoid jargon" >&2
echo "" >&2

PERSONA=$(read_multiline "Describe the persona and style:" "$PERSONA")

# ============================================================================
# SECTION 7: ROBUSTNESS
# ============================================================================

print_header "7" "Robustness"
print_question "What edge cases should it handle? What guardrails? Fallbacks?"
echo "Example:" >&2
echo "  - Edge Cases: Malformed input, rate limits, API failures" >&2
echo "  - Guardrails: Always verify before taking action, log all decisions" >&2
echo "  - Fallbacks: Escalate to human on uncertainty, graceful degradation" >&2
echo "" >&2

ROBUSTNESS=$(read_multiline "Enter robustness considerations:" "$ROBUSTNESS")

# ============================================================================
# SECTION 8: SELF-IMPROVEMENT
# ============================================================================

print_header "8" "Self-Improvement"
print_question "How should it critique itself? What iteration rules?"
echo "Example:" >&2
echo "  - After each interaction, rate own performance" >&2
echo "  - Track failure modes and adjust instructions" >&2
echo "  - Weekly: review low-confidence decisions" >&2
echo "" >&2

SELF_IMPROVE=$(read_multiline "Enter self-improvement strategy:" "$SELF_IMPROVE")

# ============================================================================
# SECTION 9: EVALUATION
# ============================================================================

print_header "9" "Evaluation"
print_question "Provide 3 test cases with validation criteria."
echo "Example:" >&2
echo "  Test 1: Customer requests refund for damaged item" >&2
echo "  - Expected: Verify damage, approve refund, send confirmation" >&2
echo "  - Criteria: Response time < 3s, accuracy 100%" >&2
echo "" >&2

EVAL=$(read_multiline "Enter test cases and validation criteria:" "$EVAL")

# ============================================================================
# GENERATE OUTPUT
# ============================================================================

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="agent-prompt-${TIMESTAMP}.md"

cat > "$OUTPUT_FILE" << EOF
# Agent Prompt

## Core Objective

$GOAL

## Scope

$SCOPE

## Rules & Constraints

$RULES

## Technical Context

$TECH

## Language & Localization

$LANGUAGE

## Persona & Style

$PERSONA

## Robustness

$ROBUSTNESS

## Self-Improvement

$SELF_IMPROVE

---

# Evaluation Suite

## Test Cases & Validation Criteria

$EVAL

---

# Refinement Loop

To improve this prompt:

1. **Run Test Cases**: Execute the evaluation test cases from the section above
2. **Identify Failure Modes**: Document where the agent failed or underperformed
3. **Analyze Root Causes**: Determine which sections need improvement
4. **Update Sections**: Refine the relevant prompt sections based on findings
5. **Re-validate**: Run test cases again to verify improvements
6. **Iterate**: Repeat until performance meets success criteria

## Meta-Prompt for Upgrades

When you're ready for an advanced refinement, use this meta-prompt:

> "Analyze this agent prompt and suggest improvements based on actual usage patterns and failure cases. Consider:
> - Missing context or constraints
> - Ambiguous instructions
> - Edge cases not covered
> - Performance bottlenecks
> - Opportunities for better self-correction
>
> Provide specific recommendations for each section, prioritized by impact."

---

**Generated**: $(date)
**Wizard Version**: 1.0
EOF

echo "" >&2
echo -e "${COLOR_GREEN}${COLOR_BOLD}✓ Agent prompt created successfully!${COLOR_RESET}" >&2
echo "" >&2
echo -e "Output file: ${COLOR_BOLD}$OUTPUT_FILE${COLOR_RESET}" >&2
echo "" >&2

# ============================================================================
# OPTIONAL: REFINE WITH CLAUDE
# ============================================================================

if [[ "$REFINE_WITH_CLAUDE" == true ]]; then
  echo -e "${COLOR_YELLOW}Refining with Claude...${COLOR_RESET}" >&2
  echo "" >&2

  # Check if claude command is available
  if ! command -v claude &> /dev/null; then
    echo -e "${COLOR_YELLOW}⚠ Claude CLI not found. Skipping refinement.${COLOR_RESET}" >&2
    echo "To enable refinement, install Claude: https://github.com/anthropics/claude-code" >&2
  else
    REFINED_FILE="agent-prompt-${TIMESTAMP}-refined.md"

    # Use Claude to refine the prompt
    if cat "$OUTPUT_FILE" | claude —-dangerously-skip-permissions --raw "Polish this agent prompt for clarity and completeness, preserving all structure and content. Make it more precise and actionable." > "$REFINED_FILE" 2>/dev/null; then
      echo -e "${COLOR_GREEN}✓ Refined version created!${COLOR_RESET}" >&2
      echo "" >&2
      echo -e "Base file:     ${COLOR_BOLD}$OUTPUT_FILE${COLOR_RESET}" >&2
      echo -e "Refined file:  ${COLOR_BOLD}$REFINED_FILE${COLOR_RESET}" >&2
    else
      echo -e "${COLOR_YELLOW}⚠ Refinement failed. Check your Claude API key.${COLOR_RESET}" >&2
      echo "Base prompt saved to: $OUTPUT_FILE" >&2
    fi
  fi
fi

echo "" >&2
echo -e "${COLOR_GREEN}${COLOR_BOLD}🎉 Wizard complete!${COLOR_RESET}" >&2
echo "" >&2
echo "Next steps:" >&2
echo "1. Review the generated prompt file" >&2
echo "2. Run your test cases" >&2
echo "3. Iterate based on results" >&2
echo "4. Use the refinement loop to improve" >&2
echo "" >&2
