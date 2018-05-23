Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50263 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753872AbeEWGNX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 02:13:23 -0400
Subject: Re: [PATCH v2] btrfs: handle failures of set_extent_bits in
 add_excluded_extent
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <1527046667-19550-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <84be1e8a-4e81-5411-2428-bb00d8c03aaf@suse.com>
Date: Wed, 23 May 2018 09:13:21 +0300
MIME-Version: 1.0
In-Reply-To: <1527046667-19550-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.05.2018 06:37, Gu Jinxiang wrote:
> set_extent_bits may fail, return the result in add_excluded_extent.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisvo@suse.com>

> Changelog:
> v2-v1:
>  1.remove goto to make the function run linearly.
>  2.change commit description not pointing out the failure detail,
>    since set_extent_bits's failure type may be added.

The changelog should really go under the scissors line but no need to
resend.

> ---
>  fs/btrfs/extent-tree.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 75cfb80d2551..65ef3456fa62 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -215,11 +215,15 @@ static int add_excluded_extent(struct btrfs_fs_info *fs_info,
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
> +		return ret;
> +	ret = set_extent_bits(&fs_info->freed_extents[1],
>  			start, end, EXTENT_UPTODATE);
> -	return 0;
> +	return ret;
>  }
>  
>  static void free_excluded_extents(struct btrfs_fs_info *fs_info,
> 
