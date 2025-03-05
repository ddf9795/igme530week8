shader_type canvas_item;

uniform float bloomRadius = 1.0;
uniform float bloomThreshold = 1.0;
uniform float bloomIntensity = 1.0;

vec3 GetBloomPixel(sampler2D tex, vec2 uv, vec2 texPixelSize) {
	vec2 uv2 = floor(uv / texPixelSize) * texPixelSize;
	uv2 += texPixelSize * .001;
	vec3 tl = max(texture(tex, uv2).rgb - bloomThreshold, 0.0);
	vec3 tr = max(texture(tex, uv2 + vec2(texPixelSize.x, 0.0)).rgb - bloomThreshold, 0.0);
	vec3 bl = max(texture(tex, uv2 + vec2(0.0, texPixelSize.y)).rgb - bloomThreshold, 0.0);
	vec3 br = max(texture(tex, uv2 + vec2(texPixelSize.x, texPixelSize.y)).rgb - bloomThreshold, 0.0);
	vec2 f = fract( uv / texPixelSize );

	vec3 tA = mix( tl, tr, f.x );
	vec3 tB = mix( bl, br, f.x );

	return mix( tA, tB, f.y );
}

vec3 GetBloom(sampler2D tex, vec2 uv, vec2 texPixelSize) {
	vec3 bloom = vec3(0.0);
	vec2 off = vec2(1) * texPixelSize * bloomRadius;
	bloom += GetBloomPixel(tex, uv + off * vec2(-1, -1), texPixelSize * bloomRadius) * 0.292893;
	bloom += GetBloomPixel(tex, uv + off * vec2(-1, 0), texPixelSize * bloomRadius) * 0.5;
	bloom += GetBloomPixel(tex, uv + off * vec2(-1, 1), texPixelSize * bloomRadius) * 0.292893;
	bloom += GetBloomPixel(tex, uv + off * vec2(0, -1), texPixelSize * bloomRadius) * 0.5;
	bloom += GetBloomPixel(tex, uv + off * vec2(0, 0), texPixelSize * bloomRadius) * 1.0;
	bloom += GetBloomPixel(tex, uv + off * vec2(0, 1), texPixelSize * bloomRadius) * 0.5;
	bloom += GetBloomPixel(tex, uv + off * vec2(1, -1), texPixelSize * bloomRadius) * 0.292893;
	bloom += GetBloomPixel(tex, uv + off * vec2(1, 0), texPixelSize * bloomRadius) * 0.5;
	bloom += GetBloomPixel(tex, uv + off * vec2(1, 1), texPixelSize * bloomRadius) * 0.292893;
	bloom /= 4.171573f;
	return bloom;
}

void fragment() {
// Input:5
	vec3 n_out5p0 = vec3(SCREEN_UV, 0.0);

// Input:7

// Texture:3
	vec3 n_out3p0;
	float n_out3p1;
	{
		vec4 TEXTURE_tex_read = texture(TEXTURE, n_out5p0.xy);
		n_out3p0 = TEXTURE_tex_read.rgb;
		n_out3p1 = TEXTURE_tex_read.a;
	}

// Input:6
	vec3 n_out6p0 = vec3(SCREEN_UV, 0.0);

// VectorFunc:8
	vec3 n_out8p0 = acos(n_out6p0);

// VectorOp:9
	vec3 n_in9p1 = vec3(-0.1000, -0.3000, 0.2000);
	vec3 n_out9p0 = n_out6p0 - n_in9p1;

// Fresnel:4
	float n_in4p3 = 5.00000;
	float n_out4p0 = pow(clamp(dot(n_out8p0, n_out9p0), 0.0, 1.0), n_in4p3);

// Output:0
	COLOR.rgb = n_out3p0;
	COLOR.a = n_out4p0;

	vec4 col = texture(TEXTURE, UV);
	vec3 bloom = GetBloom(TEXTURE, UV, TEXTURE_PIXEL_SIZE);
	col.rgb += bloom * bloomIntensity;
	COLOR.rgb = col.rgb;

}