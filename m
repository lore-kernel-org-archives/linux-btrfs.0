From: David Sterba <dave@jikos.cz>
Subject: [BUG, integration-test] fs/btrfs/inode.c:835
Date: Fri, 30 Sep 2011 00:05:13 +0200
Message-ID: <20110929220513.GH22205@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

xfstests/013 triggered this bug (I've never seen it before, though the
integration-test is basically the same what I was hammering with xfstests
recently):

[15572.066484] ------------[ cut here ]------------
[15572.068548] kernel BUG at fs/btrfs/inode.c:835!
[15572.068548] invalid opcode: 0000 [#1] SMP
[15572.068548] CPU 1
[15572.068548] Modules linked in: loop btrfs aoe [last unloaded: btrfs]
[15572.068548]
[15572.068548] Pid: 8543, comm: fsstress Not tainted 3.1.0-rc7-default+ #36 Intel Corporation Santa Rosa platform/Mat
anzas
[15572.068548] RIP: 0010:[<ffffffffa00de821>]  [<ffffffffa00de821>] cow_file_range+0x381/0x390 [btrfs]
[15572.068548] RSP: 0018:ffff880016f0f898  EFLAGS: 00010286
[15572.068548] RAX: 00000000ffffffe4 RBX: ffff880054854868 RCX: 0000000000000001

-ENOSPC

 828         while (disk_num_bytes > 0) {
 829                 unsigned long op;
 830
 831                 cur_alloc_size = disk_num_bytes;
 832                 ret = btrfs_reserve_extent(trans, root, cur_alloc_size,
 833                                            root->sectorsize, 0, alloc_hint,
 834                                            (u64)-1, &ins, 1);
 835                 BUG_ON(ret);


[15572.068548] RDX: ffff880016f0f8f8 RSI: 0000000000000001 RDI: ffff88004b784000
[15572.068548] RBP: ffff880016f0f948 R08: 0000000000000000 R09: 0000000000000001
[15572.068548] R10: 0000000000000000 R11: 86a0000000000000 R12: 000000000004d000
[15572.068548] R13: ffff8800548548b0 R14: 000000000004dfff R15: ffff880054854be8
[15572.068548] FS:  00007f96e66e2700(0000) GS:ffff88007e600000(0000) knlGS:0000000000000000
[15572.068548] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15572.068548] CR2: 00007f96e5ec9d50 CR3: 0000000012537000 CR4: 00000000000006e0
[15572.068548] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15572.068548] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[15572.068548] Process fsstress (pid: 8543, threadinfo ffff880016f0e000, task ffff88004b67d2c0)
[15572.068548] Stack:
[15572.068548]  ffffffffffffffff ffff880016f0f8f8 0000000000000001 ffffffff810d18dd
[15572.068548]  0000000000000000 ffff8800548548b0 ffff88007dad2d60 ffff880052022390
[15572.068548]  ffff88001f747000 0000000000001000 ffff880016f0fad8 ffff880054854860
[15572.068548] Call Trace:
[15572.068548]  [<ffffffff810d18dd>] ? lock_release_holdtime+0x3d/0x1a0
[15572.068548]  [<ffffffffa00df363>] run_delalloc_range+0x343/0x380 [btrfs]
[15572.068548]  [<ffffffff810c46df>] ? local_clock+0x6f/0x80
[15572.068548]  [<ffffffffa00f63b0>] __extent_writepage+0x5c0/0x750 [btrfs]
[15572.068548]  [<ffffffff810d18dd>] ? lock_release_holdtime+0x3d/0x1a0
[15572.068548]  [<ffffffff81139b3f>] ? find_get_pages_tag+0x10f/0x200
[15572.068548]  [<ffffffff81139b57>] ? find_get_pages_tag+0x127/0x200
[15572.068548]  [<ffffffffa00f676a>] extent_write_cache_pages.clone.0+0x22a/0x3b0 [btrfs]
[15572.068548]  [<ffffffff810c46df>] ? local_clock+0x6f/0x80
[15572.068548]  [<ffffffff810d7b91>] ? mark_held_locks+0x81/0x160
[15572.068548]  [<ffffffff81177e75>] ? kmem_cache_free+0xb5/0x110
[15572.068548]  [<ffffffffa00f6b36>] extent_writepages+0x46/0x60 [btrfs]
[15572.068548]  [<ffffffffa00daef0>] ? uncompress_inline+0x200/0x200 [btrfs]
[15572.068548]  [<ffffffffa00d9ef7>] btrfs_writepages+0x27/0x30 [btrfs]
[15572.068548]  [<ffffffff81143ea4>] do_writepages+0x24/0x40
[15572.068548]  [<ffffffff8113a1db>] __filemap_fdatawrite_range+0x5b/0x60
[15572.068548]  [<ffffffff8113b153>] filemap_fdatawrite_range+0x13/0x20
[15572.068548]  [<ffffffffa00f1857>] btrfs_wait_ordered_range+0x57/0x150 [btrfs]
[15572.068548]  [<ffffffffa00e1069>] btrfs_truncate+0xb9/0x670 [btrfs]
[15572.068548]  [<ffffffffa00e197c>] btrfs_setsize+0x4c/0xd0 [btrfs]
[15572.068548]  [<ffffffffa00e1abc>] btrfs_setattr+0xbc/0xd0 [btrfs]
[15572.068548]  [<ffffffff8118207a>] ? do_truncate+0x5a/0xa0
[15572.068548]  [<ffffffff811a026e>] notify_change+0x13e/0x360
[15572.068548]  [<ffffffff81182086>] do_truncate+0x66/0xa0
[15572.068548]  [<ffffffff8118221c>] sys_truncate+0x15c/0x1b0
[15572.068548]  [<ffffffff81be85c2>] system_call_fastpath+0x16/0x1b
[15572.068548] Code: 41 5c 41 5d 41 5e 41 5f c9 c3 48 8b 7d 88 4c 89 fe 4c 89 95 70 ff ff ff e8 bd 81 00 00 4c 8b 95 70 ff ff ff e9 52 fd ff ff 0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 1f 44 00 00 55 48 89 e5 41 57
[15572.068548] RIP  [<ffffffffa00de821>] cow_file_range+0x381/0x390 [btrfs]
[15572.068548]  RSP <ffff880016f0f898>
[15572.552342] ---[ end trace 6c8debc90a75da62 ]---


$ btrfs fi show
Label: none  uuid: e72aab6b-cb1e-45d2-81dc-6afb3773ab86
        Total devices 1 FS bytes used 92.00KB
        devid    1 size 10.00GB used 2.04GB path /dev/sda10

Label: none  uuid: 5e0e3c03-125d-4889-9118-cd57ff31f719
        Total devices 5 FS bytes used 247.46MB
        devid    5 size 10.00GB used 2.01GB path /dev/sda9
        devid    4 size 10.00GB used 2.01GB path /dev/sda8
        devid    3 size 10.00GB used 1.01GB path /dev/sda7
        devid    2 size 10.00GB used 1.01GB path /dev/sda6
        devid    1 size 10.00GB used 2.02GB path /dev/sda5

$ btrfs fi df /mnt/a1
Data, RAID10: total=2.00GB, used=242.25MB
Data: total=8.00MB, used=0.00
System, RAID10: total=16.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, RAID10: total=2.00GB, used=5.29MB
Metadata: total=8.00MB, used=4.00KB


processes in D state:

  PID TTY      STAT   TIME COMMAND
 8537 ?        D      0:00 [btrfs-transacti]
[<ffffffff810909af>] schedule+0x3f/0x60
[<ffffffffa00d6fe7>] btrfs_commit_transaction+0x247/0x8d0 [btrfs]
[<ffffffffa00cfe13>] transaction_kthread+0x283/0x2a0 [btrfs]
[<ffffffff810bd0f6>] kthread+0xa6/0xb0
[<ffffffff81be9844>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
 8575 pts/0    D+     0:00 mount -o remount,rw /dev/sda5
[<ffffffff810909af>] schedule+0x3f/0x60
[<ffffffff811ab9a9>] writeback_inodes_sb_nr+0x139/0x170
[<ffffffff811abd11>] writeback_inodes_sb+0x21/0x30
[<ffffffff811b2269>] __sync_filesystem+0x49/0x90
[<ffffffff811b231a>] sync_filesystem+0x3a/0x70
[<ffffffff81187931>] do_remount_sb+0x61/0x130
[<ffffffff811a57c4>] do_mount+0x5f4/0x7a0
[<ffffffff811a5d68>] sys_mount+0x98/0xf0
[<ffffffff81be85c2>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
 8576 ?        D      0:00 [flush-btrfs-151]
[<ffffffff810909af>] schedule+0x3f/0x60
[<ffffffff811389fe>] sleep_on_page+0xe/0x20
[<ffffffff811389e7>] __lock_page+0x67/0x70
[<ffffffffa00f6738>] extent_write_cache_pages.clone.0+0x1f8/0x3b0 [btrfs]
[<ffffffffa00f6b36>] extent_writepages+0x46/0x60 [btrfs]
[<ffffffffa00d9ef7>] btrfs_writepages+0x27/0x30 [btrfs]
[<ffffffff81143ea4>] do_writepages+0x24/0x40
[<ffffffff811ad7d4>] writeback_single_inode+0x184/0x420
[<ffffffff811ade80>] writeback_sb_inodes+0x1b0/0x270
[<ffffffff811ae0eb>] wb_writeback+0xdb/0x310
[<ffffffff811ae5bc>] wb_do_writeback+0xbc/0x250
[<ffffffff811ae7fb>] bdi_writeback_thread+0xab/0x290
[<ffffffff810bd0f6>] kthread+0xa6/0xb0
[<ffffffff81be9844>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND


david
