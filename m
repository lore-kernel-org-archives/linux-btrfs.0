Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57694 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751964AbdL1ApC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Dec 2017 19:45:02 -0500
Subject: Re: [PATCH] Btrfs: enchanse raid1/10 balance heuristic for non
 rotating devices
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
References: <20171227223931.7878-1-nefelim4ag@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4bc00e2e-7a46-b02c-a97b-90947fc242d9@gmx.com>
Date: Thu, 28 Dec 2017 08:44:56 +0800
MIME-Version: 1.0
In-Reply-To: <20171227223931.7878-1-nefelim4ag@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uB4jClYRJZ5AEGnf4h4MuqucUoAC9yrna"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uB4jClYRJZ5AEGnf4h4MuqucUoAC9yrna
Content-Type: multipart/mixed; boundary="PewD0dqFSGhHE8mlbLyVUzRTtwL9Kux6g";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <4bc00e2e-7a46-b02c-a97b-90947fc242d9@gmx.com>
Subject: Re: [PATCH] Btrfs: enchanse raid1/10 balance heuristic for non
 rotating devices
References: <20171227223931.7878-1-nefelim4ag@gmail.com>
In-Reply-To: <20171227223931.7878-1-nefelim4ag@gmail.com>

--PewD0dqFSGhHE8mlbLyVUzRTtwL9Kux6g
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

And I'm wondering why this case can't use the same bdev queue length?

Any special reason spinning disk can't benifit from a shorter queue?

Thanks,
Qu

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


--PewD0dqFSGhHE8mlbLyVUzRTtwL9Kux6g--

--uB4jClYRJZ5AEGnf4h4MuqucUoAC9yrna
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpEPokXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh0mwf8Ck8Xe0ybKRMpkgXNKrOig50H
05MTP8/AKBC2vlrt26+c4pn9BIFyde6ya8RmqwBbamZikG0O1l0GljeJQwplSLEQ
lrJsrwttkiP6RTJVy8ZOnP/9ajFHHgSo+vICQTCPJRu45Kk/tu2hK2rhYl9CIss/
Drzd4AI+aECTYaJPAJ/Z267GXcsrDQSsydxfji6HeQ/JgtPjwwt21sKCixRXHGfN
rjiiwd+M9LyEpMnNYsjiBOBCe3xnvHSo2z0WYM+3+Eo90C8kWny5wmtZrf6pH/fK
Ol4yMX7q2l3HMLnGhdb/sigmP0S3LXYwxQ2UyUGvdpGY3f5w4Ogu/WXDcUueGw==
=Z/Ju
-----END PGP SIGNATURE-----

--uB4jClYRJZ5AEGnf4h4MuqucUoAC9yrna--
