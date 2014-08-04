Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59436 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbaHDODH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 10:03:07 -0400
Received: by mail-ie0-f172.google.com with SMTP id lx4so9839310iec.31
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 07:03:06 -0700 (PDT)
Message-ID: <53DF9293.2090508@gmail.com>
Date: Mon, 04 Aug 2014 10:02:59 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Peter Waller <peter@scraperwiki.com>, linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com> <53DEE40C.6020403@cn.fujitsu.com> <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com> <17833067.mzxAL4oqZq@quad> <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com> <20140804102206.GA31950@carfax.org.uk> <CAFvQSYRDz1EW4CiKbRNEp0HKhciHPM+b_63CrOOko+D6aYPnvw@mail.gmail.com> <20140804113231.GD31950@carfax.org.uk> <CAFChkqv3N27jWxL=URgkZ1G86BFBo+-Cmg9emOO3G80OKY2n4g@mail.gmail.com>
In-Reply-To: <CAFChkqv3N27jWxL=URgkZ1G86BFBo+-Cmg9emOO3G80OKY2n4g@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000801060900080305050504"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000801060900080305050504
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-08-04 09:17, Peter Waller wrote:
> For anyone else having this problem, this article is fairly useful for
> understanding disk full problems and rebalance:
>=20
> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesy=
stem-Full-Problems.html
>=20
> It actually covers the problem that I had, which is that a rebalance
> can't take place because it is full.
>=20
> I still am unsure what is really wrong with this whole situation. Is
> it that I wasn't careful to do a rebalance when I should have been
> doing? Is it that BTRFS doesn't do a rebalance automatically when it
> could in principle?
>=20
> It's pretty bad to end up in a situation (with spare space) where the
> only way out is to add more storage, which may be impractical,
> difficult or expensive.
I really disagree with the statement that adding more storage is
difficult or expensive, all you need to do is plug in a 2G USB flash
drive, or allocate a ramdisk, and add the device to the filesystem only
long enough to do a full balance.
>=20
> The other thing that I still don't understand I've seen repeated in a
> few places, from the above article:
>=20
> "because the filesystem is only 55% full, I can ask balance to rewrite
> all chunks that are more than 55% full"
>=20
> Then he uses `btrfs balance start -dusage=3D55 /mnt/btrfs_pool1`. I
> don't understand the relationship between "the FS is 55% full" and
> "chunks more than 55% full". What's going on here?
To understand this, you have to understand that BTRFS uses a two level
allocation scheme, at the top level, you have chunks, which are
contiguous regions of the disk that get used for storing a specific
block type.  For data chunks, these default to 1G in size, for metadata,
they default to 256M in size.  When a filesystem is created, you get the
minimum number of chunks of each type based on the replication profiles
chosen for each chunk type; with no extra options, this means 1 data
chunk and 2 metadata chunks for a single disk filesystem.  Within each
chunk, BTRFS then allocates and frees individual blocks on demand, these
blocks are the analogue of blocks in most other filesystems.  When there
are no free blocks in any chunks of a given type, BTRFS then allocates
new chunks of that type based on the replication profile.  Unlike blocks
however, chunks aren't freed automatically (there are good reasons for
this behavior, but they are kind of long to explain here), this is where
balance comes in, it takes all of the blocks in the filesystem, and
sends them back through the block allocator.  This usually causes all of
the free blocks to end up in a single chunk, and frees the unneeded chunk=
s.

When someone talks about a chunk being x% full, they mean that x% of the
space in that chunk is used by allocated blocks.  Talking about how full
the filesystem is can get tricky because of the replication profiles,
but the usual consensus is to treat that as the percentage of the
filesystem that contains blocks that are being used.

It should say LESS than 55% full in the various articles, as the
-dusage=3Dx option tells balance to only consider chunks that are less
than 55% full for balancing.  In general, if your filesystem is totally
full, you should use numbers starting with 0, and working your way up
from there.  You may even get lucky, and using -dusage=3D0 -musage=3D0 ma=
y
free up enough chunks that you don't need to add more storage.
>=20
> I conclude that now since I have added more storage, the rebalance
> won't fail and if I keep rebalancing from a cron job I won't hit this
> problem again (unless the filesystem fills up very fast! what then?).
> I don't know however what value to assign to `-dusage` in general for
> the cron rebalance. Any hints?
I've found that something between 25 and 50 tends to do well, much
outside of that range and you start to get diminishing returns.  The
exact value tends to be more personal preference, I use 25 on most of my
systems, because I don't like saturating the disks with I/O for very
long.  Do make sure however to add -musage=3Dx as well, metadata also
should be balanced (especially if you have very large numbers of small
files).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20



--------------ms000801060900080305050504
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDgwNDE0MDI1OVowIwYJKoZIhvcNAQkE
MRYEFFl1T/nOIUK+FV+wZlaYXqskw9HxMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAD3qXebtxNv2hkvf4ZkpN4JvxMom2jLoWBW/mLFY/UzH/c+9
iabm/ERUUdFCaKgQbDJRj+x+kbG+tJUF/jbscku/ANdpjhHUytry2YeYDhDUh93pPAv4HZkp
fdY/kKiA1net1lq9RyceN2CMbw8K5EewVHJ739l3UYNeyIDyjmpE1rVr7pEf16sZnLRmDCH8
qFOHjDgE3UQkvWWXVjuWmAg8tL/iZbHrl53RBEtLYHBuuAROR0WJhXi5vLaUgVzy7tvX0ot5
38POWIsfcmPimH5eV+CtA/409KQeS2o8fyy+hcRuHhIp7mWcHvHJZm0Hu+shnld4CKluGznW
4a2g/F7fifg0ijxqOwB7EKc73i9M1y3RpysjnRf0p+k1HFXvTcfnRzwd+eycKF5sAQ6ALzbw
3K2bQuTbBPK9yTh1UTIlT6uYoiWBVHhC0o5lbPPyVxASpZGmg/6CFPtezfOAwHGkgMhcUfHZ
D82btTAdQ2oH4OH19rtmTuCq3GCfgg2l7ifaG6SeHr/rL0fz7aqwkFG0CO4QPttg6sHHKN4O
+Ng2fpJ6zzfJyDPT2qLnuWlCaON2M8O0Z9d9pdIMbwZxlZ/LTuiPzgAwu9WmpJu5rKtRRKWi
1Y3xDhWy5aG7ukQ9OT+uPV7uPSF941symLEZWpDTwuZ9aCWNyykR38iS9tXbAAAAAAAA
--------------ms000801060900080305050504--
