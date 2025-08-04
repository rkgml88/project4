package org.zerock.security;

import java.io.IOException;
import java.util.Collection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {

        // �α����� ������� ���� ��� ��������
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

        String redirectUrl = "/"; // �⺻ �����̷�Ʈ URL

        
        for (GrantedAuthority authority : authorities) {
            String role = authority.getAuthority();
            if (role.equals("ROLE_USER")) {
                redirectUrl = "/main";
                break;
            } else if (role.equals("ROLE_ADMIN")) {
                redirectUrl = "/main";
                break;
            }
        }

        // ���� �����̷�Ʈ
        response.sendRedirect(redirectUrl);
    }
}
