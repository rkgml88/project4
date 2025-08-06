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
    <title>IN COFFEE | 글쓰기</title>
    <link rel="stylesheet" type="text/css" href="resources/css/nav.css">
    <link rel="stylesheet" type="text/css" href="resources/css/write.css">
    <script src="resources/js/nav.js"></script>
    <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
    <script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.js"></script>    
</head>
<body>
	<div class="wrap">
		<!-- 카테고리 -->
	    <jsp:include page="/WEB-INF/views/nav.jsp" />
	    
	    <section>    
		    <h1 id="mainT">IN COFFEE | 글쓰기</h1>
		    <div name="writeFrm">
		        <h3 class="subT">Title</h3>
		        <div id="titleSlt">
		            <select name="ctgSlt" class="box" id="ctgSlt">
		                <option value="News">News</option>
		                <option value="Menu">Menu</option>
		                <option value="Store">Store</option>
		            </select>
		            <select name="subCtgSlt" class="box" id="subCtgSlt"></select>
		            <select name="typeSlt" class="box" id="typeSlt" disabled></select>
		        </div>
		        <input class="box" id="title" type="text" name="title" placeholder="제목(제품명)을 입력하세요">
		        <h3 class="subT">Content</h3>
		        <div id="editor"></div>
		        <p class="blue"><i class="bi bi-exclamation-square"></i> 제일 첫번째 이미지가 썸네일이 됩니다.</p>
		        <button type="button" onclick="savePost()" id="submitBtn">등록</button>
		        <button type="button" onclick="goBack()" id="backBtn">목록</button>
		    </div>
	    </section>
    </div>
<script src="resources/js/write.js"></script>
<script>
var csrfHeader = "${_csrf.headerName}";
var csrfToken = "${_csrf.token}";

function goBack() {
    window.history.back();
}

// 카테고리 셀렉트 박스 연동
document.addEventListener('DOMContentLoaded', function () {
    const ctgSlt = document.getElementById('ctgSlt');
    const subCtgSlt = document.getElementById('subCtgSlt');
    const typeSlt = document.getElementById('typeSlt');   

    const categoryParam = '<%= request.getParameter("category") != null ? request.getParameter("category") : "" %>';
    const subCategoryParam = '<%= request.getParameter("subCategory") != null ? request.getParameter("subCategory") : "" %>';

    const subCtgOptions = {
        News: [
            { value: 'INCOFFEE소식', text: 'INCOFFEE 소식' },
            { value: '이벤트', text: '이벤트' }
        ],
        Menu: [
            { value: '신메뉴', text: '신메뉴' },
            { value: '커피', text: '커피' },
            { value: '논커피', text: '논커피' },
            { value: '디저트', text: '디저트' }
        ],
        Store: [
            { value: '원두', text: '원두' },
            { value: '머그컵/텀블러', text: '머그컵/텀블러' }
        ]
    };

    const typeOptions = {
        INCOFFEE소식: [
            { value: '공지사항', text: '공지사항' },
            { value: 'INCOFFEE소식', text: 'INCOFFEE 소식' }
        ],
        이벤트: [
            { value: '진행중', text: '진행중인 이벤트' },
            { value: '종료', text: '종료된 이벤트' }
        ],
        논커피: [
            { value: '스무디&프라페', text: '스무디&프라페' },
            { value: '에이드&주스', text: '에이드&주스' },
            { value: '음료', text: '음료' },
            { value: '디카페인', text: '디카페인' },
            { value: '티', text: '티' }
        ]
    };
    
    function updateSelect(selectElement, options) {
        selectElement.innerHTML = '';
        options.forEach(opt => {
            const option = document.createElement('option');
            option.value = opt.value;
            option.textContent = opt.text;
            selectElement.appendChild(option);
        });
    }

    function updateSubCtg(selectedSubCategory = null) {
        const ctgValue = ctgSlt.value;
        const options = subCtgOptions[ctgValue] || [];
        updateSelect(subCtgSlt, options);
        
        if (selectedSubCategory) {
            subCtgSlt.value = selectedSubCategory;
        }
        
        updateTypeSlt(); // 초기화
    }

    function updateTypeSlt() {
        const subCtgValue = subCtgSlt.value;
        const options = typeOptions[subCtgValue];

        if (options) {
            updateSelect(typeSlt, options);
            typeSlt.disabled = false;
        } else {
            typeSlt.innerHTML = '';
            typeSlt.disabled = true;
        }
    }

    ctgSlt.addEventListener('change', updateSubCtg);
    subCtgSlt.addEventListener('change', updateTypeSlt);

    // 초기화
    if (categoryParam) {
        ctgSlt.value = categoryParam;
        updateSubCtg(subCategoryParam);  // 여기에 인자 넘기기
    } else {
        updateSubCtg();  // 기본 초기화
    }
});

// toastui Editor
const editor = new toastui.Editor({
    el: document.querySelector('#editor'),
    height: '500px',
    initialEditType: 'wysiwyg',
    previewStyle: 'vertical',
    hideModeSwitch: true,
    language: 'ko',
    hooks: {
        addImageBlobHook: function(blob, callback) {
        	const formData = new FormData();
            formData.append('file', blob);
            
            var contextPath = '${pageContext.request.contextPath}';
            $.ajax({
                url: contextPath + '/board/uploadFile',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                dataType: 'json',
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                },
                success: function(res) {
                	console.log("이미지 업로드 성공, 반환 URL:", res.url);
                    callback(res.url, '업로드 파일');
                },
                error: function() {
                    alert('업로드 실패');
                }
            });
        }
    }
});

// 게시글 저장
function savePost() {	
	const title = $('#title').val();
    const content = editor.getHTML();
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = content;
    const firstImg = tempDiv.querySelector('img');
    const thumbnail = firstImg ? firstImg.src : null;

    console.log("썸네일 URL:", thumbnail);
    
    const ctg = ctgSlt.value;
    const subCtg = subCtgSlt.value;
    const type = typeSlt.disabled ? null : typeSlt.value;

    if (!title) {
        alert('제목을 입력하세요.');
        return;
    }

    $.ajax({
        beforeSend: function(xhr) {
            xhr.setRequestHeader(csrfHeader, csrfToken);
        },
        url: '${pageContext.request.contextPath}/board/savePost',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            title: title,
            content: content,
            category: ctg,
            subCategory: subCtg,
            type: type,
            thumbnail: thumbnail
        }),
        success: function() {
            // alert('저장 완료!');
            window.location.href = document.referrer;
        },
        error: function() {
            alert('저장 실패');
        }
    });
}
</script>
</body>
</html>