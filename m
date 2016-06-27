Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43113 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750759AbcF0Er1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 00:47:27 -0400
Subject: Re: [PATCH 05/14] Btrfs: warn_on for unaccounted spaces
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
 <1458926760-17563-6-git-send-email-jbacik@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d8055e61-f36f-f7d8-8963-e84532a0e31a@cn.fujitsu.com>
Date: Mon, 27 Jun 2016 12:47:13 +0800
MIME-Version: 1.0
In-Reply-To: <1458926760-17563-6-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Would you please move this patch to the first of the patchset?

It's making bisect quite hard, as it will always stop at this patch, 
hard to check if it's a regression or existing bug.

Thanks,
Qu

At 03/26/2016 01:25 AM, Josef Bacik wrote:
> These were hidden behind enospc_debug, which isn't helpful as they indicate
> actual bugs, unlike the rest of the enospc_debug stuff which is really debug
> information.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 157a0b6..90ac821 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9633,13 +9633,15 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
>  		space_info = list_entry(info->space_info.next,
>  					struct btrfs_space_info,
>  					list);
> -		if (btrfs_test_opt(info->tree_root, ENOSPC_DEBUG)) {
> -			if (WARN_ON(space_info->bytes_pinned > 0 ||
> +
> +		/*
> +		 * Do not hide this behind enospc_debug, this is actually
> +		 * important and indicates a real bug if this happens.
> +		 */
> +		if (WARN_ON(space_info->bytes_pinned > 0 ||
>  			    space_info->bytes_reserved > 0 ||
> -			    space_info->bytes_may_use > 0)) {
> -				dump_space_info(space_info, 0, 0);
> -			}
> -		}
> +			    space_info->bytes_may_use > 0))
> +			dump_space_info(space_info, 0, 0);
>  		list_del(&space_info->list);
>  		for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
>  			struct kobject *kobj;
>


