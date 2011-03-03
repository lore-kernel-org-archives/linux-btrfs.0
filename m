From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V2] btrfs: implement delayed inode items operation
Date: Thu, 03 Mar 2011 14:15:44 +0800
Message-ID: <4D6F3210.3040104@cn.fujitsu.com>
References: <20110224230255.78496fc6.kitayama@cl.bb4u.ne.jp>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110224230255.78496fc6.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Kitayama-san

Sorry for my late reply.

On Thu, 24 Feb 2011 23:02:55 +0900, Itaru Kitayama wrote:
> I have applied the V2 patch on top of the next-rc branch of btrfs-unstable
> and ran dbench 50. The run never finished and lots of stall messages recorded
> in the log.
> Looking at the stack trace, something wrong with the delayed item balancing?
> Are you working on the similar problem for V3?

I have made the third version of this patch, could you test it for me to check
whether this problem still happens or not?

Thanks
Miao
 
> 
> INFO: rcu_sched_state detected stall on CPU 1 (t=15000 jiffies)
> sending NMI to all CPUs:
> NMI backtrace for cpu 0
> CPU 0 
> Modules linked in: nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput snd_ens1371 gameport snd_rawmidi snd_ac97_codec ppdev ac97_bus snd_seq snd_seq_device snd_pcm vmw_balloon microcode snd_timer pcspkr parport_pc snd parport e1000 i2c_piix4 soundcore shpchp i2c_core snd_page_alloc mptspi mptscsih mptbase scsi_transport_spi floppy [last unloaded: speedstep_lib]
> 
> Pid: 3297, comm: dbench Not tainted 2.6.36-desktop+ #51 440BX Desktop Reference Platform/VMware Virtual Platform
> RIP: 0010:[<ffffffff8101ea75>]  [<ffffffff8101ea75>] native_apic_mem_write+0x11/0x13
> RSP: 0018:ffff880004e03ea8  EFLAGS: 00000006
> RAX: ffffffff81a147c0 RBX: ffff880004e0d480 RCX: 0000000000000020
> RDX: 0000000000059a96 RSI: 00000000000005eb RDI: 0000000000000380
> RBP: ffff880004e03ea8 R08: ffff880004e0d480 R09: 0000000000000001
> R10: ffff880004e03f18 R11: ffff8800345cd208 R12: 0000000000000000
> R13: ffffffff817a4bbe R14: 0000000000000000 R15: ffff880004e03f48
> FS:  00007fd473373720(0000) GS:ffff880004e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007fcd41ce3000 CR3: 000000003715f000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process dbench (pid: 3297, threadinfo ffff880039314000, task ffff8800345cd1d0)
> Stack:
>  ffff880004e03eb8 ffffffff8101a8c8 ffff880004e03ec8 ffffffff8106a60d
> <0> ffff880004e03f08 ffffffff8106bb62 00000055a1ca9b4c 00000055a1d040c0
> <0> ffff880004e103c0 00000055a1ca9b4c 0000000000000000 ffff880004e10400
> Call Trace:
>  <IRQ> 
>  [<ffffffff8101a8c8>] lapic_next_event+0x1d/0x21
>  [<ffffffff8106a60d>] clockevents_program_event+0x7a/0x83
>  [<ffffffff8106bb62>] tick_dev_program_event+0x3c/0xfc
>  [<ffffffff8106bc81>] tick_program_event+0x2a/0x2c
>  [<ffffffff81061904>] hrtimer_interrupt+0x11a/0x1c3
>  [<ffffffff8149c389>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff814a342b>] smp_apic_timer_interrupt+0x88/0x9b
>  [<ffffffff81003613>] apic_timer_interrupt+0x13/0x20
>  <EOI> 
>  [<ffffffff8149c5ff>] ? _raw_spin_lock+0x62/0x69
>  [<ffffffff8107103b>] ? lock_acquired+0x259/0x268
>  [<ffffffff81202f27>] ? btrfs_wq_run_delayed_node+0x3f/0x149
>  [<ffffffff8149c5ff>] _raw_spin_lock+0x62/0x69
>  [<ffffffff81202f27>] ? btrfs_wq_run_delayed_node+0x3f/0x149
>  [<ffffffff81202f27>] btrfs_wq_run_delayed_node+0x3f/0x149
>  [<ffffffff812030ef>] btrfs_balance_delayed_items+0xbe/0xc9
>  [<ffffffff8149afd1>] ? mutex_unlock+0xe/0x10
>  [<ffffffff81201ad5>] ? btrfs_release_delayed_node+0xdd/0xfb
>  [<ffffffff8120330d>] btrfs_delayed_update_inode+0xbd/0xcb
>  [<ffffffff811ccd5e>] btrfs_update_inode+0x17/0x44
>  [<ffffffff811cef4c>] btrfs_dirty_inode+0x57/0x103
>  [<ffffffff81130cd0>] __mark_inode_dirty+0x33/0x1aa
>  [<ffffffff81125ad9>] touch_atime+0x107/0x12a
>  [<ffffffff810cd9d5>] generic_file_aio_read+0x567/0x5bc
>  [<ffffffff81111f07>] do_sync_read+0xcb/0x108
>  [<ffffffff812140da>] ? fsnotify_perm+0x4a/0x50
>  [<ffffffff81214141>] ? security_file_permission+0x2e/0x33
>  [<ffffffff81112579>] vfs_read+0xab/0x107
>  [<ffffffff8111262f>] sys_pread64+0x5a/0x76
>  [<ffffffff81002c1b>] system_call_fastpath+0x16/0x1b
> Code: 0f b6 34 dd 01 f0 f9 81 89 c2 48 c7 c7 99 70 77 81 31 c0 e8 88 b4 47 00 eb d5 55 48 89 e5 0f 1f 44 00 00 89 ff 89 b7 00 b0 5f ff <c9> c3 55 48 89 e5 0f 1f 44 00 00 89 ff 8b 87 00 b0 5f ff c9 c3 
> Call Trace:
>  <IRQ>  [<ffffffff8101a8c8>] lapic_next_event+0x1d/0x21
>  [<ffffffff8106a60d>] clockevents_program_event+0x7a/0x83
>  [<ffffffff8106bb62>] tick_dev_program_event+0x3c/0xfc
>  [<ffffffff8106bc81>] tick_program_event+0x2a/0x2c
>  [<ffffffff81061904>] hrtimer_interrupt+0x11a/0x1c3
>  [<ffffffff8149c389>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff814a342b>] smp_apic_timer_interrupt+0x88/0x9b
>  [<ffffffff81003613>] apic_timer_interrupt+0x13/0x20
>  <EOI>  [<ffffffff8149c5ff>] ? _raw_spin_lock+0x62/0x69
>  [<ffffffff8107103b>] ? lock_acquired+0x259/0x268
>  [<ffffffff81202f27>] ? btrfs_wq_run_delayed_node+0x3f/0x149
>  [<ffffffff8149c5ff>] _raw_spin_lock+0x62/0x69
>  [<ffffffff81202f27>] ? btrfs_wq_run_delayed_node+0x3f/0x149
>  [<ffffffff81202f27>] btrfs_wq_run_delayed_node+0x3f/0x149
>  [<ffffffff812030ef>] btrfs_balance_delayed_items+0xbe/0xc9
>  [<ffffffff8149afd1>] ? mutex_unlock+0xe/0x10
>  [<ffffffff81201ad5>] ? btrfs_release_delayed_node+0xdd/0xfb
>  [<ffffffff8120330d>] btrfs_delayed_update_inode+0xbd/0xcb
>  [<ffffffff811ccd5e>] btrfs_update_inode+0x17/0x44
>  [<ffffffff811cef4c>] btrfs_dirty_inode+0x57/0x103
>  [<ffffffff81130cd0>] __mark_inode_dirty+0x33/0x1aa
>  [<ffffffff81125ad9>] touch_atime+0x107/0x12a
>  [<ffffffff810cd9d5>] generic_file_aio_read+0x567/0x5bc
>  [<ffffffff81111f07>] do_sync_read+0xcb/0x108
>  [<ffffffff812140da>] ? fsnotify_perm+0x4a/0x50
>  [<ffffffff81214141>] ? security_file_permission+0x2e/0x33
>  [<ffffffff81112579>] vfs_read+0xab/0x107
>  [<ffffffff8111262f>] sys_pread64+0x5a/0x76
>  [<ffffffff81002c1b>] system_call_fastpath+0x16/0x1b
> Pid: 3297, comm: dbench Not tainted 2.6.36-desktop+ #51
> Call Trace:
>  <NMI>  [<ffffffff8100a038>] ? show_regs+0x2b/0x30
>  [<ffffffff8149e836>] arch_trigger_all_cpu_backtrace_handler+0x76/0x9a
>  [<ffffffff814a02c8>] notifier_call_chain+0x68/0x9c
>  [<ffffffff814a035a>] __atomic_notifier_call_chain+0x5e/0x8b
>  [<ffffffff814a02fc>] ? __atomic_notifier_call_chain+0x0/0x8b
>  [<ffffffff814a039b>] atomic_notifier_call_chain+0x14/0x16
>  [<ffffffff814a03cb>] notify_die+0x2e/0x30
>  [<ffffffff8149dd0e>] do_nmi+0xaa/0x293
>  [<ffffffff8149d74a>] nmi+0x1a/0x2c
>  [<ffffffff8101ea75>] ? native_apic_mem_write+0x11/0x13
>  <<EOE>>  <IRQ>  [<ffffffff8101a8c8>] lapic_next_event+0x1d/0x21
>  [<ffffffff8106a60d>] clockevents_program_event+0x7a/0x83
>  [<ffffffff8106bb62>] tick_dev_program_event+0x3c/0xfc
>  [<ffffffff8106bc81>] tick_program_event+0x2a/0x2c
>  [<ffffffff81061904>] hrtimer_interrupt+0x11a/0x1c3
>  [<ffffffff8149c389>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff814a342b>] smp_apic_timer_interrupt+0x88/0x9b
>  [<ffffffff81003613>] apic_timer_interrupt+0x13/0x20
>  <EOI>  [<ffffffff8149c5ff>] ? _raw_spin_lock+0x62/0x69
>  [<ffffffff8107103b>] ? lock_acquired+0x259/0x268
>  [<ffffffff81202f27>] ? btrfs_wq_run_delayed_node+0x3f/0x149
>  [<ffffffff8149c5ff>] _raw_spin_lock+0x62/0x69
>  [<ffffffff81202f27>] ? btrfs_wq_run_delayed_node+0x3f/0x149
>  [<ffffffff81202f27>] btrfs_wq_run_delayed_node+0x3f/0x149
>  [<ffffffff812030ef>] btrfs_balance_delayed_items+0xbe/0xc9
>  [<ffffffff8149afd1>] ? mutex_unlock+0xe/0x10
>  [<ffffffff81201ad5>] ? btrfs_release_delayed_node+0xdd/0xfb
>  [<ffffffff8120330d>] btrfs_delayed_update_inode+0xbd/0xcb
>  [<ffffffff811ccd5e>] btrfs_update_inode+0x17/0x44
>  [<ffffffff811cef4c>] btrfs_dirty_inode+0x57/0x103
>  [<ffffffff81130cd0>] __mark_inode_dirty+0x33/0x1aa
>  [<ffffffff81125ad9>] touch_atime+0x107/0x12a
>  [<ffffffff810cd9d5>] generic_file_aio_read+0x567/0x5bc
>  [<ffffffff81111f07>] do_sync_read+0xcb/0x108
>  [<ffffffff812140da>] ? fsnotify_perm+0x4a/0x50
>  [<ffffffff81214141>] ? security_file_permission+0x2e/0x33
>  [<ffffffff81112579>] vfs_read+0xab/0x107
>  [<ffffffff8111262f>] sys_pread64+0x5a/0x76
>  [<ffffffff81002c1b>] system_call_fastpath+0x16/0x1b
> NMI backtrace for cpu 1
> CPU 1 
> Modules linked in: nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput snd_ens1371 gameport snd_rawmidi snd_ac97_codec ppdev ac97_bus snd_seq snd_seq_device snd_pcm vmw_balloon microcode snd_timer pcspkr parport_pc snd parport e1000 i2c_piix4 soundcore shpchp i2c_core snd_page_alloc mptspi mptscsih mptbase scsi_transport_spi floppy [last unloaded: speedstep_lib]
> 
> Pid: 3301, comm: dbench Not tainted 2.6.36-desktop+ #51 440BX Desktop Reference Platform/VMware Virtual Platform
> RIP: 0010:[<ffffffff8101ee4c>]  [<ffffffff8101ee4c>] _flat_send_IPI_mask+0x6c/0x90
> RSP: 0018:ffff880005003da8  EFLAGS: 00000046
> RAX: 0000000000000c00 RBX: 0000000003000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000300
> RBP: ffff880005003dc8 R08: 0000000000000096 R09: 0000000000000000
> R10: ffff880005003c68 R11: 0000000000000000 R12: 0000000000000046
> R13: 0000000000000002 R14: 0000000000000c00 R15: ffffffff8106c00b
> FS:  00007fd473373720(0000) GS:ffff880005000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff880051370e10 CR3: 0000000034691000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process dbench (pid: 3301, threadinfo ffff8800370a2000, task ffff88003463d2d0)
> Stack:
>  0000000000000000 ffff8800051d06c0 ffffffff81a21d80 ffff880005003f48
> <0> ffff880005003dd8 ffffffff8101eed6 ffff880005003df8 ffffffff8101bae8
> <0> 0000000000000001 ffffffff81a21c80 ffff880005003e48 ffffffff810a3a2f
> Call Trace:
>  <IRQ> 
>  [<ffffffff8101eed6>] flat_send_IPI_all+0x22/0x5c
>  [<ffffffff8101bae8>] arch_trigger_all_cpu_backtrace+0x56/0x86
>  [<ffffffff810a3a2f>] __rcu_pending+0x86/0x31b
>  [<ffffffff8103b874>] ? account_system_time+0x138/0x147
>  [<ffffffff8106c00b>] ? tick_sched_timer+0x0/0xa1
>  [<ffffffff810a3d8a>] rcu_check_callbacks+0xc6/0xf8
>  [<ffffffff8104fe00>] update_process_times+0x41/0x61
>  [<ffffffff8106c082>] tick_sched_timer+0x77/0xa1
>  [<ffffffff810615eb>] __run_hrtimer+0xc3/0x152
>  [<ffffffff810618b1>] hrtimer_interrupt+0xc7/0x1c3
>  [<ffffffff8149c389>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff814a342b>] smp_apic_timer_interrupt+0x88/0x9b
>  [<ffffffff81102e17>] ? kfree+0x88/0xac
>  [<ffffffff81003613>] apic_timer_interrupt+0x13/0x20
>  <EOI> 
>  [<ffffffff81256f3a>] ? delay_tsc+0x19/0x5f
>  [<ffffffff81256eaf>] __delay+0xf/0x11
>  [<ffffffff8125b661>] do_raw_spin_lock+0xd8/0x142
>  [<ffffffff81102e2f>] ? kfree+0xa0/0xac
>  [<ffffffff81102e17>] ? kfree+0x88/0xac
>  [<ffffffff81102e2f>] ? kfree+0xa0/0xac
>  [<ffffffff8149c5f3>] _raw_spin_lock+0x56/0x69
>  [<ffffffff81201b45>] ? btrfs_next_delayed_node+0x1b/0x53
>  [<ffffffff81102e17>] ? kfree+0x88/0xac
>  [<ffffffff81201b45>] btrfs_next_delayed_node+0x1b/0x53
>  [<ffffffff81202ffd>] btrfs_wq_run_delayed_node+0x115/0x149
>  [<ffffffff812030ef>] btrfs_balance_delayed_items+0xbe/0xc9
>  [<ffffffff8149afd1>] ? mutex_unlock+0xe/0x10
>  [<ffffffff81201ad5>] ? btrfs_release_delayed_node+0xdd/0xfb
>  [<ffffffff8120330d>] btrfs_delayed_update_inode+0xbd/0xcb
>  [<ffffffff811ccd5e>] btrfs_update_inode+0x17/0x44
>  [<ffffffff811cef4c>] btrfs_dirty_inode+0x57/0x103
>  [<ffffffff81130cd0>] __mark_inode_dirty+0x33/0x1aa
>  [<ffffffff81125ad9>] touch_atime+0x107/0x12a
>  [<ffffffff811207b5>] ? filldir+0x0/0xd0
>  [<ffffffff811209ce>] vfs_readdir+0x8f/0xb6
>  [<ffffffff81120b45>] sys_getdents+0x85/0xd8
>  [<ffffffff81002c1b>] system_call_fastpath+0x16/0x1b
> Code: f6 c4 10 75 f2 c1 e3 18 89 1c 25 10 b3 5f ff 44 89 e8 44 09 f0 41 81 ce 00 04 00 00 41 83 fd 02 41 0f 44 c6 89 04 25 00 b3 5f ff <41> f7 c4 00 02 00 00 75 0a 41 54 9d e8 12 f8 04 00 eb 08 e8 18 
> Call Trace:
>  <IRQ>  [<ffffffff8101eed6>] flat_send_IPI_all+0x22/0x5c
>  [<ffffffff8101bae8>] arch_trigger_all_cpu_backtrace+0x56/0x86
>  [<ffffffff810a3a2f>] __rcu_pending+0x86/0x31b
>  [<ffffffff8103b874>] ? account_system_time+0x138/0x147
>  [<ffffffff8106c00b>] ? tick_sched_timer+0x0/0xa1
>  [<ffffffff810a3d8a>] rcu_check_callbacks+0xc6/0xf8
>  [<ffffffff8104fe00>] update_process_times+0x41/0x61
>  [<ffffffff8106c082>] tick_sched_timer+0x77/0xa1
>  [<ffffffff810615eb>] __run_hrtimer+0xc3/0x152
>  [<ffffffff810618b1>] hrtimer_interrupt+0xc7/0x1c3
>  [<ffffffff8149c389>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff814a342b>] smp_apic_timer_interrupt+0x88/0x9b
>  [<ffffffff81102e17>] ? kfree+0x88/0xac
>  [<ffffffff81003613>] apic_timer_interrupt+0x13/0x20
>  <EOI>  [<ffffffff81256f3a>] ? delay_tsc+0x19/0x5f
>  [<ffffffff81256eaf>] __delay+0xf/0x11
>  [<ffffffff8125b661>] do_raw_spin_lock+0xd8/0x142
>  [<ffffffff81102e2f>] ? kfree+0xa0/0xac
>  [<ffffffff81102e17>] ? kfree+0x88/0xac
>  [<ffffffff81102e2f>] ? kfree+0xa0/0xac
>  [<ffffffff8149c5f3>] _raw_spin_lock+0x56/0x69
>  [<ffffffff81201b45>] ? btrfs_next_delayed_node+0x1b/0x53
>  [<ffffffff81102e17>] ? kfree+0x88/0xac
>  [<ffffffff81201b45>] btrfs_next_delayed_node+0x1b/0x53
>  [<ffffffff81202ffd>] btrfs_wq_run_delayed_node+0x115/0x149
>  [<ffffffff812030ef>] btrfs_balance_delayed_items+0xbe/0xc9
>  [<ffffffff8149afd1>] ? mutex_unlock+0xe/0x10
>  [<ffffffff81201ad5>] ? btrfs_release_delayed_node+0xdd/0xfb
>  [<ffffffff8120330d>] btrfs_delayed_update_inode+0xbd/0xcb
>  [<ffffffff811ccd5e>] btrfs_update_inode+0x17/0x44
>  [<ffffffff811cef4c>] btrfs_dirty_inode+0x57/0x103
>  [<ffffffff81130cd0>] __mark_inode_dirty+0x33/0x1aa
>  [<ffffffff81125ad9>] touch_atime+0x107/0x12a
>  [<ffffffff811207b5>] ? filldir+0x0/0xd0
>  [<ffffffff811209ce>] vfs_readdir+0x8f/0xb6
>  [<ffffffff81120b45>] sys_getdents+0x85/0xd8
>  [<ffffffff81002c1b>] system_call_fastpath+0x16/0x1b
> Pid: 3301, comm: dbench Not tainted 2.6.36-desktop+ #51
> Call Trace:
>  <NMI>  [<ffffffff8100a038>] ? show_regs+0x2b/0x30
>  [<ffffffff8149e836>] arch_trigger_all_cpu_backtrace_handler+0x76/0x9a
>  [<ffffffff814a02c8>] notifier_call_chain+0x68/0x9c
>  [<ffffffff814a035a>] __atomic_notifier_call_chain+0x5e/0x8b
>  [<ffffffff814a02fc>] ? __atomic_notifier_call_chain+0x0/0x8b
>  [<ffffffff8106c00b>] ? tick_sched_timer+0x0/0xa1
>  [<ffffffff814a039b>] atomic_notifier_call_chain+0x14/0x16
>  [<ffffffff814a03cb>] notify_die+0x2e/0x30
>  [<ffffffff8149dd0e>] do_nmi+0xaa/0x293
>  [<ffffffff8149d74a>] nmi+0x1a/0x2c
>  [<ffffffff8106c00b>] ? tick_sched_timer+0x0/0xa1
>  [<ffffffff8101ee4c>] ? _flat_send_IPI_mask+0x6c/0x90
>  <<EOE>>  <IRQ>  [<ffffffff8101eed6>] flat_send_IPI_all+0x22/0x5c
>  [<ffffffff8101bae8>] arch_trigger_all_cpu_backtrace+0x56/0x86
>  [<ffffffff810a3a2f>] __rcu_pending+0x86/0x31b
>  [<ffffffff8103b874>] ? account_system_time+0x138/0x147
>  [<ffffffff8106c00b>] ? tick_sched_timer+0x0/0xa1
>  [<ffffffff810a3d8a>] rcu_check_callbacks+0xc6/0xf8
>  [<ffffffff8104fe00>] update_process_times+0x41/0x61
>  [<ffffffff8106c082>] tick_sched_timer+0x77/0xa1
>  [<ffffffff810615eb>] __run_hrtimer+0xc3/0x152
>  [<ffffffff810618b1>] hrtimer_interrupt+0xc7/0x1c3
>  [<ffffffff8149c389>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff814a342b>] smp_apic_timer_interrupt+0x88/0x9b
>  [<ffffffff81102e17>] ? kfree+0x88/0xac
>  [<ffffffff81003613>] apic_timer_interrupt+0x13/0x20
>  <EOI>  [<ffffffff81256f3a>] ? delay_tsc+0x19/0x5f
>  [<ffffffff81256eaf>] __delay+0xf/0x11
>  [<ffffffff8125b661>] do_raw_spin_lock+0xd8/0x142
>  [<ffffffff81102e2f>] ? kfree+0xa0/0xac
>  [<ffffffff81102e17>] ? kfree+0x88/0xac
>  [<ffffffff81102e2f>] ? kfree+0xa0/0xac
>  [<ffffffff8149c5f3>] _raw_spin_lock+0x56/0x69
>  [<ffffffff81201b45>] ? btrfs_next_delayed_node+0x1b/0x53
>  [<ffffffff81102e17>] ? kfree+0x88/0xac
>  [<ffffffff81201b45>] btrfs_next_delayed_node+0x1b/0x53
>  [<ffffffff81202ffd>] btrfs_wq_run_delayed_node+0x115/0x149
>  [<ffffffff812030ef>] btrfs_balance_delayed_items+0xbe/0xc9
>  [<ffffffff8149afd1>] ? mutex_unlock+0xe/0x10
>  [<ffffffff81201ad5>] ? btrfs_release_delayed_node+0xdd/0xfb
>  [<ffffffff8120330d>] btrfs_delayed_update_inode+0xbd/0xcb
>  [<ffffffff811ccd5e>] btrfs_update_inode+0x17/0x44
>  [<ffffffff811cef4c>] btrfs_dirty_inode+0x57/0x103
>  [<ffffffff81130cd0>] __mark_inode_dirty+0x33/0x1aa
>  [<ffffffff81125ad9>] touch_atime+0x107/0x12a
>  [<ffffffff811207b5>] ? filldir+0x0/0xd0
>  [<ffffffff811209ce>] vfs_readdir+0x8f/0xb6
>  [<ffffffff81120b45>] sys_getdents+0x85/0xd8
>  [<ffffffff81002c1b>] system_call_fastpath+0x16/0x1b
> 
> 
> 
> 

