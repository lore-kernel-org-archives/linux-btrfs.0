Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53999 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751130AbeDAKfd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 1 Apr 2018 06:35:33 -0400
Subject: Re: [PATCH RESEND 1/2] btrfs: Enhance btrfs_trim_fs function to
 handle error better
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171128070830.12756-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4befd8e2-c6e6-a3cb-2d38-9a3c9739a32e@gmx.com>
Date: Sun, 1 Apr 2018 18:35:17 +0800
MIME-Version: 1.0
In-Reply-To: <20171128070830.12756-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GLQ8HDP8DQa2NEjqueJZHCDEUnC8jbiGo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GLQ8HDP8DQa2NEjqueJZHCDEUnC8jbiGo
Content-Type: multipart/mixed; boundary="zHuWTtNzNRyuKVOFhI8LtHkI63cUx3RFP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <4befd8e2-c6e6-a3cb-2d38-9a3c9739a32e@gmx.com>
Subject: Re: [PATCH RESEND 1/2] btrfs: Enhance btrfs_trim_fs function to
 handle error better
References: <20171128070830.12756-1-wqu@suse.com>
In-Reply-To: <20171128070830.12756-1-wqu@suse.com>

--zHuWTtNzNRyuKVOFhI8LtHkI63cUx3RFP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Gentle ping?

The patch is small and (with its 2nd patch) should fix trim behavior
inside block groups.

Thanks,
Qu

On 2017=E5=B9=B411=E6=9C=8828=E6=97=A5 15:08, Qu Wenruo wrote:
> Function btrfs_trim_fs() doesn't handle errors in a consistent way, if
> error happens when trimming existing block groups, it will skip the
> remaining blocks and continue to trim unallocated space for each device=
=2E
>=20
> And the return value will only reflect the final error from device
> trimming.
>=20
> This patch will fix such behavior by:
>=20
> 1) Recording first error from block group or device trimming
>    So return value will also reflect any error found when trimming.
>    Make developer more aware of the problem.
>=20
> 2) Outputting btrfs warning message for each trimming failure
>    Any error for block group or device trimming will cause btrfs warnin=
g
>    kernel message.
>=20
> 3) Continuing trimming if we can
>    If we failed to trim one block group or device, we could still try
>    next block group or device.
>=20
> Such behavior can avoid confusion for case like failure to trim the
> first block group and then only unallocated space is trimmed.
>=20
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 59 ++++++++++++++++++++++++++++++++++++------=
--------
>  1 file changed, 43 insertions(+), 16 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 673ac4e01dd0..f830aa91ac3d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10948,6 +10948,16 @@ static int btrfs_trim_free_extents(struct btrf=
s_device *device,
>  	return ret;
>  }
> =20
> +/*
> + * Trim the whole fs, by:
> + * 1) Trimming free space in each block group
> + * 2) Trimming unallocated space in each device
> + *
> + * Will try to continue trimming even if we failed to trim one block g=
roup or
> + * device.
> + * The return value will be the error return value of the first error.=

> + * Or 0 if nothing wrong happened.
> + */
>  int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *=
range)
>  {
>  	struct btrfs_block_group_cache *cache =3D NULL;
> @@ -10958,6 +10968,8 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info=
, struct fstrim_range *range)
>  	u64 end;
>  	u64 trimmed =3D 0;
>  	u64 total_bytes =3D btrfs_super_total_bytes(fs_info->super_copy);
> +	int bg_ret =3D 0;
> +	int dev_ret =3D 0;
>  	int ret =3D 0;
> =20
>  	/*
> @@ -10968,7 +10980,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info=
, struct fstrim_range *range)
>  	else
>  		cache =3D btrfs_lookup_block_group(fs_info, range->start);
> =20
> -	while (cache) {
> +	for (; cache; cache =3D next_block_group(fs_info, cache)) {
>  		if (cache->key.objectid >=3D (range->start + range->len)) {
>  			btrfs_put_block_group(cache);
>  			break;
> @@ -10982,29 +10994,36 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_in=
fo, struct fstrim_range *range)
>  			if (!block_group_cache_done(cache)) {
>  				ret =3D cache_block_group(cache, 0);
>  				if (ret) {
> -					btrfs_put_block_group(cache);
> -					break;
> +					btrfs_warn_rl(fs_info,
> +		"failed to cache block group %llu ret %d",
> +						   cache->key.objectid, ret);
> +					if (!bg_ret)
> +						bg_ret =3D ret;
> +					continue;
>  				}
>  				ret =3D wait_block_group_cache_done(cache);
>  				if (ret) {
> -					btrfs_put_block_group(cache);
> -					break;
> +					btrfs_warn_rl(fs_info,
> +		"failed to wait cache for block group %llu ret %d",
> +						   cache->key.objectid, ret);
> +					if (!bg_ret)
> +						bg_ret =3D ret;
> +					continue;
>  				}
>  			}
> -			ret =3D btrfs_trim_block_group(cache,
> -						     &group_trimmed,
> -						     start,
> -						     end,
> -						     range->minlen);
> +			ret =3D btrfs_trim_block_group(cache, &group_trimmed,
> +						start, end, range->minlen);
> =20
>  			trimmed +=3D group_trimmed;
>  			if (ret) {
> -				btrfs_put_block_group(cache);
> -				break;
> +				btrfs_warn_rl(fs_info,
> +		"failed to trim block group %llu ret %d",
> +					   cache->key.objectid, ret);
> +				if (!bg_ret)
> +					bg_ret =3D ret;
> +				continue;
>  			}
>  		}
> -
> -		cache =3D next_block_group(fs_info, cache);
>  	}
> =20
>  	mutex_lock(&fs_info->fs_devices->device_list_mutex);
> @@ -11012,15 +11031,23 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_in=
fo, struct fstrim_range *range)
>  	list_for_each_entry(device, devices, dev_alloc_list) {
>  		ret =3D btrfs_trim_free_extents(device, range->minlen,
>  					      &group_trimmed);
> -		if (ret)
> +		if (ret) {
> +			btrfs_warn_rl(fs_info,
> +		"failed to trim unallocated space for devid %llu ret %d",
> +				      device->devid, ret);
> +			if (!dev_ret)
> +				dev_ret =3D ret;
>  			break;
> +		}
> =20
>  		trimmed +=3D group_trimmed;
>  	}
>  	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> =20
>  	range->len =3D trimmed;
> -	return ret;
> +	if (bg_ret)
> +		return bg_ret;
> +	return dev_ret;
>  }
> =20
>  /*
>=20


--zHuWTtNzNRyuKVOFhI8LtHkI63cUx3RFP--

--GLQ8HDP8DQa2NEjqueJZHCDEUnC8jbiGo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrAteYACgkQwj2R86El
/qhrlQf+KJxefXZ3v75xvqSjhrc9rXKeYB+q5ZMIohcAIGZjl669TasvMJyDkNZm
8DA9zNZrPtR/NHOvtspYGNcy9pcl1cYp8WfpVCeJC7d1m8EVhJ2hdPxwS2L1dYyH
XY0gRvrHcJ3Faiois8MCp+4BB7/kzupZrGFcVQoxnabRe3t+VGo73scM6FYkWvWk
0jy2HLOlkgemAnsrdoCxN7yTgv70/ApSWxmFpJ6mKI7UjoLtKWJE5MR3xh0iUtKE
JXHoiK/VsXpbxo8MThVokJzNI1EGz+lHfGE4DU9WMaGoNMhVyhF6A2hOpLo5fEZf
k7xQVHtW40vK5hyTJrqB0ibeimiObw==
=0M1m
-----END PGP SIGNATURE-----

--GLQ8HDP8DQa2NEjqueJZHCDEUnC8jbiGo--
