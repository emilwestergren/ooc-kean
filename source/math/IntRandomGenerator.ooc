//
// Copyright (c) 2011-2014 Simon Mika <simon@mika.se>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

use ooc-math
import math
import os/Time

IntUniformRandomGenerator: class {
	_state, _min, _max, _range: Int
	_shortRange: Bool
	minimum ::= this _min
	maximum ::= this _max
	init: func (seed := Time microtime()) {
		this setRange(0, Int maximumValue)
		this _state = seed
	}
	init: func ~withParameters (min, max: Int, seed := Time microtime()) {
		this setRange(min, max)
		this _state = seed
	}
	_generate: func -> Int {
		// Based on Intel fast_rand()
		// https://software.intel.com/en-us/articles/fast-random-number-generator-on-the-intel-pentiumr-4-processor/
		this _state = 214013 * this _state + 2531011
		(this _state >> 16) & Short maximumValue
	}
	setRange: func (=_min, =_max) {
		this _range = this _max - this _min + 1
		this _shortRange = (this _range < Short maximumValue)
	}
	next: func -> Int {
		result : Int
		first := this _generate()
		if (this _shortRange)
			result = first
		else {
			second := this _generate()
			third := this _generate()
			result = (first as Int << 16) | (second as Int << 1) | (third & 1)
		}
		this _min + (result % this _range)
	}
	next: func ~withCount (count: Int) -> Int[] {
		result := Int[count] new()
		for (i in 0 .. count)
			result[i] = this next()
		result
	}
}

IntGaussianRandomGenerator: class {
	_backend: FloatGaussianRandomGenerator
	init: func {
		this _backend = FloatGaussianRandomGenerator new(0.0f, 1.0f)
	}
	init: func ~withSeed (seed: Int) {
		this _backend = FloatGaussianRandomGenerator new(0.0f, 1.0f, seed)
	}
	init: func ~withParameters (mu, sigma: Float, seed := Time microtime()) {
		this _backend = FloatGaussianRandomGenerator new(mu, sigma, seed)
	}
	init: func ~withUniformBackend (=_backend)
	init: func ~withUniformBackendAndParameters (mu, sigma: Float, backend: FloatUniformRandomGenerator) {
		this _backend = FloatGaussianRandomGenerator new~withBackendAndParameters(mu, sigma, backend)
	}
	free: override func {
		this _backend free()
		super()
	}
	setRange: func (mu, sigma: Float) {
		this _backend setRange(mu, sigma)
	}
	next: func -> Int {
		this _backend next() as Int
	}
	next: func ~withCount (count: Int) -> Int[] {
		result := Int[count] new()
		for (i in 0 .. count)
			result[i] = this next()
		result
	}
}
