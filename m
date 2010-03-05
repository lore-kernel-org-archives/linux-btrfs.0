From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make df be a little bit more understandable
Date: Fri, 5 Mar 2010 16:59:21 -0500
Message-ID: <20100305215921.GC15771@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The way we report df usage is way confusing for everybody, including some other
utilities (bacula for one).  So this patch makes df a little bit more
understandable.  First we make used actually count the total amount of used
space in all space info's.  This will give us a real view of how much disk space
is in use.  Second, for blocks available, only count data space.  This makes
things like bacula work because it says 0 when you can no longer write anymore
data to the disk.  I think this is a nice compromise, since you will end up with
something like the following

[root@alpha ~]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup-lv_root
                      148G   30G  111G  21% /
/dev/sda1             194M  116M   68M  64% /boot
tmpfs                 985M   12K  985M   1% /dev/shm
/dev/mapper/VolGroup-LogVol02
                      145G  140G     0 100% /mnt/btrfs-test

Compare this with btrfsctl -i output

[root@alpha btrfs-progs-unstable]# ./btrfsctl -i /mnt/btrfs-test/
Metadata, DUP: total=4.62GB, used=2.46GB
System, DUP: total=8.00MB, used=24.00KB
Data: total=134.80GB, used=134.80GB
Metadata: total=8.00MB, used=0.00
System: total=4.00MB, used=0.00
operation complete

This way we show that there is no more data space to be used, but we have
another 5GB of space left for metadata.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/super.c |   29 ++++++++++++++++++++++++++---
 1 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8a1ea6e..26681e3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -623,14 +623,37 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct btrfs_root *root = btrfs_sb(dentry->d_sb);
 	struct btrfs_super_block *disk_super = &root->fs_info->super_copy;
+	struct list_head *head = &root->fs_info->space_info;
+	struct btrfs_space_info *found;
+	u64 total_used = 0;
+	u64 data_used = 0;
 	int bits = dentry->d_sb->s_blocksize_bits;
 	__be32 *fsid = (__be32 *)root->fs_info->fsid;
 
+	rcu_read_lock();
+	list_for_each_entry_rcu(found, head, list) {
+		if (found->flags & (BTRFS_BLOCK_GROUP_DUP|
+				    BTRFS_BLOCK_GROUP_RAID10|
+				    BTRFS_BLOCK_GROUP_RAID1)) {
+			total_used += found->bytes_used;
+			if (found->flags & BTRFS_BLOCK_GROUP_DATA)
+				data_used += found->bytes_used;
+			else
+				data_used += found->total_bytes;
+		}
+
+		total_used += found->bytes_used;
+		if (found->flags & BTRFS_BLOCK_GROUP_DATA)
+			data_used += found->bytes_used;
+		else
+			data_used += found->total_bytes;
+	}
+	rcu_read_unlock();
+
 	buf->f_namelen = BTRFS_NAME_LEN;
 	buf->f_blocks = btrfs_super_total_bytes(disk_super) >> bits;
-	buf->f_bfree = buf->f_blocks -
-		(btrfs_super_bytes_used(disk_super) >> bits);
-	buf->f_bavail = buf->f_bfree;
+	buf->f_bfree = buf->f_blocks - (total_used >> bits);
+	buf->f_bavail = buf->f_blocks - (data_used >> bits);
 	buf->f_bsize = dentry->d_sb->s_blocksize;
 	buf->f_type = BTRFS_SUPER_MAGIC;
 
-- 
1.6.5.rc2

