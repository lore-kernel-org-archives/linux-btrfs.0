Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31983 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751455AbdFFJzT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 05:55:19 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 1/9] btrfs: Introduce btrfs_is_name_len_valid to avoid reading beyond boundary
Date: Tue, 6 Jun 2017 17:57:00 +0800
Message-ID: <20170606095708.494-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
References: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce function btrfs_is_name_len_valid.

The function compares arg @name_len with item boundary then returns value
represents name_len is valid or not.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h    |  2 ++
 fs/btrfs/dir-item.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 643c70d2b2e6..776b16ec7a47 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3037,6 +3037,8 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_fs_info *fs_info,
 						 struct btrfs_path *path,
 						 const char *name,
 						 int name_len);
+bool btrfs_is_name_len_valid(struct extent_buffer *leaf, int slot,
+			     unsigned long start, u16 name_len);
 
 /* orphan.c */
 int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index c24d615e3d7f..b54c920c8412 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -484,3 +484,76 @@ int verify_dir_item(struct btrfs_fs_info *fs_info,
 
 	return 0;
 }
+
+bool btrfs_is_name_len_valid(struct extent_buffer *leaf, int slot,
+			     unsigned long start, u16 name_len)
+{
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
+	struct btrfs_key key;
+	u32 read_start;
+	u32 read_end;
+	u32 item_start;
+	u32 item_end;
+	u32 size;
+	bool ret = true;
+
+	ASSERT(start > btrfs_leaf_data(leaf));
+
+	read_start = start - btrfs_leaf_data(leaf);
+	read_end = read_start + name_len;
+	item_start = btrfs_item_offset_nr(leaf, slot);
+	item_end = btrfs_item_end_nr(leaf, slot);
+
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+
+	switch (key.type) {
+	case BTRFS_DIR_ITEM_KEY:
+	case BTRFS_XATTR_ITEM_KEY:
+	case BTRFS_DIR_INDEX_KEY:
+		size = sizeof(struct btrfs_dir_item);
+		break;
+	case BTRFS_INODE_REF_KEY:
+		size = sizeof(struct btrfs_inode_ref);
+		break;
+	case BTRFS_INODE_EXTREF_KEY:
+		size = sizeof(struct btrfs_inode_extref);
+		break;
+	case BTRFS_ROOT_REF_KEY:
+	case BTRFS_ROOT_BACKREF_KEY:
+		size = sizeof(struct btrfs_root_ref);
+		break;
+	default:
+		ret = false;
+		goto out;
+	}
+
+	if (read_start < item_start) {
+		ret = false;
+		goto out;
+	}
+	if (read_end > item_end) {
+		ret = false;
+		goto out;
+	}
+
+	/* there shall be item(s) before name */
+	if (read_start - item_start < size) {
+		ret = false;
+		goto out;
+	}
+
+	/*
+	 * This may be the last item in the slot
+	 * Or same type item(s) is left between read_end and item_end
+	 */
+	if (item_end != read_end &&
+	    item_end - read_end < size) {
+		ret = false;
+		goto out;
+	}
+out:
+	if (!ret)
+		btrfs_crit(fs_info, "invalid dir item name len: %u",
+			   (unsigned int)name_len);
+	return ret;
+}
-- 
2.13.0



