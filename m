Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37957 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaBXN50 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 08:57:26 -0500
Date: Mon, 24 Feb 2014 13:57:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to identify if a partition containing a btrfs volume is
 mounted and where
Message-ID: <20140224135702.GG23877@carfax.org.uk>
References: <CAMU1PDh6crrOW02oqz6jqvG+rAG6W3mb+V=gHEy37FB1q0UpOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y+xroYBkGM9OatJL"
In-Reply-To: <CAMU1PDh6crrOW02oqz6jqvG+rAG6W3mb+V=gHEy37FB1q0UpOg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Y+xroYBkGM9OatJL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 24, 2014 at 01:48:55PM +0000, Mike Fleetwood wrote:
> Hi,
> 
> I am trying to enhance GParted (http://www.gparted.org/) to better
> support btrfs, specifically multi-device ones.  GParted displays the
> busy status (mounted or not) and the mount point of each partition.
> 
> For a single device file system this is easy.  Entry in /proc/mounts
> for the partition identifies it's mounted and provides the mount
> point.
> 
> In the general case for btrfs I don't know how to get from device name
> containing a btrfs volume to knowing if it's mounted and where?
> btrfs filesystem show can identify the devices in a btrfs, but if the
> mounting device was removed from the file system this linkage is
> broken.
[snip]
> So in there a way to determine whether a specific partition containing
> a btrfs volume is mounted and on what mount point?

   Right now: no.

   Anand posted some kernel patches for an ioctl a few weeks ago that
would allow you to get hold of the kernel's UUID<->device mapping.
There was also a suggestion that the information also be exposed in
/sys/fs/btrfs, and that mounted filesystems, and their list of
devices, be shown in /sys as well. See the discussion from [1]
onwards.

   Hugo.

[1] http://www.spinics.net/lists/linux-btrfs/msg31080.html

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- There are three mistaikes in this sentance. ---           

--Y+xroYBkGM9OatJL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUwtPrVheFHXiqx3kAQIQEA/+OZIG1oUycvf5amT9FyMWlslrlDoDZOpe
dDjx22zEK00nQeaBM1It+WZROzOi8XWKqCbQhmYqXApph1BS208R+ww3WTcFI+1n
1IC01eKA/hYHWNAKxGvWol1SPN+em55W7LEmroAhx/y+z3gmvTs7ZpmCRWkgWAaX
Uotapkox/BOYQJX3WidLsWvSevpg48mzbW/WWsw2lNkQ7zd6JR3pcZiKlwkaR/xN
bI15qQvwGG80SquFEpWqgNwRVQhoOTXXOHvuAC+NVFFNrsrxOQs77iQCofiTZObY
d0Cfddy+KrQxkce0fpLUQV8s1l/uVYbymgCBtrhPU07I9XejdrDaDZjYVk5idG91
zZ9JX8J+ruj66BV8IOEdHgCJLfBHzqlYjp5tRWrv5buNnFX7bBA5H7/9Ju1BEUaB
1qsnBjjq5Kt4NHOVoTQLCk+k+GyFkxJ2OHpQTgcas4RtxFtSizmHUf/QUK8eVwa8
aJ9Fa+pUYRLZbdT01z2ToN2wcvakut7cJdpX5G49onsUmn2pP0D6SOlPNrv8cf8K
VFKU4BrX/WhZPVsMC30VEd9kDN73aqEG8PfzqPCU8lwT2YC83t186p/CICKAi4J4
Oft0mAvQBtsQS7BKAfWOgID/VWfAdwbE5CR/t41GtzVbCmhWhctGGybjIyhWPbnA
YPYjjylfhk0=
=r0zW
-----END PGP SIGNATURE-----

--Y+xroYBkGM9OatJL--
