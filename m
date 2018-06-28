Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:61634 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751702AbeF1EQ1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 00:16:27 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id A4B2EAC01A0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 13:16:17 +0900 (JST)
Subject: Re: [PATCH v1] btrfs: quota: Set rescan progress to (u64)-1 if we hit
 last leaf
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180627101955.12034-1-wqu@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <60200f56-d020-98ea-c3bf-23a0b189f4e6@jp.fujitsu.com>
Date: Thu, 28 Jun 2018 13:16:01 +0900
MIME-Version: 1.0
In-Reply-To: <20180627101955.12034-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/06/27 19:19, Qu Wenruo wrote:
> Commit ff3d27a048d9 ("btrfs: qgroup: Finish rescan when hit the last leaf
> of extent tree") added a new exit for rescan finish.
> 
> However after finishing quota rescan, we set
> fs_info->qgroup_rescan_progress to (u64)-1 before we exit through the
> original exit path.
> While we missed that assignment of (u64)-1 in the new exit path.
> 
> The end result is, the quota status item doesn't have the same value.
> (-1 vs the last bytenr + 1)
> Although it doesn't affect quota accounting, it's still better to keep
> the original behavior.
> 
> Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Fixes: ff3d27a048d9 ("btrfs: qgroup: Finish rescan when hit the last leaf of extent tree")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v2:
>   Commit message update, as the bug only changes the resulting quota status
>   item without impacting the behavior.


Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

(As you said, the problem I reported in 
https://marc.info/?t=152999303500007&r=1&w=2 is not related to this change)

Thanks,
Tomohiro Misono

> ---
>  fs/btrfs/qgroup.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 1874a6d2e6f5..99f2b9ce0f15 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2680,8 +2680,10 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
>  		free_extent_buffer(scratch_leaf);
>  	}
>  
> -	if (done && !ret)
> +	if (done && !ret) {
>  		ret = 1;
> +		fs_info->qgroup_rescan_progress.objectid = (u64)-1;
> +	}
>  	return ret;
>  }
>  
> 

