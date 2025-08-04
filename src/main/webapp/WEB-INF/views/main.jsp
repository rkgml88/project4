<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IN COFFEE | INDUSTRIAL MOOD</title>
    <link rel="stylesheet" type="text/css" href="resources/css/nav.css">
    <link rel="stylesheet" type="text/css" href="resources/css/footer.css">
    <link rel="stylesheet" type="text/css" href="resources/css/main.css">
    
    <script src="resources/js/nav.js"></script>
    
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
    <link rel="stylesheet" href="https://unpkg.com/aos@2.3.1/dist/aos.css">
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    
    
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
	<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>
	<script src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
    <script>
        $(document).ready(function(){
            
            // 자동 슬라이드 전환
            $('.row1').slick({
                slidesToShow: 1,
                slidesToScroll: 1,
                autoplay: true,
                autoplaySpeed: 5000,       
            });

            // 네온 효과
            setInterval(function() {
                $("#exp1 h2").toggleClass("neon1");
            }, 1000);
            setInterval(function() {
                $("#exp1 span").toggleClass("neon2");
            }, 1000);
            setInterval(function() {
                $("#exp2 h2").toggleClass("neon3");
            }, 1000);
            setInterval(function() {
                $("#exp2 span").toggleClass("neon4");
            }, 1000);

        })
    </script>
</head>
<body>
    <div class="wrap">
        <!-- 카테고리 -->
        <jsp:include page="/WEB-INF/views/nav.jsp" />

        <section class="main">
        <!-- 메인 이미지 -->
            <article class="row1">
                <div id="mainImg1">
                    <!-- 슬라이드1 -->
                    <img src="resources/img/cafeMain1.jpg" alt="메인 이미지1">
                    <div class="overlay"><!-- 캐치프라이즈 -->
                        <h1>"공간을 채우는 한 잔"</h1>
                        <p>.in coffee</p>
                    </div>
                </div>
                <div id="mainImg2">
                    <!-- 슬라이드2 -->
                    <img src="resources/img/cafeMain2.jpg" alt="메인 이미지2">
                    <div class="overlay"><!-- 캐치프라이즈 -->
                        <h1>"거친 멋, 깊은 향"</h1>
                        <p>.in coffee</p>
                    </div>
                </div>
            </article>
            <div class="banner">
                <img class="IM" src="resources/img/banner.png" alt="배너">
                <img class="IM" id="afterB" src="resources/img/banner.png" alt="배너">
            </div>
            
            <div class="section2">
        <!-- 주력 메뉴 -->
                <article class="row2">
                    <div class="explain" id="exp1">
            <!-- 주력 메뉴 설명 -->
                        <h2><span>signature |</span> cappuccino</h2>
                        <p data-aos="fade-right" data-aos-duration="3000">
                            부드러운 우유 거품과 진한 에스프레소가 어우러진 클래식한 카푸치노
                        </p>
                    </div>
            <!-- 주력 메뉴 이미지_우 -->
                    <img data-aos="fade-left" data-aos-duration="3000" src="resources/img/카푸치노.png">
                </article>
        <!-- 신메뉴 -->
                <article class="row3">
            <!-- 신메뉴 이미지_좌 -->
                    <img data-aos="fade-right" data-aos-delay="50" data-aos-duration="3000" src="resources/img/스무디.png">
            <!-- 신메뉴 설명 -->
                    <div class="explain" id="exp2">
                        <h2>rasberry smoothie <span>| new</span></h2>
                        <p data-aos="fade-left" data-aos-delay="50" data-aos-duration="3000">
                            상큼한 라즈베리의 진한 풍미가 가득한 시원하고 부드러운 스무디
                        </p>
                    </div>
                </article>
            </div>
        <!-- 디저트 -->
            <article class="row4">
                <h1 data-aos="flip-down" data-aos-delay="50">dessert</h1>
                <div class="dessertWrap">
                    <div data-aos="fade-up" data-aos-delay="500" class="dessert">
                        <img id="scone" src="resources/img/scone.jpg" alt="scone">
                        <div class="overlay2">
                            <p>스콘</p>
                            <button><a href="dessert">more</a></button>
                        </div>
                    </div>
                    <div data-aos="fade-down" data-aos-delay="500" class="dessert">
                        <img src="resources/img/macarons.jpg" alt="macaron">
                        <div class="overlay2">
                            <p>마카롱</p>
                            <button><a href="dessert">more</a></button>
                        </div>
                    </div>
                    <div data-aos="fade-up" data-aos-delay="500" class="dessert">
                        <img src="resources/img/affogato.jpg" alt="affogato">
                        <div class="overlay2">
                            <p>아포가토</p>
                            <button><a href="dessert">more</a></button>
                        </div>
                    </div>
                    <div data-aos="fade-down" data-aos-delay="500" class="dessert">
                        <img src="resources/img/cheesecake.jpg" alt="cheesecake">
                        <div class="overlay2">
                            <p>치즈케이크</p>
                            <button><a href="dessert">more</a></button>
                        </div>
                    </div>
                    <div data-aos="fade-up" data-aos-delay="500" class="dessert">
                        <img src="resources/img/cookies.jpg" alt="cookie">
                        <div class="overlay2">
                            <p>쿠키</p>
                            <button><a href="dessert">more</a></button>
                        </div>
                    </div>
                </div>
            </article>
        </section>
        <!-- footer -->
        <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>

    <script>
        AOS.init({
            duration: 2000, // 애니메이션 지속 시간 (ms)
            easing: 'ease-in-out-back',
            once: false // 한 번만 실행
            
        });
        
    </script>
</body>
</html>