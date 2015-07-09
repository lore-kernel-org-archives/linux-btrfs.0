Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:33950 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbbGIL7U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 07:59:20 -0400
Received: by igoe12 with SMTP id e12so12156301igo.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 04:59:19 -0700 (PDT)
Message-ID: <559E6210.2020707@gmail.com>
Date: Thu, 09 Jul 2015 07:59:12 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Donald Pearson <donaldwhpearson@gmail.com>,
        Hendrik Friedel <hendrik@friedels.name>
CC: Omar Sandoval <osandov@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: size 2.73TiB used 240.97GiB after balance
References: <000f4242.05e425492a977c7b@friedels.name> <CAC=t97AcztZ9vKvMe8o70F3VsGR-_9TdFO4t=Rdt8q=9hDYm8A@mail.gmail.com> <559B66C9.6060606@friedels.name> <CAC=t97Cm8nAhwfS3vYc802Xi2tmGuvzRzOfXzSkUgaF5y0zQWQ@mail.gmail.com> <559D7245.9030204@friedels.name> <CAC=t97CWsK1HLY9WMOQb7WxN9n2dS=FBE1PE+8bQ-Fa1VzNCQA@mail.gmail.com>
In-Reply-To: <CAC=t97CWsK1HLY9WMOQb7WxN9n2dS=FBE1PE+8bQ-Fa1VzNCQA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070702020909030706080901"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070702020909030706080901
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-08 15:06, Donald Pearson wrote:
> I wouldn't use dd.
>
> I would use recover to get the data if at all possible, then you can
> experiment with try to fix the degraded condition live.  If you have
> any chance of getting data from the pool, you reduce that chance every
> time you make a change.
>
> If btrfs did the balance like you said, it wouldn't be raid5.  What
> you just described is raid4 where only one drive holds parity data.  I
> can't say that I actually know for a fact that btrfs doesn't do this,
> but I'd be shocked and some dev would need to eat their underware if
> the balance job didn't distribute the parity also.
>
That is correct, it does distribute the parity among all the member=20
drives.  That said, it would still have to modify the existing drives=20
even if it did put the parity on just the new drive, because raid{4,5,6} =

are defined as _striped_ data with parity, not mirrored (ie, if you just =

removed the parity, you'd have a raid0, not a raid1).



--------------ms070702020909030706080901
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDcwOTExNTkxMlowIwYJKoZIhvcNAQkE
MRYEFLHKvDzhrhgPU2hEF47Q6nZijKYtMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAGXq2DmfOSEv0lRaiHRaF286wIKVse5v9TolcODBdcPvr/+H
yh8iyTahZFE+zdU/fuuB72y4c9Je8VEYZrAZR7nUuMea+uzyTsqyeShtT6ZJPzjQaQ2CkvXx
uJf09OH73cJi/drV3TQhpy66iLCV8c8Cz5CCc1I2FKN+0JJmtalVDZVQESVmXF4H0KiUYuWb
HGV3i4lXcGFrYFLP4ZhGo0+HEF+CNw0lT+fCa5qBSNt/7thVVHhi/SYoPQwJgSf13stwzh/2
X+0cFIkLA+RJwEGrVgYB1gFwk1VfbFsi2lcz6u9JtSfM0JiDWsed9D1Hn+RyKi5g3EAW+fUu
qoVr8/OfhK9/WDE7qeAdbJxc/ttanWGPDrImT8L8zczjz+zOwiGHF4u4oDT0z7WDLEz+htDj
bO9INFFehrrelP4Kdey36aAM0nd1Y19ZIZqOa9Nz3WL0m0By08S2IwQKQwZqGF4mguYPKtoM
/GJp7403YJks73Nn7SECIrHcL5Rj/qlhCVGcT5ThvT07pzI+B1bcSCCEt3uFtNeNShNaRaIo
975cnAS78hukTuKjZe2cnzhj0wUOAoe7Lktv1iRRcSbTsDp52WUIjALj08T50ugnHPmMcIwG
/PVhjZf4Dh4fCDTy/hVClw3qnLMpObe3yWLviSxW+BN/j8F/wX/IWErYJDSIAAAAAAAA
--------------ms070702020909030706080901--
