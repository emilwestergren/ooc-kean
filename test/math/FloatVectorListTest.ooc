//
// Copyright (c) 2011-2015 Simon Mika <simon@mika.se>
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

use ooc-unit
use ooc-math
use ooc-collections
import math
import text/StringTokenizer
import lang/IO

FloatVectorListTest: class extends Fixture {
	tolerance := 0.000001f

	init: func {
		super("FloatVectorList")
		this add("sum", func {
			list := FloatVectorList new()
			expect(list sum, is equal to(0.0f) within(tolerance))
			list add(-1.0f)
			list add(2.0f)
			list add(-3.0f)
			list add(4.0f)
			expect(list sum, is equal to(2.0f) within(tolerance))
			list free()
		})
		this add("maxValue", func {
			list := FloatVectorList new()
			list add(1.0f)
			expect(list maxValue, is equal to(1.0f) within(tolerance))
			list add(2.0f)
			expect(list maxValue, is equal to(2.0f) within(tolerance))
			list add(3.0f)
			expect(list maxValue, is equal to(3.0f) within(tolerance))
			list add(-3.0f)
			expect(list maxValue, is equal to(3.0f) within(tolerance))
			list add(4.0f)
			expect(list maxValue, is equal to(4.0f) within(tolerance))
			list free()
		})
		this add("mean", func {
			list := FloatVectorList new()
			list add(10.0f)
			list add(20.0f)
			list add(30.0f)
			list add(40.0f)
			expect(list mean, is equal to(25.0f) within(tolerance))
			list free()
		})
		this add("variance", func {
			list := FloatVectorList new()
			list add(10.0f)
			list add(20.0f)
			list add(30.0f)
			list add(40.0f)
			expect(list variance, is equal to(125.0f) within(tolerance))
			list free()
		})
		this add("standard deviation", func {
			list := FloatVectorList new()
			list add(10.0f)
			list add(20.0f)
			list add(30.0f)
			list add(40.0f)
			expect(list standardDeviation, is equal to(sqrt(125.0f) as Float) within(tolerance))
			list free()
		})
		this add("sort", func {
			list := FloatVectorList new()
			list add(-1.0f)
			list add(2.0f)
			list add(-3.0f)
			list add(4.0f)
			list sort()
			expect(list[0], is equal to(-3.0f) within(tolerance))
			expect(list[1], is equal to(-1.0f) within(tolerance))
			expect(list[2], is equal to(2.0f) within(tolerance))
			expect(list[3], is equal to(4.0f) within(tolerance))
			list free()
		})
		this add("accumulate", func {
			list := FloatVectorList new()
			list add(-1.0f)
			list add(2.0f)
			list add(-3.0f)
			list add(4.0f)
			result := list accumulate()
			expect(result[0], is equal to(-1.0f) within(tolerance))
			expect(result[1], is equal to(1.0f) within(tolerance))
			expect(result[2], is equal to(-2.0f) within(tolerance))
			expect(result[3], is equal to(2.0f) within(tolerance))
			result free()
			list free()
		})
		this add("copy", func {
			list := FloatVectorList new()
			list add(-1.0f)
			list add(2.0f)
			list add(-3.0f)
			list add(4.0f)
			copy := list copy()
			expect(list count == copy count)
			for (i in 0 .. list count)
				expect(copy[i], is equal to(list[i]) within(tolerance))
			list free()
			copy free()
		})
		this add("operator + (This)", func {
			list1 := FloatVectorList new()
			list2 := FloatVectorList new()
			list1 add(9.0f)
			list1 add(8.0f)
			list1 add(7.0f)
			list2 add(2.0f)
			list2 add(1.0f)
			result := list1 + list2
			expect(result count == list2 count)
			expect(result[0], is equal to(11.0f) within(tolerance))
			expect(result[1], is equal to(9.0f) within(tolerance))
			list1 free()
			list2 free()
			result free()
		})
		this add("add into", func {
			list1 := FloatVectorList new()
			list2 := FloatVectorList new()
			list1 add(9.0f)
			list1 add(8.0f)
			list1 add(7.0f)
			list2 add(2.0f)
			list2 add(1.0f)
			list1 addInto(list2)
			expect(list1[0], is equal to(11.0f) within(tolerance))
			expect(list1[1], is equal to(9.0f) within(tolerance))
			expect(list1[2], is equal to(7.0f) within(tolerance))
			list1 free()
			list2 free()
		})
		this add("operator - (This)", func {
			list1 := FloatVectorList new()
			list2 := FloatVectorList new()
			list1 add(9.0f)
			list1 add(8.0f)
			list1 add(7.0f)
			list2 add(2.0f)
			list2 add(1.0f)
			result := list1 - list2
			expect(result count == list2 count)
			expect(result[0], is equal to(7.0f) within(tolerance))
			expect(result[1], is equal to(7.0f) within(tolerance))
			list1 free()
			list2 free()
			result free()
		})
		this add("operator * (Float)", func {
			list := FloatVectorList new()
			list add(2.0f)
			list add(1.0f)
			list add(6.0f)
			list add(4.0f)
			list add(7.0f)
			result := list * 5.0f
			expect(result count == list count)
			expect(result[0] == 10.0f)
			expect(result[1] == 5.0f)
			expect(result[2] == 30.0f)
			expect(result[3] == 20.0f)
			expect(result[4] == 35.0f)
			list free()
			result free()
		})
		this add("operator / (Float)", func {
			list := FloatVectorList new()
			list add(20.0f)
			list add(10.0f)
			list add(60.0f)
			list add(40.0f)
			list add(70.0f)
			result := list / 10.0f
			expect(result count == list count)
			expect(result[0] == 2.0f)
			expect(result[1] == 1.0f)
			expect(result[2] == 6.0f)
			expect(result[3] == 4.0f)
			expect(result[4] == 7.0f)
			list free()
			result free()
		})
		this add("operator + (Float)", func {
			this add("operator * (Float)", func {
				list := FloatVectorList new()
				list add(2.0f)
				list add(1.0f)
				list add(6.0f)
				list add(4.0f)
				list add(7.0f)
				result := list + 5.0f
				expect(result count == list count)
				expect(result[0] == 7.0f)
				expect(result[1] == 6.0f)
				expect(result[2] == 11.0f)
				expect(result[3] == 9.0f)
				expect(result[4] == 12.0f)
				list free()
				result free()
			})
		})
		this add("operator - (Float)", func {
			this add("operator * (Float)", func {
				list := FloatVectorList new()
				list add(2.0f)
				list add(1.0f)
				list add(6.0f)
				list add(4.0f)
				list add(7.0f)
				result := list - 5.0f
				expect(result count == list count)
				expect(result[0] == -3.0f)
				expect(result[1] == -4.0f)
				expect(result[2] == 1.0f)
				expect(result[3] == -1.0f)
				expect(result[4] == 2.0f)
				list free()
				result free()
			})
		})
		this add("array index", func {
			list := FloatVectorList new()
			list add(0.0f)
			list add(-6.0f)
			expect(list[1], is equal to(-6.0f) within(tolerance))
			list[0] = 7.0f
			list[1] = -7.0f
			expect(list[0], is equal to(7.0f) within(tolerance))
			expect(list[1], is equal to(-7.0f) within(tolerance))
			list free()
		})
		this add("to string", func {
			list := FloatVectorList new()
			list add(1.0f)
			list add(2.0f)
			s := list toString()
			expect(s length() > 0)
			expect(s indexOf(1.0f toString()) >= 0)
			expect(s indexOf(2.0f toString()) >= 0)
			list free()
			s free()
		})
		this add("median", func {
			list := FloatVectorList new()
			list add(2.0f)
			expect(list median(), is equal to(2.0f) within(tolerance))
			expect(list median(), is equal to(list fastMedian()) within(tolerance))
			list add(1.0f)
			expect(list median(), is equal to(1.5f) within(tolerance))
			expect(list median(), is equal to(list fastMedian()) within(tolerance))
			list add(6.0f)
			expect(list median(), is equal to(2.0f) within(tolerance))
			expect(list median(), is equal to(list fastMedian()) within(tolerance))
			list add(4.0f)
			expect(list median(), is equal to(3.0f) within(tolerance))
			expect(list median(), is equal to(list fastMedian()) within(tolerance))
			list add(7.0f)
			expect(list median(), is equal to(4.0f) within(tolerance))
			expect(list median(), is equal to(list fastMedian()) within(tolerance))
			list free()
		})
		this add("moving median filter", func {
			list := FloatVectorList new()
			list add(2.0f)
			list add(1.0f)
			list add(6.0f)
			list add(4.0f)
			list add(7.0f)
			filtered := list movingMedianFilter(3)
			expect(filtered count == list count)
			expect(filtered[0], is equal to(1.5f) within(tolerance))
			expect(filtered[1], is equal to(2.0f) within(tolerance))
			expect(filtered[2], is equal to(4.0f) within(tolerance))
			expect(filtered[3], is equal to(6.0f) within(tolerance))
			expect(filtered[4], is equal to(5.5f) within(tolerance))
			list free()
			filtered free()
		})
	}
}
FloatVectorListTest new() run()
