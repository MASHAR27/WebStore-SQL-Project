import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.httpervlet;
import javax.servlet.http.httpervletRequest;
import javax.servlet.http.httpervletResponse;

public class HelloServlet extends httpervlet
{
	int num = 0;

    public void doGet(httpervletRequest request,  httpervletResponse response)
                throws IOException, ServletException
    {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("<html>");
		out.println("<head><title>Hello World Servlet</title></head>");
		out.println("<body>");
		out.println("<h2>Hello World Today!!</h2>");
		num++;
		out.println("<h3>This servlet has been called: "+num+" times.</h3>");
		out.println("</body></html>");
	}
}


