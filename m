Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59165 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbbDSSvf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 14:51:35 -0400
Date: Sun, 19 Apr 2015 18:51:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Craig Ringer <craig@2ndquadrant.com>, linux-btrfs@vger.kernel.org
Subject: Re: The FAQ on fsync/O_SYNC
Message-ID: <20150419185132.GD18187@carfax.org.uk>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com>
 <2245776.oZdMfpEQBm@merkaba>
 <20150419181824.GC18187@carfax.org.uk>
 <6274834.Q47roFjYxL@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HnQK338I3UIa/qiP"
In-Reply-To: <6274834.Q47roFjYxL@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HnQK338I3UIa/qiP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2015 at 08:41:39PM +0200, Martin Steigerwald wrote:
> Am Sonntag, 19. April 2015, 18:18:24 schrieb Hugo Mills:
> > On Sun, Apr 19, 2015 at 07:50:32PM +0200, Martin Steigerwald wrote:
> > > Am Sonntag, 19. April 2015, 15:18:51 schrieb Hugo Mills:
> > > > On Sun, Apr 19, 2015 at 05:10:30PM +0200, Martin Steigerwald wrote:
> > > > > Am Sonntag, 19. April 2015, 22:31:02 schrieb Craig Ringer:
> > > > > > I'm curious as to whether +C has any effect on BTRFS's
> > > > > > durability,
> > > > > > too.
> > > > >=20
> > > > > You will loose the ability to snapshot that directory tree then.
> > > > >=20
> > > >    No you won't.
> > > >   =20
> > > >    The +C attribute still allows snapshotting and reflink copies.
> > > >=20
> > > > However, after the snapshot, writes to either copy will result in
> > > > that
> > > > copy being CoWed. (Specifically, writes to an extent of a +C file
> > > > with
> > > > more than one reference to the extent will result in a CoW
> > > > operation,
> > > > until there is only one reference, and then the writes will not be
> > > > CoWed again).
> > > >=20
> > > >    The practical upshot of this is that every snapshot of, and
> > > >=20
> > > > subsequent writes to, a +C file will introduce fragmentation in the
> > > > same way that writes to a non-+C file would.
> > > >=20
> > > >    You also have a disadvantage with +C that you lose the
> > > >    checksumming
> > > >=20
> > > > features of the FS, and hence the self-healing properties if you're
> > > > running with btrfs-native RAID.
> > >=20
> > > Thanks for clarifying this Hugo, so chattr +C will make the directory
> > > cowed again.
> >=20
> >    Not quite sure what you mean there.
> >=20
> >    If you set +C on a file or directory, there's no CoW operations on
> > write to any of the affected files, *except* if there's a snapshot, in
> > which case the file being written to will have *one* CoW operation
> > before reverting to nodatacow again.
>=20
> What do you mean by *one* CoW operation, will BTRFS duplicate the whole=
=20
> file to keep it no-cowed? Or, hmmm, I think now I get it: There will be o=
ne=20
> CoW operation for each write =E2=80=93 well, with some granularity, exten=
t? =E2=80=93, but=20
> *just* one, cause then the written data is cowed from the snapshot and=20
> then can be written again in a no-cowed way.

   Correct.

   Granularity -- the storage of data is on a block basis (4k), but
extent size goes down to individual bytes. I think this means that if
you read and then write a single byte and then sync, the block is read
into the page cache, the byte is modified, the block is written out
(elsewhere, because it's CoW), and then the extents are updated to
reference the one modified byte from the new block. I'm not 100% sure
on that, though.

> > > And there is not checksumming on the FS at all anymore. Why is the
> > > later? Why can=C2=B4t BTRFS checkum nocowed objects or at least the c=
owed
> > > ones in the same FS? Cause of atomicity guarentees?
> >=20
> >    Atomicity, indeed. You need to be able to update the checksum and
> > the new data atomically. This is possible when the data can be CoWed,
> > but if the data is being modified in place, there must be a short
> > period of time when the two parts are out of sync.
>=20
> And it would be too much effort or too much of a performance penalty to l=
et=20
> any checksum check wait till they are in sync again?

   It's more that if the system crashes or suffers a power outage in
that time window, you've got a mismatch that shows EIO even though the
data is valid.

> >    Just to make it clear, the lack of checksums is *only* for those
> > files which are marked +C. The rest of the FS is unaffected.
>=20
> Thanks for that clarification. I read your original wording as if the who=
le=20
> FS was affected.

   Only if the FS is mounted with nodatacow. :)

   Hugo.

--=20
Hugo Mills             | Jenkins! Chap with the wings there! Five rounds
hugo@... carfax.org.uk | rapid!
http://carfax.org.uk/  |                 Brigadier Alistair Lethbridge-Stew=
art
PGP: E2AB1DE4          |                                Dr Who and the Daem=
ons

--HnQK338I3UIa/qiP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVM/k0AAoJEFheFHXiqx3krvEP/Rim+NDo+wKBU7C5PY5hDVff
1oHdpvAQ2igFIqkzNO9IECUi+bkfXzy1V+4dk5IxkwomH0oGXK4znFtsSheFRDnz
IWvxewTZXtXf7PIiNf+8fegcz6SY24qwo3zVRmSxWiGLLWV/6EdIRAplQuTjUX8k
LDc+3pvio+TJ3kp4D6xK569Qhobl+NpFz+9k+dvBepBNYp5A1VRJ6r1hV3geMNW/
gzObdYKFyj44n/DxVhYJqa13iBhnYe6WFqL+ZKOwg30MT3XKsLAfxiGZNakbS1bf
wrN4HD/dMnlbLnqeRv14wuAYGXUACX4oZfLFC4YBqy5cEFPqF/MRwO6LcxU2cq8P
7onACpaYajZOtvoBkEf2Zymq0cwip6p60RkVrd43uSkofHiodu09lVk/IkiBeaBE
cfLZTjpw8A6aN7frcTPJ1KVztfrVHX+fI4ednm34bj8WmB7d27cxJxE8XXO3kjv2
7CChm5P1HKxYnwCtZ6hIhNVStq18+zfDiUxB+dVpNwaHEJYPRU+WoBvwkkhA4mWS
hDKzzltNGFuYNRQw6fhcsvHaJFW7Wn8UlSE00YsomQqCteJTrBoUDo1vOIom2bjT
ZDU9PJIKW2QnilDWBhfc9W3Z3txeaW6XZqr4fd1FGTOtRfpcYx5RmWbvkHcZnXkj
d91FbcJMPkibC4T1m/4T
=jEs7
-----END PGP SIGNATURE-----

--HnQK338I3UIa/qiP--
