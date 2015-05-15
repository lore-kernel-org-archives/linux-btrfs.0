Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:35403 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbbEOLZM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 07:25:12 -0400
Received: by igbyr2 with SMTP id yr2so213779090igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 04:25:11 -0700 (PDT)
Message-ID: <5555D78D.5040909@gmail.com>
Date: Fri, 15 May 2015 07:25:01 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Christian <cdysthe@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Mysterious device (id 0).
References: <mj3dg9$h3k$1@ger.gmane.org>
In-Reply-To: <mj3dg9$h3k$1@ger.gmane.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090904050702070309060901"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090904050702070309060901
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-05-14 20:09, Christian wrote:
> Hi,
>
> My laptop has a small ext4 /boot partition /dev/sda1 and a large btrfs
> partition containing / and /home as a sub volume /dev/sda3
>
> When I run scrub on /dev/sda3 and check status with sudo btrfs scrub
> status -d /dev/sda3 I get:
>
> scrub status for 3d52dc93-c89f-453f-965d-8601d11e7710
> scrub device /dev/sda3 (id 1) history
>      scrub started at Thu May 14 19:54:02 2015 and finished after 235
> seconds
>      total bytes scrubbed: 111.03GiB with 0 errors
> scrub device  (id 0) history
>      scrub started at Thu May 14 19:54:02 2015 and was aborted after 0
> seconds
>      total bytes scrubbed: 0.00B with 0 errors
>
> As device (id 0) is indicated, but I have no idea what it is.
>
> When I run scrub with a script (cron) the same device (id 0) shows up i=
n
> a warning:
>
> /etc/cron.daily/btrfs-scrub:
> WARNING: device 0 not present
> scrub device /dev/sda3 (id 1) done
>      scrub started at Sat May  2 08:03:46 2015 and finished after 241
> seconds
>      total bytes scrubbed: 109.06GiB with 0 errors
> scrub device  (id 0) canceled
>      scrub started at Sat May  2 08:03:46 2015 and was aborted after 0
> seconds
>      total bytes scrubbed: 0.00B with 0 errors
>
> What is this device (id 0) which never gets scrubbed but always shows u=
p?
>
> I'm running Ubuntu 15.04 with the 3.19.0-16-generic kernel.
>
Have you ever run 'btrfs replace' to replace a device in the filesystem? =

  I know that new device in a replace operation get's tagged as device=20
id 0 until the replace operation completes (at which point it gets the=20
devid of the device it replaced).  Personally, this is the only case=20
that I know of that devid 0 is actually used in the code.  Thinking=20
further though, it might also be an off-by-one error somewhere, although =

I have no idea where.



--------------ms090904050702070309060901
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAxBuVTANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNTAz
MjUxOTM0MzhaFw0xNTA5MjExOTM0MzhaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCdD/zW
2rRAFCLnDfXpWxU1+ODqRVUgzHvrRO7ADUxRo1CBDc3JSX5TIW2OGmQ3DAKGOACp8Z0sgxMc
B05tzAZ/M7m4jajVrwwdVCdrwVGxTdAai7Kwg4ZCVfyMVhcwo8R2eW3QahBx34G0RKumK9sZ
ZQSQ+zULAzpY6uz7T1sAk/erMoivRXF6u8WvOsLkOD1F/Xyv1ZccSUG5YeDgZgc0nZUBvyIp
zXSHjgWerFkrxEM3y2z/Ff3eL1sgGYecV/I1F+I5S01V7Kclt/qRW10c/4JEGRcI1FmrJBPu
BtMYPbg/3Y9LZROYN+mVIFxZxOfrmjfFZ96xt/TaMXo8vcEKtWcNEjhGBjEbfMUEm4aq8ygQ
4MuEcpJc8DJCHBkg2KBk13DkbU2qNepTD6Uip1C+g+KMr0nd6KOJqSH27ZuNY4xqV4hIxFHp
ex0zY7mq6fV2o6sKBGQzRdI20FDYmNjsLJwjH6qJ8laxFphZnPRpBThmu0AjuBWE72GnI1oA
aO+bs92MQGJernt7hByCnDO82W/ykbVz+Ge3Sax8NY0m2Xdvp6WFDY/PjD9CdaJ9nwQGsUSa
N54lrZ2qMTeCI9Vauwf6U69BA42xgk65VvxvTNqji+tZ4aZbarZ7el2/QDHOb/rRwlCFplS/
z4l1f1nOrE6bnDl5RBJyW3zi74P6GwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAGvl7xb42JMRH5D/vCIDYvFY3dR2FPd5kmOqpKU/fvQ8ovmJa
p5N/FDrsCL+YdslxPY+AAn78PYmL5pFHTdRadT++07DPIMtQyy2qd+XRmz6zP8Il7vGcEDmO
WmMLYMq4xV9s/N7t7JJp6ftdIYUcoTVChUgilDaRWMLidtslCdRsBVfUjPb1bF5Ua31diKDP
e0M9/e2CU36rbcTtiNCXhptMigzuL3zJXUf2B9jyUV8pnqNEQH36fqJ7YTBLcpq3aYa2XbAH
Hgx9GehJBIqwspDmhPCFZ/QmqUXCkt+XfvinQ2NzKR6P3+OdYbwqzVX8BdMeojh7Ig8x/nIx
mQ+/ufstL1ZYp0bg13fyK/hPYSIBpayaC76vzWovkIm70DIDRIFLi20p/qTd7rfDYy831Hjm
+lDdCECF9bIXEWFk33kA97dgQIMbf5chEmlFg8S0e4iw7LMjvRqMX3eCD8GJ2+oqyZUwzZxy
S0Mx+rBld5rrN7LsXwZ671HsGqNeYbYeU25e7t7/Gcc6Bd/kPfA+adEuUGFcvUKH3trDYqNq
6mOkAd8WO/mQadlc3ztS++XDMhmIpfBre9MPAr6usqf+wc+R8Nk9KLK39kEgrqVfzc/fgf8L
MaD4rHnusdg4gca6Yi+kNrm99anw7SwaBrBvULYBp7ixNRUhaYiNW4YjTrYxggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5VMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDUxNTExMjUwMVowIwYJKoZIhvcNAQkE
MRYEFCeA3YiMtpZmwsjRhbPCK1QMce9gMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAI2kQV4F73FcQuV+A3kIE9iey6tWUPTxZRw2UUGrzmErUcSL
vuW+BAKt8jiKikr22fireuHpYJa3ogiFKXccmc/6qxw2nFESFRCmbBrcncDRpZPKhc6/FBlo
kKbaPe6/ynSVMPdHo1Bclwr4ufwdWFrNF4yDSJLMroxdHzrk4XQ4g3Q2UUbOfd9pRcqKWLou
iW/wiBlc9KAQtvpI2mqyA5g14HW+jV8KcQg8d20LHUyRYRDBKSNqpAz9ztNWuNW1czRcZAx5
Pt05kZMYIKOx/FbcrQtDSb/Tr3rO3Zh9HaOojBoOpnxp4mhX3Z5HQwOYkMcrd/GnVVsLCfZ+
794Thi9Wpf+sCg0yNOdvVmsNjNUjlJfcXDbvft/UNKsWiM9NYamARIHtgXzqjaSvMK8V4Vzi
0kA+3dwpz4jS17IShufDSFd58zCv4FParS7eUCnrOkrm9DcUyjH+v4WwBIK/r860p+qp5gjN
QTlkU3DLqW0n0tV0iA9mXLcP0j9IuizgSXuMBJVYMjkLZ1BB+j+hBm52Kqi8gW4AowrXLt0H
PtfinkWOFlH8B6IRjgYyBANfDORwjtjHW/dqJex1SwIR5LNlYEKch4CfI2DvBgkYmP8kH4TO
5SuhA1+vTo8itB9E9LvRzzvuCxj3KVtcnY0FpVoioBEq5o34Z7MImqtiwn3qAAAAAAAA
--------------ms090904050702070309060901--
