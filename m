Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48982 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbbIIFF1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Sep 2015 01:05:27 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t888dQvF019126
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Sep 2015 16:39:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 16/19] btrfs: extent-tree: Add new version of btrfs_delalloc_reserve_space
Date: Tue,  8 Sep 2015 16:37:33 +0800
Message-Id: <1441701456-8034-17-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441701456-8034-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441701456-8034-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new version of btrfs_delalloc_reserve_space() function, which
supports accurate qgroup reserve.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/extent-tree.c | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c1a0aaf..12f14fd 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3472,6 +3472,7 @@ void btrfs_subvolume_release_metadata(struct btrfs_root *root,
 int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
 int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes);
+int __btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len);
 void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2e3f19e..07f45b7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5686,6 +5686,44 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
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
+		btrfs_free_reserved_data_space(inode, len);
+	return ret;
+}
+
+/**
  * btrfs_delalloc_reserve_space - reserve data and metadata space for delalloc
  * @inode: inode we're writing to
  * @num_bytes: the number of bytes we want to allocate
-- 
2.5.1

