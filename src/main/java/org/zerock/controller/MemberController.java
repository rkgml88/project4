package org.zerock.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.MemberDTO;
import org.zerock.service.MemberService;

@Controller
public class MemberController {
	@Autowired
    private MemberService memberService;

	@GetMapping("/login")
    public String redirectLogininGet() {
        
        return "login";
    }
	
	@GetMapping("/joinU")
    public String redirectJoinUGet() {
        
        return "joinU";
    }
    
	@GetMapping("/joinA")
    public String redirectJoinAGet() {
        
        return "joinA";
    }
	
	@PostMapping("/checkUsername")
	@ResponseBody
	public String checkUsername(@RequestParam String username) {
	    boolean exists = memberService.existsByUsername(username); // DB 조회
	    return exists ? "FAIL" : "OK";
	}

    @PostMapping("/joinU")
    public String joinUser(@ModelAttribute MemberDTO member, RedirectAttributes redirectAttributes) {
        // 사용자 role 고정
    	member.setRole("ROLE_USER");
    	memberService.insertMember(member);
    	redirectAttributes.addFlashAttribute("msg", "회원가입이 완료되었습니다.");
        return "redirect:/login";
    }

    @PostMapping("/joinA")
    public String joinAdmin(@ModelAttribute MemberDTO member, RedirectAttributes redirectAttributes) {
        // 관리자 role 고정
    	member.setRole("ROLE_ADMIN");
    	memberService.insertMember(member);
    	redirectAttributes.addFlashAttribute("msg", "회원가입이 완료되었습니다.");
        return "redirect:/login";
    }
    
    @GetMapping("/userinfo")
    public String redirectUserinfoGet(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        MemberDTO member = memberService.findByusername(username);
        model.addAttribute("member", member);
        return "userinfo";
    }

    @PostMapping("/update")
    public String updateMember(MemberDTO member) {
        // username은 member.username에 들어 있음
        memberService.updateMember(member);
        return "redirect:/userinfo"; // 다시 회원정보 페이지로
    }
    
    @PostMapping("/deleteMember")
    public String deleteMember(
    		@RequestParam("username") String username, 
    		HttpServletRequest request, 
    		HttpServletResponse response, 
    		Model model) {
        memberService.deleteMember(username);
        
        // 로그아웃 처리
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null){
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        
        model.addAttribute("message", "회원 탈퇴되셨습니다.");
        model.addAttribute("redirectUrl", "/main");
        return "alertRedirect";
    }


}
