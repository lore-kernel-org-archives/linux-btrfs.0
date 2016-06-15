Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456AbcFOWuK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 18:50:10 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 1/2] btrfs-progs: free qgroup counts in btrfsck
Date: Wed, 15 Jun 2016 15:50:01 -0700
Message-Id: <1466031002-14533-2-git-send-email-mfasheh@suse.de>
In-Reply-To: <1466031002-14533-1-git-send-email-mfasheh@suse.de>
References: <1466031002-14533-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 cmds-check.c    |  1 +
 qgroup-verify.c | 13 +++++++++++++
 qgroup-verify.h |  2 ++
 3 files changed, 16 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index bada87e..7b65f89 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9890,6 +9890,7 @@ out:
 		(unsigned long long)data_bytes_allocated,
 		(unsigned long long)data_bytes_referenced);
 
+	free_qgroup_counts();
 	free_root_recs_tree(&root_cache);
 close_out:
 	close_ctree(root);
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 1a0d38c..7b78504 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -1095,6 +1095,19 @@ int report_qgroups(int all)
 	return ret;
 }
 
+void free_qgroup_counts(void)
+{
+	struct rb_node *node;
+	struct qgroup_count *c;
+	node = rb_first(&counts.root);
+	while (node) {
+		c = rb_entry(node, struct qgroup_count, rb_node);
+		node = rb_next(node);
+		rb_erase(&c->rb_node, &counts.root);
+		free(c);
+	}
+}
+
 int qgroup_verify_all(struct btrfs_fs_info *info)
 {
 	int ret;
diff --git a/qgroup-verify.h b/qgroup-verify.h
index 3747465..0f8ff9b 100644
--- a/qgroup-verify.h
+++ b/qgroup-verify.h
@@ -27,4 +27,6 @@ int report_qgroups(int all);
 
 int print_extent_state(struct btrfs_fs_info *info, u64 subvol);
 
+void free_qgroup_counts(void);
+
 #endif
-- 
2.1.4

