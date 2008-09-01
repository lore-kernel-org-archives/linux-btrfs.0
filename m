From: Zheng Yan <zheng.yan@oracle.com>
Subject: [PATCH] Update find free objectid function for orphan cleanup code
Date: Tue, 02 Sep 2008 02:28:41 +0800
Message-ID: <48BC3459.80705@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Orphan items use BTRFS_ORPHAN_OBJECTID (-5UUL) as key objectid. This
affects the find free objectid functions, inode objectid can easily
overflow after orphan file cleanup.

---
diff -r 8fe9e10847fa ctree.h
--- a/ctree.h	Thu Aug 28 06:21:17 2008 -0400
+++ b/ctree.h	Tue Sep 02 01:41:40 2008 +0800
@@ -78,9 +78,10 @@
 #define BTRFS_ORPHAN_OBJECTID -5ULL
 
 /*
- * All files have objectids higher than this.
+ * All files have objectids in this range.
  */
 #define BTRFS_FIRST_FREE_OBJECTID 256ULL
+#define BTRFS_LAST_FREE_OBJECTID -256ULL
 #define BTRFS_FIRST_CHUNK_TREE_OBJECTID 256ULL
 
 
diff -r 8fe9e10847fa inode-map.c
--- a/inode-map.c	Thu Aug 28 06:21:17 2008 -0400
+++ b/inode-map.c	Tue Sep 02 01:41:40 2008 +0800
@@ -32,7 +32,8 @@
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
-	search_key.objectid = (u64)-1;
+	search_key.objectid = BTRFS_LAST_FREE_OBJECTID;
+	search_key.type = -1;
 	search_key.offset = (u64)-1;
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
 	if (ret < 0)
@@ -70,16 +71,17 @@
 	u64 search_start = dirid;
 
 	mutex_lock(&root->objectid_mutex);
-	if (root->last_inode_alloc) {
+	if (root->last_inode_alloc >= BTRFS_FIRST_FREE_OBJECTID &&
+	    root->last_inode_alloc < BTRFS_LAST_FREE_OBJECTID) {
 		*objectid = ++root->last_inode_alloc;
 		mutex_unlock(&root->objectid_mutex);
 		return 0;
 	}
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
-	search_start = root->last_inode_alloc;
 	search_start = max(search_start, BTRFS_FIRST_FREE_OBJECTID);
 	search_key.objectid = search_start;
+	search_key.type = 0;
 	search_key.offset = 0;
 
 	btrfs_init_path(path);
@@ -87,9 +89,6 @@
 	ret = btrfs_search_slot(trans, root, &search_key, path, 0, 0);
 	if (ret < 0)
 		goto error;
-
-	if (path->slots[0] > 0)
-		path->slots[0]--;
 
 	while (1) {
 		l = path->nodes[0];
@@ -120,13 +119,15 @@
 				}
 			}
 		}
+		if (key.objectid >= BTRFS_LAST_FREE_OBJECTID)
+			break;
 		start_found = 1;
 		last_ino = key.objectid + 1;
 		path->slots[0]++;
 	}
 	// FIXME -ENOSPC
+	BUG_ON(1);
 found:
-	root->last_inode_alloc = *objectid;
 	btrfs_release_path(root, path);
 	btrfs_free_path(path);
 	BUG_ON(*objectid < search_start);
