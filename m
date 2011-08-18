From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 5/5] btrfs: use fs netlink interface for ENOSPC conditions
Date: Thu, 18 Aug 2011 20:22:00 +0200
Message-ID: <20110818182200.GE16820@ds.suse.cz>
References: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
 <1313669906-14931-6-git-send-email-lczerner@redhat.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1313669906-14931-6-git-send-email-lczerner@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I see you are mixing a cleanup while adding a new feature.

On Thu, Aug 18, 2011 at 02:18:26PM +0200, Lukas Czerner wrote:
> Register fs netlink interface and send proper warning if ENOSPC is
> encountered. Note that we differentiate between enospc for metadata and
> enospc for data.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: linux-btrfs@vger.kernel.org
> ---
>  fs/btrfs/extent-tree.c |   13 ++++++++++---
>  fs/btrfs/super.c       |    1 +
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 66bac22..a47d9b9 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3029,13 +3029,14 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)

hm, if diff is correct with the context, you are changing function
btrfs_check_data_free_space and reporting it as metadata ENOSPC later.
Although it's called for metadata (or I should say non-user file blocks,
like space cache, ino cache) block allocation, it's called from
btrfs_fallocate too. Seems that there has to be additional flag to say
if it's really metadata or data.

>  {
>  	struct btrfs_space_info *data_sinfo;
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_fs_info *fs_info = root->fs_info;

change unrealated to ENOSPC-netlink

>  	u64 used;
>  	int ret = 0, committed = 0, alloc_chunk = 1;
>  
>  	/* make sure bytes are sectorsize aligned */
>  	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
>  
> -	if (root == root->fs_info->tree_root ||
> +	if (root == fs_info->tree_root ||

here

>  	    BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID) {
>  		alloc_chunk = 0;
>  		committed = 1;
> @@ -3070,7 +3071,7 @@ alloc:
>  			if (IS_ERR(trans))
>  				return PTR_ERR(trans);
>  
> -			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
> +			ret = do_chunk_alloc(trans, fs_info->extent_root,

here

>  					     bytes + 2 * 1024 * 1024,
>  					     alloc_target,
>  					     CHUNK_ALLOC_NO_FORCE);
> @@ -3100,7 +3101,7 @@ alloc:
>  		/* commit the current transaction and try again */
>  commit_trans:
>  		if (!committed &&
> -		    !atomic_read(&root->fs_info->open_ioctl_trans)) {
> +		    !atomic_read(&fs_info->open_ioctl_trans)) {

here

>  			committed = 1;
>  			trans = btrfs_join_transaction(root);
>  			if (IS_ERR(trans))
> @@ -3111,6 +3112,8 @@ commit_trans:
>  			goto again;
>  		}
>  
> +		fs_nl_send_warning(fs_info->fs_devices->latest_bdev->bd_dev,
> +				   FS_NL_ENOSPC_WARN);

or is it due to this line being too long with root-> ? :)

>  		return -ENOSPC;
>  	}
>  	data_sinfo->bytes_may_use += bytes;
> @@ -3522,6 +3525,10 @@ again:
>  	}
>  
>  out:
> +	if (unlikely(-ENOSPC == ret)) {

'unlikely' is not needed here, it does not bring anything compiler
wouldn't know, static branch prediction will give low probabiliy to this
check anyway

> +		dev_t bdev = root->fs_info->fs_devices->latest_bdev->bd_dev;
> +		fs_nl_send_warning(bdev, FS_NL_META_ENOSPC_WARN);
> +	}
>  	if (flushing) {
>  		spin_lock(&space_info->lock);
>  		space_info->flush = 0;
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 15634d4..8ac9e01 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1266,6 +1266,7 @@ static int __init init_btrfs_fs(void)
>  	if (err)
>  		goto unregister_ioctl;
>  
> +	init_fs_nl_family();
>  	printk(KERN_INFO "%s loaded\n", BTRFS_BUILD_VERSION);
>  	return 0;


david
