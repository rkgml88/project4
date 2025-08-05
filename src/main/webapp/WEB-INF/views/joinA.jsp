<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
	<meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>회원가입 | 관리자</title>
    <link rel="stylesheet" type="text/css" href="resources/css/nav.css">
    <link rel="stylesheet" type="text/css" href="resources/css/footer.css">
    <link rel="stylesheet" type="text/css" href="resources/css/join.css">
    
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
    <script src="resources/js/nav.js"></script>
    <script src="resources/js/join.js"></script>
</head>
<body>
    <div class="wrap">
        <!-- 카테고리 -->
        <jsp:include page="/WEB-INF/views/nav.jsp" />

        <section>
            
            <div class="joinWrap">
            <div id="category">
                <h1>join</h1>
            </div>
                <form action="/joinA" method="post" id="joinFrm">
                	<sec:csrfInput />
                    <div id="joinBox">
                        <input type="text" class="inp" id="id" name="username" placeholder="아이디">
                        <input type="button" class="btn" id="idCheckBtn" value="중복확인">
                        <p class="blue" id="idCheck"></p>
                        <p class="red" id="idErrMsg"></p>
                        <input type="password" class="inp" id="pw" name="password" placeholder="비밀번호">
                        <p class="red" id="pwErrMsg"></p>
                        <input type="password" class="inp" id="pw2" placeholder="비밀번호 재확인">
                        <p class="red" id="pwErrMsg2"></p>
                        <input type="text" class="inp" id="name" name="name" placeholder="이름">
                        <p class="red" id="nameErrMsg"></p>
                        <input type="text" class="inp" id="tel" name="tel" placeholder="전화번호">
                        <p class="red" id="telErrMsg"></p>
                        <input type="email" class="inp" id="email" name="email"  placeholder="이메일">
                        <p class="red" id="emailErrMsg"></p>
                    </div>
                    <div id="chk">
                    	<input type="checkbox" id="marketingYn" name="marketingYn" value="Y">
                        <label for="marketingYn" style="cursor: pointer;">마케팅 알림 동의(선택)</label>                        
                        <!-- <p class="red" id="marketingYnErrMsg"></p> -->
                    </div>
                    <div class="button_final">
                        <input type="submit" value="가입하기">
                    </div>
                </form>
            </div>
        </section>

        <!-- footer -->
        <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>
</body>
</html>