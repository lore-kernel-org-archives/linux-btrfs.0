Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63626 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752381AbdLHIRW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 03:17:22 -0500
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171208075705.23462-1-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ee4df708-3197-7d37-8c6a-65f07cc760b5@gmx.com>
Date: Fri, 8 Dec 2017 16:17:12 +0800
MIME-Version: 1.0
In-Reply-To: <20171208075705.23462-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KkVO5EW93JLDFIkppx7KhE440LNBlFaJu"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KkVO5EW93JLDFIkppx7KhE440LNBlFaJu
Content-Type: multipart/mixed; boundary="BOg99V8FNlH5mQVdAFVXaTaGt64KblIP3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <ee4df708-3197-7d37-8c6a-65f07cc760b5@gmx.com>
Subject: Re: [PATCH RFC] btrfs: self heal from SB fail
References: <20171208075705.23462-1-anand.jain@oracle.com>
In-Reply-To: <20171208075705.23462-1-anand.jain@oracle.com>

--BOg99V8FNlH5mQVdAFVXaTaGt64KblIP3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8808=E6=97=A5 15:57, Anand Jain wrote:
> -EXPERIMENTAL-
> As of now when primary SB fails we won't self heal and would fail mount=
,
> this is an experimental patch which thinks why not go and read backup
> copy.

Just curious about in which real world case that backup super block can
help.
At least from what I see in mail list, only few cases where backup super
helps.

Despite that self super heal seems good, although I agree with David, we
need a weaker but necessary check (magic and fsid from primary super?)
to ensure it's a valid btrfs before we use the backup supers.

Thanks,
Qu


>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c |  8 +++++++-
>  fs/btrfs/volumes.c | 10 +++++++---
>  2 files changed, 14 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 9b20c1f3563b..a791b8dfe8a8 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3190,7 +3190,7 @@ struct buffer_head *btrfs_read_dev_super(struct b=
lock_device *bdev)
>  	 * So, we need to add a special mount option to scan for
>  	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>  	 */
> -	for (i =3D 0; i < 1; i++) {
> +	for (i =3D 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>  		ret =3D btrfs_read_dev_one_super(bdev, i, &bh);
>  		if (ret)
>  			continue;
> @@ -4015,11 +4015,17 @@ static int btrfs_check_super_valid(struct btrfs=
_fs_info *fs_info)
>  		ret =3D -EINVAL;
>  	}
> =20
> +#if 0
> +	/*
> +	 * Need a way to check for any copy of SB, as its not a
> +	 * strong check, just ignore this for now.
> +	 */
>  	if (btrfs_super_bytenr(sb) !=3D BTRFS_SUPER_INFO_OFFSET) {
>  		btrfs_err(fs_info, "super offset mismatch %llu !=3D %u",
>  			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
>  		ret =3D -EINVAL;
>  	}
> +#endif
> =20
>  	/*
>  	 * Obvious sys_chunk_array corruptions, it must hold at least one key=

> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9fa2539a8493..f368db94d62b 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1369,7 +1369,7 @@ int btrfs_scan_one_device(const char *path, fmode=
_t flags, void *holder,
>  {
>  	struct btrfs_super_block *disk_super;
>  	struct block_device *bdev;
> -	struct page *page;
> +	struct buffer_head *sb_bh;
>  	int ret =3D -EINVAL;
>  	u64 devid;
>  	u64 transid;
> @@ -1392,8 +1392,12 @@ int btrfs_scan_one_device(const char *path, fmod=
e_t flags, void *holder,
>  		goto error;
>  	}
> =20
> -	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super))
> +	sb_bh =3D btrfs_read_dev_super(bdev);
> +	if (IS_ERR(sb_bh)) {
> +		ret =3D PTR_ERR(sb_bh);
>  		goto error_bdev_put;
> +	}
> +	disk_super =3D (struct btrfs_super_block *) sb_bh->b_data;
> =20
>  	devid =3D btrfs_stack_device_id(&disk_super->dev_item);
>  	transid =3D btrfs_super_generation(disk_super);
> @@ -1413,7 +1417,7 @@ int btrfs_scan_one_device(const char *path, fmode=
_t flags, void *holder,
>  	if (!ret && fs_devices_ret)
>  		(*fs_devices_ret)->total_devices =3D total_devices;
> =20
> -	btrfs_release_disk_super(page);
> +	brelse(sb_bh);
> =20
>  error_bdev_put:
>  	blkdev_put(bdev, flags);
>=20


--BOg99V8FNlH5mQVdAFVXaTaGt64KblIP3--

--KkVO5EW93JLDFIkppx7KhE440LNBlFaJu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloqSogXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg8Cgf/TjeZiviBHAVTCX8V+ZqykER+
O3dp8QVZy/PUdbhidWz2IXWMSduoAR9qrJYcIq/ZgD1+DUKnD7RsN8uwkDTM7Vu5
zffUQqda8XP2euLDbBw2ah9DtJELpEao86art4w6JOOF8uAKmCBer7crPVjgq3Zu
gnVpYHX+wNkV6k67108Uf3vHw+vRGdz/cLBsVWxjhh6gVexksDL5CKT9WJJeXNuO
t1NN2bg2f9o9fpfGkMtHP21xj6h6EK4T8yMHYfN4jr2SWc0OP6iG6uodNfm4NQpp
XY8al5VZNh/mvRcOK13OwB5y4O9RRMTM7lAkJme1iYeN+uDuVZlI/ldknEgHGQ==
=PBnn
-----END PGP SIGNATURE-----

--KkVO5EW93JLDFIkppx7KhE440LNBlFaJu--
