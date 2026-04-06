uniform vec3 uColourA;
uniform vec3 uColourB;

varying float vEork;

void main()
{
  float colourMix = smoothstep(-1.0, 1.0, vEork);
  csm_DiffuseColor.rgb = mix(uColourA, uColourB, colourMix);

  // Mirror Step
  // csm_Metalness = step(0.25, vEork);
  // csm_Roughness = 1.0 - csm_Metalness;

  csm_Roughness = 1.0 - colourMix;
}