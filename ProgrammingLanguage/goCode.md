1.	The	grammar	for	the	type	language	is	as	follows:<br>
TYPE ::= TYPEVAR | PRIMITIVE_TYPE | FUNCTYPE | LISTTYPE;<br>
PRIMITIVE_TYPE ::= ‘int’ | ‘float’ | ‘long’ | ‘string’;<br>
TYPEVAR ::= ‘`’ VARNAME; // Note, the character is a backwards apostrophe!<br>
VARNAME ::= [a-zA-Z][a-zA-Z0-9]*; // Initial letter, then can have numbers<br>
FUNCTYPE ::= ‘(‘ ARGLIST ‘)’ -> TYPE | ‘(‘ ‘)’ -> TYPE;<br>
ARGLIST ::= TYPE ‘,’ ARGLIST | TYPE;<br>
LISTTYPE ::= ‘[‘ TYPE ‘]’;<br>
2.	A	single	input	consists	of	a	pair	of	types	on	a	single	line,	separated	by	an	ampersand:
UNIFICATION_QUERY ::= TYPE ‘&’ TYPE NEWLINE;
NEWLINE ::= ‘\n’;
3.	White	space	(tabs	and	spaces)	cannot	occur	in	the	middle	of	a	TYPEVAR or	PRIMITIVE_TYPE,	but can	be	
added	anywhere	else.		This	is	true	for	both	input	and	output.
4.	When	a	UNIFICAITON_QUERY	does	not	match	the	above	grammar,	your	program	shall	output	only	
“ERR”	followed	by	a	newline,	and	then	exit.
5.	Valid	input	to	your	program	follows	this	grammar:
VALID_INPUT ::= QUERY_LIST ‘QUIT’ ‘\n’;QUERY_LIST ::= UNIFICATION_QUERY QUERY_LIST | ;
6.	After	you	read	in	each	unification	query,	you	must	output	the	correct	result,	which	should	either	be:
a)	The	most	general	unifier,	if	it	exists.		It	should	follow	the	type	grammar	above.
b)	If	no	most	general	unifier	exists,	output:	“BOTTOM”	(all	caps)	on	a	line	by	itself,	and	then	exit.
7.	When	the	program	input	consists	of	a	“QUIT”	command	instead	of	a	UNIFICATION_QUERY,	your	
program	should	exit	without	reading	further	input or	producing	further	output.
8.	When	your	program	outputs	either	“ERR”	or	“BOTTOM”,	you	must	not	read	any	additional	input,	or	
produce	any	additional	output.
9.	All	input	is	case	sensitive.		For	instance,	`a	and	`A	represent different	type	variables.
10.	If	unification	would	create	a	recursive	type,	you	must	output	“BOTTOM”.
11.	Different	primitive	types	cannot	unify	with	each	other.
12.	When	you	unify	two	type	variables,	it	does	not	matter	which	name	you	use	as	the	proper	name.		For	
instance,	if	you’re	asked	to	unify	`a	and	`b,	either	`a	or	`b	are	acceptable	as	an	output.
