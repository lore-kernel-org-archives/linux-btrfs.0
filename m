Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42068 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750875AbaKYWV1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 17:21:27 -0500
Date: Tue, 25 Nov 2014 17:21:26 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
Message-ID: <20141125222126.GQ17380@hungrycats.org>
References: <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
 <546BA96D.4050805@ubuntu.com>
 <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
 <546CB531.2060509@ubuntu.com>
 <20141121042814.GR17395@hungrycats.org>
 <5470C92E.1070607@inwind.it>
 <20141123001927.GO17380@hungrycats.org>
 <5474AF87.6090702@inwind.it>
 <20141125202948.GP17380@hungrycats.org>
 <5474FBD9.5070709@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HAv5+T9jbwMPl6Kw"
In-Reply-To: <5474FBD9.5070709@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HAv5+T9jbwMPl6Kw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2014 at 10:59:53PM +0100, Goffredo Baroncelli wrote:
> On 11/25/2014 09:29 PM, Zygo Blaxell wrote:
> > On Tue, Nov 25, 2014 at 05:34:15PM +0100, Goffredo Baroncelli wrote:
> >> On 11/23/2014 01:19 AM, Zygo Blaxell wrote:
> >> [...]
> >>> md-raid works as long as you specify the devices, and because it's al=
ways
> >>> the lowest layer it can ignore LVs (snapshot or otherwise).  It's also
> >>> not a particularly common use case, while making an LV snapshot of a
> >>> filesystem is a typical use case.
> >>
> >> I fully agree; but you still consider a *multi-device* btrfs over lvm.=
=2E.
> >> This is like a dm over lvm... which doesn't make sense at all (as you=
=20
> >> already wrote)
> >=20
> > It makes sense for btrfs because btrfs can productively use LVs on
> > different PVs (e.g. btrfs-raid1 on two LVs, one on each PV).  LVM is
> > the bottom layer because not everything in the world is btrfs--things
> > like ephemeral /tmp, boot, swap, and temporary backup copies of the btr=
fs
> > (e.g.  before running btrfsck) have to live on the same physical drives
> > as the btrfs filesystems.
>=20
> Let me to summrize
>=20
> 1) btrfs-single-disk on lvm works fine
> 2) btrfs-w/multiple-disk on lvm works fine
> 3) btrfs-single-disk on lvm works fine even with snapshot
>=20
> 4) btrfs-w/multiple-disk doesn't work with lvm AND snapshot
>=20
> However I still doesn't understood why you want btrfs-w/multiple disk ove=
r LVM ?

I want to split a few disks into partitions, but I want to create,
move, and resize the partitions from time to time.  Only LVM can do
that without taking the machine down, reducing RAID integrity levels,
hotplugging drives, or leaving installed drives idle most of the time.

I want btrfs-raid1 because of its ability to replace corrupted or lost
data from one disk using the other.  If I run a single-volume btrfs
on LVM-RAID1 (or dm-RAID1, or RAID1 at any other layer of the storage
stack), I can detect lost data, but not replace it automatically from
the other mirror.

Since I want both things at the same time, I have btrfs w/multiple disks
on LVM.

The LVM snapshots are for providing an 'undo' capability when I experiment
with some btrfs or btrfsck feature that destroys the filesystem.

> >>>>> and mounting the filesystem fails at 3. =20
> >>>> Are you sure ?
> >>>
> >>> Yes, I'm sure.  I've had to replace filesystems destroyed this way.
>=20
> In a previous email you wrote:
> >> Multi-device btrfs fails at 2,=20
> So I assumed that the point 3 onwards were related to a "single-disk" btr=
fs.
>=20
>=20
>=20
> [...]
>=20
>=20
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

--HAv5+T9jbwMPl6Kw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlR1AOYACgkQgfmLGlazG5woAwCfRXaTEl2q1WxVz3t3heay3FKE
KLcAmgLBLnGwchRKj1fpflZYgp4cGwPH
=nQrl
-----END PGP SIGNATURE-----

--HAv5+T9jbwMPl6Kw--
