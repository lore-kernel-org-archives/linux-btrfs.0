Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47871 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab3AHRKP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 12:10:15 -0500
Date: Tue, 8 Jan 2013 17:10:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3707 still not fixed in 3.7.1
 (btrfs-zero-log required) but shown as "RIP btrfs_num_copies"
Message-ID: <20130108171012.GP19051@carfax.org.uk>
References: <20130108164958.GA2044@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YzDq+9le76OY47R0"
In-Reply-To: <20130108164958.GA2044@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YzDq+9le76OY47R0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 08, 2013 at 08:49:58AM -0800, Marc MERLIN wrote:
> Unfortunately my laptop deadlocks from time to time, and too often
> it triggers this bug in btrfs which is quite hard to recover from.
> 
> The bigger problem is that all the user sees (if anything) is seemingly 
> unrelated info, namely, "RIP: btrfs_num_copies+0x42/0x0b" or somesuch
> http://marc.merlins.org/tmp/btrfs_num_copies.jpg
> 
> It's only if you have serial console, or netconsole, which we can't really
> assume the average users to have, that you can get the correct oops and bug
> info.
> I lost another 3 hours with many reboots and a recovery drive to recover my
> root drive.
> 
> Question #1:
> I have hourly snapshots of my root filesystem, and I wasn't able to mount
> any of them. I got the BUG at fs/btrfs/volumes.c:3707 each time.
> gandalfthegreat:~# mount -o ro,recovery /dev/mapper/root -o 'subvol=root_daily_20130108_00:01:02,defaults,compress=lzo,discard,nossd,space_cache,noatime'
> 
> If my log is damaged, why are all other snapshots also broken?

   Snapshots are not independent of each other. The filesystem as a
whole is damaged -- if you can't mount it, it won't make a difference
which subvolume you try to mount. A snapshot is not a backup; it won't
save you from a broken filesystem or dead hardware. At best, it'll
save you from accidental deletion of files.

> Question #2:
> This btrfs-zero-log business, which in the end fixed my problem, should 
> not be a routine recovery method, especially because the ooops you get on
> your screen doesn't have the proper info that tells you that it's actually
> the right bug as described on
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_can.27t_mount_my_filesystem.2C_and_I_get_a_kernel_oops.21
> 
> Could mainline kernels be fixed not to oops so badly and in a hard to debug 
> way when this problem which happens too often (at least for me), is hit?

   Oopses in log playback are a bug. The last time we had such a bug
which was identifiable and traceable (back in the 3.1-3.2 era, IIRC),
it got fixed, eventually. So yes, this is a bug, it should be fixed,
and you're not the only person to have seen log tree replys fail in
3.6 and 3.7 kernels.

   Since you seem to be hitting the problem frequently and repeatably,
could you help? Josef has said he'd like a copy of the filesystem
image that btrfs-image produces when run against the broken FS (i.e.
while the FS can't mount) -- that would help track down the corruption
problem, and make the kernel more robust in this area. Just as a
warning, the output may be quite large: it contains all of your FS's
metadata.

> If that helps, here's what I got after the fact when trying to mount the
> broken filesystem before zero'ing logs
[snip]

   That information may also be helpful in conjunction with the
btrfs-image dump of a broken FS. I'm not sure how much help it is on
its own (but thanks for providing it anyway).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 4: Future Perfect ---       

--YzDq+9le76OY47R0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUOxS9L9z9OVl50rAAQJqnA/9Fw60sm3IEtmocnKSdLgGyDsry9pY8APe
uSIp6/gsaQdP29W+4rVAebjWgzJW+Xpltp2BTgKEVJ9Df7RYAYCyhDDuX2WEPV7i
Ls8dUYtUAZub3pRPxabVw6Y/6ZeUcv/ZseCpOpDYUnIC1A6sLfErdVMSmoRUF30I
N67c1GANBZXRqN9rihiunch26efzvkJXyzXR7/2Z46L2RKs5UEsv4cRuqWRCcb03
Q9Q63HLsQyUkj6Yc1vC0fmrKGdtz3OQAIH4k+iGD9LtLjcCBNtMe0tY9xLx4v2kk
GQup6i7NyMJEqFJ42oPQY9kly8v+3KNgJtYby7wAdjkiMkZrCZ8h/CS7qIsKf1CK
QcsZOXAS2aHJDPy/RUQcNPo1KhyK4GjqQ2A/7gUCBejtnhvGg7jVFjQqxMzmLhec
rcg6GQir6bRsU3oIN2tITomzgNuiBy9QmYirav43mSm7NV7nBz1ssM004Js9XqbY
VZbUCfHzfblG+GiCWU2scM4S9Ag5J6y38t2g0AzrB1DqWUOMVckUGCRmC8wLm8Kh
tZn5w2UgYCqqO80AIJ9JcnQ2LJTWaF0bU/JfzUAO1Cl9mh+2n8mR4wzazU3vg3M+
PaSHfYvqHcgIvr+kiM6tTAP3IV7rbi/04dGmuf5buRxSZwf1UTjwyvC8mhWPb4AD
Ap2JZXmhk0U=
=Gwji
-----END PGP SIGNATURE-----

--YzDq+9le76OY47R0--
