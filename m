Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49227 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbaJ0BY3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Oct 2014 21:24:29 -0400
Received: from marcec.fritz.box ([93.181.44.4]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0LvlWS-1Y9ztv1TZM-017Y12 for
 <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 02:24:27 +0100
Date: Mon, 27 Oct 2014 02:24:15 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Poll: time to switch skinny-metadata on by default?
Message-ID: <20141027022415.14940745@marcec.fritz.box>
In-Reply-To: <CF7BFF69-89E5-44EE-8CC3-E306531B88FE@colorremedies.com>
References: <20141016113337.GC22943@twin.jikos.cz>
	<20141020163403.GW22943@twin.jikos.cz>
	<20141025142458.5d96970b@marcec>
	<64867638-EADF-4258-ACD7-BC33014B3DA9@colorremedies.com>
	<CF7BFF69-89E5-44EE-8CC3-E306531B88FE@colorremedies.com>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/52l8thtaJDpcwiXFXF9gq9X"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/52l8thtaJDpcwiXFXF9gq9X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Sat, 25 Oct 2014 14:35:33 -0600
schrieb Chris Murphy <lists@colorremedies.com>:

>=20
> On Oct 25, 2014, at 2:33 PM, Chris Murphy <lists@colorremedies.com> wrote:
>=20
> >=20
> > On Oct 25, 2014, at 6:24 AM, Marc Joliet <marcec@gmx.de> wrote:
> >>=20
> >> First of all: does grub2 support booting from a btrfs file system with
> >> skinny-metadata, or is it irrelevant?
> >=20
> > Seems plausible if older kernels don't understand skinny-metadata, that=
 GRUB2 won't either. So I just tested it with grub2-2.02-0.8.fc21 and it wo=
rks. I'm surprised, actually.
>=20
> I don't understand the nature of the incompatibility with older kernels. =
Can they not mount a Btrfs volume even as ro? If so then I'd expect GRUB to=
 have a problem, so I'm going to guess that maybe a 3.9 or older kernel cou=
ld ro mount a Btrfs volume with skinny extents and the incompatibility is w=
riting.

That sounds plausible, though I hope for a definitive answer. (FWIW, I
originally asked because I couldn't find any commits to grub2 related to sk=
inny
metadata; the updates to the btrfs driver were fairly sparse.)

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/52l8thtaJDpcwiXFXF9gq9X
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUTZ7JAAoJEL/Q5oYsiHj0rH0P/13HSDQzEYRCkWWEyxaeQT3a
hUvM3gTiP8T0qHcYWJZgZgwTKDHk3W0xU9tXiV7VjnkU7mTFbpyRhT9ORv2Aa+tx
QMsBJT05iKRU7ErjxFsu3jF3Wegn7engem87IaPsEOhm5T/VrtozVfx2cGVCMaw5
tjr3QEYU97vLhwMf+FsMvVRA2r5xbehPsUwv5q3y/EAMVGYGnwmoMQqt06Pwd33f
hKxbqij/E/bi2at3m0QOIMiiO0gYsbx97nWeHHioH1XonNjjCUILnOPWcfTVwFPL
VihhpS82BAD6PDQaoTOVNFhelgK2EJOvZXzEL/lZy4WLhEeGqQqFhppz32llFpZ1
GPaZbpcJ9nEoMjP+weTga8pBDymaac+tgIBL8wkCuFWIh58DpaHYuxdBjVahWtIx
pxISo0jvzZKS5ImZQO3Ml3Jy1I4W87pB5+pRCY364qCz1QlCO1xr442zI8C3oCBY
fy3wtGhlO1KT58RDrNBr0UQ2sTKfLyqaNQXrOwg2mDbshN8EwwJvFyqNTX3Rsws9
7dAcVtn1xJagnKLHae3dCchFqPSIXGJDHYNCDzLlXvp5LV9UxsPbugv209g+wwoC
H716u278rMHET2hMpbX6mHe25RrnA7VCT2aGGRNbHQkGeGKM78uqEyw13K7uh7c8
Z9SGjE4ACpAyBZaR3Qx1
=faEf
-----END PGP SIGNATURE-----

--Sig_/52l8thtaJDpcwiXFXF9gq9X--
