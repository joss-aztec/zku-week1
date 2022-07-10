const fs = require("fs");
const solidityRegex = /pragma solidity \^\d+\.\d+\.\d+/

const verifierRegex = /contract Verifier/

let content = fs.readFileSync("./contracts/HelloWorldVerifier.sol", { encoding: 'utf-8' });
let bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0');
bumped = bumped.replace(verifierRegex, 'contract HelloWorldVerifier');

fs.writeFileSync("./contracts/HelloWorldVerifier.sol", bumped);

// [assignment] add your own scripts below to modify the other verifier contracts you will build during the assignment

// I guess refactoring was overkill in this case, but I may find myself reusing this again later.
function bump({ circuit, asPlonk = false }) {
  const filename = asPlonk
    ? `${circuit}Verifier_plonk.sol`
    : `${circuit}Verifier.sol`;
  const path = `./contracts/${filename}`;
  if (!fs.existsSync(path)) {
    console.log(`Skipping ${path}`);
    return;
  }
  let content = fs.readFileSync(path, { encoding: "utf-8" });
  content = content.replace(solidityRegex, "pragma solidity ^0.8.0");
  if (asPlonk) {
    content = content.replace(
      "contract PlonkVerifier",
      `contract ${circuit}PlonkVerifier`
    );
  } else {
    content = content.replace(verifierRegex, `contract ${circuit}Verifier`);
  }
  fs.writeFileSync(path, content);
}

bump({ circuit: "Multiplier3" });
bump({ circuit: "Multiplier3", asPlonk: true });
