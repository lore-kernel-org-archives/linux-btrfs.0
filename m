From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v4 4/6] btrfs: sync scrub with commit & device removal
Date: Wed, 23 Mar 2011 18:28:11 +0100
Message-ID: <20110323172811.GH17108@twin.jikos.cz>
References: <cover.1300462778.git.sensille@gmx.net>
 <a791c7692d9c1eb5cbf111c01f5d94f42b904523.1300462778.git.sensille@gmx.net>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a791c7692d9c1eb5cbf111c01f5d94f42b904523.1300462778.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

you are adding a new smp_mb, can you please explain why it's needed and
document it?

thanks,
dave

On Fri, Mar 18, 2011 at 04:55:07PM +0100, Arne Jansen wrote:
> This adds several synchronizations:
>  - for a transaction commit, the scrub gets paused before the
>    tree roots are committed until the super are safely on disk
>  - during a log commit, scrubbing of supers is disabled
>  - on unmount, the scrub gets cancelled
>  - on device removal, the scrub for the particular device gets cancelled
> 
> Signed-off-by: Arne Jansen <sensille@gmx.net>
> ---
>  fs/btrfs/disk-io.c     |    1 +
>  fs/btrfs/transaction.c |    3 +++
>  fs/btrfs/tree-log.c    |    2 ++
>  fs/btrfs/volumes.c     |    2 ++
>  4 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 3e1ea3e..924a366 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2493,6 +2493,7 @@ int close_ctree(struct btrfs_root *root)
>  	fs_info->closing = 1;
>  	smp_mb();
>  
> +	btrfs_scrub_cancel(root);
>  	btrfs_put_block_group_cache(fs_info);
>  
>  	/*
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 3d73c8d..5a43b20 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1310,6 +1310,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  
>  	WARN_ON(cur_trans != trans->transaction);
>  
> +	btrfs_scrub_pause(root);
>  	/* btrfs_commit_tree_roots is responsible for getting the
>  	 * various roots consistent with each other.  Every pointer
>  	 * in the tree of tree roots has to point to the most up to date
> @@ -1391,6 +1392,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  
>  	mutex_unlock(&root->fs_info->trans_mutex);
>  
> +	btrfs_scrub_continue(root);
> +
>  	if (current->journal_info == trans)
>  		current->journal_info = NULL;
>  
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1f6788f..2be84fa 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2098,7 +2098,9 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>  	 * the running transaction open, so a full commit can't hop
>  	 * in and cause problems either.
>  	 */
> +	btrfs_scrub_pause_super(root);
>  	write_ctree_super(trans, root->fs_info->tree_root, 1);
> +	btrfs_scrub_continue_super(root);
>  	ret = 0;
>  
>  	mutex_lock(&root->log_mutex);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 7dc9fa5..ad3ea88 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1330,6 +1330,8 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>  		goto error_undo;
>  
>  	device->in_fs_metadata = 0;
> +	smp_mb();
        ^^^^^^^^

> +	btrfs_scrub_cancel_dev(root, device);
>  
>  	/*
>  	 * the device list mutex makes sure that we don't change
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
