From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: BUG at fs/btrfs/inode.c:841!
Date: Mon, 05 Dec 2011 14:49:16 +0100
Message-ID: <4EDCCBDC.1000402@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While running xfstest 013 with Chris' for-linus on an ssd I hit this the
following bug. Before, the system was freshly bootet and all I did was
insmod and starting "./check" in the xfstests directory. I cannot
reproduce it so far:

Dec  5 14:22:18 oglaroon kernel: [ 1284.890509] device fsid
f3549a38-35ea-4fc4-a027-d473bc226620 devid 1 transid 15537 /dev/sdv2
Dec  5 14:22:18 oglaroon kernel: [ 1284.894758] Btrfs detected SSD
devices, enabling SSD mode
Dec  5 14:22:23 oglaroon kernel: [ 1286.466817] ------------[ cut here
]------------
Dec  5 14:22:23 oglaroon kernel: [ 1286.522351] kernel BUG at
fs/btrfs/inode.c:841!
Dec  5 14:22:23 oglaroon kernel: [ 1286.576855] invalid opcode: 0000
[#1] SMP
Dec  5 14:22:23 oglaroon kernel: [ 1286.626464] CPU 1
Dec  5 14:22:23 oglaroon kernel: [ 1286.648512] Modules linked in: btrfs
mpt2sas scsi_transport_sas raid_class
Dec  5 14:22:23 oglaroon kernel: [ 1286.733894]
Dec  5 14:22:23 oglaroon kernel: [ 1286.751785] Pid: 27856, comm:
fsstress Not tainted 3.1.0+ #9 Supermicro X8SIL/X8SIL
Dec  5 14:22:23 oglaroon kernel: [ 1286.844197] RIP:
0010:[<ffffffffa00712e3>]  [<ffffffffa00712e3>]
cow_file_range+0x383/0x3a0 [btrfs]
Dec  5 14:22:23 oglaroon kernel: [ 1286.953334] RSP:
0018:ffff880234fe59c8  EFLAGS: 00010286
Dec  5 14:22:23 oglaroon kernel: [ 1287.017092] RAX: 00000000ffffffe4
RBX: ffff8802271270e0 RCX: 0000000000000020
Dec  5 14:22:23 oglaroon kernel: [ 1287.102783] RDX: 0000000000000001
RSI: 0000000000000001 RDI: ffff880232a10000
Dec  5 14:22:23 oglaroon kernel: [ 1287.188582] RBP: ffff880234fe5a78
R08: 0000000000000000 R09: 0000000000000002
Dec  5 14:22:23 oglaroon kernel: [ 1287.274383] R10: 0000000000000000
R11: 0000000000000001 R12: 00000000000b8000
Dec  5 14:22:23 oglaroon kernel: [ 1287.360182] R13: 0000000000001000
R14: 00000000000b7fff R15: ffff8802271273e0
Dec  5 14:22:23 oglaroon kernel: [ 1287.445880] FS:
00007f1ca1e62700(0000) GS:ffff88023fc40000(0000) knlGS:0000000000000000
Dec  5 14:22:23 oglaroon kernel: [ 1287.543119] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Dec  5 14:22:23 oglaroon kernel: [ 1287.612175] CR2: 00007f1ca13515f0
CR3: 0000000233888000 CR4: 00000000000006e0
Dec  5 14:22:23 oglaroon kernel: [ 1287.698079] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Dec  5 14:22:23 oglaroon kernel: [ 1287.783878] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec  5 14:22:23 oglaroon kernel: [ 1287.869677] Process fsstress (pid:
27856, threadinfo ffff880234fe4000, task ffff88022f3f3ea0)
Dec  5 14:22:23 oglaroon kernel: [ 1287.972118] Stack:
Dec  5 14:22:23 oglaroon kernel: [ 1287.996247]  ffffffffffffffff
ffff880234fe5a28 0000000000000001 0000001000000008
Dec  5 14:22:23 oglaroon kernel: [ 1288.085687]  0000000000000000
ffff880227127118 ffffea0008a039c0 ffff8802345d9708
Dec  5 14:22:23 oglaroon kernel: [ 1288.175023]  ffff88022f19a800
0000000000001000 0000000000001000 ffff8802271270d8
Dec  5 14:22:23 oglaroon kernel: [ 1288.264474] Call Trace:
Dec  5 14:22:23 oglaroon kernel: [ 1288.293802]  [<ffffffffa0072237>]
run_delalloc_range+0x347/0x380 [btrfs]
Dec  5 14:22:23 oglaroon kernel: [ 1288.374434]  [<ffffffffa0085c18>]
__extent_writepage+0x598/0x720 [btrfs]
Dec  5 14:22:23 oglaroon kernel: [ 1288.454995]  [<ffffffff813af9e6>] ?
radix_tree_gang_lookup_tag_slot+0x96/0xe0
Dec  5 14:22:23 oglaroon kernel: [ 1288.540793]  [<ffffffff8113607b>] ?
find_get_pages_tag+0x11b/0x1b0
Dec  5 14:22:23 oglaroon kernel: [ 1288.615056]  [<ffffffffa008626a>]
T.1043+0x2fa/0x3a0 [btrfs]
Dec  5 14:22:23 oglaroon kernel: [ 1288.683073]  [<ffffffffa008634f>]
extent_writepages+0x3f/0x60 [btrfs]
Dec  5 14:22:23 oglaroon kernel: [ 1288.760552]  [<ffffffffa006d0b0>] ?
acls_after_inode_item+0xd0/0xd0 [btrfs]
Dec  5 14:22:23 oglaroon kernel: [ 1288.844193]  [<ffffffff813a9cbd>] ?
_atomic_dec_and_lock+0x4d/0x70
Dec  5 14:22:23 oglaroon kernel: [ 1288.918526]  [<ffffffffa006a842>]
btrfs_writepages+0x22/0x30 [btrfs]
Dec  5 14:22:23 oglaroon kernel: [ 1288.995116]  [<ffffffff8113deff>]
do_writepages+0x1f/0x40
Dec  5 14:22:23 oglaroon kernel: [ 1289.060076]  [<ffffffff81134970>]
__filemap_fdatawrite_range+0x80/0x90
Dec  5 14:22:23 oglaroon kernel: [ 1289.138481]  [<ffffffff81134b97>]
filemap_flush+0x17/0x20
Dec  5 14:22:23 oglaroon kernel: [ 1289.203384]  [<ffffffffa0068f52>]
btrfs_start_delalloc_inodes+0xd2/0x230 [btrfs]
Dec  5 14:22:23 oglaroon kernel: [ 1289.292296]  [<ffffffff811a9c30>] ?
__sync_filesystem+0x80/0x80
Dec  5 14:22:23 oglaroon kernel: [ 1289.363540]  [<ffffffffa00439b0>]
btrfs_sync_fs+0x30/0xc0 [btrfs]
Dec  5 14:22:23 oglaroon kernel: [ 1289.436882]  [<ffffffff811a9c09>]
__sync_filesystem+0x59/0x80
Dec  5 14:22:23 oglaroon kernel: [ 1289.506017]  [<ffffffff811a9c47>]
sync_one_sb+0x17/0x20
Dec  5 14:22:23 oglaroon kernel: [ 1289.568816]  [<ffffffff8118043e>]
iterate_supers+0x7e/0xe0
Dec  5 14:22:23 oglaroon kernel: [ 1289.634781]  [<ffffffff811a9c90>]
sys_sync+0x40/0x60
Dec  5 14:22:23 oglaroon kernel: [ 1289.694363]  [<ffffffff8188df3b>]
system_call_fastpath+0x16/0x1b
Dec  5 14:22:23 oglaroon kernel: [ 1289.766536] Code: 41 5d 41 5e 41 5f
c9 c3 48 8b 7d 88 4c 89 fe 4c 89 95 70 ff ff ff e8 ed 4b 00 00 4c 8b 95
70 ff ff ff e9 4f fd ff ff 0f 0b eb fe <0f> 0b eb fe 0f 0b eb fe 0f 0b
eb fe 0f 0b eb fe 0f 0b eb fe 66
Dec  5 14:22:23 oglaroon kernel: [ 1290.001054] RIP
[<ffffffffa00712e3>] cow_file_range+0x383/0x3a0 [btrfs]
Dec  5 14:22:23 oglaroon kernel: [ 1290.081758]  RSP <ffff880234fe59c8>
Dec  5 14:22:23 oglaroon kernel: [ 1290.123960] ---[ end trace
96c36b632cca59d5 ]---

Just for reference, the code goes like this:

 772 static noinline int cow_file_range(struct inode *inode,
...
 834         while (disk_num_bytes > 0) {
 835                 unsigned long op;
 836
 837                 cur_alloc_size = disk_num_bytes;
 838                 ret = btrfs_reserve_extent(trans, root, cur_alloc_size,
 839                                            root->sectorsize, 0,
alloc_hint,
 840                                            (u64)-1, &ins, 1);
 841                 BUG_ON(ret);

-Jan
