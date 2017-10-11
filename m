Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41157 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751958AbdJKMmL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 08:42:11 -0400
Subject: Re: Fatal failure, btrfs raid with duplicated metadata
To: Ian Kumlien <ian.kumlien@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAA85sZtPya5pQvRxyYpNB_HO0jfajvpg42EKNkKjuPuojZ-2pQ@mail.gmail.com>
 <4b291404-9f0a-e95d-e505-4a14fb1160d0@suse.com>
 <CAA85sZv2pctgR+yDR7biJO8H-0D4mwR5MhbdcrfG122rphbJ7A@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <edf2cb77-6e85-98ea-f16e-1fa2399cbdc6@suse.com>
Date: Wed, 11 Oct 2017 14:42:09 +0200
MIME-Version: 1.0
In-Reply-To: <CAA85sZv2pctgR+yDR7biJO8H-0D4mwR5MhbdcrfG122rphbJ7A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lDD5Mh0PnGd8FMGvqHuGtcIbPBCFE3v5O"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lDD5Mh0PnGd8FMGvqHuGtcIbPBCFE3v5O
Content-Type: multipart/mixed; boundary="vtlPQMsV2Hbai76v5reHPLacLrXw8VqaD";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Ian Kumlien <ian.kumlien@gmail.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <edf2cb77-6e85-98ea-f16e-1fa2399cbdc6@suse.com>
Subject: Re: Fatal failure, btrfs raid with duplicated metadata
References: <CAA85sZtPya5pQvRxyYpNB_HO0jfajvpg42EKNkKjuPuojZ-2pQ@mail.gmail.com>
 <4b291404-9f0a-e95d-e505-4a14fb1160d0@suse.com>
 <CAA85sZv2pctgR+yDR7biJO8H-0D4mwR5MhbdcrfG122rphbJ7A@mail.gmail.com>
In-Reply-To: <CAA85sZv2pctgR+yDR7biJO8H-0D4mwR5MhbdcrfG122rphbJ7A@mail.gmail.com>

--vtlPQMsV2Hbai76v5reHPLacLrXw8VqaD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/11/17 2:20 PM, Ian Kumlien wrote:
>=20
>=20
> On Wed, Oct 11, 2017 at 2:10 PM Jeff Mahoney <jeffm@suse.com
> <mailto:jeffm@suse.com>> wrote:
>=20
>     On 10/11/17 12:41 PM, Ian Kumlien wrote:
>=20
> [--8<--]=C2=A0
>=20
>     > Eventually the filesystem becomes read-only and everything is odd=
=2E..
>=20
>     Are you still able to mount it?=C2=A0 I'd be surprised if you could=
 if check
>     can't open the file system.
>=20
>=20
> Nope, it's like there never was a filesystem in the first place...=C2=A0=

>=20
> But since metadata should be duplicated all over, i'd assume that it
> would be able to mount it and survive.... =3D)

If you'd been using RAID1 or something instead, you'd be able to mount
the file system and replace the disk.
>     > Trying to run btrfs check on the disks results in:
>     > btrfs check -b /dev/disk/by-uuid/8d431da9-dad4-481c-a5ad-5e6844f3=
1da0
>     > bytenr mismatch, want=3D912228352, have=3D0
>     > Couldn't read tree root
>     > ERROR: cannot open file system
>     >
>     > (For backup and normal)
>     >
>     > So even if the data is duplicated on all disks, something in the =
above
>     > errors seemed to cause it to abort
>     > (These disks are seagate sshd disks, never ever buying them again=
)
>=20
>     If you have metadata: dup, that doesn't mean the metadata is duplic=
ated
>     on every disk.=C2=A0 It means that there are two copies of the meta=
data on a
>     single disk.=C2=A0 If that disk is going bad and returning failures=
 for both
>     copies of the metadata, you may be out of luck.=C2=A0 It's really i=
ntended
>     for single spinning disks to get a little bit more resiliency in th=
e
>     face of bad sectors.
>=20
>=20
> Oh? it looks like it would be 2 per 1 device, but ok - Then i could hav=
e
> had a issue where the drive that keeps the metadata is gone... I
> suspected that I did do DUP on multiple devices
>=20
> from the man page:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Note 1: DUP may exist on more than 1 device =
if it starts on a
> single device and another one is added. Since version 4.5.1,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mkfs.btrfs will let you create DUP on multip=
le devices.

I can see how you'd reach that conclusion.  The wording is somewhat
confusing.  We allocate space in chunks that are usually about 1GB in
size.  When DUP is used, we allocate two chunks on the same device and
that is presented as a single usable chunk.  The constituent chunks will
be allocated on the same device, but which device is used can change
with each allocation.

Say you have 5 disks and 8 metadata chunks.  They can be allocated like s=
o:

sda: A A D D
sdb: B B
sdc: C C
sde: F F G G
sdf: H H I I

There is no redundancy in the case of a disk failure, only for sector
failures.  To spread metadata across disks for redundancy you'll need to
use a raid mode instead.  If one of those disks is failing and it
contains a critical part of the metadata, the file system won't be
mountable.

>     The check error above means that it wasn't able to map a logical ad=
dress
>     to a physical address.=C2=A0 Typically that means that the mapping =
was lost.
>=20
>=20
> I was more reporting that it happened and if there was any useful data
> that we could extract from this if it's a failure that shouldn't happen=
 :)
>=20
> I haven't wiped anything yet - preparing to replace the disks though

Thanks for reporting it, but in this context, it's somewhat of an
expected failure mode.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--vtlPQMsV2Hbai76v5reHPLacLrXw8VqaD--

--lDD5Mh0PnGd8FMGvqHuGtcIbPBCFE3v5O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlneEaIACgkQHntLYyF5
5bJYRRAAkNWeDam67cHfaOzAhEo+dIBVwXI7vUaXpPWjps5s/z31O2CbqvmyKiEu
jnUJxm5wQAO43LhrQNLBXmhk62lUMrdLw0cHCjsO6gARybIwCMYGoB/tftb2J8Bf
4xJKbkF7z2/UOYuwvG3hYUtGq8Kgpsi7RwCHL6BMMuY8Vd2CQrKjOZ+RpeSFEAJq
Ezgd7yzn9oXbj6wm0C6WaBmvgJLHUywczUgZLeLU3NMibYJr9gaJaIVP5PF/u3d7
jWWfCfWqV7UuxMVTybVSy/Eb0Hp5n4oW1GztMBgaTSVgn2ifxp0hs3rw+wM2CSwV
fBCFrjEGgt5ygBQfRtxIeyWXjCl6iKhv7dPW2HSvWOCzxwpC1egMioBO3ctyiOsM
S3zLGYPCOyHCEsDVM/lMATTIe+GuDQvGuFCKgosJHgU/LfZagteBDYVim8hp4d7w
QBXy/jno1v3wkT/hYEgHSpaJdyBsBvT4/6oLdOdzdJgBl7BT2hwkl3/NBCa9HJI1
M57Jc496ZTn6fNPBi89dhq7jpoVW9QYuRvyV/p0y5reTQQcJ1G63tEjQnH63bljr
exzv2PGIt0dyJAak0vd2CmLiQJEEI87aUVE0pG7JY3fXhgt98iJXb+3x+3fnDF3f
UPwcxQJwuwM2Ml9rw7zqW9fKtBYwUJUYHFh2w4R8RLaesxadzC0=
=xd9+
-----END PGP SIGNATURE-----

--lDD5Mh0PnGd8FMGvqHuGtcIbPBCFE3v5O--
