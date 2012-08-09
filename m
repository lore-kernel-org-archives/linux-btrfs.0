Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:27252 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031087Ab2HIPgz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2012 11:36:55 -0400
Received: from [172.24.1.80] (yian-ho01.nir.cronon.net [192.166.201.94])
	by smtp.strato.de (joses mo27) (RZmta 30.7 AUTH)
	with ESMTPA id k075e5o79FUB5N for <linux-btrfs@vger.kernel.org>;
	Thu, 9 Aug 2012 17:36:53 +0200 (CEST)
Message-ID: <5023D916.6030707@giantdisaster.de>
Date: Thu, 09 Aug 2012 17:36:54 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: [BUG] btrfs dev del causes 'possible circular locking dependency
 detected'
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With chris' for-linus of today.

The script:
echo /dev/sdo, /dev/sdp and /dev/sdq are 1TB disks
mkfs.btrfs -d raid1 -m raid1 -b1600M /dev/sdo /dev/sdp
mount /dev/sdo /mnt2
echo 'copy kernel source and built kernel objects (much larger than 1600MB):'
(cd ~/git/btrfs; tar cf - .) | (cd /mnt2; tar xf -) 2>/dev/null
echo fails with ENOSPC after some seconds
umount /mnt2
mount /dev/sdo /mnt2
btrfs dev add /dev/sdq /mnt2
btrfs dev del /dev/sdp /mnt2
echo causes the 'INFO: possible circular locking dependency detected'
echo fails with 'ERROR: error removing the device '/dev/sdp' - No space left on device'


The kernel log:
Aug  9 16:02:12 qvarne kernel: [  542.335716] btrfs: relocating block group 1677721600 flags 20
Aug  9 16:02:12 qvarne kernel: [  542.548469] btrfs: relocating block group 1639972864 flags 17
Aug  9 16:02:21 qvarne kernel: [  542.619398]
Aug  9 16:02:21 qvarne kernel: [  542.637165] ======================================================
Aug  9 16:02:21 qvarne kernel: [  542.711109] [ INFO: possible circular locking dependency detected ]
Aug  9 16:02:21 qvarne kernel: [  542.786094] 3.5.0+ #84 Not tainted
Aug  9 16:02:21 qvarne kernel: [  542.826757] -------------------------------------------------------
Aug  9 16:02:21 qvarne kernel: [  542.901739] btrfs/3790 is trying to acquire lock:
Aug  9 16:02:21 qvarne kernel: [  542.958005]  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffffa0120a37>] prealloc_file_extent_cluster+0x57/0x150 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  543.092788]
Aug  9 16:02:21 qvarne kernel: [  543.092788] but task is already holding lock:
Aug  9 16:02:21 qvarne kernel: [  543.162571]  (&fs_info->cleaner_mutex){+.+...}, at: [<ffffffffa0126de7>] btrfs_relocate_block_group+0x187/0x2c0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  543.292053]
Aug  9 16:02:21 qvarne kernel: [  543.292053] which lock already depends on the new lock.
Aug  9 16:02:21 qvarne kernel: [  543.292053]
Aug  9 16:02:21 qvarne kernel: [  543.389916]
Aug  9 16:02:21 qvarne kernel: [  543.389916] the existing dependency chain (in reverse order) is:
Aug  9 16:02:21 qvarne kernel: [  543.479460]
Aug  9 16:02:21 qvarne kernel: [  543.479460] -> #2 (&fs_info->cleaner_mutex){+.+...}:
Aug  9 16:02:21 qvarne kernel: [  543.541341]        [<ffffffff810da005>] lock_acquire+0x95/0x150
Aug  9 16:02:21 qvarne kernel: [  543.612269]        [<ffffffff819259a1>] mutex_lock_nested+0x71/0x360
Aug  9 16:02:21 qvarne kernel: [  543.688396]        [<ffffffffa00da06f>] btrfs_commit_super+0x1f/0x100 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  543.773884]        [<ffffffffa00db8a8>] close_ctree+0x318/0x360 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  543.853132]        [<ffffffffa00b3da4>] btrfs_put_super+0x14/0x20 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  543.934459]        [<ffffffff8118ce6d>] generic_shutdown_super+0x5d/0xf0
Aug  9 16:02:21 qvarne kernel: [  544.014747]        [<ffffffff8118cf91>] kill_anon_super+0x11/0x20
Aug  9 16:02:21 qvarne kernel: [  544.087756]        [<ffffffffa00b7405>] btrfs_kill_super+0x15/0x90 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  544.170124]        [<ffffffff8118d1bd>] deactivate_locked_super+0x3d/0x70
Aug  9 16:02:21 qvarne kernel: [  544.251452]        [<ffffffff8118dcf9>] deactivate_super+0x49/0x70
Aug  9 16:02:21 qvarne kernel: [  544.325500]        [<ffffffff811a8eae>] mntput_no_expire+0xfe/0x160
Aug  9 16:02:21 qvarne kernel: [  544.400588]        [<ffffffff811a9c69>] sys_umount+0x69/0x3a0
Aug  9 16:02:21 qvarne kernel: [  544.469435]        [<ffffffff81931162>] system_call_fastpath+0x16/0x1b
Aug  9 16:02:21 qvarne kernel: [  544.547644]
Aug  9 16:02:21 qvarne kernel: [  544.547644] -> #1 (&type->s_umount_key#31){+++++.}:
Aug  9 16:02:21 qvarne kernel: [  544.608588]        [<ffffffff810da005>] lock_acquire+0x95/0x150
Aug  9 16:02:21 qvarne kernel: [  544.679516]        [<ffffffff81926ca7>] down_read+0x47/0x8e
Aug  9 16:02:21 qvarne kernel: [  544.746283]        [<ffffffff811b3ae8>] writeback_inodes_sb_nr_if_idle+0x38/0x60
Aug  9 16:02:21 qvarne kernel: [  544.834891]        [<ffffffffa00cbfed>] reserve_metadata_bytes+0x4fd/0x800 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  544.925581]        [<ffffffffa00cc3c2>] btrfs_block_rsv_add+0x32/0x60 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  545.011068]        [<ffffffffa00e0e04>] start_transaction+0x2e4/0x3b0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  545.096555]        [<ffffffffa00e119e>] btrfs_start_transaction+0xe/0x10 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  545.185165]        [<ffffffffa00ecb21>] btrfs_create+0x41/0x210 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  545.264412]        [<ffffffff8119776c>] vfs_create+0xac/0x110
Aug  9 16:02:21 qvarne kernel: [  545.333259]        [<ffffffff81198409>] do_last+0x769/0x9b0
Aug  9 16:02:21 qvarne kernel: [  545.400027]        [<ffffffff8119a3f4>] path_openat+0xd4/0x450
Aug  9 16:02:21 qvarne kernel: [  545.469915]        [<ffffffff8119a87d>] do_filp_open+0x3d/0xa0
Aug  9 16:02:21 qvarne kernel: [  545.539803]        [<ffffffff8118a573>] do_sys_open+0xf3/0x1d0
Aug  9 16:02:21 qvarne kernel: [  545.609692]        [<ffffffff8118a66c>] sys_open+0x1c/0x20
Aug  9 16:02:21 qvarne kernel: [  545.675421]        [<ffffffff81931162>] system_call_fastpath+0x16/0x1b
Aug  9 16:02:21 qvarne kernel: [  545.753629]
Aug  9 16:02:21 qvarne kernel: [  545.753629] -> #0 (&sb->s_type->i_mutex_key#11){+.+.+.}:
Aug  9 16:02:21 qvarne kernel: [  545.819772]        [<ffffffff810d99c4>] __lock_acquire+0x1b74/0x1ba0
Aug  9 16:02:21 qvarne kernel: [  545.895899]        [<ffffffff810da005>] lock_acquire+0x95/0x150
Aug  9 16:02:21 qvarne kernel: [  545.966828]        [<ffffffff819259a1>] mutex_lock_nested+0x71/0x360
Aug  9 16:02:21 qvarne kernel: [  546.042956]        [<ffffffffa0120a37>] prealloc_file_extent_cluster+0x57/0x150 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  546.138843]        [<ffffffffa01211a6>] relocate_file_extent_cluster+0xa6/0x370 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  546.234732]        [<ffffffffa0121523>] relocate_data_extent+0xb3/0xd0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  546.321261]        [<ffffffffa0126975>] relocate_block_group+0x335/0x620 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  546.409869]        [<ffffffffa0126df8>] btrfs_relocate_block_group+0x198/0x2c0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  546.504717]        [<ffffffffa0101052>] btrfs_relocate_chunk+0x82/0x770 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  546.592283]        [<ffffffffa01023a6>] btrfs_shrink_device+0x256/0x490 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  546.679851]        [<ffffffffa0106785>] btrfs_rm_device+0x1f5/0x6a0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  546.763260]        [<ffffffffa010e82a>] btrfs_ioctl+0x74a/0x12c0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  546.843549]        [<ffffffff8119cb6e>] do_vfs_ioctl+0x8e/0x540
Aug  9 16:02:21 qvarne kernel: [  546.914476]        [<ffffffff8119d0a9>] sys_ioctl+0x89/0x90
Aug  9 16:02:21 qvarne kernel: [  546.981245]        [<ffffffff81931162>] system_call_fastpath+0x16/0x1b
Aug  9 16:02:21 qvarne kernel: [  547.059452]
Aug  9 16:02:21 qvarne kernel: [  547.059452] other info that might help us debug this:
Aug  9 16:02:21 qvarne kernel: [  547.059452]
Aug  9 16:02:21 qvarne kernel: [  547.155235] Chain exists of:
Aug  9 16:02:21 qvarne kernel: [  547.155235]   &sb->s_type->i_mutex_key#11 --> &type->s_umount_key#31 --> &fs_info->cleaner_mutex
Aug  9 16:02:21 qvarne kernel: [  547.155235]
Aug  9 16:02:21 qvarne kernel: [  547.282012]  Possible unsafe locking scenario:
Aug  9 16:02:21 qvarne kernel: [  547.282012]
Aug  9 16:02:21 qvarne kernel: [  547.352837]        CPU0                    CPU1
Aug  9 16:02:21 qvarne kernel: [  547.407019]        ----                    ----
Aug  9 16:02:21 qvarne kernel: [  547.461203]   lock(&fs_info->cleaner_mutex);
Aug  9 16:02:21 qvarne kernel: [  547.512477]                                lock(&type->s_umount_key#31);
Aug  9 16:02:21 qvarne kernel: [  547.592971]                                lock(&fs_info->cleaner_mutex);
Aug  9 16:02:21 qvarne kernel: [  547.674405]   lock(&sb->s_type->i_mutex_key#11);
Aug  9 16:02:21 qvarne kernel: [  547.729939]
Aug  9 16:02:21 qvarne kernel: [  547.729939]  *** DEADLOCK ***
Aug  9 16:02:21 qvarne kernel: [  547.729939]
Aug  9 16:02:21 qvarne kernel: [  547.800765] 3 locks held by btrfs/3790:
Aug  9 16:02:21 qvarne kernel: [  547.846629]  #0:  (&fs_info->volume_mutex){+.+.+.}, at: [<ffffffffa010e7e3>] btrfs_ioctl+0x703/0x12c0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  547.965812]  #1:  (uuid_mutex){+.+...}, at: [<ffffffffa01065b5>] btrfs_rm_device+0x25/0x6a0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  548.074596]  #2:  (&fs_info->cleaner_mutex){+.+...}, at: [<ffffffffa0126de7>] btrfs_relocate_block_group+0x187/0x2c0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  548.209381]
Aug  9 16:02:21 qvarne kernel: [  548.209381] stack backtrace:
Aug  9 16:02:21 qvarne kernel: [  548.261484] Pid: 3790, comm: btrfs Not tainted 3.5.0+ #84
Aug  9 16:02:21 qvarne kernel: [  548.326069] Call Trace:
Aug  9 16:02:21 qvarne kernel: [  548.355296]  [<ffffffff8191ccc8>] print_circular_bug+0x1fb/0x20c
Aug  9 16:02:21 qvarne kernel: [  548.427159]  [<ffffffff810d99c4>] __lock_acquire+0x1b74/0x1ba0
Aug  9 16:02:21 qvarne kernel: [  548.496943]  [<ffffffff81183209>] ? deactivate_slab+0x439/0x4e0
Aug  9 16:02:21 qvarne kernel: [  548.567766]  [<ffffffff81929446>] ? _raw_spin_unlock+0x26/0x40
Aug  9 16:02:21 qvarne kernel: [  548.637558]  [<ffffffffa0120a37>] ? prealloc_file_extent_cluster+0x57/0x150 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  548.729174]  [<ffffffff810da005>] lock_acquire+0x95/0x150
Aug  9 16:02:21 qvarne kernel: [  548.793766]  [<ffffffffa0120a37>] ? prealloc_file_extent_cluster+0x57/0x150 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  548.885382]  [<ffffffff810daabd>] ? trace_hardirqs_on_caller+0xfd/0x190
Aug  9 16:02:21 qvarne kernel: [  548.964525]  [<ffffffff819259a1>] mutex_lock_nested+0x71/0x360
Aug  9 16:02:21 qvarne kernel: [  549.034318]  [<ffffffffa0120a37>] ? prealloc_file_extent_cluster+0x57/0x150 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  549.125941]  [<ffffffffa0120a37>] ? prealloc_file_extent_cluster+0x57/0x150 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  549.217558]  [<ffffffff810daabd>] ? trace_hardirqs_on_caller+0xfd/0x190
Aug  9 16:02:21 qvarne kernel: [  549.296709]  [<ffffffffa0120a37>] prealloc_file_extent_cluster+0x57/0x150 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  549.386245]  [<ffffffff81184250>] ? kmem_cache_alloc_trace+0xd0/0x160
Aug  9 16:02:21 qvarne kernel: [  549.463308]  [<ffffffff81184559>] ? kmem_cache_free+0x69/0x160
Aug  9 16:02:21 qvarne kernel: [  549.533102]  [<ffffffffa01211a6>] relocate_file_extent_cluster+0xa6/0x370 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  549.622644]  [<ffffffffa00e093a>] ? __btrfs_end_transaction+0x1ba/0x300 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  549.710102]  [<ffffffff81184640>] ? kmem_cache_free+0x150/0x160
Aug  9 16:02:21 qvarne kernel: [  549.780934]  [<ffffffffa0121523>] relocate_data_extent+0xb3/0xd0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  549.861118]  [<ffffffffa0126975>] relocate_block_group+0x335/0x620 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  549.943381]  [<ffffffffa00de3a0>] ? btrfs_clean_old_snapshots+0x90/0x160 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  550.031886]  [<ffffffffa0126df8>] btrfs_relocate_block_group+0x198/0x2c0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  550.120390]  [<ffffffffa0101052>] btrfs_relocate_chunk+0x82/0x770 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  550.201615]  [<ffffffffa00f7b21>] ? release_extent_buffer+0xb1/0xe0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  550.284910]  [<ffffffff81929446>] ? _raw_spin_unlock+0x26/0x40
Aug  9 16:02:21 qvarne kernel: [  550.354702]  [<ffffffffa00f7b21>] ? release_extent_buffer+0xb1/0xe0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  550.438007]  [<ffffffffa00f7c8a>] ? free_extent_buffer+0x1a/0x90 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  550.518189]  [<ffffffffa00f7ca7>] ? free_extent_buffer+0x37/0x90 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  550.598374]  [<ffffffffa01023a6>] btrfs_shrink_device+0x256/0x490 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  550.679598]  [<ffffffffa00fe874>] ? btrfs_find_device+0x54/0x80 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  550.758742]  [<ffffffffa0106785>] btrfs_rm_device+0x1f5/0x6a0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  550.835798]  [<ffffffff8116199e>] ? might_fault+0x4e/0xa0
Aug  9 16:02:21 qvarne kernel: [  550.900391]  [<ffffffffa010e82a>] btrfs_ioctl+0x74a/0x12c0 [btrfs]
Aug  9 16:02:21 qvarne kernel: [  550.974325]  [<ffffffff810a784e>] ? up_read+0x1e/0x40
Aug  9 16:02:21 qvarne kernel: [  551.034749]  [<ffffffff8192ce14>] ? do_page_fault+0x1c4/0x510
Aug  9 16:02:21 qvarne kernel: [  551.103494]  [<ffffffff810b601b>] ? local_clock+0x4b/0x60
Aug  9 16:02:21 qvarne kernel: [  551.168077]  [<ffffffff8119cb6e>] do_vfs_ioctl+0x8e/0x540
Aug  9 16:02:21 qvarne kernel: [  551.232661]  [<ffffffff8116a2cf>] ? sys_brk+0xef/0x130
Aug  9 16:02:21 qvarne kernel: [  551.294125]  [<ffffffff81929846>] ? retint_swapgs+0xe/0x13
Aug  9 16:02:21 qvarne kernel: [  551.359748]  [<ffffffff8119d0a9>] sys_ioctl+0x89/0x90
Aug  9 16:02:21 qvarne kernel: [  551.420174]  [<ffffffff81931162>] system_call_fastpath+0x16/0x1b
Aug  9 16:02:22 qvarne kernel: [  552.129529] btrfs: found 280 extents
Aug  9 16:02:23 qvarne kernel: [  553.454727] btrfs: found 280 extents
Aug  9 16:02:24 qvarne kernel: [  553.696200] btrfs: relocating block group 364904448 flags 20
Aug  9 16:02:36 qvarne kernel: [  566.015078] btrfs: found 9030 extents
Aug  9 16:02:36 qvarne kernel: [  566.258504] btrfs: relocating block group 197132288 flags 17
Aug  9 16:02:39 qvarne kernel: [  568.937819] btrfs: found 835 extents
Aug  9 16:02:41 qvarne kernel: [  570.801513] btrfs: found 834 extents
Aug  9 16:02:41 qvarne kernel: [  571.074987] btrfs: relocating block group 29360128 flags 20
Aug  9 16:02:46 qvarne kernel: [  576.368622] btrfs: found 9363 extents
Aug  9 16:02:47 qvarne kernel: [  576.602578] btrfs: relocating block group 20971520 flags 18
Aug  9 16:02:47 qvarne kernel: [  576.875397] btrfs: found 1 extents

