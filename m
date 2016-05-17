Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4492 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbcEQJjN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 05:39:13 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fb.com
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [RFC PATCH v2.1 07/16] btrfs-progs: fsck: Introduce function to check shared data backref
Date: Tue, 17 May 2016 17:38:41 +0800
Message-Id: <1463477930-3925-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce the function check_shared_data_backref() to check the
referencer of a given shared data backref.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 6b59397..18325f9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9028,6 +9028,50 @@ out:
 	return 0;
 }
 
+/*
+ * Check if the referencer of a shared data backref exists
+ */
+static int check_shared_data_backref(struct btrfs_fs_info *fs_info,
+				     u64 parent, u64 bytenr)
+{
+	struct extent_buffer *eb;
+	struct btrfs_key key;
+	struct btrfs_file_extent_item *fi;
+	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
+	u32 nr;
+	int found_parent = 0;
+	int i;
+
+	eb = read_tree_block_fs_info(fs_info, parent, nodesize, 0);
+	if (!extent_buffer_uptodate(eb))
+		goto out;
+
+	nr = btrfs_header_nritems(eb);
+	for (i = 0; i < nr; i++) {
+		btrfs_item_key_to_cpu(eb, &key, i);
+		if (key.type != BTRFS_EXTENT_DATA_KEY)
+			continue;
+
+		fi = btrfs_item_ptr(eb, i, struct btrfs_file_extent_item);
+		if (btrfs_file_extent_type(eb, fi) == BTRFS_FILE_EXTENT_INLINE)
+			continue;
+
+		if (btrfs_file_extent_disk_bytenr(eb, fi) == bytenr) {
+			found_parent = 1;
+			break;
+		}
+	}
+
+out:
+	free_extent_buffer(eb);
+	if (!found_parent) {
+		error("Shared extent %llu referencer lost(parent: %llu)",
+		      bytenr, parent);
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



