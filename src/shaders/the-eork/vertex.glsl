uniform float uTwistStrength;
uniform float uTime;
uniform float uPositionFrequency;
uniform float uTimeFrequency;
uniform float uStrength;
uniform float uWarpPositionFrequency;
uniform float uWarpTimeFrequency;
uniform float uWarpStrength;

attribute vec4 tangent;

varying float vEork;

#include ../includes/simplexNoise4d.glsl

float getEork(vec3 position)
{
  vec3 warpedPosition = position;
  warpedPosition += simplexNoise4d(vec4(
    position * uWarpPositionFrequency,
    uTime * uWarpTimeFrequency
  )) * uWarpStrength;

  return simplexNoise4d(vec4(
    warpedPosition * uPositionFrequency,
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

  float angle = eork * uTwistStrength * 0.5;
  mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));

  vec2 twistedMain = rot * csm_Position.xz;
  csm_Position.x = twistedMain.x;
  csm_Position.z = twistedMain.y;

  vec2 twistedA = rot * positionA.xz;
  positionA.x = twistedA.x;
  positionA.z = twistedA.y;

  vec2 twistedB = rot * positionB.xz;
  positionB.x = twistedB.x;
  positionB.z = twistedB.y;

  vec3 toA = normalize(positionA - csm_Position);
  vec3 toB = normalize(positionB - csm_Position);
  csm_Normal = cross(toA, toB);

  vEork = eork / uStrength;

}
