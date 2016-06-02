/* This file is part of magic-sdk, an sdk for the open source programming language magic.
 *
 * Copyright (C) 2016 magic-lang
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

use geometry
use draw
use base
use concurrent
import GraphicBuffer, OpenGLContext, OpenGLPacked, YuvExtensionContext
import backend/[GLTexture, GLContext, EGLImage]

version(!gpuOff) {
EGLYuv: class extends OpenGLPacked {
	_buffer: GraphicBuffer
	buffer ::= this _buffer
	init: func ~fromGraphicBuffer (=_buffer, context: OpenGLContext) {
		texture := This _bin search(|texture| texture _handle == this buffer _handle)
		if (texture == null) {
			texture = EGLImage create(TextureType External, this _buffer size, this _buffer nativeBuffer, context backend)
			texture _handle = this _buffer _handle
		}
		super(texture, 3, context)
	}
	free: override func {
		This _bin add(this _backend as EGLImage)
		this _recyclable = false
		this _buffer free()
		this _ownsBackend = false
		super()
	}
	create: override func (size: IntVector2D) -> This { this _context as YuvExtensionContext getYuv(size) }
	toRasterDefault: override func -> RasterImage { Debug error("toRasterDefault unimplemented for EGLYuv"); null }
	toRasterDefault: override func ~target (target: RasterImage) { Debug error("toRasterDefault~target unimplemented for EGLYuv"); null }

	_bin := static RecycleBin<EGLImage> new(100, |image| image free())
}
}
