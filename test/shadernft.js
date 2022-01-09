const ShaderNFT = artifacts.require("ShaderNFT");
const truffleAssert = require("truffle-assertions");

contract("ShaderNFT", async (accounts) => {
  it("owner gets set correctly", async () => {
    const instance = await ShaderNFT.deployed();
    const owner = await instance.owner();
    assert.equal(owner, accounts[0], "Owner is set incorrectly");
  });

  it("minting and gettingURI work", async () => {
    let code =
      "vec2 p=(FC.xy*2.-r)/min(r.x,r.y);for(int i=0;i<8;++i){p.xy=abs(p)/abs(dot(p,p))-vec2(.9+cos(t*.2)*.4);}o=vec4(p.xxy,1);";
    let mode = 7;
    let encoded_code =
      "vec2%20p%3D(FC.xy*2.-r)/min(r.x,r.y)%3Bfor(int%20i%3D0%3Bi<8%3B%2B%2Bi){p.xy%3Dabs(p)/abs(dot(p,p))-vec2(.9%2Bcos(t*.2)*.4)%3B}o%3Dvec4(p.xxy,1)%3B";

    const instance = await ShaderNFT.deployed();
    await instance.mintNFT(accounts[0], code, encoded_code, mode);
    const uri = await instance.tokenURI(0x0);
    const content = JSON.parse(uri.substring(uri.indexOf("{")));
    console.log(content);
    assert.equal(
      content["description"],
      code,
      "URI Doesn't include expected substring"
    );
    assert.equal(
      content["name"],
      "0",
      "URI Doesn't include expected substring"
    );
  });

  it("failing to mint when shader code is longer than 256 chars", async () => {
    let code =
      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    let mode = 7;
    let encoded_code =
      "vec2%20p%3D(FC.xy*2.-r)/min(r.x,r.y)%3Bfor(int%20i%3D0%3Bi<8%3B%2B%2Bi){p.xy%3Dabs(p)/abs(dot(p,p))-vec2(.9%2Bcos(t*.2)*.4)%3B}o%3Dvec4(p.xxy,1)%3B";

    const instance = await ShaderNFT.deployed();
    await truffleAssert.reverts(
      instance.mintNFT(accounts[0], code, encoded_code, mode),
      "VM Exception while processing transaction: revert Shader code is larger than 256 characters -- Reason given: Shader code is larger than 256 characters."
    );
  });
});
