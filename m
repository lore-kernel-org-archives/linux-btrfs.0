Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:59331 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab3H2Ntk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 09:49:40 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2EC469A03ED
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 07:49:40 -0600 (MDT)
Date: Thu, 29 Aug 2013 09:49:37 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: <linux-btrfs@vger.kernel.org>, <sbehrens@giantdisaster.de>
Subject: Re: [PATCH] Btrfs: optimize key searches in btrfs_search_slot
Message-ID: <20130829134937.GA10591@localhost.localdomain>
References: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 29, 2013 at 01:44:13PM +0100, Filipe David Borba Manana wrote:
> When the binary search returns 0 (exact match), the target key
> will necessarily be at slot 0 of all nodes below the current one,
> so in this case the binary search is not needed because it will
> always return 0, and we waste time doing it, holding node locks
> for longer than necessary, etc.
> 
> Below follow histograms with the times spent on the current approach of
> doing a binary search when the previous binary search returned 0, and
> times for the new approach, which directly picks the first item/child
> node in the leaf/node.
> 
> Current approach:
> 
> Count: 5013
> Range: 25.000 - 497.000; Mean: 82.767; Median: 64.000; Stddev: 49.972
> Percentiles:  90th: 141.000; 95th: 182.000; 99th: 287.000
>   25.000 -   33.930:   211 ######
>   33.930 -   45.927:   277 ########
>   45.927 -   62.045:  1834 #####################################################
>   62.045 -   83.699:  1203 ###################################
>   83.699 -  112.789:   609 ##################
>  112.789 -  151.872:   450 #############
>  151.872 -  204.377:   246 #######
>  204.377 -  274.917:   124 ####
>  274.917 -  369.684:    48 #
>  369.684 -  497.000:    11 |
> 
> Approach proposed by this patch:
> 
> Count: 5013
> Range: 10.000 - 8303.000; Mean: 28.505; Median: 18.000; Stddev: 119.147
> Percentiles:  90th: 49.000; 95th: 74.000; 99th: 115.000
>  10.000 -   20.339:  3160 #####################################################
>  20.339 -   40.397:  1131 ###################
>  40.397 -   79.308:   507 #########
>  79.308 -  154.794:   199 ###
> 154.794 -  301.232:    14 |
> 301.232 -  585.313:     1 |
> 585.313 - 8303.000:     1 |
> 
> These samples were captured during a run of the btrfs tests 001, 002 and
> 004 in the xfstests, with a leaf/node size of 4Kb.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/ctree.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 59 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 5fa521b..5b20eec 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2426,6 +2426,59 @@ done:
>  	return ret;
>  }
>  
> +static int key_search(struct extent_buffer *b, struct btrfs_key *key,
> +		      int level, int *prev_cmp, int *slot)
> +{
> +	unsigned long eb_offset = 0;
> +	unsigned long len_left = b->len;
> +	char *kaddr = NULL;
> +	unsigned long map_start = 0;
> +	unsigned long map_len = 0;
> +	unsigned long offset;
> +	struct btrfs_disk_key *k = NULL;
> +	struct btrfs_disk_key unaligned;
> +
> +	if (*prev_cmp != 0) {
> +		*prev_cmp = bin_search(b, key, level, slot);
> +		return *prev_cmp;
> +	}
> +
> +	if (level == 0)
> +		offset = offsetof(struct btrfs_leaf, items);
> +	else
> +		offset = offsetof(struct btrfs_node, ptrs);
> +
> +	/*
> +	 * Map the entire extent buffer, otherwise callers can't access
> +	 * all keys/items of the leaf/node. Specially needed for case
> +	 * where leaf/node size is greater than page cache size.
> +	 */
> +	while (len_left > 0) {
> +		unsigned long len = min(PAGE_CACHE_SIZE, len_left);
> +		int err;
> +
> +		err = map_private_extent_buffer(b, eb_offset, len, &kaddr,
> +						&map_start, &map_len);
> +		len_left -= len;
> +		eb_offset += len;
> +		if (k)
> +			continue;
> +		if (!err) {
> +			k = (struct btrfs_disk_key *)(kaddr + offset -
> +						      map_start);
> +		} else {
> +			read_extent_buffer(b, &unaligned,
> +					   offset, sizeof(unaligned));
> +			k = &unaligned;
> +		}
> +	}
> +

This confuses me, if we're at slot 0 we should be at the front of the first
page, no matter what, so why not just read the first key and carry on?

> +	BUG_ON(comp_keys(k, key) != 0);

Please use the ASSERT() macro.  Thanks,

Josef
