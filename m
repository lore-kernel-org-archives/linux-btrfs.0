Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:54780 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaHAKRs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Aug 2014 06:17:48 -0400
Received: by mail-qa0-f45.google.com with SMTP id cm18so3627428qab.4
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Aug 2014 03:17:47 -0700 (PDT)
Message-ID: <53DB6948.3000009@gmail.com>
Date: Fri, 01 Aug 2014 06:17:44 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs offline deduplication
References: <CAGqmi747VW41DOPR-uev5cDaYtJ=FzzMCVfNNqtF7OUwB1jLjg@mail.gmail.com>
In-Reply-To: <CAGqmi747VW41DOPR-uev5cDaYtJ=FzzMCVfNNqtF7OUwB1jLjg@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020105070903080404030606"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020105070903080404030606
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/31/2014 07:54 PM, Timofey Titovets wrote:
> Good time of day.
> I have several questions about data deduplication on btrfs.
> Sorry if i ask stupid questions or waste you time %)
>=20
> What about implementation of offline data deduplication? I don't see
> any activity on this place, may be i need to ask a particular person?
> Where the problem? May be a can i try to help (testing as example)?
>=20
> I could be wrong, but as i understand btrfs store crc32 checksum one
> per file, if this is true, may be make a sense to create small worker
> for dedup files? Like worker for autodefrag?
> With simple logic like:
> if sum1 =3D=3D sum2 && file_size1 =3D=3D file_size2; then
> if (bit_to_bit_identical(file1,2)); then merge(file1, file2);
> This can be first attempt to implement per file offline dedup
> What you think about it? could i be wrong? or this is a horrible crutch=
?
> (as i understand it not change format of fs)
>=20
> (bedup and other tools, its cool, but have several problem with these
> tools and i think, what kernel implementation can work better).
>=20
I think there may be some misunderstandings here about some of the
internals of BTRFS.  First of all, checksums are stored per block, not
per file, and secondly, deduplication can be done on a much finer scale
than individual files (you can deduplicate individual extents).

I do think however that having the option of a background thread doing
deduplication asynchronously is a good idea, but then you would have to
have some way to trigger it on individual files/trees, and triggering on
writes like the autodefrag thread does doesn't make much sense.  Having
some userspace program to tell it to run on a given set of files would
probably be the best approach for a trigger.  I don't remember if this
kind of thing was also included in the online deduplication patches that
got posted a while back or not.


--------------ms020105070903080404030606
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDgwMTEwMTc0NFowIwYJKoZIhvcNAQkE
MRYEFHNf9Fushc8jYhW0zZOjeFm3TvUVMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAE9oJxW95JjrWo7MDkcQ7hzOImkkM6sGBY1j9VAucG917ULt
Tny5YpA3XkqqmjR5eyastA45rGthA7FEAC4COyD2HcDqBYCuC60nzTFUO+OmbSKmKKC3BFR+
u78+QvLz9soAlmKiVhaF4lWKG6OLz8aLvHY7pisOm7W1sc7Cbp8X7zbeM1G7XFsuOl1PSlVN
2eJcj1UoY9cEiLD+Qh8xhPvQcrOdyP3Fq5JFliTeDeWJWZCY0mpmQTj4fTnpzM+7JLIrvl5y
x4o+KH4f8wjHqIrN+X/fbnbnr1m4TgOH0kzIi9R7iJCqVVIzNueTmN7XN9vNmh95ENEXA4ZF
+DxzbJUmBgtybdzrQo8/LPstaEXCHEVcuj9mIEaJBEPp5XrzaLoWy84jD9HgTdVGgBj/5auK
OYu5VSyju5lruIBYI/4s+PhREDaL3v2TIxt4kgFcXH6Abf8p49WKuVXf6kXmG66imIy9aWVL
5ujPkFjbWlgWdWq/yaXAzAbWjl+tUo8nWOi/HyZmzZjmTEIe/pWvZhi+k3ful5bgh937qBkZ
tqhlh5jPzzg3kcw2Od1eUWG7qxOCHDfeYELahKVZQlBU+36IrM4v69jC8kugKibjjgNTaJYu
2MpYea5uF/wLhRECsQ36cijfgWa1ZcZ3e/EyklVg1/gSJdVgRWJ6GmZQX5jSAAAAAAAA
--------------ms020105070903080404030606--
