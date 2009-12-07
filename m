From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: [RFC] Btrfs: add ioctl to set the default mount subvol
Date: Mon, 07 Dec 2009 12:23:58 +0900
Message-ID: <4B1C754E.6000803@jp.fujitsu.com>
References: <20091204215713.GD7441@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: josef@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091204215713.GD7441@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Josef.

 Thank you for your considering listing patch.
 For now, snapshot listing starts with mounted directory,
but I thought listing by subvol id is needed, considering
'subvol' option (and now, your patch).
 I made a 'subvol id' patch, but if you have another idea,
could you tell me?

Regards,
taruisi

Josef Bacik wrote:
> This patch needs to go along with my previous patch.  This lets us set the
> default dir item's location to whatever root we want to use as our default
> mounting subvol.  With this we don't have to use mount -o subvol=<tree id>
> anymore to mount a different subvol, we can just set the new one and it will
> just magically work.  I've just done some superficial testing on this, but it
> works well enough.  It breaks the snapshot listing thing so don't try and use
> that with this patch, I will fix that later, I just want to run this by
> everybody to make sure this is what we want.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/ioctl.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/ioctl.h |    2 +
>  2 files changed, 66 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index c157eb7..9b747a9 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1551,6 +1551,68 @@ out:
>  	return ret;
>  }
>  
> +static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
> +{
> +	struct inode *inode = fdentry(file)->d_inode;
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_root *new_root;
> +	struct btrfs_dir_item *di;
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_path *path;
> +	struct btrfs_key location;
> +	struct btrfs_disk_key disk_key;
> +	u64 objectid = 0;
> +	u64 dir_id;
> +
> +	if (copy_from_user(&objectid, argp, sizeof(objectid)))
> +		return -EFAULT;
> +
> +	if (!objectid)
> +		objectid = root->root_key.objectid;
> +
> +	location.objectid = objectid;
> +	location.type = BTRFS_ROOT_ITEM_KEY;
> +	location.offset = (u64)-1;
> +
> +	new_root = btrfs_read_fs_root_no_name(root->fs_info, &location);
> +	if (IS_ERR(new_root))
> +		return PTR_ERR(new_root);
> +
> +	if (btrfs_root_refs(&new_root->root_item) == 0)
> +		return -ENOENT;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +	path->leave_spinning = 1;
> +
> +	trans = btrfs_start_transaction(root, 1);
> +	if (!trans) {
> +		btrfs_free_path(path);
> +		return -ENOMEM;
> +	}
> +
> +	dir_id = btrfs_super_root_dir(&root->fs_info->super_copy);
> +	di = btrfs_lookup_dir_item(trans, root->fs_info->tree_root, path,
> +				   dir_id, "default", 7, 1);
> +	if (!di) {
> +		btrfs_free_path(path);
> +		btrfs_end_transaction(trans, root);
> +		printk(KERN_ERR "Umm, you don't have the default dir item, "
> +		       "this isn't going to work\n");
> +		return -ENOENT;
> +	}
> +
> +	btrfs_cpu_key_to_disk(&disk_key, &new_root->root_key);
> +	btrfs_set_dir_item_key(path->nodes[0], di, &disk_key);
> +	btrfs_mark_buffer_dirty(path->nodes[0]);
> +	btrfs_free_path(path);
> +
> +	btrfs_end_transaction(trans, root);
> +
> +	return 0;
> +}
> +
>  /*
>   * there are many ways the trans_start and trans_end ioctls can lead
>   * to deadlocks.  They should only be used by applications that
> @@ -1597,6 +1659,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_snap_create(file, argp, 1);
>  	case BTRFS_IOC_SNAP_DESTROY:
>  		return btrfs_ioctl_snap_destroy(file, argp);
> +	case BTRFS_IOC_DEFAULT_SUBVOL:
> +		return btrfs_ioctl_default_subvol(file, argp);
>  	case BTRFS_IOC_DEFRAG:
>  		return btrfs_ioctl_defrag(file);
>  	case BTRFS_IOC_RESIZE:
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 18c554b..9e5074c 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -96,4 +96,6 @@ struct btrfs_ioctl_clone_range_args {
>  				struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_SNAP_LISTING _IOWR(BTRFS_IOCTL_MAGIC, 16, \
>  				   struct btrfs_ioctl_subvol_args)
> +#define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 17, u64)
> +
>  #endif


-- 
taruisi

