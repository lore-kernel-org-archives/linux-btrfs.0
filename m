Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4492 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbcEQJjM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 05:39:12 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fb.com
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [RFC PATCH v2.1 09/16] btrfs-progs: fsck: Introduce function to check dev extent item
Date: Tue, 17 May 2016 17:38:43 +0800
Message-Id: <1463477930-3925-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce function check_dev_extent_item() to find its referencer chunk.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 927ee04..79a22c9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9193,6 +9193,64 @@ out:
 	return err;
 }
 
+/*
+ * Check if a dev extent item is referred correctly by its chunk
+ */
+static int check_dev_extent_item(struct btrfs_fs_info *fs_info,
+				 struct extent_buffer *eb, int slot)
+{
+	struct btrfs_root *chunk_root = fs_info->chunk_root;
+	struct btrfs_dev_extent *ptr;
+	struct btrfs_path path;
+	struct btrfs_key chunk_key;
+	struct btrfs_key devext_key;
+	struct btrfs_chunk *chunk;
+	struct extent_buffer *l;
+	int num_stripes;
+	u64 length;
+	int i;
+	int found_chunk = 0;
+	int ret;
+
+	btrfs_item_key_to_cpu(eb, &devext_key, slot);
+	ptr = btrfs_item_ptr(eb, slot, struct btrfs_dev_extent);
+	length = btrfs_dev_extent_length(eb, ptr);
+
+	chunk_key.objectid = btrfs_dev_extent_chunk_objectid(eb, ptr);
+	chunk_key.type = BTRFS_CHUNK_ITEM_KEY;
+	chunk_key.offset = btrfs_dev_extent_chunk_offset(eb, ptr);
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, chunk_root, &chunk_key, &path, 0, 0);
+	if (ret)
+		goto out;
+
+	l = path.nodes[0];
+	chunk = btrfs_item_ptr(l, path.slots[0], struct btrfs_chunk);
+	if (btrfs_chunk_length(l, chunk) != length)
+		goto out;
+
+	num_stripes = btrfs_chunk_num_stripes(l, chunk);
+	for (i = 0; i < num_stripes; i++) {
+		u64 devid = btrfs_stripe_devid_nr(l, chunk, i);
+		u64 offset = btrfs_stripe_offset_nr(l, chunk, i);
+
+		if (devid == devext_key.objectid &&
+		    offset == devext_key.offset) {
+			found_chunk = 1;
+			break;
+		}
+	}
+out:
+	btrfs_release_path(&path);
+	if (!found_chunk) {
+		error("Device extent[%llu, %llu, %llu] didn't find the relative chunk",
+		       devext_key.objectid, devext_key.offset, length);
+		return REFERENCER_MISSING;
+	}
+	return 0;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
-- 
2.8.2



