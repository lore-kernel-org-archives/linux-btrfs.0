Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43808 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751713AbdEQNuk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 09:50:40 -0400
Subject: Re: [PATCH 2/2] btrfs: Refactor update_space_info
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com
References: <1494318859-7555-1-git-send-email-nborisov@suse.com>
 <1494318859-7555-3-git-send-email-nborisov@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <e0228ca9-8b33-5f06-d9c5-63fc3ab1eb32@suse.com>
Date: Wed, 17 May 2017 09:50:36 -0400
MIME-Version: 1.0
In-Reply-To: <1494318859-7555-3-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xx0B1xqpQcIOVaDBrKS0bOd5Pn4u44Qrt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xx0B1xqpQcIOVaDBrKS0bOd5Pn4u44Qrt
Content-Type: multipart/mixed; boundary="vFSdsk1PcC0KjhppaSnVKjqnXwQrRcl1C";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com
Message-ID: <e0228ca9-8b33-5f06-d9c5-63fc3ab1eb32@suse.com>
Subject: Re: [PATCH 2/2] btrfs: Refactor update_space_info
References: <1494318859-7555-1-git-send-email-nborisov@suse.com>
 <1494318859-7555-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1494318859-7555-3-git-send-email-nborisov@suse.com>

--vFSdsk1PcC0KjhppaSnVKjqnXwQrRcl1C
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/9/17 4:34 AM, Nikolay Borisov wrote:
> Following the factoring out of the creation code udpate_space_info can =
only
> be called for already-existing space_info structs. As such it cannot fa=
il.
> Remove superfulous error handling and make the function return void.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 53 ++++++++++++++----------------------------=
--------
>  1 file changed, 15 insertions(+), 38 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e71921d8c610..3ab1f88af038 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3958,7 +3958,7 @@ static int create_space_info(struct btrfs_fs_info=
 *info, u64 flags,
>  	return ret;
>  }
> =20
> -static int update_space_info(struct btrfs_fs_info *info, u64 flags,
> +static void update_space_info(struct btrfs_fs_info *info, u64 flags,
>  			     u64 total_bytes, u64 bytes_used,
>  			     u64 bytes_readonly,
>  			     struct btrfs_space_info **space_info)

Since we don't have any errors to report anymore, let's just return the
space_info directly instead of passing it back via parameter.

> @@ -3973,21 +3973,18 @@ static int update_space_info(struct btrfs_fs_in=
fo *info, u64 flags,
>  		factor =3D 1;
> =20
>  	found =3D __find_space_info(info, flags);

BUG_ON(!found);

> -	if (found) {
> -		spin_lock(&found->lock);
> -		found->total_bytes +=3D total_bytes;
> -		found->disk_total +=3D total_bytes * factor;
> -		found->bytes_used +=3D bytes_used;
> -		found->disk_used +=3D bytes_used * factor;
> -		found->bytes_readonly +=3D bytes_readonly;
> -		if (total_bytes > 0)
> -			found->full =3D 0;
> -		space_info_add_new_bytes(info, found, total_bytes -
> -					 bytes_used - bytes_readonly);
> -		spin_unlock(&found->lock);
> -		*space_info =3D found;
> -		return 0;
> -	}
> +	spin_lock(&found->lock);
> +	found->total_bytes +=3D total_bytes;
> +	found->disk_total +=3D total_bytes * factor;
> +	found->bytes_used +=3D bytes_used;
> +	found->disk_used +=3D bytes_used * factor;
> +	found->bytes_readonly +=3D bytes_readonly;
> +	if (total_bytes > 0)
> +		found->full =3D 0;
> +	space_info_add_new_bytes(info, found, total_bytes -
> +				 bytes_used - bytes_readonly);
> +	spin_unlock(&found->lock);
> +	*space_info =3D found;
>  }
> =20
>  static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 fl=
ags)
> @@ -10041,19 +10038,9 @@ int btrfs_read_block_groups(struct btrfs_fs_in=
fo *info)
>  		}
> =20
>  		trace_btrfs_add_block_group(info, cache, 0);
> -		ret =3D update_space_info(info, cache->flags, found_key.offset,
> +		update_space_info(info, cache->flags, found_key.offset,
>  					btrfs_block_group_used(&cache->item),
>  					cache->bytes_super, &space_info);

Whitespace needs adjusting too.

> -		if (ret) {
> -			btrfs_remove_free_space_cache(cache);
> -			spin_lock(&info->block_group_cache_lock);
> -			rb_erase(&cache->cache_node,
> -				 &info->block_group_cache_tree);
> -			RB_CLEAR_NODE(&cache->cache_node);
> -			spin_unlock(&info->block_group_cache_lock);
> -			btrfs_put_block_group(cache);
> -			goto error;
> -		}
> =20
>  		cache->space_info =3D space_info;
> =20
> @@ -10212,18 +10199,8 @@ int btrfs_make_block_group(struct btrfs_trans_=
handle *trans,
>  	 * the rbtree, update the space info's counters.
>  	 */
>  	trace_btrfs_add_block_group(fs_info, cache, 1);
> -	ret =3D update_space_info(fs_info, cache->flags, size, bytes_used,
> +	update_space_info(fs_info, cache->flags, size, bytes_used,
>  				cache->bytes_super, &cache->space_info);

Same.

> -	if (ret) {
> -		btrfs_remove_free_space_cache(cache);
> -		spin_lock(&fs_info->block_group_cache_lock);
> -		rb_erase(&cache->cache_node,
> -			 &fs_info->block_group_cache_tree);
> -		RB_CLEAR_NODE(&cache->cache_node);
> -		spin_unlock(&fs_info->block_group_cache_lock);
> -		btrfs_put_block_group(cache);
> -		return ret;
> -	}
>  	update_global_block_rsv(fs_info);
> =20
>  	__link_block_group(cache->space_info, cache);
>=20

Otherwise, looks good.  With those changes, you can add:

Reviewed-by: Jeff Mahoney <jeffm@suse.com>

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--vFSdsk1PcC0KjhppaSnVKjqnXwQrRcl1C--

--xx0B1xqpQcIOVaDBrKS0bOd5Pn4u44Qrt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWRxVLR57S2MheeWyAQhsWRAAuox/Zz9Bg87NkEiNvO/KF9fTrWMBKI2e
t2w/fH+htD5Nib5XqqxN+Frqm9WyN42d28h5Dz9ptM3t2TdvTl0EdjaQm22e5XbC
mZTV+fnUnf3FKFy2UuZdPNS1wl/tMNOR9hvJ4+0OwO92cq3MdOiUpGNYaZSv2Pmn
yeDEQwVhM7svknM07myCKmnc+mpONqrHXU8VdUEIYUU5j7mY1W7WcQZdFkI1cdKK
rdvcsVrxWEbtRvTrRDUOXGuNfLcnSKXuxZ6jeOgsItf/xwaAhCzeSmlu6dJqXXGP
m3NdTkUPARexA6pZ6PmJuwjRHKJRcDaCKBaA7ubB1ValRvVS8WLe3eRESGolZYmt
SXf1RwCXgjtOrMF76Bne/hfMMgr5VZv6Cn+v2lreniqg6DlNZh0M++MqHP++UY4Y
OhRNgp9ciRvOLJm/v+/Vy02UGkWAOdXd8zRscC5Mmit0fUjQBRKXOVNEHEEg6bJG
Z+h8cgKBdqvJeL69neh5KTxavzDhAGItzDEY/J0gOwCcruU9ELhYlukO1SJISRBS
KXiyXEmw/9AKv+Ck0T2x2bTzjSfUbt3rvCcf86Ufe2GzO3iC3EtEGYNIkNV8p4l1
ZHyNYVMLV6I8EuhWfXXyjpZu+8rztcyvgN4WNXGFTw44UL6e3413SStRQakWGTEE
hLANJqtI5tQ=
=DKvr
-----END PGP SIGNATURE-----

--xx0B1xqpQcIOVaDBrKS0bOd5Pn4u44Qrt--
