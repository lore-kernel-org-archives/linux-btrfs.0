From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: cross-subvolume cp --reflink
Date: Sun, 29 Apr 2012 01:53:54 +0200
Message-ID: <2272893.XFoXOC5Zif@bursa22>
References: <20120401152749.61790@gmx.net> <CALJXSJpjOX3t6Xa=gFF2p13eSb+SJfRc_pc0d5ScShnK-5BwkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart14210487.EdzILNcUGp"; micalg="sha256"; protocol="application/pkcs7-signature"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Norbert Scheibner <scno@gmx.net>
To: =?ISO-8859-1?Q?J=E9r=F4me?= Poulin <jeromepoulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALJXSJpjOX3t6Xa=gFF2p13eSb+SJfRc_pc0d5ScShnK-5BwkQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart14210487.EdzILNcUGp
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Sunday 01 of April 2012 11:42:23 J=E9r=F4me Poulin wrote:
> On Sun, Apr 1, 2012 at 11:27 AM, Norbert Scheibner <scno@gmx.net> wro=
te:
> > Some users tested this patch successfully for week,s or months in 2=
 or 3
> > kernel versions since then, true?
> If this feature must be implented in VFS in another patch, why not
> just activate what works and make the future patch disable it again?

Why would (should) it be impleemented in VFS? reflink copy is completel=
y=20
different from normal copy and hard link.

Subvolumes in btrfs are barriers *only* in btrfs and not visible in VFS=
.

IMHO it's strictly btrfs business and not supporting reflink copy betwe=
en=20
arbitrary directories is a bug.

Regards,
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--nextPart14210487.EdzILNcUGp
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMjA0MjgyMzUzNTVaMCgGCSqGSIb3DQEJDzEbMBkwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMC8GCSqGSIb3DQEJBDEiBCA7PEfm2WaugJIJ+rA+CEuc/qpM
txkZp/PiTtqwA2CNlzANBgkqhkiG9w0BAQEFAASCAQBvxM9pmBAmTpBqffTsScKQuPf8UKk9P0OU
Nj6g4Wu0ig05o9NbDXIG2DP13c9w7roQVCHE78xviNSrLNvpgsjNuGRX/sbFx8/oSPwriTd4rvpo
cAiw2LV0JJ1dV+edjh8x3K6XI4NAgIWAVYCEg/8pL6az83FKTwJeKVvGgpW/rGVSr87lTIjy7wZQ
O/ahLyjbwmpwHq5fM//oWYyaHKHk0ig1Ls8w9j4SGDh1LXmz4mLmloOev/j0DjG9+Rx5fPzti/Yt
kmCxMGARsjZgXKqaCCYnPOgN4rN1BMMW3cpPXNeYJzSxg3OGqwrkNJgZj4ew5Pjq/BER3VlQJ5xf
+IvUAAAAAAAA

--nextPart14210487.EdzILNcUGp--

