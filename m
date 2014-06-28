Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52962 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaF1D2a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 23:28:30 -0400
Received: by mail-qc0-f174.google.com with SMTP id x13so5160631qcv.19
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 20:28:29 -0700 (PDT)
Message-ID: <53AE365B.10105@gmail.com>
Date: Fri, 27 Jun 2014 23:28:27 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: russell@coker.com.au, linux-btrfs@vger.kernel.org
Subject: Re: [Question] Btrfs on iSCSI device
References: <CAMXuLLrhMv82LPveRemDU_v_Kru2US6sKVn377gS3t9p-VFrag@mail.gmail.com> <53AD9D1A.4050703@libero.it> <2173101.6G0fsERxkf@xev>
In-Reply-To: <2173101.6G0fsERxkf@xev>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060504020207010906020105"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060504020207010906020105
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/27/2014 07:40 PM, Russell Coker wrote:
> On Fri, 27 Jun 2014 18:34:34 Goffredo Baroncelli wrote:
>> I don't think that it is possible to mount the _same device_ at the _s=
ame
>> time_ on two different machines. And this doesn't depend by the filesy=
stem.
>=20
> If you use a clustered filesystem then you can safely mount it on multi=
ple=20
> machines.
>=20
> If you use a non-clustered filesystem it can still mount and even appea=
r to=20
> work for a while.  It's surprising how many writes you can make to a du=
al-
> mounted filesystem that's not designed for such things before you get a=
=20
> totally broken filesystem.
>=20
> On Fri, 27 Jun 2014 13:15:16 Austin S Hemmelgarn wrote:
>> The reason it appears to work when using iSCSI and not with directly
>> connected parallel SCSI or SAS is that iSCSI doesn't provide low level=

>> hardware access.
>=20
> I've tried this with dual-attached FC and had no problems mounting.  In=
 what=20
> way is directly connected SCSI different from FC?
>=20
FC is actually it's own networking stack (and you can even run (in
theory) other protocols like IP and ATM on top of it), whereas parallel
SCSI is just a multi-drop bus, and SAS is just a tree-structured bus
with point-to-point communications emulated on top of it.  In other
words, parallel SCSI has topological constraints like RS-485, SAS has
topology constraints like USB, and FC has topology constraints like
Ethernet.

Secondarily, most filesystems on Linux will let you mount them multiple
times on separate hosts (ext4 has features to prevent this, but they are
expensive and therefore turned off by default, I think XFS might have
similar features, but I'm not sure).  BTRFS should in theory be more
resilient than most because of the COW nature (as long as it's only a
few commit cycles, you should still be able to recover most of the data
just fine).


--------------ms060504020207010906020105
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDYyODAzMjgyN1owIwYJKoZIhvcNAQkE
MRYEFCc1VbOus3+Xtjh2f9Qkyj1if6AAMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAKaiWzUr0TfOIwfkq4ndzwRlJQeR0cjQu8WW+U5SeVYoEbKI
tr2S4yf7VVhxu1NSeMxSKm8St22r7p3lwi6TsfmKffUABGY7A/W/qi9nl/SjrZQ27L6oanwu
w2Qt+0AKtKIXHcicp0xlGQdGcHbMSMTJRXONULggZOSF0HTXhb1fdHJpj7r1RqqNJp9Hm42w
rkbrhy7EKDbWlKjdXybrlPA2LyyEUCkZPlWfoCmdkOXwOPboFYhctPs+itEZorjbIKF/+hY6
/0j9CBeuxQMWZfQjgyGsjKh8+Y8SX1JoExiuGyRhhzs+J+FmaoKYNzy93ZLObKi4OY31TJOw
W4FOXLDDSQdRWn49MhWpSu+shg9etMilqqsLHP84Tuqg+vz07S+pufEzihTlWei7D7roihr+
QxmHTU1L5QHJXLvYFJk7wBNA6ikGYTwQJI28ZLtvhzngTliOwRNOXs5U/u/BbJkAAIuvVuGx
c3DD4BF+sfqPln1s21ayHTUXDW8nEq5Q4vJ9Mn6zDh8QO/EFQbIdsqaIM3xKmpATWUBFDACa
90wgrueHTpv/IpFoc/hTRu8vlZCaGWOI7XA0qOI4Jug2NOoMS+KEp0cc63nce/CRjqKzb/t9
5QBQ1LGuflWtWQaR2SxtYfiomnxaYEh61ERgNfgLuRp4/oTwfXDPJ+UJlnS4AAAAAAAA
--------------ms060504020207010906020105--
