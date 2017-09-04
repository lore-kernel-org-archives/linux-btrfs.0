Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55951 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753246AbdIDGlY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 02:41:24 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/5] btrfs-progs: mkfs: Update allocation info before verbose output
Date: Mon,  4 Sep 2017 15:41:09 +0900
Message-Id: <20170904064110.25951-5-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
References: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since new --rootdir can allocate chunk, it will modify the chunk
allocation result.

This patch will update allocation info before verbose output to reflect
such info.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 mkfs/main.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index c43ce18d..873aec83 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1380,6 +1380,38 @@ out:
 	return ret;
 }
 
+/*
+ * Just update chunk allocation info, since --rootdir may allocate new
+ * chunks which is not updated in @allocation structure.
+ */
+static void update_chunk_allocation(struct btrfs_fs_info *fs_info,
+				    struct mkfs_allocation *allocation)
+{
+	struct btrfs_block_group_cache *bg_cache;
+	u64 mixed_flag = BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA;
+	u64 search_start = 0;
+
+	allocation->mixed = 0;
+	allocation->data = 0;
+	allocation->metadata = 0;
+	allocation->system = 0;
+	while (1) {
+		bg_cache = btrfs_lookup_first_block_group(fs_info,
+							  search_start);
+		if (!bg_cache)
+			break;
+		if ((bg_cache->flags & mixed_flag) == mixed_flag)
+			allocation->mixed += bg_cache->key.offset;
+		else if (bg_cache->flags & BTRFS_BLOCK_GROUP_DATA)
+			allocation->data += bg_cache->key.offset;
+		else if (bg_cache->flags & BTRFS_BLOCK_GROUP_METADATA)
+			allocation->metadata += bg_cache->key.offset;
+		else
+			allocation->system += bg_cache->key.offset;
+		search_start = bg_cache->key.objectid + bg_cache->key.offset;
+	}
+}
+
 int main(int argc, char **argv)
 {
 	char *file;
@@ -1842,6 +1874,7 @@ raid_groups:
 	if (verbose) {
 		char features_buf[64];
 
+		update_chunk_allocation(fs_info, &allocation);
 		printf("Label:              %s\n", label);
 		printf("UUID:               %s\n", mkfs_cfg.fs_uuid);
 		printf("Node size:          %u\n", nodesize);
-- 
2.14.1

