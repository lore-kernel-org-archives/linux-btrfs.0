Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63428 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751964AbdL1Akg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Dec 2017 19:40:36 -0500
Subject: Re: [PATCH] Btrfs: enchanse raid1/10 balance heuristic for non
 rotating devices
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
References: <20171227223931.7878-1-nefelim4ag@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <55ed0f1b-8cbf-3faf-0041-8451c3747ed2@gmx.com>
Date: Thu, 28 Dec 2017 08:40:29 +0800
MIME-Version: 1.0
In-Reply-To: <20171227223931.7878-1-nefelim4ag@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uM8o4B1ET9UgJurpaci79sUOsPJXHBTs0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uM8o4B1ET9UgJurpaci79sUOsPJXHBTs0
Content-Type: multipart/mixed; boundary="Qwtx9WHN6uqHl1Ws4zB30qtoyc0f4rcWo";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <55ed0f1b-8cbf-3faf-0041-8451c3747ed2@gmx.com>
Subject: Re: [PATCH] Btrfs: enchanse raid1/10 balance heuristic for non
 rotating devices
References: <20171227223931.7878-1-nefelim4ag@gmail.com>
In-Reply-To: <20171227223931.7878-1-nefelim4ag@gmail.com>

--Qwtx9WHN6uqHl1Ws4zB30qtoyc0f4rcWo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8828=E6=97=A5 06:39, Timofey Titovets wrote:
> Currently btrfs raid1/10 balancer blance requests to mirrors,
> based on pid % num of mirrors.
>=20
> Update logic and make it understood if underline device are non rotatio=
nal.
>=20
> If one of mirrors are non rotational, then all read requests will be mo=
ved to
> non rotational device.
>=20
> If both of mirrors are non rotational, calculate sum of
> pending and in flight request for queue on that bdev and use
> device with least queue leght.
>=20
> P.S.
> Inspired by md-raid1 read balancing

Any benchmark?

It would be more persuasive.

Thanks,
Qu

>=20
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/volumes.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  1 file changed, 59 insertions(+)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9a04245003ab..98bc2433a920 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5216,13 +5216,30 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info=
 *fs_info, u64 logical, u64 len)
>  	return ret;
>  }
> =20
> +static inline int bdev_get_queue_len(struct block_device *bdev)
> +{
> +	int sum =3D 0;
> +	struct request_queue *rq =3D bdev_get_queue(bdev);
> +
> +	sum +=3D rq->nr_rqs[BLK_RW_SYNC] + rq->nr_rqs[BLK_RW_ASYNC];
> +	sum +=3D rq->in_flight[BLK_RW_SYNC] + rq->in_flight[BLK_RW_ASYNC];
> +
> +	/*
> +	 * Try prevent switch for every sneeze
> +	 * By roundup output num by 2
> +	 */
> +	return ALIGN(sum, 2);
> +}
> +
>  static int find_live_mirror(struct btrfs_fs_info *fs_info,
>  			    struct map_lookup *map, int first, int num,
>  			    int optimal, int dev_replace_is_ongoing)
>  {
>  	int i;
>  	int tolerance;
> +	struct block_device *bdev;
>  	struct btrfs_device *srcdev;
> +	bool all_bdev_nonrot =3D true;
> =20
>  	if (dev_replace_is_ongoing &&
>  	    fs_info->dev_replace.cont_reading_from_srcdev_mode =3D=3D
> @@ -5231,6 +5248,48 @@ static int find_live_mirror(struct btrfs_fs_info=
 *fs_info,
>  	else
>  		srcdev =3D NULL;
> =20
> +	/*
> +	 * Optimal expected to be pid % num
> +	 * That's generaly ok for spinning rust drives
> +	 * But if one of mirror are non rotating,
> +	 * that bdev can show better performance
> +	 *
> +	 * if one of disks are non rotating:
> +	 *  - set optimal to non rotating device
> +	 * if both disk are non rotating
> +	 *  - set optimal to bdev with least queue
> +	 * If both disks are spinning rust:
> +	 *  - leave old pid % nu,
> +	 */
> +	for (i =3D 0; i < num; i++) {
> +		bdev =3D map->stripes[i].dev->bdev;
> +		if (!bdev)
> +			continue;
> +		if (blk_queue_nonrot(bdev_get_queue(bdev)))
> +			optimal =3D i;
> +		else
> +			all_bdev_nonrot =3D false;
> +	}
> +
> +	if (all_bdev_nonrot) {
> +		int qlen;
> +		/* Forse following logic choise by init with some big number */
> +		int optimal_dev_rq_count =3D 1 << 24;
> +
> +		for (i =3D 0; i < num; i++) {
> +			bdev =3D map->stripes[i].dev->bdev;
> +			if (!bdev)
> +				continue;
> +
> +			qlen =3D bdev_get_queue_len(bdev);
> +
> +			if (qlen < optimal_dev_rq_count) {
> +				optimal =3D i;
> +				optimal_dev_rq_count =3D qlen;
> +			}
> +		}
> +	}
> +
>  	/*
>  	 * try to avoid the drive that is the source drive for a
>  	 * dev-replace procedure, only choose it if no other non-missing
>=20


--Qwtx9WHN6uqHl1Ws4zB30qtoyc0f4rcWo--

--uM8o4B1ET9UgJurpaci79sUOsPJXHBTs0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpEPX0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgC5wf/VHFxti0HBE5ppmuyAZfZsLXe
hmK3UUq07H63TAE/2POtsJnbzux93zzfjpkvp36vVQUqZdeleBTh9aEYNP/RTQuo
txo2UukraIFyLigivV6G21VkTAUD5uTgLkAGqK81j2uLeY23NSzyPGLQQytwWD84
hOOkm1SLNqFj4BZtF5euXqd7fLUV5Sd0nzHFjiBn1YEpWvO8fb6bJ8S1ybI5COzg
zTOm39tfh1fZOicVjglA2CS2u5/ZHW5VGCLSqt4MTNQ8Dtorou2SudKw7Rzlgdy1
QaqRgi+6qqBbxA0MBEUv0M2wnrOSVF7pLJZZqhlsu3SMXzpI/61yZOM/IJqYsQ==
=WQrg
-----END PGP SIGNATURE-----

--uM8o4B1ET9UgJurpaci79sUOsPJXHBTs0--
