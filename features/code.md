# Code Blocks

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
