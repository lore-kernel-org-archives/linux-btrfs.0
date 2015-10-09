Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:50983 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752300AbbJIC2L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 22:28:11 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t992RWSq023467
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 10:27:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 15/23] btrfs: extent-tree: Add new version of btrfs_delalloc_reserve/release_space
Date: Fri, 9 Oct 2015 10:25:49 +0800
Message-ID: <1444357551-1286-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new version of btrfs_delalloc_reserve_space() and
btrfs_delalloc_release_space() functions, which supports accurate qgroup
reserve.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Add new function btrfs_delalloc_release_space() to handle error case.
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

