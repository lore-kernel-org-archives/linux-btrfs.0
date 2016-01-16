Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from webmail.ccur.com ([12.198.185.177]:35989 "EHLO webmail.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbcAPI2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jan 2016 03:28:43 -0500
From: "Apperson, Bryan" <Bryan.Apperson@ccur.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Sat, 16 Jan 2016 03:23:30 -0500
Subject: BTRFS CPU Soft Lockup
Message-ID: <7914622D-E396-4AA2-BBAC-F78CC1A5B936@ccur.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

Seeing a soft lockup followed by a hard lockup with BTRFS:

Jan 16 02:52:46 hjem kernel: NMI watchdog: BUG: soft lockup - CPU#3 stuck for 23s! [btrfs-transacti:2209]
Jan 16 02:52:46 hjem kernel: Modules linked in: cmac xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun nvidia_modeset(POE) nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 fuse xt_conntrack bnep ebtable_nat ebtable_broute bridge ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw rbd libceph libcrc32c uinput eeepc_wmi asus_wmi sparse_keymap snd_hda_codec_hdmi x86_pkg_temp_thermal snd_hda_codec_realtek snd_hda_codec_generic coretemp vfat fat kvm_intel btusb btrtl btbcm btintel i915 bluetooth kvm crct10dif_pclmul crc32_pclmul drm_kms_helper snd_hda_intel
Jan 16 02:52:46 hjem kernel:  snd_hda_codec snd_hda_core wl(POE) snd_hwdep snd_seq snd_seq_device snd_pcm nvidia(POE) cfg80211 snd_timer snd drm soundcore rfkill i2c_i801 shpchp tpm_tis tpm pinctrl_sunrisepoint pinctrl_intel acpi_als kfifo_buf industrialio acpi_pad acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) btrfs xor 8021q mxm_wmi garp stp llc mrp igb e1000e crc32c_intel raid6_pq serio_raw dca ptp pps_core i2c_algo_bit wmi video i2c_hid
Jan 16 02:52:46 hjem kernel: CPU: 3 PID: 2209 Comm: btrfs-transacti Tainted: P      D W  OE   4.2.8-200.fc22.x86_64 #1
Jan 16 02:52:46 hjem kernel: Hardware name: System manufacturer System Product Name/Z170-DELUXE, BIOS 0901 08/31/2015
Jan 16 02:52:46 hjem kernel: task: ffff88084d299e80 ti: ffff88080c228000 task.ti: ffff88080c228000
Jan 16 02:52:46 hjem kernel: RIP: 0010:[<ffffffff810e7c3d>]  [<ffffffff810e7c3d>] queue_write_lock_slowpath+0x3d/0x80
Jan 16 02:52:46 hjem kernel: RSP: 0018:ffff88080c22b948  EFLAGS: 00000286
Jan 16 02:52:46 hjem kernel: RAX: 00000000000000ff RBX: ffffffffa022ce33 RCX: 0000000000000000
Jan 16 02:52:46 hjem kernel: RDX: 0000000000000001 RSI: ffff88084d299e80 RDI: ffff88082002e290
Jan 16 02:52:46 hjem kernel: RBP: ffff88080c22b958 R08: 000000000000009e R09: ffff88082000b908
Jan 16 02:52:46 hjem kernel: R10: 0000000000000000 R11: 0000000000000001 R12: ffff880830ca6800
Jan 16 02:52:46 hjem kernel: R13: 0000000000000001 R14: 0000000000032c58 R15: ffff8808300d6f10
Jan 16 02:52:46 hjem kernel: FS:  0000000000000000(0000) GS:ffff8808764c0000(0000) knlGS:0000000000000000
Jan 16 02:52:46 hjem kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jan 16 02:52:46 hjem kernel: CR2: 000000000130f638 CR3: 0000000001c0b000 CR4: 00000000003406e0
Jan 16 02:52:46 hjem kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 16 02:52:46 hjem kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jan 16 02:52:46 hjem kernel: Stack:
Jan 16 02:52:46 hjem kernel:  ffff88080c22b988 ffff88082002e230 ffff88080c22b968 ffffffff81779f5e
Jan 16 02:52:46 hjem kernel:  ffff88080c22b988 ffffffffa026dcb9 ffff8807b9f22d88 ffff8807b9f22d80
Jan 16 02:52:46 hjem kernel:  ffff88080c22ba38 ffffffffa020de8e ffff88080c22b9d8 ffffffff8153f67f
Jan 16 02:52:46 hjem kernel: Call Trace:
Jan 16 02:52:46 hjem kernel:  [<ffffffff81779f5e>] _raw_write_lock+0x1e/0x20
Jan 16 02:52:46 hjem kernel:  [<ffffffffa026dcb9>] btrfs_try_tree_write_lock+0x29/0x70 [btrfs]
Jan 16 02:52:46 hjem kernel:  [<ffffffffa020de8e>] btrfs_search_slot+0x3de/0xa10 [btrfs]
Jan 16 02:52:46 hjem kernel:  [<ffffffff8153f67f>] ? ahci_qc_prep+0x19f/0x1b0
Jan 16 02:52:46 hjem kernel:  [<ffffffffa0215530>] lookup_inline_extent_backref+0xf0/0x5b0 [btrfs]
Jan 16 02:52:46 hjem kernel:  [<ffffffffa0215a58>] insert_inline_extent_backref+0x68/0xf0 [btrfs]
Jan 16 02:52:46 hjem kernel:  [<ffffffff81200236>] ? kmem_cache_alloc+0x1d6/0x210
Jan 16 02:52:46 hjem kernel:  [<ffffffffa0208d4a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
Jan 16 02:52:46 hjem kernel:  [<ffffffffa0215f79>] __btrfs_inc_extent_ref.isra.52+0xa9/0x270 [btrfs]
Jan 16 02:52:46 hjem kernel:  [<ffffffff8177584d>] ? io_schedule_timeout+0xdd/0x110
Jan 16 02:52:46 hjem kernel:  [<ffffffff810d1289>] ? update_curr+0x119/0x150
Jan 16 02:52:46 hjem kernel:  [<ffffffffa021b2ba>] __btrfs_run_delayed_refs+0x8ca/0x1090 [btrfs]
Jan 16 02:52:46 hjem kernel:  [<ffffffff810d59bb>] ? dequeue_task_fair+0x36b/0x700
Jan 16 02:52:46 hjem kernel:  [<ffffffff810d4d81>] ? put_prev_entity+0x31/0x420
Jan 16 02:52:46 hjem kernel:  [<ffffffffa021e644>] btrfs_run_delayed_refs.part.72+0x74/0x270 [btrfs]
Jan 16 02:52:46 hjem kernel:  [<ffffffffa021e855>] btrfs_run_delayed_refs+0x15/0x20 [btrfs]
Jan 16 02:52:46 hjem kernel:  [<ffffffffa0232ef6>] btrfs_commit_transaction+0x56/0xad0 [btrfs]
Jan 16 02:52:46 hjem kernel:  [<ffffffffa022e5d4>] transaction_kthread+0x214/0x230 [btrfs]
Jan 16 02:52:46 hjem kernel:  [<ffffffffa022e3c0>] ? btrfs_cleanup_transaction+0x510/0x510 [btrfs]
Jan 16 02:52:46 hjem kernel:  [<ffffffff810bc8c8>] kthread+0xd8/0xf0
Jan 16 02:52:46 hjem kernel:  [<ffffffff810bc7f0>] ? kthread_worker_fn+0x160/0x160
Jan 16 02:52:46 hjem kernel:  [<ffffffff8177a69f>] ret_from_fork+0x3f/0x70
Jan 16 02:52:46 hjem kernel:  [<ffffffff810bc7f0>] ? kthread_worker_fn+0x160/0x160
Jan 16 02:52:46 hjem kernel: Code: 89 fb 48 83 ec 08 f0 0f b1 57 04 85 c0 75 4f 8b 03 85 c0 75 0d ba ff 00 00 00 f0 0f b1 13 85 c0 74 31 ba 01 00 00 00 eb 02 f3 90 <0f> b6 03 84 c0 75 f7 f0 0f b0 13 84 c0 75 ef ba ff 00 00 00 eb
Jan 16 02:52:47 hjem abrt-dump-journal-oops[1713]: abrt-dump-journal-oops: Found oopses: 1
Jan 16 02:52:47 hjem abrt-dump-journal-oops[1713]: abrt-dump-journal-oops: Creating problem directories
Jan 16 02:52:48 hjem abrt-dump-journal-oops[1713]: Reported 1 kernel oopses to Abrt
Jan 16 02:52:49 hjem abrt-server[4941]: Deleting problem directory oops-2016-01-16-02:52:47-1713-0 (dup of oops-2016-01-16-00:56:01-1841-0)

Next:

Jan 16 03:08:20 hjem kernel: btrfs-transacti R  running task        0  2209      2 0x00000008
Jan 16 03:08:20 hjem kernel:  ffff88084d299e80 0000000047cdb606 ffff8808764c3d78 ffffffff810ca089
Jan 16 03:08:20 hjem kernel:  0000000000000003 ffffffff81c54080 ffff8808764c3d98 ffffffff810cc97b
Jan 16 03:08:20 hjem kernel:  ffff8808764c3d98 0000000000000004 ffff8808764c3dc8 ffffffff810fee58
Jan 16 03:08:20 hjem kernel: Call Trace:
Jan 16 03:08:20 hjem kernel:  <IRQ>  [<ffffffff810ca089>] sched_show_task+0xa9/0x110
Jan 16 03:08:20 hjem kernel:  [<ffffffff810cc97b>] dump_cpu_task+0x3b/0x50
Jan 16 03:08:20 hjem kernel:  [<ffffffff810fee58>] rcu_dump_cpu_stacks+0x88/0xd0
Jan 16 03:08:20 hjem kernel:  [<ffffffff81102b03>] rcu_check_callbacks+0x513/0x800
Jan 16 03:08:20 hjem kernel:  [<ffffffff811574fc>] ? acct_account_cputime+0x1c/0x20
Jan 16 03:08:20 hjem kernel:  [<ffffffff810cd591>] ? account_system_time+0x81/0x120
Jan 16 03:08:20 hjem kernel:  [<ffffffff811174c0>] ? tick_sched_handle.isra.16+0x60/0x60
Jan 16 03:08:20 hjem kernel:  [<ffffffff81107e79>] update_process_times+0x39/0x60
Jan 16 03:08:20 hjem kernel:  [<ffffffff81117485>] tick_sched_handle.isra.16+0x25/0x60
Jan 16 03:08:20 hjem kernel:  [<ffffffff81117504>] tick_sched_timer+0x44/0x80
Jan 16 03:08:20 hjem kernel:  [<ffffffff8110878e>] __hrtimer_run_queues+0xee/0x220
Jan 16 03:08:20 hjem kernel:  [<ffffffff81108eb8>] hrtimer_interrupt+0xa8/0x190
Jan 16 03:08:20 hjem kernel:  [<ffffffff8104e98c>] local_apic_timer_interrupt+0x3c/0x70
Jan 16 03:08:20 hjem kernel:  [<ffffffff8177cfb1>] smp_apic_timer_interrupt+0x41/0x60
Jan 16 03:08:20 hjem kernel:  [<ffffffff8177b14b>] apic_timer_interrupt+0x6b/0x70
Jan 16 03:08:20 hjem kernel:  <EOI>  [<ffffffffa022ce33>] ? btrfs_buffer_uptodate+0x53/0x70 [btrfs]
Jan 16 03:08:20 hjem kernel:  [<ffffffff810e7c3d>] ? queue_write_lock_slowpath+0x3d/0x80
Jan 16 03:08:20 hjem kernel:  [<ffffffff81779f5e>] _raw_write_lock+0x1e/0x20
Jan 16 03:08:20 hjem kernel:  [<ffffffffa026dcb9>] btrfs_try_tree_write_lock+0x29/0x70 [btrfs]
Jan 16 03:08:20 hjem kernel:  [<ffffffffa020de8e>] btrfs_search_slot+0x3de/0xa10 [btrfs]
Jan 16 03:08:20 hjem kernel:  [<ffffffff8153f67f>] ? ahci_qc_prep+0x19f/0x1b0
Jan 16 03:08:20 hjem kernel:  [<ffffffffa0215530>] lookup_inline_extent_backref+0xf0/0x5b0 [btrfs]
Jan 16 03:08:20 hjem kernel:  [<ffffffffa0215a58>] insert_inline_extent_backref+0x68/0xf0 [btrfs]
Jan 16 03:08:20 hjem kernel:  [<ffffffff81200236>] ? kmem_cache_alloc+0x1d6/0x210
Jan 16 03:08:20 hjem kernel:  [<ffffffffa0208d4a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
Jan 16 03:08:20 hjem kernel:  [<ffffffffa0215f79>] __btrfs_inc_extent_ref.isra.52+0xa9/0x270 [btrfs]
Jan 16 03:08:20 hjem kernel:  [<ffffffff8177584d>] ? io_schedule_timeout+0xdd/0x110
Jan 16 03:08:20 hjem kernel:  [<ffffffff810d1289>] ? update_curr+0x119/0x150
Jan 16 03:08:20 hjem kernel:  [<ffffffffa021b2ba>] __btrfs_run_delayed_refs+0x8ca/0x1090 [btrfs]
Jan 16 03:08:20 hjem kernel:  [<ffffffff810d59bb>] ? dequeue_task_fair+0x36b/0x700
Jan 16 03:08:20 hjem kernel:  [<ffffffff810d4d81>] ? put_prev_entity+0x31/0x420
Jan 16 03:08:20 hjem kernel:  [<ffffffffa021e644>] btrfs_run_delayed_refs.part.72+0x74/0x270 [btrfs]
Jan 16 03:08:20 hjem kernel:  [<ffffffffa021e855>] btrfs_run_delayed_refs+0x15/0x20 [btrfs]
Jan 16 03:08:20 hjem kernel:  [<ffffffffa0232ef6>] btrfs_commit_transaction+0x56/0xad0 [btrfs]
Jan 16 03:08:20 hjem kernel:  [<ffffffffa022e5d4>] transaction_kthread+0x214/0x230 [btrfs]
Jan 16 03:08:20 hjem kernel:  [<ffffffffa022e3c0>] ? btrfs_cleanup_transaction+0x510/0x510 [btrfs]
Jan 16 03:08:20 hjem kernel:  [<ffffffff810bc8c8>] kthread+0xd8/0xf0
Jan 16 03:08:20 hjem kernel:  [<ffffffff810bc7f0>] ? kthread_worker_fn+0x160/0x160
Jan 16 03:08:20 hjem kernel:  [<ffffffff8177a69f>] ret_from_fork+0x3f/0x70
Jan 16 03:08:20 hjem kernel:  [<ffffffff810bc7f0>] ? kthread_worker_fn+0x160/0x160

Any advice?

Regards,
Bryan

