Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38996 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3DROGJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 10:06:09 -0400
Date: Thu, 18 Apr 2013 15:06:04 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID device nomination (Feature request)
Message-ID: <20130418140604.GL7639@carfax.org.uk>
References: <kkotdg$o1e$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IR1Y5IvQhrKgS4e6"
In-Reply-To: <kkotdg$o1e$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--IR1Y5IvQhrKgS4e6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2013 at 02:45:24PM +0100, Martin wrote:
> Dear Devs,
>=20
> I have a number of esata disk packs holding 4 physical disks each where
> I wish to use the disk packs aggregated for 16TB and up to 64TB backups...
>=20
> Can btrfs...?
>=20
> 1:
>=20
> Mirror data such that there is a copy of data on each *disk pack* ?
>=20
> Note that esata shows just the disks as individual physical disks, 4 per
> disk pack. Can physical disks be grouped together to force the RAID data
> to be mirrored across all the nominated groups?

   Interesting you should ask this: I realised quite recently that
this could probably be done fairly easily with a modification to the
chunk allocator.

> 2:
>=20
> Similarly for a mix of different storage technologies such as
> manufacturer or type (SSD/HDD), can the disks be grouped to ensure a
> copy of the data is replicated across all the groups?
>=20
> For example, I deliberately buy HDDs from different
> batches/manufacturers to try to avoid common mode or similarly timed
> failures. Can btrfs be guided to safely spread the RAID data across the
> *different* hardware types/batches?

   From the kernel point of view, this is the same question as the
previous one.

> 3:
>=20
> Also, for different speeds of disks, can btrfs tune itself to balance
> the read/writes accordingly?

   Not that I'm aware of.

> 4:
>=20
> Further thought: For SSDs, is the "minimise heads movement" 'staircase'
> code bypassed so as to speed up allocation for the "don't care"
> addressing (near zero seek time) of SSDs?

   I think this is more to do with the behaviour of the block layer
than the FS. There are alternative elevators that can be used, but I
don't know how to configure them (or whether they need configuring at
all).

> And then again: Is 64TBytes of btrfs a good idea in the first place?!
>=20
> (There's more than one physical set of backups but I'd rather not suffer
> weeks to recover from one hiccup in the filesystem... Should I partition
> btrfs down to smaller gulps, or does the structure of btrfs in effect
> already do that?)

   You have backups, which is good. Keep up with the latest kernels
=66rom kernel.org. The odds of you hitting something major are small,
but non-zero. One thing that's probably fairly likely with your setup
is accidental disconnection of a disk or block of disks. Having
duplicate data is really quite handy in that instance -- if you lose
one device and reinsert it, you can recover easily with a scrub (I've
done that). If you lose multiple devices in a block, then the FS will
probably go read-only and stop any further damage from being done
until it can be unmounted and the hardware reassembled (I've done this
too(+), with half of my 10 TB(*) array).

   So with light home use on a largeish array, I've had a number of
cockups recently that were recoverable, albeit with some swearing.

   On the other hand, it's entirely possible that something else will
go wrong and things will blow up. My guess is that unless you have
really dodgy hardware that keeps screwing stuff up, you _probably_
won't have to restore from backup. But it still may happen. It's
really hard to put figures on it, because (a) we don't have figures on
how many people actually use the FS, and (b) we don't have many that
we're aware of working at the >10TB level.

   Hugo.

(+) eSATA connectors look regrettably similar to HDMI connectors in
the half-light under the desk.
(*) 5 TB after RAID-1.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- But somewhere along the line, it seems / That pimp became ---   =20
                       cool,  and punk mainstream.                      =20

--IR1Y5IvQhrKgS4e6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUW/9zFheFHXiqx3kAQIBfw//ShmitZi6dS3olog3dPebc0qQ02iiNWa8
Go1ObtBewYhLz2oncpHPsentTIGwH+nBpz0Tv0w7cNMv8NAfoO+jx2G4MKGMaslK
aXhmKrYwfSsNpGpg62+UvZLSTWG2HD1elI3HYSZJtWlV4AX2gOBnTqqkizvpq7q7
HqaLlV8tmPPwg5pBVIqD7O/q2cIJCuZHcE+5KYfFCl/lR8lztOMzydSwwLgihecD
Gu+/EwUYzJUn0iLnVIih8nI8FrvWDx/Q67UWJzb8JddoWug6rWX025OmoX0BBlaT
x2cZkAmQluVFnSHfOdN9DEBxpiDkxDICz8GXWbbDO+xk7biN05owsd7ase56KubK
OB8k+DdVrEWvtL6e2POu0Q/8+mpHiD9eEg6Y9+jDl+nAtFJnYll3TP5mlfn6zzIz
WNw7HLofBWVbcxGet6cq/d/iaNRSfqMsx6KYzt8NCKnbwzrZktbC6Nhhd/KDbps9
I0DS+3CuTv7qRPtE+wv/yWvpb3mfncnBTak7528mX9h4Ph0TMmqOhHnGYHJwY5Ml
lJttlajs7ULROhd6iuz7snQNaIx1e+WSD/+kexX5jP7vEdRkLZnT+orPPDQocN7/
Ypyd+HpUWT7iXAb1Wv4eHkVEMRaChU66jeYseE9yuhdLD+lyIuRqYjGjgw9BP4/Q
kznlsyUxPDU=
=+Qr8
-----END PGP SIGNATURE-----

--IR1Y5IvQhrKgS4e6--
