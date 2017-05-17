Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:46777 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751045AbdEQIwU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 04:52:20 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailext.virtall.com (Postfix) with ESMTP id DA589D115B4
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 10:44:03 +0200 (CEST)
Received: from mailext.virtall.com ([127.0.0.1])
        by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Q4DYu2yM5BYB for <linux-btrfs@vger.kernel.org>;
        Wed, 17 May 2017 10:44:02 +0200 (CEST)
Received: from admin.virtall.com (localhost [127.0.0.1])
        by mailext.virtall.com (Postfix) with ESMTP
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 10:44:02 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 17 May 2017 17:44:02 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs hang with 4.11.1 kernel
Message-ID: <400eaec1e8e4ae2539d4dd8623d43edd@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After upgrading to 4.11.1 and running for ~12 hours, btrfs filesystem 
hanged - most processes on a server accessing the filesystem went into 
"D" state and blocked.

The server would not reboot and had to be power cycled.


Previously, it was running 4.10.7 for around 1.5 month without any 
issues.

The server has ~10 subvolumes and 5-10 snapshots, >220 GB free (about 
50% free), runs in RAID-1 mode on SSD disks.


Is it anything known with 4.11.x?


May 17 07:47:53 lxd02 kernel: [43865.593536] INFO: task 
btrfs-transacti:610 blocked for more than 120 seconds.
May 17 07:47:53 lxd02 kernel: [43865.593557]       Not tainted 
4.11.1-041101-generic #201705140931
May 17 07:47:53 lxd02 kernel: [43865.593572] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 07:47:53 lxd02 kernel: [43865.593593] btrfs-transacti D    0   
610      2 0x00000000
May 17 07:47:53 lxd02 kernel: [43865.593596] Call Trace:
May 17 07:47:53 lxd02 kernel: [43865.593605]  __schedule+0x3c6/0x8c0
May 17 07:47:53 lxd02 kernel: [43865.593609]  schedule+0x36/0x80
May 17 07:47:53 lxd02 kernel: [43865.593645]  
wait_current_trans+0xc2/0x100 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.593649]  ? 
wake_atomic_t_function+0x60/0x60
May 17 07:47:53 lxd02 kernel: [43865.593675]  
start_transaction+0x24e/0x460 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.593698]  
btrfs_attach_transaction+0x1d/0x20 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.593720]  
transaction_kthread+0x8c/0x1c0 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.593724]  kthread+0x109/0x140
May 17 07:47:53 lxd02 kernel: [43865.593744]  ? 
btrfs_cleanup_transaction+0x530/0x530 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.593748]  ? 
kthread_create_on_node+0x70/0x70
May 17 07:47:53 lxd02 kernel: [43865.593751]  ret_from_fork+0x2c/0x40
May 17 07:47:53 lxd02 kernel: [43865.593778] INFO: task mongod:6703 
blocked for more than 120 seconds.
May 17 07:47:53 lxd02 kernel: [43865.593793]       Not tainted 
4.11.1-041101-generic #201705140931
May 17 07:47:53 lxd02 kernel: [43865.593809] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 07:47:53 lxd02 kernel: [43865.593829] mongod          D    0  
6703   3531 0x00000100
May 17 07:47:53 lxd02 kernel: [43865.593832] Call Trace:
May 17 07:47:53 lxd02 kernel: [43865.593836]  __schedule+0x3c6/0x8c0
May 17 07:47:53 lxd02 kernel: [43865.593839]  schedule+0x36/0x80
May 17 07:47:53 lxd02 kernel: [43865.593860]  
wait_current_trans+0xc2/0x100 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.593863]  ? 
wake_atomic_t_function+0x60/0x60
May 17 07:47:53 lxd02 kernel: [43865.593883]  
start_transaction+0x2d4/0x460 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.593903]  
btrfs_start_transaction+0x1e/0x20 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.593926]  btrfs_create+0x5d/0x210 
[btrfs]
May 17 07:47:53 lxd02 kernel: [43865.593930]  path_openat+0x1433/0x1500
May 17 07:47:53 lxd02 kernel: [43865.593935]  do_filp_open+0x99/0x110
May 17 07:47:53 lxd02 kernel: [43865.593938]  ? 
__check_object_size+0x100/0x19d
May 17 07:47:53 lxd02 kernel: [43865.593942]  do_sys_open+0x130/0x220
May 17 07:47:53 lxd02 kernel: [43865.593944]  ? do_sys_open+0x130/0x220
May 17 07:47:53 lxd02 kernel: [43865.593946]  SyS_open+0x1e/0x20
May 17 07:47:53 lxd02 kernel: [43865.593950]  do_syscall_64+0x5b/0xc0
May 17 07:47:53 lxd02 kernel: [43865.593952]  
entry_SYSCALL64_slow_path+0x25/0x25
May 17 07:47:53 lxd02 kernel: [43865.593954] RIP: 0033:0x7f5e3b44947d
May 17 07:47:53 lxd02 kernel: [43865.593956] RSP: 002b:00007f5e2ee4f310 
EFLAGS: 00000293 ORIG_RAX: 0000000000000002
May 17 07:47:53 lxd02 kernel: [43865.593959] RAX: ffffffffffffffda RBX: 
0000000031815840 RCX: 00007f5e3b44947d
May 17 07:47:53 lxd02 kernel: [43865.593960] RDX: 00000000000001b6 RSI: 
0000000000000241 RDI: 0000000006d83d80
May 17 07:47:53 lxd02 kernel: [43865.593962] RBP: 0000000006d83d80 R08: 
0000000000000004 R09: 0000000000000001
May 17 07:47:53 lxd02 kernel: [43865.593963] R10: 0000000000000240 R11: 
0000000000000293 R12: 0000000001da7d7d
May 17 07:47:53 lxd02 kernel: [43865.593964] R13: 0000000000000001 R14: 
000000000324de08 R15: 000000000226f370
May 17 07:47:53 lxd02 kernel: [43865.593971] INFO: task mongod:7627 
blocked for more than 120 seconds.
May 17 07:47:53 lxd02 kernel: [43865.593986]       Not tainted 
4.11.1-041101-generic #201705140931
May 17 07:47:53 lxd02 kernel: [43865.594001] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 07:47:53 lxd02 kernel: [43865.594021] mongod          D    0  
7627   3531 0x00000100
May 17 07:47:53 lxd02 kernel: [43865.594024] Call Trace:
May 17 07:47:53 lxd02 kernel: [43865.594028]  __schedule+0x3c6/0x8c0
May 17 07:47:53 lxd02 kernel: [43865.594031]  schedule+0x36/0x80
May 17 07:47:53 lxd02 kernel: [43865.594060]  
btrfs_tree_read_lock+0xcc/0x120 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594063]  ? 
wake_atomic_t_function+0x60/0x60
May 17 07:47:53 lxd02 kernel: [43865.594081]  
btrfs_read_lock_root_node+0x34/0x50 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594100]  
btrfs_search_slot+0x6d5/0x9d0 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594122]  
btrfs_lookup_inode+0x3e/0xc0 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594150]  
__btrfs_update_delayed_inode+0x70/0x210 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594154]  ? mutex_lock+0x12/0x40
May 17 07:47:53 lxd02 kernel: [43865.594179]  
__btrfs_run_delayed_items+0x57d/0x670 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594204]  
btrfs_run_delayed_items+0x13/0x20 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594227]  
btrfs_commit_transaction+0x211/0x900 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594254]  ? 
btrfs_wait_ordered_range+0x7c/0x100 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594279]  
btrfs_sync_file+0x307/0x3e0 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594285]  vfs_fsync_range+0x4b/0xb0
May 17 07:47:53 lxd02 kernel: [43865.594288]  do_fsync+0x3d/0x70
May 17 07:47:53 lxd02 kernel: [43865.594291]  SyS_fdatasync+0x13/0x20
May 17 07:47:53 lxd02 kernel: [43865.594294]  do_syscall_64+0x5b/0xc0
May 17 07:47:53 lxd02 kernel: [43865.594296]  
entry_SYSCALL64_slow_path+0x25/0x25
May 17 07:47:53 lxd02 kernel: [43865.594298] RIP: 0033:0x7f5e3b44fc2d
May 17 07:47:53 lxd02 kernel: [43865.594299] RSP: 002b:00007f5e1aa05540 
EFLAGS: 00000293 ORIG_RAX: 000000000000004b
May 17 07:47:53 lxd02 kernel: [43865.594302] RAX: ffffffffffffffda RBX: 
0000000000000033 RCX: 00007f5e3b44fc2d
May 17 07:47:53 lxd02 kernel: [43865.594303] RDX: 0000000112f50b00 RSI: 
0000000000000033 RDI: 0000000000000033
May 17 07:47:53 lxd02 kernel: [43865.594304] RBP: 00007f5e1aa05590 R08: 
0000000112f4edc0 R09: 000000000154cf00
May 17 07:47:53 lxd02 kernel: [43865.594306] R10: 0022341aa4390ae6 R11: 
0000000000000293 R12: 000000000000000a
May 17 07:47:53 lxd02 kernel: [43865.594307] R13: 0000000000000001 R14: 
0000000112f50b00 R15: 0000000001da602b
May 17 07:47:53 lxd02 kernel: [43865.594315] INFO: task mongod:5256 
blocked for more than 120 seconds.
May 17 07:47:53 lxd02 kernel: [43865.594330]       Not tainted 
4.11.1-041101-generic #201705140931
May 17 07:47:53 lxd02 kernel: [43865.594345] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 07:47:53 lxd02 kernel: [43865.594365] mongod          D    0  
5256   3979 0x00000100
May 17 07:47:53 lxd02 kernel: [43865.594368] Call Trace:
May 17 07:47:53 lxd02 kernel: [43865.594372]  __schedule+0x3c6/0x8c0
May 17 07:47:53 lxd02 kernel: [43865.594375]  schedule+0x36/0x80
May 17 07:47:53 lxd02 kernel: [43865.594379]  
rwsem_down_write_failed+0x230/0x3a0
May 17 07:47:53 lxd02 kernel: [43865.594398]  ? 
btrfs_search_slot+0x429/0x9d0 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594403]  
call_rwsem_down_write_failed+0x17/0x30
May 17 07:47:53 lxd02 kernel: [43865.594406]  ? 
call_rwsem_down_write_failed+0x17/0x30
May 17 07:47:53 lxd02 kernel: [43865.594409]  down_write+0x2d/0x40
May 17 07:47:53 lxd02 kernel: [43865.594432]  
btrfs_file_write_iter+0x74/0x4a0 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594435]  __vfs_write+0xe5/0x160
May 17 07:47:53 lxd02 kernel: [43865.594439]  vfs_write+0xb5/0x1a0
May 17 07:47:53 lxd02 kernel: [43865.594442]  SyS_pwrite64+0x95/0xb0
May 17 07:47:53 lxd02 kernel: [43865.594445]  do_syscall_64+0x5b/0xc0
May 17 07:47:53 lxd02 kernel: [43865.594447]  
entry_SYSCALL64_slow_path+0x25/0x25
May 17 07:47:53 lxd02 kernel: [43865.594449] RIP: 0033:0x7fea0d06bda3
May 17 07:47:53 lxd02 kernel: [43865.594450] RSP: 002b:00007fea0b1b56c0 
EFLAGS: 00000293 ORIG_RAX: 0000000000000012
May 17 07:47:53 lxd02 kernel: [43865.594452] RAX: ffffffffffffffda RBX: 
0000000000000a00 RCX: 00007fea0d06bda3
May 17 07:47:53 lxd02 kernel: [43865.594453] RDX: 0000000000000a00 RSI: 
00000000055ca000 RDI: 000000000000005d
May 17 07:47:53 lxd02 kernel: [43865.594455] RBP: 00007fea0b1b5710 R08: 
00000000055ca000 R09: 0000000003843f00
May 17 07:47:53 lxd02 kernel: [43865.594456] R10: 0000000003843f00 R11: 
0000000000000293 R12: 0000000000000a00
May 17 07:47:53 lxd02 kernel: [43865.594457] R13: 00000000055ca000 R14: 
00000000667023f0 R15: 0000000003843f00
May 17 07:47:53 lxd02 kernel: [43865.594461] INFO: task mongod:5280 
blocked for more than 120 seconds.
May 17 07:47:53 lxd02 kernel: [43865.594476]       Not tainted 
4.11.1-041101-generic #201705140931
May 17 07:47:53 lxd02 kernel: [43865.594491] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 07:47:53 lxd02 kernel: [43865.594511] mongod          D    0  
5280   3979 0x00000100
May 17 07:47:53 lxd02 kernel: [43865.594514] Call Trace:
May 17 07:47:53 lxd02 kernel: [43865.594517]  __schedule+0x3c6/0x8c0
May 17 07:47:53 lxd02 kernel: [43865.594520]  schedule+0x36/0x80
May 17 07:47:53 lxd02 kernel: [43865.594543]  wait_for_commit+0x46/0x90 
[btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594546]  ? 
wake_atomic_t_function+0x60/0x60
May 17 07:47:53 lxd02 kernel: [43865.594567]  
btrfs_commit_transaction+0xf3/0x900 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594593]  ? 
btrfs_wait_ordered_range+0x7c/0x100 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594616]  
btrfs_sync_file+0x307/0x3e0 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594621]  vfs_fsync_range+0x4b/0xb0
May 17 07:47:53 lxd02 kernel: [43865.594624]  do_fsync+0x3d/0x70
May 17 07:47:53 lxd02 kernel: [43865.594627]  SyS_fdatasync+0x13/0x20
May 17 07:47:53 lxd02 kernel: [43865.594629]  do_syscall_64+0x5b/0xc0
May 17 07:47:53 lxd02 kernel: [43865.594632]  
entry_SYSCALL64_slow_path+0x25/0x25
May 17 07:47:53 lxd02 kernel: [43865.594633] RIP: 0033:0x7fea0cd8ec2d
May 17 07:47:53 lxd02 kernel: [43865.594634] RSP: 002b:00007fea081af480 
EFLAGS: 00000293 ORIG_RAX: 000000000000004b
May 17 07:47:53 lxd02 kernel: [43865.594636] RAX: ffffffffffffffda RBX: 
0000000000000079 RCX: 00007fea0cd8ec2d
May 17 07:47:53 lxd02 kernel: [43865.594638] RDX: 000000019a32ea00 RSI: 
0000000000000079 RDI: 0000000000000079
May 17 07:47:53 lxd02 kernel: [43865.594639] RBP: 00007fea081af4d0 R08: 
0000000000000000 R09: 0000000000000022
May 17 07:47:53 lxd02 kernel: [43865.594640] R10: 0000000000000011 R11: 
0000000000000293 R12: 000000000000000a
May 17 07:47:53 lxd02 kernel: [43865.594641] R13: 0000000000000001 R14: 
000000019a32ea00 R15: 0000000001da6002
May 17 07:47:53 lxd02 kernel: [43865.594644] INFO: task mongod:5281 
blocked for more than 120 seconds.
May 17 07:47:53 lxd02 kernel: [43865.594682]       Not tainted 
4.11.1-041101-generic #201705140931
May 17 07:47:53 lxd02 kernel: [43865.594719] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 07:47:53 lxd02 kernel: [43865.594778] mongod          D    0  
5281   3979 0x00000100
May 17 07:47:53 lxd02 kernel: [43865.594780] Call Trace:
May 17 07:47:53 lxd02 kernel: [43865.594783]  __schedule+0x3c6/0x8c0
May 17 07:47:53 lxd02 kernel: [43865.594806]  ? 
btrfs_releasepage+0x20/0x20 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594809]  schedule+0x36/0x80
May 17 07:47:53 lxd02 kernel: [43865.594831]  
wait_current_trans+0xc2/0x100 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594834]  ? 
wake_atomic_t_function+0x60/0x60
May 17 07:47:53 lxd02 kernel: [43865.594854]  
start_transaction+0x2d4/0x460 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594874]  
btrfs_start_transaction+0x1e/0x20 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594896]  
btrfs_sync_file+0x24b/0x3e0 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.594900]  vfs_fsync_range+0x4b/0xb0
May 17 07:47:53 lxd02 kernel: [43865.594903]  do_fsync+0x3d/0x70
May 17 07:47:53 lxd02 kernel: [43865.594906]  SyS_fdatasync+0x13/0x20
May 17 07:47:53 lxd02 kernel: [43865.594909]  do_syscall_64+0x5b/0xc0
May 17 07:47:53 lxd02 kernel: [43865.594911]  
entry_SYSCALL64_slow_path+0x25/0x25
May 17 07:47:53 lxd02 kernel: [43865.594912] RIP: 0033:0x7fea0cd8ec2d
May 17 07:47:53 lxd02 kernel: [43865.594913] RSP: 002b:00007fea079ae360 
EFLAGS: 00000293 ORIG_RAX: 000000000000004b
May 17 07:47:53 lxd02 kernel: [43865.594915] RAX: ffffffffffffffda RBX: 
000000000000005d RCX: 00007fea0cd8ec2d
May 17 07:47:53 lxd02 kernel: [43865.594916] RDX: 0000000163b7be00 RSI: 
000000000000005d RDI: 000000000000005d
May 17 07:47:53 lxd02 kernel: [43865.594918] RBP: 00007fea079ae3b0 R08: 
0000000163b78600 R09: 0000000003843f00
May 17 07:47:53 lxd02 kernel: [43865.594919] R10: 0023a254a0d06f9f R11: 
0000000000000293 R12: 000000000000000a
May 17 07:47:53 lxd02 kernel: [43865.594920] R13: 0000000000000001 R14: 
0000000163b7be00 R15: 0000000001da602b
May 17 07:47:53 lxd02 kernel: [43865.594934] INFO: task mongos:7681 
blocked for more than 120 seconds.
May 17 07:47:53 lxd02 kernel: [43865.594972]       Not tainted 
4.11.1-041101-generic #201705140931
May 17 07:47:53 lxd02 kernel: [43865.595008] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 07:47:53 lxd02 kernel: [43865.595067] mongos          D    0  
7681   4349 0x00000100
May 17 07:47:53 lxd02 kernel: [43865.595069] Call Trace:
May 17 07:47:53 lxd02 kernel: [43865.595073]  __schedule+0x3c6/0x8c0
May 17 07:47:53 lxd02 kernel: [43865.595094]  ? 
reserve_metadata_bytes+0x965/0xa90 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595097]  schedule+0x36/0x80
May 17 07:47:53 lxd02 kernel: [43865.595123]  
lock_extent_bits+0x185/0x1d0 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595126]  ? 
wake_atomic_t_function+0x60/0x60
May 17 07:47:53 lxd02 kernel: [43865.595150]  
lock_and_cleanup_extent_if_need+0x102/0x280 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595171]  
__btrfs_buffered_write+0x1ed/0x770 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595192]  
btrfs_file_write_iter+0x17c/0x4a0 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595196]  __vfs_write+0xe5/0x160
May 17 07:47:53 lxd02 kernel: [43865.595199]  vfs_write+0xb5/0x1a0
May 17 07:47:53 lxd02 kernel: [43865.595202]  SyS_write+0x55/0xc0
May 17 07:47:53 lxd02 kernel: [43865.595204]  do_syscall_64+0x5b/0xc0
May 17 07:47:53 lxd02 kernel: [43865.595207]  
entry_SYSCALL64_slow_path+0x25/0x25
May 17 07:47:53 lxd02 kernel: [43865.595208] RIP: 0033:0x7f826324e4bd
May 17 07:47:53 lxd02 kernel: [43865.595209] RSP: 002b:00007f8258d53730 
EFLAGS: 00000293 ORIG_RAX: 0000000000000001
May 17 07:47:53 lxd02 kernel: [43865.595211] RAX: ffffffffffffffda RBX: 
0000000000000091 RCX: 00007f826324e4bd
May 17 07:47:53 lxd02 kernel: [43865.595212] RDX: 0000000000000091 RSI: 
0000000001ee4000 RDI: 0000000000000004
May 17 07:47:53 lxd02 kernel: [43865.595213] RBP: 0000000001ee4000 R08: 
0000000000000004 R09: 0000000000000000
May 17 07:47:53 lxd02 kernel: [43865.595214] R10: 0000000000000000 R11: 
0000000000000293 R12: 0000000000000004
May 17 07:47:53 lxd02 kernel: [43865.595216] R13: 0000000000000091 R14: 
00007f8258d539d0 R15: 0000000001d3b0d0
May 17 07:47:53 lxd02 kernel: [43865.595225] INFO: task mysqld:7284 
blocked for more than 120 seconds.
May 17 07:47:53 lxd02 kernel: [43865.595263]       Not tainted 
4.11.1-041101-generic #201705140931
May 17 07:47:53 lxd02 kernel: [43865.595300] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 07:47:53 lxd02 kernel: [43865.595364] mysqld          D    0  
7284   5295 0x00000100
May 17 07:47:53 lxd02 kernel: [43865.595367] Call Trace:
May 17 07:47:53 lxd02 kernel: [43865.595370]  __schedule+0x3c6/0x8c0
May 17 07:47:53 lxd02 kernel: [43865.595392]  ? 
btrfs_releasepage+0x20/0x20 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595396]  schedule+0x36/0x80
May 17 07:47:53 lxd02 kernel: [43865.595417]  
wait_current_trans+0xc2/0x100 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595420]  ? 
wake_atomic_t_function+0x60/0x60
May 17 07:47:53 lxd02 kernel: [43865.595440]  
start_transaction+0x2d4/0x460 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595460]  
btrfs_start_transaction+0x1e/0x20 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595481]  
btrfs_sync_file+0x24b/0x3e0 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595485]  vfs_fsync_range+0x4b/0xb0
May 17 07:47:53 lxd02 kernel: [43865.595488]  do_fsync+0x3d/0x70
May 17 07:47:53 lxd02 kernel: [43865.595491]  SyS_fsync+0x10/0x20
May 17 07:47:53 lxd02 kernel: [43865.595494]  do_syscall_64+0x5b/0xc0
May 17 07:47:53 lxd02 kernel: [43865.595496]  
entry_SYSCALL64_slow_path+0x25/0x25
May 17 07:47:53 lxd02 kernel: [43865.595497] RIP: 0033:0x7f869cad5b2d
May 17 07:47:53 lxd02 kernel: [43865.595498] RSP: 002b:00007f4d1512cc60 
EFLAGS: 00000293 ORIG_RAX: 000000000000004a
May 17 07:47:53 lxd02 kernel: [43865.595501] RAX: ffffffffffffffda RBX: 
0000000000000009 RCX: 00007f869cad5b2d
May 17 07:47:53 lxd02 kernel: [43865.595502] RDX: 0000000000c50710 RSI: 
00007f4d1512ccf8 RDI: 0000000000000009
May 17 07:47:53 lxd02 kernel: [43865.595503] RBP: 00007f4d1512cc90 R08: 
00007f4d1512ccc0 R09: 000000003ab097f9
May 17 07:47:53 lxd02 kernel: [43865.595504] R10: 000000003ffff000 R11: 
0000000000000293 R12: 0000000000000000
May 17 07:47:53 lxd02 kernel: [43865.595506] R13: 0000000051eb851f R14: 
0000000000000000 R15: 0000000001207fe0
May 17 07:47:53 lxd02 kernel: [43865.595509] INFO: task mysqld:7286 
blocked for more than 120 seconds.
May 17 07:47:53 lxd02 kernel: [43865.595547]       Not tainted 
4.11.1-041101-generic #201705140931
May 17 07:47:53 lxd02 kernel: [43865.595583] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 07:47:53 lxd02 kernel: [43865.595642] mysqld          D    0  
7286   5295 0x00000100
May 17 07:47:53 lxd02 kernel: [43865.595644] Call Trace:
May 17 07:47:53 lxd02 kernel: [43865.595648]  __schedule+0x3c6/0x8c0
May 17 07:47:53 lxd02 kernel: [43865.595669]  ? 
btrfs_releasepage+0x20/0x20 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595672]  schedule+0x36/0x80
May 17 07:47:53 lxd02 kernel: [43865.595693]  
wait_current_trans+0xc2/0x100 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595696]  ? 
wake_atomic_t_function+0x60/0x60
May 17 07:47:53 lxd02 kernel: [43865.595715]  
start_transaction+0x2d4/0x460 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595735]  
btrfs_start_transaction+0x1e/0x20 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595755]  
btrfs_sync_file+0x24b/0x3e0 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595759]  vfs_fsync_range+0x4b/0xb0
May 17 07:47:53 lxd02 kernel: [43865.595762]  do_fsync+0x3d/0x70
May 17 07:47:53 lxd02 kernel: [43865.595765]  SyS_fsync+0x10/0x20
May 17 07:47:53 lxd02 kernel: [43865.595768]  do_syscall_64+0x5b/0xc0
May 17 07:47:53 lxd02 kernel: [43865.595770]  
entry_SYSCALL64_slow_path+0x25/0x25
May 17 07:47:53 lxd02 kernel: [43865.595771] RIP: 0033:0x7f869cad5b2d
May 17 07:47:53 lxd02 kernel: [43865.595772] RSP: 002b:00007f4d0effc9a0 
EFLAGS: 00000293 ORIG_RAX: 000000000000004a
May 17 07:47:53 lxd02 kernel: [43865.595774] RAX: ffffffffffffffda RBX: 
0000000000000003 RCX: 00007f869cad5b2d
May 17 07:47:53 lxd02 kernel: [43865.595775] RDX: 0000000000c50710 RSI: 
00007f4d0effca38 RDI: 0000000000000003
May 17 07:47:53 lxd02 kernel: [43865.595777] RBP: 00007f4d0effc9d0 R08: 
00007f4d0effca00 R09: 00007f4c39f50000
May 17 07:47:53 lxd02 kernel: [43865.595778] R10: 00007f4d0effc9e0 R11: 
0000000000000293 R12: 0000000000000000
May 17 07:47:53 lxd02 kernel: [43865.595779] R13: 0000000051eb851f R14: 
0000000000010000 R15: 0000000001207fe0
May 17 07:47:53 lxd02 kernel: [43865.595782] INFO: task mysqld:7292 
blocked for more than 120 seconds.
May 17 07:47:53 lxd02 kernel: [43865.595820]       Not tainted 
4.11.1-041101-generic #201705140931
May 17 07:47:53 lxd02 kernel: [43865.595857] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 17 07:47:53 lxd02 kernel: [43865.595915] mysqld          D    0  
7292   5295 0x00000100
May 17 07:47:53 lxd02 kernel: [43865.595918] Call Trace:
May 17 07:47:53 lxd02 kernel: [43865.595921]  __schedule+0x3c6/0x8c0
May 17 07:47:53 lxd02 kernel: [43865.595941]  ? 
btrfs_releasepage+0x20/0x20 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595945]  schedule+0x36/0x80
May 17 07:47:53 lxd02 kernel: [43865.595965]  
wait_current_trans+0xc2/0x100 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.595968]  ? 
wake_atomic_t_function+0x60/0x60
May 17 07:47:53 lxd02 kernel: [43865.595987]  
start_transaction+0x2d4/0x460 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.596006]  
btrfs_start_transaction+0x1e/0x20 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.596027]  
btrfs_sync_file+0x24b/0x3e0 [btrfs]
May 17 07:47:53 lxd02 kernel: [43865.596031]  vfs_fsync_range+0x4b/0xb0
May 17 07:47:53 lxd02 kernel: [43865.596034]  do_fsync+0x3d/0x70
May 17 07:47:53 lxd02 kernel: [43865.596037]  SyS_fsync+0x10/0x20
May 17 07:47:53 lxd02 kernel: [43865.596040]  do_syscall_64+0x5b/0xc0
May 17 07:47:53 lxd02 kernel: [43865.596042]  
entry_SYSCALL64_slow_path+0x25/0x25
May 17 07:47:53 lxd02 kernel: [43865.596043] RIP: 0033:0x7f869cad5b2d
May 17 07:47:53 lxd02 kernel: [43865.596044] RSP: 002b:00007f86700ac550 
EFLAGS: 00000293 ORIG_RAX: 000000000000004a
May 17 07:47:53 lxd02 kernel: [43865.596046] RAX: ffffffffffffffda RBX: 
00007f86700ac630 RCX: 00007f869cad5b2d
May 17 07:47:53 lxd02 kernel: [43865.596047] RDX: 00007f86700ada30 RSI: 
000000000000000a RDI: 000000000000043c
May 17 07:47:53 lxd02 kernel: [43865.596049] RBP: 00007f86700ac620 R08: 
0000000000000000 R09: 000000003df7938e
May 17 07:47:53 lxd02 kernel: [43865.596050] R10: 00007f4cf401ca80 R11: 
0000000000000293 R12: 0000000001207fe0
May 17 07:47:53 lxd02 kernel: [43865.596051] R13: 000000000000043c R14: 
0000000000000030 R15: 0000000000000013




Tomasz Chmielewski
https://lxadm.com
