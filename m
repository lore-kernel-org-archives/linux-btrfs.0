Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40827 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdK0OAD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 09:00:03 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: lakshmipathi.g@gmail.com
Subject: [PATCH] btrfs: ignore return from btrfs_open_one_device()
Date: Mon, 27 Nov 2017 22:00:14 +0800
Message-Id: <20171127140014.25873-1-anand.jain@oracle.com>
In-Reply-To: <CAKuJGC_CrmmT8=U3KNcw4i_6sSDtwhCCs8iui4Ov+ECzsfAB6A@mail.gmail.com>
References: <CAKuJGC_CrmmT8=U3KNcw4i_6sSDtwhCCs8iui4Ov+ECzsfAB6A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Test case btrfs-progs test-misc/012 can recreate the same fsid with
different number of struct btrfs_fs_devices::total_devices. And the
previous device which is in the kernel device list is stale now. But
as we don't clean the kernel device list (unless same device is scanned
with different fsid), so in the mount context it really ended up
reading the device to find zeroed SB. And thus return the fail to mount.

The long term fix for this should be to refresh the kernel device list.

Though the patch
  btrfs: factor __btrfs_open_devices() to create btrfs_open_one_device()
did tried to skip the failed open, but it forgot to reset the ret value
or not to assign, thus error went up the stack in the mount context.

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
index 5bd73edc2602..a3fa2dc39881 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1047,8 +1047,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 
 	list_for_each_entry(device, head, dev_list) {
 		/* Just open everything we can; ignore failures here */
-		ret = btrfs_open_one_device(fs_devices, device, flags, holder);
-		if (ret)
+		if (btrfs_open_one_device(fs_devices, device, flags, holder))
 			continue;
 
 		if (!latest_dev ||
-- 
2.15.0

