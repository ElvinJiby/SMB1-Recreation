shader_type canvas_item;

uniform float time_speed : hint_range(3, 20.0) = 3.0;
uniform float intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
	// Cycle through the colors based on time
	float time = TIME * time_speed;
	float r = sin(time) * 0.5 + 0.5;
	float g = sin(time + 2.0) * 0.5 + 0.5;
	float b = sin(time + 4.0) * 0.5 + 0.5;
	
	vec3 flash_color = vec3(r,g,b);
	
	// mix color
	COLOR = mix(color, vec4(flash_color, color.a), intensity);
}
