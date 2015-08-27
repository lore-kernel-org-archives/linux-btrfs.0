Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33523 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbbH0Pil (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 11:38:41 -0400
Received: by pacti10 with SMTP id ti10so29976100pac.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 08:38:41 -0700 (PDT)
Received: from arch-nb.localdomain ([175.118.89.137])
        by smtp.gmail.com with ESMTPSA id vw6sm2844831pab.14.2015.08.27.08.38.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 27 Aug 2015 08:38:40 -0700 (PDT)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: add memory allocation fail check in btrfs_add_to_fsid()
Date: Fri, 28 Aug 2015 00:38:18 +0900
Message-Id: <1440689898-35178-4-git-send-email-bhlee.kernel@gmail.com>
In-Reply-To: <1440689898-35178-1-git-send-email-bhlee.kernel@gmail.com>
References: <1440689898-35178-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_add_to_fsid(), strdup() allocates memory to device->name, but
the return value is not checked.
So add the return value check and error handling code.
And clean-up error handling code for ENOMEM case.

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 utils.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/utils.c b/utils.c
index 280637d896c1..160a8c273da8 100644
--- a/utils.c
+++ b/utils.c
@@ -729,21 +729,18 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	struct btrfs_super_block *super = root->fs_info->super_copy;
 	struct btrfs_device *device;
 	struct btrfs_dev_item *dev_item;
-	char *buf;
+	char *buf = NULL;
 	u64 total_bytes;
 	u64 num_devs;
 	int ret;
 
 	device = kzalloc(sizeof(*device), GFP_NOFS);
 	if (!device)
-		return -ENOMEM;
-	buf = kmalloc(sectorsize, GFP_NOFS);
-	if (!buf) {
-		kfree(device);
-		return -ENOMEM;
-	}
+		goto err_nomem;
+	buf = kzalloc(sectorsize, GFP_NOFS);
+	if (!buf)
+		goto err_nomem;
 	BUG_ON(sizeof(*disk_super) > sectorsize);
-	memset(buf, 0, sectorsize);
 
 	disk_super = (struct btrfs_super_block *)buf;
 	dev_item = &disk_super->dev_item;
@@ -761,6 +758,8 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	device->total_ios = 0;
 	device->dev_root = root->fs_info->dev_root;
 	device->name = strdup(path);
+	if (!device->name)
+		goto err_nomem;
 
 	ret = btrfs_add_device(trans, root, device);
 	BUG_ON(ret);
@@ -790,6 +789,11 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	list_add(&device->dev_list, &root->fs_info->fs_devices->devices);
 	device->fs_devices = root->fs_info->fs_devices;
 	return 0;
+
+err_nomem:
+	kfree(device);
+	kfree(buf);
+	return -ENOMEM;
 }
 
 static void btrfs_wipe_existing_sb(int fd)
-- 
2.5.0

