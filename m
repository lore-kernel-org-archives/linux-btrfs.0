Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23999 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaGWDhG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 23:37:06 -0400
Date: Wed, 23 Jul 2014 11:36:50 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: BUGS: bogus out of space reported when mounted raid1 degraded,
 btrfs replace failure, then oops
Message-ID: <20140723033649.GB4955@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <3823A5F4-169B-4EAC-A548-B0E4FE782F0E@colorremedies.com>
 <53CF235D.1040703@redhat.com>
 <FE022C52-674C-491B-AAC1-2A5B4576D8B3@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <FE022C52-674C-491B-AAC1-2A5B4576D8B3@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 22, 2014 at 09:28:52PM -0600, Chris Murphy wrote:
> 
> On Jul 22, 2014, at 8:52 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> 
> > This one (your bug #4) was likely caused by:
> > 
> > commit 99994cde9c59c2b8bb67d46d531b26cc73e39747
> > Author: Anand Jain <Anand.Jain@oracle.com>
> > Date:   Tue Jun 3 11:36:00 2014 +0800
> > 
> >    btrfs: dev delete should remove sysfs entry
> > 
> > and hopefully fixed by:
> > 
> > commit 0bfaa9c5cb479cebc24979b384374fe47500b4c9
> > Author: Eric Sandeen <sandeen@redhat.com>
> > Date:   Mon Jul 7 12:34:49 2014 -0500
> > 
> >    btrfs: test for valid bdev before kobj removal in btrfs_rm_device
> 
> OK good. Hopefully the first one is reverted or the second one is accepted before 3.16 is released, replace appears to be broken at the moment.
> 

Looks that they are not the same one, since you didn't use a btrfs_rm_device,

As we just skip adding a sysfs entry for a missing device(dev->bdev is NULL), we
can do the same thing in removing a sysfs entry, could you please try this?

-liubo

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 7869936..12e5355 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -614,7 +614,7 @@ int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
 	if (!fs_info->device_dir_kobj)
 		return -EINVAL;
 
-	if (one_device) {
+	if (one_device && one_device->bdev) {
 		disk = one_device->bdev->bd_part;
 		disk_kobj = &part_to_dev(disk)->kobj;

