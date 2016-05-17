Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18565 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbcEQJjN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 05:39:13 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fb.com
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [RFC PATCH v2.1 05/16] btrfs-progs: fsck: Introduce function to check shared block ref
Date: Tue, 17 May 2016 17:38:39 +0800
Message-Id: <1463477930-3925-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce function check_shared_block_backref() to check shared block
ref.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 443b337..6ca84f5 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8886,6 +8886,48 @@ out:
 	return err;
 }
 
+/*
+ * Check referencer for shared block backref
+ * If level == -1, this function will resolve the level.
+ */
+static int check_shared_block_backref(struct btrfs_fs_info *fs_info,
+				     u64 parent, u64 bytenr, int level)
+{
+	struct extent_buffer *eb;
+	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
+	u32 nr;
+	int found_parent = 0;
+	int i;
+
+	eb = read_tree_block_fs_info(fs_info, parent, nodesize, 0);
+	if (!extent_buffer_uptodate(eb))
+		goto out;
+
+	if (level == -1)
+		level = query_tree_block_level(fs_info, bytenr);
+	if (level < 0)
+		goto out;
+
+	if (level + 1 != btrfs_header_level(eb))
+		goto out;
+
+	nr = btrfs_header_nritems(eb);
+	for (i = 0; i < nr; i++) {
+		if (bytenr == btrfs_node_blockptr(eb, i)) {
+			found_parent = 1;
+			break;
+		}
+	}
+out:
+	free_extent_buffer(eb);
+	if (!found_parent) {
+		error("Shared extent[%llu %u] lost its parent(parent: %llu, level: %u)",
+		      bytenr, nodesize, parent, level);
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



