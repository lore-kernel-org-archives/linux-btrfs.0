Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42406 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2GCPWL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2012 11:22:11 -0400
Date: Tue, 3 Jul 2012 16:22:08 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS fsck apparent errors
Message-ID: <20120703152208.GA28701@carfax.org.uk>
References: <4FF30B55.6060205@petaramesh.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
In-Reply-To: <4FF30B55.6060205@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 03, 2012 at 05:10:13PM +0200, Sw=E2mi Petaramesh wrote:
> A couple days ago, I have converted my Ubuntu Precise machine from
> ext4 to BTRFS using btrfs-convert.
[snip]
> After I had shifted, I tried to defragment and compress my FS using
> commands such as :
>=20
> find /mnt/STORAGEFS/STORAGE/ -exec btrfs fi defrag -clzo -v {} \;
>=20
> During execution of such commands, my kernel oopsed, so I restarted.
>=20
> Afterwards, I noticed that, during the execution of such a command,
> my FS free space was quickly dropping, where I would have expected
> it to increase...

   What you're seeing is the fact that you've still got the complete
ext4 filesystem and all of its data sitting untouched on the disk as
well. The defrag will have taken a complete new copy of the data but
not removed the ext4 copy.

   If you delete the conversion recovery directory (ext2_subvol), then
you'll see the space usage drop again. Of course, doing that will also
mean that you won't be able to roll back to ext4 without reformatting
and restoring from your backups. (You have got backups, right?)

> Once finished, I checked a couple of BTRFS FSes using btrfsck, but I
> interpret the results as having some errors :
>=20
> root@fnix:/# btrfsck /dev/VG1/DEBMINT
> checking extents
> checking fs roots
> root 256 inode 257 errors 800
> found 7814565888 bytes used err is 1
> total csum bytes: 6264636
> total tree bytes: 394928128
> total fs tree bytes: 365121536
> btree space waste bytes: 101451531
> file data blocks allocated: 20067590144
>  referenced 13270241280
> Btrfs Btrfs v0.19
>=20
> root@fnix:/# btrfsck /dev/VG1/STORAGE
> checking extents
> checking fs roots
> root 301 inode 10644 errors 1000
> root 301 inode 10687 errors 1000
> root 301 inode 10688 errors 1000
> root 301 inode 10749 errors 1000
> found 55683117056 bytes used err is 1
> total csum bytes: 54188580
> total tree bytes: 191500288
> total fs tree bytes: 103596032
> btree space waste bytes: 49730472
> file data blocks allocated: 55640522752
>  referenced 56466059264
> Btrfs Btrfs v0.19
>=20
> It doesn't seem that btrfsck attempts to fix these errors in any
> way... It just displays them.

   Correct, by default it just checks the filesystem. Just to be sure:
the filesystems in question weren't mounted, were they?

   I would also suggest using a 3.4 kernel. There's at least one FS
corruption bug known to exist in 3.2 that's been fixed in 3.4.
(Probably not what's happened in this case, but it's best to try to
avoid these kinds of issues).

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- emacs: Eats Memory and Crashes. ---                =20

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP8w4gIKyzvlFcI40RAnphAKDCYBpkBazIKVQ3xJ0JM2lfmdL/NACg0iTm
nq1TupkosbpaoNM9CbHjHaI=
=+7w6
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
