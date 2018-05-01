#version 120

// directional & point light per pixel  + shadow mapping with PCF + normal mapping

uniform int NeedNormalMapping;

varying vec3 pNormal; // already normalized
varying vec3 pTangent;
varying vec3 pBinormal;
varying vec3 Vertex;
varying vec4 ShadowTexCoord;


void main()
{
	pNormal = normalize(gl_NormalMatrix * gl_Normal);
	// calculate Tangent and Binormal
	if (NeedNormalMapping == 1) {
		vec3 vTangent = vec3(gl_MultiTexCoord1.st, gl_MultiTexCoord2.s);
		pTangent  = normalize(gl_NormalMatrix * vTangent);
		pBinormal = normalize(gl_NormalMatrix * (cross(gl_Normal, vTangent) * gl_MultiTexCoord2.t));
	}

	Vertex = vec3(gl_ModelViewMatrix * gl_Vertex);
	
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;

	// setup shadow map by texture's matrix
	ShadowTexCoord = gl_TextureMatrix[2] * gl_ModelViewMatrix * gl_Vertex;
} 
