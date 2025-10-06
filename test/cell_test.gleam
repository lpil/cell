import cell.{type Cell}
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn readme_test() {
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

  // when you are finished with them.
  assert cell.delete(cell) == Ok(Nil)
  assert cell.read(cell) == Error(Nil)

  // Other cells can be made with differing types
  let cell2: Cell(String) = cell.new(table)
  assert cell.write(cell2, "Hello!") == Ok(Nil)

  // The whole table of cells can be dropped
  cell.drop(table)
  assert cell.read(cell) == Error(Nil)
  assert cell.read(cell2) == Error(Nil)
}
