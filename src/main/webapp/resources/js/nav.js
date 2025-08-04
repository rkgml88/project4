/**
 * 
 */
 document.addEventListener("DOMContentLoaded", function () {
    const hamburger = document.querySelector(".hamburger");
    const mobileMenu = document.querySelector(".mobile-menu");
    const overlay = document.querySelector(".mobile-menu-overlay");
    const mainMenus = document.querySelectorAll(".mobile-mainmenu");

    
    // 열기
    hamburger.addEventListener("click", function () {
        mobileMenu.classList.remove("closing"); // 혹시 닫는 중이었다면 제거
        mobileMenu.classList.add("active");
        overlay.classList.add("active");
    });

    // 닫기 (슬라이드 아웃 포함)
    function closeMenu() {
        mobileMenu.classList.remove("active");
        mobileMenu.classList.add("closing");
        overlay.classList.remove("active");

        // 슬라이드 아웃 시간 후 초기화
        setTimeout(() => {
            mobileMenu.classList.remove("closing");

            // 서브메뉴 초기화
            document.querySelectorAll(".mobile-mainmenu").forEach(menu => {
                menu.classList.remove("active");
                menu.style.color = "";
                menu.style.webkitTextStroke = "";
            });
            document.querySelectorAll(".mobile-submenu").forEach(sub => {
                sub.style.maxHeight = "0";
            });
        }, 800); // CSS transition 시간과 동일
    }

    overlay.addEventListener("click", closeMenu);


    // 메뉴 토글
    mainMenus.forEach(menu => {
        const submenu = menu.querySelector(".mobile-submenu");

        // 초기화
        submenu.style.maxHeight = "0";

        menu.addEventListener("click", function () {
            const isActive = submenu.style.maxHeight !== "0px";

            // 모든 메뉴 닫기
            document.querySelectorAll(".mobile-submenu").forEach(s => {
                s.style.maxHeight = "0";
            });

            document.querySelectorAll(".mobile-mainmenu").forEach(m => {
                m.classList.remove("active");
            });

            // 클릭한 메뉴 열기
            if (!isActive) {
                submenu.style.maxHeight = submenu.scrollHeight + "px";
                menu.classList.add("active");
            }
        });
    });
});

// 우클릭 방지
// window.addEventListener("contextmenu", e => e.preventDefault());