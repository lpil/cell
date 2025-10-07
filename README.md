# Cell

Mutable references that can be concurrently accessed, based on ETS tables.

[![Package Version](https://img.shields.io/hexpm/v/cell)](https://hex.pm/packages/cell)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/cell/)

There are some other packages similar to this one, but this one is distinct in
that it uses an ETS table instead of a process to hold this data, giving it
superior performance, making it more reliable, and providing monitoring
benefits.

This package provides mutation in Gleam, an immutable language. This does not
mean it is suitable for implementing mutation based algorithms, as one would
use in a mutable language such as C, Python, or Java. Instead this package is
suitable for creating values that many processes can access concurrently, that
is sometimes updated, such as some cached or precomputed value.

```sh
gleam add cell@1
```
```gleam
import cell.{type Cell}

pub fn main() -> Nil {
  let table = cell.new_table()
  let cell: Cell(Int) = cell.new(table)

  // Cells start empty
  assert cell.read(cell) == Error(Nil)

  // They can be written to
  assert cell.write(cell, 1000) == Ok(Nil)
  assert cell.read(cell) == Ok(1000)

  // They can be written to again, to replace the inner value
  assert cell.write(cell, 5) == Ok(Nil)
  assert cell.read(cell) == Ok(5)

  // They can have their value deleted
  //
  // Cells are not garbage collected, so you must always delete their contents
  // when you are finished with them.
  assert cell.delete(cell) == Ok(Nil)
  assert cell.read(cell) == Error(Nil)


  // Other cells can be made with differing types
  let cell2: Cell(String) = cell.new(table)
  assert cell.write(cell2, "Hello!") == Ok(Nil)
  assert cell.read(cell2) == Ok("Hello!")

  // The whole table of cells can be dropped
  cell.drop(table)
  assert cell.read(cell) == Error(Nil)
  assert cell.read(cell2) == Error(Nil)
}
```

Further documentation can be found at <https://hexdocs.pm/cell>.
