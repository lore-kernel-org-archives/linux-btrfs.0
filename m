Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45571 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab3LICKl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Dec 2013 21:10:41 -0500
Date: Mon, 9 Dec 2013 10:10:27 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: more efficient push_leaf_right
Message-ID: <20131209021026.GA32246@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1386195459-15523-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1386195459-15523-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 04, 2013 at 10:17:39PM +0000, Filipe David Borba Manana wrote:
> Currently when finding the leaf to insert a key into a btree, if the
> leaf doesn't have enough space to store the item we attempt to move
> off some items from our leaf to its right neighbor leaf, and if this
> fails to create enough free space in our leaf, we try to move off more
> items to the left neighbor leaf as well.
> 
> When trying to move off items to the right neighbor leaf, if it has
> enough room to store the new key but not not enough room to move off
> at least one item from our target leaf, __push_leaf_right returns 1 and
> we have to attempt to move items to the left neighbor (push_leaf_left
> function) without touching the right neighbor leaf.
> For the case where the right leaf has enough room to store at least 1
> item from our leaf, we end up modifying (and dirtying) both our leaf
> and the right leaf. This is non-optimal for the case where the new key
> is greater than any key in our target leaf because it can be inserted at
> slot 0 of the right neighbor leaf and we don't need to touch our leaf
> at all nor to attempt to move off items to the left neighbor leaf.
> 
> Therefore this change just selects the right neighbor leaf as our new
> target leaf if it has enough room for the new key without modifying our
> initial target leaf - we do this only if the new key is higher than any
> key in the initial target leaf.
> 
> While running the following test, push_leaf_right was called by split_leaf
> 4802 times. Out of those 4802 calls, for 2571 calls (53.5%) we hit this
> special case (right leaf has enough room and new key is higher than any key
> in the initial target leaf).
> 
> Test:
> 
>   sysbench --test=fileio --file-num=512 --file-total-size=5G \
>     --file-test-mode=[seqwr|rndwr] --num-threads=512 --file-block-size=8192 \
>     --max-requests=100000 --file-io-mode=sync [prepare|run]
> 
> Results:
> 
> sequential writes
> 
> Throughput before this change: 65.71Mb/sec (average of 10 runs)
> Throughput after this change:  66.58Mb/sec (average of 10 runs)
> 
> random writes
> 
> Throughput before this change: 10.75Mb/sec (average of 10 runs)
> Throughput after this change:  11.56Mb/sec (average of 10 runs)

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo

> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/ctree.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 11f9a18..a57507a 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -3613,6 +3613,19 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
>  	if (left_nritems == 0)
>  		goto out_unlock;
>  
> +	if (path->slots[0] == left_nritems && !empty) {
> +		/* Key greater than all keys in the leaf, right neighbor has
> +		 * enough room for it and we're not emptying our leaf to delete
> +		 * it, therefore use right neighbor to insert the new item and
> +		 * no need to touch/dirty our left leaft. */
> +		btrfs_tree_unlock(left);
> +		free_extent_buffer(left);
> +		path->nodes[0] = right;
> +		path->slots[0] = 0;
> +		path->slots[1]++;
> +		return 0;
> +	}
> +
>  	return __push_leaf_right(trans, root, path, min_data_size, empty,
>  				right, free_space, left_nritems, min_slot);
>  out_unlock:
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
