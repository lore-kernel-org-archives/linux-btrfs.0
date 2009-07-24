From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] fix find_free_dev_extent
Date: Fri, 24 Jul 2009 14:53:01 +0800
Message-ID: <4A695A4D.2010401@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

find_free_dev_extent does not properly handle the case:
device is not complete free, and there is a free extent
at the beginning of the device.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/volumes.c 2/fs/btrfs/volumes.c
--- 1/fs/btrfs/volumes.c	2009-07-24 09:57:18.679312973 +0800
+++ 2/fs/btrfs/volumes.c	2009-07-24 11:25:19.381057978 +0800
@@ -758,9 +758,13 @@ static noinline int find_free_dev_extent
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto error;
-	ret = btrfs_previous_item(root, path, 0, key.type);
-	if (ret < 0)
-		goto error;
+	if (ret > 0) {
+		ret = btrfs_previous_item(root, path, key.objectid, key.type);
+		if (ret < 0)
+			goto error;
+		if (ret > 0)
+			start_found = 1;
+	}
 	l = path->nodes[0];
 	btrfs_item_key_to_cpu(l, &key, path->slots[0]);
 	while (1) {
