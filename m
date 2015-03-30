Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36665 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752911AbbC3R07 (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 30 Mar 2015 13:26:59 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, <stable@vger.kernel.org>
Subject: [PATCH] Btrfs: fix inode eviction infinite loop after extent_same ioctl
Date: Mon, 30 Mar 2015 18:26:47 +0100
Message-Id: <1427736407-29521-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we pass a length of 0 to the extent_same ioctl, we end up locking an
extent range with a start offset greater then its end offset (if the
destination file's offset is greater than zero). This results in a warning
from extent_io.c:insert_state through the following call chain:

  btrfs_extent_same()
    btrfs_double_lock()
      lock_extent_range()
        lock_extent(inode->io_tree, offset, offset + len - 1)
          lock_extent_bits()
            __set_extent_bit()
              insert_state()
                --> WARN_ON(end < start)

This leads to an infinite loop when evicting the inode. This is the same
problem that my previous patch titled
"Btrfs: fix inode eviction infinite loop after cloning into it" addressed
but for the extent_same ioctl instead of the clone ioctl.

CC: <stable@vger.kernel.org>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4c32350..09a566a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2897,6 +2897,9 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 len,
 	if (src == dst)
 		return -EINVAL;
 
+	if (len == 0)
+		return 0;
+
 	btrfs_double_lock(src, loff, dst, dst_loff, len);
 
 	ret = extent_same_check_offsets(src, loff, len);
-- 
2.1.3

