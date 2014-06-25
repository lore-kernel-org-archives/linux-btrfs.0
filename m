Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:45441 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaFYCUi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 22:20:38 -0400
Received: by mail-qc0-f172.google.com with SMTP id o8so1146833qcw.3
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 19:20:38 -0700 (PDT)
Message-ID: <53AA31F3.6090702@gmail.com>
Date: Tue, 24 Jun 2014 22:20:35 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Gerald Hopf <gerald.hopf@nv-systems.net>, linux-btrfs@vger.kernel.org
Subject: Re: "-d single" for data blocks on a multiple devices doesn't work
 as it should
References: <53A955F8.8090101@nv-systems.net> <pan$22dbe$42ad0785$2759193a$9b9beea1@cox.net> <53A9F2F2.3030402@nv-systems.net>
In-Reply-To: <53A9F2F2.3030402@nv-systems.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030002020204060708040909"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030002020204060708040909
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

> I somehow have doubts that a complex filesystem is the right project fo=
r
> me to start learning C, so I'll have to pass :-) No huge corporation
> with that itch behind me either, and I guess it will be more than a few=

> hours for a btrfs programmer so no way I could sponsor that on my own.

Whether or not it is the right project really depends on where you
intend to do most of your C programming.  If you plan to do most of it
in kernel code and occasional userspace wrappers for kernel interfaces
(like me), then it could be a great place because it's under such heavy
development (which means more developers are working on it, and bugs get
spotted faster, both of which are good things for project you are using
to learn a language).  If, however, you intend to use it mostly for
userspace, then I would definitely agree with you, programming in
userspace and kernel-space are so different that it's almost like a
different language using the same syntax and similar semantics.


--------------ms030002020204060708040909
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDYyNTAyMjAzNVowIwYJKoZIhvcNAQkE
MRYEFK69vQN6CySI58BHXUL4mhrcyYLBMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICADYABgKFyzqrbl86Rntw1V9Ha22m8GSMtroRWBth7PbbSz1s
LFBbog60cuYZL88m+1a7xeM9w3EHjLm4A7TG3YavX24qZrlm2oMcd3BhW5R3egB5miDvwVjh
09d7AswVfq1wWOGe0YUSIJIPQB2hJabhgzv9y1T4EqnxviPCqBH0fAtCT8E3P5rTUj+tm6R9
EvQJGo15BOVIxhp3NytFHZK/NLWE8vJplum+t7nXHp1Nvut1F5uF+pKQHGB3N5xQpicae3Dq
GcwF67H6dbYa3FPWUCFZ5i8RnKhRLlypLYqmlBIjUt4XGuAYE0lVm6MIBiUYtkUybp0AwSyZ
2nRWeOu7xcEvOKEbpPXP/+XV6zLVF8wsymtoSX4fXhFE+6OQLsORsDr16QCNsYsn+1/fV5Jg
kXub9OgcAecnPCtNqLkeMU5wdlBCeXZ/2pHzfSFZhyYw9rSOm2/OiQjiTEgRM5Wvez6T5pQZ
LbyYgNoGIQEQdEfAVvfnkq0m7FFxPBBhES7xzXsuE1uoQD2zi8anUGq/2TurjATX2Q+VpHh4
g0pmai9pOEtEu62Tqj/FXyHtuklwXmDbLtzPjfC6NDSMyiicZXbLAT6e54QVqqwd0AgMwfC+
36IIWQPXD4jkdM7y1Yqs7+NWVIsS4Au2MLX+5U2lKI6ZbtvuZUf/JRgkgIXlAAAAAAAA
--------------ms030002020204060708040909--
