Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:38920 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaFPLYA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 07:24:00 -0400
Received: by mail-ig0-f177.google.com with SMTP id l13so2792011iga.16
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 04:23:59 -0700 (PDT)
Message-ID: <539ED3A2.50309@gmail.com>
Date: Mon, 16 Jun 2014 07:23:14 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
CC: Linux BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS, SSD and single metadata
References: <1723493.aXdklhDgAK@vajra> <539ED083.5050705@gmail.com> <4823159.jCObc9Zrv0@vajra>
In-Reply-To: <4823159.jCObc9Zrv0@vajra>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090601010108070607040108"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090601010108070607040108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-06-16 07:18, Sw=E2mi Petaramesh wrote:
> Hi Austin, and thanks for your reply.
>=20
> Le lundi 16 juin 2014, 07:09:55 Austin S Hemmelgarn a =E9crit :
>>
>> What mkfs.btrfs looks at is
>> /sys/block/<whatever-device>/queue/rotational, if that is 1 it knows
>> that the device isn't a SSD.  I believe that LVM passes through whatev=
er
>> the next lower layer's value is, but dmcrypt (and by extension LUKS)
>> always force it to a 1 (possibly to prevent programs from using
>> heuristics for enabling discard)
>=20
> In the current "running condition", the system clearly sees this is *no=
t*=20
> rotational, even thru the LVM/dmcrypt stack :
>=20
> # mount | grep btrfs
> /dev/mapper/VG-LINUX on / type btrfs=20
> (rw,noatime,seclabel,compress=3Dlzo,ssd,discard,space_cache,autodefrag)=

>=20
> # ll /dev/mapper/VGV-LINUX
> lrwxrwxrwx. 1 root root 7 16 juin  09:21 /dev/mapper/VG-LINUX -> ../dm-=
1
>=20
> # cat /sys/block/dm-1/queue/rotational=20
> 0
>=20
> ...However, at mkfs.btrfs time, it migth well not have seen it, as I ma=
de it=20
> from a live USB key in which both the lvm.conf and crypttab had not bee=
n=20
> taylored to allow "trim" commands...
>=20
> However, now that the FS is created, I still wonder whether I should us=
e a=20
> rebalance to change the metadata from DUP to SINGLE, or if Id' better s=
tay=20
> with DUP...
>=20
> Kind regards.
>=20
>=20
I'd personally stay with the DUP profile, but then that's just me being
paranoid.  You will almost certainly get better performance using the
SINGLE profile instead of DUP, but this is mostly due to it requiring
fewer blocks to be encrypted by LUKS (Which is almost certainly your
primary bottleneck unless you have some high-end crypto-accelerator card)=
=2E


--------------ms090601010108070607040108
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAw8BRDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA1
MTIxNDEwMzJaFw0xNDExMDgxNDEwMzJaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDbLUaL
Gs4JTdU7sgr0MzD57CMUAv307ddC9pxooDMN3PiUvzEd5kLtBCh8KDB1wbMdfm4hte2rDd+j
hM1tIq67BvNbdDPztOcBZwT2/3OVyyG4B1ddCqUyt03zGKw6Y34eHNfapsZiiItX0GBNfjHU
Wv+WDo+XNha/WmGSSMv21HkftF9XA1KC9Bpr9JJI23MKK7T2g/7b3KoGZlx3ekLIJsF5B7+B
DMPPDqOHQbRnccyOHEMyhM13g6WoAbU+3aKYc+C/9UsYtDV+xlvBLWagky1acstD5wOA35V6
uDRbUhD+vOjuMRMCj9jJOIYqa6AeSagBjxRnisJr0RFzQ4f+NjGCHPaFTvRvbkiXh4q22doT
0SxbNBUm7B9ANugIOtS9/VQhTWKDi//WTqZQ7Ecl4yVJbMCUg/iaRHMCGS41vqMICPszRidW
rL04NwS9D2cREEY1y/xrNo0ZvKPZu6tLhxhPf7w+5rsN3+wWxGaR1hNpnVUT9AeacLKZO6W9
FsRT3Unkr91IhQATHTKYr4EAkjN/5lgvA+sxp5TxxsUnoJYrD8IHf8aYfJsAHMleBwx4xSeZ
tw/n5iIjJjFZq9IRZ1zQhK62p+a5vJ2vlJHjTgavhQrfb1pUOjbqsnI4ndQ5hNosL9el4Kxq
Yko+HsxVEmSwSsjq6cV2L3oz0z8NUwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAIokFPcW8+cO2Clu0Ei+ehAmQRBHfV5RWJ8aMVLXOCfiJX0ch
IjVSIt6I3uQaR4J1ZIAjCSPkbpfZQDaLoGFI5j8aYEQhOeKxrvOMzY9/aSUYabCJIhE/sX64
klFV0bzm+PR9cDMWeQ9BoZf0m8UROPSfDnrjEk+p04hGg3pAZMcSwCzxdb604NHjgHJmf2xG
UQVzQgC6Ek/BKat0xuPTuPmtPv9OicK75CPmLZKYW3rFpCD6bhb1mm+ROcCNhniRY2LYm9YN
QdlHQUzTFqj0tvuYrzNI3LNV4PjEfN8z6omPCT2Rq8/uKLseN+m8F0ioqm+cphqpmzKoDUpN
nePLkqDFUFWCeWRxSjBTy4IMVUfdNXriVGihH8hyIICQiOfmmBOzhzUifdomJuTGtoXRuHVT
R2f/YdrJrLnKI4f+Othdp7F3KhB4c6JiOnTEH5J8n9q3rFjt4MPRwcjIHMhmF5nZVQlgxEMo
1cPCmvG1D9tcgXbH79jjqydo9SDXhzLQob7axkzGRY96IstNcvoQ/UNsdPPfFMYlHtGz4TxT
DhBjv4ERskGmKBZrfmxkXkcuTV/gcykct6Xvw9YXb8WTL4qSYHSYk9fReVLgE/L4RBUpX2JJ
QvIR0AJLER165/aZlQXZtuJjnfxJtJTJZZ+Gor9h0G2kuR5Dy0JuYdBO4t4xggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFEMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDYxNjExMjMxNFowIwYJKoZIhvcNAQkE
MRYEFJCIxlqjr799lOKDTpAudLQEnSQqMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAF0cHZqgx7s9wSTgSnanUIZAjvM2WP7BiDaa7upvwmd1Bq81
1mFLjCr3uUYMO/GM3ZYNOYyVqb4DhybCDPGG9OTg0h4pF4kUybgPFveNV9xJ50fif/HDPRBo
B1yiFnIvswCka+ng4/bzA5A81P66NVJEQJhKtbxcB0wWDRtD4uESS2sjvqcURT1/5DULSBWd
get57FLY3MtSHjPNRGaGUOuLSlOy4XyVIo8kVuNnxYHSTyeGXf6X79Ys4asePBrO9QVqDVX2
baYm185XDsQaG73f16tW5460rLDOY/79gnfWHi384WXDZnduyONrXWwO0sBfcC1UdgI4OhQQ
WIpfFq7jg/SJfwJpBoCJjxf4tuBUxfI6tIRI/EpMkBlNP3aCtROqIZUviWZ/bN2PiNiG0Oy5
v/p+T2maWXDiImxG1mBW9iaT9jbV7++CEZM8ulQ30G/1caJzqmfV4OTiH5FTwwmZoFR7Nzyx
0Ed0zzXQIGSbJOQbDFtPK1yUCacaFBdWWTuLFiD/2XUV3u+crJ4z6IhNsNr97Dq/9oFkTl0z
krGvkHrnSL5OJlcOxUuIRwaYUcd5FcE5HybeuwXUkA1UiCAQJk2ylVo+irJMFZHnwBlTktFo
/WGJqc50ZkAsxucS3YK2Sc444uDmlTX4RrN4oe8GQw01Pk0TxFLtBYo74pNlAAAAAAAA
--------------ms090601010108070607040108--
