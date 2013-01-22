Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20791 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3AVO1I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 09:27:08 -0500
Date: Tue, 22 Jan 2013 22:24:15 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH 1/5] Btrfs: fix repeated delalloc work allocation
Message-ID: <20130122142414.GA15978@liubo>
Reply-To: bo.li.liu@oracle.com
References: <50FE6E9C.2040803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50FE6E9C.2040803@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 06:49:00PM +0800, Miao Xie wrote:
> btrfs_start_delalloc_inodes() locks the delalloc_inodes list, fetches the
> first inode, unlocks the list, triggers btrfs_alloc_delalloc_work/
> btrfs_queue_worker for this inode, and then it locks the list, checks the
> head of the list again. But because we don't delete the first inode that it
> deals with before, it will fetch the same inode. As a result, this function
> allocates a huge amount of btrfs_delalloc_work structures, and OOM happens.
> 
> Fix this problem by splice this delalloc list.
> 
> Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c |   55 ++++++++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 41 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 67ed24a..86f1d25 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7545,41 +7545,61 @@ void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work)
>   */
>  int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
>  {
> -	struct list_head *head = &root->fs_info->delalloc_inodes;
>  	struct btrfs_inode *binode;
>  	struct inode *inode;
>  	struct btrfs_delalloc_work *work, *next;
>  	struct list_head works;
> +	struct list_head splice;
>  	int ret = 0;
>  
>  	if (root->fs_info->sb->s_flags & MS_RDONLY)
>  		return -EROFS;
>  
>  	INIT_LIST_HEAD(&works);
> -
> +	INIT_LIST_HEAD(&splice);
> +again:
>  	spin_lock(&root->fs_info->delalloc_lock);
> -	while (!list_empty(head)) {
> -		binode = list_entry(head->next, struct btrfs_inode,
> +	list_splice_init(&root->fs_info->delalloc_inodes, &splice);
> +	while (!list_empty(&splice)) {
> +		binode = list_entry(splice.next, struct btrfs_inode,
>  				    delalloc_inodes);
> +
> +		list_del_init(&binode->delalloc_inodes);
> +

I believe this patch can work well, but it's a little complex.

How about adding a flag in runtime_flags set?

We can use the flag instead of 'delalloc_inodes' list to tell if we
have clear the delalloc bytes, and the most important thing is it
won't touch the original code logic too much.

thanks,
liubo

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 67ed24a..692ed0e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1555,8 +1555,8 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 		BTRFS_I(inode)->delalloc_bytes -= len;
 
 		if (do_list && BTRFS_I(inode)->delalloc_bytes == 0 &&
-		    !list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
-			list_del_init(&BTRFS_I(inode)->delalloc_inodes);
+		    test_bit(BTRFS_INODE_FLUSH, &BTRFS_I(inode)->runtime_flags)) {
+			clear_bit(BTRFS_INODE_FLUSH, &BTRFS_I(inode)->runtime_flags);
 		}
 		spin_unlock(&root->fs_info->delalloc_lock);
 	}
@@ -7562,8 +7562,9 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 		binode = list_entry(head->next, struct btrfs_inode,
 				    delalloc_inodes);
 		inode = igrab(&binode->vfs_inode);
-		if (!inode)
-			list_del_init(&binode->delalloc_inodes);
+
+		list_del_init(&binode->delalloc_inodes);
+
 		spin_unlock(&root->fs_info->delalloc_lock);
 		if (inode) {
 			work = btrfs_alloc_delalloc_work(inode, 0, delay_iput);
@@ -7572,6 +7573,7 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 				goto out;
 			}
 			list_add_tail(&work->list, &works);
+			set_bit(BTRFS_INODE_FLUSH, &binode->runtime_flags);
 			btrfs_queue_worker(&root->fs_info->flush_workers,
 					   &work->work);
 		}
@@ -7580,6 +7582,18 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 	}
 	spin_unlock(&root->fs_info->delalloc_lock);
 
+	/* make sure we clear all delalloc bytes we have scheduled */
+	while (!list_empty(&works)) {
+		work = list_entry(works.next, struct btrfs_delalloc_work,
+				  list);
+		binode = btrfs_ino(work->inode);
+		if (!test_bit(BTRFS_INODE_FLUSH, &binode->runtime_flags)) {
+			list_del_init(&work->list);
+			btrfs_wait_and_free_delalloc_work(work);
+		}
+		cond_resched();
+	}
+
 	/* the filemap_flush will queue IO into the worker threads, but
 	 * we have to make sure the IO is actually started and that
 	 * ordered extents get created before we return



>  		inode = igrab(&binode->vfs_inode);
>  		if (!inode)
> -			list_del_init(&binode->delalloc_inodes);
> +			continue;
> +
> +		list_add_tail(&binode->delalloc_inodes,
> +			      &root->fs_info->delalloc_inodes);
>  		spin_unlock(&root->fs_info->delalloc_lock);
> -		if (inode) {
> -			work = btrfs_alloc_delalloc_work(inode, 0, delay_iput);
> -			if (!work) {
> -				ret = -ENOMEM;
> -				goto out;
> -			}
> -			list_add_tail(&work->list, &works);
> -			btrfs_queue_worker(&root->fs_info->flush_workers,
> -					   &work->work);
> +
> +		work = btrfs_alloc_delalloc_work(inode, 0, delay_iput);
> +		if (unlikely(!work)) {
> +			ret = -ENOMEM;
> +			goto out;
>  		}
> +		list_add_tail(&work->list, &works);
> +		btrfs_queue_worker(&root->fs_info->flush_workers,
> +				   &work->work);
> +
>  		cond_resched();
>  		spin_lock(&root->fs_info->delalloc_lock);
>  	}
>  	spin_unlock(&root->fs_info->delalloc_lock);
>  
> +	list_for_each_entry_safe(work, next, &works, list) {
> +		list_del_init(&work->list);
> +		btrfs_wait_and_free_delalloc_work(work);
> +	}
> +
> +	spin_lock(&root->fs_info->delalloc_lock);
> +	if (!list_empty(&root->fs_info->delalloc_inodes)) {
> +		spin_unlock(&root->fs_info->delalloc_lock);
> +		goto again;
> +	}
> +	spin_unlock(&root->fs_info->delalloc_lock);
> +
>  	/* the filemap_flush will queue IO into the worker threads, but
>  	 * we have to make sure the IO is actually started and that
>  	 * ordered extents get created before we return
> @@ -7592,11 +7612,18 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
>  		    atomic_read(&root->fs_info->async_delalloc_pages) == 0));
>  	}
>  	atomic_dec(&root->fs_info->async_submit_draining);
> +	return 0;
>  out:
>  	list_for_each_entry_safe(work, next, &works, list) {
>  		list_del_init(&work->list);
>  		btrfs_wait_and_free_delalloc_work(work);
>  	}
> +
> +	if (!list_empty_careful(&splice)) {
> +		spin_lock(&root->fs_info->delalloc_lock);
> +		list_splice_tail(&splice, &root->fs_info->delalloc_inodes);
> +		spin_unlock(&root->fs_info->delalloc_lock);
> +	}
>  	return ret;
>  }
>  
> -- 
> 1.6.5.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
