Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33802 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbcFTSKA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 14:10:00 -0400
Received: by mail-pf0-f179.google.com with SMTP id h14so41184750pfe.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 11:09:53 -0700 (PDT)
Date: Mon, 20 Jun 2016 11:09:51 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] btrfs: fix free space calculation in
 dump_space_info()
Message-ID: <20160620180951.GA16446@vader.DHCP.thefacebook.com>
References: <1466419625-6755-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466419625-6755-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 20, 2016 at 06:47:05PM +0800, Wang Xiaoguang wrote:
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f3e6666..13a87fe 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7736,8 +7736,8 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
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

I think you meant to send this to linux-btrfs@vger.kernel.org

-- 
Omar
