package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CafeController {
	@GetMapping("/main")
    public String redirectMainGet() {
        
        return "main";
    }
	
	@GetMapping("/about")
    public String redirectAboutGet() {
        
        return "about";
    }
}
