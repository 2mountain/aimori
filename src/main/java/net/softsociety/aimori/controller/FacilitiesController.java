package net.softsociety.aimori.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.slf4j.Slf4j;
import net.softsociety.aimori.domain.Facilities;
import net.softsociety.aimori.domain.FacilitiesValuation;
import net.softsociety.aimori.service.FacilitiesService;

@Slf4j
@RequestMapping("facilities")
@Controller
public class FacilitiesController {
	
	// 별점은 5가 최대
	@Value("${user.facilities.star}")
	int star;
	
	@Autowired
	FacilitiesService service;
	
	@GetMapping({"", "/"})
	public String facilities(Model model) {
		
		// 이부분에다가 값을 바꿔주면 처음 띄울 때 값이 바뀐다!
		String place = "애완동물";
		int radius = 3000;
		 
		model.addAttribute("place", place);
		model.addAttribute("radius", radius);
		
		log.debug("[FacilitiesController] facilities");
		
		return "facilities/facilities";
	}
	
	@PostMapping({"", "/"})
	public String placeSave(Model model, 
			@RequestParam(name="place", defaultValue="애완동물") String place,
			@RequestParam(name="radius", defaultValue="3000") int radius) {
		log.debug("[FacilitiesController] placeSave - parameter : {}", place);
		log.debug("[FacilitiesController] placeSave - parameter : {}", radius);

		model.addAttribute("place", place);
		model.addAttribute("radius", radius);
		
		return "facilities/facilities";
	}
	
}
