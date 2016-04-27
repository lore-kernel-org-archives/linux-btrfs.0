Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59873 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316AbcD0Te4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 15:34:56 -0400
Subject: Re: [PATCH] btrfs: do not return EBUSY on concurrent subvolume mounts
To: David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1461770076-13000-1-git-send-email-dsterba@suse.com>
CC: <clm@fb.com>, <stable@vger.kernel.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <bdceb8b7-3951-1b4c-5945-d92344d5b260@fb.com>
Date: Wed, 27 Apr 2016 15:34:48 -0400
MIME-Version: 1.0
In-Reply-To: <1461770076-13000-1-git-send-email-dsterba@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/27/2016 11:14 AM, David Sterba wrote:
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
>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
