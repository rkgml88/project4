<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        #new{
            background-color: rgb(16, 15, 80);
        }
        #new a{
            color: white;
        }
        #coffee a{
            color: rgb(16, 15, 80);
        }
        #noncoffee a{
            color: rgb(16, 15, 80);
        }
        #dessert a{
            color: rgb(16, 15, 80);
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
                
                <!-- 게시글 -->
                <div class="postWrap">
				    <c:choose>
				        <c:when test="${empty newmenuList}">
				            <div align="center">등록된 게시물이 없습니다.</div>
				        </c:when>
				        <c:otherwise>
				            <div id="postExist">
				                <c:forEach var="post" items="${newmenuList}">
				                    <div class="post">
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
					    <!-- 첫 페이지 이동 버튼 -->
					    <c:if test="${pageNewmenu > 1}">
					      <a class="jump" href="?pageNewmenu=1">
					      	<i class="bi bi-rewind-fill"></i>
					      </a>
					    </c:if>
					
					    <!-- 페이지 번호 버튼 -->
					    <c:forEach begin="${startPage}" end="${endPage}" var="p">
					      <c:choose>
					        <c:when test="${p == pageNewmenu}">
					          <span id="nowp">${p}</span> <!-- 현재 페이지는 굵게 표시 -->
					        </c:when>
					        <c:otherwise>
					          <a class="nonp" href="?pageNewmenu=${p}">${p}</a>
					        </c:otherwise>
					      </c:choose>
					    </c:forEach>
					
					    <!-- 마지막 페이지 이동 버튼 -->
					    <c:if test="${pageNewmenu < newmenuTotalPages}">
					      <a class="jump" href="?pageNewmenu=${newmenuTotalPages}">
					      	<i class="bi bi-fast-forward-fill"></i>
					      </a>
					    </c:if>
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
</body>
</html>