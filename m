Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031057Ab3HIUrp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 16:47:45 -0400
Message-ID: <5205556E.8030902@redhat.com>
Date: Fri, 09 Aug 2013 15:47:42 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: btrfs_rm_device() should zero mirror SB as
 well
References: <1374773376-29853-1-git-send-email-anand.jain@oracle.com> <1374773376-29853-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1374773376-29853-2-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/25/13 12:29 PM, Anand Jain wrote:
> There is a very less chance that all the copies of SB
> on the disk is zeroed unintentionally. unless device
> is removed, so this fix will ensure all copies on the
> disk is zeroed when the disk is intentionally removed.
> 
> reproducer:
> -------------------
> btrfs dev del /dev/sdc /btrfs
> echo $?
> 0
> umount /btrfs
> btrfs fi show
> Label: none  uuid: e7aae9f0-1aa8-41f5-8fb6-d4d8f80cdb2c
>         Total devices 1 FS bytes used 28.00KiB
>         devid    1 size 2.00GiB used 20.00MiB path /dev/sdb

Great, so dev del makes it unfindable . . . 

> ./btrfs-select-super -s 1 /dev/sdc
> using SB copy 1, bytenr 67108864

Now you use a rescue tool to resurrect the fs from a backup
superblock.  And:

> btrfs fi show
> Label: none  uuid: e7aae9f0-1aa8-41f5-8fb6-d4d8f80cdb2c
>         Total devices 1 FS bytes used 28.00KiB
>         devid    2 size 2.00GiB used 0.00 path /dev/sdc   <-- WRONG
>         devid    1 size 2.00GiB used 20.00MiB path /dev/sdb

Ok, now it's findable.  Isn't that exactly how this should behave?
What is wrong about this?

> mount /dev/sdc /btrfs
> btrfs fi show --kernel
> Label: none  uuid: e7aae9f0-1aa8-41f5-8fb6-d4d8f80cdb2c mounted: /btrfs
>         Group profile: metadata: single  data: single
>         Total devices 1 FS bytes used 28.00KiB
>         devid    1 size 2.00GiB used 20.00MiB path /dev/sdb

Oh good, you could bring it back after a potential administrative error,
using a recovery tool (btrfs-select-super)!  Isn't that a good thing?

IOWS: what does this change actually fix?

-Eric

> ---------------------
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 557a743..090f57c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1641,12 +1641,42 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>  	 * remove it from the devices list and zero out the old super
>  	 */
>  	if (clear_super && disk_super) {
> +		u64 bytenr;
> +		int i;
> +
>  		/* make sure this device isn't detected as part of
>  		 * the FS anymore
>  		 */
>  		memset(&disk_super->magic, 0, sizeof(disk_super->magic));
>  		set_buffer_dirty(bh);
>  		sync_dirty_buffer(bh);
> +
> +		/* clear the mirror copies of super block on the disk
> +		 * being removed, 0th copy is been taken care above and
> +		 * the below would take of the rest
> +		 */
> +		for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> +			brelse(bh);
> +			bytenr = btrfs_sb_offset(i);
> +			if (bytenr + BTRFS_SUPER_INFO_SIZE >=
> +					i_size_read(bdev->bd_inode))
> +				break;
> +			bh = __bread(bdev, bytenr / 4096,
> +					BTRFS_SUPER_INFO_SIZE);
> +			if (!bh)
> +				continue;
> +
> +			disk_super = (struct btrfs_super_block *)bh->b_data;
> +
> +			if (btrfs_super_bytenr(disk_super) != bytenr ||
> +				btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
> +				continue;
> +			}
> +			memset(&disk_super->magic, 0,
> +						sizeof(disk_super->magic));
> +			set_buffer_dirty(bh);
> +			sync_dirty_buffer(bh);
> +		}
>  	}
>  
>  	ret = 0;
> 

