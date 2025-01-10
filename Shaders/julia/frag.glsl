#version 430
uniform vec2 resolution;
uniform float time;
uniform sampler1D samples;
uniform sampler1D fft;
out vec4 color;

// 0: integer hash
// 1: float hash (aliasing based) (don't do this unless you live in the year 2013)
#define METHOD 0

// 0: cubic
// 1: quintic
#define INTERPOLANT 0

#if METHOD==0
float hash( in ivec2 p )  // this hash is not production ready, please
{                         // replace this by something better

    // 2D -> 1D
    int n = p.x*3 + p.y*113;

    // 1D hash by Hugo Elias
	n = (n << 13) ^ n;
    n = n * (n * n * 15731 + 789221) + 1376312589;
    return -1.0+2.0*float( n & 0x0fffffff)/float(0x0fffffff);
}
#else
float hash(vec2 p)  // replace this by something better
{
    p  = 50.0*fract( p*0.3183099 + vec2(0.71,0.113));
    return -1.0+2.0*fract( p.x*p.y*(p.x+p.y) );
}
#endif

float noise( in vec2 p )
{
    #if METHOD==0
    ivec2 i = ivec2(floor( p ));
    #else
    vec2 i = floor( p );
    #endif
    vec2 f = fract( p );

    #if INTERPOLANT==1
    // quintic interpolant
    vec2 u = f*f*f*(f*(f*6.0-15.0)+10.0);
    #else
    // cubic interpolant
    vec2 u = f*f*(3.0-2.0*f);
    #endif

    #if METHOD==0
    return mix( mix( hash( i + ivec2(0,0) ),
                     hash( i + ivec2(1,0) ), u.x),
                mix( hash( i + ivec2(0,1) ),
                     hash( i + ivec2(1,1) ), u.x), u.y);
    #else
    return mix( mix( hash( i + vec2(0.0,0.0) ),
                     hash( i + vec2(1.0,0.0) ), u.x),
                mix( hash( i + vec2(0.0,1.0) ),
                     hash( i + vec2(1.0,1.0) ), u.x), u.y);
    #endif
}

vec3 hsv2rgb( in vec3 c )
{
    vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );

	rgb = rgb*rgb*(3.0-2.0*rgb); // cubic smoothing

	return c.z * mix( vec3(1.0), rgb, c.y);
}

vec2 square(in vec2 x) {
    return vec2(x.x * x.x - x.y * x.y, 2.0 * (x.x * x.y));
}

vec2 iterate(in vec2 z, in vec2 c) {
    return square(z) + c;
}

vec2 screen2world(in vec2 x) {

    highp vec2 center = vec2(0);
    highp float zoom  = 2.0;
    x /= resolution.xy;
    x = mix(vec2(-zoom, zoom * -450.0/800.0) + center, vec2(zoom, zoom * 450.0/800.0) + center, x);
    return x;
}

void main()
{

       int iterationcount = 100;

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = gl_FragCoord.xy;

    float t = exp(-mod(time, 5.0));
    int s = int(time / 5.0);
    vec2 start = vec2(
        noise(vec2(s, 0)),
        noise(vec2(0, s))
    );
    vec2 end = vec2(
        noise(vec2(s + 1, 0)),
        noise(vec2(0, s + 1))
    );

    highp vec2 c = mix(end, start, t);
    //c.x = 0.0;
    //c.y = 0.0;



    highp vec2 z = screen2world(uv);
    float iterations = 0.0;
    for (int i = 0; i < iterationcount; i++) {
        z = iterate(z, c);
        if (length(z) >= 2.0) {
            break;
        }
        iterations ++;
    }
    if (length(z) <= 2.0) {
        color = vec4(0, 0, 0, 0.0);
        return;
    }
    vec3 col = hsv2rgb(vec3(0.6 - iterations/float(iterationcount), 1, min(1.0, iterations/10.0)));
    color = vec4(col, iterations/10.0);
}
