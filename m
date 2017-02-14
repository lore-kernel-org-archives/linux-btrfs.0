Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54399 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752767AbdBNJYC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 04:24:02 -0500
Subject: Re: [PATCH 3/7] btrfs: embed extent_changeset::range_changed to the
 structure
To: David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <cover.1486995885.git.dsterba@suse.com>
 <b433a540538d5f7e95f813ee13636b135ef8ce7d.1486995885.git.dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <8eb633eb-28fb-b0d1-5e34-c545dffaca3d@cn.fujitsu.com>
Date: Tue, 14 Feb 2017 17:23:53 +0800
MIME-Version: 1.0
In-Reply-To: <b433a540538d5f7e95f813ee13636b135ef8ce7d.1486995885.git.dsterba@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/13/2017 10:30 PM, David Sterba wrote:
> We can embed range_changed to the extent changeset to address following
> problems:
>
> - no need to allocate ulist dynamically, we also get rid of the GFP_NOFS
>   for free
> - fix lack of allocation failure checking in btrfs_qgroup_reserve_data

Nice catch.

>
> The stack consuption where extent_changeset is used slightly increases:
>
> before: 16
> after: 16 - 8 (for pointer) + 32 (sizeof ulist) = 40
>
> Which is bearable.
>
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu

> ---
>  fs/btrfs/extent_io.c |  2 +-
>  fs/btrfs/extent_io.h |  2 +-
>  fs/btrfs/qgroup.c    | 24 +++++++++---------------
>  3 files changed, 11 insertions(+), 17 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 9df6ed30de00..9140847bfb0c 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -144,7 +144,7 @@ static void add_extent_changeset(struct extent_state *state, unsigned bits,
>  	if (!set && (state->state & bits) == 0)
>  		return;
>  	changeset->bytes_changed += state->end - state->start + 1;
> -	ret = ulist_add(changeset->range_changed, state->start, state->end,
> +	ret = ulist_add(&changeset->range_changed, state->start, state->end,
>  			GFP_ATOMIC);
>  	/* ENOMEM */
>  	BUG_ON(ret < 0);
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 4551a5b4b8f5..270d03be290e 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -193,7 +193,7 @@ struct extent_changeset {
>  	u64 bytes_changed;
>
>  	/* Changed ranges */
> -	struct ulist *range_changed;
> +	struct ulist range_changed;
>  };
>
>  static inline void extent_set_compress_type(unsigned long *bio_flags,
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 971701328229..7cc2e2221f55 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2828,7 +2828,7 @@ int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
>  		return 0;
>
>  	changeset.bytes_changed = 0;
> -	changeset.range_changed = ulist_alloc(GFP_NOFS);
> +	ulist_init(&changeset.range_changed);
>  	ret = set_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
>  			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
>  	trace_btrfs_qgroup_reserve_data(inode, start, len,
> @@ -2840,17 +2840,17 @@ int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
>  	if (ret < 0)
>  		goto cleanup;
>
> -	ulist_free(changeset.range_changed);
> +	ulist_fini(&changeset.range_changed);
>  	return ret;
>
>  cleanup:
>  	/* cleanup already reserved ranges */
>  	ULIST_ITER_INIT(&uiter);
> -	while ((unode = ulist_next(changeset.range_changed, &uiter)))
> +	while ((unode = ulist_next(&changeset.range_changed, &uiter)))
>  		clear_extent_bit(&BTRFS_I(inode)->io_tree, unode->val,
>  				 unode->aux, EXTENT_QGROUP_RESERVED, 0, 0, NULL,
>  				 GFP_NOFS);
> -	ulist_free(changeset.range_changed);
> +	ulist_fini(&changeset.range_changed);
>  	return ret;
>  }
>
> @@ -2862,10 +2862,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
>  	int ret;
>
>  	changeset.bytes_changed = 0;
> -	changeset.range_changed = ulist_alloc(GFP_NOFS);
> -	if (!changeset.range_changed)
> -		return -ENOMEM;
> -
> +	ulist_init(&changeset.range_changed);
>  	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
>  			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
>  	if (ret < 0)
> @@ -2878,7 +2875,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
>  	trace_btrfs_qgroup_release_data(inode, start, len,
>  					changeset.bytes_changed, trace_op);
>  out:
> -	ulist_free(changeset.range_changed);
> +	ulist_fini(&changeset.range_changed);
>  	return ret;
>  }
>
> @@ -2976,22 +2973,19 @@ void btrfs_qgroup_check_reserved_leak(struct inode *inode)
>  	int ret;
>
>  	changeset.bytes_changed = 0;
> -	changeset.range_changed = ulist_alloc(GFP_NOFS);
> -	if (WARN_ON(!changeset.range_changed))
> -		return;
> -
> +	ulist_init(&changeset.range_changed);
>  	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
>  			EXTENT_QGROUP_RESERVED, &changeset);
>
>  	WARN_ON(ret < 0);
>  	if (WARN_ON(changeset.bytes_changed)) {
>  		ULIST_ITER_INIT(&iter);
> -		while ((unode = ulist_next(changeset.range_changed, &iter))) {
> +		while ((unode = ulist_next(&changeset.range_changed, &iter))) {
>  			btrfs_warn(BTRFS_I(inode)->root->fs_info,
>  				"leaking qgroup reserved space, ino: %lu, start: %llu, end: %llu",
>  				inode->i_ino, unode->val, unode->aux);
>  		}
>  		qgroup_free(BTRFS_I(inode)->root, changeset.bytes_changed);
>  	}
> -	ulist_free(changeset.range_changed);
> +	ulist_fini(&changeset.range_changed);
>  }
>


