Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36100 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbbDNNTc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 09:19:32 -0400
Received: by igblo3 with SMTP id lo3so73451360igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2015 06:19:32 -0700 (PDT)
Message-ID: <552D13D0.2030205@gmail.com>
Date: Tue, 14 Apr 2015 09:19:12 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: dsterba@suse.cz,
        =?windows-1252?Q?Lauri_V=F5sandi?= <lauri.vosandi@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: enforce chroot for btrfs receive
References: <217a387d55b5828a82fadad98dd88a959e7a13ed.1429008167.git.lauri.vosandi@gmail.com> <20150414122810.GN25622@twin.jikos.cz>
In-Reply-To: <20150414122810.GN25622@twin.jikos.cz>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050203020501000908070509"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050203020501000908070509
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-04-14 08:28, David Sterba wrote:
> On Tue, Apr 14, 2015 at 01:44:32PM +0300, Lauri V=F5sandi wrote:
>> This patch forces btrfs receive to issue chroot before
>> parsing the btrfs stream to confine the process and
>> minimize damage that could be done via malicious
>> btrfs stream.
>
> Thanks.
>
> As we've discussed, there are possibly some things to resolve:
>
> * chdir("/") after chroot
> * commandline options to enable/disable chroot, choose the default
>
> Receive should work for a non-root user so chroot should be conditional=
,
> but I'm not sure if this should be guessed from the UID or if this woul=
d
> be better to specify only by the commandline options.
>
> I'll put the patch into a separate branch for now.

Personally, I would expect it to default to not using chroot(), provide=20
a commandline option to tell it to do so, and then just catch the error=20
from trying to chroot as a non-root user.



--------------ms050203020501000908070509
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDQxNDEzMTkxMlowIwYJKoZIhvcNAQkE
MRYEFLIRd59eVcLa9scvVAwl3fn+VQ28MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICADW3KOsfCtZMQJz6ZswkUQQePlAEkQMTTD/kS4fOqL3CEe43
59CXMvPM+dczJqrXRnro6P1KySMwcpqi0adMHCix3eUIqTVno2ZXrPgUypqWktpu941aXij1
UAhMOm7YG1HBoA9kRAL0wAY+vvftWV3mVZR1Djxt9HZyRbJzfjhTf5tG5ymkBTonBBFFEY0G
ZOdqKC1oAz33PnnF8r+I32IO26ql3J/C/LEVZrgot7t+kdom8+FKk3dDr4dhprF/dJUJEty7
75Op9oL4Clgf4ScwwquHn3qNkQPry846CxeFM3cjgXugb+up2JQWtrV03Ur/3b+s88rC4Tmm
ri94b/WvWpjW2nyTKdj72GBM71NtITr/3D7yznsRv1m1xst/+9ju4ycB8GvGMEwVgCf4Uz4N
s2QmPKM/K7hvfbSPzsyCNA2Kh+wcvdJS+83ZaKBUx7Paaj36Bm2+3q160EuytP8dIe8SH4cg
Kgyh+KQj60ASycjPvaDteWyRCXb/iwvMsNWxjkBZKp3mH9aIl9r0Z3UQ1ngoO/yLl9qIryvB
Xu+hz8bPX/tght6jwOglg1MTod3b025DxER5ve9tRRpnQA4i1bDTfOeoL0B4UzPKHDEByPpR
FL0AlgzBV1qObBN5Jc/ruDWFWqZ+E64xdV3m+EZbsP1MVPOsgPjn2utqKPbGAAAAAAAA
--------------ms050203020501000908070509--
