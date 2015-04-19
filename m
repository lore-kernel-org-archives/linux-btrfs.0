Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57814 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbbDSPSy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 11:18:54 -0400
Date: Sun, 19 Apr 2015 15:18:51 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Craig Ringer <craig@2ndquadrant.com>, linux-btrfs@vger.kernel.org
Subject: Re: The FAQ on fsync/O_SYNC
Message-ID: <20150419151851.GA18187@carfax.org.uk>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com>
 <49296740.rPqQP4vAjc@merkaba>
 <CAMsr+YH9jC-x57_fVv8N+DuhotYCZAibTE2ELQwN=DgK3qoL9w@mail.gmail.com>
 <2307095.Pe1DVVsSIY@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
In-Reply-To: <2307095.Pe1DVVsSIY@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2015 at 05:10:30PM +0200, Martin Steigerwald wrote:
> Am Sonntag, 19. April 2015, 22:31:02 schrieb Craig Ringer:
> > On 19 April 2015 at 22:28, Martin Steigerwald <martin@lichtvoll.de>=20
> wrote:
> > > Am Sonntag, 19. April 2015, 21:20:11 schrieb Craig Ringer:
> > >> Hi all
> > >=20
> > > Hi Craig,
> > >=20
> > >> I'm looking into the advisability of running PostgreSQL on BTRFS, and
> > >> after looking at the FAQ there's something I'm hoping you could
> > >> clarify.
> > >>=20
> > >> The wiki FAQ says:
> > >>=20
> > >> "Btrfs does not force all dirty data to disk on every fsync or O_SYNC
> > >> operation, fsync is designed to be fast."
> > >>=20
> > >> Is that wording intended narrowly, to contrast with ext3's nasty
> > >> habit
> > >> of flushing *all* dirty blocks for the entire file system whenever
> > >> anyone calls fsync() ? Or is it intended broadly, to say that btrfs's
> > >> fsync won't necessarily flush all data blocks (just metadata) ?
> > >>=20
> > >> Is that statement still true in recent BTRFS versions (3.18, etc)?
> > >=20
> > > I don=B4t know, thus leave that for others to answer. I always assume=
d a
> > > strong fsync() guarentee as in "its on disk" with BTRFS. So I am
> > > interested in that as well.
> > >=20
> > > But for databases, did you consider the copy on write fragmentation
> > > BTRFS will give? Even with autodefrag, afaik it is not recommended to
> > > use it for large databases on rotating media at least.
> >=20
> > I did, and any testing would need to look at the efficacy of the
> > chattr +C option on the database directory tree.
> >=20
> > PostgreSQL is its self copy-on-write (because of multi-version
> > concurrency control), so it doesn't make much sense to have the FS
> > doing another layer of COW.
> >=20
> > I'm curious as to whether +C has any effect on BTRFS's durability, too.
>=20
> You will loose the ability to snapshot that directory tree then.

   No you won't.

   The +C attribute still allows snapshotting and reflink copies.
However, after the snapshot, writes to either copy will result in that
copy being CoWed. (Specifically, writes to an extent of a +C file with
more than one reference to the extent will result in a CoW operation,
until there is only one reference, and then the writes will not be
CoWed again).

   The practical upshot of this is that every snapshot of, and
subsequent writes to, a +C file will introduce fragmentation in the
same way that writes to a non-+C file would.

   You also have a disadvantage with +C that you lose the checksumming
features of the FS, and hence the self-healing properties if you're
running with btrfs-native RAID.

   Hugo.

--=20
Hugo Mills             | Nothing right in my left brain. Nothing left in my
hugo@... carfax.org.uk | right brain.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVM8dbAAoJEFheFHXiqx3k4aIP/AnIoezQabLGU4rxpPiBdjMd
Z6FW9kQUhJE58GMRxh3c1CCiMPqhY/34kR7ntpZ4gkr2ZHgh48x/hDkiBZf0zM/E
kHt5aTC0rBsMLn6zRvEnwfMvGBXqsZDSbU/89C8Dc1QensjMb7Cj/8i+oS1kP+aG
bSrsCABNN74x9NMW9sF4kdYjQKBrcE1WHlb63i7eOShP39eP8R/rVQm8du8TyA64
s8sht7miNF2yihr0BS/+DL3lJ80NHm+6n0ZkKh7U8pTeh9dFb+ZRYndf9bSAA+KF
D8JM6qfNiGphpQMoDN9VCDrQLSm1qhSvCv9k0Mc267qHExfQfRSIVGJWZ/bekBuo
zzV8eF3BSmB/AOkd3WVf7olCEzIYwAWtP6OWty/oS6hYlkGoqAhZQT84UQiihjQM
u6CMLKCFtQYzY7QAtvQ31RHjxcHL4ybds8hS3Eh88RokDg2WP/BPiE1kglKf+u7C
iQ/lSP5qcdlz/yYNjI0MvZbv2Rha3JBjLyHjY6I2crIWTeSdSrDXhOjofZABI1O4
Uop5byGJ5MM0YG304EOqT4qzlGiMCPeTIWThcCjYYjrgPjhkk/2b6w9+xJ9cLfMB
WKaKXhYhbOOrni1l1yzHSeX+odJmDh/6Lf8BtMFJ+OnWzQgcOinbvrWpTo7ivKgw
vUMPq3VwyuwKzUSlD95U
=5KrK
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
