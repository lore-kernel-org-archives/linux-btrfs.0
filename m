Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60365 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932208AbeFFH10 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 03:27:26 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 95C5AADB4
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Jun 2018 07:27:25 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs-progs: check/lowmem: Repair wrong inlien ram_bytes for uncompressed extent
Date: Wed,  6 Jun 2018 15:27:16 +0800
Message-Id: <20180606072717.28854-6-wqu@suse.com>
In-Reply-To: <20180606072717.28854-1-wqu@suse.com>
References: <20180606072717.28854-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Similar to the original mode repair.

Reported-by: Steve Leung <sjleung@shaw.ca>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 73 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 3280591396bd..cb778ce6f789 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1735,6 +1735,70 @@ static int punch_extent_hole(struct btrfs_root *root, u64 ino, u64 start,
 	return ret;
 }
 
+static int repair_inline_ram_bytes(struct btrfs_root *root,
+				   struct btrfs_path *path, u64 *ram_bytes_ret)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key key;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_item *i;
+	u32 on_disk_data_len;
+	int ret;
+	int recover_ret;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		return ret;
+	}
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	btrfs_release_path(path);
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	/* Not really possible */
+	if (ret > 0) {
+		ret = -ENOENT;
+		btrfs_release_path(path);
+		goto recover;
+	}
+	if (ret < 0) {
+		goto recover;
+	}
+	i = btrfs_item_nr(path->slots[0]);
+	on_disk_data_len = btrfs_file_extent_inline_item_len(path->nodes[0], i);
+
+	fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_file_extent_item);
+	if (btrfs_file_extent_type(path->nodes[0], fi) !=
+			BTRFS_FILE_EXTENT_INLINE ||
+	    btrfs_file_extent_compression(path->nodes[0], fi) !=
+			BTRFS_COMPRESS_NONE)
+		return -EINVAL;
+	btrfs_set_file_extent_ram_bytes(path->nodes[0], fi, on_disk_data_len);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+
+	ret = btrfs_commit_transaction(trans, root);
+	if (!ret) {
+		printf(
+	"Successfully repaired inline ram_bytes for root %llu ino %llu\n",
+			root->objectid, key.objectid);
+		*ram_bytes_ret = on_disk_data_len;
+	}
+	return ret;
+
+recover:
+	/*
+	 * CoW search failed, mostly due to the extra CoW work
+	 * (extent allocation, etc).
+	 * Since we have a good path before, readonly search should still
+	 * work, or later checks will fail due to empty path
+	 */
+	recover_ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+
+	/* This really shouldn't happen, or we have a big trouble */
+	ASSERT(recover_ret == 0);
+	return ret;
+}
+
 /*
  * Check file extent datasum/hole, update the size of the file extents,
  * check and update the last offset of the file extent.
@@ -1817,7 +1881,14 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
 		"root %llu EXTENT_DATA[%llu %llu] wrong inline size, have: %llu, expected: %u",
 				root->objectid, fkey.objectid, fkey.offset,
 				extent_num_bytes, item_inline_len);
-			err |= FILE_EXTENT_ERROR;
+			if (repair) {
+				ret = repair_inline_ram_bytes(root, path,
+							      &extent_num_bytes);
+				if (ret)
+					err |= FILE_EXTENT_ERROR;
+			} else {
+				err |= FILE_EXTENT_ERROR;
+			}
 		}
 		*end += extent_num_bytes;
 		*size += extent_num_bytes;
-- 
2.17.1

