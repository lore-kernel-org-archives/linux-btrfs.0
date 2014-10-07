Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34077 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaJGJ0R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 05:26:17 -0400
Date: Tue, 7 Oct 2014 10:26:12 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Juan Orti Alcaine <juan.orti@miceliux.com>, linux-btrfs@vger.kernel.org
Subject: Re: Identify mounted subvolume
Message-ID: <20141007092611.GF11870@carfax.org.uk>
References: <c7a9551462105e36f8ac5f874d19e9c2@miceliux.com>
 <20141007090608.GE11870@carfax.org.uk>
 <5433AFFB.20101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K/NRh952CO+2tg14"
In-Reply-To: <5433AFFB.20101@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--K/NRh952CO+2tg14
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2014 at 05:18:51PM +0800, Qu Wenruo wrote:
>=20
> -------- Original Message --------
> Subject: Re: Identify mounted subvolume
> From: Hugo Mills <hugo@carfax.org.uk>
> To: Juan Orti Alcaine <juan.orti@miceliux.com>
> Date: 2014=E5=B9=B410=E6=9C=8807=E6=97=A5 17:06
> >On Tue, Oct 07, 2014 at 10:47:56AM +0200, Juan Orti Alcaine wrote:
> >>I cannot find the answer to this one. How can I determine which subvolu=
me I
> >>have mounted in a certain path? I'm looking through /sys but no clue.
> >    Rumour has it that /proc/self/mountinfo is meant to have the
> >information, but I've just checked, and it doesn't seem to have the
> >subvol in it on my server (3.16.2).
> >
> >    Hugo.
> >
> This accepted patch will make /proc/self/mountinfo to have all the info.
> https://patchwork.kernel.org/patch/4593831/
>=20
> But I didn't see it in 3.17 kernel or integration branch, maybe next merge
> window?
>=20
> Even without the patch, when mounting using '-o subvol=3D' mount option w=
ill
> also fill the /proc/self/mountinfo,
> using 3.16.4.
> ---
> 149 19 0:39 / /mnt/btrfs rw,relatime shared:101 - btrfs /dev/sda6
> rw,space_cache
> 153 19 0:39 */subvol1* /mnt/other rw,relatime shared:104 - btrfs /dev/sda6
> rw,space_cache
> ---

   Aaaah, I see. I was just misinterpreting the information.

> On the other hand, without the patch and you mount with '-o subvolid=3D',=
 then
> mountinfo will not help.

   Got it. Thanks for clearing up my lack of understanding.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Unix:  For controlling fungal diseases in crops ---        =20

--K/NRh952CO+2tg14
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVDOxs1heFHXiqx3kAQI3sA//SbfALP/mv1MPOShsed5D2w4EnJUD5Xhr
bVEbSJPdUt9xzcm9OfPw/hhDGm5T+ZawKDeF1j6NGHO1ZZnB+9Mr92FcA1IblRua
RA/S54MnnJM9LyfspBvnMQZ3t0eSY1zeLiHERMBfVS5+wYbdIK6SD8WNZO/A9Nwk
h9QuaA/N/6IMFpgOG66/vgl2DAa5pqNIXMctG9+4JzMznz/HAql9LIx8awD1tQZN
mTIEJUcQ6bFkzZzG1Z6vaoXhraK8bO/pC2oVq+R7rgtswE+CZTxyhlPPjUEarFwx
i3Her2M/W5i+6vtx2iydMwdYo3jjGv9PwjeP6tzaWSq7nDWUYpbvEGfSs/ISspD6
yq76PdjLTcyotwMpoWucYOoFqyXlmz9poXj68vObNprNDFw8CzwB+N3PYR5hawOT
7qiuF3EKdFYlNR61f/7SXl1X4WTUsNhWRzqMA+dVd2DaKoGlN9CZW6kiL/UJ/kgV
gzfOgVZpwkBnWiHo6JHs1aZvstP0C36bjo768UaR3Sinpes+xudoGB3eeAIROYwq
CgWvhnoHyUn44CfNespS1sB7oUjO/qodbqpEozs9Fzfsrn5711HgUpDC2x0fuHiA
f1FUulJZp4UTjyU3KEkKSNW2NB71pGgkrxkrqJ+SgG2PFhVNiYBISsH/yr8V/XcD
QhKHTFAkghU=
=I3Pq
-----END PGP SIGNATURE-----

--K/NRh952CO+2tg14--
