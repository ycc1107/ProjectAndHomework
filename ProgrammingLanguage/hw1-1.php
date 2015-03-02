/*
TASK 1:
We're going to write a program which implements a very simple (almost useless) cypher algorithm.  The algorithm works by adding the number 13 to every letter and (with wrapping so that 'Z'+1='A') will result in a new letter.  Numbers are increased by 5 with wrapping so they remain just one digit. Other characters are left untouched.

Your code must meet the following restrictions

1) Your program must use filenames that are given on the command line in the form of "php myprog.php 1 input.txt output.txt" (1 is the task number for this assignment).  Your program MUST NOT crash if only one file name (or no file names) are given or if the input file doesn't exist.  Likewise you should detect any error and generate a "nice" notice for the user.

2) The output will be the encoding of the input file.  For our purposes the algorithm is defined as follows:
	A) If the input is a lower case letter, the output is the lower case letter plus 13 (with wrap-around, so 'n' becomes 'a')
	B) If the input is a upper case letter, the output is the upper case letter plus 13 (with wrap-around, so 'n' becomes 'a')
	C) If the input is a number the output is the number plus 5 (with wrap-around so '6' becomes '1')
	D) If the input is neither letter nor number, the output is the same as the input ('!' becomes '!' and ' ' becomes ' ')

3) If I execute the following (assumes 1.txt is a valid text file):
	"php myprog.php 1 1.txt 2.txt"
	"php myprog.php 1 2.txt 3.txt"
   Then 1.txt and 3.txt will have the exact same information

4) For this task, you may not use the str_rot13 function (that would be a little to easy).  You may define your own functions, but you do not have to.
*/

<?php
// version : 1.0
// author : Cheng Yan
// uid : n15639404
?>
<?php
function isTxtFile($fileName){
	$fileNameArray =  explode('.', $fileName);
	if(count($fileNameArray) == 2 ){
		if($fileNameArray == 'txt'){
			return True;
		}
	}
	return False;
}
function isValidFilePath($argv){
	$errorFlag = False;
	$flag = True;
	foreach($argv as $value){
		if($flag){
			$flag = False;
			continue;
		}
		else{
			if(!isTxtFile($value)){
				$errorFlag = True;
				$wrongArray[$i++] = $value;
			}
		}		
	}
	if($errorFlag){
			print "Invalid file path, please double check input argument(s). \n";
			foreach($wrongArray as $value){
				print "$value  ";
			}
			print "\n";
	}
}
function encodingLetter($letter){
	$numLetter = ord($letter);
	if( $numLetter >= ord('a') && $numLetter <= ord('z')){
		$base = ord('z');
		$start = ord('a');
	}
	else{
		$base = ord('Z');
		$start = ord('A');
	}
	$encodingOrd = $numLetter + 13;
	if($encodingOrd/$base > 1){
		$result = chr( $encodingOrd%$base + $start - 1);
	}
	else{
		$result = chr($encodingOrd);
	}
	
	//print $letter.$numLetter."-->".$result.$encodingOrd."\n";
	return $result;
}
function encodingWord($context){
	$result = array();
	foreach(str_split($context) as $value){
		if(is_numeric($value)){
			array_push($result,($value + 5)%10);
		}
		elseif (preg_match('/[a-zA-z]/',$value)){
			array_push($result,encodingLetter($value));
		}	
		else{
			array_push($result,$value);
		}
			
	}
	return implode("",$result);	
}

function checkOutputFile($argv){
	$defualtOutputNameFlag = False;
	if(empty($argv[3])){
			print "There is no output file path(name). The name of output will be defualt name (output.txt) \n";
			$defualtOutputNameFlag = True;
	}
	if($defualtOutputNameFlag){
		$result = "output.txt";
	}
	else{
		$result = $argv[3];
	}
	return $result;
}

function readTxtFile($argv){
	if(empty($argv[2])){
		print "There is no input file path(name) \n";
		exit();
	}
	else{
		
		if(!file_exists($argv[2])){
			die("File not found!\n");
		}
		else{
			$result = file($argv[2]);
		}
	}
	return $result;
}
function checkTaskNumber($argv){
	if($argv[1] != 1){
		print "Task Number is Wrong\n";
		exit();
	}
}
function run($argv){
	$result = array();
	checkTaskNumber($argv);
	$txtContain = readTxtFile($argv);
	$outputFileName  = checkOutputFile($argv);

	foreach($txtContain as $line){
		$lines = explode(" ", $line);
		foreach( $lines as $word){
			array_push($result,encodingWord($word));
			//array_push($result," ");
		}
	}
	$buffer = substr(implode(" ",$result),1,-1);
	file_put_contents($outputFileName, $buffer);
	//return trim(implode(" ",$result));
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*
	for($i = ord('A'); $i <= ord("Z") ; $i++ ){
		print chr($i)."-->".$i."\n";
	}
*/
	run($argv);
	
	
?>
