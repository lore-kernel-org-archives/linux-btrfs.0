Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58146 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755067AbeDTO3y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 10:29:54 -0400
Subject: Re: [PATCH 1/3] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180419093816.888-1-wqu@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <6df01860-98e8-b4a1-0d76-68a22511ca52@oracle.com>
Date: Fri, 20 Apr 2018 22:32:03 +0800
MIME-Version: 1.0
In-Reply-To: <20180419093816.888-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/19/2018 05:38 PM, Qu Wenruo wrote:
> Although we have already checked incompat flags manually before really
> mounting it, we could still enhance btrfs_check_super_valid() to check
> incompat flags for later write time super block validation check.
> 
> This patch adds such incompat flags check for btrfs_check_super_valid(),
> currently it won't be triggered, but provides the basis for later write
> time check.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/disk-io.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 60caa68c3618..ec123158f051 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4104,6 +4104,19 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
>   		ret = -EINVAL;
>   	}
>   
> +	/*
> +	 * Before calling btrfs_check_super_valid() we have already checked
> +	 * incompat flags. So if we developr new incompat flags, it's must be
> +	 * some corruption.
> +	 */
> +	if (btrfs_super_incompat_flags(sb) & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
> +		btrfs_err(fs_info,
> +		"corrupted incompat flags detected 0x%llx, supported 0x%llx",
> +			  btrfs_super_incompat_flags(sb),
> +			  BTRFS_FEATURE_INCOMPAT_SUPP);
> +		ret = -EINVAL;
> +	}
> +
>   	/*
>   	 * The generation is a global counter, we'll trust it more than the others
>   	 * but it's still possible that it's the one that's wrong.
> 

This patch should move the existing check in the open_ctree() line 2707
into the btrfs_check_super_valid(), we don't need duplicate checks.

disk-io.c

2707         features = btrfs_super_incompat_flags(disk_super) &
2708                 ~BTRFS_FEATURE_INCOMPAT_SUPP;
2709         if (features) {
2710                 btrfs_err(fs_info,
2711                     "cannot mount because of unsupported optional features (%llx)",
2712                     features);
2713                 err = -EINVAL;
2714                 goto fail_alloc;
2715         }


Thanks, Anand
