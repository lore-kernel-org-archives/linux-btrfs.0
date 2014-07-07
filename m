Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:61544 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaGGOOo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 10:14:44 -0400
Received: by mail-ie0-f181.google.com with SMTP id y20so3683403ier.12
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jul 2014 07:14:43 -0700 (PDT)
Message-ID: <53BAAB37.7030800@gmail.com>
Date: Mon, 07 Jul 2014 10:14:15 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        =?UTF-8?B?QW5kcsOpLVNl?= =?UTF-8?B?YmFzdGlhbiBMaWViZQ==?=
	<andre@lianse.eu>,
        linux-btrfs@vger.kernel.org
Subject: Re: mount time of multi-disk arrays
References: <53BAA2E5.2090801@lianse.eu> <53BAA67D.1050101@gmail.com>
In-Reply-To: <53BAA67D.1050101@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080708030104080005000100"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080708030104080005000100
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-07-07 09:54, Konstantinos Skarlatos wrote:
> On 7/7/2014 4:38 =CE=BC=CE=BC, Andr=C3=A9-Sebastian Liebe wrote:
>> Hello List,
>>
>> can anyone tell me how much time is acceptable and assumable for a
>> multi-disk btrfs array with classical hard disk drives to mount?
>>
>> I'm having a bit of trouble with my current systemd setup, because it
>> couldn't mount my btrfs raid anymore after adding the 5th drive. With
>> the 4 drive setup it failed to mount once in a few times. Now it fails=

>> everytime because the default timeout of 1m 30s is reached and mount i=
s
>> aborted.
>> My last 10 manual mounts took between 1m57s and 2m12s to finish.
> I have the exact same problem, and have to manually mount my large
> multi-disk btrfs filesystems, so I would be interested in a solution as=

> well.
>=20
>>
>> My hardware setup contains a
>> - Intel Core i7 4770
>> - Kernel 3.15.2-1-ARCH
>> - 32GB RAM
>> - dev 1-4 are 4TB Seagate ST4000DM000 (5900rpm)
>> - dev 5 is a 4TB Wstern Digital WDC WD40EFRX (5400rpm)
>>
>> Thanks in advance
>>
>> Andr=C3=A9-Sebastian Liebe
>> ----------------------------------------------------------------------=
----------------------------
>>
>>
>> # btrfs fi sh
>> Label: 'apc01_pool0'  uuid: 066141c6-16ca-4a30-b55c-e606b90ad0fb
>>          Total devices 5 FS bytes used 14.21TiB
>>          devid    1 size 3.64TiB used 2.86TiB path /dev/sdd
>>          devid    2 size 3.64TiB used 2.86TiB path /dev/sdc
>>          devid    3 size 3.64TiB used 2.86TiB path /dev/sdf
>>          devid    4 size 3.64TiB used 2.86TiB path /dev/sde
>>          devid    5 size 3.64TiB used 2.88TiB path /dev/sdb
>>
>> Btrfs v3.14.2-dirty
>>
>> # btrfs fi df /data/pool0/
>> Data, single: total=3D14.28TiB, used=3D14.19TiB
>> System, RAID1: total=3D8.00MiB, used=3D1.54MiB
>> Metadata, RAID1: total=3D26.00GiB, used=3D20.20GiB
>> unknown, single: total=3D512.00MiB, used=3D0.00

This is interesting, I actually did some profiling of the mount timings
for a bunch of different configurations of 4 (identical other than
hardware age) 1TB Seagate disks.  One of the arrangements I tested was
Data using single profile and Metadata/System using RAID1.  Based on the
results I got, and what you are reporting, the mount time doesn't scale
linearly in proportion to the amount of storage space.

You might want to try the RAID10 profile for Metadata, of the
configurations I tested, the fastest used Single for Data and RAID10 for
Metadata/System.

Also, based on the System chunk usage, I'm guessing that you have a LOT
of subvolumes/snapshots, and I do know that having very large (100+)
numbers of either does slow down the mount command (I don't think that
we cache subvolume information between mount invocations, so it has to
re-parse the system chunks for each individual mount).


--------------ms080708030104080005000100
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDcwNzE0MTQxNVowIwYJKoZIhvcNAQkE
MRYEFF0Wd24xOW7+u1vrbWB11UOaN5YWMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAMhPh5SnaXS21k582XGZhFrYZS4AjySQ5oMIhWr3nzn/htyY
f2u7JhS6/xTDLxn2ko7A1rIvnW6/2wEygxp9iGDTl/15fAgcRKCyLUZCWsl0eUMrDQNGE6mO
UdBgMHP0Iz7PVBsLgN6Lr8Cart/oVQMt7GYpm5h9EtulS0W9dkN9TaWB7BPiEua7US8TGWg3
l4ezexe+515n6AJ7gDB5wk98O6f98/mWJFzIMwB1N3Dnmhd0xejIJjUAK960CRAO8XO7glpj
xVqo7KLG/WXU7hMUOsNytnEKS1RWC8qqsUfxGuQOsb744qRFeR3xRh7hx7re8iRfqB6W85GW
Ybmq9eIh0IQ27vNZfNuek+82Ve1oZuu5cNgnIxbaUKQOU/z5F1QZdexR5s08tUzUO4GMXaED
b0TsEan5/Zq2cXSi7PTnvEILtV14bFdQuPWWGo/oFAbliSNyHV1zAdzEqO8cIKAwRHBmXTUy
JJQjx4ZymidBs9WaNnLvU9XZmwQgDFF8fZWZkMp2LhYeAaCjkpGjhssottS+mDn4zk9T51Lw
PhJRM75LICBKGfviTZox1fUTCNCkO3TwHKp7lai6leEiO4thZLx2XSwHCi2BirndvhTSBOCu
dfBPPKVr7s2NoxSMERG6V9EMh8cW9v7c7LQPphsttk8WTudbSVpzsJmMWtiKAAAAAAAA
--------------ms080708030104080005000100--
