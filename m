Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0604BC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 02:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E22D20841
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 02:17:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E22D20841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbeJKJmS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 05:42:18 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:46153 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725971AbeJKJmS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 05:42:18 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45902883"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 11 Oct 2018 10:17:17 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9ADA34B71F25;
        Thu, 11 Oct 2018 10:17:15 +0800 (CST)
Received: from [10.167.226.24] (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 11 Oct 2018 10:17:21 +0800
Subject: Re: [PATCH v2 4/4] btrfs: Refactor find_free_extent() loops update
 into find_free_extent_update_loop()
To:     Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180821084426.7858-1-wqu@suse.com>
 <20180821084426.7858-5-wqu@suse.com>
From:   Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <ed3ded5d-77fe-b499-9c01-697a3020e6d0@cn.fujitsu.com>
Date:   Thu, 11 Oct 2018 10:24:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180821084426.7858-5-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: 9ADA34B71F25.AB71D
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 8/21/18 4:44 PM, Qu Wenruo wrote:
> We have a complex loop design for find_free_extent(), that has different
> behavior for each loop, some even includes new chunk allocation.
> 
> Instead of putting such a long code into find_free_extent() and makes it
> harder to read, just extract them into find_free_extent_update_loop().
> 
> With all the cleanups, the main find_free_extent() should be pretty
> barebone:
> 
> find_free_extent()
> |- Iterate through all block groups
> |  |- Get a valid block group
> |  |- Try to do clustered allocation in that block group
> |  |- Try to do unclustered allocation in that block group
> |  |- Check if the result is valid
> |  |  |- If valid, then exit
> |  |- Jump to next block group
> |
> |- Push harder to find free extents
>     |- If not found, re-iterate all block groups
> 
Clean enough.

> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
>   fs/btrfs/extent-tree.c | 218 ++++++++++++++++++++++-------------------
>   1 file changed, 117 insertions(+), 101 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 5bc8919edac2..eeec20238f78 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7415,7 +7415,9 @@ struct find_free_extent_ctrl {
>   	/* RAID index, converted from flags */
>   	int index;
>   
> -	/* Current loop number */
> +	/*
> +	 * Current loop number, check find_free_extent_update_loop() for details
> +	 */
>   	int loop;
>   
>   	/*
> @@ -7607,6 +7609,117 @@ static int find_free_extent_unclustered(struct btrfs_block_group_cache *bg,
>   	return 0;
>   }
>   
> +/*
> + * Return >0 means caller needs to re-search for free extent
> + * Return 0 means we have the needed free extent.
> + * Return <0 means we failed to locate any free extent.
> + */
> +static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
> +					struct btrfs_free_cluster *last_ptr,
> +					struct btrfs_key *ins,
> +					struct find_free_extent_ctrl *ctrl,
> +					int full_search, bool use_cluster)
> +{
> +	struct btrfs_root *root = fs_info->extent_root;
> +	int ret;
> +
> +	if ((ctrl->loop == LOOP_CACHING_NOWAIT) && ctrl->have_caching_bg &&
> +	    !ctrl->orig_have_caching_bg)
> +		ctrl->orig_have_caching_bg = true;
> +
> +	if (!ins->objectid && ctrl->loop >= LOOP_CACHING_WAIT &&
> +	     ctrl->have_caching_bg)
> +		return 1;
> +
> +	if (!ins->objectid && ++(ctrl->index) < BTRFS_NR_RAID_TYPES)
> +		return 1;
> +
> +	/*
> +	 * LOOP_CACHING_NOWAIT, search partially cached block groups, kicking
> +	 *			caching kthreads as we move along
> +	 * LOOP_CACHING_WAIT, search everything, and wait if our bg is caching
> +	 * LOOP_ALLOC_CHUNK, force a chunk allocation and try again
> +	 * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and try
> +	 *			again
> +	 */
> +	if (!ins->objectid && ctrl->loop < LOOP_NO_EMPTY_SIZE) {
> +		ctrl->index = 0;
> +		if (ctrl->loop == LOOP_CACHING_NOWAIT) {
> +			/*
> +			 * We want to skip the LOOP_CACHING_WAIT step if we
> +			 * don't have any uncached bgs and we've already done a
> +			 * full search through.
> +			 */
> +			if (ctrl->orig_have_caching_bg || !full_search)
> +				ctrl->loop = LOOP_CACHING_WAIT;
> +			else
> +				ctrl->loop = LOOP_ALLOC_CHUNK;
> +		} else {
> +			ctrl->loop++;
> +		}
> +
> +		if (ctrl->loop == LOOP_ALLOC_CHUNK) {
> +			struct btrfs_trans_handle *trans;
> +			int exist = 0;
> +
> +			trans = current->journal_info;
> +			if (trans)
> +				exist = 1;
> +			else
> +				trans = btrfs_join_transaction(root);
> +
> +			if (IS_ERR(trans)) {
> +				ret = PTR_ERR(trans);
> +				return ret;
> +			}
> +
> +			ret = do_chunk_alloc(trans, fs_info, ctrl->flags,
> +					     CHUNK_ALLOC_FORCE);
> +
> +			/*
> +			 * If we can't allocate a new chunk we've already looped
> +			 * through at least once, move on to the NO_EMPTY_SIZE
> +			 * case.
> +			 */
> +			if (ret == -ENOSPC)
> +				ctrl->loop = LOOP_NO_EMPTY_SIZE;
> +
> +			/* Do not bail out on ENOSPC since we can do more. */
> +			if (ret < 0 && ret != -ENOSPC)
> +				btrfs_abort_transaction(trans, ret);
> +			else
> +				ret = 0;
> +			if (!exist)
> +				btrfs_end_transaction(trans);
> +			if (ret)
> +				return ret;
> +		}
> +
> +		if (ctrl->loop == LOOP_NO_EMPTY_SIZE) {
> +			/*
> +			 * Don't loop again if we already have no empty_size and
> +			 * no empty_cluster.
> +			 */
> +			if (ctrl->empty_size == 0 &&
> +			    ctrl->empty_cluster == 0)
> +				return -ENOSPC;
> +			ctrl->empty_size = 0;
> +			ctrl->empty_cluster = 0;
> +		}
> +		return 1;
> +	} else if (!ins->objectid) {
> +		ret = -ENOSPC;
> +	} else if (ins->objectid) {
> +		if (!use_cluster && last_ptr) {
> +			spin_lock(&last_ptr->lock);
> +			last_ptr->window_start = ins->objectid;
> +			spin_unlock(&last_ptr->lock);
> +		}
> +		ret = 0;
> +	}
> +	return ret;
> +}
> +
>   /*
>    * walks the btree of allocated extents and find a hole of a given size.
>    * The key ins is changed to record the hole:
> @@ -7624,7 +7737,6 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>   				u64 flags, int delalloc)
>   {
>   	int ret = 0;
> -	struct btrfs_root *root = fs_info->extent_root;
>   	struct btrfs_free_cluster *last_ptr = NULL;
>   	struct btrfs_block_group_cache *block_group = NULL;
>   	struct find_free_extent_ctrl ctrl = {0};
> @@ -7858,107 +7970,11 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>   	}
>   	up_read(&space_info->groups_sem);
>   
> -	if ((ctrl.loop == LOOP_CACHING_NOWAIT) && ctrl.have_caching_bg
> -		&& !ctrl.orig_have_caching_bg)
> -		ctrl.orig_have_caching_bg = true;
> -
> -	if (!ins->objectid && ctrl.loop >= LOOP_CACHING_WAIT &&
> -	    ctrl.have_caching_bg)
> -		goto search;
> -
> -	if (!ins->objectid && ++ctrl.index < BTRFS_NR_RAID_TYPES)
> +	ret = find_free_extent_update_loop(fs_info, last_ptr, ins, &ctrl,
> +					   full_search, use_cluster);
> +	if (ret > 0)
>   		goto search;
>   
> -	/*
> -	 * LOOP_CACHING_NOWAIT, search partially cached block groups, kicking
> -	 *			caching kthreads as we move along
> -	 * LOOP_CACHING_WAIT, search everything, and wait if our bg is caching
> -	 * LOOP_ALLOC_CHUNK, force a chunk allocation and try again
> -	 * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and try
> -	 *			again
> -	 */
> -	if (!ins->objectid && ctrl.loop < LOOP_NO_EMPTY_SIZE) {
> -		ctrl.index = 0;
> -		if (ctrl.loop == LOOP_CACHING_NOWAIT) {
> -			/*
> -			 * We want to skip the LOOP_CACHING_WAIT step if we
> -			 * don't have any uncached bgs and we've already done a
> -			 * full search through.
> -			 */
> -			if (ctrl.orig_have_caching_bg || !full_search)
> -				ctrl.loop = LOOP_CACHING_WAIT;
> -			else
> -				ctrl.loop = LOOP_ALLOC_CHUNK;
> -		} else {
> -			ctrl.loop++;
> -		}
> -
> -		if (ctrl.loop == LOOP_ALLOC_CHUNK) {
> -			struct btrfs_trans_handle *trans;
> -			int exist = 0;
> -
> -			trans = current->journal_info;
> -			if (trans)
> -				exist = 1;
> -			else
> -				trans = btrfs_join_transaction(root);
> -
> -			if (IS_ERR(trans)) {
> -				ret = PTR_ERR(trans);
> -				goto out;
> -			}
> -
> -			ret = do_chunk_alloc(trans, fs_info, flags,
> -					     CHUNK_ALLOC_FORCE);
> -
> -			/*
> -			 * If we can't allocate a new chunk we've already looped
> -			 * through at least once, move on to the NO_EMPTY_SIZE
> -			 * case.
> -			 */
> -			if (ret == -ENOSPC)
> -				ctrl.loop = LOOP_NO_EMPTY_SIZE;
> -
> -			/*
> -			 * Do not bail out on ENOSPC since we
> -			 * can do more things.
> -			 */
> -			if (ret < 0 && ret != -ENOSPC)
> -				btrfs_abort_transaction(trans, ret);
> -			else
> -				ret = 0;
> -			if (!exist)
> -				btrfs_end_transaction(trans);
> -			if (ret)
> -				goto out;
> -		}
> -
> -		if (ctrl.loop == LOOP_NO_EMPTY_SIZE) {
> -			/*
> -			 * Don't loop again if we already have no empty_size and
> -			 * no empty_cluster.
> -			 */
> -			if (empty_size == 0 &&
> -			    ctrl.empty_cluster == 0) {
> -				ret = -ENOSPC;
> -				goto out;
> -			}
> -			empty_size = 0;
> -			ctrl.empty_cluster = 0;
> -		}
> -
> -		goto search;
> -	} else if (!ins->objectid) {
> -		ret = -ENOSPC;
> -	} else if (ins->objectid) {
> -		if (!use_cluster && last_ptr) {
> -			spin_lock(&last_ptr->lock);
> -			last_ptr->window_start = ins->objectid;
> -			spin_unlock(&last_ptr->lock);
> -		}
> -		ret = 0;
> -	}
> -out:
>   	if (ret == -ENOSPC) {
>   		spin_lock(&space_info->lock);
>   		space_info->max_extent_size = ctrl.max_extent_size;
> 


