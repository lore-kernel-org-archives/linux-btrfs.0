Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43726 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab3DYMNn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 08:13:43 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com
Subject: [PATCH] btrfs-progs: mkfs seg fault for wrong free
Date: Thu, 25 Apr 2013 20:15:42 +0800
Message-Id: <1366892142-21920-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With commit
        87c09f7 Btrfs-progs: fix memory leaks on cleanup

mkfs on multiple dev is ending with segfault at
close_all_devices() during kfree(device->name)

because mkfs calls btrfs_add_to_fsid, which does not initialize
name when dev is added to the list.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 disk-io.c | 6 ++++--
 utils.c   | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index be4abb8..15c90fe 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1290,8 +1290,10 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
 				fprintf(stderr, "Warning, could not drop caches\n");
 		}
 		close(device->fd);
-		kfree(device->name);
-		kfree(device->label);
+		if (device->name)
+			kfree(device->name);
+		if (device->label)
+			kfree(device->label);
 		kfree(device);
 	}
 	kfree(fs_info->fs_devices);
diff --git a/utils.c b/utils.c
index 7b028a7..8104465 100644
--- a/utils.c
+++ b/utils.c
@@ -484,6 +484,8 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	device = kmalloc(sizeof(*device), GFP_NOFS);
 	if (!device)
 		return -ENOMEM;
+	memset(device, 0, sizeof(*device));
+	
 	buf = kmalloc(sectorsize, GFP_NOFS);
 	if (!buf) {
 		kfree(device);
-- 
1.8.1.227.g44fe835

