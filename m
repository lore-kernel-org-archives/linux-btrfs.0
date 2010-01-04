From: jim owens <jowens@hp.com>
Subject: [RFC 10/12 PATCH] Btrfs: add direct I/O checksum option to btrfs_lookup_csums_range.
Date: Mon, 04 Jan 2010 16:14:14 -0500
Message-ID: <4B425A26.30509@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Direct I/O needs to efficiently fetch an extent range of checksums
so an option is added to copy raw checksums into a buffer instead
of locally allocating and returning btrfs_ordered_sum structs.

Signed-off-by: jim owens <jowens@hp.com>
---
 fs/btrfs/ctree.h      |    2 +-
 fs/btrfs/file-item.c  |   28 +++++++++++++++++++++++++---
 fs/btrfs/inode.c      |    2 +-
 fs/btrfs/relocation.c |    2 +-
 fs/btrfs/tree-log.c   |    4 ++--
 5 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9f806dd..bf04876 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2280,7 +2280,7 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, struct btrfs_path *path,
 			u64 isize);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start,
-			     u64 end, struct list_head *list);
+			     u64 end, struct list_head *list, u32 *csums);
 /* inode.c */
 
 /* RHEL and EL kernels have a patch that renames PG_checked to FsMisc */
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 9b99886..72c76bd 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -245,7 +245,7 @@ found:
 }
 
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
-			     struct list_head *list)
+			     struct list_head *list, u32 *csums)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -302,8 +302,15 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 		if (key.offset > end)
 			break;
 
-		if (key.offset > start)
+		if (key.offset > start) {
+			if (csums) {
+				size_t num;
+				num = (key.offset - start) / root->sectorsize;
+				memset(csums, 0, num * csum_size);
+				csums += num;
+			}
 			start = key.offset;
+		}
 
 		size = btrfs_item_size_nr(leaf, path->slots[0]);
 		csum_end = key.offset + (size / csum_size) * root->sectorsize;
@@ -315,7 +322,16 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 		csum_end = min(csum_end, end + 1);
 		item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				      struct btrfs_csum_item);
-		while (start < csum_end) {
+		if (csums) {
+			size_t num = (csum_end - start) / root->sectorsize;
+			offset = (start - key.offset) /
+				root->sectorsize * csum_size;
+			read_extent_buffer(path->nodes[0], csums,
+					((unsigned long)item) +
+					offset, num * csum_size);
+			csums += num;
+			start = csum_end;
+		} else while (start < csum_end) {
 			size = min_t(size_t, csum_end - start,
 					MAX_ORDERED_SUM_BYTES(root));
 			sums = kzalloc(btrfs_ordered_sum_size(root, size),
@@ -346,6 +362,12 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 		}
 		path->slots[0]++;
 	}
+
+	if (csums && start < end) {
+		size_t num = (end - start + 1) / root->sectorsize;
+		memset(csums, 0, num * csum_size);
+	}
+
 	ret = 0;
 fail:
 	btrfs_free_path(path);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 152015c..fbc5bd1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -978,7 +978,7 @@ static noinline int csum_exist_in_range(struct btrfs_root *root,
 	LIST_HEAD(list);
 
 	ret = btrfs_lookup_csums_range(root->fs_info->csum_root, bytenr,
-				       bytenr + num_bytes - 1, &list);
+				       bytenr + num_bytes - 1, &list, NULL);
 	if (ret == 0 && list_empty(&list))
 		return 0;
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a972868..0056769 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3789,7 +3789,7 @@ int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len)
 
 	disk_bytenr = file_pos + BTRFS_I(inode)->index_cnt;
 	ret = btrfs_lookup_csums_range(root->fs_info->csum_root, disk_bytenr,
-				       disk_bytenr + len - 1, &list);
+				       disk_bytenr + len - 1, &list, NULL);
 
 	while (!list_empty(&list)) {
 		sums = list_entry(list.next, struct btrfs_ordered_sum, list);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4a9434b..51ed422 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -604,7 +604,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 
 			ret = btrfs_lookup_csums_range(root->log_root,
 						csum_start, csum_end - 1,
-						&ordered_sums);
+						&ordered_sums, NULL);
 			BUG_ON(ret);
 			while (!list_empty(&ordered_sums)) {
 				struct btrfs_ordered_sum *sums;
@@ -2645,7 +2645,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 				ret = btrfs_lookup_csums_range(
 						log->fs_info->csum_root,
 						ds + cs, ds + cs + cl - 1,
-						&ordered_sums);
+						&ordered_sums, NULL);
 				BUG_ON(ret);
 			}
 		}
-- 
1.5.6.3
