Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36856 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2FGBxw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2012 21:53:52 -0400
Date: Thu, 7 Jun 2012 02:53:49 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Sonu <sonuansuja@yahoo.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: locating a func in btrfs-progs
Message-ID: <20120607015349.GB11283@carfax.org.uk>
References: <1339033093.37771.YahooMailNeo@web190103.mail.sg3.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
In-Reply-To: <1339033093.37771.YahooMailNeo@web190103.mail.sg3.yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 07, 2012 at 09:38:13AM +0800, Sonu wrote:
>=20
>=20
> Hi=20
>=20
> =A0 Any clues on where I can find the function=A0 'btrfs_header_level' in=
 btrfs-progs ?=A0=20

   It's a getter/setter pair. See line 1555 of ctree.h.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Don't worry, he's not drunk. He's like that all the time. ---   =20

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP0AmtIKyzvlFcI40RArdSAJwIamio2S5JtaYAH3a6vWBYUMWhOQCfZl0c
QrOx3Fa3tYqye8DD+xA+TlY=
=XOQ/
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
