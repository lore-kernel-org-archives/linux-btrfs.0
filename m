Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:53150 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbaHELcD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Aug 2014 07:32:03 -0400
Received: by mail-ie0-f177.google.com with SMTP id at20so853747iec.36
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Aug 2014 04:32:02 -0700 (PDT)
Message-ID: <53E0C0AE.9060000@gmail.com>
Date: Tue, 05 Aug 2014 07:31:58 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>	<53DEE40C.6020403@cn.fujitsu.com>	<CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>	<17833067.mzxAL4oqZq@quad>	<CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>	<20140804102206.GA31950@carfax.org.uk>	<CAFChkquonAbMbPynpxvayb3qpLAEcMSfC2TvGKCG+kFo-Qy7eA@mail.gmail.com>	<53DFBE43.2050901@gmail.com> <pan$92d50$cb27b892$f18e750a$667475cd@cox.net>
In-Reply-To: <pan$92d50$cb27b892$f18e750a$667475cd@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000006090200010501040005"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000006090200010501040005
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-08-05 04:20, Duncan wrote:
> Austin S Hemmelgarn posted on Mon, 04 Aug 2014 13:09:23 -0400 as
> excerpted:
>=20
>> Think of each chunk like a box, and each block as a block, and that yo=
u
>> have two different types of block (data and metadata) and two differen=
t
>> types of box (also data and metadata). The data boxes are four times t=
he
>> size of the metadata boxes, and they all have to fit in one really big=

>> container (the device itself).  You can only put data blocks in the da=
ta
>> boxs, and you can only put metadata blocks in metadata boxes.  Say tha=
t
>> in total, you can fit 128 data boxes in the large container, or you ca=
n
>> replace one data box with up to four metadata boxes.  Even though you
>> may only have a few blocks in a given box, the box still takes up the
>> same amount of space in the larger container.  Thus, it's possible to
>> have only a few blocks stored, but not be able to add any more boxes t=
o
>> the larger container.  A balance operation is essentially the equivale=
nt
>> of taking all of the blocks of a given type, and fitting them into the=

>> smallest number of boxes possible.
>=20
> FWIW, that's a great analogy to stick up on the wiki somewhere, probabl=
y=20
> somewhere in the FAQ related to ENOSPC.  Please consider doing so.
>=20
> (Someone took one of my explanations from the list and stuck it in the =

> wiki, virtually word-for-word, with a link to the list post in the=20
> archives for more.  I was glad, as for some reason I just seem to work =

> best on the lists, and seem to treat web pages as read-only, even if=20
> they're on a wiki I in theory have or can get write-privs on.  I'm=20
> suggesting someone, doesn't have to be you tho great if it is, do the=20
> same with this.)
>=20
I would love to have it up on the wiki, but don't have an account or
write privileges.  FWIW, I consider anything I post on a mailing list
that isn't marked otherwise (except patches) to be public domain, so
everyone feel free to use it however you want.


--------------ms000006090200010501040005
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDgwNTExMzE1OFowIwYJKoZIhvcNAQkE
MRYEFHMxALiJlqpuX51fWuI0WIl7mKVuMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICALpy+NqUqdvKhTU2lUdwDrAhUnhUP837B0y6tu8YOeBSRVIs
o4z8hAH4Yb7DQTojTF2DyMCuvyfYKWYCzsvmyo3E8Qy28xLIC9+5sXIPT+OzHyGLvKpvb3t/
1+GdT+RHBZ7vPX88FyLchm6rWl1H2vhrq3+krT5XYc0v8rsqTA7bYxr1dnCcGTZTGVN5kWJn
mJftIJLrVNml0SAOJ+Z9KlHZGSnap03n1DRziOHDl1PyE1A7jIbYfIzb8tzQUSqXpuTj3LDn
OuyMufGboqFfngv3a1lFp0aCrWiK8++S23st8emTCy7kAolVxtWvuiEw3zrdAyGgmnaR02P4
1xTn+YIvX0R7POkEPj8Ug6mmdtfekuCAD/q58Yy22B4CourvZzoYiV0lmnOhnwHApavNGdFc
lse8Tg/Xdk8Jor/PFWtVafavsV2QPJFs/xZizVjX9nBBonOA9LctMO+n1h0CvcvFTesWuFdv
GaeFR6v+cYQGjW/ZKnEpHQ7IKeFABXDfmMm5SZxW+hOd16cZxOexBud9e/LIIiSjfQiHZ5rG
htZgvV/5MoOsT79qaDtdH5E7wEl92Qx2RkfE4LtlCPNhJ1ZuXNcvhPQHZlJ2fJ83zEdS0+w/
j1OkcQKMIaiJDKIN9MhnNkRGUDvA7EvGHgp49rY7UzRPKDzrnmt7C8GiIhc2AAAAAAAA
--------------ms000006090200010501040005--
