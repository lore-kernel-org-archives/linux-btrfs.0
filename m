Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:48634 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab2HBLrH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 07:47:07 -0400
Date: Thu, 2 Aug 2012 13:46:31 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Seto Hidetoshi <seto.hidetoshi@jp.fujitsu.com>,
        David Sterba <dave@jikos.cz>
Subject: Re: [PATCH V3 2/2] Btrfs: fix the snapshot that should not exist
Message-ID: <20120802114631.GM17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <501A04CE.9090408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <501A04CE.9090408@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

appologies for late reply,

On Thu, Aug 02, 2012 at 12:40:46PM +0800, Miao Xie wrote:
> Changelog v1 -> v2:
> - add comment to explain why we need deal with the delayed items after
>   snapshot creation and why this operation do not corrupt the metadata.

I'm sorry, the comment did not fix the bug :)

The subvol stress is able to hit this:

[ 2360.444321] ------------[ cut here ]------------
[ 2360.448019] kernel BUG at fs/btrfs/extent-tree.c:6047!
[ 2360.448019] invalid opcode: 0000 [#1] SMP
[ 2360.448019] CPU 0
[ 2360.448019] Modules linked in: btrfs aoe [last unloaded: btrfs]
[ 2360.448019]
[ 2360.448019] Pid: 8212, comm: btrfs Not tainted 3.5.0-default+ #170 Intel Corporation Santa Rosa platform/Matanzas
[ 2360.448019] RIP: 0010:[<ffffffffa00f62a1>]  [<ffffffffa00f62a1>] run_clustered_refs+0xa11/0xa20 [btrfs]
[ 2360.448019] RSP: 0018:ffff88003eca1a68  EFLAGS: 00010246
[ 2360.448019] RAX: 00000000000007ff RBX: ffff880017a694c8 RCX: ffff88003eca1a08
[ 2360.448019] RDX: ffff880028aa9000 RSI: 00000000000007fe RDI: ffff880064223cf0
[ 2360.448019] RBP: ffff88003eca1b48 R08: 00000000000007ff R09: ffff88003eca19f8
[ 2360.448019] R10: ffff88002435d1e8 R11: 0000000000000000 R12: ffff880025d66d28
[ 2360.448019] R13: ffff880038640000 R14: ffff8800778dfa88 R15: ffff880060f010d0
[ 2360.448019] FS:  00007f3289f35740(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
[ 2360.448019] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2360.448019] CR2: ffffffffff600400 CR3: 000000002e112000 CR4: 00000000000007f0
[ 2360.448019] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2360.448019] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2360.448019] Process btrfs (pid: 8212, threadinfo ffff88003eca0000, task ffff88001d834200)
[ 2360.448019] Stack:
[ 2360.448019]  0000000000000000 0000000000000000 0000000000000001 0000000000000000
[ 2360.448019]  00000000000007ed ffff88002435d1e8 000000003eca1b18 0000000000000000
[ 2360.448019]  0000000000000770 0000000000000000 000000005cb1e000 ffff88003eca1c08
[ 2360.448019] Call Trace:
[ 2360.448019]  [<ffffffffa00f6479>] btrfs_run_delayed_refs+0x1c9/0x550 [btrfs]
[ 2360.448019]  [<ffffffff810a4d15>] ? trace_hardirqs_on_caller+0x155/0x1d0
[ 2360.448019]  [<ffffffffa00e306a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[ 2360.448019]  [<ffffffffa015c741>] ? btrfs_run_delayed_items+0xf1/0x160 [btrfs]
[ 2360.448019]  [<ffffffffa0108a15>] btrfs_commit_transaction+0x605/0xb00 [btrfs]
[ 2360.448019]  [<ffffffff8109e70d>] ? lock_release_holdtime+0x3d/0x1c0
[ 2360.448019]  [<ffffffffa013fc88>] ? btrfs_mksubvol+0x298/0x360 [btrfs]
[ 2360.448019]  [<ffffffff8106d210>] ? wake_up_bit+0x40/0x40
[ 2360.448019]  [<ffffffff8137d88e>] ? do_raw_spin_unlock+0x5e/0xb0
[ 2360.448019]  [<ffffffffa013fd48>] btrfs_mksubvol+0x358/0x360 [btrfs]
[ 2360.448019]  [<ffffffffa013fe5a>] btrfs_ioctl_snap_create_transid+0x10a/0x190 [btrfs]
[ 2360.448019]  [<ffffffffa014005d>] btrfs_ioctl_snap_create_v2.clone.0+0xfd/0x110 [btrfs]
[ 2360.448019]  [<ffffffffa01419ee>] btrfs_ioctl+0x48e/0x1340 [btrfs]
[ 2360.448019]  [<ffffffff818f0f00>] ? do_page_fault+0x2d0/0x580
[ 2360.448019]  [<ffffffff818eca70>] ? _raw_spin_unlock_irq+0x30/0x50
[ 2360.448019]  [<ffffffff81078463>] ? finish_task_switch+0x83/0xf0
[ 2360.448019]  [<ffffffff81161d08>] do_vfs_ioctl+0x98/0x560
[ 2360.448019]  [<ffffffff818ed215>] ? retint_swapgs+0x13/0x1b
[ 2360.448019]  [<ffffffff8116221f>] sys_ioctl+0x4f/0x80
[ 2360.448019]  [<ffffffff818f56e9>] system_call_fastpath+0x16/0x1b
[ 2360.448019] Code: 8b 76 40 48 89 d7 48 89 55 a0 e8 2b 74 ff ff 83 f8 17 0f 87 1e ff ff ff 0f 0b 80 fa b2 0f 84 b4 f8 ff ff 0f 0b 0f 0b 0f 0b 0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 0f 1f 80 00 00 00 00 55 48 89 e5 41 57
[ 2360.448019] RIP  [<ffffffffa00f62a1>] run_clustered_refs+0xa11/0xa20 [btrfs]
[ 2360.448019]  RSP <ffff88003eca1a68>
[ 2360.814508] ---[ end trace 555a16cac3620ccb ]---
[ 2360.820398] note: btrfs[8212] exited with preempt_count 1
[ 2360.827072] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[ 2360.836047] in_atomic(): 1, irqs_disabled(): 0, pid: 8212, name: btrfs
[ 2360.843859] INFO: lockdep is turned off.
[ 2360.849021] Pid: 8212, comm: btrfs Tainted: G      D      3.5.0-default+ #170
[ 2360.849022] Call Trace:
[ 2360.849027]  [<ffffffff8107a40c>] __might_sleep+0xfc/0x130
[ 2360.849030]  [<ffffffff818ea0f6>] down_read+0x26/0xa0
[ 2360.849034]  [<ffffffff810b416b>] acct_collect+0x4b/0x1b0
[ 2360.849038]  [<ffffffff8104c838>] do_exit+0x718/0x9a0
[ 2360.849041]  [<ffffffff81049a26>] ? kmsg_dump+0x26/0x140
[ 2360.849043]  [<ffffffff818ee0c0>] oops_end+0xb0/0xf0
[ 2360.849046]  [<ffffffff81005a7b>] die+0x5b/0x90
[ 2360.849048]  [<ffffffff818ed9a4>] do_trap+0xc4/0x170
[ 2360.849052]  [<ffffffff810030a5>] do_invalid_op+0x95/0xb0
[ 2360.849067]  [<ffffffffa00f62a1>] ? run_clustered_refs+0xa11/0xa20 [btrfs]
[ 2360.849071]  [<ffffffff813779dd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 2360.849073]  [<ffffffff818ed260>] ? restore_args+0x30/0x30
[ 2360.849076]  [<ffffffff818f674b>] invalid_op+0x1b/0x20
[ 2360.849087]  [<ffffffffa00f62a1>] ? run_clustered_refs+0xa11/0xa20 [btrfs]
[ 2360.849097]  [<ffffffffa00f5f2b>] ? run_clustered_refs+0x69b/0xa20 [btrfs]
[ 2360.849108]  [<ffffffffa00f6479>] btrfs_run_delayed_refs+0x1c9/0x550 [btrfs]
[ 2360.849110]  [<ffffffff810a4d15>] ? trace_hardirqs_on_caller+0x155/0x1d0
[ 2360.849119]  [<ffffffffa00e306a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[ 2360.849133]  [<ffffffffa015c741>] ? btrfs_run_delayed_items+0xf1/0x160 [btrfs]
[ 2360.849145]  [<ffffffffa0108a15>] btrfs_commit_transaction+0x605/0xb00 [btrfs]
[ 2360.849148]  [<ffffffff8109e70d>] ? lock_release_holdtime+0x3d/0x1c0
[ 2360.849161]  [<ffffffffa013fc88>] ? btrfs_mksubvol+0x298/0x360 [btrfs]
[ 2360.849164]  [<ffffffff8106d210>] ? wake_up_bit+0x40/0x40
[ 2360.849166]  [<ffffffff8137d88e>] ? do_raw_spin_unlock+0x5e/0xb0
[ 2360.849180]  [<ffffffffa013fd48>] btrfs_mksubvol+0x358/0x360 [btrfs]
[ 2360.849194]  [<ffffffffa013fe5a>] btrfs_ioctl_snap_create_transid+0x10a/0x190 [btrfs]
[ 2360.849207]  [<ffffffffa014005d>] btrfs_ioctl_snap_create_v2.clone.0+0xfd/0x110 [btrfs]
[ 2360.849221]  [<ffffffffa01419ee>] btrfs_ioctl+0x48e/0x1340 [btrfs]
[ 2360.849224]  [<ffffffff818f0f00>] ? do_page_fault+0x2d0/0x580
[ 2360.849226]  [<ffffffff818eca70>] ? _raw_spin_unlock_irq+0x30/0x50
[ 2360.849229]  [<ffffffff81078463>] ? finish_task_switch+0x83/0xf0
[ 2360.849231]  [<ffffffff81161d08>] do_vfs_ioctl+0x98/0x560
[ 2360.849234]  [<ffffffff818ed215>] ? retint_swapgs+0x13/0x1b
[ 2360.849236]  [<ffffffff8116221f>] sys_ioctl+0x4f/0x80
[ 2360.849239]  [<ffffffff818f56e9>] system_call_fastpath+0x16/0x1b
[ 2360.849255] BUG: scheduling while atomic: btrfs/8212/0x10000002
[ 2360.849256] INFO: lockdep is turned off.
[ 2360.849257] Modules linked in: btrfs aoe [last unloaded: btrfs]
[ 2360.849261] Pid: 8212, comm: btrfs Tainted: G      D      3.5.0-default+ #170
[ 2360.849262] Call Trace:
[ 2360.849262]  [<ffffffff81078318>] __schedule_bug+0x68/0x90
[ 2360.849265]  [<ffffffff818eafcc>] __schedule+0x73c/0x810
[ 2360.849268]  [<ffffffff8107b48a>] __cond_resched+0x2a/0x40
[ 2360.849270]  [<ffffffff818eb121>] _cond_resched+0x31/0x40
[ 2360.849273]  [<ffffffff81128e13>] unmap_single_vma+0x493/0x750
[ 2360.849276]  [<ffffffff811100b0>] ? lru_deactivate_fn+0x1e0/0x1e0
[ 2360.849279]  [<ffffffff810a4be0>] ? trace_hardirqs_on_caller+0x20/0x1d0
[ 2360.849281]  [<ffffffff8112986c>] unmap_vmas+0x3c/0x60
[ 2360.849284]  [<ffffffff81130de1>] exit_mmap+0x81/0x140
[ 2360.849287]  [<ffffffff81043824>] mmput+0x74/0x130
[ 2360.849289]  [<ffffffff8104a520>] exit_mm+0x100/0x120
[ 2360.849292]  [<ffffffff8104c858>] do_exit+0x738/0x9a0
[ 2360.849294]  [<ffffffff81049a26>] ? kmsg_dump+0x26/0x140
[ 2360.849297]  [<ffffffff818ee0c0>] oops_end+0xb0/0xf0
[ 2360.849299]  [<ffffffff81005a7b>] die+0x5b/0x90
[ 2360.849301]  [<ffffffff818ed9a4>] do_trap+0xc4/0x170
[ 2360.849304]  [<ffffffff810030a5>] do_invalid_op+0x95/0xb0
[ 2360.849307]  [<ffffffffa00f62a1>] ? run_clustered_refs+0xa11/0xa20 [btrfs]
[ 2360.849317]  [<ffffffff813779dd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 2360.849320]  [<ffffffff818ed260>] ? restore_args+0x30/0x30
[ 2360.849322]  [<ffffffff818f674b>] invalid_op+0x1b/0x20
[ 2360.849325]  [<ffffffffa00f62a1>] ? run_clustered_refs+0xa11/0xa20 [btrfs]
[ 2360.849335]  [<ffffffffa00f5f2b>] ? run_clustered_refs+0x69b/0xa20 [btrfs]
[ 2360.849346]  [<ffffffffa00f6479>] btrfs_run_delayed_refs+0x1c9/0x550 [btrfs]
[ 2360.849356]  [<ffffffff810a4d15>] ? trace_hardirqs_on_caller+0x155/0x1d0
[ 2360.849358]  [<ffffffffa00e306a>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[ 2360.849367]  [<ffffffffa015c741>] ? btrfs_run_delayed_items+0xf1/0x160 [btrfs]
[ 2360.849380]  [<ffffffffa0108a15>] btrfs_commit_transaction+0x605/0xb00 [btrfs]
[ 2360.849393]  [<ffffffff8109e70d>] ? lock_release_holdtime+0x3d/0x1c0
[ 2360.849395]  [<ffffffffa013fc88>] ? btrfs_mksubvol+0x298/0x360 [btrfs]
[ 2360.849409]  [<ffffffff8106d210>] ? wake_up_bit+0x40/0x40
[ 2360.849411]  [<ffffffff8137d88e>] ? do_raw_spin_unlock+0x5e/0xb0
[ 2360.849413]  [<ffffffffa013fd48>] btrfs_mksubvol+0x358/0x360 [btrfs]
[ 2360.849427]  [<ffffffffa013fe5a>] btrfs_ioctl_snap_create_transid+0x10a/0x190 [btrfs]
[ 2360.849441]  [<ffffffffa014005d>] btrfs_ioctl_snap_create_v2.clone.0+0xfd/0x110 [btrfs]
[ 2360.849455]  [<ffffffffa01419ee>] btrfs_ioctl+0x48e/0x1340 [btrfs]
[ 2360.849469]  [<ffffffff818f0f00>] ? do_page_fault+0x2d0/0x580
[ 2360.849471]  [<ffffffff818eca70>] ? _raw_spin_unlock_irq+0x30/0x50
[ 2360.849473]  [<ffffffff81078463>] ? finish_task_switch+0x83/0xf0
[ 2360.849476]  [<ffffffff81161d08>] do_vfs_ioctl+0x98/0x560
[ 2360.849478]  [<ffffffff818ed215>] ? retint_swapgs+0x13/0x1b
[ 2360.849481]  [<ffffffff8116221f>] sys_ioctl+0x4f/0x80
[ 2360.849483]  [<ffffffff818f56e9>] system_call_fastpath+0x16/0x1b

fs/btrfs/extent-tree.c:6047

6046         if (parent > 0) {
6047                 BUG_ON(!(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
6048                 btrfs_set_extent_inline_ref_type(leaf, iref,
6049                                                  BTRFS_SHARED_BLOCK_REF_KEY);
6050                 btrfs_set_extent_inline_ref_offset(leaf, iref, parent);
6051         } else {
6052                 btrfs_set_extent_inline_ref_type(leaf, iref,
6053                                                  BTRFS_TREE_BLOCK_REF_KEY);
6054                 btrfs_set_extent_inline_ref_offset(leaf, iref, root_objectid);
6055         }


Currently for-linux hangs early during the test, so I applied V3 patches on top
of 3.5.

The filesystem is freshly created, the load is to simultaneously unpack large tar,
snapshot the fs, delete random snapshot, looped rm of the untarred dir. Crashes after
some minutes, reliably.

Fsck spits lots of errors:

ref mismatch on [1133031424 4096] extent item 1, found 0
Backref 1133031424 root 5 not referenced back 0x7d1f40
Incorrect global backref count on 1133031424 found 1 wanted 0
backpointer mismatch on [1133031424 4096]
owner ref check failed [1133031424 4096]

ref mismatch on [11213131776 16384] extent item 1, found 0
Incorrect local backref count on 11213131776 root 5 owner 34509 offset 0 found 0 wanted 1 back 0x1424d8e0
backpointer mismatch on [11213131776 16384]
owner ref check failed [11213131776 16384]

fs tree 260 refs 6 not found
        unresolved ref root 263 dir 256 index 4 namelen 14 name snap2748615355 error 600
        unresolved ref root 267 dir 256 index 4 namelen 14 name snap2748615355 error 600
        unresolved ref root 269 dir 256 index 4 namelen 14 name snap2748615355 error 600
        unresolved ref root 273 dir 256 index 4 namelen 14 name snap2748615355 error 600
        unresolved ref root 274 dir 256 index 4 namelen 14 name snap2748615355 error 600
        unresolved ref root 276 dir 256 index 4 namelen 14 name snap2748615355 error 600


I've asked Josef to pull those patches out of btrfs-next, feel free to send me any testing
version if you can't reproduce it on your side.


david
