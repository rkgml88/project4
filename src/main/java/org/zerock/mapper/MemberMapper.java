package org.zerock.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.zerock.domain.MemberDTO;

@Mapper
public interface MemberMapper {
	
	void insertMember(MemberDTO member);
	
	int existsByUsername(String username);
	
	MemberDTO findByusername(String username);
	
	void updateMember(MemberDTO member);

	void deleteMember(String username);
}
