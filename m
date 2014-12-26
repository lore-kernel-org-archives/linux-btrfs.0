Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33138 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750740AbaLZUFw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Dec 2014 15:05:52 -0500
Date: Fri, 26 Dec 2014 15:05:45 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Ankur Tank <Ankur.Tank@LntTechservices.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs doesn't format eMMC if previous filesystem is ext4
Message-ID: <20141226200529.GA11406@hungrycats.org>
References: <CFB3B8F56DDE9F45B45EBDEBED372A6644232D@POCITMSEXMB05.LntUniverse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
In-Reply-To: <CFB3B8F56DDE9F45B45EBDEBED372A6644232D@POCITMSEXMB05.LntUniverse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 26, 2014 at 03:24:59PM +0000, Ankur Tank wrote:
> I wanted to test btrfs on the eMMC of beaglebone black based custom board.
> Precondition: eMMC is formatted with ext4 filesystem
> Use case:
>         Format eMMC with mkfs.btrfs  -L  <label>  <dev>
> Result:
>         Mkfs.btrfs denies formatting eMMC because its existing filesystem
>=20
> # mkfs.btrfs -L "1storage" /dev/mmcblk0p2
> /dev/mmcblk0p2 appears to contain an existing filesystem (ext4).
> Error: Use the -f option to force overwrite.
>=20
> If I add "-f" its possible to format the eMMC.

It seems to be a feature.  mkfs.btrfs will test the device with libblkid
to see if there is a filesystem present to prevent administrator mistakes.
If libblkid can identify and device, it will prevent format without -f.

If you're doing an automated script, you need the -f.  libblkid isn't
particularly reliable and can false-positive on random data (e.g. the
HFS module can detect a filesystem that is not there).  If you're doing
tests that involve reformatting the filesystem in a loop, you need the -f.

> # mkfs.btrfs -f -L "1storage" /dev/mmcblk0p2
> Detected a SSD, turning off metadata duplication.  Mkfs with -m dup if yo=
u want to force metadata duplication.
> Btrfs v3.17
> See http://btrfs.wiki.kernel.org for more information.
>=20
> Performing full device TRIM (1.72GiB) ...
> Turning ON incompat feature 'extref': increased hardlink limit per file t=
o 65536
> [273917.692896] btrfs: device label 1storage devid 1 transid 3 /dev/mmcbl=
k0p2
> fs created label 1storage on /dev/mmcblk0p2
>         nodesize 16384 leafsize 16384 sectorsize 4096 size 1.72GiB
>=20
> I had downloaded debian package from following link
> https://packages.debian.org/sid/armhf/btrfs-tools/download
>=20
> Is it a bug ? or I am missing something ?

If your device is small or solid-state, btrfs will change the default
options (mixed-metadata, no duplicate metadata).

"extref" is a feature that enables large numbers of hardlinks to a
single file.  You can leave it enabled-it's unlikely your devices
will ever see a kernel old enough that it's not compatible.


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSdv4YACgkQgfmLGlazG5yW2wCcDGuJNIGuuNqLG3l5qyEyFyDF
HpcAn0FKbysrVSd5Ggxk2jKdA58uFGxo
=dqg4
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
