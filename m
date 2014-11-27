Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47714 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753367AbaK0EPM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 23:15:12 -0500
Date: Wed, 26 Nov 2014 23:15:10 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
Message-ID: <20141127041510.GV17380@hungrycats.org>
References: <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
 <546CB531.2060509@ubuntu.com>
 <20141121042814.GR17395@hungrycats.org>
 <5470C92E.1070607@inwind.it>
 <20141123001927.GO17380@hungrycats.org>
 <5474AF87.6090702@inwind.it>
 <20141125202948.GP17380@hungrycats.org>
 <5474FBD9.5070709@inwind.it>
 <20141125222126.GQ17380@hungrycats.org>
 <54760B89.3050604@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NAmHCRPXNp23hR9r"
In-Reply-To: <54760B89.3050604@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NAmHCRPXNp23hR9r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2014 at 06:19:05PM +0100, Goffredo Baroncelli wrote:
> On 11/25/2014 11:21 PM, Zygo Blaxell wrote:
> >> > However I still doesn't understood why you want btrfs-w/multiple dis=
k over LVM ?
> > I want to split a few disks into partitions, but I want to create,
> > move, and resize the partitions from time to time.  Only LVM can do
> > that without taking the machine down, reducing RAID integrity levels,
> > hotplugging drives, or leaving installed drives idle most of the time.
> >=20
> > I want btrfs-raid1 because of its ability to replace corrupted or lost
> > data from one disk using the other.  If I run a single-volume btrfs
> > on LVM-RAID1 (or dm-RAID1, or RAID1 at any other layer of the storage
> > stack), I can detect lost data, but not replace it automatically from
> > the other mirror.
> OK, now I have understood.
>=20
> Anyway as workaround, take in account that you can pass explicitly the
> devices as:
>=20
> mount -o device=3D/dev/sda,device=3D/dev/sdb,device=3D/dev/sdc /dev/sdd /=
mnt
>=20
> (supposing that the filesystem is on /dev/sda.../dev/sdd)
>=20
> I am working to a mount.btrfs helper. The aim of this helper is to manage
> the assembling of multiple devices; the main points will be:
> - wait until all the devices appeared

=2E..and make sure there are no duplicate UUIDs.

> - allow (if required) to mount in degraded mode after a timeout

This is a terrible idea with current btrfs, at least for read-write
degraded mounting (fallback to read-only degraded would be OK).
Mounting a filesystem read-write and degraded is something you only want
to do immediately before you replace all the missing disks and bring the
filesystem up to a non-degraded space and after you've ensured that the
missing disks can never, ever come back; otherwise, btrfs eats your data
in a slightly different way than we have discussed so far...

> - at this point it could/should also skip the lvm-snapshotted devices (bu=
t before=20
> I have to know how recognize these)=20

You don't have to recognize them as snapshots (and it's probably better
not to treat snapshots specially anyway--how do you know whether the
snapshot or the origin LVs are wanted for mounting?).  You just have to
detect duplicate UUIDs at the btrfs subdevice level, and if any are found,
stop immediately (or get a hint from the admin).

This is a weakness of the current udev and asynchronous device hotplug
concept:  there is no notion of bus enumeration in progress, so we can be
trying to assemble multi-device storage before we have all the devices
visible.  Assembly of aggregate storage (whatever it is--btrfs, md,
lvm2...) has to wait until all known storage buses are fully enumerated
in order to detect if there are duplicates.

> I hope to issue the patches in the next week
>=20
> BR
> G.Baroncelli
>=20
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

--NAmHCRPXNp23hR9r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlR2pU4ACgkQgfmLGlazG5ykhQCgg/f1f/39M7GknpNeZBNUeb9F
zBYAoNk8oHXAooQx4uzratJiynV60Nb8
=VCVK
-----END PGP SIGNATURE-----

--NAmHCRPXNp23hR9r--
