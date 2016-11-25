Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35637 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbcKYLNx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 06:13:53 -0500
Received: by mail-wm0-f42.google.com with SMTP id a197so140298438wmd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Nov 2016 03:12:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGqmi74PvWRLwwxsd1b76QqyS=NHZwxm871DN57ALnEjMZfreA@mail.gmail.com>
References: <CAGqmi74PvWRLwwxsd1b76QqyS=NHZwxm871DN57ALnEjMZfreA@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 25 Nov 2016 14:11:42 +0300
Message-ID: <CAGqmi74R7SVSp9-KG5-C=bd2q8hAmMstaNYtegQkOy0dYRFGTA@mail.gmail.com>
Subject: Re: Help with stack trace
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So it's btrfs problem,
i catch hung again with 4.8.7, and i can't catch if ES data stored on ext4
Trace from 4.8.7:
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: INFO: task
btrfs-transacti:4143 blocked for more than 120 seconds.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:       Not tainted 4.8.0-1-amd64 #1
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: btrfs-transacti D
ffff9dd15e0d8180     0  4143      2 0x00000000
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dd954a97100
ffff9dd15a7b80c0 ffffffff920e5e15 ffff9dd956ffbe08
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dd956ffc000
ffff9dd9553091f0 ffff9dd955309000 ffff9dd9553091f0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  0000000000000000
ffff9dd954a97100 ffffffff925eb4d1 ffff9dca41f6e550
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: Call Trace:
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff920e5e15>] ?
try_to_del_timer_sync+0x55/0x80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925eb4d1>] ?
schedule+0x31/0x80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc04f3dad>] ?
wait_current_trans.isra.21+0xcd/0x110 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff920bcf40>] ?
wake_atomic_t_function+0x60/0x60
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc04f6453>] ?
start_transaction+0x273/0x4b0 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc04f02d7>] ?
transaction_kthread+0x77/0x200 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc04f0260>] ?
btrfs_cleanup_transaction+0x590/0x590 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff9209af8d>] ?
kthread+0xcd/0xf0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925efaaf>] ?
ret_from_fork+0x1f/0x40
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff9209aec0>] ?
kthread_create_on_node+0x190/0x190
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: INFO: task htop:12776
blocked for more than 120 seconds.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:       Not tainted 4.8.0-1-amd64 #1
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: htop            D
ffff9dd95d898180     0 12776      1 0x00000004
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dd84d02d0c0
ffff9dd959c9a0c0 ffff9dd183ed3e00 0000004100000000
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dd84d050000
ffff9dd84d04fdf8 ffff9dca4319cc68 ffff9dca4319cc80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffffffffffffffff
ffff9dd84d04fd90 ffffffff925eb4d1 ffff9dd84d02d0c0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: Call Trace:
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925eb4d1>] ?
schedule+0x31/0x80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ede48>] ?
rwsem_down_read_failed+0xf8/0x150
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92334f04>] ?
call_rwsem_down_read_failed+0x14/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ed70c>] ?
down_read+0x1c/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff922715de>] ?
proc_pid_cmdline_read+0xae/0x540
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92202160>] ?
vfs_read+0x90/0x130
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff922035d2>] ?
SyS_read+0x52/0xc0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ef876>] ?
system_call_fast_compare_end+0xc/0x96
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: INFO: task iotop:12785
blocked for more than 120 seconds.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:       Not tainted 4.8.0-1-amd64 #1
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: iotop           D
ffff9dd15e158180     0 12785      1 0x00000004
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dd855a92100
ffff9dd15a7ba140 ffff9dd9546e1c00 00007ff86ac74000
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dd8549cc000
ffff9dd8549cbdf8 ffff9dca4319cc68 ffff9dca4319cc80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffffffffffffffff
ffff9dd8549cbd90 ffffffff925eb4d1 ffff9dd855a92100
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: Call Trace:
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925eb4d1>] ?
schedule+0x31/0x80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ede48>] ?
rwsem_down_read_failed+0xf8/0x150
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92334f04>] ?
call_rwsem_down_read_failed+0x14/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ed70c>] ?
down_read+0x1c/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff922715de>] ?
proc_pid_cmdline_read+0xae/0x540
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92202160>] ?
vfs_read+0x90/0x130
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff922035d2>] ?
SyS_read+0x52/0xc0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ef876>] ?
system_call_fast_compare_end+0xc/0x96
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: INFO: task java:18198
blocked for more than 120 seconds.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:       Not tainted 4.8.0-1-amd64 #1
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: java            D
ffff9dd95d898180     0 18198      1 0x00000100
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dd660e1a140
ffff9dd959c9a0c0 ffff9dd660e1a140 ffffffff92cff1f8
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dca431b4000
ffff9dca431b3e90 ffff9dca4319cc68 ffff9dca4319cc80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffffffffffffffff
ffff9dca431b3e20 ffffffff925eb4d1 ffff9dd660e1a140
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: Call Trace:
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925eb4d1>] ?
schedule+0x31/0x80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ede48>] ?
rwsem_down_read_failed+0xf8/0x150
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff921b51bc>] ?
handle_mm_fault+0xebc/0x1250
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92334f04>] ?
call_rwsem_down_read_failed+0x14/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ed70c>] ?
down_read+0x1c/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92065caf>] ?
__do_page_fault+0x43f/0x500
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925f0c58>] ?
page_fault+0x28/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: INFO: task java:18207
blocked for more than 120 seconds.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:       Not tainted 4.8.0-1-amd64 #1
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: java            D
ffff9dd15e018180     0 18207      1 0x00000100
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dd660e21080
ffffffff92a0d500 ffffffff920f9a34 0000000000000000
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dcf70c28000
ffff9dcf70c27df0 ffff9dca4319cc68 ffff9dca4319cc80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffffffffffffffff
ffff9dcf70c27d80 ffffffff925eb4d1 ffff9dd660e21080
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: Call Trace:
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff920f9a34>] ?
get_futex_key+0x304/0x3d0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925eb4d1>] ?
schedule+0x31/0x80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ede48>] ?
rwsem_down_read_failed+0xf8/0x150
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92334f04>] ?
call_rwsem_down_read_failed+0x14/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ed70c>] ?
down_read+0x1c/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff921c844c>] ?
SyS_madvise+0x3cc/0x920
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff9200337c>] ?
syscall_trace_enter+0xcc/0x300
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92003b8a>] ?
do_syscall_64+0x7a/0xd0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ef925>] ?
entry_SYSCALL64_slow_path+0x25/0x25
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: INFO: task java:18295
blocked for more than 120 seconds.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:       Not tainted 4.8.0-1-amd64 #1
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: java            D
ffff9dd15e0d8180     0 18295      1 0x00000100
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dcb4db10040
ffff9dd15a7b80c0 00007f1cf5c2a610 0000000000000000
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dccd142c000
ffff9dccd142be90 ffff9dca4319cc68 ffff9dca4319cc80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffffffffffffffff
ffff9dccd142be20 ffffffff925eb4d1 ffff9dcb4db10040
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: Call Trace:
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925eb4d1>] ?
schedule+0x31/0x80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ede48>] ?
rwsem_down_read_failed+0xf8/0x150
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92334f04>] ?
call_rwsem_down_read_failed+0x14/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ed70c>] ?
down_read+0x1c/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92065caf>] ?
__do_page_fault+0x43f/0x500
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925f0c58>] ?
page_fault+0x28/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: INFO: task java:18959
blocked for more than 120 seconds.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:       Not tainted 4.8.0-1-amd64 #1
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: java            D
ffff9dd95da58180     0 18959      1 0x00000100
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dd83b3d7080
ffff9dd959ca1100 00007f1cf53297b0 0000000000000000
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dce69624000
ffff9dce69623e90 ffff9dca4319cc68 ffff9dca4319cc80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffffffffffffffff
ffff9dce69623e20 ffffffff925eb4d1 ffff9dd83b3d7080
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: Call Trace:
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925eb4d1>] ?
schedule+0x31/0x80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ede48>] ?
rwsem_down_read_failed+0xf8/0x150
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff921b51bc>] ?
handle_mm_fault+0xebc/0x1250
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92334f04>] ?
call_rwsem_down_read_failed+0x14/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ed70c>] ?
down_read+0x1c/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92065caf>] ?
__do_page_fault+0x43f/0x500
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925f0c58>] ?
page_fault+0x28/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: INFO: task java:19019
blocked for more than 120 seconds.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:       Not tainted 4.8.0-1-amd64 #1
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: java            D
ffff9dd95da58180     0 19019      1 0x00000100
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dca49c62100
ffff9dd959ca1100 0000000000000863 ffff9dd157647ba8
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dd157648000
ffff9dd183d042d8 ffff9dd183d042f0 ffff9dd157647bc0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dd183d042d0
ffff9dd18302c7e8 ffffffff925eb4d1 ffff9dd183d04270
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: Call Trace:
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925eb4d1>] ?
schedule+0x31/0x80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc0533984>] ?
btrfs_tree_lock+0x74/0x210 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff920bcf40>] ?
wake_atomic_t_function+0x60/0x60
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc04cdf57>] ?
btrfs_search_slot+0x707/0x9f0 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc04ce1fe>] ?
btrfs_search_slot+0x9ae/0x9f0 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc05504a1>] ?
btrfs_delete_delayed_items+0xc1/0x310 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc0550a4d>] ?
__btrfs_update_delayed_inode+0x1ad/0x210 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ed26e>] ?
mutex_lock+0xe/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc0550f95>] ?
__btrfs_run_delayed_items+0x4e5/0x5e0 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc04e3bf6>] ?
btrfs_start_dirty_block_groups+0x3c6/0x420 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc04f5a07>] ?
btrfs_commit_transaction+0x267/0xa40 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc051337e>] ?
btrfs_wait_ordered_range+0x7e/0x100 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc050e0a2>] ?
btrfs_sync_file+0x302/0x3f0 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92235888>] ?
do_fsync+0x38/0x60
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92235afc>] ?
SyS_fsync+0xc/0x10
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92003b8a>] ?
do_syscall_64+0x7a/0xd0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ef925>] ?
entry_SYSCALL64_slow_path+0x25/0x25
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: INFO: task java:19058
blocked for more than 120 seconds.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:       Not tainted 4.8.0-1-amd64 #1
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: java            D
ffff9dd15e098180     0 19058      1 0x00000100
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dd5d92e50c0
ffff9dd15a7b6080 0000000000000000 00000000eb451169
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dcc51224000
ffff9dcc51223e90 ffff9dca4319cc68 ffff9dca4319cc80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffffffffffffffff
ffff9dcc51223e20 ffffffff925eb4d1 ffff9dd5d92e50c0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: Call Trace:
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925eb4d1>] ?
schedule+0x31/0x80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ede48>] ?
rwsem_down_read_failed+0xf8/0x150
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff921b4f59>] ?
handle_mm_fault+0xc59/0x1250
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92334f04>] ?
call_rwsem_down_read_failed+0x14/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ed70c>] ?
down_read+0x1c/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92065caf>] ?
__do_page_fault+0x43f/0x500
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925f0c58>] ?
page_fault+0x28/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: INFO: task java:23693
blocked for more than 120 seconds.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:       Not tainted 4.8.0-1-amd64 #1
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: java            D
ffff9dd15e0d8180     0 23693      1 0x00000100
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dca49e8b040
ffff9dd15a7b80c0 ffffffff00010000 ffff9dcaa19a7ca0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dcaa19a8000
ffff9dd660e2a4c8 00000000ffffff00 ffff9dca49e8b040
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  ffff9dca49e8b040
ffff9dcaa19a7cb8 ffffffff925eb4d1 ffff9dd660e2a460
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel: Call Trace:
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925eb4d1>] ?
schedule+0x31/0x80
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc05336c5>] ?
btrfs_tree_read_lock+0xd5/0x120 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff920bcf40>] ?
wake_atomic_t_function+0x60/0x60
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc04c8f8f>] ?
btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc04cdfa6>] ?
btrfs_search_slot+0x756/0x9f0 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ed26e>] ?
mutex_lock+0xe/0x30
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92216770>] ?
fillonedir+0xe0/0xe0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffffc04fa7a1>] ?
btrfs_real_readdir+0xf1/0x590 [btrfs]
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff9221651b>] ?
iterate_dir+0x16b/0x190
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92216a09>] ?
SyS_getdents+0x99/0x120
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92216770>] ?
fillonedir+0xe0/0xe0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff92003b8a>] ?
do_syscall_64+0x7a/0xd0
Nov 25 14:09:30 msq-k1-srv-ids-01 kernel:  [<ffffffff925ef925>] ?
entry_SYSCALL64_slow_path+0x25/0x25

-- 
Have a nice day,
Timofey.
