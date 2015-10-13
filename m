Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64609 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932284AbbJMCUj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 22:20:39 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9D2K1QC012662
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 10:20:09 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 12/21] btrfs: extent-tree: Add new version of btrfs_delalloc_reserve/release_space
Date: Tue, 13 Oct 2015 10:20:18 +0800
Message-Id: <1444702827-18169-13-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new version of btrfs_delalloc_reserve_space() and
btrfs_delalloc_release_space() functions, which supports accurate qgroup
reserve.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Add new function btrfs_delalloc_release_space() to handle error case.
v3:
  None
---
 fs/btrfs/ctree.h       |  2 ++
 fs/btrfs/extent-tree.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 19450a1..4221bfd 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3473,7 +3473,9 @@ void btrfs_subvolume_release_metadata(struct btrfs_root *root,
 int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
 int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes);
+int __btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len);
 void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes);
+void __btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
 					      unsigned short type);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f4b9db8..32455e0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5723,6 +5723,44 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 }
 
 /**
+ * __btrfs_delalloc_reserve_space - reserve data and metadata space for
+ * delalloc
+ * @inode: inode we're writing to
+ * @start: start range we are writing to
+ * @len: how long the range we are writing to
+ *
+ * TODO: This function will finally replace old btrfs_delalloc_reserve_space()
+ *
+ * This will do the following things
+ *
+ * o reserve space in data space info for num bytes
+ *   and reserve precious corresponding qgroup space
+ *   (Done in check_data_free_space)
+ *
+ * o reserve space for metadata space, based on the number of outstanding
+ *   extents and how much csums will be needed
+ *   also reserve metadata space in a per root over-reserve method.
+ * o add to the inodes->delalloc_bytes
+ * o add it to the fs_info's delalloc inodes list.
+ *   (Above 3 all done in delalloc_reserve_metadata)
+ *
+ * Return 0 for success
+ * Return <0 for error(-ENOSPC or -EQUOT)
+ */
+int __btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
+{
+	int ret;
+
+	ret = __btrfs_check_data_free_space(inode, start, len);
+	if (ret < 0)
+		return ret;
+	ret = btrfs_delalloc_reserve_metadata(inode, len);
+	if (ret < 0)
+		__btrfs_free_reserved_data_space(inode, start, len);
+	return ret;
+}
+
+/**
  * btrfs_delalloc_reserve_space - reserve data and metadata space for delalloc
  * @inode: inode we're writing to
  * @num_bytes: the number of bytes we want to allocate
@@ -5755,6 +5793,27 @@ int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes)
 }
 
 /**
+ * __btrfs_delalloc_release_space - release data and metadata space for delalloc
+ * @inode: inode we're releasing space for
+ * @start: start position of the space already reserved
+ * @len: the len of the space already reserved
+ *
+ * This must be matched with a call to btrfs_delalloc_reserve_space.  This is
+ * called in the case that we don't need the metadata AND data reservations
+ * anymore.  So if there is an error or we insert an inline extent.
+ *
+ * This function will release the metadata space that was not used and will
+ * decrement ->delalloc_bytes and remove it from the fs_info delalloc_inodes
+ * list if there are no delalloc bytes left.
+ * Also it will handle the qgroup reserved space.
+ */
+void __btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len)
+{
+	btrfs_delalloc_release_metadata(inode, len);
+	__btrfs_free_reserved_data_space(inode, start, len);
+}
+
+/**
  * btrfs_delalloc_release_space - release data and metadata space for delalloc
  * @inode: inode we're releasing space for
  * @num_bytes: the number of bytes we want to free up
-- 
2.6.1

