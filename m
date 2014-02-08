Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:50766 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaBHWK4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 17:10:56 -0500
Date: Sun, 9 Feb 2014 04:10:50 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
Message-ID: <20140209041050.529ff6f9@natsu>
In-Reply-To: <cikisa-qf7.ln1@hurikhan77.spdns.de>
References: <20140206021516.304732cd@natsu>
	<52F3EED4.7030603@fb.com>
	<agsfsa-mks.ln1@hurikhan77.spdns.de>
	<20140208173310.1f90af3b@natsu>
	<20140208114634.GH6490@carfax.org.uk>
	<cikisa-qf7.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/l7JjyZSKu+QwbTJwDnH=SRJ"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/l7JjyZSKu+QwbTJwDnH=SRJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 08 Feb 2014 22:35:40 +0100
Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:

> Imagine the future: Btrfs supports different RAID levels per subvolume. W=
e=20
> need to figure out where to place a new subvolume. I need raw numbers for=
=20
> it. Df won't tell me that now. Things become very difficult now.

If you need to perform a btrfs-specific operation, you can easily use the
btrfs-specific tools to prepare for it, specifically use "btrfs fi df" which
could give provide every imaginable interpretation of free space estimate
and then some.

UNIX 'df' and the 'statfs' call on the other hand should keep the behavior
people are accustomized to rely on since 1970s.

--=20
With respect,
Roman

--Sig_/l7JjyZSKu+QwbTJwDnH=SRJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlL2q2oACgkQTLKSvz+PZwhVRQCdE8PlW1tLZVk+miXH+OtuoOhN
5KMAnixFMOkqASxnR6GxXAPy9i7kPAzC
=bvNK
-----END PGP SIGNATURE-----

--Sig_/l7JjyZSKu+QwbTJwDnH=SRJ--
