From: Avi Kivity <avi.kivity@gmail.com>
Subject: Re: Suddenly, a dead filesystem
Date: Sat, 1 Oct 2011 00:40:06 +0300
Message-ID: <CAEbWairrpVkcnDb37O2dF+sQxnmmP7+N2sBd=-pdCNVOH9n8eg@mail.gmail.com>
References: <CAEbWaipxhyMf2VQRdfnpMcXwyf84YupLOm8hQRf4Q8wJu060ng@mail.gmail.com>
	<4E53B7DC.7020807@redhat.com>
	<CAEbWaipUPoO95kbmewfi1j=tBk5gv4Ui6yY8XSOpGHJH9KQpNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAEbWaipUPoO95kbmewfi1j=tBk5gv4Ui6yY8XSOpGHJH9KQpNQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 24, 2011 at 12:08 AM, Avi Kivity <avi.kivity@gmail.com> wro=
te:
>> This is fixed upstream, I've sent the patch to -stable so hopefully =
it
>> will show up in fedora soon, but in the meantime can you try Linus's
>> tree and verify that it fixes it? =A0Thanks,
>
> Thanks, it appears to be fixed (at least in a VM). =A0Will try native=
 soon.
>

It's back.  3.1-rc8:


[   24.431935] kernel BUG at fs/btrfs/tree-log.c:1690!
[   24.431935] invalid opcode: 0000 [#1] SMP
[   24.431935] CPU 0
[   24.431935] Modules linked in:
[   24.431935]
[   24.431935] Pid: 1, comm: swapper Not tainted 3.1.0-rc8+ #4 Bochs Bo=
chs
[   24.431935] RIP: 0010:[<ffffffff8127d8cc>]  [<ffffffff8127d8cc>]
replay_one_buffer+0x24c/0x330
[   24.431935] RSP: 0018:ffff8800078d7810  EFLAGS: 00010282
[   24.431935] RAX: 00000000fffffffb RBX: 0000000000000002 RCX: 0000000=
0fffb921b
[   24.431935] RDX: ffffffffffffff24 RSI: 0000000000000001 RDI: 0000000=
000000286
[   24.431935] RBP: ffff8800078d78b0 R08: ffff880006cabf18 R09: 9018000=
000000000
[   24.431935] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000=
000000097
[   24.431935] R13: ffff8800078d79b8 R14: ffff8800073755a0 R15: 0000000=
00000000c
[   24.431935] FS:  0000000000000000(0000) GS:ffff880007c00000(0000)
knlGS:0000000000000000
[   24.431935] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   24.431935] CR2: 0000000000000000 CR3: 0000000001a05000 CR4: 0000000=
0000006f0
[   24.431935] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[   24.431935] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[   24.431935] Process swapper (pid: 1, threadinfo ffff8800078d6000,
task ffff8800078d8000)
[   24.431935] Stack:
[   24.431935]  ffff8800078d785e ffff880007372090 ffff8800078d78a0
ffffffff8126b38d
[   24.431935]  ffff880007388000 ffff880006d0b000 ffff880007372120
ffff880006d0b400
[   24.431935]  0000000000009d48 0005000000001000 060c000000000000
0500000000000000
[   24.431935] Call Trace:
[   24.431935]  [<ffffffff8126b38d>] ? alloc_extent_buffer+0x7d/0x420
[   24.431935]  [<ffffffff8127a90a>] walk_down_log_tree+0x1ea/0x3b0
[   24.431935]  [<ffffffff8127adcd>] walk_log_tree+0xbd/0x1d0
[   24.431935]  [<ffffffff8127eb21>] btrfs_recover_log_trees+0x211/0x30=
0
[   24.431935]  [<ffffffff8127d680>] ? fixup_inode_link_counts+0x150/0x=
150
[   24.431935]  [<ffffffff8124b104>] open_ctree+0x13f4/0x17a0
[   24.431935]  [<ffffffff811c8eca>] ? disk_name+0xba/0xc0
[   24.431935]  [<ffffffff8122ba66>] btrfs_mount+0x426/0x5d0
[   24.431935]  [<ffffffff811656b0>] mount_fs+0x20/0xd0
[   24.431935]  [<ffffffff8117dc8a>] vfs_kern_mount+0x6a/0xc0
[   24.431935]  [<ffffffff8117f024>] do_kern_mount+0x54/0x110
[   24.431935]  [<ffffffff81180a2a>] do_mount+0x53a/0x840
[   24.431935]  [<ffffffff8111f1bb>] ? memdup_user+0x4b/0x90
[   24.431935]  [<ffffffff8111f25b>] ? strndup_user+0x5b/0x80
[   24.431935]  [<ffffffff81181118>] sys_mount+0x98/0xf0
[   24.431935]  [<ffffffff81b6bf0b>] mount_block_root+0xe4/0x28a
[   24.431935]  [<ffffffff81171443>] ? sys_mknodat+0xc3/0x1f0
[   24.431935]  [<ffffffff81b6c237>] mount_root+0x53/0x57
[   24.431935]  [<ffffffff81b6c3a8>] prepare_namespace+0x16d/0x1a6
[   24.431935]  [<ffffffff81b6bd63>] kernel_init+0x153/0x158
[   24.431935]  [<ffffffff81061e67>] ? schedule_tail+0x27/0xb0
[   24.431935]  [<ffffffff81593074>] kernel_thread_helper+0x4/0x10
[   24.431935]  [<ffffffff81b6bc10>] ? start_kernel+0x3bb/0x3bb
[   24.431935]  [<ffffffff81593070>] ? gs_change+0x13/0x13
[   24.431935] Code: 8b 4d 90 48 8b 55 88 48 8b 75 98 41 89 d9 48 89
04 24 4d 89 f0 e8 e5 ea ff ff 83 f8 fe 0f 84 a2 fe ff ff 85 c0 0f 84
9a fe ff ff <0f> 0b 66 90 49 8b 7d 20 48 8b 55 90 4c 8d 4d ae 48 8b 75
98 41
[   24.431935] RIP  [<ffffffff8127d8cc>] replay_one_buffer+0x24c/0x330
[   24.431935]  RSP <ffff8800078d7810>
[   24.573567] ---[ end trace f1fff9aaced9257d ]---
[   24.575888] Kernel panic - not syncing: Attempted to kill init!
[   24.578587] Pid: 1, comm: swapper Tainted: G      D     3.1.0-rc8+ #=
4
[   24.581490] Call Trace:
[   24.582643]  [<ffffffff8157e978>] panic+0x91/0x1a7
[   24.584839]  [<ffffffff8106e000>] do_exit+0x760/0x830
[   24.587148]  [<ffffffff8106b75a>] ? kmsg_dump+0x4a/0xe0
[   24.589520]  [<ffffffff8158a48b>] oops_end+0xab/0xf0
[   24.591794]  [<ffffffff81016788>] die+0x58/0x90
[   24.593879]  [<ffffffff81589b94>] do_trap+0xc4/0x170
[   24.596162]  [<ffffffff81013e25>] do_invalid_op+0x95/0xb0
[   24.598672]  [<ffffffff8127d8cc>] ? replay_one_buffer+0x24c/0x330
[   24.601534]  [<ffffffff8117aa73>] ? iput+0x103/0x200
[   24.603767]  [<ffffffff8127c8a0>] ? add_inode_ref+0x500/0x520
[   24.606333]  [<ffffffff81592eeb>] invalid_op+0x1b/0x20
[   24.608647]  [<ffffffff8127d8cc>] ? replay_one_buffer+0x24c/0x330
[   24.611366]  [<ffffffff8126b38d>] ? alloc_extent_buffer+0x7d/0x420
[   24.614119]  [<ffffffff8127a90a>] walk_down_log_tree+0x1ea/0x3b0
[   24.616829]  [<ffffffff8127adcd>] walk_log_tree+0xbd/0x1d0
[   24.619168]  [<ffffffff8127eb21>] btrfs_recover_log_trees+0x211/0x30=
0
[   24.621825]  [<ffffffff8127d680>] ? fixup_inode_link_counts+0x150/0x=
150
[   24.624669]  [<ffffffff8124b104>] open_ctree+0x13f4/0x17a0
[   24.627186]  [<ffffffff811c8eca>] ? disk_name+0xba/0xc0
[   24.629735]  [<ffffffff8122ba66>] btrfs_mount+0x426/0x5d0
[   24.632180]  [<ffffffff811656b0>] mount_fs+0x20/0xd0
[   24.634475]  [<ffffffff8117dc8a>] vfs_kern_mount+0x6a/0xc0
[   24.636989]  [<ffffffff8117f024>] do_kern_mount+0x54/0x110
[   24.639528]  [<ffffffff81180a2a>] do_mount+0x53a/0x840
[   24.641886]  [<ffffffff8111f1bb>] ? memdup_user+0x4b/0x90
[   24.644360]  [<ffffffff8111f25b>] ? strndup_user+0x5b/0x80
[   24.646854]  [<ffffffff81181118>] sys_mount+0x98/0xf0
[   24.649200]  [<ffffffff81b6bf0b>] mount_block_root+0xe4/0x28a
[   24.651793]  [<ffffffff81171443>] ? sys_mknodat+0xc3/0x1f0
[   24.654305]  [<ffffffff81b6c237>] mount_root+0x53/0x57
[   24.656610]  [<ffffffff81b6c3a8>] prepare_namespace+0x16d/0x1a6
[   24.659370]  [<ffffffff81b6bd63>] kernel_init+0x153/0x158
[   24.661878]  [<ffffffff81061e67>] ? schedule_tail+0x27/0xb0
[   24.664400]  [<ffffffff81593074>] kernel_thread_helper+0x4/0x10
[   24.667062]  [<ffffffff81b6bc10>] ? start_kernel+0x3bb/0x3bb
[   24.669668]  [<ffffffff81593070>] ? gs_change+0x13/0x13

Again, the machine died, and wouldn't mount /home any more.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
