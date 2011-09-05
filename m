From: Arne Jansen <sensille@gmx.net>
Subject: Lockdep rant on 3.1-rc4 with balance
Date: Mon, 05 Sep 2011 15:21:03 +0200
Message-ID: <4E64CCBF.40605@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While testing with balance I ran into the following lockdep issue.
It occurs on the second run.

[16678.879547] =======================================================
[16678.972317] [ INFO: possible circular locking dependency detected ]
[16679.047301] 3.1.0-rc4+ #61
[16679.079644] -------------------------------------------------------
[16679.154630] umount/22597 is trying to acquire lock:
[16679.212972]  (&fs_info->cleaner_mutex){+.+.+.}, at: 
[<ffffffffa0061041>] btrfs_commit_super+0x21/0xd0 [btrfs]
[16679.331950]
[16679.331950] but task is already holding lock:
[16679.401836]  (&type->s_umount_key#34){++++..}, at: 
[<ffffffff8118216d>] deactivate_super+0x3d/0x60
[16679.509476]
[16679.509477] which lock already depends on the new lock.
[16679.509478]
[16679.607548]
[16679.607548] the existing dependency chain (in reverse order) is:
[16679.697197]
[16679.697198] -> #1 (&type->s_umount_key#34){++++..}:
[16679.773741]        [<ffffffff810cc3d7>] lock_acquire+0x97/0x110
[16679.844668]        [<ffffffff8188e609>] down_read+0x39/0x90
[16679.911436]        [<ffffffff811a5845>] 
writeback_inodes_sb_nr_if_idle+0x35/0x60
[16680.000044]        [<ffffffffa004fe9a>] 
reserve_metadata_bytes+0x34a/0x540 [btrfs]
[16680.090734]        [<ffffffffa0050ff4>] 
btrfs_delalloc_reserve_metadata+0xd4/0x150 [btrfs]
[16680.189741]        [<ffffffffa00a4895>] 
relocate_file_extent_cluster+0x145/0x350 [btrfs]
[16680.286668]        [<ffffffffa00a4b53>] 
relocate_data_extent+0xb3/0xd0 [btrfs]
[16680.373197]        [<ffffffffa00a98db>] 
relocate_block_group+0x33b/0x600 [btrfs]
[16680.461909]        [<ffffffffa00a9d48>] 
btrfs_relocate_block_group+0x1a8/0x2d0 [btrfs]
[16680.556756]        [<ffffffffa00894e3>] 
btrfs_relocate_chunk+0x83/0x680 [btrfs]
[16680.644325]        [<ffffffffa008a898>] btrfs_balance+0x228/0x2a0 
[btrfs]
[16680.725652]        [<ffffffffa0093888>] btrfs_ioctl+0x848/0xd30 [btrfs]
[16680.804901]        [<ffffffff8118fecc>] do_vfs_ioctl+0x9c/0x560
[16680.875828]        [<ffffffff81190429>] sys_ioctl+0x99/0xa0
[16680.942612]        [<ffffffff818975fb>] system_call_fastpath+0x16/0x1b
[16681.020910]
[16681.020911] -> #0 (&fs_info->cleaner_mutex){+.+.+.}:
[16681.098389]        [<ffffffff810cbb23>] __lock_acquire+0x13a3/0x1610
[16681.174516]        [<ffffffff810cc3d7>] lock_acquire+0x97/0x110
[16681.245445]        [<ffffffff8188ded8>] __mutex_lock_common+0x48/0x3a0
[16681.323652]        [<ffffffff8188e2a6>] mutex_lock_nested+0x16/0x20
[16681.398740]        [<ffffffffa0061041>] btrfs_commit_super+0x21/0xd0 
[btrfs]
[16681.483189]        [<ffffffffa0062000>] close_ctree+0x310/0x380 [btrfs]
[16681.562437]        [<ffffffffa00425e8>] btrfs_put_super+0x18/0x30 
[btrfs]
[16681.643765]        [<ffffffff8118094d>] generic_shutdown_super+0x5d/0xe0
[16681.724054]        [<ffffffff81180a61>] kill_anon_super+0x11/0x20
[16681.797060]        [<ffffffff81181475>] deactivate_locked_super+0x45/0x70
[16681.878389]        [<ffffffff81182175>] deactivate_super+0x45/0x60
[16681.952437]        [<ffffffff8119c4e7>] mntput_no_expire+0xe7/0x130
[16682.027524]        [<ffffffff8119c9d3>] sys_umount+0x73/0x3a0
[16682.096373]        [<ffffffff818975fb>] system_call_fastpath+0x16/0x1b
[16682.174612]
[16682.174613] other info that might help us debug this:
[16682.174614]
[16682.270676]  Possible unsafe locking scenario:
[16682.270676]
[16682.341611]        CPU0                    CPU1
[16682.395789]        ----                    ----
[16682.449972]   lock(&type->s_umount_key);
[16682.497085]                                lock(&fs_info->cleaner_mutex);
[16682.578516]                                lock(&type->s_umount_key);
[16682.655892]   lock(&fs_info->cleaner_mutex);
[16682.707165]
[16682.707165]  *** DEADLOCK ***
[16682.707166]
[16682.778197] 1 lock held by umount/22597:
[16682.825101]  #0:  (&type->s_umount_key#34){++++..}, at: 
[<ffffffff8118216d>] deactivate_super+0x3d/0x60
[16682.938046]  [16682.938046] stack backtrace:
[16682.990254] Pid: 22597, comm: umount Not tainted 3.1.0-rc4+ #61
[16683.061077] Call Trace:
[16683.090302]  [<ffffffff810c8e0e>] print_circular_bug+0x20e/0x2f0
[16683.162167]  [<ffffffff810cbb23>] __lock_acquire+0x13a3/0x1610
[16683.231951]  [<ffffffff810c631d>] ? trace_hardirqs_off+0xd/0x10
[16683.302780]  [<ffffffffa0061041>] ? btrfs_commit_super+0x21/0xd0 [btrfs]
[16683.382958]  [<ffffffff810cc3d7>] lock_acquire+0x97/0x110
[16683.447549]  [<ffffffffa0061041>] ? btrfs_commit_super+0x21/0xd0 [btrfs]
[16683.527729]  [<ffffffff810b9775>] ? sched_clock_cpu+0xc5/0x100
[16683.597509]  [<ffffffff8188ded8>] __mutex_lock_common+0x48/0x3a0
[16683.669379]  [<ffffffffa0061041>] ? btrfs_commit_super+0x21/0xd0 [btrfs]
[16683.749563]  [<ffffffffa004efdc>] ? next_block_group+0x6c/0x80 [btrfs]
[16683.827772]  [<ffffffffa0061041>] ? btrfs_commit_super+0x21/0xd0 [btrfs]
[16683.907951]  [<ffffffff8188fef6>] ? _raw_spin_unlock+0x26/0x30
[16683.977733]  [<ffffffff8188e2a6>] mutex_lock_nested+0x16/0x20
[16684.046485]  [<ffffffffa0061041>] btrfs_commit_super+0x21/0xd0 [btrfs]
[16684.124616]  [<ffffffffa0062000>] close_ctree+0x310/0x380 [btrfs]
[16684.197608]  [<ffffffff811986f7>] ? dispose_list+0x47/0x60
[16684.263218]  [<ffffffffa00425e8>] btrfs_put_super+0x18/0x30 [btrfs]
[16684.338199]  [<ffffffff8118094d>] generic_shutdown_super+0x5d/0xe0
[16684.412142]  [<ffffffff81180a61>] kill_anon_super+0x11/0x20
[16684.478806]  [<ffffffff8118216d>] ? deactivate_super+0x3d/0x60
[16684.548609]  [<ffffffff81181475>] deactivate_locked_super+0x45/0x70
[16684.623612]  [<ffffffff81182175>] deactivate_super+0x45/0x60
[16684.691383]  [<ffffffff8119c4e7>] mntput_no_expire+0xe7/0x130
[16684.760127]  [<ffffffff8119c9d3>] sys_umount+0x73/0x3a0
[16684.822630]  [<ffffffff818975fb>] system_call_fastpath+0x16/0x1b

-Arne
