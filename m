Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45351 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752742AbdK2U2X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 15:28:23 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eK8xn-0001ut-78
        for linux-btrfs@vger.kernel.org; Wed, 29 Nov 2017 21:28:11 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Subject: Re: [PATCH v2.1 2/2] btrfs: Ensure btrfs_trim_fs can trim the whole
 fs
Date: Wed, 29 Nov 2017 20:28:04 +0000 (UTC)
Message-ID: <pan$88120$ebd66120$90fe7970$4dcb0a4f@applied-asynchrony.com>
References: <20171128070830.12756-2-wqu@suse.com>
        <20171128072039.13973-1-wqu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: stable@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 28 Nov 2017 15:20:39 +0800, Qu Wenruo wrote:

> [BUG]
> fstrim on some btrfs only trims the unallocated space, not trimming any
> space in existing block groups.
> 
> [CAUSE]
> Before fstrim_range passed to btrfs_trim_fs(), it get truncated to
> range [0, super->total_bytes).
> So later btrfs_trim_fs() will only be able to trim block groups in range
> [0, super->total_bytes).
> 
> While for btrfs, any bytenr aligned to sector size is valid, since btrfs use
> its logical address space, there is nothing limiting the location where
> we put block groups.
> 
> For btrfs with routine balance, it's quite easy to relocate all
> block groups and bytenr of block groups will start beyond super->total_bytes.
> 
> In that case, btrfs will not trim existing block groups.
> 
> [FIX]
> Just remove the truncation in btrfs_ioctl_fitrim(), so btrfs_trim_fs()
> can get the unmodified range, which is normally set to [0, U64_MAX].
> 
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Fixes: f4c697e6406d ("btrfs: return EINVAL if start > total_bytes in fitrim ioctl")
> Cc: <stable@vger.kernel.org> # v4.0+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v2:
>   Locate the root cause in btrfs_ioctl_fitrim(), remove the truncation
>   so we can still allow user to trim custom range.
> v2.1:
>   Include the missing change in btrfs_trim_fs() and update the commit
>   message to reflect this.
> ---
>  fs/btrfs/extent-tree.c |  9 +--------
>  fs/btrfs/ioctl.c       | 11 +++++++----
>  2 files changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f830aa91ac3d..f74958e11008 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10972,14 +10972,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
>  	int dev_ret = 0;
>  	int ret = 0;
>  
> -	/*
> -	 * try to trim all FS space, our block group may start from non-zero.
> -	 */
> -	if (range->len == total_bytes)
> -		cache = btrfs_lookup_first_block_group(fs_info, range->start);
> -	else
> -		cache = btrfs_lookup_block_group(fs_info, range->start);
> -
> +	cache = btrfs_lookup_first_block_group(fs_info, range->start);
>  	for (; cache; cache = next_block_group(fs_info, cache)) {
>  		if (cache->key.objectid >= (range->start + range->len)) {
>  			btrfs_put_block_group(cache);
(..snip..)

This first hunk should also remove total_bytes, otherwise we get an
unused-variable warning:

@@ -10972,19 +10972,11 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
	u64 start;
	u64 end;
	u64 trimmed = 0;
-	u64 total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
	int bg_ret = 0;
 	int dev_ret = 0;
 	int ret = 0;
..etc..
 
cheers,
Holger

