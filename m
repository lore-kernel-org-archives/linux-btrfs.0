Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:46287 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316Ab2ETQGh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:37 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 06/24] Btrfs: add tree mod log to fs_info
Date: Sun, 20 May 2012 18:06:17 +0200
Message-Id: <5481ec858047957eb8dda2470db726353b75ebf8.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.h   |    9 +++++++++
 fs/btrfs/disk-io.c |    5 +++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e0da6db..6774821 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1129,6 +1129,15 @@ struct btrfs_fs_info {
 	spinlock_t delayed_iput_lock;
 	struct list_head delayed_iputs;
 
+	/* this protects tree_mod_seq_list */
+	spinlock_t tree_mod_seq_lock;
+	atomic_t tree_mod_seq;
+	struct list_head tree_mod_list;
+
+	/* this protects tree_mod_log */
+	rwlock_t tree_mod_log_lock;
+	struct rb_root tree_mod_log;
+
 	atomic_t nr_async_submits;
 	atomic_t async_submit_draining;
 	atomic_t nr_async_bios;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f433074..6aec7c6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1914,11 +1914,14 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->delayed_iput_lock);
 	spin_lock_init(&fs_info->defrag_inodes_lock);
 	spin_lock_init(&fs_info->free_chunk_lock);
+	spin_lock_init(&fs_info->tree_mod_seq_lock);
+	rwlock_init(&fs_info->tree_mod_log_lock);
 	mutex_init(&fs_info->reloc_mutex);
 
 	init_completion(&fs_info->kobj_unregister);
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
 	INIT_LIST_HEAD(&fs_info->space_info);
+	INIT_LIST_HEAD(&fs_info->tree_mod_list);
 	btrfs_mapping_init(&fs_info->mapping_tree);
 	btrfs_init_block_rsv(&fs_info->global_block_rsv);
 	btrfs_init_block_rsv(&fs_info->delalloc_block_rsv);
@@ -1931,12 +1934,14 @@ int open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->async_submit_draining, 0);
 	atomic_set(&fs_info->nr_async_bios, 0);
 	atomic_set(&fs_info->defrag_running, 0);
+	atomic_set(&fs_info->tree_mod_seq, 0);
 	fs_info->sb = sb;
 	fs_info->max_inline = 8192 * 1024;
 	fs_info->metadata_ratio = 0;
 	fs_info->defrag_inodes = RB_ROOT;
 	fs_info->trans_no_join = 0;
 	fs_info->free_chunk_space = 0;
+	fs_info->tree_mod_log = RB_ROOT;
 
 	/* readahead state */
 	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_WAIT);
-- 
1.7.3.4

