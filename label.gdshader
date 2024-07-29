shader_type canvas_item;

uniform float arc_radius : hint_range(50.0, 1000.0); // Minimum value should be greater than 0 to avoid division by zero
uniform vec2 label_size;

void vertex() {
    float center_x = label_size.x / 2.0;
    float angle = (VERTEX.x - center_x) / arc_radius;
    VERTEX.x = center_x + arc_radius * sin(angle);
    VERTEX.y -= arc_radius * (1.0 - cos(angle));
}