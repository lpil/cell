/// An table of cells.
///
/// Internally this is an Erlang ETS table, so when the process that created
/// table terminates the table is dropped.
///
pub type Table

type CellReference(value)

pub opaque type Cell(value) {
  Cell(table: Table, reference: CellReference(value))
}

/// Create a new table.
///
/// The process that calls this function is the owner of the ETS table, and the
/// table will be dropped when the owner process terminates.
///
@external(erlang, "cell_ffi", "new_table")
pub fn new_table() -> Table

@external(erlang, "erlang", "make_ref")
fn new_cell_reference() -> CellReference(value)

/// Create a new cell.
///
/// If the table the cell is part of to is dropped then the cell will no longer
/// be usable.
///
pub fn new(table: Table) -> Cell(value) {
  Cell(table:, reference: new_cell_reference())
}

/// Read the current value contained by a cell.
///
/// This function will return an error if the table has been dropped, or if the
/// cell does not yet have a value.
///
pub fn read(cell: Cell(value)) -> Result(value, Nil) {
  get(cell.table, cell.reference)
}

@external(erlang, "cell_ffi", "read")
fn get(table: Table, key: CellReference(v)) -> Result(v, Nil)

/// Set the value of a cell, overwriting any previous value.
///
/// This function will return an error if the table has been dropped.
///
pub fn write(cell: Cell(value), value: value) -> Result(Nil, Nil) {
  set(cell.table, cell.reference, value)
}

@external(erlang, "cell_ffi", "write")
fn set(table: Table, key: CellReference(v), value: v) -> Result(Nil, Nil)

/// Delete the value from a cell, freeing the memory used.
///
pub fn delete(cell: Cell(value)) -> Result(Nil, Nil) {
  empty(cell.table, cell.reference)
}

@external(erlang, "cell_ffi", "empty")
fn empty(table: Table, key: CellReference(v)) -> Result(Nil, Nil)

/// Drop a table, freeing the memory it used.
///
/// Any attempt to use a table after it was dropped will result in an error.
///
@external(erlang, "cell_ffi", "drop")
pub fn drop(table: Table) -> Nil
