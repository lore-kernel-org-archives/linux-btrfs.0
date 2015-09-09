Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:55472 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbbIIR1Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 13:27:16 -0400
Date: Wed, 9 Sep 2015 22:27:13 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Jon Keane <jkeane@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Unmountable btrfs after power failure
Message-ID: <20150909222713.60d7d9de@natsu>
In-Reply-To: <20150909171951.GQ23944@carfax.org.uk>
References: <CAE+qdJbDCaBpiw2JQdOVPk0qmR4NE3NZV+mF8-cXk2y697a3Hg@mail.gmail.com>
	<20150909171951.GQ23944@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6ciVqM4s20Eh=1T=tAk+Dw7"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/6ciVqM4s20Eh=1T=tAk+Dw7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 9 Sep 2015 17:19:51 +0000
Hugo Mills <hugo@carfax.org.uk> wrote:

>    The bug you've hit is almost certainly fixed in more recent
> kernels. I can't recommend stongly enough that you upgrade it (or
> contact your vendor's support department to find out how they will
> support your use of btrfs on a kernel that old). 3.19 is about the
> earliest kernel I'd feel happy about using at this point.

3.19 is EOL and is not featured on https://www.kernel.org/ anymore.

I hope 3.18 is also good enough, for those of us who prefer to stay on a
"longterm" kernel and not jump every time onto a new series only to find out
that it's in fact destined to go into the EOL trashcan. (There's a certain
amount of tinkering with the .config required each time when switching
releases, and I'd like to minimize that).

--=20
With respect,
Roman

--Sig_/6ciVqM4s20Eh=1T=tAk+Dw7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlXwa/EACgkQTLKSvz+PZwhjFwCfZccxB5lJY/J3DXKuZPukxgsB
QvIAmwd7al+65YCS7fjUySS6rsmuBBxd
=m5wa
-----END PGP SIGNATURE-----

--Sig_/6ciVqM4s20Eh=1T=tAk+Dw7--
