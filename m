From: Piavlo <piavka@cs.bgu.ac.il>
Subject: Re: error during umuont after set-default with 2.6.34-rc2
Date: Sun, 21 Mar 2010 22:58:25 +0200
Message-ID: <4BA68871.2050309@cs.bgu.ac.il>
References: <201003212045.o2LKjBgg002162@indigo.cs.bgu.ac.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003212045.o2LKjBgg002162@indigo.cs.bgu.ac.il>
List-ID: <linux-btrfs.vger.kernel.org>

Got another one

[  365.232703] ------------[ cut here ]------------
[  365.244894] kernel BUG at fs/dcache.c:676!
[  365.244896] invalid opcode: 0000 [#1] SMP
[  365.244898] last sysfs file: /sys/devices/virtual/block/dm-13/uevent
[  365.244900] CPU 4
[  365.244901] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
[  365.244904]
[  365.244907] Pid: 5359, comm: mount Not tainted 2.6.34-rc2 #1 Not
Available         /Not Available
[  365.244910] RIP: 0010:[<ffffffff81101b02>]  [<ffffffff81101b02>]
shrink_dcache_for_umount_subtree+0x1b4/0x29d
[  365.244919] RSP: 0018:ffff88037b283c38  EFLAGS: 00010292
[  365.244920] RAX: 0000000000000067 RBX: ffff88067b558400 RCX:
0000000000000000
[  365.244922] RDX: ffff88038aa00000 RSI: 0000000000000046 RDI:
ffff88037b283a88
[  365.244924] RBP: ffff88037b283c68 R08: 0000000000018989 R09:
0000000000000000
[  365.244926] R10: ffff8800000b95e0 R11: 0000007d7b2839b8 R12:
ffff88067a99bb00
[  365.244928] R13: 0000000000000000 R14: ffff88067a99bb60 R15:
0000000000000000
[  365.244930] FS:  00007f9fb75c8730(0000) GS:ffff88038aa00000(0000)
knlGS:0000000000000000
[  365.244932] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  365.244934] CR2: 00007faafe17f850 CR3: 000000067c2c7000 CR4:
00000000000006e0
[  365.244935] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  365.244937] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  365.244939] Process mount (pid: 5359, threadinfo ffff88037b282000,
task ffff88037c6bb2e0)
[  365.244941] Stack:
[  365.244942]  ffff88067b558668 ffff88067c3fb800 ffff88067b558400
ffffffffa0063670
[  365.244944] <0> ffff88067b558400 ffff88067c3fd000 ffff88037b283c88
ffffffff81101c27
[  365.244946] <0> ffff88037b283d94 ffff88067b558400 ffff88037b283ca8
ffffffff810f34e0
[  365.244951] Call Trace:
[  365.244956]  [<ffffffff81101c27>] shrink_dcache_for_umount+0x3c/0x4c
[  365.244961]  [<ffffffff810f34e0>] generic_shutdown_super+0x1f/0x102
[  365.244964]  [<ffffffff810f3618>] kill_anon_super+0x16/0x4f
[  365.244967]  [<ffffffff810f36bf>] deactivate_locked_super+0x43/0x63
[  365.244979]  [<ffffffffa0016a80>] btrfs_get_sb+0x65c/0x6ff [btrfs]
[  365.244984]  [<ffffffff811080a0>] ? alloc_vfsmnt+0xa5/0x17a
[  365.244989]  [<ffffffff810e2afa>] ? alloc_pages_current+0x9b/0xa4
[  365.244992]  [<ffffffff810f3791>] vfs_kern_mount+0xb2/0x16d
[  365.244995]  [<ffffffff810f38b3>] do_kern_mount+0x4c/0xec
[  365.244997]  [<ffffffff81108ead>] do_mount+0x765/0x7de
[  365.245000]  [<ffffffff81107133>] ? copy_mount_options+0xd4/0x137
[  365.245003]  [<ffffffff81108faa>] sys_mount+0x84/0xbe
[  365.245007]  [<ffffffff8140f91a>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[  365.245011]  [<ffffffff81002c1b>] system_call_fastpath+0x16/0x1b
[  365.245013] Code: 38 49 8b 44 24 10 48 85 c0 74 04 48 8b 50 40 48 8d
86 68 02 00 00 48 c7 c7 7e da 76 81 48 89 04 24 4c 89 e6 31 c0 e8 62 be
30 00 <0f> 0b eb fe 49 8b 5c 24 28 49 39 dc 75 04 31 db eb 03 f0 ff 0b
[  365.245028] RIP  [<ffffffff81101b02>]
shrink_dcache_for_umount_subtree+0x1b4/0x29d
[  365.245031]  RSP <ffff88037b283c38>
[  365.245038] ---[ end trace 96c601e4dd23e97f ]---


On 03/21/2010 10:45 PM, Alexander Piavlo wrote:
> Hi,
> trying the new btrfs tool and set-default with 2.6.34-rc2 i hit the the
> following problem:
>
> mkfs.btrfs -d single /dev/sys/btrfs
> mount -t btrfs /dev/sys/btrfs /btrfs
> btrfs subvolume create /btrfs/newroot
> mkdir /btrfs/newroot/.btrfs
> btrfs subvolume set-default 256 /btrfs
> umount /btrfs
> mount -t btrfs /dev/sys/btrfs /btrfs
>
> up till now everything works ok
>
> A question How do i access or mount the original root of btrfs? Which
> tree id does it have?
> It would be great if "btrfs subvolume list ..." would also list the
> original root.
>
> I guessed I need to use 0, so i tried:
>   mount -t btrfs -o subvol=0 /dev/sys/btrfs /btrfs/.btrfs
> and:
>   mount -t btrfs -o subvol=. /dev/sys/btrfs /btrfs/.btrfs
> but in both cases it mounted the newroot subvolume with id 256 under
> /btrfs/.btrfs
>
> So I tried setting the original root back with:
>   btrfs subvolume set-default 0 /btrfs
>
> and next umount with:
>    umount /btrfs
> BUT the unmount got stuck and i got the following trace
>
>
>
> [72657.249428] BUG: unable to handle kernel NULL pointer dereference at 00000000000001e0
> [72657.256085] IP: [<ffffffff8111493a>] bio_get_nr_vecs+0x10/0x3b
> [72657.269999] PGD 0
> [72657.271328] Oops: 0000 [#2] SMP
> [72657.274228] last sysfs file: /sys/devices/virtual/block/dm-13/uevent
> [72657.290252] CPU 8
> [72657.291527] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
> [72657.309520]
> [72657.310450] Pid: 22580, comm: flush-btrfs-16 Tainted: G      D 2.6.34-rc2 #1 Not Available         /Not Available
> [72657.330925] RIP: 0010:[<ffffffff8111493a>]  [<ffffffff8111493a>] bio_get_nr_vecs+0x10/0x3b
> [72657.338377] RSP: 0018:ffff88037ce639a0  EFLAGS: 00010246
> [72657.351905] RAX: 0000000000000000 RBX: 0000000000000100 RCX:
> 000000000000e060
> [72657.369112] RDX: ffffea0016b094a8 RSI: ffff88037c2aea10 RDI:
> ffff88067e2eb0c0
> [72657.376303] RBP: ffff88037ce639a0 R08: 0000000000001000 R09:
> 0000000000000000
> [72657.391338] R10: 0008000000000000 R11: dead000000100100 R12:
> 0000000000000000
> [72657.409371] R13: 0000000000000000 R14: 0000000000001000 R15:
> 0000000000001c0c
> [72657.413345] FS:  0000000000000000(0000) GS:ffff880002100000(0000)
> knlGS:0000000000000000
> [72657.431689] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [72657.435338] CR2: 00000000000001e0 CR3: 0000000001a1b000 CR4:
> 00000000000006e0
> [72657.452048] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [72657.469286] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [72657.474437] Process flush-btrfs-16 (pid: 22580, threadinfo
> ffff88037ce62000, task ffff88037be74c50)
> [72657.492828] Stack:
> [72657.494314]  ffff88037ce63a00 ffffffffa0046cde 0000000000000000
> 000000000000e060
> [72657.512301] <0> ffffea0016b094a8 ffff88037c2aea10 0000044100000282
> ffffea0016b094a8
> [72657.530760] <0> ffffea0016b094a8 0000000001c0c000 0000000000001c0d
> 0000000000001c0c
> [72657.536518] Call Trace:
> [72657.549071]  [<ffffffffa0046cde>] submit_extent_page+0xfd/0x1c1 [btrfs]
> [72657.551996]  [<ffffffffa004ada4>] __extent_writepage+0x598/0x5f4 [btrfs]
> [72657.569734]  [<ffffffffa0048e8f>] ?
> end_bio_extent_writepage+0x0/0x160 [btrfs]
> [72657.589129]  [<ffffffff810bd916>] ? activate_page+0x146/0x156
> [72657.593942]  [<ffffffffa0048403>]
> extent_write_cache_pages+0x16c/0x257 [btrfs]
> [72657.609762]  [<ffffffffa0046de5>] ? flush_write_bio+0x0/0x10 [btrfs]
> [72657.612899]  [<ffffffffa004a80c>] ? __extent_writepage+0x0/0x5f4 [btrfs]
> [72657.629600]  [<ffffffff8103ae11>] ? load_balance+0x351/0xef1
> [72657.631840]  [<ffffffffa0048542>] extent_writepages+0x54/0x69 [btrfs]
> [72657.651442]  [<ffffffffa002a5f0>] ? btree_get_extent+0x0/0x190 [btrfs]
> [72657.668832]  [<ffffffff81058682>] ? bit_waitqueue+0x19/0xa8
> [72657.671772]  [<ffffffffa002b055>] btree_writepages+0x53/0x59 [btrfs]
> [72657.688819]  [<ffffffff810bc236>] do_writepages+0x21/0x2a
> [72657.692005]  [<ffffffff8110c3eb>] writeback_single_inode+0xe2/0x2d7
> [72657.709688]  [<ffffffff8110d0c3>] writeback_inodes_wb+0x36e/0x44f
> [72657.714306]  [<ffffffff8110d2e3>] wb_writeback+0x13f/0x1ba
> [72657.729897]  [<ffffffff8108c526>] ? call_rcu_sched+0x15/0x17
> [72657.733276]  [<ffffffff8108c536>] ? call_rcu+0xe/0x10
> [72657.754040]  [<ffffffff8110d49a>] wb_do_writeback+0x7a/0x161
> [72657.757423]  [<ffffffff8110d5c0>] bdi_writeback_task+0x3f/0xad
> [72657.770202]  [<ffffffff810c9962>] ? bdi_start_fn+0x0/0xd6
> [72657.774697]  [<ffffffff810c99d8>] bdi_start_fn+0x76/0xd6
> [72657.790365]  [<ffffffff810c9962>] ? bdi_start_fn+0x0/0xd6
> [72657.794878]  [<ffffffff810582a8>] kthread+0x82/0x8a
> [72657.808548]  [<ffffffff81003a14>] kernel_thread_helper+0x4/0x10
> [72657.812371]  [<ffffffff81410029>] ? restore_args+0x0/0x30
> [72657.828787]  [<ffffffff81058226>] ? kthread+0x0/0x8a
> [72657.832409]  [<ffffffff81003a10>] ? kernel_thread_helper+0x0/0x10
> [72657.848453] Code: 48 8d 47 44 f0 ff 08 0f 94 c2 84 d2 74 0b 48 c7 47
> 08 00 00 00 00 ff 51 68 c9 c3 55 48 89 e5 0f 1f 44 00 00 48 8b 87 90 00
> 00 00 <48> 8b 80 e0 01 00 00 8b 90 34 04 00 00 0f b7 80 5a 04 00 00 c1
> [72657.886666] RIP  [<ffffffff8111493a>] bio_get_nr_vecs+0x10/0x3b
> [72657.890247]  RSP <ffff88037ce639a0>
> [72657.894937] CR2: 00000000000001e0
> [72657.907995] ---[ end trace 0e660d939479d800 ]---
>
>
> BTW this is reproducible.
>
> Another issue the set-default accepts all garbage input for example:
>   btrfs subvolume set-default sfsdfsdfs /btrfs
>
> So it would be good if this command was a little more verbose , and
> would print that setting the new mount root actually succeeded or not
> and not always return silently.
>
> Thanks a lot
> Alex
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

