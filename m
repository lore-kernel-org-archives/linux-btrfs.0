Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44862 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750830AbbCMJUE (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 13 Mar 2015 05:20:04 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] Btrfs: add missing inode item update in fallocate()
Date: Thu, 12 Mar 2015 23:23:13 +0000
Message-Id: <1426202593-20067-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1426174618-929-1-git-send-email-fdmanana@suse.com>
References: <1426174618-929-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we fallocate(), without the keep size flag, into an area already covered
by an extent previously fallocated, we were updating the inode's i_size but
we weren't updating the inode item in the fs/subvol tree. A following umount
+ mount would result in a loss of the inode's size (and an fsync would miss
too the fact that the inode changed).

Reproducer:

  $ mkfs.btrfs -f /dev/sdd
  $ mount /dev/sdd /mnt
  $ fallocate -n -l 1M /mnt/foobar
  $ fallocate -l 512K /mnt/foobar
  $ umount /mnt
  $ mount /dev/sdd /mnt
  $ od -t x1 /mnt/foobar
  0000000

The expected result is:

  $ od -t x1 /mnt/foobar
  0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  *
  2000000

A test case for fstests follows soon.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Update the inode's sizes and ctime while holding a transaction
    open.

 fs/btrfs/file.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8f256b1..c261ff0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2677,23 +2677,34 @@ static long btrfs_fallocate(struct file *file, int mode,
 							1 << inode->i_blkbits,
 							offset + len,
 							&alloc_hint);
-
-			if (ret < 0) {
-				free_extent_map(em);
-				break;
-			}
 		} else if (actual_end > inode->i_size &&
 			   !(mode & FALLOC_FL_KEEP_SIZE)) {
+			struct btrfs_trans_handle *trans;
+
 			/*
 			 * We didn't need to allocate any more space, but we
 			 * still extended the size of the file so we need to
-			 * update i_size.
+			 * update i_size and the inode item.
 			 */
-			inode->i_ctime = CURRENT_TIME;
-			i_size_write(inode, actual_end);
-			btrfs_ordered_update_i_size(inode, actual_end, NULL);
+			trans = btrfs_start_transaction(root, 1);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+			} else {
+				inode->i_ctime = CURRENT_TIME;
+				i_size_write(inode, actual_end);
+				btrfs_ordered_update_i_size(inode, actual_end,
+							    NULL);
+				ret = btrfs_update_inode(trans, root, inode);
+				if (ret)
+					btrfs_end_transaction(trans, root);
+				else
+					ret = btrfs_end_transaction(trans,
+								    root);
+			}
 		}
 		free_extent_map(em);
+		if (ret < 0)
+			break;
 
 		cur_offset = last_byte;
 		if (cur_offset >= alloc_end) {
-- 
2.1.3

