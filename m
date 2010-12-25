From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: "btrfs allocation failed" while running qemu image
Date: Sat, 25 Dec 2010 18:13:04 +0100
Message-ID: <20101225171304.GA2362@gentoo.trippels.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Just got these errors on a btrfs test partion, when I started qemu with
a qcow2 image file (freshly copied from a ext4 partition shortly before):

 % qemu-kvm -net nic,vlan=0,model=virtio -net user -drive file=ubuntu,if=virtio,boot=on -smp 2 -m 512

Dec 25 17:58:41 [kernel] btrfs allocation failed flags 36, wanted 4096
Dec 25 17:58:41 [kernel] space_info has 221898240 free, is not full
Dec 25 17:58:41 [kernel] space_info total=1350565888, used=633548800, pinned=262320128, reserved=224344576, may_use=0, readonly=8454144
Dec 25 17:58:41 [kernel] block group 29360128 has 1073741824 bytes, 633032704 used 8192 pinned 4587520 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 395166351360 has 134217728 bytes, 471040 used 133709824 pinned 36864 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 462946304000 has 134217728 bytes, 45056 used 128602112 pinned 5570560 reserved
Dec 25 17:58:41 [kernel] entry offset 462946304000, bytes 0, bitmap yes
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 4194304 has 8388608 bytes, 0 used 0 pinned 0 reserved
Dec 25 17:58:41 [kernel] entry offset 4194304, bytes 8388608, bitmap no
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 1 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] btrfs allocation failed flags 36, wanted 4096
Dec 25 17:58:41 [kernel] space_info has 221902336 free, is not full
Dec 25 17:58:41 [kernel] space_info total=1350565888, used=633548800, pinned=262320128, reserved=224340480, may_use=0, readonly=8454144
Dec 25 17:58:41 [kernel] block group 29360128 has 1073741824 bytes, 633032704 used 8192 pinned 4587520 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 395166351360 has 134217728 bytes, 471040 used 133709824 pinned 36864 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 462946304000 has 134217728 bytes, 45056 used 128602112 pinned 5570560 reserved
Dec 25 17:58:41 [kernel] entry offset 462946304000, bytes 0, bitmap yes
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 4194304 has 8388608 bytes, 0 used 0 pinned 0 reserved
Dec 25 17:58:41 [kernel] entry offset 4194304, bytes 8388608, bitmap no
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 1 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] kernel BUG at fs/btrfs/extent-tree.c:5420!
Dec 25 17:58:41 [kernel] btrfs allocation failed flags 36, wanted 4096
Dec 25 17:58:41 [kernel] space_info has 221911552 free, is not full
Dec 25 17:58:41 [kernel] space_info total=1350565888, used=633548800, pinned=262320128, reserved=224331264, may_use=0, readonly=8454144
Dec 25 17:58:41 [kernel] block group 29360128 has 1073741824 bytes, 633032704 used 8192 pinned 4587520 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 395166351360 has 134217728 bytes, 471040 used 133709824 pinned 36864 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 462946304000 has 134217728 bytes, 45056 used 128602112 pinned 5570560 reserved
Dec 25 17:58:41 [kernel] entry offset 462946304000, bytes 0, bitmap yes
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 4194304 has 8388608 bytes, 0 used 0 pinned 0 reserved
Dec 25 17:58:41 [kernel] entry offset 4194304, bytes 8388608, bitmap no
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 1 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] btrfs allocation failed flags 36, wanted 4096
                - Last output repeated twice -
Dec 25 17:58:41 [kernel] space_info has 222006784 free, is not full
Dec 25 17:58:41 [kernel] space_info total=1350565888, used=633548800, pinned=262320128, reserved=224236032, may_use=0, readonly=8454144
Dec 25 17:58:41 [kernel] space_info has 222006784 free, is not full
Dec 25 17:58:41 [kernel] block group 29360128 has 1073741824 bytes, 633032704 used 8192 pinned 4587520 reserved
Dec 25 17:58:41 [kernel] space_info total=1350565888, used=633548800, pinned=262320128, reserved=224236032, may_use=0, readonly=8454144
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 29360128 has 1073741824 bytes, 633032704 used 8192 pinned 4587520 reserved
Dec 25 17:58:41 [kernel] block group 395166351360 has 134217728 bytes, 471040 used 133709824 pinned 36864 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
                - Last output repeated twice -
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
                - Last output repeated twice -
Dec 25 17:58:41 [kernel] space_info has 221898240 free, is not full
Dec 25 17:58:41 [kernel] entry offset 462946304000, bytes 0, bitmap yes
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 462946304000 has 134217728 bytes, 45056 used 128602112 pinned 5570560 reserved
Dec 25 17:58:41 [kernel] entry offset 462946304000, bytes 0, bitmap yes
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 4194304 has 8388608 bytes, 0 used 0 pinned 0 reserved
Dec 25 17:58:41 [kernel] entry offset 4194304, bytes 8388608, bitmap no
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 1 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 4194304 has 8388608 bytes, 0 used 0 pinned 0 reserved
Dec 25 17:58:41 [kernel] entry offset 4194304, bytes 8388608, bitmap no
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 1 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] btrfs allocation failed flags 36, wanted 4096
Dec 25 17:58:41 [kernel] space_info has 222006784 free, is not full
Dec 25 17:58:41 [kernel] space_info total=1350565888, used=633548800, pinned=262320128, reserved=224236032, may_use=0, readonly=8454144
Dec 25 17:58:41 [kernel] block group 29360128 has 1073741824 bytes, 633032704 used 8192 pinned 4587520 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 395166351360 has 134217728 bytes, 471040 used 133709824 pinned 36864 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 462946304000 has 134217728 bytes, 45056 used 128602112 pinned 5570560 reserved
Dec 25 17:58:41 [kernel] entry offset 462946304000, bytes 0, bitmap yes
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 4194304 has 8388608 bytes, 0 used 0 pinned 0 reserved
Dec 25 17:58:41 [kernel] entry offset 4194304, bytes 8388608, bitmap no
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 1 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] btrfs allocation failed flags 36, wanted 4096
Dec 25 17:58:41 [kernel] space_info has 222105600 free, is not full
Dec 25 17:58:41 [kernel] space_info total=1350565888, used=633548800, pinned=262320128, reserved=224137216, may_use=0, readonly=8454144
Dec 25 17:58:41 [kernel] block group 29360128 has 1073741824 bytes, 633032704 used 8192 pinned 4587520 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 395166351360 has 134217728 bytes, 471040 used 133709824 pinned 36864 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 462946304000 has 134217728 bytes, 45056 used 128602112 pinned 5570560 reserved
Dec 25 17:58:41 [kernel] entry offset 462946304000, bytes 0, bitmap yes
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 4194304 has 8388608 bytes, 0 used 0 pinned 0 reserved
Dec 25 17:58:41 [kernel] entry offset 4194304, bytes 8388608, bitmap no
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 1 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] PREEMPT SMP 
Dec 25 17:58:41 [kernel] CPU 0 
Dec 25 17:58:41 [kernel] Pid: 3033, comm: qemu-kvm Not tainted 2.6.37-rc7-00165-g2c90487 #27 M4A78T-E/System Product Name
Dec 25 17:58:41 [kernel] RIP: 0010:[<ffffffff811e0da1>]  [<ffffffff811e0da1>] alloc_reserved_file_extent.clone.61+0x201/0x220
Dec 25 17:58:41 [kernel] RSP: 0018:ffff8800da89ba08  EFLAGS: 00010286
Dec 25 17:58:41 [kernel] RAX: 00000000ffffffe4 RBX: ffff88011c0535a0 RCX: 00000000ffffffe4
Dec 25 17:58:41 [kernel] RDX: 0000000000000008 RSI: ffff88011c0535a0 RDI: 0000000000000000
Dec 25 17:58:41 [kernel] RBP: ffff8800da89ba88 R08: 0000000000000000 R09: 000000000000fffe
Dec 25 17:58:41 [kernel] R10: 00000000ffffffe4 R11: ffff88011eee5d40 R12: 00000000000000b2
Dec 25 17:58:41 [kernel] R13: ffff8800da89bb38 R14: 0000000000000000 R15: ffff8800ba6aa380
Dec 25 17:58:41 [kernel] FS:  00007f2b174f2710(0000) GS:ffff8800dfc00000(0000) knlGS:0000000000000000
Dec 25 17:58:41 [kernel] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec 25 17:58:41 [kernel] CR2: 00007fceddb1c020 CR3: 00000000daded000 CR4: 00000000000006f0
Dec 25 17:58:41 [kernel] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec 25 17:58:41 [kernel] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec 25 17:58:41 [kernel] Process qemu-kvm (pid: 3033, threadinfo ffff8800da89a000, task ffff88011ff10000)
Dec 25 17:58:41 [kernel]  ffff880000000001 0000003500000003 ffff8800da89ba88 ffff8800da803660
Dec 25 17:58:41 [kernel]  [<ffffffff811e4bac>] run_clustered_refs+0x2ec/0x860
Dec 25 17:58:41 [kernel]  [<ffffffff8106682d>] ? select_idle_sibling+0xad/0x180
Dec 25 17:58:41 [kernel]  [<ffffffff81233f01>] ? btrfs_find_ref_cluster+0x81/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff811e51f8>] btrfs_run_delayed_refs+0xd8/0x240
Dec 25 17:58:41 [kernel]  [<ffffffff811f4d3e>] btrfs_commit_transaction+0x7e/0x760
Dec 25 17:58:41 [kernel]  [<ffffffff81094420>] ? autoremove_wake_function+0x0/0x40
Dec 25 17:58:41 [kernel]  [<ffffffff8106ead5>] ? wake_up_process+0x15/0x20
Dec 25 17:58:41 [kernel]  [<ffffffff81203c01>] btrfs_file_aio_write+0x621/0xa40
Dec 25 17:58:41 [kernel]  [<ffffffff8106ea92>] ? default_wake_function+0x12/0x20
Dec 25 17:58:41 [kernel]  [<ffffffff8111895a>] do_sync_write+0xda/0x120
Dec 25 17:58:41 [kernel]  [<ffffffff81088981>] ? sys_kill+0xa1/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff81118a4e>] vfs_write+0xae/0x160
Dec 25 17:58:41 [kernel]  [<ffffffff81118d12>] sys_pwrite64+0x72/0xa0
Dec 25 17:58:41 [kernel]  [<ffffffff8103aeab>] system_call_fastpath+0x16/0x1b
Dec 25 17:58:41 [kernel] RIP  [<ffffffff811e0da1>] alloc_reserved_file_extent.clone.61+0x201/0x220
Dec 25 17:58:41 [kernel]  RSP <ffff8800da89ba08>
Dec 25 17:58:41 [kernel] ---[ end trace b3f0b4b8a48cf83a ]---
Dec 25 17:58:41 [kernel] kernel BUG at fs/btrfs/extent-tree.c:5420!
Dec 25 17:58:41 [kernel] CPU 2 
Dec 25 17:58:41 [kernel] Pid: 3066, comm: qemu-kvm Tainted: G      D     2.6.37-rc7-00165-g2c90487 #27 M4A78T-E/System Product Name
Dec 25 17:58:41 [kernel] RIP: 0010:[<ffffffff811e0da1>]  [<ffffffff811e0da1>] alloc_reserved_file_extent.clone.61+0x201/0x220
Dec 25 17:58:41 [kernel] RSP: 0018:ffff880094f91948  EFLAGS: 00010286
Dec 25 17:58:41 [kernel] RAX: 00000000ffffffe4 RBX: ffff88011c3ceea0 RCX: 00000000ffffffe4
Dec 25 17:58:41 [kernel] RDX: 0000000000000008 RSI: ffff88011c3ceea0 RDI: 0000000000000000
Dec 25 17:58:41 [kernel] RBP: ffff880094f919c8 R08: 000000000000fffc R09: 000000000000fffe
Dec 25 17:58:41 [kernel] R10: 00000000ffffffe4 R11: ffff88011eee5d40 R12: 00000000000000b2
Dec 25 17:58:41 [kernel] R13: ffff880094f91a78 R14: 0000000000000000 R15: ffff8800ba74fbc0
Dec 25 17:58:41 [kernel] FS:  00007f2b084d4710(0000) GS:ffff8800dfd00000(0000) knlGS:0000000000000000
Dec 25 17:58:41 [kernel] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec 25 17:58:41 [kernel] CR2: 00007fceddb1c020 CR3: 00000000daded000 CR4: 00000000000006e0
Dec 25 17:58:41 [kernel] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec 25 17:58:41 [kernel] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec 25 17:58:41 [kernel] Process qemu-kvm (pid: 3066, threadinfo ffff880094f90000, task ffff88011fdd8c00)
Dec 25 17:58:41 [kernel]  0000000000000035 0000000000006394 0000000000000005 0000000000000000
Dec 25 17:58:41 [kernel]  ffff88011e95d128 ffffffff81252f65 ffff88011eb7fa00 ffff88011c928000
Dec 25 17:58:41 [kernel]  ffff880094f91998 00000035dfc11540 ffff880094f919c8 ffff8800da7d58a0
Dec 25 17:58:41 [kernel]  [<ffffffff81252f65>] ? blk_unplug+0x25/0xa0
Dec 25 17:58:41 [kernel]  [<ffffffff811e4bac>] run_clustered_refs+0x2ec/0x860
Dec 25 17:58:41 [kernel]  [<ffffffff810e9cc4>] ? ____pagevec_lru_add+0x184/0x1a0
Dec 25 17:58:41 [kernel]  [<ffffffff81233f01>] ? btrfs_find_ref_cluster+0x81/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff811e51f8>] btrfs_run_delayed_refs+0xd8/0x240
Dec 25 17:58:41 [kernel]  [<ffffffff811f4d3e>] btrfs_commit_transaction+0x7e/0x760
Dec 25 17:58:41 [kernel]  [<ffffffff8112d70d>] ? dput+0x10d/0x1a0
Dec 25 17:58:41 [kernel]  [<ffffffff81094420>] ? autoremove_wake_function+0x0/0x40
Dec 25 17:58:41 [kernel]  [<ffffffff8122d608>] ? btrfs_log_dentry_safe+0x48/0x60
Dec 25 17:58:41 [kernel]  [<ffffffff81203c01>] btrfs_file_aio_write+0x621/0xa40
Dec 25 17:58:41 [kernel]  [<ffffffff8106c920>] ? check_preempt_wakeup+0x140/0x1a0
Dec 25 17:58:41 [kernel]  [<ffffffff812035e0>] ? btrfs_file_aio_write+0x0/0xa40
Dec 25 17:58:41 [kernel]  [<ffffffff81118e73>] do_sync_readv_writev+0xd3/0x120
Dec 25 17:58:41 [kernel]  [<ffffffff815717ae>] ? _raw_spin_unlock_irqrestore+0x2e/0x40
Dec 25 17:58:41 [kernel]  [<ffffffff8156eb3a>] ? preempt_schedule+0x3a/0x60
Dec 25 17:58:41 [kernel]  [<ffffffff815717ae>] ? _raw_spin_unlock_irqrestore+0x2e/0x40
Dec 25 17:58:41 [kernel]  [<ffffffff810870a5>] ? do_send_sig_info+0x65/0x80
Dec 25 17:58:41 [kernel]  [<ffffffff81119149>] do_readv_writev+0xc9/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff81088981>] ? sys_kill+0xa1/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff811192e0>] vfs_writev+0x40/0x60
Dec 25 17:58:41 [kernel]  [<ffffffff81119512>] sys_pwritev+0x72/0xa0
Dec 25 17:58:41 [kernel]  [<ffffffff8103aeab>] system_call_fastpath+0x16/0x1b
Dec 25 17:58:41 [kernel] RIP  [<ffffffff811e0da1>] alloc_reserved_file_extent.clone.61+0x201/0x220
Dec 25 17:58:41 [kernel]  RSP <ffff880094f91948>
Dec 25 17:58:41 [kernel] kernel BUG at fs/btrfs/extent-tree.c:5420!
Dec 25 17:58:41 [kernel] CPU 3 
Dec 25 17:58:41 [kernel] Pid: 3058, comm: qemu-kvm Tainted: G      D     2.6.37-rc7-00165-g2c90487 #27 M4A78T-E/System Product Name
Dec 25 17:58:41 [kernel] RIP: 0010:[<ffffffff811e0da1>]  [<ffffffff811e0da1>] alloc_reserved_file_extent.clone.61+0x201/0x220
Dec 25 17:58:41 [kernel] RSP: 0018:ffff880093c75948  EFLAGS: 00010286
Dec 25 17:58:41 [kernel] RAX: 00000000ffffffe4 RBX: ffff88011c209e10 RCX: ffff88008d1aa760
Dec 25 17:58:41 [kernel] RDX: ffff8800930a18f0 RSI: 0000000000000292 RDI: 0000000000000000
Dec 25 17:58:41 [kernel] RBP: ffff880093c759c8 R08: 0000000000000000 R09: 0000000000000001
Dec 25 17:58:41 [kernel] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000000b2
Dec 25 17:58:41 [kernel] R13: ffff880093c75a78 R14: 0000000000000000 R15: ffff8800ba6aa800
Dec 25 17:58:41 [kernel] FS:  00007f2b0c4dc710(0000) GS:ffff8800dfd80000(0000) knlGS:0000000000000000
Dec 25 17:58:41 [kernel] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec 25 17:58:41 [kernel] CR2: 00007fceddb1c020 CR3: 00000000daded000 CR4: 00000000000006e0
Dec 25 17:58:41 [kernel] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec 25 17:58:41 [kernel]  ffff88011e95d128 ffffffff8106c216 ffff88011fcbaa00 ffff88011c928000
Dec 25 17:58:41 [kernel]  0000000000000000 0000003500000000 ffff880093c759c8 ffff8800da7d5de0
Dec 25 17:58:41 [kernel]  [<ffffffff8106c216>] ? dequeue_task_fair+0x56/0x60
Dec 25 17:58:41 [kernel]  [<ffffffff811e4bac>] run_clustered_refs+0x2ec/0x860
Dec 25 17:58:41 [kernel]  [<ffffffff8106682d>] ? select_idle_sibling+0xad/0x180
Dec 25 17:58:41 [kernel]  [<ffffffff81233f01>] ? btrfs_find_ref_cluster+0x81/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff811e51f8>] btrfs_run_delayed_refs+0xd8/0x240
Dec 25 17:58:41 [kernel]  [<ffffffff811f4d3e>] btrfs_commit_transaction+0x7e/0x760
Dec 25 17:58:41 [kernel]  [<ffffffff81094420>] ? autoremove_wake_function+0x0/0x40
Dec 25 17:58:41 [kernel]  [<ffffffff8106ead5>] ? wake_up_process+0x15/0x20
Dec 25 17:58:41 [kernel]  [<ffffffff81203c01>] btrfs_file_aio_write+0x621/0xa40
Dec 25 17:58:41 [kernel]  [<ffffffff8106c903>] ? check_preempt_wakeup+0x123/0x1a0
Dec 25 17:58:41 [kernel]  [<ffffffff8106ea92>] ? default_wake_function+0x12/0x20
Dec 25 17:58:41 [kernel]  [<ffffffff8112a2f6>] ? pollwake+0x56/0x60
Dec 25 17:58:41 [kernel]  [<ffffffff812035e0>] ? btrfs_file_aio_write+0x0/0xa40
Dec 25 17:58:41 [kernel]  [<ffffffff81118e73>] do_sync_readv_writev+0xd3/0x120
Dec 25 17:58:41 [kernel]  [<ffffffff810870a5>] ? do_send_sig_info+0x65/0x80
Dec 25 17:58:41 [kernel]  [<ffffffff81119149>] do_readv_writev+0xc9/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff81088981>] ? sys_kill+0xa1/0x1c0
Dec 25 17:58:41 [kernel] ---[ end trace b3f0b4b8a48cf83b ]---
Dec 25 17:58:41 [kernel]  [<ffffffff811192e0>] vfs_writev+0x40/0x60
Dec 25 17:58:41 [kernel]  [<ffffffff81119512>] sys_pwritev+0x72/0xa0
Dec 25 17:58:41 [kernel]  [<ffffffff8103aeab>] system_call_fastpath+0x16/0x1b
Dec 25 17:58:41 [kernel] RIP  [<ffffffff811e0da1>] alloc_reserved_file_extent.clone.61+0x201/0x220
Dec 25 17:58:41 [kernel]  RSP <ffff880093c75948>
Dec 25 17:58:41 [kernel] kernel BUG at fs/btrfs/extent-tree.c:5480!
Dec 25 17:58:41 [kernel] CPU 1 
Dec 25 17:58:41 [kernel] Pid: 3073, comm: qemu-kvm Tainted: G      D     2.6.37-rc7-00165-g2c90487 #27 M4A78T-E/System Product Name
Dec 25 17:58:41 [kernel] RIP: 0010:[<ffffffff811e510b>]  [<ffffffff811e510b>] run_clustered_refs+0x84b/0x860
Dec 25 17:58:41 [kernel] RSP: 0018:ffff880093c95a98  EFLAGS: 00010286
Dec 25 17:58:41 [kernel] RAX: 00000000ffffffe4 RBX: ffff8800b446bf60 RCX: 00000000ffffffe4
Dec 25 17:58:41 [kernel] RDX: 0000000000000008 RSI: ffff88011c005090 RDI: 0000000000000000
Dec 25 17:58:41 [kernel] RBP: ffff880093c95b88 R08: 000000000000fffc R09: 000000000000fffe
Dec 25 17:58:41 [kernel] R10: 00000000ffffffe4 R11: ffff88011eee5d40 R12: ffff8800da4f2200
Dec 25 17:58:41 [kernel] R13: ffff8800daf24f40 R14: ffff88009afeb000 R15: 0000000000000000
Dec 25 17:58:41 [kernel] FS:  00007f2b04ccd710(0000) GS:ffff8800dfc80000(0000) knlGS:0000000000000000
Dec 25 17:58:41 [kernel] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec 25 17:58:41 [kernel] CR2: 00007fceddb1c020 CR3: 00000000daded000 CR4: 00000000000006e0
Dec 25 17:58:41 [kernel] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec 25 17:58:41 [kernel] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec 25 17:58:41 [kernel] Process qemu-kvm (pid: 3073, threadinfo ffff880093c94000, task ffff88011e94ce00)
Dec 25 17:58:41 [kernel]  ffff880093c95ab8 ffffffff812647d5 0000000000011540 ffff8800dfc8d7d8
Dec 25 17:58:41 [kernel]  ffff880093c95b08 ffffffff8106682d 0000000093c95ae8 ffff88011e95d128
Dec 25 17:58:41 [kernel]  0000000000000000 0000000000000005 ffff8800dfc91540 0000000000000000
Dec 25 17:58:41 [kernel]  [<ffffffff812647d5>] ? cpumask_next_and+0x35/0x60
Dec 25 17:58:41 [kernel]  [<ffffffff8106682d>] ? select_idle_sibling+0xad/0x180
Dec 25 17:58:41 [kernel]  [<ffffffff811e51f8>] btrfs_run_delayed_refs+0xd8/0x240
Dec 25 17:58:41 [kernel]  [<ffffffff811f4d3e>] btrfs_commit_transaction+0x7e/0x760
Dec 25 17:58:41 [kernel]  [<ffffffff81094420>] ? autoremove_wake_function+0x0/0x40
Dec 25 17:58:41 [kernel]  [<ffffffff8106ead5>] ? wake_up_process+0x15/0x20
Dec 25 17:58:41 [kernel]  [<ffffffff81203c01>] btrfs_file_aio_write+0x621/0xa40
Dec 25 17:58:41 [kernel]  [<ffffffff8111895a>] do_sync_write+0xda/0x120
Dec 25 17:58:41 [kernel]  [<ffffffff81088981>] ? sys_kill+0xa1/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff81118a4e>] vfs_write+0xae/0x160
Dec 25 17:58:41 [kernel]  [<ffffffff81118d12>] sys_pwrite64+0x72/0xa0
Dec 25 17:58:41 [kernel]  [<ffffffff8103aeab>] system_call_fastpath+0x16/0x1b
Dec 25 17:58:41 [kernel] RIP  [<ffffffff811e510b>] run_clustered_refs+0x84b/0x860
Dec 25 17:58:41 [kernel]  RSP <ffff880093c95a98>
Dec 25 17:58:41 [kernel] ---[ end trace b3f0b4b8a48cf83c ]---
Dec 25 17:58:41 [kernel] space_info has 221709824 free, is not full
Dec 25 17:58:41 [kernel] space_info total=1350565888, used=633548800, pinned=262340608, reserved=224512512, may_use=0, readonly=8454144
Dec 25 17:58:41 [kernel] block group 29360128 has 1073741824 bytes, 633032704 used 8192 pinned 4612096 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 395166351360 has 134217728 bytes, 471040 used 133709824 pinned 36864 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 462946304000 has 134217728 bytes, 45056 used 128622592 pinned 5550080 reserved
Dec 25 17:58:41 [kernel] entry offset 462946304000, bytes 0, bitmap yes
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 4194304 has 8388608 bytes, 0 used 0 pinned 0 reserved
Dec 25 17:58:41 [kernel] entry offset 4194304, bytes 8388608, bitmap no
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 1 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] btrfs allocation failed flags 36, wanted 4096
Dec 25 17:58:41 [kernel] space_info has 221784064 free, is not full
Dec 25 17:58:41 [kernel] space_info total=1350565888, used=633548800, pinned=262340608, reserved=224438272, may_use=0, readonly=8454144
Dec 25 17:58:41 [kernel] block group 29360128 has 1073741824 bytes, 633032704 used 8192 pinned 4612096 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 395166351360 has 134217728 bytes, 471040 used 133709824 pinned 36864 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 462946304000 has 134217728 bytes, 45056 used 128622592 pinned 5550080 reserved
Dec 25 17:58:41 [kernel] entry offset 462946304000, bytes 0, bitmap yes
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 4194304 has 8388608 bytes, 0 used 0 pinned 0 reserved
Dec 25 17:58:41 [kernel] entry offset 4194304, bytes 8388608, bitmap no
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 1 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] kernel BUG at fs/btrfs/extent-tree.c:5480!
Dec 25 17:58:41 [kernel] CPU 3 
Dec 25 17:58:41 [kernel] Pid: 3071, comm: qemu-kvm Tainted: G      D     2.6.37-rc7-00165-g2c90487 #27 M4A78T-E/System Product Name
Dec 25 17:58:41 [kernel] RIP: 0010:[<ffffffff811e510b>]  [<ffffffff811e510b>] run_clustered_refs+0x84b/0x860
Dec 25 17:58:41 [kernel] RSP: 0018:ffff8800930a1a98  EFLAGS: 00010286
Dec 25 17:58:41 [kernel] RAX: 00000000ffffffe4 RBX: ffff8800da803d20 RCX: 00000000ffffffe4
Dec 25 17:58:41 [kernel] RDX: 0000000000000008 RSI: ffff88011c005120 RDI: 0000000000000000
Dec 25 17:58:41 [kernel] RBP: ffff8800930a1b88 R08: 000000000000fffc R09: 000000000000fffe
Dec 25 17:58:41 [kernel] R10: 00000000ffffffe4 R11: 0000000000000001 R12: ffff8800dae32780
Dec 25 17:58:41 [kernel] R13: ffff8800dae679c0 R14: ffff88009afeb000 R15: 0000000000000000
Dec 25 17:58:41 [kernel] FS:  00007f2b05ccf710(0000) GS:ffff8800dfd80000(0000) knlGS:0000000000000000
Dec 25 17:58:41 [kernel] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec 25 17:58:41 [kernel] CR2: 00007fff2b0ff5c8 CR3: 00000000daded000 CR4: 00000000000006e0
Dec 25 17:58:41 [kernel] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec 25 17:58:41 [kernel] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec 25 17:58:41 [kernel] Process qemu-kvm (pid: 3071, threadinfo ffff8800930a0000, task ffff88011fd37200)
Dec 25 17:58:41 [kernel]  0000000000000001 0000000000000460 ffff8800930a1b08 ffffffff810e9cc4
Dec 25 17:58:41 [kernel]  ffff8800930a1c10 ffffea0001e1da38 0000000000000003 ffff88011e95d128
Dec 25 17:58:41 [kernel]  0000000000000000 0000000000000005 0000000000000002 0000000000000001
Dec 25 17:58:41 [kernel]  [<ffffffff810e9cc4>] ? ____pagevec_lru_add+0x184/0x1a0
Dec 25 17:58:41 [kernel]  [<ffffffff811e51f8>] btrfs_run_delayed_refs+0xd8/0x240
Dec 25 17:58:41 [kernel]  [<ffffffff811f4d3e>] btrfs_commit_transaction+0x7e/0x760
Dec 25 17:58:41 [kernel]  [<ffffffff8112d70d>] ? dput+0x10d/0x1a0
Dec 25 17:58:41 [kernel]  [<ffffffff81094420>] ? autoremove_wake_function+0x0/0x40
Dec 25 17:58:41 [kernel]  [<ffffffff8122d608>] ? btrfs_log_dentry_safe+0x48/0x60
Dec 25 17:58:41 [kernel]  [<ffffffff81203c01>] btrfs_file_aio_write+0x621/0xa40
Dec 25 17:58:41 [kernel]  [<ffffffff8111895a>] do_sync_write+0xda/0x120
Dec 25 17:58:41 [kernel]  [<ffffffff81088981>] ? sys_kill+0xa1/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff81118a4e>] vfs_write+0xae/0x160
Dec 25 17:58:41 [kernel]  [<ffffffff81118d12>] sys_pwrite64+0x72/0xa0
Dec 25 17:58:41 [kernel]  [<ffffffff8103aeab>] system_call_fastpath+0x16/0x1b
Dec 25 17:58:41 [kernel] RIP  [<ffffffff811e510b>] run_clustered_refs+0x84b/0x860
Dec 25 17:58:41 [kernel]  RSP <ffff8800930a1a98>
Dec 25 17:58:41 [kernel] ---[ end trace b3f0b4b8a48cf83d ]---
Dec 25 17:58:41 [kernel] ---[ end trace b3f0b4b8a48cf83e ]---
Dec 25 17:58:41 [kernel] btrfs allocation failed flags 36, wanted 4096
Dec 25 17:58:41 [kernel] space_info has 221586432 free, is not full
Dec 25 17:58:41 [kernel] space_info total=1350565888, used=633548800, pinned=262340608, reserved=224635904, may_use=0, readonly=8454144
Dec 25 17:58:41 [kernel] block group 29360128 has 1073741824 bytes, 633032704 used 8192 pinned 4612096 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 395166351360 has 134217728 bytes, 471040 used 133709824 pinned 36864 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 462946304000 has 134217728 bytes, 45056 used 128622592 pinned 5550080 reserved
Dec 25 17:58:41 [kernel] entry offset 462946304000, bytes 0, bitmap yes
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 4194304 has 8388608 bytes, 0 used 0 pinned 0 reserved
Dec 25 17:58:41 [kernel] entry offset 4194304, bytes 8388608, bitmap no
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 1 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] kernel BUG at fs/btrfs/extent-tree.c:5420!
Dec 25 17:58:41 [kernel] CPU 0 
Dec 25 17:58:41 [kernel] Pid: 3037, comm: qemu-kvm Tainted: G      D     2.6.37-rc7-00165-g2c90487 #27 M4A78T-E/System Product Name
Dec 25 17:58:41 [kernel] RIP: 0010:[<ffffffff811e0da1>]  [<ffffffff811e0da1>] alloc_reserved_file_extent.clone.61+0x201/0x220
Dec 25 17:58:41 [kernel] RSP: 0018:ffff8800da719a08  EFLAGS: 00010286
Dec 25 17:58:41 [kernel] RAX: 00000000ffffffe4 RBX: ffff88011c053510 RCX: 00000000ffffffe4
Dec 25 17:58:41 [kernel] RDX: 0000000000000008 RSI: ffff88011c053510 RDI: 0000000000000000
Dec 25 17:58:41 [kernel] RBP: ffff8800da719a88 R08: 000000000000fffc R09: 000000000000fffe
Dec 25 17:58:41 [kernel] R10: 00000000ffffffe4 R11: ffff88011eee5d40 R12: 00000000000000b2
Dec 25 17:58:41 [kernel] R13: ffff8800da719b38 R14: 0000000000000000 R15: ffff8800ba6aa600
Dec 25 17:58:41 [kernel] FS:  00007f2b154ee710(0000) GS:ffff8800dfc00000(0000) knlGS:0000000000000000
Dec 25 17:58:41 [kernel] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec 25 17:58:41 [kernel] CR2: 000000000129b008 CR3: 00000000daded000 CR4: 00000000000006f0
Dec 25 17:58:41 [kernel] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec 25 17:58:41 [kernel] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec 25 17:58:41 [kernel] Process qemu-kvm (pid: 3037, threadinfo ffff8800da718000, task ffff88011ff12400)
Dec 25 17:58:41 [kernel]  ffff880100000035 0000000000006394 0000000000000005 0000000000000000
Dec 25 17:58:41 [kernel]  ffff88011e95d128 ffffffff8106c216 ffff88011ff12400 ffff88011c928000
Dec 25 17:58:41 [kernel]  0000000000000000 0000003500000000 ffff8800da719a88 ffff8800da9542a0
Dec 25 17:58:41 [kernel]  [<ffffffff8106c216>] ? dequeue_task_fair+0x56/0x60
Dec 25 17:58:41 [kernel]  [<ffffffff811e4bac>] run_clustered_refs+0x2ec/0x860
Dec 25 17:58:41 [kernel]  [<ffffffff8106682d>] ? select_idle_sibling+0xad/0x180
Dec 25 17:58:41 [kernel]  [<ffffffff81233f01>] ? btrfs_find_ref_cluster+0x81/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff811e51f8>] btrfs_run_delayed_refs+0xd8/0x240
Dec 25 17:58:41 [kernel]  [<ffffffff811f4d3e>] btrfs_commit_transaction+0x7e/0x760
Dec 25 17:58:41 [kernel]  [<ffffffff81094420>] ? autoremove_wake_function+0x0/0x40
Dec 25 17:58:41 [kernel]  [<ffffffff8106ead5>] ? wake_up_process+0x15/0x20
Dec 25 17:58:41 [kernel]  [<ffffffff81203c01>] btrfs_file_aio_write+0x621/0xa40
Dec 25 17:58:41 [kernel]  [<ffffffff8106ea92>] ? default_wake_function+0x12/0x20
Dec 25 17:58:41 [kernel]  [<ffffffff8111895a>] do_sync_write+0xda/0x120
Dec 25 17:58:41 [kernel]  [<ffffffff81088981>] ? sys_kill+0xa1/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff81118a4e>] vfs_write+0xae/0x160
Dec 25 17:58:41 [kernel]  [<ffffffff81118d12>] sys_pwrite64+0x72/0xa0
Dec 25 17:58:41 [kernel]  [<ffffffff8103aeab>] system_call_fastpath+0x16/0x1b
Dec 25 17:58:41 [kernel] RIP  [<ffffffff811e0da1>] alloc_reserved_file_extent.clone.61+0x201/0x220
Dec 25 17:58:41 [kernel]  RSP <ffff8800da719a08>
Dec 25 17:58:41 [kernel] ---[ end trace b3f0b4b8a48cf83f ]---
Dec 25 17:58:41 [kernel] btrfs allocation failed flags 36, wanted 4096
Dec 25 17:58:41 [kernel] space_info has 221586432 free, is not full
Dec 25 17:58:41 [kernel] block group 29360128 has 1073741824 bytes, 633032704 used 8192 pinned 4612096 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 395166351360 has 134217728 bytes, 471040 used 133709824 pinned 36864 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 462946304000 has 134217728 bytes, 45056 used 128622592 pinned 5550080 reserved
Dec 25 17:58:41 [kernel] entry offset 462946304000, bytes 0, bitmap yes
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 4194304 has 8388608 bytes, 0 used 0 pinned 0 reserved
Dec 25 17:58:41 [kernel] entry offset 4194304, bytes 8388608, bitmap no
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 1 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] kernel BUG at fs/btrfs/extent-tree.c:5480!
Dec 25 17:58:41 [kernel] CPU 0 
Dec 25 17:58:41 [kernel] Pid: 3045, comm: qemu-kvm Tainted: G      D     2.6.37-rc7-00165-g2c90487 #27 M4A78T-E/System Product Name
Dec 25 17:58:41 [kernel] RIP: 0010:[<ffffffff811e510b>]  [<ffffffff811e510b>] run_clustered_refs+0x84b/0x860
Dec 25 17:58:41 [kernel] RSP: 0018:ffff880097e5da98  EFLAGS: 00010286
Dec 25 17:58:41 [kernel] RAX: 00000000ffffffe4 RBX: ffff880119c414e0 RCX: 00000000ffffffe4
Dec 25 17:58:41 [kernel] RDX: 0000000000000008 RSI: ffff88011c0537e0 RDI: 0000000000000000
Dec 25 17:58:41 [kernel] RBP: ffff880097e5db88 R08: 000000000000fffc R09: 000000000000fffe
Dec 25 17:58:41 [kernel] R10: 00000000ffffffe4 R11: ffff88011eee5d40 R12: ffff88009a1df000
Dec 25 17:58:41 [kernel] R13: ffff8800da928b40 R14: ffff88009afeb000 R15: 0000000000000000
Dec 25 17:58:41 [kernel] FS:  00007f2b11ce7710(0000) GS:ffff8800dfc00000(0000) knlGS:0000000000000000
Dec 25 17:58:41 [kernel] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec 25 17:58:41 [kernel] CR2: 000000000129b008 CR3: 00000000daded000 CR4: 00000000000006f0
Dec 25 17:58:41 [kernel] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec 25 17:58:41 [kernel] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec 25 17:58:41 [kernel] Process qemu-kvm (pid: 3045, threadinfo ffff880097e5c000, task ffff88011fddf200)
Dec 25 17:58:41 [kernel]  ffff880097e5dab8 ffffffff812647d5 0000000000011540 ffff8800dfc0d7d8
Dec 25 17:58:41 [kernel]  ffff880097e5db08 ffffffff8106682d 0000000397e5dae8 ffff88011e95d128
Dec 25 17:58:41 [kernel]  0000000000000000 0000000000000007 0000000000008000 0000000000007c00
Dec 25 17:58:41 [kernel]  [<ffffffff812647d5>] ? cpumask_next_and+0x35/0x60
Dec 25 17:58:41 [kernel]  [<ffffffff8106682d>] ? select_idle_sibling+0xad/0x180
Dec 25 17:58:41 [kernel]  [<ffffffff811e51f8>] btrfs_run_delayed_refs+0xd8/0x240
Dec 25 17:58:41 [kernel]  [<ffffffff811f4d3e>] btrfs_commit_transaction+0x7e/0x760
Dec 25 17:58:41 [kernel]  [<ffffffff81094420>] ? autoremove_wake_function+0x0/0x40
Dec 25 17:58:41 [kernel]  [<ffffffff8106ead5>] ? wake_up_process+0x15/0x20
Dec 25 17:58:41 [kernel]  [<ffffffff81203c01>] btrfs_file_aio_write+0x621/0xa40
Dec 25 17:58:41 [kernel]  [<ffffffff8106ea92>] ? default_wake_function+0x12/0x20
Dec 25 17:58:41 [kernel]  [<ffffffff8111895a>] do_sync_write+0xda/0x120
Dec 25 17:58:41 [kernel]  [<ffffffff81088981>] ? sys_kill+0xa1/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff81118a4e>] vfs_write+0xae/0x160
Dec 25 17:58:41 [kernel]  [<ffffffff81118d12>] sys_pwrite64+0x72/0xa0
Dec 25 17:58:41 [kernel]  [<ffffffff8103aeab>] system_call_fastpath+0x16/0x1b
Dec 25 17:58:41 [kernel] RIP  [<ffffffff811e510b>] run_clustered_refs+0x84b/0x860
Dec 25 17:58:41 [kernel]  RSP <ffff880097e5da98>
Dec 25 17:58:41 [kernel] ---[ end trace b3f0b4b8a48cf840 ]---
Dec 25 17:58:41 [kernel] btrfs allocation failed flags 36, wanted 4096
Dec 25 17:58:41 [kernel] space_info has 221586432 free, is not full
Dec 25 17:58:41 [kernel] space_info total=1350565888, used=633548800, pinned=262340608, reserved=224635904, may_use=0, readonly=8454144
Dec 25 17:58:41 [kernel] block group 29360128 has 1073741824 bytes, 633032704 used 8192 pinned 4612096 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 395166351360 has 134217728 bytes, 471040 used 133709824 pinned 36864 reserved
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 0 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] block group 462946304000 has 134217728 bytes, 45056 used 128622592 pinned 5550080 reserved
Dec 25 17:58:41 [kernel] entry offset 462946304000, bytes 0, bitmap yes
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] block group 4194304 has 8388608 bytes, 0 used 0 pinned 0 reserved
Dec 25 17:58:41 [kernel] entry offset 4194304, bytes 8388608, bitmap no
Dec 25 17:58:41 [kernel] block group has cluster?: no
Dec 25 17:58:41 [kernel] 1 blocks of free space at or bigger than bytes is
Dec 25 17:58:41 [kernel] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
Dec 25 17:58:41 [kernel] IP: [<ffffffff811e9249>] btrfs_print_leaf+0x29/0x8a0
Dec 25 17:58:41 [kernel] PGD da492067 PUD dab6b067 PMD 0 
Dec 25 17:58:41 [kernel] CPU 0 
Dec 25 17:58:41 [kernel] Pid: 3031, comm: qemu-kvm Tainted: G      D     2.6.37-rc7-00165-g2c90487 #27 M4A78T-E/System Product Name
Dec 25 17:58:41 [kernel] RIP: 0010:[<ffffffff811e9249>]  [<ffffffff811e9249>] btrfs_print_leaf+0x29/0x8a0
Dec 25 17:58:41 [kernel] RSP: 0018:ffff8800da65b918  EFLAGS: 00010296
Dec 25 17:58:41 [kernel] RAX: 00000000ffffffe4 RBX: 0000000000000000 RCX: ffff8800da65bfd8
Dec 25 17:58:41 [kernel] RDX: ffff8800da65a000 RSI: 0000000000000000 RDI: ffff88011ea4c000
Dec 25 17:58:41 [kernel] RBP: ffff8800da65b998 R08: 000000000000fffc R09: 000000000000fffe
Dec 25 17:58:41 [kernel] R10: 00000000ffffffe4 R11: ffff88011eee5d40 R12: 0000000000000002
Dec 25 17:58:41 [kernel] R13: 0000005c07c18000 R14: 0000000000000000 R15: 0000000000000000
Dec 25 17:58:41 [kernel] FS:  00007f2b184f4710(0000) GS:ffff8800dfc00000(0000) knlGS:0000000000000000
Dec 25 17:58:41 [kernel] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Dec 25 17:58:41 [kernel] CR2: 0000000000000030 CR3: 00000000daded000 CR4: 00000000000006f0
Dec 25 17:58:41 [kernel] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec 25 17:58:41 [kernel] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec 25 17:58:41 [kernel] Process qemu-kvm (pid: 3031, threadinfo ffff8800da65a000, task ffff88011ff13c00)
Dec 25 17:58:41 [kernel]  0000005c07c18000 ffffffff1341c340 ffff88011ea4c000 ffffffff8156ee40
Dec 25 17:58:41 [kernel]  ffff8800dfd11540 ffff88011c053750 0000005c07c18000 00000000001000a8
Dec 25 17:58:41 [kernel]  ffff8800da65bf00 ffff8800db2bab40 0000000000000002 ffff88011c053750
Dec 25 17:58:41 [kernel]  [<ffffffff8156ee40>] ? schedule+0x2e0/0xa00
Dec 25 17:58:41 [kernel]  [<ffffffff811e140d>] __btrfs_free_extent+0x64d/0x720
Dec 25 17:58:41 [kernel]  [<ffffffff81062db3>] ? hrtick_update+0x33/0x40
Dec 25 17:58:41 [kernel]  [<ffffffff8106c216>] ? dequeue_task_fair+0x56/0x60
Dec 25 17:58:41 [kernel]  [<ffffffff811e4c41>] run_clustered_refs+0x381/0x860
Dec 25 17:58:41 [kernel]  [<ffffffff8106682d>] ? select_idle_sibling+0xad/0x180
Dec 25 17:58:41 [kernel]  [<ffffffff81233f00>] ? btrfs_find_ref_cluster+0x80/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff811e51f8>] btrfs_run_delayed_refs+0xd8/0x240
Dec 25 17:58:41 [kernel]  [<ffffffff811f4d3e>] btrfs_commit_transaction+0x7e/0x760
Dec 25 17:58:41 [kernel]  [<ffffffff81094420>] ? autoremove_wake_function+0x0/0x40
Dec 25 17:58:41 [kernel]  [<ffffffff8106ead5>] ? wake_up_process+0x15/0x20
Dec 25 17:58:41 [kernel]  [<ffffffff81203c01>] btrfs_file_aio_write+0x621/0xa40
Dec 25 17:58:41 [kernel]  [<ffffffff8111895a>] do_sync_write+0xda/0x120
Dec 25 17:58:41 [kernel]  [<ffffffff81088981>] ? sys_kill+0xa1/0x1c0
Dec 25 17:58:41 [kernel]  [<ffffffff81118a4e>] vfs_write+0xae/0x160
Dec 25 17:58:41 [kernel]  [<ffffffff81118d12>] sys_pwrite64+0x72/0xa0
Dec 25 17:58:41 [kernel]  [<ffffffff8103aeab>] system_call_fastpath+0x16/0x1b
Dec 25 17:58:41 [kernel] RIP  [<ffffffff811e9249>] btrfs_print_leaf+0x29/0x8a0
Dec 25 17:58:41 [kernel]  RSP <ffff8800da65b918>
Dec 25 17:58:41 [kernel] ---[ end trace b3f0b4b8a48cf841 ]---
Dec 25 17:59:05 [kernel] SysRq : Emergency Sync
Dec 25 17:59:05 [kernel] Emergency Sync complete
-- 
Markus
