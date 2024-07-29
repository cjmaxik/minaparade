shader_type canvas_item;

uniform float bloat_factor : hint_range(0.0, 5.0) = 0.5;

void fragment() {
    // Get the UV coordinates specific to the sprite
    vec2 uv = UV;

    // Center of the sprite in UV coordinates
    vec2 center = vec2(0.5, 0.5);

    // Vector from the center to the current UV coordinate
    vec2 offset = uv - center;

    // Compute the distance from the center
    float distance = length(offset);

    // Scale the distance to create the bloat effect (adjust the factor as needed)
    float scaled_bloat = 1.0 + bloat_factor * distance;

    // Apply the bloat effect
    vec2 bloated_uv = center + offset * scaled_bloat;

    // Clamp the bloated coordinates to keep them within texture bounds
    bloated_uv = clamp(bloated_uv, vec2(0.0), vec2(1.0));

    // Sample the texture at the new bloated coordinates
    vec4 color = texture(TEXTURE, bloated_uv);

    // Output the color
    COLOR = color;
}
