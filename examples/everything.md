# Markdown to Typst Feature Reference

This document exercises every Markdown feature supported by mdtyp.

---

## Headings

### Third Level

#### Fourth Level

##### Fifth Level

###### Sixth Level

## Heading with **bold** and _italic_ words

## Heading with `inline code`

---

## Inline Formatting

This is **bold text** and this is _italic text_ and this is ~~strikethrough text~~.

Combining: **bold and _italic_ together** and ~~strikethrough with **bold**~~.

Here is `inline code` in a sentence.

---

## Links and Images

Here is a [link to Google](https://google.com) and a [link with **bold** text](https://example.com).

<!-- Images omitted: Typst requires actual image files to compile.
     Syntax: ![Photo of a sunset](sunset.jpg) → #figure(image("sunset.jpg"), caption: [...]) -->

---

## Lists

### Unordered List

- Item one
- Item two
- Item three

### Ordered List

1. First item
2. Second item
3. Third item

### Nested Unordered

- Top level
  - Second level
    - Third level
  - Back to second
- Back to top

### Nested Ordered

1. First
   1. Sub first
   2. Sub second
2. Second
   1. Another sub

### Mixed Nesting

1. Ordered top
   - Unordered child
   - Another child
2. Back to ordered
   - Child again
     1. Deep ordered
     2. More deep

### List Items with Formatting

- **Bold item**
- _Italic item_
- Item with `code`
- Item with [a link](https://example.com)

---

## Blockquotes

> This is a simple blockquote.

> This is a blockquote
> that spans multiple lines
> in the source.

> First paragraph of a blockquote.
>
> Second paragraph of the same blockquote.

> Blockquote with **bold**, _italic_, and `code`.

> > Nested blockquote inside a blockquote.

> Blockquote with a list:
>
> - Item one
> - Item two

---

## Code Blocks

Inline: use `print("hello")` to print.

Fenced with language:

```python
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)
```

```javascript
function greet(name) {
    console.log(`Hello, ${name}!`);
}
```

Fenced without language:

```
Just plain text in a code block.
No syntax highlighting.
```

Indented code block:

    this is an indented
    code block with
    four spaces

---

## Tables

### Simple Table

| Name | Age | City |
|------|-----|------|
| Alice | 30 | London |
| Bob | 25 | Paris |

### Table with Alignment

| Left | Center | Right |
|:-----|:------:|------:|
| L1 | C1 | R1 |
| L2 | C2 | R2 |
| L3 | C3 | R3 |

### Table with Formatting

| Feature | Syntax | Output |
|---------|--------|--------|
| Bold | `**text**` | **text** |
| Italic | `_text_` | _text_ |
| Code | `` `code` `` | `code` |
| Link | `[t](url)` | [t](https://example.com) |

### Single Column Table

| Values |
|--------|
| One |
| Two |
| Three |

### Wide Table

| Col1 | Col2 | Col3 | Col4 | Col5 | Col6 |
|------|------|------|------|------|------|
| a | b | c | d | e | f |

---

## Horizontal Rules

Content above the first rule.

---

Content between rules.

***

Content after the last rule.

---

## Math

### Inline Math

The quadratic formula is $x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$.

Euler's identity: $e^{i\pi} + 1 = 0$.

A simple sum: $\sum_{i=1}^{n} i = \frac{n(n+1)}{2}$.

### Display Math

$$
\int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
$$

$$
\mathbf{F} = m\mathbf{a}
$$

### Fractions and Roots

$\frac{a}{b}$, $\frac{1}{\sqrt{2}}$, $\sqrt[3]{x}$

### Greek Letters

$\alpha, \beta, \gamma, \delta, \epsilon, \theta, \lambda, \mu, \pi, \sigma, \omega$

$\Gamma, \Delta, \Theta, \Lambda, \Pi, \Sigma, \Omega$

### Matrices

$$
\begin{bmatrix}
a & b \\
c & d
\end{bmatrix}
$$

$$
\begin{pmatrix}
1 & 0 \\
0 & 1
\end{pmatrix}
$$

### Aligned Equations

$$
\begin{aligned}
f(x) &= x^2 + 2x + 1 \\
      &= (x + 1)^2
\end{aligned}
$$

### Cases

$$
f(x) = \begin{cases}
x^2 & \text{if } x \geq 0 \\
-x & \text{otherwise}
\end{cases}
$$

### Operators and Relations

$\leq, \geq, \neq, \approx, \equiv, \sim, \propto$

$\in, \notin, \subset, \subseteq, \cup, \cap$

$\forall, \exists, \nabla, \partial, \infty$

### Accents and Decorations

$\hat{x}, \bar{y}, \vec{v}, \dot{x}, \ddot{x}, \tilde{n}$

### Big Operators

$$
\prod_{i=1}^{n} x_i \qquad \sum_{k=0}^{\infty} a_k \qquad \int_a^b f(x)\,dx
$$

### Subscripts and Superscripts

$x_1, x_{12}, x^2, x^{2n}, x_i^2, a_{i,j}^{k+1}$

### Text in Math

$x = 0 \text{ when } y > 1$

### Blackboard Bold

$\mathbb{R}, \mathbb{N}, \mathbb{Z}, \mathbb{Q}, \mathbb{C}$

---

## HTML Elements

Some inline HTML: <b>bold via HTML</b> and <em>emphasis via HTML</em>.

A block of HTML:

<div class="note">
  <p>This is an HTML block.</p>
</div>

---

## Special Characters

Ampersands & angles < > and quotes "double" 'single'.

Backslash: \ and tilde: ~ and caret: ^

Dollar sign: $100 and hash: #hashtag and at: @mention

---

## Consecutive Formatting

**bold1** **bold2** _italic1_ _italic2_ `code1` `code2`

---

## Paragraph and Soft Breaks

This is the first paragraph. It has multiple sentences. They should flow together.

This is the second paragraph, separated by a blank line.

This line has a soft break
that should become a space.

A paragraph with **bold**, _italic_, `code`, and [a link](https://example.com) all mixed together in one flowing block of text.
