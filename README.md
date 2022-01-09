## General Plan
We want a way to store shader code on-chain as an NFT. Aside from being cool, shader code can be pretty small (~300 chars), meaning it can be stored for signifacntly cheaper than trying to store a GIF on chain. To complete the NFT, we need a way to view what the on-chain shader generates. There's already some sites to vew GLSL shaders (Shadertoy, Twigl, GLSLsandbox).

OpenSea has good support for HTML5 animations using the `animation_url` inside of our URI. We need this URL to point to [slim twig](https://github.com/mybropro/slim-twigl), with support for passing in the shader code as a URL parameter.

### Data to store in contract
+ shader code - [enforce a char limit](#shader-code-character-limit)
+ encoded shader code (this is what goes into the URL of our shader viewer. Wish we could do this in Solidity, but it seems difficult. Might need to do this if gas is to expensive)
+ shader mode (classic, geek, geekest, or variants of those)
+ title (depending on what we want to use for titles)

### URI required
+ `title` - [TODO: maybe just "Shader #001"]
+ `image` - Generated SVG
+ `description` - shader code
+ `attribute.shader_mode` - either values (classic, geek, etc) or mode number (0, 1, 2, ..)
+ `attribute.length` - `len(description)`. Maybe smaller shaders will be more valuable?
+ `animmation_url` - can be generated at runtime by combining the viewer url, with the shader code + mode

## Generating Image
We can make the image (used for thumbnails), at runtime using SVG. I think this should look like black background + white coder text, maybe with the text spaced and broken up in a certain way.

## animation_url
We want this url to stay up and work indefinitely. Storing the shader code on chain is pretty worthless if we are dependent upon a single server to provide the frontend for seeing what the code generates. Way to fix this is IPFS web hosting [multi-page website on IPFS](https://docs.ipfs.io/how-to/websites-on-ipfs/multipage-website/#prerequisites). We'll use [slim twigl](https://github.com/mybropro/slim-twigl) as a viewer for this, just need a copy of it on IPFS.

## Shader code character limit
Currently, a 256 char limit is enforced on shader code when minting a ShaderNFT. The current thumbnail image SVG is designed with this limit in mind. If this limit ever increases (maybe to 512 chars), the SVG generation needs to be updated.
Gas costs need to be evaluated to decide if storing 256 char shaders vs 512 chars is worth it.

