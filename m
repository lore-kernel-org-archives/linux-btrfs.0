Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44620 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751581AbeGBNci (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 09:32:38 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E5BD5AE07
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 13:32:36 +0000 (UTC)
Subject: Re: [PATCH 4/4] btrfs: Remove unnecessary locking code in
 qgroup_rescan_leaf
To: linux-btrfs@vger.kernel.org
References: <1530106705-27186-1-git-send-email-nborisov@suse.com>
 <1530106705-27186-5-git-send-email-nborisov@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2f7e8b4d-8c7d-9c28-3044-33b2676af6e1@suse.com>
Date: Mon, 2 Jul 2018 16:32:35 +0300
MIME-Version: 1.0
In-Reply-To: <1530106705-27186-5-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.06.2018 16:38, Nikolay Borisov wrote:
> In qgroup_rescan_leaf a copy is made of the target leaf by calling
> btrfs_clone_extent_buffer. The latter allocates a new buffer and
> attaches a new set of pages and copies the content of the source
> buffer. The new scratch buffer is only used to iterate it's items, it's
> not published anywhere and cannot be accessed by a third party. Hence,
> it's not necessary to perform any locking on it whatsoever. Furthermore,
> remove the extra extent_buffer_get call since the new buffer is always
> allocated with a reference count of 1 which is sufficient here.
> No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

I'm going to be sending this patch as part of a larger series so you can
ignore it for now.

> ---
>  fs/btrfs/qgroup.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 1874a6d2e6f5..3b57dc247fa2 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2647,9 +2647,6 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
>  		mutex_unlock(&fs_info->qgroup_rescan_lock);
>  		goto out;
>  	}
> -	extent_buffer_get(scratch_leaf);
> -	btrfs_tree_read_lock(scratch_leaf);
> -	btrfs_set_lock_blocking_rw(scratch_leaf, BTRFS_READ_LOCK);
>  	slot = path->slots[0];
>  	btrfs_release_path(path);
>  	mutex_unlock(&fs_info->qgroup_rescan_lock);
> @@ -2675,10 +2672,8 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
>  			goto out;
>  	}
>  out:
> -	if (scratch_leaf) {
> -		btrfs_tree_read_unlock_blocking(scratch_leaf);
> +	if (scratch_leaf)
>  		free_extent_buffer(scratch_leaf);
> -	}
>  
>  	if (done && !ret)
>  		ret = 1;
> 
