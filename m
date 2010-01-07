From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: [btrfs] kernel BUG at include/linux/spinlock.h:376!
Date: Thu, 7 Jan 2010 22:29:32 +0100
Message-ID: <201001072229.33976.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

One of my btrfs filesystems gives the following bug message on access:

Jan  6 23:08:12 datengrab kernel: ------------[ cut here ]------------
Jan  6 23:08:12 datengrab kernel: kernel BUG at include/linux/spinlock.h:376!
Jan  6 23:08:12 datengrab kernel: invalid opcode: 0000 [#1] SMP
Jan  6 23:08:12 datengrab kernel: last sysfs file: 
/sys/devices/pci0000:00/0000:00:18.3/temp1_input
Jan  6 23:08:12 datengrab kernel: CPU 1
Jan  6 23:08:12 datengrab kernel: Pid: 2837, comm: btrfs-endio-wri Not tainted 
2.6.33-rc3-00033-g03b7675 #12 TYAN Tiger K8W Dual AMD Opteron, S2875/To Be 
Filled
By O.E.M.
Jan  6 23:08:12 datengrab kernel: RIP: 0010:[<ffffffff8118f7ea>]  [<ffffffff8118f7ea>] 
btrfs_assert_tree_locked+0x16/0x1c
Jan  6 23:08:12 datengrab kernel: RSP: 0018:ffff8800237b5a50  EFLAGS: 00010246
Jan  6 23:08:12 datengrab kernel: RAX: 0000000000000404 RBX: ffff88011f444ea0 
RCX: ffff880000000000
Jan  6 23:08:12 datengrab kernel: RDX: 0000000000000004 RSI: ffff88011c219000 
RDI: ffff8800829b3c00
Jan  6 23:08:12 datengrab kernel: RBP: ffff8800237b5a50 R08: 0000000000000016 
R09: ffff8800237b5a30
Jan  6 23:08:12 datengrab kernel: R10: ffff8800237b5a28 R11: 0000000000000191 
R12: ffff88011c219000
Jan  6 23:08:12 datengrab kernel: R13: 000000000000000c R14: 0000000000000001 
R15: ffff88011981e740
Jan  6 23:08:12 datengrab kernel: FS:  00007f2c79ac8700(0000) 
GS:ffff88002b400000(0000) knlGS:0000000000000000
Jan  6 23:08:12 datengrab kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Jan  6 23:08:12 datengrab kernel: CR2: 00000000026300a0 CR3: 0000000116b7f000 
CR4: 00000000000006f0
Jan  6 23:08:12 datengrab kernel: DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
Jan  6 23:08:12 datengrab kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 
DR7: 0000000000000400
Jan  6 23:08:12 datengrab kernel: Process btrfs-endio-wri (pid: 2837, 
threadinfo ffff8800237b4000, task ffff8800235037e0)
Jan  6 23:08:12 datengrab kernel: Stack:
Jan  6 23:08:12 datengrab kernel: ffff8800237b5ac0 ffffffff81154ded 000000000000012c 
000000000000000c
Jan  6 23:08:12 datengrab kernel: <0> ffff880000000016 0000000181150b93 
0000000000000ce3 00000f6600000000
Jan  6 23:08:12 datengrab kernel: <0> ffff88007ff44000 ffff8800829b3d00 
0000000000000000 ffff88011f444ea0
Jan  6 23:08:12 datengrab kernel: Call Trace:
Jan  6 23:08:12 datengrab kernel: [<ffffffff81154ded>] push_leaf_left+0x9f/0x158
Jan  6 23:08:12 datengrab kernel: [<ffffffff8115539e>] btrfs_del_items+0x363/0x48f
Jan  6 23:08:12 datengrab kernel: [<ffffffff81175b06>] 
btrfs_mark_extent_written+0x53b/0x55f
Jan  6 23:08:12 datengrab kernel: [<ffffffff8105616c>] ? trace_hardirqs_on+0xd/0xf
Jan  6 23:08:12 datengrab kernel: [<ffffffff8138bc85>] ? mutex_unlock+0x9/0xb
Jan  6 23:08:12 datengrab kernel: [<ffffffff8117422d>] 
btrfs_finish_ordered_io+0x176/0x247
Jan  6 23:08:12 datengrab kernel: [<ffffffff810544cf>] ? trace_hardirqs_off+0xd/0xf
Jan  6 23:08:12 datengrab kernel: [<ffffffff81174313>] 
btrfs_writepage_end_io_hook+0x15/0x17
Jan  6 23:08:12 datengrab kernel: [<ffffffff81184dd5>] 
end_bio_extent_writepage+0xa9/0x154
Jan  6 23:08:12 datengrab kernel: [<ffffffff8105613b>] ? 
trace_hardirqs_on_caller+0x10c/0x130
Jan  6 23:08:12 datengrab kernel: [<ffffffff810c8d27>] bio_endio+0x26/0x28
Jan  6 23:08:12 datengrab kernel: [<ffffffff81167b8d>] 
end_workqueue_fn+0x10c/0x11b
Jan  6 23:08:12 datengrab kernel: [<ffffffff8118d259>] worker_loop+0x175/0x44d
Jan  6 23:08:12 datengrab kernel: [<ffffffff8118d0e4>] ? worker_loop+0x0/0x44d
Jan  6 23:08:12 datengrab kernel: [<ffffffff81047197>] kthread+0x7a/0x82
Jan  6 23:08:12 datengrab kernel: [<ffffffff81002c94>] 
kernel_thread_helper+0x4/0x10
Jan  6 23:08:12 datengrab kernel: [<ffffffff8138e13c>] ? restore_args+0x0/0x30
Jan  6 23:08:12 datengrab kernel: [<ffffffff8104711d>] ? kthread+0x0/0x82
Jan  6 23:08:12 datengrab kernel: [<ffffffff81002c90>] ? 
kernel_thread_helper+0x0/0x10
Jan  6 23:08:12 datengrab kernel: Code: c8 ff 48 81 c4 88 00 00 00 5b 41 5c 41 
5d 41 5e 41 5f c9 c3 90 f6 47 38 02 55 48 89 e5 75 10 8b 47 70 89 c2 c1 fa 08 
38 c
2 75 04 <0f> 0b eb fe c9 c3 55 31 c0 65 48 8b 14 25 48 b5 00 00 48 89 e5
Jan  6 23:08:12 datengrab kernel: RIP  [<ffffffff8118f7ea>] 
btrfs_assert_tree_locked+0x16/0x1c
Jan  6 23:08:12 datengrab kernel: RSP <ffff8800237b5a50>
Jan  6 23:08:12 datengrab kernel: ---[ end trace 96d932f09da027f6 ]---

It only happens on write access. I was able to copy all the data to another 
drive without any error. The filesystem is damaged, btrfsck gives

root 5 inode 6969680 errors 2000
found 191511994368 bytes used err is 1
total csum bytes: 186404900
total tree bytes: 629936128
total fs tree bytes: 388333568
btree space waste bytes: 146015924
file data blocks allocated: 191957340160
 referenced 190751694848
Btrfs v0.19-4-gab8fb4c

It's the btrfs-code from 2.6.33 with the following additional patches:

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2e9e699..3a3a96d 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -111,13 +111,15 @@ static int btrfs_set_acl(struct btrfs_trans_handle 
*trans,

        switch (type) {
        case ACL_TYPE_ACCESS:
-               mode = inode->i_mode;
-               ret = posix_acl_equiv_mode(acl, &mode);
-               if (ret < 0)
-                       return ret;
-               ret = 0;
-               inode->i_mode = mode;
                name = POSIX_ACL_XATTR_ACCESS;
+               if (acl) {
+                       mode = inode->i_mode;
+                       ret = posix_acl_equiv_mode(acl, &mode);
+                       if (ret < 0)
+                               return ret;
+                       ret = 0;
+                       inode->i_mode = mode;
+               }
                break;
        case ACL_TYPE_DEFAULT:
                if (!S_ISDIR(inode->i_mode))

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c4bc570..654f702 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -679,7 +679,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
                        if (!cur) {
                                cur = read_tree_block(root, blocknr,
                                                         blocksize, gen);
-                       } else if (!uptodate) {
+                       } else {
                                btrfs_read_buffer(cur, gen);
                        }
                }

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a972868..ed3e4a2 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3281,8 +3281,10 @@ static noinline_for_stack int 
relocate_block_group(struct reloc_control *rc)
                return -ENOMEM;

        path = btrfs_alloc_path();
-       if (!path)
+       if (!path) {
+               kfree(cluster);
                return -ENOMEM;
+       }

        rc->extents_found = 0;
        rc->extents_skipped = 0;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 198cff2..220dad5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2649,8 +2649,10 @@ again:
        em = lookup_extent_mapping(em_tree, logical, *length);
        read_unlock(&em_tree->lock);

-       if (!em && unplug_page)
+       if (!em && unplug_page) {
+               kfree(multi);
                return 0;
+       }

        if (!em) {
                printk(KERN_CRIT "unable to find logical %llu len %llu\n",

I don't think that anyone of these patches causes the bug or FS corruption.

regards,
  Johannes
