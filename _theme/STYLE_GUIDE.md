# OCN 682 — Lecture Style Guide
**Data Science Fundamentals in R**  
Last updated: August 2026

This guide documents all design conventions for the lecture series. Every lecture should reference `custom-theme.scss` and follow these patterns for visual consistency.

---

## File Setup

Every `.qmd` lecture file should use this YAML header, updating the `title`, `subtitle`, `footer`, and `date` fields:

```yaml
---
title: "Computer Modeling (OCN 682)"
subtitle: "Your Lecture Title Here"
author: "Dr. Nyssa Silbiger"
institute: "UH Fall 2026"
date: today
format:
  revealjs:
    theme: [default, ../_theme/custom-theme.scss]
    highlight-style: github
    code-line-numbers: true
    width: 1500
    height: 1000
    preview-links: auto
    self-contained-math: true
    embed-resources: false
    slide-number: c/t
    footer: "OCN 682 | Week X | Lecture Title"
---
```

> ⚠️ Update the path to `custom-theme.scss` relative to each week's folder.

---

## Slide Types

### Regular slide
```markdown
## Slide Title

Content here.
```

### Section-break slide (inverse — dark background with gradient bars)
Use for major topic transitions only. Title text goes directly on the `##` line:
```markdown
## Section Title {.inverse .center .middle}
```

### Centered content slide
```markdown
## Slide Title {.center}
```

### Thanks / closing slide
```markdown
## {.center .middle}

# Thanks!

Slides created via [**Quarto**](https://quarto.org/)
```

---

## Color Convention

All three brand colors have a defined semantic role. Use them consistently:

| Color | Hex | Role |
|-------|-----|------|
| 🟠 Orange | `#F58634` | Function names, operators, data types |
| 🟢 Green  | `#007965` | Variables, user-defined objects, R output |
| 🟡 Yellow | `#FFCC29` | Warnings, errors, critical gotchas |

---

## Inline Code Annotation Classes

Use these span classes to annotate code **in prose** (not inside code blocks).  
Syntax: `[text]{.classname}`

| Class | Color | Monospace | Use for | Example |
|-------|-------|-----------|---------|---------|
| `.fn` | 🟠 Orange | ✓ | Function names | `[ggplot]{.fn}()` |
| `.op` | 🟠 Orange | ✓ | Operators | `[<-]{.op}`, `[+]{.op}` |
| `.dt` | 🟠 Orange | ✓ | Data type names | `[numeric]{.dt}`, `[factor]{.dt}` |
| `.param` | 🟡 Dark yellow | ✓ | User-supplied arguments | `[x]{.param}`, `["hello"]{.param}` |
| `.default-param` | Gray italic | ✓ | Default arguments | `[na.rm = FALSE]{.default-param}` |
| `.var` | 🟢 Green | ✓ | Variable / object names | `[my_df]{.var}`, `[result]{.var}` |
| `.err` | 🟡 Yellow bg | ✓ | Errors, things to avoid | `[=]{.err}` instead of `[<-]{.op}` |
| `.orange` | 🟠 Orange | ✗ | General orange emphasis | `[important]{.orange}` |
| `.green`  | 🟢 Green  | ✗ | General green emphasis  | `[correct]{.green}` |
| `.yellow` | 🟡 Yellow | ✗ | General yellow emphasis | `[caution]{.yellow}` |

**Example in a slide:**
```markdown
Use [sqrt]{.fn}([x]{.param}) to take the square root of [x]{.var}.  
Never use [=]{.err} for assignment — always use [<-]{.op}.
```

---

## Code Blocks

### Show output only (default for data structure examples)
```r
```{r label, echo=FALSE}
your_code_here
```
```

### Show code + output (default for teaching syntax)
```r
```{r label}
#| echo: true
#| eval: true
your_code_here
```
```

### Show code only (no execution)
```r
```{r label}
#| echo: true
#| eval: false
your_code_here
```
```

**Visual convention:**
- 🟠 Orange left border = code input (what you type)
- 🟢 Green left border = R output (what R returns)

---

## Callout Boxes

Three flavors, each with a specific purpose:

### Tip — orange (coding best practices, syntax reminders)
```markdown
::: {.callout-tip}
## Title Here
Content here.
:::
```

### Note — green (general info, context, reminders)
```markdown
::: {.callout-note}
## Title Here
Content here.
:::
```

### Warning — yellow (common mistakes, things to avoid)
```markdown
::: {.callout-warning}
## Title Here
Content here.
:::
```

---

## Incremental Reveals

### Bullet lists — use `.incremental`
```markdown
::: {.incremental}
- First point
- Second point
- Third point
:::
```

### Non-list content (paragraphs, images, code blocks) — use `.fragment`
Each `.fragment` appears on a separate click:
```markdown
::: {.fragment}
Content that appears on click 1
:::

::: {.fragment}
Content that appears on click 2
:::
```

> ⚠️ Do **not** wrap `.columns` in `.incremental` — it doesn't work.  
> Instead, put `.fragment` **inside** each column:

```markdown
::: {.columns}

::: {.column width="50%"}
::: {.fragment}
Left content — appears on click 1
:::
:::

::: {.column width="50%"}
::: {.fragment}
Right content — appears on click 2
:::
:::

:::
```

---

## Column Layouts

Always use the Quarto columns system. Never use `float: right` or `float: left`.

### Two columns (50/50)
```markdown
::: {.columns}

::: {.column width="50%"}
Left content
:::

::: {.column width="50%"}
Right content
:::

:::
```

### Two columns (text-heavy / image)
```markdown
::: {.columns}

::: {.column width="60%"}
Text or list content
:::

::: {.column width="40%"}
![](image.png){width="100%"}
:::

:::
```

### Three columns
```markdown
::: {.columns}

::: {.column width="33%"}
Content A
:::

::: {.column width="33%"}
Content B
:::

::: {.column width="33%"}
Content C
:::

:::
```

> ⚠️ Always add `{width="100%"}` to images inside columns to prevent them from breaking the layout.

---

## Images

```markdown
![](path/to/image.png){fig-align="center" width="70%"}
```

- Use `fig-align="center"` for standalone images
- Use `width="100%"` for images inside columns
- Prefer remote URLs for web images; store local images in `libs/images/`

---

## Footer Convention

Update the footer for each lecture to follow this pattern:

```
"OCN 682 | Week X | Short Lecture Title"
```

| Week | Lecture | Footer |
|------|---------|--------|
| 1 | What is Data | `OCN 682 \| Week 1 \| What is Data?` |
| 1 | Collecting Data | `OCN 682 \| Week 1 \| Collecting Data & Metadata` |
| 2 | *(next)* | `OCN 682 \| Week 2 \| Lecture Title` |

---

## Quick Reference Card

```markdown
<!-- Section break -->
## Title {.inverse .center .middle}

<!-- Incremental list -->
::: {.incremental}
- item
:::

<!-- Incremental non-list -->
::: {.fragment}
content
:::

<!-- Callouts -->
::: {.callout-tip}    <!-- orange -->
::: {.callout-note}   <!-- green  -->
::: {.callout-warning} <!-- yellow -->

<!-- Inline annotation -->
[fn_name]{.fn}   [arg]{.param}   [var_name]{.var}   [bad]{.err}

<!-- Two columns -->
::: {.columns}
::: {.column width="50%"}
:::
::: {.column width="50%"}
:::
:::
```
