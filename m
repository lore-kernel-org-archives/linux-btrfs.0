Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30968 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750761AbdK3XCu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 18:02:50 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: lakshmipathi.g@gmail.com
Subject: [PATCH RESEND] btrfs: ignore return from btrfs_open_one_device()
Date: Fri,  1 Dec 2017 07:02:30 +0800
Message-Id: <20171130230230.10185-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test case like btrfs-progs test-misc/012 can recreate the same fsid with
different number of struct btrfs_fs_devices::total_devices. And the
previous device which is in the kernel device list is stale now, but as
we don't clean the kernel device list, and in the mount context, it really
ends up reading the device to find its zeroed SB. And thus return the fail
to mount.

The long term fix for this should be to create a new kernel device list,
for the mount context.

Though the patch
  btrfs: factor __btrfs_open_devices() to create btrfs_open_one_device()
did tried to skip the failed open, but it forgot to reset the ret value.
Thus returning the error up the stack in the mount context.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Fixes:
  btrfs: factor __btrfs_open_devices() to create btrfs_open_one_device()
---
Hi David,

 My bad. The above patch introduced a regression. Can you kindly squash
 this patch to it.

Thanks, Anand

 fs/btrfs/volumes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b408a3f7229e..7da65625677f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1035,8 +1035,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 
 	list_for_each_entry(device, head, dev_list) {
 		/* Just open everything we can; ignore failures here */
-		ret = btrfs_open_one_device(fs_devices, device, flags, holder);
-		if (ret)
+		if (btrfs_open_one_device(fs_devices, device, flags, holder))
 			continue;
 
 		if (!latest_dev ||
-- 
2.15.0

