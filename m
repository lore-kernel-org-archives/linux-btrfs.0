Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50129 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751537AbdCAGbu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Mar 2017 01:31:50 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 196F847D8B79
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:17 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 12/20] btrfs-progs: cmds-check.c: introduce __create_inode_item
Date: Wed, 1 Mar 2017 11:13:55 +0800
Message-ID: <20170301031403.23902-13-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce '__create_inode' to create and insert inode item.
Modify origin 'create_inode_item' call it.
Create 'create_inode_item_lowmem' call it.
The patch is for further lowmem repair.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 83 ++++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 30 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index bda0849b..256bfbc9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2586,13 +2586,55 @@ static int delete_dir_index(struct btrfs_root *root,
 	return ret;
 }
 
+static int __create_inode_item(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root, u64 ino, u64 size,
+			       u64 nbytes, u64 nlink, u32 mode)
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
+
+static int create_inode_item_lowmem(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root, u64 ino,
+				    u8 filetype)
+{
+	u32 mode = (filetype == BTRFS_FT_DIR ? S_IFDIR : S_IFREG) | 0755;
+
+	return __create_inode_item(trans, root, ino, 0, 0, 0, mode);
+}
+
 static int create_inode_item(struct btrfs_root *root,
 			     struct inode_record *rec,
 			     struct inode_backref *backref, int root_dir)
 {
 	struct btrfs_trans_handle *trans;
-	struct btrfs_inode_item inode_item;
-	time_t now = time(NULL);
+	u64 nlink = 0;
+	u32 mode = 0;
+	u64 size = 0;
 	int ret;
 
 	trans = btrfs_start_transaction(root, 1);
@@ -2601,18 +2643,7 @@ static int create_inode_item(struct btrfs_root *root,
 		return ret;
 	}
 
-	fprintf(stderr, "root %llu inode %llu recreating inode item, this may "
-		"be incomplete, please check permissions and content after "
-		"the fsck completes.\n", (unsigned long long)root->objectid,
-		(unsigned long long)rec->ino);
-
-	memset(&inode_item, 0, sizeof(inode_item));
-	btrfs_set_stack_inode_generation(&inode_item, trans->transid);
-	if (root_dir)
-		btrfs_set_stack_inode_nlink(&inode_item, 1);
-	else
-		btrfs_set_stack_inode_nlink(&inode_item, rec->found_link);
-	btrfs_set_stack_inode_nbytes(&inode_item, rec->found_size);
+	nlink = root_dir ? 1 : rec->found_link;
 	if (rec->found_dir_item) {
 		if (rec->found_file_extent)
 			fprintf(stderr, "root %llu inode %llu has both a dir "
@@ -2620,23 +2651,15 @@ static int create_inode_item(struct btrfs_root *root,
 				"regular file so setting it as a directory\n",
 				(unsigned long long)root->objectid,
 				(unsigned long long)rec->ino);
-		btrfs_set_stack_inode_mode(&inode_item, S_IFDIR | 0755);
-		btrfs_set_stack_inode_size(&inode_item, rec->found_size);
+		mode = S_IFDIR | 0755;
+		size = rec->found_size;
 	} else if (!rec->found_dir_item) {
-		btrfs_set_stack_inode_size(&inode_item, rec->extent_end);
-		btrfs_set_stack_inode_mode(&inode_item, S_IFREG | 0755);
-	}
-	btrfs_set_stack_timespec_sec(&inode_item.atime, now);
-	btrfs_set_stack_timespec_nsec(&inode_item.atime, 0);
-	btrfs_set_stack_timespec_sec(&inode_item.ctime, now);
-	btrfs_set_stack_timespec_nsec(&inode_item.ctime, 0);
-	btrfs_set_stack_timespec_sec(&inode_item.mtime, now);
-	btrfs_set_stack_timespec_nsec(&inode_item.mtime, 0);
-	btrfs_set_stack_timespec_sec(&inode_item.otime, 0);
-	btrfs_set_stack_timespec_nsec(&inode_item.otime, 0);
-
-	ret = btrfs_insert_inode(trans, root, rec->ino, &inode_item);
-	BUG_ON(ret);
+		size = rec->extent_end;
+		mode =  S_IFREG | 0755;
+	}
+
+	ret = __create_inode_item(trans, root, rec->ino, size, rec->nbytes,
+				  nlink, mode);
 	btrfs_commit_transaction(trans, root);
 	return 0;
 }
-- 
2.11.1



