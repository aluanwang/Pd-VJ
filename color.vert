uniform float vel;
uniform vec3 noise;

float rand(vec3 co) {
  return fract(sin(dot(co.xyz, vec3(12.9898, 73.233,2.3456))) * vel);
}

void main()
{
    	gl_TexCoord[0] = gl_MultiTexCoord0;
	
	vec3 pos = gl_Vertex.xyz + (noise*rand(gl_Vertex.xyz));
     	gl_Position = gl_ModelViewProjectionMatrix * vec4(pos,1.0);

}
