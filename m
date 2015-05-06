Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:36018 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbbEFRcG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 13:32:06 -0400
Received: by iecnq11 with SMTP id nq11so19910114iec.3
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 10:32:06 -0700 (PDT)
Message-ID: <554A5012.1090801@gmail.com>
Date: Wed, 06 May 2015 13:32:02 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs 4.0 breaks btrfs fi show?
References: <CAJCQCtR7ZT6vt06fbw3sh9sQxufsck=v2J+HJKz2DLFxR9q8RQ@mail.gmail.com>	<5549CCD8.2010000@cn.fujitsu.com>	<CAJCQCtT0ff8fVrMQ7rrgW1VFkiBL+f_upGOUZ7DY65N62jAsBQ@mail.gmail.com>	<5549DF66.5090900@cn.fujitsu.com>	<CAJCQCtSYbumV4-SPXRCxTzb0gXw6NaLYrNUCC79bz7eUNOiSPw@mail.gmail.com> <CAJCQCtRjWYgGJkKp0jOsb31cqjyh00K2tV-wbJqnSAYC3ekcMg@mail.gmail.com>
In-Reply-To: <CAJCQCtRjWYgGJkKp0jOsb31cqjyh00K2tV-wbJqnSAYC3ekcMg@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050203030109050006090504"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050203030109050006090504
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-05-06 13:05, Chris Murphy wrote:
> Ok so now that my mea culpa is out of the way, I'm actually wondering
> why non-root users can't do certain btrfs tasks when they're read-only
> commands.
>
> [chris@f22m ~]$ btrfs fi show
> ERROR: could not open /dev/sda7   ##this is new it wasn't doing this la=
st night
> btrfs-progs v4.0
> [chris@f22m ~]$ btrfs fi df /
> Data, single: total=3D4.00GiB, used=3D3.57GiB
> System, single: total=3D4.00MiB, used=3D16.00KiB
> Metadata, single: total=3D1.01GiB, used=3D198.30MiB
> GlobalReserve, single: total=3D80.00MiB, used=3D0.00B
> [chris@f22m ~]$ btrfs fi usage /
> WARNING: can't read detailed chunk info, RAID5/6 numbers will be
> incorrect, run as root
> WARNING: can't get filesystem info from ioctl(FS_INFO), run as root
> ERROR: couldn't get space info on '/' - Operation not permitted
>
>
> I think usage is more useful than df for users, and contains largely
> the same information as df + show, so I think all three should be
> non-root user usable.
>
That may be tricky to do, I think show and usage both access the=20
underlying block device directly (or try to in any case), which would=20
explain why they don't work as non-root; most modern linux distributions =

have permissions on (non-hot-plugged) block devices set to 660 and owned =

by root:disk.



--------------ms050203030109050006090504
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDUwNjE3MzIwMlowIwYJKoZIhvcNAQkE
MRYEFGxoRlTmyABCGf2y02q7udG90uGHMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAFyYgA9D0VYtbEa1ttiZ/KxtnyJT9n1jzMI2cy9VmRGzsLKh
JIZgX3jalMXeT4aoU4I6wnL81qoQXGLW/R6P45QDLX1C52u2hGwm9/JYXwsGJxneb5S50z8d
gd9D+vf/5wP1muOvGy2trw6Ml9wUV/13xPw5sv/Qupubf93fJbC7dsj2UJa0KvW7HWhIoj5k
LzD9ykQEmgmTUrt/FeHWI4WZBGyGJmlIKDX0Skpw2jbas9BZSHnJsm7ceDCJvsKWMTsdJlKE
h/Rz9N2NU6h+BUCEbIKu5hSoi+/QjoECM2x18FFkiLYSaqaqMSklTyF6Puos7h6bh0Xe+SoN
fgUK4wpKvRmOzxXCIg4f/nIj4RLp1Q7Md+QQdJEkjHEi5dpcAuNpD5qYFf6jxVUiO2IUrMI3
uwLoBECYWb5az0XHr2EZWSIH+/vRr2Kl5IguGJtJn/w7TSbkal2ErFkNiAmre6XrLC0dklAn
kZFwSkQAm8a7Zk59JtO4vxuUyalomLH2FGa62cb1HGf77SKi4z+dA17G/BqW9OeVgH7rq5TP
b+G9NH2AYM2qR1JpCYXCPuyJBiEzdMvdpDP6fOmpo7bGeitfBlkYC4AW97qrNgHwVaSsrBjg
JZHaF69E8j6QOmYVrhpK2ENhcGZtsHG3CLF5x/T6aPM0/it/vUu0o5xBD4DEAAAAAAAA
--------------ms050203030109050006090504--
