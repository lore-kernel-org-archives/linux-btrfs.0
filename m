From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: strange btrfs sub list output
Date: Fri, 27 May 2011 10:45:23 +0100
Message-ID: <20110527094523.GA12089@carfax.org.uk>
References: <20110526212203.GA4611@yahoo.fr>
 <chaz20110527080157.GA27537@seebyte.com>
 <4DDF5EEF.6060706@gmail.com>
 <chaz20110527084733.GC27537@seebyte.com>
 <20110527091224.GA15627@carfax.org.uk>
 <chaz20110527093029.GA30613@seebyte.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110527093029.GA30613@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 27, 2011 at 10:30:29AM +0100, Stephane Chazelas wrote:
> 2011-05-27 10:12:24 +0100, Hugo Mills:
> [skipped useful clarification]
> >=20
> >    That's all rather dense, and probably too much information. Hope
> > it's helpful, though.
> [...]
>=20
> It is, thanks.
>=20
> How would one end up in a situation where the output of "btrfs
> sub list ." has:
>=20
> ID 287 top level 285 path data
>=20
> How could a "subvolume 285" become a "top level"?

> How does one get a subvolume with a top-level other than "5"?

   This just means that subvolume 287 was created (somewhere) inside
subvolume 285.

   Due to the way that the FS trees and subvolumes work, there's no
global namespace structure in btrfs; that is, there's no single data
structure that represents the entirety of the file/directory hierarchy
in the filesystem. Instead, it's broken up into these sub-namespaces
called subvolumes, and we only record parent/child relationships for
each subvolume separately. The "full path" you get from "btrfs subv
list" is reconstructed from that information in userspace(*).

   Hugo.

(*) Here's how it does it:

The userspace tool gets a list of every subvolume by looking at the FS
tree. It uses the corresponding back-refs to get the inode that
represents each of those FS trees inside its parent:

Subvol  inode   in subvol
256      991        5
257      896      256
258     1073      257

=46rom the inode numbers, it can then recursively walk back up the
directory path to the top of each subvolume:

Subvol  inode   in subvol    relative path
256      991        5        henry
257      896      256        edward/mary
258     1073      257        elizabeth

=46rom that, it can then reconstruct the full pathnames, by walking back
up the subvolume tree:

subvol 258 is elizabeth in 257
           is edward/mary/elizabeth in 256
           is henry/edward/mary/elizabeth in 5

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- A linked list is still a binary tree.  Just a very unbalanced --- =20
                             one.  -- dragon                            =20

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN33KzIKyzvlFcI40RAol0AKDASm3M8ZugXePGB+InFF71wpSLtACeLWP4
1ZlEmivL3kDgJrxOWh9Wjgo=
=aL+y
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
