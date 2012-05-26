Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:44219 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab2EZK7u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:59:50 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 06/15] Btrfs: move struct seq_list to ctree.h
Date: Sat, 26 May 2012 12:59:40 +0200
Message-Id: <64947ec0d16dd20d6542b58cf82c8d5f9678cabf.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
References: <cover.1338027552.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.h       |    7 +++++++
 fs/btrfs/delayed-ref.h |    5 -----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e863188..e0da6db 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3098,4 +3098,11 @@ void btrfs_reada_detach(void *handle);
 int btree_readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
 			 u64 start, int err);
 
+/* delayed seq elem */
+struct seq_list {
+	struct list_head list;
+	u64 seq;
+	u32 flags;
+};
+
 #endif
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index d8f244d..fd82446 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -195,11 +195,6 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
 			   struct list_head *cluster, u64 search_start);
 
-struct seq_list {
-	struct list_head list;
-	u64 seq;
-};
-
 static inline u64 inc_delayed_seq(struct btrfs_delayed_ref_root *delayed_refs)
 {
 	assert_spin_locked(&delayed_refs->lock);
-- 
1.7.3.4

