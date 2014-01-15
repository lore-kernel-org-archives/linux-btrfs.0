Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51858 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaAOL7f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 06:59:35 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0FBxSMO003391
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 19:59:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] Btrfs: change the members' order of btrfs_space_info structure to reduce the cache miss
Date: Wed, 15 Jan 2014 20:00:54 +0800
Message-Id: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is better that the position of the lock is close to the data which is
protected by it, because they may be in the same cache line, we will load
less cache lines when we access them. So we rearrange the members' position
of btrfs_space_info structure to make the lock be closer to the its data.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 54ab861..1667c9a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1094,7 +1094,7 @@ struct btrfs_qgroup_limit_item {
 } __attribute__ ((__packed__));
 
 struct btrfs_space_info {
-	u64 flags;
+	spinlock_t lock;
 
 	u64 total_bytes;	/* total bytes in the space,
 				   this doesn't take mirrors into account */
@@ -1104,14 +1104,25 @@ struct btrfs_space_info {
 				   transaction finishes */
 	u64 bytes_reserved;	/* total bytes the allocator has reserved for
 				   current allocations */
-	u64 bytes_readonly;	/* total bytes that are read only */
-
 	u64 bytes_may_use;	/* number of bytes that may be used for
 				   delalloc/allocations */
+	u64 bytes_readonly;	/* total bytes that are read only */
+
+	unsigned int full:1;	/* indicates that we cannot allocate any more
+				   chunks for this space */
+	unsigned int chunk_alloc:1;	/* set if we are allocating a chunk */
+
+	unsigned int flush:1;		/* set if we are trying to make space */
+
+	unsigned int force_alloc;	/* set if we need to force a chunk
+					   alloc for this space */
+
 	u64 disk_used;		/* total bytes used on disk */
 	u64 disk_total;		/* total bytes on disk, takes mirrors into
 				   account */
 
+	u64 flags;
+
 	/*
 	 * bytes_pinned is kept in line with what is actually pinned, as in
 	 * we've called update_block_group and dropped the bytes_used counter
@@ -1124,21 +1135,11 @@ struct btrfs_space_info {
 	 */
 	struct percpu_counter total_bytes_pinned;
 
-	unsigned int full:1;	/* indicates that we cannot allocate any more
-				   chunks for this space */
-	unsigned int chunk_alloc:1;	/* set if we are allocating a chunk */
-
-	unsigned int flush:1;		/* set if we are trying to make space */
-
-	unsigned int force_alloc;	/* set if we need to force a chunk
-					   alloc for this space */
-
 	struct list_head list;
 
+	struct rw_semaphore groups_sem;
 	/* for block groups in our same type */
 	struct list_head block_groups[BTRFS_NR_RAID_TYPES];
-	spinlock_t lock;
-	struct rw_semaphore groups_sem;
 	wait_queue_head_t wait;
 };
 
-- 
1.8.3.1

