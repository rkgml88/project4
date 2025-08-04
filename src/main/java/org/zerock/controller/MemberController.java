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
	    boolean exists = memberService.existsByUsername(username); // DB ��ȸ
	    return exists ? "FAIL" : "OK";
	}

    @PostMapping("/joinU")
    public String joinUser(@ModelAttribute MemberDTO member, RedirectAttributes redirectAttributes) {
        // ����� role ����
    	member.setRole("ROLE_USER");
    	memberService.insertMember(member);
    	redirectAttributes.addFlashAttribute("msg", "ȸ�������� �Ϸ�Ǿ����ϴ�.");
        return "redirect:/login";
    }

    @PostMapping("/joinA")
    public String joinAdmin(@ModelAttribute MemberDTO member, RedirectAttributes redirectAttributes) {
        // ������ role ����
    	member.setRole("ROLE_ADMIN");
    	memberService.insertMember(member);
    	redirectAttributes.addFlashAttribute("msg", "ȸ�������� �Ϸ�Ǿ����ϴ�.");
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
        // username�� member.username�� ��� ����
        memberService.updateMember(member);
        return "redirect:/userinfo"; // �ٽ� ȸ������ ��������
    }
    
    @PostMapping("/deleteMember")
    public String deleteMember(
    		@RequestParam("username") String username, 
    		HttpServletRequest request, 
    		HttpServletResponse response, 
    		Model model) {
        memberService.deleteMember(username);
        
        // �α׾ƿ� ó��
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null){
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        
        model.addAttribute("message", "ȸ�� Ż��Ǽ̽��ϴ�.");
        model.addAttribute("redirectUrl", "/main");
        return "alertRedirect";
    }


}
