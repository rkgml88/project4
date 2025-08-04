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
    
<script>
$(function(){
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");

    $(document).ajaxSend(function(e, xhr, options) {
        xhr.setRequestHeader(header, token);
    });
});
//폼 제출 시 유효성 검사
$(document).ready(function(){
	// 적절한 값이 입력되면 에러메시지 제거
	$("#id").on("input", function () {
		this.value = this.value.replace(/[^A-Za-z0-9]/g, "");
	    if (/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,20}$/.test(this.value)) {
	        $("#idErrMsg").html("");
	    }
	});
	
	$("#pw").on("input", function () {
	    if (/^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()\-_=+{}\[\]:;"'<>,.?/~`|\\])[A-Za-z\d!@#$%^&*()\-_=+{}\[\]:;"'<>,.?/~`|\\]{8,25}$/.test(this.value)) {
	        $("#pwErrMsg").html("");
	    }
	});
	
	$("#pw2").on("input", function () {
	    if ($(this).val().trim() == $("#pw").val().trim()) {
	        $("#pwErrMsg2").html("");
	    }
	});
	
	let idCheckDone = false;   // 중복확인 완료 여부
	let canUseId = false;      // 사용 가능한 아이디인지 여부
	
	// 중복확인 버튼 클릭 시
	$("#idCheckBtn").on("click", function () {
		console.log("중복확인 버튼 클릭됨");
	
	    let username = $("#id").val().trim();
	    $("#idErrMsg").html(""); // 이전 에러 제거
	
	    if (!username) {
	        $("#idErrMsg").html("아이디를 입력해 주십시오.");
	        return;
	    } else if (!/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,20}$/.test(username)) {
            $("#idErrMsg").html("아이디는 영문자, 숫자 조합(5~20자리)이어야 합니다.");
            return;
        }
	    
	    $.ajax({
	        url: "/checkUsername",   // Spring 컨트롤러에서 처리할 URL
	        method: "POST",
	        data: { username: username },
	        success: function (result) {
	            idCheckDone = true;
	            if (result === "OK") {
	                canUseId = true;
	                $("#idCheck").html("사용 가능한 아이디입니다.").css("color", "darkblue");
	            } else {
	                canUseId = false;
	                $("#idCheck").html("사용할 수 없는 아이디입니다.").css("color", "darkred");
	            }
	        },
	        error: function () {
	            alert("서버 오류가 발생했습니다. 다시 시도해주세요.");
	        }
	    });
	});
	
    $("#joinFrm").on("submit", function (e) {
        e.preventDefault();

        let isValid = true;
        const id = $("#id").val().trim();
        const pw = $("#pw").val().trim();
        const pw2 = $("#pw2").val().trim();

        // 에러 초기화
        $("#idErrMsg, #pwErrMsg, #pwErrMsg2").html("");

        if (!id) {
            $("#idErrMsg").html("아이디를 입력해 주십시오.");
            isValid = false;
        } else if (!/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,20}$/.test(id)) {
            $("#idErrMsg").html("아이디는 영문자, 숫자 조합(5~20자리)이어야 합니다.");
            isValid = false;
        }

        if (!pw) {
            $("#pwErrMsg").html("비밀번호를 입력해 주십시오.");
            isValid = false;
        } else if (!/^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()\-_=+{}\[\]:;"'<>,.?/~`|\\])[A-Za-z\d!@#$%^&*()\-_=+{}\[\]:;"'<>,.?/~`|\\]{8,25}$/.test(pw)) {
            $("#pwErrMsg").html("비밀번호는 영문자, 숫자, 특수기호 조합(8~25자리)이어야 합니다.");
            isValid = false;
        }

        if (!pw2) {
            $("#pwErrMsg2").html("비밀번호를 재확인해 주십시오.");
            isValid = false;
        } else if (pw != pw2) {
            $("#pwErrMsg2").html("비밀번호가 일치하지 않습니다.");
            isValid = false;
        }

        if (isValid) {
            this.submit(); // ← 검증 통과 시 폼 제출
        }
    });
});

</script>
</body>
</html>