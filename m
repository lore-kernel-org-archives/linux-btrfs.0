From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] fix min_objectid check in btrfs_previous_item
Date: Fri, 24 Jul 2009 13:27:00 +0800
Message-ID: <4A694624.4040200@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

check objectid of item before checking the item type.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/ctree.c 2/fs/btrfs/ctree.c
--- 1/fs/btrfs/ctree.c	2009-07-24 09:57:18.670312761 +0800
+++ 2/fs/btrfs/ctree.c	2009-07-24 11:23:27.131306044 +0800
@@ -4308,10 +4308,10 @@ int btrfs_previous_item(struct btrfs_roo
 			path->slots[0]--;
 
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-		if (found_key.type == type)
-			return 0;
 		if (found_key.objectid < min_objectid)
 			break;
+		if (found_key.type == type)
+			return 0;
 		if (found_key.objectid == min_objectid &&
 		    found_key.type < type)
 			break;

