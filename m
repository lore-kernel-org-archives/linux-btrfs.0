Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:62703 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHATSu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Aug 2014 15:18:50 -0400
Received: by mail-qg0-f52.google.com with SMTP id f51so6105507qge.39
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Aug 2014 12:18:49 -0700 (PDT)
Message-ID: <53DBE816.9050209@gmail.com>
Date: Fri, 01 Aug 2014 15:18:46 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: dsterba@suse.cz, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Btrfs offline deduplication
References: <CAGqmi747VW41DOPR-uev5cDaYtJ=FzzMCVfNNqtF7OUwB1jLjg@mail.gmail.com> <53DB6948.3000009@gmail.com> <20140801132308.GF1553@twin.jikos.cz> <53DBA128.8060605@gmail.com> <20140801185559.GG2203@wotan.suse.de>
In-Reply-To: <20140801185559.GG2203@wotan.suse.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060902050306060009030407"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060902050306060009030407
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/01/2014 02:55 PM, Mark Fasheh wrote:
> On Fri, Aug 01, 2014 at 10:16:08AM -0400, Austin S Hemmelgarn wrote:
>> On 2014-08-01 09:23, David Sterba wrote:
>>> On Fri, Aug 01, 2014 at 06:17:44AM -0400, Austin S Hemmelgarn wrote:
>>>> I do think however that having the option of a background thread doi=
ng
>>>> deduplication asynchronously is a good idea, but then you would have=
 to
>>>> have some way to trigger it on individual files/trees, and triggerin=
g on
>>>> writes like the autodefrag thread does doesn't make much sense.  Hav=
ing
>>>> some userspace program to tell it to run on a given set of files wou=
ld
>>>> probably be the best approach for a trigger.  I don't remember if th=
is
>>>> kind of thing was also included in the online deduplication patches =
that
>>>> got posted a while back or not.
>>>
>>> IIRC the proposed implementation only merged new writes with existing=

>>> data.
>>>
>>> For the out-of-band ("off-line") dedup there's bedup
>>> (https://github.com/g2p/bedup) or Mark's duperemove tool
>>> (https://github.com/markfasheh/duperemove) that work on a set of file=
s.
>>>
>> Something kernel-side to do the work asynchronously would be nice,
>> especially if it could leverage the check-sums that BTRFS already stor=
es
>> for the blocks.  Having a userspace interface for offline deduplicatio=
n
>> similar to that for scrub operations would even better.
>=20
> Why does this have to be kernel side? There's userspace software alread=
y to
> dedupe that can be run on a regular basis. Exporting checksums is a
> differnet story (you can do that via ioctl) but running the dedupe soft=
ware
> itself inside the kernel is exactly what we want to avoid by having the=

> dedupe ioctl in the first place.
> 	--Mark
>=20
> --
> Mark Fasheh
>=20
Based on the same logic however, we don't need scrub to be done kernel
side, as it wouldn't take but one more ioctl to be able to tell it which
block out of a set to treat as valid.  I'm not saying that things need
to be done in the kernel, but duperemove doesn't use the ioctl interface
even if it exists, and bedup is buggy as hell (unless it's improved
greatly in the last two weeks), and neither of them is at all efficient.
 I do understand that this isn't something that is computationally
simple (especially on x86 with it's defficiency of registers), but rsync
does almost the same thing for data transmission over the network, and
it does so seemingly much more efficiently than either option available
at the moment.


--------------ms060902050306060009030407
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDgwMTE5MTg0NlowIwYJKoZIhvcNAQkE
MRYEFEC6MPBUK5TAHgYneDqwOCRy3bOrMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAHZf63Kiv46Xko9TeY5Ay75RCY7DhAI0ysGuPj0wFe2hbKTE
Uds2oTvCtDJ7tQ67fuVdaOayk8ooBrYlVdA/VgIXZfVsa6iSrw0zNl+S+YO+Fa7sRwI7eRqX
XqM4VmzBQVD5QlPC6fg4U7oTHK/b53d3LBUBfZcfpV/uqOK/JwfBZDXXQHkbdhLOxX6Fs04A
nibkG+SS2bDVWCviMQFHRJQcHg3JAPQJ3APIZD7Bo8dQClTRGaf59zkxTiF7VEFrhgzpzW+C
muKE0liyCDS586idFEJzvS6NoNQQSOarzx7V9OJX2CJOTKxVNVDe98mzvXJUrkWiqLrIffWD
Ai0WVpaJlxwlnUFX/fiRYtZWYgVO3PBEDlstUy4L7qIAJgeYH7dR/CG2XViQgKE6tz+kaxBl
EpV08OTTD/tIw8WK/ZLZzSOU0jb92crJdELzT/PiEyU0vf/+pdVaGzqmnLdp3hAXq+q6I7vH
sMlSzC6uI+n5flNWSvmILNbgzdVlJ+2dxrv/mU7Q5YVWTIPyUNEdZp2SOjKsIGwhEwvsUBnS
SejiP3X7P5D4Z4tF6DGnLAXzFFjKQRteIgbKeRyw2RCiEyTWo1myThPOd3YrmIlyCmG44O2M
AeGfgqlphkm5/1QSYn7Z3zI1Opfhgo6U0daQflUXAb7QI5dCj2OsAkInBdEoAAAAAAAA
--------------ms060902050306060009030407--
