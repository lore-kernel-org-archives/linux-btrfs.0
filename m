Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18236 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751469AbaJWIip (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 04:38:45 -0400
Message-ID: <5448BEF7.1080500@cn.fujitsu.com>
Date: Thu, 23 Oct 2014 16:40:23 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: properly clean up btrfs_end_io_wq_cache
References: <1413407999-1154-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1413407999-1154-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 15 Oct 2014 17:19:59 -0400, Josef Bacik wrote:
> In one of Dave's cleanup commits he forgot to call btrfs_end_io_wq_exit on
> unload, which makes us unable to unload and then re-load the btrfs module.  This
> fixes the problem.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
>  fs/btrfs/super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index b83ef15..c1d020f 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2151,6 +2151,7 @@ static void __exit exit_btrfs_fs(void)
>  	extent_map_exit();
>  	extent_io_exit();
>  	btrfs_interface_exit();
> +	btrfs_end_io_wq_exit();
>  	unregister_filesystem(&btrfs_fs_type);
>  	btrfs_exit_sysfs();
>  	btrfs_cleanup_fs_uuids();
> 

