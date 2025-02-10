shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

float MAX(float r, float g,float b){
	if(r > g){
		if(r > b){
			return r;
		}
		else{
			return b;
		}
	}
	else{
		if(g > b){
			return g;
		}
		else{
			return b;
		}
	}
}

float MIN(float r, float g, float b){
	if(r < g){
		if(r < b){
			return r;
		}
		else{
			return b;
		}
	}
	else{
		if(g < b){
			return g;
		}
		else{
			return b;
		}
	}
}

float hue(float r,float g,float b){
	float maxc = MAX(r, g, b);
	float minc = MIN(r, g, b);
	float delta = maxc - minc;
	
	float gb = g - b;
	float br = b - r;
	float rg = r - g;
	
	float result;
	if (r == maxc){
		result = 60.0 * gb / delta;
	}
	else if (g == maxc){
		result = 60.0 * ((br/delta) +2.0f);
	}
	else{
		result = 60.0 * ((rg/delta) +4.0f);
	}
	
	if(result < 0.0){
		result += 360.0f;
	}
	return result;
}

uniform bool showRed = false;
uniform bool showBlue = true;
uniform bool showGreen = true;
uniform bool showOrange = true;
uniform bool showPink = true;
uniform bool showPurple = false;
uniform bool showTeal = false;
uniform bool showYellow = false;

void fragment() {
	
	float rMinHue = 0.0f, rMaxHue = 2.0f;
	float gMinHue = 94.0f, gMaxHue = 96.0f;
	float bMinHue = 217.0f, bMaxHue = 219.0f;
	float oMinHue = 23.0f, oMaxHue = 25.0f;
	float pMinHue = 317.0f, pMaxHue = 319.0f;
	float puMinHue = 282.0f, puMaxHue = 284.0f;
	float tMinHue = 189.0f, tMaxHue = 191.0f;
	float yMinHue = 56.0f, yMaxHue = 58.0f;
	
	vec4 color = texture(screen_texture, SCREEN_UV);
		
	float h = hue(color.r,color.g,color.b);
	bool colored = false;
	
	if(h >= rMinHue && h <= rMaxHue){
		if(showRed){
			colored = true;
		}
	}
	else if(h >= bMinHue && h <= bMaxHue){
		if(showBlue){
			colored = true;
		}
	}
	else if(h >= bMinHue && h <= bMaxHue){
		if(showBlue){
			colored = true;
		}
	}
	else if(h >= gMinHue && h <= gMaxHue){
		if(showGreen){
			colored = true;
		}
	}
	else if(h >= oMinHue && h <= oMaxHue){
		if(showOrange){
			colored = true;
		}
	}
	else if(h >= pMinHue && h <= pMaxHue){
		if(showPink){
			colored = true;
		}
	}
	else if(h >= puMinHue && h <= puMaxHue){
		if(showPurple){
			colored = true;
		}
	}
	else if(h >= tMinHue && h <= tMaxHue){
		if(showTeal){
			colored = true;
		}
	}
	else if(h >= yMinHue && h <= yMaxHue){
		if(showYellow){
			colored = true;
		}
	}
	
	if(colored){
		COLOR = vec4(color.rgb, 1.0f);
	}
	else{
		float avg = (color.r + color.g + color.b) / 3.0f;
		COLOR = vec4(avg, avg, avg, 1.0f);
	}
}