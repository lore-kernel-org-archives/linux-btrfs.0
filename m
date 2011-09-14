From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH 1/2] Btrfs: don't make a file partly checksummed through
 file clone
Date: Wed, 14 Sep 2011 05:17:53 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1109140517120.24029@cobra.newdream.net>
References: <4E703AC1.5060205@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E703AC1.5060205@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 14 Sep 2011, Li Zefan wrote:

> To reproduce the bug:
> 
>   # mount /dev/sda7 /mnt
>   # dd if=/dev/zero of=/mnt/src bs=4K count=1
>   # umount /mnt
> 
>   # mount -o nodatasum /dev/sda7 /mnt
>   # dd if=/dev/zero of=/mnt/dst bs=4K count=1
>   # clone_range -s 4K -l 4K /mnt/src /mnt/dst
> 
>   # echo 3 > /proc/sys/vm/drop_caches
>   # cat /mnt/dst
>   # dmesg
>   ...
>   btrfs no csum found for inode 258 start 0
>   btrfs csum failed ino 258 off 0 csum 2566472073 private 0
> 
> It's because part of the file is checksummed and the other part is not,
> and then btrfs will complain checksum is not found when we read the file.
> 
> Disallow file clone if src and dst file have different checksum flag,
> so we ensure a file is completely checksummed or unchecksummed.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Looks good to me.

Reviewed-by: Sage Weil <sage@newdream.net>

> ---
>  fs/btrfs/ioctl.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 970977a..dc82bbb 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2177,6 +2177,11 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  	if (!(src_file->f_mode & FMODE_READ))
>  		goto out_fput;
>  
> +	/* don't make the dst file partly checksummed */
> +	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
> +	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
> +		goto out_fput;
> +
>  	ret = -EISDIR;
>  	if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
>  		goto out_fput;
> -- 1.7.3.1 
> 
> 
