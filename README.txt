## General Plan
We want a way to store shader code on-chain as an NFT. Aside from being cool, shader code can be pretty small (<300 chars), meaning it can be stored in chain. To complete the NFT, we need a way to view what the on-chain shader generates.
OpenSea has good support for HTML5 animations using the `animation_url` inside of our URI. We need this URL to point to some version of (twigl.app)[https://twigl.app], with support for passing in the shader code as a parameter. Twigl supports this natively.


### Data to store
+ shader code
+ shader mode (classic, geek, geekest, or variants of those)

### URI required
+ `title` - [TODO: maybe just "Shader #001"]
+ `image` - Generated SVG
+ `description` - shader code
+ `attribute.shader_mode` - either values (classic, geek, etc) or mode number (0, 1, 2, ..)
+ `attribute.length` - `len(description)`
+ `animmation_url` - can be generated at runtime by combining the viewer url, with the shader code + mode


## Generating Image
We can make the image (used for thumbnails), at runtime using some SVG. I think this should look like black background + white coder text, maybe with the text spaced and broken up in a certain way. TBD

##

