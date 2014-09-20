Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52241 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbaITIX7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 04:23:59 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Holger =?ISO-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Performance Issues
Date: Sat, 20 Sep 2014 10:23:52 +0200
Message-ID: <1678306.dObPo7E7s7@fb07-iapwap2>
In-Reply-To: <pan.2014.09.19.13.51.22@googlemail.com>
References: <1411129114.1811.7.camel@zarniwoop.blob> <pan.2014.09.19.13.51.22@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart10776813.lzMSiVhkQ7"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart10776813.lzMSiVhkQ7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Am Freitag, 19. September 2014, 13:51:22 schrieb Holger Hoffst=C3=A4tte=
:
>=20
> On Fri, 19 Sep 2014 13:18:34 +0100, Rob Spanton wrote:
>=20
> > I have a particularly uncomplicated setup (a desktop PC with a hard=

> > disk) and I'm seeing particularly slow performance from btrfs.  A `=
git
> > status` in the linux source tree takes about 46 seconds after dropp=
ing
> > caches, whereas on other machines using ext4 this takes about 13s. =
 My
> > mail client (evolution) also seems to perform particularly poorly o=
n
> > this setup, and my hunch is that it's spending a lot of time waitin=
g on
> > the filesystem.
>=20
> This is - unfortunately - a particular btrfs oddity/characteristic/fl=
aw,
> whatever you want to call it. git relies a lot on fast stat() calls,
> and those seem to be particularly slow with btrfs esp. on rotational
> media. I have the same problem with rsync on a freshly mounted volume=
;
> it gets fast (quite so!) after the first run.

my favorite benchmark is "ls -l /usr/bin":

ext4:     0.934s
btrfs:   21.814s

also mounting large partitons (several 100Gs) takes lot of time on btrf=
s.
Better to defer it during boot using e.g. "noauto,x-systemd.automount".=


Marc

--nextPart10776813.lzMSiVhkQ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJUHTmYAAoJEKyeR39HFBtoVB4H/R1fL37opgSqmGN8jsM7Kmns
dYtbWsYfFS8kDUXNpyRX/e/zxIyVrDWhCiakPFlgFgOj56UCDemhbujUgk9huh4N
rLutQppfw4TDqVik0Ae76hcm4RT8NBcG3VdA2zdJrre40A8K9V6n7UAFD15xXMKl
SwsGAhv/02zSvnpFBWnCGKTYVc+1A9ydbqgddwiOgyyXhRqiGR20b+RilVVh8ecm
qh8GofB+a7sXgeMSVFtbeqZHVgWkAsL/xrCkcBB8cb/kmht5U3OqnArb77QJqSVl
RlzK31u1InKKZbynwv/K4b6JobI9Jo0d29bxumFuMIP0fkHTQaXeXZ0mglHQphw=
=2n0B
-----END PGP SIGNATURE-----

--nextPart10776813.lzMSiVhkQ7--

