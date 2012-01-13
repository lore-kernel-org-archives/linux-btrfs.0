From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Can't resize second device in RAID1
Date: Fri, 13 Jan 2012 23:17:17 +0000
Message-ID: <20120113231717.GB21769@carfax.org.uk>
References: <CADy=jfVZjRAE049OiD6VkoKkpzZh9e_=V62AvuVwxyHZyfuU1w@mail.gmail.com>
 <CADy=jfWbzq81CrhCFy+RVd8e7265XZgkqomwOOxYaKehSpzasQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Cc: linux-btrfs@vger.kernel.org
To: "Marco L. Crociani" <marco.crociani@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADy=jfWbzq81CrhCFy+RVd8e7265XZgkqomwOOxYaKehSpzasQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 14, 2012 at 12:12:06AM +0100, Marco L. Crociani wrote:
> Hi,
> the situation:
> Label: 'RootFS'=A0 uuid: c87975a0-a575-405e-9890-d3f7f25bbd96
> =A0=A0=A0 Total devices 2 FS bytes used 284.98GB
> =A0=A0=A0 devid=A0=A0=A0 2 size 311.82GB used 286.51GB path /dev/sdb3
> =A0=A0=A0 devid=A0=A0=A0 1 size 897.76GB used 286.51GB path /dev/sda3
>=20
> RootFS created when sda3 was 897.76GB and sdb3 311.82GB.
> I have now freed other space on sdb. So I deleted sdb3 and recreated
> it occupying all available space.
>=20
> Disk /dev/sdb: 2000 GB, 2000396321280 bytes
> 255 heads, 63 sectors/track, 243201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> /dev/sdb3=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 54=A0=A0=A0=A0=A0 117249=
=A0=A0 941368837=A0=A0 83=A0 Linux
>=20
> same as
> /dev/sda3=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 54=A0=A0=A0=A0=A0 117249=
=A0=A0 941368837=A0=A0 83=A0 Linux
>=20
> # ./btrfs filesystem resize max /mnt/RootFS
> Resize '/mnt/RootFS' of 'max'
>=20
> on dmesg I get only:
> [=A0 657.438464] btrfs: new size for /dev/sda3 is 963962208256
>=20
> # ./btrfs fi sh
> Label: 'RootFS'=A0 uuid: c87975a0-a575-405e-9890-d3f7f25bbd96
> =A0=A0=A0 Total devices 2 FS bytes used 284.98GB
> =A0=A0=A0 devid=A0=A0=A0 2 size 311.82GB used 286.51GB path /dev/sdb3
> =A0=A0=A0 devid=A0=A0=A0 1 size 897.76GB used 286.51GB path /dev/sda3
>=20
> /dev/sdb3 is the same.
>=20
> How can I resize /dev/sdb3?

   I think the syntax you need is btrfs fi resize max /mnt/RootFS:2

   But I could be wrong. If it works, can you add it to the UseCases
page on the wiki, please?

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Someone's been throwing dead sheep down my Fun Well ---      =20

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPELt8IKyzvlFcI40RAmqYAJ403ClqQ1XLwMXvzW+xRIT7DDWVZgCguo7p
U4teRc3LlpEFHwINTtvCQ80=
=trFY
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
