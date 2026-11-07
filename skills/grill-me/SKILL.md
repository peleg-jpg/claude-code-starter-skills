---
name: grill-me
version: 1.0.0
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

## Why one-at-a-time

A batch questionnaire lets the user answer the easy questions and skate past the ones that hide a real fork. Asking one question at a time, and following each answer to its consequence, surfaces the hidden decision branches a checklist misses - because the next question only exists once you see where the last answer led.

## How

- Ask the questions one at a time.
- If a question can be answered by exploring the codebase, explore the codebase instead of asking.
- For each question, give your recommended answer, then let the user confirm or override before moving to the branch it opens.

## Stopping condition

Stop when shared understanding is reached: no open branches remain, every decision traces to an answered question or an explored fact, and a new question would just be restating something already settled.

When run as the default interview-first step (not an explicit "grill me"): cap at about 10 questions, skip anything memory, the vault or the code already answers, and stop on "skip" or "enough". Close with a 3-6 line decision summary, then hand off to planning.

## Worked example round

Q: "Should the retry logic use exponential backoff or fixed delay?"
Recommended answer: exponential backoff (fixed delay risks thundering-herd retries under a real outage).
Follow-up branch this opens: "What's the max backoff ceiling and retry count before giving up?" - which then opens whether a giving-up state needs to notify the user or just log silently.
