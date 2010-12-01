From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 21:28:22 +0000
Message-ID: <20101201212822.GC4087@carfax.org.uk>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
 <20101201163800.GA4087@carfax.org.uk>
 <20101201173830.GA7021@localhost.localdomain>
 <20101201193512.GB4087@carfax.org.uk>
 <AANLkTink81Mcc9yEUF2cw3TZg=7F6=H52A-tfbtb8E39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com
To: Freddie Cash <fjwcash@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTink81Mcc9yEUF2cw3TZg=7F6=H52A-tfbtb8E39@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 01, 2010 at 12:24:28PM -0800, Freddie Cash wrote:
> On Wed, Dec 1, 2010 at 11:35 AM, Hugo Mills <hugo-lkml@carfax.org.uk> wro=
te:
> >> =A0The idea is you are only charged for what blocks
> >> you have on the disk. =A0Thanks,
> >
> > =A0 My point was that it's perfectly possible to have blocks on the
> > disk that are effectively owned by two people, and that the person to
> > charge for those blocks is, to me, far from clear. You either end up
> > charging twice for a single set of blocks on the disk, or you end up
> > in a situation where one person's actions can cause another person's
> > quota to fill up. Neither of these is particularly obvious behaviour.
>=20
> As a sysadmin and as a user, quotas shouldn't be about "physical
> blocks of storage used" but should be about "logical storage used".
>=20
> IOW, if the filesystem is compressed, using 1 GB of physical space to
> store 10 GB of data, my "quota used" should be 10 GB.
>=20
> Similar for deduplication.  The quota is based on the storage *before*
> the file is deduped.  Not after.
>=20
> Similar for snapshots.  If UserA has 10 GB of quota used, I snapshot
> their filesystem, then my "quota used" would be 10 GB as well.  As
> data in my snapshot changes, my "quota used" is updated to reflect
> that (change 1 GB of data compared to snapshot, use 1 GB of quota).

   So if I've got 10G of data, and I snapshot it, I've just used
another 10G of quota?

> You have to (or at least should) keep two sets of stats for storage usage:
>   - logical amount used ("real" file size, before compression, before
> de-dupe, before snapshots, etc)
>   - physical amount used (what's actually written to disk)
>=20
> User-level quotas are based on the logical storage used.
> Admin-level quotas (if you want to implement them) would be based on
> physical storage used.
>=20
> Thus, the output of things like df, du, ls would show the "logical"
> storage used and file sizes.  And you would either have an additional
> option to those apps (--real or something) to show the "actual"
> storage used and file sizes as stored on disk.
>=20
> Trying to make quotas and disk usage utilities to work based on what's
> physically on disk is just backwards, imo.  And prone to a lot of
> confusion.

   Trying to make quotas work based on what's physically on the disk
appears to have serious issues on the semantics of "using up space",
so I agree with you on this point (and, indeed, it was the point I was
trying to make).

   However, doing it that way also effectively penalises users and
prevents (or severely discourages) them from using the advanced
functions of the filesystem. There's no benefit (in disk usage terms)
to the user in using a snapshot -- they might as well use plain cp.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- I believe that it's closely correlated with ---          =20
                       the aeroswine coefficient.                       =20

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM9r32IKyzvlFcI40RAngsAKCqb9oGVVHvCBiDV6SWK3/+6NQiuwCgjpW9
p9ImxhkvxlLO6qtTwKRcqic=
=69HP
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
