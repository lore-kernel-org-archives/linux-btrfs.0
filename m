Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55022 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756520AbbGGIPo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 04:15:44 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 4/7] btrfs-progs: extent-tree: Introduce functions to free chunk items
Date: Tue, 7 Jul 2015 16:15:25 +0800
Message-ID: <1436256928-23812-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce two functions, free_chunk_item and free_system_chunk_item.
First one will free chunk item in chunk tree.
The latter one will free a system chunk in super block.

They are used for later chunk/block group free function.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent-tree.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/extent-tree.c b/extent-tree.c
index afc7822..499838c 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3557,6 +3557,92 @@ out:
 	return ret;
 }
 
+static int free_system_chunk_item(struct btrfs_super_block *super,
+				  struct btrfs_key *key)
+{
+	struct btrfs_disk_key *disk_key;
+	struct btrfs_key cpu_key;
+	u32 array_size = btrfs_super_sys_array_size(super);
+	char *ptr = (char *)super->sys_chunk_array;
+	int cur = 0;
+	int ret = -ENOENT;
+
+	while (cur < btrfs_super_sys_array_size(super)) {
+		struct btrfs_chunk *chunk;
+		u32 num_stripes;
+		u32 chunk_len;
+
+		disk_key = (struct btrfs_disk_key *)(ptr + cur);
+		btrfs_disk_key_to_cpu(&cpu_key, disk_key);
+		if (cpu_key.type != BTRFS_CHUNK_ITEM_KEY) {
+			/* just in case */
+			ret = -EIO;
+			goto out;
+		}
+
+		chunk = (struct btrfs_chunk *)(ptr + cur + sizeof(*disk_key));
+		num_stripes = btrfs_stack_chunk_num_stripes(chunk);
+		chunk_len = btrfs_chunk_item_size(num_stripes) +
+			    sizeof(*disk_key);
+
+		if (key->objectid == cpu_key.objectid &&
+		    key->offset == cpu_key.offset &&
+		    key->type == cpu_key.type) {
+			memmove(ptr + cur, ptr + cur + chunk_len,
+				array_size - cur - chunk_len);
+			array_size -= chunk_len;
+			btrfs_set_super_sys_array_size(super, array_size);
+			ret = 0;
+			goto out;
+		}
+
+		cur += chunk_len;
+	}
+out:
+	return ret;
+}
+
+static int free_chunk_item(struct btrfs_trans_handle *trans,
+			   struct btrfs_fs_info *fs_info,
+			   u64 bytenr, u64 len)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_root *root = fs_info->chunk_root;
+	struct btrfs_chunk *chunk;
+	u64 chunk_type;
+	int ret;
+
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.offset = bytenr;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+	if (ret < 0)
+		goto out;
+	chunk = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			       struct btrfs_chunk);
+	chunk_type = btrfs_chunk_type(path->nodes[0], chunk);
+
+	ret = btrfs_del_item(trans, root, path);
+	if (ret < 0)
+		goto out;
+
+	if (chunk_type & BTRFS_BLOCK_GROUP_SYSTEM)
+		ret = free_system_chunk_item(fs_info->super_copy, &key);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 /*
  * Fixup block accounting. The initial block accounting created by
  * make_block_groups isn't accuracy in this case.
-- 
2.4.4

