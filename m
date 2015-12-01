Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53935 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754451AbbLAKxv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 05:53:51 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 1936B40427C6
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Dec 2015 18:53:43 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: Fix no_space in write and rm loop
Date: Tue, 1 Dec 2015 18:51:53 +0800
Message-ID: <8fc5de8c2a2a3bea83818f970f649a9024725cfa.1448967099.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I see no_space in v4.4-rc1 again in xfstests generic/102.
It happened randomly in some node only.
(one of 4 phy-node, and a kvm with non-virtio block driver)

By bisect, we can found the first-bad is:
 commit bdced438acd8 ("block: setup bi_phys_segments after splitting")'
But above patch only triggered the bug by making bio operation
faster(or slower).

Main reason is in our space_allocating code, we need to commit
page writeback before wait it complish, this patch fixed above
bug.

BTW, there is another reason for generic/102 fail, caused by
disable default mixed-blockgroup, I'll fix it in xfstests.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index acf3ed1..ab85393 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4086,8 +4086,10 @@ commit_trans:
 		    !atomic_read(&root->fs_info->open_ioctl_trans)) {
 			need_commit--;
 
-			if (need_commit > 0)
+			if (need_commit > 0) {
+				btrfs_start_delalloc_roots(fs_info, 0, -1);
 				btrfs_wait_ordered_roots(fs_info, -1);
+			}
 
 			trans = btrfs_join_transaction(root);
 			if (IS_ERR(trans))
-- 
1.8.5.1



