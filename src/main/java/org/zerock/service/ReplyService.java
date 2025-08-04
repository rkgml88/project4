package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.ReplyDTO;
import org.zerock.mapper.ReplyMapper;

@Service
public class ReplyService {
	@Autowired
    private ReplyMapper replyMapper;

    public List<ReplyDTO> getList(int num) {
        return replyMapper.getList(num);
    }

    public void insert(ReplyDTO dto) {
        replyMapper.insert(dto);
    }

    public void delete(int rnum) {
        replyMapper.delete(rnum);
    }

    public void update(ReplyDTO dto) {
        replyMapper.update(dto);
    }
    
    public List<ReplyDTO> getListPage(int num, int offset, int size){
        return replyMapper.getListPage(num, offset, size);
    }
    
    public int countReplies(int num){
        return replyMapper.countReplies(num);
    }
}
