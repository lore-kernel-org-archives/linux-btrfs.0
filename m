From: Dave Chinner <david@fromorbit.com>
Subject: Re: [3.2-rc7] slowdown, warning + oops creating lots of files
Date: Thu, 5 Jan 2012 09:11:05 +1100
Message-ID: <20120104221105.GF17026@dastard>
References: <20120104214445.GE17026@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120104214445.GE17026@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 05, 2012 at 08:44:45AM +1100, Dave Chinner wrote:
> Hi there buttery folks,
> 
> I just hit this warning and oops running a parallel fs_mark create
> workload on a test VM using a 17TB btrfs filesystem (12 disk dm
> RAID0) using default mkfs and mount parmeters, mounted on
> /mnt/scratch. The VM has 8p and 4GB RAM, and the fs_mark command
> line was:
> 
> $ ./fs_mark  -D  10000  -S0  -n  100000 -s  0  -L  250 \
> 	-d /mnt/scratch/0  -d /mnt/scratch/1 \
> 	-d /mnt/scratch/2  -d /mnt/scratch/3 \
> 	-d /mnt/scratch/4  -d /mnt/scratch/5 \
> 	-d /mnt/scratch/6  -d /mnt/scratch/7
> 
> The attached image should give you a better idea of the performance
> drop-off that was well under way when the crash occurred at about 96
> million files created.
> 
> I'm rerunning the test on a fresh filesystem, so I guess I'll see if
> this a one-off in the next couple of hours....

Looks to be reproducable. With a fresh filesystem performance was all
over the place from the start, and the warning/oops occurred at
about 43M files created. the failure stacks this time are:

[ 1490.841957] device fsid 4b7ec51b-9747-4244-a568-fbecdb157383 devid 1 transid 4 /dev/vdc
[ 1490.847408] btrfs: disk space caching is enabled
[ 3027.690722] ------------[ cut here ]------------
[ 3027.692612] WARNING: at fs/btrfs/extent-tree.c:4771 __btrfs_free_extent+0x630/0x6d0()
[ 3027.695607] Hardware name: Bochs
[ 3027.696968] Modules linked in:
[ 3027.697894] Pid: 3460, comm: fs_mark Not tainted 3.2.0-rc7-dgc+ #167
[ 3027.699581] Call Trace:
[ 3027.700452]  [<ffffffff8108a69f>] warn_slowpath_common+0x7f/0xc0
[ 3027.701973]  [<ffffffff8108a6fa>] warn_slowpath_null+0x1a/0x20
[ 3027.703480]  [<ffffffff815b0680>] __btrfs_free_extent+0x630/0x6d0
[ 3027.704981]  [<ffffffff815ac110>] ? block_group_cache_tree_search+0x90/0xc0
[ 3027.706368]  [<ffffffff815b42f1>] run_clustered_refs+0x381/0x800
[ 3027.707897]  [<ffffffff815b483a>] btrfs_run_delayed_refs+0xca/0x220
[ 3027.709347]  [<ffffffff815b8f1c>] ? btrfs_update_root+0x9c/0xe0
[ 3027.710909]  [<ffffffff815c3c33>] commit_cowonly_roots+0x33/0x1e0
[ 3027.712370]  [<ffffffff81ab168e>] ? _raw_spin_lock+0xe/0x20
[ 3027.713220]  [<ffffffff815c54cf>] btrfs_commit_transaction+0x3bf/0x840
[ 3027.714412]  [<ffffffff810ac420>] ? add_wait_queue+0x60/0x60
[ 3027.715460]  [<ffffffff815c5da4>] ? start_transaction+0x94/0x2b0
[ 3027.716790]  [<ffffffff815ac80c>] may_commit_transaction+0x6c/0x100
[ 3027.717843]  [<ffffffff815b2b47>] reserve_metadata_bytes.isra.71+0x5a7/0x660
[ 3027.719223]  [<ffffffff81073c23>] ? __wake_up+0x53/0x70
[ 3027.720328]  [<ffffffff815a43ba>] ? btrfs_free_path+0x2a/0x40
[ 3027.721511]  [<ffffffff815b2f9e>] btrfs_block_rsv_add+0x3e/0x70
[ 3027.722610]  [<ffffffff81666dfb>] ? security_d_instantiate+0x1b/0x30
[ 3027.723765]  [<ffffffff815c5f65>] start_transaction+0x255/0x2b0
[ 3027.725204]  [<ffffffff815c6283>] btrfs_start_transaction+0x13/0x20
[ 3027.726273]  [<ffffffff815d2236>] btrfs_create+0x46/0x220
[ 3027.727275]  [<ffffffff8116c204>] vfs_create+0xb4/0xf0
[ 3027.728344]  [<ffffffff8116e1d7>] do_last.isra.45+0x547/0x7c0
[ 3027.729400]  [<ffffffff8116f7ab>] path_openat+0xcb/0x3d0
[ 3027.730363]  [<ffffffff81ab168e>] ? _raw_spin_lock+0xe/0x20
[ 3027.731394]  [<ffffffff8117cc1e>] ? vfsmount_lock_local_unlock+0x1e/0x30
[ 3027.733077]  [<ffffffff8116fbd2>] do_filp_open+0x42/0xa0
[ 3027.733949]  [<ffffffff8117c487>] ? alloc_fd+0xf7/0x150
[ 3027.734911]  [<ffffffff8115f8e7>] do_sys_open+0xf7/0x1d0
[ 3027.735894]  [<ffffffff810b572a>] ? do_gettimeofday+0x1a/0x50
[ 3027.737304]  [<ffffffff8115f9e0>] sys_open+0x20/0x30
[ 3027.738099]  [<ffffffff81ab9502>] system_call_fastpath+0x16/0x1b
[ 3027.739199] ---[ end trace df586861a93ef3bf ]---
[ 3027.740348] btrfs unable to find ref byte nr 19982405632 parent 0 root 2  owner 0 offset 0
[ 3027.742001] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 3027.743502] IP: [<ffffffff815e60f2>] map_private_extent_buffer+0x12/0x150
[ 3027.744982] PGD 109d8e067 PUD 1050a9067 PMD 0
[ 3027.745968] Oops: 0000 [#1] SMP
[ 3027.745968] CPU 7
[ 3027.745968] Modules linked in:
[ 3027.745968]
[ 3027.745968] Pid: 3460, comm: fs_mark Tainted: G        W    3.2.0-rc7-dgc+ #167 Bochs Bochs
[ 3027.745968] RIP: 0010:[<ffffffff815e60f2>]  [<ffffffff815e60f2>] map_private_extent_buffer+0x12/0x150
[ 3027.745968] RSP: 0018:ffff8800d2ac36d8  EFLAGS: 00010296
[ 3027.745968] RAX: 0000000000000000 RBX: 0000000000000065 RCX: ffff8800d2ac3708
[ 3027.745968] RDX: 0000000000000004 RSI: 000000000000007a RDI: 0000000000000000
[ 3027.745968] RBP: ffff8800d2ac36f8 R08: ffff8800d2ac3710 R09: ffff8800d2ac3718
[ 3027.745968] R10: 0000000000000000 R11: 0000000000000001 R12: 000000000000007a
[ 3027.745968] R13: 0000000000000000 R14: 00000000ffffffe4 R15: 0000000000001000
[ 3027.745968] FS:  00007f3bf8ab5700(0000) GS:ffff88011fdc0000(0000) knlGS:0000000000000000
[ 3027.745968] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3027.745968] CR2: 00007fe424b0e000 CR3: 0000000106c33000 CR4: 00000000000006e0
[ 3027.745968] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3027.745968] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3027.745968] Process fs_mark (pid: 3460, threadinfo ffff8800d2ac2000, task ffff88006c81c100)
[ 3027.745968] Stack:
[ 3027.745968]  00000000ffffffe4 0000000000000065 000000000000007a 0000000000000000
[ 3027.745968]  ffff8800d2ac3748 ffffffff815db96c ffff8800d2ac3758 ffff8800d2ac3718
[ 3027.745968]  0000000000000002 00000004a70b5000 0000000000000000 ffff88010bf1a910
[ 3027.745968] Call Trace:
[ 3027.745968]  [<ffffffff815db96c>] btrfs_item_size+0x3c/0x90
[ 3027.745968]  [<ffffffff815b0282>] __btrfs_free_extent+0x232/0x6d0
[ 3027.745968]  [<ffffffff815ac110>] ? block_group_cache_tree_search+0x90/0xc0
[ 3027.745968]  [<ffffffff815b42f1>] run_clustered_refs+0x381/0x800
[ 3027.745968]  [<ffffffff815b483a>] btrfs_run_delayed_refs+0xca/0x220
[ 3027.745968]  [<ffffffff815b8f1c>] ? btrfs_update_root+0x9c/0xe0
[ 3027.745968]  [<ffffffff815c3c33>] commit_cowonly_roots+0x33/0x1e0
[ 3027.745968]  [<ffffffff81ab168e>] ? _raw_spin_lock+0xe/0x20
[ 3027.745968]  [<ffffffff815c54cf>] btrfs_commit_transaction+0x3bf/0x840
[ 3027.745968]  [<ffffffff810ac420>] ? add_wait_queue+0x60/0x60
[ 3027.745968]  [<ffffffff815c5da4>] ? start_transaction+0x94/0x2b0
[ 3027.745968]  [<ffffffff815ac80c>] may_commit_transaction+0x6c/0x100
[ 3027.745968]  [<ffffffff815b2b47>] reserve_metadata_bytes.isra.71+0x5a7/0x660
[ 3027.745968]  [<ffffffff81073c23>] ? __wake_up+0x53/0x70
[ 3027.745968]  [<ffffffff815a43ba>] ? btrfs_free_path+0x2a/0x40
[ 3027.745968]  [<ffffffff815b2f9e>] btrfs_block_rsv_add+0x3e/0x70
[ 3027.745968]  [<ffffffff81666dfb>] ? security_d_instantiate+0x1b/0x30
[ 3027.745968]  [<ffffffff815c5f65>] start_transaction+0x255/0x2b0
[ 3027.745968]  [<ffffffff815c6283>] btrfs_start_transaction+0x13/0x20
[ 3027.745968]  [<ffffffff815d2236>] btrfs_create+0x46/0x220
[ 3027.745968]  [<ffffffff8116c204>] vfs_create+0xb4/0xf0
[ 3027.745968]  [<ffffffff8116e1d7>] do_last.isra.45+0x547/0x7c0
[ 3027.745968]  [<ffffffff8116f7ab>] path_openat+0xcb/0x3d0
[ 3027.745968]  [<ffffffff81ab168e>] ? _raw_spin_lock+0xe/0x20
[ 3027.745968]  [<ffffffff8117cc1e>] ? vfsmount_lock_local_unlock+0x1e/0x30
[ 3027.745968]  [<ffffffff8116fbd2>] do_filp_open+0x42/0xa0
[ 3027.745968]  [<ffffffff8117c487>] ? alloc_fd+0xf7/0x150
[ 3027.745968]  [<ffffffff8115f8e7>] do_sys_open+0xf7/0x1d0
[ 3027.745968]  [<ffffffff810b572a>] ? do_gettimeofday+0x1a/0x50
[ 3027.745968]  [<ffffffff8115f9e0>] sys_open+0x20/0x30
[ 3027.745968]  [<ffffffff81ab9502>] system_call_fastpath+0x16/0x1b
[ 3027.745968] Code: 83 c0 01 48 89 85 78 ff ff ff e9 c0 fc ff ff 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 55 41 54 53 48 83 ec 08 66 66 66 66 90 <4c> 8b 27 48 89
[ 3027.745968] RIP  [<ffffffff815e60f2>] map_private_extent_buffer+0x12/0x150
[ 3027.745968]  RSP <ffff8800d2ac36d8>
[ 3027.745968] CR2: 0000000000000000
[ 3027.817725] ---[ end trace df586861a93ef3c0 ]---

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
