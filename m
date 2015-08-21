Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:58367 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbHUJWI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 05:22:08 -0400
Date: Fri, 21 Aug 2015 14:16:32 +0500
From: Roman Mamedov <rm@romanrm.net>
To: =?UTF-8?B?U3fDom1p?= Petaramesh <swami@petaramesh.org>
Cc: Karsten Heymann <karsten.heymann@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS cannot remove empry directory pretending it is not empty
Message-ID: <20150821141632.21e1d073@natsu>
In-Reply-To: <11080876.b5D4dVKWvo@zafu>
References: <2017000.AEG9PyVY17@zafu>
	<CAL017hDuuzfnPWpGthbHg+wkwinF90W8Ps-4uXY52ZJasJ42Hw@mail.gmail.com>
	<11080876.b5D4dVKWvo@zafu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/U/jO84yVGC3XIUNh4r0INjl"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/U/jO84yVGC3XIUNh4r0INjl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Aug 2015 11:15:23 +0200
Sw=C3=A2mi Petaramesh <swami@petaramesh.org> wrote:

> Le vendredi 21 ao=C3=BBt 2015 10:47:45 Karsten Heymann a =C3=A9crit :
> >=20
> > did you check with lsof that no process has an open file descriptor in
> > that directory?
>=20
> Yes, I even renamed it and rebooted the machine to be double-sure, but to=
 no=20
> avail...

And did you try the obvious, i.e. running btrfsck?

--=20
With respect,
Roman

--Sig_/U/jO84yVGC3XIUNh4r0INjl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlXW7HAACgkQTLKSvz+PZwjRxQCdGuhCPTt9tEpion/t6fQju7HJ
zkwAnjEaIPs//QWQk2mw8LefNMkKFXoM
=CcSG
-----END PGP SIGNATURE-----

--Sig_/U/jO84yVGC3XIUNh4r0INjl--
