Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:57624 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753986AbeASFiB (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:38:01 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 12/16] btrfs-progs: check: move reada_walk_down to check/common.c
Date: Fri, 19 Jan 2018 13:37:27 +0800
Message-Id: <20180119053731.10795-13-wqu@suse.com>
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
References: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Both original and lowmem mode shares this function to do readahead.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/common.c | 23 +++++++++++++++++++++++
 check/common.h |  2 ++
 check/main.c   | 22 ----------------------
 3 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/check/common.c b/check/common.c
index 7392ed6b472f..1ea9f506713a 100644
--- a/check/common.c
+++ b/check/common.c
@@ -20,6 +20,7 @@
 #include "messages.h"
 #include "transaction.h"
 #include "utils.h"
+#include "disk-io.h"
 #include "check/common.h"
 
 /*
@@ -252,3 +253,25 @@ void check_dev_size_alignment(u64 devid, u64 total_bytes, u32 sectorsize)
 		warning("this can be fixed by 'btrfs rescue fix-device-size'");
 	}
 }
+
+void reada_walk_down(struct btrfs_root *root, struct extent_buffer *node,
+		     int slot)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	u64 bytenr;
+	u64 ptr_gen;
+	u32 nritems;
+	int i;
+	int level;
+
+	level = btrfs_header_level(node);
+	if (level != 1)
+		return;
+
+	nritems = btrfs_header_nritems(node);
+	for (i = slot; i < nritems; i++) {
+		bytenr = btrfs_node_blockptr(node, i);
+		ptr_gen = btrfs_node_ptr_generation(node, i);
+		readahead_tree_block(fs_info, bytenr, ptr_gen);
+	}
+}
diff --git a/check/common.h b/check/common.h
index 72146b444a79..34b2f8a9cd87 100644
--- a/check/common.h
+++ b/check/common.h
@@ -91,5 +91,7 @@ int link_inode_to_lostfound(struct btrfs_trans_handle *trans,
 			    u64 ino, char *namebuf, u32 name_len,
 			    u8 filetype, u64 *ref_count);
 void check_dev_size_alignment(u64 devid, u64 total_bytes, u32 sectorsize);
+void reada_walk_down(struct btrfs_root *root, struct extent_buffer *node,
+		     int slot);
 
 #endif
diff --git a/check/main.c b/check/main.c
index a8155630df18..aa7098a0be96 100644
--- a/check/main.c
+++ b/check/main.c
@@ -1667,28 +1667,6 @@ out:
 	return ret;
 }
 
-static void reada_walk_down(struct btrfs_root *root,
-			    struct extent_buffer *node, int slot)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	u64 bytenr;
-	u64 ptr_gen;
-	u32 nritems;
-	int i;
-	int level;
-
-	level = btrfs_header_level(node);
-	if (level != 1)
-		return;
-
-	nritems = btrfs_header_nritems(node);
-	for (i = slot; i < nritems; i++) {
-		bytenr = btrfs_node_blockptr(node, i);
-		ptr_gen = btrfs_node_ptr_generation(node, i);
-		readahead_tree_block(fs_info, bytenr, ptr_gen);
-	}
-}
-
 /*
  * Check the child node/leaf by the following condition:
  * 1. the first item key of the node/leaf should be the same with the one
-- 
2.15.1

