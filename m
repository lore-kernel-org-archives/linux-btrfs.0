Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:52849 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab2E1NmS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 May 2012 09:42:18 -0400
Date: Mon, 28 May 2012 15:41:59 +0200
From: David Sterba <dave@jikos.cz>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        jeffm@suse.com
Subject: Re: [PATCH 1/2] btrfs: Drop unused function btrfs_abort_devices()
Message-ID: <20120528134159.GT24394@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1337915422-24988-1-git-send-email-asias@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1337915422-24988-1-git-send-email-asias@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 25, 2012 at 11:10:21AM +0800, Asias He wrote:
> 1) This function is not used anywhere.

This was added in 49b25e0540904be0bf558b84475c69d72e4de66e adding a
transaction abort infrastructure.  I'm not sure if Jeff had some
intentions with it or whether it got obsolete during the patchset long
evolution, CCed.


david


> 2) Using the blk_abort_queue() to abort the queue seems not correct.
> blk_abort_queue() is used for timeout handling (block/blk-timeout.c).
> 
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: linux-btrfs@vger.kernel.org
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Asias He <asias@redhat.com>
> ---
>  fs/btrfs/disk-io.c |   13 -------------
>  fs/btrfs/disk-io.h |    1 -
>  2 files changed, 14 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index e1fe74a..3521866 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2902,19 +2902,6 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> -/* Kill all outstanding I/O */
> -void btrfs_abort_devices(struct btrfs_root *root)
> -{
> -	struct list_head *head;
> -	struct btrfs_device *dev;
> -	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
> -	head = &root->fs_info->fs_devices->devices;
> -	list_for_each_entry_rcu(dev, head, dev_list) {
> -		blk_abort_queue(dev->bdev->bd_disk->queue);
> -	}
> -	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
> -}
> -
>  void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
>  {
>  	spin_lock(&fs_info->fs_roots_radix_lock);
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index ab1830a..05b3fab 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -89,7 +89,6 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
>  int btrfs_cleanup_transaction(struct btrfs_root *root);
>  void btrfs_cleanup_one_transaction(struct btrfs_transaction *trans,
>  				  struct btrfs_root *root);
> -void btrfs_abort_devices(struct btrfs_root *root);
>  
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  void btrfs_init_lockdep(void);
