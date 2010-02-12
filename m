From: Alex Elsayed <eternaleye@gmail.com>
Subject: Kernel BUG on mounting BtrFS / after reboot
Date: Fri, 12 Feb 2010 21:04:39 +0000 (UTC)
Message-ID: <loom.20100212T220341-877@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm getting a rather nasty BUG when I try to mount this filesystem, 
_including_ when I specify -o ro. I'm unsure what caused it, but the problem 
manifested after my computer hardlocked while reading my RSS feeds, complete 
with flashing lights. After I rebooted it, the screen filled with panic 
messages when the initramfs tried to mount it RO to pivot into. I am running 
2.6.33-rc6. The BUG message is as follows:

[ 6169.574592] ------------[ cut here ]------------
[ 6169.575423] Kernel BUG at ffffffff81244cf8 [verbose debug info 
unavailable]
[ 6169.575423] invalid opcode: 0000 [#1] PREEMPT SMP
[ 6169.575423] last sysfs file: 
/sys/devices/pci0000:00/0000:00:1c.3/0000:06:00.0/firmware/0000:06:00.0/loading
[ 6169.575423] CPU 0
[ 6169.593813] Pid: 3457, comm: mount Not tainted 2.6.33-rc6-zen1 #3 
MS-1651/GX620
[ 6169.594013] RIP: 0010:[<ffffffff81244cf8>]  [<ffffffff81244cf8>] 
add_inode_ref+0x69/0x423
[ 6169.594013] RSP: 0018:ffff88013a587888  EFLAGS: 00010246
[ 6169.594013] RAX: 0000000000000000 RBX: ffff8800a98dfe10 RCX: 
ffff880137d7b720
[ 6169.594013] RDX: ffff88013a5877e8 RSI: ffff8800a153e000 RDI: 
ffff88013a587800
[ 6169.594013] RBP: ffff88013a587948 R08: ffff880005a127e0 R09: 
ffff880137d72530
[ 6169.594013] R10: ffff88013a587758 R11: dead000000200200 R12: 
ffff8800a153e000
[ 6169.594013] R13: ffff8800268d3cb0 R14: 0000000000000000 R15: 
ffff88013a5879a8
[ 6169.594013] FS:  00007f517839e740(0000) GS:ffff880005a00000(0000) 
knlGS:0000000000000000
[ 6169.594013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6169.594013] CR2: 00007fd3edf7ee40 CR3: 0000000123136000 CR4: 
00000000000006f0
[ 6169.594013] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 6169.649381] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 6169.649381] Process mount (pid: 3457, threadinfo ffff88013a586000, task 
ffff880136a32e00)
[ 6169.649381] Stack:
[ 6169.649381]  ffff88013a587900 ffffffff00000004 ffff8800a153f800 
00000000000000ac
[ 6169.649381] <0> 0000000000000065 00000002a9837630 0000000000000097 
ffffffff816acf65
[ 6169.649381] <0> ffff88013a5878d8 ffffffff81233d0e ffff88013a587948 
ffffffff8122a4e2
[ 6169.649381] Call Trace:
[ 6169.649381]  [<ffffffff816acf65>] ? sub_preempt_count+0x9/0x83
[ 6169.649381]  [<ffffffff81233d0e>] ? unmap_extent_buffer+0x13/0x2e
[ 6169.649381]  [<ffffffff8122a4e2>] ? btrfs_item_size+0xbb/0xcb
[ 6169.649381]  [<ffffffff81245e54>] replay_one_buffer+0x27e/0x310
[ 6169.649381]  [<ffffffff81243138>] walk_down_log_tree+0x277/0x5fd
[ 6169.649381]  [<ffffffff8124359d>] walk_log_tree+0xdf/0x250
[ 6169.649381]  [<ffffffff816a9ac9>] ? _raw_spin_unlock+0x15/0x30
[ 6169.649381]  [<ffffffff81244714>] btrfs_recover_log_trees+0x1be/0x2d6
[ 6169.649381]  [<ffffffff81245bd6>] ? replay_one_buffer+0x0/0x310
[ 6169.649381]  [<ffffffff81216ccd>] ? 
btree_read_extent_buffer_pages+0x71/0xaf
[ 6169.649381]  [<ffffffff8121ac4e>] open_ctree+0x12d2/0x154a
[ 6169.649381]  [<ffffffff812dbc0b>] ? vsnprintf+0x1d8/0x44b
[ 6169.649381]  [<ffffffff811fda01>] btrfs_get_sb+0x1d0/0x3ec
[ 6169.649381]  [<ffffffff81123806>] vfs_kern_mount+0xa9/0x168
[ 6169.649381]  [<ffffffff8112392d>] do_kern_mount+0x4d/0xed
[ 6169.649381]  [<ffffffff8113a19b>] do_mount+0x786/0x7fd
[ 6169.649381]  [<ffffffff810eed34>] ? strndup_user+0x5d/0x85
[ 6169.649381]  [<ffffffff8113a29a>] sys_mount+0x88/0xc2
[ 6169.649381]  [<ffffffff81009c52>] system_call_fastpath+0x16/0x1b
[ 6169.649381] Code: 89 e7 e8 05 eb ff ff 49 89 c5 b8 fe ff ff ff 4d 85 ed 
0f 84 bb 03 00 00 49 8b 37 4c 89 e7 e8 e9 ea ff ff 49 89 c6 48 85 c0 75 04 
<0f> 0b eb fe 48 63 85 6c ff ff ff 48 8b 7d b0 48 6b c0 19 48 83
[ 6169.649381] RIP  [<ffffffff81244cf8>] add_inode_ref+0x69/0x423
[ 6169.649381]  RSP <ffff88013a587888>
[ 6169.867976] ---[ end trace 4b4c67dcecd13d7d ]---

I ran btrfsck on it, which produced this output:

root 5 inode 1525410 errors 400
root 5 inode 5364659 errors 2
root 5 inode 5364663 errors 2
root 5 inode 5364668 errors 2
root 5 inode 5364677 errors 2
root 5 inode 6123691 errors 400
root 5 inode 6239775 errors 2
root 5 inode 6239779 errors 2
root 5 inode 6239789 errors 2
root 5 inode 6239971 errors 2
root 5 inode 6269030 errors 2
root 5 inode 6269034 errors 2
root 5 inode 6269667 errors 2
root 5 inode 6270025 errors 2
root 5 inode 6423082 errors 400
root 5 inode 6424288 errors 2
root 5 inode 6424328 errors 2
root 5 inode 6424506 errors 2
root 5 inode 6424510 errors 2
root 5 inode 7314036 errors 400
root 5 inode 7538573 errors 400
root 5 inode 7541407 errors 400
root 5 inode 7541533 errors 400
root 5 inode 7954626 errors 400
root 5 inode 7955659 errors 2
root 5 inode 7955723 errors 2
root 5 inode 7955727 errors 2
root 5 inode 7957158 errors 2
root 5 inode 8076299 errors 2
root 5 inode 8138735 errors 400
root 5 inode 8346718 errors 400
root 5 inode 8378669 errors 400
root 5 inode 8504794 errors 400
root 5 inode 8628757 errors 400
root 5 inode 8628952 errors 2
root 5 inode 8628966 errors 2
root 5 inode 8628970 errors 2
root 5 inode 8629003 errors 2
root 5 inode 8633819 errors 2
root 5 inode 8693549 errors 400
root 5 inode 9014871 errors 2
root 5 inode 9014938 errors 2
root 5 inode 9014942 errors 2
root 5 inode 9014946 errors 2
found 449101881344 bytes used err is 1
total csum bytes: 433187792
total tree bytes: 5517582336
total fs tree bytes: 4585160704
btree space waste bytes: 1419008115
file data blocks allocated: 1040877457408
 referenced 439746732032
Btrfs v0.19-4-gab8fb4c

Is there any way to salvage this filesystem?

