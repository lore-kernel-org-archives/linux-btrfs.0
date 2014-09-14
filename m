Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44706 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaINEoJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Sep 2014 00:44:09 -0400
Date: Sun, 14 Sep 2014 05:44:05 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Piotr =?utf-8?Q?Paw=C5=82ow?= <pp@siedziba.pl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 failure and recovery
Message-ID: <20140914044405.GU5783@carfax.org.uk>
References: <000f01cfce67$9e9015f0$dbb041d0$@csy.ca>
 <20140912104732.GO5783@carfax.org.uk>
 <5415083C.4050404@siedziba.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HtRZva1Vzv8iP5ye"
In-Reply-To: <5415083C.4050404@siedziba.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HtRZva1Vzv8iP5ye
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 14, 2014 at 05:15:08AM +0200, Piotr Paw=C5=82ow wrote:
> On 12.09.2014 12:47, Hugo Mills wrote:
> >I've done this before, by accident (pulled the wrong drive, reinserted
> >it). You can fix it by running a scrub on the device (btrfs scrub
> >start /dev/ice, I think).
>=20
> I'd like to remind everyone that btrfs has weak checksums. It may be good
> for correcting an occasional error, but I wouldn't trust it to correct
> larger amounts of data.

   Checksums are done for each 4k block, so the increase in
probability of a false negative is purely to do with the sher volume
of data. "Weak" checksums like the CRC32 that btrfs currently uses are
indeed poor for detecting malicious targeted attacks on the data, but
for random failures, such as a disk block being unreadable and
returning zeroes or having bit errors, the odds of identifying the
failure are still excellent.

> Additionally, nocow files are not checksummed. They will not be corrected
> and may return good data or random garbage, depending on which mirror is
> accessed.

   Yes, this is a trade-off that you have to make for your own
use-case and happiness. For some things (like a browser cache), I'd be
happy with losing the checksums. For others (e.g. mail), I wouldn't be.

   Hugo.

> Below is a test I did some time ago, demonstrating the problem with nocow
> files:
>=20
> #!/bin/sh
> MOUNT_DIR=3Dmnt
> DISK1=3Dd1
> DISK2=3Dd2
> SIZE=3D2G
> # create raid1 FS
> mkdir $MOUNT_DIR
> truncate --size $SIZE $DISK1
> truncate --size $SIZE $DISK2
> L1=3D$(losetup --show -f $DISK1)
> L2=3D$(losetup --show -f $DISK2)
> mkfs.btrfs -d raid1 -m raid1 $L1 $L2
> mount $L1 $MOUNT_DIR
> # enable NOCOW
> chattr +C $MOUNT_DIR
> umount $MOUNT_DIR
> # fail the second drive
> losetup -d $L2
> mount $L1 $MOUNT_DIR -odegraded
> # file must be large enough to not get embedded inside metadata
> perl -e 'print "Test OK.\n"x4096' >$MOUNT_DIR/testfile
> umount $MOUNT_DIR
> # reattach the second drive
> L2=3D$(losetup --show -f $DISK2)
> mount $L1 $MOUNT_DIR
> # let's see what we get - correct data or garbage?
> cat $MOUNT_DIR/testfile
> # clean up
> umount $MOUNT_DIR
> losetup -d $L1
> losetup -d $L2
> rm $DISK1 $DISK2
> rmdir $MOUNT_DIR

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Hey, Virtual Memory! Now I can have a *really big* ramdisk! ---  =20

--HtRZva1Vzv8iP5ye
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVBUdFVheFHXiqx3kAQIrQBAAi7wAAnvsRm5Ft++ZkBK8R6DU0yxqBTVS
GYO28yDGCC0wxJ3W/KajmGSqNdUEUajl6t+MvNA/HHG6YTigXlb6rk2nxe78O+lB
FLEbp/zwJftd93jubJ1TNpQvMMMl0bN4ppI+0wFnB4n+w03Kf1FZdU8FKlZ8lcre
f77TLOADigPuqmoI3TvS+Y7PglF2yp0lKBKcoV7JV46nI12yneqsctSxapQY9j24
lXftH71668MynFOaieq/lp1CIGTIIgNwHgtmvsFYGd4AJlhlioOC4fqS3sPv7HIk
1eXCWNxpMDaq2QEEeP3esmWyCf3LBn6fRSRwt6Hy0Obe1nY9VUbj1efNINhmFS8H
m9GirNRQph1v7JX7EidyHCRedNbklzqhYeq8t9apcdsP2Of+QWn/vC3ScZAtAxW7
MRFTb71ps6RrzbwvvCMgqyCkJq8Y81Bi56veqgXYo2yrsV1JhL2CmLYGiapiSkX3
Dq2ptM0lUuy9FVq+wlzj1HkiyNwXVZpfdYqX9X750u0SnXB484zyYQSq1JTypn5y
KU160VL3xF0WZdNL8fT1mw4uwjd8d/8LVf3Moc0q0Wjf3eCTGdtRUWGRzSNdD7Av
wzzvtLQVW6ikgYbv1ZmFcUeYiUc3BXFqVVVhX1dsQ4UMydfWzw3vnqJJ1tqaYaH4
CPxKKTPB3Fc=
=ccC2
-----END PGP SIGNATURE-----

--HtRZva1Vzv8iP5ye--
