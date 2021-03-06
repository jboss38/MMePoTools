function Disable-SslVerification
{
    if ($PSEdition -eq 'Desktop')
    {
        # if ePo uses self signed certificate invoke-webrequest in PS 5 does not contain skipcertificatecheck
        # so it is good to disable to check ssl certifikatov
        # it is not required for PS 7 / Core, where skipcertificatecheck is available
        if (-not ([System.Management.Automation.PSTypeName]"TrustEverything").Type)
        {
            Add-Type -TypeDefinition  @"
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
public static class TrustEverything
{
    private static bool ValidationCallback(object sender, X509Certificate certificate, X509Chain chain,
        SslPolicyErrors sslPolicyErrors) { return true; }
    public static void SetCallback() { System.Net.ServicePointManager.ServerCertificateValidationCallback = ValidationCallback; }
    public static void UnsetCallback() { System.Net.ServicePointManager.ServerCertificateValidationCallback = null; }
}
"@
        }
        [TrustEverything]::SetCallback()
    }
}
