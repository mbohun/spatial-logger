<%-- 
    Document   : bottom
    Created on : Nov 8, 2011, 11:09:54 PM
    Author     : ajay
--%>
<c:if test="${empty param.format || param.format != 'minimal'}">
    <div id="footer">
        <div id="footer-nav">
            <ul id="menu-footer-site">
                <li id="menu-item-1046" class="menu-item menu-item-type-post_type"><a
                        href="http://www.ala.org.au/">Home</a></li>
                <li id="menu-item-1049" class="menu-item menu-item-type-post_type"><a
                        href="http://www.ala.org.au/explore/maps/explore-stateterritory/">Explore</a></li>
                <li id="menu-item-1051" class="menu-item menu-item-type-post_type"><a
                        href="http://www.ala.org.au/tools-services/">Tools</a></li>
                <li id="menu-item-1050" class="menu-item menu-item-type-post_type current-page-ancestor"><a
                        href="http://www.ala.org.au/support/">Support</a></li>
                <li id="menu-item-1048" class="menu-item menu-item-type-post_type"><a
                        href="http://www.ala.org.au/support/contact-us/">Contact Us</a></li>
                <li id="menu-item-1052" class="last menu-item menu-item-type-custom"><a
                        href="http://www.ala.org.au/about/">About the Atlas</a></li>
            </ul>
            <ul id="menu-footer-legal">
                <li id="menu-item-1042" class="menu-item menu-item-type-post_type"><a
                        href="http://www.ala.org.au/home/citing-the-atlas/">Citing the Atlas</a></li>
                <li id="menu-item-1043" class="menu-item menu-item-type-post_type"><a
                        href="http://www.ala.org.au/home/disclaimer/">Disclaimer</a></li>
                <li id="menu-item-1044" class="menu-item menu-item-type-post_type"><a
                        href="http://www.ala.org.au/home/privacy-policy/">Privacy Policy</a></li>
                <li id="menu-item-1045" class="last menu-item menu-item-type-post_type"><a
                        href="http://www.ala.org.au/home/terms-of-use/">Terms of Use</a></li>
            </ul>
        </div>
        <div class="copyright">
            <p>
                <a href="http://creativecommons.org/licenses/by/3.0/au/" title="External link to Creative Commons"
                   class="left no-pipe">
                    <img src="https://www.ala.org.au/wp-content/themes/ala/images/creativecommons.png" width="88"
                         height="31" alt=""/></a>This site is licensed under a
                <a href="http://creativecommons.org/licenses/by/2.5/au/" title="External link to Creative Commons">Creative
                    Commons Attribution 3.0 Australia License</a>
            </p>
        </div>
    </div>
    <!--close footer-->
</c:if>
</div><!--close wrapper-->

<script type="text/javascript">
    $(document).ready(function () {
        $('.nav-logout a')[0].href = "${pageContext.request.contextPath}/logout";
    });
</script>
</body>
</html>