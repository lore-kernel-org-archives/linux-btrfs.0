Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54309 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3CBSEI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Mar 2013 13:04:08 -0500
Date: Sat, 2 Mar 2013 20:04:04 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: Jerry Snitselaar <jerry.snitselaar@oracle.com>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, dsterba@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: return EPERM in btrfs_rm_device()
Message-ID: <20130302180404.GA1991@zambezi.lan>
References: <1362208439-19245-1-git-send-email-jerry.snitselaar@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362208439-19245-1-git-send-email-jerry.snitselaar@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 02, 2013 at 12:13:59AM -0700, Jerry Snitselaar wrote:
> Currently there are error paths in btrfs_rm_device() where EINVAL is
> returned telling the user they passed an invalid argument even though
> they passed a valid device. Change to return EPERM instead as the
> operation is not permitted.
> 
> Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
> ---
>  fs/btrfs/volumes.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 5cbb7f4..3e1586c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1392,14 +1392,14 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>  	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices <= 4) {
>  		printk(KERN_ERR "btrfs: unable to go below four devices "
>  		       "on raid10\n");
> -		ret = -EINVAL;
> +		ret = -EPERM;
>  		goto out;
>  	}
>  
>  	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) && num_devices <= 2) {
>  		printk(KERN_ERR "btrfs: unable to go below two "
>  		       "devices on raid1\n");
> -		ret = -EINVAL;
> +		ret = -EPERM;
>  		goto out;
>  	}
>  
> @@ -1449,14 +1449,14 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>  
>  	if (device->is_tgtdev_for_dev_replace) {
>  		pr_err("btrfs: unable to remove the dev_replace target dev\n");
> -		ret = -EINVAL;
> +		ret = -EPERM;
>  		goto error_brelse;
>  	}
>  
>  	if (device->writeable && root->fs_info->fs_devices->rw_devices == 1) {
>  		printk(KERN_ERR "btrfs: unable to remove the only writeable "
>  		       "device\n");
> -		ret = -EINVAL;
> +		ret = -EPERM;

I don't think returning EPERM in these cases is any better than EINVAL.
FWIW, many other btrfs ioctls, especially balance, suffer from this as
well.  What we really need is some kind of error message delivery
system, but that's not going to happen any time soon...

Thanks,

		Ilya
