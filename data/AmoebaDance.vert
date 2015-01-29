/************** generic cartesian spherical conversion functions ***************/
struct spherical {
	float r, phi, theta;
};

spherical cartesianToSpherical(vec3 cPoint) {
	spherical sCoords;
	float xyLen = length(cPoint.xy);
	sCoords.r = length(cPoint);  
	sCoords.phi = acos(cPoint.z / sCoords.r);
	sCoords.theta = atan(cPoint.x, cPoint.y);
	return sCoords;
}

vec3 sphericalToCartesian(spherical sPoint) {
	vec3 cCoords;
	cCoords.x = sPoint.r * sin(sPoint.phi) * cos(sPoint.theta);
	cCoords.y = sPoint.r * sin(sPoint.phi) * sin(sPoint.theta);
	cCoords.z = sPoint.r * cos(sPoint.phi);
	return cCoords;
}
/*************************************************************/


uniform float RadMod;

uniform vec2 count;
uniform vec2 phase;
uniform vec2 amount;
uniform float vel;
uniform vec3 noise;



/************* simple scaling function, adds to the radius ***********/
// takes a spherical coordinates as parameter
// and returns spherical coordinates
spherical radialDistort(spherical sPoint, float RadMod) {
	sPoint.r += RadMod;
	return sPoint;
}


/************* modulates radius based on theta and phi ***********/
// takes a spherical coordinates as parameter
// and returns spherical coordinates by writing to the same parameter
// did it like that just to try out the in/out keywords
void radialDistort2(inout spherical sPoint) {
	sPoint.r += sin(sPoint.phi * count.x + phase.x) * amount.x;
	sPoint.r += cos(sPoint.theta * count.y + phase.y) * amount.y;
}



void main()
{
	spherical sphereCoords = cartesianToSpherical(gl_Vertex.xyz);
	
	// this function just scales and returns the new spherical coordinates in the function
	sphereCoords = radialDistort(sphereCoords, RadMod);
	
	// this function does some other stuff and writes the spherical coordinates back to the same variable
	// did it like that just to try out the in/out keywords
	radialDistort2(sphereCoords);
	
	// convert modified spherical coordindates back to cartesian
	vec3 outCoords = sphericalToCartesian(sphereCoords)+ noise3( gl_Vertex.xyz * vel * noise);
	gl_Position = gl_ModelViewProjectionMatrix * vec4(outCoords, 1.0);
	
	
	// lighting
	vec3 normal = normalize(gl_NormalMatrix * gl_Normal);	vec3 lightDir = normalize(vec3(gl_LightSource[0].position));	float NdotL = max(dot(normal, lightDir), 0.0);	vec4 diffuse = gl_FrontMaterial.diffuse * gl_LightSource[0].diffuse;	gl_FrontColor =  NdotL * diffuse;
	
	// add fake lighting based on radius;
	gl_FrontColor =  gl_FrontColor * 0.5 + (abs(sphereCoords.r)-RadMod) * 0.5;
        gl_TexCoord[0] = gl_MultiTexCoord0;
       
}
