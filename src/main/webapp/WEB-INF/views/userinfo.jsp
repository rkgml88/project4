<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                    <p class="red" id="nameErrMsg"></p>
                    <input type="text" id="username" name="username" value="${member.username}" readonly>
                </div>
                <div id="infoWrap">
                	<div id="telWrap">
	                	<i class="bi bi-phone tel-icon"></i>
	                	<input type="text" class="inp" id="tel" name="tel" value="${member.tel}" readonly>
	                	<p class="red" id="telErrMsg"></p>
                	</div>
                	<div id="emailWrap">
	                	<i class="bi bi-envelope email-icon"></i>
	                	<input type="email" class="inp" id="email" name="email" value="${member.email}" readonly>
	                	<p class="red" id="emailErrMsg"></p>
                	</div>
                	<div class="inp" id="addWrap">
                		<div id="postcodeWrap">
		                	<input type="text" id="sample6_postcode" name="postcode" value="${member.postcode}" readonly placeholder="우편번호(선택)">
		                	<input type="button" id="postBtn" value="검색" onclick="sample6_execDaumPostcode()" style="display:none;">
	                	</div>
	                	<input type="text" id="sample6_address" name="address1" value="${member.address1}" readonly placeholder="지번/도로명 주소">
	                	<input type="hidden" id="sample6_extraAddress">
	                	<input type="text" id="sample6_detailAddress" name="address2" value="${member.address2}" readonly placeholder="상세주소">
                	</div>
                	<div id="chk">
					    <input type="checkbox" id="marketingYn" name="marketingYn" value="Y" disabled
					        <c:if test="${member.marketingYn eq 'Y'}">checked</c:if>>
					    <label for="marketingYn" style="cursor: pointer;">마케팅 알림 동의(선택)</label>
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
        
         	// 💡 전화번호 하이픈 제거
            if (input.name === 'tel') {
                input.value = input.value.replace(/-/g, '');
            }
        }
    });
    
 	// 체크박스 활성화
    document.getElementById('marketingYn').removeAttribute('disabled');

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

function cancelEdit() {
    // input 요소들 선택
    const inputs = document.querySelectorAll('#updateForm input');

    // 변경 전 값 복원
    inputs.forEach(input => {
        if (input.name && originalValues.hasOwnProperty(input.name)) {
        	if (input.type === 'checkbox') {
                input.checked = originalValues[input.name] === "Y";
            } else {
                input.value = originalValues[input.name];
            }
        }
    });

    // readonly 다시 설정
    inputs.forEach(input => {
        if (input.name !== 'username') {
            input.setAttribute('readonly', true);
        }
    });
    
 	// 체크박스 비활성화
    document.getElementById('marketingYn').setAttribute('disabled', true);

    // postBtn 숨기기
    document.getElementById('postBtn').style.display = 'none';

    // 버튼 되돌림
    const editBtn = document.getElementById('editBtn');
    editBtn.textContent = '수정';
    editBtn.onclick = enableEdit;

    // 취소 버튼 숨기기
    document.getElementById('cancelBtn').style.display = 'none';
}

// 유효성 검사
function validateAndSubmitForm() {
    let isValid = true;

    const name = $("#name").val().trim();
    const tel = $("#tel").val().trim().replace(/-/g, "");  // 하이픈 제거
    const email = $("#email").val().trim();

    $("#nameErrMsg, #telErrMsg, #emailErrMsg").html("");

    if (!name) {
        $("#nameErrMsg").html("이름을 입력해 주십시오.");
        isValid = false;
    }

    if (!tel) {
        $("#telErrMsg").html("전화번호를 입력해 주십시오.");
        isValid = false;
    } else if (!/^\d{8,11}$/.test(tel)) {
        $("#telErrMsg").html("전화번호는 숫자만 8~11자리 입력해 주십시오.");
        isValid = false;
    }

    if (!email) {
        $("#emailErrMsg").html("이메일을 입력해 주십시오.");
        isValid = false;
    }

    if (isValid) {
        if (!$("input[name='marketingYn']").is(":checked")) {
            $("#updateForm").append('<input type="hidden" name="marketingYn" value="N">');
        }
        
     	// 하이픈 제거
        $("#tel").val($("#tel").val().replace(/-/g, ""));

        document.getElementById("updateForm").submit(); // DOM 방식도 가능
    }
}

function submitUpdate() {
    validateAndSubmitForm();  // 유효성 검사 포함
}

// 실시간 입력 유효성 체크
$("#tel").on("input", function () {
    this.value = this.value.replace(/[^0-9]/g, "");
    if (/^\d{8,11}$/.test(this.value)) {
        $("#telErrMsg").html("");
    }
});

$("#name").on("input", function () {
    if ($(this).val().trim() !== "") {
        $("#nameErrMsg").html("");
    }
});

$("#email").on("input", function () {
    if ($(this).val().trim() !== "") {
        $("#emailErrMsg").html("");
    }
});


document.addEventListener("DOMContentLoaded", function () {
    const telInput = document.getElementById("tel");
    
    if (telInput && telInput.readOnly) {
        const raw = telInput.value.replace(/[^0-9]/g, "");

        if (raw.length === 11) {
        	telInput.value = raw.replace(/^(\d{3})(\d{4})(\d{4})$/, "$1-$2-$3");
        } else if (raw.length === 10) {
            if (raw.startsWith("02")) {
            	telInput.value = raw.replace(/^(\d{2})(\d{4})(\d{4})$/, "$1-$2-$3");
            } else {
            	telInput.value = raw.replace(/^(\d{3})(\d{3})(\d{4})$/, "$1-$2-$3");
            }
        } else if (raw.length === 9 && raw.startsWith("02")) {
        	telInput.value = raw.replace(/^(\d{2})(\d{3})(\d{4})$/, "$1-$2-$3");
        }
    }
    
   //입력 중 자동 하이픈 (수정모드 중일 때만)
    telInput.addEventListener("input", function () {
        if (!this.readOnly) {  // 수정모드일 때만 자동 하이픈 적용
            let raw = this.value.replace(/[^0-9]/g, "");

            if (raw.length <= 10) {
                // 10자리 번호 (지역번호 포함)
                if (raw.startsWith("02") && raw.length >= 9) {
                    // 02 지역번호
                    this.value = raw.replace(/^(\d{2})(\d{3,4})(\d{4})$/, "$1-$2-$3");
                } else if (raw.length >= 10) {
                    // 3자리 지역번호
                    this.value = raw.replace(/^(\d{3})(\d{3,4})(\d{4})$/, "$1-$2-$3");
                } else {
                    this.value = raw;
                }
            } else if (raw.length === 11) {
                // 휴대폰 번호
                this.value = raw.replace(/^(\d{3})(\d{4})(\d{4})$/, "$1-$2-$3");
            } else {
                this.value = raw; // 포맷 안 맞으면 그대로
            }
        }
    });
});


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