Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49994 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaCILyQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Mar 2014 07:54:16 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: Massive BTRFS performance degradation
Date: Sun, 09 Mar 2014 12:54:08 +0100
Message-ID: <2387882.QV4t13Wz0H@merkaba>
In-Reply-To: <20140309113350.GH6318@carfax.org.uk>
References: <531C1CC4.701@gmail.com> <1756989.4ep0Vdupld@tethys> <20140309113350.GH6318@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8719138.rLpX7DvT87"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart8719138.rLpX7DvT87
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Sonntag, 9. M=E4rz 2014, 11:33:50 schrieb Hugo Mills:
> On Sun, Mar 09, 2014 at 11:23:29AM +0100, Sw=E2mi Petaramesh wrote:
> > Le dimanche 9 mars 2014 11:01:17 vous avez =E9crit :
> > > This ThinkPad T520 has been with BTRFS since installation of the =
Debian
> > > sid system on it with Kernel 2.6.39 or even 2.6.38 (where Sandybr=
idge
> > > graphics didn=B4t work so well as today yet).
> > >=20
> > > So that much to any FUD about BTRFS and SSDs.
> >
> >=20
> >
> > Wow !
> >
> >=20
> >
> > Thanks for this very interesting info. Would you tell me if you use=
 any of
> > the  SSD optimisation mount options: discard, ssd or ssd_spread ?
>=20
>    I would recommend none of the three.
>=20
>    ssd should be activated automatically on any non-rotational device=
.
> ssd_spread is generally slower on modern SSDs than the ssd option.
> discard is, except on the very latest hardware, a synchronous command=

> (it's a limitation of the SATA standard), and therefore results in
> very very poor performance.

Thats exactly how I use it. I just fstrim the partitions from time to t=
ime.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart8719138.rLpX7DvT87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlMcVmYACgkQmRvqrKWZhMf5sQCfdyJ0noIfFw24N4wLUDAlujwI
Gg8AnjHDZxA7ZnsO+ThWUO1Whj9060bO
=tz99
-----END PGP SIGNATURE-----

--nextPart8719138.rLpX7DvT87--

