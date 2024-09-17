#!/usr/bin/env python

from __future__ import division, print_function

def test(conv_fun):
	print(conv_fun)
	#print(conv_fun(255, 255, 255))
	#print(conv_fun(0, 215, 0))
	#print(conv_fun(255, 0, 0))
	#print(conv_fun(0, 255, 0))
	#print(conv_fun(0, 255, 255))
	print(conv_fun(0, 255, 200))
	print(conv_fun(0, 200, 255))
	print(conv_fun(0, 255, 127))
	#print(conv_fun(0, 0, 255))
	print()

def rgb_to_hsv(r, g, b):
	r, g, b = r/255.0, g/255.0, b/255.0
	mx = max(r, g, b)
	mn = min(r, g, b)
	df = mx-mn
	if mx == mn:
		h = 0
	elif mx == r:
		h = (60 * ((g-b)/df) + 360) % 360
	elif mx == g:
		h = (60 * ((b-r)/df) + 120) % 360
	elif mx == b:
		h = (60 * ((r-g)/df) + 240) % 360
	if mx == 0:
		s = 0
	else:
		s = (df/mx)*100
	v = mx*100
	return h, s, v

test(rgb_to_hsv)

def RGB_2_HSV(R, G, B):
	# Compute the H value by finding the maximum of the RGB values
	RGB_Max = max(R, G, B)
	RGB_Min = min(R, G, B)

	# Compute the value
	V = RGB_Max;
	if V == 0:
		H = S = 0
		return (H,S,V)


	# Compute the saturation value
	S = 255 * (RGB_Max - RGB_Min) // V

	if S == 0:
		H = 0
		return (H, S, V)

	# Compute the Hue
	if RGB_Max == R:
		H = 0 + 43*(G - B)//(RGB_Max - RGB_Min)
	elif RGB_Max == G:
		H = 85 + 43*(B - R)//(RGB_Max - RGB_Min)
	else: # RGB_MAX == B
		H = 171 + 43*(R - G)//(RGB_Max - RGB_Min)

	return (H, S, V)

test(RGB_2_HSV)


def int_inverse(
	one_shift,
	den # 8b
):
	num = 1 << one_shift # 16b

	assert(0 < den and den < 256)

	num2 = num # 24b
	den2 = den << 16 # 24b

	res = 0 # 16b
	for i in range(17):
		res <<= 1
		if num2 >= den2:
			res += 1
			num2 -= den2
		den2 >>= 1

	assert(num//den == res)
	assert(res <= 1<<one_shift)
	return res

# Test.
for i in range(1, 255):
	int_inverse(14, i)


def int_div(
	num, # 24b
	den # 8b
):
	assert(0 < den and den < 256)

	#print("num", num)
	#print("den", den)
	if num >= 0:
		num2 = num # 24b
	else:
		num2 = -num # 24b

	den2 = den << 16 # 24b
	#den2 = den

	res = 0 # 16b
	for i in range(17):
		#print("i", i)
		#print("res", res)
		#print("num2", num2)
		#print("den2", den2)
		res <<= 1
		if num2 >= den2:
			res += 1
			num2 -= den2
		den2 >>= 1

	if num < 0:
		res = -res
	#print("res", res)
	#print("num//den", num//den)
	assert(num//den - res <= 1)
	#assert(num//den == res)
	return res

for n in range(-255, 255):
	for d in range(1, 255):
		int_div(n<<8, d)


def RGB_2_H_simple(R, G, B):
	# Compute the H value by finding the maximum of the RGB values
	RGB_Max = max(R, G, B)
	RGB_Min = min(R, G, B)

	# Compute the value
	V = RGB_Max;
	# All 0.
	if V == 0:
		return 0


	DF = RGB_Max - RGB_Min

	# Saturation 0.
	if 255*DF < V:
		return 0


	# Compute the Hue
	if RGB_Max == R:
		D = G - B
	elif RGB_Max == G:
		D = B - R
	else: # RGB_MAX == B
		D = R - G
	
	#M = 43*D // DF
	O = 43 << 8
	OD = O * D


	num = OD
	den = DF

	if num >= 0:
		num2 = num # 24b
	else:
		num2 = -num # 24b

	den2 = den << 16 # 24b

	res = 0 # 16b
	for i in range(17):
		res <<= 1
		if num2 >= den2:
			res += 1
			num2 -= den2
		den2 >>= 1

	if num < 0:
		res = -res

	res = DIV


	M = DIV >> 8

	# Compute the Hue
	if RGB_Max == R:
		H = 0 + M
	elif RGB_Max == G:
		H = 85 + M
	else: # RGB_MAX == B
		H = 171 + M

	return H


# OVO napravi u rgb_to_h.vhd fajlu
def RGB_2_H(R, G, B):
	# Compute the H value by finding the maximum of the RGB values
	RGB_Max = max(R, G, B)
	RGB_Min = min(R, G, B)

	# Compute the value
	V = RGB_Max;


	DF = RGB_Max - RGB_Min


	# Compute the Hue
	if RGB_Max == R:
		D = G - B
	elif RGB_Max == G:
		D = B - R
	else: # RGB_MAX == B
		D = R - G
	
	#M = 43*D // DF
	O = 43 << 8
	OD = O * D
	DIV = int_div(OD, DF)
	M = DIV >> 8

	# Compute the Hue
	if RGB_Max == R:
		H = 0 + M
	elif RGB_Max == G:
		H = 85 + M
	else: # RGB_MAX == B
		H = 171 + M

	# All 0.
	if V == 0:
		return 0
	# Saturation 0.
	elif 255*DF < V:
		return 0
	else:
		return H


test(RGB_2_H)

for r in range(256):
	print(r)
	for g in range(256):
		for b in range(256):
			exp_h, _, _ = RGB_2_HSV(r, g, b)
			obs_h = RGB_2_H(r, g, b)
			if exp_h != obs_h:
				print(r, g, b, obs_h, exp_h)
				assert(False)







