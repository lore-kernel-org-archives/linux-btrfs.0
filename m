From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC][PATCH 1/2] Btrfs: try to allocate new chunks with degenerated
 profile
Date: Tue, 17 Jan 2012 18:02:32 +0800
Message-ID: <4F154738.8000709@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If there is no free space, the free space allocator will try to get space from
the block group with the degenerated profile. For example, if there is no free
space in the RAID1 block groups, the allocator will try to allocate space from
the DUP block groups. And besides that, the space reservation has the similar
behaviour: if there is no enough space in the space cache to reserve, it will
reserve the space according to the disk space, and it just take mirror storage
into account, no RAID0, RAID1, or RAID10.

So we'd better make the behaviour of chunk allocation correspond with space
reservation and free space allocation, if there is no enough disk space to
allocate RAID(RAID0, RAID1, RAID10) chunks, we degenerate the profile and try
to allocate chunks again. Otherwise, enospc will happen though we reserve
the space successfully and BUG_ON() will be triggered.

Degenerating rule:
  RAID10 -> RAID1 -> DUP
  RAID0 -> SINGLE

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   43 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3e68e2b..87cd611 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3065,6 +3065,30 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	return flags;
 }
 
+/*
+ * Degenerate the alloc profile:
+ *   RAID10 -> RAID1 -> DUP
+ *   RAID0 -> SINGLE
+ *
+ * This is used when there is no enough disk space to do chunk allocation.
+ * After degenerating the profile, we will try to allocate new chunks again.
+ */
+static u64 btrfs_degenerate_alloc_profile(u64 flags)
+{
+	if (flags & BTRFS_BLOCK_GROUP_RAID10) {
+		flags &= ~BTRFS_BLOCK_GROUP_RAID10;
+		flags |= BTRFS_BLOCK_GROUP_RAID1;
+	} else if (flags & BTRFS_BLOCK_GROUP_RAID1) {
+		flags &= ~BTRFS_BLOCK_GROUP_RAID1;
+		flags |= BTRFS_BLOCK_GROUP_DUP;
+	} else if (flags & BTRFS_BLOCK_GROUP_RAID0) {
+		flags &= ~BTRFS_BLOCK_GROUP_RAID0;
+	} else
+		flags = ULLONG_MAX;
+
+	return flags;
+}
+
 static u64 get_alloc_profile(struct btrfs_root *root, u64 flags)
 {
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
@@ -3356,8 +3380,23 @@ again:
 	}
 
 	ret = btrfs_alloc_chunk(trans, extent_root, flags);
-	if (ret < 0 && ret != -ENOSPC)
-		goto out;
+	if (ret < 0) {
+		if (ret != -ENOSPC)
+			goto out;
+
+		/*
+		 * Degenerate the alloc profile:
+		 *   RAID10 -> RAID1 -> DUP
+		 *   RAID0 -> SINGLE
+		 * then we will try to allocate new chunks again. By this way,
+		 * we can utilize the whole disk spacem and make the behaviour
+		 * of the chunk allocation correspond with the space reservation
+		 * and the free space allocation.
+		 */
+		flags = btrfs_degenerate_alloc_profile(flags);
+		if (flags != ULLONG_MAX)
+			goto again;
+	}
 
 	spin_lock(&space_info->lock);
 	if (ret)
-- 
1.7.6.5
