haskell-fischbot
================

[python-fischbot](//github.com/flyingfisch/python-fischbot) ported to Haskell.

Important files
---------------

* `./config/admins.txt`: Contains idents of all users with access to
  fischbot's restricted commands. To add or remove administrators from
  this list use the `!add-admin <ident>` and `!remove-admin <ident>`
  commands in the IRC channel.

Running fischbot
----------------

If you are running Ubuntu (possibly other distros work as well, not tested), you should be able to run fischbot by running the following commands in terminal:

~~~
$ git clone https://github.com/flyingfisch/haskell-fischbot
$ cd haskell-fischbot
$ ./fischbot
~~~

Join `#fischbot` on `irc.afternet.org` and you should see the bot
running happily. Try running `./fischbot --help` for information on
getting it to join other networks and channels.


Compiling fischbot from source
------------------------------

### System Requirements

If you want to compile from source you will need [Haskell platform](https://www.haskell.org/platform/).

### Compiling

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
