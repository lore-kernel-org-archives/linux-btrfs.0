From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Problems with set-default, home subvolume and snapshot
Date: Mon, 5 Sep 2011 13:45:44 +0100
Message-ID: <20110905124544.GN9907@carfax.org.uk>
References: <4E64A0C5.2060409@cyberphoria.org>
 <20110905103033.GL9907@carfax.org.uk>
 <4E64BE74.7040000@cyberphoria.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YuJye9aIuN0w6xGV"
Cc: linux-btrfs@vger.kernel.org
To: =?iso-8859-1?Q?Bj=F6rn?= Kalkbrenner <terminar@cyberphoria.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E64BE74.7040000@cyberphoria.org>
List-ID: <linux-btrfs.vger.kernel.org>


--YuJye9aIuN0w6xGV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 05, 2011 at 02:20:04PM +0200, Bj=F6rn Kalkbrenner wrote:
> Hi!
>=20
> Thank you Hugo for your answers, but i have an update.
>=20
> "It's dead Jim."
>=20
> When i tried to mount subvolid=3D0 to a temporary folder i got a kernel
> segfault and a BUG line in btrfs kernel code somewhere (reproducable),
> after a reboot all volumes are broken, can't be mounted anymore...

   Did you manage to capture that output at all? (A photo would do).

   What kernel version are you running? (anything earlier than 2.6.39
is probably considered too old for comfort)

> btrfsfsck gave me inode errors on subvol 256 (my home).
> mount does nothing but sleep/hang...

   btrfsck doesn't generally achieve much at the moment. However,
having mount hang is quite odd. It usually either succeeds, or causes
a kernel oops (if the latter has already happened, then *subsequent*
mount attempts may hang, but the original oops is still of interest)

> Now i am trying to restore my system and home from a backup to a new
> harddrive, without btrfs at the moment...

   It'd be good if you have the time to try to reproduce this,
particularly with the latest kernels (3.0 or 3.1-rcX)

> I think my question 6 is now answered: it's completely broken.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- My doctor tells me that I have a malformed public-duty gland, --- =20
                and a natural deficiency in moral fibre.                =20

--YuJye9aIuN0w6xGV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOZMR4IKyzvlFcI40RAoGrAJwIrK2GiZ66opHr8Dv59pahnWGe/gCfa1vP
bhR/zEs8FEKt7XmZ4fGBgUc=
=k1fC
-----END PGP SIGNATURE-----

--YuJye9aIuN0w6xGV--
