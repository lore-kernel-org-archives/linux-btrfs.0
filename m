Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from efeu.mur.at ([89.106.208.66]:40029 "EHLO efeu.mur.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbaJCSKJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Oct 2014 14:10:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by efeu.mur.at (Postfix) with ESMTP id 9AD0E2232F
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Oct 2014 20:10:07 +0200 (CEST)
Received: from efeu.mur.at ([127.0.0.1])
	by localhost (efeu.mur.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id J5lF9PLf79oe for <linux-btrfs@vger.kernel.org>;
	Fri,  3 Oct 2014 20:10:07 +0200 (CEST)
Received: from [192.168.2.2] (85-126-169-193.work.xdsl-line.inode.at [85.126.169.193])
	by efeu.mur.at (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Oct 2014 20:10:07 +0200 (CEST)
Message-ID: <542EE67E.2010202@mur.at>
Date: Fri, 03 Oct 2014 20:10:06 +0200
From: =?UTF-8?B?Sm9naSBIb2Ztw7xsbGVy?= <jogi@mur.at>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs 3.16.2 does not recognize subvolumes correctly
References: <542D100F.9050502@mur.at> <542E7D21.2030905@mur.at> <20141003165332.GA24593@mew.dhcp4.washington.edu>
In-Reply-To: <20141003165332.GA24593@mew.dhcp4.washington.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="shDQgugdag536dOQo3FQ3WMmVAWARceNU"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--shDQgugdag536dOQo3FQ3WMmVAWARceNU
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Omar,

Am 2014-10-03 um 18:53 schrieb Omar Sandoval:

> There was a similar issue in btrfs-progs 3.16 that was fixed in 3.16.1 =
by this
> commit:
> https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/comm=
it/?id=3D6a47725a6fb8a463dd60611800222c7297195588
>=20
> I'd do a quick `btrfs --version` just to make sure you're running the v=
ersion
> you think you are. Otherwise, the output of `mount` might shed some lig=
ht on why
> you're getting this.

Turns out I am still using btrfs-progs 3.16 :(  Don't know where I came
across the version 3.16.2 that I put in the subject.  Gee, embarrassing.
 Sorry for the noise.  Hope 3.16.1 will be available in Debian testing so=
on.

Regards,
--=20
j.hofm=C3=BCller

Ger=C3=BCchtegenerator		               http://plagi.at/geruecht


--shDQgugdag536dOQo3FQ3WMmVAWARceNU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlQu5n4ACgkQkaXhaapqItmslwEA7ndpBf+5pEihRfTbsqBD5Rz9
TfZnjvirHp444tIjS+oA/2KELsTnhRAafdb61cypJ/EF3JGV2qJ0u53AuDJ8kPLi
=IlPM
-----END PGP SIGNATURE-----

--shDQgugdag536dOQo3FQ3WMmVAWARceNU--
