Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59801 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751649AbdLTFjE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 00:39:04 -0500
Subject: Re: [PATCH v2 05/17] btrfs-progs: lowmem check: introduce
 modify_block_groups_cache()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-6-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2bd256bd-319e-5947-13fc-d52babbba300@gmx.com>
Date: Wed, 20 Dec 2017 13:38:55 +0800
MIME-Version: 1.0
In-Reply-To: <20171220045731.19343-6-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bxlFtBJ1Fo7L9O5bUN6mjNn1zrFkieEG4"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bxlFtBJ1Fo7L9O5bUN6mjNn1zrFkieEG4
Content-Type: multipart/mixed; boundary="tL0lbtOSpJKZ5skTcTHBOGrs0GMEvqDEp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <2bd256bd-319e-5947-13fc-d52babbba300@gmx.com>
Subject: Re: [PATCH v2 05/17] btrfs-progs: lowmem check: introduce
 modify_block_groups_cache()
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-6-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-6-suy.fnst@cn.fujitsu.com>

--tL0lbtOSpJKZ5skTcTHBOGrs0GMEvqDEp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 12:57, Su Yue wrote:
> Excluding or pining all metadata blocks is not time-efficient for large=

> storage filesystems.
> Here is another way to mark all metadata block groups full and allocate=

> a new chunk for CoW. So new reservered extents never overwrite
> extents.
>=20
> Introduce modify_block_groups_cache() to modify all blocks groups
> cache state and set all extents in block groups unfree in free space
> cache.
>=20
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  1 file changed, 83 insertions(+)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index dd46569f3811..d98d4bda7357 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -10828,6 +10828,89 @@ static void reset_cached_block_groups(struct b=
trfs_fs_info *fs_info)
>  	}
>  }
> =20
> +/*
> + * Mark all extents unfree in the block group. And set @block_group->c=
ached
> + * according to @cache.
> + */
> +static int modify_block_group_cache(struct btrfs_fs_info *fs_info,
> +		    struct btrfs_block_group_cache *block_group, int cache)
> +{
> +	struct extent_io_tree *free_space_cache =3D &fs_info->free_space_cach=
e;
> +	u64 start =3D block_group->key.objectid;
> +	u64 end =3D start + block_group->key.offset;
> +
> +	if (cache && !block_group->cached) {
> +		block_group->cached =3D 1;
> +		clear_extent_dirty(free_space_cache, start, end - 1);
> +	}
> +
> +	if (!cache && block_group->cached) {
> +		block_group->cached =3D 0;
> +		clear_extent_dirty(free_space_cache, start, end - 1);
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Modify block groups which have @flags unfree in free space cache.
> + *
> + * @cache: if 0, clear block groups cache state;
> + *         not 0, mark blocks groups cached.

The naming of the function and the @cache parameter is quite confusing.

And so is the later usage of the function.
It's used by both marking all block groups full and revert the full mark
as cleanup.


I would call the function mark_block_groups_full() to do the full
marking thing, without the extra @cache parameter.

And another function to clear_block_groups_full() to make them into back
to normal status.

Thanks,
Qu
> + */
> +static int modify_block_groups_cache(struct btrfs_fs_info *fs_info, u6=
4 flags,
> +				     int cache)
> +{
> +	struct btrfs_root *root =3D fs_info->extent_root;
> +	struct btrfs_key key;
> +	struct btrfs_path path;
> +	struct btrfs_block_group_cache *bg_cache;
> +	struct btrfs_block_group_item *bi;
> +	struct btrfs_block_group_item bg_item;
> +	struct extent_buffer *eb;
> +	int slot;
> +	int ret;
> +
> +	key.objectid =3D 0;
> +	key.type =3D BTRFS_BLOCK_GROUP_ITEM_KEY;
> +	key.offset =3D 0;
> +
> +	btrfs_init_path(&path);
> +	ret =3D btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> +	if (ret < 0) {
> +		error("fail to search block groups due to %s", strerror(-ret));
> +		goto out;
> +	}
> +
> +	while (1) {
> +		eb =3D path.nodes[0];
> +		slot =3D path.slots[0];
> +		btrfs_item_key_to_cpu(eb, &key, slot);
> +		bg_cache =3D btrfs_lookup_block_group(fs_info, key.objectid);
> +		if (!bg_cache) {
> +			ret =3D -ENOENT;
> +			goto out;
> +		}
> +
> +		bi =3D btrfs_item_ptr(eb, slot, struct btrfs_block_group_item);
> +		read_extent_buffer(eb, &bg_item, (unsigned long)bi,
> +				   sizeof(bg_item));
> +		if (btrfs_block_group_flags(&bg_item) & flags)
> +			modify_block_group_cache(fs_info, bg_cache, cache);
> +
> +		ret =3D btrfs_next_item(root, &path);
> +		if (ret > 0) {
> +			ret =3D 0;
> +			goto out;
> +		}
> +		if (ret < 0)
> +			goto out;
> +	}
> +
> +out:
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> +
>  static int check_extent_refs(struct btrfs_root *root,
>  			     struct cache_tree *extent_cache)
>  {
>=20


--tL0lbtOSpJKZ5skTcTHBOGrs0GMEvqDEp--

--bxlFtBJ1Fo7L9O5bUN6mjNn1zrFkieEG4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo593AXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhIZAgAheeynfH0F4E5RG1ArFcztzjX
5Na/oQAAO8aWQfc5n7yjGTfirPd4LaymYlCCI+/8MitPWCIUkQ0XiR9F5K94mRB1
Co0dWvNtDYPgLZPFAAD9lKYMORGq1uj0743xxPPRBIp5XYqcEJf3lr5e3MRddQui
0zRS9iytpA3WLft88ThTFjTg1sSxTmIY2nMFw2Ikiu8c4LzxQNzUus0SRIP27Z5V
u96at/8ZVy7E0y7PgYwnKvF8HXx9EDte/MwDdnVEUIg3lhsdmdCi8oBtTB0pv7XE
fpqnfc028/FmoOCPSA1UfyxAqzfH3LJkI4t0nJyQ0F3y8uQyen1VLq5iMzbQhg==
=QxeQ
-----END PGP SIGNATURE-----

--bxlFtBJ1Fo7L9O5bUN6mjNn1zrFkieEG4--
