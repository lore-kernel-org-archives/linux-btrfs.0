Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40724 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaJBGxG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Oct 2014 02:53:06 -0400
Date: Thu, 2 Oct 2014 07:53:02 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Justin Brown <justin.brown@fandingo.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Fwd: Deleting a Subvol from a Cancelled Btrfs-Send
Message-ID: <20141002065302.GF11747@carfax.org.uk>
References: <CAKZK7uzNJWSQAmaem4eZj-dcSJOvmT=-Mn53rjCbb=fNY9zEhw@mail.gmail.com>
 <CAKZK7uwWDQa_7LThjW_58+DpNQogkepuwvPhg-9bzsgyQjn14Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yZnyZsPjQYjG7xG7"
In-Reply-To: <CAKZK7uwWDQa_7LThjW_58+DpNQogkepuwvPhg-9bzsgyQjn14Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yZnyZsPjQYjG7xG7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 02, 2014 at 12:05:39AM -0500, Justin Brown wrote:
> I'm experimenting with btrfs-send. Previously (2014-09-26), I did my
> first btrfs-send on a subvol, and that worked fine. Today, I tried to
> send a new snapshot. Unfortunately, I realized part way through that I
> forgot to specify the parent to only send a delta, and killed the send
> with ^C.
>=20
> On the destination, I'm left with:
>=20
> ~$ sudo btrfs subvol list /var/media/backups/venus/home/
> ID 2820 gen 57717 top level 5 path media
> ID 2821 gen 57402 top level 5 path ovirt
> ID 4169 gen 57703 top level 2820 path media/backups/venus/home
> ID 4170 gen 57575 top level 4169 path home-2014-09-26
> ID 4243 gen 57707 top level 4169 path home-2014-10-01
>=20
> Home-2014-10-01 was the partial send that was cancelled. I figured
> that I could delete this partial subvol and try again.
>=20
> ~$ sudo btrfs subvol del home-2014-10-01
> Transaction commit: none (default)
> ERROR: error accessing 'home-2014-10-01'

   If you're not doing this from /var/media/backups/venus/home/ it
won't succeed. You need to specify (either via a relative path or an
absolute one) where the subvol is, not just what its name is.

   (Consider what happens if you have two filesystems, each with a
home-2014-09-26 subvol.)

   Hugo.

> Obviously, trying to delete the subvol directory fails too:
>=20
> ~$ sudo rm -rf /var/media/backups/venus/home/home-2014-10-01/
> rm: cannot remove =E2=80=98/var/media/backups/venus/home/home-2014-10-01/=
=E2=80=99:
> Operation not permitted
>=20
> Is there anyway to delete this partial subvol?
>=20
> Thanks,
> Justin

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- All hope abandon,  Ye who press Enter here. ---          =20

--yZnyZsPjQYjG7xG7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVCz2TVheFHXiqx3kAQIJLQ//XGMmUjj3z8fupyU36nBn6Hl3mycxfNt8
IAGS70nGtoA692J8LqQXhoBgbbSoEznLxZUpzCGB0ydP7fhZ42MoNNE3JkvFb/n1
7ZwQJfbxyZhAECuDBymwRXyqz6U7TndEDiM/9KNqVuMpNhv2ZCsUsLFMW0tpiJqt
qgcdj++BXMr9Ln987iybTylWVw7zN+PkEFOfEaKAi6nmzsgZQy8DnSPPCeJRjvRp
h2jLfza4FyjvgIHnc7/tKFgizt/9BJli81AB2pD/2OuEwQ3paJjwmgDiAyvJ+mCe
V4KTbeW3HqxO1Wbz2s5VodVGG012kKcLztSJamQ9hbxc2vCgwnXiZZfMi6kUyrrr
bWPPJhGGykM9n0JRHAMK4JTRChCe7T16C2Hmwclq4tQ6bagJYIDJGClZ5jwR6mhL
zcSQul0XqKT7kqe8r5Kzu7Kj6sdIYV0dFrx8J6R8Na55ng4Qw5nCpNGeRCbCrE2r
yOwohB5G4crv/nuuSByv3rvQHOMkYoh1fxrQqEJLto7GKxOTT27BpuC2gTQwtUWN
rWwHxslYPhpJx6qLkgXY2qeZIBlpqDk5seLmr2GLDthMOrawtP5I5cw8eOFoZ2sj
I2OS65SiZWsjr5p7idlScshEfChm3Lll3qxOnAgpCrdI7dGMIVpXbTKujnm6Klv3
yQ08Y+c2b6w=
=EfoG
-----END PGP SIGNATURE-----

--yZnyZsPjQYjG7xG7--
