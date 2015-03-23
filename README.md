# L-language Toy Example
Calculator like language with heavy inspiration from Lisp
built ontop of java for practice

##Technologies
* [vim](http://www.vim.org/)
* [antlr4](http://www.antlr.org/)


##Discussion:

1.

The major inspiration is lisp for the syntax which also draws heavily on Lambda Calculus. The Overall design was to take use a symbols table to keep track of variable names. The default number type is a double for precision and ease of use. It is mostly a math language as it supports *, /, +, -, sin, cos, sqrt. There is some error handling in case you type the wrong things like more than 1 argument for sin/cos.

2.

The language extension I chose is a commonplace one that arguably makes computers so amazing. The Incredable **IF** statement. 
```
if <expr> <op> <expr> then <expr> else <expr>
```

|argument|description|
|---|---|
|expr|Any expression that evaluates to a number|
|op|Evaluation operator (!=, ==, >, <)|

The first 2 expressions are evaluated according to the operator used and if the result is true then the 3rd expression's result is returned, otherwise, the 4rth expression's result is returned. Very handy when making programs that need to make decisions.

3.

The grammar has been extended by adding the rules shown above on the main stat non-terminal symbol. The program uses the underlying Java implementation of ==, !=, >, < to accomodate the switches. In this case more terminals had to be added to allow for the keywords required for new functionality.  In a way it is just an adapter built ontop of java.

4.

L can be extended much further into a functional language by adding more keywords. The higher the level of abstraction the more "functional" it will become. We can keep distilling new programming patterns to see what people like and build off those features. I can see how this humble compiler can become pretty sweet once we start to add more features. An example could be doing map or foreach like is other languages to iterate over an array. By adding keywords we can take away alot of boilerplate code.

##License
Copyright (c) <2015> <Jose Miguel Mendez>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
