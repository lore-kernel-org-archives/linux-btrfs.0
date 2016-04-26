Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22441 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbcDZDtj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 23:49:39 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH RFC 09/16] btrfs-progs: fsck: Introduce function to check dev extent item
Date: Tue, 26 Apr 2016 11:48:56 +0800
Message-Id: <1461642543-4621-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce function check_dev_extent_item() to find its referencer chunk.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 7f9f848..92c254f 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9126,6 +9126,63 @@ out:
 	return -err;
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
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_chunk *chunk;
+	struct extent_buffer *l;
+	int num_stripes;
+	u64 length;
+	int i;
+	int found_chunk = 0;
+	int ret;
+
+	btrfs_item_key_to_cpu(eb, &found_key, slot);
+	ptr = btrfs_item_ptr(eb, slot, struct btrfs_dev_extent);
+	length = btrfs_dev_extent_length(eb, ptr);
+
+	key.objectid = btrfs_dev_extent_chunk_objectid(eb, ptr);
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+	key.offset = btrfs_dev_extent_chunk_offset(eb, ptr);
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, chunk_root, &key, &path, 0, 0);
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
+		if (devid == found_key.objectid && offset == found_key.offset) {
+			found_chunk= 1;
+			break;
+		}
+	}
+out:
+	btrfs_release_path(&path);
+	if (!found_chunk) {
+		error("Device extent[%llu, %llu, %llu] didn't find the relative chunk",
+		       found_key.objectid, found_key.offset, length);
+		return -MISSING_REFERENCER;
+	}
+	return 0;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
-- 
2.8.0



