/*
* Copyright (C) 2014 - Simon Mika <simon@mika.se>
*
* This sofware is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* This software is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with this software. If not, see <http://www.gnu.org/licenses/>.
*/

use ooc-math
use ooc-base
use ooc-collections
use ooc-draw
use ooc-draw-gpu

import OpenGLES3/Fbo, OpenGLES3/Quad, OpenGLES3/Texture, OpenGLES3Bgr, OpenGLES3Yuv420Semiplanar, OpenGLES3Yuv420Planar, Map/OpenGLES3Map, OpenGLES3Bgra, OpenGLES3Uv, OpenGLES3Monochrome, OpenGLES3Context

OpenGLES3Canvas: class extends GpuCanvas {
	_renderTarget: Fbo
	context ::= this _context as OpenGLES3Context
	init: func (image: GpuImage, context: GpuContext) {
		super(image, context)
		this reset()
	}
	free: override func {
		this _renderTarget free()
		super()
	}
	_bind: override func { this _renderTarget bind() }
	_unbind: override func { this _renderTarget unbind() }
	onRecycle: func {
		this reset()
		this _renderTarget invalidate()
	}
	draw: func ~packed (image: GpuPacked) {
		map := this _context getMap(this _target, GpuMapType transform) as OpenGLES3MapDefault
		map model = FloatTransform3D new(image size width / 2, 0.0f, 0.0f, 0.0f, image size height / 2, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, -this focalLength)
		map view = FloatTransform3D identity
		map projection = this projection
		this draw(func {
			image bind(0)
			map use()
		})
	}
	draw: func (image: Image) {
		if (image instanceOf?(GpuPacked)) { this draw(image as GpuPacked) }
		else if (image instanceOf?(RasterPacked)) {
			temp := this context createGpuImage(image as RasterPacked)
			this draw(temp as GpuPacked)
			temp free()
		}
		else
			Debug raise("Trying to draw unsupported image format to OpenGLES3Canvas!")
	}
	clear: override func { this draw(func { this _renderTarget clear() }) }
	readPixels: override func -> ByteBuffer { this _renderTarget readPixels() }
	create: static func (image: GpuPacked, context: GpuContext) -> This {
		result := This new(image, context)
		result _renderTarget = Fbo create(image texture _backend as Texture, image size)
		result _size = image size
		result _renderTarget != null ? result : null
	}
}
OpenGLES3CanvasYuv420Planar: class extends GpuCanvas {
	target ::= this _target as GpuYuv420Planar

	init: func (image: GpuImage, context: GpuContext) { super(image, context) }
	onRecycle: func
	_draw: func (image: OpenGLES3Yuv420Planar) {
		this target y canvas draw(image y)
		this target u canvas draw(image u)
		this target v canvas draw(image v)
	}
	draw: func (image: Image) {
		if (image instanceOf?(RasterYuv420Planar)) {
			temp := this _context createGpuImage(image as RasterYuv420Planar) as OpenGLES3Yuv420Planar
			this _draw(temp)
			temp free()
		}
		else if (image instanceOf?(OpenGLES3Yuv420Planar)) {
			temp := image as OpenGLES3Yuv420Planar
			this _draw(temp)
		}
		else
			Debug raise("Trying to draw unsupported image format to OpenGLES3Yuv420Planar")
	}
	drawLines: override func (pointList: VectorList<FloatPoint2D>) { this target y canvas drawLines(pointList) }
	drawBox: override func (box: FloatBox2D) { this target y canvas drawBox(box) }
	drawPoints: override func (pointList: VectorList<FloatPoint2D>) { this target y canvas drawPoints(pointList) }
	clear: override func {
		this target y canvas clear()
		this target u canvas clear()
		this target v canvas clear()
	}
	create: static func (image: OpenGLES3Yuv420Planar, context: GpuContext) -> This { This new(image, context) }
}

OpenGLES3CanvasYuv420Semiplanar: class extends GpuCanvas {
	target ::= this _target as GpuYuv420Semiplanar

	init: func (image: GpuImage, context: GpuContext) { super(image, context) }
	onRecycle: func
	_draw: func (image: OpenGLES3Yuv420Semiplanar) {
		this target y canvas draw(image y)
		this target uv canvas draw(image uv)
	}
	draw: func (image: Image) {
		if (image instanceOf?(RasterYuv420Semiplanar)) {
			temp := this _context createGpuImage(image as RasterYuv420Semiplanar) as OpenGLES3Yuv420Semiplanar
			this _draw(temp)
			temp free()
		}
		else if (image instanceOf?(OpenGLES3Yuv420Semiplanar)) {
			this _draw(image as OpenGLES3Yuv420Semiplanar)
		}
		else
			Debug raise("Trying to draw unsupported image format to OpenGLES3Yuv420Semiplanar")
	}
	drawLines: override func (pointList: VectorList<FloatPoint2D>) { this target y canvas drawLines(pointList) }
	drawBox: override func (box: FloatBox2D) { this target y canvas drawBox(box) }
	drawPoints: override func (pointList: VectorList<FloatPoint2D>) { this target y canvas drawPoints(pointList) }
	clear: override func {
		this target y canvas clear()
		this target uv canvas clear()
	}
	create: static func (image: OpenGLES3Yuv420Semiplanar, context: GpuContext) -> This { This new(image, context) }
}
