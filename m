Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751199AbeEVKvI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 06:51:08 -0400
Subject: Re: [PATCH 1/2] btrfs: handle failures of set_extent_bits in
 add_excluded_extent
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1526982411-9243-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9cf1e494-7099-7b37-dd38-ac25d56ffe56@suse.com>
Date: Tue, 22 May 2018 13:51:06 +0300
MIME-Version: 1.0
In-Reply-To: <1526982411-9243-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.05.2018 12:46, Gu Jinxiang wrote:
> set_extent_bits may return 0/-EEXIST, so return the result in
> add_excluded_extent.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/extent-tree.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 75cfb80d2551..2e85e99b5e6f 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -215,11 +215,16 @@ static int add_excluded_extent(struct btrfs_fs_info *fs_info,
>  			       u64 start, u64 num_bytes)
>  {
>  	u64 end = start + num_bytes - 1;
> -	set_extent_bits(&fs_info->freed_extents[0],
> +	int ret = 0;
> +
> +	ret = set_extent_bits(&fs_info->freed_extents[0],
>  			start, end, EXTENT_UPTODATE);
> -	set_extent_bits(&fs_info->freed_extents[1],
> +	if (ret)
> +		goto out;
> +	ret = set_extent_bits(&fs_info->freed_extents[1],
>  			start, end, EXTENT_UPTODATE);
> -	return 0;
> +out:
> +	return ret;
>  }
>  
>  static void free_excluded_extents(struct btrfs_fs_info *fs_info,
> 
