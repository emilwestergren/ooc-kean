/* This file is part of magic-sdk, an sdk for the open source programming language magic.
 *
 * Copyright (C) 2016 magic-lang
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

use draw-gpu
use collections
use draw
use geometry
use base
use concurrent
import OpenGLContext, GraphicBuffer, GraphicBufferYuv420Semiplanar, EGLYuv, OpenGLPacked, OpenGLMap, OpenGLPromise

version(!gpuOff) {
YuvExtensionContext: class extends OpenGLContext {
	_yuvShader := OpenGLMapTransform new(slurp("shaders/yuv.frag"), this)
	yuvShader ::= this _yuvShader
	_unpackY := OpenGLMap new(slurp("shaders/unpackYuv.vert"), slurp("shaders/unpackYuvToMonochrome.frag"), this)
	_unpackUv := OpenGLMap new(slurp("shaders/unpackYuv.vert"), slurp("shaders/unpackYuvToUv.frag"), this)
	_pack := OpenGLMap new(slurp("shaders/unpackYuv.vert"), slurp("shaders/packCompositeYuvToYuv.frag"), this)
	_outputBuffers := SynchronizedQueue<EGLYuv> new()
	outputBuffers ::= this _outputBuffers
	defaultMap ::= this _yuvShader
	init: func (other: This = null) { super(other) }
	free: override func {
		this _backend makeCurrent()
		(this _yuvShader, this _unpackY, this _unpackUv, this _pack) free()
		super()
	}
	createImage: override func (rasterImage: RasterImage) -> GpuImage {
		match (rasterImage) {
			case (graphicBufferImage: GraphicBufferYuv420Semiplanar) => graphicBufferImage toYuv(this)
			case => super(rasterImage)
		}
	}
	getYuv: func (size: IntVector2D) -> EGLYuv {
		result := this _outputBuffers dequeue(null)
		if (result == null)
			Debug print("Warning: No available output buffers in YuvExtensionContext!")
		result
	}
	toRaster: override func ~target (source: GpuImage, target: RasterImage) -> Promise {
		result := OpenGLPromise new(this)
		result sync()
		result
	}
	// createImage: override func (rasterImage: RasterImage) -> GpuImage {
	// 	match(rasterImage) {
	// 		case (graphicBufferImage: GraphicBufferYuv420Semiplanar) =>
	// 			yuv := graphicBufferImage toYuv(this)
	// 			result := this createYuv420Semiplanar(rasterImage size)
	// 			this _unpack(yuv, result)
	// 			yuv referenceCount decrease()
	// 			result
	// 		case => super(rasterImage)
	// 	}
	// }
	// toRaster: override func ~target (source: GpuImage, target: RasterImage) -> Promise {
	// 	result: Promise
	// 	if (target instanceOf(GraphicBufferYuv420Semiplanar) && source instanceOf(GpuYuv420Semiplanar)) {
	// 		sourceImage := source as GpuYuv420Semiplanar
	// 		targetImage := target as GraphicBufferYuv420Semiplanar
	// 		targetYuv := targetImage toYuv(this)
	// 		this _pack add("y", sourceImage y)
	// 		this _pack add("uv", sourceImage uv)
	// 		DrawState new(targetYuv) setMap(this _pack) draw()
	// 		result = OpenGLPromise new(this)
	// 		(result as OpenGLPromise) sync()
	// 		targetYuv referenceCount decrease()
	// 	} else
	// 		result = super(source, target)
	// 	result
	// }
	_unpack: func (input: EGLYuv, target: GpuYuv420Semiplanar) {
		this _unpackY add("texture0", input)
		DrawState new(target y) setMap(this _unpackY) draw()
		this _unpackUv add("texture0", input)
		DrawState new(target uv) setMap(this _unpackUv) draw()
	}
}
}
