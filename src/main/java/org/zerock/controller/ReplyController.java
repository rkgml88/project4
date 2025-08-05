package org.zerock.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.zerock.domain.ReplyDTO;
import org.zerock.service.ReplyService;

@Controller
@RequestMapping("/reply")
public class ReplyController {
	@Autowired
    private ReplyService replyService;

    // 댓글 리스트 가져오기 (AJAX)
    @GetMapping("/list")
    @ResponseBody
    public List<ReplyDTO> getList(@RequestParam int num) {
        return replyService.getList(num);
    }

    // 댓글 추가
    @PostMapping("/insert")
    @ResponseBody
    public String addReply(@RequestBody ReplyDTO replyDTO) {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	String username = authentication.getName();

    	replyDTO.setReplyer(username);

        replyService.insert(replyDTO);
        return "success";
    }

    // 댓글 삭제
    @PostMapping("/delete")
    @ResponseBody
    public void deleteReply(@RequestBody Map<String, Integer> data) {
        int rnum = data.get("rnum");
        replyService.delete(rnum);
    }


    // 댓글 수정
    @PostMapping("/update")
    @ResponseBody
    public String updateReply(@RequestBody ReplyDTO replyDTO) {
        replyService.update(replyDTO);
        return "success";
    }
    
    @GetMapping("/listPage")
    @ResponseBody
    public List<ReplyDTO> getListPage(@RequestParam int num,
                                      @RequestParam int page,
                                      @RequestParam(defaultValue="10") int size) {
        int offset = (page - 1) * size;
        return replyService.getListPage(num, offset, size);
    }

    @GetMapping(value = "/count", produces = "application/json")
    @ResponseBody
    public Map<String, Integer> getReplyCount(@RequestParam int num) {
        int count = replyService.countReplies(num);
        return Collections.singletonMap("count", count);
    }



}
