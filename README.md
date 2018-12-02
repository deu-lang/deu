<p align="center">
<img src="docs/deu-total-deepsaffron-transparent.png" height="180px" alt="Deu Logo" title="Deu Logo">
</p>

**Deu** is a powerful, general purpose, interpreted programming language made in <a href="http://dlang.org/">D</a>.  
It is easy to learn, providing a bunch of features, such as <a href="https://en.wikipedia.org/wiki/Type_system#Static_and_dynamic_type_checking_in_practice">dynamic and static typing</a> or <a href="https://en.wikipedia.org/wiki/Object-oriented_programming">object-oriented programming</a>.
Deu's syntax is inspired by <a href="https://en.wikipedia.org/wiki/JavaScript">JavaScript</a>, <a href="https://en.wikipedia.org/wiki/Python_(programming_language)">Python</a>, <a href="https://en.wikipedia.org/wiki/D_(programming_language)">D</a> and real-world experiences.

## __Getting Started__
The interpreter is not complete yet.

## __Examples__
```python
print "Hello World!"; # output = string: "Hello World!"
```

```javascript
import std.io;

function main() {
   let name = io.input("> ");
   io.println("hi " ++ name ++ "!");
}
```

```d
class Math {
   function sum(ref real: n1, ref real: n2) {
      return <n1 + n2>;
   }

   function rest(ref real: n1, ref real: n2) {
      return sum(n1, -n2);
   }
}
```

```javascript
import std.io;
import std.algorithm;

function main() {

   let elementsCount = 5;
   let elements = [];

   for(i; 0, elementsCount) {
      elements.push(
         io.input("element " ++ i ++ ": ")
      );
   }

   elements = elements.sort();

   io.println(elements)
}

```

See <a href="https://github.com/deu-lang/deu/tree/master/samples">samples</a> to see more examples.

## __License__
Deu is available under the <a href="https://github.com/deu-lang/deu/blob/master/LICENSE">BSL-1.0 license</a>.
