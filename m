Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:43852 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbeCTGmn (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 20 Mar 2018 02:42:43 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 1/6] btrfs-progs: convert: Fix inline file extent creation condition
Date: Tue, 20 Mar 2018 14:42:24 +0800
Message-Id: <20180320064229.31493-2-wqu@suse.com>
In-Reply-To: <20180320064229.31493-1-wqu@suse.com>
References: <20180320064229.31493-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Bug]
On btrfs converted from ext*, one user reported the following kernel
warning:
 ------------[ cut here ]------------
 BTRFS: Transaction aborted (error -95)
 WARNING: CPU: 0 PID: 324 at fs/btrfs/inode.c:3042 btrfs_finish_ordered_io+0x7ab/0x850 [btrfs]
 Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
 RIP: 0010:btrfs_finish_ordered_io+0x7ab/0x850 [btrfs]
 ...
 Call Trace:
  normal_work_helper+0x39/0x370 [btrfs]
  process_one_work+0x1ce/0x410
  worker_thread+0x2b/0x3d0
  ? process_one_work+0x410/0x410
  kthread+0x113/0x130
  ? kthread_create_on_node+0x70/0x70
  ? do_syscall_64+0x74/0x190
  ? SyS_exit_group+0x10/0x10
  ret_from_fork+0x35/0x40
 ---[ end trace c8ed62ff6a525901 ]---
 BTRFS: error (device dm-2) in
btrfs_finish_ordered_io:3042: errno=-95 unknown
 BTRFS info (device dm-2): forced readonly
 BTRFS error (device dm-2): pending csums is 6447104

[Cause]
The call trace and the unique return value points to
__btrfs_drop_extents(), when we tries to drop pages of an inline extent,
we will trigger such -EOPNOTSUPP.

However kernel has limitation on the size of inline file extent
(sector size for ram size and sector size - 1for on-disk size),
btrfs-convert doesn't have the same limitation, resulting much larger
file extent.

The lack of correct inline extent size check dates back to 2008 when
btrfs-convert is added into btrfs-progs.

[Fix]
Fix the inline extent creation condition, not only using
BTRFS_MAX_INLINE_DATA_SIZE(), which is only the maximum size of inline
data according to nodesize, but also limit it against sector size.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 convert/source-ext2.c     | 2 +-
 convert/source-reiserfs.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/convert/source-ext2.c b/convert/source-ext2.c
index b1492c78693d..e13fbe00415a 100644
--- a/convert/source-ext2.c
+++ b/convert/source-ext2.c
@@ -310,7 +310,7 @@ static int ext2_create_file_extents(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto fail;
 	if ((convert_flags & CONVERT_FLAG_INLINE_DATA) && data.first_block == 0
-	    && data.num_blocks > 0
+	    && data.num_blocks > 0 && inode_size < sectorsize
 	    && inode_size <= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info)) {
 		u64 num_bytes = data.num_blocks * sectorsize;
 		u64 disk_bytenr = data.disk_block * sectorsize;
diff --git a/convert/source-reiserfs.c b/convert/source-reiserfs.c
index 39d6f0728bd3..eeb68d962c5d 100644
--- a/convert/source-reiserfs.c
+++ b/convert/source-reiserfs.c
@@ -376,7 +376,8 @@ static int reiserfs_convert_tail(struct btrfs_trans_handle *trans,
 	u64 isize;
 	int ret;
 
-	if (length >= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info))
+	if (length >= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info) ||
+	    length >= root->fs_info->sectorsize)
 		return convert_direct(trans, root, objectid, inode, body,
 				      length, offset, convert_flags);
 
-- 
2.16.2

