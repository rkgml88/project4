package org.zerock.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardDTO;
import org.zerock.service.BoardService;

@Controller
public class BoardController {
	@GetMapping("/write")
    public String redirectWriteGet() {
        
        return "write";
    }
	
	@Autowired
    private ServletContext servletContext;

    @Autowired
    private BoardService boardService; // Service 레이어 예시

    @PostMapping("/board/uploadFile")
    @ResponseBody
    public Map<String, String> uploadFile(@RequestParam("file") MultipartFile file) throws IOException {
    	System.out.println("=== uploadFile 호출됨 ===");
        System.out.println("파일 이름: " + file.getOriginalFilename());
    	
    	String uploadDir = servletContext.getRealPath("/resources/upload");
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        file.transferTo(new File(uploadDir, fileName));

        String url = "/resources/upload/" + fileName;
        Map<String, String> result = new HashMap<>();
        result.put("url", url);
        return result;
    }

    @PostMapping("/board/savePost")
    @ResponseBody
    public Map<String, Object> savePost(@RequestBody BoardDTO board) {
    	// 로그인한 사용자 정보 가져오기
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    	String username = authentication.getName();
    	
    	// 작성자 자동 세팅
    	board.setWriter(username);
    	
    	// DB에 저장
        boardService.insertPost(board);
        
        // 응답
        Map<String, Object> res = new HashMap<>();
        res.put("success", true);
        return res;
    }
    
    @GetMapping("/view")
    public String viewPost(@RequestParam("num") int num, Model model) {
        BoardDTO post = boardService.findByNum(num);
        model.addAttribute("post", post);
        
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        model.addAttribute("loginUser", username);
        
        return "view"; // view.jsp
    }
    
    @GetMapping("/modify")
    public String modPost(@RequestParam("num") int num, Model model) {
    	BoardDTO post = boardService.findByNum(num);
        model.addAttribute("post", post);
        return "modify";
    }
    
    @PostMapping("/modify")
    @ResponseBody
	public String modpost(@RequestBody BoardDTO board) {
    	boardService.modify(board);
    	return "success";		
	}
    
    @PostMapping("/delete")
	public String delete(@RequestParam("num") int num) {
		boardService.delete(num);	
		return "redirect:/";
	}
    
    @GetMapping("/news")
    public String newsPage(
        @RequestParam(defaultValue = "1") int pageNotice,
        @RequestParam(defaultValue = "1") int pageNews,
        @RequestParam(required = false) String search,
        Model model) {

        int pageSize = 5;

        // 공지사항 파라미터
        Map<String, Object> noticeParams = new HashMap<>();
        noticeParams.put("category", "News");
        noticeParams.put("subCategory", "INCOFFEE소식");
        noticeParams.put("type", "공지사항");
        noticeParams.put("offset", (pageNotice - 1) * pageSize);
        noticeParams.put("limit", pageSize);
        if (search != null && !search.isEmpty()) {
            noticeParams.put("search", search);
        }

        // 뉴스 파라미터
        Map<String, Object> newsParams = new HashMap<>();
        newsParams.put("category", "News");
        newsParams.put("subCategory", "INCOFFEE소식");
        newsParams.put("type", "INCOFFEE소식");
        newsParams.put("offset", (pageNews - 1) * pageSize);
        newsParams.put("limit", pageSize);
        if (search != null && !search.isEmpty()) {
            newsParams.put("search", search);
        }

        // 총 개수
        int noticeTotal = boardService.countByCtg(noticeParams);
        int newsTotal = boardService.countByCtg(newsParams);

        int noticeTotalPages = (int) Math.ceil((double) noticeTotal / pageSize);
        int newsTotalPages = (int) Math.ceil((double) newsTotal / pageSize);
        
        // << 뉴스 페이지 블록 계산 >>
        int pageBlock = 5;
        int startPage = Math.max(1, pageNews - pageBlock / 2);
        int endPage = startPage + pageBlock - 1;
        if (endPage > newsTotalPages) {
            endPage = newsTotalPages;
            startPage = Math.max(1, endPage - pageBlock + 1);
        }

        // 리스트 조회
        List<BoardDTO> noticeList = boardService.findByCtgPaging(noticeParams);
        List<BoardDTO> newsList = boardService.findByCtgPaging(newsParams);

        // 모델에 값 설정
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("newsList", newsList);

        model.addAttribute("pageNotice", pageNotice);
        model.addAttribute("pageNews", pageNews);
        model.addAttribute("noticeTotal", noticeTotal);
        model.addAttribute("newsTotal", newsTotal);
        model.addAttribute("noticeTotalPages", noticeTotalPages);
        model.addAttribute("newsTotalPages", newsTotalPages);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("search", search); // 검색어 유지
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);

        return "news";
    }


    @GetMapping("/event")
    public String eventPage(
        @RequestParam(defaultValue = "1") int pageEvent,
        @RequestParam(required = false) String type,
        @RequestParam(required = false) String search,
        Model model) {
        int pageSize = 8;
        int offset = (pageEvent - 1) * pageSize;

        Map<String, Object> params = new HashMap<>();
        params.put("category", "News");
        params.put("subCategory", "이벤트");
        params.put("type", "전체".equals(type) ? null : type); // 전체 선택 시 type=null
        params.put("offset", offset);
        params.put("limit", pageSize);
        if (search != null && !search.isEmpty()) {
        	params.put("search", search);
        }

        int eventTotal = boardService.countByCtg(params);
        int eventTotalPages = (int) Math.ceil((double) eventTotal / pageSize);
        
        // 페이지 블록 계산 (최대 5개)
        int pageBlock = 5;
        int startPage = Math.max(1, pageEvent - pageBlock / 2);
        int endPage = startPage + pageBlock - 1;
        if (endPage > eventTotalPages) {
            endPage = eventTotalPages;
            startPage = Math.max(1, endPage - pageBlock + 1);
        }

        List<BoardDTO> eventList = boardService.findByCtgPaging(params);

        model.addAttribute("eventList", eventList);
        model.addAttribute("pageEvent", pageEvent);
        model.addAttribute("eventTotal", eventTotal);
        model.addAttribute("eventTotalPages", eventTotalPages);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("selectedType", type != null ? type : "전체");
        model.addAttribute("search", search); // 검색어 유지
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);

        return "event";
    }

    @GetMapping("/newmenu")
    public String newMenuPage(@RequestParam(defaultValue = "1") int pageNewmenu, Model model) {
        int pageSize = 12;
        int offset = (pageNewmenu - 1) * pageSize;

        Map<String, Object> params = new HashMap<>();
        params.put("category", "Menu");
        params.put("subCategory", "신메뉴");
        params.put("type", null);
        params.put("offset", offset);
        params.put("limit", pageSize);

        int newmenuTotal = boardService.countByCtg(params);
        int newmenuTotalPages = (int) Math.ceil((double) newmenuTotal / pageSize);
        
        // << 페이지 블록 계산 >>
        int pageBlock = 5; // 최대 5개 노출
        int startPage = Math.max(1, pageNewmenu - pageBlock / 2);
        int endPage = startPage + pageBlock - 1;
        if (endPage > newmenuTotalPages) {
            endPage = newmenuTotalPages;
            startPage = Math.max(1, endPage - pageBlock + 1);
        }

        List<BoardDTO> newmenuList = boardService.findByCtgPaging(params);

        model.addAttribute("newmenuList", newmenuList);
        model.addAttribute("pageNewmenu", pageNewmenu);
        model.addAttribute("newmenuTotal", newmenuTotal);
        model.addAttribute("newmenuTotalPages", newmenuTotalPages);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);

        return "newmenu";
    }

	
	@GetMapping("/coffee")
    public String coffeePage(
            @RequestParam(defaultValue = "1") int pageCoffee, Model model) {
            int pageSize = 12;
            int offset = (pageCoffee - 1) * pageSize;

            Map<String, Object> params = new HashMap<>();
            params.put("category", "Menu");
            params.put("subCategory", "커피");
            params.put("type", null);
            params.put("offset", offset);
            params.put("limit", pageSize);

            int coffeeTotal = boardService.countByCtg(params);
            int coffeeTotalPages = (int) Math.ceil((double) coffeeTotal / pageSize);
            
            // << 페이지 블록 계산 >>
            int pageBlock = 5; // 최대 5개 노출
            int startPage = Math.max(1, pageCoffee - pageBlock / 2);
            int endPage = startPage + pageBlock - 1;
            if (endPage > coffeeTotalPages) {
                endPage = coffeeTotalPages;
                startPage = Math.max(1, endPage - pageBlock + 1);
            }

            List<BoardDTO> coffeeList = boardService.findByCtgPaging(params);

            model.addAttribute("coffeeList", coffeeList);
            model.addAttribute("pageCoffee", pageCoffee);
            model.addAttribute("coffeeTotal", coffeeTotal);
            model.addAttribute("coffeeTotalPages", coffeeTotalPages);
            model.addAttribute("pageSize", pageSize);
            model.addAttribute("startPage", startPage);
            model.addAttribute("endPage", endPage);

        return "coffee";
    }
	
	@GetMapping("/noncoffee")
	public String noncoffeePage(
	    @RequestParam(defaultValue = "1") int pageNoncoffee,
	    @RequestParam(required = false, name = "types") List<String> types,
	    Model model) {

	    int pageSize = 12;
	    // types가 null/empty면 null 넘김 (Mapper에서 type!=null 조건으로 동작)
	    String typeParam = null;
	    if (types != null && !types.isEmpty()) {
	        if (types.size() == 1 && "전체".equals(types.get(0))) {
	            typeParam = null;
	        } else {
	            typeParam = String.join(",", types);
	        }
	    }

	    Map<String, Object> params = new HashMap<>();
	    params.put("category", "Menu");
	    params.put("subCategory", "논커피");
	    params.put("type", typeParam);

	    int noncoffeeTotal = boardService.countByCtg(params);
	    int noncoffeeTotalPages = (int) Math.ceil((double) noncoffeeTotal / pageSize);

	    params.put("offset", (pageNoncoffee - 1) * pageSize);
	    params.put("limit", pageSize);
	    
	    // << 페이지 블록 계산 >>
        int pageBlock = 5; // 최대 5개 노출
        int startPage = Math.max(1, pageNoncoffee - pageBlock / 2);
        int endPage = startPage + pageBlock - 1;
        if (endPage > noncoffeeTotalPages) {
            endPage = noncoffeeTotalPages;
            startPage = Math.max(1, endPage - pageBlock + 1);
        }

	    List<BoardDTO> noncoffeeList = boardService.findByCtgPaging(params);

	    model.addAttribute("noncoffeeList", noncoffeeList);
	    model.addAttribute("pageNoncoffee", pageNoncoffee);
	    model.addAttribute("noncoffeeTotalPages", noncoffeeTotalPages);
	    model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
	    // 체크박스 복원 위해 types 넘기되, null이면 전체로
	    model.addAttribute("selectedTypes", types != null ? types : new ArrayList<>());

	    return "noncoffee";
	}
	
	@GetMapping("/dessert")
    public String dessertPage(
            @RequestParam(defaultValue = "1") int pageDessert, Model model) {
            int pageSize = 12;
            int offset = (pageDessert - 1) * pageSize;

            Map<String, Object> params = new HashMap<>();
            params.put("category", "Menu");
            params.put("subCategory", "디저트");
            params.put("type", null);
            params.put("offset", offset);
            params.put("limit", pageSize);
            
            int dessertTotal = boardService.countByCtg(params);
            int dessertTotalPages = (int) Math.ceil((double) dessertTotal / pageSize);
            
            // << 페이지 블록 계산 >>
            int pageBlock = 5; // 최대 5개 노출
            int startPage = Math.max(1, pageDessert - pageBlock / 2);
            int endPage = startPage + pageBlock - 1;
            if (endPage > dessertTotalPages) {
                endPage = dessertTotalPages;
                startPage = Math.max(1, endPage - pageBlock + 1);
            }

            List<BoardDTO> dessertList = boardService.findByCtgPaging(params);
            
            model.addAttribute("dessertList", dessertList);
            model.addAttribute("pageDessert", pageDessert);
            model.addAttribute("dessertTotal", dessertTotal);
            model.addAttribute("dessertTotalPages", dessertTotalPages);
            model.addAttribute("pageSize", pageSize);
            model.addAttribute("startPage", startPage);
            model.addAttribute("endPage", endPage);

        return "dessert";
    }
	
	@GetMapping("/coffeebean")
    public String coffeebeanPage(
            @RequestParam(defaultValue = "1") int pageCoffeebean, Model model) {
            int pageSize = 12;
            int offset = (pageCoffeebean - 1) * pageSize;

            Map<String, Object> params = new HashMap<>();
            params.put("category", "Store");
            params.put("subCategory", "원두");
            params.put("type", null);
            params.put("offset", offset);
            params.put("limit", pageSize);
            
            int coffeebeanTotal = boardService.countByCtg(params);
            int coffeebeanTotalPages = (int) Math.ceil((double) coffeebeanTotal / pageSize);
            
            // << 페이지 블록 계산 >>
            int pageBlock = 5; // 최대 5개 노출
            int startPage = Math.max(1, pageCoffeebean - pageBlock / 2);
            int endPage = startPage + pageBlock - 1;
            if (endPage > coffeebeanTotalPages) {
                endPage = coffeebeanTotalPages;
                startPage = Math.max(1, endPage - pageBlock + 1);
            }

            List<BoardDTO> coffeebeanList = boardService.findByCtgPaging(params);

            model.addAttribute("coffeebeanList", coffeebeanList);
            model.addAttribute("pageCoffeebean", pageCoffeebean);
            model.addAttribute("coffeebeanTotal", coffeebeanTotal);
            model.addAttribute("coffeebeanTotalPages", coffeebeanTotalPages);
            model.addAttribute("pageSize", pageSize);
            model.addAttribute("startPage", startPage);
            model.addAttribute("endPage", endPage);

        return "coffeebean";
    }
	
	@GetMapping("/cup")
    public String cupPage(
            @RequestParam(defaultValue = "1") int pageCup, Model model) {
            int pageSize = 12;
            int offset = (pageCup - 1) * pageSize;

            Map<String, Object> params = new HashMap<>();
            params.put("category", "Store");
            params.put("subCategory", "머그컵/텀블러");
            params.put("type", null);
            params.put("offset", offset);
            params.put("limit", pageSize);
            
            int cupTotal = boardService.countByCtg(params);
            int cupTotalPages = (int) Math.ceil((double) cupTotal / pageSize);
            
            // << 페이지 블록 계산 >>
            int pageBlock = 5; // 최대 5개 노출
            int startPage = Math.max(1, pageCup - pageBlock / 2);
            int endPage = startPage + pageBlock - 1;
            if (endPage > cupTotalPages) {
                endPage = cupTotalPages;
                startPage = Math.max(1, endPage - pageBlock + 1);
            }

            List<BoardDTO> cupList = boardService.findByCtgPaging(params);
            
            model.addAttribute("cupList", cupList);
            model.addAttribute("pageCup", pageCup);
            model.addAttribute("cupTotal", cupTotal);
            model.addAttribute("cupTotalPages", cupTotalPages);
            model.addAttribute("pageSize", pageSize);
            model.addAttribute("startPage", startPage);
            model.addAttribute("endPage", endPage);

        return "cup";
    }
}
