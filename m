From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] Btrfs: potential NULL dereferences
Date: Mon, 31 Aug 2009 15:17:24 +0200
Message-ID: <4A9BCD64.8010308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris.mason@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Allocations may fail, prevent NULL dereferences.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
In several sections of fs/btrfs code a kmalloc() occurs without a
check whether it succeeded. this potentially leads to dereferences
of a NULL pointer. Are there reasons why we do not check the
allocations? Did I choose an incorrect way to err out? please
review.

 fs/btrfs/compression.c |    3 +++
 fs/btrfs/extent-tree.c |    2 ++
 fs/btrfs/file.c        |    2 ++
 fs/btrfs/inode.c       |    2 ++
 fs/btrfs/tree-log.c    |    2 ++
 5 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 9d8ba4d..1cb049d 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -351,6 +351,8 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 
 	WARN_ON(start & ((u64)PAGE_CACHE_SIZE - 1));
 	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
+	if (cb == NULL)
+		return -ENOMEM;
 	atomic_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
@@ -601,6 +603,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 	compressed_len = em->block_len;
 	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
+	BUG_ON(cb == NULL);
 	atomic_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 72a2b9c..e37aa04 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6729,6 +6729,8 @@ static noinline int relocate_one_extent(struct btrfs_root *extent_root,
 				u64 group_start = group->key.objectid;
 				new_extents = kmalloc(sizeof(*new_extents),
 						      GFP_NOFS);
+				if (new_extents == NULL)
+					goto out
 				nr_extents = 1;
 				ret = get_new_locations(reloc_inode,
 							extent_key,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 4b83397..58b343c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -949,6 +949,8 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 	file_update_time(file);
 
 	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+	if (pages == NULL)
+		goto out_nolock;
 
 	mutex_lock(&inode->i_mutex);
 	BTRFS_I(inode)->sequence++;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 59cba18..cea4423 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4013,6 +4013,8 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	inline_size = btrfs_file_extent_inline_item_len(leaf,
 					btrfs_item_nr(leaf, path->slots[0]));
 	tmp = kmalloc(inline_size, GFP_NOFS);
+	if (tmp == NULL)
+		return -ENOMEM;
 	ptr = btrfs_file_extent_inline_start(item);
 
 	read_extent_buffer(leaf, tmp, ptr, inline_size);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index d91b0de..fc6c3f1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -652,6 +652,7 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	btrfs_dir_item_key_to_cpu(leaf, di, &location);
 	name_len = btrfs_dir_name_len(leaf, di);
 	name = kmalloc(name_len, GFP_NOFS);
+	BUG_ON(name == NULL);
 	read_extent_buffer(leaf, name, (unsigned long)(di + 1), name_len);
 	btrfs_release_path(root, path);
 
@@ -1155,6 +1156,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 
 	name_len = btrfs_dir_name_len(eb, di);
 	name = kmalloc(name_len, GFP_NOFS);
+	BUG_ON(name == NULL);
 	log_type = btrfs_dir_type(eb, di);
 	read_extent_buffer(eb, name, (unsigned long)(di + 1),
 		   name_len);
