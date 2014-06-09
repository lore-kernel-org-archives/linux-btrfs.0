Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34340 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaFIPRD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jun 2014 11:17:03 -0400
Message-ID: <5395CFE6.10804@oracle.com>
Date: Mon, 09 Jun 2014 11:16:54 -0400
From: Sasha Levin <sasha.levin@oracle.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, jbacik@fb.com
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        linux-btrfs@vger.kernel.org
Subject: btrfs: hang on boot due to tests
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

It seems that some recent changes to btrfs tests make it hang during boot:

[   49.730033] NMI watchdog: BUG: soft lockup - CPU#34 stuck for 23s! [swapper/0:1]
[   49.730033] Modules linked in:
[   49.730033] hardirqs last enabled at (6389143): restore_args (arch/x86/kernel/entry_64.S:829)
[   49.730033] hardirqs last disabled at (6389144): apic_timer_interrupt (arch/x86/kernel/entry_64.S:1021)
[   49.730033] softirqs last enabled at (6389142): __do_softirq (./arch/x86/include/asm/preempt.h:22 kernel/softirq.c:296)
[   49.730033] softirqs last disabled at (6389139): irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
[   49.730033] CPU: 34 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc8-next-20140606-sasha-00021-ga9d3a0b-dirty #597
[   49.730033] task: ffff880628550000 ti: ffff880036218000 task.ti: ffff880036218000
[   49.730033] RIP: __write_lock_failed (arch/x86/lib/rwlock.S:20)
[   49.730033] RSP: 0000:ffff88003621b9e8  EFLAGS: 00000297
[   49.730033] RAX: 0000000000000022 RBX: ffffffff845658fb RCX: 000000059e1d8462
[   49.730033] RDX: 0000000000000003 RSI: ffffffff85907bf4 RDI: ffff8800365c00bc
[   49.730033] RBP: ffff88003621b9e8 R08: 0000000000001b48 R09: ffffffff819618b8
[   49.730033] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88003621b958
[   49.730033] R13: 0000000000000001 R14: ffff880036218000 R15: ffff880628550000
[   49.730033] FS:  0000000000000000(0000) GS:ffff8800a6e00000(0000) knlGS:0000000000000000
[   49.730033] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   49.730033] CR2: 00000000ffffffff CR3: 000000000602e000 CR4: 00000000000006a0
[   49.730033] Stack:
[   49.730033]  ffff88003621ba08 ffffffff811d18de ffff88003621ba68 ffff8800365c00b8
[   49.730033]  ffff88003621ba38 ffffffff84563ac0 ffffffff81961d7c ffffffff81b33a05
[   49.730033]  ffff8800365c0000 ffff8800365c0100 ffff88003621baa8 ffffffff81961d7c
[   49.730033] Call Trace:
[   49.730033] do_raw_write_lock (kernel/locking/spinlock_debug.c:236 kernel/locking/spinlock_debug.c:280)
[   49.730033] _raw_write_lock (include/linux/rwlock_api_smp.h:211 kernel/locking/spinlock.c:295)
[   49.730033] ? btrfs_tree_lock (./arch/x86/include/asm/atomic.h:27 fs/btrfs/locking.c:219)
[   49.730033] ? delay_tsc (./arch/x86/include/asm/preempt.h:98 arch/x86/lib/delay.c:86)
[   49.730033] btrfs_tree_lock (./arch/x86/include/asm/atomic.h:27 fs/btrfs/locking.c:219)
[   49.730033] ? __const_udelay (arch/x86/lib/delay.c:126)
[   49.730033] ? __rcu_read_unlock (kernel/rcu/update.c:97)
[   49.730033] btrfs_lock_root_node (fs/btrfs/ctree.c:193)
[   49.730033] btrfs_search_slot (fs/btrfs/ctree.c:2768)
[   49.730033] btrfs_insert_empty_items (fs/btrfs/ctree.c:4836)
[   49.730033] ? dlm_init (fs/btrfs/super.c:1914)
[   49.730033] insert_normal_tree_ref.constprop.4 (fs/btrfs/tests/qgroup-tests.c:60)
[   49.730033] ? dlm_init (fs/btrfs/super.c:1914)
[   49.730033] test_no_shared_qgroup (fs/btrfs/tests/qgroup-tests.c:249)
[   49.730033] btrfs_test_qgroups (fs/btrfs/tests/qgroup-tests.c:462)
[   49.730033] init_btrfs_fs (fs/btrfs/super.c:1909 fs/btrfs/super.c:1969)
[   49.730033] ? dlm_init (fs/btrfs/super.c:1914)
[   49.730033] do_one_initcall (init/main.c:791)
[   49.730033] ? parse_args (kernel/params.c:120 kernel/params.c:205)
[   49.730033] kernel_init_freeable (init/main.c:856 init/main.c:865 init/main.c:884 init/main.c:1005)
[   49.730033] ? loglevel (init/main.c:241)
[   49.730033] ? rest_init (init/main.c:932)
[   49.730033] kernel_init (init/main.c:937)
[   49.730033] ret_from_fork (arch/x86/kernel/entry_64.S:349)
[   49.730033] ? rest_init (init/main.c:932)
[ 49.730033] Code: 1f 00 48 89 01 31 c0 0f 1f 00 c3 b8 f2 ff ff ff 0f 1f 00 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 f0 ff 07 f3 90 <83> 3f 01 75 f9 f0 ff 0f 75 f1 5d c3 66 66 2e 0f 1f 84 00 00 00
All code
========
   0:	1f                   	(bad)
   1:	00 48 89             	add    %cl,-0x77(%rax)
   4:	01 31                	add    %esi,(%rcx)
   6:	c0 0f 1f             	rorb   $0x1f,(%rdi)
   9:	00 c3                	add    %al,%bl
   b:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  10:	0f 1f 00             	nopl   (%rax)
  13:	c3                   	retq
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	90                   	nop
  1b:	90                   	nop
  1c:	90                   	nop
  1d:	90                   	nop
  1e:	90                   	nop
  1f:	90                   	nop
  20:	90                   	nop
  21:	90                   	nop
  22:	55                   	push   %rbp
  23:	48 89 e5             	mov    %rsp,%rbp
  26:	f0 ff 07             	lock incl (%rdi)
  29:	f3 90                	pause
  2b:*	83 3f 01             	cmpl   $0x1,(%rdi)		<-- trapping instruction
  2e:	75 f9                	jne    0x29
  30:	f0 ff 0f             	lock decl (%rdi)
  33:	75 f1                	jne    0x26
  35:	5d                   	pop    %rbp
  36:	c3                   	retq
  37:	66                   	data16
  38:	66                   	data16
  39:	2e                   	cs
  3a:	0f                   	.byte 0xf
  3b:	1f                   	(bad)
  3c:	84 00                	test   %al,(%rax)
  3e:	00 00                	add    %al,(%rax)
	...

Code starting with the faulting instruction
===========================================
   0:	83 3f 01             	cmpl   $0x1,(%rdi)
   3:	75 f9                	jne    0xfffffffffffffffe
   5:	f0 ff 0f             	lock decl (%rdi)
   8:	75 f1                	jne    0xfffffffffffffffb
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66                   	data16
   d:	66                   	data16
   e:	2e                   	cs
   f:	0f                   	.byte 0xf
  10:	1f                   	(bad)
  11:	84 00                	test   %al,(%rax)
  13:	00 00                	add    %al,(%rax)
	...
[   49.730033] Kernel panic - not syncing: softlockup: hung tasks
[   49.730033] CPU: 34 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc8-next-20140606-sasha-00021-ga9d3a0b-dirty #597
[   49.730033]  ffff880628550000 ffff8800a6e03dd8 ffffffff8451770c 0000000000000001
[   49.730033]  ffffffff856ec784 ffff8800a6e03e58 ffffffff8450952f 0000000000003556
[   49.730033]  ffff880600000008 ffff8800a6e03e68 ffff8800a6e03e08 000000000000353e
[   49.730033] Call Trace:
[   49.730033] <IRQ> dump_stack (lib/dump_stack.c:52)
[   49.730033] panic (kernel/panic.c:119)
[   49.730033] watchdog_timer_fn (kernel/watchdog.c:372)
[   49.730033] __run_hrtimer (kernel/hrtimer.c:1268 (discriminator 2))
[   49.730033] ? watchdog (kernel/hung_task.c:191 kernel/hung_task.c:232)
[   49.730033] hrtimer_interrupt (kernel/hrtimer.c:1915)
[   49.730033] local_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:921)
[   49.730033] ? btrfs_tree_read_lock (./arch/x86/include/asm/atomic.h:27 fs/btrfs/locking.c:103)
[   49.730033] smp_apic_timer_interrupt (./arch/x86/include/asm/apic.h:696 arch/x86/kernel/apic/apic.c:945)
[   49.730033] apic_timer_interrupt (arch/x86/kernel/entry_64.S:1021)
[   49.730033] <EOI> ? retint_restore_args (arch/x86/kernel/entry_64.S:829)
[   49.730033] ? btrfs_tree_read_lock (./arch/x86/include/asm/atomic.h:27 fs/btrfs/locking.c:103)
[   49.730033] ? __write_lock_failed (arch/x86/lib/rwlock.S:20)
[   49.730033] do_raw_write_lock (kernel/locking/spinlock_debug.c:236 kernel/locking/spinlock_debug.c:280)
[   49.730033] _raw_write_lock (include/linux/rwlock_api_smp.h:211 kernel/locking/spinlock.c:295)
[   49.730033] ? btrfs_tree_lock (./arch/x86/include/asm/atomic.h:27 fs/btrfs/locking.c:219)
[   49.730033] ? delay_tsc (./arch/x86/include/asm/preempt.h:98 arch/x86/lib/delay.c:86)
[   49.730033] btrfs_tree_lock (./arch/x86/include/asm/atomic.h:27 fs/btrfs/locking.c:219)
[   49.730033] ? __const_udelay (arch/x86/lib/delay.c:126)
[   49.730033] ? __rcu_read_unlock (kernel/rcu/update.c:97)
[   49.730033] btrfs_lock_root_node (fs/btrfs/ctree.c:193)
[   49.730033] btrfs_search_slot (fs/btrfs/ctree.c:2768)
[   49.730033] btrfs_insert_empty_items (fs/btrfs/ctree.c:4836)
[   49.730033] ? dlm_init (fs/btrfs/super.c:1914)
[   49.730033] insert_normal_tree_ref.constprop.4 (fs/btrfs/tests/qgroup-tests.c:60)
[   49.730033] ? dlm_init (fs/btrfs/super.c:1914)
[   49.730033] test_no_shared_qgroup (fs/btrfs/tests/qgroup-tests.c:249)
[   49.730033] btrfs_test_qgroups (fs/btrfs/tests/qgroup-tests.c:462)
[   49.730033] init_btrfs_fs (fs/btrfs/super.c:1909 fs/btrfs/super.c:1969)
[   49.730033] ? dlm_init (fs/btrfs/super.c:1914)
[   49.730033] do_one_initcall (init/main.c:791)
[   49.730033] ? parse_args (kernel/params.c:120 kernel/params.c:205)
[   49.730033] kernel_init_freeable (init/main.c:856 init/main.c:865 init/main.c:884 init/main.c:1005)
[   49.730033] ? loglevel (init/main.c:241)
[   49.730033] ? rest_init (init/main.c:932)
[   49.730033] kernel_init (init/main.c:937)
[   49.730033] ret_from_fork (arch/x86/kernel/entry_64.S:349)
[   49.730033] ? rest_init (init/main.c:932)
[   49.730033] Dumping ftrace buffer:
[   49.730033]    (ftrace buffer empty)
[   49.730033] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)


Thanks,
Sasha
