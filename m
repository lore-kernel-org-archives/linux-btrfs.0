Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12836 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965772Ab3GSH5P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jul 2013 03:57:15 -0400
Message-ID: <51E8F193.5030009@cn.fujitsu.com>
Date: Fri, 19 Jul 2013 15:58:11 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add missing path alloc return value check
References: <1374216370-18953-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1374216370-18953-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 18 Jul 2013 23:46:10 -0700, Filipe David Borba Manana wrote:
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  extent-tree.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/extent-tree.c b/extent-tree.c
> index f597e16..8e93bab 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -1577,6 +1577,8 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
>  				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
>  
>  	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
>  	path->reada = 1;
>  
>  	key.objectid = bytenr;
> 

Many functions have the same problem, you can fix them in this patch.

Thanks
Miao
