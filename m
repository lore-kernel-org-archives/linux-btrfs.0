Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:49574 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759011AbcAUJCN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 04:02:13 -0500
Date: Thu, 21 Jan 2016 14:02:09 +0500
From: Roman Mamedov <rm@romanrm.net>
To: fdmanana@gmail.com
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel 4.4.0 intermittent ENOSPC during heavy data write and
 concurrent snapshotting
Message-ID: <20160121140209.28d0072e@natsu>
In-Reply-To: <CAL3q7H6y3-8PhZOiBVxszZV5DN-c81EsQ_NjMaHmgGmJrc9aQA@mail.gmail.com>
References: <20160120202909.4a804707@natsu>
 <CAL3q7H6y3-8PhZOiBVxszZV5DN-c81EsQ_NjMaHmgGmJrc9aQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/r866T.bF7i+sSAIo8xSrn=7"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/r866T.bF7i+sSAIo8xSrn=7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, 20 Jan 2016 20:46:39 +0000
Filipe Manana <fdmanana@gmail.com> wrote:

> Try this: https://patchwork.kernel.org/patch/7967161/
>=20
> (It's not a regression in 4.4 however, it has been there for a long time)

I can't reproduce the problem on 4.3.3 or 3.18.22. On 4.4.0 it occurs almost
instantly (faster if not including 'sync' into the dd cycle).

The patch seems to fix it for 4.4.0, thanks.

--=20
With respect,
Roman

--Sig_/r866T.bF7i+sSAIo8xSrn=7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlagnpEACgkQTLKSvz+PZwhr3ACaAri7mN8UUF8ICuD0uDvHUUBS
ePEAnRKRWky74HTZpG8K8mtCb+UJTjWH
=a2q9
-----END PGP SIGNATURE-----

--Sig_/r866T.bF7i+sSAIo8xSrn=7--
