haskell_Assignment
==================
1. program	must	read	from	standard	input,	and	output	to	standard	output.
2. Input	will	consist	on	queries	that	operate	on	a	sequence	of	numbers.
3. The	sequence	shall	be	defined	as	follows:
  * a. F(0)	=	1
  * b. F(1)	=	1
  * c. F(2)	=	1
  * d. F(3)	=	1
  * e. F(n)	=	⎣(F(n-1)+F(n-2))*F(n-3)/F(n-4)⎦
The	first	ten	numbers	of	this	sequence	(starting	at	n=0 and	ending	with	n=9)	
are:
1,	1,	1,	1,	2,	3,	5,	16,	31,	78
4. The user	will	enter	a	query	on	a	line	by	itself,	and	your	program	will	produce	
output	based	on	the	query,	on	a line	by	itself.		The	queries	will	be	a	one-word	
command (CASE	SENSITIVE),	which,	depending	on	the	command,	may	be	
followed	by	a	single	argument.
5. The	commands	are:
  * a. NTH – Print the	nth	integer in	the	sequence,	starting	with	the	0th
element.
  * b. SUM	– Print	the	sum	of	all	n	integers	in	the	sequence,	starting	from		
the	0th element.
  * c. BOUNDS	– Given	a	number	as	an	input	(positive	numbers	accepted	
only—accept	only	decimal,	and	do	not	accept	+,	etc),	print,	on	two	
separate	lines,	the	two	non-inclusive	bounding	numbers	of	the	
sequence.		For	instance,	if	the	input	is	12,	you	print	5	and	16.	
  * d. QUIT	– your	program	should	exit	immediately	without	outputting.		
With	this	command,	it	is	NOT	valid	to	use	any spaces.
