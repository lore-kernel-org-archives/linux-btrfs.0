Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4152 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751982AbcJJDLm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 9 Oct 2016 23:11:42 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lakshmipathi.g@gmail.com
Subject: [PATCH 2/4] btrfs-progs: Make btrfs-debug-tree print all readable strings for inode flags
Date: Mon, 10 Oct 2016 11:11:19 +0800
Message-Id: <20161010031121.5017-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161010031121.5017-1-quwenruo@cn.fujitsu.com>
References: <20161010031121.5017-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, only 3 inode flags have readable string: NODATACOW,
NODATASUM, READONLY.

This patch will output all readable strings for remaining inode flags,
making debug-tree tool more handy.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 print-tree.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 4444a14..f015646 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -851,29 +851,35 @@ static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
 	}
 }
 
-/* Caller should ensure sizeof(*ret) >= 29 "NODATASUM|NODATACOW|READONLY" */
+#define copy_one_inode_flag(flags, name, empty, dst) ({			\
+	if (flags & BTRFS_INODE_##name) {				\
+		if (!empty)						\
+			strcat(dst, "|");				\
+		strcat(dst, #name);					\
+		empty = 0;						\
+	}								\
+})
+
+/*
+ * Caller should ensure sizeof(*ret) >= 102: all charactors plus '|' of
+ * BTRFS_INODE_* flags
+ */
 static void inode_flags_to_str(u64 flags, char *ret)
 {
 	int empty = 1;
 
-	if (flags & BTRFS_INODE_NODATASUM) {
-		empty = 0;
-		strcpy(ret, "NODATASUM");
-	}
-	if (flags & BTRFS_INODE_NODATACOW) {
-		if (!empty) {
-			empty = 0;
-			strcat(ret, "|");
-		}
-		strcat(ret, "NODATACOW");
-	}
-	if (flags & BTRFS_INODE_READONLY) {
-		if (!empty) {
-			empty = 0;
-			strcat(ret, "|");
-		}
-		strcat(ret, "READONLY");
-	}
+	copy_one_inode_flag(flags, NODATASUM, empty, ret);
+	copy_one_inode_flag(flags, NODATACOW, empty, ret);
+	copy_one_inode_flag(flags, READONLY, empty, ret);
+	copy_one_inode_flag(flags, NOCOMPRESS, empty, ret);
+	copy_one_inode_flag(flags, PREALLOC, empty, ret);
+	copy_one_inode_flag(flags, SYNC, empty, ret);
+	copy_one_inode_flag(flags, IMMUTABLE, empty, ret);
+	copy_one_inode_flag(flags, APPEND, empty, ret);
+	copy_one_inode_flag(flags, NODUMP, empty, ret);
+	copy_one_inode_flag(flags, NOATIME, empty, ret);
+	copy_one_inode_flag(flags, DIRSYNC, empty, ret);
+	copy_one_inode_flag(flags, COMPRESS, empty, ret);
 	if (empty)
 		strcat(ret, "none");
 }
@@ -902,7 +908,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	u32 nr = btrfs_header_nritems(l);
 	u64 objectid;
 	u32 type;
-	char flags_str[32];
+	char flags_str[128];
 
 	printf("leaf %llu items %d free space %d generation %llu owner %llu\n",
 		(unsigned long long)btrfs_header_bytenr(l), nr,
-- 
2.10.0



