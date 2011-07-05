From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [BUG] delayed inodes and reflinks
Date: Tue, 05 Jul 2011 15:25:12 +0200
Message-ID: <4E1310B8.40706@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I hit this bug an hour ago while executing some cp --reflink:

Jul  5 13:54:02 oglaroon kernel: [ 2654.545244] ------------[ cut here
]------------
Jul  5 13:54:02 oglaroon kernel: [ 2654.600508] kernel BUG at
fs/btrfs/delayed-inode.c:1637!
Jul  5 13:54:02 oglaroon kernel: [ 2654.664052] invalid opcode: 0000
[#1] SMP
Jul  5 13:54:02 oglaroon kernel: [ 2654.713244] last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.4/0000:04:00.0/net/eth3/broadcast
Jul  5 13:54:02 oglaroon kernel: [ 2654.819429] CPU 1
Jul  5 13:54:02 oglaroon kernel: [ 2654.841372] Modules linked in: btrfs
mpt2sas scsi_transport_sas raid_class [last unloaded: btrfs]
Jul  5 13:54:02 oglaroon kernel: [ 2654.950364]
Jul  5 13:54:02 oglaroon kernel: [ 2654.968147] Pid: 22343, comm: cp
Tainted: G        W   2.6.39+ #2 Supermicro X8SIL/X8SIL
Jul  5 13:54:02 oglaroon kernel: [ 2655.065386] RIP:
0010:[<ffffffffa0222490>]  [<ffffffffa0222490>]
btrfs_delayed_update_inode+0x120/0x130 [btrfs]
Jul  5 13:54:02 oglaroon kernel: [ 2655.186237] RSP:
0018:ffff88023010dbd8  EFLAGS: 00010286
Jul  5 13:54:02 oglaroon kernel: [ 2655.249780] RAX: 00000000ffffffe4
RBX: ffff8802356bec40 RCX: 0000000000018000
Jul  5 13:54:02 oglaroon kernel: [ 2655.335164] RDX: 0000000000000047
RSI: 0000000000000000 RDI: ffff880230a84390
Jul  5 13:54:02 oglaroon kernel: [ 2655.420652] RBP: ffff88023010dc18
R08: ffffffff825eb2a0 R09: 0000000000000001
Jul  5 13:54:02 oglaroon kernel: [ 2655.506036] R10: 00000000000003e0
R11: ffff8802317c4560 R12: ffff8802356bec88
Jul  5 13:54:02 oglaroon kernel: [ 2655.591419] R13: ffff88023569c6f8
R14: ffff88023334f000 R15: ffff880234318000
Jul  5 13:54:02 oglaroon kernel: [ 2655.676803] FS:
00007f07d396c700(0000) GS:ffff88023fc40000(0000) knlGS:0000000000000000
Jul  5 13:54:02 oglaroon kernel: [ 2655.773733] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Jul  5 13:54:02 oglaroon kernel: [ 2655.842476] CR2: 0000000000407407
CR3: 0000000230974000 CR4: 00000000000006e0
Jul  5 13:54:02 oglaroon kernel: [ 2655.927859] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Jul  5 13:54:02 oglaroon kernel: [ 2656.013245] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul  5 13:54:02 oglaroon kernel: [ 2656.098733] Process cp (pid: 22343,
threadinfo ffff88023010c000, task ffff8802317c3e80)
Jul  5 13:54:02 oglaroon kernel: [ 2656.194516] Stack:
Jul  5 13:54:02 oglaroon kernel: [ 2656.218540]  ffff88023010dc38
0000000000018000 000000000000013b ffff88023569c6f8
Jul  5 13:54:02 oglaroon kernel: [ 2656.307564]  ffff88023334f000
ffff88023569c6f8 ffff88023568d000 0000000000000000
Jul  5 13:54:02 oglaroon kernel: [ 2656.396483]  ffff88023010dc68
ffffffffa01db4de 0000000000000068 0000000000000000
Jul  5 13:54:02 oglaroon kernel: [ 2656.485403] Call Trace:
Jul  5 13:54:02 oglaroon kernel: [ 2656.514742]  [<ffffffffa01db4de>]
btrfs_update_inode+0x3e/0x150 [btrfs]
Jul  5 13:54:02 oglaroon kernel: [ 2656.593884]  [<ffffffffa0209160>]
btrfs_ioctl_clone+0x9e0/0xca0 [btrfs]
Jul  5 13:54:02 oglaroon kernel: [ 2656.673022]  [<ffffffff81151f00>] ?
might_fault+0x40/0xa0
Jul  5 13:54:02 oglaroon kernel: [ 2656.737613]  [<ffffffffa0209b05>]
btrfs_ioctl+0x335/0xf70 [btrfs]
Jul  5 13:54:02 oglaroon kernel: [ 2656.810612]  [<ffffffff81151f57>] ?
might_fault+0x97/0xa0
Jul  5 13:54:02 oglaroon kernel: [ 2656.875198]  [<ffffffff81151f0e>] ?
might_fault+0x4e/0xa0
Jul  5 13:54:02 oglaroon kernel: [ 2656.939782]  [<ffffffff81859006>] ?
_raw_spin_unlock+0x26/0x30
Jul  5 13:54:02 oglaroon kernel: [ 2657.009567]  [<ffffffff8117fcd3>] ?
cp_new_stat+0xf3/0x110
Jul  5 13:54:02 oglaroon kernel: [ 2657.075325]  [<ffffffff8118cb5c>]
do_vfs_ioctl+0x9c/0x560
Jul  5 13:54:02 oglaroon kernel: [ 2657.139982]  [<ffffffff818607ac>] ?
sysret_check+0x27/0x62
Jul  5 13:54:02 oglaroon kernel: [ 2657.205604]  [<ffffffff8118d0b9>]
sys_ioctl+0x99/0xa0
Jul  5 13:54:02 oglaroon kernel: [ 2657.266133]  [<ffffffff8186077b>]
system_call_fastpath+0x16/0x1b
Jul  5 13:54:02 oglaroon kernel: [ 2657.337995] Code: f8 05 00 00 8d 0c
49 48 89 ca 48 89 4d c8 e8 c8 c7 f9 ff 85 c0 48 8b 4d c8 75 10 48 89 4b
08 e9 3d ff ff ff 0f 1f 80 00 00 00 00 <0f> 0b eb fe 66 66 66 2e 0f 1f
84 00 00 00 00 00 55 48 89 e5 41
Jul  5 13:54:02 oglaroon kernel: [ 2657.570642] RIP
[<ffffffffa0222490>] btrfs_delayed_update_inode+0x120/0x130 [btrfs]
Jul  5 13:54:02 oglaroon kernel: [ 2657.663516]  RSP <ffff88023010dbd8>
Jul  5 13:54:02 oglaroon kernel: [ 2657.705561] ---[ end trace
0ae6cc23c8022b5b ]---

I was testing some completely different modifications I made myself, but
I'm quite certain that my changes did not trigger this error. With the
fs I could reproducably get to this bug by creating 10 reflinks of a
certain file in a shell loop.

I lost the file system while trying to setup a clean, tight test case.
The fs I used had something like 50 files, some reflinks and a snapshot
with some files deleted. The tree had explicit backrefs and shared backrefs.

Anyway, I could not setup a new file system triggering this bug. The
line that triggered is the BUG_ON in btrfs_delayed_update_inode (line
1693 in for-linus branch). We seem to have missed some reservation in
some special case. The patch Miao sent some days ago does not
interrelate at first sight.

If I get back to a situation where I can reproduce the bug, I'll send a
follow up.

-Jan
