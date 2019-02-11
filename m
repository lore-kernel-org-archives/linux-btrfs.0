Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE36C169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 13:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15121218D8
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 13:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfBKNEl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 08:04:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:39620 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727182AbfBKNEl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 08:04:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 54B43AF58
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 13:04:39 +0000 (UTC)
Subject: Re: [PATCH v3 7/9] btrfs: extent-tree: Use btrfs_ref to refactor
 btrfs_inc_extent_ref()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190211051653.3167-1-wqu@suse.com>
 <20190211051653.3167-8-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <15a41104-eb91-2a90-3237-0234da65c260@suse.com>
Date:   Mon, 11 Feb 2019 15:04:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190211051653.3167-8-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11.02.19 г. 7:16 ч., Qu Wenruo wrote:
> Now we don't need to play the dirty game of reusing @owner for tree block
> level.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>


> ---
>  fs/btrfs/ctree.h       |  5 ++--
>  fs/btrfs/extent-tree.c | 57 ++++++++++++++++++++++++------------------
>  fs/btrfs/file.c        | 17 +++++++++----
>  fs/btrfs/inode.c       | 10 +++++---
>  fs/btrfs/ioctl.c       | 15 ++++++-----
>  fs/btrfs/relocation.c  | 42 ++++++++++++++++++++-----------
>  fs/btrfs/tree-log.c    | 11 +++++---
>  7 files changed, 96 insertions(+), 61 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 9306925b6790..cd90f7cbc8f2 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -41,6 +41,7 @@ extern struct kmem_cache *btrfs_bit_radix_cachep;
>  extern struct kmem_cache *btrfs_path_cachep;
>  extern struct kmem_cache *btrfs_free_space_cachep;
>  struct btrfs_ordered_sum;
> +struct btrfs_ref;
>  
>  #define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null */
>  
> @@ -2755,9 +2756,7 @@ int btrfs_free_and_pin_reserved_extent(struct btrfs_fs_info *fs_info,
>  void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info);
>  int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
>  int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
> -			 struct btrfs_root *root,
> -			 u64 bytenr, u64 num_bytes, u64 parent,
> -			 u64 root_objectid, u64 owner, u64 offset);
> +			 struct btrfs_ref *generic_ref);
>  
>  int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans);
>  int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 5419266d3e5d..d08186ec6410 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2044,35 +2044,28 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
>  
>  /* Can return -ENOMEM */
>  int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
> -			 struct btrfs_root *root,
> -			 u64 bytenr, u64 num_bytes, u64 parent,
> -			 u64 root_objectid, u64 owner, u64 offset)
> +			 struct btrfs_ref *generic_ref)
>  {
> -	struct btrfs_fs_info *fs_info = root->fs_info;
> -	struct btrfs_ref generic_ref = { 0 };
> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>  	int old_ref_mod, new_ref_mod;
>  	int ret;
>  
> -	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
> -	       root_objectid == BTRFS_TREE_LOG_OBJECTID);
> +	ASSERT(generic_ref->type != BTRFS_REF_NOT_SET &&
> +	       generic_ref->action);
> +	BUG_ON(generic_ref->type == BTRFS_REF_METADATA &&
> +	       generic_ref->tree_ref.root == BTRFS_TREE_LOG_OBJECTID);
>  
> -	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_REF, bytenr,
> -			       num_bytes, parent);
> -	generic_ref.real_root = root->root_key.objectid;
> -	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
> -		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);
> -		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref,
> +	if (generic_ref->type == BTRFS_REF_METADATA)
> +		ret = btrfs_add_delayed_tree_ref(trans, generic_ref,
>  				NULL, &old_ref_mod, &new_ref_mod);
> -	} else {
> -		btrfs_init_data_ref(&generic_ref, root_objectid, owner, offset);
> -		ret = btrfs_add_delayed_data_ref(trans, &generic_ref, 0,
> +	else
> +		ret = btrfs_add_delayed_data_ref(trans, generic_ref, 0,
>  						 &old_ref_mod, &new_ref_mod);
> -	}
>  
> -	btrfs_ref_tree_mod(fs_info, &generic_ref);
> +	btrfs_ref_tree_mod(fs_info, generic_ref);
>  
>  	if (ret == 0 && old_ref_mod < 0 && new_ref_mod >= 0)
> -		add_pinned_bytes(fs_info, &generic_ref);
> +		add_pinned_bytes(fs_info, generic_ref);
>  
>  	return ret;
>  }
> @@ -3246,7 +3239,10 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
>  	u32 nritems;
>  	struct btrfs_key key;
>  	struct btrfs_file_extent_item *fi;
> +	struct btrfs_ref generic_ref = { 0 };
> +	bool for_reloc = btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC);
>  	int i;
> +	int action;
>  	int level;
>  	int ret = 0;
>  
> @@ -3264,6 +3260,10 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
>  		parent = buf->start;
>  	else
>  		parent = 0;
> +	if (inc)
> +		action = BTRFS_ADD_DELAYED_REF;
> +	else
> +		action = BTRFS_DROP_DELAYED_REF;
>  
>  	for (i = 0; i < nritems; i++) {
>  		if (level == 0) {
> @@ -3281,10 +3281,14 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
>  
>  			num_bytes = btrfs_file_extent_disk_num_bytes(buf, fi);
>  			key.offset -= btrfs_file_extent_offset(buf, fi);
> +			btrfs_init_generic_ref(&generic_ref, action, bytenr,
> +					       num_bytes, parent);
> +			generic_ref.real_root = root->root_key.objectid;
> +			btrfs_init_data_ref(&generic_ref, ref_root, key.objectid,
> +					    key.offset);
> +			generic_ref.skip_qgroup = for_reloc;
>  			if (inc)
> -				ret = btrfs_inc_extent_ref(trans, root, bytenr,
> -						num_bytes, parent, ref_root,
> -						key.objectid, key.offset);
> +				ret = btrfs_inc_extent_ref(trans, &generic_ref);
>  			else
>  				ret = btrfs_free_extent(trans, root, bytenr,
>  						num_bytes, parent, ref_root,
> @@ -3294,10 +3298,13 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
>  		} else {
>  			bytenr = btrfs_node_blockptr(buf, i);
>  			num_bytes = fs_info->nodesize;
> +			btrfs_init_generic_ref(&generic_ref, action, bytenr,
> +					       num_bytes, parent);
> +			generic_ref.real_root = root->root_key.objectid;
> +			btrfs_init_tree_ref(&generic_ref, level - 1, ref_root);
> +			generic_ref.skip_qgroup = for_reloc;
>  			if (inc)
> -				ret = btrfs_inc_extent_ref(trans, root, bytenr,
> -						num_bytes, parent, ref_root,
> -						level - 1, 0);
> +				ret = btrfs_inc_extent_ref(trans, &generic_ref);
>  			else
>  				ret = btrfs_free_extent(trans, root, bytenr,
>  						num_bytes, parent, ref_root,
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 34fe8a58b0e9..2aba5980f522 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -754,6 +754,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
>  	struct btrfs_fs_info *fs_info = root->fs_info;
>  	struct extent_buffer *leaf;
>  	struct btrfs_file_extent_item *fi;
> +	struct btrfs_ref ref = { 0 };
>  	struct btrfs_key key;
>  	struct btrfs_key new_key;
>  	u64 ino = btrfs_ino(BTRFS_I(inode));
> @@ -909,11 +910,14 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
>  			btrfs_mark_buffer_dirty(leaf);
>  
>  			if (update_refs && disk_bytenr > 0) {
> -				ret = btrfs_inc_extent_ref(trans, root,
> -						disk_bytenr, num_bytes, 0,
> +				btrfs_init_generic_ref(&ref,
> +						BTRFS_ADD_DELAYED_REF,
> +						disk_bytenr, num_bytes, 0);
> +				btrfs_init_data_ref(&ref,
>  						root->root_key.objectid,
>  						new_key.objectid,
>  						start - extent_offset);
> +				ret = btrfs_inc_extent_ref(trans, &ref);
>  				BUG_ON(ret); /* -ENOMEM */
>  			}
>  			key.offset = start;
> @@ -1142,6 +1146,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
>  	struct extent_buffer *leaf;
>  	struct btrfs_path *path;
>  	struct btrfs_file_extent_item *fi;
> +	struct btrfs_ref ref = { 0 };
>  	struct btrfs_key key;
>  	struct btrfs_key new_key;
>  	u64 bytenr;
> @@ -1287,9 +1292,11 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
>  						extent_end - split);
>  		btrfs_mark_buffer_dirty(leaf);
>  
> -		ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes,
> -					   0, root->root_key.objectid,
> -					   ino, orig_offset);
> +		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, bytenr,
> +				       num_bytes, 0);
> +		btrfs_init_data_ref(&ref, root->root_key.objectid, ino,
> +				    orig_offset);
> +		ret = btrfs_inc_extent_ref(trans, &ref);
>  		if (ret) {
>  			btrfs_abort_transaction(trans, ret);
>  			goto out;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3f180b857e20..95535ba375f8 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2531,6 +2531,7 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
>  	struct btrfs_file_extent_item *item;
>  	struct btrfs_ordered_extent *ordered;
>  	struct btrfs_trans_handle *trans;
> +	struct btrfs_ref ref = { 0 };
>  	struct btrfs_root *root;
>  	struct btrfs_key key;
>  	struct extent_buffer *leaf;
> @@ -2701,10 +2702,11 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
>  	inode_add_bytes(inode, len);
>  	btrfs_release_path(path);
>  
> -	ret = btrfs_inc_extent_ref(trans, root, new->bytenr,
> -			new->disk_len, 0,
> -			backref->root_id, backref->inum,
> -			new->file_pos);	/* start - extent_offset */
> +	btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, new->bytenr,
> +			       new->disk_len, 0);
> +	btrfs_init_data_ref(&ref, backref->root_id, backref->inum,
> +			    new->file_pos);  /* start - extent_offset */
> +	ret = btrfs_inc_extent_ref(trans, &ref);
>  	if (ret) {
>  		btrfs_abort_transaction(trans, ret);
>  		goto out_free_path;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 3f9d7be30bf4..f5d49a92f53c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3755,13 +3755,16 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>  								datal);
>  
>  				if (disko) {
> +					struct btrfs_ref ref = { 0 };
>  					inode_add_bytes(inode, datal);
> -					ret = btrfs_inc_extent_ref(trans,
> -							root,
> -							disko, diskl, 0,
> -							root->root_key.objectid,
> -							btrfs_ino(BTRFS_I(inode)),
> -							new_key.offset - datao);
> +					btrfs_init_generic_ref(&ref,
> +						BTRFS_ADD_DELAYED_REF, disko,
> +						diskl, 0);
> +					btrfs_init_data_ref(&ref,
> +						root->root_key.objectid,
> +						btrfs_ino(BTRFS_I(inode)),
> +						new_key.offset - datao);
> +					ret = btrfs_inc_extent_ref(trans, &ref);
>  					if (ret) {
>  						btrfs_abort_transaction(trans,
>  									ret);
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 70b85a593b7b..b82d532d8e5e 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1643,6 +1643,8 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
>  
>  	nritems = btrfs_header_nritems(leaf);
>  	for (i = 0; i < nritems; i++) {
> +		struct btrfs_ref ref = { 0 };
> +
>  		cond_resched();
>  		btrfs_item_key_to_cpu(leaf, &key, i);
>  		if (key.type != BTRFS_EXTENT_DATA_KEY)
> @@ -1703,10 +1705,12 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
>  		dirty = 1;
>  
>  		key.offset -= btrfs_file_extent_offset(leaf, fi);
> -		ret = btrfs_inc_extent_ref(trans, root, new_bytenr,
> -					   num_bytes, parent,
> -					   btrfs_header_owner(leaf),
> -					   key.objectid, key.offset);
> +		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, new_bytenr,
> +				       num_bytes, parent);
> +		ref.real_root = root->root_key.objectid;
> +		btrfs_init_data_ref(&ref, btrfs_header_owner(leaf),
> +				    key.objectid, key.offset);
> +		ret = btrfs_inc_extent_ref(trans, &ref);
>  		if (ret) {
>  			btrfs_abort_transaction(trans, ret);
>  			break;
> @@ -1756,6 +1760,7 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
>  	struct btrfs_fs_info *fs_info = dest->fs_info;
>  	struct extent_buffer *eb;
>  	struct extent_buffer *parent;
> +	struct btrfs_ref ref = { 0 };
>  	struct btrfs_key key;
>  	u64 old_bytenr;
>  	u64 new_bytenr;
> @@ -1914,13 +1919,17 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
>  					      path->slots[level], old_ptr_gen);
>  		btrfs_mark_buffer_dirty(path->nodes[level]);
>  
> -		ret = btrfs_inc_extent_ref(trans, src, old_bytenr,
> -					blocksize, path->nodes[level]->start,
> -					src->root_key.objectid, level - 1, 0);
> +		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, old_bytenr,
> +				       blocksize, path->nodes[level]->start);
> +		ref.skip_qgroup = true;
> +		btrfs_init_tree_ref(&ref, level - 1, src->root_key.objectid);
> +		ret = btrfs_inc_extent_ref(trans, &ref);
>  		BUG_ON(ret);
> -		ret = btrfs_inc_extent_ref(trans, dest, new_bytenr,
> -					blocksize, 0, dest->root_key.objectid,
> -					level - 1, 0);
> +		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, new_bytenr,
> +				       blocksize, 0);
> +		ref.skip_qgroup = true;
> +		btrfs_init_tree_ref(&ref, level - 1, dest->root_key.objectid);
> +		ret = btrfs_inc_extent_ref(trans, &ref);
>  		BUG_ON(ret);
>  
>  		ret = btrfs_free_extent(trans, src, new_bytenr, blocksize,
> @@ -2719,6 +2728,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
>  	rc->backref_cache.path[node->level] = node;
>  	list_for_each_entry(edge, &node->upper, list[LOWER]) {
>  		struct btrfs_key first_key;
> +		struct btrfs_ref ref = { 0 };
>  
>  		cond_resched();
>  
> @@ -2816,11 +2826,13 @@ static int do_relocation(struct btrfs_trans_handle *trans,
>  						      trans->transid);
>  			btrfs_mark_buffer_dirty(upper->eb);
>  
> -			ret = btrfs_inc_extent_ref(trans, root,
> -						node->eb->start, blocksize,
> -						upper->eb->start,
> -						btrfs_header_owner(upper->eb),
> -						node->level, 0);
> +			btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF,
> +					       node->eb->start, blocksize,
> +					       upper->eb->start);
> +			ref.real_root = root->root_key.objectid;
> +			btrfs_init_tree_ref(&ref, node->level,
> +					    btrfs_header_owner(upper->eb));
> +			ret = btrfs_inc_extent_ref(trans, &ref);
>  			BUG_ON(ret);
>  
>  			ret = btrfs_drop_subtree(trans, root, eb, upper->eb);
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1a69a45ae926..2e62f275ae5b 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -693,9 +693,11 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
>  			goto out;
>  
>  		if (ins.objectid > 0) {
> +			struct btrfs_ref ref = { 0 };
>  			u64 csum_start;
>  			u64 csum_end;
>  			LIST_HEAD(ordered_sums);
> +
>  			/*
>  			 * is this extent already allocated in the extent
>  			 * allocation tree?  If so, just add a reference
> @@ -703,10 +705,13 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
>  			ret = btrfs_lookup_data_extent(fs_info, ins.objectid,
>  						ins.offset);
>  			if (ret == 0) {
> -				ret = btrfs_inc_extent_ref(trans, root,
> -						ins.objectid, ins.offset,
> -						0, root->root_key.objectid,
> +				btrfs_init_generic_ref(&ref,
> +						BTRFS_ADD_DELAYED_REF,
> +						ins.objectid, ins.offset, 0);
> +				btrfs_init_data_ref(&ref,
> +						root->root_key.objectid,
>  						key->objectid, offset);
> +				ret = btrfs_inc_extent_ref(trans, &ref);
>  				if (ret)
>  					goto out;
>  			} else {
> 
