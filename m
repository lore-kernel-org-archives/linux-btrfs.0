Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:50737 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751796AbdJTB7c (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 19 Oct 2017 21:59:32 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 6/7] btrfs-progs: mkfs: Update allocation info before verbose output
Date: Fri, 20 Oct 2017 09:59:06 +0800
Message-Id: <20171020015907.25430-7-wqu@suse.com>
In-Reply-To: <20171020015907.25430-1-wqu@suse.com>
References: <20171020015907.25430-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since new --rootdir can allocate chunk, it will modify the chunk
allocation result.

This patch will update allocation info before verbose output to reflect
such info.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/main.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index 0866e40d155f..6aefb50a8033 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -670,6 +670,38 @@ out:
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
@@ -1164,6 +1196,7 @@ raid_groups:
 	if (verbose) {
 		char features_buf[64];
 
+		update_chunk_allocation(fs_info, &allocation);
 		printf("Label:              %s\n", label);
 		printf("UUID:               %s\n", mkfs_cfg.fs_uuid);
 		printf("Node size:          %u\n", nodesize);
-- 
2.14.2

