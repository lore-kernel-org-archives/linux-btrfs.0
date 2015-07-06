Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38285 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbGFSfM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 14:35:12 -0400
Received: by wibdq8 with SMTP id dq8so161697110wib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2015 11:35:10 -0700 (PDT)
Subject: Re: Btrfs - distribute files equally across multiple devices
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <559AAB5C.1030001@gmail.com>
 <20150706175327.GD10539@carfax.org.uk>
From: Johannes Pfrang <johannespfrang@gmail.com>
Message-ID: <559ACA50.8000304@gmail.com>
Date: Mon, 6 Jul 2015 20:34:56 +0200
MIME-Version: 1.0
In-Reply-To: <20150706175327.GD10539@carfax.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DmCCD7s6h1CXp69WvVDGdGKQaVvbdwqu5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DmCCD7s6h1CXp69WvVDGdGKQaVvbdwqu5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Thank you. That's a very helpful explanation. I've just did balance
start -dconvert=3Dsingle ;)
Fwiw, the best explanation about "single" I could find was in the
Glossary[1].
I don't have an account on the wiki, but your first paragraph would fit
great there!


[1] https://btrfs.wiki.kernel.org/index.php/Glossary


On 06.07.2015 19:53, Hugo Mills wrote:
> On Mon, Jul 06, 2015 at 06:22:52PM +0200, Johannes Pfrang wrote:
>    Not quite. In single mode, the FS will allocate linear chunks of
> space 1 GiB in size, and use those to write into (fitting many files
> into each chunk, potentially). The chunks are allocated as needed, and
> will go on the device with the most unallocated space.
>
>    So, with equal-sized devices, the first 1 GiB will go on the first
> device, the second 1 GiB on the second device, and so on.
>
>    With unequal devices, you'll put data on the largest device, until
> its free space reaches the size of the next largest, and then the
> chunks will be alternated between those two, until the free space on
> each of the two largest reaches the size of the third-largest, and so
> on.
>
>    (e.g. for devices sized 6 TB, 4 TB, 3 TB, the first 2 TB will go
> exclusively on the first device; the next 2 TB will go on the first
> two devices, alternating in 1 GB chunks; the rest goes across all
> three devices, again, alternating in 1 GB chunks.)
>
>    This is all very well for an append-only filesystem, but if you're
> changing the files on the FS at all, there's no guarantee as to where
> the changed extents will end up -- not even on the same device, let
> alone close to the rest of the file on the platter.
>
>    I did work out, some time ago, a prototype chunk allocator (the 1
> GiB-scale allocations) that would allow enough flexibility to control
> where the next chunk to be allocated would go. However, that still
> leaves the extent allocator to deal with, which is the second, and
> much harder, part of the problem.
>
>    Basically, don't assume any kind of structure to the location of
> your data on the devices you have, and keep good, tested, regular
> backups of anything you can't stand to lose and can't replace. There
> are no guarantees that would let you assume easily that any one file
> is on a single device, or that anything would survive the loss of a
> device.
I promise I won't assume that.

Two 4TB data disks:
- 3TiB+3TiB data=3Dsingle,meta=3Draid1 replaceable/unimportant
- 654Gib|654Gib data/meta=3Draid1 important with regular backups

efficient + safe enough (for my use-case)
>
>    I'm sure this is an FAQ entry somewhere... It's come up enough
> times.
>
>    Hugo.
>
>


--DmCCD7s6h1CXp69WvVDGdGKQaVvbdwqu5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVmspRAAoJEE/+YBzbApIXXPkP/i2baawJ6Zc+o/gAxVhHE5pB
+rEflbkZAANdTwatEZujCyaNpTsrs8VrWWPs/Sg+Z6rnuKa0B6JdCW3XVJMeOhLw
gtuzf22qd3xOlOtUinUuoRGTLIz9cgwB7QaTqFv6SnrdxlZyvLFxGRFeGiS95K6a
EN/ojCbMjf2btoER6NVvulDq+kxYYSUstCFzSdcaoujpsj+peMKCiHS6ySmwBjwL
FqT33Hst248RO3shpR0frXfh63B3yImfX0eAxYK5Ym0exfp7EmHwxbMVtS36FRh0
gxx0kw6acidToGz+ZkfZNg/8ZMFejZ/+TEw0GStnGfe/J07BUICq7CKRIXeCtGBz
DCHj9ItvdDP7jPJ2uYiU4342YtqINAGnh/UcatBhI3BIODB/tGPYb0dcX+3FHN+T
5TvQBMjDZWlO5My30cEsFFBGfX9kGh00pU+S5b3nHAdf1CUGV2s+0IZ6X8J1/wQC
hxI68Ri1todbKiOND0vbKKLR5DPHUn2rdhoCM6ZYKwVSR22Gahj0F6dD5Ov4b/Ht
pT4YQSY1WAU7ECyIucwO4TbWyeJOFxYZHN3rpneE1PjQu02eEiEzwxyR2l9C6ich
t8Wfy3iiZMj0Z9bjj5L/Dy8I2qer4RdbQ85OxB2zpyGcMW8tkbXHEvQ8bygVjBj8
T4Y1ru5mVR6+5XHS0gu2
=j1RX
-----END PGP SIGNATURE-----

--DmCCD7s6h1CXp69WvVDGdGKQaVvbdwqu5--
