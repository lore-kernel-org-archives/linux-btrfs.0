Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45394 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360AbbGCUU6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jul 2015 16:20:58 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, stable@vger.kernel.org
Subject: [PATCH] Btrfs: fix list transaction->pending_ordered corruption
Date: Fri,  3 Jul 2015 20:46:40 +0100
Message-Id: <1435952800-23922-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

When we call btrfs_commit_transaction(), we splice the list "ordered"
of our transaction handle into the transaction's "pending_ordered"
list, but we don't reinitialize the "ordered" list of our transaction
handle, this means it still points to the same elements it used to
before the splice. Then we check if the current transaction's state
is >= TRANS_STATE_COMMIT_START and if it is we end up calling
btrfs_end_transaction() which simply splices again the "ordered" list
of our handle into the transaction's "pending_ordered" list, leaving
multiple pointers to the same ordered extents which results in list
corruption when we are iterating, removing and freeing ordered extents
at btrfs_wait_pending_ordered(), resulting in access to dangling
pointers / use-after-free issues.

This produces the following warning on a kernel with linked list
debugging enabled:

[109749.265416] ------------[ cut here ]------------
[109749.266410] WARNING: CPU: 7 PID: 324 at lib/list_debug.c:59 __list_del_entry+0x5a/0x98()
[109749.267969] list_del corruption. prev->next should be ffff8800ba087e20, but was fffffff8c1f7c35d
[109749.269760] Modules linked in: btrfs crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc loop fuse acpi_cpufreq psmouse parport_pc proc$
[109749.277766] CPU: 7 PID: 324 Comm: fsstress Not tainted 4.1.0-rc6-btrfs-next-11+ #2
[109749.279313] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 04/01/2014
[109749.282868]  0000000000000009 ffff88020852fc68 ffffffff8145f077 ffffffff81095de5
[109749.284411]  ffff88020852fcb8 ffff88020852fca8 ffffffff8104b3b0 0000000000000000
[109749.285952]  ffffffff81260642 ffff8800ba087e20 ffff8802087711c0 ffff880105146d20
[109749.287505] Call Trace:
[109749.288135]  [<ffffffff8145f077>] dump_stack+0x4f/0x7b
[109749.298080]  [<ffffffff81095de5>] ? console_unlock+0x356/0x3a2
[109749.331605]  [<ffffffff8104b3b0>] warn_slowpath_common+0xa1/0xbb
[109749.334849]  [<ffffffff81260642>] ? __list_del_entry+0x5a/0x98
[109749.337093]  [<ffffffff8104b410>] warn_slowpath_fmt+0x46/0x48
[109749.337847]  [<ffffffff81260642>] __list_del_entry+0x5a/0x98
[109749.338678]  [<ffffffffa053e8bf>] btrfs_wait_pending_ordered+0x46/0xdb [btrfs]
[109749.340145]  [<ffffffffa058a65f>] ? __btrfs_run_delayed_items+0x149/0x163 [btrfs]
[109749.348313]  [<ffffffffa054077d>] btrfs_commit_transaction+0x36b/0xa10 [btrfs]
[109749.349745]  [<ffffffff81087310>] ? trace_hardirqs_on+0xd/0xf
[109749.350819]  [<ffffffffa055370d>] btrfs_sync_file+0x36f/0x3fc [btrfs]
[109749.351976]  [<ffffffff8118ec98>] vfs_fsync_range+0x8f/0x9e
[109749.360341]  [<ffffffff8118ecc3>] vfs_fsync+0x1c/0x1e
[109749.368828]  [<ffffffff8118ee1d>] do_fsync+0x34/0x4e
[109749.369790]  [<ffffffff8118f045>] SyS_fsync+0x10/0x14
[109749.370925]  [<ffffffff81465197>] system_call_fastpath+0x12/0x6f
[109749.382274] ---[ end trace 48e0d07f7c03d95a ]---

On a non-debug kernel this leads to invalid memory accesses, causing a
crash. Fix this by using list_splice_init() instead of list_splice() in
btrfs_commit_transaction().

Cc: stable@vger.kernel.org
Fixes: 50d9aa99bd35 ("Btrfs: make sure logged extents complete in the current transaction V3"
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c0f18e7..3f1a03d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1866,7 +1866,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	}
 
 	spin_lock(&root->fs_info->trans_lock);
-	list_splice(&trans->ordered, &cur_trans->pending_ordered);
+	list_splice_init(&trans->ordered, &cur_trans->pending_ordered);
 	if (cur_trans->state >= TRANS_STATE_COMMIT_START) {
 		spin_unlock(&root->fs_info->trans_lock);
 		atomic_inc(&cur_trans->use_count);
-- 
2.1.3

