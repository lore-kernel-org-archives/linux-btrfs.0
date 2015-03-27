Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45943 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752093AbbC0KXE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Mar 2015 06:23:04 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2RAM01u021662
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2015 18:22:00 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: wait for delayed iputs on no space
Date: Fri, 27 Mar 2015 18:21:27 +0800
Message-ID: <2a18d8c0cec80a48662cfd33bf80f30e2e7b7058.1427450911.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1427450911.git.zhaolei@cn.fujitsu.com>
References: <cover.1427450911.git.zhaolei@cn.fujitsu.com>
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
index 6c1e211..94fb15f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3683,6 +3683,9 @@ commit_trans:
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

