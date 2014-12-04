haskell-fischbot
================

Fischbot ported to Haskell

Running fischbot
----------------

If you are running Ubuntu (possibly other distros work as well, not tested), you should be able to run fischbot by running the following commands in terminal:

~~~
$ git clone https://github.com/flyingfisch/haskell-fischbot
$ cd haskell-fischbot
$ ./fischbot
~~~

Join `#fischbot` on `irc.afternet.org` and you should see the bot
running happily. Try running `fischbot --help` for information on
getting it to join other networks and channels.


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
