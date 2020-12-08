const Table = require("cli-table");

const defaultTable = new Table({
  style: { head: ["cyanBright"] },
  head: ["Request Id", "Challenge", "Difficulty"],
  colWidths: [12, 75, 15],
});

function displayTable({ id, challenge, difficulty }) {
  defaultTable.pop();
  defaultTable.push([id, challenge, difficulty]);
  console.log(defaultTable.toString());
}

module.exports = displayTable;
