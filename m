Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37823 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753979AbaHKVl1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 17:41:27 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] Btrfs: fix regression of btrfs device replace
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1406632179-17747-1-git-send-email-bo.li.liu@oracle.com>
Date: Mon, 11 Aug 2014 15:41:25 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <27C52EC9-CF6E-4FB7-9504-316A25D45DFB@colorremedies.com>
References: <1406632179-17747-1-git-send-email-bo.li.liu@oracle.com>
To: Liu Bo <bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 29, 2014, at 5:09 AM, Liu Bo <bo.li.liu@oracle.com> wrote:

> Commit 49c6f736f34f901117c20960ebd7d5e60f12fcac(
> btrfs: dev replace should replace the sysfs entry) added the missing sysfs entry
> in the process of device replace, but didn't take missing devices into account,
> so now we have
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
> IP: [<ffffffffa0268551>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
> ...
> 
> To reproduce it,
> 1. mkfs.btrfs -f disk1 disk2
> 2. mkfs.ext4 disk1
> 3. mount disk2 /mnt -odegraded
> 4. btrfs replace start -B 1 disk3 /mnt
> --------------------------
> 
> This fixes the problem.
> 
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> fs/btrfs/sysfs.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 7869936..12e5355 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -614,7 +614,7 @@ int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
> 	if (!fs_info->device_dir_kobj)
> 		return -EINVAL;
> 
> -	if (one_device) {
> +	if (one_device && one_device->bdev) {
> 		disk = one_device->bdev->bd_part;
> 		disk_kobj = &part_to_dev(disk)->kobj;
> 


Applied to 3.16.0 and tested, problem is fixed.


Chris Murphy

