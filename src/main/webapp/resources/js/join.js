/**
 * 
 */
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

$(function(){
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");

    $(document).ajaxSend(function(e, xhr, options) {
        xhr.setRequestHeader(header, token);
    });
});

// 폼 제출 시 유효성 검사
$(document).ready(function(){
		// 적절한 값이 입력되면 에러메시지 제거
		$("#id").on("input", function () {
		    this.value = this.value.replace(/[^A-Za-z0-9]/g, "");
		
		    // 아이디 입력이 바뀌면 중복확인 상태를 무효화
		    idCheckDone = false;
		    canUseId = false;
		
		    // 메시지도 초기화
		    $("#idErrMsg").html("");
		    $("#idCheck").html("");
		
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
    	
    	/*$("#postcode").on("input", function () {
    	    if ($(this).val().trim() !== "") {
    	        $("#addrErrMsg").html("");
    	    }
    	});*/
    	
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

	// 입력 중 자동 하이픈
    var $telInput = $("#tel");
    
    $telInput.on("input", function() {
        var raw = $(this).val().replace(/[^0-9]/g, "");

        if (raw.length <= 10) {
            if (raw.startsWith("02") && raw.length >= 9) {
                $(this).val(raw.replace(/^(\d{2})(\d{3,4})(\d{4})$/, "$1-$2-$3"));
            } else if (raw.length >= 10) {
                $(this).val(raw.replace(/^(\d{3})(\d{3,4})(\d{4})$/, "$1-$2-$3"));
            } else {
                $(this).val(raw);
            }
        } else if (raw.length === 11) {
            $(this).val(raw.replace(/^(\d{3})(\d{4})(\d{4})$/, "$1-$2-$3"));
        } else {
            $(this).val(raw);
        }
    });
    
    $("#joinFrm").on("submit", function (e) {
        e.preventDefault();

        let isValid = true;
        const id = $("#id").val().trim();
        const pw = $("#pw").val().trim();
        const pw2 = $("#pw2").val().trim();
        const name = $("#name").val().trim();
        const tel = $("#tel").val().trim();
        const email = $("#email").val().trim();
        // const postcode = $("#sample6_postcode").val().trim();
        const marketingYn = $("input[name='marketingYn']:checked").val();

        // 에러 초기화
        $("#idErrMsg, #pwErrMsg, #pwErrMsg2, #nameErrMsg, #telErrMsg, #emailErrMsg, #addrErrMsg").html("");

        if (!id) {
            $("#idErrMsg").html("아이디를 입력해 주십시오.");
            isValid = false;
        } else if (!idCheckDone) {
	        $("#idErrMsg").html("아이디 중복 검사를 해주십시오.");
	        isValid = false;
	    } else if (!canUseId) {
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
        
        if (!name) {
            $("#nameErrMsg").html("이름을 입력해 주십시오.");
            isValid = false;
        }
        
		const telRaw = tel.replace(/-/g, "");
        if (!tel) {
            $("#telErrMsg").html("전화번호를 입력해 주십시오.");
            isValid = false;
        } else if (!/^\d{8,11}$/.test(telRaw)) {
            $("#telErrMsg").html("전화번호는 숫자만 8~11자리 입력해 주십시오.");
            isValid = false;
        }
        
        if (!email) {
            $("#emailErrMsg").html("이메일을 입력해 주십시오.");
            isValid = false;
        }
        
        /*if (!postcode) {
            $("#addrErrMsg").html("주소를 입력해 주십시오.");
            isValid = false;
        }
        
        if (!agree) {
            $("#agreeErrMsg").html("약관에 동의해 주십시오.");
            isValid = false;
        }*/

        if (isValid) {
        	if (!$("input[name='marketingYn']").is(":checked")) {
		        $("#joinFrm").append('<input type="hidden" name="marketingYn" value="N">');
		    }
		    
		    // 하이픈 제거
        	$("#tel").val($("#tel").val().replace(/-/g, ""));
		    
            this.submit();
        }
    });
});
