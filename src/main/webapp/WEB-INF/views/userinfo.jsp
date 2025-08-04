<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link rel="stylesheet" type="text/css" href="resources/css/nav.css">
    <link rel="stylesheet" type="text/css" href="resources/css/footer.css">
    <link rel="stylesheet" type="text/css" href="resources/css/userinfo.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="resources/js/nav.js"></script>
    <title>IN COFFEE | 회원 정보</title>
</head>
<body>
	<div class="wrap">
	<!-- 카테고리 -->
    <jsp:include page="/WEB-INF/views/nav.jsp" />
    
    <section>        
        <div id="contain">
            <div id="category">
                <h1>회원 정보</h1>
            </div>
            <form id="updateForm" action="/update" method="post">
            <sec:csrfInput />
            <div id="main">           	
                <div id="nameWrap">
                    <input type="text" id="name" name="name" value="${member.name}" readonly>
                    <input type="text" id="username" name="username" value="${member.username}" readonly>
                </div>
                <div id="infoWrap">
                	<input type="text" class="inp" id="tel" name="tel" value="${member.tel}" readonly>
                	<input type="email" class="inp" id="email" name="email" value="${member.email}" readonly>
                	<div class="inp" id="addWrap">
                		<div id="postcodeWrap">
		                	<input type="text" id="sample6_postcode" name="postcode" value="${member.postcode}" readonly>
		                	<input type="button" id="postBtn" value="검색" onclick="sample6_execDaumPostcode()" style="display:none;">
	                	</div>
	                	<input type="text" id="sample6_address" name="address1" value="${member.address1}" readonly>
	                	<input type="hidden" id="sample6_extraAddress">
	                	<input type="text" id="sample6_detailAddress" name="address2" value="${member.address2}" readonly>
                	</div>
                </div>
                <div id="bottomRow">
                    <button type="button" id=editBtn onclick="enableEdit()">수정</button>
                    <button type="button" id="cancelBtn" onclick="cancelEdit()" style="display:none;">취소</button>
                </div>
            </div>
            </form>
            <form action="/deleteMember" method="post" onsubmit="return confirm('정말 탈퇴하시겠습니까?')">
           		<sec:csrfInput />
                <input type="hidden" name="username" value="${member.username}" />
                <button id="deleteBtn">회원탈퇴 <i class="bi bi-person-x-fill"></i></button>
            </form>
        </div>
    </section>    
    <!-- footer -->
    <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>
<script>
let originalValues = {};

function enableEdit() {
    // input 요소들 선택
    const inputs = document.querySelectorAll('#updateForm input');

    // 변경 전 값 저장
    inputs.forEach(input => {
        if (input.name) { // name이 있는 input만
            originalValues[input.name] = input.value;
        }
    });

    // readonly 해제
    inputs.forEach(input => {
        if (input.name !== 'username' &&
       		input.name !== 'postcode' &&
       		input.name !== 'address1'
        ) { // username 제외
            input.removeAttribute('readonly');
        }
    });

    // postBtn 보이기
    document.getElementById('postBtn').style.display = 'inline-block';
    
    document.getElementById('name').focus();

    // 버튼 변경
    const editBtn = document.getElementById('editBtn');
    editBtn.textContent = '저장';
    editBtn.onclick = submitUpdate;

    // 취소 버튼 보이기
    document.getElementById('cancelBtn').style.display = 'inline-block';
}

function submitUpdate() {
    document.getElementById('updateForm').submit();
}

function cancelEdit() {
    // input 요소들 선택
    const inputs = document.querySelectorAll('#updateForm input');

    // 변경 전 값 복원
    inputs.forEach(input => {
        if (input.name && originalValues.hasOwnProperty(input.name)) {
            input.value = originalValues[input.name];
        }
    });

    // readonly 다시 설정
    inputs.forEach(input => {
        if (input.name !== 'username') {
            input.setAttribute('readonly', true);
        }
    });

    // postBtn 숨기기
    document.getElementById('postBtn').style.display = 'none';

    // 버튼 되돌림
    const editBtn = document.getElementById('editBtn');
    editBtn.textContent = '수정';
    editBtn.onclick = enableEdit;

    // 취소 버튼 숨기기
    document.getElementById('cancelBtn').style.display = 'none';
}

function sample6_execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 조합된 참고항목을 해당 필드에 넣는다.
                document.getElementById("sample6_extraAddress").value = extraAddr;
            
            } else {
                document.getElementById("sample6_extraAddress").value = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('sample6_postcode').value = data.zonecode;
            document.getElementById("sample6_address").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("sample6_detailAddress").focus();
        }
    }).open();
}
</script>
    
</body>
</html>