Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46790 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab3EVBeo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 May 2013 21:34:44 -0400
Message-ID: <519C20F7.1090709@cn.fujitsu.com>
Date: Wed, 22 May 2013 09:35:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: chris.mason@fusionio.com, yongjun_wei@trendmicro.com.cn,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH -next] Btrfs: return error code in btrfs_check_trunc_cache_free_space()
References: <CAPgLHd99KGnuvOqOzKHveWLg1huNK1b9=PbC331nKrGXrGF54w@mail.gmail.com>
In-Reply-To: <CAPgLHd99KGnuvOqOzKHveWLg1huNK1b9=PbC331nKrGXrGF54w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 21 May 2013 10:39:21 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return error code instead always return 0 from function
> btrfs_check_trunc_cache_free_space().
> Introduced by commit 7b61cd92242542944fc27024900c495a6a7b3396
> (Btrfs: don't use global block reservation for inode cache truncation)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks for your fix.

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
>  fs/btrfs/free-space-cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index e530096..73577f4 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -213,7 +213,7 @@ int btrfs_check_trunc_cache_free_space(struct btrfs_root *root,
>  	else
>  		ret = 0;
>  	spin_unlock(&rsv->lock);
> -	return 0;
> +	return ret;
>  }
>  
>  int btrfs_truncate_free_space_cache(struct btrfs_root *root,
> 
> 

