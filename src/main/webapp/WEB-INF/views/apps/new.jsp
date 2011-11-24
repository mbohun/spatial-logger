<%@ include file="/WEB-INF/views/common/top.jsp"%>
<div id="content">
    <div id="header">
        <h1>Register your new application</h1>
    </div><!--close header-->

    <div class="section">

        <h4>
            If you would like to start using the ALA/Spatial web services,
            please register your application here
        </h4>
        <form class="emmet-form fm-v" action="#" method="post">
            <fieldset>
                <div class="emmet-panel">
                    <div class="row">
                        <label for="name">Application name:</label>
                        <input type="text" id="name" name="name" class="required" placeholder="Enter the application name" />
                    </div>

                    <div class="row">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" class="required" placeholder="Enter an email address" />
                    </div>

                    <div class="row">
                        <label for="organisation">Organisation:</label>
                        <input type="text" id="organisation" name="organisation" class="required" placeholder="Enter the organisation name" />
                    </div>

                    <div class="row">
                        <label for="description">Description:</label>
                        <textarea id="description" name="description" class="required" placeholder="Enter your application description"></textarea>
                    </div>

                    <input type="submit" value="Register" />
                </div>
            </fieldset>
        </form>

    </div>

</div><!--close content-->
<%@ include file="/WEB-INF/views/common/bottom.jsp"%>
