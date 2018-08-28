Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725976AbeH1JpA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 05:45:00 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 06516AEAE
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 05:54:58 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs: clone: Flush data before doing clone
Date: Tue, 28 Aug 2018 13:54:53 +0800
Message-Id: <20180828055453.2353-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Due to the limitation of btrfs_cross_ref_exist(), run_delalloc_nocow()
can still fall back to CoW even only (unrelated) part of the
preallocated extent is shared.

This makes the follow case to do unnecessary CoW:

 # xfs_io -f -c "falloc 0 2M" $mnt/file
 # xfs_io -c "pwrite 0 1M" $mnt/file
 # xfs_io -c "reflink $mnt/file 1M 4M 1M" $mnt/file
 # sync

The pwrite will still be CoWed, since at writeback time, the
preallocated extent is already shared, btrfs_cross_ref_exist() will
return 1 and make run_delalloc_nocow() fall back to cow_file_range().

This is definitely an overkilling workaround, but this should be the
simplest way without further screwing up already complex NOCOW routine.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/file.c  |  4 ++--
 fs/btrfs/ioctl.c | 21 +++++++++++++++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 53af9f5253f4..ddacc41ff124 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3228,6 +3228,7 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 			   struct btrfs_inode *inode);
 int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info);
 void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info);
+int btrfs_start_ordered_ops(struct inode *inode, loff_t start, loff_t end);
 int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync);
 void btrfs_drop_extent_cache(struct btrfs_inode *inode, u64 start, u64 end,
 			     int skip_pinned);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2be00e873e92..118bfd019c6c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1999,7 +1999,7 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static int start_ordered_ops(struct inode *inode, loff_t start, loff_t end)
+int btrfs_start_ordered_ops(struct inode *inode, loff_t start, loff_t end)
 {
 	int ret;
 	struct blk_plug plug;
@@ -2056,7 +2056,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * multi-task, and make the performance up.  See
 	 * btrfs_wait_ordered_range for an explanation of the ASYNC check.
 	 */
-	ret = start_ordered_ops(inode, start, end);
+	ret = btrfs_start_ordered_ops(inode, start, end);
 	if (ret)
 		goto out;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 63600dc2ac4c..866979f530bc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4266,6 +4266,27 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 			goto out_unlock;
 	}
 
+	/*
+	 * btrfs_cross_ref_exist() only does check at extent level,
+	 * we could cause unexpected NOCOW write to be COWed.
+	 * E.g.:
+	 * falloc 0 2M file1
+	 * pwrite 0 1M file1 (at this point it should go NOCOW)
+	 * reflink src=file1 srcoff=1M dst=file1 dstoff=4M len=1M
+	 * sync
+	 *
+	 * In above case, due to the preallocated extent is shared
+	 * the data at 0~1M can't go NOCOW.
+	 *
+	 * So flush the whole src inode to avoid any unneeded CoW.
+	 */
+	ret = btrfs_start_ordered_ops(src, 0, -1);
+	if (ret < 0)
+		goto out_unlock;
+	ret = btrfs_wait_ordered_range(src, 0, -1);
+	if (ret < 0)
+		goto out_unlock;
+
 	/*
 	 * Lock the target range too. Right after we replace the file extent
 	 * items in the fs tree (which now point to the cloned data), we might
-- 
2.18.0
