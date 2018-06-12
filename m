Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:43460 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934383AbeFLXsS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Jun 2018 19:48:18 -0400
Received: by mail-io0-f195.google.com with SMTP id t6-v6so1434112iob.10
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2018 16:48:18 -0700 (PDT)
MIME-Version: 1.0
From: Alexander Zapatka <alexzapatka@gmail.com>
Date: Tue, 12 Jun 2018 19:48:06 -0400
Message-ID: <CAFd7XodrzgLZrMQW_AUcZVL_3tZuw9mWn7CF-Sibz84J7RPP+A@mail.gmail.com>
Subject: deadlock on btrfs scrub...
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello.  a while ago i wrote to the list that i was getting a deadlock
when working with a btrfs file system on a drive that had a bad
sector.  i finally resolved the bad sector, smartctl says there are no
bad sectors, and it has been successfully remapped.  after it had been
resolved i still am getting the dead locks.  i am on the latest ubuntu
kernel with the latest release btrfs-progs...

$ btrfs --version
btrfs-progs v4.16.1
$ uname -a
Linux kodbox 4.17.0-041700-generic #201806032231 SMP Sun Jun 3
22:33:34 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

when i run the scrub it seams to deadlock here:

scrub status for cb30a848-1882-4f7f-aae1-1533f52d8783
        scrub started at Tue Jun 12 07:46:02 2018, running for 11:54:47
        total bytes scrubbed: 1.55TiB with 0 errors

i get this in dmesg:

[166039.655485] usb 2-3: reset SuperSpeed USB device number 3 using xhci_hcd
[166141.914961] INFO: task btrfs-transacti:660 blocked for more than
120 seconds.
[166141.914983]       Not tainted 4.17.0-041700-generic #201806032231
[166141.914991] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[166141.915003] btrfs-transacti D    0   660      2 0x80000000
[166141.915011] Call Trace:
[166141.915032]  __schedule+0x291/0x870
[166141.915040]  schedule+0x2c/0x80
[166141.915123]  btrfs_scrub_pause+0x9a/0xf0 [btrfs]
[166141.915131]  ? wait_woken+0x80/0x80
[166141.915197]  btrfs_commit_transaction+0x20c/0x8a0 [btrfs]
[166141.915261]  ? start_transaction+0xa0/0x3e0 [btrfs]
[166141.915326]  transaction_kthread+0x14b/0x170 [btrfs]
[166141.915333]  kthread+0x121/0x140
[166141.915397]  ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[166141.915403]  ? kthread_create_worker_on_cpu+0x70/0x70
[166141.915409]  ret_from_fork+0x35/0x40
[166141.915457] INFO: task btrfs:2617 blocked for more than 120 seconds.
[166141.915467]       Not tainted 4.17.0-041700-generic #201806032231
[166141.915475] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[166141.915484] btrfs           D    0  2617      1 0x00000000
[166141.915490] Call Trace:
[166141.915498]  __schedule+0x291/0x870
[166141.915505]  schedule+0x2c/0x80
[166141.915577]  __scrub_blocked_if_needed+0x79/0xd0 [btrfs]
[166141.915583]  ? wait_woken+0x80/0x80
[166141.915652]  scrub_pause_off+0x26/0x60 [btrfs]
[166141.915721]  scrub_enumerate_chunks+0x345/0x660 [btrfs]
[166141.915729]  ? wait_woken+0x80/0x80
[166141.915798]  btrfs_scrub_dev+0x1ea/0x550 [btrfs]
[166141.915806]  ? __mnt_want_write+0x49/0x60
[166141.915876]  btrfs_ioctl+0x1726/0x1c80 [btrfs]
[166141.915884]  ? __handle_mm_fault+0x47b/0x5c0
[166141.915893]  do_vfs_ioctl+0xa8/0x620
[166141.915963]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
[166141.915969]  ? do_vfs_ioctl+0xa8/0x620
[166141.915976]  ? get_task_io_context+0x46/0x90
[166141.915983]  ksys_ioctl+0x75/0x80
[166141.915990]  __x64_sys_ioctl+0x1a/0x20
[166141.915997]  do_syscall_64+0x5a/0x120
[166141.916003]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[166141.916008] RIP: 0033:0x7ff7dce01ef7
[166141.916012] RSP: 002b:00007ff7dccf6d48 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[166141.916018] RAX: ffffffffffffffda RBX: 0000555a49ef4660 RCX:
00007ff7dce01ef7
[166141.916021] RDX: 0000555a49ef4660 RSI: 00000000c400941b RDI:
0000000000000003
[166141.916025] RBP: 0000000000000000 R08: 00007ff7dccf7700 R09:
00007ff7dccf6da0
[166141.916028] R10: 00007ff7dccf7700 R11: 0000000000000246 R12:
00007ffced6360be
[166141.916031] R13: 00007ffced6360bf R14: 00007ff7dccf7700 R15:
00007ff7dccf79c0
[166141.916039] INFO: task btrfs:2618 blocked for more than 120 seconds.
[166141.916048]       Not tainted 4.17.0-041700-generic #201806032231
[166141.916056] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[166141.916065] btrfs           D    0  2618      1 0x00000000
[166141.916070] Call Trace:
[166141.916077]  __schedule+0x291/0x870
[166141.916084]  schedule+0x2c/0x80
[166141.916153]  __scrub_blocked_if_needed+0x79/0xd0 [btrfs]
[166141.916158]  ? wait_woken+0x80/0x80
[166141.916227]  scrub_pause_off+0x26/0x60 [btrfs]
[166141.916295]  scrub_stripe+0x9ca/0x10a0 [btrfs]
[166141.916306]  ? wait_woken+0x80/0x80
[166141.916365]  ? btrfs_block_rsv_check+0x25/0x70 [btrfs]
[166141.916435]  scrub_chunk+0x100/0x150 [btrfs]
[166141.916503]  ? lookup_extent_mapping+0x13/0x20 [btrfs]
[166141.916572]  ? scrub_chunk+0x100/0x150 [btrfs]
[166141.916641]  scrub_enumerate_chunks+0x2c6/0x660 [btrfs]
[166141.916649]  ? wait_woken+0x50/0x80
[166141.916718]  btrfs_scrub_dev+0x1ea/0x550 [btrfs]
[166141.916724]  ? __mnt_want_write+0x49/0x60
[166141.916795]  btrfs_ioctl+0x1726/0x1c80 [btrfs]
[166141.916801]  ? __handle_mm_fault+0x47b/0x5c0
[166141.916809]  do_vfs_ioctl+0xa8/0x620
[166141.916878]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
[166141.916884]  ? do_vfs_ioctl+0xa8/0x620
[166141.916890]  ? get_task_io_context+0x46/0x90
[166141.916897]  ksys_ioctl+0x75/0x80
[166141.916903]  __x64_sys_ioctl+0x1a/0x20
[166141.916909]  do_syscall_64+0x5a/0x120
[166141.916915]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[166141.916919] RIP: 0033:0x7ff7dce01ef7
[166141.916922] RSP: 002b:00007ff7dc4f5d48 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[166141.916927] RAX: ffffffffffffffda RBX: 0000555a49ef4ae0 RCX:
00007ff7dce01ef7
[166141.916930] RDX: 0000555a49ef4ae0 RSI: 00000000c400941b RDI:
0000000000000003
[166141.916933] RBP: 0000000000000000 R08: 00007ff7dc4f6700 R09:
00007ff7dc4f5da0
[166141.916937] R10: 00007ff7dc4f6700 R11: 0000000000000246 R12:
00007ffced6360be
[166141.916940] R13: 00007ffced6360bf R14: 00007ff7dc4f6700 R15:
00007ff7dc4f69c0
[166141.916946] INFO: task btrfs:2619 blocked for more than 120 seconds.
[166141.916957]       Not tainted 4.17.0-041700-generic #201806032231
[166141.916965] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[166141.916975] btrfs           D    0  2619      1 0x00000000
[166141.916980] Call Trace:
[166141.916988]  __schedule+0x291/0x870
[166141.916995]  schedule+0x2c/0x80
[166141.917063]  __scrub_blocked_if_needed+0x79/0xd0 [btrfs]
[166141.917069]  ? wait_woken+0x80/0x80
[166141.917137]  scrub_pause_off+0x26/0x60 [btrfs]
[166141.917206]  scrub_enumerate_chunks+0x345/0x660 [btrfs]
[166141.917214]  ? wait_woken+0x80/0x80
[166141.917283]  btrfs_scrub_dev+0x1ea/0x550 [btrfs]
[166141.917289]  ? __mnt_want_write+0x49/0x60
[166141.917359]  btrfs_ioctl+0x1726/0x1c80 [btrfs]
[166141.917369]  do_vfs_ioctl+0xa8/0x620
[166141.917438]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
[166141.917444]  ? do_vfs_ioctl+0xa8/0x620
[166141.917450]  ? get_task_io_context+0x46/0x90
[166141.917457]  ksys_ioctl+0x75/0x80
[166141.917464]  ? __switch_to+0x13a/0x500
[166141.917471]  __x64_sys_ioctl+0x1a/0x20
[166141.917476]  do_syscall_64+0x5a/0x120
[166141.917482]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[166141.917486] RIP: 0033:0x7ff7dce01ef7
[166141.917489] RSP: 002b:00007ff7dbcf4d48 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[166141.917494] RAX: ffffffffffffffda RBX: 0000555a49ef4f60 RCX:
00007ff7dce01ef7
[166141.917497] RDX: 0000555a49ef4f60 RSI: 00000000c400941b RDI:
0000000000000003
[166141.917500] RBP: 0000000000000000 R08: 00007ff7dbcf5700 R09:
0000000000000000
[166141.917503] R10: 00007ff7dbcf5700 R11: 0000000000000246 R12:
00007ffced6360be
[166141.917506] R13: 00007ffced6360bf R14: 00007ff7dbcf5700 R15:
00007ff7dbcf59c0
[166141.917513] INFO: task btrfs:2620 blocked for more than 120 seconds.
[166141.917523]       Not tainted 4.17.0-041700-generic #201806032231
[166141.917531] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[166141.917541] btrfs           D    0  2620      1 0x00000000
[166141.917546] Call Trace:
[166141.917553]  __schedule+0x291/0x870
[166141.917622]  ? scrub_missing_raid56_end_io+0x50/0x50 [btrfs]
[166141.917629]  schedule+0x2c/0x80
[166141.917697]  scrub_add_page_to_rd_bio+0x216/0x2c0 [btrfs]
[166141.917703]  ? wait_woken+0x80/0x80
[166141.917772]  scrub_pages+0x215/0x400 [btrfs]
[166141.917843]  scrub_stripe+0x7c7/0x10a0 [btrfs]
[166141.917908]  ? btrfs_block_rsv_check+0x25/0x70 [btrfs]
[166141.917978]  scrub_chunk+0x100/0x150 [btrfs]
[166141.918045]  ? lookup_extent_mapping+0x13/0x20 [btrfs]
[166141.918114]  ? scrub_chunk+0x100/0x150 [btrfs]
[166141.918183]  scrub_enumerate_chunks+0x2c6/0x660 [btrfs]
[166141.918191]  ? wait_woken+0x50/0x80
[166141.918260]  btrfs_scrub_dev+0x1ea/0x550 [btrfs]
[166141.918266]  ? __mnt_want_write+0x49/0x60
[166141.918337]  btrfs_ioctl+0x1726/0x1c80 [btrfs]
[166141.918347]  do_vfs_ioctl+0xa8/0x620
[166141.918417]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
[166141.918423]  ? do_vfs_ioctl+0xa8/0x620
[166141.918429]  ? get_task_io_context+0x46/0x90
[166141.918435]  ksys_ioctl+0x75/0x80
[166141.918442]  ? __switch_to+0x13a/0x500
[166141.918448]  __x64_sys_ioctl+0x1a/0x20
[166141.918454]  do_syscall_64+0x5a/0x120
[166141.918460]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[166141.918463] RIP: 0033:0x7ff7dce01ef7
[166141.918466] RSP: 002b:00007ff7db4f3d48 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[166141.918472] RAX: ffffffffffffffda RBX: 0000555a49ef53e0 RCX:
00007ff7dce01ef7
[166141.918475] RDX: 0000555a49ef53e0 RSI: 00000000c400941b RDI:
0000000000000003
[166141.918478] RBP: 0000000000000000 R08: 00007ff7db4f4700 R09:
0000000000000000
[166141.918481] R10: 00007ff7db4f4700 R11: 0000000000000246 R12:
00007ffced6360be
[166141.918484] R13: 00007ffced6360bf R14: 00007ff7db4f4700 R15:
00007ff7db4f49c0
[166262.746841] INFO: task scsi_eh_3:211 blocked for more than 120 seconds.
[166262.746864]       Not tainted 4.17.0-041700-generic #201806032231
[166262.746873] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[166262.746885] scsi_eh_3       D    0   211      2 0x80000000
[166262.746893] Call Trace:
[166262.746914]  __schedule+0x291/0x870
[166262.746922]  schedule+0x2c/0x80
[166262.746929]  schedule_preempt_disabled+0xe/0x10
[166262.746935]  __mutex_lock.isra.4+0x18c/0x4d0
[166262.746944]  ? dequeue_task_fair+0x676/0x830
[166262.746951]  __mutex_lock_slowpath+0x13/0x20
[166262.746957]  ? __mutex_lock_slowpath+0x13/0x20
[166262.746962]  mutex_lock+0x2f/0x40
[166262.746977]  device_reset+0x22/0x50 [usb_storage]
[166262.746985]  scsi_eh_ready_devs+0x333/0xbf0
[166262.746994]  ? __pm_runtime_resume+0x5b/0x80
[166262.746999]  ? scsi_try_target_reset+0x90/0x90
[166262.747005]  scsi_error_handler+0x4c2/0x5b0
[166262.747013]  kthread+0x121/0x140
[166262.747018]  ? scsi_eh_get_sense+0x200/0x200
[166262.747024]  ? kthread_create_worker_on_cpu+0x70/0x70
[166262.747029]  ret_from_fork+0x35/0x40
[166262.747037] INFO: task usb-storage:213 blocked for more than 120 seconds.
[166262.747049]       Not tainted 4.17.0-041700-generic #201806032231
[166262.747056] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[166262.747067] usb-storage     D    0   213      2 0x80000000
[166262.747072] Call Trace:
[166262.747080]  __schedule+0x291/0x870
[166262.747087]  schedule+0x2c/0x80
[166262.747093]  schedule_timeout+0x1db/0x360
[166262.747098]  ? schedule+0x2c/0x80
[166262.747104]  ? schedule_timeout+0x1db/0x360
[166262.747110]  ? _cond_resched+0x19/0x40
[166262.747116]  wait_for_completion+0xba/0x140
[166262.747123]  ? wake_up_q+0x80/0x80
[166262.747130]  usb_sg_wait+0x12d/0x190
[166262.747140]  usb_stor_bulk_transfer_sglist.part.1+0x67/0xc0 [usb_storage]
[166262.747149]  usb_stor_bulk_srb+0x4b/0x80 [usb_storage]
[166262.747157]  usb_stor_Bulk_transport+0x175/0x400 [usb_storage]
[166262.747166]  usb_stor_invoke_transport+0x41/0x540 [usb_storage]
[166262.747173]  ? default_wake_function+0x12/0x20
[166262.747181]  ? wait_for_completion_interruptible+0xb7/0x180
[166262.747190]  usb_stor_transparent_scsi_command+0xe/0x10 [usb_storage]
[166262.747198]  usb_stor_control_thread+0x1ca/0x290 [usb_storage]
[166262.747205]  kthread+0x121/0x140
[166262.747214]  ? usb_stor_disconnect+0xc0/0xc0 [usb_storage]
[166262.747219]  ? kthread_create_worker_on_cpu+0x70/0x70
[166262.747224]  ret_from_fork+0x35/0x40
[166262.747245] INFO: task btrfs-transacti:660 blocked for more than
120 seconds.
[166262.747256]       Not tainted 4.17.0-041700-generic #201806032231
[166262.747264] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[166262.747274] btrfs-transacti D    0   660      2 0x80000000
[166262.747279] Call Trace:
[166262.747287]  __schedule+0x291/0x870
[166262.747293]  schedule+0x2c/0x80
[166262.747374]  btrfs_scrub_pause+0x9a/0xf0 [btrfs]
[166262.747380]  ? wait_woken+0x80/0x80
[166262.747446]  btrfs_commit_transaction+0x20c/0x8a0 [btrfs]
[166262.747510]  ? start_transaction+0xa0/0x3e0 [btrfs]
[166262.747575]  transaction_kthread+0x14b/0x170 [btrfs]
[166262.747581]  kthread+0x121/0x140
[166262.747644]  ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[166262.747650]  ? kthread_create_worker_on_cpu+0x70/0x70
[166262.747655]  ret_from_fork+0x35/0x40
[166262.747701] INFO: task btrfs:2617 blocked for more than 120 seconds.
[166262.747712]       Not tainted 4.17.0-041700-generic #201806032231
[166262.747720] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[166262.747730] btrfs           D    0  2617      1 0x00000000
[166262.747736] Call Trace:
[166262.747743]  __schedule+0x291/0x870
[166262.747750]  schedule+0x2c/0x80
[166262.747822]  __scrub_blocked_if_needed+0x79/0xd0 [btrfs]
[166262.747828]  ? wait_woken+0x80/0x80
[166262.747897]  scrub_pause_off+0x26/0x60 [btrfs]
[166262.747966]  scrub_enumerate_chunks+0x345/0x660 [btrfs]
[166262.747973]  ? wait_woken+0x80/0x80
[166262.748043]  btrfs_scrub_dev+0x1ea/0x550 [btrfs]
[166262.748051]  ? __mnt_want_write+0x49/0x60
[166262.748121]  btrfs_ioctl+0x1726/0x1c80 [btrfs]
[166262.748129]  ? __handle_mm_fault+0x47b/0x5c0
[166262.748139]  do_vfs_ioctl+0xa8/0x620
[166262.748208]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
[166262.748214]  ? do_vfs_ioctl+0xa8/0x620
[166262.748221]  ? get_task_io_context+0x46/0x90
[166262.748228]  ksys_ioctl+0x75/0x80
[166262.748235]  __x64_sys_ioctl+0x1a/0x20
[166262.748242]  do_syscall_64+0x5a/0x120
[166262.748248]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[166262.748254] RIP: 0033:0x7ff7dce01ef7
[166262.748257] RSP: 002b:00007ff7dccf6d48 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[166262.748264] RAX: ffffffffffffffda RBX: 0000555a49ef4660 RCX:
00007ff7dce01ef7
[166262.748267] RDX: 0000555a49ef4660 RSI: 00000000c400941b RDI:
0000000000000003
[166262.748270] RBP: 0000000000000000 R08: 00007ff7dccf7700 R09:
00007ff7dccf6da0
[166262.748273] R10: 00007ff7dccf7700 R11: 0000000000000246 R12:
00007ffced6360be
[166262.748276] R13: 00007ffced6360bf R14: 00007ff7dccf7700 R15:
00007ff7dccf79c0
[166262.748284] INFO: task btrfs:2618 blocked for more than 120 seconds.
[166262.748294]       Not tainted 4.17.0-041700-generic #201806032231
[166262.748302] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[166262.748312] btrfs           D    0  2618      1 0x00000000
[166262.748317] Call Trace:
[166262.748325]  __schedule+0x291/0x870
[166262.748331]  schedule+0x2c/0x80
[166262.748400]  __scrub_blocked_if_needed+0x79/0xd0 [btrfs]
[166262.748405]  ? wait_woken+0x80/0x80
[166262.748474]  scrub_pause_off+0x26/0x60 [btrfs]
[166262.748543]  scrub_stripe+0x9ca/0x10a0 [btrfs]
[166262.748554]  ? wait_woken+0x80/0x80
[166262.748613]  ? btrfs_block_rsv_check+0x25/0x70 [btrfs]
[166262.748683]  scrub_chunk+0x100/0x150 [btrfs]
[166262.748750]  ? lookup_extent_mapping+0x13/0x20 [btrfs]
[166262.748819]  ? scrub_chunk+0x100/0x150 [btrfs]
[166262.748888]  scrub_enumerate_chunks+0x2c6/0x660 [btrfs]
[166262.748897]  ? wait_woken+0x50/0x80
[166262.748966]  btrfs_scrub_dev+0x1ea/0x550 [btrfs]
[166262.748972]  ? __mnt_want_write+0x49/0x60
[166262.749042]  btrfs_ioctl+0x1726/0x1c80 [btrfs]
[166262.749048]  ? __handle_mm_fault+0x47b/0x5c0
[166262.749056]  do_vfs_ioctl+0xa8/0x620
[166262.749126]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
[166262.749132]  ? do_vfs_ioctl+0xa8/0x620
[166262.749138]  ? get_task_io_context+0x46/0x90
[166262.749145]  ksys_ioctl+0x75/0x80
[166262.749151]  __x64_sys_ioctl+0x1a/0x20
[166262.749157]  do_syscall_64+0x5a/0x120
[166262.749163]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[166262.749166] RIP: 0033:0x7ff7dce01ef7
[166262.749169] RSP: 002b:00007ff7dc4f5d48 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[166262.749175] RAX: ffffffffffffffda RBX: 0000555a49ef4ae0 RCX:
00007ff7dce01ef7
[166262.749178] RDX: 0000555a49ef4ae0 RSI: 00000000c400941b RDI:
0000000000000003
[166262.749181] RBP: 0000000000000000 R08: 00007ff7dc4f6700 R09:
00007ff7dc4f5da0
[166262.749184] R10: 00007ff7dc4f6700 R11: 0000000000000246 R12:
00007ffced6360be
[166262.749188] R13: 00007ffced6360bf R14: 00007ff7dc4f6700 R15:
00007ff7dc4f69c0


i have increased the drive timeouts and i has had no effect.  on top
of this, i cannot kill the btrfs scrub without rebooting the
machine... usually forcefully with sysrq commands.  anyone have any
idea what is happening?  smartctl says the drive is fine, but maybe i
still have a bad sector?


-- 
 -o)
  /\\    Message void if penguin violated
_\_V    Don't mess with the penguin
