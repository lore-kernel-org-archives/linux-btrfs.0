Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54135 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752973AbeBSQ0g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Feb 2018 11:26:36 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0DB96AC12
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Feb 2018 16:26:35 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: add more __cold annotations
Date: Mon, 19 Feb 2018 17:24:18 +0100
Message-Id: <ae138eda7238652deb934d9f24b3f0ba857fbab4.1519057258.git.dsterba@suse.com>
In-Reply-To: <cover.1519057258.git.dsterba@suse.com>
References: <cover.1519057258.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The __cold functions are placed to a special section, as they're
expected to be called rarely. This could help i-cache prefetches or help
compiler to decide which branches are more/less likely to be taken
without any other annotations needed.

Though we can't add more __exit annotations, it's still possible to add
__cold (that's also added with __exit). That way the following function
categories are tagged:

- printf wrappers, error messages
- exit helpers

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/backref.c       | 2 +-
 fs/btrfs/backref.h       | 2 +-
 fs/btrfs/compression.c   | 2 +-
 fs/btrfs/compression.h   | 2 +-
 fs/btrfs/ctree.h         | 9 +++++----
 fs/btrfs/delayed-inode.c | 2 +-
 fs/btrfs/delayed-inode.h | 2 +-
 fs/btrfs/delayed-ref.c   | 2 +-
 fs/btrfs/delayed-ref.h   | 2 +-
 fs/btrfs/disk-io.c       | 2 +-
 fs/btrfs/disk-io.h       | 2 +-
 fs/btrfs/extent_io.c     | 2 +-
 fs/btrfs/extent_io.h     | 2 +-
 fs/btrfs/extent_map.c    | 2 +-
 fs/btrfs/extent_map.h    | 2 +-
 fs/btrfs/file.c          | 2 +-
 fs/btrfs/inode.c         | 2 +-
 fs/btrfs/ordered-data.c  | 2 +-
 fs/btrfs/ordered-data.h  | 2 +-
 fs/btrfs/super.c         | 2 +-
 fs/btrfs/sysfs.c         | 2 +-
 fs/btrfs/tree-checker.c  | 3 +++
 22 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index f94b2d8c744a..4e89598ca878 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -170,7 +170,7 @@ int __init btrfs_prelim_ref_init(void)
 	return 0;
 }
 
-void btrfs_prelim_ref_exit(void)
+void __cold btrfs_prelim_ref_exit(void)
 {
 	kmem_cache_destroy(btrfs_prelim_ref_cache);
 }
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 0c2fab8514ff..0a30028d5196 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -73,7 +73,7 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
 int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr);
 
 int __init btrfs_prelim_ref_init(void);
-void btrfs_prelim_ref_exit(void);
+void __cold btrfs_prelim_ref_exit(void);
 
 struct prelim_ref {
 	struct rb_node rbnode;
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 07d049c0c20f..562c3e633403 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1133,7 +1133,7 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 	return ret;
 }
 
-void btrfs_exit_compress(void)
+void __cold btrfs_exit_compress(void)
 {
 	free_workspaces();
 }
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 677fa4aa0bd7..ce796557a918 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -76,7 +76,7 @@ struct compressed_bio {
 };
 
 void __init btrfs_init_compress(void);
-void btrfs_exit_compress(void);
+void __cold btrfs_exit_compress(void);
 
 int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 			 u64 start, struct page **pages,
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 773c0cecc608..0b67ee4dcb6e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3202,7 +3202,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb);
 void btrfs_destroy_inode(struct inode *inode);
 int btrfs_drop_inode(struct inode *inode);
 int __init btrfs_init_cachep(void);
-void btrfs_destroy_cachep(void);
+void __cold btrfs_destroy_cachep(void);
 long btrfs_ioctl_trans_end(struct file *file);
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *was_new);
@@ -3253,7 +3253,7 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
 
 /* file.c */
 int __init btrfs_auto_defrag_init(void);
-void btrfs_auto_defrag_exit(void);
+void __cold btrfs_auto_defrag_exit(void);
 int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 			   struct btrfs_inode *inode);
 int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info);
@@ -3288,7 +3288,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 
 /* sysfs.c */
 int __init btrfs_init_sysfs(void);
-void btrfs_exit_sysfs(void);
+void __cold btrfs_exit_sysfs(void);
 int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info);
 void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
 
@@ -3300,13 +3300,14 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			unsigned long new_flags);
 int btrfs_sync_fs(struct super_block *sb, int wait);
 
-static inline __printf(2, 3)
+static inline __printf(2, 3) __cold
 void btrfs_no_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 {
 }
 
 #ifdef CONFIG_PRINTK
 __printf(2, 3)
+__cold
 void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...);
 #else
 #define btrfs_printk(fs_info, fmt, args...) \
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 09939fc37f2a..d06bef16ebd5 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -42,7 +42,7 @@ int __init btrfs_delayed_inode_init(void)
 	return 0;
 }
 
-void btrfs_delayed_inode_exit(void)
+void __cold btrfs_delayed_inode_exit(void)
 {
 	kmem_cache_destroy(delayed_node_cache);
 }
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index ae893d85224f..100a91e26b55 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -149,7 +149,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 
 /* for init */
 int __init btrfs_delayed_inode_init(void);
-void btrfs_delayed_inode_exit(void);
+void __cold btrfs_delayed_inode_exit(void);
 
 /* for debugging */
 void btrfs_assert_delayed_root_empty(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 7ab5e0128f0c..03bdf355107a 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -930,7 +930,7 @@ btrfs_find_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_refs, u64 byt
 	return find_ref_head(&delayed_refs->href_root, bytenr, 0);
 }
 
-void btrfs_delayed_ref_exit(void)
+void __cold btrfs_delayed_ref_exit(void)
 {
 	kmem_cache_destroy(btrfs_delayed_ref_head_cachep);
 	kmem_cache_destroy(btrfs_delayed_tree_ref_cachep);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index c4f625e5a691..9e3e5aff0937 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -204,7 +204,7 @@ extern struct kmem_cache *btrfs_delayed_data_ref_cachep;
 extern struct kmem_cache *btrfs_delayed_extent_op_cachep;
 
 int __init btrfs_delayed_ref_init(void);
-void btrfs_delayed_ref_exit(void);
+void __cold btrfs_delayed_ref_exit(void);
 
 static inline struct btrfs_delayed_extent_op *
 btrfs_alloc_delayed_extent_op(void)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c10c84640eee..798e602c1834 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -110,7 +110,7 @@ int __init btrfs_end_io_wq_init(void)
 	return 0;
 }
 
-void btrfs_end_io_wq_exit(void)
+void __cold btrfs_end_io_wq_exit(void)
 {
 	kmem_cache_destroy(btrfs_end_io_wq_cache);
 }
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index e2ac6a14150a..aaf99529883d 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -153,7 +153,7 @@ struct extent_map *btree_get_extent(struct btrfs_inode *inode,
 		int create);
 int btrfs_get_num_tolerated_disk_barrier_failures(u64 flags);
 int __init btrfs_end_io_wq_init(void);
-void btrfs_end_io_wq_exit(void);
+void __cold btrfs_end_io_wq_exit(void);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 void btrfs_init_lockdep(void);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4e73705b405e..da46e9372262 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -187,7 +187,7 @@ int __init extent_io_init(void)
 	return -ENOMEM;
 }
 
-void extent_io_exit(void)
+void __cold extent_io_exit(void)
 {
 	btrfs_leak_debug_check();
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index da9be2fb0502..e359c5d4305c 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -286,7 +286,7 @@ int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end);
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 			  get_extent_t *get_extent, int mirror_num);
 int __init extent_io_init(void);
-void extent_io_exit(void);
+void __cold extent_io_exit(void);
 
 u64 count_range_bits(struct extent_io_tree *tree,
 		     u64 *start, u64 search_end,
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index b8ead8dc2ebe..53a0633c6ef7 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -19,7 +19,7 @@ int __init extent_map_init(void)
 	return 0;
 }
 
-void extent_map_exit(void)
+void __cold extent_map_exit(void)
 {
 	kmem_cache_destroy(extent_map_cache);
 }
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index b29f77bc0732..f6f8ba114977 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -86,7 +86,7 @@ void replace_extent_mapping(struct extent_map_tree *tree,
 struct extent_map *alloc_extent_map(void);
 void free_extent_map(struct extent_map *em);
 int __init extent_map_init(void);
-void extent_map_exit(void);
+void __cold extent_map_exit(void);
 int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len, u64 gen);
 void clear_em_logging(struct extent_map_tree *tree, struct extent_map *em);
 struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 41ab9073d1d4..a335e2e6c84d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3378,7 +3378,7 @@ const struct file_operations btrfs_file_operations = {
 	.dedupe_file_range = btrfs_dedupe_file_range,
 };
 
-void btrfs_auto_defrag_exit(void)
+void __cold btrfs_auto_defrag_exit(void)
 {
 	kmem_cache_destroy(btrfs_inode_defrag_cachep);
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 491a7397f6fa..bb5de52cbc09 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9478,7 +9478,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-void btrfs_destroy_cachep(void)
+void __cold btrfs_destroy_cachep(void)
 {
 	/*
 	 * Make sure all delayed rcu free inodes are flushed before we
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 5b311aeddcc8..9be98e42cfb6 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -1154,7 +1154,7 @@ int __init ordered_data_init(void)
 	return 0;
 }
 
-void ordered_data_exit(void)
+void __cold ordered_data_exit(void)
 {
 	kmem_cache_destroy(btrfs_ordered_extent_cache);
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index c53e2cfb72d9..4a1672a13ba6 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -217,5 +217,5 @@ void btrfs_wait_logged_extents(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *log, u64 transid);
 void btrfs_free_logged_extents(struct btrfs_root *log, u64 transid);
 int __init ordered_data_init(void);
-void ordered_data_exit(void);
+void __cold ordered_data_exit(void);
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3b145c603009..4ee705c2beb0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2336,7 +2336,7 @@ static int __init btrfs_interface_init(void)
 	return misc_register(&btrfs_misc);
 }
 
-static void btrfs_interface_exit(void)
+static __cold void btrfs_interface_exit(void)
 {
 	misc_deregister(&btrfs_misc);
 }
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index a8bafed931f4..6af7b58e1a90 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -923,7 +923,7 @@ int __init btrfs_init_sysfs(void)
 	return ret;
 }
 
-void btrfs_exit_sysfs(void)
+void __cold btrfs_exit_sysfs(void)
 {
 	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 	kset_unregister(btrfs_kset);
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index e96cfd93ae3f..8871286c1a91 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -52,6 +52,7 @@
  * Allows callers to customize the output.
  */
 __printf(4, 5)
+__cold
 static void generic_err(const struct btrfs_fs_info *fs_info,
 			const struct extent_buffer *eb, int slot,
 			const char *fmt, ...)
@@ -76,6 +77,7 @@ static void generic_err(const struct btrfs_fs_info *fs_info,
  * offset has its own meaning.
  */
 __printf(4, 5)
+__cold
 static void file_extent_err(const struct btrfs_fs_info *fs_info,
 			    const struct extent_buffer *eb, int slot,
 			    const char *fmt, ...)
@@ -229,6 +231,7 @@ static int check_csum_item(struct btrfs_fs_info *fs_info,
  * which represents inode number
  */
 __printf(4, 5)
+__cold
 static void dir_item_err(const struct btrfs_fs_info *fs_info,
 			 const struct extent_buffer *eb, int slot,
 			 const char *fmt, ...)
-- 
2.16.1

