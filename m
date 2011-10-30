From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Find RAID level, Change RAID level.
Date: Sun, 30 Oct 2011 14:31:50 +0000
Message-ID: <20111030143150.GR29548@carfax.org.uk>
References: <CACCfv7oD=u3dyz38Q32+ehi0gG_-TZes-E6WMD3YVETDexbpNA@mail.gmail.com>
 <Bwm7ykHD1uB@helmut.hullen.de>
 <CACCfv7onURQQGGtY63kcirrxFtW4w-K8x0uqb_TPExoJc96row@mail.gmail.com>
 <20111030140617.GA7012@zambezi.lan>
 <CACCfv7rE+1v5bAo4aDDq1i-_4BG8VRCTowDQt1uWDaZ=czgCyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sBcizk6cgRZY6rnJ"
Cc: Ilya Dryomov <idryomov@gmail.com>, linux-btrfs@vger.kernel.org
To: Jordan Windsor <jordanw2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACCfv7rE+1v5bAo4aDDq1i-_4BG8VRCTowDQt1uWDaZ=czgCyQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--sBcizk6cgRZY6rnJ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 31, 2011 at 12:56:51AM +1030, Jordan Windsor wrote:
> On Mon, Oct 31, 2011 at 12:36 AM, Ilya Dryomov <idryomov@gmail.com> wrote:
> > On Mon, Oct 31, 2011 at 12:10:34AM +1030, Jordan Windsor wrote:
> >> Thanks, It currently shows this:
> >>
> >> Data: total=3D195.01GB, used=3D193.93GB
> >> System, DUP: total=3D8.00MB, used=3D28.00KB
> >> System: total=3D4.00MB, used=3D0.00
> >> Metadata, DUP: total=3D1.75GB, used=3D385.41MB
> >> Metadata: total=3D8.00MB, used=3D0.00
> >>
> >> I didn't specify any RAID levels during creation. I'd like to have a
> >> RAID0 installation across two hard drives.
> >
> > How many devices do you have in your FS right now ? =A0If it's only 1 t=
hen
> > add another one (btrfs device add <dev> <path to FS>) and run balance
> > (btrfs fi balance <path to FS>). =A0That should give you raid0 for data
> > across two drives w/o applying any patches.
>=20
> Thanks, I was wondering if I added a device that was already part of
> another btrfs volume, then would I have the files merged as one volume
> or overwritten in the newly added one?

   You'll lose the original data on the disk you're adding. No merging
will take place.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                        --- argc, argv, argh! ---                       =20

--sBcizk6cgRZY6rnJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOrV/WIKyzvlFcI40RAvJQAKCnzGiIc1G1cquu3hmtFzf3Y80udwCdH8Ca
8XFdF9kj3Rgt2jIyFL++f2M=
=E4nd
-----END PGP SIGNATURE-----

--sBcizk6cgRZY6rnJ--
