Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:35635 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbbGML61 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 07:58:27 -0400
Received: by iecuq6 with SMTP id uq6so233159610iec.2
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2015 04:58:26 -0700 (PDT)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.googlemail.com with ESMTPSA id w75sm7986337iod.34.2015.07.13.04.58.25
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2015 04:58:25 -0700 (PDT)
Message-ID: <55A3A7DF.8080009@gmail.com>
Date: Mon, 13 Jul 2015 07:58:23 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [RFC] Add an option to disable automatic chunk reclamation.
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040605000600010302030705"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040605000600010302030705
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Since upgrading to a kernel with the automatic chunk reclamation=20
patches, I've noticed a number of issues with BTRFS that all seem to=20
either be caused by, or are further exacerbated by, this 'feature'.

The four big issues I've seen regarding it are:
1. TRIM/DISCARD support is broken as a (partial?) result of this.
2. It appears to expose underlying issues with the defrag code (stuff=20
ending up more fragmented after defrag).
3. Since upgrading to a kernel with this patch, most of the BTRFS=20
filesystems that I have that are very rewrite heavy have gotten very=20
noticeably slower that they were beforehand (and this goes away when I=20
run them on a kernel without auto-reclaim).
4. All of my filesystems are experiencing seemingly non-deterministic=20
delays around most large scale VFS level operations (eg, deleting or=20
relocating lots of files)

While I understand that this feature does solve (at least partially) an=20
very real issue with BTRFS, there were a number of people who never had=20
this issue to begin with because we ran regular balance operations on=20
our filesystems.

Based on this, I would like to propose that some method be provided to=20
disable auto-reclaim be added.  Personally, I would prefer to leave it=20
as the default and have a mount option to disable it.


--------------ms040605000600010302030705
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDcxMzExNTgyM1owIwYJKoZIhvcNAQkE
MRYEFMBsO/O3eYMU+PCOC0G52rgGZZuIMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAFHfXhEI7xrpSmM5pWxgMfA+JKFYoByvK9R39FMDrsEaFJWB
6UmAeY5yoDyI6jFn7UHXQZJ/kWcNyd3ZCjgddcYSbaa8qEyvW/utTyHaMdWnVAP8RSbZBP8W
Y8BeakTPNi5QUlTSVdAuYqJELZZxdFDMJPLZTvciYFE56ZhJOeF4kdXaJQe31Lv+FpRjNjsz
G9wzMYvD7wZjJkRdrted4w7VXXzN7OdrXfPeLbpedu/NeKqVDxoq5Mu+F3U6MUcEzSpzpZ9N
Hwvjh9C5oyt+wIZgAkUXPRojPmh2M12j6rnbkaP5QEc2FqNiE6h9Vhj/z4Ju9SngcVBU2mT0
AiERpm+e5s103niwAiYkPw/+Xqc2e8EJjbGiAiJkLiZaQFGr06X9za6MpFe2bDnOSGfiM1r4
0FpHdw+4MH+wfG01UCIQ5SRbUVU0njireizS3mouc+P5y1nG10agDcD5a2UuL/Th0iu57TSL
gg8ZzLYsw3+0H2Gi8PS2+qPyuOoTyAr8BONmWtnSIraxR8+6o7nyIA8cTwU+DfoRrmz1TWJP
PWDxU3x3DWqyhCGOxcBq4Zpxh+LAd48mIXlPZUiGK4/hh8L2nzFzoRgp0d4H3NHkywJTCd18
Y8KdAPnlbw4+1XKee0VbQ2B1bzK8CuAKJEmbvxmkVFBtz6PLOCSQtWwnR8vPAAAAAAAA
--------------ms040605000600010302030705--
