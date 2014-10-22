Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34573 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750714AbaJVECz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 00:02:55 -0400
Date: Wed, 22 Oct 2014 00:02:53 -0400
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Robert White <rwhite@pobox.com>
Cc: Arnaud Kapp <kapp.arno@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 5 _thousand_ snapshots? even 160? (was: device balance times)
Message-ID: <20141022040253.GD29401@hungrycats.org>
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com>
 <5446BEC0.8070009@siedziba.pl>
 <5446C597.9080904@gmail.com>
 <54470403.8020904@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qGV0fN9tzfkG3CxV"
In-Reply-To: <54470403.8020904@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qGV0fN9tzfkG3CxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2014 at 06:10:27PM -0700, Robert White wrote:
> That's an unmanageably large and probably pointless number of
> snapshots guys.
>=20
> I mean 150 is a heck of a lot, and 5000 is almost unfathomable in
> terms of possible usefulness.
>=20
> Snapshots are cheap but they aren't free.

This could be better documented.  Most of the documentation about btrfs
snapshots frankly just says how to make them and how awesome they are.
In small-scale tests they seem cheap--a little more expensive than
mkdir--but on larger scales they can become nightmares.

Things I learned the hard way about ~200 snapshots on a half-TB
filesystem:

btrfs balance cancel/pause take a long time.  Like 24+ hours.  Not the
entire balance operation--just one block group.  Reboot and mount with
skip_balance is a crude but effective way out.

Making new snapshots is cheap.  Deleting them is not.  btrfs-cleaner
will systematically disassemble each snapshot, sequentially, one extent
(or some similarly tiny fragment) at a time, for more than a week.
fsync() will take several seconds on that filesystem for the entire
time btrfs-cleaner is running.  There is no way to pause or stop the
btrfs-cleaner kernel thread and as far as I can tell it's more or less
immune to attempts to limit the amount of I/O bandwidth it demands with
cgroup blkio.weight or ionice.  Rebooting won't even stop it--it will
just resume the next time the filesystem is mounted.  mkfs and restore
the filesystem from a backup of the original subvolume--it's an order
of magnitude faster even with rsync.

2 or 3 are good numbers for snapshots.  0 or 1 are even better.

--qGV0fN9tzfkG3CxV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRHLG0ACgkQgfmLGlazG5xyZwCglMR69kgGjUgP10o+ehSetoZy
DMQAoMYD/LZACpapl/YF4kVrtnGrpOCO
=k6kl
-----END PGP SIGNATURE-----

--qGV0fN9tzfkG3CxV--
