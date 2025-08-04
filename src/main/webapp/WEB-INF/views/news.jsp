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
    <title>IN COFFEE | NEWS</title>
    <link rel="stylesheet" type="text/css" href="resources/css/nav.css">
    <link rel="stylesheet" type="text/css" href="resources/css/footer.css">
    <link rel="stylesheet" type="text/css" href="resources/css/news.css">
    <link rel="stylesheet" type="text/css" href="resources/css/incoffeeNews.css">
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
                
                <!-- 공지사항 -->
                <div class="subT">
                	<h3>NOTICE</h3>
	                <h4>
					    <c:if test="${pageNotice > 1}">
					      <a href="?pageNotice=${pageNotice - 1}&pageNews=${pageNews}&search=${search}">&lt;</a>
					    </c:if>
					    <c:if test="${pageNotice < noticeTotalPages}">
					      <a href="?pageNotice=${pageNotice + 1}&pageNews=${pageNews}&search=${search}">&gt;</a>
					    </c:if>
				    </h4>
			    </div>
                <div class="notice">
                    <c:forEach var="post" items="${noticeList}" varStatus="status">
				        <div class="accordion-item">
				            <div class="accordion-header">
				            	<div class="bno">
				            		${noticeTotal - ((pageNotice - 1) * pageSize + status.index)}
				            	</div>
				            	<div class="btitle">${post.title}</div>
				            	<sec:authorize access="!hasRole('ROLE_ADMIN')">
				            		<div class="plus">+</div>
				            	</sec:authorize>            	
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
			            	</div>
				            <div class="accordion-content">
				                <c:out value="${post.content}" escapeXml="false"/>
				            </div>
				        </div>
				    </c:forEach>
				    <c:if test="${empty noticeList}">
				        <p>등록된 공지사항이 없습니다.</p>
				    </c:if>
                </div>
                
                <!-- 게시글 -->
                <div class="subT"><h3>INCOFFEE NEWS</h3></div>
                <div class="posts">
                    <table>
                    	<tbody id="postTableBody">
                        <c:forEach var="post" items="${newsList}" varStatus="status">
			                <tr>
			                	<td width="10%">${newsTotal - ((pageNews - 1) * pageSize + status.index)}</td>
			                    <td>
			                    	<a href="${pageContext.request.contextPath}/view?num=${post.num}">
			                    		${post.title}
		                    		</a>
	                    		</td>
			                    <td width="10%"><fmt:formatDate value="${post.postdate}" pattern="MM-dd"/></td>
			                </tr>
			            </c:forEach>
			            <c:if test="${empty newsList}">
			                <tr>
			                    <td colspan="3" align="center">등록된 게시물이 없습니다.</td> 
			                </tr>
			            </c:if>
                        </tbody>
                    </table>
                </div>
                
                <div id="bottomRow">
                    <!-- 검색창 -->
                    <form method="get" id="searchFrm" action="/news">
                    	<sec:csrfInput />
                    	<input type="hidden" name="pageNotice" value="1">
    					<input type="hidden" name="pageNews" value="1">
                        <input type="text" name="search" id="search" placeholder="검색" value="${search}">
                        <input type="submit" value="검색" id="searchBtn">
                    </form>
                    
					<div id="pagination">
					    <!-- 첫 페이지 이동 버튼 -->
					    <c:if test="${pageNews > 1}">
					      <a class="jump" href="?pageNews=1&pageNotice=${pageNotice}&search=${search}">
					      	<i class="bi bi-rewind-fill"></i>
					      </a>
					    </c:if>
					
					    <!-- 페이지 번호 버튼 -->
					    <c:forEach begin="${startPage}" end="${endPage}" var="p">
					      <c:choose>
					        <c:when test="${p == pageNews}">
					          <span id="nowp">${p}</span>
					        </c:when>
					        <c:otherwise>
					          <a class="nonp" href="?pageNews=${p}&pageNotice=${pageNotice}&search=${search}">${p}</a>
					        </c:otherwise>
					      </c:choose>
					    </c:forEach>
					
					    <!-- 마지막 페이지 이동 버튼 -->
					    <c:if test="${pageNews < newsTotalPages}">
					      <a class="jump" href="?pageNews=${newsTotalPages}&pageNotice=${pageNotice}&search=${search}">
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
<script>
document.addEventListener('DOMContentLoaded', () => {
	  const headers = document.querySelectorAll('.accordion-header');

	  headers.forEach(header => {
	    header.addEventListener('click', () => {
	      const item = header.parentElement;
	      item.classList.toggle('active');
	    });
	  });
	});

</script>
</body>
</html>