package org.zerock.domain;

import java.util.Date;

import lombok.Data;

@Data
public class BoardDTO {
	private int num;
	private String category;
    private String subCategory;
    private String type;
    private String title;
    private String thumbnail;
    private String content;
    private Date postdate;
    private Date updatedate;
    private int visitcount;
    private String writer;
}
