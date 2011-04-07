From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: 2.6.29-rc2 oops and assertion failure...
Date: Thu, 7 Apr 2011 15:21:25 +0800
Message-ID: <BANLkTikJJFqEs0F_wPdTinct0k_4uLh1hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When running a practical stress-test on 2.6.29-rc2 trying to reproduce
an older (extent refcounting) issue, I am consistently able to hit an
oops [1] and an assertion failure [2].

Here, I'm testing with 8 block ramdisks, configured in the kernel to
256MB each (intentionally testing free-space handling):

for i in `seq 0 7`; do mknod /dev/ram$i b 1 $i; dd if=/dev/zero
of=/dev/ram$i bs=1024k count=256; done
mkfs.btrfs -m raid10 -d raid10 /dev/ram0 /dev/ram1 /dev/ram2 /dev/ram3
/dev/ram4 /dev/ram5 /dev/ram6 /dev/ram7
mount /dev/ram0 /mnt -o space_cache,ssd,nobarrier,compress # try
without compress also
cp -xa / /mnt

the next steps are executed in parallel:

while :; do cp -xa / /mnt; done &
while :; do btrfs filesystem balance /mnt; done &
while :; do find /mnt -print0 | xargs -0 btrfs filesystem defragment -c; done &

--- [1]

general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/bus/hid/drivers/generic-usb/new_id
CPU 0
Modules linked in: brd loop [last unloaded: brd]

Pid: 28000, comm: btrfs Tainted: G        W   2.6.39-rc2-350cd #2
Supermicro X8STi/X8STi
RIP: 0010:[<ffffffff812d40a4>]  [<ffffffff812d40a4>]
btrfs_write_out_cache+0x9d4/0xdf0
RSP: 0018:ffff8802af913968  EFLAGS: 00010246
RAX: db73880000000000 RBX: 0000000000000000 RCX: 0000000000000200
RDX: 0000000000001000 RSI: ffff8802ba9b1048 RDI: db73880000000000
RBP: ffff8802af913ae8 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffff810e8130 R11: 0000000000000000 R12: ffff8802510a3be0
R13: ffff8802acf8b948 R14: ffff8802510a3bb0 R15: ffff8802b9f561c8
FS:  00007fabcef8d740(0000) GS:ffff88031fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000003c960c8 CR3: 00000002afa29000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs (pid: 28000, threadinfo ffff8802af912000, task ffff8803090d0000)
Stack:
 ffff8802af913988 0000000000000001 ffff8802af913998 ffff8802af913a88
 ffff8802af9139a8 0000000000000000 0000000000000040 ffff880215059770
 ffff880215059710 0000000000000010 ffff8802acf8b908 000000000000000f
Call Trace:
 [<ffffffff810506b1>] ? get_parent_ip+0x11/0x50
 [<ffffffff8105584d>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff8128a98b>] btrfs_write_dirty_block_groups+0x2ab/0x300
 [<ffffffff81296a35>] commit_cowonly_roots+0x105/0x1e0
 [<ffffffff8129782d>] btrfs_commit_transaction+0x37d/0x720
 [<ffffffff81080ad0>] ? wake_up_bit+0x40/0x40
 [<ffffffff812e0afc>] relocate_block_group+0x4bc/0x600
 [<ffffffff812e0de8>] btrfs_relocate_block_group+0x1a8/0x2d0
 [<ffffffff812c14ed>] btrfs_relocate_chunk+0x6d/0x3b0
 [<ffffffff810506b1>] ? get_parent_ip+0x11/0x50
 [<ffffffff8105584d>] ? sub_preempt_count+0x9d/0xd0
 [<ffffffff812c20dd>] btrfs_balance+0x20d/0x280
 [<ffffffff812c9ec0>] btrfs_ioctl+0x450/0x590
 [<ffffffff81152e8d>] do_vfs_ioctl+0x8d/0x330
 [<ffffffff81141444>] ? fget_light+0x274/0x3c0
 [<ffffffff81106cc0>] ? __do_fault+0x150/0x5d0
 [<ffffffff8115317a>] sys_ioctl+0x4a/0x80
 [<ffffffff81709ffb>] system_call_fastpath+0x16/0x1b
Code: 89 ad 38 ff ff ff 49 89 c7 4c 8b ad 48 ff ff ff e9 e4 00 00 00
66 90 40 f6 c7 04 0f 85 6e 01 00 00 89 d1 c1 e9 03 f6 c2 04 89 c9 <f3>
48 a5 74 09 8b 0e 89 0f b9 04 00 00 00 f6 c2 02 74 0e 44 0f
RIP  [<ffffffff812d40a4>] btrfs_write_out_cache+0x9d4/0xdf0
 RSP <ffff8802af913968>
---[ end trace a7919e7f17c0a728 ]---

--- [2]

kernel BUG at fs/btrfs/relocation.c:4282!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
CPU 0
Modules linked in: brd loop

Pid: 7775, comm: flush-btrfs-1 Tainted: G        W   2.6.39-rc2-350cd
#2 Supermicro X8STi/X8STi
RIP: 0010:[<ffffffff812da5ab>]  [<ffffffff812da5ab>]
btrfs_reloc_cow_block+0x28b/0x2c0
RSP: 0018:ffff8803057817f0  EFLAGS: 00010246
RAX: ffff880305728000 RBX: ffff880305640000 RCX: ffff880235d92e40
RDX: ffff880209c1f5f0 RSI: ffff880308bdd168 RDI: ffff8802ff1fb220
RBP: ffff880305781850 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff812d8630 R11: 0000000000000000 R12: ffff880308bdd168
R13: ffff880209c1f5f0 R14: ffff8802ff1fb220 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88031fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f7355663650 CR3: 00000001f75f7000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process flush-btrfs-1 (pid: 7775, threadinfo ffff880305780000, task
ffff880308fa8000)
Stack:
 ffff880305781850 ffffffff81276c5d fffffffffffffff7 ffffea0006cd7e90
 0000000000000000 ffff880235d92e40 ffff880305781850 ffff880308bdd168
 ffff880235d92e40 ffff880209c1f5f0 ffff8802ff1fb220 0000000000000000
Call Trace:
 [<ffffffff81276c5d>] ? update_ref_for_cow+0x26d/0x360
 [<ffffffff81277401>] __btrfs_cow_block+0x6b1/0x980
 [<ffffffff81277e4b>] btrfs_cow_block+0x11b/0x2c0
 [<ffffffff8127b915>] btrfs_search_slot+0x3c5/0x790
 [<ffffffff812762d5>] ? btrfs_alloc_path+0x15/0x30
 [<ffffffff812a1640>] btrfs_truncate_inode_items+0x110/0x770
 [<ffffffff810506b1>] ? get_parent_ip+0x11/0x50
 [<ffffffff817094d0>] ? _raw_spin_unlock+0x30/0x60
 [<ffffffff812a21fb>] btrfs_evict_inode+0x18b/0x200
 [<ffffffff8115b511>] evict+0x81/0x180
 [<ffffffff8115b9c6>] iput_final+0xe6/0x1a0
 [<ffffffff8115bab6>] iput+0x36/0x50
 [<ffffffff811672de>] writeback_sb_inodes+0x12e/0x1d0
 [<ffffffff81167e9b>] writeback_inodes_wb+0x7b/0x180
 [<ffffffff8116825b>] wb_writeback+0x2bb/0x320
 [<ffffffff8115c882>] ? get_nr_inodes+0x62/0xb0
 [<ffffffff811684dc>] wb_do_writeback+0x21c/0x230
 [<ffffffff81168582>] bdi_writeback_thread+0x92/0x180
 [<ffffffff811684f0>] ? wb_do_writeback+0x230/0x230
 [<ffffffff81080596>] kthread+0xb6/0xc0
 [<ffffffff8109629d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff8170b154>] kernel_thread_helper+0x4/0x10
 [<ffffffff81055718>] ? finish_task_switch+0x78/0x110
 [<ffffffff81709884>] ? retint_restore_args+0xe/0xe
 [<ffffffff810804e0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8170b150>] ? gs_change+0xb/0xb
Code: ff ff e8 79 bf 42 00 e9 ae fe ff ff eb 02 90 90 e8 6b bf 42 00
eb 01 90 e9 33 fe ff ff 48 83 be 47 01 00 00 f7 0f 85 c2 fd ff ff <0f>
0b eb fe 48 3b 50 20 0f 84 04 ff ff ff 0f 0b eb fe 83 7d c4
RIP  [<ffffffff812da5ab>] btrfs_reloc_cow_block+0x28b/0x2c0
 RSP <ffff8803057817f0>
---[ end trace a7919e7f17c0a728 ]---
-- 
Daniel J Blueman
