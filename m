Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64820 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751368AbcJJDLl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 9 Oct 2016 23:11:41 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lakshmipathi.g@gmail.com
Subject: [PATCH 1/4] btrfs-progs: Copy btrfs inode flags from kernel header
Date: Mon, 10 Oct 2016 11:11:18 +0800
Message-Id: <20161010031121.5017-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161010031121.5017-1-quwenruo@cn.fujitsu.com>
References: <20161010031121.5017-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs-progs header lacks quite a lot inode flags.
Copy them from kernel for later use.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/ctree.h b/ctree.h
index e0dd2e4..c76b1f1 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1246,6 +1246,15 @@ struct btrfs_root {
 #define BTRFS_INODE_NODATASUM		(1 << 0)
 #define BTRFS_INODE_NODATACOW		(1 << 1)
 #define BTRFS_INODE_READONLY		(1 << 2)
+#define BTRFS_INODE_NOCOMPRESS		(1 << 3)
+#define BTRFS_INODE_PREALLOC		(1 << 4)
+#define BTRFS_INODE_SYNC		(1 << 5)
+#define BTRFS_INODE_IMMUTABLE		(1 << 6)
+#define BTRFS_INODE_APPEND		(1 << 7)
+#define BTRFS_INODE_NODUMP		(1 << 8)
+#define BTRFS_INODE_NOATIME		(1 << 9)
+#define BTRFS_INODE_DIRSYNC		(1 << 10)
+#define BTRFS_INODE_COMPRESS		(1 << 11)
 
 #define read_eb_member(eb, ptr, type, member, result) (			\
 	read_extent_buffer(eb, (char *)(result),			\
-- 
2.10.0



