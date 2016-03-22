Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758147AbcCVBiv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:38:51 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 83B2D405641B
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 09:37:56 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v8 22/27] btrfs: dedupe: Fix metadata balance error when dedupe is enabled
Date: Tue, 22 Mar 2016 09:35:47 +0800
Message-Id: <1458610552-9845-23-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A missing branch in btrfs_get_fs_root() is making dedupe_root read from
disk, and REF_COWS bit set.
This makes btrfs balance treating dedupe_root as fs root, and reusing the
old dedupe root bytenr to drop tree ref, causing the following kernel
warning after metadata balancing:

BTRFS error (device sdb6): unable to find ref byte nr 29736960 parent 0
root 11  owner 0 offset 0
------------[ cut here ]------------
WARNING: CPU: 1 PID: 19113 at fs/btrfs/extent-tree.c:6636
__btrfs_free_extent.isra.66+0xb6d/0xd20 [btrfs]()
BTRFS: Transaction aborted (error -2)
Modules linked in: btrfs(O) xor zlib_deflate raid6_pq xfs [last
unloaded: btrfs]
CPU: 1 PID: 19113 Comm: btrfs Tainted: G        W  O    4.5.0-rc5+ #2
Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox
12/01/2006
 0000000000000000 ffff880035b0ba18 ffffffff813771ff ffff880035b0ba60
 ffffffffa06a810a ffff880035b0ba50 ffffffff810bcb81 ffff88003c45c528
 0000000001c5c000 00000000fffffffe ffff88003dc8c520 0000000000000000
Call Trace:
 [<ffffffff813771ff>] dump_stack+0x67/0x98
 [<ffffffff810bcb81>] warn_slowpath_common+0x81/0xc0
 [<ffffffff810bcc07>] warn_slowpath_fmt+0x47/0x50
 [<ffffffffa06028fd>] __btrfs_free_extent.isra.66+0xb6d/0xd20 [btrfs]
 [<ffffffffa0606d4d>] __btrfs_run_delayed_refs.constprop.71+0x96d/0x1560
[btrfs]
 [<ffffffff81202ad9>] ? cmpxchg_double_slab.isra.68+0x149/0x160
 [<ffffffff81106a1d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa060a5ce>] btrfs_run_delayed_refs+0x8e/0x2d0 [btrfs]
 [<ffffffffa06209fe>] btrfs_commit_transaction+0x3e/0xb50 [btrfs]
 [<ffffffffa069f26e>] ? btrfs_dedupe_disable+0x28e/0x2c0 [btrfs]
 [<ffffffff812035c3>] ? kfree+0x223/0x270
 [<ffffffffa069f27a>] btrfs_dedupe_disable+0x29a/0x2c0 [btrfs]
 [<ffffffffa065e403>] btrfs_ioctl+0x2363/0x2a40 [btrfs]
 [<ffffffff8116b12a>] ? __audit_syscall_entry+0xaa/0xf0
 [<ffffffff81137ce6>] ? current_kernel_time64+0x56/0xa0
 [<ffffffff8122080e>] do_vfs_ioctl+0x8e/0x690
 [<ffffffff8116b12a>] ? __audit_syscall_entry+0xaa/0xf0
 [<ffffffff8122c181>] ? __fget_light+0x61/0x90
 [<ffffffff81220e84>] SyS_ioctl+0x74/0x80
 [<ffffffff8180ad57>] entry_SYSCALL_64_fastpath+0x12/0x6f
---[ end trace 618d5a5bc21d6a7c ]---

Fix it by adding corresponding branch for btrfs_get_fs_root().

Reported-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c    | 5 +++++
 fs/btrfs/relocation.c | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 44d098d..ec9fff3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1679,6 +1679,11 @@ struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
 	if (location->objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
 		return fs_info->free_space_root ? fs_info->free_space_root :
 						  ERR_PTR(-ENOENT);
+	if (location->objectid == BTRFS_DEDUPE_TREE_OBJECTID) {
+		if (fs_info->dedupe_enabled && fs_info->dedupe_info)
+			return fs_info->dedupe_info->dedupe_root;
+		return ERR_PTR(-ENOENT);
+	}
 again:
 	root = btrfs_lookup_fs_root(fs_info, location->objectid);
 	if (root) {
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 71a5cd0..74fd5d9 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -577,7 +577,8 @@ static int is_cowonly_root(u64 root_objectid)
 	    root_objectid == BTRFS_CSUM_TREE_OBJECTID ||
 	    root_objectid == BTRFS_UUID_TREE_OBJECTID ||
 	    root_objectid == BTRFS_QUOTA_TREE_OBJECTID ||
-	    root_objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
+	    root_objectid == BTRFS_FREE_SPACE_TREE_OBJECTID ||
+	    root_objectid == BTRFS_DEDUPE_TREE_OBJECTID)
 		return 1;
 	return 0;
 }
-- 
2.7.3



