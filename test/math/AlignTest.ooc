use ooc-math
use ooc-unit
import math

version(debugTests) {
	res1 := Int align(720, 64)
	println(res1 toString())

	for (i in 0 .. 66)
		println(Int align(i, 1) toString())
}

"AlignTest [TODO: Not implemented as a fixture!]" printfln()
