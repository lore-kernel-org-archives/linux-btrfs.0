From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: your mail
Date: Tue, 20 Sep 2011 16:40:13 +0100
Message-ID: <20110920154013.GF21530@carfax.org.uk>
References: <c627c52800e0bb4e7884aa7174cb4a18@www.jots.org>
 <20110920153540.GE21530@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E7i4zwmWs5DOuDSH"
To: linux-btrfs@vger.kernel.org, Ken D'Ambrosio <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110920153540.GE21530@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--E7i4zwmWs5DOuDSH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

   [Your Reply-to: header was screwed up, so I'm sending this again.

=46rom: Ken D'Ambrosio <ken@jots.org>
Reply-to: File's@jots.org, checksum?@jots.org

]

On Tue, Sep 20, 2011 at 04:35:40PM +0100, Hugo Mills wrote:
> On Tue, Sep 20, 2011 at 11:24:30AM -0400, Ken D'Ambrosio wrote:
> > Just wondering if/how one goes about getting the btrfs checksum of a gi=
ven
> > file.  Is there a way?
>=20
>    Checksums are computed on individual 4k blocks, not on the whole
> file. There's no explicit interface for retrieving checksums, but if
> you understand the data structures, you can get hold of the checksums
> for a file using the BTRFS_IOC_TREE_SEARCH ioctl.
>=20
>    Hugo.
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "How deep will this sub go?" "Oh,  she'll go all the way to ---  =20
                    the bottom if we don't stop her."                   =20

--E7i4zwmWs5DOuDSH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOeLPdIKyzvlFcI40RAhiLAKCT5J/sx1RpyPSD60XQNnpuc1y6GwCghOxy
psV45hFf6p0heVUgf3tUSYA=
=2ccW
-----END PGP SIGNATURE-----

--E7i4zwmWs5DOuDSH--
