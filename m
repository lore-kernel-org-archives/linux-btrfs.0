From: Olivier Bonvalet <btrfs.list@daevel.fr>
Subject: Segfault on "btrfs subvolume delete" with kernel 3.3.4
Date: Mon, 30 Apr 2012 13:44:46 +0200
Message-ID: <4F9E7B2E.2030109@daevel.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

on a Xen paravirtualized VM running a 3.3.4 I obtain a "segfault" when 
doing a "btrfs subvolume delete" on a specific subvolume ; here the trace :

Apr 30 13:37:05 frozen kernel: [  238.508387] ------------[ cut here 
]------------
Apr 30 13:37:05 frozen kernel: [  238.508402] kernel BUG at 
fs/btrfs/inode.c:2951!
Apr 30 13:37:05 frozen kernel: [  238.508409] invalid opcode: 0000 [#1] SMP
Apr 30 13:37:05 frozen kernel: [  238.508418] CPU 1
Apr 30 13:37:05 frozen kernel: [  238.508422] Modules linked in: ipv6 
btrfs zram(C) nf_conntrack
Apr 30 13:37:05 frozen kernel: [  238.508439]
Apr 30 13:37:05 frozen kernel: [  238.508445] Pid: 2811, comm: btrfs 
Tainted: G         C   2.6.43.4-dae-xen #2
Apr 30 13:37:05 frozen kernel: [  238.508458] RIP: 
e030:[<ffffffffa004207f>]  [<ffffffffa004207f>] 
btrfs_unlink_subvol+0x184/0x1f9 [btrfs]
Apr 30 13:37:05 frozen kernel: [  238.508489] RSP: e02b:ffff880268299d18 
  EFLAGS: 00010286
Apr 30 13:37:05 frozen kernel: [  238.508496] RAX: 00000000ffffffe4 RBX: 
ffff880268af81b0 RCX: ffff880272180e58
Apr 30 13:37:05 frozen kernel: [  238.508504] RDX: ffff880268ace148 RSI: 
0000000000000000 RDI: ffff880268ace228
Apr 30 13:37:05 frozen kernel: [  238.508512] RBP: ffff88027055f090 R08: 
0000000000014580 R09: 00000000000006cf
Apr 30 13:37:05 frozen kernel: [  238.508520] R10: 00000000000006cf R11: 
0000000000000004 R12: ffff880272037400
Apr 30 13:37:05 frozen kernel: [  238.508528] R13: 0000000000000036 R14: 
ffff880268ae6000 R15: ffff880268ad9db8
Apr 30 13:37:05 frozen kernel: [  238.508541] FS: 
00007fa83d74c760(0000) GS:ffff88027ff5f000(0000) knlGS:0000000000000000
Apr 30 13:37:05 frozen kernel: [  238.508550] CS:  e033 DS: 0000 ES: 
0000 CR0: 000000008005003b
Apr 30 13:37:05 frozen kernel: [  238.508558] CR2: 00007fa83ccbe1a0 CR3: 
0000000271c10000 CR4: 0000000000002660
Apr 30 13:37:05 frozen kernel: [  238.508566] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Apr 30 13:37:05 frozen kernel: [  238.508575] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Apr 30 13:37:05 frozen kernel: [  238.508583] Process btrfs (pid: 2811, 
threadinfo ffff880268298000, task ffff880267d99320)
Apr 30 13:37:05 frozen kernel: [  238.508591] Stack:
Apr 30 13:37:05 frozen kernel: [  238.508596]  ffff880268ad9db8 
ffffffff0000001b ffff880268ace028 000000000000080c
Apr 30 13:37:05 frozen kernel: [  238.508611]  0000000000000116 
000000000000033a 3a00000000014bb6 8400000000000003
Apr 30 13:37:05 frozen kernel: [  238.508626]  ffffffffffffffff 
0000000000000005 ffff880268ad9d80 0000000000000000
Apr 30 13:37:05 frozen kernel: [  238.508641] Call Trace:
Apr 30 13:37:05 frozen kernel: [  238.508662]  [<ffffffffa005dcf0>] ? 
btrfs_ioctl_snap_destroy+0x2df/0x3ee [btrfs]
Apr 30 13:37:05 frozen kernel: [  238.508684]  [<ffffffffa005f4e3>] ? 
btrfs_ioctl+0x4fa/0xfb3 [btrfs]
Apr 30 13:37:05 frozen kernel: [  238.508697]  [<ffffffff810212ae>] ? 
do_page_fault+0x270/0x2da
Apr 30 13:37:05 frozen kernel: [  238.508707]  [<ffffffff81002d5c>] ? 
xen_write_msr_safe+0x73/0xb9
Apr 30 13:37:05 frozen kernel: [  238.508716]  [<ffffffff81002649>] ? 
xen_end_context_switch+0xe/0x1c
Apr 30 13:37:05 frozen kernel: [  238.508727]  [<ffffffff810057cf>] ? 
xen_restore_fl_direct_reloc+0x4/0x4
Apr 30 13:37:05 frozen kernel: [  238.508737]  [<ffffffff810051fc>] ? 
xen_force_evtchn_callback+0x9/0xa
Apr 30 13:37:05 frozen kernel: [  238.508748]  [<ffffffff810d495f>] ? 
do_vfs_ioctl+0x405/0x446
Apr 30 13:37:05 frozen kernel: [  238.508757]  [<ffffffff810051fc>] ? 
xen_force_evtchn_callback+0x9/0xa
Apr 30 13:37:05 frozen kernel: [  238.508767]  [<ffffffff810057e2>] ? 
check_events+0x12/0x20
Apr 30 13:37:05 frozen kernel: [  238.508776]  [<ffffffff810d49dc>] ? 
sys_ioctl+0x3c/0x60
Apr 30 13:37:05 frozen kernel: [  238.508786]  [<ffffffff812ffb39>] ? 
system_call_fastpath+0x16/0x1b
Apr 30 13:37:05 frozen kernel: [  238.508793] Code: 48 89 43 c8 e8 ca 21 
02 e1 4c 89 e6 4c 89 f7 48 89 53 70 48 89 53 60 48 89 da 48 89 43 68 48 
89 43 58 e8 54 d9 ff ff 85 c0 74 02 <0f> 0b 48 89 ef e8 b3 f8 fd ff 31 
c0 eb 05 b8 f4 ff ff ff 48 83
Apr 30 13:37:05 frozen kernel: [  238.508915] RIP  [<ffffffffa004207f>] 
btrfs_unlink_subvol+0x184/0x1f9 [btrfs]
Apr 30 13:37:05 frozen kernel: [  238.508937]  RSP <ffff880268299d18>
Apr 30 13:37:05 frozen kernel: [  238.508944] ---[ end trace 
2d6ae5b9b304acdb ]---


And now I have a "frozen" (= status D) process "btrfs-transacti" (for a 
different subvolume).

Is there something to do to fix that ?

Olivier
