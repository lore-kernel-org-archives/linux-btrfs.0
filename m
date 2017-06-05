Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:34414 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751162AbdFEQD2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jun 2017 12:03:28 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 8E00B60013
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Jun 2017 18:03:21 +0200 (CEST)
Subject: Re: [PATCH] Btrfs: Improve btrfs_ioctl_search_key documentation
References: <20170605152733.25441-1-hans.van.kranenburg@mendix.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <049e0584-0450-a1f7-5f65-c5d150cb8547@mendix.com>
Date: Mon, 5 Jun 2017 18:03:20 +0200
MIME-Version: 1.0
In-Reply-To: <20170605152733.25441-1-hans.van.kranenburg@mendix.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/05/2017 05:27 PM, Hans van Kranenburg wrote:
> A programmer who is trying to implement calling the btrfs SEARCH
> or SEARCH_V2 ioctl will probably soon end up reading this struct
> definition.
> 
> Properly document the input fields to prevent common misconceptions:
>  1. The search space is linear, not 3 dimensional.
>  2. The transaction id (a.k.a. generation) filter applies only on
>  transaction id of the last COW operation on a whole metadata page, not
>  on individual items.
> 
> Ad 1. The first misunderstanding was helped by the previous misleading
> comments on min/max type and offset: "keys returned will be
>> = min and <= max".
> 
> Ad 2. For example, running btrfs balance will happily cause rewriting of
> metadata pages that contain a filesystem tree of a read only subvolume,
> causing transids to be increased.
> 
> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> ---
>  include/uapi/linux/btrfs.h | 63 +++++++++++++++++++++++++++++++---------------
>  1 file changed, 43 insertions(+), 20 deletions(-)
> 
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index a456e5309238..864ad86c5d80 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -427,30 +427,53 @@ struct btrfs_ioctl_ino_lookup_args {
>  };
>  
>  struct btrfs_ioctl_search_key {
> -	/* which root are we searching.  0 is the tree of tree roots */
> -	__u64 tree_id;

Since this 0 is incorrect... I also fixed that...

> -
> -	/* keys returned will be >= min and <= max */
> -	__u64 min_objectid;
> -	__u64 max_objectid;
> -
> -	/* keys returned will be >= min and <= max */
> -	__u64 min_offset;
> -	__u64 max_offset;
> -
> -	/* max and min transids to search for */
> -	__u64 min_transid;
> -	__u64 max_transid;
> +	/*
> +	 * The tree we're searching in. 1 is the tree of tree roots, 2 is the
> +	 * extent tree, etc...

But after trying to feed a tree 0 to SEARCH, I got output, while this
tree does not exist at all...

Then I found this, in ioctl.c:

    if (sk->tree_id == 0) {
        /* search the root of the inode that was passed */
        root = BTRFS_I(inode)->root;
    }

I'll send an updated patch later to also mention that special case,
which is quite useful to know about actually...

Hans

> +	 */
> +	__u64 tree_id;	/* in */
>  
> -	/* keys returned will be >= min and <= max */
> -	__u32 min_type;
> -	__u32 max_type;
> +	/*
> +	 * This struct is used to provide the search key range for the SEARCH and
> +	 * SEARCH_V2 ioctls.
> +	 *
> +	 * When doing a tree search, we're actually taking a slice from a linear
> +	 * search space of 136-bit keys:
> +	 *
> +	 * Key of the first possible item to be returned:
> +	 *   (min_objectid << 72) + (min_type << 64) + min_offset
> +	 * Key of the last possible item to be returned:
> +	 *   (max_objectid << 72) + (max_type << 64) + max_offset
> +	 *
> +	 * All of the min/max input numbers only define the ultimate lower and
> +	 * upper boundary of the keys of items that will be returned. In other
> +	 * words, they are not used to filter the type or offset of intermediate
> +	 * keys encountered.
> +	 *
> +	 * Additionally, we can filter the items returned on transaction id of the
> +	 * metadata block they're stored in by specifying a transid range.  Be
> +	 * aware that this transaction id only denotes when the metadata page that
> +	 * currently contains the item got written the last time as result of a COW
> +	 * operation.  The number does not have any meaning related to the
> +	 * transaction in which an individual item that is being returned was
> +	 * created or changed.
> +	 */
> +	__u64 min_objectid;	/* in */
> +	__u64 max_objectid;	/* in */
> +	__u64 min_offset;	/* in */
> +	__u64 max_offset;	/* in */
> +	__u64 min_transid;	/* in */
> +	__u64 max_transid;	/* in */
> +	__u32 min_type;	/* in */
> +	__u32 max_type;	/* in */
>  
>  	/*
> -	 * how many items did userland ask for, and how many are we
> -	 * returning
> +	 * input: The maximum amount of results desired.
> +	 * output: The actual amount of items returned, restricted by either
> +	 *   stopping the search when reaching the input nr_items amount of items,
> +	 *   or restricted by the size of the supplied memory buffer.
>  	 */
> -	__u32 nr_items;
> +	__u32 nr_items;	/* in/out */
>  
>  	/* align to 64 bits */
>  	__u32 unused;
> 


-- 
Hans van Kranenburg
