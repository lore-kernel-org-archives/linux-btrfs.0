Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46687 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751663Ab3LMJhQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 04:37:16 -0500
Message-ID: <52AAD595.8040903@cn.fujitsu.com>
Date: Fri, 13 Dec 2013 17:38:29 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Btrfs: avoid building inode cache repeatly
References: <1386926183-18325-1-git-send-email-bo.li.liu@oracle.com> <1386926183-18325-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1386926183-18325-2-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On fri, 13 Dec 2013 17:16:21 +0800, Liu Bo wrote:
> Inode cache is similar to free space cache and in fact shares the same
> code, however, we don't load inode cache unless we're about to allocate
> inode id, then there is a case where we only commit the transaction during
> other operations, such as snapshot creation, we now update fs roots' generation
> to the new transaction id, after that when we want to load the inode cache,
> we'll find that it's not valid thanks to the mismatch of generation, and we
> have to push btrfs-ino-cache thread to build inode cache from disk, and
> this operation is sometimes time-costing.
> 
> So to fix the above, we load inode cache into memory during reading fs root.

This patch will introduce a problem that if some tasks load the same fs root
at the same time, they will building inode cache for it respectively. So I will
NACK this patch. Why not build the inode cache after the fs root is inserted
into the radix tree successfully.

Thanks
Miao

> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/disk-io.c   | 9 +++++----
>  fs/btrfs/inode-map.c | 2 ++
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8072cfa..cb0b12b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1524,14 +1524,15 @@ int btrfs_init_fs_root(struct btrfs_root *root)
>  		goto fail;
>  	}
>  
> -	btrfs_init_free_ino_ctl(root);
> +	ret = get_anon_bdev(&root->anon_dev);
> +	if (ret)
> +		goto fail;
> +
>  	mutex_init(&root->fs_commit_mutex);
>  	spin_lock_init(&root->cache_lock);
>  	init_waitqueue_head(&root->cache_wait);
> +	btrfs_init_free_ino_ctl(root);
>  
> -	ret = get_anon_bdev(&root->anon_dev);
> -	if (ret)
> -		goto fail;
>  	return 0;
>  fail:
>  	kfree(root->free_ino_ctl);
> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> index ab485e5..6c8d7bb 100644
> --- a/fs/btrfs/inode-map.c
> +++ b/fs/btrfs/inode-map.c
> @@ -388,6 +388,8 @@ void btrfs_init_free_ino_ctl(struct btrfs_root *root)
>  	pinned->private = NULL;
>  	pinned->extents_thresh = 0;
>  	pinned->op = &pinned_free_ino_op;
> +
> +	start_caching(root);
>  }
>  
>  int btrfs_save_ino_cache(struct btrfs_root *root,
> 

