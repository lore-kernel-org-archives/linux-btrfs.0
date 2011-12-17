From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 11:26:19 +0000
Message-ID: <20111217112619.GD17573@carfax.org.uk>
References: <201112161851.52011.Martin@lichtvoll.de>
 <201112162158.45819.Martin@lichtvoll.de>
 <20111217100302.6beffbcd@sf.vba.domain>
 <201112171209.56877.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8nsIa27JVQLqB7/C"
Cc: Sergei Trofimovich <slyich@gmail.com>, linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112171209.56877.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>


--8nsIa27JVQLqB7/C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 17, 2011 at 12:09:56PM +0100, Martin Steigerwald wrote:
> I think I will scrub / balance / defragment the filesystem after a backup=
=2E=20
> But I am not sure in what order.
>=20
> I understand that defragment defragments files. But then what does balanc=
e=20
> do? For RAID setup I have seen it distributing data evenly across drives=
=20
> when I echo > /sys/block/sda/[=E2=80=A6]/delete a drive before and BTRFS =
had to=20
> distribute unevenly cause of that. But what does it do on a filesystem on=
 a=20
> single drive? I bet it would balance out trees? Will it resize trees with=
=20
> lots of unused space as well?

   The metadata trees are automatically balanced, simply by the nature
of the B-tree algorithms used. Balance won't, in general, affect them.
The only thing that a balance will achieve on a single-disk filesystem
is to reclaim unused space from allocated block groups -- so the
"total" value in your Data and Metadata entries below will go down.

> According to
>=20
> deepdance:~> btrfs filesystem df /=20
> Data: total=3D11.23GB, used=3D6.98GB
> System, DUP: total=3D8.00MB, used=3D4.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, DUP: total=3D1.86GB, used=3D511.35MB
> deepdance:~> btrfs filesystem show
> [=E2=80=A6]
> Label: 'debian'  uuid: 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
>         Total devices 1 FS bytes used 7.48GB
>         devid    1 size 15.00GB used 14.97GB path /dev/dm-0
>=20
> Btrfs Btrfs v0.19
>=20
> the filesystem might have had some chances to fragment heavily, cause the=
=20
> tree sizes add up almost to the 15 GB of space available.
>=20
> I also remember that for some time the filesystem was nearly full which=
=20
> would explain the tree sizes.

   For metadata, the lower bound on size is 0.1% of the data size
(because checksums are computed at 4 bytes for every 4096 bytes of
data). However, data usage can be very much greater than this with
inline extents, where small files can get embedded directly in the
metadata section. This is probably more likely what explains the tree
sizes.

   I understand (although I've not done the analysis myself) that the
maximum "wasted" space in btrfs's B-tree implementation is 50%. To the
best of my knowledge, there's no compaction process for btrfs's trees
available -- nor, in general, should you need one, as a fully-
compacted tree would only have to be rearranged when more data is
added to it, thus slowing the system down after compaction.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I'll take your bet, but make it ten thousand francs. I'm only --- =20
                       a _poor_ corrupt official.                       =20

--8nsIa27JVQLqB7/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFO7HxbIKyzvlFcI40RAlGAAJ9pylYc2jmtDKzj+9eoNU7A6P49RQCfRdE5
0v+YZfuW/xc/bvygwOIs1/I=
=60Vn
-----END PGP SIGNATURE-----

--8nsIa27JVQLqB7/C--
