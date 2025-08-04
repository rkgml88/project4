package org.zerock.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.zerock.domain.BoardDTO;

@Mapper
public interface BoardMapper {
	
	void insertPost(BoardDTO board);
	
	List<BoardDTO> findByCtgPaging(Map<String, Object> params);

	int countByCtg(Map<String, Object> params);

	BoardDTO findByNum(int num);
	
	void modify(BoardDTO board);
	
	void delete(int num);
	
	void visitcount(int num);
}
