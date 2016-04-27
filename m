Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21815 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbcD0XVo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 19:21:44 -0400
Date: Wed, 27 Apr 2016 16:22:17 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: do not return EBUSY on concurrent subvolume mounts
Message-ID: <20160427232217.GL15822@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1461770076-13000-1-git-send-email-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461770076-13000-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 27, 2016 at 05:14:36PM +0200, David Sterba wrote:
> A user reported mount failures with EBUSY during boot, there's root
> partition and many subvolumes, mounted via /etc/fstab.
> 
> The failure depends on timing, when multiple subvolumes reach the code
> between superblock creation in RO mode, while the subvolumes are RW.
> This discrepancy leads to EBUSY and the code has been there since ages.
> 
> If the subvolumes are mounted after a short delay, there's no EBUSY.
> There's no missing locking, the supreblock creation is atomic and the
> error code seems to be just artificial. We support different RO/RW
> mounts in mount_subvol and do the relevant adjustments if the flags do
> not match.

Looks good to me.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

But What I'm worrying about is that mount_subvol() will help subvolume
mounting get correct mount flags by calling btrfs_remount(), and
btrfs_remount() can remove sb->s_flags's MS_RDONLY.  In all syscall cases
it's ok as we have mnt->mnt_flags, but for btrfs's add_dev ioctl, we
don't check mnt_want_write_file() while btrfs's rm_dev ioctl does the
check, should we add that for add_dev ioctl?

Thanks,

-liubo

> 
> There are no apparent problems if the check and EBUSY are dropped, no
> wrong refcounting, umount works etc.
> 
> Reproducer:
> 
> mkdir -p mnt $(eval echo mnt{1..10})
> mkfs.btrfs -f /dev/sdx
> mount /dev/sdx mnt
> for i in `seq 10`; do btrfs subvol create subv$i; done
> loops=0
> while [ $loops -lt 10 ]; do
>   umount mnt*
>   mount -o ro /dev/sdx mnt &
>   for i in `seq 10`; do
>     mount -o subvol=subv$i /dev/sdx mnt$i || \
>       echo "FAIL: mnt$i, loop $loops" > log-$i-$loops &
>     fi
>   done
>   wait
>   : $((loops++))
> done
> 
> Do 10 iterations, try to run subvolume mounts concurrently, log mount
> failures to files, the actual EBUSY errors are on screen.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/super.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 00b8f37cc306..0c398643d2a1 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1588,8 +1588,6 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  	if (s->s_root) {
>  		btrfs_close_devices(fs_devices);
>  		free_fs_info(fs_info);
> -		if ((flags ^ s->s_flags) & MS_RDONLY)
> -			error = -EBUSY;
>  	} else {
>  		snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
>  		btrfs_sb(s)->bdev_holder = fs_type;
> -- 
> 2.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
