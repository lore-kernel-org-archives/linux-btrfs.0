Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42468 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752891AbaKWATl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 19:19:41 -0500
Date: Sat, 22 Nov 2014 19:19:30 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Phillip Susi <psusi@ubuntu.com>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
Message-ID: <20141123001927.GO17380@hungrycats.org>
References: <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
 <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
 <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
 <546B68F8.6080008@ubuntu.com>
 <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
 <546BA96D.4050805@ubuntu.com>
 <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
 <546CB531.2060509@ubuntu.com>
 <20141121042814.GR17395@hungrycats.org>
 <5470C92E.1070607@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqN4RWvJTb9VNux/"
In-Reply-To: <5470C92E.1070607@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tqN4RWvJTb9VNux/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 22, 2014 at 06:34:38PM +0100, Goffredo Baroncelli wrote:
> On 11/21/2014 05:28 AM, Zygo Blaxell wrote:
> > e.g. if an ext4 filesystem explodes, I can:
> >=20
> > 	1.  make a LVM snapshot of the broken filesystem
> >=20
> > 	2.  run e2fsck on the snapshot
> >=20
> > 	3.  mount and repair the snapshot, e.g. rsync any missing files
> > 	from backups, salvage anything that survived
> >=20
> > 	4.  LVM merge the snapshot to its origin volume
> >=20
> > 	5.  umount the origin volume and mount the merged volume
> > 	(or just reboot)
> >=20
> > ...and I can do all of this on a running system, in-place, with only a
> > few minutes of downtime in the must-reboot case.
> >=20
> > None of the above works with btrfs at all.  Multi-device btrfs fails
> > at 2,=20
>=20
> You can't compare ext4 with btrfs, if you are talking about a multi-devic=
e=20
> filesystem: ext4 haven't this capability.=20

btrfs fails this comparison as a single-device filesystem.

> Try to make a md-raid over a snapshotted logical volume(s); I never tried
> that, but I suppose that there will be the same problems...

md-raid works as long as you specify the devices, and because it's always
the lowest layer it can ignore LVs (snapshot or otherwise).  It's also
not a particularly common use case, while making an LV snapshot of a
filesystem is a typical use case.

> > and mounting the filesystem fails at 3. =20
> Are you sure ?

Yes, I'm sure.  I've had to replace filesystems destroyed this way.

>[working instance snipped]

> On the basis of the example above, in case you want to mount a=20
> "single-disk", BTRFS seems me to work properly. You have to pay
> attention only to not mount the two filesystem at the same time.

The problem is btrfs stops searching when it sees one disk with each UUID,
so the set of disks (snapshot vs origin) that you get is *random*.
For a pair of origin + snapshots, there's a 50% chance it works, 50%
chance it eats your data.

> BR
> G.Baroncelli
>=20
>=20
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

--tqN4RWvJTb9VNux/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRxKA8ACgkQgfmLGlazG5xd5ACfbX2y0OV+E9CJLb7cWNeqMMyH
kzAAnRa1MhUySa8sne6xZNdyIkvhaK8R
=UG0D
-----END PGP SIGNATURE-----

--tqN4RWvJTb9VNux/--
