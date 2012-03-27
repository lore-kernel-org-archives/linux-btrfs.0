From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 05/10][RESEND] Btrfs: fix recursive defragment with autodefrag option
Date: Tue, 27 Mar 2012 14:44:33 +0800
Message-ID: <1332830678-3992-6-git-send-email-liubo2009@cn.fujitsu.com>
References: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Reproduce:
$ mkfs.btrfs disk
$ mount disk /mnt -o autodefrag
$ dd if=/dev/zero of=/mnt/foobar bs=4k count=10 2>/dev/null && sync
$ for i in `seq 9 -2 0`; do dd if=/dev/zero of=/mnt/foobar bs=4k count=1 \
  seek=$i conv=notrunc 2> /dev/null; done && sync

then we'll get to defrag "foobar" again and again.
So does option "-o autodefrag,compress".

Reasons:
When the cleaner kthread gets to fetch inodes from the defrag tree and defrag
them, it will dirty pages and submit them, this will comes to another DATA COW
where the processing inode will be inserted to the defrag tree again.

This patch sets a rule for COW code, i.e. insert an inode when we're really
going to make some defragments.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 892b347..7f5018d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -344,8 +344,9 @@ static noinline int compress_file_range(struct inode *inode,
 	int will_compress;
 	int compress_type = root->fs_info->compress_type;
 
-	/* if this is a small write inside eof, kick off a defragbot */
-	if (end <= BTRFS_I(inode)->disk_i_size && (end - start + 1) < 16 * 1024)
+	/* if this is a small write inside eof, kick off a defrag */
+	if ((end - start + 1) < 16 * 1024 &&
+	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
 		btrfs_add_inode_defrag(NULL, inode);
 
 	actual_end = min_t(u64, isize, end + 1);
@@ -800,7 +801,8 @@ static noinline int cow_file_range(struct inode *inode,
 	ret = 0;
 
 	/* if this is a small write inside eof, kick off defrag */
-	if (end <= BTRFS_I(inode)->disk_i_size && num_bytes < 64 * 1024)
+	if (num_bytes < 64 * 1024 &&
+	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
 		btrfs_add_inode_defrag(trans, inode);
 
 	if (start == 0) {
-- 
1.6.5.2

