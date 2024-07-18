package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

const name = "go-sqlite3-crossbuild-example"

const version = "0.0.2"

var revision = "HEAD"

func fatalIf(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func main() {
	db, err := sql.Open("sqlite3", ":memory:")
	fatalIf(err)
	defer db.Close()

	_, err = db.Exec("create table foo(id integer primary key, text text not null)")
	fatalIf(err)

	_, err = db.Exec("insert into foo(id, text) values(1, 'Hello')")
	fatalIf(err)

	var text string
	err = db.QueryRow("select text from foo where id = 1").Scan(&text)
	fatalIf(err)

	fmt.Println(text)
}
