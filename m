Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asuka.romanrm.net ([128.199.93.76]:40617 "EHLO
	asuka.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbbDPEyk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Apr 2015 00:54:40 -0400
Date: Thu, 16 Apr 2015 09:54:40 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Matt Grant <matt@mattgrant.net.nz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs-cleaner FS DoS issues
Message-ID: <20150416095440.4da97eae@natsu>
In-Reply-To: <20150416014135.6FB5841C60@mx.anathoth.net>
References: <20150416014135.6FB5841C60@mx.anathoth.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GWF=UD5kCSyuPGzol.eM3Hf"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/GWF=UD5kCSyuPGzol.eM3Hf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Apr 2015 13:41:21 +1200
Matt Grant <matt@mattgrant.net.nz> wrote:

> Hi!
>=20
> When ever I delete a large snapshot this stalls all the processes on my s=
ystem for 30 minutes plus, kernel v19.2. Btrfs-cleaner is taking 100% CPU w=
hen completely stalled. Every few minutes its say 99.8% and satall abates a=
nd=C2=A0 processes/io happen.

By any chance do you use this on SSD with TRIM enabled?

--=20
With respect,
Roman

--Sig_/GWF=UD5kCSyuPGzol.eM3Hf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUvQJEACgkQTLKSvz+PZwiPNACcChfuCFJpLU70g02wCh4eOzau
3loAn0iB90A0AJ4WqZVoPqPOUN8TldxC
=GPXc
-----END PGP SIGNATURE-----

--Sig_/GWF=UD5kCSyuPGzol.eM3Hf--
