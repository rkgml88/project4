<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IN COFFEE | NEWS</title>
    <link rel="stylesheet" type="text/css" href="resources/css/nav.css">
    <link rel="stylesheet" type="text/css" href="resources/css/footer.css">
    <link rel="stylesheet" type="text/css" href="resources/css/news.css">
    <link rel="stylesheet" type="text/css" href="resources/css/event.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="resources/js/nav.js"></script>
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
                <jsp:include page="/WEB-INF/views/newsNav.jsp" />
                
                <div id="eventSltWrap">
                    <!-- 이벤트 현황 선택창 -->
                    <select name="eventSlt" id="eventSlt">
					    <option value="전체" <c:if test="${selectedType == '전체'}">selected</c:if>>전체</option>
					    <option value="진행중" <c:if test="${selectedType == '진행중'}">selected</c:if>>진행중인 이벤트</option>
					    <option value="종료" <c:if test="${selectedType == '종료'}">selected</c:if>>종료된 이벤트</option>
					</select>
                </div>
                <!-- 게시글 -->
                <div class="postWrap">
				    <c:choose>
				        <c:when test="${empty eventList}">
				            <div align="center">등록된 게시물이 없습니다.</div>
				        </c:when>
				        <c:otherwise>
				            <div id="postExist">
				                <c:forEach var="post" items="${eventList}">
				                    <div class="post ${post.type}">
				                        <a href="view?num=${post.num}">
				                            <img src="${pageContext.request.contextPath}${post.thumbnail}" alt="">
				                            <p>${post.title}</p>
				                        </a>
				                    </div>
				                </c:forEach>
				            </div>
				        </c:otherwise>
				    </c:choose>
				</div>
				
                <div id="bottomRow">
                    <!-- 검색창 -->
                    <form method="get" id="searchFrm" action="/event">
                    	<sec:csrfInput />
                    	<input type="hidden" name="pageNotice" value="1">
    					<input type="hidden" name="pageNews" value="1">
                        <input type="text" name="search" id="search" placeholder="검색" value="${search}">
                        <input type="submit" value="검색" id="searchBtn">
                    </form>
                    
					<div id="pagination">
					    <c:set var="typesForUrl" value="${empty selectedTypes ? fn:split('전체', ',') : selectedTypes}" />
					
					    <!-- 첫 페이지 이동 버튼 -->
					    <c:if test="${pageEvent > 1}">
						  <a class="jump" href="?pageEvent=1
						      <c:forEach var='t' items='${typesForUrl}'>&types=${t}</c:forEach>
						      &search=${search}">
						      	<i class="bi bi-rewind-fill"></i>
					      </a>
						</c:if>
					
					    <!-- 페이지 번호 -->
					    <c:forEach begin="${startPage}" end="${endPage}" var="p">
						    <c:url var="pageUrl" value="/event">
						        <c:param name="pageEvent" value="${p}" />
						        <c:forEach var="t" items="${typesForUrl}">
						            <c:param name="types" value="${t}" />
						        </c:forEach>
						        <c:param name="search" value="${search}" />
						    </c:url>
						    <c:choose>
						        <c:when test="${p == pageEvent}">
						            <span id="nowp">${p}</span>
						        </c:when>
						        <c:otherwise>
						            <a class="nonp" href="${pageUrl}">${p}</a>
						        </c:otherwise>
						    </c:choose>
						</c:forEach>
					
					    <!-- 마지막 페이지 이동 버튼 -->
					    <c:if test="${pageEvent < eventTotalPages}"> 
						  <a class="jump" href="?pageEvent=${eventTotalPages}
						      <c:forEach var='t' items='${typesForUrl}'>&types=${t}</c:forEach>
						      &search=${search}">
						      	<i class="bi bi-fast-forward-fill"></i>
				      	  </a>
						</c:if>
				   </div>
				
				
                   <!-- 글쓰기 버튼 -->
                   <sec:authorize access="hasRole('ROLE_ADMIN')">
                   	<button id=writeBtn><a href="write?category=News&subCategory=이벤트">글쓰기</a></button>
                   </sec:authorize>
               	</div>
             </div>
        </section>
        <!-- footer -->
        <jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
    <script>
    document.getElementById("eventSlt").addEventListener("change", function () {
        const selected = this.value;
        
     	// 현재 URL의 search 파라미터 가져오기
        const urlParams = new URLSearchParams(window.location.search);
        const currentSearch = urlParams.get("search");
        
        const params = new URLSearchParams();
        params.append("pageEvent", 1); // 새로 선택 시 1페이지로
        
        if (selected !== "전체") {
            params.append("type", selected);
        }
        
     	// 기존 search가 있으면 추가
        if (currentSearch && currentSearch.trim() !== "") {
            params.append("search", currentSearch);
        }
        
        location.href = "/event?" + params.toString();
    });
    </script>
</body>
</html>