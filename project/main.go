package main

import "fmt"

func main() {
	slice1 := []int{1, 2, 3}
	change1(slice1)

	fmt.Println("传递切片", slice1)

	slice2 := []int{1, 2, 3}
	change(&slice2)

	fmt.Println("传递切片指针", slice2)
}

func change(aa *[]int) {
	*aa = append(*aa, []int{1, 3, 4, 6, 5}...)
}

func change1(aa []int) {
	aa = append(aa, []int{1, 3, 4, 6, 5}...)
}
