Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33476 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756837AbaKUE2O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 23:28:14 -0500
Date: Thu, 20 Nov 2014 23:28:14 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Phillip Susi <psusi@ubuntu.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
Message-ID: <20141121042814.GR17395@hungrycats.org>
References: <54699CC7.1050909@swiftspirit.co.za>
 <546A46A5.8030603@inwind.it>
 <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
 <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
 <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
 <546B68F8.6080008@ubuntu.com>
 <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
 <546BA96D.4050805@ubuntu.com>
 <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
 <546CB531.2060509@ubuntu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HAv5+T9jbwMPl6Kw"
In-Reply-To: <546CB531.2060509@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HAv5+T9jbwMPl6Kw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2014 at 10:20:17AM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> On 11/18/2014 9:54 PM, Chris Murphy wrote:
> > Why is it silly? Btrfs on a thin volume has practical use case
> > aside from just being thinly provisioned, its snapshots are block
> > device based, not merely that of an fs tree.
>=20
> Umm... because one of the big selling points of btrfs is that it is in
> a much better position to make snapshots being aware of the fs tree
> rather than doing it in the block layer.

One of the big selling points of LVM is that it is in a much better
position to make snapshots so you can run btrfsck on the shattered
remains of your broken btrfs filesystem.

The UUID-driven behavior of btrfs is _really extremely annoying_.
No other filesystem forces me to jump through the hoops btrfs does
to get routine admin tasks done.

e.g. if an ext4 filesystem explodes, I can:

	1.  make a LVM snapshot of the broken filesystem

	2.  run e2fsck on the snapshot

	3.  mount and repair the snapshot, e.g. rsync any missing files
	from backups, salvage anything that survived

	4.  LVM merge the snapshot to its origin volume

	5.  umount the origin volume and mount the merged volume
	(or just reboot)

=2E..and I can do all of this on a running system, in-place, with only a
few minutes of downtime in the must-reboot case.

None of the above works with btrfs at all.  Multi-device btrfs fails
at 2, and mounting the filesystem fails at 3.  The closest I've gotten
to this workflow is to set up a kvm instance that can see only the LVM
snapshots, (only) and run the btrfsck or rsync there--and hope that the
system doesn't crash and reboot during that time, or the filesystem will
be more or less destroyed by the random combination of origin and
snapshot LVs.

I've also learned the hard way to always make an LVM snapshot before
running btrfsck, just in case you discover a new btrfsck bug with your
filesystem.  That at least works for single-device btrfs filesystems.

> So it is kind of silly in the first place to be using lvm snapshots
> under btrfs, but it is is doubly silly to use lvm for snapshots, and
> btrfs for the mirroring rather than lvm.  Pick one layer and use it
> for both functions.  Even if that is lvm, then it should also be
> handling the mirroring.
>=20
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (MingW32)
>=20
> iQEcBAEBAgAGBQJUbLUxAAoJEI5FoCIzSKrwh0oH/3TZ2oo8u2BjHYO3b0x8800/
> LFkmGFWrZFSnAvtWuN5B1WlhMXku4dxLRXz14fJKFp3fNmnYRNVvw3tu9btvsBsC
> sZdwLaKwKPHTK8RS+QCI2pZPX+cGB+F7/z9PCHrzIzzCKk/4SvnJ76e2nnZFpY1m
> Md3f1BCHEVUPMMXbqv6Ry6v7PDs/8bx8WITYyAL9uh3tjh0dXQsjbZJn5u4XDitS
> /CoE8eX4rf1vc7qHI4K56TtArCcXQxAHcC56fXmcmS03bVhAkkJ5Z+/uwi6+TkJe
> 55rMFCd7UFy9pwKha3Q2flJHtDYG6ns7Njyff6BSL9Yzq7tHh4wLk1H3XxaOCP8=3D
> =3Dktv/
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--HAv5+T9jbwMPl6Kw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRuv14ACgkQgfmLGlazG5xlQQCgn6G/fVbuVLV2uaygpqY/9c08
Q+EAn0R3iyAyXYYekILsf6AnKbW/Fq6L
=PzEw
-----END PGP SIGNATURE-----

--HAv5+T9jbwMPl6Kw--
