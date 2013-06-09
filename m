Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55103 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3FILMD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Jun 2013 07:12:03 -0400
Date: Sun, 9 Jun 2013 12:11:56 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Andr=E9?= Schlichting <andre@delorus.de>
Cc: Chris Murphy <lists@colorremedies.com>, linux-btrfs@vger.kernel.org
Subject: Re: Moved partition via dd
Message-ID: <20130609111156.GA4174@carfax.org.uk>
References: <51B327C4.3000304@delorus.de>
 <E3D849EC-DDAC-4E05-9571-303B869F7A8D@colorremedies.com>
 <51B3B339.4030108@delorus.de>
 <8E5CABA3-602A-4D2F-AAEF-74F007F3C2FF@colorremedies.com>
 <51B45C87.2040308@delorus.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
In-Reply-To: <51B45C87.2040308@delorus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 09, 2013 at 12:44:23PM +0200, Andr=E9 Schlichting wrote:
> Am 09.06.2013 00:57, schrieb Chris Murphy:
> >The next issue:
> >
> >>>if=3D/dev/sdc2 skip=3D$((245547520-33024)) seek=3D0 of=3D/dev/sdc2
> >
> >You have a skip (skip n block from input) value well inside of sdc2. It =
seems you should have skipped from sdc not sdc2, and should have used the o=
ld start value for sdc2 which was just 245547520, and you needed to specify=
 a count value in order to get the correct number of blocks, which would ha=
ve been 732566527-245547520. Then write those blocks to sdc2 (which makes s=
eek=3D unnecessary).
> >
> >
> >Chris Murphy
> >
>=20
> /dev/sdc2 at this moment was already the new partition with
> boundaries 33024 to 732566640 with the old partition inside.
> Therefore I used skip=3Dold start - new start, which inside of sdc2
> points to the start of the old partition. I didn't worry about the
> count, because the partition was at the end of the disk.
>=20
> I actually think that the move of the partition was no problem. I
> guess that btrfs has some absolute references which have to be
> adjusted and now has some problems with sectors not at the right
> place.

   No, it doesn't. All the position values in the FS are either
relative to the containing block device (i.e. the partition, in this
case), or are based on an internal virtual address space -- which is
itself mapped in terms of the containing block device(s).

> The following error from btrfsck
> > Check tree block failed, want=3D959572647936, have=3D135872930979158343=
79
> suggests that 959572647936 is a way off...

   That just says to me that you've got garbage metadata -- usually a
good indication that there's some file data where there should be
metadata, which would further suggest that you've somehow moved the
wrong data (or the right data into the wrong place).

> Maybe first, the principal question: Can one just move a
> btrfs-partition to the left by
> * delete partition
> * create partition moved
> * dd data from old to new partition
> Or does one have to adjust some references inside the btrfs filesystem?

   In theory, that process should be safe. In fact, I'm not aware of
*any* filesystem which is dependent on the position of the partition
within a larger device.

   I think at this point, you should try testdisk to see if it can
identify your FS's superblock. If that doesn't work, then restore from
backup is likely to be your fastest route to recovery.

   Hugo.

http://www.cgsecurity.org/wiki/TestDisk

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- I get nervous when I see words like 'mayhaps' in a novel, ---   =20
                because I fear that just round the corner               =20
                          is lurking 'forsooth'                         =20

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUbRi/FheFHXiqx3kAQKRoQ/+I1OcWAszwgvXmew+Ly3Z48mL1VVmUQTH
RAZ+pY8bAz3s8agXKH9w7zzjN0xtaNR54FMZa2aKs7lWT8erCPoztR4AZ/5m/fLZ
6pMBfppL/wwCNQLVZe9nGO57iwJpmgA6UlNHU9Ash5BUqFA9OE3psGD1M3yGLmSw
qiFv/KeG7SjYJ2eg9kC5FjNKBzlcvhaAWLXlujXBnRYf/p9qDQ3710J5Kmw7Hh4E
nej6oZu9qbu/yg8JSrYWsyCT8qAWm+b/FN7JcU47N2GsEB7v7UQDxgrH1UbDMgYq
hZf9hZtHq8ELHmB5bb/X9fHcZNO9rKxJuLA4QODqqwHenP7xQIttMYlCV2J60XEl
VRhpaYvOqqbZ6rhE2BAyAVxKQgvu+hnGFnERvW2HG+t+YqDm84MMUf9+C8XqwpvY
Q4Nb/7PuEfP2hfPX4vObiDdyRa/S9u4mawtxAoilh0GrqLXDtCAtYBB1zNeXJWv7
F6af864IqiK+UBXMtvQg5uIE8sM3no8MvhzYi6mbBtG1H61PLLmfgK+TgwP8fyFr
q11eGAHZnGKfbP8Q8fZlknMdH6UhB8edAUehoEVrhjRxPA+4h9A4e3cp0NyPRW1y
QTuge4r5pxLU2aBHFIqvGcizdhgxRKHhVHQ7UM0b3YnboD6pHKL7wukdQVG/6Duy
y3glpOn33Ko=
=/Vpp
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
