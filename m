Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:47020 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaFQAP3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 20:15:29 -0400
Received: by mail-qa0-f47.google.com with SMTP id hw13so7030184qab.6
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 17:15:29 -0700 (PDT)
Message-ID: <539F889D.5000102@gmail.com>
Date: Mon, 16 Jun 2014 20:15:25 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
CC: systemd-devel@lists.freedesktop.org
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <539BFF47.8060006@libero.it> <20140615221307.GE24386@tango.0pointer.de> <1709025.rRUgx5gMp1@xev> <20140616101448.GB18016@tango.0pointer.de> <539F15DC.4010600@fb.com> <lnnht8$f3j$1@ger.gmane.org>
In-Reply-To: <lnnht8$f3j$1@ger.gmane.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050001080201090608020600"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050001080201090608020600
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/16/2014 03:52 PM, Martin wrote:
> On 16/06/14 17:05, Josef Bacik wrote:
>>
>> On 06/16/2014 03:14 AM, Lennart Poettering wrote:
>>> On Mon, 16.06.14 10:17, Russell Coker (russell@coker.com.au) wrote:
>>>
>>>>> I am not really following though why this trips up btrfs though. I =
am
>>>>> not sure I understand why this breaks btrfs COW behaviour. I mean,
>=20
>>>> I don't believe that fallocate() makes any difference to
>>>> fragmentation on
>>>> BTRFS.  Blocks will be allocated when writes occur so regardless of =
an
>>>> fallocate() call the usage pattern in systemd-journald will cause
>>>> fragmentation.
>>>
>>> journald's write pattern looks something like this: append something =
to
>>> the end, make sure it is written, then update a few offsets stored at=

>>> the beginning of the file to point to the newly appended data. This i=
s
>>> of course not easy to handle for COW file systems. But then again, it=
's
>>> probably not too different from access patterns of other database or
>>> database-like engines...
>=20
> Even though this appears to be a problem case for btrfs/COW, is there a=

> more favourable write/access sequence possible that is easily
> implemented that is favourable for both ext4-like fs /and/ COW fs?
>=20
> Database-like writing is known 'difficult' for filesystems: Can a data
> log can be a simpler case?
>=20
>=20
>> Was waiting for you to show up before I said anything since most syste=
md
>> related emails always devolve into how evil you are rather than what i=
s
>> actually happening.
>=20
> Ouch! Hope you two know each other!! :-P :-)
>=20
>=20
> [...]
>> since we shouldn't be fragmenting this badly.
>>
>> Like I said what you guys are doing is fine, if btrfs falls on it's fa=
ce
>> then its not your fault.  I'd just like an exact idea of when you guys=

>> are fsync'ing so I can replicate in a smaller way.  Thanks,
>=20
> Good if COW can be so resilient. I have about 2GBytes of data logging
> files and I must defrag those as part of my backups to stop the system
> fragmenting to a stop (I use "cp -a" to defrag the files to a new area
> and restart the data software logger on that).
>=20
>=20
> Random thoughts:
>=20
> Would using a second small file just for the mmap-ed pointers help avoi=
d
> repeated rewriting of random offsets in the log file causing excessive
> fragmentation?
>=20
> Align the data writes to 16kByte or 64kByte boundaries/chunks?
>=20
> Are mmap-ed files a similar problem to using a swap file and so should
> the same "btrfs file swap" code be used for both?
>=20
>=20
> Not looked over the code so all random guesses...
>=20
> Regards,
> Martin
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
Just a thought, partly inspired by the mention of the swap code, has
anyone tried making the file NOCOW and pre-allocating to the max journal
size?  A similar approach has seemed to help on my systems with generic
log files (I keep debug level logs from almost everything, so I end up
with very active log files with ridiculous numbers of fragments if I
don't pre-allocate and mark them NOCOW).  I don't know for certain how
BTRFS handles appends to NOCOW files, but I would be willing to bet that
it ends up with a new fragment for each filesystem block worth of space
allocated.


--------------ms050001080201090608020600
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDYxNzAwMTUyNVowIwYJKoZIhvcNAQkE
MRYEFF1Iu2DRSLBByo3nfIj4YCES3GK3MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICANBDz7BiGJQLr9HrP0OIqxvzsbpz28/fwql6/nKHWc0/dOtJ
+vu5Ax8IkOS7K2GMY8ANMttiyOWao1O20Ew62L8Vvc24CSMjNiWTsei20vlm7rjFh7vFKm3y
K0q+oEmB8lz9I1O9f47SxuFBs5VwGwhZZ1DX/m/Y+HZ7q3t/Ntcw1ZH8h6UznLDCra4X2rHQ
cBs4REQyO6DUE60doEfX7Ip11/+zuSaBvQcdTu/NojCwtPEerUCvQujkA9e5gdaQvO0gGY0O
iCEku+VqenNVmqvomfPQHf60q4Fb0kj8Xp+0LlLxomBzGVlmS2vX+ga4q+UfAV1pyV37B0bb
Z6arFg9r4ECcDDZt47jgQ8nVrd2EM3rDviSMVPiUgBClY6VMof1Ff4O+2OYgDchfPqg8yuqw
NS3Te6zvqfTEMUs1CCJnjvE7rqfhjXXsBjPgc/CnpFAWPELSb5qeku6a9dY5I5/Xg7IWUw+b
h1+9c+uy28MKrdxzHB0dT86HUoh/vwFjr1gKQuQAbZ3FL/4fDWKslxEWSdfKb6989E6niZHe
Ept5qQGwGEwHPlR1QC2Ol+Wv7Bjo81qK6Ooc196zraqIIrFgjMj+QoTJtIBxWd/uk3X6t5wL
bndUzfK9ChTjQPI1qboaDrq1kKYpDj+bznTeqB/BnkMSs2oRjOprSZrewR/pAAAAAAAA
--------------ms050001080201090608020600--
