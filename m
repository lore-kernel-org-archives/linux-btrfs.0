Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62078 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754673Ab3GWCDE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jul 2013 22:03:04 -0400
Message-ID: <51EDE48E.3010302@cn.fujitsu.com>
Date: Tue, 23 Jul 2013 10:03:58 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: release both paths before logging dir/changed
 extents
References: <1374512160-1888-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1374512160-1888-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On mon, 22 Jul 2013 12:56:00 -0400, Josef Bacik wrote:
> The ceph guys tripped over this bug where we were still holding onto the
> original path that we used to copy the inode with when logging.  This is based
> on Chris's fix which was reported to fix the problem.  We need to drop the paths
> in two cases anyway so just move the drop up so that we don't have duplicate
> code.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
>  fs/btrfs/tree-log.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 2c67914..ff60d89 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3746,8 +3746,9 @@ next_slot:
>  	}
>  
>  log_extents:
> +	btrfs_release_path(path);
> +	btrfs_release_path(dst_path);
>  	if (fast_search) {
> -		btrfs_release_path(dst_path);
>  		ret = btrfs_log_changed_extents(trans, root, inode, dst_path);
>  		if (ret) {
>  			err = ret;
> @@ -3764,8 +3765,6 @@ log_extents:
>  	}
>  
>  	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->i_mode)) {
> -		btrfs_release_path(path);
> -		btrfs_release_path(dst_path);
>  		ret = log_directory_changes(trans, root, inode, path, dst_path);
>  		if (ret) {
>  			err = ret;
> 

