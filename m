Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:40782 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab3C3KND (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Mar 2013 06:13:03 -0400
Message-ID: <5156B985.8060506@gmx.net>
Date: Sat, 30 Mar 2013 11:08:05 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org, list.btrfs@jan-o-sch.net,
        wangsl-fnst@cn.fujitsu.com
Subject: Re: [PATCH] Btrfs: cleanup to remove reduplicate code in iterate_extent_inode()
References: <1364564554-1848-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1364564554-1848-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/29/13 14:42, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> Just remove the unnecessary check and assignment.
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/backref.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 3ca413bb..e102b48 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1499,7 +1499,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
>  		if (ret)
>  			break;
>  		ULIST_ITER_INIT(&root_uiter);
> -		while (!ret && (root_node = ulist_next(roots, &root_uiter))) {
> +		while ((root_node = ulist_next(roots, &root_uiter))) {

It doesn't look unnecessary at all to me. ret is set in the loop and
only checked in the while condition.

>  			pr_debug("root %llu references leaf %llu, data list "
>  				 "%#llx\n", root_node->val, ref_node->val,
>  				 (long long)ref_node->aux);
> @@ -1510,7 +1510,6 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
>  						iterate, ctx);
>  		}
>  		ulist_free(roots);
> -		roots = NULL;

roots gets freed again later on. If you don't set it to NULL, it will
result in a double free.

-Arne

>  	}
>  
>  	free_leaf_list(refs);
> 

