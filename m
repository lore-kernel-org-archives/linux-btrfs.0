Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24362 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbaHZPPo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 11:15:44 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: toralf.foerster@gmx.de
Subject: [PATCH RFC] Btrfs: fix warning of insert_state() when doing lseek
Date: Tue, 26 Aug 2014 23:15:30 +0800
Message-Id: <1409066130-29948-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An user reported this, it is because that lseek's SEEK_SET/SEEK_CUR/SEEK_END
allow a negative value for @offset, but btrfs's SEEK_DATA/SEEK_HOLE don't
prepare for that and convert the negative @offset into unsigned type,
so we get (end < start) warning.

[ 1269.835374] ------------[ cut here ]------------
[ 1269.836809] WARNING: CPU: 0 PID: 1241 at fs/btrfs/extent_io.c:430 insert_state+0x11d/0x140()
[ 1269.838816] BTRFS: end < start 4094 18446744073709551615
[ 1269.840334] CPU: 0 PID: 1241 Comm: a.out Tainted: G        W      3.16.0+ #306
[ 1269.858229] Call Trace:
[ 1269.858612]  [<ffffffff81801a69>] dump_stack+0x4e/0x68
[ 1269.858952]  [<ffffffff8107894c>] warn_slowpath_common+0x8c/0xc0
[ 1269.859416]  [<ffffffff81078a36>] warn_slowpath_fmt+0x46/0x50
[ 1269.859929]  [<ffffffff813b0fbd>] insert_state+0x11d/0x140
[ 1269.860409]  [<ffffffff813b1396>] __set_extent_bit+0x3b6/0x4e0
[ 1269.860805]  [<ffffffff813b21c7>] lock_extent_bits+0x87/0x200
[ 1269.861697]  [<ffffffff813a5b28>] btrfs_file_llseek+0x148/0x2a0
[ 1269.862168]  [<ffffffff811f201e>] SyS_lseek+0xae/0xc0
[ 1269.862620]  [<ffffffff8180b212>] system_call_fastpath+0x16/0x1b
[ 1269.862970] ---[ end trace 4d33ea885832054b ]---

This adds a check for that, if we find the unsigned type @offset is greater
than inode's size, we get to skip trying to find extent maps.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1f2b99c..a370916 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2644,6 +2644,13 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int whence)
 	u64 len = i_size_read(inode);
 	int ret = 0;
 
+	/*
+	 * *offset can be negative, so start is greater than inode->i_size in
+	 * this case, and we can skip finding em.
+	 */
+	if (start >= inode->i_size)
+		goto out;
+
 	lockend = max_t(u64, root->sectorsize, lockend);
 	if (lockend <= lockstart)
 		lockend = lockstart + root->sectorsize;
@@ -2681,14 +2688,15 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int whence)
 		cond_resched();
 	}
 	free_extent_map(em);
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
+			     &cached_state, GFP_NOFS);
+out:
 	if (!ret) {
 		if (whence == SEEK_DATA && start >= inode->i_size)
 			ret = -ENXIO;
 		else
 			*offset = min_t(loff_t, start, inode->i_size);
 	}
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-			     &cached_state, GFP_NOFS);
 	return ret;
 }
 
-- 
1.8.1.4

