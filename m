Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:51999 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaFPLRL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 07:17:11 -0400
Received: by mail-ig0-f170.google.com with SMTP id h3so3732241igd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 04:17:10 -0700 (PDT)
Message-ID: <539ED209.1070501@gmail.com>
Date: Mon, 16 Jun 2014 07:16:25 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: russell@coker.com.au, Lennart Poettering <lennart@poettering.net>
CC: kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org, systemd-devel@lists.freedesktop.org
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <1709025.rRUgx5gMp1@xev> <20140616101448.GB18016@tango.0pointer.de> <1753705.q94Xp43O1l@xev>
In-Reply-To: <1753705.q94Xp43O1l@xev>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010902010708020501070708"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010902010708020501070708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-06-16 06:35, Russell Coker wrote:
> On Mon, 16 Jun 2014 12:14:49 Lennart Poettering wrote:
>> On Mon, 16.06.14 10:17, Russell Coker (russell@coker.com.au) wrote:
>>>> I am not really following though why this trips up btrfs though. I a=
m
>>>> not sure I understand why this breaks btrfs COW behaviour. I mean,
>>>> fallocate() isn't necessarily supposed to write anything really, it'=
s
>>>> mostly about allocating disk space in advance. I would claim that
>>>> journald's usage of it is very much within the entire reason why it
>>>> exists...
>>>
>>> I don't believe that fallocate() makes any difference to fragmentatio=
n on
>>> BTRFS.  Blocks will be allocated when writes occur so regardless of a=
n
>>> fallocate() call the usage pattern in systemd-journald will cause
>>> fragmentation.
>>
>> journald's write pattern looks something like this: append something t=
o
>> the end, make sure it is written, then update a few offsets stored at
>> the beginning of the file to point to the newly appended data. This is=

>> of course not easy to handle for COW file systems. But then again, it'=
s
>> probably not too different from access patterns of other database or
>> database-like engines...
>=20
> Not being too different from the access patterns of other databases mea=
ns=20
> having all the same problems as other databases...  Oracle is now selli=
ng ZFS=20
> servers specifically designed for running the Oracle database, but that=
's with=20
> "hybrid storage" "flash" (ZIL and L2ARC on SSD).  While BTRFS doesn't s=
upport=20
> features equivalent for ZIL and L2ARC it's easy to run a separate files=
ystem=20
> on SSD for things that need performance (few if any current BTRFS users=
 would=20
> have a database too big to entirely fit on a SSD).
>=20
> The problem we are dealing with is "database-like" access patterns on s=
ystems=20
> that are not designed as database servers.
>=20
> Would it be possible to get an interface for defragmenting files that's=
 not=20
> specific to BTRFS?  If we had a standard way of doing this then systemd=
-
> journald could request a defragment of the file at appropriate times.
>=20
While this is a wonderful idea, what about all the extra I/O this will
cause (and all the extra wear on SSD's)?  While I understand wanting
this to be faster, you should also consider the fact that defragmenting
the file on a regular basis is going to trash performance for other
applications.


--------------ms010902010708020501070708
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDYxNjExMTYyNVowIwYJKoZIhvcNAQkE
MRYEFHh17Gpne8/q2ruHkDzk5lrF8CP5MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAGGHYOqIlUR05jN5CTjNQIDygdb9jqS7BFDzwi8Wajtwpv7s
qKDG4EJZJKhZDS10f+idwKSQCflJ8EM2fbe1EOeakkaBKrCm1t5P5GYhZhgwsKnXWvOKtX+N
zVlzqVWZVniSroTnuno8ZRZhnftGjjqrx0P/wcHVdO82INBxxMFgpEQesmnXPc1yLJKivjsb
tVXmJCf1P60qzwDpl3sL2BMF8rvs6DPxtnuxyunoz7E5ZrvC2YlNYQ/pEKGaQyr331MHcUb+
w7YVPww176tc4OM7njKv4JqRhgpYYW+Phm/QfChlURTDdNCyJLbXLpu8szcocnldLpw4etvb
TN6wSK81Hpn3b/TQmXc93rrZIimO/z5hHsCO6WthaSCn0sf3gVK55g/G28N9DwMzoxHSzZ5o
eookjboKfpMBiEElFsvqlc9g3n2WtrVCiofAOydhheFkh7H4rhcnjlHzFM6FFKavEHjZvqYK
G1DdGhd/B1drWG2sLKjLdThGkEbCtVbRcu5CZNJ0dB6/xyca1Xaqn+N8S1IHXbCylDMzY7eV
2M+jsLDAk5QeyX/r/fE8jYtF0JOvt/BhPd7LU6vBkf2lxR4/t4aJtNTntM1iqx6ZzsTsmzAc
EJoQBp/tNKCL9axjuYdONxgo7kaJBikA84z5e95GQJyC5H7qzt/gYxi4WrF1AAAAAAAA
--------------ms010902010708020501070708--
