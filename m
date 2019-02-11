Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30375C169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 12:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F144C218D8
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 12:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfBKM7Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 07:59:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:38486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726025AbfBKM7Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 07:59:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B00CAAD38
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 12:59:21 +0000 (UTC)
Subject: Re: [PATCH v3 4/9] btrfs: delayed-ref: Use btrfs_ref to refactor
 btrfs_add_delayed_data_ref()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190211051653.3167-1-wqu@suse.com>
 <20190211051653.3167-5-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <b916a8d6-56cf-dbd1-bd42-1f8e4f15604e@suse.com>
Date:   Mon, 11 Feb 2019 14:59:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190211051653.3167-5-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11.02.19 г. 7:16 ч., Qu Wenruo wrote:
> Just like btrfs_add_delayed_tree_ref(), use btrfs_ref to refactor
> btrfs_add_delayed_data_ref().
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>


> ---
>  fs/btrfs/delayed-ref.c | 20 ++++++++++++++------
>  fs/btrfs/delayed-ref.h |  7 +++----
>  fs/btrfs/extent-tree.c | 23 ++++++++++-------------
>  3 files changed, 27 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 5c864ce2f959..d4245ccd1afb 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -837,10 +837,9 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>   * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
>   */
>  int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
> -			       u64 bytenr, u64 num_bytes,
> -			       u64 parent, u64 ref_root,
> -			       u64 owner, u64 offset, u64 reserved, int action,
> -			       int *old_ref_mod, int *new_ref_mod)
> +			       struct btrfs_ref *generic_ref,
> +			       u64 reserved, int *old_ref_mod,
> +			       int *new_ref_mod)
>  {
>  	struct btrfs_fs_info *fs_info = trans->fs_info;
>  	struct btrfs_delayed_data_ref *ref;
> @@ -848,9 +847,17 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
>  	struct btrfs_delayed_ref_root *delayed_refs;
>  	struct btrfs_qgroup_extent_record *record = NULL;
>  	int qrecord_inserted;
> +	int action = generic_ref->action;
>  	int ret;
> +	u64 bytenr = generic_ref->bytenr;
> +	u64 num_bytes = generic_ref->len;
> +	u64 parent = generic_ref->parent;
> +	u64 ref_root = generic_ref->data_ref.ref_root;
> +	u64 owner = generic_ref->data_ref.ino;
> +	u64 offset = generic_ref->data_ref.offset;
>  	u8 ref_type;
>  
> +	ASSERT(generic_ref->type == BTRFS_REF_DATA && action);
>  	ref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, GFP_NOFS);
>  	if (!ref)
>  		return -ENOMEM;
> @@ -874,8 +881,9 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
>  	}
>  
>  	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
> -	    is_fstree(ref_root)) {
> -		record = kmalloc(sizeof(*record), GFP_NOFS);
> +	    is_fstree(ref_root) && is_fstree(generic_ref->real_root) &&
> +	    !generic_ref->skip_qgroup) {
> +		record = kzalloc(sizeof(*record), GFP_NOFS);
>  		if (!record) {
>  			kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
>  			kmem_cache_free(btrfs_delayed_ref_head_cachep,
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index 70bb080bf3ef..9037a7de18b7 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -355,10 +355,9 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>  			       struct btrfs_delayed_extent_op *extent_op,
>  			       int *old_ref_mod, int *new_ref_mod);
>  int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
> -			       u64 bytenr, u64 num_bytes,
> -			       u64 parent, u64 ref_root,
> -			       u64 owner, u64 offset, u64 reserved, int action,
> -			       int *old_ref_mod, int *new_ref_mod);
> +			       struct btrfs_ref *generic_ref,
> +			       u64 reserved, int *old_ref_mod,
> +			       int *new_ref_mod);
>  int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
>  				struct btrfs_trans_handle *trans,
>  				u64 bytenr, u64 num_bytes,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index b01fad9a56ff..36516b33d07f 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2066,10 +2066,8 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>  		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref,
>  				NULL, &old_ref_mod, &new_ref_mod);
>  	} else {
> -		ret = btrfs_add_delayed_data_ref(trans, bytenr,
> -						 num_bytes, parent,
> -						 root_objectid, owner, offset,
> -						 0, BTRFS_ADD_DELAYED_REF,
> +		btrfs_init_data_ref(&generic_ref, root_objectid, owner, offset);
> +		ret = btrfs_add_delayed_data_ref(trans, &generic_ref, 0,
>  						 &old_ref_mod, &new_ref_mod);
>  	}
>  
> @@ -7378,10 +7376,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>  		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, NULL,
>  						 &old_ref_mod, &new_ref_mod);
>  	} else {
> -		ret = btrfs_add_delayed_data_ref(trans, bytenr,
> -						 num_bytes, parent,
> -						 root_objectid, owner, offset,
> -						 0, BTRFS_DROP_DELAYED_REF,
> +		btrfs_init_data_ref(&generic_ref, root_objectid, owner, offset);
> +		ret = btrfs_add_delayed_data_ref(trans, &generic_ref, 0,
>  						 &old_ref_mod, &new_ref_mod);
>  	}
>  
> @@ -8489,6 +8485,7 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
>  				     u64 offset, u64 ram_bytes,
>  				     struct btrfs_key *ins)
>  {
> +	struct btrfs_ref generic_ref = { 0 };
>  	int ret;
>  
>  	BUG_ON(root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID);
> @@ -8497,11 +8494,11 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
>  			   root->root_key.objectid, owner, offset,
>  			   BTRFS_ADD_DELAYED_EXTENT);
>  
> -	ret = btrfs_add_delayed_data_ref(trans, ins->objectid,
> -					 ins->offset, 0,
> -					 root->root_key.objectid, owner,
> -					 offset, ram_bytes,
> -					 BTRFS_ADD_DELAYED_EXTENT, NULL, NULL);
> +	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_EXTENT,
> +			       ins->objectid, ins->offset, 0);
> +	btrfs_init_data_ref(&generic_ref, root->root_key.objectid, owner, offset);
> +	ret = btrfs_add_delayed_data_ref(trans, &generic_ref,
> +					 ram_bytes, NULL, NULL);
>  	return ret;
>  }
>  
> 
