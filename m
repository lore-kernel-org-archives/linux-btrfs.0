Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41101 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752080AbbJPXIi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 19:08:38 -0400
Date: Fri, 16 Oct 2015 19:08:37 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: extend balance filter limit to take minimum
 and maximum
Message-ID: <20151016230837.GD4400@hungrycats.org>
References: <cover.1445013000.git.dsterba@suse.com>
 <35832c0abf72cfd1e118d484f6a9ebdd689f8757.1445013000.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vni90+aGYgRvsTuO"
In-Reply-To: <35832c0abf72cfd1e118d484f6a9ebdd689f8757.1445013000.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2015 at 06:50:08PM +0200, David Sterba wrote:
> The 'limit' filter is underdesigned, it should have been a range for
> [min,max], with some relaxed semantics when one of the bounds is
> missing. Besides that, using a full u64 for a single value is a waste of
> bytes.

What is min for?

If we have more than 'max' matching chunks, we'd process 'max' and stop.
If we have fewer than 'min' chunks, we'd process what we have and run out.

If we have more than 'min' chunks but fewer than 'max' chunks, why would
we stop before we reach 'max' chunks?

> Let's fix both by extending the use of the u64 bytes for the [min,max]
> range. This can be done in a backward compatible way, the range will be
> interpreted only if the appropriate flag is set
> (BTRFS_BALANCE_ARGS_LIMITS).
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h           | 14 ++++++++++++--
>  fs/btrfs/volumes.c         | 42 ++++++++++++++++++++++++++++++++++++++++=
++
>  fs/btrfs/volumes.h         |  1 +
>  include/uapi/linux/btrfs.h | 13 ++++++++++++-
>  4 files changed, 67 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 938efe33be80..7d2e1b6d0ac1 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -846,8 +846,18 @@ struct btrfs_disk_balance_args {
>  	/* BTRFS_BALANCE_ARGS_* */
>  	__le64 flags;
> =20
> -	/* BTRFS_BALANCE_ARGS_LIMIT value */
> -	__le64 limit;
> +	/*
> +	 * BTRFS_BALANCE_ARGS_LIMIT with value 'limit'
> +	 * BTRFS_BALANCE_ARGS_LIMITS - the extend version can use minimum and
> +	 * maximum
> +	 */
> +	union {
> +		__le64 limit;
> +		struct {
> +			__le32 limit_min;
> +			__le32 limit_max;
> +		};
> +	};
> =20
>  	__le64 unused[7];
>  } __attribute__ ((__packed__));
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6fc735869c18..0fbe6855ea05 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3250,6 +3250,16 @@ static int should_balance_chunk(struct btrfs_root =
*root,
>  			return 0;
>  		else
>  			bargs->limit--;
> +	} else if ((bargs->flags & BTRFS_BALANCE_ARGS_LIMITS)) {
> +		/*
> +		 * Same logic as the 'limit' filter; the minimum cannot be
> +		 * determined here because we do not have the global informatoin
> +		 * about the count of all chunks that satisfy the filters.
> +		 */
> +		if (bargs->limit_max =3D=3D 0)
> +			return 0;
> +		else
> +			bargs->limit_max--;
>  	}
> =20
>  	return 1;
> @@ -3264,6 +3274,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs=
_info)
>  	struct btrfs_device *device;
>  	u64 old_size;
>  	u64 size_to_free;
> +	u64 chunk_type;
>  	struct btrfs_chunk *chunk;
>  	struct btrfs_path *path;
>  	struct btrfs_key key;
> @@ -3274,9 +3285,13 @@ static int __btrfs_balance(struct btrfs_fs_info *f=
s_info)
>  	int ret;
>  	int enospc_errors =3D 0;
>  	bool counting =3D true;
> +	/* The single value limit and min/max limits use the same bytes in the =
*/
>  	u64 limit_data =3D bctl->data.limit;
>  	u64 limit_meta =3D bctl->meta.limit;
>  	u64 limit_sys =3D bctl->sys.limit;
> +	u32 count_data =3D 0;
> +	u32 count_meta =3D 0;
> +	u32 count_sys =3D 0;
> =20
>  	/* step one make some room on all the devices */
>  	devices =3D &fs_info->fs_devices->devices;
> @@ -3317,6 +3332,10 @@ static int __btrfs_balance(struct btrfs_fs_info *f=
s_info)
>  	spin_unlock(&fs_info->balance_lock);
>  again:
>  	if (!counting) {
> +		/*
> +		 * The single value limit and min/max limits use the same bytes
> +		 * in the
> +		 */
>  		bctl->data.limit =3D limit_data;
>  		bctl->meta.limit =3D limit_meta;
>  		bctl->sys.limit =3D limit_sys;
> @@ -3364,6 +3383,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs=
_info)
>  		}
> =20
>  		chunk =3D btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
> +		chunk_type =3D btrfs_chunk_type(leaf, chunk);
> =20
>  		if (!counting) {
>  			spin_lock(&fs_info->balance_lock);
> @@ -3384,6 +3404,28 @@ static int __btrfs_balance(struct btrfs_fs_info *f=
s_info)
>  			spin_lock(&fs_info->balance_lock);
>  			bctl->stat.expected++;
>  			spin_unlock(&fs_info->balance_lock);
> +
> +			if (chunk_type & BTRFS_BLOCK_GROUP_DATA)
> +				count_data++;
> +			else if (chunk_type & BTRFS_BLOCK_GROUP_SYSTEM)
> +				count_sys++;
> +			else if (chunk_type & BTRFS_BLOCK_GROUP_METADATA)
> +				count_meta++;
> +
> +			goto loop;
> +		}
> +
> +		/*
> +		 * Apply limit_min filter, no need to check if the LIMITS
> +		 * filter is used, limit_min is 0 by default
> +		 */
> +		if (((chunk_type & BTRFS_BLOCK_GROUP_DATA) &&
> +					count_data < bctl->data.limit_min)
> +				|| ((chunk_type & BTRFS_BLOCK_GROUP_METADATA) &&
> +					count_meta < bctl->meta.limit_min)
> +				|| ((chunk_type & BTRFS_BLOCK_GROUP_SYSTEM) &&
> +					count_sys < bctl->sys.limit_min)) {
> +			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
>  			goto loop;
>  		}
> =20
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 2ca784a14e84..1c9d8edd7d57 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -375,6 +375,7 @@ struct map_lookup {
>  #define BTRFS_BALANCE_ARGS_DRANGE	(1ULL << 3)
>  #define BTRFS_BALANCE_ARGS_VRANGE	(1ULL << 4)
>  #define BTRFS_BALANCE_ARGS_LIMIT	(1ULL << 5)
> +#define BTRFS_BALANCE_ARGS_LIMITS	(1ULL << 6)
> =20
>  /*
>   * Profile changing flags.  When SOFT is set we won't relocate chunk if
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index b6dec05c7196..264ecea5ecfc 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -217,7 +217,18 @@ struct btrfs_balance_args {
> =20
>  	__u64 flags;
> =20
> -	__u64 limit;		/* limit number of processed chunks */
> +	/*
> +	 * BTRFS_BALANCE_ARGS_LIMIT with value 'limit'
> +	 * BTRFS_BALANCE_ARGS_LIMITS - the extend version can use minimum and
> +	 * maximum
> +	 */
> +	union {
> +		__u64 limit;		/* limit number of processed chunks */
> +		struct {
> +			__u32 limit_min;
> +			__u32 limit_max;
> +		};
> +	};
>  	__u64 unused[7];
>  } __attribute__ ((__packed__));
> =20
> --=20
> 2.6.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--vni90+aGYgRvsTuO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlYhg3UACgkQgfmLGlazG5xBNwCfSXYp4sTAbGQ817fS/+U/b2DL
ceYAniZIAhoUJLu2Szk4Ys/ypQGqKeaT
=F51F
-----END PGP SIGNATURE-----

--vni90+aGYgRvsTuO--
