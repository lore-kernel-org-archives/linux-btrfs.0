From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v4 1/6] btrfs: add parameter to btrfs_lookup_csum_range
Date: Fri, 18 Mar 2011 16:55:04 +0100
Message-ID: <f3f65b930707a0308d57d698f58623394a42e446.1300462778.git.sensille@gmx.net>
References: <cover.1300462778.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1300462778.git.sensille@gmx.net>
In-Reply-To: <cover.1300462778.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

A parameter is added to search the commit root instead of the live root.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.h      |    4 ++--
 fs/btrfs/file-item.c  |    8 +++++++-
 fs/btrfs/inode.c      |    2 +-
 fs/btrfs/relocation.c |    2 +-
 fs/btrfs/tree-log.c   |    4 ++--
 5 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8b4b9d1..fd2b92f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2459,8 +2459,8 @@ struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
 int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, struct btrfs_path *path,
 			u64 isize);
-int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start,
-			     u64 end, struct list_head *list);
+int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
+			     struct list_head *list, int search_commit);
 /* inode.c */
 
 /* RHEL and EL kernels have a patch that renames PG_checked to FsMisc */
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 4f19a3e..9643d6e 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -263,7 +263,7 @@ int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
 }
 
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
-			     struct list_head *list)
+			     struct list_head *list, int search_commit)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -280,6 +280,12 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
+	if (search_commit) {
+		path->skip_locking = 1;
+		path->reada = 2;
+		path->search_commit_root = 1;
+	}
+
 	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
 	key.offset = start;
 	key.type = BTRFS_EXTENT_CSUM_KEY;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index db67821..c392d89 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1001,7 +1001,7 @@ static noinline int csum_exist_in_range(struct btrfs_root *root,
 	LIST_HEAD(list);
 
 	ret = btrfs_lookup_csums_range(root->fs_info->csum_root, bytenr,
-				       bytenr + num_bytes - 1, &list);
+				       bytenr + num_bytes - 1, &list, 0);
 	if (ret == 0 && list_empty(&list))
 		return 0;
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 31ade58..d7ae412 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4236,7 +4236,7 @@ int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len)
 
 	disk_bytenr = file_pos + BTRFS_I(inode)->index_cnt;
 	ret = btrfs_lookup_csums_range(root->fs_info->csum_root, disk_bytenr,
-				       disk_bytenr + len - 1, &list);
+				       disk_bytenr + len - 1, &list, 0);
 
 	while (!list_empty(&list)) {
 		sums = list_entry(list.next, struct btrfs_ordered_sum, list);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a4bbb85..1f6788f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -614,7 +614,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 
 			ret = btrfs_lookup_csums_range(root->log_root,
 						csum_start, csum_end - 1,
-						&ordered_sums);
+						&ordered_sums, 0);
 			BUG_ON(ret);
 			while (!list_empty(&ordered_sums)) {
 				struct btrfs_ordered_sum *sums;
@@ -2691,7 +2691,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 				ret = btrfs_lookup_csums_range(
 						log->fs_info->csum_root,
 						ds + cs, ds + cs + cl - 1,
-						&ordered_sums);
+						&ordered_sums, 0);
 				BUG_ON(ret);
 			}
 		}
-- 
1.7.3.4

