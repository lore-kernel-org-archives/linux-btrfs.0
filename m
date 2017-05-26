Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51243 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S970603AbdEZHJ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 03:09:57 -0400
Subject: Re: [PATCH 1/6] Btrfs: add a helper to retrive extent inline ref type
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
 <20170526002631.8546-2-bo.li.liu@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <cb0f4c50-3871-b688-161a-912628f7dcdb@suse.com>
Date: Fri, 26 May 2017 10:09:54 +0300
MIME-Version: 1.0
In-Reply-To: <20170526002631.8546-2-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.05.2017 03:26, Liu Bo wrote:
> An invalid value of extent inline ref type may be read from a
> malicious image which may force btrfs to crash.
> 
> This adds a helper which does sanity check for the ref type, so we can
> know if it's sane, return type if so, otherwise return an error.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/ctree.h       |  4 ++++
>  fs/btrfs/extent-tree.c | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index c411590..206ae8c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2542,6 +2542,10 @@ static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
>  
>  /* extent-tree.c */
>  
> +int btrfs_get_extent_inline_ref_type(struct extent_buffer *eb,
> +				     struct btrfs_extent_inline_ref *iref,
> +				     int is_data);
> +
>  u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes);
>  
>  static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_fs_info *fs_info,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index be54776..fba8ca0 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -1117,6 +1117,41 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
>  }
>  #endif
>  
> +/*
> + * is_data == 0, tree block type is required,
> + * is_data == 1, data type is requried,
> + * is_data == 2, either type is OK.
> + */

Can you change those numbers to either #defines or better an enum type?
Looking at one call site the last argument being a number says nothing
and one has to context switch to the function definition. E.g. from
patch2 :

*out_type = btrfs_get_extent_inline_ref_type(eb, *out_eiref, 2);

possible names:

BTRFS_BLOCK_REF_TYPE
BTRFS_DATA_REF_TYPE
BTRFS_ANY_TYPE

> +int btrfs_get_extent_inline_ref_type(struct extent_buffer *eb,
> +				     struct btrfs_extent_inline_ref *iref,
> +				     int is_data)
> +{
> +	int type = btrfs_extent_inline_ref_type(eb, iref);
> +
> +	if (type == BTRFS_TREE_BLOCK_REF_KEY ||
> +	    type == BTRFS_SHARED_BLOCK_REF_KEY ||
> +	    type == BTRFS_SHARED_DATA_REF_KEY ||
> +	    type == BTRFS_EXTENT_DATA_REF_KEY) {
> +		if (is_data == 2) {
> +			return type;
> +		} else if (is_data == 1) {
> +			if (type == BTRFS_EXTENT_DATA_REF_KEY ||
> +			    type == BTRFS_SHARED_DATA_REF_KEY)
> +				return type;
> +		} else {
> +			if (type == BTRFS_TREE_BLOCK_REF_KEY ||
> +			    type == BTRFS_SHARED_BLOCK_REF_KEY)
> +				return type;
> +		}
> +	}
> +
> +	btrfs_print_leaf(eb->fs_info, eb);
> +	WARN(1, "eb %llu(%s block) invalid extent inline ref type %d\n",
> +	     eb->start, (is_data) ? "data" : "tree", type);
> +
> +	return -EINVAL;
> +}
> +
>  static u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset)
>  {
>  	u32 high_crc = ~(u32)0;
> 
