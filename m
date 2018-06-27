Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934391AbeF0PoL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 11:44:11 -0400
Subject: Re: [PATCH] Btrfs: fix mount failure when qgroup rescan is in
 progress
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20180626234315.15643-1-fdmanana@kernel.org>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7aed7d16-ec6b-ec08-e5da-63e6bb2dede8@suse.com>
Date: Wed, 27 Jun 2018 18:44:08 +0300
MIME-Version: 1.0
In-Reply-To: <20180626234315.15643-1-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.06.2018 02:43, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If a power failure happens while the qgroup rescan kthread is running,
> the next mount operation will always fail. This is because of a recent
> regression that makes qgroup_rescan_init() incorrectly return -EINVAL
> when we are mounting the filesystem (through btrfs_read_qgroup_config()).
> This causes the -EINVAL error to be returned regardless of any qgroup
> flags being set instead of returning the error only when neither of
> the flags BTRFS_QGROUP_STATUS_FLAG_RESCAN nor BTRFS_QGROUP_STATUS_FLAG_ON
> are set.
> 
> A test case for fstests follows up soon.
> 
> Fixes: 9593bf49675e ("btrfs: qgroup: show more meaningful qgroup_rescan_init error message")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/qgroup.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 1874a6d2e6f5..d4171de93087 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2784,13 +2784,20 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
>  
>  	if (!init_flags) {
>  		/* we're resuming qgroup rescan at mount time */
> -		if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN))
> +		if (!(fs_info->qgroup_flags &
> +		      BTRFS_QGROUP_STATUS_FLAG_RESCAN)) {
>  			btrfs_warn(fs_info,
>  			"qgroup rescan init failed, qgroup is not enabled");
> -		else if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))
> +			ret = -EINVAL;
> +		} else if (!(fs_info->qgroup_flags &
> +			     BTRFS_QGROUP_STATUS_FLAG_ON)) {
>  			btrfs_warn(fs_info,
>  			"qgroup rescan init failed, qgroup rescan is not queued");
> -		return -EINVAL;
> +			ret = -EINVAL;
> +		}
> +
> +		if (ret)
> +			return ret;


How is this patch functionally different than the old code. In both
cases if either of those 2 is not set a warn is printed and -EINVAL is
returned?

>  	}
>  
>  	mutex_lock(&fs_info->qgroup_rescan_lock);
> 
