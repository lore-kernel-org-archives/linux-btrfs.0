Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39411 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752015AbcJESld (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Oct 2016 14:41:33 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 12456ACEA
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Oct 2016 18:41:30 +0000 (UTC)
Subject: Re: [PATCH] btrfs: opencode chunk locking, remove helpers
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20161005122306.3530-1-dsterba@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <50a2d25f-844b-651c-4d55-2a5ea66d178e@suse.com>
Date: Wed, 5 Oct 2016 14:41:24 -0400
MIME-Version: 1.0
In-Reply-To: <20161005122306.3530-1-dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="sNvFf8s2QEMAaV3ScK5pHMkksEqSox0Pm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sNvFf8s2QEMAaV3ScK5pHMkksEqSox0Pm
Content-Type: multipart/mixed; boundary="cCfT92GnAkwjIk5tPuc0vIQdUhduc9uld";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <50a2d25f-844b-651c-4d55-2a5ea66d178e@suse.com>
Subject: Re: [PATCH] btrfs: opencode chunk locking, remove helpers
References: <20161005122306.3530-1-dsterba@suse.com>
In-Reply-To: <20161005122306.3530-1-dsterba@suse.com>

--cCfT92GnAkwjIk5tPuc0vIQdUhduc9uld
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/5/16 8:23 AM, David Sterba wrote:
> The helpers are trivial and we don't use them consistently.

This one is going to conflict with the root->fs_info removal patchset in
every chunk since the helper does nothing with the root.  Otherwise, the
idea is sound.

-Jeff

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/disk-io.c          |  4 +--
>  fs/btrfs/extent-tree.c      |  8 +++---
>  fs/btrfs/free-space-cache.c |  4 +--
>  fs/btrfs/volumes.c          | 70 ++++++++++++++++++++++---------------=
--------
>  fs/btrfs/volumes.h          | 10 -------
>  5 files changed, 43 insertions(+), 53 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 54bc8c7c6bcd..6091663a9ed3 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3989,7 +3989,7 @@ void close_ctree(struct btrfs_root *root)
>  	__btrfs_free_block_rsv(root->orphan_block_rsv);
>  	root->orphan_block_rsv =3D NULL;
> =20
> -	lock_chunks(root);
> +	mutex_lock(&fs_info->chunk_mutex);
>  	while (!list_empty(&fs_info->pinned_chunks)) {
>  		struct extent_map *em;
> =20
> @@ -3998,7 +3998,7 @@ void close_ctree(struct btrfs_root *root)
>  		list_del_init(&em->list);
>  		free_extent_map(em);
>  	}
> -	unlock_chunks(root);
> +	mutex_unlock(&fs_info->chunk_mutex);
>  }
> =20
>  int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transi=
d,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 665da8f66ff1..00e5655cfd84 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9617,9 +9617,9 @@ int btrfs_inc_block_group_ro(struct btrfs_root *r=
oot,
>  out:
>  	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
>  		alloc_flags =3D update_block_group_flags(root, cache->flags);
> -		lock_chunks(root->fs_info->chunk_root);
> +		mutex_lock(&root->fs_info->chunk_mutex);
>  		check_system_chunk(trans, root, alloc_flags);
> -		unlock_chunks(root->fs_info->chunk_root);
> +		mutex_unlock(&root->fs_info->chunk_mutex);
>  	}
>  	mutex_unlock(&root->fs_info->ro_block_group_mutex);
> =20
> @@ -10647,7 +10647,7 @@ int btrfs_remove_block_group(struct btrfs_trans=
_handle *trans,
> =20
>  	memcpy(&key, &block_group->key, sizeof(key));
> =20
> -	lock_chunks(root);
> +	mutex_lock(&root->fs_info->chunk_mutex);
>  	if (!list_empty(&em->list)) {
>  		/* We're in the transaction->pending_chunks list. */
>  		free_extent_map(em);
> @@ -10715,7 +10715,7 @@ int btrfs_remove_block_group(struct btrfs_trans=
_handle *trans,
>  		free_extent_map(em);
>  	}
> =20
> -	unlock_chunks(root);
> +	mutex_unlock(&root->fs_info->chunk_mutex);
> =20
>  	ret =3D remove_block_group_free_space(trans, root->fs_info, block_gro=
up);
>  	if (ret)
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index d571bd2b697b..0e33d3d84870 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -3328,7 +3328,7 @@ void btrfs_put_block_group_trimming(struct btrfs_=
block_group_cache *block_group)
>  	spin_unlock(&block_group->lock);
> =20
>  	if (cleanup) {
> -		lock_chunks(block_group->fs_info->chunk_root);
> +		mutex_lock(&block_group->fs_info->chunk_mutex);
>  		em_tree =3D &block_group->fs_info->mapping_tree.map_tree;
>  		write_lock(&em_tree->lock);
>  		em =3D lookup_extent_mapping(em_tree, block_group->key.objectid,
> @@ -3340,7 +3340,7 @@ void btrfs_put_block_group_trimming(struct btrfs_=
block_group_cache *block_group)
>  		 */
>  		remove_extent_mapping(em_tree, em);
>  		write_unlock(&em_tree->lock);
> -		unlock_chunks(block_group->fs_info->chunk_root);
> +		mutex_unlock(&block_group->fs_info->chunk_mutex);
> =20
>  		/* once for us and once for the tree */
>  		free_extent_map(em);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 035efce603a9..cc31b39160be 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1878,10 +1878,10 @@ int btrfs_rm_device(struct btrfs_root *root, ch=
ar *device_path, u64 devid)
>  	}
> =20
>  	if (device->writeable) {
> -		lock_chunks(root);
> +		mutex_lock(&root->fs_info->chunk_mutex);
>  		list_del_init(&device->dev_alloc_list);
>  		device->fs_devices->rw_devices--;
> -		unlock_chunks(root);
> +		mutex_unlock(&root->fs_info->chunk_mutex);
>  		dev_name =3D kstrdup(device->name->str, GFP_KERNEL);
>  		if (!dev_name) {
>  			ret =3D -ENOMEM;
> @@ -1985,11 +1985,11 @@ int btrfs_rm_device(struct btrfs_root *root, ch=
ar *device_path, u64 devid)
> =20
>  error_undo:
>  	if (device->writeable) {
> -		lock_chunks(root);
> +		mutex_lock(&root->fs_info->chunk_mutex);
>  		list_add(&device->dev_alloc_list,
>  			 &root->fs_info->fs_devices->alloc_list);
>  		device->fs_devices->rw_devices++;
> -		unlock_chunks(root);
> +		mutex_unlock(&root->fs_info->chunk_mutex);
>  	}
>  	goto out;
>  }
> @@ -2216,9 +2216,9 @@ static int btrfs_prepare_sprout(struct btrfs_root=
 *root)
>  	list_for_each_entry(device, &seed_devices->devices, dev_list)
>  		device->fs_devices =3D seed_devices;
> =20
> -	lock_chunks(root);
> +	mutex_lock(&root->fs_info->chunk_mutex);
>  	list_splice_init(&fs_devices->alloc_list, &seed_devices->alloc_list);=

> -	unlock_chunks(root);
> +	mutex_unlock(&root->fs_info->chunk_mutex);
> =20
>  	fs_devices->seeding =3D 0;
>  	fs_devices->num_devices =3D 0;
> @@ -2407,7 +2407,7 @@ int btrfs_init_new_device(struct btrfs_root *root=
, char *device_path)
>  	device->fs_devices =3D root->fs_info->fs_devices;
> =20
>  	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
> -	lock_chunks(root);
> +	mutex_lock(&root->fs_info->chunk_mutex);
>  	list_add_rcu(&device->dev_list, &root->fs_info->fs_devices->devices);=

>  	list_add(&device->dev_alloc_list,
>  		 &root->fs_info->fs_devices->alloc_list);
> @@ -2441,13 +2441,13 @@ int btrfs_init_new_device(struct btrfs_root *ro=
ot, char *device_path)
>  	 */
>  	btrfs_clear_space_info_full(root->fs_info);
> =20
> -	unlock_chunks(root);
> +	mutex_unlock(&root->fs_info->chunk_mutex);
>  	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
> =20
>  	if (seeding_dev) {
> -		lock_chunks(root);
> +		mutex_lock(&root->fs_info->chunk_mutex);
>  		ret =3D init_first_rw_device(trans, root, device);
> -		unlock_chunks(root);
> +		mutex_unlock(&root->fs_info->chunk_mutex);
>  		if (ret) {
>  			btrfs_abort_transaction(trans, ret);
>  			goto error_trans;
> @@ -2691,13 +2691,13 @@ int btrfs_grow_device(struct btrfs_trans_handle=
 *trans,
>  	if (!device->writeable)
>  		return -EACCES;
> =20
> -	lock_chunks(device->dev_root);
> +	mutex_lock(&device->dev_root->fs_info->chunk_mutex);
>  	old_total =3D btrfs_super_total_bytes(super_copy);
>  	diff =3D new_size - device->total_bytes;
> =20
>  	if (new_size <=3D device->total_bytes ||
>  	    device->is_tgtdev_for_dev_replace) {
> -		unlock_chunks(device->dev_root);
> +		mutex_unlock(&device->dev_root->fs_info->chunk_mutex);
>  		return -EINVAL;
>  	}
> =20
> @@ -2712,7 +2712,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *=
trans,
>  	if (list_empty(&device->resized_list))
>  		list_add_tail(&device->resized_list,
>  			      &fs_devices->resized_devices);
> -	unlock_chunks(device->dev_root);
> +	mutex_unlock(&device->dev_root->fs_info->chunk_mutex);
> =20
>  	return btrfs_update_device(trans, device);
>  }
> @@ -2767,7 +2767,7 @@ static int btrfs_del_sys_chunk(struct btrfs_root =
*root, u64 chunk_objectid, u64
>  	u32 cur;
>  	struct btrfs_key key;
> =20
> -	lock_chunks(root);
> +	mutex_lock(&root->fs_info->chunk_mutex);
>  	array_size =3D btrfs_super_sys_array_size(super_copy);
> =20
>  	ptr =3D super_copy->sys_chunk_array;
> @@ -2797,7 +2797,7 @@ static int btrfs_del_sys_chunk(struct btrfs_root =
*root, u64 chunk_objectid, u64
>  			cur +=3D len;
>  		}
>  	}
> -	unlock_chunks(root);
> +	mutex_unlock(&root->fs_info->chunk_mutex);
>  	return ret;
>  }
> =20
> @@ -2834,9 +2834,9 @@ int btrfs_remove_chunk(struct btrfs_trans_handle =
*trans,
>  		return -EINVAL;
>  	}
>  	map =3D em->map_lookup;
> -	lock_chunks(root->fs_info->chunk_root);
> +	mutex_lock(&root->fs_info->chunk_mutex);
>  	check_system_chunk(trans, extent_root, map->type);
> -	unlock_chunks(root->fs_info->chunk_root);
> +	mutex_unlock(&root->fs_info->chunk_mutex);
> =20
>  	/*
>  	 * Take the device list mutex to prevent races with the final phase o=
f
> @@ -2856,14 +2856,14 @@ int btrfs_remove_chunk(struct btrfs_trans_handl=
e *trans,
>  		}
> =20
>  		if (device->bytes_used > 0) {
> -			lock_chunks(root);
> +			mutex_lock(&root->fs_info->chunk_mutex);
>  			btrfs_device_set_bytes_used(device,
>  					device->bytes_used - dev_extent_len);
>  			spin_lock(&root->fs_info->free_chunk_lock);
>  			root->fs_info->free_chunk_space +=3D dev_extent_len;
>  			spin_unlock(&root->fs_info->free_chunk_lock);
>  			btrfs_clear_space_info_full(root->fs_info);
> -			unlock_chunks(root);
> +			mutex_unlock(&root->fs_info->chunk_mutex);
>  		}
> =20
>  		if (map->stripes[i].dev) {
> @@ -4383,7 +4383,7 @@ int btrfs_shrink_device(struct btrfs_device *devi=
ce, u64 new_size)
> =20
>  	path->reada =3D READA_FORWARD;
> =20
> -	lock_chunks(root);
> +	mutex_lock(&root->fs_info->chunk_mutex);
> =20
>  	btrfs_device_set_total_bytes(device, new_size);
>  	if (device->writeable) {
> @@ -4392,7 +4392,7 @@ int btrfs_shrink_device(struct btrfs_device *devi=
ce, u64 new_size)
>  		root->fs_info->free_chunk_space -=3D diff;
>  		spin_unlock(&root->fs_info->free_chunk_lock);
>  	}
> -	unlock_chunks(root);
> +	mutex_unlock(&root->fs_info->chunk_mutex);
> =20
>  again:
>  	key.objectid =3D device->devid;
> @@ -4464,7 +4464,7 @@ int btrfs_shrink_device(struct btrfs_device *devi=
ce, u64 new_size)
>  		goto done;
>  	}
> =20
> -	lock_chunks(root);
> +	mutex_lock(&root->fs_info->chunk_mutex);
> =20
>  	/*
>  	 * We checked in the above loop all device extents that were already =
in
> @@ -4484,7 +4484,7 @@ int btrfs_shrink_device(struct btrfs_device *devi=
ce, u64 new_size)
> =20
>  		if (contains_pending_extent(trans->transaction, device,
>  					    &start, len)) {
> -			unlock_chunks(root);
> +			mutex_unlock(&root->fs_info->chunk_mutex);
>  			checked_pending_chunks =3D true;
>  			failed =3D 0;
>  			retried =3D false;
> @@ -4502,7 +4502,7 @@ int btrfs_shrink_device(struct btrfs_device *devi=
ce, u64 new_size)
> =20
>  	WARN_ON(diff > old_total);
>  	btrfs_set_super_total_bytes(super_copy, old_total - diff);
> -	unlock_chunks(root);
> +	mutex_unlock(&root->fs_info->chunk_mutex);
> =20
>  	/* Now btrfs_update_device() will change the on-disk size. */
>  	ret =3D btrfs_update_device(trans, device);
> @@ -4510,14 +4510,14 @@ int btrfs_shrink_device(struct btrfs_device *de=
vice, u64 new_size)
>  done:
>  	btrfs_free_path(path);
>  	if (ret) {
> -		lock_chunks(root);
> +		mutex_lock(&root->fs_info->chunk_mutex);
>  		btrfs_device_set_total_bytes(device, old_size);
>  		if (device->writeable)
>  			device->fs_devices->total_rw_bytes +=3D diff;
>  		spin_lock(&root->fs_info->free_chunk_lock);
>  		root->fs_info->free_chunk_space +=3D diff;
>  		spin_unlock(&root->fs_info->free_chunk_lock);
> -		unlock_chunks(root);
> +		mutex_unlock(&root->fs_info->chunk_mutex);
>  	}
>  	return ret;
>  }
> @@ -4531,11 +4531,11 @@ static int btrfs_add_system_chunk(struct btrfs_=
root *root,
>  	u32 array_size;
>  	u8 *ptr;
> =20
> -	lock_chunks(root);
> +	mutex_lock(&root->fs_info->chunk_mutex);
>  	array_size =3D btrfs_super_sys_array_size(super_copy);
>  	if (array_size + item_size + sizeof(disk_key)
>  			> BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
> -		unlock_chunks(root);
> +		mutex_unlock(&root->fs_info->chunk_mutex);
>  		return -EFBIG;
>  	}
> =20
> @@ -4546,7 +4546,7 @@ static int btrfs_add_system_chunk(struct btrfs_ro=
ot *root,
>  	memcpy(ptr, chunk, item_size);
>  	item_size +=3D sizeof(disk_key);
>  	btrfs_set_super_sys_array_size(super_copy, array_size + item_size);
> -	unlock_chunks(root);
> +	mutex_unlock(&root->fs_info->chunk_mutex);
> =20
>  	return 0;
>  }
> @@ -6795,7 +6795,7 @@ int btrfs_read_chunk_tree(struct btrfs_root *root=
)
>  		return -ENOMEM;
> =20
>  	mutex_lock(&uuid_mutex);
> -	lock_chunks(root);
> +	mutex_lock(&root->fs_info->chunk_mutex);
> =20
>  	/*
>  	 * Read all device items, and then all the chunk items. All
> @@ -6862,7 +6862,7 @@ int btrfs_read_chunk_tree(struct btrfs_root *root=
)
>  	}
>  	ret =3D 0;
>  error:
> -	unlock_chunks(root);
> +	mutex_unlock(&root->fs_info->chunk_mutex);
>  	mutex_unlock(&uuid_mutex);
> =20
>  	btrfs_free_path(path);
> @@ -7161,13 +7161,13 @@ void btrfs_update_commit_device_size(struct btr=
fs_fs_info *fs_info)
>  		return;
> =20
>  	mutex_lock(&fs_devices->device_list_mutex);
> -	lock_chunks(fs_info->dev_root);
> +	mutex_lock(&fs_info->dev_root->fs_info->chunk_mutex);
>  	list_for_each_entry_safe(curr, next, &fs_devices->resized_devices,
>  				 resized_list) {
>  		list_del_init(&curr->resized_list);
>  		curr->commit_total_bytes =3D curr->disk_total_bytes;
>  	}
> -	unlock_chunks(fs_info->dev_root);
> +	mutex_unlock(&fs_info->dev_root->fs_info->chunk_mutex);
>  	mutex_unlock(&fs_devices->device_list_mutex);
>  }
> =20
> @@ -7184,7 +7184,7 @@ void btrfs_update_commit_device_bytes_used(struct=
 btrfs_root *root,
>  		return;
> =20
>  	/* In order to kick the device replace finish process */
> -	lock_chunks(root);
> +	mutex_lock(&root->fs_info->chunk_mutex);
>  	list_for_each_entry(em, &transaction->pending_chunks, list) {
>  		map =3D em->map_lookup;
> =20
> @@ -7193,7 +7193,7 @@ void btrfs_update_commit_device_bytes_used(struct=
 btrfs_root *root,
>  			dev->commit_bytes_used =3D dev->bytes_used;
>  		}
>  	}
> -	unlock_chunks(root);
> +	mutex_unlock(&root->fs_info->chunk_mutex);
>  }
> =20
>  void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info)
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 6613e6335ca2..6f9422013715 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -512,16 +512,6 @@ void btrfs_update_commit_device_size(struct btrfs_=
fs_info *fs_info);
>  void btrfs_update_commit_device_bytes_used(struct btrfs_root *root,
>  					struct btrfs_transaction *transaction);
> =20
> -static inline void lock_chunks(struct btrfs_root *root)
> -{
> -	mutex_lock(&root->fs_info->chunk_mutex);
> -}
> -
> -static inline void unlock_chunks(struct btrfs_root *root)
> -{
> -	mutex_unlock(&root->fs_info->chunk_mutex);
> -}
> -
>  struct list_head *btrfs_get_fs_uuids(void);
>  void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
>  void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
>=20


--=20
Jeff Mahoney
SUSE Labs


--cCfT92GnAkwjIk5tPuc0vIQdUhduc9uld--

--sNvFf8s2QEMAaV3ScK5pHMkksEqSox0Pm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX9UlYAAoJEB57S2MheeWynKMQAJtJtzlHCggL6jCn7rze/yQD
UiONKCIT64nj3wkmQkJAWdW+zLLdV2eCdqjYoN7uc3LLBjHDH2pIBLvcLcQrdpE9
raP65j1+OWG9uh5dCUJXSfzv/ZugZrCvLT5lngUp/huUdwU55Ew8xOpi8KwOga+S
h1t84+3P9Oot3AGIcU3tkQGrznqW4+rdJtb7Kcl/+ZspjDjoLwhQKH/azKcVhLWX
mdHKLYtHMgNhsdXing2V7JAnmFndCf+7O8duLGT6jwb5mvVhZH78XfcCqNIVgmUW
2uSwD2Ne33P06hBmXQLEAHTC6x8bV1vpKeZBXp0SZbY7u+4NM2gCHfhuAqH70nu3
bxNUp2a67rAyaQDx68b5VVodOzkgOBbj5Kfm5S30yP2ABATbdhHxOxME+IFYi5fW
A3pf0Ipm8efS6B5GTFBcvxKOAKhfqQBKGYAuJASW7JmIAQyU3sQ7paszqK0b5Cw2
2mYo4mU78YzqQyMQEHTZCHJVQ38IPh7BXSkZ6Kf+5YLUar+MNEA5mmNXai52Msp4
o8OGUuhPlzD0bGu+WOH90UqwPq3Kfkd5f9ODiTVC8tP4ent9xTZ0m93ThQ6WIp/C
wYngtyD3RI51GThlpuJ7ZL5+tdOx8F2Uc8y/CH9dDLH2CUM7VjEudqdc6nqQT1xe
OJJYrTGyxlA/bbXCP4Ry
=7jpz
-----END PGP SIGNATURE-----

--sNvFf8s2QEMAaV3ScK5pHMkksEqSox0Pm--
