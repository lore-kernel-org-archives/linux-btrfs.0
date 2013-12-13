Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5197 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209Ab3LMPGZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 10:06:25 -0500
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id rBDF5qBt014473
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 07:06:23 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1gqkgg2jnd-14
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 07:06:23 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: deal with io_tree->mapping being NULL
Date: Fri, 13 Dec 2013 10:03:54 -0500
Message-ID: <1386947034-9987-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I need to add infrastructure to allocate dummy extent buffers for running sanity
tests, and to do this I need to not have to worry about having an
address_mapping for an io_tree, so just fix up the places where we assume that
all io_tree's have a non-NULL ->mapping.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent_io.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3c3f448..2779255 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -77,13 +77,19 @@ void btrfs_leak_debug_check(void)
 	}
 }
 
-#define btrfs_debug_check_extent_io_range(inode, start, end)		\
-	__btrfs_debug_check_extent_io_range(__func__, (inode), (start), (end))
+#define btrfs_debug_check_extent_io_range(tree, start, end)		\
+	__btrfs_debug_check_extent_io_range(__func__, (tree), (start), (end))
 static inline void __btrfs_debug_check_extent_io_range(const char *caller,
-		struct inode *inode, u64 start, u64 end)
+		struct extent_io_tree *tree, u64 start, u64 end)
 {
-	u64 isize = i_size_read(inode);
+	struct inode *inode;
+	u64 isize;
 
+	if (!tree->mapping)
+		return;
+
+	inode = tree->mapping->host;
+	isize = i_size_read(inode);
 	if (end >= PAGE_SIZE && (end % 2) == 0 && end != isize - 1) {
 		printk_ratelimited(KERN_DEBUG
 		    "btrfs: %s: ino %llu isize %llu odd range [%llu,%llu]\n",
@@ -124,6 +130,8 @@ static noinline void flush_write_bio(void *data);
 static inline struct btrfs_fs_info *
 tree_fs_info(struct extent_io_tree *tree)
 {
+	if (!tree->mapping)
+		return NULL;
 	return btrfs_sb(tree->mapping->host->i_sb);
 }
 
@@ -570,7 +578,7 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	int err;
 	int clear = 0;
 
-	btrfs_debug_check_extent_io_range(tree->mapping->host, start, end);
+	btrfs_debug_check_extent_io_range(tree, start, end);
 
 	if (bits & EXTENT_DELALLOC)
 		bits |= EXTENT_NORESERVE;
@@ -730,7 +738,7 @@ static void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct extent_state *state;
 	struct rb_node *node;
 
-	btrfs_debug_check_extent_io_range(tree->mapping->host, start, end);
+	btrfs_debug_check_extent_io_range(tree, start, end);
 
 	spin_lock(&tree->lock);
 again:
@@ -817,7 +825,7 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	u64 last_start;
 	u64 last_end;
 
-	btrfs_debug_check_extent_io_range(tree->mapping->host, start, end);
+	btrfs_debug_check_extent_io_range(tree, start, end);
 
 	bits |= EXTENT_FIRST_DELALLOC;
 again:
@@ -1043,7 +1051,7 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	u64 last_start;
 	u64 last_end;
 
-	btrfs_debug_check_extent_io_range(tree->mapping->host, start, end);
+	btrfs_debug_check_extent_io_range(tree, start, end);
 
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
-- 
1.8.3.1

