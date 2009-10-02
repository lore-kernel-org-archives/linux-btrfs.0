From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: 2.6.32-rc1: btrfs hugs
Date: Fri, 2 Oct 2009 15:18:41 +0400
Message-ID: <a4423d670910020418w4de348c7x763bb7d548d927ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi
The kernel is  2.6.32-rc2-00196-g0efe5e3
SMP, 4cpus

I tested dbench with 150 threads on 120G partition.


device fsid b467c30bdb79768-7e6f9a05192ee4b5 devid 1 transid 7 /dev/sda3
thread pool is 6
INFO: task btrfs-transacti:28788 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transac D 39a378f5  5476 28788      2 0x00000000
 f600fe30 00000046 00000001 39a378f5 c161aea0 39a378f5 f6b5da90 00023662
 00000000 0000025a 00007ca0 00000000 f6b5df9c f6b5da90 39a378f5 00000001
 f6b5da90 c161a984 c175e240 f6b5dd20 c175e240 c175e240 f6b5dd20 c175e240
Call Trace:
 [<c12284aa>] ? blk_backing_dev_unplug+0x1a/0x40
 [<c140ac8f>] io_schedule+0x3f/0x70
 [<c1082dcd>] sync_page+0x4d/0x70
 [<c140b38d>] __wait_on_bit+0x5d/0xa0
 [<c1082d80>] ? sync_page+0x0/0x70
 [<c1083013>] wait_on_page_bit+0x93/0xb0
 [<c1052a80>] ? wake_bit_function+0x0/0x70
 [<c11d3bdb>] btrfs_write_and_wait_marked_extents+0x20b/0x310
 [<c11d3d09>] btrfs_write_and_wait_transaction+0x29/0x60
 [<c11d41ac>] btrfs_commit_transaction+0x46c/0x6b0
 [<c1052a20>] ? autoremove_wake_function+0x0/0x60
 [<c11ce8db>] transaction_kthread+0x1bb/0x1f0
 [<c11ce720>] ? transaction_kthread+0x0/0x1f0
 [<c105271c>] kthread+0x7c/0x90
 [<c10526a0>] ? kthread+0x0/0x90
 [<c1003edb>] kernel_thread_helper+0x7/0x7c
2 locks held by btrfs-transacti/28788:
 #0:  (&fs_info->transaction_kthread_mutex){+.+...}, at: [<c11ce7ee>]
transaction_kthread+0xce/0x1f0
 #1:  (&fs_info->tree_log_mutex){+.+...}, at: [<c11d3fd5>]
btrfs_commit_transaction+0x295/0x6b0
INFO: task dbench:28790 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
dbench        D 4babb2c2  4928 28790  28789 0x00000000
 f5dbde10 00000046 00000000 4babb2c2 c161aea0 4babb2c2 f67399e0 00d321b1
 00000000 f6059e00 00025bc4 00000000 4babb2c2 f5dbddbc c1065cb8 4babb2c2
 00000000 c161a984 c175e240 f6739c70 c175e240 c175e240 f6739c70 c175e240
Call Trace:
 [<c1065cb8>] ? put_lock_stats+0x18/0x50
 [<c12284aa>] ? blk_backing_dev_unplug+0x1a/0x40
 [<c140ac8f>] io_schedule+0x3f/0x70
 [<c1082dcd>] sync_page+0x4d/0x70
 [<c140b38d>] __wait_on_bit+0x5d/0xa0
 [<c1082d80>] ? sync_page+0x0/0x70
 [<c1083013>] wait_on_page_bit+0x93/0xb0
 [<c1052a80>] ? wake_bit_function+0x0/0x70
 [<c10830da>] wait_on_page_writeback_range+0xaa/0x150
 [<c1083388>] filemap_write_and_wait_range+0x98/0xb0
 [<c10dc3af>] vfs_fsync_range+0x9f/0x110
 [<c10dc50b>] vfs_fsync+0x3b/0x60
 [<c10dc567>] do_fsync+0x37/0x60
 [<c10dc5eb>] sys_fsync+0x1b/0x40
 [<c10032cf>] sysenter_do_call+0x12/0x36
no locks held by dbench/28790.


# cat /proc/28788/stack
[<c1082dcd>] sync_page+0x4d/0x70
[<c1083013>] wait_on_page_bit+0x93/0xb0
[<c11d3bdb>] btrfs_write_and_wait_marked_extents+0x20b/0x310
[<c11d3d09>] btrfs_write_and_wait_transaction+0x29/0x60
[<c11d41ac>] btrfs_commit_transaction+0x46c/0x6b0
[<c11ce8db>] transaction_kthread+0x1bb/0x1f0
[<c105271c>] kthread+0x7c/0x90
[<c1003edb>] kernel_thread_helper+0x7/0x7c
[<ffffffff>] 0xffffffff
