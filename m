Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35286 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaETOHN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 10:07:13 -0400
Received: by mail-ie0-f176.google.com with SMTP id rl12so486535iec.35
        for <linux-btrfs@vger.kernel.org>; Tue, 20 May 2014 07:07:12 -0700 (PDT)
Message-ID: <537B6190.2030100@gmail.com>
Date: Tue, 20 May 2014 10:07:12 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: russell@coker.com.au, Brendan Hide <brendan@swiftspirit.co.za>,
        linux-btrfs@vger.kernel.org
Subject: Re: ditto blocks on ZFS
References: <2308735.51F3c4eZQ7@xev> <lldpvm$s7c$1@ger.gmane.org> <537A7BF9.5060508@swiftspirit.co.za> <4483661.BdmCOR8JR5@xev>
In-Reply-To: <4483661.BdmCOR8JR5@xev>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070703080409030108000701"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070703080409030108000701
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-05-19 22:07, Russell Coker wrote:
> On Mon, 19 May 2014 23:47:37 Brendan Hide wrote:
>> This is extremely difficult to measure objectively. Subjectively ... s=
ee
>> below.
>>
>>> [snip]
>>>
>>> *What other failure modes* should we guard against?
>>
>> I know I'd sleep a /little/ better at night knowing that a double disk=

>> failure on a "raid5/1/10" configuration might ruin a ton of data along=

>> with an obscure set of metadata in some "long" tree paths - but not th=
e
>> entire filesystem.
>=20
> My experience is that most disk failures that don't involve extreme phy=
sical=20
> damage (EG dropping a drive on concrete) don't involve totally losing t=
he=20
> disk.  Much of the discussion about RAID failures concerns entirely fai=
led=20
> disks, but I believe that is due to RAID implementations such as Linux =

> software RAID that will entirely remove a disk when it gives errors.
>=20
> I have a disk which had ~14,000 errors of which ~2000 errors were corre=
cted by=20
> duplicate metadata.  If two disks with that problem were in a RAID-1 ar=
ray=20
> then duplicate metadata would be a significant benefit.
>=20
>> The other use-case/failure mode - where you are somehow unlucky enough=

>> to have sets of bad sectors/bitrot on multiple disks that simultaneous=
ly
>> affect the only copies of the tree roots - is an extremely unlikely
>> scenario. As unlikely as it may be, the scenario is a very painful
>> consequence in spite of VERY little corruption. That is where the
>> peace-of-mind/bragging rights come in.
>=20
> http://research.cs.wisc.edu/adsl/Publications/corruption-fast08.html
>=20
> The NetApp research on latent errors on drives is worth reading.  On pa=
ge 12=20
> they report latent sector errors on 9.5% of SATA disks per year.  So if=
 you=20
> lose one disk entirely the risk of having errors on a second disk is hi=
gher=20
> than you would want for RAID-5.  While losing the root of the tree is=20
> unlikely, losing a directory in the middle that has lots of subdirector=
ies is=20
> a risk.
>=20
> I can understand why people wouldn't want ditto blocks to be mandatory.=
  But=20
> why are people arguing against them as an option?
>=20
>=20
> As an aside, I'd really like to be able to set RAID levels by subtree. =
 I'd=20
> like to use RAID-1 with ditto blocks for my important data and RAID-0 f=
or=20
> unimportant data.
>=20
But the proposed changes for n-way replication would already handle
this.  They would just need the option of having more than one copy per
device (which theoretically shouldn't be too hard once you have n-way
replication).  Also, BTRFS already has the option of replicating the
root tree across multiple devices (it is included in the System Data
subset), and in fact dose so by default when using multiple devices.
Also, there are plans to have per-subvolume or per file RAID level
selection, but IIRC that is planned for after n-way replication (and of
course, RAID 5/6, as n-way replication isn't going to be implemented
until after RAID 5/6)


--------------ms070703080409030108000701
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDUyMDE0MDcxMlowIwYJKoZIhvcNAQkE
MRYEFKdiB2bIbgBGxfPj4ksfSMysJBwJMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAA6uAagx98NtWQnpgMzax9ttIlU/2JGmsQbXGEzjGavUQ/js
Pr4uetDABXufz/7YtZzh7b5CfvSYilF79x+mft2/j1VpvP7aBMmN3sEib0ZrYJfwc7wMRmUu
iL+dRH6bHFX6Z6acockl2XfpNpMr1jJblxqDNaj4V4nUJIf6vlvG6Of2qYvlPg815Ow0X21X
IIMHE5j+A30ecLFieGDNCVYs5Vmi2JN0yxCjNLMd590XJaXERgnyHsrwWSBbIevHe7k16X+i
/Me9lJffIiMCBU7HEZ6gK+GiCOV9r00j6CmisFBspjLCHqMmTIbcHpiuQ8s6s6sEHELkw2vy
Hw+9OVwXDHAbO3kA58MLU5+gXzp28Hx9yZnP2paXgnGuGZ8zUyWSZpEKRoqnBJLJcAZmR2UF
JuuFFONkxy1rMld1EDxNWNyXm5Ve/6D0phRjJqYDYUH+wJJbaiWn4vlan0DCV6ErW/1PoBgA
qT8JSRbmHASb6pMM//u9TJOOqgBNGx51Swukmpl1dLBdxslb8Ul1VnYJkJ87l4prr+d/K28H
Pz+nBdHZL86Bg4TJtamEWF3Q5SqmULxU5IvMrnIO4e594vFkdzb4OekRZdrrO/i2gV+fyNDT
Za1kkhMeq9Fwm4DvON2sUH04fczZH6zb0GBlMpTfnWOk+u6hbp68GOR1TJQkAAAAAAAA
--------------ms070703080409030108000701--
