From: Dave <dave@thekilempire.com>
Subject: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)'
 failed.
Date: Tue, 2 Aug 2011 10:44:53 -0400
Message-ID: <20110802144452.GA15647@hendrix.borisch.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A power failure has left me with a broken btrfs.  Trying to mount the filesystem
with Kernel 3.0 gives me an unrecognized superblock error.  btrfs-debug-tree
spits out the folowing:

parent transid verify failed on 349129785344 wanted 120602 found 120627
parent transid verify failed on 349129785344 wanted 120602 found 120627
parent transid verify failed on 349129785344 wanted 120602 found 120627
btrfs-debug-tree: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)' failed.

btrfsck (with -s1) fails the same assertion, as do btrfs-zero-log and
btrfs-select-super.

Now here's something that's truly weird.  By booting an older kernel (2.6.34 in
this case), I am able to mount the filesystem as read-only.  Mounting produces
the following dmesg:

device fsid 6a417c5b1cfb7e42-d3aa784df5324d8e devid 1 transid 123587 /dev/sda1
parent transid verify failed on 349129785344 wanted 120602 found 120627
parent transid verify failed on 349129785344 wanted 120602 found 120627
parent transid verify failed on 349129785344 wanted 120602 found 120627

Attempting to copy a file off of this volume causes cp to give an Input/output
error and results in the following dmesg:

btrfs no csum found for inode 566 start 0
btrfs no csum found for inode 566 start 0
btrfs no csum found for inode 566 start 0
btrfs no csum found for inode 566 start 0
btrfs no csum found for inode 566 start 0
btrfs csum failed ino 566 extent 2194907136 csum 1712577361 wanted 0 mirror 0
btrfs no csum found for inode 566 start 0
btrfs no csum found for inode 566 start 0
btrfs no csum found for inode 566 start 0
btrfs no csum found for inode 566 start 0
btrfs no csum found for inode 566 start 0
--snip--
btrfs csum failed ino 566 extent 2194907136 csum 1712577361 wanted 0 mirror 1
btrfs csum failed ino 566 extent 2194907136 csum 1712577361 wanted 0 mirror 1
btrfs csum failed ino 566 extent 2194907136 csum 1712577361 wanted 0 mirror 1
btrfs csum failed ino 566 extent 2194907136 csum 1712577361 wanted 0 mirror 1
btrfs csum failed ino 566 extent 2194907136 csum 1712577361 wanted 0 mirror 1
btrfs csum failed ino 566 extent 2194907136 csum 1712577361 wanted 0 mirror 0
--snip--

(the actual output is almost 1000 lines)
The resulting file is simply zeros.

This happens for MOST of the files on the volume.  Attempting to rsync my data
to another volume results in 85% of the files being all zeros.

I can list all of my subvolumes:

ID 256 top level 5 path __active
ID 257 top level 5 path __active/home
ID 258 top level 5 path __active/usr
ID 259 top level 5 path __active/var
ID 407 top level 5 path __snapshot/home/weekly_2011-07-10_00:00:01.544862418
ID 581 top level 5 path __snapshot/home/weekly_2011-07-17_00:00:01.524232939
ID 759 top level 5 path __snapshot/home/weekly_2011-07-24_00:00:01.526621374
ID 809 top level 5 path __snapshot/home/daily_2011-07-26_00:00:01.524527287
ID 833 top level 5 path __snapshot/home/daily_2011-07-27_00:00:01.916055120
ID 859 top level 5 path __snapshot/home/daily_2011-07-28_00:00:01.686502790
ID 884 top level 5 path __snapshot/home/daily_2011-07-29_00:00:01.526246864
ID 909 top level 5 path __snapshot/home/daily_2011-07-30_00:00:01.520820006
ID 934 top level 5 path __snapshot/home/daily_2011-07-31_00:00:01.526377498
ID 935 top level 5 path __snapshot/home/weekly_2011-07-31_00:00:01.525911555
ID 960 top level 5 path __snapshot/home/daily_2011-08-01_00:00:01.640038038
ID 968 top level 5 path __snapshot/home/hourly_2011-08-01_08:00:01.538986109
ID 969 top level 5 path __snapshot/home/hourly_2011-08-01_09:00:01.558601454
ID 970 top level 5 path __snapshot/home/hourly_2011-08-01_10:00:01.795524373
ID 971 top level 5 path __snapshot/home/hourly_2011-08-01_11:00:01.536477883
ID 972 top level 5 path __snapshot/home/hourly_2011-08-01_12:00:01.828023102
ID 973 top level 5 path __snapshot/home/hourly_2011-08-01_13:00:01.776132934

The dmesg errors occur regardless of which subvolume I try to read data from.

So, I used ddrescue to copy the filesystem elsewhere and tried to mount rw.
Simply cd'ing into the filesystem results with the following kernel BUG:

kernel: btrfs: unlinked 2 orphans
kernel: ------------[ cut here ]------------
kernel: kernel BUG at fs/btrfs/extent-tree.c:1246!
kernel: invalid opcode: 0000 [#1] SMP 
kernel: last sysfs file: /sys/devices/virtual/bdi/btrfs-2/uevent
kernel: CPU 4 
kernel: Modules linked in: aes_x86_64 aes_generic xts gf128mul dm_crypt ipv6 ppdev parport_pc serio_raw parport i2c_i801 pcspkr i2c_core iTCO_wdt xhci_hcd iTCO_vendor_support raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear usb_storage firewire_ohci firewire_core pata_it8213 r8169 mii ata_generic pata_acpi
kernel: 
kernel: Pid: 4003, comm: ls Not tainted 2.6.34.01-alt158-amd64 #2 P55A-UD3/P55A-UD3
kernel: RIP: 0010:[<ffffffff813149a9>]  [<ffffffff813149a9>] lookup_inline_extent_backref+0xe3/0x3a9
kernel: RSP: 0000:ffff88011da71698  EFLAGS: 00010202
kernel: RAX: 0000000000000001 RBX: ffff8801e6650090 RCX: 0000000000000002
kernel: RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff8801e66503f0
kernel: RBP: ffff88011da71738 R08: ffff88011da71588 R09: ffff88011da71580
kernel: R10: ffff88011da71488 R11: ffff88011da71228 R12: 00000000000000b0
kernel: R13: ffff88008e241ac0 R14: 0000000000000001 R15: 0000000000000007
kernel: FS:  0000000000000000(0000) GS:ffff880002500000(0063) knlGS:00000000f759e6c0
kernel: CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
kernel: CR2: 0000000009761964 CR3: 000000012fe6d000 CR4: 00000000000006e0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel: Process ls (pid: 4003, threadinfo ffff88011da70000, task ffff88013ba05d40)
kernel: Stack:
kernel: ffff88011da716c8 ffffffff81310bd0 00000004e6650ad0 ffff88011da717f0
kernel: <0> 0000000000000000 0000005149c1c000 ffff88011da716d8 ffff8802135ff800
kernel: <0> ffffffff1da71728 0000000000000246 0000005149c1c000 00000000001000a8
kernel: Call Trace:
kernel: [<ffffffff81310bd0>] ? block_group_cache_tree_search+0x24/0x95
kernel: [<ffffffff8131596d>] __btrfs_free_extent+0xd8/0x64b
kernel: [<ffffffff81316379>] run_one_delayed_ref+0x499/0x4b5
kernel: [<ffffffff810ede0e>] ? __slab_free+0x81/0x22e
kernel: [<ffffffff8131281f>] ? btrfs_put_delayed_ref+0x53/0x57
kernel: [<ffffffff8131818d>] run_clustered_refs+0x255/0x2a7
kernel: [<ffffffff810ecd41>] ? virt_to_head_page+0xe/0x2f
kernel: [<ffffffff813182ad>] btrfs_run_delayed_refs+0xce/0x18e
kernel: [<ffffffff813211ba>] __btrfs_end_transaction+0x6a/0x146
kernel: [<ffffffff813212bb>] btrfs_end_transaction+0x10/0x12
kernel: [<ffffffff813286f9>] btrfs_delete_inode+0xf2/0x146
kernel: [<ffffffff8110e6ad>] generic_delete_inode+0x96/0x10b
kernel: [<ffffffff8110e73e>] generic_drop_inode+0x1c/0x5b
kernel: [<ffffffff8132261d>] btrfs_drop_inode+0x2b/0x2d
kernel: [<ffffffff8110d994>] iput+0x66/0x6a
kernel: [<ffffffff81329707>] btrfs_orphan_cleanup+0x1b5/0x1fd
kernel: [<ffffffff81329ab2>] btrfs_lookup_dentry+0x363/0x388
kernel: [<ffffffff81329aed>] btrfs_lookup+0x16/0x2f
kernel: [<ffffffff81103e37>] do_lookup+0xf5/0x18b
kernel: [<ffffffff811046d0>] link_path_walk+0x3d1/0x527
kernel: [<ffffffff81104916>] path_walk+0x4f/0x9f
kernel: [<ffffffff811061b1>] ? path_init+0xc4/0x14c
kernel: [<ffffffff81106263>] do_path_lookup+0x2a/0x8d
kernel: [<ffffffff81107507>] user_path_at+0x56/0x93
kernel: [<ffffffff8111169f>] ? mntput_no_expire+0x2c/0xef
kernel: [<ffffffff81103aac>] ? mntput+0x1d/0x1f
kernel: [<ffffffff810ff50c>] vfs_fstatat+0x37/0x62
kernel: [<ffffffff810ff592>] vfs_lstat+0x1e/0x20
kernel: [<ffffffff8102e58c>] sys32_lstat64+0x1f/0x39
kernel: [<ffffffff8102d8d2>] ia32_sysret+0x0/0x5
kernel: Code: 44 8b 45 a4 48 8b 75 98 48 8d 55 b0 41 b9 01 00 00 00 48 89 d9 4c 89 ef e8 57 a1 ff ff 83 f8 00 41 89 c6 0f 8c 94 02 00 00 74 04 <0f> 0b eb fe 4c 8b 33 8b 73 40 4c 89 f7 e8 1f fc ff ff 41 89 c7 
kernel: RIP  [<ffffffff813149a9>] lookup_inline_extent_backref+0xe3/0x3a9
kernel: RSP <ffff88011da71698>
kernel: ---[ end trace ef480fade4d32824 ]---

At this point ls segfaults and I can't unmount because "device is busy."  Hard
rebooting is the only to revive the system.  I'm wondering what my options are
at this point?
