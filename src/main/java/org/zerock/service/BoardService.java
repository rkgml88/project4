package org.zerock.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.BoardDTO;
import org.zerock.mapper.BoardMapper;

@Service
public class BoardService {
	
	@Autowired
    private BoardMapper boardMapper;

    public void insertPost(BoardDTO board) {
        boardMapper.insertPost(board);
    }
    
    public List<BoardDTO> findByCtgPaging(Map<String, Object> params) {
        return boardMapper.findByCtgPaging(params);
    }

    public int countByCtg(Map<String, Object> params) {
        return boardMapper.countByCtg(params);
    }
    
    public BoardDTO findByNum(int num) {
    	boardMapper.visitcount(num);
    	return boardMapper.findByNum(num);
    }
    
    public void modify(BoardDTO board) {
		
    	boardMapper.modify(board);
	}
    
    public void delete(int num) {
    	boardMapper.delete(num);
	}
}
