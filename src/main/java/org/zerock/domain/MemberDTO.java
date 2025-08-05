package org.zerock.domain;

import java.util.Date;

import lombok.Data;

@Data
public class MemberDTO {
	private String username; 
	private String password;
	private String name;
	private String tel;
	private String email;
	private String postcode;
	private String address1;
	private String address2;
	private String marketingYn;
	private Date regidate;
	private String role;
}
