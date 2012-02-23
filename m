From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [RFC] btrfs auto snapshot
Date: Thu, 23 Feb 2012 14:24:09 +0100
Message-ID: <1877276.9NitRBY2zL@k85hala03>
References: <4E4B2452.9070407@oracle.com> <1483419.CO5JBoDgFX@bursa22> <4F462ADE.4040507@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2380644.tagiL9g2aH"; micalg="sha256"; protocol="application/pkcs7-signature"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F462ADE.4040507@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2380644.tagiL9g2aH
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Thursday 23 of February 2012 20:02:38 Anand Jain wrote:
>   autosnap code is available either end of this week or early
>   next week and what you will notice is autosnap snapshots
>   are named using uuid.
>=20
>   Main reason to drop time-stamp based names is that,
>      - test (clicking on Take-snapshot button) which took more
>    than one snapshot per second was failing.
>      - a more descriptive creation time is available using a
>     command line option as in the example below.
>   -----
>   # btrfs su list -t tag=3D@minute,parent=3D/btrfs/sv1 /btrfs
>   /btrfs/.autosnap/6c0dabfa-5ddb-11e1-a8c1-0800271feb99 Thu Feb 23 13=
:01:18
> 2012 /btrfs/sv1 @minute
> /btrfs/.autosnap/5669613e-5ddd-11e1-a644-0800271feb99 Thu Feb 23 13:1=
5:01
> 2012 /btrfs/sv1 @minute -----
>=20
>   As of now code for time-stamp as autosnap snapshot name is
>   commented out, if more people wanted it to be a time-stamp
>   based names, I don't mind having that way. Please do let me know.

I'd say, that having it as configure option (do Samba-style snapshot na=
ming=20
vs. uuid based) would be sufficient. The question remains what should b=
e the=20
default.

That being said, what use-case would require snapshots taken more often=
 than=20
every second? I doubt that you actually can do snapshots every second o=
n a=20
busy file system, let alone more often. On lightly-used one they will b=
e=20
identical and just clutter the name-space.

Regards,
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--nextPart2380644.tagiL9g2aH
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCBsow
ggbGMIIErqADAgECAghgRNYwzIbzHzANBgkqhkiG9w0BAQsFADBRMSowKAYDVQQLDCFRQlMgQ2xh
c3MgMyBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkxFjAUBgNVBAoMDVFCUyBKYW4gS3ViYW4xCzAJBgNV
BAYTAlBMMB4XDTExMDUxNjEwMDUzMloXDTEyMDUxNjEwMDUzMlowgaYxHTAbBgkqhkiG9w0BCQEW
DmhrYUBxYnMuY29tLnBsMRUwEwYDVQQDDAxIdWJlcnQgS2FyaW8xDzANBgNVBCoMBkh1YmVydDEO
MAwGA1UEBAwFS2FyaW8xFzAVBgNVBAoMDlFCUyBKYW4gS3ViYcWEMREwDwYDVQQHDAhXYXJzemF3
YTEUMBIGA1UECAwLbWF6b3dpZWNraWUxCzAJBgNVBAYTAlBMMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAtmTUo4Y/Qnf6MzeQiOYc56cvVa1b3VJaZDGC3ZSj8rPlj68nHL/Tk9FCRI3S
YlJ1efskI4j8zVlxKTLetPCEUqE3PO2UQ0OaFCpdcbZQ9yvVXUbEVNAZ5quE856LmQzQ33/Kvsek
LEzfYfeLS1yjqrhqIUYblkycZT6wowsx70NfXtfSb6H9DDjX1u0WpU6jK8lLaphEA9vQB+zEfYQW
raCY1E0auEiGbPfPNi3x0if/ckVuUYCwr7IJaQg4hcYXFhUuKcbbFebUDOl8L1oi/2QwxC83U87p
an+2awtbCWD33Q+QwSRoHUuX6pQs0sPnZehh+PfdmAC9MkWAg8fXRwIDAQABo4ICSjCCAkYwUQYI
KwYBBQUHAQEERTBDMEEGCCsGAQUFBzABhjVodHRwOi8vY2EucWJzLmNvbS5wbDo4MDgwL2VqYmNh
L3B1YmxpY3dlYi9zdGF0dXMvb2NzcDAdBgNVHQ4EFgQUZ6aWItDHMTdc4y1LLdYvTB/kmhswDAYD
VR0TAQH/BAIwADAfBgNVHSMEGDAWgBRThM4WgbPV3Ji/Qgr6taX1RUTbLDCB/QYDVR0fBIH1MIHy
MIHvoIGVoIGShoGPaHR0cDovL2NhLnFicy5jb20ucGw6ODA4MC9lamJjYS9wdWJsaWN3ZWIvd2Vi
ZGlzdC9jZXJ0ZGlzdD9jbWQ9Y3JsJmlzc3Vlcj1vdT1RQlMlMjBDbGFzcyUyMDMlMjBDZXJ0aWZp
Y2F0ZSUyMEF1dGhvcml0eSxvPVFCUyUyMEphbiUyMEt1YmFuLGM9UEyiVaRTMFExKjAoBgNVBAsM
IVFCUyBDbGFzcyAzIENlcnRpZmljYXRlIEF1dGhvcml0eTEWMBQGA1UECgwNUUJTIEphbiBLdWJh
bjELMAkGA1UEBhMCUEwwDgYDVR0PAQH/BAQDAgSwMGIGA1UdJQRbMFkGCCsGAQUFBwMCBggrBgEF
BQcDAwYIKwYBBQUHAwQGCisGAQQBgjcUAgIGCisGAQQBgjcKAwwGCisGAQQBgjcCARUGCisGAQQB
gjcCARYGCSqGSIb3LwEBBTAvBgNVHREEKDAmgQ5oa2FAcWJzLmNvbS5wbIEUd2VibWFzdGVyQHFi
cy5jb20ucGwwDQYJKoZIhvcNAQELBQADggIBAE2d0JelbaaQJRuxZxndox3YC6JbOU+rG2wtQ0NG
rS2xtlqW3NnFrwj0Z9aCAJxFh1kD6HpeGqhx6QHILCIjjogJ4hJsge66B37oP+xd1SJVGHlpeyA/
hS2Fj6r0YnTT6umy0i6tDO9lvbPewalfklVCwkjqnJsFiMI4qew7HY/Gc/GxHABjE2W9NeXtDDfq
zxJ3LUXwuqVHF74EMO7N1mBgiGOM7yAVuOCGzpX86fgWFpLqRHKymuSj9VgIAa80eX3+LOZ3YYzc
SAbY2TJbN1BmU5kfGQMTIceXzB8Inub1PfUQ7mrLhheq3UIt+3MaUtgfhi2Um1RPtxway6JtUpu+
pDXHukM5vgYHRfIgfVE5jClLLeIv9ktjDpd5cGhhQjtzfeE+kaP8323xj2M+c2RJurcj2TGE48dj
e3aGLK4a7VSd8fsGNgdOYjua3f29kRGX/O1hug+bRAd0WYYEjIZL/eB8EAm6k75B9IyGvdyXP5xu
SxW4kRRj6cU22M8evhFJ6uM/Rljn3UESuob2m7hsloJVJbqDPUlvkqT8q26VLdiSoHY0vikw+oxq
dgmTm8dicjBi+ajvkonqDP3d2sm+yqpOld0+2HvEzYrPxCzg85H5WWCmTjR+bgbb04gFWi0e7P6X
hGysv5O7TJTFOkZ4WnKM6QqUrpSaM9PC4eR7MYICHjCCAhoCAQEwXTBRMSowKAYDVQQLDCFRQlMg
Q2xhc3MgMyBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkxFjAUBgNVBAoMDVFCUyBKYW4gS3ViYW4xCzAJ
BgNVBAYTAlBMAghgRNYwzIbzHzANBglghkgBZQMEAgEFAKCBkzAYBgkqhkiG9w0BCQMxCwYJKoZI
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMjAyMjMxMzI0MDlaMCgGCSqGSIb3DQEJDzEbMBkwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMC8GCSqGSIb3DQEJBDEiBCBvlCee0xW8yEEg5hgdxB5joza0
OK2rEypKKWXz5CQZBDANBgkqhkiG9w0BAQEFAASCAQCNb2vUbosKDIqeDCxEzxPHtK/BXJOb+XIp
ZWjkcupyXiobKmmlK3SJ5JPaMXvwRq05ixcHNMGX8qErLvByKKX06UvoTtkrcM00d4Ak2LUQvgZS
lkvesfmapixtScOJVjRWXWKxECKwU5WYpS/tKdIcweDc0Re91d0wLPMu5cfGSBsPfhjkV6j7L7SJ
PxDTjPiudq02zjobaiHyZp6FN8Yi0zXSqNjfcnhslv/T+7iDl/CY0+OWAt+BqL5ASbysY5WK2frT
j6SAGWpRm1a4vUlDu5Sa1yRQdMv3wzIEAMUjWBPeGXspyyZsrse4OrJ7+BPe9nl2oa9f/THeT/MZ
gv1iAAAAAAAA

--nextPart2380644.tagiL9g2aH--

