From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: btrfs-convert processing time
Date: Mon, 20 Feb 2012 14:20:48 +0100
Message-ID: <20458953.qbO19NXijp@k85hala03>
References: <4F4241D1.4080506@daevel.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2163538.osHJ88CU33"; micalg=""; protocol="application/pkcs7-signature"
Cc: linux-btrfs@vger.kernel.org
To: Olivier Bonvalet <btrfs.list@daevel.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F4241D1.4080506@daevel.fr>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2163538.osHJ88CU33
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Monday 20 of February 2012 13:51:29 Olivier Bonvalet wrote:
> Hi,
>=20
> I'm trying to convert two ext4 FS to btrfs, but I'm surprised by the
> time needed to do that conversion.
>=20
> The first FS is on a 500GiB block device, and btrfs-convert is runnin=
g
> since more than 48h :
> root      1978 25.6 47.7 748308 732556 ?       D    Feb18 944:44
> btrfs-convert /dev/vg-backup/backup
>=20
> The second is on a 340GiB block device, and the processing time is si=
milar :
> root     30192  5.2  3.0  73180 61520 pts/0    R    Feb18 121:04
> btrfs-convert /dev/vg-balor/backup
>=20
>=20
> Is it "normal", or is there a problem during the processing ?
>=20
> Thanks,
> Olivier

How much free space did those FS have? How many files were on them (was=
 they=20
dominated by small or large files)?

Regards,
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--nextPart2163538.osHJ88CU33
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
hGysv5O7TJTFOkZ4WnKM6QqUrpSaM9PC4eR7

--nextPart2163538.osHJ88CU33--

