Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37157 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbbGIMDD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 08:03:03 -0400
Received: by igau2 with SMTP id u2so87550834iga.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 05:03:01 -0700 (PDT)
Message-ID: <559E62F0.4060409@gmail.com>
Date: Thu, 09 Jul 2015 08:02:56 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Donald Pearson <donaldwhpearson@gmail.com>,
        Hendrik Friedel <hendrik@friedels.name>
CC: Omar Sandoval <osandov@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: size 2.73TiB used 240.97GiB after balance
References: <000f4242.05e425492a977c7b@friedels.name> <CAC=t97AcztZ9vKvMe8o70F3VsGR-_9TdFO4t=Rdt8q=9hDYm8A@mail.gmail.com> <559B66C9.6060606@friedels.name> <CAC=t97Cm8nAhwfS3vYc802Xi2tmGuvzRzOfXzSkUgaF5y0zQWQ@mail.gmail.com> <559D7245.9030204@friedels.name> <CAC=t97CWsK1HLY9WMOQb7WxN9n2dS=FBE1PE+8bQ-Fa1VzNCQA@mail.gmail.com> <559D964C.8060502@friedels.name> <CAC=t97CoEZgU4+bQXtJGFrgQfUgXdk0XqUBBVd-rQ=VW7bpxAQ@mail.gmail.com>
In-Reply-To: <CAC=t97CoEZgU4+bQXtJGFrgQfUgXdk0XqUBBVd-rQ=VW7bpxAQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080303080601010204010308"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080303080601010204010308
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-08 18:16, Donald Pearson wrote:
> Basically I wouldn't trust the drive that's already showing signs of
> failure to survive a dd.  It isn't completely full, so the recover is
> less load.  That's just the way I see it.  But I see your point of
> trying to get drive images now to hedge against failures.
>
> Unfortunately those errors are over my head so hopefully someone else
> has insights.
>
A better option if you want a block level copy would probably be=20
ddrescue (it's available in almost every distro in a package of the same =

name), it's designed for recovering as much data as possible from failed =

disks (and gives a much nicer status display than plain old dd).  If you =

do go for a block level copy however, make certain that no more than one =

of the copies is visible to the system at any given time, especially=20
when the filesystem is mounted, otherwise things _WILL_ get=20
exponentially worse.



--------------ms080303080601010204010308
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDcwOTEyMDI1NlowIwYJKoZIhvcNAQkE
MRYEFAWEskUbDq1Xn7roXiWw2MIBgBNWMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAAITKjLQF0ew55TMjPsPbGrZKwZn7fKCJOV5hUrYNV/jRIQ+
6KVDDUnOIlowiOBBZGQ3GuivYlaYrvmuOoKzM94kl4M5K4/m4HxNBr03F+2CNaV5ZyJS/9mk
CFhJlwBz9l+PqZKW2UK+0+7xMQZZqvsd6hAKse4Mmd8BJuD+c3UMuFTQfACyu0N8S2gVibU4
/Oi8bwYrzuRdvOmp+lcK9wVviixuM4n0LOfVgHy0BTA3NYiCxpNGlw4TXFRyg20fRXF1YJfy
YH9v0sNg/8yz8Ajm8Kb1tZ55gb0ZCo7p7rAZ+LIEmCa4Eb+UoSwunusUzhY3UZOGnnxonadK
5wIZaNDSDH6pF5Apb+z2eJXZDJkD46gcVL64f6wisGCt/i1JPlQFOb6gvtBIWyZsgE2F901J
6q4C4VYmq1zs9k7OGQhZpn16Rfu1Fb9qkgtENMfVpK+jhnUBDybI+mBb5gl2TMJ+1HXzbH0/
dGwzjvV/WZqnuyMp6HFuZ+SgYNwkUbzoLKPerw/FCjOlsiZW2CzMu6mQ4Dc3zLFfOH2gATZ3
2wgb6GdQ3kYBq1irzbuyO5TDLp4e5x39E1AFkzkx6e/QJdm+aYUmuLjs5uNE+mMGHgRMA7Sq
RfQUCHSStYYfbv4007AYT/uC2TxZO77QB3OBNkhg3vN1NXrWUAPPnP60MkVBAAAAAAAA
--------------ms080303080601010204010308--
