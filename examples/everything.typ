= Markdown to Typst Feature Reference

This document exercises every Markdown feature supported by mdtyp.

#line(length: 100%)


== Headings


=== Third Level


==== Fourth Level


===== Fifth Level


====== Sixth Level


== Heading with *bold* and _italic_ words


== Heading with `inline code`

#line(length: 100%)


== Inline Formatting

This is *bold text* and this is _italic text_ and this is #strike[strikethrough text].

Combining: *bold and _italic_ together* and #strike[strikethrough with *bold*].

Here is `inline code` in a sentence.

#line(length: 100%)


== Links and Images

Here is a #link("https://google.com")[link to Google] and a #link("https://example.com")[link with *bold* text].

/* HTML: <!-- Images omitted: Typst requires actual image files to compile.
     Syntax: ![Photo of a sunset](sunset.jpg) → #figure(image("sunset.jpg"), caption: [...]) --> */

#line(length: 100%)


== Lists


=== Unordered List

- Item one
- Item two
- Item three


=== Ordered List

+ First item
+ Second item
+ Third item


=== Nested Unordered

- Top level
  - Second level
    - Third level
  - Back to second
- Back to top


=== Nested Ordered

+ First
  + Sub first
  + Sub second
+ Second
  + Another sub


=== Mixed Nesting

+ Ordered top
  - Unordered child
  - Another child
+ Back to ordered
  - Child again
    + Deep ordered
    + More deep


=== List Items with Formatting

- *Bold item*
- _Italic item_
- Item with `code`
- Item with #link("https://example.com")[a link]

#line(length: 100%)


== Blockquotes

#quote[
This is a simple blockquote.
]

#quote[
This is a blockquote that spans multiple lines in the source.
]

#quote[
First paragraph of a blockquote.

Second paragraph of the same blockquote.
]

#quote[
Blockquote with *bold*, _italic_, and `code`.
]

#quote[
#quote[
Nested blockquote inside a blockquote.
]
]

#quote[
Blockquote with a list:

- Item one
- Item two
]

#line(length: 100%)


== Code Blocks

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

```
this is an indented
code block with
four spaces
```

#line(length: 100%)


== Tables


=== Simple Table

#table(
  columns: 3,
  align: (auto, auto, auto,),
  table.header(
    [*Name*],
    [*Age*],
    [*City*],
  ),
  [Alice],
  [30],
  [London],
  [Bob],
  [25],
  [Paris],
)

=== Table with Alignment

#table(
  columns: 3,
  align: (left, center, right,),
  table.header(
    [*Left*],
    [*Center*],
    [*Right*],
  ),
  [L1],
  [C1],
  [R1],
  [L2],
  [C2],
  [R2],
  [L3],
  [C3],
  [R3],
)

=== Table with Formatting

#table(
  columns: 3,
  align: (auto, auto, auto,),
  table.header(
    [*Feature*],
    [*Syntax*],
    [*Output*],
  ),
  [Bold],
  [`**text**`],
  [*text*],
  [Italic],
  [`_text_`],
  [_text_],
  [Code],
  [``code``],
  [`code`],
  [Link],
  [`[t](url)`],
  [#link("https://example.com")[t]],
)

=== Single Column Table

#table(
  columns: 1,
  align: (auto,),
  table.header(
    [*Values*],
  ),
  [One],
  [Two],
  [Three],
)

=== Wide Table

#table(
  columns: 6,
  align: (auto, auto, auto, auto, auto, auto,),
  table.header(
    [*Col1*],
    [*Col2*],
    [*Col3*],
    [*Col4*],
    [*Col5*],
    [*Col6*],
  ),
  [a],
  [b],
  [c],
  [d],
  [e],
  [f],
)
#line(length: 100%)


== Horizontal Rules

Content above the first rule.

#line(length: 100%)

Content between rules.

#line(length: 100%)

Content after the last rule.

#line(length: 100%)


== Math


=== Inline Math

The quadratic formula is $x = frac(-b plus.minus sqrt(b^2 - 4"ac"), 2a)$.

Euler's identity: $e^(i pi) + 1 = 0$.

A simple sum: $sum_(i=1)^(n) i = frac(n(n+1), 2)$.


=== Display Math

$ integral_0^infinity e^(-x^2) "dx" = frac(sqrt(pi), 2) $

$ bold(F) = m bold(a) $


=== Fractions and Roots

$frac(a, b)$, $frac(1, sqrt(2))$, $root(3, x)$


=== Greek Letters

$alpha, beta, gamma, delta, epsilon, theta, lambda, mu, pi, sigma, omega$

$Gamma, Delta, Theta, Lambda, Pi, Sigma, Omega$


=== Matrices

$ mat(delim: "[", a, b; c, d) $

$ mat(delim: "(", 1, 0; 0, 1) $


=== Aligned Equations

$ f(x) = x^2 + 2x + 1 \
= (x + 1)^2 $


=== Cases

$ f(x) = cases(
 x^2 & "if " x >= 0,
 -x & "otherwise"
) $


=== Operators and Relations

$<=, >=, !=, approx, equiv, tilde.op, prop$

$in, in.not, subset, subset.eq, union, sect$

$forall, exists, nabla, diff, infinity$


=== Accents and Decorations

$hat(x), macron(y), arrow(v), dot(x), diaer(x), tilde(n)$


=== Big Operators

$ product_(i=1)^(n) x_i wide sum_(k=0)^(infinity) a_k wide integral_a^b f(x)thin "dx" $


=== Subscripts and Superscripts

$x_1, x_(12), x^2, x^(2n), x_i^2, a_(i,j)^(k+1)$


=== Text in Math

$x = 0 " when " y > 1$


=== Blackboard Bold

$RR, NN, ZZ, QQ, CC$

#line(length: 100%)


== HTML Elements

Some inline HTML: /* <b> */bold via HTML/* </b> */ and /* <em> */emphasis via HTML/* </em> */.

A block of HTML:

/* HTML: <div class="note">
  <p>This is an HTML block.</p>
</div> */

#line(length: 100%)


== Special Characters

Ampersands & angles \< \> and quotes "double" 'single'.

Backslash: \\ and tilde: \~ and caret: ^

Dollar sign: \$100 and hash: \#hashtag and at: \@mention

#line(length: 100%)


== Consecutive Formatting

*bold1* *bold2* _italic1_ _italic2_ `code1` `code2`

#line(length: 100%)


== Paragraph and Soft Breaks

This is the first paragraph. It has multiple sentences. They should flow together.

This is the second paragraph, separated by a blank line.

This line has a soft break that should become a space.

A paragraph with *bold*, _italic_, `code`, and #link("https://example.com")[a link] all mixed together in one flowing block of text.
