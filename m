Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34821 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636AbbFQRRo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 13:17:44 -0400
Received: by qcsf5 with SMTP id f5so15746535qcs.2
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 10:17:43 -0700 (PDT)
Message-ID: <5581ABA2.30906@gmail.com>
Date: Wed, 17 Jun 2015 13:17:22 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Christian <cdysthe@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: trim not working and irreparable errors from btrfsck
References: <mlpb8i$dus$1@ger.gmane.org>	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>	<55816E7B.5040905@gmail.com>	<CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>	<mls0gb$s7m$1@ger.gmane.org> <CAJCQCtTJU3z4je=CBWDP6qE7_rDt46ivYBs9T1NNj3b-5Fy_PA@mail.gmail.com> <mls4dj$2oh$1@ger.gmane.org>
In-Reply-To: <mls4dj$2oh$1@ger.gmane.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020904000003090304030805"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020904000003090304030805
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-06-17 11:40, Christian wrote:
> On 06/17/2015 11:28 AM, Chris Murphy wrote:
>
>>>
>>> However, fstrim still gives me "0 B (0 bytes) trimmed, so that may be=

>>> another problem. Is there a way to check if trim works?
>>
>> That sounds like maybe your SSD is blacklisted for trim, is all I can
>> think of. So trim shouldn't be the cause of the problem if it's being
>> blacklisted. The recent problems appear to be around newer SSDs that
>> support queue trim and newer kernels that issue queued trim. There
>> have been some patches related to trim to the kernel, but the
>> existence of blacklisting and claims of bugs in firmware make it
>> difficult to test and isolate.
>>
>> http://techreport.com/news/28473/some-samsung-ssds-may-suffer-from-a-b=
uggy-trim-implementation
>>
>>
> This is an Intel SSD in a Lenovo Thinkpad X1 Carbon. Trim worked until =
a
> few weeks ago and still works for my small ext4 boot partition (just ra=
n
> it to check). I will keep looking for a solution. Thanks!
>
I'm seeing the same issue here, but with a Crucial brand SSD.  Somewhat=20
interestingly, I don't see any issues like this with BTRFS on top of=20
LVM's thin-provisioning volumes, or with any other filesystems, so I=20
think it has something to do with how BTRFS is reporting unused space or =

how it is submitting the discard requests.


--------------ms020904000003090304030805
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDYxNzE3MTcyMlowIwYJKoZIhvcNAQkE
MRYEFHsHohL07YYgkh1lARhxbKjmj06VMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAAr9FaZ2rqKIREyea7Lx4ZFLj3y1KSvWkR8MyJomZ1QEBHut
oU26ymSt/KQE00Y4GjoRCEo481oUwt5/n3aSnfpNhnyvvEyzzRqtZ3ocnENAL2u2EojRVTaM
7jEzH3OKmVwtLogq0TczM3kOuVmEZpdLKsfO3X2T9JUjDljwQyRQfLlP7UjJLuNhUBvdYxdt
lgGHd/8Q3j5Gffwdl6MVYIjIHoKuBxKkFJlNfx7oAnxdf+JnAaRVexGhEtq12f2LhvFh7Ftt
vtzUtdV5fUK7zQwTREAj8+FrotlBQRTO1qNRGA5tBHfIMbqXGOCk3lDc/4hVx9HXFc/d5pYD
MoZ79/C+g8QqSVoV+xgaPCBbt+teVQYmwfQ3sp7sF1jMkx0NfRR9g8R5i7NX5rmkH+D5yUO5
4PE7RN81LY7ZBeqdwMY8H8MzB9ZEwVODJh7m71Wc5wPtTKD8N+GtCQ2bjq8aHur5nIdpcl/r
3CyFBEfyvo2BsJyVrJ7w1Mmr/c0OsHly6QdXLG/72pH+9nI4Udcc0xcRafDqq+Ww+NfHPmMW
Y4NvG2buDIxEUix/y1u3o6SZ0Lzt6m1eW4C/Xb4rVI3hT8vjopwL5gOVKFvGvsBX3VjaM+sw
FxHfOPhefSd/VWF05xFOoQ1qyQ8XIzb0X3OyyL0dJcjWhi5y1YEMoJafUSVBAAAAAAAA
--------------ms020904000003090304030805--
