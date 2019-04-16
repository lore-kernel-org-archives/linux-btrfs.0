Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4210C10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C425020857
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbfDPHjF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 03:39:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:49124 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726783AbfDPHjF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 03:39:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 679BAAE0F
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 07:39:03 +0000 (UTC)
Subject: Re: [PATCH 2/3] btrfs-progs: Refactor btrfs_finish_extent_commit()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190416071526.3576-1-wqu@suse.com>
 <20190416071526.3576-3-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <c5e92734-0c9a-aab2-2c6f-e849418bbdde@suse.com>
Date:   Tue, 16 Apr 2019 10:39:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190416071526.3576-3-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 16.04.19 г. 10:15 ч., Qu Wenruo wrote:
> This patch will refactor btrfs_finish_extent_commit() by:
> - Make it return void
>   There is no failure pattern for btrfs_finish_extent_commit(), thus it
>   always return 0. And the caller doesn't care about the return value.
>   So no need to return int.
> 
> - Remove @root and @unpin parameters
>   @root is only used to extract fs_info, which can be extracted from
>   transaction handler already.
>   @unpin is always fs_info->pinned_extents.
>   All these parameters can be extracted from @trans, no need to pass
>   them.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

This also makes the function's signature identical to its kernel
counterpart.


Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  ctree.h       |  4 +---
>  extent-tree.c | 14 ++++++--------
>  transaction.c |  3 +--
>  3 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/ctree.h b/ctree.h
> index 3357290d7045..76f52b1c9b08 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -2516,9 +2516,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>  		      struct btrfs_root *root,
>  		      u64 bytenr, u64 num_bytes, u64 parent,
>  		      u64 root_objectid, u64 owner, u64 offset);
> -int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
> -			       struct btrfs_root *root,
> -			       struct extent_io_tree *unpin);
> +void btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
>  int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>  				struct btrfs_root *root,
>  				u64 bytenr, u64 num_bytes, u64 parent,
> diff --git a/extent-tree.c b/extent-tree.c
> index b7ece0ccc237..1140ebfc61ff 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -1977,27 +1977,25 @@ next:
>  	return 0;
>  }
>  
> -int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
> -			       struct btrfs_root *root,
> -			       struct extent_io_tree *unpin)
> +void btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
>  {
>  	u64 start;
>  	u64 end;
>  	int ret;
> -	struct extent_io_tree *free_space_cache;
> -	free_space_cache = &root->fs_info->free_space_cache;
> +	struct btrfs_fs_info *fs_info = trans->fs_info;
> +	struct extent_io_tree *free_space_cache = &fs_info->free_space_cache;
> +	struct extent_io_tree *pinned_extents = &fs_info->pinned_extents;
>  
>  	while(1) {
> -		ret = find_first_extent_bit(unpin, 0, &start, &end,
> +		ret = find_first_extent_bit(pinned_extents, 0, &start, &end,
>  					    EXTENT_DIRTY);
>  		if (ret)
>  			break;
>  		update_pinned_extents(trans->fs_info, start, end + 1 - start,
>  				      0);
> -		clear_extent_dirty(unpin, start, end);
> +		clear_extent_dirty(pinned_extents, start, end);
>  		set_extent_dirty(free_space_cache, start, end);
>  	}
> -	return 0;
>  }
>  
>  static int pin_down_bytes(struct btrfs_trans_handle *trans, u64 bytenr,
> diff --git a/transaction.c b/transaction.c
> index 3a63988b0969..8d15eb11c7b5 100644
> --- a/transaction.c
> +++ b/transaction.c
> @@ -198,8 +198,7 @@ commit_tree:
>  	if (ret < 0)
>  		goto out;
>  	ret = write_ctree_super(trans);
> -	btrfs_finish_extent_commit(trans, fs_info->extent_root,
> -			           &fs_info->pinned_extents);
> +	btrfs_finish_extent_commit(trans);
>  	kfree(trans);
>  	free_extent_buffer(root->commit_root);
>  	root->commit_root = NULL;
> 
