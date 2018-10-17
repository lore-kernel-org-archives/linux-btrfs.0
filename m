Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C28DECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 14:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C2CC2150F
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 14:56:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C2CC2150F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbeJQWwR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 18:52:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:58140 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727000AbeJQWwR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 18:52:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E258EAE8F
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2018 14:56:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 28439DAD55; Wed, 17 Oct 2018 16:56:03 +0200 (CEST)
Date:   Wed, 17 Oct 2018 16:56:01 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 2/4] btrfs: Refactor clustered extent allocation into
 find_free_extent_clustered()
Message-ID: <20181017145601.GF29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181017065606.8707-1-wqu@suse.com>
 <20181017065606.8707-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181017065606.8707-3-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 17, 2018 at 02:56:04PM +0800, Qu Wenruo wrote:
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7261,6 +7261,115 @@ struct find_free_extent_ctl {
>  	u64 found_offset;
>  };
>  
> +

No extra newlines.

> +/*
> + * Helper function for find_free_extent().
> + *
> + * Return -ENOENT to inform caller that we need fallback to unclustered mode.
> + * Return -EAGAIN to inform caller that we need to re-search this block group
> + * Return >0 to inform caller that we find nothing
> + * Return 0 means we have found a location and set ffe_ctl->found_offset.
> + */
> +static int find_free_extent_clustered(struct btrfs_block_group_cache *bg,
> +		struct btrfs_free_cluster *last_ptr,
> +		struct find_free_extent_ctl *ffe_ctl,
> +		struct btrfs_block_group_cache **cluster_bg_ret)
> +{
> +	struct btrfs_fs_info *fs_info = bg->fs_info;
> +	struct btrfs_block_group_cache *cluster_bg;
> +	u64 aligned_cluster;
> +	u64 offset;
> +	int ret;
> +
> +	cluster_bg = btrfs_lock_cluster(bg, last_ptr, ffe_ctl->delalloc);
> +	if (!cluster_bg)
> +		goto refill_cluster;
> +	if (cluster_bg != bg && (cluster_bg->ro ||
> +	    !block_group_bits(cluster_bg, ffe_ctl->flags)))
> +		goto release_cluster;
> +
> +	offset = btrfs_alloc_from_cluster(cluster_bg, last_ptr,
> +			ffe_ctl->num_bytes, cluster_bg->key.objectid,
> +			&ffe_ctl->max_extent_size);
> +	if (offset) {
> +		/* we have a block, we're done */
> +		spin_unlock(&last_ptr->refill_lock);
> +		trace_btrfs_reserve_extent_cluster(cluster_bg,
> +				ffe_ctl->search_start, ffe_ctl->num_bytes);
> +		*cluster_bg_ret = cluster_bg;
> +		ffe_ctl->found_offset = offset;
> +		return 0;
> +	}
> +	WARN_ON(last_ptr->block_group != cluster_bg);
> +release_cluster:
> +	/* If we are on LOOP_NO_EMPTY_SIZE, we can't set up a new clusters, so

If you move or update comment that does not follow our preferred style,
please fix it.

I'll fix both and maybe more that I find while committing the patches.

> +	 * lets just skip it and let the allocator find whatever block it can
> +	 * find. If we reach this point, we will have tried the cluster
> +	 * allocator plenty of times and not have found anything, so we are
> +	 * likely way too fragmented for the clustering stuff to find anything.
> +	 *
> +	 * However, if the cluster is taken from the current block group,
> +	 * release the cluster first, so that we stand a better chance of
> +	 * succeeding in the unclustered allocation.
> +	 */
