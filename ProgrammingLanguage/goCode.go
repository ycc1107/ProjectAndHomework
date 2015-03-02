package main

import (
	"fmt"
	"strings"
	"os"
	"bufio"
)
/////////////////////////////////////////////////////////////////////
// global var 
/////////////////////////////////////////////////////////////////////
var gEnvironment = ""
var gTypeName = []string{}
var gVarLst = []string{}
var gMapVarToType = make(map[string]string)
var gMapVarToVar = make(map[string]string)

/////////////////////////////////////////////////////////////////////
// parsing 
/////////////////////////////////////////////////////////////////////
func unifyQuery() string{
	result := ""
	firstEnviroment := strings.Split(strings.Split(gEnvironment,"&")[0],",")
	secondEnviroment := strings.Split(strings.Split(gEnvironment,"&")[1],",")

	
	if (firstEnviroment[0] =="List" && (secondEnviroment[0] == "pVar" ||secondEnviroment[0] == "pVar")) || (secondEnviroment[0] =="List" && (firstEnviroment[0] == "pVar" ||firstEnviroment[0] == "pVar")) {
		bottomHandle()
	}else if (firstEnviroment[0]=="Var" && secondEnviroment[0] == "pVar") || (secondEnviroment[0]=="Var" && firstEnviroment[0] == "pVar"){
		result = checkVarAndPrimitvie(firstEnviroment[0],secondEnviroment[0])
	}else if firstEnviroment[0] == "|Func" && secondEnviroment[0] == "|Func"{
		result = checkFuncAndFunc(firstEnviroment,secondEnviroment)
	}else if firstEnviroment[0] =="List" && secondEnviroment[0] == "List"{
		result = checkListAndList(firstEnviroment,secondEnviroment)
	}else{
		bottomHandle()
	}

	return result
}

/////////////////////////////////////////////////////////////////////
// check  
/////////////////////////////////////////////////////////////////////
func checkListAndList(firstEnviroment []string ,secondEnviroment []string)string{
	result:=""
	temp:=""
	if len(firstEnviroment) != len(secondEnviroment) {bottomHandle()}
	for index,element := range firstEnviroment{
		if element == "pVar" {
			if secondEnviroment[index] == "Var"{
				if v,k := gMapVarToType[gTypeName[1]]; k{
					if v != gTypeName[0] { bottomHandle() }
				}else{
					gMapVarToType[gTypeName[1]] = gTypeName[0]
					temp = gTypeName[0]
				}
			}
		}
		if element == "Var" {
			if secondEnviroment[index] == "pVar"{
				if v,k := gMapVarToType[gTypeName[0]]; k{
					if v != gTypeName[1] { bottomHandle() }
				}else{
					gMapVarToType[gTypeName[0]] = gTypeName[1]
					temp = gTypeName[1]
				}
			}
		}
	}
	counter := 0
	for _,element := range firstEnviroment{
		if element =="List"{
			counter += 1
		} 
	}
	result = strings.Repeat("[",counter)+temp+strings.Repeat("]",counter)

	return result
}

func checkFuncAndFunc(firstEnviroment []string ,secondEnviroment []string) string{
	result := ""
	flag := len(firstEnviroment) >= len(secondEnviroment) 
	var checkIndex  int
	for index,item :=range gTypeName{
			if item =="|"{
				checkIndex = index
				break
			}
	}

	first := gTypeName[:checkIndex]
	second := gTypeName[checkIndex+1:]



	counter := 0
	insideCounter := 0
	for _,firstItem := range firstEnviroment{
	// fmt.Println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")	
	// fmt.Println("first evn: ")
	// fmt.Println(firstEnviroment)
	// fmt.Println("second evn: ")
	// fmt.Println(secondEnviroment)
	// fmt.Println("map var to type : ")
	// fmt.Println(gMapVarToType)
	// fmt.Println("map var to var :")
	// fmt.Println(gMapVarToVar)
	// fmt.Println("gTypeName frist:")
	// fmt.Println(first)
	// fmt.Println("gTypeName second:")
	// fmt.Println(second)
		//check pVar != pVar at same position
		if firstItem =="pVar" || firstItem == "Var"{
			insideCounter = 0
			for _,secondItem := range secondEnviroment{
				if secondItem =="pVar" || secondItem =="Var"{
					//fmt.Println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" +firstItem+"    "+secondItem)
					if insideCounter == counter{
						switch {
						case firstItem == "pVar" && secondItem =="pVar":
							if first[counter] != second[counter]{
									bottomHandle()
							}
							break
						case firstItem == "pVar" && secondItem =="Var":
							if v,k := gMapVarToType[second[counter]] ; k{
								if v != first[counter]{ bottomHandle() }
							}else{
								gMapVarToType[second[counter]] = first[counter]
							}
							break
						case firstItem == "Var" && secondItem =="pVar":
							fmt.Println(gMapVarToType)
							fmt.Println(first[counter] +" " +second[counter])
							if v,k := gMapVarToType[first[counter]] ; k{
								if v != second[counter]{ bottomHandle() }
							}else{
								gMapVarToType[first[counter]] = second[counter]
							}
							break
						case firstItem == "Var" && secondItem =="Var":
							if flag{
								if _,k := gMapVarToVar[first[counter]]; !k{
									gMapVarToVar[first[counter]] = second[counter]
								}
							}else{
								if _,k := gMapVarToVar[second[counter]]; !k{
										gMapVarToVar[second[counter]] = first[counter]
								}
							}
							break
						}
						insideCounter += 1
					}
				}
			}
			counter += 1		
		}
	}

	if flag{
		result = reconstructQuery(firstEnviroment,first)
	}else{
		result = reconstructQuery(secondEnviroment,second)
	}

	return result
}

func checkVarAndPrimitvie(first string,second string) string{
	var checkStr, typeStr string
	var checkIndex int
	
	for index,item :=range gTypeName{
			if item =="|"{
				checkIndex = index + 1
				break
			}
	}

	if first == "Var"{
		checkStr = gTypeName[0]
		typeStr = gTypeName[checkIndex]
	}else{
		checkStr = gTypeName[checkIndex]
		typeStr = gTypeName[0]
	}

	result := typeStr
	if v,k := gMapVarToType[checkStr]; k {
		if v != typeStr{ bottomHandle() }
	}
	gMapVarToType[checkStr] = typeStr
	
	return result
}

func reconstructQuery(enviroment []string,varLst []string)string{
	temp := ""
	result := ""
	varCounter := 0
	lstBrecketCounter := 0
	//fmt.Println(enviroment)
	for _,element := range enviroment{
		temp,lstBrecketCounter,varCounter = selectFunc(element,lstBrecketCounter,varCounter,varLst)
		if len(result) > 0 && result[len(result)-1] == ',' && (temp[0] == ']' || temp[0] == ')') { result = result[:len(result)-1]}
		result += temp
		temp = ""
	}
	if result[len(result)-1] == ',' { result = result[:len(result)-1]}
	return result
}

func selectFunc(element string, lstBrecketCounter int,varCounter int ,varLst []string) (string,int,int){
	result := ""
	switch{
		case element =="|Func":
		
			result += strings.Repeat("]",lstBrecketCounter)
			lstBrecketCounter = 0
			result += "("
			break
		case element =="pVar" ||  element =="Var":
			result += strings.Repeat("]",lstBrecketCounter)
			lstBrecketCounter = 0
			if v,k := gMapVarToType[varLst[varCounter]];k{
				result += v 
			}else{
				if vS,kS := gMapVarToVar[varLst[varCounter]];kS{
					if vT,kT := gMapVarToType[vS];kT{
						result += vT 
					}
					result += vS
				}else{
					result += varLst[varCounter] 
				}
			}
			result += ","
			varCounter += 1
			break
		case element =="List":
		
			result += strings.Repeat("]",lstBrecketCounter)
			lstBrecketCounter = 0
			result += "["
			lstBrecketCounter += 1
			break
		}
	if element[0] =='\\' {
		temp :=""
		result += ")->"
		temp,lstBrecketCounter,varCounter = selectFunc(element[1:],lstBrecketCounter,varCounter,varLst)
		result += temp

	}

	return result,lstBrecketCounter,varCounter

}
/////////////////////////////////////////////////////////////////////
// parsing 
/////////////////////////////////////////////////////////////////////
func parseSwitch(str string){
	switch {
		case str[0] == '[':
			validListType(str)
			gEnvironment += "List,"
			parseListType(str)
			break
		case str[0] == 'i'|| str[0] == 'f' || str[0]== 'l' || str[0] == 's':
			gEnvironment += "pVar,"
			parsePrimitiveType(str)
			break
		case str[0] == '`':
			gEnvironment += "Var,"
			parseTypeVar(str)
			break
		case str[0] == '(':
			validFuncType(str)
			gEnvironment += "|Func,"
			parseFuncType(str)
			break
		default:
			errorHandle()
			break
	}
}

func parseListType(str string) {
	parseSwitch(str[1:len(str)-1])
}

func parsePrimitiveType(str string){
	switch  {
		case str == "int" :  
			break
		case str == "float" : 
			break
		case str == "long" : 
			break
		case str == "string" :  
			break
		default: errorHandle()
	}
	gTypeName = append(gTypeName,str)
}

func isLetter(ch rune) bool { 
        return 'a' <= ch && ch <= 'z' || 'A' <= ch && ch <= 'Z'
} 

func isNumber(ch rune) bool{
	return '0' <= ch && ch <= '9'	
}

func parseTypeVar(str string) {
	str = str[1:]
	for index, element := range str{
		if index == 0 && !isLetter(element) {
			errorHandle()
		}
		if index != 0 {
			if !isLetter(element) && !isNumber(element){
				errorHandle()
			}
		}
	}
	gTypeName = append(gTypeName,str)
	gVarLst = append(gVarLst,str)
}

func parseFuncType(str string){
	var input,output string
	var splitIndex int
	for i:= len(str)-1;i>=0;i--{
		
		if str[i] == '>' && str[i-1] == '-'{
			splitIndex = i
			break
		}
	}
	
	input = str[1:splitIndex-2]
	output = str[splitIndex+1:]

	if len(input) > 0 {
		for _,item := range strings.Split(input,","){
			parseSwitch(item)
		}
	}
	gEnvironment += "\\"
	parseSwitch(output)
	
}

/////////////////////////////////////////////////////////////////////
// validation 
/////////////////////////////////////////////////////////////////////

func validListType(str string){
	stack := ""
	for _,element := range str{
		if element == '[' { stack += string(element) }
		if element == ']' && len(stack) >= 1{ 
			left := stack[len(stack) - 1]
			if left != '[' { errorHandle() }
			stack = stack[:len(stack) - 1]
		}
	}
	
}

func validFuncType(str string){
	stack := ""
	for _,element := range str{
		if element == '(' { stack += string(element) }
		if element == ')' && len(stack) >= 1{
			left := stack[len(stack) - 1]
			if left !=  '(' { errorHandle() }
			stack = stack[:len(stack) - 1]
		}
	}

	tempStrLst :=  strings.Split(str,"->")
	if len(tempStrLst) <=1 { errorHandle() }
}

/////////////////////////////////////////////////////////////////////
// exit handle
/////////////////////////////////////////////////////////////////////
func errorHandle(){
	fmt.Println("ERR ")
	os.Exit(0)
}

func bottomHandle(){
	fmt.Println("BOTTOM")
	os.Exit(0)
}
/////////////////////////////////////////////////////////////////////
// clean input
/////////////////////////////////////////////////////////////////////
func inputClean(str string) string{
	gEnvironment = ""
	gTypeName = []string{}
	gVarLst = []string{}
	result := strings.TrimRight(str,"\n")
	result = strings.TrimSpace(str)
	return result
}
/////////////////////////////////////////////////////////////////////
// entry point
/////////////////////////////////////////////////////////////////////
func run(){
	reader := bufio.NewReader(os.Stdin)
	text,_:= reader.ReadString('\n')
	text = inputClean(text)
	for text != "QUIT"{ 
		splitText := strings.Split(text,"&")
		if len(splitText) != 2 { errorHandle() }
		for index,query := range splitText{
			parseSwitch(query)
			if index == 0 {gEnvironment = gEnvironment[:len(gEnvironment)-1]}
			gEnvironment += "&"
			gTypeName = append(gTypeName,"|")
			gVarLst = append(gVarLst,"|")
		}
		gEnvironment = gEnvironment[:len(gEnvironment)-2]
		gTypeName = gTypeName[:len(gTypeName)-1]

		output:=unifyQuery()
		fmt.Println(output)

		text,_ = reader.ReadString('\n')
		text = inputClean(text)
	}
}

func main(){
	run()
}
