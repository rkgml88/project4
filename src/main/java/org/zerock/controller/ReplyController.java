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

    // ´ñ±Û ¸®½ºÆ® °¡Á®¿À±â (AJAX)
    @GetMapping("/list")
    @ResponseBody
    public List<ReplyDTO> getList(@RequestParam int num) {
        return replyService.getList(num);
    }

    // ´ñ±Û Ãß°¡
    @PostMapping("/insert")
    @ResponseBody
    public String addReply(@RequestBody ReplyDTO replyDTO) {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	String username = authentication.getName();

    	replyDTO.setReplyer(username);

        replyService.insert(replyDTO);
        return "success";
    }

    // ´ñ±Û »èÁ¦
    @PostMapping("/delete")
    @ResponseBody
    public void deleteReply(@RequestBody Map<String, Integer> data) {
        int rnum = data.get("rnum");
        replyService.delete(rnum);
    }


    // ´ñ±Û ¼öÁ¤
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
