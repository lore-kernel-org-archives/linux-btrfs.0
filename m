Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41033 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3EZNvV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 May 2013 09:51:21 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4QDpI4u007265
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:19 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4QDpKVt012184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:20 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4QDpJCS009883
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:19 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] Btrfs: fix use-after-free bug during umount
Date: Sun, 26 May 2013 21:50:27 +0800
Message-Id: <1369576231-17836-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1369576231-17836-1-git-send-email-bo.li.liu@oracle.com>
References: <1369576231-17836-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit be283b2e674a09457d4563729015adb637ce7cc1
(    Btrfs: use helper to cleanup tree roots) introduced the following bug,

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000034
 IP: [<ffffffffa039368c>] extent_buffer_get+0x4/0xa [btrfs]
[...]
 Pid: 2463, comm: btrfs-cache-1 Tainted: G           O 3.9.0+ #4 innotek GmbH VirtualBox/VirtualBox
 RIP: 0010:[<ffffffffa039368c>]  [<ffffffffa039368c>] extent_buffer_get+0x4/0xa [btrfs]
 Process btrfs-cache-1 (pid: 2463, threadinfo ffff880112d60000, task ffff880117679730)
[...]
 Call Trace:
  [<ffffffffa0398a99>] btrfs_search_slot+0x104/0x64d [btrfs]
  [<ffffffffa039aea4>] btrfs_next_old_leaf+0xa7/0x334 [btrfs]
  [<ffffffffa039b141>] btrfs_next_leaf+0x10/0x12 [btrfs]
  [<ffffffffa039ea13>] caching_thread+0x1a3/0x2e0 [btrfs]
  [<ffffffffa03d8811>] worker_loop+0x14b/0x48e [btrfs]
  [<ffffffffa03d86c6>] ? btrfs_queue_worker+0x25c/0x25c [btrfs]
  [<ffffffff81068d3d>] kthread+0x8d/0x95
  [<ffffffff81068cb0>] ? kthread_freezable_should_stop+0x43/0x43
  [<ffffffff8151e5ac>] ret_from_fork+0x7c/0xb0
  [<ffffffff81068cb0>] ? kthread_freezable_should_stop+0x43/0x43
RIP  [<ffffffffa039368c>] extent_buffer_get+0x4/0xa [btrfs]

We've free'ed commit_root before actually getting to free block groups where
caching thread needs valid extent_root->commit_root.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e7b3cb5..a5c8f28 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3512,10 +3512,10 @@ int close_ctree(struct btrfs_root *root)
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
 	}
 
-	free_root_pointers(fs_info, 1);
-
 	btrfs_free_block_groups(fs_info);
 
+	free_root_pointers(fs_info, 1);
+
 	del_fs_roots(fs_info);
 
 	iput(fs_info->btree_inode);
-- 
1.7.7

