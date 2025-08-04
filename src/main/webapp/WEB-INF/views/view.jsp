<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="stylesheet" type="text/css" href="resources/css/nav.css">
    <link rel="stylesheet" type="text/css" href="resources/css/footer.css">
    <link rel="stylesheet" type="text/css" href="resources/css/news.css">
    <link rel="stylesheet" type="text/css" href="resources/css/view.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>
    <script src="resources/js/nav.js"></script>
    <title>IN COFFEE | NEWS</title>    
</head>
<body>
    <div class="wrap">
        <!-- 카테고리 -->
        <jsp:include page="/WEB-INF/views/nav.jsp" />

        <section>
            <div id="banner">
                <h1>IN COFFEE</h1>
            </div>
            <div id="category">
                <h1>news</h1>
            </div>
            <div class="main">
                <!-- 카테고리 버튼 -->
                <div class="ctgBtn">
				    <div id="news" class="<c:if test='${post.subCategory == "INCOFFEE소식"}'>active</c:if>">
				        <a href="news">IN COFFEE 소식</a>
				    </div>
				    <div id="events" class="<c:if test='${post.subCategory == "이벤트"}'>active</c:if>">
				        <a href="event">이벤트</a>
				    </div>
				</div>
                
                <!-- 상세페이지 -->
                <div class="viewWrap">
                    <input type="hidden" name="num" value="${post.num}">
                    <sec:authorize access="hasRole('ROLE_ADMIN')">
	                    <div id="visitcountWrap">
	                    	<span>조회</span>
	                    	<span id="visitcount" name="visitcount">${post.visitcount}</span>
	                    </div>
	                    <div id="writerWrap">
	                    	<span>작성자</span>
	                    	<span id="writer" name="writer">${post.writer}</span>
	                    </div>
                    </sec:authorize>
                    <div id="title">
                        <h3>${post.title}</h3>
                    </div>
                    <div id="content">
                    	<c:out value="${post.content}" escapeXml="false"/>
                    </div>
                </div>
                <div id="bottomRow">
                    <!-- 수정 버튼 -->
                    <sec:authorize access="hasRole('ROLE_ADMIN')">
	                    <button id=editBtn><a href="modify?num=${post.num}">수정</a></button>
	                    <form action="/delete" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?')">
						  <input type="hidden" name="num" value="${post.num}" />
						  <button id="deleteBtn">삭제</button>
						</form>
					</sec:authorize>
                </div>
                <div id="replyWrap">
                	<input type="hidden" id="num" value="${post.num}">
                    <div id="replyList"></div> <!-- 댓글 목록 출력 -->
                    <sec:authorize access="!isAuthenticated()">
                    	<p style="text-align:center;">로그인 후 댓글을 작성해주세요 :)</p>
                    </sec:authorize>
                    <sec:authorize access="isAuthenticated()">
	                    <div id="myReplyWrap">
	                        <div>	                            
	                            <input type="text" class="replyer" name="replyer" value="${loginUser}" readonly>
	                        </div>
	                        <div id="replycontent">
	                            <textarea id="reply"></textarea>
	                            <button type="button" id="replyBtn">등록</button>
	                        </div>
	                    </div>
                    </sec:authorize>
                    <div id="pagination" style="margin-top: 15px;"></div>
                </div>
            </div>
            
        </section>
        <!-- footer -->
        <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>
    <script>
    var csrfHeader = "${_csrf.headerName}";
    var csrfToken = "${_csrf.token}";
    var loginUser = "${loginUser}";
    var num = $('#num').val();
    var pageSize = 10; // 한 페이지에 댓글 10개
    var currentPage = 1; // 현재 페이지

    // 전역에 선언
    function loadReply(page){
    	currentPage = page || 1;
        $.getJSON('/reply/listPage', {num:num, page:currentPage, size:pageSize}, function(list){
            let html = '';
            $.each(list, function(i, reply){
                html += '<div class="otherReplyWrap">';
                html += '<input type="hidden" value="'+reply.rnum+'">';
                html += '<div class="replyer">'+reply.replyer+'</div>';
                html += '<div id="replyText_'+reply.rnum+'">';
                html += '<div class="otherReply">'+reply.reply+'</div>';
                html += '</div>';
                var formattedDate = moment(reply.replydate).format('YYYY. MM. DD hh:mm');
                html += '<div class="date">'+formattedDate+'</div>';
                if(reply.replyer == loginUser){
                	html += '<div class="replyBottomRow" id="replyBtnRow_'+reply.rnum+'">';
                    html += '<button class="replyEdit" onclick="showUpdate('+reply.rnum+',\''+reply.reply+'\')">수정</button>';
                    html += '<button class="replyDelete" onclick="deleteReply('+reply.rnum+')">삭제</button>';
                    html += '</div>';
                }
                html += '</div>';
            });
            $('#replyList').html(html);
        });
        
     	// 댓글 개수 가져와서 페이지네이션
        $.get('/reply/count', {num:num}, function(res){
        	var count = res.count;  // JSON 객체에서 꺼냄
            renderPagination(count, currentPage, pageSize);
        });
    }
    
 	// 페이지네이션 그리기
    function renderPagination(totalCount, currentPage, pageSize){
        var totalPages = Math.ceil(totalCount / pageSize);
        var pageLimit = 5; // 최대 5개의 페이지 번호
        var startPage = Math.max(1, currentPage - Math.floor(pageLimit/2));
        var endPage = Math.min(totalPages, startPage + pageLimit - 1);

        if(endPage - startPage < pageLimit -1){
            startPage = Math.max(1, endPage - pageLimit +1);
        }

        let html = '';

        if(currentPage > 1){
            html += '<button class="jump" onclick="loadReply(1)">';
            html += '<i class="bi bi-rewind-fill"></i></button>';
        }

        for(var i=startPage; i<=endPage; i++){
            if(i==currentPage){
                html += '<button disabled id="nowp">'+i+'</button>';
            } else {
                html += '<button class="nonp" style="cursor: pointer;" onclick="loadReply('+i+')">'+i+'</button>';
            }
        }

        if(currentPage < totalPages){
            html += '<button class="jump" onclick="loadReply('+totalPages+')">';
            html += '<i class="bi bi-fast-forward-fill"></i></button>';
        }

        $('#pagination').html(html);
    }

    // 페이지 로드 시 실행
    $(function(){
        loadReply(1);

        // 댓글 등록
        $('#replyBtn').click(function(){
            let reply = $('#reply').val();
            let replyer = $('#replyer').val();

            if(reply.trim()==''){
                alert('내용을 입력하세요!');
                return;
            }

            $.ajax({
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                },
                url:'/reply/insert',
                type:'POST',
                contentType:'application/json',
                data: JSON.stringify({
                    num: num,
                    reply: reply,
                    replyer: replyer
                }),
                success:function(){
                    $('#reply').val('');
                    loadReply(1); // 첫 페이지로
                },
                error: function(xhr, status, error){
                    console.error("등록 실패:", error);
                    alert("등록 실패: " + xhr.responseText);
                }
            });
        });
    });

    // 댓글 수정
    function showUpdate(rnum, oldReply){
	    // textarea로 교체
	    let html = '<div id="updatecontent"><textarea id="updateReply">'+oldReply+'</textarea></div>';
	    $('#replyText_'+rnum).html(html);
	
	    // 버튼도 저장/취소로 교체
	    let btnHtml = '';
	    btnHtml += '<button id="saveupdate" onclick="updateReply('+rnum+')">저장</button>';
	    btnHtml += '<button id="cancleupdate" onclick="loadReply('+currentPage+')">취소</button>';
	    $('#replyBtnRow_'+rnum).html(btnHtml);
	}

    // 댓글 수정 저장
    function updateReply(rnum){
        let content = $('#updateReply').val();
        if(content.trim() == ''){
            alert('내용을 입력하세요!');
            return;
        }

        $.ajax({
            beforeSend: function(xhr) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
            },
            url:'/reply/update',
            type:'POST',
            contentType:'application/json',
            data: JSON.stringify({rnum:rnum, reply:content}),
            success:function(){
                loadReply(currentPage);
            },
            error: function(xhr, status, error){
                console.error("수정 실패:", error);
                alert("수정 실패: " + xhr.responseText);
            }
        });
    }

    // 댓글 삭제
    function deleteReply(rnum){
        if(confirm('정말 삭제하시겠습니까?')){
            $.ajax({
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                },
                url:'/reply/delete',
                type:'POST',
                data: JSON.stringify({ rnum: rnum }),
                contentType:'application/json',
                success:function(){
                    loadReply(currentPage);
                },
                error: function(xhr, status, error){
                    console.error("삭제 실패:", error);
                    alert("삭제 실패: " + xhr.responseText);
                }
            });
        }
    }
	</script>
</body>
</html>