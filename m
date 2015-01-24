Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55459 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbbAXOgd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Jan 2015 09:36:33 -0500
Date: Sat, 24 Jan 2015 14:36:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Daniel Pocock <daniel@pocock.pro>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 migrate to bigger disks
Message-ID: <20150124143632.GF1654@carfax.org.uk>
References: <54C3AD0C.7080407@pocock.pro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fwqqG+mf3f7vyBCB"
In-Reply-To: <54C3AD0C.7080407@pocock.pro>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fwqqG+mf3f7vyBCB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 24, 2015 at 03:32:44PM +0100, Daniel Pocock wrote:
> 
> 
> 
> I've got a RAID1 on two 1TB partitions, /dev/sda3 and /dev/sdb3
> 
> I'm adding two new disks, they will have bigger partitions /dev/sdc3 and
> /dev/sdd3
> 
> I'd like the BtrFs to migrate from the old partitions to the new ones as
> safely and quickly as possible and if it is reasonable to do so, keeping
> it online throughout the migration.
> 
> Should I do the following:
> 
> btrfs device add /dev/sdc3 /dev/sdd3 /mnt/btrfs0
> btrfs device delete /dev/sda3 /dev/sdb3 /mnt/btrfs0
> 
> or should I do it this way:
> 
> btrfs device add /dev/sdc3 /mnt/btrfs0
> btrfs device delete /dev/sda3 /mnt/btrfs0
> btrfs device add /dev/sdd3 /mnt/btrfs0
> btrfs device delete /dev/sdb3 /mnt/btrfs0
> 
> or is there some other way to go about it?

btrfs replace start /dev/sda3 /dev/sdc3 /mountpoint
btrfs fi resize 3:max /mountpoint
btrfs replace start /dev/sdb3 /dev/sdd3 /mountpoint
btrfs fi resize 4:max /mountpoint

   The 3 and 4 in the resize commands should be the devid of the
newly-added device.

   Hugo.

-- 
Hugo Mills             | I'll take your bet, but make it ten thousand francs.
hugo@... carfax.org.uk | I'm only a _poor_ corrupt official.
http://carfax.org.uk/  |
PGP: 65E74AC0          |                              Capt. Renaud, Casablanca

--fwqqG+mf3f7vyBCB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUw63vAAoJEFheFHXiqx3kVskP/R9cSrmdV8SzjHfwpdofA9UD
JYHFZM9VlosQNIXGa4mK47JdZlTkKdI4iVoX2Oxmolnw0lDfDR/44g7e9bxC8u1+
SGw6ccFNJacI3S9emDjfz1Wn5svjVULiTXqoTrEdaYUDo8W6CHj75ObQo3HTgSXu
TdLWNM9EiffaTSfVyIljxXp6VTmO2+wYUJbdx3yxkE6Wh+WDF/QDzkqC9pAm6F8f
7NOsKVPz0Oo5e8GOiSLhzLoXNR9Kn8br93fisTMOpwbBnFRDfWaYLVxUjAD8rL5P
d2gtTPrylA7tbWdi3i4jclq2QgElcGR4OL0GPw47euaeuZQ+b0Mm2dJvyRcVoax2
UsABxjOdU531mmAvT7YPD21VJbDi8bVlz9JfP7NZeWl0Q9xi4I5uEiq98NR8L5eQ
971jeJUmZXEKBs2pwtfrWS10j02Lvtb8E9G4JMITq6aqHn++7B33NxuyU0oxsf0I
mFWUWmIoLazYZN7vVdTb0Tw4/hYQ/cd1ifNOzf6VeXF44bzNx+h+rwyJVl6cfVrM
pfqRSVuxwdoO/GEZVuuqvXhcE56QpdFwzW8vQcQdJBCy4ZjhfZKlHAJar/0N0uxq
UdTbkb8yosr/4t++xLWC8ilH5yYrHv18ipkkP8HiCRFQbdkNXJuZWq70UFVgzfT2
d9asN6I6ROR7+TEDb6YJ
=1Huv
-----END PGP SIGNATURE-----

--fwqqG+mf3f7vyBCB--
