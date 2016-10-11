Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41982 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753085AbcJKCpC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 22:45:02 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 3/4] btrfs-progs: convert: Convert ext inode flags to btrfs inode flags
Date: Tue, 11 Oct 2016 10:44:45 +0800
Message-Id: <20161011024446.16546-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161011024446.16546-1-quwenruo@cn.fujitsu.com>
References: <20161011024446.16546-1-quwenruo@cn.fujitsu.com>
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
 btrfs-convert.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 542179e..2bcc16c 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2201,6 +2201,31 @@ static int ext2_check_state(struct btrfs_convert_context *cctx)
 		return 0;
 }
 
+/* EXT2_*_FL to BTRFS_INODE_FLAG_* stringification helper */
+#define COPY_ONE_EXT2_FLAG(flags, ext2_inode, name) ({			\
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
+	COPY_ONE_EXT2_FLAG(flags, src, APPEND);
+	COPY_ONE_EXT2_FLAG(flags, src, SYNC);
+	COPY_ONE_EXT2_FLAG(flags, src, IMMUTABLE);
+	COPY_ONE_EXT2_FLAG(flags, src, NODUMP);
+	COPY_ONE_EXT2_FLAG(flags, src, NOATIME);
+	COPY_ONE_EXT2_FLAG(flags, src, DIRSYNC);
+	btrfs_set_stack_inode_flags(dst, flags);
+}
+
 /*
  * copy a single inode. do all the required works, such as cloning
  * inode item, creating file extents and creating directory entries.
@@ -2223,6 +2248,7 @@ static int ext2_copy_single_inode(struct btrfs_trans_handle *trans,
 			    BTRFS_INODE_NODATASUM;
 		btrfs_set_stack_inode_flags(&btrfs_inode, flags);
 	}
+	ext2_convert_inode_flags(&btrfs_inode, ext2_inode);
 
 	switch (ext2_inode->i_mode & S_IFMT) {
 	case S_IFREG:
-- 
2.10.0



