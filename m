Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52718 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab3CIVq0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Mar 2013 16:46:26 -0500
Date: Sat, 9 Mar 2013 21:46:22 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Harald Glatt <mail@hachre.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Message-ID: <20130309214622.GA30771@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <CAFWF=am4ki529Zez4123gYk3BD+Z9RONRpAK7NZe=skHzcdMiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
In-Reply-To: <CAFWF=am4ki529Zez4123gYk3BD+Z9RONRpAK7NZe=skHzcdMiw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 09, 2013 at 10:31:25PM +0100, Harald Glatt wrote:
> On Sat, Mar 9, 2013 at 9:31 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>=20
> >    Some time ago, and occasionally since, we've discussed altering the
> > "RAID-n" terminology to change it to an "nCmSpP" format, where n is the
> > number of copies, m is the number of (data) devices in a stripe per cop=
y,
> > and p is the number of parity devices in a stripe.
> >
> >    The current kernel implementation uses as many devices as it can in =
the
> > striped modes (RAID-0, -10, -5, -6), and in this implementation, that is
> > written as "mS" (with a literal "m"). The mS and pP sections are omitted
> > if the value is 1S or 0P.
> >
> >    The magic look-up table for old-style / new-style is:
> >
> > single           1C (or omitted, in btrfs fi df output)
> > RAID-0           1CmS
> > RAID-1           2C
> > DUP                      2CD
> > RAID-10          2CmS
> > RAID-5           1CmS1P
> > RAID-6           1CmS2P
> >
> >    The following patch set modifies userspace tools to accept C/S/P for=
mats
> > in input (mkfs and the restriper). The older formats are also accepted.=
 It
> > also prints the newer formats by default in btrfs fi df, with an option=
 to
> > show the older format for the traditionalists.
> >
> >    I'm not sure whether we should omit the 1C in btrfs fi df output, or
> > make it explicit even in the "single" case.
> >
> >    Hugo.
> >
> > Hugo Mills (5):
> >   Use nCmSpP format for mkfs
> >   Move parse_profile to utils.c
> >   Convert balance filter parser to use common nCmSpP replication-level
> >     parser
> >   Change output of btrfs fi df to report new (or old) RAID names
> >   Add man page description for nCmSpP replication levels
> >
> >  cmds-balance.c      |   23 +++------
> >  cmds-filesystem.c   |  135
> > +++++++++++++++++++++++++++++++++++++++++++--------
> >  man/btrfs.8.in      |    9 ++++
> >  man/mkfs.btrfs.8.in |   24 ++++++++-
> >  mkfs.c              |   35 ++++---------
> >  utils.c             |   94 +++++++++++++++++++++++++++++++++++
> >  utils.h             |    1 +
> >  7 files changed, 258 insertions(+), 63 deletions(-)
> >
> > --
> > 1.7.10.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
> I vote make it explicit to give people a chance to understand the new way
> it works even with just one device. The idea for this new naming scheme is
> great, I like it!! Will btrfs allow for things like 2C10SP2 too? Basically
> two RAID6 arrays with 12 drives each (10 for data, 2 for parity), if I
> understand it right with the entire array being mirrored to another one.

   You wouldn't necessarily get exactly the same semantics. 2C10S2P
would require at least 24 drives, and in the traditional "mirrored
pair of RAID-6" configuration, you could lose drives 1-14, and still
rebuild successfully from the the remaining degraded RAID-6 array. The
btrfs implementation probably wouldn't let you go so far -- you'd only
get a guarantee of being able to lose any four devices; anything after
that would be quite likely to destroy the array, because the
allocation of "position" to device in any given stripe isn't as
regimented as for the traditional RAID configurations.

   Basically, both would provide the same minimum safety guarantees,
but the odds of the btrfs array losing (some) data after that point
are considerably higher. This is all moot for now, anyway, because as
far as I know there aren't any plans for generalising this completely.

   Chris is definitely planning fixed values for mS (so you can ask
for, say, exactly 4 stripes and one parity), and values for nC greater
than 2. As far as I know, there aren't any plans for nC > 1 and pP > 0
together. I haven't got far enough into the kernel code to work out
whether that's simple or not to implement.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- What's a Nazg=FBl like you doing in a place like this? ---     =
=20

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUTutrr9z9OVl50rAAQJJNw//XUwfuY/Te3W3V3hClb2j3I8JslTL+Nyl
IU37zv9n6l7IPiWf2PArmmVILiMoy7bw1iIvNAJZZJLRefDQF/8a+4vXTnAtM6YY
IAgIY8T6LvZLquoC2fOL5kfJhKdiuOgymd26oQFXVpm14zog07t+Cf6pJl8nKgFU
B6xUKMNaCoWbEMkyVOkklDFUebd/+AvkRAD3RKo7+NHHJVeiULSLKpdtG/m0ZfAy
RkKTAxG+NDq+key6ZZ3I5KaGa7edjRqYSG/Ia48y20HqPRVlVsst7KbzZc8BV7LV
44xK9nf+p2a5Y4Qcs0+sC+MkuHG6gxMUHIvN0fiGpQfQi2i5Inkb0NG1AVy4EDL8
Y9UhQCkRrxTB8kCwScB4idW4RVqakD3KeRpkzR5YHPTHk0OV4nUKfLpTlOe6DTM+
O11lwK/wynUCxztv2qf2BoBEtxPUh3XVW2+G5nt3881qJKDBSA6XrK10uF6qvFWx
Me+yH6li5Tj6zwV1xQjaPuq3UfKI5ed2rfc1kQL5xQNTcNA+F7AA0l484gb4ZztD
TvdD0tin00IoSMCqDmjY2298DAbFBHLZsH2vtvKowrUcPOCLVF/6CuNc+wQI8wo3
egtElogXrPunZcBBdQKzVFTLLA3nWxxmZvXb+ShLEA96XZie3d/SAkOvTL6/mWuf
dXMWDbzvP64=
=Xs4b
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
