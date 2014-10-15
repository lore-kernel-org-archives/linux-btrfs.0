Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23754 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaJOIik (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 04:38:40 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 1/1] btrfs-progs: mkfs should be consistent in calling register device
Date: Wed, 15 Oct 2014 08:45:11 +0800
Message-Id: <1413333911-25542-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we have one device we don't call register device.
(in fact not mandatory, but to make it consistent)
And when we have more than one we call register device.

reproducer:
Nothing in the kernel device list
cat /proc/fs/btrfs/devlist | egrep fsid | wc -l
0

mkfs.btrfs will automatically call register device when devices
is more than 1.

mkfs.btrfs -f /dev/sdb /dev/sdc
cat /proc/fs/btrfs/devlist | egrep fsid | wc -l
1

But it does not when there is only one device

mkfs.btrfs -f /dev/sdb
cat /proc/fs/btrfs/devlist | egrep fsid | wc -l
0

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 9de61e1..e10e62d 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1588,11 +1588,11 @@ int main(int ac, char **av)
 
 	trans = btrfs_start_transaction(root, 1);
 
+	btrfs_register_one_device(file);
+
 	if (dev_cnt == 0)
 		goto raid_groups;
 
-	btrfs_register_one_device(file);
-
 	while (dev_cnt-- > 0) {
 		int old_mixed = mixed;
 
-- 
2.0.0.153.g79dcccc

