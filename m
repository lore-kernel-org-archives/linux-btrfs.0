Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36603 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaFJRNF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jun 2014 13:13:05 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so2940431wgh.11
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jun 2014 10:13:03 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix RCU correctness warning when running sanity tests
Date: Tue, 10 Jun 2014 19:12:41 +0100
Message-Id: <1402423961-12169-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When CONFIG_PROVE_RCU=y and CONFIG_PROVE_RCU_REPEATEDLY=y, the
following was dumped in dmesg:

[ 3197.218064] ===============================
[ 3197.218064] [ INFO: suspicious RCU usage. ]
[ 3197.218066] 3.15.0-rc8-fdm-btrfs-next-33+ #4 Not tainted
[ 3197.218067] -------------------------------
[ 3197.218068] include/linux/radix-tree.h:196 suspicious rcu_dereference_check() usage!
[ 3197.218068]
[ 3197.218068] other info that might help us debug this:
[ 3197.218068]
[ 3197.218070]
[ 3197.218070] rcu_scheduler_active = 1, debug_locks = 1
[ 3197.218071] 1 lock held by modprobe/12024:
[ 3197.218072]  #0:  (&(&fs_info->buffer_lock)->rlock){+.+...}, at: [<ffffffffa025c5fa>] btrfs_free_dummy_root+0x5a/0x1d0 [btrfs]
[ 3197.218093]
[ 3197.218093] stack backtrace:
[ 3197.218095] CPU: 3 PID: 12024 Comm: modprobe Not tainted 3.15.0-rc8-fdm-btrfs-next-33+ #4
[ 3197.218096] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 3197.218097]  0000000000000001 ffff8800af18fc18 ffffffff81685c5a 000000000000feb0
[ 3197.218099]  ffff8800cf6ccb40 ffff8800af18fc48 ffffffff810a6316 ffff8801d955f640
[ 3197.218101]  ffff8800d719e328 ffff8800d719e370 ffff8800d719c000 ffff8800af18fcb8
[ 3197.218102] Call Trace:
[ 3197.218105]  [<ffffffff81685c5a>] dump_stack+0x4e/0x68
[ 3197.218108]  [<ffffffff810a6316>] lockdep_rcu_suspicious+0xe6/0x130
[ 3197.218119]  [<ffffffffa025c728>] btrfs_free_dummy_root+0x188/0x1d0 [btrfs]
[ 3197.218129]  [<ffffffffa025f56a>] btrfs_test_qgroups+0xea/0x1bb [btrfs]
[ 3197.218137]  [<ffffffffa03a19d2>] ? ftrace_define_fields_btrfs_space_reservation+0xfd/0xfd [btrfs]
[ 3197.218144]  [<ffffffffa03a19d2>] ? ftrace_define_fields_btrfs_space_reservation+0xfd/0xfd [btrfs]
[ 3197.218151]  [<ffffffffa03a1ab7>] init_btrfs_fs+0xe5/0x184 [btrfs]
[ 3197.218154]  [<ffffffff81000352>] do_one_initcall+0x102/0x150
[ 3197.218157]  [<ffffffff8103d223>] ? set_memory_nx+0x43/0x50
[ 3197.218160]  [<ffffffff81682668>] ? set_section_ro_nx+0x6d/0x74
[ 3197.218162]  [<ffffffff810d91cc>] load_module+0x1cdc/0x2630
[ 3197.218164]  [<ffffffff810d4e90>] ? show_initstate+0x60/0x60
[ 3197.218166]  [<ffffffff810d9c9e>] SyS_finit_module+0x8e/0x90
[ 3197.218168]  [<ffffffff81698212>] system_call_fastpath+0x16/0x1b

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/tests/btrfs-tests.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index a5dcacb..bbbfec9 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -130,8 +130,8 @@ static void btrfs_free_dummy_fs_info(struct btrfs_fs_info *fs_info)
 	struct radix_tree_iter iter;
 	void **slot;
 
-	spin_lock(&fs_info->buffer_lock);
 restart:
+	rcu_read_lock();
 	radix_tree_for_each_slot(slot, &fs_info->buffer_radix, &iter, 0) {
 		struct extent_buffer *eb;
 
@@ -144,11 +144,11 @@ restart:
 				goto restart;
 			continue;
 		}
-		spin_unlock(&fs_info->buffer_lock);
+		rcu_read_unlock();
 		free_extent_buffer_stale(eb);
-		spin_lock(&fs_info->buffer_lock);
+		goto restart;
 	}
-	spin_unlock(&fs_info->buffer_lock);
+	rcu_read_unlock();
 
 	btrfs_free_qgroup_config(fs_info);
 	btrfs_free_fs_roots(fs_info);
-- 
1.9.1

