Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:46286 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab2ETQGh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:37 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 04/24] Btrfs: move struct seq_list to ctree.h
Date: Sun, 20 May 2012 18:06:15 +0200
Message-Id: <2697aa7519e0de5d45ac1ebf7d3c2287d6439a64.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
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

