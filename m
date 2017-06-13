Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29819 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752543AbdFMJTr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:47 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 05/19] btrfs-progs: Refactor write_and_map_eb to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:21 +0800
Message-ID: <20170613091935.23277-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 2 +-
 disk-io.c      | 8 ++++----
 disk-io.h      | 2 +-
 mkfs/main.c    | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index bf050132..103cd5cd 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -370,7 +370,7 @@ static int migrate_one_reserved_range(struct btrfs_trans_handle *trans,
 		eb->len = key.offset;
 
 		/* Write the data */
-		ret = write_and_map_eb(root, eb);
+		ret = write_and_map_eb(root->fs_info, eb);
 		free(eb);
 		if (ret < 0)
 			break;
diff --git a/disk-io.c b/disk-io.c
index bf00e195..88e7c3f7 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -417,7 +417,7 @@ err:
 	return ret;
 }
 
-int write_and_map_eb(struct btrfs_root *root, struct extent_buffer *eb)
+int write_and_map_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 {
 	int ret;
 	int dev_nr;
@@ -427,11 +427,11 @@ int write_and_map_eb(struct btrfs_root *root, struct extent_buffer *eb)
 
 	dev_nr = 0;
 	length = eb->len;
-	ret = btrfs_map_block(root->fs_info, WRITE, eb->start, &length,
+	ret = btrfs_map_block(fs_info, WRITE, eb->start, &length,
 			      &multi, 0, &raid_map);
 
 	if (raid_map) {
-		ret = write_raid56_with_parity(root->fs_info, eb, multi,
+		ret = write_raid56_with_parity(fs_info, eb, multi,
 					       length, raid_map);
 		BUG_ON(ret);
 	} else while (dev_nr < multi->num_stripes) {
@@ -464,7 +464,7 @@ int write_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
 	csum_tree_block(root->fs_info, eb, 0);
 
-	return write_and_map_eb(root, eb);
+	return write_and_map_eb(root->fs_info, eb);
 }
 
 void btrfs_setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
diff --git a/disk-io.h b/disk-io.h
index 6dab689f..96133d32 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -191,6 +191,6 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
 int write_tree_block(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct extent_buffer *eb);
-int write_and_map_eb(struct btrfs_root *root, struct extent_buffer *eb);
+int write_and_map_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb);
 
 #endif
diff --git a/mkfs/main.c b/mkfs/main.c
index 24a51cb4..df2af474 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -753,7 +753,7 @@ again:
 		if (ret)
 			goto end;
 
-		ret = write_and_map_eb(root, eb);
+		ret = write_and_map_eb(root->fs_info, eb);
 		if (ret) {
 			error("failed to write %s", path_name);
 			goto end;
-- 
2.13.1



