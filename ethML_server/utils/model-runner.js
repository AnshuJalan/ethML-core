const { PythonShell } = require("python-shell");
const ipfs = require("nano-ipfs-store").at("https://ipfs.infura.io:5001");

//For local testing
const data = {
  1: "cancer.py",
  2: "diabetes.py",
};

async function getPrediction(modelId, dataPoint) {
  const dataPointArgs = JSON.parse(await ipfs.cat(dataPoint));
  const prediction = await new Promise((resolve, reject) => {
    PythonShell.run(
      `./ethML_server/models/${data[modelId]}`,
      { args: dataPointArgs },
      function (err, result) {
        if (err) reject(err);
        resolve(result[0]);
      }
    );
  });

  return prediction;
}

module.exports = { getPrediction };
