Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35704 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbcD1KBz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 06:01:55 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1461770076-13000-1-git-send-email-dsterba@suse.com>
References: <1461770076-13000-1-git-send-email-dsterba@suse.com>
Date: Thu, 28 Apr 2016 11:01:54 +0100
Message-ID: <CAL3q7H5bJqYy-T6Hz71ZeDW9Fx=60KVoOWmmY8u_wAWcb1o+sw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: do not return EBUSY on concurrent subvolume mounts
From: Filipe Manana <fdmanana@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 27, 2016 at 4:14 PM, David Sterba <dsterba@suse.com> wrote:
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

This is easy to reproduce, can you please make a test case for xfstests?
Thanks.

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
>         if (s->s_root) {
>                 btrfs_close_devices(fs_devices);
>                 free_fs_info(fs_info);
> -               if ((flags ^ s->s_flags) & MS_RDONLY)
> -                       error = -EBUSY;
>         } else {
>                 snprintf(s->s_id, sizeof(s->s_id), "%pg", bdev);
>                 btrfs_sb(s)->bdev_holder = fs_type;
> --
> 2.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
