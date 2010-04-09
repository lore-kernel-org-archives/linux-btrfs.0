From: Christian Kujau <lists@nerdbynature.de>
Subject: 2.6.34-rc3: task btrfs-transacti:4083 blocked for more than 120
 seconds.
Date: Fri, 9 Apr 2010 14:19:49 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.1004091409320.29272@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while running some filesystem benchmarks[0] I noticed the following 
message in my logs during bonnie++:

device fsid 944150ad12159fd6-cc6b5d7368bfb90 devid 1 transid 7 /dev/md0
INFO: task btrfs-transacti:4083 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transac D 0000000000000001     0  4083      2 0x00000000   
 ffff8801feb0dce0 0000000000000046 ffff8801feb0dc50 ffffffff81060e1d
 00000000001d2240 00000000001d2240 ffff8801feb0dfd8 ffff8801feb0dfd8
 ffff8801feb8b930 00000000001d2240 ffff8801feb0dfd8 00000000001d2240
Call Trace:
 [<ffffffff81060e1d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff814cd055>] schedule_timeout+0x1c5/0x220
 [<ffffffff814cd489>] ? mutex_unlock+0x9/0x10
 [<ffffffff812e9414>] ? btrfs_run_ordered_operations+0x224/0x240
 [<ffffffff8106467d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff812cf2fd>] btrfs_commit_transaction+0x24d/0x6f0
 [<ffffffff81051440>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff812cfac0>] ? start_transaction+0x120/0x170
 [<ffffffff812c9edb>] transaction_kthread+0x1fb/0x230
 [<ffffffff812c9ce0>] ? transaction_kthread+0x0/0x230
 [<ffffffff81050f9e>] kthread+0xae/0xc0
 [<ffffffff81064625>] ? trace_hardirqs_on_caller+0x155/0x1a0
 [<ffffffff81003b54>] kernel_thread_helper+0x4/0x10
 [<ffffffff814cfa3c>] ? restore_args+0x0/0x30
 [<ffffffff81050ef0>] ? kthread+0x0/0xc0
 [<ffffffff81003b50>] ? kernel_thread_helper+0x0/0x10
1 lock held by btrfs-transacti/4083:
 #0:  (&fs_info->transaction_kthread_mutex){+.+...}, at: [<ffffffff812c9dc5>] transaction_kthread+0xe5/0x230


I've run bonnie++ with earlier kernel version (2.6.33, etc) on this very 
same machine w/o thoese messages. Although bonnie++ has been 
upgraded, I'm seeing the same when running tiobench on the same 
machine:

device fsid 9b4ce407187a1f20-31cd51397b5b52bf devid 1 transid 7 /dev/md0
INFO: task btrfs-transacti:10530 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transac D 0000000000000001     0 10530      2 0x00000000
 ffff8800b147bce0 0000000000000046 ffff8800b147bc50 ffffffff81060dfd
 00000000001d2240 00000000001d2240 ffff8800b147bfd8 ffff8800b147bfd8
 ffff880009f09310 00000000001d2240 ffff8800b147bfd8 00000000001d2240
Call Trace:
 [<ffffffff81060dfd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff814ccf55>] schedule_timeout+0x1c5/0x220
 [<ffffffff814cd389>] ? mutex_unlock+0x9/0x10 
 [<ffffffff812e9394>] ? btrfs_run_ordered_operations+0x224/0x240
 [<ffffffff8106465d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff812cf27d>] btrfs_commit_transaction+0x24d/0x6f0
 [<ffffffff81051420>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff812cfa40>] ? start_transaction+0x120/0x170
 [<ffffffff812c9e5b>] transaction_kthread+0x1fb/0x230
 [<ffffffff812c9c60>] ? transaction_kthread+0x0/0x230
 [<ffffffff81050f7e>] kthread+0xae/0xc0
 [<ffffffff81064605>] ? trace_hardirqs_on_caller+0x155/0x1a0
 [<ffffffff81003b54>] kernel_thread_helper+0x4/0x10
 [<ffffffff814cf93c>] ? restore_args+0x0/0x30 
 [<ffffffff81050ed0>] ? kthread+0x0/0xc0
 [<ffffffff81003b50>] ? kernel_thread_helper+0x0/0x10
1 lock held by btrfs-transacti/10530:
 #0:  (&fs_info->transaction_kthread_mutex){+.+...}, at: [<ffffffff812c9d45>] transaction_kthread+0xe5/0x230


Is this something to worry about or should I just go ahead and set 
hung_task_timeout_secs to 0? Running the same version of bonnie++ on other 
filesystems (on the same machine) does not prodcude this messages (well, 
the other fs have different issues).

I've put a few details about this online:

  http://nerdbynature.de/bits/2.6.34-rc3/btrfs/
  http://nerdbynature.de/bits/2.6.34-rc3/err/

Christian.

[0] http://nerdbynature.de/benchmarks/v40z/2010-04-06/
-- 
BOFH excuse #428:

Firmware update in the coffee machine
