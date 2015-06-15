Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:34211 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbbFOPh2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 11:37:28 -0400
Received: by ykfl8 with SMTP id l8so59462533ykf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2015 08:37:27 -0700 (PDT)
Message-ID: <557EF12E.6000309@gmail.com>
Date: Mon, 15 Jun 2015 11:37:18 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Tovo Rabemanantsoa <tovo.rabemanantsoa@bordeaux.inra.fr>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Bad performance with near-full FS
References: <557EC95C.8020902@bordeaux.inra.fr> <20150615132915.GM6761@twin.jikos.cz> <557EE4BF.2090908@bordeaux.inra.fr>
In-Reply-To: <557EE4BF.2090908@bordeaux.inra.fr>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010105040207060306030909"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010105040207060306030909
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-06-15 10:44, Tovo Rabemanantsoa wrote:
> On 06/15/2015 03:29 PM, David Sterba wrote:
>> On Mon, Jun 15, 2015 at 02:47:24PM +0200, Tovo Rabemanantsoa wrote:
>>> Hi all,
>>> By browsing this list's archive, I've found a thread initiated by
>>> Charles Cazabon entitled: "Oddly slow read performance with near-full=

>>> largish FS."
>>> Actually, I'm living the same experience but with a not so large FS
>>> (256GB on a SSD). Indeed, when I have less than 1GB of free space, th=
e
>>> applications (thunderbird, thunar ...) on the machine become awfully
>>> slow but remain normal if I make some cleaning.
>>> Is it due to the FS or because it's an SSD hard disk ?
>>
>> 1G of 256G is less than a percent. At this level of usage you can expe=
ct
>> slowdown on any filesystem.
>>
>> This could be caused by free space fragmentation and even on a SSD, th=
is
>> needs extra time to process.  Higher number of fragments needs more
>> structures to represent them and cost more CPU time, though this still=

>> might not be the worst impact.
>>
>> AFAIK btrfs space handling logic needs to do more flushes of unwritten=

>> data when the accounted free space goes below some threshold (because
>> COW needs to write the data twice before it switches to the new "root"=

>> pointer and can free the previous version).
>
> Thanks for you reply,
> If I really understand, it's always a good idea to keep more than 1% of=

> free space. Right ?
For almost any non-COW filesystem (ext4, XFS, JFS, etc.), 1% or 100MB=20
(whichever is larger) is generally a good buffer.  On BTRFS, I would say =

at least 5% or 1.5G (again, whichever is larger; and if performance is a =

concern, go for at least 10-20%), as BTRFS is known to have some rather=20
poor behavior when running very close to full.



--------------ms010105040207060306030909
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDYxNTE1MzcxOFowIwYJKoZIhvcNAQkE
MRYEFE1SC7tFGGg3URkt4P5t3/vfGMxaMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAHdL2IMHBNNNAOuu42hlaB4Cq5BDbEG1tyaI61a86nhrY2pa
p4fNF9MAOdz3IixiHr8yzPDnG5Mxg/EbNR8ALeLvpiP0hQdCaX4HTtUb4J92DptVT5PT+wUH
yafjofZUw6XFioYokthikk3sohq+B/WoLcDyvYFKbLdZ6dEaDqiKpYSnmojwhouvFVuidIBR
QMnVrQykP+Yyr7SWrHnbdQ/u5c0GKEz8Nel1q2stgN+pC75uikAnXxAnekTCm4NOxv27h2B3
kN6X520cz6XdSrDvgQ+mO1gTuTmhgrI9Nypd1IEzROyAAw0+tnubGOy6mbaX1ag5rcwYpTlh
lCr96qbof1rM3rEPM/ikhUFjUDt2LymBov2pE7XoChkcF81w2LrJcWcnku4M42p/YasK1of7
89XCJKCpoVp7ZyhOvTtxj6jG6SvhK9jogJKkcWsllXwPprE4lW+zOBQesCkqXWtK6veSLCq9
1RUOxEaBg34L31Ffcdty9XZ6xIWhmL1eJcQhed255hvv4w+4WSRdnsH1hklt1+u4U7hNJ87l
9GCjcaLDEFxvUgRkgkzlZX4e0LzZmWykxwiUFIUymtxACBu+tqG4ChZtOyztZ+wmJ8UUrkBY
TEMCcSEheMFZxHPGlPbBqzBwbqBhjfOPnUV07/g5PiFg9Wt14OTVJiQTpFypAAAAAAAA
--------------ms010105040207060306030909--
