<p align="center">
<img src="docs/deu-total-deepsaffron-transparent.png" height="180px" alt="Deu Logo" title="Deu Logo">
</p>

**Deu** is a powerful, general purpose, interpreted programming language made in <a href="http://dlang.org/">D</a>.  
It is easy to learn, providing a bunch of features, such as <a href="https://en.wikipedia.org/wiki/Type_system#Static_and_dynamic_type_checking_in_practice">dynamic and static typing</a> or <a href="https://en.wikipedia.org/wiki/Object-oriented_programming">object-oriented programming</a>.
Deu's syntax is inspired by <a href="https://en.wikipedia.org/wiki/JavaScript">JavaScript</a>, <a href="https://en.wikipedia.org/wiki/Python_(programming_language)">Python</a>, <a href="https://en.wikipedia.org/wiki/D_(programming_language)">D</a> and real-world experiences.

## __Examples__
```c
printf("Hello World!"); /* output "Hello World!" */
```

```go
func main() {
   var name = io.input("> ");
   println("hi " ++ name ++ "!");
}
```

```go
func sum(n1: ref real, n2: ref real) {
    return <n1 + n2>;
}

/* n1 and n2 are references to real numbers real */

func rest(ref real: n1 & n2) {
    return sum(n1, -n2);
}
```

```go
import <std.io>;
import <std.algo>;

func main() {

   var elementsCount = 5;
   var elements: int[];

   for(i; 0, elementsCount) {
      elements.push(
         io.input("element " ++ i ++ ": ")!int
      );
   }

   elements = elements.sort();

   printf("%s\n", elements!string);
}
```

See <a href="https://github.com/deu-lang/deu/tree/master/samples">samples</a> to see more examples.

## __License__
Deu is available under the <a href="https://github.com/deu-lang/deu/blob/master/LICENSE">BSL-1.0 license</a>