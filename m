Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:36764 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbdECEy0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 00:54:26 -0400
Date: Wed, 3 May 2017 06:54:23 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix the mount failure due to missing devices
Message-ID: <20170503045423.2fcacmvybdku27hh@angband.pl>
References: <1493768920-29678-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493768920-29678-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 02, 2017 at 05:48:40PM -0600, Liu Bo wrote:
> Say there is a raid1 btrfs which consists of two disks, after one disk
> becomes unavailable, we can still mount it in degraded mode once, for
> the second mount it would refuse to mount it with an error
> 
> "BTRFS warning (device sdf): missing devices (1) exceeds the limit (0), writeable mount is not allowed"
> 
> The reason is that during the first mount (with the default mount
> option), it creates a chunk of single profile so that another mount
> will report the limit to tolerate missing or faulty devices as 0.
> 
> But we're mounting the filesystem from the device where the single
> profile chunk lives, we can safely allow it to be mounted in the
> degraded mode.

Nope, this approach doesn't work.  This patch breaks JBOD setups and any
other scheme that has single chunks that are present on missing devices.

I've tested, with obvious results.  Reproducer:
dd if=/dev/zero of=ra bs=1048576 seek=4095 count=1
dd if=/dev/zero of=rb bs=1048576 seek=4095 count=1
losetup -D
losetup -f ra
losetup -f rb
mkfs.btrfs -mraid1 -dsingle /dev/loop0 /dev/loop1
mount -onoatime /dev/loop0 /mnt/vol1
dd if=/dev/zero of=/mnt/vol1/foo bs=1048576 count=2048
umount /mnt/vol1
losetup -D
losetup -f ra
mount -onoatime,degraded /dev/loop0 /mnt/vol1

Both vanilla and with Qu's chunk check patch, the mount properly fails. 
With this patch instead, it succeeds with disastrous results.  There's
little point in allowing mounting when half of the data -- or worse,
metadata -- is missing.


> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index eb1ee7b..b65a265 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3686,8 +3686,15 @@ int btrfs_calc_num_tolerated_disk_barrier_failures(
>  						   &space);
>  			if (space.total_bytes == 0 || space.used_bytes == 0)
>  				continue;
> -			flags = space.flags;
>  
> +			/*
> +			 * skip single profile as we have opened this
> +			 * device for single profile
> +			 */
> +			if ((space.flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0)
> +				continue;
> +
> +			flags = space.flags;
>  			num_tolerated_disk_barrier_failures = min(
>  				num_tolerated_disk_barrier_failures,
>  				btrfs_get_num_tolerated_disk_barrier_failures(
> -- 
> 1.8.3.1

Meow!
-- 
Don't be racist.  White, amber or black, all beers should be judged based
solely on their merits.  Heck, even if occasionally a cider applies for a
beer's job, why not?
On the other hand, corpo lager is not a race.
