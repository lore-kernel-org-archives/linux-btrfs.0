From: "Alexander Piavlo" <piavka@cs.bgu.ac.il>
Subject: error during umuont after set-default with 2.6.34-rc2
Date: Sun, 21 Mar 2010 22:45:11 +0200
Message-ID: <201003212045.o2LKjBgg002162@indigo.cs.bgu.ac.il>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
trying the new btrfs tool and set-default with 2.6.34-rc2 i hit the the
following problem:

mkfs.btrfs -d single /dev/sys/btrfs
mount -t btrfs /dev/sys/btrfs /btrfs
btrfs subvolume create /btrfs/newroot
mkdir /btrfs/newroot/.btrfs
btrfs subvolume set-default 256 /btrfs
umount /btrfs
mount -t btrfs /dev/sys/btrfs /btrfs

up till now everything works ok

A question How do i access or mount the original root of btrfs? Which
tree id does it have?
It would be great if "btrfs subvolume list ..." would also list the
original root.

I guessed I need to use 0, so i tried:
  mount -t btrfs -o subvol=0 /dev/sys/btrfs /btrfs/.btrfs
and:
  mount -t btrfs -o subvol=. /dev/sys/btrfs /btrfs/.btrfs
but in both cases it mounted the newroot subvolume with id 256 under
/btrfs/.btrfs

So I tried setting the original root back with:
  btrfs subvolume set-default 0 /btrfs

and next umount with:
   umount /btrfs
BUT the unmount got stuck and i got the following trace



[72657.249428] BUG: unable to handle kernel NULL pointer dereference at 00000000000001e0
[72657.256085] IP: [<ffffffff8111493a>] bio_get_nr_vecs+0x10/0x3b
[72657.269999] PGD 0
[72657.271328] Oops: 0000 [#2] SMP
[72657.274228] last sysfs file: /sys/devices/virtual/block/dm-13/uevent
[72657.290252] CPU 8
[72657.291527] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
[72657.309520]
[72657.310450] Pid: 22580, comm: flush-btrfs-16 Tainted: G      D 2.6.34-rc2 #1 Not Available         /Not Available
[72657.330925] RIP: 0010:[<ffffffff8111493a>]  [<ffffffff8111493a>] bio_get_nr_vecs+0x10/0x3b
[72657.338377] RSP: 0018:ffff88037ce639a0  EFLAGS: 00010246
[72657.351905] RAX: 0000000000000000 RBX: 0000000000000100 RCX:
000000000000e060
[72657.369112] RDX: ffffea0016b094a8 RSI: ffff88037c2aea10 RDI:
ffff88067e2eb0c0
[72657.376303] RBP: ffff88037ce639a0 R08: 0000000000001000 R09:
0000000000000000
[72657.391338] R10: 0008000000000000 R11: dead000000100100 R12:
0000000000000000
[72657.409371] R13: 0000000000000000 R14: 0000000000001000 R15:
0000000000001c0c
[72657.413345] FS:  0000000000000000(0000) GS:ffff880002100000(0000)
knlGS:0000000000000000
[72657.431689] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[72657.435338] CR2: 00000000000001e0 CR3: 0000000001a1b000 CR4:
00000000000006e0
[72657.452048] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[72657.469286] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[72657.474437] Process flush-btrfs-16 (pid: 22580, threadinfo
ffff88037ce62000, task ffff88037be74c50)
[72657.492828] Stack:
[72657.494314]  ffff88037ce63a00 ffffffffa0046cde 0000000000000000
000000000000e060
[72657.512301] <0> ffffea0016b094a8 ffff88037c2aea10 0000044100000282
ffffea0016b094a8
[72657.530760] <0> ffffea0016b094a8 0000000001c0c000 0000000000001c0d
0000000000001c0c
[72657.536518] Call Trace:
[72657.549071]  [<ffffffffa0046cde>] submit_extent_page+0xfd/0x1c1 [btrfs]
[72657.551996]  [<ffffffffa004ada4>] __extent_writepage+0x598/0x5f4 [btrfs]
[72657.569734]  [<ffffffffa0048e8f>] ?
end_bio_extent_writepage+0x0/0x160 [btrfs]
[72657.589129]  [<ffffffff810bd916>] ? activate_page+0x146/0x156
[72657.593942]  [<ffffffffa0048403>]
extent_write_cache_pages+0x16c/0x257 [btrfs]
[72657.609762]  [<ffffffffa0046de5>] ? flush_write_bio+0x0/0x10 [btrfs]
[72657.612899]  [<ffffffffa004a80c>] ? __extent_writepage+0x0/0x5f4 [btrfs]
[72657.629600]  [<ffffffff8103ae11>] ? load_balance+0x351/0xef1
[72657.631840]  [<ffffffffa0048542>] extent_writepages+0x54/0x69 [btrfs]
[72657.651442]  [<ffffffffa002a5f0>] ? btree_get_extent+0x0/0x190 [btrfs]
[72657.668832]  [<ffffffff81058682>] ? bit_waitqueue+0x19/0xa8
[72657.671772]  [<ffffffffa002b055>] btree_writepages+0x53/0x59 [btrfs]
[72657.688819]  [<ffffffff810bc236>] do_writepages+0x21/0x2a
[72657.692005]  [<ffffffff8110c3eb>] writeback_single_inode+0xe2/0x2d7
[72657.709688]  [<ffffffff8110d0c3>] writeback_inodes_wb+0x36e/0x44f
[72657.714306]  [<ffffffff8110d2e3>] wb_writeback+0x13f/0x1ba
[72657.729897]  [<ffffffff8108c526>] ? call_rcu_sched+0x15/0x17
[72657.733276]  [<ffffffff8108c536>] ? call_rcu+0xe/0x10
[72657.754040]  [<ffffffff8110d49a>] wb_do_writeback+0x7a/0x161
[72657.757423]  [<ffffffff8110d5c0>] bdi_writeback_task+0x3f/0xad
[72657.770202]  [<ffffffff810c9962>] ? bdi_start_fn+0x0/0xd6
[72657.774697]  [<ffffffff810c99d8>] bdi_start_fn+0x76/0xd6
[72657.790365]  [<ffffffff810c9962>] ? bdi_start_fn+0x0/0xd6
[72657.794878]  [<ffffffff810582a8>] kthread+0x82/0x8a
[72657.808548]  [<ffffffff81003a14>] kernel_thread_helper+0x4/0x10
[72657.812371]  [<ffffffff81410029>] ? restore_args+0x0/0x30
[72657.828787]  [<ffffffff81058226>] ? kthread+0x0/0x8a
[72657.832409]  [<ffffffff81003a10>] ? kernel_thread_helper+0x0/0x10
[72657.848453] Code: 48 8d 47 44 f0 ff 08 0f 94 c2 84 d2 74 0b 48 c7 47
08 00 00 00 00 ff 51 68 c9 c3 55 48 89 e5 0f 1f 44 00 00 48 8b 87 90 00
00 00 <48> 8b 80 e0 01 00 00 8b 90 34 04 00 00 0f b7 80 5a 04 00 00 c1
[72657.886666] RIP  [<ffffffff8111493a>] bio_get_nr_vecs+0x10/0x3b
[72657.890247]  RSP <ffff88037ce639a0>
[72657.894937] CR2: 00000000000001e0
[72657.907995] ---[ end trace 0e660d939479d800 ]---


BTW this is reproducible.

Another issue the set-default accepts all garbage input for example:
  btrfs subvolume set-default sfsdfsdfs /btrfs

So it would be good if this command was a little more verbose , and
would print that setting the new mount root actually succeeded or not
and not always return silently.

Thanks a lot
Alex

