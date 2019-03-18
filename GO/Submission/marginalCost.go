package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
	"sync"
)

type Pair struct {
	xCoord int
	yCoord int
}

type Path struct {
	items []Pair
}

type Cell struct {
	xCoord int
	yCoord int
}

//*****************************************************
// Public Variables
//*****************************************************
var wgRout sync.WaitGroup
var wgCost sync.WaitGroup
var dataInitial [][]string
var dataRaw [][]string
var lowestCost int
var lowestPath Path
var sem = make(chan int, 1)

//*****************************************************
// main
// Get user input for the file name and run the stepping
// stone algorithm to find the better solution
//*****************************************************

func main() {
	reader := bufio.NewReader(os.Stdin)
	fmt.Print("\nEnter the inputdata filename: ")
	inputStr, _ := reader.ReadString('\n')
	fmt.Println(inputStr)
	dataRaw = readFile(inputStr[:len(inputStr)-1])

	fmt.Print("\nEnter the intialdata filename: ")
	inputStr2, _ := reader.ReadString('\n')
	fmt.Println(inputStr2)

	dataInitial = readFile(inputStr2[:len(inputStr2)-1])

	path := make(chan Path, 10)

	//* The for loop finds empty cell and run stepping stone concurrently *//
	xlength := len(dataInitial[0]) - 1
	ylength := len(dataInitial) - 1
	findCost(path)

	for j := 1; j < ylength; j++ {
		for i := 1; i < xlength; i++ {
			if dataInitial[j][i] == "-" {
				fmt.Println("Found empty cell at (", i, ",", j, ")")
				cell := Cell{i, j}
				go marginalCost(cell, path)
				wgRout.Add(1)
				wgCost.Add(1)
			}
		}
	}

	wgRout.Wait()
	wgCost.Wait()
	generateSolution(lowestPath)
}

//*****************************************************
// marginalcost
// This function only find the closed loop for each empty cell
// and pass the result to the channel
//*****************************************************
func marginalCost(cell Cell, result chan Path) {
	xlength := len(dataInitial[0]) - 1
	ylength := len(dataInitial) - 1

	//* Algorithm begins *//
	xIndex := cell.xCoord
	yIndex := cell.yCoord
	xCurrentIndex := cell.xCoord
	yCurrentIndex := cell.yCoord
	whileFlag := true

	xFlag := true
	var stack Path

	// start //
	if dataInitial[yIndex][xIndex] == "-" { //if loop reach at empty cell
		fmt.Println("Finding close loop at empty cell (", xIndex, ",", yIndex, ")")
		stack.Push(Pair{xIndex, yIndex})
		xCurrentIndex = xIndex
		yCurrentIndex = yIndex

		for whileFlag {

			if xFlag {

				counter := xlength
				for i := (xCurrentIndex % xlength) + 1; ; i++ {

					if counter == 0 { // If finish one loop, then pop the stack
						fmt.Println("Popping at X")
						popStack := stack.Pop()
						popStack = stack.Pop()
						xCurrentIndex = popStack.xCoord
						yCurrentIndex = popStack.yCoord
						break
					}
					if i == xlength { // If reach end of the loop, then reset the value i
						i = 1
					}

					if xCurrentIndex == i { // If reach the same cell, do nothing

					} else if dataInitial[yCurrentIndex][i] != "-" {
						fmt.Println("checking at (", i, ",", yCurrentIndex, ")")
						xCurrentIndex = i
						stack.Push(Pair{i, yCurrentIndex})
						xFlag = false
						break
					}
					counter -= 1
				}

			} else {

				counter := ylength
				for i := (yCurrentIndex % ylength) + 1; ; i++ {

					if xCurrentIndex == xIndex { // if loop found the original empty cell
						whileFlag = false
						break
					}

					if counter == 0 { // If finish one loop, then pop the stack
						fmt.Println("Popping at Y")
						popStack := stack.Pop()
						xCurrentIndex = popStack.xCoord
						yCurrentIndex = popStack.yCoord
						xFlag = true
						break
					}

					if i == ylength { // If reach end of the loop, then reset the value i
						i = 1
					}

					if yCurrentIndex == i { // If reach the same cell, do nothing

					} else if dataInitial[i][xCurrentIndex] != "-" {
						fmt.Println("checking at (", xCurrentIndex, ",", i, ")")
						yCurrentIndex = i
						stack.Push(Pair{xCurrentIndex, i})
						xFlag = true
						break
					}
					counter -= 1
				}
			}
		}
		fmt.Println("Closed loop for empty cell (", cell.xCoord, ",", cell.yCoord, ") : ", stack)

		// Done find close loop //
		whileFlag = true
	}
	result <- stack
	wgRout.Done()
}

//*****************************************************
// findCost
// This function will calculate the new cost for each closed
// loop it receive from the channel
//*****************************************************
func findCost(path chan Path) {
	go func() {
		for task := range path {
			sem <- 1
			positiveFlag := false
			cost := 0
			fmt.Println("New incoming data : ", task)
			backup := task
			for i := 0; i < len(backup.items); i++ {
				pair := task.Pop()
				if positiveFlag {
					value, _ := strconv.Atoi(dataRaw[pair.yCoord][pair.xCoord])
					cost += value
					positiveFlag = false
				} else {
					value, _ := strconv.Atoi(dataRaw[pair.yCoord][pair.xCoord])
					cost -= value
					positiveFlag = true
				}
			}

			if cost < lowestCost {
				lowestCost = cost
				lowestPath = backup
			}

			fmt.Println("Cost is : ", cost)
			<-sem
			wgCost.Done()
		}
	}()
}

//*****************************************************
// generateSolution
// This function will modify the initial.txt file and
// produce a solution.txt file
//******************************************************

func generateSolution(path Path) {
	fmt.Println("\n ----- Generating Solution -----")
	fmt.Println(path)
	lowestValue := 10000
	dummy := path
	for i := 0; i < len(path.items)-1; i++ {
		pair := dummy.Pop()
		value, _ := strconv.Atoi(dataInitial[pair.yCoord][pair.xCoord])

		if value < lowestValue {
			lowestValue = value
		}
	}

	dummy = path
	positiveFlag := false

	fmt.Println(lowestValue)
	for i := 0; i < len(path.items); i++ {
		pair := dummy.Pop()
		fmt.Println(pair)
		if positiveFlag {
			value, _ := strconv.Atoi(dataInitial[pair.yCoord][pair.xCoord])
			dataInitial[pair.yCoord][pair.xCoord] = strconv.Itoa(value + lowestValue)
			positiveFlag = false
		} else {
			value, _ := strconv.Atoi(dataInitial[pair.yCoord][pair.xCoord])
			dataInitial[pair.yCoord][pair.xCoord] = strconv.Itoa(value - lowestValue)
			positiveFlag = true
		}

	}

	fmt.Println("Result is ....")
	fmt.Println(dataRaw)

	fmt.Println("\n\nSolution.txt file created!")

	//* Writing array to file *//
	f, err := os.Create("solution.txt")
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Fprintln(f, "Solution created by Haziq Hafizi (8346453)")
	fmt.Fprintln(f, "Result for Stepping Stone Algorithm :")
	for i := 0; i < len(dataInitial); i++ {
		for j := 0; j < len(dataInitial[0]); j++ {
			fmt.Fprint(f, dataInitial[i][j])
			fmt.Fprint(f, " ")
		}
		fmt.Fprintln(f, "")
	}

}

//*****************************************************
// readFile
// This function will read file based on the argument
// in the function
//******************************************************

func readFile(fileName string) [][]string {
	home := os.Getenv("HOME")
	err := os.Chdir(home + "/desktop/CSI ASSIGNMENT/GO") // TODO : CHANGE THIS TO LOCATION OF TXT FILES
	if err != nil {
		panic(err)
	}

	b, err := ioutil.ReadFile(fileName)
	if err != nil {
		fmt.Print(err)
	}
	lengthy := strings.Split(string(b), "\n")
	lengthy2 := strings.Fields(lengthy[0])

	var arrData = make([][]string, len(lengthy))
	for i := range arrData {
		arrData[i] = make([]string, len(lengthy2))
	}

	real, err := ioutil.ReadFile(fileName)
	if err != nil {
		fmt.Print(err)
	}
	lines := strings.Split(string(real), "\n")

	for index, elem := range lines {
		dummy := strings.Fields(elem)
		for i := 0; i < len(dummy); i++ {
			arrData[index][i] = dummy[i]
		}
	}

	return arrData
}

//*****************************************************
// New() Push() Pop()
//
// Interfaces for stack
// Implement Pop and Push method for the stack
//******************************************************

func (s *Path) New() *Path {
	s.items = []Pair{}
	return s
}

func (s *Path) Push(t Pair) {
	s.items = append(s.items, t)
}

func (s *Path) Pop() *Pair {
	item := s.items[len(s.items)-1]
	s.items = s.items[0 : len(s.items)-1]
	return &item
}
