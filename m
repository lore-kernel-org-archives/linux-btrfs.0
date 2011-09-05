From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Problems with set-default, home subvolume and snapshot
Date: Mon, 5 Sep 2011 14:57:40 +0100
Message-ID: <20110905135740.GO9907@carfax.org.uk>
References: <4E64A0C5.2060409@cyberphoria.org>
 <20110905135129.GI11678@ds.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gh4H09KImyIEQ1se"
To: =?iso-8859-1?Q?Bj=F6rn?= Kalkbrenner <terminar@cyberphoria.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110905135129.GI11678@ds.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>


--gh4H09KImyIEQ1se
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 05, 2011 at 03:51:29PM +0200, David Sterba wrote:
> Hi,
>=20
> On Mon, Sep 05, 2011 at 12:13:25PM +0200, Bj=F6rn Kalkbrenner wrote:
> > Then i tried to
> > "mount -o subvolumeid=3D256 /dev/mapper/root /home" (id of home subvol)
> > and the content of my home is back...
>=20
> this is a known limitation and a fix is pending in Josef's development
> tree
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/josef/btrfs-work.git;a=3Dcomm=
it;h=3D4fbb149dfc7454d0f233fa8e5b9167f3645c8fcc
>=20
>=20
> "Btrfs: fix how we mount subvol=3D<whatever>
>=20
>  We've only been able to mount with subvol=3D<whatever> where whatever was
>  a subvol within whatever root we had as the default.  This allows us to
>  mount -o subvol=3Dpath/to/subvol/you/want relative from the normal
>  fs_tree root.  Thanks,"
>=20
> currently, the /home subvolume is searched inside the volume set by
> 'set-default'. When you change it to an alternative root snapshot, the
> '/home' subvolume lookup fails as you've seen.
>=20
> The patch changes it so that the subvolumes are always looked up to the
> original default root subvolume (I don't know of a better name, internal
> id 5 or alse selectable by subvolid=3D0).

   I've always tried to refer to it as the "top level" or "subvolid=3D0".

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Always be sincere,  whether you mean it or not. ---        =20

--gh4H09KImyIEQ1se
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOZNVUIKyzvlFcI40RAkY3AJ9qdngtA6xtqoxITOL4Y4YOAvpwCgCfRJ/i
KlyzR3Tc7LbeK0YJMhckCaQ=
=Sa+/
-----END PGP SIGNATURE-----

--gh4H09KImyIEQ1se--
