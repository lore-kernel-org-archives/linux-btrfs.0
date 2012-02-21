From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Deadlock while mounting with current for-linus
Date: Tue, 21 Feb 2012 08:56:29 +0100
Message-ID: <4F434E2D.4050005@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

the current for-linus head as of today (d98456fc) gets stuck
in a deadlock when executing xfstest 083. This is the
corresponding output, preceeded by a related lockdep warning:

Feb 21 08:30:52 oglaroon kernel: [56906.451059] ======================================================
Feb 21 08:30:52 oglaroon kernel: [56906.525002] [ INFO: possible circular locking dependency detected ]
Feb 21 08:30:52 oglaroon kernel: [56906.599986] 3.2.0+ #15
Feb 21 08:30:52 oglaroon kernel: [56906.628170] -------------------------------------------------------
Feb 21 08:30:52 oglaroon kernel: [56906.703156] mount/17200 is trying to acquire lock:
Feb 21 08:30:52 oglaroon kernel: [56906.760458]  (&ei->delalloc_mutex){+.+...}, at: [<ffffffffa01209fd>] btrfs_delalloc_reserve_metadata+0x7d/0x3d0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56906.889835] 
Feb 21 08:30:52 oglaroon kernel: [56906.889835] but task is already holding lock:
Feb 21 08:30:52 oglaroon kernel: [56906.959722]  (&fs_info->cleanup_work_sem){++++..}, at: [<ffffffffa012c079>] open_ctree+0x1689/0x19f0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56907.077657] 
Feb 21 08:30:52 oglaroon kernel: [56907.077658] which lock already depends on the new lock.
Feb 21 08:30:52 oglaroon kernel: [56907.077658] 
Feb 21 08:30:52 oglaroon kernel: [56907.175731] 
Feb 21 08:30:52 oglaroon kernel: [56907.175732] the existing dependency chain (in reverse order) is:
Feb 21 08:30:52 oglaroon kernel: [56907.265379] 
Feb 21 08:30:52 oglaroon kernel: [56907.265379] -> #2 (&fs_info->cleanup_work_sem){++++..}:
Feb 21 08:30:52 oglaroon kernel: [56907.345978]        [<ffffffff810cf957>] lock_acquire+0x97/0x140
Feb 21 08:30:52 oglaroon kernel: [56907.416906]        [<ffffffff818fbab7>] down_write+0x57/0xa0
Feb 21 08:30:52 oglaroon kernel: [56907.484715]        [<ffffffffa0128db7>] btrfs_commit_super+0x57/0xd0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56907.569162]        [<ffffffffa012a160>] close_ctree+0x350/0x3c0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56907.648409]        [<ffffffffa0107988>] btrfs_put_super+0x18/0x30 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56907.729738]        [<ffffffff8118ba4d>] generic_shutdown_super+0x5d/0xe0
Feb 21 08:30:52 oglaroon kernel: [56907.810026]        [<ffffffff8118bb61>] kill_anon_super+0x11/0x20
Feb 21 08:30:52 oglaroon kernel: [56907.883033]        [<ffffffff8118c595>] deactivate_locked_super+0x45/0x70
Feb 21 08:30:52 oglaroon kernel: [56907.964362]        [<ffffffff8118d295>] deactivate_super+0x45/0x60
Feb 21 08:30:52 oglaroon kernel: [56908.038409]        [<ffffffff811a8387>] mntput_no_expire+0xe7/0x130
Feb 21 08:30:52 oglaroon kernel: [56908.113499]        [<ffffffff811a8963>] sys_umount+0x73/0x3b0
Feb 21 08:30:52 oglaroon kernel: [56908.182346]        [<ffffffff819040fb>] system_call_fastpath+0x16/0x1b
Feb 21 08:30:52 oglaroon kernel: [56908.260555] 
Feb 21 08:30:52 oglaroon kernel: [56908.260555] -> #1 (&type->s_umount_key#34){+++++.}:
Feb 21 08:30:52 oglaroon kernel: [56908.337097]        [<ffffffff810cf957>] lock_acquire+0x97/0x140
Feb 21 08:30:52 oglaroon kernel: [56908.408026]        [<ffffffff818fbb47>] down_read+0x47/0xa0
Feb 21 08:30:52 oglaroon kernel: [56908.474795]        [<ffffffff811b2378>] writeback_inodes_sb_nr_if_idle+0x38/0x60
Feb 21 08:30:52 oglaroon kernel: [56908.563403]        [<ffffffffa0120294>] reserve_metadata_bytes+0x4c4/0x760 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56908.654091]        [<ffffffffa0120aac>] btrfs_delalloc_reserve_metadata+0x12c/0x3d0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56908.754137]        [<ffffffffa0120d8b>] btrfs_delalloc_reserve_space+0x3b/0x60 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56908.848986]        [<ffffffffa01344ad>] btrfs_truncate+0x2dd/0x630 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56908.931354]        [<ffffffffa013713e>] btrfs_setattr+0xee/0x190 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56909.011643]        [<ffffffff811a4cf5>] notify_change+0x185/0x2b0
Feb 21 08:30:52 oglaroon kernel: [56909.084650]        [<ffffffff81187f3e>] do_truncate+0x5e/0x90
Feb 21 08:30:52 oglaroon kernel: [56909.153499]        [<ffffffff8118817f>] sys_truncate+0x12f/0x150
Feb 21 08:30:52 oglaroon kernel: [56909.225467]        [<ffffffff819040fb>] system_call_fastpath+0x16/0x1b
Feb 21 08:30:52 oglaroon kernel: [56909.303779] 
Feb 21 08:30:52 oglaroon kernel: [56909.303780] -> #0 (&ei->delalloc_mutex){+.+...}:
Feb 21 08:30:52 oglaroon kernel: [56909.377202]        [<ffffffff810cf073>] __lock_acquire+0x13e3/0x1650
Feb 21 08:30:52 oglaroon kernel: [56909.453643]        [<ffffffff810cf957>] lock_acquire+0x97/0x140
Feb 21 08:30:52 oglaroon kernel: [56909.524938]        [<ffffffff818fb225>] __mutex_lock_common+0x65/0x4d0
Feb 21 08:30:52 oglaroon kernel: [56909.603401]        [<ffffffff818fb7c0>] mutex_lock_nested+0x40/0x50
Feb 21 08:30:52 oglaroon kernel: [56909.678803]        [<ffffffffa01209fd>] btrfs_delalloc_reserve_metadata+0x7d/0x3d0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56909.778331]        [<ffffffffa0120d8b>] btrfs_delalloc_reserve_space+0x3b/0x60 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56909.873595]        [<ffffffffa01344ad>] btrfs_truncate+0x2dd/0x630 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56909.956380]        [<ffffffffa0134f56>] btrfs_orphan_cleanup+0x296/0x490 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56910.045403]        [<ffffffffa012c082>] open_ctree+0x1692/0x19f0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56910.126105]        [<ffffffffa010a680>] btrfs_mount+0x4b0/0x580 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56910.205667]        [<ffffffff8118c7be>] mount_fs+0x3e/0x1a0
Feb 21 08:30:52 oglaroon kernel: [56910.272746]        [<ffffffff811a7b20>] vfs_kern_mount+0x50/0xb0
Feb 21 08:30:52 oglaroon kernel: [56910.345130]        [<ffffffff811a84dd>] do_kern_mount+0x4d/0x110
Feb 21 08:30:52 oglaroon kernel: [56910.417410]        [<ffffffff811aa20d>] do_mount+0x24d/0x7e0
Feb 21 08:30:52 oglaroon kernel: [56910.485530]        [<ffffffff811aa82b>] sys_mount+0x8b/0xe0
Feb 21 08:30:52 oglaroon kernel: [56910.552609]        [<ffffffff819040fb>] system_call_fastpath+0x16/0x1b
Feb 21 08:30:52 oglaroon kernel: [56910.631235] 
Feb 21 08:30:52 oglaroon kernel: [56910.631235] other info that might help us debug this:
Feb 21 08:30:52 oglaroon kernel: [56910.631236] 
Feb 21 08:30:52 oglaroon kernel: [56910.727641] Chain exists of:
Feb 21 08:30:52 oglaroon kernel: [56910.727642]   &ei->delalloc_mutex --> &type->s_umount_key --> &fs_info->cleanup_work_sem
Feb 21 08:30:52 oglaroon kernel: [56910.857953] 
Feb 21 08:30:52 oglaroon kernel: [56910.877933]  Possible unsafe locking scenario:
Feb 21 08:30:52 oglaroon kernel: [56910.877933] 
Feb 21 08:30:52 oglaroon kernel: [56910.949162]        CPU0                    CPU1
Feb 21 08:30:52 oglaroon kernel: [56911.003555]        ----                    ----
Feb 21 08:30:52 oglaroon kernel: [56911.057947]   lock(&fs_info->cleanup_work_sem);
Feb 21 08:30:52 oglaroon kernel: [56911.112442]                                lock(&type->s_umount_key);
Feb 21 08:30:52 oglaroon kernel: [56911.190130]                                lock(&fs_info->cleanup_work_sem);
Feb 21 08:30:52 oglaroon kernel: [56911.275098]   lock(&ei->delalloc_mutex);
Feb 21 08:30:52 oglaroon kernel: [56911.322419] 
Feb 21 08:30:52 oglaroon kernel: [56911.322419]  *** DEADLOCK ***
Feb 21 08:30:52 oglaroon kernel: [56911.322420] 
Feb 21 08:30:52 oglaroon kernel: [56911.393762] 2 locks held by mount/17200:
Feb 21 08:30:52 oglaroon kernel: [56911.440933]  #0:  (&type->s_umount_key#33/1){+.+.+.}, at: [<ffffffff8118cb5e>] sget+0x23e/0x4f0
Feb 21 08:30:52 oglaroon kernel: [56911.546122]  #1:  (&fs_info->cleanup_work_sem){++++..}, at: [<ffffffffa012c079>] open_ctree+0x1689/0x19f0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56911.669779] 
Feb 21 08:30:52 oglaroon kernel: [56911.669779] stack backtrace:
Feb 21 08:30:52 oglaroon kernel: [56911.722300] Pid: 17200, comm: mount Tainted: G        W    3.2.0+ #15
Feb 21 08:30:52 oglaroon kernel: [56911.799674] Call Trace:
Feb 21 08:30:52 oglaroon kernel: [56911.829109]  [<ffffffff810cc4be>] print_circular_bug+0x20e/0x2f0
Feb 21 08:30:52 oglaroon kernel: [56911.901285]  [<ffffffff810cf073>] __lock_acquire+0x13e3/0x1650
Feb 21 08:30:52 oglaroon kernel: [56911.971388]  [<ffffffffa01209fd>] ? btrfs_delalloc_reserve_metadata+0x7d/0x3d0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56912.066540]  [<ffffffff810cf957>] lock_acquire+0x97/0x140
Feb 21 08:30:52 oglaroon kernel: [56912.131443]  [<ffffffffa01209fd>] ? btrfs_delalloc_reserve_metadata+0x7d/0x3d0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56912.226596]  [<ffffffff818fb225>] __mutex_lock_common+0x65/0x4d0
Feb 21 08:30:52 oglaroon kernel: [56912.298779]  [<ffffffffa01209fd>] ? btrfs_delalloc_reserve_metadata+0x7d/0x3d0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56912.393933]  [<ffffffff810bc63b>] ? local_clock+0x4b/0x60
Feb 21 08:30:52 oglaroon kernel: [56912.458834]  [<ffffffffa01209fd>] ? btrfs_delalloc_reserve_metadata+0x7d/0x3d0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56912.553987]  [<ffffffff810cd0cd>] ? lock_release_holdtime+0xed/0x190
Feb 21 08:30:52 oglaroon kernel: [56912.630331]  [<ffffffffa012cd1f>] ? btrfs_transaction_in_commit+0x3f/0x50 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56912.720283]  [<ffffffff818fb7c0>] mutex_lock_nested+0x40/0x50
Feb 21 08:30:52 oglaroon kernel: [56912.789346]  [<ffffffffa01209fd>] btrfs_delalloc_reserve_metadata+0x7d/0x3d0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56912.882419]  [<ffffffff810cd0cd>] ? lock_release_holdtime+0xed/0x190
Feb 21 08:30:52 oglaroon kernel: [56912.958761]  [<ffffffffa0120d8b>] btrfs_delalloc_reserve_space+0x3b/0x60 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56913.047677]  [<ffffffff810c95cd>] ? trace_hardirqs_off+0xd/0x10
Feb 21 08:30:52 oglaroon kernel: [56913.118819]  [<ffffffffa01344ad>] btrfs_truncate+0x2dd/0x630 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56913.195260]  [<ffffffffa0134f56>] btrfs_orphan_cleanup+0x296/0x490 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56913.277837]  [<ffffffffa012c082>] open_ctree+0x1692/0x19f0 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56913.352193]  [<ffffffffa010a680>] btrfs_mount+0x4b0/0x580 [btrfs]
Feb 21 08:30:52 oglaroon kernel: [56913.425405]  [<ffffffff818fb029>] ? mutex_unlock+0x9/0x10
Feb 21 08:30:52 oglaroon kernel: [56913.490300]  [<ffffffff8115c0c9>] ? pcpu_alloc+0x399/0xa00
Feb 21 08:30:52 oglaroon kernel: [56913.556237]  [<ffffffff811a736a>] ? alloc_vfsmnt+0x9a/0x1b0
Feb 21 08:30:52 oglaroon kernel: [56913.623212]  [<ffffffff8118c7be>] mount_fs+0x3e/0x1a0
Feb 21 08:30:52 oglaroon kernel: [56913.683932]  [<ffffffff811a7386>] ? alloc_vfsmnt+0xb6/0x1b0
Feb 21 08:30:52 oglaroon kernel: [56913.750820]  [<ffffffff811a7b20>] vfs_kern_mount+0x50/0xb0
Feb 21 08:30:52 oglaroon kernel: [56913.816755]  [<ffffffff811a84dd>] do_kern_mount+0x4d/0x110
Feb 21 08:30:52 oglaroon kernel: [56913.882693]  [<ffffffff813dd005>] ? security_capable+0x25/0x30
Feb 21 08:30:52 oglaroon kernel: [56913.952788]  [<ffffffff811aa20d>] do_mount+0x24d/0x7e0
Feb 21 08:30:52 oglaroon kernel: [56914.014563]  [<ffffffff81157476>] ? memdup_user+0x46/0x90
Feb 21 08:30:52 oglaroon kernel: [56914.079459]  [<ffffffff81157513>] ? strndup_user+0x53/0x70
Feb 21 08:30:52 oglaroon kernel: [56914.145395]  [<ffffffff811aa82b>] sys_mount+0x8b/0xe0
Feb 21 08:30:52 oglaroon kernel: [56914.206133]  [<ffffffff819040fb>] system_call_fastpath+0x16/0x1b
Feb 21 08:30:52 oglaroon kernel: [56914.305298] BTRFS: inode 365 still on the orphan list
Feb 21 08:30:52 oglaroon kernel: [56914.365840] btrfs: could not do orphan cleanup -28
Feb 21 08:30:52 oglaroon kernel: [56914.516029] btrfs: open_ctree failed

-Jan
