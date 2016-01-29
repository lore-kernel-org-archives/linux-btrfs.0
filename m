Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34452 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbcA2NhA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 08:37:00 -0500
Received: by mail-pf0-f195.google.com with SMTP id 65so3810366pfd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jan 2016 05:37:00 -0800 (PST)
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Cc: kinglongmee@gmail.com
From: Kinglong Mee <kinglongmee@gmail.com>
Subject: [PATCH 3/3] btrfs: drop null testing before destroy functions
Message-ID: <56AB6AE3.4010706@gmail.com>
Date: Fri, 29 Jan 2016 21:36:35 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup.

kmem_cache_destroy has support NULL argument checking, 
so drop the double null testing before calling it.

Signed-off-by: Kinglong Mee <kinglongmee@gmail.com>
---
 fs/btrfs/backref.c       |  3 +--
 fs/btrfs/delayed-inode.c |  3 +--
 fs/btrfs/delayed-ref.c   | 12 ++++--------
 fs/btrfs/disk-io.c       |  3 +--
 fs/btrfs/extent_io.c     |  6 ++----
 fs/btrfs/extent_map.c    |  3 +--
 fs/btrfs/file.c          |  3 +--
 fs/btrfs/inode.c         | 15 +++++----------
 fs/btrfs/ordered-data.c  |  3 +--
 9 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index b90cd37..bf1336e 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -148,8 +148,7 @@ int __init btrfs_prelim_ref_init(void)
 
 void btrfs_prelim_ref_exit(void)
 {
-	if (btrfs_prelim_ref_cache)
-		kmem_cache_destroy(btrfs_prelim_ref_cache);
+	kmem_cache_destroy(btrfs_prelim_ref_cache);
 }
 
 /*
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 0be47e4..716a4ec 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -43,8 +43,7 @@ int __init btrfs_delayed_inode_init(void)
 
 void btrfs_delayed_inode_exit(void)
 {
-	if (delayed_node_cache)
-		kmem_cache_destroy(delayed_node_cache);
+	kmem_cache_destroy(delayed_node_cache);
 }
 
 static inline void btrfs_init_delayed_node(
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 914ac13..430b368 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -929,14 +929,10 @@ btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr)
 
 void btrfs_delayed_ref_exit(void)
 {
-	if (btrfs_delayed_ref_head_cachep)
-		kmem_cache_destroy(btrfs_delayed_ref_head_cachep);
-	if (btrfs_delayed_tree_ref_cachep)
-		kmem_cache_destroy(btrfs_delayed_tree_ref_cachep);
-	if (btrfs_delayed_data_ref_cachep)
-		kmem_cache_destroy(btrfs_delayed_data_ref_cachep);
-	if (btrfs_delayed_extent_op_cachep)
-		kmem_cache_destroy(btrfs_delayed_extent_op_cachep);
+	kmem_cache_destroy(btrfs_delayed_ref_head_cachep);
+	kmem_cache_destroy(btrfs_delayed_tree_ref_cachep);
+	kmem_cache_destroy(btrfs_delayed_data_ref_cachep);
+	kmem_cache_destroy(btrfs_delayed_extent_op_cachep);
 }
 
 int btrfs_delayed_ref_init(void)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dd08e29..669958d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -110,8 +110,7 @@ int __init btrfs_end_io_wq_init(void)
 
 void btrfs_end_io_wq_exit(void)
 {
-	if (btrfs_end_io_wq_cache)
-		kmem_cache_destroy(btrfs_end_io_wq_cache);
+	kmem_cache_destroy(btrfs_end_io_wq_cache);
 }
 
 /*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2e7c97a..889d180 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -206,10 +206,8 @@ void extent_io_exit(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
-	if (extent_state_cache)
-		kmem_cache_destroy(extent_state_cache);
-	if (extent_buffer_cache)
-		kmem_cache_destroy(extent_buffer_cache);
+	kmem_cache_destroy(extent_state_cache);
+	kmem_cache_destroy(extent_buffer_cache);
 	if (btrfs_bioset)
 		bioset_free(btrfs_bioset);
 }
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 84fb56d..cdbadea 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -20,8 +20,7 @@ int __init extent_map_init(void)
 
 void extent_map_exit(void)
 {
-	if (extent_map_cache)
-		kmem_cache_destroy(extent_map_cache);
+	kmem_cache_destroy(extent_map_cache);
 }
 
 /**
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 098bb8f..7f5bf64 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2939,8 +2939,7 @@ const struct file_operations btrfs_file_operations = {
 
 void btrfs_auto_defrag_exit(void)
 {
-	if (btrfs_inode_defrag_cachep)
-		kmem_cache_destroy(btrfs_inode_defrag_cachep);
+	kmem_cache_destroy(btrfs_inode_defrag_cachep);
 }
 
 int btrfs_auto_defrag_init(void)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e28f3d4..9669c3b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9156,16 +9156,11 @@ void btrfs_destroy_cachep(void)
 	 * destroy cache.
 	 */
 	rcu_barrier();
-	if (btrfs_inode_cachep)
-		kmem_cache_destroy(btrfs_inode_cachep);
-	if (btrfs_trans_handle_cachep)
-		kmem_cache_destroy(btrfs_trans_handle_cachep);
-	if (btrfs_transaction_cachep)
-		kmem_cache_destroy(btrfs_transaction_cachep);
-	if (btrfs_path_cachep)
-		kmem_cache_destroy(btrfs_path_cachep);
-	if (btrfs_free_space_cachep)
-		kmem_cache_destroy(btrfs_free_space_cachep);
+	kmem_cache_destroy(btrfs_inode_cachep);
+	kmem_cache_destroy(btrfs_trans_handle_cachep);
+	kmem_cache_destroy(btrfs_transaction_cachep);
+	kmem_cache_destroy(btrfs_path_cachep);
+	kmem_cache_destroy(btrfs_free_space_cachep);
 }
 
 int btrfs_init_cachep(void)
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 8c27292..988eb15 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -1114,6 +1114,5 @@ int __init ordered_data_init(void)
 
 void ordered_data_exit(void)
 {
-	if (btrfs_ordered_extent_cache)
-		kmem_cache_destroy(btrfs_ordered_extent_cache);
+	kmem_cache_destroy(btrfs_ordered_extent_cache);
 }
-- 
2.5.0

