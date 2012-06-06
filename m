Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39934 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2FFTk2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2012 15:40:28 -0400
Date: Wed, 6 Jun 2012 20:40:24 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Jim Meyering <jim@meyering.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCHv2 3/4] avoid several strncpy-induced buffer overruns
Message-ID: <20120606194024.GU15986@carfax.org.uk>
References: <1334950046-24147-1-git-send-email-jim@meyering.net>
 <1334950046-24147-4-git-send-email-jim@meyering.net>
 <20120606193147.GS15986@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eNjIDde0W37E3OQP"
In-Reply-To: <20120606193147.GS15986@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--eNjIDde0W37E3OQP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 06, 2012 at 08:31:47PM +0100, Hugo Mills wrote:
> > @@ -378,6 +380,7 @@ static int cmd_snapshot(int argc, char **argv)
> >=20
> >  	args.fd =3D fd;
> >  	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
> > +	args.name[BTRFS_PATH_NAME_MAX-1] =3D 0;
>=20
>    This, however, is wrong. args here is a struct
> btrfs_ioctl_vol_args_v2, and the name field is BTRFS_SUBVOL_NAME_MAX+1
> long, so it should be:
>=20
> -  	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
> +  	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX+1);
> +	args.name[BTRFS_SUBVOL_NAME_MAX] =3D 0;

   Oops, just spotted the v3 with this fix in. Ignore this comment.
(I'm actually using the v3 in integration, but I reviewed the mail
=66rom a different mailbox and got the wrong series...)

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Your problem is that you've got too much taste to be ---      =20
                            a web developer.                            =20

--eNjIDde0W37E3OQP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFPz7IoIKyzvlFcI40RAsKzAJ4/jgahtZMWcP/k+tCu69e6teBdwwCglZHL
WdsAtjk39QVwBYRSxoRxUSk=
=MK8n
-----END PGP SIGNATURE-----

--eNjIDde0W37E3OQP--
