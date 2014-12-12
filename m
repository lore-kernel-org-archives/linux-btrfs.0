Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:35676 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751848AbaLLD4x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 22:56:53 -0500
Date: Thu, 11 Dec 2014 22:56:51 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Robert White <rwhite@pobox.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: mkfs.btrfs limits "odd" [and maybe a "failed" phantom device?]
Message-ID: <20141212035651.GD22023@hungrycats.org>
References: <5488C6CF.1080608@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
In-Reply-To: <5488C6CF.1080608@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2014 at 02:18:55PM -0800, Robert White wrote:
> (3) why can I make a raid5 out of two devices? (I understand that we
> are currently just making mirrors, but the standard requires three
> devices in the geometry etc. So I would expect a two device RAID5 to
> be considered degraded with all that entails. It just looks like its
> asking for trouble to allow this once the support is finalized as
> suddenly a working RAID5 thats really a mirror would become
> something that can only be mounted with the degraded flag.)

RAID5 with even parity and two devices should be exactly the same as
RAID1 (i.e. disk1 ^ disk2 =3D=3D 0, therefore disk1 =3D=3D disk2, the strip=
ing
is irrelevant because there is no difference in disk contents so the
disks are interchangeable), except with different behavior when more
devices are added (RAID1 will mirror chunks on pairs of disks, RAID5
should start writing new chunks with N stripes instead of two).

> (4) Same question for raid6 but with three drives instead of the
> mandated four.

RAID6 with three devices should behave more or less like three-way RAID1,
except maybe the two parity disks might be different (I forget how the
function used to calculate the two parity stripes works, and whether
it can be defined such that F(disk1, disk2, disk3) =3D=3D disk1).

> (5) If I can make a RAID5 or RAID6 device with one missing element,
> why can't I make a RAID1 out of one drive, e.g. with one missing
> element?

They're only missing if you believe the minimum number of RAID5 disks
is not two and the minimum number of RAID6 disks is not three.

> (6) If I make a RAID1 out of three devices are there three copies of
> every extent or are there always two copies that are semi-randomly
> spread across three devices? (ibid for more than three).

There are always two copies.  RAID1 on 3x1TBdisks gives you 1.5TB
of mirrored storage.

> ---
>=20
> It seems to me (very dangerous words in computer science, I know)
> that we need a "failed" device designator so that a device can be in
> the geometry (e.g. have a device ID) but not actually exist.
> Reads/writes to the failed device would always be treated as error
> returns.
>=20
> The failed device would be subject to replacement with "btrfs dev
> replace", and could be the source of said replacement to drop a
> problematic device out of an array.
>=20
> EXAMPLE:
> Gust t # mkfs.btrfs -f /dev/loop0 failed -d raid1 -m raid1
> Btrfs v3.17.1
> See http://btrfs.wiki.kernel.org for more information.
>=20
> Performing full device TRIM (2.00GiB) ...
> Turning ON incompat feature 'extref': increased hardlink limit per
> file to 65536
> Processing explicitly missing device
> adding device (failed) id 2 (phantom device)
>=20
> mount /dev/loop0 /mountpoint
>=20
> btrfs replace start 2 /dev/loop1 /mountpoint
>=20
> (and so on)
>=20
> Being able to "replace" a faulty device with a phantom "failed"
> device would nicely disambiguate the whole device add/remove versus
> replace mistake.

It is a little odd that an array of 3 disks with one missing looks
like this:

Label: none  uuid: dde7fa84-11ed-4281-8d90-3eb0d29b949b
        Total devices 3 FS bytes used 256.00KiB
        devid    1 size 4.00GiB used 847.12MiB path /dev/mapper/vgtester-d01
        devid    2 size 4.00GiB used 827.12MiB path /dev/mapper/vgtester-d02
        devid    3 size 4.00GiB used 0.00B path /dev/mapper/vgtester-d04

In the above, "vgtest-d02" was a deleted LV and does not exist, but
you'd never know that from the output of 'btrfs fi show'...

> It would make the degraded status less mysterious.

The 'degraded' status currently protects against some significant data
corruption risks.  :-O

> A filesystem with an explicitly failed element would also make the
> future roll-out of full RAID5/6 less confusing.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSKZ4MACgkQgfmLGlazG5yRdACfRcml1k2mJr+mcsy5TeHBhT+u
jFEAn3XD1EK+bBUzBfE+cleCBI3hJcKM
=+Ym2
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
