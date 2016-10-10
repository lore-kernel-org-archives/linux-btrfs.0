Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4152 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751368AbcJJDLj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 9 Oct 2016 23:11:39 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lakshmipathi.g@gmail.com
Subject: [PATCH 3/4] btrfs-progs: convert: Convert ext inode flags to btrfs inode flags
Date: Mon, 10 Oct 2016 11:11:20 +0800
Message-Id: <20161010031121.5017-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161010031121.5017-1-quwenruo@cn.fujitsu.com>
References: <20161010031121.5017-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, btrfs-convert never copy ext* inode flags to
corresponding btrfs inode flags.

This makes common flags like APPEND/SYNC/SYNCDIR/IMMUTABLE not copied to
btrfs inode.

This patch introduces ext2_convert_inode_flags() function to handle the
convert, so btrfs-convert can copy as many inode flags as possible.

Reported-by: Lakshmipathi.G <lakshmipathi.g@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 542179e..160a635 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2201,6 +2201,30 @@ static int ext2_check_state(struct btrfs_convert_context *cctx)
 		return 0;
 }
 
+#define copy_one_ext2_flag(flags, ext2_inode, name) ({			\
+	if (ext2_inode->i_flags & EXT2_##name##_FL)			\
+		flags |= BTRFS_INODE_##name;				\
+})
+
+/*
+ * Convert EXT2_*_FL to corresponding BTRFS_INODE_* flags
+ *
+ * Only a subset of EXT_*_FL is supported in btrfs.
+ */
+static void ext2_convert_inode_flags(struct btrfs_inode_item *dst,
+				     struct ext2_inode *src)
+{
+	u64 flags = 0;
+
+	copy_one_ext2_flag(flags, src, APPEND);
+	copy_one_ext2_flag(flags, src, SYNC);
+	copy_one_ext2_flag(flags, src, IMMUTABLE);
+	copy_one_ext2_flag(flags, src, NODUMP);
+	copy_one_ext2_flag(flags, src, NOATIME);
+	copy_one_ext2_flag(flags, src, DIRSYNC);
+	btrfs_set_stack_inode_flags(dst, flags);
+}
+
 /*
  * copy a single inode. do all the required works, such as cloning
  * inode item, creating file extents and creating directory entries.
@@ -2223,6 +2247,7 @@ static int ext2_copy_single_inode(struct btrfs_trans_handle *trans,
 			    BTRFS_INODE_NODATASUM;
 		btrfs_set_stack_inode_flags(&btrfs_inode, flags);
 	}
+	ext2_convert_inode_flags(&btrfs_inode, ext2_inode);
 
 	switch (ext2_inode->i_mode & S_IFMT) {
 	case S_IFREG:
-- 
2.10.0



