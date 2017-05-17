Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43796 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751713AbdEQNue (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 09:50:34 -0400
Subject: Re: [PATCH 1/2] btrfs: Separate space_info create/update
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com
References: <1494318859-7555-1-git-send-email-nborisov@suse.com>
 <1494318859-7555-2-git-send-email-nborisov@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <71ed70a8-b0b8-a93e-cee4-a914c00b1483@suse.com>
Date: Wed, 17 May 2017 09:50:30 -0400
MIME-Version: 1.0
In-Reply-To: <1494318859-7555-2-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UpVMIpFTk6LusuLDjSHpECuBD0nR8uNoW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UpVMIpFTk6LusuLDjSHpECuBD0nR8uNoW
Content-Type: multipart/mixed; boundary="VGll3CpilFx1Wb8hfUCLv2Bit0xK7qOrV";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com
Message-ID: <71ed70a8-b0b8-a93e-cee4-a914c00b1483@suse.com>
Subject: Re: [PATCH 1/2] btrfs: Separate space_info create/update
References: <1494318859-7555-1-git-send-email-nborisov@suse.com>
 <1494318859-7555-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1494318859-7555-2-git-send-email-nborisov@suse.com>

--VGll3CpilFx1Wb8hfUCLv2Bit0xK7qOrV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/9/17 4:34 AM, Nikolay Borisov wrote:
> Currently the struct space_info creation code is intermixed in the
> udpate_space_info function. There are well-defined points at which the =
we
> actually want to create brand-new space_info structs (e.g. during mount=
 of
> the filesystem as well as sometimes when adding/initialising new chunks=
). In
> such cases udpate_space_info is called with 0 as the bytes parameter. A=
ll of
> this makes for spaghetti code.
>=20
> Fix it by factoring out the creation code in a separate create_space_in=
fo
> structure. This also allows to simplify the internals. Furthermore it w=
ill
> make the update_space_info function not fail, allowing to remove error
> handling in callers. This will come in a follow up patch.
>=20
> This bears no functional changes
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 127 ++++++++++++++++++++++++-----------------=
--------
>  1 file changed, 62 insertions(+), 65 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index be5477676cc8..e71921d8c610 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3914,15 +3914,57 @@ static const char *alloc_name(u64 flags)
>  	};
>  }
> =20
> +static int create_space_info(struct btrfs_fs_info *info, u64 flags,
> +			     struct btrfs_space_info **new) {
> +
> +	struct btrfs_space_info *space_info;
> +	int i;
> +	int ret;
> +
> +	space_info =3D kzalloc(sizeof(*space_info), GFP_NOFS);
> +	if (!space_info)
> +		return -ENOMEM;
> +
> +	ret =3D percpu_counter_init(&space_info->total_bytes_pinned, 0, GFP_K=
ERNEL);
> +	if (ret) {
> +		kfree(space_info);
> +		return ret;
> +	}
> +
> +	for (i =3D 0; i < BTRFS_NR_RAID_TYPES; i++)
> +		INIT_LIST_HEAD(&space_info->block_groups[i]);
> +	init_rwsem(&space_info->groups_sem);
> +	spin_lock_init(&space_info->lock);
> +	space_info->flags =3D flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
> +	space_info->force_alloc =3D CHUNK_ALLOC_NO_FORCE;
> +	init_waitqueue_head(&space_info->wait);
> +	INIT_LIST_HEAD(&space_info->ro_bgs);
> +	INIT_LIST_HEAD(&space_info->tickets);
> +	INIT_LIST_HEAD(&space_info->priority_tickets);
> +
> +	ret =3D kobject_init_and_add(&space_info->kobj, &space_info_ktype,
> +				    info->space_info_kobj, "%s",
> +				    alloc_name(space_info->flags));
> +	if (ret) {

Not your bug (it's mine from 6ab0a2029c), but we need
percpu_counter_destroy here.  I just sent a patch to fix the original
case so we can pull it into stable as well.

> +		kfree(space_info);
> +		return ret;
> +	}
> +
> +	*new =3D space_info;
> +	list_add_rcu(&space_info->list, &info->space_info);
> +	if (flags & BTRFS_BLOCK_GROUP_DATA)
> +		info->data_sinfo =3D space_info;
> +
> +	return ret;
> +}
> +
>  static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>  			     u64 total_bytes, u64 bytes_used,
>  			     u64 bytes_readonly,
>  			     struct btrfs_space_info **space_info)
>  {
>  	struct btrfs_space_info *found;
> -	int i;
>  	int factor;
> -	int ret;
> =20
>  	if (flags & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
>  		     BTRFS_BLOCK_GROUP_RAID10))
> @@ -3946,53 +3988,6 @@ static int update_space_info(struct btrfs_fs_inf=
o *info, u64 flags,
>  		*space_info =3D found;
>  		return 0;
>  	}
> -	found =3D kzalloc(sizeof(*found), GFP_NOFS);
> -	if (!found)
> -		return -ENOMEM;
> -
> -	ret =3D percpu_counter_init(&found->total_bytes_pinned, 0, GFP_KERNEL=
);
> -	if (ret) {
> -		kfree(found);
> -		return ret;
> -	}
> -
> -	for (i =3D 0; i < BTRFS_NR_RAID_TYPES; i++)
> -		INIT_LIST_HEAD(&found->block_groups[i]);
> -	init_rwsem(&found->groups_sem);
> -	spin_lock_init(&found->lock);
> -	found->flags =3D flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
> -	found->total_bytes =3D total_bytes;
> -	found->disk_total =3D total_bytes * factor;
> -	found->bytes_used =3D bytes_used;
> -	found->disk_used =3D bytes_used * factor;
> -	found->bytes_pinned =3D 0;
> -	found->bytes_reserved =3D 0;
> -	found->bytes_readonly =3D bytes_readonly;
> -	found->bytes_may_use =3D 0;
> -	found->full =3D 0;
> -	found->max_extent_size =3D 0;
> -	found->force_alloc =3D CHUNK_ALLOC_NO_FORCE;
> -	found->chunk_alloc =3D 0;
> -	found->flush =3D 0;
> -	init_waitqueue_head(&found->wait);
> -	INIT_LIST_HEAD(&found->ro_bgs);
> -	INIT_LIST_HEAD(&found->tickets);
> -	INIT_LIST_HEAD(&found->priority_tickets);
> -
> -	ret =3D kobject_init_and_add(&found->kobj, &space_info_ktype,
> -				    info->space_info_kobj, "%s",
> -				    alloc_name(found->flags));
> -	if (ret) {
> -		kfree(found);
> -		return ret;
> -	}
> -
> -	*space_info =3D found;
> -	list_add_rcu(&found->list, &info->space_info);
> -	if (flags & BTRFS_BLOCK_GROUP_DATA)
> -		info->data_sinfo =3D found;
> -
> -	return ret;
>  }
> =20
>  static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 fl=
ags)
> @@ -4495,10 +4490,9 @@ static int do_chunk_alloc(struct btrfs_trans_han=
dle *trans,
> =20
>  	space_info =3D __find_space_info(fs_info, flags);
>  	if (!space_info) {
> -		ret =3D update_space_info(fs_info, flags, 0, 0, 0, &space_info);
> +		ret =3D create_space_info(fs_info, flags, &space_info);
>  		BUG_ON(ret); /* -ENOMEM */
>  	}
> -	BUG_ON(!space_info); /* Logic error */
> =20
>  again:
>  	spin_lock(&space_info->lock);
> @@ -5763,7 +5757,7 @@ int btrfs_orphan_reserve_metadata(struct btrfs_tr=
ans_handle *trans,
>  	 */
>  	u64 num_bytes =3D btrfs_calc_trans_metadata_size(fs_info, 1);
> =20
> -	trace_btrfs_space_reservation(fs_info, "orphan", btrfs_ino(inode),=20
> +	trace_btrfs_space_reservation(fs_info, "orphan", btrfs_ino(inode),
>  			num_bytes, 1);
>  	return btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
>  }
> @@ -10153,6 +10147,7 @@ int btrfs_make_block_group(struct btrfs_trans_h=
andle *trans,
>  	struct btrfs_block_group_cache *cache;
>  	int ret;
> =20
> +
>  	btrfs_set_log_full_commit(fs_info, trans);
> =20
>  	cache =3D btrfs_create_block_group_cache(fs_info, chunk_offset, size)=
;

Drop this chunk.

> @@ -10191,16 +10186,18 @@ int btrfs_make_block_group(struct btrfs_trans=
_handle *trans,
>  	}
>  #endif
>  	/*
> -	 * Call to ensure the corresponding space_info object is created and
> -	 * assigned to our block group, but don't update its counters just ye=
t.
> -	 * We want our bg to be added to the rbtree with its ->space_info set=
=2E
> +	 * Ensure the corresponding space_info object is created and
> +	 * assigned to our block group. We want our bg to be added to the rbt=
ree
> +	 * with its ->space_info set.
>  	 */
> -	ret =3D update_space_info(fs_info, cache->flags, 0, 0, 0,
> -				&cache->space_info);
> -	if (ret) {
> -		btrfs_remove_free_space_cache(cache);
> -		btrfs_put_block_group(cache);
> -		return ret;
> +	cache->space_info =3D __find_space_info(fs_info, cache->flags);
> +	if (!cache->space_info) {
> +		ret =3D create_space_info(fs_info, cache->flags, &cache->space_info)=
;
> +		if (ret) {
> +			btrfs_remove_free_space_cache(cache);
> +			btrfs_put_block_group(cache);
> +			return ret;
> +		}
>  	}
> =20
>  	ret =3D btrfs_add_block_group_cache(fs_info, cache);
> @@ -10774,21 +10771,21 @@ int btrfs_init_space_info(struct btrfs_fs_inf=
o *fs_info)
>  		mixed =3D 1;
> =20
>  	flags =3D BTRFS_BLOCK_GROUP_SYSTEM;
> -	ret =3D update_space_info(fs_info, flags, 0, 0, 0, &space_info);
> +	ret =3D create_space_info(fs_info, flags, &space_info);
>  	if (ret)
>  		goto out;
> =20
>  	if (mixed) {
>  		flags =3D BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA;
> -		ret =3D update_space_info(fs_info, flags, 0, 0, 0, &space_info);
> +		ret =3D create_space_info(fs_info, flags, &space_info);
>  	} else {
>  		flags =3D BTRFS_BLOCK_GROUP_METADATA;
> -		ret =3D update_space_info(fs_info, flags, 0, 0, 0, &space_info);
> +		ret =3D create_space_info(fs_info, flags, &space_info);
>  		if (ret)
>  			goto out;
> =20
>  		flags =3D BTRFS_BLOCK_GROUP_DATA;
> -		ret =3D update_space_info(fs_info, flags, 0, 0, 0, &space_info);
> +		ret =3D create_space_info(fs_info, flags, &space_info);
>  	}
>  out:
>  	return ret;
>=20

Reviewed-by: Jeff Mahoney <jeffm@suse.com>

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--VGll3CpilFx1Wb8hfUCLv2Bit0xK7qOrV--

--UpVMIpFTk6LusuLDjSHpECuBD0nR8uNoW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWRxVJh57S2MheeWyAQhGpA/+Mx5aoyMr0b2huVjVOwedJdnbxMiqEoPT
BEamMmG1pRK2GNIi5SijnjgsoGo2rCxqAIP44PT7YTiKg1RRnb9juzEzP2scwaAv
iMVNRnUCaaOw/CUyaXhwZgRSoN/fdg/18Lx/joQ7H1ldshiPOqb6c5C+3hV1TG6w
6pvurnmopFYH/xzzlDw2Kxbvys8pqasF3fwLyR/7FvLuzgfS79QKJ8LIiQBja5xo
/0lxgCz7lpn5HJP+FsEk1ehZKYHBcdoWjXPjW5BcBoDaOWXqWzq8LJzaMeUWIABC
mDFrwq8WbL0FjP4qIMnPsSJpp67K/HvQNkfTw0XDK5zwGYSiDKvJNeEoBTyQjBBV
9PYZsqGjT1Dw4pBeCQUwqinPVQ9FWq5IpqMwYXzQU5RcHLaNN3oXNoA6odnJ52eP
bTWXv+emSokElNtpniui5uRB5LH8vtbdIBzdDGRzbXqNaYKYL1qoBIaZel9ZJhaZ
m4wpQOqkiVuYWC+ehgavLjt1eja6QEtOaydDws4moc8sCSlZoD6wxkoC4dJdXps8
qsDc9E+Hz7jFb6646wHgHfiwpYGfWeq2riIYcYEx3f9cekg2xpkqvjAVKzqQqA7b
MZpkPU327QW4K0t6goFytQsKh2EAblL5iNmUjiYqAq4dPvW6edf0nA+0oPkkcfpO
empmBoSpKEY=
=9fa6
-----END PGP SIGNATURE-----

--UpVMIpFTk6LusuLDjSHpECuBD0nR8uNoW--
