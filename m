From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2] Btrfs: fix wrong error returned by adding a device
Date: Fri, 11 May 2012 10:49:52 -0400
Message-ID: <20120511144952.GA3847@localhost.localdomain>
References: <1336644639-21595-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1336644639-21595-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2012 at 06:10:38PM +0800, Liu Bo wrote:
> Reproduce:
> $ mkfs.btrfs /dev/sdb7
> $ mount /dev/sdb7 /mnt/btrfs -o ro
> $ btrfs dev add /dev/sdb8 /mnt/btrfs
> ERROR: error adding the device '/dev/sdb8' - Invalid argument
> 
> Since we mount with readonly options, and /dev/sdb7 is not a seeding one,
> a readonly notification is preferred.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 1411b99..48a06d1 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1633,7 +1633,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>  	int ret = 0;
>  
>  	if ((sb->s_flags & MS_RDONLY) && !root->fs_info->fs_devices->seeding)
> -		return -EINVAL;
> +		return -EROFS;
>  
>  	bdev = blkdev_get_by_path(device_path, FMODE_WRITE | FMODE_EXCL,
>  				  root->fs_info->bdev_holder);
> -- 
> 1.6.5.2
> 

I've committed these to btrfs-next and added my Reviewed-by.  Thanks,

Josef
