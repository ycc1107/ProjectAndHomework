AdaProgrammingLinkedList
Program Specification In this assignment, you will be writing a program that takes linked-list specifications
as input, and outputs information about the linked list.
Your program must read from standard input.
When the program begins, input lines represent individual linked list nodes (phase 1).
Each linked list node specification consists of three parts, separated by a
semi-colon (“;”): the name of the linked list node, the value stored with the linked list node, and the name of the next linked list node, from the given
node.
If a linked list node does not have a next node, then there will be nothing after the second semicolon.
Linked list names can be any ASCII alphanumeric value, but may not contain any other characters.
Linked list values may be any ASCII alphanumeric value at all.
Spaces are not allowed anywhere in the phase 1 input, except in the MIDDLE
of a linked list value.
A blank line during phase 1 signifies that the phase is over, and that phase 2
shall begin.
If there is any sort of input that violates the above input specification, the program should print BAD on a line by itself and exit (you can do this as soon
as you recognize bad input, and must do this before accepting input for phase
2).
In phase 2, the user will enter a query on a line by itself, and your program will produce output based on the query, on a line by itself. The queries will be a one-word command, followed by one or more spaces, followed by the name of a starting node.
The commands are: a. COUNT – Your output for this command is a single integer indicating
how many nodes are accessible from the given node. b. SUM – if all values in the linked list are integers, then your output shall
be the sum of all the values. Otherwise, your output should be the concatenation of all the values. c. UNUSED – you should output the number of nodes in the linked list
that are NOT accessible from the given start node. d. LINKS – you should output the number of nodes in the linked list that
link to the specified node. e. QUIT – your program should exit immediately without outputting.
With this command, it is NOT valid to provide a space or start node.
After you give output for your command, continue to read additional
command, until the QUIT command is issued, or until “end of file” is seen.
Commands and names are not case sensitive.
Spaces are ignored anywhere in a command, except to separate the command from the argument.
If an invalid command is given, or if the linked list is otherwise inconsistent
or wrong to the point that the operation does not make sense, you should
print ERR on a line by itself, and continue to accept input.
