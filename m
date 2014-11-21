Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33363 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751368AbaKUEYY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 23:24:24 -0500
Date: Thu, 20 Nov 2014 23:24:23 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org,
        bug-grub@gnu.org
Subject: Re: BTRFS messes up snapshot LV with origin
Message-ID: <20141121042423.GQ17395@hungrycats.org>
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com>
 <pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net>
 <54699CC7.1050909@swiftspirit.co.za>
 <546A46A5.8030603@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2lX4GznBIrto1wi"
In-Reply-To: <546A46A5.8030603@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--s2lX4GznBIrto1wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 08:04:05PM +0100, Goffredo Baroncelli wrote:
> On 2014-11-17 07:59, Brendan Hide wrote:
> >=20
> > That leaves two aspects of this issue which I view as two separate bugs:
> > a) Btrfs cannot gracefully handle separate filesystems that have the sa=
me UUID. At all.
> > b) Grub appears to pick the wrong filesystem when presented with two fi=
lesystems with the same UUID.
> >=20
> > I feel a) is a btrfs bug.
> > I feel b) is a bug that is more about "ecosystem design" than grub bein=
g silly.
>=20
> Regarding a)
> IIRC, btrfs collects the filesystem information by UUID; if two=20
> filesystems have the same UUID (like the LVM-snapshot case), the
> last filesystem discovered overwrite the first one.
>=20
> The filesystem discovering is done in user-space; so it should be simple
> to skip a filesystem on a LVM-snapshot.
>=20
> Regarding b)
> I am bit confused: if I understood correctly, the root filesystem was
> picked from a LVM-snapshot, so grub-probe *correctly* reported that
> the root device is the snapshot.
> The problem was that during the boot filesystem discovering: first
> scanned the *real* device, then the LVM-snapshot; the latter
> overwrote the former so the system booted from the LVM-snapshot.

IMHO if the device UUID search finds multiple devices with the same device
UUID, it should ignore _all_ of them as the identification problem
is unsolvable without further user input.  This is what the 'device=3D'
mount option is for.

> My conclusion is that we should improve the btrfs scan so:
> - in udev rules, a partition that is a LVM snapshot by default=20
> should be not scanned by "btrfs dev scan"
> - "btrfs dev scan", during the partition discovery should skip the=20
> lvm-snapshot.

That would mean I can't do this:

	1.  lvm snapshot of ext4 filesystem

	2.  btrfs-convert the snapshot

	3.  mount the snapshot, make sure it's OK

	4.  merge LVM snapshot to overwrite original ext4 filesystem

which would be a shame since that's the only way I ever convert ext3/4
filesystems to btrfs (btrfs-convert is a little buggy still).

> BR
> G.Baroncelli
>=20
>=20
>=20
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--s2lX4GznBIrto1wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRuvnYACgkQgfmLGlazG5yBPQCg6WDr32+sdXJJKxAaX8F3C1+i
P+4An3qjOHOIX76fgkspenvIcDRWIkrB
=ouBM
-----END PGP SIGNATURE-----

--s2lX4GznBIrto1wi--
