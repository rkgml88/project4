<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<header>
            <nav>
                <ul class="nav-links">
                    <li><a href="about">cafe</a></li>
                    <li><a href="newmenu">menu</a></li>
        <!-- 로고 이미지 -->
                    <li><a href="main" id="logo"><img src="resources/img/cafe-logo.png"></a></li>
                    <li><a href="news">news</a></li>
                    <li><a href="coffeebean">store</a></li>
                </ul>

                <!-- 서브메뉴 -->
                <div class="submenu-wrapper">
                    <div id="submenu-column1">
                        <ul>
                            <li><a href="about">INCOFFEE 소개</a></li>
                            <li><a href="map">찾아오시는 길</a></li>
                        </ul>
                    </div>
                    <div id="submenu-column2">
                        <ul>
                            <li><a href="newmenu">신메뉴</a></li>
                            <li><a href="coffee">커피</a></li>
                            <li><a href="noncoffee">논커피</a></li>
                            <li><a href="dessert">디저트</a></li>
                        </ul>
                    </div>
                    <div id="submenu-column3">
                        <ul>
                            <li><a href="news">INCOFFEE 소식</a></li>
                            <li><a href="event">이벤트</a></li>
                        </ul>
                    </div>
                    <div id="submenu-column4">
                        <ul>
                            <li><a href="coffeebean">원두</a></li>
                            <li><a href="cup">머그컵/텀블러</a></li>
                        </ul>
                    </div>
                </div>
            </nav>
            <div id="loginNav">
            <!-- 로그인하지 않은 경우 -->
		    <sec:authorize access="!isAuthenticated()">
		        <a href="login">login</a>
		        <a href="joinU">join</a>
		    </sec:authorize>    
		    <!-- 로그인한 경우 -->
		    <sec:authorize access="isAuthenticated()">
		    	<a href="userinfo" id="userinfo">회원정보</a>
		        <form action="${pageContext.request.contextPath}/logout" method="post" style="display:inline;">
		        	<sec:csrfInput />
		            <button type="submit" style="
		            	background:none; cursor:pointer; font-family: 'HANAMDAUM'
		            ">logout</button>
		        </form>		        
		    </sec:authorize>
            </div>

            <!-- 햄버거 메뉴 아이콘 -->
            <div class="hamburger">
                &#9776; 
            </div>
            <!-- 모바일 로고 -->
            <a href="main"><span id="mobileLogo">IN COFFEE</span></a>
        </header>

        <!-- 오버레이 (배경 클릭용) -->
        <div class="mobile-menu-overlay"></div>

        
        <!-- 모바일 전용 메뉴 (초기 숨김) -->
        <div class="mobile-menu">
            <ul>
                <li class="mobile-mainmenu">cafe
                    <ul class="mobile-submenu">
                        <li><a href="about">INCOFFEE 소개</a></li>
                        <li><a href="map">찾아오시는 길</a></li>
                    </ul>
                </li>
                <li class="mobile-mainmenu">menu
                    <ul class="mobile-submenu">
                        <li><a href="newmenu">신메뉴</a></li>
                        <li><a href="coffee">커피</a></li>
                        <li><a href="noncoffee">논커피</a></li>
                        <li><a href="dessert">디저트</a></li>
                    </ul>
                </li>
                <li class="mobile-mainmenu">news
                    <ul class="mobile-submenu">
                        <li><a href="news">INCOFFEE 소식</a></li>
                        <li><a href="event">이벤트</a></li>
                    </ul>
                </li>
                <li class="mobile-mainmenu">store
                    <ul class="mobile-submenu">
                        <li><a href="coffeebean">원두</a></li>
                        <li><a href="cup">머그컵/텀블러</a></li>
                    </ul>
                </li>
            </ul>
            <div id="loginNav-mobile">
            <!-- 로그인하지 않은 경우 -->
		    <sec:authorize access="!isAuthenticated()">
                <a href="login">login</a>
                <a href="joinU">join</a>
            </sec:authorize>
            <!-- 로그인한 경우 -->
		    <sec:authorize access="isAuthenticated()">
		    	<a href="userinfo" id="userinfo">회원정보</a>
		        <form action="${pageContext.request.contextPath}/logout" method="post" style="display:inline;">
		        	<sec:csrfInput />
		            <button type="submit" style="
		            	background:none; cursor:pointer; font-family: 'HANAMDAUM'
		            ">logout</button>
		        </form>		        
		    </sec:authorize>
            </div>
        </div>