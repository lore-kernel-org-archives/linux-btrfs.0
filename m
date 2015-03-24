Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asuka.romanrm.net ([128.199.93.76]:57068 "EHLO
	asuka.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbbCXXbL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 19:31:11 -0400
Date: Wed, 25 Mar 2015 04:31:13 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Kline, Matthew" <matthew.kline@flukenetworks.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs balance fails with no space errors (despite having
 plenty)
Message-ID: <20150325043113.35bd9078@natsu>
In-Reply-To: <E8C63C11EA3FB04DBDFEDECEFD927FD1140C1E65@US-EVT-EXM04-P.global.tektronix.net>
References: <E8C63C11EA3FB04DBDFEDECEFD927FD1140C1E31@US-EVT-EXM04-P.global.tektronix.net>
	<20150325040321.361abf2f@natsu>
	<E8C63C11EA3FB04DBDFEDECEFD927FD1140C1E65@US-EVT-EXM04-P.global.tektronix.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6tTqjpg_a/iiWbF1J3yLQxr"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/6tTqjpg_a/iiWbF1J3yLQxr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Mar 2015 23:09:47 +0000
"Kline, Matthew" <matthew.kline@flukenetworks.com> wrote:

> Data, single: total=3D44.00GiB, used=3D43.37GiB
> System, single: total=3D32.00MiB, used=3D12.00KiB
> Metadata, single: total=3D2.00GiB, used=3D876.84MiB
> GlobalReserve, single: total=3D296.00MiB, used=3D0.00B
>=20
> Total partition size is 322 GB, as given by `parted -l` (I misspoke in th=
e last email - the drive is only 14% full)

Okay that's some different issue then, doesn't look like what I had, where =
on
a 9 TB FS after conversion I got 2 TB of metadata (with 1.2TB free space).

--=20
With respect,
Roman

--Sig_/6tTqjpg_a/iiWbF1J3yLQxr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUR88EACgkQTLKSvz+PZwgRBACeNp/oSTjiRSfPTXWjglPjY7gw
ZucAnRvv74SHhFqQ6jaDAQTEK0rPfPA/
=7KND
-----END PGP SIGNATURE-----

--Sig_/6tTqjpg_a/iiWbF1J3yLQxr--
