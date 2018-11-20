Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4EEFC32788
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E66220831
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:52:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E66220831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbeKTTUD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 14:20:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:57162 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbeKTTUC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 14:20:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 03197AE62
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:51:58 +0000 (UTC)
Subject: Re: [PATCH] btrfs: qgroup: Skip delayed data ref for reloc trees
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181120084636.31346-1-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <970d0031-00ec-eb37-7245-f682f4f10569@suse.com>
Date:   Tue, 20 Nov 2018 10:51:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181120084636.31346-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 20.11.18 г. 10:46 ч., Qu Wenruo wrote:
> Currently we only check @ref_root in btrfs_add_delayed_data_ref() to
> determine whether a data delayed ref is for reloc tree.
> 
> Such check is insufficient as for relocation we could pass @ref_root
> as the source file tree, causing qgroup to trace unchanged data extents
> even we're only relocating metadata chunks.
> 
> We could insert qgroup extent record for the following call trace even
> we're only relocating metadata block group:
> 
> do_relocation()
> |- btrfs_cow_block(root=reloc_root)
>    |- update_ref_for_cow(root=reloc_root)
>       |- __btrfs_mod_ref(root=reloc_root)
>          |- ref_root = btrfs_header_owner()
>          |- btrfs_add_delayed_data_ref(ref_root=source_root)
> 
> And another case when dropping reloc tree:
> 
> clean_dirty_root()
> |- btrfs_drop_snapshot(root=relocc_root)
>    |- walk_up_tree(root=reloc_root)
>       |- walk_up_proc(root=reloc_root)
>          |- btrfs_dec_ref(root=reloc_root)
>             |- __btrfs_mod_ref(root=reloc_root)
>                |- ref_root = btrfs_header_owner()
>                |- btrfs_add_delayed_data_ref(ref_root=source_root)
> 
> This patch will introduce @root parameter for
> btrfs_add_delayed_data_ref(), so that we could determine if this data
> extent belongs to reloc tree or not.
> 
> This could skip data extents which aren't really modified during
> relocation.
> 
> For the same real world 4G data 16 snapshots 4K nodesize metadata
> balance test:
>                      | v4.20-rc1 + delaye*  | w/ patch       | diff
> -----------------------------------------------------------------------
> relocated extents    | 22773                | 22656          | -0.1%
> qgroup dirty extents | 122879               | 74316          | -39.5%
> time (real)          | 23.073s              | 14.971         | -35.1%
> 
> *: v4.20-rc1 + delayed subtree scan patchset
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/delayed-ref.c | 3 ++-
>  fs/btrfs/delayed-ref.h | 1 +
>  fs/btrfs/extent-tree.c | 6 +++---
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 9301b3ad9217..269bd6ecb8f3 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -798,6 +798,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>   * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
>   */
>  int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
> +			       struct btrfs_root *root,

I'm beginning to wonder, should we document
btrfs_add_delayed_data_ref/btrfs_add_tree_ref arguments separate for
each function, or should only the differences be documented - in this
case the newly added root parameter. The rest of the arguments are being
documented at init_delayed_ref_common.

>  			       u64 bytenr, u64 num_bytes,
>  			       u64 parent, u64 ref_root,
>  			       u64 owner, u64 offset, u64 reserved, int action,
> @@ -835,7 +836,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
>  	}
>  
>  	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
> -	    is_fstree(ref_root)) {
> +	    is_fstree(ref_root) && is_fstree(root->root_key.objectid)) {
>  		record = kmalloc(sizeof(*record), GFP_NOFS);
>  		if (!record) {
>  			kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index 8e20c5cb5404..6c60737e55d6 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -240,6 +240,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
>  			       struct btrfs_delayed_extent_op *extent_op,
>  			       int *old_ref_mod, int *new_ref_mod);
>  int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
> +			       struct btrfs_root *root,
>  			       u64 bytenr, u64 num_bytes,
>  			       u64 parent, u64 ref_root,
>  			       u64 owner, u64 offset, u64 reserved, int action,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a1febf155747..0554d2cc2ea1 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2046,7 +2046,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>  						 BTRFS_ADD_DELAYED_REF, NULL,
>  						 &old_ref_mod, &new_ref_mod);
>  	} else {
> -		ret = btrfs_add_delayed_data_ref(trans, bytenr,
> +		ret = btrfs_add_delayed_data_ref(trans, root, bytenr,
>  						 num_bytes, parent,
>  						 root_objectid, owner, offset,
>  						 0, BTRFS_ADD_DELAYED_REF,
> @@ -7104,7 +7104,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>  						 BTRFS_DROP_DELAYED_REF, NULL,
>  						 &old_ref_mod, &new_ref_mod);
>  	} else {
> -		ret = btrfs_add_delayed_data_ref(trans, bytenr,
> +		ret = btrfs_add_delayed_data_ref(trans, root, bytenr,
>  						 num_bytes, parent,
>  						 root_objectid, owner, offset,
>  						 0, BTRFS_DROP_DELAYED_REF,
> @@ -8080,7 +8080,7 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
>  			   root->root_key.objectid, owner, offset,
>  			   BTRFS_ADD_DELAYED_EXTENT);
>  
> -	ret = btrfs_add_delayed_data_ref(trans, ins->objectid,
> +	ret = btrfs_add_delayed_data_ref(trans, root, ins->objectid,
>  					 ins->offset, 0,
>  					 root->root_key.objectid, owner,
>  					 offset, ram_bytes,
> 
