<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="resources/css/nav.css">
    <link rel="stylesheet" type="text/css" href="resources/css/footer.css">
    <link rel="stylesheet" type="text/css" href="resources/css/about.css">
    <script src="resources/js/nav.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/aos@2.3.1/dist/aos.css">
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <title>IN COFFEE | ABOUT</title>
</head>
<body>
    <div class="wrap">
        <!-- 카테고리 -->
        <jsp:include page="/WEB-INF/views/nav.jsp" />

        <section>
            <div id="banner">
                <h1>IN COFFEE</h1>
            </div>
            
            <div class="main">
	            <div id="ctgWrap">
	                <h1 id="category">about</h1>
	            </div>
                <div data-aos="fade-up" id="row1">
                    <h1 class="title">커피와 공간에 대한 철학</h1>
                    <div class="memo" id="content1">
                        <h3>
                        좋은 커피는 좋은 공간에서 완성된다는 믿음으로 incoffee를 시작했습니다.<br>
                        <br>
                        <i>
                        질 좋은 원두를 가장 잘 느낄 수 있도록,<br>
                        불필요한 요소는 덜고 본질에 집중한<br>
                        인더스트리얼 모던 카페를 만들었습니다.<br>
                        </i>
                        <br>
                        커피 한 잔이 일상의 리듬을 바꾸길 바라는 마음으로,<br>
                        오늘도 정직한 한 잔을 준비합니다.
                        </h3>
                        <br>
                        <br>
                    </div>
                </div>
                <div data-aos="fade-left" id="row2">
                    <h1 class="title">우리가 사랑하는 원두 이야기</h1>
                    <div id="content2">
                        <div class="memo" id="c2">
                            <h3>
                            incoffee에서는<br>
                            에티오피아 예가체프 G1 내추럴 원두를<br>
                            사용하고 있습니다.<br>
                            <br>
                            <i>
                            깊이 있는 단맛과 부드러운 산미,<br>
                            베리류의 풍미가 조화롭게 어우러져<br>
                            마시는 순간 여운을 남깁니다.<br>
                            </i>
                            <br>
                            계절에 따라 가장 좋은 상태의<br>
                            생두를 선별하고,<br>
                            매장에서 직접 로스팅하여
                            신선한 맛을 유지합니다.
                            </h3>
                        </div>
                        <img src="resources/img/farming.jpg">
                    </div>
                    
                </div>
                <div data-aos="fade-right" id="row3">
                    <h1 class="title">공간이 주는 여유로움</h1>
                    <div id="content3">
                        <img src="resources/img/카페 내부 사진.png">
                        <div class="memo" id="c3">
                            <h3>
                            카페 내부는 노출 콘크리트와 금속 소재를 중심으로 구성되어,<br>
                            차갑지만 정제된 아름다움을 담고 있습니다.<br>
                            <br>
                            <i>
                            남색과 흰색의 대비가 공간에 깊이를 더하고,<br>
                            곳곳에 배치된 따뜻한 조명과 식물이 균형을 잡아줍니다.<br>
                            </i>
                            <br>
                            조용히 머물며 나만의 시간을 갖기 좋은 곳, incoffee입니다.
                            </h3>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- footer -->
        <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>
    <script>
        AOS.init({
            duration: 1000, // 애니메이션 지속 시간 (ms)
            easing: 'ease-out',
            once: true // 한 번만 실행
            
        });
    </script>
</body>
</html>