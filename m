Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:56132 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753956AbeASFiB (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:38:01 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 09/16] btrfs-progs: check: Move __create_inode_item function to check/common.c
Date: Fri, 19 Jan 2018 13:37:24 +0800
Message-Id: <20180119053731.10795-10-wqu@suse.com>
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
References: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move __create_inode_item() function to check/common.c and rename it to
insert_inode_item(), with comment added.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/common.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 check/common.h |  3 +++
 check/main.c   | 36 ++----------------------------------
 3 files changed, 50 insertions(+), 34 deletions(-)

diff --git a/check/common.c b/check/common.c
index ed4f2a40bac2..6a7d86dfd8f7 100644
--- a/check/common.c
+++ b/check/common.c
@@ -14,8 +14,11 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <time.h>
 #include "ctree.h"
 #include "internal.h"
+#include "messages.h"
+#include "transaction.h"
 #include "check/common.h"
 
 /*
@@ -99,3 +102,45 @@ out:
 	return 0;
 }
 
+/*
+ * Wrapper to insert one inode item into given @root
+ * Timestamp will be set to current time.
+ *
+ * @root:	the root to insert inode item into
+ * @ino:	inode number
+ * @size:	inode size
+ * @nbytes:	nbytes (real used size, without hole)
+ * @nlink:	number of links
+ * @mode:	file mode, including S_IF* bits
+ */
+int insert_inode_item(struct btrfs_trans_handle *trans,
+		      struct btrfs_root *root, u64 ino, u64 size,
+		      u64 nbytes, u64 nlink, u32 mode)
+{
+	struct btrfs_inode_item ii;
+	time_t now = time(NULL);
+	int ret;
+
+	btrfs_set_stack_inode_size(&ii, size);
+	btrfs_set_stack_inode_nbytes(&ii, nbytes);
+	btrfs_set_stack_inode_nlink(&ii, nlink);
+	btrfs_set_stack_inode_mode(&ii, mode);
+	btrfs_set_stack_inode_generation(&ii, trans->transid);
+	btrfs_set_stack_timespec_nsec(&ii.atime, 0);
+	btrfs_set_stack_timespec_sec(&ii.ctime, now);
+	btrfs_set_stack_timespec_nsec(&ii.ctime, 0);
+	btrfs_set_stack_timespec_sec(&ii.mtime, now);
+	btrfs_set_stack_timespec_nsec(&ii.mtime, 0);
+	btrfs_set_stack_timespec_sec(&ii.otime, 0);
+	btrfs_set_stack_timespec_nsec(&ii.otime, 0);
+
+	ret = btrfs_insert_inode(trans, root, ino, &ii);
+	ASSERT(!ret);
+
+	warning("root %llu inode %llu recreating inode item, this may "
+		"be incomplete, please check permissions and content after "
+		"the fsck completes.\n", (unsigned long long)root->objectid,
+		(unsigned long long)ino);
+
+	return 0;
+}
diff --git a/check/common.h b/check/common.h
index cd64798f4804..efab05ad6b68 100644
--- a/check/common.h
+++ b/check/common.h
@@ -82,5 +82,8 @@ static inline int fs_root_objectid(u64 objectid)
 
 int count_csum_range(struct btrfs_fs_info *fs_info, u64 start,
 		     u64 len, u64 *found);
+int insert_inode_item(struct btrfs_trans_handle *trans,
+		      struct btrfs_root *root, u64 ino, u64 size,
+		      u64 nbytes, u64 nlink, u32 mode);
 
 #endif
diff --git a/check/main.c b/check/main.c
index b891f4815d30..e594b5986a47 100644
--- a/check/main.c
+++ b/check/main.c
@@ -2691,45 +2691,13 @@ static int delete_dir_index(struct btrfs_root *root,
 	return ret;
 }
 
-static int __create_inode_item(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root, u64 ino, u64 size,
-			       u64 nbytes, u64 nlink, u32 mode)
-{
-	struct btrfs_inode_item ii;
-	time_t now = time(NULL);
-	int ret;
-
-	btrfs_set_stack_inode_size(&ii, size);
-	btrfs_set_stack_inode_nbytes(&ii, nbytes);
-	btrfs_set_stack_inode_nlink(&ii, nlink);
-	btrfs_set_stack_inode_mode(&ii, mode);
-	btrfs_set_stack_inode_generation(&ii, trans->transid);
-	btrfs_set_stack_timespec_nsec(&ii.atime, 0);
-	btrfs_set_stack_timespec_sec(&ii.ctime, now);
-	btrfs_set_stack_timespec_nsec(&ii.ctime, 0);
-	btrfs_set_stack_timespec_sec(&ii.mtime, now);
-	btrfs_set_stack_timespec_nsec(&ii.mtime, 0);
-	btrfs_set_stack_timespec_sec(&ii.otime, 0);
-	btrfs_set_stack_timespec_nsec(&ii.otime, 0);
-
-	ret = btrfs_insert_inode(trans, root, ino, &ii);
-	ASSERT(!ret);
-
-	warning("root %llu inode %llu recreating inode item, this may "
-		"be incomplete, please check permissions and content after "
-		"the fsck completes.\n", (unsigned long long)root->objectid,
-		(unsigned long long)ino);
-
-	return 0;
-}
-
 static int create_inode_item_lowmem(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root, u64 ino,
 				    u8 filetype)
 {
 	u32 mode = (filetype == BTRFS_FT_DIR ? S_IFDIR : S_IFREG) | 0755;
 
-	return __create_inode_item(trans, root, ino, 0, 0, 0, mode);
+	return insert_inode_item(trans, root, ino, 0, 0, 0, mode);
 }
 
 static int create_inode_item(struct btrfs_root *root,
@@ -2762,7 +2730,7 @@ static int create_inode_item(struct btrfs_root *root,
 		mode =  S_IFREG | 0755;
 	}
 
-	ret = __create_inode_item(trans, root, rec->ino, size, rec->nbytes,
+	ret = insert_inode_item(trans, root, rec->ino, size, rec->nbytes,
 				  nlink, mode);
 	btrfs_commit_transaction(trans, root);
 	return 0;
-- 
2.15.1

