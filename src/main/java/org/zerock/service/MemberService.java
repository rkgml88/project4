package org.zerock.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.zerock.domain.MemberDTO;
import org.zerock.mapper.MemberMapper;

@Service
public class MemberService {
	
	@Autowired
    private MemberMapper memberMapper;
	
	public void insertMember(MemberDTO member) {
        // 비밀번호 암호화 예시 (Spring Security)
        String encodedPassword = new BCryptPasswordEncoder().encode(member.getPassword());
        member.setPassword(encodedPassword);

        memberMapper.insertMember(member);
    }
	
	public boolean existsByUsername(String username) {
		return memberMapper.existsByUsername(username) > 0;
	}
	
	public MemberDTO findByusername(String username) {
    	return memberMapper.findByusername(username);
    }
	
	public void updateMember(MemberDTO member) {
	    memberMapper.updateMember(member);
	}
	
	public void deleteMember(String username) {
		memberMapper.deleteMember(username);
	}
}
