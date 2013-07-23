Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35652 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3GWBwZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jul 2013 21:52:25 -0400
Message-ID: <51EDE212.8040708@cn.fujitsu.com>
Date: Tue, 23 Jul 2013 09:53:22 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: reset ret in record_one_backref
References: <1374511955-1830-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1374511955-1830-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On mon, 22 Jul 2013 12:52:35 -0400, Josef Bacik wrote:
> I was getting warnings when running find ./ -type f -exec btrfs fi defrag -f {}
> \; from record_one_backref because ret was set.  Turns out it was because it was
> set to 1 because the search slot didn't come out exact and we never reset it.
> So reset it to 0 right after the search so we don't leak this and get
> uneccessary warnings.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
>  fs/btrfs/inode.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index dd05238..a3a6155 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2132,6 +2132,7 @@ static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
>  		WARN_ON(1);
>  		return ret;
>  	}
> +	ret = 0;
>  
>  	while (1) {
>  		cond_resched();
> @@ -2181,8 +2182,6 @@ static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
>  		    old->len || extent_offset + num_bytes <=
>  		    old->extent_offset + old->offset)
>  			continue;
> -
> -		ret = 0;
>  		break;
>  	}
>  
> 

