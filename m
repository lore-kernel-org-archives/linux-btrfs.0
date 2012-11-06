Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45721 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2KFTU5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2012 14:20:57 -0500
Date: Tue, 6 Nov 2012 19:20:54 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Bart Noordervliet <bart@noordervliet.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 00/26] Btrfs: Add device replace code
Message-ID: <20121106192054.GC29581@carfax.org.uk>
References: <cover.1352214751.git.sbehrens@giantdisaster.de>
 <CAGy7UtjR+kZoBYWaeg=-jHbJHQh4pe3Jt5cwX-rTQEBHFkQ-YQ@mail.gmail.com>
 <50995DAB.6070103@giantdisaster.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8NvZYKFJsRX2Djef"
In-Reply-To: <50995DAB.6070103@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 06, 2012 at 07:57:47PM +0100, Stefan Behrens wrote:
> On 11/06/2012 19:17, Bart Noordervliet wrote:
> >Great new feature Stefan, thanks a lot! Going to give it a spin right
> >away. While compiling I got this (probably superfluous) error that you
> >might want to prevent:
> >
> >fs/btrfs/dev-replace.c: In function =E2=80=98btrfs_dev_replace_start=E2=
=80=99:
> >fs/btrfs/dev-replace.c:344:5: warning: =E2=80=98ret=E2=80=99 may be used=
 uninitialized
> >in this function [-Wmaybe-uninitialized]
> >
> >Regards,
> >
> >Bart
> >
>=20
> Yes, this happens on 32 bit builds, not on 64 bit builds. If you
> look at the source code, the compiler is obviously wrong (or I am
> blind).
>=20
>         ret =3D btrfs_dev_replace_find_srcdev(root, args->start.srcdevid,
>                                             args->start.srcdev_name,
>                                             &src_device);
>         mutex_unlock(&fs_info->volume_mutex);
>         if (ret) {  <-- this is line 344
>=20
> But thanks for the feedback anyway!

   This usually means that somewhere in the call tree under
btrfs_dev_replace_find_srcdev(), there's a way that the function can
return without returning a value, or returning an unintialised
variable. Not quite sure why it's only on 32 bits, though.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Computer Science is not about computers,  any more than ---    =20
                     astronomy is about telescopes.                     =20

--8NvZYKFJsRX2Djef
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUJljFr9z9OVl50rAAQKdvQ/+KTO06G6whD17IItfd22At7plNIeIcznh
VKnu2/Oj7WdVxLr9Id3ysu4ypSqHze7SS7clFsn+V//eaW+pmlJ3w5SWmm/7xLrB
yYMMBjDNHFUhcefZkra246qMBqV8E40e6/JEu+1e1cLvvqmlPrpMzzD1O1E3QThQ
X7Ys+oNhAhfQCqNz4J28dNEc1C4Qj2A2wp9V4G4r2S2MKpnsUx3FC7ao7ynemlvv
XazHRNLPBFglijN+DjC3nT1ncfECLjb9W0+YUG83/EMSyNEd12UtqzORXsyzXK7r
M5SshbBiLuT6AtcKs0Ix7Q0K4v+bdCEG9R/xhf/v1TkIO7bs5MWYXd/3l4NhlnPz
vV8INkW4oBLr5+vd3apKF8BMCNc/LrFnT1OfY1sLnCD27mB3MUJ/PyDyCwUjOdV8
RoN3yg6mM4/EV2OTHSp9KZYvO8UOgVjY3HXyo96/KUQhOxUISFte6IoXWUL63Fiy
5/7fvT5WcZLHquBkWNiug81wPgphLTG9Juk3ZSP0iVgFH5hy6nt4Cnh1L+7qVG9G
jE56yqCmUC0duGRiSG5FmZTEK1HRB27bmrscoix1b4g/13s5fNHFBSCETqDuPQpb
bN/DJSwkib8TjEEQ7sD7NJRAVJOGJN11bj46KJaf2tNDXSKEJSAzd0gaP4ovAUpZ
MYNkJN7+BmA=
=Cj2c
-----END PGP SIGNATURE-----

--8NvZYKFJsRX2Djef--
