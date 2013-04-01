Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:49749 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758434Ab3DAPQV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Apr 2013 11:16:21 -0400
Date: Mon, 1 Apr 2013 21:16:16 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS error in __btrfs_inc_extent_ref:1935: Object already
 exists
Message-ID: <20130401211616.3fedecd0@natsu>
In-Reply-To: <20130401133110.GH1876@localhost.localdomain>
References: <20130401041540.4b8a4ab3@natsu>
	<20130401043605.2eb250a7@natsu>
	<20130401141207.533886a2@natsu>
	<20130401133110.GH1876@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P9BOXst/ejM8oqmtXF.qTUx"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/P9BOXst/ejM8oqmtXF.qTUx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Apr 2013 09:31:10 -0400
Josef Bacik <jbacik@fusionio.com> wrote:

> Can you capture an image of these broken file systems the next time it ha=
ppens?
> You'll need to clone the progs here
>=20
> git://github.com/josefbacik/btrfs-progs.git
>=20
> and build and then run
>=20
> btrfs-image -w /dev/whatever blah.img
>=20
> and then upload blah.img up somewhere I can pull it down.  You can use th=
e -t
> and -c options too, but the -w is the most important since you have exten=
t tree
> corruption.  Thanks,

Hello,

I have sent the link privately to your E-Mail.

--=20
With respect,
Roman

--Sig_/P9BOXst/ejM8oqmtXF.qTUx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFZpMAACgkQTLKSvz+PZwi4CQCfYrU/F3y0m6amOoYqzU4cq52F
fDkAnAxOhOmzgE76I5qIfe7n2ZdR16+T
=3Q60
-----END PGP SIGNATURE-----

--Sig_/P9BOXst/ejM8oqmtXF.qTUx--
