Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39542 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbcDZDtq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 23:49:46 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH RFC 03/16] btrfs-progs: fsck: Introduce function to query tree block level
Date: Tue, 26 Apr 2016 11:48:50 +0800
Message-Id: <1461642543-4621-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce function query_tree_block_level() to resolve tree block level
by reading out the tree block.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index d097edd..6633b6e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8716,6 +8716,26 @@ error:
 	return err;
 }
 
+/*
+ * Get real tree block level for case like shared block
+ * Return >= 0 as tree level
+ * Return <0 for error
+ */
+static int query_tree_block_level(struct btrfs_fs_info *fs_info, u64 bytenr)
+{
+	struct extent_buffer *eb;
+	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
+	int ret = -EIO;
+
+	eb = read_tree_block_fs_info(fs_info, bytenr, nodesize, 0);
+	if (!extent_buffer_uptodate(eb))
+		goto out;
+	ret = btrfs_header_level(eb);
+out:
+	free_extent_buffer(eb);
+	return ret;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
-- 
2.8.0



