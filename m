Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49467 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932810AbcI3PlI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Sep 2016 11:41:08 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] qgroup: Prevent qgroup->reserved from going subzero
Date: Fri, 30 Sep 2016 10:40:52 -0500
Message-Id: <20160930154052.6827-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

While free'ing qgroup->reserved resources, we much check if
the page has not been invalidated by a truncate operation
by checking if the page is still dirty before reducing the
qgroup resources. Resources in such a case are free'd when
the entire extent is released by delayed_ref.

This fixes a double accounting while releasing resources
in case of truncating a file, reproduced by the following testcase.

SCRATCH_DEV=/dev/vdb
SCRATCH_MNT=/mnt
mkfs.btrfs -f $SCRATCH_DEV
mount -t btrfs $SCRATCH_DEV $SCRATCH_MNT
cd $SCRATCH_MNT
btrfs quota enable $SCRATCH_MNT
btrfs subvolume create a
btrfs qgroup limit 500m a $SCRATCH_MNT
sync
for c in {1..15}; do
dd if=/dev/zero  bs=1M count=40 of=$SCRATCH_MNT/a/file;
done

sleep 10
sync
sleep 5

touch $SCRATCH_MNT/a/newfile

echo "Removing file"
rm $SCRATCH_MNT/a/file

Fixes: b9d0b38928 ("btrfs: Add handler for invalidate page")
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e6811c4..bc1a004 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8915,9 +8915,14 @@ again:
 	 *    So even we call qgroup_free_data(), it won't decrease reserved
 	 *    space.
 	 * 2) Not written to disk
-	 *    This means the reserved space should be freed here.
+	 *    This means the reserved space should be freed here. However,
+	 *    if a truncate invalidates the page (by clearing PageDirty)
+	 *    and the page is accounted for while allocating extent
+	 *    in btrfs_check_data_free_space() we let delayed_ref to
+	 *    free the entire extent.
 	 */
-	btrfs_qgroup_free_data(inode, page_start, PAGE_SIZE);
+	if (PageDirty(page))
+		btrfs_qgroup_free_data(inode, page_start, PAGE_SIZE);
 	if (!inode_evicting) {
 		clear_extent_bit(tree, page_start, page_end,
 				 EXTENT_LOCKED | EXTENT_DIRTY |
-- 
2.10.0

