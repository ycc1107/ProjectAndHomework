-- This program is for programming language course assignment 3
-- Cheng Yan

--import Control.Monad
import Data.Char
import System.Exit

cal :: Integer -> Integer
cal n
		| n == 0 = 1
		| n == 1  = 1
		| n == 2  = 1
		| n == 3  = 1
		| otherwise  = ((cal (n-1) + cal (n-2)) * cal(n-3)) `div` cal(n-4)

sumCal :: Integer -> Integer
sumCal n 
		| n == 0 =  cal(n)
		| otherwise = cal(n) + sumCal(n-1)
		
boundLower :: Integer -> Integer -> Integer
boundLower n m
		| n == cal(m) = cal(m)
		| n < cal(m) = cal(m-1)
		| n > cal(m) = boundLower n plusOne
		where plusOne = m + 1
		
boundUpper :: Integer -> Integer -> Integer
boundUpper n m
		| n == cal(m) = cal(m)
		| n < cal(m) = cal(m)
		| n > cal(m) = boundUpper n plusOne
		where plusOne = m + 1
		
bound n = do
		print( boundLower n 1)
		print( boundUpper n 1)
		
isInteger :: [Char] -> Bool
isInteger [] = error"ERR"
isInteger [x] = isDigit x
isInteger (x:xs) 
		| isDigit x == True = isInteger xs
		| otherwise = False
		
compareCmd :: [Char] -> Int
compareCmd cmd 
		| cmd == "NTH" = 0
		| cmd == "SUM" = 1
		| cmd == "BOUNDS" = 2
		| otherwise = 3
		
getCmdLenght :: [Char] -> Int -> Int
getCmdLenght [] counter = 0
getCmdLenght [x] counter = 0
getCmdLenght (x:xs) counter
		| x == ' ' = counter
		| otherwise = getCmdLenght xs (counter+1)
		
errorMsg = do
		putStrLn "ERR"
		exitFailure

runCmd n value 
		| n == 0 = print(cal value)
		| n == 1 = print(sumCal value)
		| n == 2 = bound value
 
getCmd cmd = do
	let len = getCmdLenght cmd 0
	let code = compareCmd (take len cmd)
	let tempValue = drop (len+1) cmd
	if isInteger tempValue  && code < 3 then do
		let value = read tempValue :: Integer
		runCmd code value
	else 
		errorMsg
		
main = do
	cmd <- getLine
	if cmd /= "QUIT" then do 
		getCmd cmd
		main
	else
		return()
		
	

		
