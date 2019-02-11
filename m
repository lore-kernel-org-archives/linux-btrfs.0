Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83665C169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 12:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E4A2218D8
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 12:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfBKM6l (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 07:58:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:38394 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727106AbfBKM6k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 07:58:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C0376AC3B
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 12:58:38 +0000 (UTC)
Subject: Re: [PATCH v3 3/9] btrfs: delayed-ref: Use btrfs_ref to refactor
 btrfs_add_delayed_tree_ref()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190211051653.3167-1-wqu@suse.com>
 <20190211051653.3167-4-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <4cadf3c6-f6bf-f7ff-4c6a-7e9c22356061@suse.com>
Date:   Mon, 11 Feb 2019 14:58:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190211051653.3167-4-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11.02.19 г. 7:16 ч., Qu Wenruo wrote:
> btrfs_add_delayed_tree_ref() has a longer and longer parameter list, and
> some caller like btrfs_inc_extent_ref() are using @owner as level for
> delayed tree ref.
> 
> Instead of making the parameter list longer and longer, use btrfs_ref to
> refactor it, so each parameter assignment should be self-explaining
> without dirty level/owner trick, and provides the basis for later refactor.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/delayed-ref.c | 24 +++++++++++++++--------
>  fs/btrfs/delayed-ref.h |  3 +--
>  fs/btrfs/extent-tree.c | 44 +++++++++++++++++++++++++-----------------
>  3 files changed, 43 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index cad36c99a483..5c864ce2f959 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -742,8 +742,7 @@ static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
>   * transaction commits.
>   */
>  int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
> -			       u64 bytenr, u64 num_bytes, u64 parent,
> -			       u64 ref_root,  int level, int action,
> +			       struct btrfs_ref *generic_ref,
>  			       struct btrfs_delayed_extent_op *extent_op,
>  			       int *old_ref_mod, int *new_ref_mod)
>  {
> @@ -753,10 +752,16 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>  	struct btrfs_delayed_ref_root *delayed_refs;
>  	struct btrfs_qgroup_extent_record *record = NULL;
>  	int qrecord_inserted;
> -	bool is_system = (ref_root == BTRFS_CHUNK_TREE_OBJECTID);
> +	bool is_system = (generic_ref->real_root == BTRFS_CHUNK_TREE_OBJECTID);
> +	int action = generic_ref->action;
> +	int level = generic_ref->tree_ref.level;
>  	int ret;
> +	u64 bytenr = generic_ref->bytenr;
> +	u64 num_bytes = generic_ref->len;
> +	u64 parent = generic_ref->parent;
>  	u8 ref_type;
>  
> +	ASSERT(generic_ref->type == BTRFS_REF_METADATA && generic_ref->action);
>  	BUG_ON(extent_op && extent_op->is_data);
>  	ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
>  	if (!ref)
> @@ -769,8 +774,10 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>  	}
>  
>  	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
> -	    is_fstree(ref_root)) {
> -		record = kmalloc(sizeof(*record), GFP_NOFS);
> +	    is_fstree(generic_ref->real_root) &&
> +	    is_fstree(generic_ref->tree_ref.root) &&
> +	    !generic_ref->skip_qgroup) {
> +		record = kzalloc(sizeof(*record), GFP_NOFS);
>  		if (!record) {
>  			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
>  			kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
> @@ -784,13 +791,14 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>  		ref_type = BTRFS_TREE_BLOCK_REF_KEY;
>  
>  	init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
> -				ref_root, action, ref_type);
> -	ref->root = ref_root;
> +				generic_ref->tree_ref.root, action, ref_type);
> +	ref->root = generic_ref->tree_ref.root;
>  	ref->parent = parent;
>  	ref->level = level;
>  
>  	init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
> -			      ref_root, 0, action, false, is_system);
> +			      generic_ref->tree_ref.root, 0, action, false,
> +			      is_system);
>  	head_ref->extent_op = extent_op;
>  
>  	delayed_refs = &trans->transaction->delayed_refs;
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index 24addc5163bc..70bb080bf3ef 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -351,8 +351,7 @@ static inline void btrfs_put_delayed_ref_head(struct btrfs_delayed_ref_head *hea
>  }
>  
>  int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
> -			       u64 bytenr, u64 num_bytes, u64 parent,
> -			       u64 ref_root, int level, int action,
> +			       struct btrfs_ref *generic_ref,
>  			       struct btrfs_delayed_extent_op *extent_op,
>  			       int *old_ref_mod, int *new_ref_mod);
>  int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 606187ede47b..b01fad9a56ff 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2048,6 +2048,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>  			 u64 root_objectid, u64 owner, u64 offset)
>  {
>  	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct btrfs_ref generic_ref = { 0 };
>  	int old_ref_mod, new_ref_mod;
>  	int ret;
>  
> @@ -2057,12 +2058,13 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>  	btrfs_ref_tree_mod(root, bytenr, num_bytes, parent, root_objectid,
>  			   owner, offset, BTRFS_ADD_DELAYED_REF);
>  
> +	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_REF, bytenr,
> +			       num_bytes, parent);
> +	generic_ref.real_root = root->root_key.objectid;
>  	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
> -		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
> -						 num_bytes, parent,
> -						 root_objectid, (int)owner,
> -						 BTRFS_ADD_DELAYED_REF, NULL,
> -						 &old_ref_mod, &new_ref_mod);
> +		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);
> +		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref,
> +				NULL, &old_ref_mod, &new_ref_mod);
>  	} else {
>  		ret = btrfs_add_delayed_data_ref(trans, bytenr,
>  						 num_bytes, parent,
> @@ -7277,9 +7279,15 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>  			   u64 parent, int last_ref)
>  {
>  	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct btrfs_ref generic_ref = { 0 };
>  	int pin = 1;
>  	int ret;
>  
> +	btrfs_init_generic_ref(&generic_ref, BTRFS_DROP_DELAYED_REF,
> +			       buf->start, buf->len, parent);
> +	btrfs_init_tree_ref(&generic_ref, btrfs_header_level(buf),
> +			    root->root_key.objectid);
> +
>  	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
>  		int old_ref_mod, new_ref_mod;
>  
> @@ -7287,11 +7295,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>  				   root->root_key.objectid,
>  				   btrfs_header_level(buf), 0,
>  				   BTRFS_DROP_DELAYED_REF);
> -		ret = btrfs_add_delayed_tree_ref(trans, buf->start,
> -						 buf->len, parent,
> -						 root->root_key.objectid,
> -						 btrfs_header_level(buf),
> -						 BTRFS_DROP_DELAYED_REF, NULL,
> +		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL,
>  						 &old_ref_mod, &new_ref_mod);
>  		BUG_ON(ret); /* -ENOMEM */
>  		pin = old_ref_mod >= 0 && new_ref_mod < 0;
> @@ -7344,6 +7348,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>  		      u64 owner, u64 offset)
>  {
>  	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct btrfs_ref generic_ref = { 0 };
>  	int old_ref_mod, new_ref_mod;
>  	int ret;
>  
> @@ -7355,6 +7360,9 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>  				   root_objectid, owner, offset,
>  				   BTRFS_DROP_DELAYED_REF);
>  
> +	btrfs_init_generic_ref(&generic_ref, BTRFS_DROP_DELAYED_REF, bytenr,
> +			       num_bytes, parent);
> +	generic_ref.real_root = root->root_key.objectid;
>  	/*
>  	 * tree log blocks never actually go into the extent allocation
>  	 * tree, just update pinning info and exit early.
> @@ -7366,10 +7374,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>  		old_ref_mod = new_ref_mod = 0;
>  		ret = 0;
>  	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
> -		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
> -						 num_bytes, parent,
> -						 root_objectid, (int)owner,
> -						 BTRFS_DROP_DELAYED_REF, NULL,
> +		btrfs_init_tree_ref(&generic_ref, (int)owner, root_objectid);
> +		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL,
>  						 &old_ref_mod, &new_ref_mod);
>  	} else {
>  		ret = btrfs_add_delayed_data_ref(trans, bytenr,
> @@ -8687,6 +8693,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
>  	struct btrfs_block_rsv *block_rsv;
>  	struct extent_buffer *buf;
>  	struct btrfs_delayed_extent_op *extent_op;
> +	struct btrfs_ref generic_ref = { 0 };
>  	u64 flags = 0;
>  	int ret;
>  	u32 blocksize = fs_info->nodesize;
> @@ -8744,10 +8751,11 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
>  		btrfs_ref_tree_mod(root, ins.objectid, ins.offset, parent,
>  				   root_objectid, level, 0,
>  				   BTRFS_ADD_DELAYED_EXTENT);
> -		ret = btrfs_add_delayed_tree_ref(trans, ins.objectid,
> -						 ins.offset, parent,
> -						 root_objectid, level,
> -						 BTRFS_ADD_DELAYED_EXTENT,
> +		btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_EXTENT,
> +				       ins.objectid, ins.offset, parent);
> +		generic_ref.real_root = root->root_key.objectid;
> +		btrfs_init_tree_ref(&generic_ref, level, root_objectid);
> +		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref,
>  						 extent_op, NULL, NULL);
>  		if (ret)
>  			goto out_free_delayed;
> 
