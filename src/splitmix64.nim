## https://github.com/svaarala/duktape/blob/master/misc/splitmix64.c
## 
## Originally written in 2015 by Sebastiano Vigna (vigna@acm.org)
## 
## To the extent possible under law, the author has dedicated all copyright
## and related and neighboring rights to this software to the public domain
## worldwide. This software is distributed without any warranty.
## 
## See <http://creativecommons.org/publicdomain/zero/1.0/>.

type
   Splitmix64* = object
      x*: uint64 ## Mixer state. Seed with any value.

func next*(self: var Splitmix64): uint64 =
   self.x += 0x9E3779B97F4A7C15'u64
   var z: uint64 = self.x
   z = (z xor (z shr 30)) * 0xBF58476D1CE4E5B9'u64
   z = (z xor (z shr 27)) * 0x94D049BB133111EB'u64
   return z xor (z shr 31)

func nextf*(self: var Splitmix64): float =
   const SignMask = 0x7FFFFFFFFFFFFFFF'u64

   # generate 64 bits of random then strip to ensure number is positive
   var a = cast[int64](self.next and SignMask).int
   var b = int64.high.int

   return a / b

when is_main_module:
   var s = Splitmix64(x: 1)
   for i in 1..100:
      let x = s.nextf
      echo x
      assert x >= 0.0
      assert x <= 1.0

