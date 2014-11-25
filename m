Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48825 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751289AbaKYU3u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 15:29:50 -0500
Date: Tue, 25 Nov 2014 15:29:48 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
Message-ID: <20141125202948.GP17380@hungrycats.org>
References: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
 <546B68F8.6080008@ubuntu.com>
 <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
 <546BA96D.4050805@ubuntu.com>
 <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
 <546CB531.2060509@ubuntu.com>
 <20141121042814.GR17395@hungrycats.org>
 <5470C92E.1070607@inwind.it>
 <20141123001927.GO17380@hungrycats.org>
 <5474AF87.6090702@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2lX4GznBIrto1wi"
In-Reply-To: <5474AF87.6090702@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--s2lX4GznBIrto1wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2014 at 05:34:15PM +0100, Goffredo Baroncelli wrote:
> On 11/23/2014 01:19 AM, Zygo Blaxell wrote:
> [...]
> > md-raid works as long as you specify the devices, and because it's alwa=
ys
> > the lowest layer it can ignore LVs (snapshot or otherwise).  It's also
> > not a particularly common use case, while making an LV snapshot of a
> > filesystem is a typical use case.
>=20
> I fully agree; but you still consider a *multi-device* btrfs over lvm...
> This is like a dm over lvm... which doesn't make sense at all (as you=20
> already wrote)

It makes sense for btrfs because btrfs can productively use LVs on
different PVs (e.g. btrfs-raid1 on two LVs, one on each PV).  LVM is
the bottom layer because not everything in the world is btrfs--things
like ephemeral /tmp, boot, swap, and temporary backup copies of the btrfs
(e.g.  before running btrfsck) have to live on the same physical drives
as the btrfs filesystems.

> >>> and mounting the filesystem fails at 3. =20
> >> Are you sure ?
> >=20
> > Yes, I'm sure.  I've had to replace filesystems destroyed this way.
> >=20
> >> [working instance snipped]
> >=20
> >> On the basis of the example above, in case you want to mount a=20
> >> "single-disk", BTRFS seems me to work properly. You have to pay
> >> attention only to not mount the two filesystem at the same time.
> >=20
> > The problem is btrfs stops searching when it sees one disk with each UU=
ID,
>=20
> BTRFS doens't search anything. It is udev which "push" the information
> on the kernel module. The btrfs module groups these information by UUID.
> When a new disk is inserted, overwrite the information of the old one.

Same result:  when presented with multiple devices with the same UUID,
one is chosen arbitrarily instead of rejecting all of them.

> > so the set of disks (snapshot vs origin) that you get is *random*.
> > For a pair of origin + snapshots, there's a 50% chance it works, 50%
> > chance it eats your data.
>=20
> Sorry but I have to disagree: the code is quite clear=20
> (see fs/btrfs/volume.c, near line 512):
>=20
> [...]
>=20
>         } else if (!device->name || strcmp(device->name->str, path)) {
>                 /*
>                  * When FS is already mounted.
>                  * 1. If you are here and if the device->name is NULL that
>                  *    means this device was missing at time of FS mount.
>                  * 2. If you are here and if the device->name is different
>                  *    from 'path' that means either
>                  *      a. The same device disappeared and reappeared with
>                  *         different name. or
>                  *      b. The missing-disk-which-was-replaced, has
>                  *         reappeared now.

If the FS is already mounted then there is no issue.  It's when you're tryi=
ng
to mount the FS that the fun occurs.

>                  *
>                  * We must allow 1 and 2a above. But 2b would be a spurio=
us
>                  * and unintentional.
>=20
> [...]
>=20
> The case is the 2a; in this case btrfs store the new name and mount it.
>=20
> Anyway I made a small test: I created 1 btrfs filesystem, and=20
> made a lvm-snapshot. Then create two different file in the snapshot and in
> the original one. I run a program which mounts randomly the first or
> the latter, checks if the correct file is present; after more than 130 te=
sts I
> never saw your "50% chance it works": it always works.

One btrfs filesystem on two LVs with a snapshot of each LV also present.
So you'd have:

	lv00 - btrfs device 1
	lv01 - btrfs device 2
	lv00snap - snapshot of lv00
	lv01snap - snapshot of lv01

If you mount by device UUID then you get one of these results at random:

	lv00 + lv01 - OK
	lv00snap + lv01snap - also OK
	lv00 + lv01snap - failure
	lv00snap + lv01 - failure

2 failures, 2 successes =3D 50% failure rate.

If you mount by the name of one of the devices then you only get the two
rows of the above table that match the device you named, but you still
get one success row and one failure row.

Which result you get seems to depend on the order in which LVM enumerates
the LVs, so if you are doing a mount/umount loop then you won't see any
problems as btrfs will consistently make the same choice of LVs over
and over again.  Rebooting or creating other LVs in between mounts will
definitely cause problems.

> BR
> G.Baroncelli
>=20
> >=20
> >> BR
> >> G.Baroncelli
> >>
> >>
> >> --=20
> >> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> >> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
>=20
>=20
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
>=20

--s2lX4GznBIrto1wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlR05rwACgkQgfmLGlazG5zXowCfTe16gPm73OXkjd69CnOgDsqh
/CEAoJwWu7YyQnQJje7GFOv055Am1IbV
=u7m7
-----END PGP SIGNATURE-----

--s2lX4GznBIrto1wi--
