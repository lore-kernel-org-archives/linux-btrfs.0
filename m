Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59135 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbDSSS1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 14:18:27 -0400
Date: Sun, 19 Apr 2015 18:18:24 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Craig Ringer <craig@2ndquadrant.com>, linux-btrfs@vger.kernel.org
Subject: Re: The FAQ on fsync/O_SYNC
Message-ID: <20150419181824.GC18187@carfax.org.uk>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com>
 <2307095.Pe1DVVsSIY@merkaba>
 <20150419151851.GA18187@carfax.org.uk>
 <2245776.oZdMfpEQBm@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ycz6tD7Th1CMF4v7"
In-Reply-To: <2245776.oZdMfpEQBm@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Ycz6tD7Th1CMF4v7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2015 at 07:50:32PM +0200, Martin Steigerwald wrote:
> Am Sonntag, 19. April 2015, 15:18:51 schrieb Hugo Mills:
> > On Sun, Apr 19, 2015 at 05:10:30PM +0200, Martin Steigerwald wrote:
> > > Am Sonntag, 19. April 2015, 22:31:02 schrieb Craig Ringer:
> > > > I'm curious as to whether +C has any effect on BTRFS's durability,
> > > > too.
> > >=20
> > > You will loose the ability to snapshot that directory tree then.
> >=20
> >    No you won't.
> >=20
> >    The +C attribute still allows snapshotting and reflink copies.
> > However, after the snapshot, writes to either copy will result in that
> > copy being CoWed. (Specifically, writes to an extent of a +C file with
> > more than one reference to the extent will result in a CoW operation,
> > until there is only one reference, and then the writes will not be
> > CoWed again).
> >=20
> >    The practical upshot of this is that every snapshot of, and
> > subsequent writes to, a +C file will introduce fragmentation in the
> > same way that writes to a non-+C file would.
> >=20
> >    You also have a disadvantage with +C that you lose the checksumming
> > features of the FS, and hence the self-healing properties if you're
> > running with btrfs-native RAID.
>=20
> Thanks for clarifying this Hugo, so chattr +C will make the directory=20
> cowed again.

   Not quite sure what you mean there.

   If you set +C on a file or directory, there's no CoW operations on
write to any of the affected files, *except* if there's a snapshot, in
which case the file being written to will have *one* CoW operation
before reverting to nodatacow again.

> And there is not checksumming on the FS at all anymore. Why is the later?=
=20
> Why can=B4t BTRFS checkum nocowed objects or at least the cowed ones in t=
he=20
> same FS? Cause of atomicity guarentees?

   Atomicity, indeed. You need to be able to update the checksum and
the new data atomically. This is possible when the data can be CoWed,
but if the data is being modified in place, there must be a short
period of time when the two parts are out of sync.

   Just to make it clear, the lack of checksums is *only* for those
files which are marked +C. The rest of the FS is unaffected.

> If this has been answered before, and I missed it, feel free to point me=
=20
> to it, I didn=B4t find anything obvious with my quick search.

   It's certainly knowledge that's out there (it's been discussed at
length on IRC, for example), but I don't know if there's anything
written up on the wiki.

   Hugo.

--=20
Hugo Mills             | Jenkins! Chap with the wings there! Five rounds
hugo@... carfax.org.uk | rapid!
http://carfax.org.uk/  |                 Brigadier Alistair Lethbridge-Stew=
art
PGP: E2AB1DE4          |                                Dr Who and the Daem=
ons

--Ycz6tD7Th1CMF4v7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVM/FwAAoJEFheFHXiqx3kpFYQAKr+RuotLCuryBhGfooASZiL
k+LUJjLL7IqUApn5Xtyx+PTYvmF9ct0JWm3YfO7xIDlti0c7KbSkX+Re4qem+zPO
y9CGuvIIB2r2wVbLceNJQPAbKW6BVb+UTl4BRtgbmx95FGGN5En6qxL5X4aiOxoG
TDTTRorsfVp6esSYysxGD9qYqndBVLpGxdSizBEQD4jS4jnKuE+xF6ZGZ8dN8hJD
UrxbZ0fEbxuFBW1+b5STlmT+hTbbEsvd5RVEOKp2GxPv8lJ0jk+6nbMpQQUH+fJt
vm8rrXgf55GcOWS90fon84hpJFoYATL+/y5ctxYpmGUplNkTF1JqJd3vhfsMmrkR
oI10xB/CnXnWqgvOiYaLiQoX8vMOkpbfALU2shT6IVSVUMB0di1C0oxzLJ8v/q08
EqqhOa6myLZmSUw/Snw9ilGZAywsAWIvabobgd7orT0GQA2IjeLdQAX2yKuNQxlR
Vt3vO2QMYDHVJGcvcMWNb/ok5LJep2uwr48sn2KLyikniazuiwXKjOD6NqqyNO7K
ii6YbeGXibsa9yNJQP/ViZeJsYv1IMjG9PuKU/x0b6anXbjJnQrSvqmPUgEdO9E0
r+t3QknVJABmLUQkC8wOonw4SZiyMql1o64/9vZ+8Q+SYElVFCM0h8BnWq8N8p3B
fbbOLqTE9DvqyCS9dBUM
=QJ4E
-----END PGP SIGNATURE-----

--Ycz6tD7Th1CMF4v7--
