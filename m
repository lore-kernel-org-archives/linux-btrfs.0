From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 2/2] Btrfs: add missing read locks in backref.c
Date: Fri, 13 Apr 2012 12:28:08 +0200
Message-ID: <1334312888-21760-1-git-send-email-list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

iref_to_path and iterate_irefs both increment the eb's refcount to use it
after releasing the path. Both depend on consistent data remaining in the
extent buffer and need a read lock to protect it.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 8be551c..653e20d 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -22,6 +22,7 @@
 #include "ulist.h"
 #include "transaction.h"
 #include "delayed-ref.h"
+#include "locking.h"
 
 /*
  * this structure records all encountered refs on the way up to the root
@@ -893,18 +894,22 @@ static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 	s64 bytes_left = size - 1;
 	struct extent_buffer *eb = eb_in;
 	struct btrfs_key found_key;
+	int leave_spinning = path->leave_spinning;
 
 	if (bytes_left >= 0)
 		dest[bytes_left] = '\0';
 
+	path->leave_spinning = 1;
 	while (1) {
 		len = btrfs_inode_ref_name_len(eb, iref);
 		bytes_left -= len;
 		if (bytes_left >= 0)
 			read_extent_buffer(eb, dest + bytes_left,
 						(unsigned long)(iref + 1), len);
-		if (eb != eb_in)
+		if (eb != eb_in) {
+			btrfs_tree_read_unlock_blocking(eb);
 			free_extent_buffer(eb);
+		}
 		ret = inode_ref_info(parent, 0, fs_root, path, &found_key);
 		if (ret > 0)
 			ret = -ENOENT;
@@ -919,8 +924,11 @@ static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 		slot = path->slots[0];
 		eb = path->nodes[0];
 		/* make sure we can use eb after releasing the path */
-		if (eb != eb_in)
+		if (eb != eb_in) {
 			atomic_inc(&eb->refs);
+			btrfs_tree_read_lock(eb);
+			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+		}
 		btrfs_release_path(path);
 
 		iref = btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
@@ -931,6 +939,7 @@ static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 	}
 
 	btrfs_release_path(path);
+	path->leave_spinning = leave_spinning;
 
 	if (ret)
 		return ERR_PTR(ret);
@@ -1260,6 +1269,7 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
 	struct btrfs_key found_key;
 
 	while (!ret) {
+		path->leave_spinning = 1;
 		ret = inode_ref_info(inum, parent ? parent+1 : 0, fs_root, path,
 					&found_key);
 		if (ret < 0)
@@ -1275,6 +1285,8 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
 		eb = path->nodes[0];
 		/* make sure we can use eb after releasing the path */
 		atomic_inc(&eb->refs);
+		btrfs_tree_read_lock(eb);
+		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 		btrfs_release_path(path);
 
 		item = btrfs_item_nr(eb, slot);
@@ -1293,6 +1305,7 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
 			len = sizeof(*iref) + name_len;
 			iref = (struct btrfs_inode_ref *)((char *)iref + len);
 		}
+		btrfs_tree_read_unlock_blocking(eb);
 		free_extent_buffer(eb);
 	}
 
-- 
1.7.3.4

