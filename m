Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:34715 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbcCYAqw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 20:46:52 -0400
Received: by mail-pf0-f169.google.com with SMTP id x3so70584544pfb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Mar 2016 17:46:52 -0700 (PDT)
Date: Thu, 24 Mar 2016 17:46:48 -0700
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: linux-btrfs@vger.kernel.org
Subject: Lockdep warning at device replace finishing
Message-ID: <20160325004648.GA1179@jek-Latitude-E7440>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

Can anybody point me to possible cause of this lockdep warning and say
if it is dangerous in reality?
It appeared when I started replacing from the missing drive ('btrfs replace
start <devid> <newdev> <mountpoint>). My locking-fu seems to be too weak
to resolve this by myself.

I use 4.4.5 kernel with Anand's global hotspare patches applied plus
patch 'Btrfs: fix lockdep deadlock warning due to dev_replace' was
applied also. This is reproduced rarely, so I cannot check this for sure
with latest kernels.


[ 1231.862717] BTRFS info (device sdf): dev_replace from /dev/sdf (devid 4) to /dev/sdh finished
[ 1231.881938] 
[ 1231.888624] ======================================================
[ 1231.943857] [ INFO: possible circular locking dependency detected ]
[ 1231.953686] 4.4.5-scst31x+ #16 Not tainted
[ 1231.954755] -------------------------------------------------------
[ 1232.031044] btrfs/4453 is trying to acquire lock:
[ 1232.031966]  (sb_writers){.+.+.+}, at: [<ffffffff8121dd47>] __sb_start_write+0xb7/0xf0
[ 1232.033945] 
[ 1232.033945] but task is already holding lock:
[ 1232.035238]  (&fs_info->chunk_mutex){+.+.+.}, at: [<ffffffffa01fcdc1>] btrfs_dev_replace_finishing+0x121/0x9b0 [btrfs]
[ 1232.037577] 
[ 1232.037577] which lock already depends on the new lock.
[ 1232.037577] 
[ 1232.039352] 
[ 1232.039352] the existing dependency chain (in reverse order) is:
[ 1232.040817] 
-> #4 (&fs_info->chunk_mutex){+.+.+.}:
[ 1232.042429]        [<ffffffff810da3ae>] lock_acquire+0xce/0x1e0
[ 1232.090783]        [<ffffffff8162fe79>] mutex_lock_nested+0x69/0x3c0
[ 1232.093226]        [<ffffffffa01fcdc1>] btrfs_dev_replace_finishing+0x121/0x9b0 [btrfs]
[ 1232.094913]        [<ffffffffa01fd9e0>] btrfs_dev_replace_start+0x390/0x560 [btrfs]
[ 1232.096798]        [<ffffffffa01c40ac>] btrfs_ioctl+0x1e4c/0x2c00 [btrfs]
[ 1232.098396]        [<ffffffff8122f732>] do_vfs_ioctl+0x2e2/0x530
[ 1232.099596]        [<ffffffff8122f9f9>] SyS_ioctl+0x79/0x90
[ 1232.100725]        [<ffffffff81633eb6>] entry_SYSCALL_64_fastpath+0x16/0x7a
[ 1232.102031] 
-> #3 (&fs_devs->device_list_mutex){+.+.+.}:
[ 1232.103721]        [<ffffffff810da3ae>] lock_acquire+0xce/0x1e0
[ 1232.104888]        [<ffffffff8162fe79>] mutex_lock_nested+0x69/0x3c0
[ 1232.106106]        [<ffffffffa0151bf6>] btrfs_show_devname+0x36/0x210 [btrfs]
[ 1232.107444]        [<ffffffff812638c9>] show_vfsmnt+0x49/0x150
[ 1232.108603]        [<ffffffff8123d357>] m_show+0x17/0x20
[ 1232.109696]        [<ffffffff812430b8>] seq_read+0x2d8/0x3b0
[ 1232.111160]        [<ffffffff8121a778>] __vfs_read+0x28/0xd0
[ 1232.113660]        [<ffffffff8121b056>] vfs_read+0x86/0x130
[ 1232.115847]        [<ffffffff8121bd19>] SyS_read+0x49/0xa0
[ 1232.116963]        [<ffffffff81633eb6>] entry_SYSCALL_64_fastpath+0x16/0x7a
[ 1232.118268] 
-> #2 (namespace_sem){+++++.}:
[ 1232.119795]        [<ffffffff810da3ae>] lock_acquire+0xce/0x1e0
[ 1232.125023]        [<ffffffff816316c9>] down_write+0x49/0x80
[ 1232.150746]        [<ffffffff8123fde3>] lock_mount+0x43/0x1c0
[ 1232.151914]        [<ffffffff81240463>] do_add_mount+0x23/0xd0
[ 1232.157188]        [<ffffffff8124134b>] do_mount+0x27b/0xe30
[ 1232.158416]        [<ffffffff8124222c>] SyS_mount+0x8c/0xd0
[ 1232.159622]        [<ffffffff81633eb6>] entry_SYSCALL_64_fastpath+0x16/0x7a
[ 1232.189142] 
-> #1 (&sb->s_type->i_mutex_key#5){+.+.+.}:
[ 1232.192923]        [<ffffffff810da3ae>] lock_acquire+0xce/0x1e0
[ 1232.211173]        [<ffffffff8162fe79>] mutex_lock_nested+0x69/0x3c0
[ 1232.223543]        [<ffffffff81229e58>] path_openat+0x468/0x1360
[ 1232.237187]        [<ffffffff8122c0be>] do_filp_open+0x7e/0xe0
[ 1232.239007]        [<ffffffff8121a2cb>] do_sys_open+0x12b/0x210
[ 1232.241578]        [<ffffffff8121a3ce>] SyS_open+0x1e/0x20
[ 1232.242711]        [<ffffffff81633eb6>] entry_SYSCALL_64_fastpath+0x16/0x7a
[ 1232.244018] 
-> #0 (sb_writers){.+.+.+}:
[ 1232.245504]        [<ffffffff810d96ba>] __lock_acquire+0x17ba/0x1ae0
[ 1232.246742]        [<ffffffff810da3ae>] lock_acquire+0xce/0x1e0
[ 1232.247934]        [<ffffffff810d3adf>] percpu_down_read+0x4f/0xa0
[ 1232.260955]        [<ffffffff8121dd47>] __sb_start_write+0xb7/0xf0
[ 1232.262264]        [<ffffffff8123f704>] mnt_want_write+0x24/0x50
[ 1232.263460]        [<ffffffff8122a722>] path_openat+0xd32/0x1360
[ 1232.264644]        [<ffffffff8122c0be>] do_filp_open+0x7e/0xe0
[ 1232.267248]        [<ffffffff8121a0f4>] file_open_name+0xe4/0x130
[ 1232.268454]        [<ffffffff8121a173>] filp_open+0x33/0x60
[ 1232.269584]        [<ffffffffa01adc46>] update_dev_time+0x16/0x40 [btrfs]
[ 1232.314209]        [<ffffffffa01b8abe>] btrfs_scratch_superblocks+0x4e/0x90 [btrfs]
[ 1232.315874]        [<ffffffffa01b8ba2>] btrfs_rm_dev_replace_remove_srcdev+0xa2/0xc0 [btrfs]
[ 1232.317610]        [<ffffffffa01fd130>] btrfs_dev_replace_finishing+0x490/0x9b0 [btrfs]
[ 1232.319291]        [<ffffffffa01fd9e0>] btrfs_dev_replace_start+0x390/0x560 [btrfs]
[ 1232.325306]        [<ffffffffa01c40ac>] btrfs_ioctl+0x1e4c/0x2c00 [btrfs]
[ 1232.326612]        [<ffffffff8122f732>] do_vfs_ioctl+0x2e2/0x530
[ 1232.327808]        [<ffffffff8122f9f9>] SyS_ioctl+0x79/0x90
[ 1232.328935]        [<ffffffff81633eb6>] entry_SYSCALL_64_fastpath+0x16/0x7a
[ 1232.330243] 
[ 1232.330243] other info that might help us debug this:
[ 1232.330243] 
[ 1232.414976] Chain exists of:
  sb_writers --> &fs_devs->device_list_mutex --> &fs_info->chunk_mutex

[ 1232.417570]  Possible unsafe locking scenario:
[ 1232.417570] 
[ 1232.423489]        CPU0                    CPU1
[ 1232.424379]        ----                    ----
[ 1232.425273]   lock(&fs_info->chunk_mutex);
[ 1232.426341]                                lock(&fs_devs->device_list_mutex);
[ 1232.427786]                                lock(&fs_info->chunk_mutex);
[ 1232.429158]   lock(sb_writers);
[ 1232.430097] 
[ 1232.430097]  *** DEADLOCK ***
[ 1232.430097] 
[ 1232.466399] 4 locks held by btrfs/4453:
[ 1232.467217]  #0:  (&fs_info->dev_replace.lock_finishing_cancel_unmount){+.+.+.}, at: [<ffffffffa01fcce1>] btrfs_dev_replace_finishing+0x41/0x9b0 [btrfs]
[ 1232.470045]  #1:  (uuid_mutex){+.+.+.}, at: [<ffffffffa01fcd93>] btrfs_dev_replace_finishing+0xf3/0x9b0 [btrfs]
[ 1232.521358]  #2:  (&fs_devs->device_list_mutex){+.+.+.}, at: [<ffffffffa01fcdac>] btrfs_dev_replace_finishing+0x10c/0x9b0 [btrfs]
[ 1232.523967]  #3:  (&fs_info->chunk_mutex){+.+.+.}, at: [<ffffffffa01fcdc1>] btrfs_dev_replace_finishing+0x121/0x9b0 [btrfs]
[ 1232.526488] 
[ 1232.526488] stack backtrace:
[ 1232.527578] CPU: 1 PID: 4453 Comm: btrfs Not tainted 4.4.5-scst31x+ #16
[ 1232.528722] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[ 1232.530296]  0000000000000000 ffff880062583800 ffffffff8134f233 ffffffff82614ca0
[ 1232.583206]  ffffffff826403e0 ffff880062583840 ffffffff810d656c ffff8800625838b0
[ 1232.585123]  ffff88006335acc0 ffff88006335ace8 0000000000000003 0000000000000004
[ 1232.672030] Call Trace:
[ 1232.672679]  [<ffffffff8134f233>] dump_stack+0x85/0xc2
[ 1232.673658]  [<ffffffff810d656c>] print_circular_bug+0x1ec/0x260
[ 1232.674880]  [<ffffffff810d96ba>] __lock_acquire+0x17ba/0x1ae0
[ 1232.676073]  [<ffffffff810f5e7d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[ 1232.677371]  [<ffffffff810dbf71>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
[ 1232.679149]  [<ffffffff810da3ae>] lock_acquire+0xce/0x1e0
[ 1232.680301]  [<ffffffff8121dd47>] ? __sb_start_write+0xb7/0xf0
[ 1232.681503]  [<ffffffff810d3adf>] percpu_down_read+0x4f/0xa0
[ 1232.682680]  [<ffffffff8121dd47>] ? __sb_start_write+0xb7/0xf0
[ 1232.683885]  [<ffffffff8121dd47>] __sb_start_write+0xb7/0xf0
[ 1232.685056]  [<ffffffff8123f704>] mnt_want_write+0x24/0x50
[ 1232.686202]  [<ffffffff8122a722>] path_openat+0xd32/0x1360
[ 1232.687342]  [<ffffffff8136ed54>] ? debug_check_no_obj_freed+0x214/0x230
[ 1232.688643]  [<ffffffff8122c0be>] do_filp_open+0x7e/0xe0
[ 1232.689744]  [<ffffffff810f5f6d>] ? rcu_read_lock_sched_held+0x6d/0x80
[ 1232.691622]  [<ffffffff811ff07a>] ? kmem_cache_alloc+0x18a/0x2c0
[ 1232.766936]  [<ffffffff8121a0f4>] file_open_name+0xe4/0x130
[ 1232.767963]  [<ffffffff8121a173>] filp_open+0x33/0x60
[ 1232.775605]  [<ffffffffa01adc46>] update_dev_time+0x16/0x40 [btrfs]
[ 1232.779776]  [<ffffffffa01b8abe>] btrfs_scratch_superblocks+0x4e/0x90 [btrfs]
[ 1232.801170]  [<ffffffffa01b8ba2>] btrfs_rm_dev_replace_remove_srcdev+0xa2/0xc0 [btrfs]
[ 1232.830890]  [<ffffffffa01fd130>] btrfs_dev_replace_finishing+0x490/0x9b0 [btrfs]
[ 1232.832386]  [<ffffffffa01fce9c>] ? btrfs_dev_replace_finishing+0x1fc/0x9b0 [btrfs]
[ 1232.833894]  [<ffffffffa01fd9e0>] btrfs_dev_replace_start+0x390/0x560 [btrfs]
[ 1232.835129]  [<ffffffffa01c40ac>] btrfs_ioctl+0x1e4c/0x2c00 [btrfs]
[ 1232.836244]  [<ffffffff810dbf71>] ? __raw_callee_save___pv_queued_spin_unlock+0x11/0x20
[ 1232.840742]  [<ffffffff811d3fb6>] ? handle_mm_fault+0xd76/0x1ac0
[ 1232.841817]  [<ffffffff810dd720>] ? do_raw_spin_unlock+0x50/0xc0
[ 1232.842917]  [<ffffffff81633567>] ? _raw_spin_unlock+0x27/0x40
[ 1232.843968]  [<ffffffff811d3fb6>] ? handle_mm_fault+0xd76/0x1ac0
[ 1232.845040]  [<ffffffff810f5e7d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[ 1232.846196]  [<ffffffff8122f732>] do_vfs_ioctl+0x2e2/0x530
[ 1232.847207]  [<ffffffff810d384f>] ? up_read+0x1f/0x40
[ 1232.848156]  [<ffffffff810f5e7d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[ 1232.870945]  [<ffffffff8123b756>] ? __fget_light+0x66/0x90
[ 1232.877419]  [<ffffffff8122f9f9>] SyS_ioctl+0x79/0x90
[ 1232.878386]  [<ffffffff81633eb6>] entry_SYSCALL_64_fastpath+0x16/0x7a


