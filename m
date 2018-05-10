Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56917 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966093AbeEJPhz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 11:37:55 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E3A4CAD63
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 15:37:53 +0000 (UTC)
Date: Thu, 10 May 2018 17:35:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/5] btrfs: Fix delalloc inodes invalidation during
 transaction abort
Message-ID: <20180510153514.GM6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524820914-30864-1-git-send-email-nborisov@suse.com>
 <1524820914-30864-5-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524820914-30864-5-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 12:21:53PM +0300, Nikolay Borisov wrote:
> When a transaction is aborted btrfs_cleanup_transaction is called to
> cleanup all the various in-flight bits and pieces which migth be
> active. One of those is delalloc inodes - inodes which have dirty
> pages which haven't been persisted yet. Currently the process of
> freeing such delalloc inodes in exceptional circumstances such as
> transaction abort boiled down to calling btrfs_invalidate_inodes whose
> sole job is to invalidate the dentries for all inodes related to a
> root. This is in fact wrong and insufficient since such delalloc inodes
> will likely have pending pages or ordered-extents and will be linked to
> the sb->s_inode_list. This means that unmounting a btrfs instance with
> an aborted transaction could potentially lead inodes/their pages
> visible to the system long after their superblock has been freed. This
> in turn leads to a "use-after-free" situation once page shrink is
> triggered. This situation could be simulated by running generic/019
> which would cause such inodes to be left hanging, followed by
> generic/176 which causes memory pressure and page eviction which lead
> to touching the freed super block instance. This situation is
> additionally detected by the unmount code of VFS with the following
> message:
> 
> "VFS: Busy inodes after unmount of Self-destruct in 5 seconds.  Have a nice day..."
> 
> Additionally btrfs hits WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
> in free_fs_root for the same reason.
> 
> This patch aims to rectify the sitaution by doing the following:
> 
> 1. Change btrfs_destroy_delalloc_inodes so that it calls
> invalidate_inode_pages2 for every inode on the delalloc list, this
> ensures that all the pages of the inode are released. This function
> boils down to calling btrfs_releasepage. During test I observed cases
> where inodes on the delalloc list were having an i_count of 0, so this
> necessitates using igrab to be sure we are working on a non-freed inode.
> 
> 2. Since calling btrfs_releasepage might queue delayed iputs move the
> call out to btrfs_cleanup_transaction in btrfs_error_commit_super before
> calling run_delayed_iputs for the last time. This is necessary to ensure
> that delayed iputs are run.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/disk-io.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index f50786e19a7a..0f88a551862a 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3816,6 +3816,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>  	set_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags);
>  
>  	btrfs_free_qgroup_config(fs_info);
> +	ASSERT(list_empty(&fs_info->delalloc_roots));
>  
>  	if (percpu_counter_sum(&fs_info->delalloc_bytes)) {
>  		btrfs_info(fs_info, "at unmount delalloc count %lld",
> @@ -4123,15 +4124,15 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
>  
>  static void btrfs_error_commit_super(struct btrfs_fs_info *fs_info)
>  {
> +	/* cleanup FS via transaction */
> +	btrfs_cleanup_transaction(fs_info);
> +
>  	mutex_lock(&fs_info->cleaner_mutex);
>  	btrfs_run_delayed_iputs(fs_info);
>  	mutex_unlock(&fs_info->cleaner_mutex);
>  
>  	down_write(&fs_info->cleanup_work_sem);
>  	up_write(&fs_info->cleanup_work_sem);
> -
> -	/* cleanup FS via transaction */
> -	btrfs_cleanup_transaction(fs_info);

I wonder if we still run the cleanup here. The function calls several
others but they all seem to be ok and do the initial checks if there's
any work left to do.


btrfs_error_commit_super is called only once after filesystem error is
found in close_ctree, and then the kthreads are stopped. So there should
not be any work left, but I'm not sure if this holds 100% after the
btrfs_run_delayed_iputs is still called.

More invariant assertions would be good

>  }
>  
>  static void btrfs_destroy_ordered_extents(struct btrfs_root *root)
> @@ -4256,19 +4257,19 @@ static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
>  	list_splice_init(&root->delalloc_inodes, &splice);
>  
>  	while (!list_empty(&splice)) {
> +		struct inode *inode = NULL;
>  		btrfs_inode = list_first_entry(&splice, struct btrfs_inode,
>  					       delalloc_inodes);
> -
> -		list_del_init(&btrfs_inode->delalloc_inodes);
> -		clear_bit(BTRFS_INODE_IN_DELALLOC_LIST,
> -			  &btrfs_inode->runtime_flags);
> +		__btrfs_del_delalloc_inode(root, btrfs_inode);
>  		spin_unlock(&root->delalloc_lock);
>  
> -		btrfs_invalidate_inodes(btrfs_inode->root);
> -
> +		inode = igrab(&btrfs_inode->vfs_inode);

A comment would be good here, similar to the explanation in the
changelog.

Other than that I think were good to go with this patch. I've merged the
preparatory (1-3) patches to misc-next. This one after a few more
testing rounds.

> +		if (inode) {
> +			invalidate_inode_pages2(inode->i_mapping);
> +			iput(inode);
> +		}
>  		spin_lock(&root->delalloc_lock);
>  	}
> -
>  	spin_unlock(&root->delalloc_lock);
>  }
>  
