Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11951 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752818AbbDCMNr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 08:13:47 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t33CCdIV020623
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 20:12:39 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 8/9] btrfs: wait for delayed iputs on no space
Date: Fri, 3 Apr 2015 20:12:03 +0800
Message-ID: <621459f4188f83641cd2434144d620f2653512b1.1428062473.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1428062473.git.zhaolei@cn.fujitsu.com>
References: <cover.1428062473.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

btrfs will report no_space when we run following write and delete
file loop:
 # FILE_SIZE_M=[ 75% of fs space ]
 # DEV=[ some dev ]
 # MNT=[ some dir ]
 #
 # mkfs.btrfs -f "$DEV"
 # mount -o nodatacow "$DEV" "$MNT"
 # for ((i = 0; i < 100; i++)); do dd if=/dev/zero of="$MNT"/file0 bs=1M count="$FILE_SIZE_M"; rm -f "$MNT"/file0; done
 #

Reason:
 iput() and evict() is run after write pages to block device, if
 write pages work is not finished before next write, the "rm"ed space
 is not freed, and caused above bug.

Fix:
 We can add "-o flushoncommit" mount option to avoid above bug, but
 it have performance problem. Actually, we can to wait for on-the-fly
 writes only when no-space happened, it is which this patch do.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5683736..05747d2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3725,6 +3725,9 @@ commit_trans:
 		    !atomic_read(&root->fs_info->open_ioctl_trans)) {
 			need_commit--;
 
+			if (need_commit > 0)
+				btrfs_wait_ordered_roots(fs_info, -1);
+
 			trans = btrfs_join_transaction(root);
 			if (IS_ERR(trans))
 				return PTR_ERR(trans);
-- 
1.8.5.1

