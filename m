Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34918 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbbGFMIz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 08:08:55 -0400
Received: by igcqs7 with SMTP id qs7so8322571igc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2015 05:08:55 -0700 (PDT)
Message-ID: <559A6FD2.70607@gmail.com>
Date: Mon, 06 Jul 2015 08:08:50 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Any hope of pool recovery?
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>	<CAC=t97A4JtSzXpn9Yr3vhe6Z5JCfKEFB1GfwSLsfYPOWhZ+Zrw@mail.gmail.com>	<pan$d53e4$45e2ddf7$2a88de7f$b02d251@cox.net>	<1477911.JnaWx19SzT@merkaba>	<CAC=t97D07H1LaE=Qa=jUtwGp16oyh6YWEL7YbOKNTU9jBbaL+Q@mail.gmail.com> <CAJCQCtTvb8dqeMsnxGZeU7A1rUDZV5mvRmZ3u=DF2uAZMGoiSw@mail.gmail.com>
In-Reply-To: <CAJCQCtTvb8dqeMsnxGZeU7A1rUDZV5mvRmZ3u=DF2uAZMGoiSw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070607000902080500080906"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070607000902080500080906
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-03 13:51, Chris Murphy wrote:
> On Fri, Jul 3, 2015 at 9:05 AM, Donald Pearson
> <donaldwhpearson@gmail.com> wrote:
>
>> I did some more digging and found that I had a lot of errors basically=

>> every drive.
>
> Ick. Sucks for you but then makes this less of a Btrfs problem because
> it can really only do so much if more than the number of spares have
> problems. It does suggest a more aggressive need for the volume to go
> read only in such cases though, before it gets this corrupt.
I'd almost say this is something that should be configurable.  The=20
default should probably be if there have been errors on at least as many =

drives as there are spares, the fs should go read-only; but still=20
provide the option to choose between that, going read-only immediately=20
on the first error or only going read-only on write errors.
> Multiple disk problems like this though suggest a shared hardware
> problem like a controller or expander.
>
I have to agree with this statement, I've seen stuff like this before=20
(altho0ugh thankfully not on BTRFS), and 100% of the time the root cause =

was either the storage controller of system RAM.


--------------ms070607000902080500080906
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDcwNjEyMDg1MFowIwYJKoZIhvcNAQkE
MRYEFHAIl5Pj7wxcI0VQf4pn1Jz8mSVHMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAB9JDKaMzxAVX3xuVB3Fp5HBe0+tSDZxRdN1EzT3/pvKCHCW
ptMsujbonmigWxLGuxdMLzWrvgKBvoxbg68AuqEeMaPQKqn7e/FtFIWuLYCDW2drsP6bkUUP
LLaXCJ5FmYI5IFDZe6pMtl4XpiocxHkN2dX7ca/aGJFErAClbPl+tRxUFae2mkQ0mMhk4Bzy
3/TYjOQJ9PZbFQka906JyxgM60uCy8QCPj2HgtfU6DlvRzPk8wAPovNVC6zPKFGpby5eV258
NHupx/glqpVtuJfzHNL2bYGxjTOqFGmMkLRJcRKEamdOPin6+WKoibhD6adtXaz4BWDlosZ4
Glplsej31ePRTlupx/1fTTdI3L14qR18BFQ1mi6DhSg+GdUbDI+IUv+nIuk2jao/dIOnt1Rf
Zhs0L30m1morR0xLoB636o3RHdckwRaWaKxzADiWIULHO1TNJ1hlTv/AjxK/Bgmk+8IfUWts
3/GAt7lzMB0XFg2PZ3ypIFeW44qykUncKD5bFV99gh3536NvumzR8oieQTgS7pkS4SX+kyEz
6qA8+JpQG4hiXqJy0VKb3IF9Cjj/Cw6nq2sF3fG0pWjXYutpqObH8IKVZ04iP+yA7kJ0DfYD
XR3/o9nGEZpvDnDQl29kXM7GILE8IQdscwXr6E/mVbnWz24UvyQpL0mVdNWwAAAAAAAA
--------------ms070607000902080500080906--
