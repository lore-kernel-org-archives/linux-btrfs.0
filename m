Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59449 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaA0Smg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 13:42:36 -0500
Date: Mon, 27 Jan 2014 18:42:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: KC <impactoria@googlemail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Snapshots =?utf-8?B?4oCTIG5vbw==?= =?utf-8?Q?b?= questions
Message-ID: <20140127184210.GM3314@carfax.org.uk>
References: <52E664E0.5070909@gmail.com>
 <20140127140350.GL3314@carfax.org.uk>
 <D927B5A8-4670-4A26-8C21-E389BBB0487E@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xtmLDbP6TiKhntQb"
In-Reply-To: <D927B5A8-4670-4A26-8C21-E389BBB0487E@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xtmLDbP6TiKhntQb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2014 at 11:35:03AM -0700, Chris Murphy wrote:
>=20
> On Jan 27, 2014, at 7:03 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>=20
> > On Mon, Jan 27, 2014 at 02:53:36PM +0100, KC wrote:
> >> I have been trying to understand how snapshots work (in BRTFS and in
> >> general), but I still have some questions, and would appreciate if
> >> someone could clear them for me.
> >> To make things easier, I tried to make most of them Yes/No questions:
> >>=20
> >> 1. When creating the filesystem, I only made btrfs partition with no
> >> subvolumes. Do I have to use subvolumes, or can I snapshot entire
> >> =E2=80=9C/=E2=80=9C?
> >=20
> >   / (the top level of the FS) is a subvolume as well -- it's the only
> > one that can't be renamed or deleted, though.
>=20
>=20
> I'll point out a source of confusion I've had, and see new users have the=
 same confusion quite often also. Within the file system hierarchy, / is a =
mount point. It could be that subvolume ID 5 is mounted there, which is how=
 opensuse's default rootfs on Btrfs works. However, Fedora's / is a subvolu=
me named root, the top level ID 5 subvolume isn't mounted by default.

   I agree the terminology gets confusing. I try to be consistent with
the set of words used in the SysadminGuide and (at least some of) the
rest of the website:

Subvolume id=3D5: "top level of the FS"
The top of the current visible UNIX filesystem structure: "/"
Root's home directory: "~root"

   I always try to avoid using the word "root" for any of them, as
it's rather heavily overloaded at this point.

> So / is not necessarily the top level of the file system. I'm not sure wh=
at to call the undeleteable ID 5 subvolume. It's the default subvolume, but=
 if the user changes the default subvolume then it isn't. Calling it the de=
fault default is maybe more confusing. And calling it subvolume ID 5 is a b=
it confusing because subvolume ID 0 maps to 5, and many users are more fami=
liar with subvol ID 0 than ID 5. And then if I have a subvolume within a su=
bvolume mounted and do a btrfs list, it shows top level ID with a value oth=
er than 5.
>=20
> Anyway I really don't know what else to call the undeletable first subvol=
ume.

   I call it "the top level of the btrfs filesystem", as that's what
it is. (Even if you don't always mount the top level of the FS).

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- I always felt that as a C programmer, I ---            =20
                         was becoming typecast.                         =20

--xtmLDbP6TiKhntQb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUuaoglheFHXiqx3kAQJn/w//VUneqkyuWtrW8GHW1iyD7KLpwE+QuF0o
qiUC+u7g1B8aKI1K6JF95xbMkNATsbM77UswV8U8GAynPaU+IDbSvdSHD5V3iIQ2
s0AZzkkqyHAA3ACNMGIHSp2w7ZPH+zLnmYskU8PPbEFYgd4730hq/AG2TWf/7zq2
9BgMjOT6ALrS7oJLoeU1gtm9SfV9ioxoLHLOV8XdC9sSBHGfn9ow38o/sWxVhX7+
jc5/ZVCM2dgygZPuFahDRjRoYZNpr7SaVA/e6Bm6EqDJ8g12YHbxDvQEBQrGO9eq
/WVJrnz6YpA+vXJZXbqxSSHgnxSfF5+mZz9lBwOGvQH9v58Th/CA5/f8wetq41w/
NoVhd9HMDDFoTVCfS2wwYGlkg1JtNNpfhgTyfTyjihli0DSEO9KCbk5h7FXTGG+Y
pTF5XAs0PV/U2UyKUOU8QrArJyeTeLeRvO+LBy4d5lW2wLpa7QIU7Wl8SmL8POUg
DQc8aMkkQkBpJ+tWCm9llX50C7jWwb5yRnA+s7aa+PniBlsrrAfC4Y8ndtZvX2pv
DHgpBdIIUEtOthWN/lP89X6nW/sYXXx4D30KkMnitCp4bxAT5HUCg57heNNiynSS
hTVfARfA0m8lgiXCDCcw14J0OnyqdIRZKNksyxg7MuvVFluZHPRG1mSDSTH2wffg
dhBLY96JR/0=
=zJid
-----END PGP SIGNATURE-----

--xtmLDbP6TiKhntQb--
