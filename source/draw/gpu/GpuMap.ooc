//
// Copyright (c) 2011-2014 Simon Mika <simon@mika.se>
//
// This _program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This _program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this _program. If not, see <http://www.gnu.org/licenses/>.
use ooc-math

GpuMapType: enum {
	defaultmap
	transform
	pack
	blendMap
}

GpuMap: abstract class {
	use: virtual func
	reference: FloatTransform2D { get set }
	projection: FloatTransform2D { get set }
	init: func {
		this reference = FloatTransform2D identity
		this projection = FloatTransform2D identity
	}
}
