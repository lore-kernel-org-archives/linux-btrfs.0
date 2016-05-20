Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42686 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbcETPIa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 11:08:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AC93F20357
	for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 15:08:28 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 10F942012D
	for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 15:08:26 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] Btrfs: fix race setting block group readonly during device replace
Date: Fri, 20 May 2016 05:44:47 +0100
Message-Id: <1463719487-1056-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

When we do a device replace, for each device extent we find from the
source device, we set the corresponding block group to readonly mode to
prevent writes into it from happening while we are copying the device
extent from the source to the target device. However just before we set
the block group to readonly mode some concurrent task might have already
allocated an extent from it or decided it could perform a nocow write
into one of its extents, which can make the device replace process to
miss copying an extent since it uses the extent tree's commit root to
search for extents and only once it finishes searching for all extents
belonging to the block group it does set the left cursor to the logical
end address of the block group - this is a problem if the respective
ordered extents finish while we are searching for extents using the
extent tree's commit root and no transaction commit happens while we
are iterating the tree, since it's the delayed references created by the
ordered extents (when they complete) that insert the extent items into
the extent tree (using the non-commit root of course).
Example:

          CPU 1                                            CPU 2

 btrfs_dev_replace_start()
   btrfs_scrub_dev()
     scrub_enumerate_chunks()
       --> finds device extent belonging
           to block group X

                               <transaction N starts>

                                                      starts buffered write
                                                      against some inode

                                                      writepages is run against
                                                      that inode forcing dellaloc
                                                      to run

                                                      btrfs_writepages()
                                                        extent_writepages()
                                                          extent_write_cache_pages()
                                                            __extent_writepage()
                                                              writepage_delalloc()
                                                                run_delalloc_range()
                                                                  cow_file_range()
                                                                    btrfs_reserve_extent()
                                                                      --> allocates an extent
                                                                          from block group X
                                                                          (which is not yet
                                                                           in RO mode)
                                                                    btrfs_add_ordered_extent()
                                                                      --> creates ordered extent Y
                                                        flush_epd_write_bio()
                                                          --> bio against the extent from
                                                              block group X is submitted

       btrfs_inc_block_group_ro(bg X)
         --> sets block group X to readonly

       scrub_chunk(bg X)
         scrub_stripe(device extent from srcdev)
           --> keeps searching for extent items
               belonging to the block group using
               the extent tree's commit root
           --> it never blocks due to
               fs_info->scrub_pause_req as no
               one tries to commit transaction N
           --> copies all extents found from the
               source device into the target device
           --> finishes search loop

                                                        bio completes

                                                        ordered extent Y completes
                                                        and creates delayed data
                                                        reference which will add an
                                                        extent item to the extent
                                                        tree when run (typically
                                                        at transaction commit time)

                                                          --> so the task doing the
                                                              scrub/device replace
                                                              at CPU 1 misses this
                                                              and does not copy this
                                                              extent into the new/target
                                                              device

       btrfs_dec_block_group_ro(bg X)
         --> turns block group X back to RW mode

       dev_replace->cursor_left is set to the
       logical end offset of block group X

So fix this by waiting for all cow and nocow writes after setting a block
group to readonly mode.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ordered-data.c |  6 +++++-
 fs/btrfs/ordered-data.h |  2 +-
 fs/btrfs/scrub.c        | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 5591704..e96634a 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -718,12 +718,13 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr,
 	return count;
 }
 
-void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr,
+int btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr,
 			      const u64 range_start, const u64 range_len)
 {
 	struct btrfs_root *root;
 	struct list_head splice;
 	int done;
+	int total_done = 0;
 
 	INIT_LIST_HEAD(&splice);
 
@@ -742,6 +743,7 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr,
 		done = btrfs_wait_ordered_extents(root, nr,
 						  range_start, range_len);
 		btrfs_put_fs_root(root);
+		total_done += done;
 
 		spin_lock(&fs_info->ordered_root_lock);
 		if (nr != -1) {
@@ -752,6 +754,8 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr,
 	list_splice_tail(&splice, &fs_info->ordered_roots);
 	spin_unlock(&fs_info->ordered_root_lock);
 	mutex_unlock(&fs_info->ordered_operations_mutex);
+
+	return total_done;
 }
 
 /*
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 8ef1262..700a594 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -199,7 +199,7 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 			   u32 *sum, int len);
 int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr,
 			       const u64 range_start, const u64 range_len);
-void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr,
+int btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr,
 			      const u64 range_start, const u64 range_len);
 void btrfs_get_logged_extents(struct inode *inode,
 			      struct list_head *logged_list,
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4678f03..a181b52 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3580,6 +3580,46 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		 */
 		scrub_pause_on(fs_info);
 		ret = btrfs_inc_block_group_ro(root, cache);
+		if (!ret && is_dev_replace) {
+			/*
+			 * If we are doing a device replace wait for any tasks
+			 * that started dellaloc right before we set the block
+			 * group to RO mode, as they might have just allocated
+			 * an extent from it or decided they could do a nocow
+			 * write. And if any such tasks did that, wait for their
+			 * ordered extents to complete and then commit the
+			 * current transaction, so that we can later see the new
+			 * extent items in the extent tree - the ordered extents
+			 * create delayed data references (for cow writes) when
+			 * they complete, which will be run and insert the
+			 * corresponding extent items into the extent tree when
+			 * we commit the transaction they used when running
+			 * inode.c:btrfs_finish_ordered_io(). We later use
+			 * the commit root of the extent tree to find extents
+			 * to copy from the srcdev into the tgtdev, and we don't
+			 * want to miss any new extents.
+			 */
+			btrfs_wait_block_group_reservations(cache);
+			btrfs_wait_nocow_writers(cache);
+			ret = btrfs_wait_ordered_roots(fs_info, -1,
+						       cache->key.objectid,
+						       cache->key.offset);
+			if (ret > 0) {
+				struct btrfs_trans_handle *trans;
+
+				trans = btrfs_join_transaction(root);
+				if (IS_ERR(trans))
+					ret = PTR_ERR(trans);
+				else
+					ret = btrfs_commit_transaction(trans,
+								       root);
+				if (ret) {
+					scrub_pause_off(fs_info);
+					btrfs_put_block_group(cache);
+					break;
+				}
+			}
+		}
 		scrub_pause_off(fs_info);
 
 		if (ret == 0) {
-- 
2.7.0.rc3

