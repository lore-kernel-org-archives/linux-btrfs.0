Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589FFC169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 13:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D7CD20818
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 13:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfBKNF5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 08:05:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:39738 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727182AbfBKNF5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 08:05:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E9C5EAECD
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 13:05:53 +0000 (UTC)
Subject: Re: [PATCH v3 8/9] btrfs: extent-tree: Use btrfs_ref to refactor
 btrfs_free_extent()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190211051653.3167-1-wqu@suse.com>
 <20190211051653.3167-9-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f8c23577-038f-c1c1-0c61-48f9b4e354af@suse.com>
Date:   Mon, 11 Feb 2019 15:05:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190211051653.3167-9-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11.02.19 г. 7:16 ч., Qu Wenruo wrote:
> Similar to btrfs_inc_extent_ref(), just use btrfs_ref to replace the
> long parameter list and the confusing @owner parameter.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>


> ---
>  fs/btrfs/ctree.h       |  5 +---
>  fs/btrfs/extent-tree.c | 52 +++++++++++++++++++-----------------------
>  fs/btrfs/file.c        | 22 ++++++++++--------
>  fs/btrfs/inode.c       | 13 +++++++----
>  fs/btrfs/relocation.c  | 25 ++++++++++++--------
>  5 files changed, 61 insertions(+), 56 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index cd90f7cbc8f2..84a20abd0811 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2744,10 +2744,7 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
>  				struct btrfs_fs_info *fs_info,
>  				u64 bytenr, u64 num_bytes, u64 flags,
>  				int level, int is_data);
> -int btrfs_free_extent(struct btrfs_trans_handle *trans,
> -		      struct btrfs_root *root,
> -		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
> -		      u64 owner, u64 offset);
> +int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_ref *ref);
>  
>  int btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info,
>  			       u64 start, u64 len, int delalloc);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index d08186ec6410..e2f34a8f5e91 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3290,9 +3290,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
>  			if (inc)
>  				ret = btrfs_inc_extent_ref(trans, &generic_ref);
>  			else
> -				ret = btrfs_free_extent(trans, root, bytenr,
> -						num_bytes, parent, ref_root,
> -						key.objectid, key.offset);
> +				ret = btrfs_free_extent(trans, &generic_ref);
>  			if (ret)
>  				goto fail;
>  		} else {
> @@ -3306,9 +3304,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
>  			if (inc)
>  				ret = btrfs_inc_extent_ref(trans, &generic_ref);
>  			else
> -				ret = btrfs_free_extent(trans, root, bytenr,
> -						num_bytes, parent, ref_root,
> -						level - 1, 0);
> +				ret = btrfs_free_extent(trans, &generic_ref);
>  			if (ret)
>  				goto fail;
>  		}
> @@ -7340,47 +7336,43 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>  }
>  
>  /* Can return -ENOMEM */
> -int btrfs_free_extent(struct btrfs_trans_handle *trans,
> -		      struct btrfs_root *root,
> -		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
> -		      u64 owner, u64 offset)
> +int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_ref *ref)
>  {
> -	struct btrfs_fs_info *fs_info = root->fs_info;
> -	struct btrfs_ref generic_ref = { 0 };
> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>  	int old_ref_mod, new_ref_mod;
>  	int ret;
>  
>  	if (btrfs_is_testing(fs_info))
>  		return 0;
>  
> -	btrfs_init_generic_ref(&generic_ref, BTRFS_DROP_DELAYED_REF, bytenr,
> -			       num_bytes, parent);
> -	generic_ref.real_root = root->root_key.objectid;
>  	/*
>  	 * tree log blocks never actually go into the extent allocation
>  	 * tree, just update pinning info and exit early.
>  	 */
> -	if (root_objectid == BTRFS_TREE_LOG_OBJECTID) {
> -		WARN_ON(owner >= BTRFS_FIRST_FREE_OBJECTID);
> +	if ((ref->type == BTRFS_REF_METADATA &&
> +	     ref->tree_ref.root == BTRFS_TREE_LOG_OBJECTID) ||
> +	    (ref->type == BTRFS_REF_DATA &&
> +	     ref->data_ref.ref_root == BTRFS_TREE_LOG_OBJECTID)) {
>  		/* unlocks the pinned mutex */
> -		btrfs_pin_extent(fs_info, bytenr, num_bytes, 1);
> +		btrfs_pin_extent(fs_info, ref->bytenr, ref->len, 1);
>  		old_ref_mod = new_ref_mod = 0;
>  		ret = 0;
> -	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
> -		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);
> -		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL,
> +	} else if (ref->type == BTRFS_REF_METADATA) {
> +		ret = btrfs_add_delayed_tree_ref(trans, ref, NULL,
>  						 &old_ref_mod, &new_ref_mod);
>  	} else {
> -		btrfs_init_data_ref(&generic_ref, root_objectid, owner, offset);
> -		ret = btrfs_add_delayed_data_ref(trans, &generic_ref, 0,
> +		ret = btrfs_add_delayed_data_ref(trans, ref, 0,
>  						 &old_ref_mod, &new_ref_mod);
>  	}
>  
> -	if (root_objectid != BTRFS_TREE_LOG_OBJECTID)
> -		btrfs_ref_tree_mod(fs_info, &generic_ref);
> +	if (!((ref->type == BTRFS_REF_METADATA &&
> +	       ref->tree_ref.root == BTRFS_TREE_LOG_OBJECTID) ||
> +	      (ref->type == BTRFS_REF_DATA &&
> +	       ref->data_ref.ref_root == BTRFS_TREE_LOG_OBJECTID)))
> +		btrfs_ref_tree_mod(fs_info, ref);
>  
>  	if (ret == 0 && old_ref_mod >= 0 && new_ref_mod < 0)
> -		add_pinned_bytes(fs_info, &generic_ref);
> +		add_pinned_bytes(fs_info, ref);
>  
>  	return ret;
>  }
> @@ -8957,6 +8949,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  	u64 parent;
>  	struct btrfs_key key;
>  	struct btrfs_key first_key;
> +	struct btrfs_ref ref = { 0 };
>  	struct extent_buffer *next;
>  	int level = wc->level;
>  	int reada = 0;
> @@ -9102,9 +9095,10 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  					     ret);
>  			}
>  		}
> -		ret = btrfs_free_extent(trans, root, bytenr, fs_info->nodesize,
> -					parent, root->root_key.objectid,
> -					level - 1, 0);
> +		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, bytenr,
> +				       fs_info->nodesize, parent);
> +		btrfs_init_tree_ref(&ref, level - 1, root->root_key.objectid);
> +		ret = btrfs_free_extent(trans, &ref);
>  		if (ret)
>  			goto out_unlock;
>  	}
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 2aba5980f522..f032f123be53 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -997,11 +997,14 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
>  				extent_end = ALIGN(extent_end,
>  						   fs_info->sectorsize);
>  			} else if (update_refs && disk_bytenr > 0) {
> -				ret = btrfs_free_extent(trans, root,
> -						disk_bytenr, num_bytes, 0,
> +				btrfs_init_generic_ref(&ref,
> +						BTRFS_DROP_DELAYED_REF,
> +						disk_bytenr, num_bytes, 0);
> +				btrfs_init_data_ref(&ref,
>  						root->root_key.objectid,
> -						key.objectid, key.offset -
> -						extent_offset);
> +						key.objectid,
> +						key.offset - extent_offset);
> +				ret = btrfs_free_extent(trans, &ref);
>  				BUG_ON(ret); /* -ENOMEM */
>  				inode_sub_bytes(inode,
>  						extent_end - key.offset);
> @@ -1318,6 +1321,9 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
>  
>  	other_start = end;
>  	other_end = 0;
> +	btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, bytenr,
> +			       num_bytes, 0);
> +	btrfs_init_data_ref(&ref, root->root_key.objectid, ino, orig_offset);
>  	if (extent_mergeable(leaf, path->slots[0] + 1,
>  			     ino, bytenr, orig_offset,
>  			     &other_start, &other_end)) {
> @@ -1328,9 +1334,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
>  		extent_end = other_end;
>  		del_slot = path->slots[0] + 1;
>  		del_nr++;
> -		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
> -					0, root->root_key.objectid,
> -					ino, orig_offset);
> +		ret = btrfs_free_extent(trans, &ref);
>  		if (ret) {
>  			btrfs_abort_transaction(trans, ret);
>  			goto out;
> @@ -1348,9 +1352,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
>  		key.offset = other_start;
>  		del_slot = path->slots[0];
>  		del_nr++;
> -		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
> -					0, root->root_key.objectid,
> -					ino, orig_offset);
> +		ret = btrfs_free_extent(trans, &ref);
>  		if (ret) {
>  			btrfs_abort_transaction(trans, ret);
>  			goto out;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 95535ba375f8..bc01584791fd 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4720,12 +4720,17 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  		if (found_extent &&
>  		    (test_bit(BTRFS_ROOT_REF_COWS, &root->state) ||
>  		     root == fs_info->tree_root)) {
> +			struct btrfs_ref ref = { 0 };
> +
>  			btrfs_set_path_blocking(path);
>  			bytes_deleted += extent_num_bytes;
> -			ret = btrfs_free_extent(trans, root, extent_start,
> -						extent_num_bytes, 0,
> -						btrfs_header_owner(leaf),
> -						ino, extent_offset);
> +
> +			btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF,
> +					extent_start, extent_num_bytes, 0);
> +			ref.real_root = root->root_key.objectid;
> +			btrfs_init_data_ref(&ref, btrfs_header_owner(leaf),
> +					ino, extent_offset);
> +			ret = btrfs_free_extent(trans, &ref);
>  			if (ret) {
>  				btrfs_abort_transaction(trans, ret);
>  				break;
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index b82d532d8e5e..3b93a4585b70 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1716,9 +1716,12 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
>  			break;
>  		}
>  
> -		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
> -					parent, btrfs_header_owner(leaf),
> -					key.objectid, key.offset);
> +		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, bytenr,
> +				       num_bytes, parent);
> +		ref.real_root = root->root_key.objectid;
> +		btrfs_init_data_ref(&ref, btrfs_header_owner(leaf),
> +				    key.objectid, key.offset);
> +		ret = btrfs_free_extent(trans, &ref);
>  		if (ret) {
>  			btrfs_abort_transaction(trans, ret);
>  			break;
> @@ -1932,14 +1935,18 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
>  		ret = btrfs_inc_extent_ref(trans, &ref);
>  		BUG_ON(ret);
>  
> -		ret = btrfs_free_extent(trans, src, new_bytenr, blocksize,
> -					path->nodes[level]->start,
> -					src->root_key.objectid, level - 1, 0);
> +		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, new_bytenr,
> +				       blocksize, path->nodes[level]->start);
> +		btrfs_init_tree_ref(&ref, level - 1, src->root_key.objectid);
> +		ref.skip_qgroup = true;
> +		ret = btrfs_free_extent(trans, &ref);
>  		BUG_ON(ret);
>  
> -		ret = btrfs_free_extent(trans, dest, old_bytenr, blocksize,
> -					0, dest->root_key.objectid, level - 1,
> -					0);
> +		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, old_bytenr,
> +				       blocksize, 0);
> +		btrfs_init_tree_ref(&ref, level - 1, dest->root_key.objectid);
> +		ref.skip_qgroup = true;
> +		ret = btrfs_free_extent(trans, &ref);
>  		BUG_ON(ret);
>  
>  		btrfs_unlock_up_safe(path, 0);
> 
