Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B941C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E33F620873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:29:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E33F620873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mpi-dortmund.mpg.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbeK0T0o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 14:26:44 -0500
Received: from mail-edge2.mpi-dortmund.mpg.de ([141.5.144.112]:11608 "EHLO
        smtp.mpi-dortmund.mpg.de" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727574AbeK0T0o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 14:26:44 -0500
Received: from Exchange2013-2.mpi-dortmund.mpg.de (141.5.200.102) by
 EX2013-Edge2.mpi-dortmund.mpg.de (141.5.200.112) with Microsoft SMTP Server
 (TLS) id 15.0.1395.4; Tue, 27 Nov 2018 09:28:50 +0100
Received: from [141.5.196.33] (141.5.200.120) by
 Exchange2013-2.mpi-dortmund.mpg.de (141.5.200.102) with Microsoft SMTP Server
 (TLS) id 15.0.1395.4; Tue, 27 Nov 2018 09:28:51 +0100
To:     <1i5t5.duncan@cox.net>
CC:     <linux-btrfs@vger.kernel.org>
References: <pan$f1f1$ae87783$50df180$b6b94f2a@cox.net>
Subject: Re: unable to fixup (regular) error
From:   Alexander Fieroch <alexander.fieroch@mpi-dortmund.mpg.de>
Message-ID: <1a5bfda2-ffe7-00a3-579b-a92e2e33e1f5@mpi-dortmund.mpg.de>
Date:   Tue, 27 Nov 2018 09:28:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <pan$f1f1$ae87783$50df180$b6b94f2a@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
        micalg=sha-256; boundary="------------ms000406050205050205010109"
X-ClientProxiedBy: Exchange2013-3.mpi-dortmund.mpg.de (141.5.200.103) To
 Exchange2013-2.mpi-dortmund.mpg.de (141.5.200.102)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--------------ms000406050205050205010109
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Actually the data on raid0 is not my data but of my users and they knew=20
and accepted the risk for raid0. So in my case it should be ok - I don't =

know the importance of the data files which are affected. I just wanted=20
to help finding a possible bug and experiment with a broken btrfs=20
filesystem before I recreate it.
For my own files I'd prefer raid5 or raid6...

But thanks Duncan for your explanation! Of course there are people out=20
there who do not know the difference between different raid levels and=20
should be warned!

Best regards,
Alexander


--------------ms000406050205050205010109
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
EGQwggUSMIID+qADAgECAgkA4wvV+K8l2YEwDQYJKoZIhvcNAQELBQAwgYIxCzAJBgNVBAYT
AkRFMSswKQYDVQQKDCJULVN5c3RlbXMgRW50ZXJwcmlzZSBTZXJ2aWNlcyBHbWJIMR8wHQYD
VQQLDBZULVN5c3RlbXMgVHJ1c3QgQ2VudGVyMSUwIwYDVQQDDBxULVRlbGVTZWMgR2xvYmFs
Um9vdCBDbGFzcyAyMB4XDTE2MDIyMjEzMzgyMloXDTMxMDIyMjIzNTk1OVowgZUxCzAJBgNV
BAYTAkRFMUUwQwYDVQQKEzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVu
IEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNVBAMTJERG
Ti1WZXJlaW4gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgMjCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAMtg1/9moUHN0vqHl4pzq5lN6mc5WqFggEcVToyVsuXPztNXS43O+FZs
FVV2B+pG/cgDRWM+cNSrVICxI5y+NyipCf8FXRgPxJiZN7Mg9mZ4F4fCnQ7MSjLnFp2uDo0p
eQcAIFTcFV9Kltd4tjTTwXS1nem/wHdN6r1ZB+BaL2w8pQDcNb1lDY9/Mm3yWmpLYgHurDg0
WUU2SQXaeMpqbVvAgWsRzNI8qIv4cRrKO+KA3Ra0Z3qLNupOkSk9s1FcragMvp0049ENF4N1
xDkesJQLEvHVaY4l9Lg9K7/AjsMeO6W/VRCrKq4Xl14zzsjz9AkH4wKGMUZrAcUQDBHHWekC
AwEAAaOCAXQwggFwMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUk+PYMiba1fFKpZFK4OpL
4qIMz+EwHwYDVR0jBBgwFoAUv1kgNgB5oKAia4zV8mHSuCzLgkowEgYDVR0TAQH/BAgwBgEB
/wIBAjAzBgNVHSAELDAqMA8GDSsGAQQBga0hgiwBAQQwDQYLKwYBBAGBrSGCLB4wCAYGZ4EM
AQICMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9wa2kwMzM2LnRlbGVzZWMuZGUvcmwvVGVs
ZVNlY19HbG9iYWxSb290X0NsYXNzXzIuY3JsMIGGBggrBgEFBQcBAQR6MHgwLAYIKwYBBQUH
MAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMEgGCCsGAQUFBzAChjxodHRw
Oi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9UZWxlU2VjX0dsb2JhbFJvb3RfQ2xhc3NfMi5j
ZXIwDQYJKoZIhvcNAQELBQADggEBAIcL/z4Cm2XIVi3WO5qYi3FP2ropqiH5Ri71sqQPrhE4
eTizDnS6dl2e6BiClmLbTDPo3flq3zK9LExHYFV/53RrtCyD2HlrtrdNUAtmB7Xts5et6u5/
MOaZ/SLick0+hFvu+c+Z6n/XUjkurJgARH5pO7917tALOxrN5fcPImxHhPalR6D90Bo0fa3S
PXez7vTXTf/D6OWST1k+kEcQSrCFWMBvf/iu7QhCnh7U3xQuTY+8npTD5+32GPg8SecmqKc2
2CzeIs2LgtjZeOJVEqM7h0S2EQvVDFKvaYwPBt/QolOLV5h7z/0HJPT8vcP9SpIClxvyt7bP
ZYoaorVyGTkwggWNMIIEdaADAgECAgwcOtRQhH7u81j4jncwDQYJKoZIhvcNAQELBQAwgZUx
CzAJBgNVBAYTAkRFMUUwQwYDVQQKEzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1
dHNjaGVuIEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNV
BAMTJERGTi1WZXJlaW4gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgMjAeFw0xNjExMDMxNTI0
NDhaFw0zMTAyMjIyMzU5NTlaMGoxCzAJBgNVBAYTAkRFMQ8wDQYDVQQIDAZCYXllcm4xETAP
BgNVBAcMCE11ZW5jaGVuMSAwHgYDVQQKDBdNYXgtUGxhbmNrLUdlc2VsbHNjaGFmdDEVMBMG
A1UEAwwMTVBHIENBIC0gRzAyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnhx4
59Lh4WqgOs/Md04XxU2yFtfM15ZuJV0PZP7BmqSJKLLPyqmOrADfNdJ5PIGBto2JBhtRRBHd
G0GROOvTRHjzOga95WOTeura79T21FWwwAwa29OFnD3ZplQs6HgdwQrZWNi1WHNJxn/4mA19
rNEBUc5urSIpZPvZi5XmlF3v3JHOlx3KWV7mUteB4pwEEfGTg4npPAJbp2o7arxQdoIq+Pu2
OsvqhD7Rk4QeaX+EM1QS4lqd1otW4hE70h/ODPy1xffgbZiuotWQLC6nIwa65Qv6byqlIX0q
Zuu99Vsu+r3sWYsL5SBkgecNI7fMJ5tfHrjoxfrKl/ErTAt8GQIDAQABo4ICBTCCAgEwEgYD
VR0TAQH/BAgwBgEB/wIBATAOBgNVHQ8BAf8EBAMCAQYwKQYDVR0gBCIwIDANBgsrBgEEAYGt
IYIsHjAPBg0rBgEEAYGtIYIsAQEEMB0GA1UdDgQWBBTEiKUH7rh7qgwTv9opdGNSG0lwFjAf
BgNVHSMEGDAWgBST49gyJtrV8UqlkUrg6kviogzP4TCBjwYDVR0fBIGHMIGEMECgPqA8hjpo
dHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1Yi9jcmwvY2Fjcmwu
Y3JsMECgPqA8hjpodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1
Yi9jcmwvY2FjcmwuY3JsMIHdBggrBgEFBQcBAQSB0DCBzTAzBggrBgEFBQcwAYYnaHR0cDov
L29jc3AucGNhLmRmbi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEoGCCsGAQUFBzAChj5odHRwOi8v
Y2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNy
dDBKBggrBgEFBQcwAoY+aHR0cDovL2NkcDIucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1nMi1j
YS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBABLpeD5FygzqOjj+
/lAOy20UQOGWlx0RMuPcI4nuyFT8SGmK9lD7QCg/HoaJlfU/r78ex+SEide326evlFAoJXIF
jVyzNltDhpMKrPIDuh2N12zyn1EtagqPL6hu4pVRzcBpl/F2HCvtmMx5K4WN1L1fmHWLcSap
dhXLvAZ9RG/B3rqyULLSNN8xHXYXpmtvG0VGJAndZ+lj+BH7uvd3nHWnXEHC2q7iQlDUqg0a
wIqWJgdLlx1Q8Dg/sodv0m+LN0kOzGvVDRCmowBdWGhhusD+duKV66pBl+qhC+4LipariWaM
qK5ppMQROATjYeNRvwI+nDcEXr2vDaKmdbxgDVwwggW5MIIEoaADAgECAgwf2pQ6+dTvmG2k
SlwwDQYJKoZIhvcNAQELBQAwajELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8G
A1UEBwwITXVlbmNoZW4xIDAeBgNVBAoMF01heC1QbGFuY2stR2VzZWxsc2NoYWZ0MRUwEwYD
VQQDDAxNUEcgQ0EgLSBHMDIwHhcNMTgxMDA4MDgzNDU5WhcNMjExMDA3MDgzNDU5WjCBhTEL
MAkGA1UEBhMCREUxIDAeBgNVBAoMF01heC1QbGFuY2stR2VzZWxsc2NoYWZ0MTgwNgYDVQQL
DC9NYXgtUGxhbmNrLUluc3RpdHV0IGZ1ZXIgbW9sZWt1bGFyZSBQaHlzaW9sb2dpZTEaMBgG
A1UEAwwRQWxleGFuZGVyIEZpZXJvY2gwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
AQDkaBKm1senmmNAYrpp+354J72gly61fBelNtl7FBFx/+oVrgok1dW2CQSVnCw9f4Ks6ebG
D+iGe2T4VDiele1LWmG+2IaX6BJy8jMsnMc+l9OZZ18QYLhQYeKKzOM00Zj0oFtBd00zKnp4
PWTeXZdQP9y4qKuba5LfypzSpLSIjKpK8lh8n20x2ksBQBafTrbexPBZ/Gqj8kozS+45ZUep
YwcQ0TVE3vrAr5na/3AJ3up1bxXH+/+o1LRMWjKAB3g5A2vmRYCdXCX7khbdoTha00WcC5Yv
OdPgzcqve15nz+LmGwmNXl6UwyLM0GU0gVkMFxmEptUt4uOkOPjrReGLAgMBAAGjggJBMIIC
PTAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYB
BQUHAwQwHQYDVR0OBBYEFLBDBGZbsOXrX1A1IrIHII1lNJKzMB8GA1UdIwQYMBaAFMSIpQfu
uHuqDBO/2il0Y1IbSXAWMDAGA1UdEQQpMCeBJWFsZXhhbmRlci5maWVyb2NoQG1waS1kb3J0
bXVuZC5tcGcuZGUwfQYDVR0fBHYwdDA4oDagNIYyaHR0cDovL2NkcDEucGNhLmRmbi5kZS9t
cGctZzItY2EvcHViL2NybC9jYWNybC5jcmwwOKA2oDSGMmh0dHA6Ly9jZHAyLnBjYS5kZm4u
ZGUvbXBnLWcyLWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIHNBggrBgEFBQcBAQSBwDCBvTAzBggr
BgEFBQcwAYYnaHR0cDovL29jc3AucGNhLmRmbi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEIGCCsG
AQUFBzAChjZodHRwOi8vY2RwMS5wY2EuZGZuLmRlL21wZy1nMi1jYS9wdWIvY2FjZXJ0L2Nh
Y2VydC5jcnQwQgYIKwYBBQUHMAKGNmh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvbXBnLWcyLWNh
L3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDBABgNVHSAEOTA3MA8GDSsGAQQBga0hgiwBAQQwEQYP
KwYBBAGBrSGCLAEBBAMIMBEGDysGAQQBga0hgiwCAQQDCDANBgkqhkiG9w0BAQsFAAOCAQEA
WebfqQ4rY+BOrhQ5tofe4oLUC3FZ21Cezk21+XpDmMWO4yvBMCErAhR81daQGG5vkxqExLtC
8pRopADSd3UzKWHiNJgeywXjvICfPbgpECse3Zixp+iPV5+tZMhtUKPiaH20Kgdfepraw2/D
Gs8MWlcVGdTn2XwDJDbC1iCqnXq7fBz5r8I+WhvqnUFlavzOLgV4yZDq96zyYc1D+z809kYr
3dO1t4aeijE66rZrWI69jeIH3Uh5jOvK8AkWmq5v4HSPVnxLlsIi6onXjVGuwF6dBboRuDiJ
eytT16YSj7a61SkdyzQFis1q0ztup8tMdfcRrBTaZp3Hsxl3B3o89DGCA5owggOWAgEBMHow
ajELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8GA1UEBwwITXVlbmNoZW4xIDAe
BgNVBAoMF01heC1QbGFuY2stR2VzZWxsc2NoYWZ0MRUwEwYDVQQDDAxNUEcgQ0EgLSBHMDIC
DB/alDr51O+YbaRKXDANBglghkgBZQMEAgEFAKCCAfEwGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgxMTI3MDgyODUxWjAvBgkqhkiG9w0BCQQxIgQgRGGx
pRa0xHak1Vqq9Wr968SwmxKcl/6WI+U+ZfGyL/kwbAYJKoZIhvcNAQkPMV8wXTALBglghkgB
ZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG
9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBiQYJKwYBBAGCNxAEMXwwejBqMQsw
CQYDVQQGEwJERTEPMA0GA1UECAwGQmF5ZXJuMREwDwYDVQQHDAhNdWVuY2hlbjEgMB4GA1UE
CgwXTWF4LVBsYW5jay1HZXNlbGxzY2hhZnQxFTATBgNVBAMMDE1QRyBDQSAtIEcwMgIMH9qU
OvnU75htpEpcMIGLBgsqhkiG9w0BCRACCzF8oHowajELMAkGA1UEBhMCREUxDzANBgNVBAgM
BkJheWVybjERMA8GA1UEBwwITXVlbmNoZW4xIDAeBgNVBAoMF01heC1QbGFuY2stR2VzZWxs
c2NoYWZ0MRUwEwYDVQQDDAxNUEcgQ0EgLSBHMDICDB/alDr51O+YbaRKXDANBgkqhkiG9w0B
AQEFAASCAQCIaxgfeTFuH4pXAC3ZB04TAF25dmPY7HELYZzXq8EAJjBt6IkftBveMTbxnoeP
fqStx7e9iG0638kNXKUifXF/97hX4+ymt5SNMThFyHKQY5BowvJuKkXalMtjv7fdU+HoEsBK
9NXUBFLx8gZi95NRIv+6LuqWtDOq4NHzYWufvDIl+6gYOyqKSZA8FG0Lz5NVNAdLnEpW8i/i
69l8QzKVMJ9gm/dvowlIXXSi8IbCI2iega7kHdbpEA8PsWYk6KJmVB2WFzlY2HuKmMSTQDNI
hxzl1bVHRvH19Lkc2nO3SxVPSwPIQ6cgvYRP1tGa22A9aiQ2oe96BVCc1BnxcIDfAAAAAAAA

--------------ms000406050205050205010109--
