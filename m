Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29819 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752667AbdFMJT7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:59 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 15/19] btrfs-progs: Refactor btrfs_add_system_chunk to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:31 +0800
Message-ID: <20170613091935.23277-16-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 chunk-recover.c | 5 +++--
 volumes.c       | 7 +++----
 volumes.h       | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 90791fbd..f1fa7504 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1287,13 +1287,14 @@ static int rebuild_chunk_tree(struct btrfs_trans_handle *trans,
 static int rebuild_sys_array(struct recover_control *rc,
 			     struct btrfs_root *root)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_chunk *chunk;
 	struct btrfs_key key;
 	struct chunk_record *chunk_rec;
 	int ret = 0;
 	u16 num_stripes;
 
-	btrfs_set_super_sys_array_size(root->fs_info->super_copy, 0);
+	btrfs_set_super_sys_array_size(fs_info->super_copy, 0);
 
 	list_for_each_entry(chunk_rec, &rc->good_chunks, list) {
 		if (!(chunk_rec->type_flags & BTRFS_BLOCK_GROUP_SYSTEM))
@@ -1310,7 +1311,7 @@ static int rebuild_sys_array(struct recover_control *rc,
 		key.type = BTRFS_CHUNK_ITEM_KEY;
 		key.offset = chunk_rec->offset;
 
-		ret = btrfs_add_system_chunk(root, &key, chunk,
+		ret = btrfs_add_system_chunk(fs_info, &key, chunk,
 				btrfs_chunk_item_size(num_stripes));
 		free(chunk);
 		if (ret)
diff --git a/volumes.c b/volumes.c
index db8b931f..5b3b142d 100644
--- a/volumes.c
+++ b/volumes.c
@@ -690,11 +690,10 @@ out:
 	return ret;
 }
 
-int btrfs_add_system_chunk(struct btrfs_root *root,
-			   struct btrfs_key *key,
+int btrfs_add_system_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 			   struct btrfs_chunk *chunk, int item_size)
 {
-	struct btrfs_super_block *super_copy = root->fs_info->super_copy;
+	struct btrfs_super_block *super_copy = fs_info->super_copy;
 	struct btrfs_disk_key disk_key;
 	u32 array_size;
 	u8 *ptr;
@@ -1083,7 +1082,7 @@ again:
 	BUG_ON(ret);
 
 	if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
-		ret = btrfs_add_system_chunk(chunk_root, &key,
+		ret = btrfs_add_system_chunk(info, &key,
 				    chunk, btrfs_chunk_item_size(num_stripes));
 		BUG_ON(ret);
 	}
diff --git a/volumes.h b/volumes.h
index 859fb020..783b3566 100644
--- a/volumes.h
+++ b/volumes.h
@@ -230,7 +230,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 			  u64 *total_devs, u64 super_offset, unsigned sbflags);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 struct list_head *btrfs_scanned_uuids(void);
-int btrfs_add_system_chunk(struct btrfs_root *root, struct btrfs_key *key,
+int btrfs_add_system_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 			   struct btrfs_chunk *chunk, int item_size);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 struct btrfs_device *
-- 
2.13.1



