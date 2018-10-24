

def reverseString(s):
		"""
		Reverse a string recursively

		:param s: A string
		:type s: str
		:rtype: str
		"""
		length = len(s)
		result = list(s)
		for i in range(int(length / 2)):
			result[length - 1] = s[length - 1]
			result[i] =  s[i]
			print(i,  s[length - 1], s[i], result)

			length -= 1
		return ''.join(result)

a = reverseString('hola')
print(a)