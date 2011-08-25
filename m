From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [RFC] Btrfs design defect in extent backref ?
Date: Thu, 25 Aug 2011 15:56:08 +0800
Message-ID: <4E560018.9060005@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Yan@tang.cn.fujitsu.com, Zheng <zheng.z.yan@intel.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We have an offset in file extent to indicate its position in the
corresponding extent item in extent tree. We also have an offset in
extent item to indicate the start position of the file extent that
uses this item.

The math is:

    extent_item.extent_data_ref.offset = file_pos - file_extent.extent_offset.

                       e1
disk extents:    |--------------|
                 ^     
                 |                  e2
                 |          |-----------------|
                 |          |   ^
                 |          |   |
                 v          v   |
file extents:    |----- f1 -----|----- f2 -----|

So it looks like e2.offset points to f1 not f2. Therefore given an extent item,
we'll have to search through all the file extents in an inode to find the
relative file extent in the worst case, which makes this field somewhat useless.

What makes things worse is the above fomula can make the offset a negative
value (cast to u64):

    # touch /mnt/dst
    # clone_range -s 8192 -d 4096 /mnt/src /mnt/dst
    # umount /mnt
    # btrfs-debug-tree /dev/sda7
    ...
        item 2 key (12582912 EXTENT_ITEM 49152) itemoff 3865 itemsize 82
                extent refs 2 gen 8 flags 1
                extent data backref root 5 objectid 258 offset 18446744073709543424 count 1
                extent data backref root 5 objectid 257 offset 0 count 1
    ...

and relocation won't work in this case:

    # mount /dev/sda7 /mnt
    # rm /mnt/src
    # sync
    # btrfs fi bal /mnt
    (kernel warning !!)
    (hung up !!)

I don't see the necessity or benefit of the substraction in the fomula,
and I think the correct one is:

    extent_item.extent_data_ref.offset = file_pos

(As a side effect thereafter we don't need extent_data_ref.count)

That's what this patch does. Unfornately it is an incompatable change
in disk format.

So I think we have to live with this defect, just fix relocation for
the negative offset case ?

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    1 -
 fs/btrfs/file.c        |   11 +++++------
 fs/btrfs/inode.c       |    7 +++----
 fs/btrfs/ioctl.c       |    2 +-
 fs/btrfs/relocation.c  |    1 -
 5 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f5be06a..3924e03 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2578,7 +2578,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 				continue;
 
 			num_bytes = btrfs_file_extent_disk_num_bytes(buf, fi);
-			key.offset -= btrfs_file_extent_offset(buf, fi);
 			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, key.objectid,
 					   key.offset);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..7f65a27 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -678,7 +678,7 @@ next_slot:
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
 						new_key.objectid,
-						start - extent_offset);
+						start);
 				BUG_ON(ret);
 				*hint_byte = disk_bytenr;
 			}
@@ -752,8 +752,7 @@ next_slot:
 				ret = btrfs_free_extent(trans, root,
 						disk_bytenr, num_bytes, 0,
 						root->root_key.objectid,
-						key.objectid, key.offset -
-						extent_offset);
+						key.objectid, key.offset);
 				BUG_ON(ret);
 				inode_sub_bytes(inode,
 						extent_end - key.offset);
@@ -962,7 +961,7 @@ again:
 
 		ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0,
 					   root->root_key.objectid,
-					   ino, orig_offset);
+					   ino, split);
 		BUG_ON(ret);
 
 		if (split == start) {
@@ -989,7 +988,7 @@ again:
 		del_nr++;
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
-					ino, orig_offset);
+					ino, other_start);
 		BUG_ON(ret);
 	}
 	other_start = 0;
@@ -1006,7 +1005,7 @@ again:
 		del_nr++;
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
-					ino, orig_offset);
+					ino, other_end);
 		BUG_ON(ret);
 	}
 	if (del_nr == 0) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ccc743..0158652 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3135,7 +3135,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	struct btrfs_key found_key;
 	u64 extent_start = 0;
 	u64 extent_num_bytes = 0;
-	u64 extent_offset = 0;
+	u64 offset = 0;
 	u64 item_end = 0;
 	u64 mask = root->sectorsize - 1;
 	u32 found_type = (u8)-1;
@@ -3256,8 +3256,7 @@ search_again:
 				extent_num_bytes =
 					btrfs_file_extent_disk_num_bytes(leaf,
 									 fi);
-				extent_offset = found_key.offset -
-					btrfs_file_extent_offset(leaf, fi);
+				offset = found_key.offset;
 
 				/* FIXME blocksize != 4096 */
 				num_dec = btrfs_file_extent_num_bytes(leaf, fi);
@@ -3314,7 +3313,7 @@ delete:
 			ret = btrfs_free_extent(trans, root, extent_start,
 						extent_num_bytes, 0,
 						btrfs_header_owner(leaf),
-						ino, extent_offset);
+						ino, offset);
 			BUG_ON(ret);
 		}
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3351b1b..87e126f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2379,7 +2379,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 							disko, diskl, 0,
 							root->root_key.objectid,
 							btrfs_ino(inode),
-							new_key.offset - datao);
+							new_key.offset);
 					BUG_ON(ret);
 				}
 			} else if (type == BTRFS_FILE_EXTENT_INLINE) {
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 59bb176..a8d0089 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1598,7 +1598,6 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 		btrfs_set_file_extent_disk_bytenr(leaf, fi, new_bytenr);
 		dirty = 1;
 
-		key.offset -= btrfs_file_extent_offset(leaf, fi);
 		ret = btrfs_inc_extent_ref(trans, root, new_bytenr,
 					   num_bytes, parent,
 					   btrfs_header_owner(leaf),
-- 
1.7.3.1


