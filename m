Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:33344 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbbDGRuj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 13:50:39 -0400
Received: by qcrf4 with SMTP id f4so24617830qcr.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 10:50:39 -0700 (PDT)
Message-ID: <552418E8.6060509@gmail.com>
Date: Tue, 07 Apr 2015 13:50:32 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: js7.in@samsung.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Porting BTRFS to user space
References: <759287502.475491428370096552.JavaMail.weblogic@epmlwas09d>
In-Reply-To: <759287502.475491428370096552.JavaMail.weblogic@epmlwas09d>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060904050907080206040301"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060904050907080206040301
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-04-06 21:28, =EC=9D=B8=EC=A0=95=EC=8B=9D wrote:
> Hello BTRFS developers,
>=20
> I am requesting your opion.
>=20
> I am planning to design and implement DFS version of BTRFS.
> Roughly it will be done by
>     1. Extending current DeviceID to NodeID:DeviceID to support multi-n=
ode, and
>     2. Implementing inter-node data and meta-data access over TCP.
> Do you think it would be feasible?
>=20
> For development, I would like to port the kernel code to user space.
> I could continue to run in user mode or be ported back to kernel space.=

> But I don't know how can I start to porting the kernel code to user spa=
ce.
> Is there anyone who can help?
>=20
> Thanks,
> JeongsikN=EB=96=91=EA=BF=A9=EF=BF=BDr=ED=88=A4y=E9=89=89=EC=8B=95b=EC=BE=
=8A=D0=A4=ED=91=A4v=EF=BF=BD^=EF=BF=BD)=E9=A0=BB{.n=EF=BF=BD+=EB=8F=B4=EC=
=AA=90{=EC=BC=B7=E9=9B=B9=EF=BF=BD)=EF=BF=BD=EF=A6=9Bw*=1Fjg=D0=9F=EF=BF=BD=
=1E=ED=85=8E=EC=89=B8=EB=93=B6=EC=A4=B7/=EA=B3=B4=EF=BF=BDz=EB=B0=9B=EB=BB=
=BF=EF=BF=BD2=EB=93=B7=EC=86=B3=E9=88=BA=EF=BF=BD&=EF=BF=BD)=E5=82=98=EC=B2=
=BA=EB=9B=B4=7F=EF=BF=BD=1E=EC=B7=8D=EC=B3=BA=EF=BF=BDh=EF=BF=BD=0F=EF=BF=
=BDj:+v=EB=8F=A3=EB=91=BE=EF=BF=BD=E6=98=8E
>=20
Personally, my suggestion would be to start with a port to FUSE, and
then start implementing your modifications off of that.  That said, much
of the code should already be available in userspace through libbtrfs,
which is packaged with btrfs-progs.


--------------ms060904050907080206040301
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDQwNzE3NTAzMlowIwYJKoZIhvcNAQkE
MRYEFDKlDxkIN/EEq24/dE3ILJ9M9WH9MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAJWa0+CzMwnjRkBuJGAFujQ5Wf8PxWqjQ8Lh4asaAE1qpcPs
0ZY/RhXmhzPs5y6kRi+BS3EzsSfnBzwut2qI2S66cA5I4A3aBTQYgi9cbxlyJ7hDXci8Dtjj
26szh1EpYKAoKWfxuq08jN7NvF1GDB/1AYO/LyMQ/ALXpTFELcfl3fx2yGSG7ErJLSIg5KIC
H+I/KxfF7+0EfHpse3WK86fHz7/JeR1EffsztYvAQTo1OuyEkmdwzeu/Yvt901AHGs+5meKU
JJBUXIQDskeeL0+PmQbgc3QlaV16pBnAGFPxyCi4eWcv4o+AAQoS2HShEcb6jeWSEIX+U7NO
7wGhLyiAFjNMplGLV1xP7FGaLZVXQxxtixQi/DMLpe9GCixX0u3A81+G6wQGLI8b2lz37qe0
qTLpf1nOm2RsYEVfSt7JHfEDZr/vSYjYklJ4dHVa4QEDi6P/K42gEvzsftody1adzykgAUYh
hly1DOFI4nhZ42rioKGMkReKhd22CQwujpJhBo/Tbjx+L2P1ghoaJsO73M9KjfVYb5g8pj24
kOjFmCr2y9l11kFiwml9Kl5RnfWkT8i1qYabkZ+t0WxvH6SyYS7JH+WRiEgUVmicENG9U691
A8TZ8zLO/ZdHpgnLGL0j4sG+bGhMAEiqsrY4stIebMRfu5GpuTilJpkVfCmVAAAAAAAA
--------------ms060904050907080206040301--
