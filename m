Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59999 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbbDSSlp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 14:41:45 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Craig Ringer <craig@2ndquadrant.com>, linux-btrfs@vger.kernel.org
Subject: Re: The FAQ on fsync/O_SYNC
Date: Sun, 19 Apr 2015 20:41:39 +0200
Message-ID: <6274834.Q47roFjYxL@merkaba>
In-Reply-To: <20150419181824.GC18187@carfax.org.uk>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com> <2245776.oZdMfpEQBm@merkaba> <20150419181824.GC18187@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2530797.mFKcNSpDf0"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2530797.mFKcNSpDf0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Sonntag, 19. April 2015, 18:18:24 schrieb Hugo Mills:
> On Sun, Apr 19, 2015 at 07:50:32PM +0200, Martin Steigerwald wrote:
> > Am Sonntag, 19. April 2015, 15:18:51 schrieb Hugo Mills:
> > > On Sun, Apr 19, 2015 at 05:10:30PM +0200, Martin Steigerwald wrot=
e:
> > > > Am Sonntag, 19. April 2015, 22:31:02 schrieb Craig Ringer:
> > > > > I'm curious as to whether +C has any effect on BTRFS's
> > > > > durability,
> > > > > too.
> > > >=20
> > > > You will loose the ability to snapshot that directory tree then=
.
> > > >=20
> > >    No you won't.
> > >   =20
> > >    The +C attribute still allows snapshotting and reflink copies.=

> > >=20
> > > However, after the snapshot, writes to either copy will result in=

> > > that
> > > copy being CoWed. (Specifically, writes to an extent of a +C file=

> > > with
> > > more than one reference to the extent will result in a CoW
> > > operation,
> > > until there is only one reference, and then the writes will not b=
e
> > > CoWed again).
> > >=20
> > >    The practical upshot of this is that every snapshot of, and
> > >=20
> > > subsequent writes to, a +C file will introduce fragmentation in t=
he
> > > same way that writes to a non-+C file would.
> > >=20
> > >    You also have a disadvantage with +C that you lose the
> > >    checksumming
> > >=20
> > > features of the FS, and hence the self-healing properties if you'=
re
> > > running with btrfs-native RAID.
> >=20
> > Thanks for clarifying this Hugo, so chattr +C will make the directo=
ry
> > cowed again.
>=20
>    Not quite sure what you mean there.
>=20
>    If you set +C on a file or directory, there's no CoW operations on=

> write to any of the affected files, *except* if there's a snapshot, i=
n
> which case the file being written to will have *one* CoW operation
> before reverting to nodatacow again.

What do you mean by *one* CoW operation, will BTRFS duplicate the whole=
=20
file to keep it no-cowed? Or, hmmm, I think now I get it: There will be=
 one=20
CoW operation for each write =E2=80=93 well, with some granularity, ext=
ent? =E2=80=93, but=20
*just* one, cause then the written data is cowed from the snapshot and=20=

then can be written again in a no-cowed way.

> > And there is not checksumming on the FS at all anymore. Why is the
> > later? Why can=C2=B4t BTRFS checkum nocowed objects or at least the=
 cowed
> > ones in the same FS? Cause of atomicity guarentees?
>=20
>    Atomicity, indeed. You need to be able to update the checksum and
> the new data atomically. This is possible when the data can be CoWed,=

> but if the data is being modified in place, there must be a short
> period of time when the two parts are out of sync.

And it would be too much effort or too much of a performance penalty to=
 let=20
any checksum check wait till they are in sync again?

>    Just to make it clear, the lack of checksums is *only* for those
> files which are marked +C. The rest of the FS is unaffected.

Thanks for that clarification. I read your original wording as if the w=
hole=20
FS was affected.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart2530797.mFKcNSpDf0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlUz9ucACgkQmRvqrKWZhMeVZwCdHvQNsYm7tD2Ae3Zfwcb9kHNv
I4cAnRwtEIkOQAdNFvleWnTIG4gEM2py
=rKv+
-----END PGP SIGNATURE-----

--nextPart2530797.mFKcNSpDf0--

