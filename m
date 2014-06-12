Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46212 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaFLAsB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 20:48:01 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so473559wgh.23
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jun 2014 17:47:59 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: fix qgroups sanity test crash or hang
Date: Thu, 12 Jun 2014 02:47:37 +0100
Message-Id: <1402537657-3172-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1402531956-27668-1-git-send-email-fdmanana@gmail.com>
References: <1402531956-27668-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Often when running the qgroups sanity test, a crash or a hang happened.
This is because the extent buffer the test uses for the root node doesn't
have an header level explicitly set, making it have a random level value.
This is a problem when it's not zero for the btrfs_search_slot() calls
the test ends up doing, resulting in crashes or hangs such as the following:

[ 6454.127192] Btrfs loaded, debug=on, assert=on, integrity-checker=on
(...)
[ 6454.127760] BTRFS: selftest: Running qgroup tests
[ 6454.127964] BTRFS: selftest: Running test_test_no_shared_qgroup
[ 6454.127966] BTRFS: selftest: Qgroup basic add
[ 6480.152005] BUG: soft lockup - CPU#0 stuck for 23s! [modprobe:5383]
[ 6480.152005] Modules linked in: btrfs(+) xor raid6_pq binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc i2c_piix4 i2c_core pcspkr evbug psmouse serio_raw e1000 [last unloaded: btrfs]
[ 6480.152005] irq event stamp: 188448
[ 6480.152005] hardirqs last  enabled at (188447): [<ffffffff8168ef5c>] restore_args+0x0/0x30
[ 6480.152005] hardirqs last disabled at (188448): [<ffffffff81698e6a>] apic_timer_interrupt+0x6a/0x80
[ 6480.152005] softirqs last  enabled at (188446): [<ffffffff810516cf>] __do_softirq+0x1cf/0x450
[ 6480.152005] softirqs last disabled at (188441): [<ffffffff81051c25>] irq_exit+0xb5/0xc0
[ 6480.152005] CPU: 0 PID: 5383 Comm: modprobe Not tainted 3.15.0-rc8-fdm-btrfs-next-33+ #4
[ 6480.152005] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 6480.152005] task: ffff8802146125a0 ti: ffff8800d0d00000 task.ti: ffff8800d0d00000
[ 6480.152005] RIP: 0010:[<ffffffff81349a63>]  [<ffffffff81349a63>] __write_lock_failed+0x13/0x20
[ 6480.152005] RSP: 0018:ffff8800d0d038e8  EFLAGS: 00000287
[ 6480.152005] RAX: 0000000000000000 RBX: ffffffff8168ef5c RCX: 000005deb8525852
[ 6480.152005] RDX: 0000000000000000 RSI: 0000000000001d45 RDI: ffff8802105000b8
[ 6480.152005] RBP: ffff8800d0d038e8 R08: fffffe12710f63db R09: ffffffffa03196fb
[ 6480.152005] R10: ffff8802146125a0 R11: ffff880214612e28 R12: ffff8800d0d03858
[ 6480.152005] R13: 0000000000000000 R14: ffff8800d0d00000 R15: ffff8802146125a0
[ 6480.152005] FS:  00007f14ff804700(0000) GS:ffff880215e00000(0000) knlGS:0000000000000000
[ 6480.152005] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6480.152005] CR2: 00007fff4df0dac8 CR3: 00000000d1796000 CR4: 00000000000006f0
[ 6480.152005] Stack:
[ 6480.152005]  ffff8800d0d03908 ffffffff810ae967 0000000000000001 ffff8802105000b8
[ 6480.152005]  ffff8800d0d03938 ffffffff8168e57e ffffffffa0319c16 0000000000000007
[ 6480.152005]  ffff880210500000 ffff880210500100 ffff8800d0d039b8 ffffffffa0319c16
[ 6480.152005] Call Trace:
[ 6480.152005]  [<ffffffff810ae967>] do_raw_write_lock+0x47/0xa0
[ 6480.152005]  [<ffffffff8168e57e>] _raw_write_lock+0x5e/0x80
[ 6480.152005]  [<ffffffffa0319c16>] ? btrfs_tree_lock+0x116/0x270 [btrfs]
[ 6480.152005]  [<ffffffffa0319c16>] btrfs_tree_lock+0x116/0x270 [btrfs]
[ 6480.152005]  [<ffffffffa02b2acb>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
[ 6480.152005]  [<ffffffffa02b81a6>] btrfs_search_slot+0x916/0xa20 [btrfs]
[ 6480.152005]  [<ffffffff811a727f>] ? create_object+0x23f/0x300
[ 6480.152005]  [<ffffffffa02b9958>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[ 6480.152005]  [<ffffffffa036041a>] insert_normal_tree_ref.constprop.4+0xa2/0x19a [btrfs]
[ 6480.152005]  [<ffffffffa03605c3>] test_no_shared_qgroup+0xb1/0x1ca [btrfs]
[ 6480.152005]  [<ffffffff8108cad6>] ? local_clock+0x16/0x30
[ 6480.152005]  [<ffffffffa035ef8e>] btrfs_test_qgroups+0x1ae/0x1d7 [btrfs]
[ 6480.152005]  [<ffffffffa03a69d2>] ? ftrace_define_fields_btrfs_space_reservation+0xfd/0xfd [btrfs]
[ 6480.152005]  [<ffffffffa03a6a86>] init_btrfs_fs+0xb4/0x153 [btrfs]
[ 6480.152005]  [<ffffffff81000352>] do_one_initcall+0x102/0x150
[ 6480.152005]  [<ffffffff8103d223>] ? set_memory_nx+0x43/0x50
[ 6480.152005]  [<ffffffff81682668>] ? set_section_ro_nx+0x6d/0x74
[ 6480.152005]  [<ffffffff810d91cc>] load_module+0x1cdc/0x2630
(...)

Therefore initialize the extent buffer as an empty leaf (level 0).

Issue easy to reproduce when btrfs is built as a module via:

    $ for ((i = 1; i <= 1000000; i++)); do rmmod btrfs; modprobe btrfs; done

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Fixed silly mistake. Set root->node's header level and nritems after
    checking if root->node is not null.

 fs/btrfs/tests/qgroup-tests.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index fa691b7..ec3dcb2 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -415,6 +415,8 @@ int btrfs_test_qgroups(void)
 		ret = -ENOMEM;
 		goto out;
 	}
+	btrfs_set_header_level(root->node, 0);
+	btrfs_set_header_nritems(root->node, 0);
 	root->alloc_bytenr += 8192;
 
 	tmp_root = btrfs_alloc_dummy_root();
-- 
1.9.1

