Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758125AbaGAOVl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 10:21:41 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Hugo Mills <hugo@carfax.org.uk>,
        cwillu <cwillu@cwillu.com>, Josef Bacik <jbacik@fb.com>
Subject: [PATCH] btrfs: adjust statfs calculations according to raid profiles
Date: Tue,  1 Jul 2014 16:21:33 +0200
Message-Id: <1404224493-8118-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has been discussed in thread:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/32528

and this patch implements this proposal:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/32536

Works fine for "clean" raid profiles where the raid factor correction
does the right job. Otherwise it's pessimistic and may show low space
although there's still some left.

The df nubmers are lightly wrong in case of mixed block groups, but this
is not a major usecase and can be addressed later.

The RAID56 numbers are wrong almost the same way as before and will be
addressed separately.

CC: Hugo Mills <hugo@carfax.org.uk>
CC: cwillu <cwillu@cwillu.com>
CC: Josef Bacik <jbacik@fb.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/super.c | 51 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4662d92a4b73..372e5abe6d9c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1669,6 +1669,21 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
 	return 0;
 }
 
+/*
+ * Calculate numbers for 'df', pessimistic in case of mixed raid profiles.
+ *
+ * If there's a redundant raid level at DATA block groups, use the respective
+ * multiplier to scale the sizes.
+ *
+ * Unused device space usage is based on simulating the chunk allocator
+ * algorithm that respects the device sizes, order of allocations and the
+ * 'alloc_start' value, this is a close approximation of the actual use but
+ * there are other factors that may change the result (like a new metadata
+ * chunk).
+ *
+ * FIXME: not accurate for mixed block groups, total and free/used are ok,
+ * available appears slightly larger.
+ */
 static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(dentry->d_sb);
@@ -1679,6 +1694,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u64 total_free_data = 0;
 	int bits = dentry->d_sb->s_blocksize_bits;
 	__be32 *fsid = (__be32 *)fs_info->fsid;
+	unsigned factor = 1;
+	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 
 	/* holding chunk_muext to avoid allocating new chunks */
@@ -1686,30 +1703,52 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
 		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
+			int i;
+
 			total_free_data += found->disk_total - found->disk_used;
 			total_free_data -=
 				btrfs_account_ro_block_groups_free_space(found);
+
+			for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
+				if (!list_empty(&found->block_groups[i])) {
+					switch (i) {
+					case BTRFS_RAID_DUP:
+					case BTRFS_RAID_RAID1:
+					case BTRFS_RAID_RAID10:
+						factor = 2;
+					}
+				}
+			}
 		}
 
 		total_used += found->disk_used;
 	}
+
 	rcu_read_unlock();
 
-	buf->f_namelen = BTRFS_NAME_LEN;
-	buf->f_blocks = btrfs_super_total_bytes(disk_super) >> bits;
-	buf->f_bfree = buf->f_blocks - (total_used >> bits);
-	buf->f_bsize = dentry->d_sb->s_blocksize;
-	buf->f_type = BTRFS_SUPER_MAGIC;
+	buf->f_blocks = div_u64(btrfs_super_total_bytes(disk_super), factor);
+	buf->f_blocks >>= bits;
+	buf->f_bfree = buf->f_blocks - (div_u64(total_used, factor) >> bits);
+
+	/* Account global block reserve as used, it's in logical size already */
+	spin_lock(&block_rsv->lock);
+	buf->f_bfree -= block_rsv->size >> bits;
+	spin_unlock(&block_rsv->lock);
+
 	buf->f_bavail = total_free_data;
 	ret = btrfs_calc_avail_data_space(fs_info->tree_root, &total_free_data);
 	if (ret) {
 		mutex_unlock(&fs_info->chunk_mutex);
 		return ret;
 	}
-	buf->f_bavail += total_free_data;
+	buf->f_bavail += div_u64(total_free_data, factor);
 	buf->f_bavail = buf->f_bavail >> bits;
 	mutex_unlock(&fs_info->chunk_mutex);
 
+	buf->f_type = BTRFS_SUPER_MAGIC;
+	buf->f_bsize = dentry->d_sb->s_blocksize;
+	buf->f_namelen = BTRFS_NAME_LEN;
+
 	/* We treat it as constant endianness (it doesn't matter _which_)
 	   because we want the fsid to come out the same whether mounted
 	   on a big-endian or little-endian host */
-- 
1.8.4.5

