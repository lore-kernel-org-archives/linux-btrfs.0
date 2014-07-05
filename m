Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:35098 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaGEQGV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jul 2014 12:06:21 -0400
Received: by mail-qa0-f50.google.com with SMTP id m5so2164302qaj.9
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Jul 2014 09:06:21 -0700 (PDT)
Message-ID: <53B8227A.30809@gmail.com>
Date: Sat, 05 Jul 2014 12:06:18 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Bob Williams <linux@barrowhillfarm.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: A question about subvolumes
References: <53B6BC65.3080302@barrowhillfarm.org.uk> <53B710C9.9020601@libero.it> <53B7176F.1020409@barrowhillfarm.org.uk> <53B79AE4.3030404@libero.it> <53B7E4D1.9070803@barrowhillfarm.org.uk>
In-Reply-To: <53B7E4D1.9070803@barrowhillfarm.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020404000607000901040407"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020404000607000901040407
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/05/2014 07:43 AM, Bob Williams wrote:
> On 05/07/14 07:27, Goffredo Baroncelli wrote:
>> On 07/04/2014 11:06 PM, Bob Williams wrote:
>>> On 04/07/14 21:38, Goffredo Baroncelli wrote:
>=20
>>>
>>> Thank you, Goffredo. As the current /home/bob is not a
>>> subvolume, but a regular linux directory/folder, will the "cp
>>> --reflink" still carry the same speed advantage?
>>>
>>> In other words, using your example above, will this work:
>>>
>>> # cp --reflink -R normal_directory-A/* subvolume-B/ # rm -rf=20
>>> normal_directory-A/
>=20
>> Yes.
>=20
>> If you want to move (or copy) files between subvolume, cp
>> --reflink is faster.
>=20
>=20
>> I have to point out that the "--reflink" is only an internal=20
>> detail. The two file are logically separated: if you after the
>> copy change the source, the destination is unaffected.
>=20
> Many thanks. Conversion of /home/bob to a subvolume completed
> uneventfully. :-) And very quickly, considering it is ~500GB. I have
> made a note of that --reflink option.
>=20
> Bob
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

I'm pretty certain that recent versions of the GNU Coreutils will
automatically try a reflink for cp if the underlying filesystem is
BTRFS.  I'm not 100% certain about this as I've just aliases cp to 'cp
--reflink=3Dauto' on all my systems.


--------------ms020404000607000901040407
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDcwNTE2MDYxOFowIwYJKoZIhvcNAQkE
MRYEFKlKXNPI3OR7Rc2plRSQuuqpO/O7MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAC0krgzjIPdwZSXzM9VD030l1bDdbAwutdN4P7O17ANeIGSb
G6LZ30mi/crJQKP/Ywto5CzAjmmRYJNkGpq8A3EQva6xnmhwU0y2Avfh9UM+uV8Mz9PMDubB
b7waSYR0JKDpHX19TkHn0O1KYxPM99ZDiGcZFvUGLuGZIvXIcHd1ZQFSMAKF66YjTR9//oXW
TSzVYA5fyoCS4KjajCH+4HtZkH7rpjF/wUvy/gRAp5TK48WRdT+bYUiOkHlvKr17RZyp4JJy
aucUU3GIFt2G0Qt9dXWfqbZlGuGB3fasOJHleThBaEVfOtRNSH6mHmAGY6nOdMd4ihs9+j6P
WroTMBpqIZY+ctwgwu7DHyQ4NEnCI0rPe7xKeiLZLOKPiW+uJMQh8KIWn6CtczUT9pPZmvCH
NR2jUBKOxMiubiz7ts0HDcwJqUJ82b0lqt447EK3Sz+9IJZ4dKbVbx/OlsqTE58WoMmbKN1B
KUJLztZmzuyoJop/ET0l33kB9zXGa2mP7CinkXP7CH8fE/uYitGejuFdmahWgOOvCoSN4e5n
87NBOHrrMj6ycrBpJfpyN+9u6OPWSOdEns4TLWZbbQoNEZwAzftKEMrZriOKkidW8yc7Hvr1
Ggep7dBadvIBk9TTM1GbvGa2slhKAF0tzXXLjhwvm0QPT84ZHxffJjjY4K3/AAAAAAAA
--------------ms020404000607000901040407--
