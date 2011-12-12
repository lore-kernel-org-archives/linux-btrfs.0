From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: change resize ioctl to take device path instead
 of id
Date: Mon, 12 Dec 2011 11:31:12 +0800
Message-ID: <4EE57580.8080907@cn.fujitsu.com>
References: <1323659529-2632-1-git-send-email-psusi@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1323659529-2632-1-git-send-email-psusi@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

Phillip Susi wrote:
> The resize ioctl took an optional argument that was a string
> representation of the devid which you wish to resize.  For
> the sake of consistency with the other ioctls that take a
> device argument, I converted this to take a device path instead
> of a devid number, and look up the number from the path.
> 

but.. isn't this an ABI change?

so instead of changing it, I think it's ok to extend it.

> Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
> ---
>  fs/btrfs/ioctl.c |   33 ++++++++++++++++++++++++++-------
>  1 files changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 72d4616..b4a0d46 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1211,13 +1211,32 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
>  	sizestr = vol_args->name;
>  	devstr = strchr(sizestr, ':');
>  	if (devstr) {
> -		char *end;
> -		sizestr = devstr + 1;
> -		*devstr = '\0';
> -		devstr = vol_args->name;
> -		devid = simple_strtoull(devstr, &end, 10);
> -		printk(KERN_INFO "btrfs: resizing devid %llu\n",
> -		       (unsigned long long)devid);
> +		struct block_device *bdev;
> +		struct btrfs_super_block *disk_super;
> +		struct buffer_head *bh;
> +
> +		*devstr = 0;
> +		devstr++;
> +		printk(KERN_INFO "btrfs: resizing device %s\n",
> +			devstr);
> +		bdev = blkdev_get_by_path(devstr, FMODE_READ | FMODE_EXCL,
> +					  root->fs_info->bdev_holder);
> +		if (IS_ERR(bdev)) {
> +			ret = PTR_ERR(bdev);
> +			goto out_unlock;
> +		}
> +
> +		set_blocksize(bdev, 4096);
> +		bh = btrfs_read_dev_super(bdev);
> +		if (!bh) {
> +			ret = -EINVAL;
> +			blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
> +			goto out_unlock;
> +		}
> +		disk_super = (struct btrfs_super_block *)bh->b_data;
> +		devid = btrfs_stack_device_id(&disk_super->dev_item);
> +		brelse(bh);
> +		blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
>  	}
>  	device = btrfs_find_device(root, devid, NULL, NULL);
>  	if (!device) {
