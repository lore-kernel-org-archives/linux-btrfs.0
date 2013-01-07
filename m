Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33516 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3AGSYc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2013 13:24:32 -0500
Date: Mon, 7 Jan 2013 18:24:26 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: kreijack@inwind.it
Cc: dsterba@suse.cz, util-linux@vger.kernel.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: Btrfs: wipe all the superblock [redhat bugzilla 889888]
Message-ID: <20130107182426.GM19051@carfax.org.uk>
References: <50E9C267.3050302@inwind.it>
 <20130107163327.GK20089@twin.jikos.cz>
 <50EB11E0.8030403@tiscalinet.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NOC/txXbandKISI8"
In-Reply-To: <50EB11E0.8030403@tiscalinet.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NOC/txXbandKISI8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 07, 2013 at 07:20:16PM +0100, Goffredo Baroncelli wrote:
> Hi David,
> 
> On 01/07/2013 05:33 PM, David Sterba wrote:
> > On Sun, Jan 06, 2013 at 07:28:55PM +0100, Goffredo Baroncelli wrote:
> >> Currently wipefs doesn't clear all the superblock of btrfs. Only the first 
> >> one is cleared.
> >>
> >> Btrfs has three superblocks. The first one is placed at 64KB, the second 
> >> one at 64MB, the third one at 256GB.
> > 
> > It can have as much as 4 superblock backup copies:
> > 
> > Superblock offset 0 is 65536 (0x10000, block=16/0x10)
> > Superblock offset 1 is 67108864 (0x4000000, block=16384/0x4000)
> > Superblock offset 2 is 274877906944 (0x4000000000, block=67108864/0x4000000)
> > Superblock offset 3 is 1125899906842624 (0x4000000000000, block=274877906944/0x4000000000)
> > Superblock offset 4 is 4611686018427387904 (0x4000000000000000, block=1125899906842624/0x4000000000000)
> 
> Are you sure ?
> 
> Regarding the btrfs-progs suite, I looked at the btrfs_read_dev_super():
> [..]
>         for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>                 bytenr = btrfs_sb_offset(i);
>                 ret = pread64(fd, &buf, sizeof(buf), bytenr);
> 
> Where BTRFS_SUPER_MIRROR_MAX is 3.
> 
> Regarding the kernel code, I looked at several function which call
> btrfs_sb_offset(); everywhere there is an upper limit of the superblock
> numbero which is BTRFS_SUPER_MIRROR_MAX, which is still 3.
> 
> Moreover I performed the following test:
> 
> $ ls -lh 7tb-filesystem.img
> -rw-r--r-- 1 ghigo ghigo 7.1E Jan  7 18:49 7eb-filesystem.img
> $ /sbin/mkfs.btrfs 7eb-filesystem.img
> 
> $ cat extract-sign.py
> import os
> 
> BTRFS_SUPER_MIRROR_SHIFT = 12
> BTRFS_SUPER_INFO_OFFSET = (64*1024)
> 
> def btrfs_sb_offset(mirror):
>     start = 16*1024
>     if(mirror):
>         return start << (BTRFS_SUPER_MIRROR_SHIFT * mirror)
>     return BTRFS_SUPER_INFO_OFFSET
> 
> f = open("7eb-filesystem.img","r")
> for i in range(5):
>     pos = btrfs_sb_offset(i)+64
>     f.seek(pos)
>     sign = f.read(8)
> 
>     print "Superblock #%d - %20d - '%s'"%(i,pos,sign)
> 
> $ python extract-sign.py
> Superblock #0 -                65600 - '_BHRfS_M'

64 KiB

> Superblock #1 -             67108928 - '_BHRfS_M'

256 MiB

> Superblock #2 -         274877907008 - '_BHRfS_M'

1 TiB

> Superblock #3 -     1125899906842688 - ''

4 PiB

> Superblock #4 -  4611686018427387968 - ''

16 EiB


> To me it seems that in a 7TB filesystem there is only 3 superblocks.

   That would be as expected. How many on a 5 PiB filesystem, though?
Or a 20 EiB one?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "He's a nutcase, you know. There's no getting away from it -- ---  
                     he'll end up with a knighthood"                     

--NOC/txXbandKISI8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUOsS2r9z9OVl50rAAQKEWg//ez9fUWhMtNYfrRiCbD0C40sNaN0fV4dD
5K42U2MbcWyVmvYCLYE4KL7r+INXW2lnEgm4Y3GgNH1l4IsV3fyRpNc3UBLR6FBB
vcegPMq0AwVjIEdXD8+ZU93CYGmeIrf21aalVD4iZp1Td7h2MszPgOl/vsCtgI1g
C7lHaHqe8++jzZEOmGmf+AltxBvHqIuLhtcIcGkHaC0sx0+G9kDBsrDUgzJWKTXd
PrFHzSHKT1bAMUC4rwzXjDKy06ui3aBog8tutcb+gQ2crQrVpbj6Fcl19iGu6K1r
GFgZRFj1XOk/SFno33cnwJALquC0P6ZNRCVzR/v+vBtUTb27jROZls7Sx8qbD1ZH
nQ5gcb2AWjcpXB8TuzzgdXGxY1dVLkBFK9DPt7+lShBy8cgE7rJgHSlNwtg03/ds
tk081HIMqDBAaw3Q27+FzWPncI7VmVHdBU9UTOV1EPBlMALRhzJaZBLHsnwpbILo
58ora76DShQYtEurdNI3FIxgJswNsSfHI+YFAMaLR0qpESNzUnxHuj2jELpOG4f6
LzJQd81219ZLj4WfiR8WDiBOaczxVqWwIHLKLuVl5eCJahrKElUfAxtC8icGXAeP
gQKKf6onGAD1Czn4gNgtijjpWkzlnm5Y7ET57gUlWPCOsEHtt+/7r3eaaktgSCZn
BhAV3Q3/Q1k=
=SwcU
-----END PGP SIGNATURE-----

--NOC/txXbandKISI8--
