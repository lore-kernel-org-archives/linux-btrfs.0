From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/3] Btrfs: save trimmed flag onto disk
Date: Thu, 29 Dec 2011 17:50:17 +0800
Message-ID: <4EFC37D9.6040201@cn.fujitsu.com>
References: <4EFC378D.7090606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EFC378D.7090606@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

To speed up the first fstrim after mounting the filesystem, we save the
trimmed flag to disk.

     # fstrim -v /mnt/
     /mnt/: 267714560 bytes were trimmed
     # fstrim -v /mnt/
     /mnt/: 0 bytes were trimmed
     # sync
     # umount /mnt
     # !mount
     # fstrim -v /mnt/
     /mnt/: 152240128 bytes were trimmed

Because caches for block groups smaller than 100M will not be written
to disk, we'll still have to trim them.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ctree.h            |    1 +
 fs/btrfs/free-space-cache.c |   19 ++++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ca4eb2d..84e9ff6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -280,6 +280,7 @@ struct btrfs_chunk {
 
 #define BTRFS_FREE_SPACE_EXTENT		(1 << 0)
 #define BTRFS_FREE_SPACE_BITMAP		(1 << 1)
+#define BTRFS_FREE_SPACE_TRIMMED	(1 << 2)
 
 struct btrfs_free_space_entry {
 	__le64 offset;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index cba2a94..592ba54 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -469,7 +469,7 @@ static int io_ctl_check_crc(struct io_ctl *io_ctl, int index)
 }
 
 static int io_ctl_add_entry(struct io_ctl *io_ctl, u64 offset, u64 bytes,
-			    void *bitmap)
+			    void *bitmap, bool trimmed)
 {
 	struct btrfs_free_space_entry *entry;
 
@@ -481,6 +481,8 @@ static int io_ctl_add_entry(struct io_ctl *io_ctl, u64 offset, u64 bytes,
 	entry->bytes = cpu_to_le64(bytes);
 	entry->type = (bitmap) ? BTRFS_FREE_SPACE_BITMAP :
 		BTRFS_FREE_SPACE_EXTENT;
+	if (trimmed)
+		entry->type |= BTRFS_FREE_SPACE_TRIMMED;
 	io_ctl->cur += sizeof(struct btrfs_free_space_entry);
 	io_ctl->size -= sizeof(struct btrfs_free_space_entry);
 
@@ -669,6 +671,9 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			goto free_cache;
 		}
 
+		if (type & BTRFS_FREE_SPACE_TRIMMED)
+			e->trimmed = true;
+
 		if (type & BTRFS_FREE_SPACE_EXTENT) {
 			spin_lock(&ctl->tree_lock);
 			ret = link_free_space(ctl, e);
@@ -899,7 +904,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		entries++;
 
 		ret = io_ctl_add_entry(&io_ctl, e->offset, e->bytes,
-				       e->bitmap);
+				       e->bitmap, e->trimmed);
 		if (ret)
 			goto out_nospc;
 
@@ -937,7 +942,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		len = min(len, end + 1 - start);
 
 		entries++;
-		ret = io_ctl_add_entry(&io_ctl, start, len, NULL);
+		ret = io_ctl_add_entry(&io_ctl, start, len, NULL, false);
 		if (ret)
 			goto out_nospc;
 
@@ -2696,6 +2701,14 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
 			if (update) {
 				spin_lock(&space_info->lock);
 				spin_lock(&block_group->lock);
+
+				if (btrfs_test_opt(fs_info->tree_root,
+				    SPACE_CACHE) &&
+				    block_group->disk_cache_state <
+				    BTRFS_DC_CLEAR);
+					block_group->disk_cache_state =
+						BTRFS_DC_CLEAR;
+				block_group->dirty = 1;
 				if (block_group->ro)
 					space_info->bytes_readonly += bytes;
 				block_group->reserved -= bytes;
-- 1.7.3.1 
