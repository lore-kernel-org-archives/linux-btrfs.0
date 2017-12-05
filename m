Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:56697 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753116AbdLEJfz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 04:35:55 -0500
Subject: Re: [PATCH 7/7] btrfs-progs: Fix super-recovery
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-8-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a7017b16-7f73-fe8c-310e-8bcfc4256c2c@gmx.com>
Date: Tue, 5 Dec 2017 17:35:15 +0800
MIME-Version: 1.0
In-Reply-To: <1512463189-24724-8-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="g6ce3SdlIKaa78aERV0J81pWAlPovDUaB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--g6ce3SdlIKaa78aERV0J81pWAlPovDUaB
Content-Type: multipart/mixed; boundary="d1Jsvfe234gLdLDUOQ1HSEN4nGB9pvocI";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <a7017b16-7f73-fe8c-310e-8bcfc4256c2c@gmx.com>
Subject: Re: [PATCH 7/7] btrfs-progs: Fix super-recovery
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-8-git-send-email-nborisov@suse.com>

--d1Jsvfe234gLdLDUOQ1HSEN4nGB9pvocI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 16:39, Nikolay Borisov wrote:
> Commit 3296d058b7ce ("btrfs-progs: super-recover: Reuse
>  btrfs_read_dev_super function")

Oh my fault.

> changed the logic when a superblock
> is added to the bad block list to depend on -EIO. However currently
> btrfs_read_dev_super doesn't return -EIO when the fist super block
> is broken. Instead it returns -1. This causes the super-recovery
> logic to miss the fact that the first super block is completely broken.=

>=20
> Fix this by considering any error code from btrfs_read_dev_super other
> than -ENOENT to mean that the super block is corrupted. -ENOENT
> means that the superblock copy is not part of the fs i.e. it's smaller
> than the offset of the block. This can only occur for the 2nd copy at
> 256gb mark.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>  super-recover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/super-recover.c b/super-recover.c
> index e12513100f17..880fd7712546 100644
> --- a/super-recover.c
> +++ b/super-recover.c
> @@ -136,7 +136,7 @@ read_dev_supers(char *filename, struct btrfs_recove=
r_superblock *recover)
>  			max_gen =3D btrfs_super_generation(sb);
>  			if (max_gen > recover->max_generation)
>  				recover->max_generation =3D max_gen;
> -		} else if (ret =3D=3D -EIO){
> +		} else if (ret !=3D -ENOENT){
>  			/*
>  			 * Skip superblock which doesn't exist, only adds
>  			 * really corrupted superblock
>=20


--d1Jsvfe234gLdLDUOQ1HSEN4nGB9pvocI--

--g6ce3SdlIKaa78aERV0J81pWAlPovDUaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlomaFMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh0nQf+OacCf/6TwhlPhUWqDrl8hFnW
7m8Cx1oYzYKg2n4XnyDP7eRYRYm8RNIxnIIJqcZZhsFB3RKztln5dAZUPBWeDTl8
BJEgiVTokPglNlaPPM3NbcNEGZMg8Ya0yJhLpnn3Ol40QmTYMh+DONhsWIH/YyVK
f2FwCKpGMLajGXrN/L/IUdK//f6W7TVxaR5mVTo3HwK7o8g8qvKG0iL8md48x5jd
6LtEAQKmsW6lwSNYiCEj0Kzjotdfa1fJWVe2FZrGANbt/ArYAnBwOXdpVkHcf+q4
mqzCmscYG2XbfksbI3amNX3WiZxvEsw4qMvqdeSTlgt3GSNbzqCuzoDXX8V/VQ==
=Ewwa
-----END PGP SIGNATURE-----

--g6ce3SdlIKaa78aERV0J81pWAlPovDUaB--
