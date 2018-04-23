Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55738 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932567AbeDWXal (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 19:30:41 -0400
Date: Tue, 24 Apr 2018 01:30:39 +0200
From: Petr Janecek <janecek@ucw.cz>
To: linux-btrfs@vger.kernel.org
Subject: 4.14.35: possible circular locking dependency detected
Message-ID: <20180423233039.GA26751@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
   after scrub start, scrub cancel, umount, mount of a two disk raid1
(data + metadata):

[12999.229791] ======================================================
[12999.236029] WARNING: possible circular locking dependency detected
[12999.242261] 4.14.35 #36 Not tainted
[12999.245806] ------------------------------------------------------
[12999.252037] btrfs/4682 is trying to acquire lock:
[12999.256794]  ("%s-%s""btrfs", name){+.+.}, at: [<ffffffff9b06f900>] flush_workqueue+0x70/0x480
[12999.265486] 
               but task is already holding lock:
[12999.271390]  (&fs_info->scrub_lock){+.+.}, at: [<ffffffffc03e82f1>] btrfs_scrub_dev+0x311/0x650 [btrfs]
[12999.280887] 
               which lock already depends on the new lock.

[12999.289147] 
               the existing dependency chain (in reverse order) is:
[12999.296721] 
               -> #3 (&fs_info->scrub_lock){+.+.}:
[12999.302949]        __mutex_lock+0x66/0x9a0
[12999.307287]        btrfs_scrub_dev+0x105/0x650 [btrfs]
[12999.312615]        btrfs_ioctl+0x19a0/0x2030 [btrfs]
[12999.317706]        do_vfs_ioctl+0x8c/0x6a0
[12999.321951]        SyS_ioctl+0x6f/0x80
[12999.325860]        do_syscall_64+0x64/0x170
[12999.330202]        entry_SYSCALL_64_after_hwframe+0x42/0xb7
[12999.335930] 
               -> #2 (&fs_devs->device_list_mutex){+.+.}:
[12999.342798]        __mutex_lock+0x66/0x9a0
[12999.347049]        reada_start_machine_worker+0xb0/0x3c0 [btrfs]
[12999.353324]        btrfs_worker_helper+0x8b/0x630 [btrfs]
[12999.358926]        process_one_work+0x242/0x6a0
[12999.363613]        worker_thread+0x32/0x3f0
[12999.367894]        kthread+0x11f/0x140
[12999.371792]        ret_from_fork+0x3a/0x50
[12999.376038] 
               -> #1 ((&work->normal_work)){+.+.}:
[12999.382254]        process_one_work+0x20c/0x6a0
[12999.386881]        worker_thread+0x32/0x3f0
[12999.391216]        kthread+0x11f/0x140
[12999.395107]        ret_from_fork+0x3a/0x50
[12999.399290] 
               -> #0 ("%s-%s""btrfs", name){+.+.}:
[12999.405455]        lock_acquire+0x93/0x220
[12999.409683]        flush_workqueue+0x97/0x480
[12999.414129]        drain_workqueue+0xa4/0x180
[12999.418620]        destroy_workqueue+0xe/0x1e0
[12999.423202]        btrfs_destroy_workqueue+0x57/0x280 [btrfs]
[12999.429137]        scrub_workers_put+0x29/0x60 [btrfs]
[12999.434426]        btrfs_scrub_dev+0x324/0x650 [btrfs]
[12999.439764]        btrfs_ioctl+0x19a0/0x2030 [btrfs]
[12999.444870]        do_vfs_ioctl+0x8c/0x6a0
[12999.449115]        SyS_ioctl+0x6f/0x80
[12999.453017]        do_syscall_64+0x64/0x170
[12999.457367]        entry_SYSCALL_64_after_hwframe+0x42/0xb7
[12999.463103] 
               other info that might help us debug this:

[12999.471370] Chain exists of:
                 "%s-%s""btrfs", name --> &fs_devs->device_list_mutex --> &fs_info->scrub_lock

[12999.484396]  Possible unsafe locking scenario:

[12999.490524]        CPU0                    CPU1
[12999.495161]        ----                    ----
[12999.499840]   lock(&fs_info->scrub_lock);
[12999.504001]                                lock(&fs_devs->device_list_mutex);
[12999.511341]                                lock(&fs_info->scrub_lock);
[12999.518074]   lock("%s-%s""btrfs", name);
[12999.522243] 
                *** DEADLOCK ***

[12999.528347] 2 locks held by btrfs/4682:
[12999.532330]  #0:  (sb_writers#15){.+.+}, at: [<ffffffff9b1fd163>] mnt_want_write_file+0x33/0xb0
[12999.541310]  #1:  (&fs_info->scrub_lock){+.+.}, at: [<ffffffffc03e82f1>] btrfs_scrub_dev+0x311/0x650 [btrfs]
[12999.551389] 
               stack backtrace:
[12999.555917] CPU: 3 PID: 4682 Comm: btrfs Not tainted 4.14.35 #36
[12999.562139] Hardware name: Supermicro X8SIL/X8SIL, BIOS 1.2a       06/27/2012
[12999.569487] Call Trace:
[12999.572049]  dump_stack+0x67/0x95
[12999.575530]  print_circular_bug.isra.42+0x1ce/0x1db
[12999.580580]  __lock_acquire+0x121c/0x1300
[12999.584758]  ? lock_acquire+0x93/0x220
[12999.588668]  lock_acquire+0x93/0x220
[12999.592316]  ? flush_workqueue+0x70/0x480
[12999.596485]  flush_workqueue+0x97/0x480
[12999.600487]  ? flush_workqueue+0x70/0x480
[12999.604596]  ? find_held_lock+0x2d/0x90
[12999.608541]  ? drain_workqueue+0xa4/0x180
[12999.612724]  drain_workqueue+0xa4/0x180
[12999.616730]  destroy_workqueue+0xe/0x1e0
[12999.620784]  btrfs_destroy_workqueue+0x57/0x280 [btrfs]
[12999.626252]  scrub_workers_put+0x29/0x60 [btrfs]
[12999.631087]  btrfs_scrub_dev+0x324/0x650 [btrfs]
[12999.635814]  ? __sb_start_write+0x137/0x1a0
[12999.640156]  ? mnt_want_write_file+0x33/0xb0
[12999.644624]  btrfs_ioctl+0x19a0/0x2030 [btrfs]
[12999.649194]  ? find_held_lock+0x2d/0x90
[12999.653146]  ? do_vfs_ioctl+0x8c/0x6a0
[12999.657095]  ? btrfs_ioctl_get_supported_features+0x20/0x20 [btrfs]
[12999.663572]  do_vfs_ioctl+0x8c/0x6a0
[12999.667203]  ? __fget+0x100/0x1f0
[12999.670627]  SyS_ioctl+0x6f/0x80
[12999.673954]  do_syscall_64+0x64/0x170
[12999.677777]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[12999.682993] RIP: 0033:0x7f409f638f07
[12999.686667] RSP: 002b:00007f409f549d38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[12999.694458] RAX: ffffffffffffffda RBX: 000055a730ca04b0 RCX: 00007f409f638f07
[12999.701808] RDX: 000055a730ca04b0 RSI: 00000000c400941b RDI: 0000000000000003
[12999.709208] RBP: 0000000000000000 R08: 00007f409f54a700 R09: 0000000000000000
[12999.716550] R10: 00007f409f54a700 R11: 0000000000000246 R12: 00007ffdd7f5481e
[12999.723899] R13: 00007ffdd7f5481f R14: 00007ffdd7f54820 R15: 0000000000000000


Regards,

Petr
