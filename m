From: Troy Ablan <tablan@gmail.com>
Subject: A two-off BUG during btrfs device delete.  Was able to get beyond
 it after two reboots.
Date: Sat, 02 Oct 2010 09:18:44 -0700
Message-ID: <4CA75B64.9050909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Not sure if this is useful, but during a btrfs device delete (withdrawing a
small device on a -d single -m raid1 filesystem, so that it went from two
devices to one device).

It is likely but not confirmed that snapshots were taken by scripts running
from cron at the time of the crashes, possibly triggering them both.

[459160.525611] btrfs: relocating block group 5817335480320 flags 36
[459272.687658] ------------[ cut here ]------------
[459272.687712] kernel BUG at fs/btrfs/relocation.c:837!
[459272.687764] invalid opcode: 0000 [#1] SMP
[459272.687818] last sysfs file: /sys/kernel/uevent_seqnum
[459272.687869] CPU 3
[459272.687875] Modules linked in:
[459272.687968]
[459272.688014] Pid: 20998, comm: btrfs Tainted: G   M    W   2.6.35-gentoo-r8
#1 P55M-GD45 (MS-7588) /MS-7588
[459272.688113] RIP: 0010:[<ffffffff812dd9f1>]  [<ffffffff812dd9f1>]
build_backref_tree+0xd71/0x1330
[459272.688218] RSP: 0018:ffff88008f8818c8  EFLAGS: 00010246
[459272.688272] RAX: ffff88012ae2f740 RBX: ffff88009c586280 RCX: ffff88012ae2f740
[459272.688368] RDX: 0000054c7382d000 RSI: ffff88009be6c800 RDI: ffff88013fc002c0
[459272.688463] RBP: ffff88008f8819f8 R08: 0000000000000000 R09: ffff88009c586280
[459272.688559] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88011241c490
[459272.688655] R13: ffff88008f880000 R14: ffff8800177b4940 R15: 0000000000000003
[459272.688751] FS:  00007fc199a1e740(0000) GS:ffff880001cc0000(0000)
knlGS:0000000000000000
[459272.688850] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[459272.688903] CR2: 00007fea954c2000 CR3: 00000000a5be4000 CR4: 00000000000006e0
[459272.688998] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[459272.689094] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[459272.689189] Process btrfs (pid: 20998, threadinfo ffff88008f880000, task
ffff880138419220)
[459272.689285] Stack:
[459272.689332]  ffff88008f881998 ffff88008f8819a8 ffff88008f880000
ffff88008f880000
[459272.689393] <0> ffff88008f880000 0000000400000003 ffff88009be6c820
ffff88009c586920
[459272.689500] <0> ffff88009be6c800 ffff8800177b4980 ffff8800b122abe0
ffff88010739d910
[459272.689649] Call Trace:
[459272.689699]  [<ffffffff812de9f4>] relocate_tree_blocks+0x294/0x680
[459272.689753]  [<ffffffff812dc070>] ? add_tree_block+0x130/0x1b0
[459272.689806]  [<ffffffff812e06c8>] relocate_block_group+0x188/0x5c0
[459272.689861]  [<ffffffff8129e380>] ? btrfs_clean_old_snapshots+0x80/0x160
[459272.689915]  [<ffffffff812e0c46>] btrfs_relocate_block_group+0x146/0x260
[459272.689970]  [<ffffffff812c5d83>] btrfs_relocate_chunk+0x83/0x5b0
[459272.690025]  [<ffffffff812b1d31>] ? btrfs_dev_extent_chunk_offset+0xe1/0xf0
[459272.690082]  [<ffffffff812c64e5>] btrfs_shrink_device+0x235/0x390
[459272.690137]  [<ffffffff812c2ab1>] ? btrfs_find_device+0x51/0x70
[459272.690191]  [<ffffffff812c7051>] btrfs_rm_device+0x211/0x580
[459272.690244]  [<ffffffff812cd673>] btrfs_ioctl+0x5a3/0x9c0
[459272.690298]  [<ffffffff81058be7>] ? do_page_fault+0x1c7/0x3a0
[459272.690353]  [<ffffffff811344c5>] vfs_ioctl+0x35/0xd0
[459272.690405]  [<ffffffff8113498b>] do_vfs_ioctl+0x39b/0x520
[459272.690459]  [<ffffffff816e099e>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[459272.690514]  [<ffffffff81134b5a>] sys_ioctl+0x4a/0x80
[459272.690571]  [<ffffffff81033dab>] system_call_fastpath+0x16/0x1b
[459272.690626] Code: 89 42 18 48 89 08 e9 d8 f6 ff ff 48 8b bd 20 ff ff ff 41
89 c4 e8 30 98 fa ff 48 8b bd 28 ff ff ff e8 24 98 fa ff e9 b2 f4 ff ff <0f> 0b
eb fe 0f 1f 00 0f 0b eb fe 0f 0b eb fe be c6 02 00 00 48
[459272.690928] RIP  [<ffffffff812dd9f1>] build_backref_tree+0xd71/0x1330
[459272.690985]  RSP <ffff88008f8818c8>
[459272.691294] ---[ end trace 577d56ca7c5a88fc ]---

Then it happened again on the second try after reboot, but with further progress.

[18007.182441] btrfs: relocating block group 5811027247104 flags 36
[18203.435824] ------------[ cut here ]------------
[18203.435878] kernel BUG at fs/btrfs/relocation.c:837!
[18203.435933] invalid opcode: 0000 [#1] SMP
[18203.435987] last sysfs file: /sys/devices/virtual/block/md1/md/metadata_version
[18203.436082] CPU 6
[18203.436087] Modules linked in:
[18203.436180]
[18203.436227] Pid: 6142, comm: btrfs Not tainted 2.6.35-gentoo-r8 #1 P55M-GD45
(MS-7588) /MS-7588
[18203.436324] RIP: 0010:[<ffffffff812dd9f1>]  [<ffffffff812dd9f1>]
build_backref_tree+0xd71/0x1330
[18203.436428] RSP: 0018:ffff88012f5fd8c8  EFLAGS: 00010246
[18203.436479] RAX: ffff8800479cb3c0 RBX: ffff88009e666d00 RCX: ffff8800479cb3c0
[18203.436534] RDX: 0000054f2bff8000 RSI: ffff880139caf800 RDI: ffff88013fc002c0
[18203.436588] RBP: ffff88012f5fd9f8 R08: 0000000000000000 R09: ffff88009e666d00
[18203.436642] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8800b9846640
[18203.436696] R13: ffff88012f5fc000 R14: ffff88009ab018c0 R15: 0000000000000003
[18203.436751] FS:  00007f0b09f52740(0000) GS:ffff880001d80000(0000)
knlGS:0000000000000000
[18203.436853] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[18203.436905] CR2: 00007fda9b0ebcec CR3: 000000013bfde000 CR4: 00000000000006e0
[18203.436959] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18203.437014] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[18203.437068] Process btrfs (pid: 6142, threadinfo ffff88012f5fc000, task
ffff88013e72ac10)
[18203.437165] Stack:
[18203.437211]  ffff88012f5fd998 ffff88012f5fd9a8 ffff88012f5fc000 ffff88012f5fc000
[18203.437272] <0> ffff88012f5fc000 0000000400000003 ffff880139caf820
ffff88005dbf52a0
[18203.437379] <0> ffff880139caf800 ffff88009ab01900 ffff8801091b0d00
ffff8801091b0d90
[18203.437528] Call Trace:
[18203.437577]  [<ffffffff812de9f4>] relocate_tree_blocks+0x294/0x680
[18203.437631]  [<ffffffff812dc070>] ? add_tree_block+0x130/0x1b0
[18203.437684]  [<ffffffff812e06c8>] relocate_block_group+0x188/0x5c0
[18203.437739]  [<ffffffff8129e380>] ? btrfs_clean_old_snapshots+0x80/0x160
[18203.437796]  [<ffffffff812e0c46>] btrfs_relocate_block_group+0x146/0x260
[18203.437859]  [<ffffffff812c5d83>] btrfs_relocate_chunk+0x83/0x5b0
[18203.437917]  [<ffffffff812b1d31>] ? btrfs_dev_extent_chunk_offset+0xe1/0xf0
[18203.437972]  [<ffffffff812c64e5>] btrfs_shrink_device+0x235/0x390
[18203.438026]  [<ffffffff812c2ab1>] ? btrfs_find_device+0x51/0x70
[18203.438079]  [<ffffffff812c7051>] btrfs_rm_device+0x211/0x580
[18203.438131]  [<ffffffff812cd673>] btrfs_ioctl+0x5a3/0x9c0
[18203.438185]  [<ffffffff81058be7>] ? do_page_fault+0x1c7/0x3a0
[18203.438239]  [<ffffffff811344c5>] vfs_ioctl+0x35/0xd0
[18203.438291]  [<ffffffff8113498b>] do_vfs_ioctl+0x39b/0x520
[18203.438344]  [<ffffffff816e099e>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[18203.438398]  [<ffffffff81134b5a>] sys_ioctl+0x4a/0x80
[18203.438452]  [<ffffffff81033dab>] system_call_fastpath+0x16/0x1b
[18203.438504] Code: 89 42 18 48 89 08 e9 d8 f6 ff ff 48 8b bd 20 ff ff ff 41
89 c4 e8 30 98 fa ff 48 8b bd 28 ff ff ff e8 24 98 fa ff e9 b2 f4 ff ff <0f> 0b
eb fe 0f 1f 00 0f 0b eb fe 0f 0b eb fe be
c6 02 00 00 48
[18203.438805] RIP  [<ffffffff812dd9f1>] build_backref_tree+0xd71/0x1330
[18203.438865]  RSP <ffff88012f5fd8c8>
[18203.439173] ---[ end trace 9d14e6b1ea744642 ]---


Thanks for all the hard work on btrfs: cmason, josef, yanzheng, and everyone else!

-Troy
