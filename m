From: David Sterba <dave@jikos.cz>
Subject: Warnings and crash
Date: Tue, 1 Nov 2011 13:56:55 +0100
Message-ID: <20111101125654.GF12759@twin.jikos.cz>
References: <20111101024957.GH4468@shiny>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111101024957.GH4468@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

the related source pointers of the warnings and crash (detailed below):

[ 1186.540073] WARNING: at fs/btrfs/extent-tree.c:5837 btrfs_alloc_free_block+0x337/0x350 [btrfs]()
[ 1186.541076] WARNING: at fs/btrfs/extent-tree.c:4617 __btrfs_free_extent+0x60d/0x6c0 [btrfs]()
[ 1186.541234] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 1186.541237] IP: [<ffffffffa005b881>] map_private_extent_buffer+0x21/0x1f0 [btrfs]


fs/btrfs/extent-tree.c:5837

This not a new warning, also known as 'the warn in use_block_rsv', happened
during xfstests/224.

The ratelimited printk patch (btrfs: ratelimit WARN_ON in use_block_rsv) is
part of the btrfs-next-stable branch pulled in, though is still meant as a
safety not to hang the box completely (and should go away in the future).

[ 1186.529033] btrfs: block rsv returned -28
[ 1186.534256] ------------[ cut here ]------------
[ 1186.540073] WARNING: at fs/btrfs/extent-tree.c:5837 btrfs_alloc_free_block+0x337/0x350 [btrfs]()
[ 1186.540075] Hardware name: Santa Rosa platform
[ 1186.540077] Modules linked in: btrfs aoe
[ 1186.540082] Pid: 5007, comm: btrfs-transacti Not tainted 3.1.0-default+ #64
[ 1186.540084] Call Trace:
[ 1186.540091]  [<ffffffff81057fdf>] warn_slowpath_common+0x7f/0xc0
[ 1186.540095]  [<ffffffff8105803a>] warn_slowpath_null+0x1a/0x20
[ 1186.540104]  [<ffffffffa002a9d7>] btrfs_alloc_free_block+0x337/0x350 [btrfs]
[ 1186.540109]  [<ffffffff810913dd>] ? trace_hardirqs_off+0xd/0x10
[ 1186.540113]  [<ffffffff810098d5>] ? native_sched_clock+0x15/0x70
[ 1186.540118]  [<ffffffff810844ff>] ? local_clock+0x6f/0x80
[ 1186.540126]  [<ffffffffa0017162>] __btrfs_cow_block+0x152/0x800 [btrfs]
[ 1186.540130]  [<ffffffff810844ff>] ? local_clock+0x6f/0x80
[ 1186.540133]  [<ffffffff810916fd>] ? lock_release_holdtime+0x3d/0x1a0
[ 1186.540141]  [<ffffffffa0017ae1>] btrfs_cow_block+0x2d1/0x410 [btrfs]
[ 1186.540150]  [<ffffffffa001cb88>] btrfs_search_slot+0x728/0xe70 [btrfs]
[ 1186.540159]  [<ffffffffa0022f0b>] lookup_inline_extent_backref+0x8b/0x480 [btrfs]
[ 1186.540168]  [<ffffffffa00245f0>] __btrfs_free_extent+0xd0/0x6c0 [btrfs]
[ 1186.540172]  [<ffffffff813628be>] ? do_raw_spin_unlock+0x5e/0xb0
[ 1186.540182]  [<ffffffffa00287cf>] run_clustered_refs+0x21f/0x850 [btrfs]
[ 1186.540192]  [<ffffffffa0028ec8>] btrfs_run_delayed_refs+0xc8/0x220 [btrfs]
[ 1186.540195]  [<ffffffff813628be>] ? do_raw_spin_unlock+0x5e/0xb0
[ 1186.540205]  [<ffffffffa0029178>] btrfs_write_dirty_block_groups+0x158/0x540 [btrfs]
[ 1186.540216]  [<ffffffffa0038ee5>] commit_cowonly_roots+0x115/0x1e0 [btrfs]
[ 1186.540228]  [<ffffffffa0039ee7>] btrfs_commit_transaction+0x477/0x8f0 [btrfs]
[ 1186.540240]  [<ffffffffa00391a9>] ? join_transaction+0x69/0x2b0 [btrfs]
[ 1186.540243]  [<ffffffff8107d480>] ? wake_up_bit+0x40/0x40
[ 1186.540254]  [<ffffffffa0032a1b>] transaction_kthread+0x28b/0x2a0 [btrfs]
[ 1186.540264]  [<ffffffffa0032790>] ? btree_readpage+0x30/0x30 [btrfs]
[ 1186.540267]  [<ffffffff8107cf16>] kthread+0xa6/0xb0
[ 1186.540272]  [<ffffffff81a1ea04>] kernel_thread_helper+0x4/0x10
[ 1186.540276]  [<ffffffff81a15334>] ? retint_restore_args+0x13/0x13
[ 1186.540279]  [<ffffffff8107ce70>] ? __init_kthread_worker+0x70/0x70
[ 1186.540282]  [<ffffffff81a1ea00>] ? gs_change+0x13/0x13
[ 1186.540284] ---[ end trace 6fa3da5fd65420af ]---
[ 1186.540433] btrfs: block rsv returned -28

ratelimited, I see just 2 occurences before, followed by

[ 1186.541076] WARNING: at fs/btrfs/extent-tree.c:4617 __btrfs_free_extent+0x60d/0x6c0 [btrfs]()
[ 1186.541079] Hardware name: Santa Rosa platform
[ 1186.541080] Modules linked in: btrfs aoe
[ 1186.541084] Pid: 5007, comm: btrfs-transacti Tainted: G        W   3.1.0-default+ #64
[ 1186.541086] Call Trace:
[ 1186.541089]  [<ffffffff81057fdf>] warn_slowpath_common+0x7f/0xc0
[ 1186.541093]  [<ffffffff8105803a>] warn_slowpath_null+0x1a/0x20
[ 1186.541101]  [<ffffffffa0024b2d>] __btrfs_free_extent+0x60d/0x6c0 [btrfs]
[ 1186.541105]  [<ffffffff813628be>] ? do_raw_spin_unlock+0x5e/0xb0
[ 1186.541114]  [<ffffffffa0028949>] run_clustered_refs+0x399/0x850 [btrfs]
[ 1186.541126]  [<ffffffffa0079800>] ? btrfs_find_ref_cluster+0xb0/0x1a0 [btrfs]
[ 1186.541136]  [<ffffffffa0028ec8>] btrfs_run_delayed_refs+0xc8/0x220 [btrfs]
[ 1186.541139]  [<ffffffff813628be>] ? do_raw_spin_unlock+0x5e/0xb0
[ 1186.541149]  [<ffffffffa0029178>] btrfs_write_dirty_block_groups+0x158/0x540 [btrfs]
[ 1186.541160]  [<ffffffffa0038ee5>] commit_cowonly_roots+0x115/0x1e0 [btrfs]
[ 1186.541172]  [<ffffffffa0039ee7>] btrfs_commit_transaction+0x477/0x8f0 [btrfs]
[ 1186.541183]  [<ffffffffa00391a9>] ? join_transaction+0x69/0x2b0 [btrfs]
[ 1186.541186]  [<ffffffff8107d480>] ? wake_up_bit+0x40/0x40
[ 1186.541196]  [<ffffffffa0032a1b>] transaction_kthread+0x28b/0x2a0 [btrfs]
[ 1186.541207]  [<ffffffffa0032790>] ? btree_readpage+0x30/0x30 [btrfs]
[ 1186.541210]  [<ffffffff8107cf16>] kthread+0xa6/0xb0
[ 1186.541213]  [<ffffffff81a1ea04>] kernel_thread_helper+0x4/0x10
[ 1186.541216]  [<ffffffff81a15334>] ? retint_restore_args+0x13/0x13
[ 1186.541219]  [<ffffffff8107ce70>] ? __init_kthread_worker+0x70/0x70
[ 1186.541222]  [<ffffffff81a1ea00>] ? gs_change+0x13/0x13
[ 1186.541224] ---[ end trace 6fa3da5fd65420b1 ]---
[ 1186.541076] WARNING: at fs/btrfs/extent-tree.c:4617 __btrfs_free_extent+0x60d/0x6c0 [btrfs]()
[ 1186.541079] Hardware name: Santa Rosa platform
[ 1186.541080] Modules linked in: btrfs aoe
[ 1186.541084] Pid: 5007, comm: btrfs-transacti Tainted: G        W   3.1.0-default+ #64
[ 1186.541086] Call Trace:
[ 1186.541089]  [<ffffffff81057fdf>] warn_slowpath_common+0x7f/0xc0
[ 1186.541093]  [<ffffffff8105803a>] warn_slowpath_null+0x1a/0x20
[ 1186.541101]  [<ffffffffa0024b2d>] __btrfs_free_extent+0x60d/0x6c0 [btrfs]
[ 1186.541105]  [<ffffffff813628be>] ? do_raw_spin_unlock+0x5e/0xb0
[ 1186.541114]  [<ffffffffa0028949>] run_clustered_refs+0x399/0x850 [btrfs]
[ 1186.541126]  [<ffffffffa0079800>] ? btrfs_find_ref_cluster+0xb0/0x1a0 [btrfs]
[ 1186.541136]  [<ffffffffa0028ec8>] btrfs_run_delayed_refs+0xc8/0x220 [btrfs]
[ 1186.541139]  [<ffffffff813628be>] ? do_raw_spin_unlock+0x5e/0xb0
[ 1186.541149]  [<ffffffffa0029178>] btrfs_write_dirty_block_groups+0x158/0x540 [btrfs]
[ 1186.541160]  [<ffffffffa0038ee5>] commit_cowonly_roots+0x115/0x1e0 [btrfs]
[ 1186.541172]  [<ffffffffa0039ee7>] btrfs_commit_transaction+0x477/0x8f0 [btrfs]
[ 1186.541183]  [<ffffffffa00391a9>] ? join_transaction+0x69/0x2b0 [btrfs]
[ 1186.541186]  [<ffffffff8107d480>] ? wake_up_bit+0x40/0x40
[ 1186.541196]  [<ffffffffa0032a1b>] transaction_kthread+0x28b/0x2a0 [btrfs]
[ 1186.541207]  [<ffffffffa0032790>] ? btree_readpage+0x30/0x30 [btrfs]
[ 1186.541210]  [<ffffffff8107cf16>] kthread+0xa6/0xb0
[ 1186.541213]  [<ffffffff81a1ea04>] kernel_thread_helper+0x4/0x10
[ 1186.541216]  [<ffffffff81a15334>] ? retint_restore_args+0x13/0x13
[ 1186.541219]  [<ffffffff8107ce70>] ? __init_kthread_worker+0x70/0x70
[ 1186.541222]  [<ffffffff81a1ea00>] ? gs_change+0x13/0x13
[ 1186.541224] ---[ end trace 6fa3da5fd65420b1 ]---

4615         } else {
4616                 btrfs_print_leaf(extent_root, path->nodes[0]);
4617                 WARN_ON(1);
4618                 printk(KERN_ERR "btrfs unable to find ref byte nr %llu "
4619                        "parent %llu root %llu  owner %llu offset %llu\n",
4620                        (unsigned long long)bytenr,
4621                        (unsigned long long)parent,
4622                        (unsigned long long)root_objectid,
4623                        (unsigned long long)owner_objectid,
4624                        (unsigned long long)owner_offset);
4625         }


[ 1186.541227] btrfs unable to find ref byte nr 428474368 parent 0 root 7  owner 0 offset 0
[ 1186.541234] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 1186.541237] IP: [<ffffffffa005b881>] map_private_extent_buffer+0x21/0x1f0 [btrfs]
[ 1186.541250] PGD 51ece067 PUD 6425d067 PMD 0
[ 1186.541253] Oops: 0000 [#1] SMP
[ 1186.541257] CPU 0
[ 1186.541258] Modules linked in: btrfs aoe
[ 1186.541261]
[ 1186.541263] Pid: 5007, comm: btrfs-transacti Tainted: G        W   3.1.0-default+ #64 Intel Corporation Santa Rosa platform/Matanzas
[ 1186.541268] RIP: 0010:[<ffffffffa005b881>]  [<ffffffffa005b881>] map_private_extent_buffer+0x21/0x1f0 [btrfs]
[ 1186.541281] RSP: 0018:ffff8800795d1960  EFLAGS: 00010286
[ 1186.541283] RAX: 0000000000000000 RBX: 0000000000000065 RCX: ffff8800795d19d0
[ 1186.541285] RDX: 0000000000000004 RSI: 000000000000007a RDI: 0000000000000000
[ 1186.541288] RBP: ffff8800795d19b0 R08: ffff8800795d19c8 R09: ffff8800795d19c0
[ 1186.541290] R10: 0000000000000001 R11: 0000000000000001 R12: 000000000000007a
[ 1186.541292] R13: 0000000000000000 R14: 0000000000000065 R15: 0000000000000000
[ 1186.541295] FS:  0000000000000000(0000) GS:ffff88007c000000(0000) knlGS:0000000000000000
[ 1186.541297] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1186.541300] CR2: 0000000000000000 CR3: 000000006a578000 CR4: 00000000000006f0
[ 1186.541302] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1186.541304] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1186.541307] Process btrfs-transacti (pid: 5007, threadinfo ffff8800795d0000, task ffff88007a00c880)
[ 1186.541309] Stack:
[ 1186.541310]  ffff8800795d1970 00ffffff00000003 ffff8800795d19b0 ffff880078da6520
[ 1186.541314]  0000000000000000 0000000000000065 000000000000007a 0000000000000000
[ 1186.541318]  0000000000000065 0000000000000000 ffff8800795d1a00 ffffffffa0050dfc
[ 1186.541322] Call Trace:
[ 1186.541335]  [<ffffffffa0050dfc>] btrfs_item_size+0x3c/0x90 [btrfs]
[ 1186.541344]  [<ffffffffa0024755>] __btrfs_free_extent+0x235/0x6c0 [btrfs]
[ 1186.541348]  [<ffffffff813628be>] ? do_raw_spin_unlock+0x5e/0xb0
[ 1186.541357]  [<ffffffffa0028949>] run_clustered_refs+0x399/0x850 [btrfs]
[ 1186.541369]  [<ffffffffa0079800>] ? btrfs_find_ref_cluster+0xb0/0x1a0 [btrfs]
[ 1186.541378]  [<ffffffffa0028ec8>] btrfs_run_delayed_refs+0xc8/0x220 [btrfs]
[ 1186.541382]  [<ffffffff813628be>] ? do_raw_spin_unlock+0x5e/0xb0
[ 1186.541391]  [<ffffffffa0029178>] btrfs_write_dirty_block_groups+0x158/0x540 [btrfs]
[ 1186.541402]  [<ffffffffa0038ee5>] commit_cowonly_roots+0x115/0x1e0 [btrfs]
[ 1186.541414]  [<ffffffffa0039ee7>] btrfs_commit_transaction+0x477/0x8f0 [btrfs]
[ 1186.541425]  [<ffffffffa00391a9>] ? join_transaction+0x69/0x2b0 [btrfs]
[ 1186.541428]  [<ffffffff8107d480>] ? wake_up_bit+0x40/0x40
[ 1186.541439]  [<ffffffffa0032a1b>] transaction_kthread+0x28b/0x2a0 [btrfs]
[ 1186.541449]  [<ffffffffa0032790>] ? btree_readpage+0x30/0x30 [btrfs]
[ 1186.541452]  [<ffffffff8107cf16>] kthread+0xa6/0xb0
[ 1186.541456]  [<ffffffff81a1ea04>] kernel_thread_helper+0x4/0x10
[ 1186.541459]  [<ffffffff81a15334>] ? retint_restore_args+0x13/0x13
[ 1186.541462]  [<ffffffff8107ce70>] ? __init_kthread_worker+0x70/0x70
[ 1186.541464]  [<ffffffff81a1ea00>] ? gs_change+0x13/0x13
[ 1186.541466] Code: 55 90 e9 b6 fc ff ff 0f 1f 00 55 48 89 e5 48 83 ec 50 48 89 5d d8 4c 89 65 e0 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 66 66 66 66 90 <4c> 8b 37 49 89 cd 4c 89 cb 41 81 e6 ff 0f 00 00 4a 8d 04 36 48
[ 1186.541493] RIP  [<ffffffffa005b881>] map_private_extent_buffer+0x21/0x1f0 [btrfs]
[ 1186.541506]  RSP <ffff8800795d1960>
[ 1186.541507] CR2: 0000000000000000
[ 1187.258581] ---[ end trace 6fa3da5fd65420b2 ]---


david
