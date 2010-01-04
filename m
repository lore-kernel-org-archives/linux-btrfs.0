From: jim owens <jowens@hp.com>
Subject: [RFC 11/12 PATCH] Btrfs: add direct I/O helper btrfs_lookup_one_csum().
Date: Mon, 04 Jan 2010 16:14:21 -0500
Message-ID: <4B425A2D.5030207@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Direct I/O needs to fetch a single checksum based on the
extent information instead of page struct content.

Signed-off-by: jim owens <jowens@hp.com>
---
 fs/btrfs/ctree.h     |    2 ++
 fs/btrfs/file-item.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bf04876..e5926c6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2281,6 +2281,8 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 			u64 isize);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start,
 			     u64 end, struct list_head *list, u32 *csums);
+int btrfs_lookup_one_csum(struct btrfs_root *root, struct inode *inode,
+			u64 disk_bytenr, u64 fpos, u32 *csum);
 /* inode.c */
 
 /* RHEL and EL kernels have a patch that renames PG_checked to FsMisc */
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 72c76bd..8482a56 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -244,6 +244,51 @@ found:
 	return 0;
 }
 
+int btrfs_lookup_one_csum(struct btrfs_root *root, struct inode *inode,
+			  u64 disk_bytenr, u64 fpos, u32 *csum)
+{
+	u32 diff;
+	u16 csum_size;
+	int ret;
+	struct btrfs_path *path;
+	struct btrfs_csum_item *item;
+	struct btrfs_key found_key;
+
+	if (!btrfs_find_ordered_sum(inode, fpos, disk_bytenr, csum))
+		return 0;
+
+	*csum = 0;
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	item = btrfs_lookup_csum(NULL, root->fs_info->csum_root,
+				path, disk_bytenr, 0);
+	if (IS_ERR(item)) {
+		ret = PTR_ERR(item);
+		printk(KERN_INFO "btrfs no csum found "
+				"for inode %lu start %llu err %d\n",
+				inode->i_ino, (unsigned long long)fpos, ret);
+		goto notfound;
+	}
+
+	btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
+	item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				struct btrfs_csum_item);
+	csum_size = btrfs_super_csum_size(&root->fs_info->super_copy);
+
+	diff = disk_bytenr - found_key.offset;
+	diff = diff / root->sectorsize * csum_size;
+
+	read_extent_buffer(path->nodes[0], csum,
+			   ((unsigned long)item) + diff, csum_size);
+	ret = 0;
+
+notfound:
+	btrfs_free_path(path);
+	return ret;
+}
+
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, u32 *csums)
 {
-- 
1.5.6.3
