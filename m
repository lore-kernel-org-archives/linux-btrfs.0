Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbeEVP7Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 11:59:25 -0400
Date: Tue, 22 May 2018 17:56:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, nborisov@suse.com
Subject: Re: [PATCH 1/2] btrfs: handle failures of set_extent_bits in
 add_excluded_extent
Message-ID: <20180522155641.GT6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526982411-9243-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1526982411-9243-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 05:46:50PM +0800, Gu Jinxiang wrote:
> set_extent_bits may return 0/-EEXIST, so return the result in
> add_excluded_extent.

This is misleading, set_extent_bits can return anything that gets
propagated from the callees, which is 0 and -EEXIST for now but will be
also -ENOMEM eventually. And some callers expect values >= 0 (eg. in
btrfs_get_io_failure_record) , but I haven't examined if this can really
happen.

> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
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

The function is short and fairly linear so you don't need to add the
label, 'return ret' would be ok.

> +	return ret;
>  }
>  
>  static void free_excluded_extents(struct btrfs_fs_info *fs_info,
> -- 
> 1.9.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
