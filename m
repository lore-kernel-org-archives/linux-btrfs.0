Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:35622 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab3CTTYR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 15:24:17 -0400
Date: Thu, 21 Mar 2013 01:24:14 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Chris Murphy <lists@colorremedies.com>
Cc: =?UTF-8?B?RnLDqWTDqXJpYw==?= COIFFIER <frederic.coiffier@free.fr>,
        Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
Subject: Re: How to recover uncorrectable errors ?
Message-ID: <20130321012414.3b232660@natsu>
In-Reply-To: <4B672F76-FAF9-4198-988D-440B6326A275@colorremedies.com>
References: <6033676.gK0GbPgrpE@athlonxp>
	<201303161916.55185.Martin@lichtvoll.de>
	<3160822.Hx5D6eTo7L@athlonxp>
	<4B672F76-FAF9-4198-988D-440B6326A275@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QzEzzY90GHpltgMAU7wZwGT"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/QzEzzY90GHpltgMAU7wZwGT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Mar 2013 12:19:18 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> > 195 Hardware_ECC_Recovered  0x001a   057   055   000    Old_age   Alway=
s       -       63508940

> With such high ECC recovered events, I suspect SDC.=20

If it's a Seagate drive, this is absolutely normal.
All Seagate drives have a high value in SMART Hardware_ECC_Recovered.

--=20
With respect,
Roman

--Sig_/QzEzzY90GHpltgMAU7wZwGT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFKDN4ACgkQTLKSvz+PZwgI8gCfXsSd7Aj+QjNeLLLpPea2TiXw
6QEAoIVI1VMCoJ2nCkN+YwWGNWbrSa0O
=QgZz
-----END PGP SIGNATURE-----

--Sig_/QzEzzY90GHpltgMAU7wZwGT--
