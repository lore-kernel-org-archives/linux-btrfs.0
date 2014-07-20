Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:33403 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaGTOuP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 10:50:15 -0400
Received: by mail-qa0-f51.google.com with SMTP id k15so4431849qaq.10
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 07:50:12 -0700 (PDT)
Message-ID: <53CBD721.2080502@gmail.com>
Date: Sun, 20 Jul 2014 10:50:09 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
References: <loom.20140720T102642-239@post.gmane.org> <pan$67ea$f06610e9$914a341d$b38b0b32@cox.net> <20140720140044.GB7469@mother.pipebreaker.pl>
In-Reply-To: <20140720140044.GB7469@mother.pipebreaker.pl>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020304040409050409080600"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020304040409050409080600
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/20/2014 10:00 AM, Tomasz Torcz wrote:
> On Sun, Jul 20, 2014 at 01:53:34PM +0000, Duncan wrote:
>> TM posted on Sun, 20 Jul 2014 08:45:51 +0000 as excerpted:
>>
>>> One week for a raid10 rebuild 4x3TB drives is a very long time.
>>> Any thoughts?
>>> Can you share any statistics from your RAID10 rebuilds?
>>
>>
>> At a week, that's nearly 5 MiB per second, which isn't great, but isn'=
t=20
>> entirely out of the realm of reason either, given all the processing i=
t's=20
>> doing.  A day would be 33.11+, reasonable thruput for a straight copy,=
=20
>> and a raid rebuild is rather more complex than a straight copy, so...
>=20
>   Uhm, sorry, but 5MBps is _entirely_ unreasonable.  It is order-of-mag=
nitude
> unreasonable.  And "all the processing" shouldn't even show as a blip
> on modern CPUs.
>   This "speed" is undefendable.
>=20
I wholly agree that it's undefendable, but I can tell you why it is so
slow, it's not 'all the processing' (which is maybe a few hundred
instructions on x86 for each block), it's because BTRFS still serializes
writes to devices, instead of queuing all of them in parallel (that is,
when there are four devices that need written to, it writes to each one
in sequence, waiting for the previous write to finish before dispatching
the next write).  Personally, I would love to see this behavior
improved, but I really don't have any time to work on it myself.


--------------ms020304040409050409080600
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDcyMDE0NTAwOVowIwYJKoZIhvcNAQkE
MRYEFE5tPKLxJn75oBPlTBovh9HUQMolMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAEDYf9EnPpSstv4HvWS0swr342sCM6FFusIE1ToZ82B+8ZkB
TVXbH92VjB/9iH2yjJFfHVxYraYUUM67H/ZB8phHSlxYsG8qzpV+uAi0j360Gt+pTBBHQdui
3kiXL3NM0a6z52PIYmrJSxpNo1DTbU4lYDbd6+jwM7F0Y6m/hHV+YGxItOpN3vtNuCVwTRcG
RlvXM/Hbpi4qdP2yEHUTGU2aH+stvtufUA9/tFtOI031isZ0YO/TEx4mU9zpwzp+DMhrjtcL
YvvTODiMsNg8TjReElfrOqaeAy4GkZ5FTgMv7o9hQu5+z92dHI/avwIQsc7XC91GLIZD1DWr
Mwws6rBt30fxwQG6HP26otKxGfImftFTjU1QXr8yDbf/QEq0DzA+dVlu+Sh84g8snY7XrLa/
87GRSWb5Qr/Ytrue5cfVScdpFIxidlvHFJNgSQjgyijzF3lRmdj9oYCurYFrfHJUVy9EYIe+
DzJoZ6aeMYNbFg7+dHKXQJAxKGyfOmNLlpMgL1m50rWLUpcqHAQyjS+pejPS9WOlyB1KNOei
1UJdJblFez/aP0h7ytsWdmOT4tW6SXiWTCo7NwbucfchfxjJzUzz80KTDQqUp34Niun1iLA0
F23lTa4cb7n+ksrDTnnCvgMZwlYa8m3bZswu4cIxJLGv69jPFKXDMqtnlDhSAAAAAAAA
--------------ms020304040409050409080600--
