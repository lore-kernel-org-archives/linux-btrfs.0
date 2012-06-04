Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tulsa-1.icequake.net ([65.38.17.15]:50499 "EHLO
	mail.icequake.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757203Ab2FDOzI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 10:55:08 -0400
Date: Mon, 4 Jun 2012 09:54:59 -0500
From: "Ryan C. Underwood" <nemesis-lists@icequake.net>
To: Maxim Mikheev <mikhmv@gmail.com>
Cc: Arne Jansen <sensille@gmx.net>, Liu Bo <liubo2009@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Help with data recovering
Message-ID: <20120604145459.GI25227@localhost.localdomain>
Reply-To: nemesis@icequake.net
References: <4FCA189F.9050000@gmail.com>
 <4FCC0DD7.9050807@cn.fujitsu.com>
 <4FCC12BA.9070701@gmail.com>
 <4FCC1A6F.8050805@cn.fujitsu.com>
 <4FCC1AE1.8050802@gmail.com>
 <4FCC2496.6070805@cn.fujitsu.com>
 <4FCC6F44.2030503@gmx.net>
 <4FCC9C63.7000605@gmail.com>
 <4FCC9CD5.2050309@gmx.net>
 <4FCC9F6C.5090305@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Encpt1P6Mxii2VuT"
In-Reply-To: <4FCC9F6C.5090305@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Encpt1P6Mxii2VuT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


On Mon, Jun 04, 2012 at 07:43:40AM -0400, Maxim Mikheev wrote:
> alternate copy you wish to use. In the following example we ask for
> using the superblock copy #2 of /dev/sda7:
>=20
> # ./btrfsck -s 2 /dev/sd7
>=20
> -----------------------------------------
> but it gave me:
> $ sudo btrfsck -s 2 /dev/sdb
> btrfsck: invalid option -- 's'
> usage: btrfsck dev
> Btrfs Btrfs v0.19
>=20
> What can I do more?

I have found that due to an error in getopt_long() usage, btrfsck does
not accept the short-form option.  Use --super instead.

--=20
Ryan C. Underwood, <nemesis@icequake.net>

--Encpt1P6Mxii2VuT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPzMxDIonHnh+67jkRAvE5AKCzqv1crEvwzWRHOwT3797kMeSy2ACeIC8H
BIUcaiyD3976IuFxlMPnByQ=
=Vyk0
-----END PGP SIGNATURE-----

--Encpt1P6Mxii2VuT--
