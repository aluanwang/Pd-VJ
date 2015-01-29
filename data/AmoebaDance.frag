uniform sampler2D MyTex;
uniform float B,C;
uniform float alpha;

void main()
{
	vec4 color = texture2D(MyTex, (gl_TextureMatrix[0] * gl_TexCoord[0]).st);
 	color *= B+1.; // brightness
 	vec4 gray = vec4(dot(color.rgb,vec3(0.2125,  0.7154, 0.0721)));
 	color = mix(gray, color, C+1.); // contrast
	gl_FragColor = vec4(vec3(color).rgb,alpha);
}
