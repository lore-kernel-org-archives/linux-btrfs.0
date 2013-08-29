Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39007 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3H2KbH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 06:31:07 -0400
Received: by mail-wg0-f45.google.com with SMTP id j13so229405wgh.0
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 03:31:06 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 29 Aug 2013 13:31:05 +0300
Message-ID: <CAOcd+r3zDtf3uNs5YOk=9LhGannN2WK-CpF0PQMdrnu58phBiw@mail.gmail.com>
Subject: [PATCH] Notify caching_thread()s to give up on extent_commit_sem when needed.
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

caching_thread()s do all their work under read access to extent_commit_sem.
They give up on this read access only when need_resched() tells them, or
when they exit. As a result, somebody that wants a WRITE access to this sem,
might wait for a long time. Especially this is problematic in
cache_block_group(),
which can be called on critical paths like find_free_extent() and in commit
path via commit_cowonly_roots().

This patch is an RFC, that attempts to fix this problem, by notifying the
caching threads to give up on extent_commit_sem.

On a system with a lot of metadata (~20Gb total metadata, ~10Gb extent tree),
with increased number of caching_threads, commits were very slow,
stuck in commit_cowonly_roots, due to this issue.
With this patch, commits no longer get stuck in commit_cowonly_roots.

This patch is not indented to be applied, just a request to comment on whether
you agree this problem happens, and whether the fix goes in the right direction.

Signed-off-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
---
 fs/btrfs/ctree.h       |    7 +++++++
 fs/btrfs/disk-io.c     |    1 +
 fs/btrfs/extent-tree.c |    9 +++++----
 fs/btrfs/transaction.c |    2 +-
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c90be01..b602611 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1427,6 +1427,13 @@ struct btrfs_fs_info {
     struct mutex ordered_extent_flush_mutex;

     struct rw_semaphore extent_commit_sem;
+    /* notifies the readers to give up on the sem ASAP */
+    atomic_t extent_commit_sem_give_up_read;
+#define BTRFS_DOWN_WRITE_EXTENT_COMMIT_SEM(fs_info)                  \
+    do { atomic_inc(&(fs_info)->extent_commit_sem_give_up_read);     \
+         down_write(&(fs_info)->extent_commit_sem);                  \
+         atomic_dec(&(fs_info)->extent_commit_sem_give_up_read);     \
+    } while (0)

     struct rw_semaphore cleanup_work_sem;

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 69e9afb..b88e688 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2291,6 +2291,7 @@ int open_ctree(struct super_block *sb,
     mutex_init(&fs_info->cleaner_mutex);
     mutex_init(&fs_info->volume_mutex);
     init_rwsem(&fs_info->extent_commit_sem);
+    atomic_set(&fs_info->extent_commit_sem_give_up_read, 0);
     init_rwsem(&fs_info->cleanup_work_sem);
     init_rwsem(&fs_info->subvol_sem);
     sema_init(&fs_info->uuid_tree_rescan_sem, 1);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 95c6539..28fee78 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -442,7 +442,8 @@ next:
             if (ret)
                 break;

-            if (need_resched()) {
+            if (need_resched() ||
+                atomic_read(&fs_info->extent_commit_sem_give_up_read) > 0) {
                 caching_ctl->progress = last;
                 btrfs_release_path(path);
                 up_read(&fs_info->extent_commit_sem);
@@ -632,7 +633,7 @@ static int cache_block_group(struct
btrfs_block_group_cache *cache,
         return 0;
     }

-    down_write(&fs_info->extent_commit_sem);
+    BTRFS_DOWN_WRITE_EXTENT_COMMIT_SEM(fs_info);
     atomic_inc(&caching_ctl->count);
     list_add_tail(&caching_ctl->list, &fs_info->caching_block_groups);
     up_write(&fs_info->extent_commit_sem);
@@ -5462,7 +5463,7 @@ void btrfs_prepare_extent_commit(struct
btrfs_trans_handle *trans,
     struct btrfs_block_group_cache *cache;
     struct btrfs_space_info *space_info;

-    down_write(&fs_info->extent_commit_sem);
+    BTRFS_DOWN_WRITE_EXTENT_COMMIT_SEM(fs_info);

     list_for_each_entry_safe(caching_ctl, next,
                  &fs_info->caching_block_groups, list) {
@@ -8219,7 +8220,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
     struct btrfs_caching_control *caching_ctl;
     struct rb_node *n;

-    down_write(&info->extent_commit_sem);
+    BTRFS_DOWN_WRITE_EXTENT_COMMIT_SEM(fs_info);
     while (!list_empty(&info->caching_block_groups)) {
         caching_ctl = list_entry(info->caching_block_groups.next,
                      struct btrfs_caching_control, list);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index cac4a3f..976d20a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -969,7 +969,7 @@ static noinline int commit_cowonly_roots(struct
btrfs_trans_handle *trans,
             return ret;
     }

-    down_write(&fs_info->extent_commit_sem);
+    BTRFS_DOWN_WRITE_EXTENT_COMMIT_SEM(fs_info);
     switch_commit_root(fs_info->extent_root);
     up_write(&fs_info->extent_commit_sem);

-- 
1.7.9.5
