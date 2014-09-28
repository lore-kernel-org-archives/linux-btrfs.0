Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44232 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbaI1IrU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Sep 2014 04:47:20 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so6161279pab.32
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Sep 2014 01:47:20 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] btrfs: fix sparse lock context warnings
Date: Sun, 28 Sep 2014 01:48:12 -0700
Message-Id: <1411894092-28784-3-git-send-email-osandov@osandov.com>
In-Reply-To: <1411894092-28784-1-git-send-email-osandov@osandov.com>
References: <1411894092-28784-1-git-send-email-osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix several sparse warnings that can easily be addressed with context
annotations. These annotations also provide some sort of documentation for the
internal helper functions.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/ctree.c            | 3 ++-
 fs/btrfs/extent-tree.c      | 1 +
 fs/btrfs/extent_io.c        | 2 +-
 fs/btrfs/free-space-cache.c | 1 +
 fs/btrfs/locking.c          | 1 +
 5 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 44ee5d2..c1bbc88 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -487,7 +487,8 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
  * call tree_mod_log_write_unlock() to release.
  */
 static inline int tree_mod_dont_log(struct btrfs_fs_info *fs_info,
-				    struct extent_buffer *eb) {
+				    struct extent_buffer *eb)
+{
 	smp_mb();
 	if (list_empty(&(fs_info)->tree_mod_seq_list))
 		return 1;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3efe1c3..281f30f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6387,6 +6387,7 @@ static struct btrfs_block_group_cache *
 btrfs_lock_cluster(struct btrfs_block_group_cache *block_group,
 		   struct btrfs_free_cluster *cluster,
 		   int delalloc)
+__acquires(&cluster->refill_lock)
 {
 	struct btrfs_block_group_cache *used_bg;
 	bool locked = false;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index af0359d..cc6b1fc 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4775,8 +4775,8 @@ static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
 	__free_extent_buffer(eb);
 }
 
-/* Expects to have eb->eb_lock already held */
 static int release_extent_buffer(struct extent_buffer *eb)
+__releases(&eb->refs_lock)
 {
 	WARN_ON(atomic_read(&eb->refs) == 0);
 	if (atomic_dec_and_test(&eb->refs)) {
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2b0a627..41c6cd5 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1838,6 +1838,7 @@ static struct btrfs_free_space_op free_space_op = {
 
 static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_free_space *info)
+__must_hold(&ctl->tree_lock)
 {
 	struct btrfs_free_space *bitmap_info;
 	struct btrfs_block_group_cache *block_group = NULL;
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 5665d21..47bdc2c 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -222,6 +222,7 @@ void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
  * blocking readers or writers
  */
 void btrfs_tree_lock(struct extent_buffer *eb)
+__acquires(&eb->lock)
 {
 again:
 	wait_event(eb->read_lock_wq, atomic_read(&eb->blocking_readers) == 0);
-- 
2.1.1

