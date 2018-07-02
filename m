Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45436 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752607AbeGBI3K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 04:29:10 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C24B4AD70
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 08:29:09 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Do extra chunk block group mapping check at mount
Date: Mon,  2 Jul 2018 16:29:07 +0800
Message-Id: <20180702082907.12258-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reported in https://bugzilla.kernel.org/show_bug.cgi?id=199837, if a
crafted btrfs with incorrect chunk<->block group mapping, it could leads
to a lot of unexpected behavior.

Although the crafted image can be catched by block group item checker
added in "[PATCH] btrfs: tree-checker: Verify block_group_item", if one
crafted a valid enough block group item which can pass above check but
still mismatch with existing chunk, it could cause a lot of undefined
behavior.

This patch will add extra chunk<->block group mapping check at mount
time, so such problem can be detected early and cause no harm.

Reported-by: Xu Wen <wen.xu@gatech.edu>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d9fe58c0080..7a11dc76cd6d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10003,6 +10003,31 @@ btrfs_create_block_group_cache(struct btrfs_fs_info *fs_info,
 	return cache;
 }
 
+static int verify_chunk_block_group_mapping(struct btrfs_fs_info *fs_info,
+					    u64 start, u64 len)
+{
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
+	struct extent_map *em;
+	int ret;
+
+	read_lock(&map_tree->map_tree.lock);
+	em = lookup_extent_mapping(&map_tree->map_tree, start, len);
+	read_unlock(&map_tree->map_tree.lock);
+
+	if (!em) {
+		ret = -ENOENT;
+		goto out;
+	}
+	if (em->start != start || em->len != len) {
+		ret = -ENOENT;
+		goto out;
+	}
+	ret = 0;
+out:
+	free_extent_map(em);
+	return ret;
+}
+
 int btrfs_read_block_groups(struct btrfs_fs_info *info)
 {
 	struct btrfs_path *path;
@@ -10045,6 +10070,19 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 
+		/*
+		 * Since block group and chunks are 1:1 mapped and are core
+		 * infrastructure of btrfs, we need to do extra verification.
+		 */
+		ret = verify_chunk_block_group_mapping(info,
+					found_key.objectid, found_key.offset);
+		if (ret < 0) {
+			btrfs_err_rl(info,
+		"block group start=%llu len=%llu doesn't have matched chunk",
+				     found_key.objectid, found_key.offset);
+			goto error;
+		}
+
 		cache = btrfs_create_block_group_cache(info, found_key.objectid,
 						       found_key.offset);
 		if (!cache) {
-- 
2.18.0

