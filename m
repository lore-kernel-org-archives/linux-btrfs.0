Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:44379 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbeHBKmm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 06:42:42 -0400
Subject: Re: [PATCH] btrfs: Use wrapper macro for rcu string to remove
 duplicate code
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1533189995.git.misono.tomohiro@jp.fujitsu.com>
 <0181282c-c4e3-3193-8320-57b2ec3019dc@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c2c62838-38d8-4417-2b41-416cc6925aec@gmx.com>
Date: Thu, 2 Aug 2018 16:52:22 +0800
MIME-Version: 1.0
In-Reply-To: <0181282c-c4e3-3193-8320-57b2ec3019dc@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RHjIVSbXYTPQ9c008dHq6sqduEfBsyHAE"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RHjIVSbXYTPQ9c008dHq6sqduEfBsyHAE
Content-Type: multipart/mixed; boundary="PJ5UkXAn0BE7jWuceNVXVJ72ICbkFe1mm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <c2c62838-38d8-4417-2b41-416cc6925aec@gmx.com>
Subject: Re: [PATCH] btrfs: Use wrapper macro for rcu string to remove
 duplicate code
References: <cover.1533189995.git.misono.tomohiro@jp.fujitsu.com>
 <0181282c-c4e3-3193-8320-57b2ec3019dc@jp.fujitsu.com>
In-Reply-To: <0181282c-c4e3-3193-8320-57b2ec3019dc@jp.fujitsu.com>

--PJ5UkXAn0BE7jWuceNVXVJ72ICbkFe1mm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8802=E6=97=A5 15:19, Misono Tomohiro wrote:
> Cleanup patch and no functional changes.
>=20
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/ioctl.c   |  6 ++----
>  fs/btrfs/scrub.c   |  8 ++------
>  fs/btrfs/super.c   |  9 +++------
>  fs/btrfs/volumes.c | 21 ++++++---------------
>  4 files changed, 13 insertions(+), 31 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b077544b5232..2becabe2aaf4 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3165,10 +3165,8 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs=
_info *fs_info,
>  	di_args->total_bytes =3D btrfs_device_get_total_bytes(dev);
>  	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
>  	if (dev->name) {
> -		struct rcu_string *name;
> -
> -		name =3D rcu_dereference(dev->name);
> -		strncpy(di_args->path, name->str, sizeof(di_args->path) - 1);
> +		strncpy(di_args->path, rcu_str_deref(dev->name),
> +				sizeof(di_args->path) - 1);
>  		di_args->path[sizeof(di_args->path) - 1] =3D 0;
>  	} else {
>  		di_args->path[0] =3D '\0';
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 6702896cdb8f..5a282268deee 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -4113,7 +4113,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info=
, u64 devid, u64 start,
>  	struct scrub_ctx *sctx;
>  	int ret;
>  	struct btrfs_device *dev;
> -	struct rcu_string *name;
> =20
>  	if (btrfs_fs_closing(fs_info))
>  		return -EINVAL;
> @@ -4167,11 +4166,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_inf=
o, u64 devid, u64 start,
>  	if (!is_dev_replace && !readonly &&
>  	    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state)) {
>  		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> -		rcu_read_lock();
> -		name =3D rcu_dereference(dev->name);
> -		btrfs_err(fs_info, "scrub: device %s is not writable",
> -			  name->str);
> -		rcu_read_unlock();
> +		btrfs_err_in_rcu(fs_info, "scrub: device %s is not writable",
> +			  rcu_str_deref(dev->name));
>  		return -EROFS;
>  	}
> =20
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 81107ad49f3a..d9f00704f4aa 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2290,7 +2290,6 @@ static int btrfs_show_devname(struct seq_file *m,=
 struct dentry *root)
>  	struct btrfs_fs_devices *cur_devices;
>  	struct btrfs_device *dev, *first_dev =3D NULL;
>  	struct list_head *head;
> -	struct rcu_string *name;
> =20
>  	/*
>  	 * Lightweight locking of the devices. We should not need
> @@ -2314,12 +2313,10 @@ static int btrfs_show_devname(struct seq_file *=
m, struct dentry *root)
>  		cur_devices =3D cur_devices->seed;
>  	}
> =20
> -	if (first_dev) {
> -		name =3D rcu_dereference(first_dev->name);
> -		seq_escape(m, name->str, " \t\n\\");
> -	} else {
> +	if (first_dev)
> +		seq_escape(m, rcu_str_deref(first_dev->name), " \t\n\\");
> +	else
>  		WARN_ON(1);
> -	}
>  	rcu_read_unlock();
>  	return 0;
>  }
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 1da162928d1a..d30bbc3cf921 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6187,21 +6187,12 @@ static void submit_stripe_bio(struct btrfs_bio =
*bbio, struct bio *bio,
>  	btrfs_io_bio(bio)->stripe_index =3D dev_nr;
>  	bio->bi_end_io =3D btrfs_end_bio;
>  	bio->bi_iter.bi_sector =3D physical >> 9;
> -#ifdef DEBUG
> -	{
> -		struct rcu_string *name;
> -
> -		rcu_read_lock();
> -		name =3D rcu_dereference(dev->name);
> -		btrfs_debug(fs_info,
> -			"btrfs_map_bio: rw %d 0x%x, sector=3D%llu, dev=3D%lu (%s id %llu), =
size=3D%u",
> -			bio_op(bio), bio->bi_opf,
> -			(u64)bio->bi_iter.bi_sector,
> -			(u_long)dev->bdev->bd_dev, name->str, dev->devid,
> -			bio->bi_iter.bi_size);
> -		rcu_read_unlock();
> -	}
> -#endif
> +	btrfs_debug_in_rcu(fs_info,
> +		"btrfs_map_bio: rw %d 0x%x, sector=3D%llu, dev=3D%lu (%s id %llu), s=
ize=3D%u",
> +		bio_op(bio), bio->bi_opf,
> +		(u64)bio->bi_iter.bi_sector,
> +		(u_long)dev->bdev->bd_dev, rcu_str_deref(dev->name), dev->devid,
> +		bio->bi_iter.bi_size);
>  	bio_set_dev(bio, dev->bdev);
> =20
>  	btrfs_bio_counter_inc_noblocked(fs_info);
>=20


--PJ5UkXAn0BE7jWuceNVXVJ72ICbkFe1mm--

--RHjIVSbXYTPQ9c008dHq6sqduEfBsyHAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltixkYACgkQwj2R86El
/qhAwgf7BzPFgOR1TKpAfhRCV6DwSDle+Sr6YGFSFVmk0sDPRprvUJwyRSRFlW4O
/4UuUYQiqjiLr1bwoEtZHlnoguZ0P8p2u3RAQVilLg3s1xFfWQcSpuYxrKr+OYf+
sy+DLyWDf8ev5DlLAJ0fstfss+0huASIxWvuIyC3+/62UwmTM+gJ3z55QRvRU3+o
fBdPJ766tBHJJk7n7Gxu0RVVzAbbdWcezr8NlSSevvS6cwqcSxUswXrVn9KkjdRh
xIL+uvWstzV/kj9AeL75os/2jq51rSdlIZdR64ehRaVesW+5V60oQW436/I7s6Q2
CQwOU3tJlW11T6aUd0BP7IbQ13lkKg==
=7IO3
-----END PGP SIGNATURE-----

--RHjIVSbXYTPQ9c008dHq6sqduEfBsyHAE--
