uniform sampler2D MyTex;
uniform float alpha;

void main (void)
{
 vec4 color = texture2D(MyTex, (gl_TextureMatrix[0] * gl_TexCoord[0]).st);
 gl_FragColor = vec4(color.rgb,color.a*alpha);
}
