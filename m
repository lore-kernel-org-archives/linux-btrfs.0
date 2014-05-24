Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:49520 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaEXTHi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 May 2014 15:07:38 -0400
Received: by mail-qg0-f50.google.com with SMTP id z60so9904512qgd.23
        for <linux-btrfs@vger.kernel.org>; Sat, 24 May 2014 12:07:37 -0700 (PDT)
Message-ID: <5380EDF7.6010606@gmail.com>
Date: Sat, 24 May 2014 15:07:35 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: john terragon <jterragon@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: is it safe to change BTRFS_STRIPE_LEN?
References: <CANg_oxybdjtOXrqo=yLPEKEz=NrJtSRfGgMxDeCQP+0EAbV_Qw@mail.gmail.com>
In-Reply-To: <CANg_oxybdjtOXrqo=yLPEKEz=NrJtSRfGgMxDeCQP+0EAbV_Qw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010601000602060402060402"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010601000602060402060402
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/24/2014 12:44 PM, john terragon wrote:
> Hi.
>=20
> I'm playing around with (software) raid0 on SSDs and since I remember
> I read somewhere that intel recommends 128K stripe size for HDD arrays
> but only 16K stripe size for SSD arrays, I wanted to see how a
> small(er) stripe size would work on my system. Obviously with btrfs on
> top of md-raid I could use the stripe size I want. But if I'm not
> mistaken the stripe size with the native raid0 in btrfs is fixed to
> 64K in BTRFS_STRIPE_LEN (volumes.h).
> So I was wondering if it would be reasonably safe to just change that
> to 16K (and duck and wait for the explosion ;) ).
>=20
> Can anyone adept to the inner workings of btrfs raid0 code confirm if
> that would be the right way to proceed? (obviously without absolutely
> any blame to be placed on anyone other than myself if things should go
> badly :) )
I personally can't render an opinion on whether changing it would make
things break or not, but I do know that it would need to be changed both
in the kernel and the tools, and the resultant kernel and tools would
not be entirely compatible with filesystems produced by the regular
tools and kernel, possibly to the point of corrupting any filesystem
they touch.

As for the 64k default strip size, that sounds correct, and is probably
because that's the largest block that the I/O schedulers on Linux will
dispatch as a single write to the underlying device.


--------------ms010601000602060402060402
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDUyNDE5MDczNVowIwYJKoZIhvcNAQkE
MRYEFFpDeUovW+MWQTNPoHN9JU2a4wbqMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAGRED0vHAljdeKmVjpmFH5f69Qplz3vPNsFpyB+HSDc6f0DI
QfRszPC9Rc4t8caaqlBxQt4d+CD0AUZ75U31dG126hHJ4H4Ahx19Q9PYebXohWC6kFFDLx5l
45qes50OmVL5TfSl1jnUckagOwFjBBV/jPk7mkKP1awwovpEE6EdwGhl6vNyRvkp/wQXHs3/
Nb9lYTMZtP1zwETw+Z/F/QEHV9NTH5UhHVrMU3/CT3iBsmwTNQukyZCMRDu5gy5mIudiNJmu
QXaUGAWUkW/6rmkyO+YbgrG768wtWQvSTcgzX03MdxAVA099x1t96tyXHjYKEg5RL+DK/W0h
npA49quzm9H8x8z62tN65VXJRe2KSG/caf1eXZif0LbhS76v5AE0jVOg2Q39xNt2DsYUjYkH
qzweBQyv2RTmopRcimIcugkrPEkkmgVYPGTrrOweITaLErmZTb0SKvs8oRbSHUPNFabBnt5L
Hz3YZA0REp8X84S3WwGsXEIwTRxkaxfnOr92eDcmcX4y8KcLIwvemuLynHzFx6A/Bkzg19NT
7Vxpe3P7TLl1O/+GG1LO3E7FfRpR2VnnjzN65vs98iIrI7oJKG+iCO1L/iTJVZj+xd9j5Foz
K+GSKCDPrJnY5BxzTUbF028VJGICcsvdDq1mpi4RDqm7+Z9z0xrVK8Po1NulAAAAAAAA
--------------ms010601000602060402060402--
