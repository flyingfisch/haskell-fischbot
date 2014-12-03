haskell-fischbot
================

Fischbot ported to Haskell

Running fischbot
----------------

You should be able to run fischbot by running the following commands in terminal:

~~~
$ git clone https://github.com/flyingfisch/haskell-fischbot
$ cd haskell-fischbot
$ ./fischbot
~~~

Compiling fischbot
------------------

If you want to compile from the source you can do so by running the
following in the directory you cloned fischbot

~~~
$ ghc --make fischbot
~~~

You can also use `runhaskell`

~~~
$ runhaskell fischbot.hs
~~~

Or with `hugs`

~~~
$ runhugs -98 fischbot.hs
~~~
