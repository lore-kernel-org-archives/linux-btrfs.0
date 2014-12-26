Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36581 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaLZP7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Dec 2014 10:59:11 -0500
Received: from merkaba.localnet (ppp-88-217-104-169.dynamic.mnet-online.de [88.217.104.169])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 0BE909A
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Dec 2014 16:58:26 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Fri, 26 Dec 2014 16:59:09 +0100
Message-ID: <6794875.ElpGA7E3Vr@merkaba>
In-Reply-To: <3738341.y7uRQFcLJH@merkaba>
References: <3738341.y7uRQFcLJH@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 26. Dezember 2014, 14:37:36 schrieben Sie:
> I have this on 3.18 kernel on Debian Sid with BTRFS Dual SSD RAID with
> space_cache, skinny meta data extents – are these a problem? – and
> compress=lzo:
> 
> merkaba:~> btrfs fi sh /home
> Label: 'home'  uuid: b96c4f72-0523-45ac-a401-f7be73dd624a
>         Total devices 2 FS bytes used 144.41GiB
>         devid    1 size 160.00GiB used 160.00GiB path /dev/mapper/msata-home
> devid    2 size 160.00GiB used 160.00GiB path /dev/mapper/sata-home
> 
> Btrfs v3.17
> merkaba:~> btrfs fi df /home
> Data, RAID1: total=154.97GiB, used=141.12GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=5.00GiB, used=3.29GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> 
> And I had hangs with BTRFS again. This time as I wanted to install tax
> return software in Virtualbox´d Windows XP VM (which I use once a year
> cause I know no tax return software for Linux which would be suitable for
> Germany and I frankly don´t care about the end of security cause all
> surfing and other network access I will do from the Linux box and I only
> run the VM behind a firewall).

These are 100% reproducable for me:

1) Have the compress=lzo, space_cache BTRFS RAID Dual SSD RAID 1 fill both
with trees.

2) Have a Windows XP VM in Virtualbox on that BTRFS RAID 1

3) Press "Defragment" (in the hope to be able to use sdelete -c and then
VBoxManage modifyhd Winlala.vdi --compact to reduce image size)


Gives:

One kworker thread using up 100% of a core for minutes with bursts of
btrfs-transaction-process in between and:

Dec 26 16:17:57 merkaba kernel: [ 8102.029438] mce: [Hardware Error]: Machine check events logged
Dec 26 16:18:15 merkaba kernel: [ 8119.879230] CPU2: Core temperature above threshold, cpu clock throttled (total events = 54053)
Dec 26 16:18:15 merkaba kernel: [ 8119.879232] CPU0: Package temperature above threshold, cpu clock throttled (total events = 89435)
Dec 26 16:18:15 merkaba kernel: [ 8119.879234] CPU3: Core temperature above threshold, cpu clock throttled (total events = 54053)
Dec 26 16:18:15 merkaba kernel: [ 8119.879235] CPU1: Package temperature above threshold, cpu clock throttled (total events = 89435)
Dec 26 16:18:15 merkaba kernel: [ 8119.879237] CPU3: Package temperature above threshold, cpu clock throttled (total events = 89435)
Dec 26 16:18:15 merkaba kernel: [ 8119.879245] CPU2: Package temperature above threshold, cpu clock throttled (total events = 89435)
Dec 26 16:18:15 merkaba kernel: [ 8119.880218] CPU2: Core temperature/speed normal
Dec 26 16:18:15 merkaba kernel: [ 8119.880219] CPU1: Package temperature/speed normal
Dec 26 16:18:15 merkaba kernel: [ 8119.880220] CPU3: Core temperature/speed normal
Dec 26 16:18:15 merkaba kernel: [ 8119.880221] CPU0: Package temperature/speed normal
Dec 26 16:18:15 merkaba kernel: [ 8119.880223] CPU3: Package temperature/speed normal
Dec 26 16:18:15 merkaba kernel: [ 8119.880228] CPU2: Package temperature/speed normal
Dec 26 16:20:27 merkaba kernel: [ 8252.054015] mce: [Hardware Error]: Machine check events logged
Dec 26 16:20:57 merkaba kernel: [ 8281.461874] INFO: task kded4:1959 blocked for more than 120 seconds.
Dec 26 16:20:57 merkaba kernel: [ 8281.464106]       Tainted: G           O   3.18.0-tp520 #14
Dec 26 16:20:57 merkaba kernel: [ 8281.466361] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 26 16:20:57 merkaba kernel: [ 8281.468760] kded4           D ffff88040764ce98     0  1959      1 0x00000000
Dec 26 16:20:57 merkaba kernel: [ 8281.471112]  ffff8803efa57bb8 0000000000000002 ffff8803efa57c00 ffff880407f261c0
Dec 26 16:20:57 merkaba kernel: [ 8281.473462]  ffff8803efa57fd8 ffff88040764c950 0000000000012300 ffff88040764c950
Dec 26 16:20:57 merkaba kernel: [ 8281.475780]  ffff8803efa57ba8 ffff8803eea9a900 ffff8803eea9a904 ffff88040764c950
Dec 26 16:20:57 merkaba kernel: [ 8281.478142] Call Trace:
Dec 26 16:20:57 merkaba kernel: [ 8281.480414]  [<ffffffff814a6f9a>] schedule+0x64/0x66
Dec 26 16:20:57 merkaba kernel: [ 8281.482694]  [<ffffffff814a72d3>] schedule_preempt_disabled+0x13/0x1f
Dec 26 16:20:57 merkaba kernel: [ 8281.484979]  [<ffffffff814a8440>] __mutex_lock_slowpath+0xab/0x126
Dec 26 16:20:57 merkaba kernel: [ 8281.487271]  [<ffffffff81143735>] ? lookup_fast+0x173/0x238
Dec 26 16:20:57 merkaba kernel: [ 8281.489534]  [<ffffffff814a84ce>] mutex_lock+0x13/0x24
Dec 26 16:20:57 merkaba kernel: [ 8281.491811]  [<ffffffff81143c45>] walk_component+0x69/0x17e
Dec 26 16:20:57 merkaba kernel: [ 8281.494092]  [<ffffffff81143d88>] lookup_last+0x2e/0x30
Dec 26 16:20:57 merkaba kernel: [ 8281.496416]  [<ffffffff81145a32>] path_lookupat+0x83/0x2d9
Dec 26 16:20:57 merkaba kernel: [ 8281.498733]  [<ffffffff8121f38c>] ? debug_smp_processor_id+0x17/0x19
Dec 26 16:20:57 merkaba kernel: [ 8281.501074]  [<ffffffff8114683c>] ? getname_flags+0x31/0x134
Dec 26 16:20:57 merkaba kernel: [ 8281.503338]  [<ffffffff81145cad>] filename_lookup+0x25/0x7a
Dec 26 16:20:57 merkaba kernel: [ 8281.505604]  [<ffffffff8114767a>] user_path_at_empty+0x55/0x93
Dec 26 16:20:57 merkaba kernel: [ 8281.507941]  [<ffffffff8105ec3e>] ? preempt_count_add+0x7c/0x90
Dec 26 16:20:57 merkaba kernel: [ 8281.510210]  [<ffffffff81071751>] ? cpuacct_account_field+0x56/0x5f
Dec 26 16:20:57 merkaba kernel: [ 8281.512499]  [<ffffffff81071751>] ? cpuacct_account_field+0x56/0x5f
Dec 26 16:20:57 merkaba kernel: [ 8281.514705]  [<ffffffff811476c4>] user_path_at+0xc/0xe
Dec 26 16:20:57 merkaba kernel: [ 8281.517039]  [<ffffffff8113ec3b>] vfs_fstatat+0x49/0x84
Dec 26 16:20:57 merkaba kernel: [ 8281.519397]  [<ffffffff810be29a>] ? acct_account_cputime+0x17/0x19
Dec 26 16:20:57 merkaba kernel: [ 8281.521686]  [<ffffffff8113ec8c>] vfs_stat+0x16/0x18
Dec 26 16:20:57 merkaba kernel: [ 8281.524064]  [<ffffffff8113ecd1>] SYSC_newstat+0x15/0x2e
Dec 26 16:20:57 merkaba kernel: [ 8281.526367]  [<ffffffff8100cf3f>] ? user_exit+0x13/0x15
Dec 26 16:20:57 merkaba kernel: [ 8281.528792]  [<ffffffff8100e21d>] ? syscall_trace_enter_phase1+0x57/0x12a
Dec 26 16:20:57 merkaba kernel: [ 8281.531120]  [<ffffffff8100e537>] ? syscall_trace_leave+0xcc/0x10a
Dec 26 16:20:57 merkaba kernel: [ 8281.533577]  [<ffffffff814aa264>] ? int_check_syscall_exit_work+0x34/0x3d
Dec 26 16:20:57 merkaba kernel: [ 8281.535977]  [<ffffffff8113edb9>] SyS_newstat+0x9/0xb
Dec 26 16:20:57 merkaba kernel: [ 8281.538416]  [<ffffffff814aa012>] system_call_fastpath+0x12/0x17
Dec 26 16:20:57 merkaba kernel: [ 8281.540835] INFO: task kactivitymanage:1994 blocked for more than 120 seconds.
Dec 26 16:20:57 merkaba kernel: [ 8281.540838]       Tainted: G           O   3.18.0-tp520 #14
Dec 26 16:20:57 merkaba kernel: [ 8281.540838] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 26 16:20:57 merkaba kernel: [ 8281.540848] kactivitymanage D 0000000000000000     0  1994      1 0x00000000
Dec 26 16:20:57 merkaba kernel: [ 8281.540851]  ffff8803e42efe58 0000000000000002 00000001ff68d6d6 ffff8800c285c950
Dec 26 16:20:57 merkaba kernel: [ 8281.540854]  ffff8803e42effd8 ffff8803fda361c0 0000000000012300 ffff8803fda361c0
Dec 26 16:20:57 merkaba kernel: [ 8281.540857]  00000000000034e5 ffff8804059e0348 ffff8804059e034c ffff8803fda361c0
Dec 26 16:20:57 merkaba kernel: [ 8281.540858] Call Trace:
Dec 26 16:20:57 merkaba kernel: [ 8281.540862]  [<ffffffff814a6f9a>] schedule+0x64/0x66
Dec 26 16:20:57 merkaba kernel: [ 8281.540865]  [<ffffffff814a72d3>] schedule_preempt_disabled+0x13/0x1f
Dec 26 16:20:57 merkaba kernel: [ 8281.540867]  [<ffffffff814a8440>] __mutex_lock_slowpath+0xab/0x126
Dec 26 16:20:57 merkaba kernel: [ 8281.540871]  [<ffffffff81150f22>] ? __fget+0x67/0x72
Dec 26 16:20:57 merkaba kernel: [ 8281.540873]  [<ffffffff814a84ce>] mutex_lock+0x13/0x24
Dec 26 16:20:57 merkaba kernel: [ 8281.540876]  [<ffffffff811516e9>] __fdget_pos+0x36/0x3c
Dec 26 16:20:57 merkaba kernel: [ 8281.540878]  [<ffffffff8113a393>] fdget_pos+0x9/0x15
Dec 26 16:20:57 merkaba kernel: [ 8281.540881]  [<ffffffff8113b39d>] SyS_write+0x19/0x71
Dec 26 16:20:57 merkaba kernel: [ 8281.540884]  [<ffffffff814aa264>] ? int_check_syscall_exit_work+0x34/0x3d
Dec 26 16:20:57 merkaba kernel: [ 8281.540886]  [<ffffffff814aa012>] system_call_fastpath+0x12/0x17
Dec 26 16:20:57 merkaba kernel: [ 8281.540890] INFO: task plasma-desktop:2013 blocked for more than 120 seconds.
Dec 26 16:20:57 merkaba kernel: [ 8281.540891]       Tainted: G           O   3.18.0-tp520 #14
Dec 26 16:20:57 merkaba kernel: [ 8281.540892] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 26 16:20:57 merkaba kernel: [ 8281.540895] plasma-desktop  D ffff8803fda39db8     0  2013      1 0x00000000
Dec 26 16:20:57 merkaba kernel: [ 8281.540898]  ffff8803d947fbb8 0000000000000002 ffff8803d947fc00 ffffffff81a16500
Dec 26 16:20:57 merkaba kernel: [ 8281.540900]  ffff8803d947ffd8 ffff8803fda39870 0000000000012300 ffff8803fda39870
Dec 26 16:20:57 merkaba kernel: [ 8281.540902]  ffff8803d947fba8 ffff8803eea9a900 ffff8803eea9a904 ffff8803fda39870
Dec 26 16:20:57 merkaba kernel: [ 8281.540903] Call Trace:
Dec 26 16:20:57 merkaba kernel: [ 8281.540906]  [<ffffffff814a6f9a>] schedule+0x64/0x66
Dec 26 16:20:57 merkaba kernel: [ 8281.540908]  [<ffffffff814a72d3>] schedule_preempt_disabled+0x13/0x1f
Dec 26 16:20:57 merkaba kernel: [ 8281.540910]  [<ffffffff814a8440>] __mutex_lock_slowpath+0xab/0x126
Dec 26 16:20:57 merkaba kernel: [ 8281.540913]  [<ffffffff81143735>] ? lookup_fast+0x173/0x238
Dec 26 16:20:57 merkaba kernel: [ 8281.540916]  [<ffffffff814a84ce>] mutex_lock+0x13/0x24
Dec 26 16:20:57 merkaba kernel: [ 8281.540918]  [<ffffffff81143c45>] walk_component+0x69/0x17e
Dec 26 16:20:57 merkaba kernel: [ 8281.540921]  [<ffffffff813ca675>] ? __sock_recvmsg_nosec+0x29/0x2b
Dec 26 16:20:57 merkaba kernel: [ 8281.540924]  [<ffffffff81143d88>] lookup_last+0x2e/0x30
Dec 26 16:20:57 merkaba kernel: [ 8281.540926]  [<ffffffff81145a32>] path_lookupat+0x83/0x2d9
Dec 26 16:20:57 merkaba kernel: [ 8281.540929]  [<ffffffff8121f38c>] ? debug_smp_processor_id+0x17/0x19
Dec 26 16:20:57 merkaba kernel: [ 8281.540932]  [<ffffffff8114683c>] ? getname_flags+0x31/0x134
Dec 26 16:20:57 merkaba kernel: [ 8281.540934]  [<ffffffff81145cad>] filename_lookup+0x25/0x7a
Dec 26 16:20:57 merkaba kernel: [ 8281.540937]  [<ffffffff8114767a>] user_path_at_empty+0x55/0x93
Dec 26 16:20:57 merkaba kernel: [ 8281.540942]  [<ffffffff8105ec3e>] ? preempt_count_add+0x7c/0x90
Dec 26 16:20:57 merkaba kernel: [ 8281.540947]  [<ffffffff81071751>] ? cpuacct_account_field+0x56/0x5f
Dec 26 16:20:57 merkaba kernel: [ 8281.540949]  [<ffffffff81071751>] ? cpuacct_account_field+0x56/0x5f
Dec 26 16:20:57 merkaba kernel: [ 8281.540952]  [<ffffffff811476c4>] user_path_at+0xc/0xe
Dec 26 16:20:57 merkaba kernel: [ 8281.540956]  [<ffffffff81160193>] user_statfs+0x2b/0x68
Dec 26 16:20:57 merkaba kernel: [ 8281.540960]  [<ffffffff810be29a>] ? acct_account_cputime+0x17/0x19
Dec 26 16:20:57 merkaba kernel: [ 8281.540963]  [<ffffffff811601eb>] SYSC_statfs+0x1b/0x3a
Dec 26 16:20:57 merkaba kernel: [ 8281.540965]  [<ffffffff8100cf3f>] ? user_exit+0x13/0x15
Dec 26 16:20:57 merkaba kernel: [ 8281.540968]  [<ffffffff8100e21d>] ? syscall_trace_enter_phase1+0x57/0x12a
Dec 26 16:20:57 merkaba kernel: [ 8281.540970]  [<ffffffff8100e537>] ? syscall_trace_leave+0xcc/0x10a
Dec 26 16:20:57 merkaba kernel: [ 8281.540973]  [<ffffffff814aa264>] ? int_check_syscall_exit_work+0x34/0x3d
Dec 26 16:20:57 merkaba kernel: [ 8281.540976]  [<ffffffff81160328>] SyS_statfs+0x9/0xb
Dec 26 16:20:57 merkaba kernel: [ 8281.540978]  [<ffffffff814aa012>] system_call_fastpath+0x12/0x17
Dec 26 16:20:57 merkaba kernel: [ 8281.540983] INFO: task krunner:2050 blocked for more than 120 seconds.
Dec 26 16:20:57 merkaba kernel: [ 8281.540984]       Tainted: G           O   3.18.0-tp520 #14
Dec 26 16:20:57 merkaba kernel: [ 8281.540985] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 26 16:20:57 merkaba kernel: [ 8281.540988] krunner         D 0000000000000000     0  2050      1 0x00000000
Dec 26 16:20:57 merkaba kernel: [ 8281.540991]  ffff8803cb68be58 0000000000000002 ffff8803cb68be28 ffff8803fda39870
Dec 26 16:20:57 merkaba kernel: [ 8281.540993]  ffff8803cb68bfd8 ffff8800cecee1c0 0000000000012300 ffff8800cecee1c0
Dec 26 16:20:57 merkaba kernel: [ 8281.540995]  00000000000089ef ffff8804059e0348 ffff8804059e034c ffff8800cecee1c0
Dec 26 16:20:57 merkaba kernel: [ 8281.540996] Call Trace:
Dec 26 16:20:57 merkaba kernel: [ 8281.540998]  [<ffffffff814a6f9a>] schedule+0x64/0x66
Dec 26 16:20:57 merkaba kernel: [ 8281.541001]  [<ffffffff814a72d3>] schedule_preempt_disabled+0x13/0x1f
Dec 26 16:20:57 merkaba kernel: [ 8281.541003]  [<ffffffff814a8440>] __mutex_lock_slowpath+0xab/0x126
Dec 26 16:20:57 merkaba kernel: [ 8281.541005]  [<ffffffff81150f22>] ? __fget+0x67/0x72
Dec 26 16:20:57 merkaba kernel: [ 8281.541008]  [<ffffffff814a84ce>] mutex_lock+0x13/0x24
Dec 26 16:20:57 merkaba kernel: [ 8281.541010]  [<ffffffff811516e9>] __fdget_pos+0x36/0x3c
Dec 26 16:20:57 merkaba kernel: [ 8281.541012]  [<ffffffff8113a393>] fdget_pos+0x9/0x15
Dec 26 16:20:57 merkaba kernel: [ 8281.541014]  [<ffffffff8113b39d>] SyS_write+0x19/0x71
Dec 26 16:20:57 merkaba kernel: [ 8281.541017]  [<ffffffff814aa264>] ? int_check_syscall_exit_work+0x34/0x3d
Dec 26 16:20:57 merkaba kernel: [ 8281.541019]  [<ffffffff814aa012>] system_call_fastpath+0x12/0x17
Dec 26 16:20:57 merkaba kernel: [ 8281.541035] INFO: task akonadi_baloo_i:2273 blocked for more than 120 seconds.
Dec 26 16:20:57 merkaba kernel: [ 8281.541036]       Tainted: G           O   3.18.0-tp520 #14
Dec 26 16:20:57 merkaba kernel: [ 8281.541036] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 26 16:20:57 merkaba kernel: [ 8281.541039] akonadi_baloo_i D ffff8803b773b628     0  2273   2170 0x00000000
Dec 26 16:20:57 merkaba kernel: [ 8281.541041]  ffff8803ac8ff948 0000000000000002 ffff88040d80dc00 ffffffff81a16500
Dec 26 16:20:57 merkaba kernel: [ 8281.541043]  ffff8803ac8fffd8 ffff8803b773b0e0 0000000000012300 ffff8803b773b0e0
Dec 26 16:20:57 merkaba kernel: [ 8281.541046]  ffff8803ac8ff928 7fffffffffffffff ffff8803ac8ffa80 0000000000000002
Dec 26 16:20:57 merkaba kernel: [ 8281.541046] Call Trace:
Dec 26 16:20:57 merkaba kernel: [ 8281.541049]  [<ffffffff814a8e73>] ? console_conditional_schedule+0x14/0x14
Dec 26 16:20:57 merkaba kernel: [ 8281.541051]  [<ffffffff814a6f9a>] schedule+0x64/0x66
Dec 26 16:20:57 merkaba kernel: [ 8281.541054]  [<ffffffff814a8e93>] schedule_timeout+0x20/0xf5
Dec 26 16:20:57 merkaba kernel: [ 8281.541056]  [<ffffffff8105eb92>] ? get_parent_ip+0xe/0x3e
Dec 26 16:20:57 merkaba kernel: [ 8281.541058]  [<ffffffff8105ec3e>] ? preempt_count_add+0x7c/0x90
Dec 26 16:20:57 merkaba kernel: [ 8281.541061]  [<ffffffff814a97db>] ? _raw_spin_lock_irq+0x1c/0x20
Dec 26 16:20:57 merkaba kernel: [ 8281.541063]  [<ffffffff814a7999>] __wait_for_common+0x11e/0x163
Dec 26 16:20:57 merkaba kernel: [ 8281.541066]  [<ffffffff810607da>] ? wake_up_state+0xd/0xd
Dec 26 16:20:57 merkaba kernel: [ 8281.541069]  [<ffffffff814a79fd>] wait_for_completion+0x1f/0x21
Dec 26 16:20:57 merkaba kernel: [ 8281.541072]  [<ffffffff8115b5fb>] writeback_inodes_sb_nr+0x8c/0x95
Dec 26 16:20:57 merkaba kernel: [ 8281.541077]  [<ffffffff81050101>] ? perf_trace_workqueue_work+0x8e/0x95
Dec 26 16:20:57 merkaba kernel: [ 8281.541115]  [<ffffffffc044a44e>] flush_space+0x200/0x426 [btrfs]
Dec 26 16:20:57 merkaba kernel: [ 8281.541135]  [<ffffffffc044a20c>] ? can_overcommit+0xaa/0xec [btrfs]
Dec 26 16:20:57 merkaba kernel: [ 8281.541160]  [<ffffffffc044aa48>] reserve_metadata_bytes+0x274/0x368 [btrfs]
Dec 26 16:20:57 merkaba kernel: [ 8281.541164]  [<ffffffff8105eb92>] ? get_parent_ip+0xe/0x3e
Dec 26 16:20:57 merkaba kernel: [ 8281.541166]  [<ffffffff8105ec3e>] ? preempt_count_add+0x7c/0x90
Dec 26 16:20:57 merkaba kernel: [ 8281.541185]  [<ffffffffc044b39b>] btrfs_delalloc_reserve_metadata+0x100/0x32c [btrfs]
Dec 26 16:20:57 merkaba kernel: [ 8281.541215]  [<ffffffffc046c182>] __btrfs_buffered_write+0x1be/0x4a4 [btrfs]
Dec 26 16:20:57 merkaba kernel: [ 8281.541218]  [<ffffffff81101a6e>] ? kmap_atomic+0x13/0x39
Dec 26 16:20:57 merkaba kernel: [ 8281.541220]  [<ffffffff81101aa2>] ? pagefault_enable+0xe/0x21
Dec 26 16:20:57 merkaba kernel: [ 8281.541242]  [<ffffffffc046c76b>] btrfs_file_write_iter+0x303/0x40e [btrfs]
Dec 26 16:20:57 merkaba kernel: [ 8281.541245]  [<ffffffff8113a60a>] new_sync_write+0x77/0x9b
Dec 26 16:20:57 merkaba kernel: [ 8281.541247]  [<ffffffff8113ad51>] vfs_write+0xad/0x112
Dec 26 16:20:57 merkaba kernel: [ 8281.541250]  [<ffffffff8113b4d1>] SyS_pwrite64+0x5f/0x7d
Dec 26 16:20:57 merkaba kernel: [ 8281.541253]  [<ffffffff814aa264>] ? int_check_syscall_exit_work+0x34/0x3d
Dec 26 16:20:57 merkaba kernel: [ 8281.541256]  [<ffffffff814aa012>] system_call_fastpath+0x12/0x17
Dec 26 16:20:57 merkaba kernel: [ 8281.541263] INFO: task kworker/u8:1:3336 blocked for more than 120 seconds.
Dec 26 16:20:57 merkaba kernel: [ 8281.541264]       Tainted: G           O   3.18.0-tp520 #14
Dec 26 16:20:57 merkaba kernel: [ 8281.541265] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 26 16:20:57 merkaba kernel: [ 8281.541268] kworker/u8:1    D 0000000000000000     0  3336      2 0x00000000
Dec 26 16:20:57 merkaba kernel: [ 8281.541285] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
Dec 26 16:20:57 merkaba kernel: [ 8281.541288]  ffff880332d6bb78 0000000000000002 ffff88040d80dc00 ffff8803b773b0e0
Dec 26 16:20:57 merkaba kernel: [ 8281.541290]  ffff880332d6bfd8 ffff8800c2804950 0000000000012300 ffff8800c2804950
Dec 26 16:20:57 merkaba kernel: [ 8281.541292]  ffff880332d6bb58 7fffffffffffffff ffff880332d6bcb0 0000000000000002
Dec 26 16:20:57 merkaba kernel: [ 8281.541293] Call Trace:
Dec 26 16:20:57 merkaba kernel: [ 8281.541299]  [<ffffffff814a8e73>] ? console_conditional_schedule+0x14/0x14
Dec 26 16:20:57 merkaba kernel: [ 8281.541301]  [<ffffffff814a6f9a>] schedule+0x64/0x66
Dec 26 16:20:57 merkaba kernel: [ 8281.541303]  [<ffffffff814a8e93>] schedule_timeout+0x20/0xf5
Dec 26 16:20:57 merkaba kernel: [ 8281.541306]  [<ffffffff8105eb92>] ? get_parent_ip+0xe/0x3e
Dec 26 16:20:57 merkaba kernel: [ 8281.541308]  [<ffffffff8105ec3e>] ? preempt_count_add+0x7c/0x90
Dec 26 16:20:57 merkaba kernel: [ 8281.541311]  [<ffffffff814a97db>] ? _raw_spin_lock_irq+0x1c/0x20
Dec 26 16:20:57 merkaba kernel: [ 8281.541313]  [<ffffffff814a7999>] __wait_for_common+0x11e/0x163
Dec 26 16:20:57 merkaba kernel: [ 8281.541317]  [<ffffffff810607da>] ? wake_up_state+0xd/0xd
Dec 26 16:20:57 merkaba kernel: [ 8281.541320]  [<ffffffff814a79fd>] wait_for_completion+0x1f/0x21
Dec 26 16:20:57 merkaba kernel: [ 8281.541322]  [<ffffffff8115b5fb>] writeback_inodes_sb_nr+0x8c/0x95
Dec 26 16:20:57 merkaba kernel: [ 8281.541324]  [<ffffffff81050101>] ? perf_trace_workqueue_work+0x8e/0x95
Dec 26 16:20:57 merkaba kernel: [ 8281.541343]  [<ffffffffc044a44e>] flush_space+0x200/0x426 [btrfs]
Dec 26 16:20:57 merkaba kernel: [ 8281.541346]  [<ffffffff814a97bb>] ? _raw_spin_lock+0x1b/0x1f
Dec 26 16:20:57 merkaba kernel: [ 8281.541348]  [<ffffffff814a9841>] ? _raw_spin_unlock+0x11/0x24
Dec 26 16:20:57 merkaba kernel: [ 8281.541366]  [<ffffffffc044a788>] btrfs_async_reclaim_metadata_space+0x114/0x160 [btrfs]
Dec 26 16:20:57 merkaba kernel: [ 8281.541368]  [<ffffffff81052962>] process_one_work+0x15e/0x2a9
Dec 26 16:20:57 merkaba kernel: [ 8281.541371]  [<ffffffff81052ee1>] worker_thread+0x1f6/0x2a3
Dec 26 16:20:57 merkaba kernel: [ 8281.541374]  [<ffffffff81052ceb>] ? rescuer_thread+0x214/0x214
Dec 26 16:20:57 merkaba kernel: [ 8281.541376]  [<ffffffff8105697c>] kthread+0xb2/0xba
Dec 26 16:20:57 merkaba kernel: [ 8281.541379]  [<ffffffff814a0000>] ? dcbnl_newmsg+0x14/0xa8
Dec 26 16:20:57 merkaba kernel: [ 8281.541381]  [<ffffffff810568ca>] ? __kthread_parkme+0x62/0x62
Dec 26 16:20:57 merkaba kernel: [ 8281.541384]  [<ffffffff814a9f6c>] ret_from_fork+0x7c/0xb0
Dec 26 16:20:57 merkaba kernel: [ 8281.541386]  [<ffffffff810568ca>] ? __kthread_parkme+0x62/0x62
Dec 26 16:21:24 merkaba kernel: [ 8308.678889] device eth0 left promiscuous mode
Dec 26 16:21:24 merkaba kernel: [ 8308.700212] vboxnetflt: 0 out of 34916 packets were not sent (directed to host)


which translates to:

Desktop unusable => hard reboot.


I know resized it from 160GiB to 170 GiB on both devices.

But I think I will consider moving the VM image to another filesystem.

But at least my description can give an idea on how to reproduce this behaviour.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
