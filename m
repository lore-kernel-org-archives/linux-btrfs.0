Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.229.20.24]:53864 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaAKTQV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 14:16:21 -0500
Date: Sun, 12 Jan 2014 01:16:08 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Szalma =?UTF-8?B?TMOhc3psw7M=?= <dblaci@dblaci.hu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS over LVM remounts read-only
Message-ID: <20140112011608.220a2ae3@natsu>
In-Reply-To: <52D19217.3060106@dblaci.hu>
References: <CAE8gLh=drhPtUXSbT7zHDSh7pipxuZpVhfuRQ7QOFV+HP4wHPQ@mail.gmail.com>
	<20140111150454.GV15634@carfax.org.uk>
	<CAE8gLhnd8mjRZoJCCj8ns4W6OJJXFGUiO8Ni78aYbyY2MA_Luw@mail.gmail.com>
	<52D19217.3060106@dblaci.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/L5f_bntt9uON5H6ZnEAcEmp"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/L5f_bntt9uON5H6ZnEAcEmp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 11 Jan 2014 19:48:55 +0100
Szalma L=C3=A1szl=C3=B3 <dblaci@dblaci.hu> wrote:

> 2014-01-11 18:10 keltez=C3=A9ssel, MegaBrutal =C3=ADrta:
> > How can I shrink the FS to the correct size right now, ensuring that I=
=20
> > really shrink it to the exact LV size?
>=20
> btrfs fi re 10G /dev/mapper/vg-lv
> lvresize -L 10G vg/lv

That's setting yourself up for a failure if these tools happen to disagree =
on
what "G" means (GB vs GiB). Maybe that's what happened here with the thread
starter's FS?

To be completely safe, I would recommend to resize the FS in two steps, lea=
ving
some safety margin to the partition resize first:

  btrfs fi re 8G /dev/mapper/vg-lv
  lvresize -L 10G vg/lv
  btrfs fi re max /dev/mapper/vg-lv

--=20
With respect,
Roman

--Sig_/L5f_bntt9uON5H6ZnEAcEmp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLRmHgACgkQTLKSvz+PZwgLggCgjzLwyWGg/Yab7FgVIOx1f4tq
lYYAoIfYJapIpj4sqDZ7gLSVsgPg7OW2
=NprK
-----END PGP SIGNATURE-----

--Sig_/L5f_bntt9uON5H6ZnEAcEmp--
