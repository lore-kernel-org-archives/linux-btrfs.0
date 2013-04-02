Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:38097 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760683Ab3DBJhu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Apr 2013 05:37:50 -0400
Received: from natsu (unknown [IPv6:fd39::1e6f:65ff:fea1:3ea6])
	by len.romanrm.net (Postfix) with ESMTPS id D0DC3203D1
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Apr 2013 09:37:46 +0000 (UTC)
Date: Tue, 2 Apr 2013 15:37:44 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: <linux-btrfs@vger.kernel.org>
Subject: Re: Still getting a lot of -28 (ENOSPC?) errors during balance
Message-ID: <20130402153744.679714b0@natsu>
In-Reply-To: <20130402140452.2b71794f@natsu>
References: <20130402140452.2b71794f@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XIaN_Gns8Alev5xHkovUkW/"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/XIaN_Gns8Alev5xHkovUkW/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Apr 2013 14:04:52 +0600
Roman Mamedov <rm@romanrm.ru> wrote:

> With kernel 3.7.10 patched with "Btrfs: limit the global reserve to 512mb=
".
> (the problem was occuring also without this patch, but seemed to be even =
worse).
>=20
> At the start of balance:
>=20
> Data: total=3D31.85GB, used=3D9.96GB
> System: total=3D4.00MB, used=3D16.00KB
> Metadata: total=3D1.01GB, used=3D696.17MB
>=20
> "btrfs balance start -musage=3D5 -dusage=3D5" is going on for about 50 mi=
nutes
>=20
> Current situation:
>=20
> Balance on '/mnt/r1/' is running
> 1 out of about 2 chunks balanced (20 considered),  50% left
>=20
> Data: total=3D30.85GB, used=3D10.04GB
> System: total=3D4.00MB, used=3D16.00KB
> Metadata: total=3D1.01GB, used=3D851.69MB

About 2 hours 10 minutes into the balance, it was still going, with:

Data: total=3D30.85GB, used=3D10.06GB
System: total=3D4.00MB, used=3D16.00KB
Metadata: total=3D1.01GB, used=3D909.16MB

Stream of -28 errors continues non-stop in dmesg;

At ~2hr20min looks like it decided to allocate some more space for metadata:

Data: total=3D30.85GB, used=3D10.01GB
System: total=3D4.00MB, used=3D16.00KB
Metadata: total=3D2.01GB, used=3D748.56MB

And shortly after (~ 2hr25min) it was done. After the balance:

Data: total=3D29.85GB, used=3D10.01GB
System: total=3D4.00MB, used=3D16.00KB
Metadata: total=3D2.01GB, used=3D748.27MB

--=20
With respect,
Roman

--Sig_/XIaN_Gns8Alev5xHkovUkW/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFapugACgkQTLKSvz+PZwi9dwCgjYjtBGSn940BfU7NTd4Eq3FM
9fwAn0/ijpYvQVqmsAa6PifG8YPzIVxK
=GHNX
-----END PGP SIGNATURE-----

--Sig_/XIaN_Gns8Alev5xHkovUkW/--
