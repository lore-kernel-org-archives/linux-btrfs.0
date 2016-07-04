Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbcGDRKC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 13:10:02 -0400
Date: Mon, 4 Jul 2016 19:10:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: fix free space calculation in
 dump_space_info()
Message-ID: <20160704171025.GL13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160629051216.16876-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160629051216.16876-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 29, 2016 at 01:12:16PM +0800, Wang Xiaoguang wrote:

Can you please describe in more detail what is this patch fixing?

> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 8550a0e..520ba8f 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7747,8 +7747,8 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
>  	printk(KERN_INFO "BTRFS: space_info %llu has %llu free, is %sfull\n",
>  	       info->flags,
>  	       info->total_bytes - info->bytes_used - info->bytes_pinned -
> -	       info->bytes_reserved - info->bytes_readonly,
> -	       (info->full) ? "" : "not ");
> +	       info->bytes_reserved - info->bytes_readonly -
> +	       info->bytes_may_use, (info->full) ? "" : "not ");
>  	printk(KERN_INFO "BTRFS: space_info total=%llu, used=%llu, pinned=%llu, "
>  	       "reserved=%llu, may_use=%llu, readonly=%llu\n",
>  	       info->total_bytes, info->bytes_used, info->bytes_pinned,
> -- 
> 2.9.0
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
