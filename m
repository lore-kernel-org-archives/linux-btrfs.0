Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E17C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 02:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF09920841
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 02:08:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF09920841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbeJKJdb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 05:33:31 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:14317 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725971AbeJKJdb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 05:33:31 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45902173"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 11 Oct 2018 10:08:31 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id B0E264B71141;
        Thu, 11 Oct 2018 10:08:28 +0800 (CST)
Received: from [10.167.226.24] (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 11 Oct 2018 10:08:33 +0800
Subject: Re: [PATCH v2 3/4] btrfs: Refactor unclustered extent allocation into
 find_free_extent_unclustered()
To:     Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180821084426.7858-1-wqu@suse.com>
 <20180821084426.7858-4-wqu@suse.com>
From:   Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <b0f516ff-c5c9-1689-23b8-4226d39d8a68@cn.fujitsu.com>
Date:   Thu, 11 Oct 2018 10:15:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180821084426.7858-4-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: B0E264B71141.A7B99
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 8/21/18 4:44 PM, Qu Wenruo wrote:
> This patch will extract unclsutered extent allocation code into
> find_free_extent_unclustered().
> 
> And this helper function will use return value to indicate what to do
> next.
> 
> This should make find_free_extent() a little easier to read.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>   fs/btrfs/extent-tree.c | 112 ++++++++++++++++++++++++-----------------
>   1 file changed, 66 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a603900e0eb8..5bc8919edac2 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7546,6 +7546,67 @@ static int find_free_extent_clustered(struct btrfs_block_group_cache *bg,
>   	return 1;
>   }
>   
> +/*
> + * Return >0 to inform caller that we find nothing
> + * Return -EAGAIN to inform caller that we need to re-search this block group

How about adding description of return 0?

Thanks,
Su
> + */
> +static int find_free_extent_unclustered(struct btrfs_block_group_cache *bg,
> +		struct btrfs_free_cluster *last_ptr,
> +		struct find_free_extent_ctrl *ctrl)
> +{
> +	u64 offset;
> +
> +	/*
> +	 * We are doing an unclustered alloc, set the fragmented flag so we
> +	 * don't bother trying to setup a cluster again until we get more space.
> +	 */
> +	if (unlikely(last_ptr)) {
> +		spin_lock(&last_ptr->lock);
> +		last_ptr->fragmented = 1;
> +		spin_unlock(&last_ptr->lock);
> +	}
> +	if (ctrl->cached) {
> +		struct btrfs_free_space_ctl *free_space_ctl;
> +
> +		free_space_ctl = bg->free_space_ctl;
> +		spin_lock(&free_space_ctl->tree_lock);
> +		if (free_space_ctl->free_space <
> +		    ctrl->num_bytes + ctrl->empty_cluster + ctrl->empty_size) {
> +			ctrl->max_extent_size = max_t(u64,
> +					ctrl->max_extent_size,
> +					free_space_ctl->free_space);
> +			spin_unlock(&free_space_ctl->tree_lock);
> +			return 1;
> +		}
> +		spin_unlock(&free_space_ctl->tree_lock);
> +	}
> +
> +	offset = btrfs_find_space_for_alloc(bg, ctrl->search_start,
> +			ctrl->num_bytes, ctrl->empty_size,
> +			&ctrl->max_extent_size);
> +
> +	/*
> +	 * If we didn't find a chunk, and we haven't failed on this block group
> +	 * before, and this block group is in the middle of caching and we are
> +	 * ok with waiting, then go ahead and wait for progress to be made, and
> +	 * set @retry_unclustered to true.
> +	 *
> +	 * If @retry_unclustered is true then we've already waited on this block
> +	 * group once and should move on to the next block group.
> +	 */
> +	if (!offset && !ctrl->retry_unclustered && !ctrl->cached &&
> +	    ctrl->loop > LOOP_CACHING_NOWAIT) {
> +		wait_block_group_cache_progress(bg, ctrl->num_bytes +
> +						ctrl->empty_size);
> +		ctrl->retry_unclustered = true;
> +		return -EAGAIN;
> +	} else if (!offset) {
> +		return 1;
> +	}
> +	ctrl->found_offset = offset;
> +	return 0;
> +}
> +
>   /*
>    * walks the btree of allocated extents and find a hole of a given size.
>    * The key ins is changed to record the hole:
> @@ -7747,54 +7808,13 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
>   			/* ret == -ENOENT case falss through */
>   		}
>   
> -		/*
> -		 * We are doing an unclustered alloc, set the fragmented flag so
> -		 * we don't bother trying to setup a cluster again until we get
> -		 * more space.
> -		 */
> -		if (unlikely(last_ptr)) {
> -			spin_lock(&last_ptr->lock);
> -			last_ptr->fragmented = 1;
> -			spin_unlock(&last_ptr->lock);
> -		}
> -		if (ctrl.cached) {
> -			struct btrfs_free_space_ctl *ctl =
> -				block_group->free_space_ctl;
> -
> -			spin_lock(&ctl->tree_lock);
> -			if (ctl->free_space <
> -			    num_bytes + ctrl.empty_cluster + empty_size) {
> -				if (ctl->free_space > ctrl.max_extent_size)
> -					ctrl.max_extent_size = ctl->free_space;
> -				spin_unlock(&ctl->tree_lock);
> -				goto loop;
> -			}
> -			spin_unlock(&ctl->tree_lock);
> -		}
> -
> -		ctrl.found_offset = btrfs_find_space_for_alloc(block_group,
> -				ctrl.search_start, num_bytes, empty_size,
> -				&ctrl.max_extent_size);
> -		/*
> -		 * If we didn't find a chunk, and we haven't failed on this
> -		 * block group before, and this block group is in the middle of
> -		 * caching and we are ok with waiting, then go ahead and wait
> -		 * for progress to be made, and set ctrl.retry_unclustered to
> -		 * true.
> -		 *
> -		 * If ctrl.retry_unclustered is true then we've already waited
> -		 * on this block group once and should move on to the next block
> -		 * group.
> -		 */
> -		if (!ctrl.found_offset && !ctrl.retry_unclustered &&
> -		    !ctrl.cached && ctrl.loop > LOOP_CACHING_NOWAIT) {
> -			wait_block_group_cache_progress(block_group,
> -						num_bytes + empty_size);
> -			ctrl.retry_unclustered = true;
> +		ret = find_free_extent_unclustered(block_group, last_ptr,
> +						   &ctrl);
> +		if (ret == -EAGAIN)
>   			goto have_block_group;
> -		} else if (!ctrl.found_offset) {
> +		else if (ret > 0)
>   			goto loop;
> -		}
> +		/* ret == 0 case falls through */
>   checks:
>   		ctrl.search_start = round_up(ctrl.found_offset,
>   					     fs_info->stripesize);
> 


