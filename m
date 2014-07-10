Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:33994 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaGJL2n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 07:28:43 -0400
Received: by mail-ie0-f180.google.com with SMTP id at20so830682iec.39
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 04:28:42 -0700 (PDT)
Message-ID: <53BE78E2.40005@gmail.com>
Date: Thu, 10 Jul 2014 07:28:34 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: russell@coker.com.au, Martin Steigerwald <ms@teamix.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs RAID with enterprise SATA or SAS drives
References: <4FAAE94D.4010103@pocock.com.au> <41327882.AW8TtKTnAV@merkaba> <1873412.YKCevnRR4J@russell.coker.com.au>
In-Reply-To: <1873412.YKCevnRR4J@russell.coker.com.au>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060501020404030604030003"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060501020404030604030003
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-07-09 22:10, Russell Coker wrote:
> On Wed, 9 Jul 2014 16:48:05 Martin Steigerwald wrote:
>>> - for someone using SAS or enterprise SATA drives with Linux, I
>>> understand btrfs gives the extra benefit of checksums, are there any
>>> other specific benefits over using mdadm or dmraid?
>>
>> I think I can answer this one.
>>
>> Most important advantage I think is BTRFS is aware of which blocks of =
the
>> RAID are in use and need to be synced:
>>
>> - Instant initialization of RAID regardless of size (unless at some
>> capacity mkfs.btrfs needs more time)
>=20
> From mdadm(8):
>=20
>        --assume-clean
>               Tell mdadm that the array pre-existed and is known to be =
 clean.
>               It  can be useful when trying to recover from a major fai=
lure as
>               you can be sure that no data will be affected unless  you=
  actu=E2=80=90
>               ally  write  to  the array.  It can also be used when cre=
ating a
>               RAID1 or RAID10 if you want to avoid the initial resync, =
however
>               this  practice  =E2=80=94 while normally safe =E2=80=94 i=
s not recommended.  Use
>               this only if you really know what you are doing.
>=20
>               When the devices that will be part of a new  array  were =
 filled
>               with zeros before creation the operator knows the array i=
s actu=E2=80=90
>               ally clean. If that is the case,  such  as  after  runnin=
g  bad=E2=80=90
>               blocks,  this  argument  can be used to tell mdadm the fa=
cts the
>               operator knows.
>=20
> While it might be regarded as a hack, it is possible to do a fairly ins=
tant=20
> initialisation of a Linux software RAID-1.
>
This has the notable disadvantage however that the first scrub you run
will essentially preform a full resync if you didn't make sure that the
disks had identical data to begin with.
>> - Rebuild after disk failure or disk replace will only copy *used* blo=
cks
>=20
> Have you done any benchmarks on this?  The down-side of copying used bl=
ocks is=20
> that you first need to discover which blocks are used.  Given that seek=
 time is=20
> a major bottleneck at some portion of space used it will be faster to j=
ust=20
> copy the entire disk.
>=20
> I haven't done any tests on BTRFS in this regard, but I've seen a disk =

> replacement on ZFS run significantly slower than a dd of the block devi=
ce=20
> would.
>=20
First of all, this isn't really a good comparison for two reasons:
1. EVERYTHING on ZFS (or any filesystem that tries to do that much work)
is slower than a dd of the raw block device.
2. Even if the throughput is lower, this is only really an issue if the
disk is more than half full, because you don't copy the unused blocks

Also, while it isn't really a recovery situation, I recently upgraded
from a 2 1TB disk BTRFS RAID1 setup to a 4 1TB disk BTRFS RAID10 setup,
and the performance of the re-balance really wasn't all that bad.  I
have maybe 100GB of actual data, so the array started out roughly 10%
full, and the re-balance only took about 2 minutes.  Of course, it
probably helps that I make a point to keep my filesystems de-fragmented,
scrub and balance regularly, and don't use a lot of sub-volumes or
snapshots, so the filesystem in question is not too different from what
it would have looked like if I had just wiped the FS and restored from a
backup.
>> Scrubbing can repair from good disk if RAID with redundancy, but SoftR=
AID
>> should be able to do this as well. But also for scrubbing: BTRFS only
>> check and repairs used blocks.
>=20
> When you scrub Linux Software RAID (and in fact pretty much every RAID)=
 it=20
> will only correct errors that the disks flag.  If a disk returns bad da=
ta and=20
> says that it's good then the RAID scrub will happily copy the bad data =
over=20
> the good data (for a RAID-1) or generate new valid parity blocks for ba=
d data=20
> (for RAID-5/6).
>=20
> http://research.cs.wisc.edu/adsl/Publications/corruption-fast08.html
>=20
> Page 12 of the above document says that "nearline" disks (IE the ones p=
eople=20
> like me can afford for home use) have a 0.466% incidence of returning b=
ad data=20
> and claiming it's good in a year.  Currently I run about 20 such disks =
in a=20
> variety of servers, workstations, and laptops.  Therefore the probabili=
ty of=20
> having no such errors on all those disks would be .99534^20=3D.91081.  =
The=20
> probability of having no such errors over a period of 10 years would be=
=20
> (.99534^20)^10=3D.39290 which means that over 10 years I should expect =
to have=20
> such errors, which is why BTRFS RAID-1 and DUP metadata on single disks=
 are=20
> necessary features.
>=20



--------------ms060501020404030604030003
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDcxMDExMjgzNFowIwYJKoZIhvcNAQkE
MRYEFNU+pL7+fN83mQdvp/Q3GmgUXWtUMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAHu3Ek2rlhDGirgX2vPV/Uo+/s1ZLZFOucWvG524AVewtJFr
O3UBbLtA6b6ymCqqyUT8PyPqIIESm9KXLHbnculBaiziOdV2pHzZ1OkSss8x7Ry4TzLzR4r6
a453ToJ4m+4sgg/wtvZZOd1ILD5lbVaSE5V4U45Iw3t5ba+XL5DEbKCtghaOssjz8EWMXpzb
daq8ttJ4ygiUtXFrQFc8d+dMJ5AA4OyqlcnbspPd3EUpSVGMbzWiajT5EBgcgYBeQGS5O5ew
NcCv6oDz4/kfbVi2q8pWyKvZicu/ghps/ykAkKn8E1Jc8/gKz8M5OYwdcQzGkwcWdmaGBd/t
5pGjPnqaIFZpO4I+BpgtLF5wOMxD7fOLcUpEZwRY1b0xeTOo3D4rx5sUzJMc6kXjq2TG2WRP
TL0wMjaMQFeDTzY9VJQ+5h27LW8dO0Cw+g6BkPgK9ivIVsyBnjoU/BRWzsWvspJrlDrGZyaa
W7AT3b0sfDNU2O9fcWy8D4w4HedJBH0PX7tGBfrNkPE/oEbqrA3shqqr3+fbV9pti6J9hCKp
kk/OsyIuQw2kov9MUIeH5cyzfPOylml4L6raz8W5tHTmMBmmlDW/Eh6+Swb41M3WmGTm/jFW
dCTbyaKg9Ac1S/Lz05A3vfHvCmEEekNW5wsgpu2Dvcx9zTivtWbJ4cwNGuA+AAAAAAAA
--------------ms060501020404030604030003--
