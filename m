Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59878 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbbDSRuj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 13:50:39 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Craig Ringer <craig@2ndquadrant.com>, linux-btrfs@vger.kernel.org
Subject: Re: The FAQ on fsync/O_SYNC
Date: Sun, 19 Apr 2015 19:50:32 +0200
Message-ID: <2245776.oZdMfpEQBm@merkaba>
In-Reply-To: <20150419151851.GA18187@carfax.org.uk>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com> <2307095.Pe1DVVsSIY@merkaba> <20150419151851.GA18187@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1494260.VDMFrprlsi"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1494260.VDMFrprlsi
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Sonntag, 19. April 2015, 15:18:51 schrieb Hugo Mills:
> On Sun, Apr 19, 2015 at 05:10:30PM +0200, Martin Steigerwald wrote:
> > Am Sonntag, 19. April 2015, 22:31:02 schrieb Craig Ringer:
> > > On 19 April 2015 at 22:28, Martin Steigerwald <martin@lichtvoll.d=
e>
> >=20
> > wrote:
> > > > Am Sonntag, 19. April 2015, 21:20:11 schrieb Craig Ringer:
> > > >> Hi all
> > > >=20
> > > > Hi Craig,
> > > >=20
> > > >> I'm looking into the advisability of running PostgreSQL on BTR=
FS,
> > > >> and
> > > >> after looking at the FAQ there's something I'm hoping you coul=
d
> > > >> clarify.
> > > >>=20
> > > >> The wiki FAQ says:
> > > >>=20
> > > >> "Btrfs does not force all dirty data to disk on every fsync or=

> > > >> O_SYNC
> > > >> operation, fsync is designed to be fast."
> > > >>=20
> > > >> Is that wording intended narrowly, to contrast with ext3's nas=
ty
> > > >> habit
> > > >> of flushing *all* dirty blocks for the entire file system
> > > >> whenever
> > > >> anyone calls fsync() ? Or is it intended broadly, to say that
> > > >> btrfs's
> > > >> fsync won't necessarily flush all data blocks (just metadata) =
?
> > > >>=20
> > > >> Is that statement still true in recent BTRFS versions (3.18,
> > > >> etc)?
> > > >=20
> > > > I don=B4t know, thus leave that for others to answer. I always
> > > > assumed a
> > > > strong fsync() guarentee as in "its on disk" with BTRFS. So I a=
m
> > > > interested in that as well.
> > > >=20
> > > > But for databases, did you consider the copy on write
> > > > fragmentation
> > > > BTRFS will give? Even with autodefrag, afaik it is not recommen=
ded
> > > > to
> > > > use it for large databases on rotating media at least.
> > >=20
> > > I did, and any testing would need to look at the efficacy of the
> > > chattr +C option on the database directory tree.
> > >=20
> > > PostgreSQL is its self copy-on-write (because of multi-version
> > > concurrency control), so it doesn't make much sense to have the F=
S
> > > doing another layer of COW.
> > >=20
> > > I'm curious as to whether +C has any effect on BTRFS's durability=
,
> > > too.
> >=20
> > You will loose the ability to snapshot that directory tree then.
>=20
>    No you won't.
>=20
>    The +C attribute still allows snapshotting and reflink copies.
> However, after the snapshot, writes to either copy will result in tha=
t
> copy being CoWed. (Specifically, writes to an extent of a +C file wit=
h
> more than one reference to the extent will result in a CoW operation,=

> until there is only one reference, and then the writes will not be
> CoWed again).
>=20
>    The practical upshot of this is that every snapshot of, and
> subsequent writes to, a +C file will introduce fragmentation in the
> same way that writes to a non-+C file would.
>=20
>    You also have a disadvantage with +C that you lose the checksummin=
g
> features of the FS, and hence the self-healing properties if you're
> running with btrfs-native RAID.

Thanks for clarifying this Hugo, so chattr +C will make the directory=20=

cowed again.

And there is not checksumming on the FS at all anymore. Why is the late=
r?=20
Why can=B4t BTRFS checkum nocowed objects or at least the cowed ones in=
 the=20
same FS? Cause of atomicity guarentees?

If this has been answered before, and I missed it, feel free to point m=
e=20
to it, I didn=B4t find anything obvious with my quick search.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart1494260.VDMFrprlsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlUz6u0ACgkQmRvqrKWZhMdHRwCglgpxT5p9DrFAs++72MQZBi1a
gHEAniZApseJ1Ip4Vm9yVD4g/nG8G25B
=co+i
-----END PGP SIGNATURE-----

--nextPart1494260.VDMFrprlsi--

