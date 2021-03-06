use ooc-base
use ooc-draw
use ooc-math
use ooc-unit
import lang/IO

RasterBgraTest: class extends Fixture {
	sourceSpace := "test/draw/input/Space.png"
	sourceFlower := "test/draw/input/Flower.png"
	init: func {
		super("RasterBgraTest")
		this add("equals 1", func {
			image1 := RasterBgra open(this sourceFlower)
			image2 := RasterBgra open(this sourceSpace)
			expect(image1 equals(image1))
			expect(image1 equals(image2), is false)
			image1 free(); image2 free()
		})
		this add("equals 2", func {
			output := "test/draw/output/RasterBgra_test.png"
			image1 := RasterBgra open(this sourceFlower)
			image1 save(output)
			image2 := RasterBgra open(output)
			expect(image1 equals(image2))
			image1 free(); image2 free()
		})
		this add("distance, same image", func {
			image1 := RasterBgra open(this sourceSpace)
			image2 := RasterBgra open(this sourceSpace)
			expect(image1 distance(image1), is equal to(0.0f))
			expect(image1 distance(image2), is equal to(0.0f))
			image1 free(); image2 free()
		})
		this add("distance, convertFrom self", func {
			image1 := RasterBgra open(this sourceFlower)
			image2 := RasterBgra convertFrom(image1)
			expect(image1 distance(image2), is equal to(0.0f))
			expect(image1 equals(image2))
			image1 free(); image2 free()
		})
		this add("BGRA to Monochrome", func {
			image1 := RasterBgra open(this sourceSpace)
			image2 := RasterMonochrome convertFrom(image1)
			image3 := RasterMonochrome open("test/draw/input/correct/Bgra-Monochrome-Space.png")
			expect(image2 distance(image3), is equal to(0.0f))
			image1 free(); image2 free(); image3 free()
		})
	}
}

RasterBgraTest new() run()
