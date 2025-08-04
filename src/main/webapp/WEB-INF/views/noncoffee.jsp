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
    <title>IN COFFEE | MENU</title>
    <link rel="stylesheet" type="text/css" href="resources/css/nav.css">
    <link rel="stylesheet" type="text/css" href="resources/css/footer.css">
    <link rel="stylesheet" type="text/css" href="resources/css/newmenu.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="resources/js/nav.js"></script>
    <style>
        #new a{
            color: rgb(16, 15, 80);
        }
        #coffee a{
            color: rgb(16, 15, 80);
        }
        #noncoffee{
            background-color: rgb(16, 15, 80);
        }
        #noncoffee a{
            color: white;
        }
        #dessert a{
            color: rgb(16, 15, 80);
        }
        .ctgBtn div{
            margin-bottom: 10px;
        }
        #noncoffeeType{
            display: flex;
            flex-wrap: wrap;
            justify-content: right;
            align-items: center;
            border: 1px solid black;
            padding: 10px;
            margin-bottom: 30px;
            gap: 5px;
            font-size: 13px;
            color: rgb(16, 15, 80);
        }
        input[type=checkbox]:checked {
            accent-color: rgb(16, 15, 80);
        }
    </style>
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
                <h1>menu</h1>
            </div>
            <div class="main">
                <!-- 카테고리 버튼 -->
                <jsp:include page="/WEB-INF/views/newmenuNav.jsp" />
                
                <div id="noncoffeeType">
				    <c:set var="selectedTypes" value="${selectedTypes}" />
				    <c:set var="hasType" value="${not empty selectedTypes}" />
				
				    <input type="checkbox" name="types" value="전체" id="전체"
				        <c:if test="${!hasType}">checked</c:if> >
			        <label for="전체" style="cursor: pointer;">전체</label>
				
				    <input type="checkbox" name="types" value="스무디&프라페" id="스무디&프라페"
				        <c:if test="${selectedTypes.contains('스무디&프라페')}">checked</c:if> >
			        <label for="스무디&프라페" style="cursor: pointer;">스무디&프라페</label>
				
				    <input type="checkbox" name="types" value="에이드&주스" id="에이드&주스"
				        <c:if test="${selectedTypes.contains('에이드&주스')}">checked</c:if> >
			        <label for="에이드&주스" style="cursor: pointer;">에이드&주스</label>
				
				    <input type="checkbox" name="types" value="음료" id="음료"
				        <c:if test="${selectedTypes.contains('음료')}">checked</c:if> >
			        <label for="음료" style="cursor: pointer;">음료</label>
				
				    <input type="checkbox" name="types" value="디카페인" id="디카페인"
				        <c:if test="${selectedTypes.contains('디카페인')}">checked</c:if> >
			        <label for="디카페인" style="cursor: pointer;">디카페인</label>
				
				    <input type="checkbox" name="types" value="티" id="티"
				        <c:if test="${selectedTypes.contains('티')}">checked</c:if> >
			        <label for="티" style="cursor: pointer;">티</label>
				</div>

                <!-- 게시글 -->
                <div class="postWrap">
				    <c:choose>
				        <c:when test="${empty noncoffeeList}">
				            <div align="center">등록된 게시물이 없습니다.</div>
				        </c:when>
				        <c:otherwise>
				            <div id="postExist">
				                <c:forEach var="post" items="${noncoffeeList}">
				                    <div class="post" data-category="${post.type}">
			                        	<div class="imgWrap">
			                            	<img src="${pageContext.request.contextPath}${post.thumbnail}" alt="">
			                            </div>
			                            <sec:authorize access="hasRole('ROLE_ADMIN')">
				                            <div class="modDelBtn">
				                                <a href="modify?num=${post.num}"><button id="modBtn">수정</button></a>
				                                <form action="/delete" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?')">
												  <sec:csrfInput />
										  		  <input type="hidden" name="num" value="${post.num}" />
												  <button id="delBtn">삭제</button>
												</form>
				                            </div>
			                            </sec:authorize>
			                            <p>${post.title}</p>
				                    </div>
				                </c:forEach>
				            </div>
				        </c:otherwise>
				    </c:choose>
				</div>
				
                <div id="bottomRow">
				  	<div id="pagination">
					    <c:set var="typesForUrl" value="${empty selectedTypes ? fn:split('전체', ',') : selectedTypes}" />
					
					    <!-- 첫 페이지 이동 버튼 -->
					    <c:url var="firstPageUrl" value="/noncoffee">
						    <c:param name="pageNoncoffee" value="1" />
						    <c:forEach var="t" items="${typesForUrl}">
						        <c:param name="types" value="${t}" />
						    </c:forEach>
						</c:url>
						
						<a class="jump" href="${firstPageUrl}">
						    <i class="bi bi-rewind-fill"></i>
						</a>
					
					    <!-- 페이지 번호 -->
					    <c:forEach begin="${startPage}" end="${endPage}" var="p">
						    <c:url var="pageUrl" value="/noncoffee">
						        <c:param name="pageNoncoffee" value="${p}" />
						        <c:forEach var="t" items="${typesForUrl}">
						            <c:param name="types" value="${t}" />
						        </c:forEach>
						    </c:url>
						    <c:choose>
						        <c:when test="${p == pageNoncoffee}">
						            <span id="nowp">${p}</span>
						        </c:when>
						        <c:otherwise>
						            <a class="nonp" href="${pageUrl}">${p}</a>
						        </c:otherwise>
						    </c:choose>
						</c:forEach>
					
					    <!-- 마지막 페이지 이동 버튼 -->
					    <c:url var="lastPageUrl" value="/noncoffee">
						    <c:param name="pageNoncoffee" value="${noncoffeeTotalPages}" />
						    <c:forEach var="t" items="${typesForUrl}">
						        <c:param name="types" value="${t}" />
						    </c:forEach>
						</c:url>
						
						<a class="jump" href="${lastPageUrl}">
						    <i class="bi bi-fast-forward-fill"></i>
						</a>
					</div>

                    <!-- 글쓰기 버튼 -->
                    <sec:authorize access="hasRole('ROLE_ADMIN')">
                    	<button id=writeBtn><a href="write">글쓰기</a></button>
                    </sec:authorize>
                </div>
            </div>
        </section>
        <!-- footer -->
        <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>
<script>
document.querySelectorAll('input[name="types"]').forEach(cb => {
    cb.addEventListener('change', function () {
        const checkboxes = document.querySelectorAll('input[name="types"]');
        const allCheckbox = Array.from(checkboxes).find(cb => cb.value === '전체');

        if (this.value === '전체' && this.checked) {
            checkboxes.forEach(cb => { if (cb.value !== '전체') cb.checked = false; });
        }

        if (this.value !== '전체' && this.checked) {
            allCheckbox.checked = false;
        }

        const selected = Array.from(checkboxes)
            .filter(cb => cb.checked && cb.value !== '전체')
            .map(cb => cb.value);

        const params = new URLSearchParams();
        // 선택 없으면 '전체' 추가
        if (selected.length === 0) {
            params.append('types', '전체');
        } else {
            selected.forEach(type => params.append('types', type));
        }

        location.href = '/noncoffee?' + params.toString();
    });
});
</script>

</body>
</html>