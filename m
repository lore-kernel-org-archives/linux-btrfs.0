Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28959 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbaHLDAT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 23:00:19 -0400
Date: Tue, 12 Aug 2014 11:00:05 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix regression of btrfs device replace
Message-ID: <20140812030004.GB9244@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1406632179-17747-1-git-send-email-bo.li.liu@oracle.com>
 <27C52EC9-CF6E-4FB7-9504-316A25D45DFB@colorremedies.com>
 <53E97AFC.4060404@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53E97AFC.4060404@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 12, 2014 at 11:25:00AM +0900, Satoru Takeuchi wrote:
> Hi Liu,
> 
> (2014/08/12 6:41), Chris Murphy wrote:
> >
> >On Jul 29, 2014, at 5:09 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >
> >>Commit 49c6f736f34f901117c20960ebd7d5e60f12fcac(
> >>btrfs: dev replace should replace the sysfs entry) added the missing sysfs entry
> >>in the process of device replace, but didn't take missing devices into account,
> >>so now we have
> >>
> >>BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
> >>IP: [<ffffffffa0268551>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
> >>...
> >>
> >>To reproduce it,
> >>1. mkfs.btrfs -f disk1 disk2
> >>2. mkfs.ext4 disk1
> >>3. mount disk2 /mnt -odegraded
> >>4. btrfs replace start -B 1 disk3 /mnt
> >>--------------------------
> >>
> >>This fixes the problem.
> >>
> >>Reported-by: Chris Murphy <lists@colorremedies.com>
> >>Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> >>---
> >>fs/btrfs/sysfs.c | 2 +-
> >>1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >>diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> >>index 7869936..12e5355 100644
> >>--- a/fs/btrfs/sysfs.c
> >>+++ b/fs/btrfs/sysfs.c
> >>@@ -614,7 +614,7 @@ int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
> >>	if (!fs_info->device_dir_kobj)
> >>		return -EINVAL;
> >>
> >>-	if (one_device) {
> >>+	if (one_device && one_device->bdev) {
> >>		disk = one_device->bdev->bd_part;
> >>		disk_kobj = &part_to_dev(disk)->kobj;
> >>
> >
> >
> >Applied to 3.16.0 and tested, problem is fixed.
> >
> >
> >Chris Murphy
> 
> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> I confirmed both
> 
>  - This problem happens with 3.16, and
>  - This problem doesn't happen with 3.16 + your patch.

Thanks for your testing!
 
-liubo
