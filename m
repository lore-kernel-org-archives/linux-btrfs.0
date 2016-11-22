Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-6.smtp-out.eu-west-1.amazonses.com ([54.240.4.6]:57866 "EHLO
        a4-6.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933789AbcKVSCx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 13:02:53 -0500
Subject: Re: Inconsistent free space with false ENOSPC
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <010201588c655ba6-4fe49dba-25fb-45ca-adf5-4bb721cd6ecb-000000@eu-west-1.amazonses.com>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <010201588d22ec8f-40a41aa2-9046-462a-ab95-347f101dfd02-000000@eu-west-1.amazonses.com>
Date: Tue, 22 Nov 2016 17:43:46 +0000
MIME-Version: 1.0
In-Reply-To: <010201588c655ba6-4fe49dba-25fb-45ca-adf5-4bb721cd6ecb-000000@eu-west-1.amazonses.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms060309070601030200000604"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060309070601030200000604
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 22.11.2016 15:16 Martin Raiber wrote:
> ...
> Interestingly,
> after running "btrfs check --repair" "df" shows 0 free space (Used
> 516456408 Available 0), being inconsistent with the below other btrfs
> free space information.
>
> btrfs fi usage output:
>
> Overall:
>     Device size:                 512.00GiB
>     Device allocated:            512.00GiB
>     Device unallocated:            1.04MiB
>     Device missing:                  0.00B
>     Used:                        492.03GiB
>     Free (estimated):             19.59GiB      (min: 19.59GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 326.20MiB)
>
> Data,single: Size:507.98GiB, Used:488.39GiB
>    /dev/mapper/LUKS-CC-9a6043feb9d946269555a71ec0742c8b  507.98GiB
>
> Metadata,DUP: Size:2.00GiB, Used:1.82GiB
>    /dev/mapper/LUKS-CC-9a6043feb9d946269555a71ec0742c8b    4.00GiB
>
> System,DUP: Size:8.00MiB, Used:80.00KiB
>    /dev/mapper/LUKS-CC-9a6043feb9d946269555a71ec0742c8b   16.00MiB
>
> Unallocated:
>    /dev/mapper/LUKS-CC-9a6043feb9d946269555a71ec0742c8b    1.04MiB
Looking at the code, it seems df shows zero if the available metadata
space is smaller than the used global reserve. So this file system might
be out of metadata space.


--------------ms060309070601030200000604
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CuQwggT6MIID4qADAgECAhBuZlYKQ9u25a8FBnl/zd+MMA0GCSqGSIb3DQEBCwUAMHUxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBD
ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGll
bnQgQ0EwHhcNMTYwOTE5MTMxNzAyWhcNMTcwOTE5MTMxNzAyWjBCMRwwGgYDVQQDDBNtYXJ0
aW5AdXJiYWNrdXAub3JnMSIwIAYJKoZIhvcNAQkBFhNtYXJ0aW5AdXJiYWNrdXAub3JnMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw/FqcYQTj3z2wO8ASP8j0Jvb4AbMNgB9
iv2PLMtAMzYmuW7w2VfUcXwWgM4Fkg6Nm33VhOK+Vryd2bj+jGNhm+DmbMZCfki/NrhdcHKH
AT7i1NL1lps8X3xJ7N0eJpghht9Wx5OAUfGv18HDD3yBUzqW4x7OaGoKqM0DwyUm9O/rUU6D
ugxVONmgprREB1JyJBAV8lgYbY0EEUFS1JECuxNcJQEY+G8EpUNCsZxc8nvROyRD72Aztuy2
qQj4Rs+FzQNCplzmvXot7W0T2KAH9gKb25Q5Lv0sFQEux1stcJc6KKNea21UufblNMLApQ2Z
cSNWwDF5R+YpUFW8HiBOmwIDAQABo4IBtzCCAbMwDgYDVR0PAQH/BAQDAgSwMB0GA1UdJQQW
MBQGCCsGAQUFBwMCBggrBgEFBQcDBDAJBgNVHRMEAjAAMB0GA1UdDgQWBBTKwa9D/4YV1XsZ
6affm7Wv4ykzdTAfBgNVHSMEGDAWgBQkgWw5Yb5JD4+3G0YrySi1J0htaDBvBggrBgEFBQcB
AQRjMGEwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbTA5BggrBgEFBQcw
AoYtaHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc2NhLmNsaWVudDEuY3J0MDgGA1Ud
HwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL3NjYS1jbGllbnQxLmNybDAe
BgNVHREEFzAVgRNtYXJ0aW5AdXJiYWNrdXAub3JnMCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBHBgNVHSAEQDA+MDwGCysGAQQBgbU3AQIFMC0wKwYIKwYBBQUHAgEW
H2h0dHBzOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggEBADMT
EdZtz2a7sT3FDGszfzlAfmwVamtLbG5+O6NC5xc1n9AtWa7LdRPsQzgIROT/e84D+uTPAo1c
F6rEJ7oSqhgxJcAWgGN1G0KyEzSaFs+nLvfFN1LeaYQjElnmw87z6LGLvjOnfu01M0Atj+DR
DB3NyRoAn2/5yXHJKP7/mlUSXV/fiplcvP+TJbYJwrL7QDETySua89BU0oH3vtidOm8rlWzl
cZ4ug+kXzMMwjcwSIFb/P6LDZm3FMCNbg8sBt59+V5+Duk8y6aOcQ0GdGrIXMNs+oIKL5iQW
sP9+c55K9mJVl4+3J4sTcyT/L2EOXxEZY+zEhnJAds9dQJXkKfswggXiMIIDyqADAgECAhBr
p4p9CteI1lEK+Vnk57ThMA0GCSqGSIb3DQEBCwUAMH0xCzAJBgNVBAYTAklMMRYwFAYDVQQK
Ew1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBT
aWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0x
NTEyMTYwMTAwMDVaFw0zMDEyMTYwMTAwMDVaMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQC9fdr3w6J9g/Zbgv3bW1+uHht1wLUZr5gkrLtXedg17AkefMyU
GwrQdvwObhajcVmnKVxhrUwkZPXRAwZZosRHfEIi5FH7x6SV/8Sp5lZEuiMnvMFG2MzLA84J
6Ws5T4NfXZ0qn4TPgnr3X2vPVS51M7Ua9nIJgn8jvTra4eyyQzxvuA/GZwKg7VQfDCmCS+kI
CslYYWgXOMt2xlsSslxLce0CGWRsT8EpMyt1iDflSjXZIsE7m1uTyHaKZspMLyIyz6mySu8j
8BWWHpChNNeTrFuhVfrOAyDPFJVUvKZCLKBhibTLloyy+LatoWELrjdI4a8StZY8+dIR9t4A
PXGzAgMBAAGjggFkMIIBYDAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwIG
CCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwMgYDVR0fBCswKTAnoCWgI4YhaHR0cDov
L2NybC5zdGFydHNzbC5jb20vc2ZzY2EuY3JsMGYGCCsGAQUFBwEBBFowWDAkBggrBgEFBQcw
AYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29tMDAGCCsGAQUFBzAChiRodHRwOi8vYWlhLnN0
YXJ0c3NsLmNvbS9jZXJ0cy9jYS5jcnQwHQYDVR0OBBYEFCSBbDlhvkkPj7cbRivJKLUnSG1o
MB8GA1UdIwQYMBaAFE4L7xqkQFulF2mHMMo0aEPQQa7yMD8GA1UdIAQ4MDYwNAYEVR0gADAs
MCoGCCsGAQUFBwIBFh5odHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kwDQYJKoZIhvcN
AQELBQADggIBAIvj94fsAYuErQ8BAluc4SMnIwS9NPBwAm5SH9uh2NCXTq7im61g7F1LIiNI
/+wq37fUuaMbz4g7VarKQTgf8ubs0p7NZWcIe7Bvem2AWaXBsxsaRTYw5kG3DN8pd1hSEUuF
oTa7DmNeFe8tiK1BrL3rbA/m48jp4AiFXgvxprJrW7izsyetOrRHPbkW4Y07v29MdhaPv3u1
JELyszXqOzjIYo4sWlC8iDQXwgSW/ntvWy2n4LuiaozlCfXl149tKeqvwlvrla2Yklue/quW
p9j9ou4T/OY0CXMuY+B8wNK0ohd2D4ShgFlMSjzAFRoHGKF81snTr2d1A7Ew02oF6UQyCkC2
aNNsK5cWOojBar5c7HplX9aHYUCZouxIeU28SONJAxnATgR4cJ2jrpmYSz/kliUJ46S6UpVD
o/ebn9c6PaM/XtDYCCaM/7XX6wc3s++sbQ7CtCn1Ax7df6ufQbwyO0V+oFa9H0KAsjHMzcwk
3EV2B2NLatidKE/m7G+rB9m+FlVgIiSp0mGlg43QO9Kh1+JqvTCIzv2bJJkmPMLQJNuKKwHN
L8F4GGp6jbAV+WL+LDeGfVcq8DHS3LrD+xyYEXQBiqZEdiPVOMxLDSUCXsDO0uCWpaNQ8j6y
6S9p0xE/Ga0peVLadVHhqf9nXqKaxnr358VgfrxzUIrvOaOjMYIDzDCCA8gCAQEwgYkwdTEL
MAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29t
IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENs
aWVudCBDQQIQbmZWCkPbtuWvBQZ5f83fjDANBglghkgBZQMEAgEFAKCCAhMwGAYJKoZIhvcN
AQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYxMTIyMTc0MzQzWjAvBgkqhkiG
9w0BCQQxIgQgL7p11dgmQ0b1Sp5GD9Uv2X4kI7pshGeVTioMt9lsf7cwbAYJKoZIhvcNAQkP
MV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMC
AgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBmgYJKwYBBAGC
NxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRD
b20gQ2xhc3MgMSBDbGllbnQgQ0ECEG5mVgpD27blrwUGeX/N34wwgZwGCyqGSIb3DQEJEAIL
MYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQL
EyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMSBDbGllbnQgQ0ECEG5mVgpD27blrwUGeX/N34wwDQYJKoZIhvcNAQEBBQAEggEA
bAbSl+n79FeOSoMZ6JRyhoyTSmLwV3mLfmkbEylOyyHAgg+bTFOddW6sWO84Jsrgh8ldCFjP
EPkCh18SA47dDIC1lq2ksNym22f2p8utm75jbvLv0C+6rlO5uUXTU73TC/RB2Ads6NkempEi
H03VH+g5rw6WaM0hW+JldAd+dmBEuNroaZqth4nveobEjU/Oft25zeNvk8xuMYagXnmyAk1z
hnrCpBD90nvfHT7UMqYaa5dO6mU2toi3YZVmp4F48IAE3Zou8L6FhqmF8SrTq9pO2hVPICfh
z9xHLlVxmw3uw/8F4osanIAfKSsr9aocEp+mBTsfS2O8OUzrwBlIRAAAAAAAAA==
--------------ms060309070601030200000604--
