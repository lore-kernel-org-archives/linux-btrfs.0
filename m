Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:53686 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbcBHLYN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Feb 2016 06:24:13 -0500
Date: Mon, 8 Feb 2016 16:24:10 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 4.4.0 - no space left with >1.7 TB free space left
Message-ID: <20160208162410.58cb2b4a@natsu>
In-Reply-To: <0c19f800da3013f22f2ab0d77d5a9efb@admin.virtall.com>
References: <0c19f800da3013f22f2ab0d77d5a9efb@admin.virtall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5ZAoMkpj=EYtFrZHSESR/+b"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/5ZAoMkpj=EYtFrZHSESR/+b
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 08 Feb 2016 18:22:34 +0900
Tomasz Chmielewski <tch@virtall.com> wrote:

> Linux 4.4.0 - btrfs is mainly used to host lots of test containers,=20
> often snapshots, and at times, there is heavy IO in many of them for=20
> extended periods of time. btrfs is on HDDs.
>=20
>=20
> Every few days I'm getting "no space left" in a container running mongo=20
> 3.2.1 database. Interestingly, haven't seen this issue in containers=20
> with MySQL. All databases have chattr +C set on their directories.

Hello,

Do you snapshot the parent subvolume which holds the databases? Can you
correlate that perhaps ENOSPC occurs at the time of snapshotting? If yes, t=
hen
you should try the patch https://patchwork.kernel.org/patch/7967161/

(Too bad this was not included into 4.4.1.)

--=20
With respect,
Roman

--Sig_/5ZAoMkpj=EYtFrZHSESR/+b
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAla4etoACgkQTLKSvz+PZwitWACdFq942EmVkH0EyPHCN5g1x3eO
4KAAoIEs2R2LBHtaY27yC8lDZR3P6m1t
=FJZr
-----END PGP SIGNATURE-----

--Sig_/5ZAoMkpj=EYtFrZHSESR/+b--
