package org.zerock.domain;

import java.util.Date;

import lombok.Data;

@Data
public class ReplyDTO {
	private int rnum;
	private int num;
	private String reply;
	private String replyer;
	private Date replydate;
	private Date updatedate;
}
