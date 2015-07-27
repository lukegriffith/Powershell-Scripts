$WEBSERVER = @("Web-Application-Proxy",
"Web-Server",
"Web-WebServer",
"Web-Common-Http",
"Web-Default-Doc",
"Web-Dir-Browsing",
"Web-Http-Errors",
"Web-Static-Content",
"Web-Http-Redirect",
"Web-DAV-Publishing",
"Web-Health",
"Web-Http-Logging",
"Web-Custom-Logging",
"Web-Log-Libraries",
"Web-ODBC-Logging",
"Web-Request-Monitor",
"Web-Http-Tracing",
"Web-Performance",
"Web-Stat-Compression",
"Web-Dyn-Compression",
"Web-Security",
"Web-Filtering",
"Web-Basic-Auth",
"Web-CertProvider",
"Web-Client-Auth",
"Web-Digest-Auth",
"Web-Cert-Auth",
"Web-IP-Security",
"Web-Url-Auth",
"Web-Windows-Auth",
"Web-App-Dev",
"Web-Net-Ext",
"Web-Net-Ext45",
"Web-AppInit",
"Web-ASP",
"Web-Asp-Net",
"Web-Asp-Net45",
"Web-CGI",
"Web-ISAPI-Ext",
"Web-ISAPI-Filter",
"Web-Includes",
"Web-WebSockets",
"Web-Ftp-Server",
"Web-Ftp-Service",
"Web-Ftp-Ext",
"Web-Mgmt-Tools",
"Web-Mgmt-Console",
"Web-Mgmt-Compat",
"Web-Metabase",
"Web-Lgcy-Mgmt-Console",
"Web-Lgcy-Scripting",
"Web-WMI",
"Web-Scripting-Tools",
"Web-Mgmt-Service",
"Web-WHC")


configuration lgWebServer {

    param($node)


    foreach ($feature in $WEBSERVER) {
        
        node $node 
        {
            WindowsFeature "IIS$feature" {

            Name = $feature
            Ensure = "Present"

           }

        }
    }
}

lgWebServer -node 
Start-DscConfiguration -CimSession -Path lgwebserver