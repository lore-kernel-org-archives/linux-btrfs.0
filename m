Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:34145 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3EEN6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 09:58:33 -0400
Received: by mail-pb0-f51.google.com with SMTP id wy7so1571472pbc.24
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 06:58:32 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs: use arg gfp_mask to decide how to allocate tree mod
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1367730320-7660-1-git-send-email-wangshilong1991@gmail.com>
Date: Sun, 5 May 2013 21:58:26 +0800
Cc: Wang Shilong <wangsl-fnst@fujitsu.com>
Message-Id: <5F1F1D90-E9EC-41AC-9DDB-6A91C5292C83@gmail.com>
References: <1367730320-7660-1-git-send-email-wangshilong1991@gmail.com>
To: "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


It seems the original code doesn't pass the right arg gfp_t to decide how to allocate.
Just applying this patch, fsstress will fail. So please ignore this patch, will resend later..

Thanks,
Wang

> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> We have passed arg gfp_mask to tree_mod_alloc(), so
> just use it rather than always use GFP_ATOMIC.
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
> fs/btrfs/ctree.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index de6de8e..0e3514f 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -553,7 +553,7 @@ static inline int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
> 	 * once we switch from spin locks to something different, we should
> 	 * honor the flags parameter here.
> 	 */
> -	tm = *tm_ret = kzalloc(sizeof(*tm), GFP_ATOMIC);
> +	tm = *tm_ret = kzalloc(sizeof(*tm), flags);
> 	if (!tm)
> 		return -ENOMEM;
> 
> -- 
> 1.7.11.7
> 

