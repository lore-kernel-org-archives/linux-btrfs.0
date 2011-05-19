From: Christian Brunner <chb@muc.de>
Subject: kernel BUG at fs/btrfs/extent-tree.c:5637!
Date: Thu, 19 May 2011 09:40:04 +0200
Message-ID: <BANLkTik5u3NaF12_CtADvcogaWVAGwLk3Q@mail.gmail.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we are running a ceph cluster with a btrfs store. Last night we ran
across this btrfs BUG.

Any hints on how to solve this are welcome.

Regards
Christian

May 19 06:10:07 os00 kernel: [247212.342712] ------------[ cut here
]------------
May 19 06:10:07 os00 kernel: [247212.347953] kernel BUG at
fs/btrfs/extent-tree.c:5637!
May 19 06:10:07 os00 kernel: [247212.353773] invalid opcode: 0000 [#1] SMP
May 19 06:10:07 os00 kernel: [247212.358449] last sysfs file:
/sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
May 19 06:10:07 os00 kernel: [247212.367268] CPU 6
May 19 06:10:07 os00 kernel: [247212.369407] Modules linked in: btrfs
zlib_deflate libcrc32c bonding ipv6 serio_raw pcspkr ghes hed iTCO_wdt
iTCO_vendor_support i7core_edac edac_core ixgbe mdio iomemory_vsl(P)
hpsa igb dca squashfs usb_storage [last unloaded: scsi_wait_scan]
May 19 06:10:07 os00 kernel: [247212.393864]
May 19 06:10:07 os00 kernel: [247212.395618] Pid: 3074, comm: cosd
Tainted: P            2.6.38.6-1.fits.3.el6.x86_64 #1 HP ProLiant
DL180 G6
May 19 06:10:07 os00 kernel: [247212.406885] RIP:
0010:[<ffffffffa025fdcd>]  [<ffffffffa025fdcd>]
run_clustered_refs+0x54d/0x800 [btrfs]
May 19 06:10:07 os00 kernel: [247212.417468] RSP:
0018:ffff8805dc6b99b8  EFLAGS: 00010282
May 19 06:10:07 os00 kernel: [247212.423482] RAX: 00000000ffffffef
RBX: ffff88037570ac00 RCX: ffff8805dc6b8000
May 19 06:10:07 os00 kernel: [247212.431528] RDX: 0000000000000008
RSI: ffff880000000000 RDI: ffff8805c7acabb0
May 19 06:10:07 os00 kernel: [247212.439572] RBP: ffff8805dc6b9a98
R08: 0000000000000001 R09: 0000000000000001
May 19 06:10:07 os00 kernel: [247212.447617] R10: ffff8805e0947000
R11: ffff8802e7e04480 R12: ffff8805ac2150c0
May 19 06:10:07 os00 kernel: [247212.455663] R13: ffff8804e758bc00
R14: ffff8805e0963000 R15: ffff8802e7e04480
May 19 06:10:07 os00 kernel: [247212.463709] FS:
00007fc1691d2700(0000) GS:ffff8800bf2c0000(0000)
knlGS:0000000000000000
May 19 06:10:07 os00 kernel: [247212.472820] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
May 19 06:10:07 os00 kernel: [247212.479317] CR2: 00007f907f6313b0
CR3: 00000005dfad1000 CR4: 00000000000006e0
May 19 06:10:07 os00 kernel: [247212.487363] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
May 19 06:10:07 os00 kernel: [247212.495408] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 19 06:10:07 os00 kernel: [247212.503453] Process cosd (pid: 3074,
threadinfo ffff8805dc6b8000, task ffff8805dc56e4c0)
May 19 06:10:07 os00 kernel: [247212.512563] Stack:
May 19 06:10:07 os00 kernel: [247212.514896]  0000000000000000
0000000000000000 ffff880400000001 0000000000000000
May 19 06:10:07 os00 kernel: [247212.523301]  ffff8805dfd1c000
ffff8805e1d71288 0000000000000000 ffff8805dc6b9ad8
May 19 06:10:07 os00 kernel: [247212.531673]  0000000000000000
0000000000000dd0 ffff8805e1d711d0 0000000000000002
May 19 06:10:07 os00 kernel: [247212.540054] Call Trace:
May 19 06:10:07 os00 kernel: [247212.542883]  [<ffffffffa02adf01>] ?
btrfs_find_ref_cluster+0x1/0x180 [btrfs]
May 19 06:10:07 os00 kernel: [247212.550840]  [<ffffffffa0260148>]
btrfs_run_delayed_refs+0xc8/0x230 [btrfs]
May 19 06:10:07 os00 kernel: [247212.558700]  [<ffffffffa026d6a1>]
__btrfs_end_transaction+0x71/0x210 [btrfs]
May 19 06:10:07 os00 kernel: [247212.566685]  [<ffffffffa026d895>]
btrfs_end_transaction+0x15/0x20 [btrfs]
May 19 06:10:07 os00 kernel: [247212.574382]  [<ffffffffa0273a2a>]
btrfs_dirty_inode+0x8a/0x130 [btrfs]
May 19 06:10:07 os00 kernel: [247212.581752]  [<ffffffff8117fa7f>]
__mark_inode_dirty+0x3f/0x1e0
May 19 06:10:07 os00 kernel: [247212.588446]  [<ffffffff811715ac>]
file_update_time+0xec/0x170
May 19 06:10:07 os00 kernel: [247212.594952]  [<ffffffffa027cbb0>]
btrfs_file_aio_write+0x1d0/0x4e0 [btrfs]
May 19 06:10:07 os00 kernel: [247212.602709]  [<ffffffff8126ff31>] ?
ima_counts_get+0x61/0x140
May 19 06:10:07 os00 kernel: [247212.609214]  [<ffffffffa027c9e0>] ?
btrfs_file_aio_write+0x0/0x4e0 [btrfs]
May 19 06:10:07 os00 kernel: [247212.616970]  [<ffffffff81158ff3>]
do_sync_readv_writev+0xd3/0x110
May 19 06:10:07 os00 kernel: [247212.623855]  [<ffffffff81163d42>] ?
path_put+0x22/0x30
May 19 06:10:07 os00 kernel: [247212.629675]  [<ffffffff812584a3>] ?
selinux_file_permission+0xf3/0x150
May 19 06:10:07 os00 kernel: [247212.637044]  [<ffffffff81251583>] ?
security_file_permission+0x23/0x90
May 19 06:10:07 os00 kernel: [247212.644415]  [<ffffffff81159f14>]
do_readv_writev+0xd4/0x1e0
May 19 06:10:07 os00 kernel: [247212.650818]  [<ffffffff81540d91>] ?
mutex_lock+0x31/0x60
May 19 06:10:07 os00 kernel: [247212.656832]  [<ffffffff8115a066>]
vfs_writev+0x46/0x60
May 19 06:10:07 os00 kernel: [247212.662653]  [<ffffffff8115a1a1>]
sys_writev+0x51/0xc0
May 19 06:10:07 os00 kernel: [247212.668477]  [<ffffffff8100c002>]
system_call_fastpath+0x16/0x1b
May 19 06:10:07 os00 kernel: [247212.675264] Code: 48 8b 75 a0 48 8b
7d a8 ba b0 00 00 00 e8 7c 6c 02 00 48 8b 95 78 ff ff ff 48 8b 75 a0
48 8b 7d a8 e8 68 6b 02 00 e9 04 ff ff ff <0f> 0b eb fe 0f 0b eb fe 0f
0b 66 0f 1f 84 00 00 00 00 00 eb f5
May 19 06:10:07 os00 kernel: [247212.697014] RIP  [<ffffffffa025fdcd>]
run_clustered_refs+0x54d/0x800 [btrfs]
May 19 06:10:07 os00 kernel: [247212.704981]  RSP <ffff8805dc6b99b8>
May 19 06:10:07 os00 kernel: [247212.709579] ---[ end trace
b0954a112f69e38b ]---
