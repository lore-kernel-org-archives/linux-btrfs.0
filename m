Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3846 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753085AbcJKCpF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 22:45:05 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 2/4] btrfs-progs: Make btrfs-debug-tree print all readable strings for inode flags
Date: Tue, 11 Oct 2016 10:44:44 +0800
Message-Id: <20161011024446.16546-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161011024446.16546-1-quwenruo@cn.fujitsu.com>
References: <20161011024446.16546-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, only 3 inode flags have readable string: NODATACOW,
NODATASUM, READONLY.

This patch will output all readable strings for remaining inode flags,
making debug-tree tool more handy.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 print-tree.c | 47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 4444a14..990cdba 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -851,29 +851,36 @@ static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
 	}
 }
 
-/* Caller should ensure sizeof(*ret) >= 29 "NODATASUM|NODATACOW|READONLY" */
+/* Btrfs inode flag stringification helper */
+#define CAT_ONE_INODE_FLAG(flags, name, empty, dst) ({			\
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
+	CAT_ONE_INODE_FLAG(flags, NODATASUM, empty, ret);
+	CAT_ONE_INODE_FLAG(flags, NODATACOW, empty, ret);
+	CAT_ONE_INODE_FLAG(flags, READONLY, empty, ret);
+	CAT_ONE_INODE_FLAG(flags, NOCOMPRESS, empty, ret);
+	CAT_ONE_INODE_FLAG(flags, PREALLOC, empty, ret);
+	CAT_ONE_INODE_FLAG(flags, SYNC, empty, ret);
+	CAT_ONE_INODE_FLAG(flags, IMMUTABLE, empty, ret);
+	CAT_ONE_INODE_FLAG(flags, APPEND, empty, ret);
+	CAT_ONE_INODE_FLAG(flags, NODUMP, empty, ret);
+	CAT_ONE_INODE_FLAG(flags, NOATIME, empty, ret);
+	CAT_ONE_INODE_FLAG(flags, DIRSYNC, empty, ret);
+	CAT_ONE_INODE_FLAG(flags, COMPRESS, empty, ret);
 	if (empty)
 		strcat(ret, "none");
 }
@@ -902,7 +909,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	u32 nr = btrfs_header_nritems(l);
 	u64 objectid;
 	u32 type;
-	char flags_str[32];
+	char flags_str[128];
 
 	printf("leaf %llu items %d free space %d generation %llu owner %llu\n",
 		(unsigned long long)btrfs_header_bytenr(l), nr,
-- 
2.10.0



