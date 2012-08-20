Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:49584 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab2HTRJN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Aug 2012 13:09:13 -0400
Date: Mon, 20 Aug 2012 23:09:10 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Curtis Jones <curtis.jones@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs and mdadm raid 6
Message-ID: <20120820230910.42106143@natsu>
In-Reply-To: <8AE790DA-04B5-4407-A5FE-D0AC4560B415@gmail.com>
References: <8AE790DA-04B5-4407-A5FE-D0AC4560B415@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XXcE_/5TOR_6do=.CL_LaLU"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/XXcE_/5TOR_6do=.CL_LaLU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Aug 2012 12:22:31 -0400
Curtis Jones <curtis.jones@gmail.com> wrote:

> 	4. any other caveats I might want to consider?

One more thing: if you do not fancy waiting for days/weeks for btrfs-convert
to checksum all your existing data, you might want to use
=20
  btrfs-convert -d

so that only newly-written data will be checksummed.


--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/XXcE_/5TOR_6do=.CL_LaLU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAybzYACgkQTLKSvz+PZwimQACeOx/R0HmrZKI6W8ehYdy2Xs75
/SAAn1HIDTIUXEmrTXMUylxMZvXzV9nI
=bdUl
-----END PGP SIGNATURE-----

--Sig_/XXcE_/5TOR_6do=.CL_LaLU--
