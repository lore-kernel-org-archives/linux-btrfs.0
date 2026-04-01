Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AEE44D039
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 14:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775053518; cv=none; b=E663Z19BaYv48ry5YFB6kyTX57fbvu8rzeFNPmd8jcOan48mCIU+4thmVWJFcTvi+94/sZg4v4mvgDbsWQScJiToUNRBeb9yx9iNK+iYX5Rx0vgdWLoIKaULvPOt8uBSCjI7fezI0P9VOsKC4lFcT6xkTFsdjJaTtLWQlpWFtYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775053518; c=relaxed/simple;
	bh=daX1ZDkDHmi+cXIRYFZogSRLxj6kMU5m/RQ301KeWkM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oGqV/1N1gFqeJU/Ue2n6TuQW2hf/QODHpzIqi/fGz3CfC9J4U0VJnqxEyw4fwPC4hbX4CdWoRwKnITHLoY2NTXFSnlbuMvVWPKhekoP+MQg+RNTVxfEojvBBARuwZwxRAv5/G1WuTKiPH4H0uRcWNuLTLDC6U1DX+T/LXTxokRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kg/81kp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kg/81kp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D3FC4AF0B
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 14:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775053518;
	bh=daX1ZDkDHmi+cXIRYFZogSRLxj6kMU5m/RQ301KeWkM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Kg/81kp8qumy93Y7pdyHcgLUsSkbGi0HSRvBvh75dZzcDS4G5+M7IzVejzejv08cb
	 OOltXBgp4EiLSRzTeP7rdI+LO11KY8F4Ao01M22MFmHWn8JcqcfnT1jJBijDjSGmpi
	 xYzpJnFCVQ7CrbFgtLx2Ml2tqhPd6xPMohvoS33OX1OgPALN6dBan4fbAD5rbrJcB/
	 wuhHntQIyaPktlfWWqGKmnBtCysOPAC84pinMDpGyOD9yPu6yzvLUUpSiHw2NSRgd3
	 /Hydb1oZlwUUmdJm6KQkGBy5+140jOdcwKt0ut6rWPi4uJDA6GpRO2NiyvDFtVS3OR
	 fCL2HEQCzfu1g==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b97ba4c2be2so958622066b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 07:25:18 -0700 (PDT)
X-Gm-Message-State: AOJu0YxvXf+gJgBZCpS6ovC4ognI18hBGbGHN4+pfh4z8pFfUBq3nbuh
	MbqeNoFkXk2eLI+YGLQhu7tFkoI//dn13mZ4uOIAExwjNtmTtP3XtaKp3k7Q2cUJ2z1ZohnlQx5
	fjK7M08dJBGl+wbwXDfROCJtgAi/XGCM=
X-Received: by 2002:a17:906:9b4e:b0:b97:f2b3:49b8 with SMTP id
 a640c23a62f3a-b9c13c95949mr209835566b.47.1775053516720; Wed, 01 Apr 2026
 07:25:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260331223659.2098718-1-dsterba@suse.com>
In-Reply-To: <20260331223659.2098718-1-dsterba@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 1 Apr 2026 15:24:39 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7CVWM_WSafttqhn8x-q3iUFxOGaipZExuchZH73SP9Fg@mail.gmail.com>
X-Gm-Features: AQROBzBfWjplQr94KgPiDDw0whUk_ZzNISBuqdhynnGelOutuor9lC7XnKMz43g
Message-ID: <CAL3q7H7CVWM_WSafttqhn8x-q3iUFxOGaipZExuchZH73SP9Fg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: make more ASSERTs verbose, part 3
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2026 at 11:37=E2=80=AFPM David Sterba <dsterba@suse.com> wr=
ote:
>
> We have support for optional string to be printed in ASSERT() (added in
> 19468a623a9109 ("btrfs: enhance ASSERT() to take optional format
> string")), it's not yet everywhere it could be so add a few more files.
>
> Try to finish what was left after 1c094e6ccead7a ("btrfs: make a few
> more ASSERTs verbose").
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/backref.c          |  4 ++--
>  fs/btrfs/extent-tree.c      | 14 +++++++++-----
>  fs/btrfs/extent_map.c       |  6 +++---
>  fs/btrfs/fiemap.c           |  2 +-
>  fs/btrfs/file-item.c        |  4 +++-
>  fs/btrfs/file.c             | 10 +++++++---
>  fs/btrfs/ioctl.c            |  3 ++-
>  fs/btrfs/ordered-data.c     | 12 +++++++-----
>  fs/btrfs/raid-stripe-tree.c |  7 +++++--
>  fs/btrfs/reflink.c          |  5 +++--
>  10 files changed, 42 insertions(+), 25 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 273924ca912c2f..2c25e5d86f3e42 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -2367,7 +2367,7 @@ int tree_backref_for_extent(unsigned long *ptr, str=
uct extent_buffer *eb,
>                 info =3D (struct btrfs_tree_block_info *)(ei + 1);
>                 *out_level =3D btrfs_tree_block_level(eb, info);
>         } else {
> -               ASSERT(key->type =3D=3D BTRFS_METADATA_ITEM_KEY);
> +               ASSERT(key->type =3D=3D BTRFS_METADATA_ITEM_KEY, "key->ty=
pe=3D%hhu", key->type);
>                 *out_level =3D (u8)key->offset;
>         }
>
> @@ -3199,7 +3199,7 @@ static int handle_direct_tree_backref(struct btrfs_=
backref_cache *cache,
>         struct btrfs_backref_node *upper;
>         struct rb_node *rb_node;
>
> -       ASSERT(ref_key->type =3D=3D BTRFS_SHARED_BLOCK_REF_KEY);
> +       ASSERT(ref_key->type =3D=3D BTRFS_SHARED_BLOCK_REF_KEY, "ref_key-=
>type=3D%hhu", ref_key->type);
>
>         /* Only reloc root uses backref pointing to itself */
>         if (ref_key->objectid =3D=3D ref_key->offset) {
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 391fad41c3b6d9..a097ed8518645e 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -385,7 +385,7 @@ int btrfs_get_extent_inline_ref_type(const struct ext=
ent_buffer *eb,
>                                         return type;
>                         }
>                 } else {
> -                       ASSERT(is_data =3D=3D BTRFS_REF_TYPE_ANY);
> +                       ASSERT(is_data =3D=3D BTRFS_REF_TYPE_ANY, "is_dat=
a=3D%d", is_data);
>                         return type;
>                 }
>         }
> @@ -2531,8 +2531,10 @@ int btrfs_cross_ref_exist(struct btrfs_inode *inod=
e, u64 offset,
>                                 struct btrfs_key key;
>
>                                 btrfs_item_key_to_cpu(leaf, &key, path->s=
lots[0]);
> -                               ASSERT(key.objectid =3D=3D bytenr);
> -                               ASSERT(key.type =3D=3D BTRFS_EXTENT_ITEM_=
KEY);
> +                               ASSERT(key.objectid =3D=3D bytenr, "key.o=
bjectid=3D%llu",
> +                                      key.objectid);

Just printing the key.objectid is not enough to debug anything, need
to print the bytenr variable too.

> +                               ASSERT(key.type =3D=3D BTRFS_EXTENT_ITEM_=
KEY, "key.type=3D%u",
> +                                      key.type);
>                         }
>                 }
>
> @@ -4598,10 +4600,12 @@ static noinline int find_free_extent(struct btrfs=
_root *root,
>                 /* Use dedicated sub-space_info for dedicated block group=
 users. */
>                 if (ffe_ctl->for_data_reloc) {
>                         space_info =3D space_info->sub_group[0];
> -                       ASSERT(space_info->subgroup_id =3D=3D BTRFS_SUB_G=
ROUP_DATA_RELOC);
> +                       ASSERT(space_info->subgroup_id =3D=3D BTRFS_SUB_G=
ROUP_DATA_RELOC,
> +                              "space_info->subgroup_id=3D%d", space_info=
->subgroup_id);
>                 } else if (ffe_ctl->for_treelog) {
>                         space_info =3D space_info->sub_group[0];
> -                       ASSERT(space_info->subgroup_id =3D=3D BTRFS_SUB_G=
ROUP_TREELOG);
> +                       ASSERT(space_info->subgroup_id =3D=3D BTRFS_SUB_G=
ROUP_TREELOG,
> +                              "space_info->subgroup_id=3D%d", space_info=
->subgroup_id);
>                 }
>         }
>         if (!space_info) {
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 095a561d733f0c..93a0950293a335 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -717,7 +717,7 @@ int btrfs_add_extent_mapping(struct btrfs_inode *inod=
e,
>          * file offset. Here just do a sanity check.
>          */
>         if (em->disk_bytenr =3D=3D EXTENT_MAP_INLINE)
> -               ASSERT(em->start =3D=3D 0);
> +               ASSERT(em->start =3D=3D 0, "em->start=3D%llu", em->start)=
;
>
>         ret =3D add_extent_mapping(inode, em, false);
>         /* it is possible that someone inserted the extent into the tree
> @@ -761,7 +761,7 @@ int btrfs_add_extent_mapping(struct btrfs_inode *inod=
e,
>                 }
>         }
>
> -       ASSERT(ret =3D=3D 0 || ret =3D=3D -EEXIST);
> +       ASSERT(ret =3D=3D 0 || ret =3D=3D -EEXIST, "ret=3D%d", ret);
>         return ret;
>  }
>
> @@ -943,7 +943,7 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *=
inode, u64 start, u64 end,
>
>                                 ret =3D add_extent_mapping(inode, split, =
modified);
>                                 /* Logic error, shouldn't happen. */
> -                               ASSERT(ret =3D=3D 0);
> +                               ASSERT(ret =3D=3D 0, "ret=3D%d", ret);
>                                 if (WARN_ON(ret !=3D 0) && modified)
>                                         btrfs_set_inode_full_sync(inode);
>                         }
> diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
> index 27d361c7adc4d8..6263e837093e42 100644
> --- a/fs/btrfs/fiemap.c
> +++ b/fs/btrfs/fiemap.c
> @@ -112,7 +112,7 @@ static int emit_fiemap_extent(struct fiemap_extent_in=
fo *fieinfo,
>         u64 cache_end;
>
>         /* Set at the end of extent_fiemap(). */
> -       ASSERT((flags & FIEMAP_EXTENT_LAST) =3D=3D 0);
> +       ASSERT((flags & FIEMAP_EXTENT_LAST) =3D=3D 0, "flags=3D0x%u", fla=
gs);
>
>         if (!cache->cached)
>                 goto assign;
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index d72249390030f4..82ae4a2afd3471 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -325,7 +325,9 @@ static int search_csum_tree(struct btrfs_fs_info *fs_=
info,
>
>         csum_start =3D key.offset;
>         csum_len =3D (itemsize / csum_size) * sectorsize;
> -       ASSERT(in_range(disk_bytenr, csum_start, csum_len));
> +       ASSERT(in_range(disk_bytenr, csum_start, csum_len),
> +              "disk_bytenr=3D%llu csum_start=3D%llu csum_len=3D%llu",
> +              disk_bytenr, csum_start, csum_len);
>
>  found:
>         ret =3D (min(csum_start + csum_len, disk_bytenr + len) -
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 06cc6e13cb621f..00318b9e5675d4 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1227,8 +1227,11 @@ static int copy_one_range(struct btrfs_inode *inod=
e, struct iov_iter *iter,
>                 return ret;
>         reserved_len =3D ret;
>         /* Write range must be inside the reserved range. */
> -       ASSERT(reserved_start <=3D start);
> -       ASSERT(start + write_bytes <=3D reserved_start + reserved_len);
> +       ASSERT(reserved_start <=3D start, "reserved_start=3D%llu start=3D=
%llu",
> +              reserved_start, start);
> +       ASSERT(start + write_bytes <=3D reserved_start + reserved_len,
> +              "start=3D%llu write_bytes=3D%zu reserved_start=3D%llu rese=
rved_len=3D%llu",
> +              start, write_bytes, reserved_start, reserved_len);
>
>  again:
>         ret =3D balance_dirty_pages_ratelimited_flags(inode->vfs_inode.i_=
mapping,
> @@ -2335,7 +2338,8 @@ static int btrfs_insert_replace_extent(struct btrfs=
_trans_handle *trans,
>                             btrfs_item_ptr_offset(leaf, slot),
>                             sizeof(struct btrfs_file_extent_item));
>         extent =3D btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_it=
em);
> -       ASSERT(btrfs_file_extent_type(leaf, extent) !=3D BTRFS_FILE_EXTEN=
T_INLINE);
> +       ASSERT(btrfs_file_extent_type(leaf, extent) !=3D BTRFS_FILE_EXTEN=
T_INLINE,
> +              "file_extent_type=3D%u", btrfs_file_extent_type(leaf, exte=
nt));

There's no point printing the file extent type here, if the assertion
fails it's because it's an inline extent. This would only be useful if
we were asserting it's inline, not that it's not inline.

Thanks.

>         btrfs_set_file_extent_offset(leaf, extent, extent_info->data_offs=
et);
>         btrfs_set_file_extent_num_bytes(leaf, extent, replace_len);
>         if (extent_info->is_new_extent)
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b2e447f5005c16..312585d9e1cad0 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -5092,7 +5092,8 @@ static int btrfs_ioctl_subvol_sync(struct btrfs_fs_=
info *fs_info, void __user *a
>                         return -ENOENT;
>
>                 wait_for_deletion =3D true;
> -               ASSERT(root_flags & BTRFS_ROOT_SUBVOL_DEAD);
> +               ASSERT(root_flags & BTRFS_ROOT_SUBVOL_DEAD, "root_flags=
=3D0x%llx",
> +                      root_flags);
>                 sched_ret =3D schedule_timeout_interruptible(HZ);
>                 /* Early wake up or error. */
>                 if (sched_ret !=3D 0)
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index d39f1c49d1cf8f..8ebd046b79569d 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -157,7 +157,8 @@ static struct btrfs_ordered_extent *alloc_ordered_ext=
ent(
>                ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALL=
OC)));
>
>         /* Only one type flag can be set. */
> -       ASSERT(has_single_bit_set(flags & BTRFS_ORDERED_EXCLUSIVE_FLAGS))=
;
> +       ASSERT(has_single_bit_set(flags & BTRFS_ORDERED_EXCLUSIVE_FLAGS),
> +              "flags=3D0x%lx", flags);
>
>         /* DIRECT cannot be set with COMPRESSED nor ENCODED. */
>         if (test_bit(BTRFS_ORDERED_DIRECT, &flags)) {
> @@ -302,7 +303,7 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_exte=
nt(
>  {
>         struct btrfs_ordered_extent *entry;
>
> -       ASSERT((flags & ~BTRFS_ORDERED_TYPE_FLAGS) =3D=3D 0);
> +       ASSERT((flags & ~BTRFS_ORDERED_TYPE_FLAGS) =3D=3D 0, "flags=3D0x%=
lx", flags);
>
>         /*
>          * For regular writes, we just use the members in @file_extent.
> @@ -1238,7 +1239,7 @@ struct btrfs_ordered_extent *btrfs_split_ordered_ex=
tent(
>
>         trace_btrfs_ordered_extent_split(inode, ordered);
>
> -       ASSERT(!(flags & (1U << BTRFS_ORDERED_COMPRESSED)));
> +       ASSERT(!(flags & (1U << BTRFS_ORDERED_COMPRESSED)), "flags=3D0x%l=
x", flags);
>
>         /*
>          * The entire bio must be covered by the ordered extent, but we c=
an't
> @@ -1260,7 +1261,7 @@ struct btrfs_ordered_extent *btrfs_split_ordered_ex=
tent(
>         }
>         /* We cannot split partially completed ordered extents. */
>         if (ordered->bytes_left) {
> -               ASSERT(!(flags & ~BTRFS_ORDERED_TYPE_FLAGS));
> +               ASSERT(!(flags & ~BTRFS_ORDERED_TYPE_FLAGS), "flags=3D0x%=
lx", flags);
>                 if (WARN_ON_ONCE(ordered->bytes_left !=3D ordered->disk_n=
um_bytes))
>                         return ERR_PTR(-EINVAL);
>         }
> @@ -1307,7 +1308,8 @@ struct btrfs_ordered_extent *btrfs_split_ordered_ex=
tent(
>         ordered->ram_bytes -=3D len;
>
>         if (test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags)) {
> -               ASSERT(ordered->bytes_left =3D=3D 0);
> +               ASSERT(ordered->bytes_left =3D=3D 0, "ordered->bytes_left=
=3D%llu",
> +                      ordered->bytes_left);
>                 new->bytes_left =3D 0;
>         } else {
>                 ordered->bytes_left -=3D len;
> diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
> index 638c4ad572c996..03168f9c397e10 100644
> --- a/fs/btrfs/raid-stripe-tree.c
> +++ b/fs/btrfs/raid-stripe-tree.c
> @@ -139,7 +139,8 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handl=
e *trans, u64 start, u64 le
>                         btrfs_item_key_to_cpu(leaf, &key, slot);
>                         found_start =3D key.objectid;
>                         found_end =3D found_start + key.offset;
> -                       ASSERT(found_start <=3D start);
> +                       ASSERT(found_start <=3D start, "found_start=3D%ll=
u start=3D%llu",
> +                              found_start, start);
>                 }
>
>                 if (key.type !=3D BTRFS_RAID_STRIPE_KEY)
> @@ -239,7 +240,9 @@ int btrfs_delete_raid_extent(struct btrfs_trans_handl=
e *trans, u64 start, u64 le
>                         btrfs_partially_delete_raid_extent(trans, path, &=
key,
>                                                            key.offset - l=
ength,
>                                                            length);
> -                       ASSERT(key.offset - diff_end =3D=3D length);
> +                       ASSERT(key.offset - diff_end =3D=3D length,
> +                              "key.offset=3D%llu diff_end=3D%llu length=
=3D%llu",
> +                              key.offset, diff_end, length);
>                         break;
>                 }
>
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index 49865a46378091..1897816bf7f8db 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -69,7 +69,8 @@ static int copy_inline_to_page(struct btrfs_inode *inod=
e,
>         struct address_space *mapping =3D inode->vfs_inode.i_mapping;
>         int ret;
>
> -       ASSERT(IS_ALIGNED(file_offset, block_size));
> +       ASSERT(IS_ALIGNED(file_offset, block_size), "file_offset=3D%llu b=
lock_size=3D%u",
> +              file_offset, block_size);
>
>         /*
>          * We have flushed and locked the ranges of the source and destin=
ation
> @@ -459,7 +460,7 @@ static int btrfs_clone(struct inode *src, struct inod=
e *inode,
>                     key.objectid !=3D btrfs_ino(BTRFS_I(src)))
>                         break;
>
> -               ASSERT(key.type =3D=3D BTRFS_EXTENT_DATA_KEY);
> +               ASSERT(key.type =3D=3D BTRFS_EXTENT_DATA_KEY, "key.type=
=3D%u", key.type);
>
>                 extent =3D btrfs_item_ptr(leaf, slot,
>                                         struct btrfs_file_extent_item);
> --
> 2.53.0
>
>
