uniform vec3 uColourA;
uniform vec3 uColourB;
uniform vec3 uColourC;
uniform float uGlowStrength;

varying float vEork;

void main()
{
  float m = smoothstep(-1.0, 1.0, vEork);
  vec3 base = mix(uColourA, uColourB, m);
  vec3 finalColour = mix(base, uColourC, m * m);

  float glow = pow(m, 3.0);
  finalColour = mix(finalColour, vec3(1.0), glow * uGlowStrength * 0.5);

  csm_DiffuseColor.rgb = finalColour;
}
