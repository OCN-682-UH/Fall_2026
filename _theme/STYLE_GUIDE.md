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
resources:
  - custom-theme.scss
format:
  revealjs:
    theme: [default, custom-theme.scss]
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

### Self-contained theme copy (required for publishing)

Each `Week_XX/` folder must have its **own copy** of `custom-theme.scss` sitting next to the lecture `.qmd` file(s) — do **not** reference `_theme/custom-theme.scss` with a relative `../` path.

> ⚠️ **Why:** When a single lecture is published (e.g., to Posit Connect Cloud) via `rsconnect::deployDoc()`, the deployment bundle only includes the document's own folder. A `../_theme/custom-theme.scss` reference resolves fine locally but doesn't exist on the server, causing Quarto to misinterpret the path as a built-in theme name and fail to render (`custom-theme.scss.scss not found`).

**Setup for a new week:**
```bash
cp _theme/custom-theme.scss Week_XX/custom-theme.scss
```
Then reference it in the YAML with a bare filename, as shown above: `theme: [default, custom-theme.scss]`.

**Also required — declare it as a `resources:` entry.** `rsconnect::deployDoc()` only auto-bundles files it detects being used by executed R code (images, data files, etc.) — it does not scan the `theme:` field. Without an explicit top-level `resources:` entry, `custom-theme.scss` will silently be left out of the deployment bundle even though it renders fine locally, causing the exact same publish failure as the `../_theme/` path issue. Always add it as shown in the YAML template above, and verify with `quarto inspect your-file.qmd` that `custom-theme.scss` appears under `"resources"` before publishing.

**Keeping copies in sync:** `_theme/custom-theme.scss` remains the source of truth. If you edit it (new colors, callout styles, etc.), re-copy it into every `Week_XX/` folder — the per-week copies do not update automatically:
```bash
for d in Week_*/; do cp _theme/custom-theme.scss "$d"; done
```

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

> ⚠️ **Always set `echo=TRUE` explicitly — never rely on the default.** In
> testing, revealjs chunks without an explicit `echo=TRUE` (or `#| echo: true`)
> silently dropped the source code from the rendered HTML, even though the
> code was present in the knitr-executed intermediate markdown. This affected
> plain `eval=FALSE` chunks and chunks with no echo/eval options at all. Every
> chunk meant to show code to students — including the visible half of a
> two-column code/output pair — must set `echo=TRUE` (or `echo = TRUE`) in its
> own chunk header, even though `echo` is nominally `TRUE` by default. Only
> the `-out`/`ref.label` output-only half of a pair, and chunks like `setup`
> that are meant to be fully hidden, should use `echo=FALSE`.

---

## Building Up Code Step-by-Step

When teaching a concept by building a plot (or any code) incrementally across a
sequence of slides — one small addition per slide — use the `code-line-numbers`
chunk option to highlight **only the line(s) that are new** on that slide. This
draws the reader's eye straight to what changed instead of making them re-read
the whole block each time.

```r
```{r plot-label6, eval=FALSE, echo=TRUE}
#| code-line-numbers: "2"
ggplot(data = penguins,
  mapping = aes(x = bill_depth_mm))
```
```

**Guidelines:**
- Put `#| code-line-numbers: "N"` as the **first line inside the chunk**, right
  after the opening fence (`code-line-numbers: true` in the YAML header already
  turns on line numbers globally — this option layers a highlight on top).
- Count lines from the first line of code inside the chunk (line 1), including
  blank lines within the chunk body.
- Highlight multiple lines/ranges with a comma- or hyphen-separated string,
  e.g. `"4,9"` or `"2-4"`, when more than one line changed.
- Only add this to the chunk that actually **shows** the code (the
  `eval=FALSE, echo=TRUE` chunk in a two-column code/output pair). The paired
  `ref.label` output-only chunk doesn't need it.
- When a slide isn't strictly "new code" but instead **emphasizes** which
  existing line(s) relate to the concept being introduced (e.g. pointing out
  the `color =` lines on a slide about the `color` aesthetic), highlight those
  lines instead of literally-new ones — the goal is to direct attention, not
  strictly track diffs.
- After adding or editing line numbers, re-render and check that the fenced
  code block still has the correct opening/closing triple-backticks and that
  any surrounding `::: {.columns}` / `::: {.column}` divs are still balanced —
  hand-editing existing chunks is an easy place to accidentally drop a closing
  fence or `:::`.

*Used throughout the Intro to Plotting deck's step-by-step `ggplot()` build-up
(`plot-label5`–`plot-label15`), the aesthetic-mapping slides (Color/Shape/Size/Alpha),
and the faceting slides.*

---

## Shrinking Titles on Progressively-Built Slides

When a slide title itself grows longer at each step of a build-up sequence
(e.g. "Start with the penguin dataframe" then "...and map bill depth to the
x-axis" then "...and map bill length to the y-axis." and so on), the default
h2 size (1.8em) will wrap and eat into the space needed for the code/output
below. Add the `.smaller-title` class to the heading to shrink just that
slide's title:

```markdown
## Start with the [penguin]{.orange} dataframe, [map bill depth to the x-axis]{.yellow} {.smaller-title}
```

**Guidelines:**
- Add `{.smaller-title}` at the very end of the heading line, after any
  inline spans (e.g. `[text]{.orange}`). Pandoc treats a trailing `{...}`
  block as the header's own attributes (applied to the slide's `<section>`),
  not as another inline span, as long as it isn't glued directly onto a
  `[...]` bracket.
- The class is defined once in `custom-theme.scss` under `.smaller-title h2`
  (currently `font-size: 0.75em` with a tightened `line-height` and
  `margin-bottom`). Reuse it rather than inventing a one-off size per slide.
- Only apply it to slides where the title text is genuinely the source of
  overflow (long, incrementally-built titles). Don't apply it broadly to
  every slide; most titles are short enough at the default size.
- If a title is still overflowing after `.smaller-title`, the culprit is
  likely elsewhere (code block width/font-size, image size). Investigate the
  slide's content rather than shrinking the title further.

*Used on the `plot-label5` through `plot-label15` progressive `ggplot()` build-up
slides in the Intro to Plotting deck.*

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
