Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34317 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993454AbbEEPot (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 11:44:49 -0400
Received: by iget9 with SMTP id t9so80942066ige.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 08:44:48 -0700 (PDT)
Message-ID: <5548E56A.3040407@gmail.com>
Date: Tue, 05 May 2015 11:44:42 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Rory Jaffe <rsjaffe@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: fstab: use UUID or labe?
References: <CAA=o1pmDtxRCgWZjUwazq8G+ch__oMAdXLUhnu3-N7ieASZO_Q@mail.gmail.com>
In-Reply-To: <CAA=o1pmDtxRCgWZjUwazq8G+ch__oMAdXLUhnu3-N7ieASZO_Q@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000606080005060801090103"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000606080005060801090103
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-05-04 21:42, Rory Jaffe wrote:
> Question about fault tolerance and choice of ID. I'm running btrfs
> with subvolumes for / and /home. /boot and grub are on a thumb drive.
> I have six drives in the system, running raid1 for both data and
> metadata.
>
> When I run "sudo btrfs fi show" it provides both the label and the
> uuid. The UUID shown is the same as that for the first partition that
> btrfs was installed on.
>
> In fstab, the mount points currently use that UUID to identify the file=
 system.
>
> If the original drive fails, will that UUID still point to the
> filesystem, or is it better to use the label for the filesystem? Will
> the filesystem mount in either case with the failure of the original
> drive?
>
The UUID itself refers to the filesystem as a whole, not that specific=20
partition, so even if the original drive fails, the UUID will still=20
properly reference the filesystem (whether or not you can mount it is a=20
whole separate issue, as a missing device usually means you need some=20
manual intervention for recovery).

Personally, I prefer to use labels in fstab, as it makes it much more=20
obvious what is what ( and labels are usually much more compact than=20
UUID's), although this can cause issues if you aren't careful (multiple=20
filesystems with the same label gets really interesting when trying to=20
mount by label).  Additionally, on sufficiently recent distributions,=20
you might be able to use PARTUUID or PARTLABEL to id individual=20
partitions in /etc/fstab, although the disk needs to have a partition=20
table format that actually supports this (GPT is the only one I know of, =

although there may be others).



--------------ms000606080005060801090103
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDUwNTE1NDQ0MlowIwYJKoZIhvcNAQkE
MRYEFGweXVWvNvBYlFigpn6QV6qt5rN7MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAGvRWDJSfDfyr37dNRKK/F9HDXAAWCMQEqPgrk6i8pqGoEhR
+R7dMDD9GLHlfc57b9IplAz/D/dvA4YG5CsTzqhljNugMSG+a/WIQZeDwlfvHd8QufQrlY/b
EKWslSlEAo1hwHYnDjUNMC4CBRsunvPgZ9yOd5tnxeT0BTk3kco/HZFcFqonXkAKhr/Yl4Yw
vQjE8rjtkq10bSE7hDaDSNomPemWKvr/nY6iRZkqmGXavBZ+kWEKgJV3TwpPQYquicznM5TH
CmJJON/6V11Je+jvpCFxHgw3zqPEJNMHWqm6Wy4ESFNrbQ1/d8GyfOh7oBfRR+JMbG0AjFO9
hmDZuFNclj6iGaO90WNLkl3EmF1/LBPxyxUFLksTnCBznSTW9q5P+yp3i5/Kx2YrGhHAWDtY
6ulvoB464JvrSPiouLgsd1YXyzE9C+YaiLdAAgH9JrVGZCjG+9b+VLwxy5EjOSN2xNGoiI/3
BIFOvCaCHi9MK0clRacrSFMnl2DPKDOxz4TN4IeNMbju98O1cOreEA7zKl6aoj9wj6me4pIq
82ElTCRqTCk5rbPm3bfXnzcBtZ+Pj+D2bmAE202xupdPdFU97gw1hrjkPzpPsLkKNrXk8Vb4
NRtp6PkmP764o73JK4dVw3QET59L9IOlDMfYE5wEIr12l/NEwUqAwetUJ80AAAAAAAAA
--------------ms000606080005060801090103--
