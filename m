Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39944 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324AbaHAXMt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 19:12:49 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/12] btrfs: factor btrfs_alloc_workqueues() out of open_ctree()
Date: Fri,  1 Aug 2014 18:12:44 -0500
Message-Id: <1406934766-16974-11-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/disk-io.c |  144 ++++++++++++++++++++++++++++------------------------
 1 files changed, 77 insertions(+), 67 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 31e9791..0465d43 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2307,6 +2307,80 @@ static int btrfs_setup_super(struct super_block *sb,
 	return 0;
 }
 
+static int btrfs_alloc_workqueues(struct btrfs_fs_info *fs_info,
+				  struct btrfs_fs_devices *fs_devices)
+{
+	int max_active = fs_info->thread_pool_size;
+	int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
+
+	fs_info->workers =
+		btrfs_alloc_workqueue("worker", flags | WQ_HIGHPRI,
+				      max_active, 16);
+	fs_info->delalloc_workers =
+		btrfs_alloc_workqueue("delalloc", flags, max_active, 2);
+
+	fs_info->flush_workers =
+		btrfs_alloc_workqueue("flush_delalloc", flags, max_active, 0);
+
+	fs_info->caching_workers =
+		btrfs_alloc_workqueue("cache", flags, max_active, 0);
+
+	/*
+	 * a higher idle thresh on the submit workers makes it much more
+	 * likely that bios will be send down in a sane order to the
+	 * devices
+	 */
+	fs_info->submit_workers =
+		btrfs_alloc_workqueue("submit", flags,
+				      min_t(u64, fs_devices->num_devices,
+					    max_active), 64);
+	fs_info->fixup_workers =
+		btrfs_alloc_workqueue("fixup", flags, 1, 0);
+	/*
+	 * endios are largely parallel and should have a very
+	 * low idle thresh
+	 */
+	fs_info->endio_workers =
+		btrfs_alloc_workqueue("endio", flags, max_active, 4);
+	fs_info->endio_meta_workers =
+		btrfs_alloc_workqueue("endio-meta", flags, max_active, 4);
+	fs_info->endio_meta_write_workers =
+		btrfs_alloc_workqueue("endio-meta-write", flags, max_active, 2);
+	fs_info->endio_raid56_workers =
+		btrfs_alloc_workqueue("endio-raid56", flags, max_active, 4);
+	fs_info->rmw_workers =
+		btrfs_alloc_workqueue("rmw", flags, max_active, 2);
+	fs_info->endio_write_workers =
+		btrfs_alloc_workqueue("endio-write", flags, max_active, 2);
+	fs_info->endio_freespace_worker =
+		btrfs_alloc_workqueue("freespace-write", flags, max_active, 0);
+	fs_info->delayed_workers =
+		btrfs_alloc_workqueue("delayed-meta", flags, max_active, 0);
+	fs_info->readahead_workers =
+		btrfs_alloc_workqueue("readahead", flags, max_active, 2);
+	fs_info->qgroup_rescan_workers =
+		btrfs_alloc_workqueue("qgroup-rescan", flags, 1, 0);
+	fs_info->extent_workers =
+		btrfs_alloc_workqueue("extent-refs", flags,
+				      min_t(u64, fs_devices->num_devices,
+					    max_active), 8);
+
+	if (!(fs_info->workers && fs_info->delalloc_workers &&
+	      fs_info->submit_workers && fs_info->flush_workers &&
+	      fs_info->endio_workers && fs_info->endio_meta_workers &&
+	      fs_info->endio_meta_write_workers &&
+	      fs_info->endio_write_workers && fs_info->endio_raid56_workers &&
+	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
+	      fs_info->caching_workers && fs_info->readahead_workers &&
+	      fs_info->fixup_workers && fs_info->delayed_workers &&
+	      fs_info->fixup_workers && fs_info->extent_workers &&
+	      fs_info->qgroup_rescan_workers)) {
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -2334,7 +2408,6 @@ int open_ctree(struct super_block *sb,
 	int num_backups_tried = 0;
 	int backup_index = 0;
 	int max_active;
-	int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
 	bool create_uuid_tree;
 	bool check_uuid_tree;
 
@@ -2582,72 +2655,9 @@ int open_ctree(struct super_block *sb,
 
 	max_active = fs_info->thread_pool_size;
 
-	fs_info->workers =
-		btrfs_alloc_workqueue("worker", flags | WQ_HIGHPRI,
-				      max_active, 16);
-
-	fs_info->delalloc_workers =
-		btrfs_alloc_workqueue("delalloc", flags, max_active, 2);
-
-	fs_info->flush_workers =
-		btrfs_alloc_workqueue("flush_delalloc", flags, max_active, 0);
-
-	fs_info->caching_workers =
-		btrfs_alloc_workqueue("cache", flags, max_active, 0);
-
-	/*
-	 * a higher idle thresh on the submit workers makes it much more
-	 * likely that bios will be send down in a sane order to the
-	 * devices
-	 */
-	fs_info->submit_workers =
-		btrfs_alloc_workqueue("submit", flags,
-				      min_t(u64, fs_devices->num_devices,
-					    max_active), 64);
-
-	fs_info->fixup_workers =
-		btrfs_alloc_workqueue("fixup", flags, 1, 0);
-
-	/*
-	 * endios are largely parallel and should have a very
-	 * low idle thresh
-	 */
-	fs_info->endio_workers =
-		btrfs_alloc_workqueue("endio", flags, max_active, 4);
-	fs_info->endio_meta_workers =
-		btrfs_alloc_workqueue("endio-meta", flags, max_active, 4);
-	fs_info->endio_meta_write_workers =
-		btrfs_alloc_workqueue("endio-meta-write", flags, max_active, 2);
-	fs_info->endio_raid56_workers =
-		btrfs_alloc_workqueue("endio-raid56", flags, max_active, 4);
-	fs_info->rmw_workers =
-		btrfs_alloc_workqueue("rmw", flags, max_active, 2);
-	fs_info->endio_write_workers =
-		btrfs_alloc_workqueue("endio-write", flags, max_active, 2);
-	fs_info->endio_freespace_worker =
-		btrfs_alloc_workqueue("freespace-write", flags, max_active, 0);
-	fs_info->delayed_workers =
-		btrfs_alloc_workqueue("delayed-meta", flags, max_active, 0);
-	fs_info->readahead_workers =
-		btrfs_alloc_workqueue("readahead", flags, max_active, 2);
-	fs_info->qgroup_rescan_workers =
-		btrfs_alloc_workqueue("qgroup-rescan", flags, 1, 0);
-	fs_info->extent_workers =
-		btrfs_alloc_workqueue("extent-refs", flags,
-				      min_t(u64, fs_devices->num_devices,
-					    max_active), 8);
-
-	if (!(fs_info->workers && fs_info->delalloc_workers &&
-	      fs_info->submit_workers && fs_info->flush_workers &&
-	      fs_info->endio_workers && fs_info->endio_meta_workers &&
-	      fs_info->endio_meta_write_workers &&
-	      fs_info->endio_write_workers && fs_info->endio_raid56_workers &&
-	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
-	      fs_info->caching_workers && fs_info->readahead_workers &&
-	      fs_info->fixup_workers && fs_info->delayed_workers &&
-	      fs_info->fixup_workers && fs_info->extent_workers &&
-	      fs_info->qgroup_rescan_workers)) {
-		err = -ENOMEM;
+	ret = btrfs_alloc_workqueues(fs_info, fs_devices);
+	if (ret) {
+		err = ret;
 		goto fail_sb_buffer;
 	}
 
-- 
1.7.1

