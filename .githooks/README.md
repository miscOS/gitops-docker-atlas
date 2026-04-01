# Git Hooks Setup Guide

## Overview
This directory contains custom Git hooks that automate tasks during your Git workflow. Git hooks are scripts that run automatically when specific Git events occur.

## Installation

To enable these hooks in your repository, run the following command from your repository root:

```bash
git config core.hooksPath .githooks
```

## Test Hooks
```bash
git hook run pre-commit
```

## Rotate encryption
```bash
bash ./.githooks/pre-commit --reencrypt
```