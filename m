Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:33788 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbaEEEgY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 May 2014 00:36:24 -0400
Date: Mon, 5 May 2014 10:36:17 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: Using mount -o bind vs mount -o subvol=vol
Message-ID: <20140505103617.0e66f5a9@natsu>
In-Reply-To: <53670FEA.8050806@swiftspirit.co.za>
References: <20140504004732.GE9061@merlins.org>
	<5365E74B.6020805@swiftspirit.co.za>
	<20140505005644.GB10159@merlins.org>
	<53670FEA.8050806@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TUa2QIiCk+9PwLryRpzCZY+"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/TUa2QIiCk+9PwLryRpzCZY+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 05 May 2014 06:13:30 +0200
Brendan Hide <brendan@swiftspirit.co.za> wrote:

> >> 1) There will be a *very* small performance penalty (negligible, reall=
y)
> > Oh, really, it's slower to mount the device directly? Not that I really
> > care, but that's unexpected.
>=20
> Um ... the penalty is if you're mounting indirectly. ;)

I feel that's on about the same scale as giving your files shorter filename=
s,
"so that they open faster". Or have you looked at the actual kernel code wi=
th
regard to how it's handled, or maybe even have any benchmarks, other than a
general thought of "it's indirect, so it probably must be slower"?

--=20
With respect,
Roman

--Sig_/TUa2QIiCk+9PwLryRpzCZY+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlNnFUEACgkQTLKSvz+PZwjUXwCeIR6YErmZURhT1K+7hsYJKDsz
2mQAn3LI4rKO3mC6FHnwB212PPubHrrR
=A2jo
-----END PGP SIGNATURE-----

--Sig_/TUa2QIiCk+9PwLryRpzCZY+--
