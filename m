From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Fix stop searching test in replace_one_extent
Date: Wed, 21 Jan 2009 19:53:05 +0800
Message-ID: <49770CA1.7060605@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

replace_one_extent search tree leaves for references to
a given extent. It stop searching if goes beyond the last
possible position. The last possible position is computed
by adding the starting offset of a found file extent to 
the full size of the extent. The code uses physical size
of the extent as the full size. This is incorrect since
btrfs supported compression. The fix is get the full size
from ram_bytes field of file extent item. Thank you,

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-01-07 07:16:42.762364700 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-01-08 15:14:47.000000000 +0800
@@ -4444,7 +4445,7 @@ static noinline int replace_one_extent(s
 	u64 lock_end = 0;
 	u64 num_bytes;
 	u64 ext_offset;
-	u64 first_pos;
+	u64 search_end = (u64)-1;
 	u32 nritems;
 	int nr_scaned = 0;
 	int extent_locked = 0;
@@ -4452,7 +4453,6 @@ static noinline int replace_one_extent(s
 	int ret;
 
 	memcpy(&key, leaf_key, sizeof(key));
-	first_pos = INT_LIMIT(loff_t) - extent_key->offset;
 	if (ref_path->owner_objectid != BTRFS_MULTIPLE_OBJECTIDS) {
 		if (key.objectid < ref_path->owner_objectid ||
 		    (key.objectid == ref_path->owner_objectid &&
@@ -4501,7 +4501,7 @@ next:
 			if ((key.objectid > ref_path->owner_objectid) ||
 			    (key.objectid == ref_path->owner_objectid &&
 			     key.type > BTRFS_EXTENT_DATA_KEY) ||
-			    (key.offset >= first_pos + extent_key->offset))
+			    key.offset >= search_end)
 				break;
 		}
 
@@ -4534,8 +4534,10 @@ next:
 		num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
 		ext_offset = btrfs_file_extent_offset(leaf, fi);
 
-		if (first_pos > key.offset - ext_offset)
-			first_pos = key.offset - ext_offset;
+		if (search_end == (u64)-1) {
+			search_end = key.offset - ext_offset +
+				btrfs_file_extent_ram_bytes(leaf, fi);
+		}
 
 		if (!extent_locked) {
 			lock_start = key.offset;
@@ -4724,7 +4726,7 @@ next:
 		}
 skip:
 		if (ref_path->owner_objectid != BTRFS_MULTIPLE_OBJECTIDS &&
-		    key.offset >= first_pos + extent_key->offset)
+		    key.offset >= search_end)
 			break;
 
 		cond_resched();


