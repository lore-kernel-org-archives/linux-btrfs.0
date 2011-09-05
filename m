From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Mon, 5 Sep 2011 15:00:23 +0100
Message-ID: <20110905140023.GP9907@carfax.org.uk>
References: <4E64D3D5.7020407@petaramesh.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftQmbtOmUf2cr8rB"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E64D3D5.7020407@petaramesh.org>
List-ID: <linux-btrfs.vger.kernel.org>


--ftQmbtOmUf2cr8rB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 05, 2011 at 03:51:17PM +0200, Sw=E2mi Petaramesh wrote:
> Hi list,
>=20
> I don't trust theoretical benchmarks that much and prefer "real-life
> benchs" on the occasion, so here's mine:
>=20
> Given 4 laptops, the most powerful of which was running BTRFS and
> the others ext3 or ext4, all machines running Ubuntu 11.04 Natty
> 32-bit with a stock Ubuntu 2.6.38-11 kernel, all machines were given
> the following FS-intensive task :
>=20
> - Upgrade O.S. from Ubuntu 11.04 Natty to 11.10 Oneiric (beta),
> using a local packages apt-cacher.
>=20
> Machines :
>=20
> 1/ Acer Aspire 3104 WLMi, AMD Sempron Mobile 3500+ @1.8 GHz, 1.5 GB
> RAM, 80 GB SATA HD, ext4 over standard partitions
>=20
> 2/ Asus EeePC 1005PE, Intel Atom N450 @1.66 GHz, 2 GB RAM, 250 GB
> SATA HD, ext3 over AES-128 encrypted LVM
>=20
> 3/ Compaq Mini CQ10-740SF, Intel Atom N455 @1.66 GHz, 1 GB RAM, 250
> GB SATA HD, ext4 over standard partitions
>=20
> 4/ Dell XPS M1330, Intel Core 2 Duo T9300 @2.5 GHz, 2 GB RAM, 160 B
> SATA HD, BTRFS over AES-128 encrypted LVM
>=20
> Results :
>=20
> All 3 ext3 /  ext4 machines took between 60 and 90 minutes to
> complete their upgrade.
>=20
> BTRFS machine took 20 HOURS so far, still counting (ETA 15 minutes left).
>=20
> Wow. Impressive.

   That's because dpkg is known for using (f)sync very heavily.  btrfs
honours the sync request in all cases, so it's much much slower than
ext3, which doesn't. There's an LD_PRELOAD library called "eatmydata"
that you can use to paper over the issue by running it as a wrapper
around dpkg.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Always be sincere,  whether you mean it or not. ---        =20

--ftQmbtOmUf2cr8rB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOZNX3IKyzvlFcI40RAmTCAKDMCgXeCJInW0o3f21Wag438g+5zwCfSYgN
oYDla2+jO+1haI6VigjzD0A=
=j02e
-----END PGP SIGNATURE-----

--ftQmbtOmUf2cr8rB--
