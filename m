From: cwillu <cwillu@cwillu.com>
Subject: [PATCH] Make df report effective sizes, not physical sizes
Date: Wed, 20 Oct 2010 05:19:42 -0600
Message-ID: <AANLkTikE0b8h9H=DPPXGGYhQAd8kSzvQud8DJSFm0-Cx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This currently applies on top of Josef's df patches.

----

Currently, a series of utilities are necessary to get an approximate answer to
the question "How much disk space do I have free?".  Previously, df returned
numbers which, while accurate, weren't useful:  the physical disk size isn't
interesting when you just want to know if you have room to fit that 20g backup.

Basically what we want is good estimate of sizes in terms of how much data we
can fit in our files (as we still have btrfs fi df and show if we need the
details).

The reported size is the total size of all data block groups, plus free space
in all metadata block groups, plus the unallocated space (factored by the data
profile, and less 3% for metadata).  This means that the total size will bounce
around a little depending on metadata overhead, but avoids giving an incorrect
idea of how much space is in principle available to the user.

The free disk space calculation is the same as the total size, but we replace
the total space allocated to data groups with the total space free in those
groups.  Note: as this includes the free space in metadata groups, btrfs
currently has a difficult time actually using up that space.  This is expected
to be addressed in the future.

The used space that regular df utility reports will be very close to (say) the
amount of removable media required for all the data on the filesystem (rather
than off by a factor depending on the raid level), and likewise with
the reported
free space.

Signed-off-by: Carey Underwood <cwillu@cwillu.com>
---
 fs/btrfs/super.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ea06877..81d5285 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -728,26 +728,51 @@ static int btrfs_statfs(struct dentry *dentry,
struct kstatfs *buf)
 	struct btrfs_super_block *disk_super = &root->fs_info->super_copy;
 	struct list_head *head = &root->fs_info->space_info;
 	struct btrfs_space_info *found;
-	u64 total_used = 0;
-	u64 total_used_data = 0;
+	int factor = 1;
+	u64 metadata_fuzz;
+	u64 pool_free = 0;
+	u64 data_avail = 0;
+	u64 data_used = 0;
 	int bits = dentry->d_sb->s_blocksize_bits;
 	__be32 *fsid = (__be32 *)root->fs_info->fsid;

 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
 		if (found->flags & (BTRFS_BLOCK_GROUP_METADATA |
-				    BTRFS_BLOCK_GROUP_SYSTEM))
-			total_used_data += found->disk_total;
-		else
-			total_used_data += found->disk_used;
-		total_used += found->disk_used;
+				    BTRFS_BLOCK_GROUP_SYSTEM)) {
+			/* This is space that could be used for data in a pinch,
+			   report it as such. */
+			data_avail += found->total_bytes - found->bytes_used;
+		} else {
+			data_avail += found->total_bytes;
+			data_used += found->bytes_used;
+
+			if (found->flags & (BTRFS_BLOCK_GROUP_DUP |
+					    BTRFS_BLOCK_GROUP_RAID1 |
+					    BTRFS_BLOCK_GROUP_RAID10))
+				factor = 2;
+		}
+		
+		pool_free += found->disk_total;
 	}
 	rcu_read_unlock();

+	pool_free = btrfs_super_total_bytes(disk_super) - pool_free;
+	do_div(pool_free, factor);
+	
+	/* Estimate ~3% of the free pool will go to metadata */
+	metadata_fuzz = pool_free;	
+	do_div(metadata_fuzz, 32);
+
+	/* Reported sizes in terms of how much data can fit in files. Metadata
+	   size is reflected by the difference between the reported size and
+	   the actual size of the partition.  We're interested directly useful
+	   numbers, even if they don't reflect the particulars: that's what
+	   the df ioctl is for. */
 	buf->f_namelen = BTRFS_NAME_LEN;
-	buf->f_blocks = btrfs_super_total_bytes(disk_super) >> bits;
-	buf->f_bfree = buf->f_blocks - (total_used >> bits);
-	buf->f_bavail = buf->f_blocks - (total_used_data >> bits);
+	buf->f_blocks = (pool_free + data_avail - metadata_fuzz) >> bits;
+	buf->f_bfree = buf->f_blocks - (data_used >> bits);
+	buf->f_bavail = buf->f_bfree;
 	buf->f_bsize = dentry->d_sb->s_blocksize;
 	buf->f_type = BTRFS_SUPER_MAGIC;

-- 
1.7.0.4
