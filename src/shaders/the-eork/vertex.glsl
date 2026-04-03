uniform float uTime;
uniform float uPositionFrequency;
uniform float uTimeFrequency;
uniform float uStrength;

attribute vec4 tangent;

#include ../includes/simplexNoise4d.glsl

float getEork(vec3 position)
{
  return simplexNoise4d(vec4(
    position * uPositionFrequency,
    uTime * uTimeFrequency
  )) * uStrength;
} 

void main()
{
  vec3 biTangent = cross(normal, tangent.xyz);
  float shift = 0.01;
  vec3 positionA = csm_Position + tangent.xyz * shift;
  vec3 positionB = csm_Position + biTangent * shift;

  float eork = getEork(csm_Position);
  csm_Position += eork * normal;
  positionA += getEork(positionA) * normal;
  positionB += getEork(positionB) * normal;

  vec3 toA = normalize(positionA - csm_Position);
  vec3 toB = normalize(positionB - csm_Position);
  csm_Normal = cross(toA, toB);
}