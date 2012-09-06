Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:50228 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab2IFU6M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 16:58:12 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id pevK4YytjlQlslRF (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 06 Sep 2012 14:58:11 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix our overcommit math
Date: Thu, 6 Sep 2012 17:03:35 -0400
Message-ID: <1346965415-12820-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed I was seeing large lags when running my torrent test in a vm on my
laptop.  While trying to make it lag less I noticed that our overcommit math
was taking into account the number of bytes we wanted to reclaim, not the
number of bytes we actually wanted to allocate, which means we wouldn't
overcommit as often.  This patch fixes the overcommit math and makes
shrink_delalloc() use that logic so that it will stop looping faster.  We
still have pretty high spikes of latency, but the test now takes 3 minutes
less time (about 5% faster).  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   70 ++++++++++++++++++++++++++++--------------------
 1 files changed, 41 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4bb546da..5f94ca2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3663,6 +3663,45 @@ out:
 	return ret;
 }
 
+static int can_overcommit(struct btrfs_root *root,
+			  struct btrfs_space_info *space_info, u64 bytes,
+			  int flush)
+{
+	u64 profile = btrfs_get_alloc_profile(root, 0);
+	u64 avail;
+	u64 used;
+
+	used = space_info->bytes_used + space_info->bytes_reserved +
+		space_info->bytes_pinned + space_info->bytes_readonly +
+		space_info->bytes_may_use;
+		spin_lock(&root->fs_info->free_chunk_lock);
+	avail = root->fs_info->free_chunk_space;
+
+	/*
+	 * If we have dup, raid1 or raid10 then only half of the free
+	 * space is actually useable.
+	 */
+	if (profile & (BTRFS_BLOCK_GROUP_DUP |
+		       BTRFS_BLOCK_GROUP_RAID1 |
+		       BTRFS_BLOCK_GROUP_RAID10))
+		avail >>= 1;
+
+	/*
+	 * If we aren't flushing don't let us overcommit too much, say
+	 * 1/8th of the space.  If we can flush, let it overcommit up to
+	 * 1/2 of the space.
+	 */
+	if (flush)
+		avail >>= 3;
+	else
+		avail >>= 1;
+	 spin_unlock(&root->fs_info->free_chunk_lock);
+
+	if (used + bytes < space_info->total_bytes + avail)
+		return 1;
+	return 0;
+}
+
 /*
  * shrink metadata reservation for delalloc
  */
@@ -3706,10 +3745,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 			  !atomic_read(&root->fs_info->async_delalloc_pages));
 
 		spin_lock(&space_info->lock);
-		if (space_info->bytes_used + space_info->bytes_reserved +
-		    space_info->bytes_pinned + space_info->bytes_readonly +
-		    space_info->bytes_may_use + orig <=
-		    space_info->total_bytes) {
+		if (can_overcommit(root, space_info, orig, !trans)) {
 			spin_unlock(&space_info->lock);
 			break;
 		}
@@ -3925,7 +3961,6 @@ again:
 	}
 
 	if (ret) {
-		u64 profile = btrfs_get_alloc_profile(root, 0);
 		u64 avail;
 
 		/*
@@ -3946,30 +3981,7 @@ again:
 			goto again;
 		}
 
-		spin_lock(&root->fs_info->free_chunk_lock);
-		avail = root->fs_info->free_chunk_space;
-
-		/*
-		 * If we have dup, raid1 or raid10 then only half of the free
-		 * space is actually useable.
-		 */
-		if (profile & (BTRFS_BLOCK_GROUP_DUP |
-			       BTRFS_BLOCK_GROUP_RAID1 |
-			       BTRFS_BLOCK_GROUP_RAID10))
-			avail >>= 1;
-
-		/*
-		 * If we aren't flushing don't let us overcommit too much, say
-		 * 1/8th of the space.  If we can flush, let it overcommit up to
-		 * 1/2 of the space.
-		 */
-		if (flush)
-			avail >>= 3;
-		else
-			avail >>= 1;
-		 spin_unlock(&root->fs_info->free_chunk_lock);
-
-		if (used + num_bytes < space_info->total_bytes + avail) {
+		if (can_overcommit(root, space_info, orig_bytes, flush)) {
 			space_info->bytes_may_use += orig_bytes;
 			trace_btrfs_space_reservation(root->fs_info,
 				"space_info", space_info->flags, orig_bytes, 1);
-- 
1.7.7.6

