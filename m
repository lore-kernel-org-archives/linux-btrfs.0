From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs: fix several uncheck memory allocations
Date: Wed, 26 Jan 2011 14:22:08 +0800
Message-ID: <4D3FBD90.1050107@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


To make btrfs more stable, add several missing necessary memory allocation
checks, and when no memory, return proper errno.

We've checked that some of those -ENOMEM errors will be returned to
userspace, and some will be catched by BUG_ON() in the upper callers,
and none will be ignored silently.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/export.c    |    2 ++
 fs/btrfs/file-item.c |    2 ++
 fs/btrfs/file.c      |    4 ++++
 fs/btrfs/tree-log.c  |   25 +++++++++++++++++++++++++
 4 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 6f04444..3220ad1 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -176,6 +176,8 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
 	int ret;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return ERR_PTR(-ENOMEM);
 
 	if (dir->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
 		key.objectid = root->root_key.objectid;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a562a25..d0bc726 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -536,6 +536,8 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 	root = root->fs_info->csum_root;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	while (1) {
 		key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f903433..65b2424 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -945,6 +945,10 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		     PAGE_CACHE_SIZE, PAGE_CACHE_SIZE /
 		     (sizeof(struct page *)));
 	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+	if (!pages) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	/* generic_write_checks can change our pos */
 	start_pos = pos;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 054744a..c25a41d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -338,6 +338,12 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 		}
 		dst_copy = kmalloc(item_size, GFP_NOFS);
 		src_copy = kmalloc(item_size, GFP_NOFS);
+		if (!dst_copy || !src_copy) {
+			btrfs_release_path(root, path);
+			kfree(dst_copy);
+			kfree(src_copy);
+			return -ENOMEM;
+		}
 
 		read_extent_buffer(eb, src_copy, src_ptr, item_size);
 
@@ -665,6 +671,9 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	btrfs_dir_item_key_to_cpu(leaf, di, &location);
 	name_len = btrfs_dir_name_len(leaf, di);
 	name = kmalloc(name_len, GFP_NOFS);
+	if (!name)
+		return -ENOMEM;
+
 	read_extent_buffer(leaf, name, (unsigned long)(di + 1), name_len);
 	btrfs_release_path(root, path);
 
@@ -744,6 +753,9 @@ static noinline int backref_in_log(struct btrfs_root *log,
 	int match = 0;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
 	ret = btrfs_search_slot(NULL, log, key, path, 0, 0);
 	if (ret != 0)
 		goto out;
@@ -967,6 +979,8 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 	key.offset = (u64)-1;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	while (1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
@@ -1178,6 +1192,9 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 
 	name_len = btrfs_dir_name_len(eb, di);
 	name = kmalloc(name_len, GFP_NOFS);
+	if (!name)
+		return -ENOMEM;
+
 	log_type = btrfs_dir_type(eb, di);
 	read_extent_buffer(eb, name, (unsigned long)(di + 1),
 		   name_len);
@@ -1692,6 +1709,8 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 		root_owner = btrfs_header_owner(parent);
 
 		next = btrfs_find_create_tree_block(root, bytenr, blocksize);
+		if (!next)
+			return -ENOMEM;
 
 		if (*level == 1) {
 			wc->process_func(root, next, wc, ptr_gen);
@@ -2194,6 +2213,9 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 
 	log = root->log_root;
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
 	di = btrfs_lookup_dir_item(trans, log, path, dir->i_ino,
 				   name, name_len, -1);
 	if (IS_ERR(di)) {
@@ -2594,6 +2616,9 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 
 	ins_data = kmalloc(nr * sizeof(struct btrfs_key) +
 			   nr * sizeof(u32), GFP_NOFS);
+	if (!ins_data)
+		return -ENOMEM;
+
 	ins_sizes = (u32 *)ins_data;
 	ins_keys = (struct btrfs_key *)(ins_data + nr * sizeof(u32));
 
-- 
1.6.5.2
