package main

import (
	"fmt"
)

func main() {
	var a int
	//fmt.Println(i, &i,*i)
	// 输出： nil i的地址 *i报错
	i := &a
	fmt.Println(i, &i, *i)
	*i = 10
	fmt.Println(i, &i, *i)
	// 输出： i存储的变量的地址 i的地址 i存储的变量的值10

}
