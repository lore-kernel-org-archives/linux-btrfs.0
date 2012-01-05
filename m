From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Why does Btrfs allow raid1 with mismatched drives? Also: How to
 look behind the curtain
Date: Thu, 5 Jan 2012 09:44:44 +0000
Message-ID: <20120105094444.GF27122@carfax.org.uk>
References: <4D48BA4B-AB66-46A2-8E79-050B798C9A3E@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vmttodhTwj0NAgWp"
Cc: linux-btrfs@vger.kernel.org
To: Fabian Zeindl <fabian.zeindl@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D48BA4B-AB66-46A2-8E79-050B798C9A3E@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--vmttodhTwj0NAgWp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 05, 2012 at 10:21:57AM +0100, Fabian Zeindl wrote:
> Hi,
> 
>  the subject is pretty selfexplanatory. I"m creating a btrfs using
> 
> sudo mkfs.btrfs -m raid1 -d raid1 <smalldisk> <largedisk>
> 
> it creates the fs, apparently with the size of the larger disk, no matter in which order i supply the disk-arguments.
> How can this be correct?

   Because btrfs doesn't actually do "RAID-1" (in the sense that
blocks with the same address on the two disks have identical
contents). You should probably read the mis-named "Sysadmin's Guide"
on the wiki[1], which explains what btrfs actually does with its
replication.

   You should also probably read the FAQ entries on free space[2],
since using plain "df" for btrfs is usually misleading.

> Is there some way like "cat /proc/mdstat" to see what btrfs is doing and to assure myself my raid1 is secure? It's not
> terribly important data, hence i'm trying btrfs, but i don't want to lose it either.

   You could run a scrub, which will verify all of the data mirrors on
the volume, and fix anything that's not redundant.

   Hugo.

[1] http://btrfs.ipv5.de/index.php?title=SysadminGuide
[2] http://btrfs.ipv5.de/index.php?title=FAQ#Why_does_df_show_incorrect_free_space_for_my_RAID_volume.3F

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                      --- vi: The core of evil. ---                      

--vmttodhTwj0NAgWp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPBXEMIKyzvlFcI40RArRpAKCGtsagLYnQd/xBisSaiXM8eu+rDgCgmeD/
4NG3Oi5BskiM8zvonluetnU=
=l4GP
-----END PGP SIGNATURE-----

--vmttodhTwj0NAgWp--
