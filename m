Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51142 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbaLBXux (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 18:50:53 -0500
MIME-Version: 1.0
Message-ID: <trinity-58a6c021-4212-40c8-8b23-05ad063a1e7b-1417564251420@3capp-gmx-bs32>
From: "Konstantin Matuschek" <Konstantin.Matuschek@gmx.net>
To: linux-btrfs@vger.kernel.org
Subject: raid5 filesystem only mountable ro and not currently fixable after
 a drive produced read errors
Content-Type: text/plain; charset=UTF-8
Date: Wed, 3 Dec 2014 00:50:51 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a raid5 btrfs that refuses to mount rw (ro works) and I think I'm out of options to get it fixed.

First, this is roughly what got my filesystem corrupted:


1. I created the raid5 fs in March 2014 using the latest code available (Btrfs 3.12) on four 4TB devices (each encrypted using dm-crypt). I also created 3 subvolumes. The command used was:
mkfs.btrfs -O skinny-metadata -d raid5 -m raid5 /dev/mapper/wdred4tb[2345]


2. Around October I noticed one of the drived (wdred4tb3) produced read errors. Running a long smartctl self-test would fail as well and the reported "Raw_Read_Error_Rate" increased steadily.


3. Since I had a spare drive around, but replacing a device wasn't implemented back then for raid5, I decided to use the add-then-delete approach outlined here: http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Raid5-Status . I did *not* remove the failing drive for that.


4. The rebalance triggered by the "btrfs device delete /dev/mapper/wdred4tb3" command crashed a few times (and read errors kept increasing), but each time I started it, a few hundred GiB were moved over to the newly added device. But when 414GiB were left on the failing drive, it didn't get further. It now still looks like this:
# btrfs fi show /mnt/box
Label: none  uuid: 9f3a48b7-1b88-44f0-a387-f3712fc2c0b6
	Total devices 5 FS bytes used 4.43TiB
	devid    1 size 3.64TiB used 1.50TiB path /dev/mapper/wdred4tb2
	devid    2 size 3.64TiB used 414.00GiB path /dev/mapper/wdred4tb3
	devid    3 size 3.64TiB used 1.50TiB path /dev/mapper/wdred4tb4
	devid    4 size 3.64TiB used 1.50TiB path /dev/mapper/wdred4tb5
	devid    5 size 3.64TiB used 1.10TiB path /dev/mapper/wdred4tb1
Btrfs v3.17.2-50-gcc0723c


5. I tried several things (probably a new kernel around 3.17, propbably affected the snapshot-bug, but I don't use snapshots, only subvolumes) and ended up doing a "btrfsck --repair" (v3.17-rc3) on the filesystem. I still have the complete output of that, let me know if you need it. Here are some lines that seem interesting to me:
# btrfsck --repair /dev/mapper/wdred4tb2
enabling repair mode
Checking filesystem on /dev/mapper/wdred4tb2
UUID: 9f3a48b7-1b88-44f0-a387-f3712fc2c0b6
checking extents
Check tree block failed, want=500170752, have=5421517155842471019
Check tree block failed, want=500170752, have=5421517155842471019
Check tree block failed, want=500170752, have=5421517155842471019
read block failed check_tree_block
[...]
owner ref check failed [500170752 16384]
repair deleting extent record: key 500170752 169 0
adding new tree backref on start 500170752 len 16384 parent 7 root 7
[...]
repaired damaged extent references
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
Check tree block failed, want=500170752, have=5421517155842471019
Check tree block failed, want=500170752, have=5421517155842471019
Check tree block failed, want=500170752, have=5421517155842471019
read block failed check_tree_block
[...]
Check tree block failed, want=668598272, have=668794880
Csum didn't match
[...]
checking csums
Check tree block failed, want=500170752, have=5421517155842471019
Check tree block failed, want=500170752, have=5421517155842471019
Check tree block failed, want=500170752, have=5421517155842471019
read block failed check_tree_block
Error going to next leaf -5
checking root refs
found 1469190132145 bytes used err is 0
total csum bytes: 4750630700
total tree bytes: 6141100032
total fs tree bytes: 345964544
total extent tree bytes: 194052096
btree space waste bytes: 867842012
file data blocks allocated: 4865657503744
 referenced 4895640494080
Btrfs v3.17-rc3
extent buffer leak: start 842235904 len 16384
extent buffer leak: start 842235904 len 16384
[...]


6. As far as I can remember, that was the point when mounting rw stopped working. Mounting ro seems to work quite fine though (no idea if data was lost/corrupted).



I removed the failing drive today and updated to the latest "integration" branch of cmason's git repository (including Miao Xie's patches for raid56 replacement) and David's "integration-20141125" branch for btrfs-progs. With those, I tried a mount with "-o ro,degraded,recovery" (works, but didn't recover). I also tried a btrfsck again, but it just prints some errors and then exits.
Mounting rw with "-o degraded" gives the following output in dmesg:

[ 7358.907119] BTRFS: open /dev/dm-4 failed
[ 7358.907860] BTRFS info (device dm-6): allowing degraded mounts
[ 7358.907866] BTRFS info (device dm-6): enabling auto recovery
[ 7358.907870] BTRFS info (device dm-6): disk space caching is enabled
[ 7358.907872] BTRFS: has skinny extents
[ 7360.549993] BTRFS: bdev /dev/dm-4 errs: wr 0, rd 22288, flush 0, corrupt 0, gen 0
[ 7377.923939] BTRFS info (device dm-6): The free space cache file (7065489637376) is invalid. skip it

[ 7383.443486] BTRFS (device dm-6): parent transid verify failed on 118800384 wanted 170428 found 170413
[ 7383.443551] BTRFS (device dm-6): parent transid verify failed on 118800384 wanted 170428 found 170413
[ 7387.181313] BTRFS (device dm-6): parent transid verify failed on 129810432 wanted 170426 found 170413
[ 7387.181442] BTRFS (device dm-6): parent transid verify failed on 129810432 wanted 170426 found 170413
[ 7387.233449] BTRFS (device dm-6): parent transid verify failed on 285491200 wanted 170428 found 170414
[ 7387.233504] BTRFS (device dm-6): parent transid verify failed on 285491200 wanted 170428 found 170414
[ 7387.233507] ------------[ cut here ]------------
[ 7387.233511] WARNING: CPU: 2 PID: 3433 at fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4f/0x120()
[ 7387.233512] BTRFS: Transaction aborted (error -5)
[ 7387.233513] Modules linked in: f71882fg vfat fat raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx md_mod mpt2sas usbhid uas raid_class scsi_transport_sas coretemp hwmon x86_pkg_temp_thermal microcode evdev lpc_ich i2c_i801 mfd_core efivarfs
[ 7387.233528] CPU: 2 PID: 3433 Comm: mount Tainted: G        W      3.18.0-rc5+ #5
[ 7387.233529] Hardware name: MSI MS-7751/Z77A-GD65 (MS-7751), BIOS V10.11 10/09/2013
[ 7387.233530]  0000000000000009 ffff8800ce67b6c8 ffffffff8163941b 0000000000000000
[ 7387.233532]  ffff8800ce67b718 ffff8800ce67b708 ffffffff81075747 0000000010b8c000
[ 7387.233534]  00000000fffffffb ffff8801fdb56800 ffff8800c60dcbc8 ffffffff8182fa30
[ 7387.233536] Call Trace:
[ 7387.233541]  [<ffffffff8163941b>] dump_stack+0x46/0x58
[ 7387.233544]  [<ffffffff81075747>] warn_slowpath_common+0x77/0xa0
[ 7387.233546]  [<ffffffff810757b1>] warn_slowpath_fmt+0x41/0x50
[ 7387.233548]  [<ffffffff811d5eaf>] __btrfs_abort_transaction+0x4f/0x120
[ 7387.233551]  [<ffffffff811e89d3>] __btrfs_free_extent+0x2f3/0xbf0
[ 7387.233555]  [<ffffffff8124a653>] ? btrfs_delayed_ref_lock+0x33/0x240
[ 7387.233557]  [<ffffffff811ed9f8>] __btrfs_run_delayed_refs+0x7f8/0xff0
[ 7387.233560]  [<ffffffff811f2129>] btrfs_run_delayed_refs.part.69+0x69/0x280
[ 7387.233561]  [<ffffffff811f2845>] btrfs_write_dirty_block_groups+0x445/0x6a0
[ 7387.233564]  [<ffffffff81200841>] commit_cowonly_roots+0x181/0x240
[ 7387.233567]  [<ffffffff81202a05>] btrfs_commit_transaction+0x525/0xae0
[ 7387.233569]  [<ffffffff8120304e>] ? start_transaction+0x8e/0x520
[ 7387.233571]  [<ffffffff81252b21>] btrfs_recover_relocation+0x2b1/0x3d0
[ 7387.233573]  [<ffffffff81200063>] open_ctree+0x19d3/0x1fd0
[ 7387.233575]  [<ffffffff811d77f7>] btrfs_mount+0x637/0x8b0
[ 7387.233578]  [<ffffffff81123549>] ? pcpu_next_unpop+0x39/0x50
[ 7387.233581]  [<ffffffff81159944>] mount_fs+0x14/0xc0
[ 7387.233584]  [<ffffffff81172276>] vfs_kern_mount+0x66/0x110
[ 7387.233586]  [<ffffffff81174d86>] do_mount+0x1c6/0xa50
[ 7387.233589]  [<ffffffff8110d229>] ? __get_free_pages+0x9/0x50
[ 7387.233590]  [<ffffffff81174a85>] ? copy_mount_options+0x35/0x150
[ 7387.233592]  [<ffffffff811758fa>] SyS_mount+0x6a/0xb0
[ 7387.233595]  [<ffffffff8163fb70>] tracesys_phase2+0xd4/0xd9
[ 7387.233596] ---[ end trace 17bd9f1f47042dcc ]---
[ 7387.233598] BTRFS: error (device dm-6) in __btrfs_free_extent:5977: errno=-5 IO failure
[ 7387.233600] BTRFS: error (device dm-6) in btrfs_run_delayed_refs:2792: errno=-5 IO failure
[ 7387.734024] BTRFS warning (device dm-6): Skipping commit of aborted transaction.
[ 7387.734047] BTRFS: error (device dm-6) in cleanup_transaction:1670: errno=-5 IO failure
[ 7387.743503] BTRFS: failed to recover relocation
[ 7387.923312] BTRFS warning (device dm-6): page private not zero on page 42024960
[ 7387.923316] BTRFS warning (device dm-6): page private not zero on page 42029056
[ 7387.923318] BTRFS warning (device dm-6): page private not zero on page 42033152
[ 7387.923319] BTRFS warning (device dm-6): page private not zero on page 42037248
[ 7387.940666] BTRFS: open_ctree failed




If this kind of corruption is something that btrfs could and should fix, I'd be happy to help with supplying more information or testing patches. I have quite a few dmesg.log's from the various steps I went through, so just ask if you need something.
I have most of the data backupped (the important stuff), but not all of it - therefore I'd be happy if fixing worked out, but if not, I don't mind too much ;-)


Please CC me directly since I'm not subscribed to the list.

Thanks and regards,
Luzipher
