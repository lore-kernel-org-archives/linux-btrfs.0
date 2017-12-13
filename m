Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56721 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750795AbdLMJAg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Dec 2017 04:00:36 -0500
Date: Wed, 13 Dec 2017 16:59:19 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <josef@toxicpanda.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 7/8] btrfs: don't call btrfs_start_delalloc_roots in
 flushoncommit
Message-ID: <20171213085919.GF506@fnst.localdomain>
Reply-To: <1508436962-6851-8-git-send-email-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="raC6veAxrt5nqIoY"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--raC6veAxrt5nqIoY
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

Hi all,

I'm sorry if duplicate emails bother you. (Today I always cannot successfully
send mail to the mailing list.)

I get the following warning about s_umount isn't locked when running xfstests
btrfs/001(kernel: v4.15-rc3, mount_option: flushoncommit).

[  400.276381] WARNING: CPU: 0 PID: 3371 at fs/fs-writeback.c:2339
__writeback_inodes_sb_nr+0xa1/0xb0
[snip]
[  400.300720] Call Trace:
[  400.301400]  btrfs_commit_transaction+0x7f3/0x9d0 [btrfs]
[  400.302384]  btrfs_mksubvol+0x57d/0x590 [btrfs]
[  400.303256]  ? __sb_start_write+0x151/0x1b0
[  400.304096]  ? mnt_want_write_file+0x3b/0xb0
[  400.304935]  btrfs_ioctl_snap_create_transid+0x189/0x190 [btrfs]
[  400.305966]  btrfs_ioctl_snap_create_v2+0x102/0x150 [btrfs]
[  400.307595]  btrfs_ioctl+0x57a/0x2660 [btrfs]
[  400.308406]  ? __lock_acquire+0x761/0x1430
[  400.309189]  ? find_held_lock+0x2d/0x90
[  400.309971]  ? __handle_mm_fault+0x4c3/0x990
[  400.310770]  ? do_vfs_ioctl+0x8e/0x690
[  400.311517]  do_vfs_ioctl+0x8e/0x690
[  400.312211]  SyS_ioctl+0x74/0x80
[  400.312865]  ? __audit_syscall_entry+0x9f/0x100
[  400.313640]  do_syscall_64+0x5c/0x627
[  400.314340]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[  400.315146]  entry_SYSCALL64_slow_path+0x25/0x25

After the initial investigation, the warning is triggered because of the
commit ce8ea7cc6eb3 ("btrfs: don't call btrfs_start_delalloc_roots in
flushoncommit").

It uses writeback_inodes_sb() without locking s_umount, instead of
btrfs_start_delalloc_roots in flushoncommit. However, writeback_inodes_sb will
throw a warning.

static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
enum wb_reason reason, bool skip_if_busy)
{
         [snip]
         WARN_ON(!rwsem_is_locked(&sb->s_umount));
         [snip]
}

-- 
Thanks,
Lu



--raC6veAxrt5nqIoY
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="flushoncommit_dmesg.txt"

[    0.000000] Linux version 4.15.0-rc3+ (luke@sarch) (gcc version 7.2.1 20171128 (GCC)) #29 SMP Wed Dec 13 10:11:18 CST 2017
[    0.000000] Command line: initrd=\intel-ucode.img initrd=\initramfs-custom.img console=tty0 console=ttyS0,38400n8 root=UUID=722d44fd-8aed-40f9-b921-e35906e219aa rw crashkernel=256M
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[3]:  960, xstate_sizes[3]:   64
[    0.000000] x86/fpu: xstate_offset[4]: 1024, xstate_sizes[4]:   64
[    0.000000] x86/fpu: Enabled xstate features 0x1f, context size is 1088 bytes, using 'standard' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ed61fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ed62000-0x000000007edebfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007edec000-0x000000007fe6bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fe6c000-0x000000007fec3fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007fec4000-0x000000007fecbfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007fecc000-0x000000007fecffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007fed0000-0x000000007ff7bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ff7c000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000017fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x7ebd1018-0x7ebda857] usable ==> usable
[    0.000000] e820: update [mem 0x7ebd1018-0x7ebda857] usable ==> usable
[    0.000000] e820: update [mem 0x7eb7a018-0x7ebb5257] usable ==> usable
[    0.000000] e820: update [mem 0x7eb7a018-0x7ebb5257] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x000000007eb7a017] usable
[    0.000000] reserve setup_data: [mem 0x000000007eb7a018-0x000000007ebb5257] usable
[    0.000000] reserve setup_data: [mem 0x000000007ebb5258-0x000000007ebd1017] usable
[    0.000000] reserve setup_data: [mem 0x000000007ebd1018-0x000000007ebda857] usable
[    0.000000] reserve setup_data: [mem 0x000000007ebda858-0x000000007ed61fff] usable
[    0.000000] reserve setup_data: [mem 0x000000007ed62000-0x000000007edebfff] reserved
[    0.000000] reserve setup_data: [mem 0x000000007edec000-0x000000007fe6bfff] usable
[    0.000000] reserve setup_data: [mem 0x000000007fe6c000-0x000000007fec3fff] reserved
[    0.000000] reserve setup_data: [mem 0x000000007fec4000-0x000000007fecbfff] ACPI data
[    0.000000] reserve setup_data: [mem 0x000000007fecc000-0x000000007fecffff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000007fed0000-0x000000007ff7bfff] usable
[    0.000000] reserve setup_data: [mem 0x000000007ff7c000-0x000000008fffffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000017fffffff] usable
[    0.000000] efi: EFI v2.60 by EDK II
[    0.000000] efi:  SMBIOS=0x7fe9d000  ACPI=0x7fecb000  ACPI 2.0=0x7fecb014  MEMATTR=0x7ee25698 
[    0.000000] random: fast init done
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x180000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 base 0800000000 mask F800000000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.000000] e820: last_pfn = 0x7ff7c max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [        (ptrval)] 99000 size 24576
[    0.000000] BRK [0x03821000, 0x03821fff] PGTABLE
[    0.000000] BRK [0x03822000, 0x03822fff] PGTABLE
[    0.000000] BRK [0x03823000, 0x03823fff] PGTABLE
[    0.000000] BRK [0x03824000, 0x03824fff] PGTABLE
[    0.000000] BRK [0x03825000, 0x03825fff] PGTABLE
[    0.000000] BRK [0x03826000, 0x03826fff] PGTABLE
[    0.000000] Secure boot disabled
[    0.000000] RAMDISK: [mem 0x7a60a000-0x7bfbdfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000000007FECB014 000024 (v02 BOCHS )
[    0.000000] ACPI: XSDT 0x000000007FECA0E8 000044 (v01 BOCHS  BXPCFACP 00000001      01000013)
[    0.000000] ACPI: FACP 0x000000007FEC7000 0000F4 (v03 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x000000007FEC8000 001FBD (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x000000007FECE000 000040
[    0.000000] ACPI: APIC 0x000000007FEC6000 000090 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: MCFG 0x000000007FEC5000 00003C (v01 BOCHS  BXPCMCFG 00000001 BXPC 00000001)
[    0.000000] ACPI: BGRT 0x000000007FEC4000 000038 (v01 INTEL  EDK2     00000002      01000013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Reserving 256MB of memory at 640MB for crashkernel (System RAM: 4094MB)
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000017fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000007ed61fff]
[    0.000000]   node   0: [mem 0x000000007edec000-0x000000007fe6bfff]
[    0.000000]   node   0: [mem 0x000000007fed0000-0x000000007ff7bfff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000017fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000017fffffff]
[    0.000000] On node 0 totalpages: 1048109
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 2039 pages reserved
[    0.000000]   DMA zone: 3999 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8123 pages used for memmap
[    0.000000]   DMA32 zone: 519822 pages, LIFO batch:31
[    0.000000]   Normal zone: 8192 pages used for memmap
[    0.000000]   Normal zone: 524288 pages, LIFO batch:31
[    0.000000] Reserved but unavailable: 97 pages
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7eb7a000-0x7eb7afff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ebb5000-0x7ebb5fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ebd1000-0x7ebd1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ebda000-0x7ebdafff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ed62000-0x7edebfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7fe6c000-0x7fec3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7fec4000-0x7fecbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7fecc000-0x7fecffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ff7c000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xffffffff] available for PCI devices
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] percpu: Embedded 486 pages/cpu @        (ptrval) s1951840 r8192 d30624 u2097152
[    0.000000] pcpu-alloc: s1951840 r8192 d30624 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 1029691
[    0.000000] Kernel command line: initrd=\intel-ucode.img initrd=\initramfs-custom.img console=tty0 console=ttyS0,38400n8 root=UUID=722d44fd-8aed-40f9-b921-e35906e219aa rw crashkernel=256M
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Memory: 3692484K/4192436K available (9100K kernel code, 1318K rwdata, 3752K rodata, 3220K init, 14500K bss, 499952K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] ftrace: allocating 35620 entries in 140 pages
[    0.000000] Running RCU self tests
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU event tracing is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] 	RCU callback double-/use-after-free debug enabled.
[    0.000000] 	RCU debug extended QS entry/exit.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] NR_IRQS: 4352, nr_irqs: 456, preallocated irqs: 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 7903 kB
[    0.000000]  per task-struct memory footprint: 3072 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   mixed read-lock/lock-write ABBA:             |FAILED|             |  ok  |
[    0.000000]    mixed read-lock/lock-read ABBA:             |  ok  |             |  ok  |
[    0.000000]  mixed write-lock/lock-write ABBA:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 261 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] kmemleak: Early log buffer exceeded (1005), please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
[    0.000000] ACPI: Core revision 20170831
[    0.000000] ACPI: 1 ACPI AML tables successfully acquired and loaded
[    0.001000] APIC: Switch to symmetric I/O mode setup
[    0.002000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.007000] tsc: Fast TSC calibration using PIT
[    0.008000] tsc: Detected 3191.957 MHz processor
[    0.012000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6383.91 BogoMIPS (lpj=3191957)
[    0.013018] pid_max: default: 32768 minimum: 301
[    0.023332] Security Framework initialized
[    0.024050] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.025012] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.026375] CPU: Physical Processor ID: 0
[    0.026766] mce: CPU supports 10 MCE banks
[    0.027038] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.027622] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.028094] Freeing SMP alternatives memory: 32K
[    0.032623] TSC deadline timer enabled
[    0.032630] smpboot: CPU0: Intel Core Processor (Skylake) (family: 0x6, model: 0x5e, stepping: 0x3)
[    0.033253] Performance Events: unsupported p6 CPU model 94 no PMU driver, software events only.
[    0.034114] Hierarchical SRCU implementation.
[    0.035425] NMI watchdog: Perf event create on CPU 0 failed with -2
[    0.036005] NMI watchdog: Perf NMI watchdog permanently disabled
[    0.036827] smp: Bringing up secondary CPUs ...
[    0.037442] x86: Booting SMP configuration:
[    0.037864] .... node  #0, CPUs:      #1 #2 #3
[    0.223146] smp: Brought up 1 node, 4 CPUs
[    0.224023] smpboot: Max logical packages: 4
[    0.224525] smpboot: Total of 4 processors activated (26290.49 BogoMIPS)
[    0.226607] devtmpfs: initialized
[    0.227816] PM: Registering ACPI NVS region [mem 0x7fecc000-0x7fecffff] (16384 bytes)
[    0.228449] kworker/u8:0 (34) used greatest stack depth: 13856 bytes left
[    0.229542] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.230012] futex hash table entries: 1024 (order: 5, 131072 bytes)
[    0.231083] RTC time:  2:13:56, date: 12/13/17
[    0.232017] NET: Registered protocol family 16
[    0.233000] audit: initializing netlink subsys (disabled)
[    0.233200] audit: type=2000 audit(1513131236.233:1): state=initialized audit_enabled=0 res=1
[    0.235064] kworker/u8:0 (47) used greatest stack depth: 13424 bytes left
[    0.235490] cpuidle: using governor ladder
[    0.236804] cpuidle: using governor menu
[    0.237245] ACPI: bus type PCI registered
[    0.238290] PCI: Using configuration type 1 for base access
[    0.265510] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.268036] ACPI: Added _OSI(Module Device)
[    0.268036] ACPI: Added _OSI(Processor Device)
[    0.269049] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.269482] ACPI: Added _OSI(Processor Aggregator Device)
[    0.299369] ACPI: Interpreter enabled
[    0.299937] ACPI: (supports S0 S5)
[    0.301007] ACPI: Using IOAPIC for interrupt routing
[    0.301856] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.303920] ACPI: Enabled 1 GPEs in block 00 to 3F
[    0.331760] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.332035] acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.333626] acpi PNP0A08:00: _OSC: not requesting OS control; OS requires [ExtendedConfig ASPM ClockPM MSI]
[    0.334279] PCI host bridge to bus 0000:00
[    0.334836] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.335010] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.335898] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.336009] pci_bus 0000:00: root bus resource [mem 0x90000000-0xfebfffff window]
[    0.336999] pci_bus 0000:00: root bus resource [mem 0x800000000-0x800afffff window]
[    0.337009] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.337775] pci 0000:00:00.0: [8086:29c0] type 00 class 0x060000
[    0.338382] pci 0000:00:01.0: [1b36:0100] type 00 class 0x030000
[    0.341020] pci 0000:00:01.0: reg 0x10: [mem 0x94000000-0x97ffffff]
[    0.345028] pci 0000:00:01.0: reg 0x14: [mem 0x90000000-0x93ffffff]
[    0.349036] pci 0000:00:01.0: reg 0x18: [mem 0x99604000-0x99605fff]
[    0.353026] pci 0000:00:01.0: reg 0x1c: [io  0xf2c0-0xf2df]
[    0.365027] pci 0000:00:01.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
[    0.366056] pci 0000:00:01.0: BAR 0: assigned to efifb
[    0.367225] pci 0000:00:02.0: [1b36:000c] type 01 class 0x060400
[    0.372025] pci 0000:00:02.0: reg 0x10: [mem 0x99613000-0x99613fff]
[    0.379640] pci 0000:00:02.1: [1b36:000c] type 01 class 0x060400
[    0.384026] pci 0000:00:02.1: reg 0x10: [mem 0x99612000-0x99612fff]
[    0.391564] pci 0000:00:02.2: [1b36:000c] type 01 class 0x060400
[    0.396012] pci 0000:00:02.2: reg 0x10: [mem 0x99611000-0x99611fff]
[    0.403602] pci 0000:00:02.3: [1b36:000c] type 01 class 0x060400
[    0.408025] pci 0000:00:02.3: reg 0x10: [mem 0x99610000-0x99610fff]
[    0.415565] pci 0000:00:02.4: [1b36:000c] type 01 class 0x060400
[    0.420025] pci 0000:00:02.4: reg 0x10: [mem 0x9960f000-0x9960ffff]
[    0.427564] pci 0000:00:02.5: [1b36:000c] type 01 class 0x060400
[    0.433017] pci 0000:00:02.5: reg 0x10: [mem 0x9960e000-0x9960efff]
[    0.440042] pci 0000:00:02.6: [1b36:000c] type 01 class 0x060400
[    0.445012] pci 0000:00:02.6: reg 0x10: [mem 0x9960d000-0x9960dfff]
[    0.452046] pci 0000:00:02.7: [1b36:000c] type 01 class 0x060400
[    0.457029] pci 0000:00:02.7: reg 0x10: [mem 0x9960c000-0x9960cfff]
[    0.463573] pci 0000:00:03.0: [1b36:000c] type 01 class 0x060400
[    0.469012] pci 0000:00:03.0: reg 0x10: [mem 0x9960b000-0x9960bfff]
[    0.477046] pci 0000:00:03.1: [1b36:000c] type 01 class 0x060400
[    0.482012] pci 0000:00:03.1: reg 0x10: [mem 0x9960a000-0x9960afff]
[    0.489048] pci 0000:00:03.2: [1b36:000c] type 01 class 0x060400
[    0.494028] pci 0000:00:03.2: reg 0x10: [mem 0x99609000-0x99609fff]
[    0.502102] pci 0000:00:03.3: [1b36:000c] type 01 class 0x060400
[    0.507011] pci 0000:00:03.3: reg 0x10: [mem 0x99608000-0x99608fff]
[    0.514081] pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
[    0.516025] pci 0000:00:1b.0: reg 0x10: [mem 0x99600000-0x99603fff]
[    0.533444] pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
[    0.546014] pci 0000:00:1d.0: reg 0x20: [io  0xf2a0-0xf2bf]
[    0.552033] pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
[    0.564009] pci 0000:00:1d.1: reg 0x20: [io  0xf280-0xf29f]
[    0.570397] pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
[    0.583011] pci 0000:00:1d.2: reg 0x20: [io  0xf260-0xf27f]
[    0.590243] pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
[    0.592039] pci 0000:00:1d.7: reg 0x10: [mem 0x99607000-0x99607fff]
[    0.610210] pci 0000:00:1f.0: [8086:2918] type 00 class 0x060100
[    0.610456] pci 0000:00:1f.0: quirk: [io  0x0600-0x067f] claimed by ICH6 ACPI/GPIO/TCO
[    0.611486] pci 0000:00:1f.2: [8086:2922] type 00 class 0x010601
[    0.611623] pci 0000:00:1f.2: reg 0x20: [io  0xf240-0xf25f]
[    0.611643] pci 0000:00:1f.2: reg 0x24: [mem 0x99606000-0x99606fff]
[    0.612058] pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500
[    0.612215] pci 0000:00:1f.3: reg 0x20: [io  0xf200-0xf23f]
[    0.613311] pci 0000:01:00.0: [1af4:1041] type 00 class 0x020000
[    0.619012] pci 0000:01:00.0: reg 0x14: [mem 0x99500000-0x99500fff]
[    0.629010] pci 0000:01:00.0: reg 0x20: [mem 0x800000000-0x800003fff 64bit pref]
[    0.632011] pci 0000:01:00.0: reg 0x30: [mem 0xfffc0000-0xffffffff pref]
[    0.633134] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.633780] pci 0000:00:02.0:   bridge window [mem 0x99500000-0x995fffff]
[    0.633798] pci 0000:00:02.0:   bridge window [mem 0x800000000-0x8000fffff 64bit pref]
[    0.636323] pci 0000:02:00.0: [1af4:1043] type 00 class 0x078000
[    0.641027] pci 0000:02:00.0: reg 0x14: [mem 0x99400000-0x99400fff]
[    0.650030] pci 0000:02:00.0: reg 0x20: [mem 0x800100000-0x800103fff 64bit pref]
[    0.654611] pci 0000:00:02.1: PCI bridge to [bus 02]
[    0.655026] pci 0000:00:02.1:   bridge window [mem 0x99400000-0x994fffff]
[    0.655045] pci 0000:00:02.1:   bridge window [mem 0x800100000-0x8001fffff 64bit pref]
[    0.658287] pci 0000:03:00.0: [1af4:1042] type 00 class 0x010000
[    0.663012] pci 0000:03:00.0: reg 0x14: [mem 0x99200000-0x99200fff]
[    0.672011] pci 0000:03:00.0: reg 0x20: [mem 0x800200000-0x800203fff 64bit pref]
[    0.676097] pci 0000:00:02.2: PCI bridge to [bus 03]
[    0.676852] pci 0000:00:02.2:   bridge window [io  0xf000-0xffff]
[    0.676862] pci 0000:00:02.2:   bridge window [mem 0x99200000-0x993fffff]
[    0.676879] pci 0000:00:02.2:   bridge window [mem 0x800200000-0x8002fffff 64bit pref]
[    0.679316] pci 0000:04:00.0: [1af4:1045] type 00 class 0x00ff00
[    0.692013] pci 0000:04:00.0: reg 0x20: [mem 0x800300000-0x800303fff 64bit pref]
[    0.696245] pci 0000:00:02.3: PCI bridge to [bus 04]
[    0.697018] pci 0000:00:02.3:   bridge window [io  0xe000-0xefff]
[    0.697035] pci 0000:00:02.3:   bridge window [mem 0x99000000-0x991fffff]
[    0.697052] pci 0000:00:02.3:   bridge window [mem 0x800300000-0x8003fffff 64bit pref]
[    0.700310] pci 0000:05:00.0: [1af4:1044] type 00 class 0x00ff00
[    0.713026] pci 0000:05:00.0: reg 0x20: [mem 0x800400000-0x800403fff 64bit pref]
[    0.716626] pci 0000:00:02.4: PCI bridge to [bus 05]
[    0.717019] pci 0000:00:02.4:   bridge window [io  0xd000-0xdfff]
[    0.717030] pci 0000:00:02.4:   bridge window [mem 0x98e00000-0x98ffffff]
[    0.717048] pci 0000:00:02.4:   bridge window [mem 0x800400000-0x8004fffff 64bit pref]
[    0.720307] pci 0000:06:00.0: [8086:f1a5] type 00 class 0x010802
[    0.723016] pci 0000:06:00.0: reg 0x10: [mem 0x98c00000-0x98c03fff 64bit]
[    0.738510] pci 0000:00:02.5: PCI bridge to [bus 06]
[    0.739016] pci 0000:00:02.5:   bridge window [io  0xc000-0xcfff]
[    0.739027] pci 0000:00:02.5:   bridge window [mem 0x98c00000-0x98dfffff]
[    0.742312] pci 0000:07:00.0: [1af4:1042] type 00 class 0x010000
[    0.748015] pci 0000:07:00.0: reg 0x14: [mem 0x98a00000-0x98a00fff]
[    0.758026] pci 0000:07:00.0: reg 0x20: [mem 0x800500000-0x800503fff 64bit pref]
[    0.762087] pci 0000:00:02.6: PCI bridge to [bus 07]
[    0.762931] pci 0000:00:02.6:   bridge window [io  0xb000-0xbfff]
[    0.762941] pci 0000:00:02.6:   bridge window [mem 0x98a00000-0x98bfffff]
[    0.762958] pci 0000:00:02.6:   bridge window [mem 0x800500000-0x8005fffff 64bit pref]
[    0.765320] pci 0000:08:00.0: [1af4:1042] type 00 class 0x010000
[    0.770026] pci 0000:08:00.0: reg 0x14: [mem 0x98800000-0x98800fff]
[    0.779017] pci 0000:08:00.0: reg 0x20: [mem 0x800600000-0x800603fff 64bit pref]
[    0.784587] pci 0000:00:02.7: PCI bridge to [bus 08]
[    0.785018] pci 0000:00:02.7:   bridge window [io  0xa000-0xafff]
[    0.785029] pci 0000:00:02.7:   bridge window [mem 0x98800000-0x989fffff]
[    0.785047] pci 0000:00:02.7:   bridge window [mem 0x800600000-0x8006fffff 64bit pref]
[    0.788322] pci 0000:09:00.0: [1af4:1042] type 00 class 0x010000
[    0.793025] pci 0000:09:00.0: reg 0x14: [mem 0x98600000-0x98600fff]
[    0.802028] pci 0000:09:00.0: reg 0x20: [mem 0x800700000-0x800703fff 64bit pref]
[    0.807578] pci 0000:00:03.0: PCI bridge to [bus 09]
[    0.808018] pci 0000:00:03.0:   bridge window [io  0x9000-0x9fff]
[    0.808028] pci 0000:00:03.0:   bridge window [mem 0x98600000-0x987fffff]
[    0.808045] pci 0000:00:03.0:   bridge window [mem 0x800700000-0x8007fffff 64bit pref]
[    0.811308] pci 0000:0a:00.0: [1af4:1042] type 00 class 0x010000
[    0.816025] pci 0000:0a:00.0: reg 0x14: [mem 0x98400000-0x98400fff]
[    0.825010] pci 0000:0a:00.0: reg 0x20: [mem 0x800800000-0x800803fff 64bit pref]
[    0.830569] pci 0000:00:03.1: PCI bridge to [bus 0a]
[    0.831018] pci 0000:00:03.1:   bridge window [io  0x8000-0x8fff]
[    0.831028] pci 0000:00:03.1:   bridge window [mem 0x98400000-0x985fffff]
[    0.831045] pci 0000:00:03.1:   bridge window [mem 0x800800000-0x8008fffff 64bit pref]
[    0.834265] pci 0000:0b:00.0: [1af4:1042] type 00 class 0x010000
[    0.839026] pci 0000:0b:00.0: reg 0x14: [mem 0x98200000-0x98200fff]
[    0.848017] pci 0000:0b:00.0: reg 0x20: [mem 0x800900000-0x800903fff 64bit pref]
[    0.853569] pci 0000:00:03.2: PCI bridge to [bus 0b]
[    0.854018] pci 0000:00:03.2:   bridge window [io  0x7000-0x7fff]
[    0.854029] pci 0000:00:03.2:   bridge window [mem 0x98200000-0x983fffff]
[    0.854047] pci 0000:00:03.2:   bridge window [mem 0x800900000-0x8009fffff 64bit pref]
[    0.857310] pci 0000:0c:00.0: [1af4:1042] type 00 class 0x010000
[    0.862025] pci 0000:0c:00.0: reg 0x14: [mem 0x98000000-0x98000fff]
[    0.871017] pci 0000:0c:00.0: reg 0x20: [mem 0x800a00000-0x800a03fff 64bit pref]
[    0.875604] pci 0000:00:03.3: PCI bridge to [bus 0c]
[    0.876019] pci 0000:00:03.3:   bridge window [io  0x6000-0x6fff]
[    0.876029] pci 0000:00:03.3:   bridge window [mem 0x98000000-0x981fffff]
[    0.876047] pci 0000:00:03.3:   bridge window [mem 0x800a00000-0x800afffff 64bit pref]
[    0.909011] pci_bus 0000:00: on NUMA node 0
[    0.911934] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.912705] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.913658] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.914647] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.915685] ACPI: PCI Interrupt Link [LNKE] (IRQs 5 *10 11)
[    0.916646] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 *10 11)
[    0.917688] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 10 *11)
[    0.919671] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 10 *11)
[    0.920225] ACPI: PCI Interrupt Link [GSIA] (IRQs *16)
[    0.921000] ACPI: PCI Interrupt Link [GSIB] (IRQs *17)
[    0.921112] ACPI: PCI Interrupt Link [GSIC] (IRQs *18)
[    0.921892] ACPI: PCI Interrupt Link [GSID] (IRQs *19)
[    0.922110] ACPI: PCI Interrupt Link [GSIE] (IRQs *20)
[    0.922888] ACPI: PCI Interrupt Link [GSIF] (IRQs *21)
[    0.923125] ACPI: PCI Interrupt Link [GSIG] (IRQs *22)
[    0.923923] ACPI: PCI Interrupt Link [GSIH] (IRQs *23)
[    0.926323] pci 0000:00:01.0: vgaarb: setting as boot VGA device
[    0.927000] pci 0000:00:01.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.927027] pci 0000:00:01.0: vgaarb: bridge control possible
[    0.927815] vgaarb: loaded
[    0.928564] SCSI subsystem initialized
[    0.929125] libata version 3.00 loaded.
[    0.929212] ACPI: bus type USB registered
[    0.929872] usbcore: registered new interface driver usbfs
[    0.930072] usbcore: registered new interface driver hub
[    0.930855] usbcore: registered new device driver usb
[    0.931132] pps_core: LinuxPPS API ver. 1 registered
[    0.931806] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.932036] PTP clock support registered
[    0.932620] EDAC MC: Ver: 3.0.0
[    0.933632] Registered efivars operations
[    0.934360] PCI: Using ACPI for IRQ routing
[    0.935000] PCI: pci_cache_line_size set to 64 bytes
[    0.935031] pci 0000:00:01.0: can't claim BAR 3 [io  0xf2c0-0xf2df]: address conflict with PCI Bus 0000:03 [io  0xf000-0xffff]
[    0.936148] pci 0000:00:1d.0: can't claim BAR 4 [io  0xf2a0-0xf2bf]: address conflict with PCI Bus 0000:03 [io  0xf000-0xffff]
[    0.937016] pci 0000:00:1d.1: can't claim BAR 4 [io  0xf280-0xf29f]: address conflict with PCI Bus 0000:03 [io  0xf000-0xffff]
[    0.938015] pci 0000:00:1d.2: can't claim BAR 4 [io  0xf260-0xf27f]: address conflict with PCI Bus 0000:03 [io  0xf000-0xffff]
[    0.939029] pci 0000:00:1f.3: can't claim BAR 4 [io  0xf200-0xf23f]: address conflict with PCI Bus 0000:03 [io  0xf000-0xffff]
[    0.940151] pci 0000:00:1f.2: can't claim BAR 4 [io  0xf240-0xf25f]: address conflict with PCI Bus 0000:03 [io  0xf000-0xffff]
[    0.941016] e820: reserve RAM buffer [mem 0x7eb7a018-0x7fffffff]
[    0.941029] e820: reserve RAM buffer [mem 0x7ebd1018-0x7fffffff]
[    0.941035] e820: reserve RAM buffer [mem 0x7ed62000-0x7fffffff]
[    0.941040] e820: reserve RAM buffer [mem 0x7fe6c000-0x7fffffff]
[    0.941045] e820: reserve RAM buffer [mem 0x7ff7c000-0x7fffffff]
[    0.941672] NetLabel: Initializing
[    0.942006] NetLabel:  domain hash size = 128
[    0.942600] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.943084] NetLabel:  unlabeled traffic allowed by default
[    0.944382] clocksource: Switched to clocksource refined-jiffies
[    0.982994] VFS: Disk quotas dquot_6.6.0
[    0.983035] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.984124] pnp: PnP ACPI init
[    0.984920] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.985113] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.985341] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.985909] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.988119] pnp: PnP ACPI: found 4 devices
[    1.001991] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    1.003093] clocksource: Switched to clocksource acpi_pm
[    1.003863] pci 0000:00:01.0: can't claim BAR 6 [mem 0xffff0000-0xffffffff pref]: no compatible bridge window
[    1.005260] pci 0000:01:00.0: can't claim BAR 6 [mem 0xfffc0000-0xffffffff pref]: no compatible bridge window
[    1.016910] pci 0000:00:02.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    1.028382] pci 0000:00:02.1: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    1.078529] pci 0000:00:02.5: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 06] add_size 200000 add_align 100000
[    1.078488] hrtimer: interrupt took 17813996 ns
[    1.148039] pci 0000:00:02.5: BAR 9: assigned [mem 0x99700000-0x998fffff 64bit pref]
[    1.151891] pci 0000:00:01.0: BAR 6: assigned [mem 0x99620000-0x9962ffff pref]
[    1.152817] pci 0000:00:02.0: BAR 7: assigned [io  0x1000-0x1fff]
[    1.153660] pci 0000:00:02.1: BAR 7: assigned [io  0x2000-0x2fff]
[    1.154427] pci 0000:00:1f.3: BAR 4: assigned [io  0x3000-0x303f]
[    1.155262] pci 0000:00:01.0: BAR 3: assigned [io  0x3040-0x305f]
[    1.166966] pci 0000:00:1d.0: BAR 4: assigned [io  0x3060-0x307f]
[    1.180085] pci 0000:00:1d.1: BAR 4: assigned [io  0x3080-0x309f]
[    1.191877] pci 0000:00:1d.2: BAR 4: assigned [io  0x30a0-0x30bf]
[    1.204582] pci 0000:00:1f.2: BAR 4: assigned [io  0x30c0-0x30df]
[    1.207629] pci 0000:01:00.0: BAR 6: assigned [mem 0x99540000-0x9957ffff pref]
[    1.208608] pci 0000:00:02.0: PCI bridge to [bus 01]
[    1.209346] pci 0000:00:02.0:   bridge window [io  0x1000-0x1fff]
[    1.225581] pci 0000:00:02.0:   bridge window [mem 0x99500000-0x995fffff]
[    1.239357] pci 0000:00:02.0:   bridge window [mem 0x800000000-0x8000fffff 64bit pref]
[    1.266423] pci 0000:00:02.1: PCI bridge to [bus 02]
[    1.267322] pci 0000:00:02.1:   bridge window [io  0x2000-0x2fff]
[    1.284366] pci 0000:00:02.1:   bridge window [mem 0x99400000-0x994fffff]
[    1.298253] pci 0000:00:02.1:   bridge window [mem 0x800100000-0x8001fffff 64bit pref]
[    1.322600] pci 0000:00:02.2: PCI bridge to [bus 03]
[    1.325275] pci 0000:00:02.2:   bridge window [io  0xf000-0xffff]
[    1.345374] pci 0000:00:02.2:   bridge window [mem 0x99200000-0x993fffff]
[    1.358720] pci 0000:00:02.2:   bridge window [mem 0x800200000-0x8002fffff 64bit pref]
[    1.385974] pci 0000:00:02.3: PCI bridge to [bus 04]
[    1.386784] pci 0000:00:02.3:   bridge window [io  0xe000-0xefff]
[    1.402641] pci 0000:00:02.3:   bridge window [mem 0x99000000-0x991fffff]
[    1.417407] pci 0000:00:02.3:   bridge window [mem 0x800300000-0x8003fffff 64bit pref]
[    1.442896] pci 0000:00:02.4: PCI bridge to [bus 05]
[    1.443603] pci 0000:00:02.4:   bridge window [io  0xd000-0xdfff]
[    1.460960] pci 0000:00:02.4:   bridge window [mem 0x98e00000-0x98ffffff]
[    1.473760] pci 0000:00:02.4:   bridge window [mem 0x800400000-0x8004fffff 64bit pref]
[    1.498215] pci 0000:00:02.5: PCI bridge to [bus 06]
[    1.500109] pci 0000:00:02.5:   bridge window [io  0xc000-0xcfff]
[    1.517706] pci 0000:00:02.5:   bridge window [mem 0x98c00000-0x98dfffff]
[    1.530454] pci 0000:00:02.5:   bridge window [mem 0x99700000-0x998fffff 64bit pref]
[    1.555542] pci 0000:00:02.6: PCI bridge to [bus 07]
[    1.556244] pci 0000:00:02.6:   bridge window [io  0xb000-0xbfff]
[    1.573842] pci 0000:00:02.6:   bridge window [mem 0x98a00000-0x98bfffff]
[    1.586686] pci 0000:00:02.6:   bridge window [mem 0x800500000-0x8005fffff 64bit pref]
[    1.612143] pci 0000:00:02.7: PCI bridge to [bus 08]
[    1.612901] pci 0000:00:02.7:   bridge window [io  0xa000-0xafff]
[    1.630379] pci 0000:00:02.7:   bridge window [mem 0x98800000-0x989fffff]
[    1.643057] pci 0000:00:02.7:   bridge window [mem 0x800600000-0x8006fffff 64bit pref]
[    1.667578] pci 0000:00:03.0: PCI bridge to [bus 09]
[    1.668454] pci 0000:00:03.0:   bridge window [io  0x9000-0x9fff]
[    1.686134] pci 0000:00:03.0:   bridge window [mem 0x98600000-0x987fffff]
[    1.700511] pci 0000:00:03.0:   bridge window [mem 0x800700000-0x8007fffff 64bit pref]
[    1.725053] pci 0000:00:03.1: PCI bridge to [bus 0a]
[    1.725863] pci 0000:00:03.1:   bridge window [io  0x8000-0x8fff]
[    1.743417] pci 0000:00:03.1:   bridge window [mem 0x98400000-0x985fffff]
[    1.756064] pci 0000:00:03.1:   bridge window [mem 0x800800000-0x8008fffff 64bit pref]
[    1.781324] pci 0000:00:03.2: PCI bridge to [bus 0b]
[    1.782361] pci 0000:00:03.2:   bridge window [io  0x7000-0x7fff]
[    1.799528] pci 0000:00:03.2:   bridge window [mem 0x98200000-0x983fffff]
[    1.811964] pci 0000:00:03.2:   bridge window [mem 0x800900000-0x8009fffff 64bit pref]
[    1.836685] pci 0000:00:03.3: PCI bridge to [bus 0c]
[    1.837396] pci 0000:00:03.3:   bridge window [io  0x6000-0x6fff]
[    1.854577] pci 0000:00:03.3:   bridge window [mem 0x98000000-0x981fffff]
[    1.866837] pci 0000:00:03.3:   bridge window [mem 0x800a00000-0x800afffff 64bit pref]
[    1.891623] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    1.891626] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    1.891628] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    1.891630] pci_bus 0000:00: resource 7 [mem 0x90000000-0xfebfffff window]
[    1.891631] pci_bus 0000:00: resource 8 [mem 0x800000000-0x800afffff window]
[    1.891633] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    1.891635] pci_bus 0000:01: resource 1 [mem 0x99500000-0x995fffff]
[    1.891636] pci_bus 0000:01: resource 2 [mem 0x800000000-0x8000fffff 64bit pref]
[    1.891638] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    1.891640] pci_bus 0000:02: resource 1 [mem 0x99400000-0x994fffff]
[    1.891641] pci_bus 0000:02: resource 2 [mem 0x800100000-0x8001fffff 64bit pref]
[    1.891643] pci_bus 0000:03: resource 0 [io  0xf000-0xffff]
[    1.891645] pci_bus 0000:03: resource 1 [mem 0x99200000-0x993fffff]
[    1.891647] pci_bus 0000:03: resource 2 [mem 0x800200000-0x8002fffff 64bit pref]
[    1.891649] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    1.891650] pci_bus 0000:04: resource 1 [mem 0x99000000-0x991fffff]
[    1.891652] pci_bus 0000:04: resource 2 [mem 0x800300000-0x8003fffff 64bit pref]
[    1.891654] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    1.891655] pci_bus 0000:05: resource 1 [mem 0x98e00000-0x98ffffff]
[    1.891657] pci_bus 0000:05: resource 2 [mem 0x800400000-0x8004fffff 64bit pref]
[    1.891659] pci_bus 0000:06: resource 0 [io  0xc000-0xcfff]
[    1.891660] pci_bus 0000:06: resource 1 [mem 0x98c00000-0x98dfffff]
[    1.891662] pci_bus 0000:06: resource 2 [mem 0x99700000-0x998fffff 64bit pref]
[    1.891664] pci_bus 0000:07: resource 0 [io  0xb000-0xbfff]
[    1.891665] pci_bus 0000:07: resource 1 [mem 0x98a00000-0x98bfffff]
[    1.891667] pci_bus 0000:07: resource 2 [mem 0x800500000-0x8005fffff 64bit pref]
[    1.891669] pci_bus 0000:08: resource 0 [io  0xa000-0xafff]
[    1.891671] pci_bus 0000:08: resource 1 [mem 0x98800000-0x989fffff]
[    1.891672] pci_bus 0000:08: resource 2 [mem 0x800600000-0x8006fffff 64bit pref]
[    1.891674] pci_bus 0000:09: resource 0 [io  0x9000-0x9fff]
[    1.891676] pci_bus 0000:09: resource 1 [mem 0x98600000-0x987fffff]
[    1.891677] pci_bus 0000:09: resource 2 [mem 0x800700000-0x8007fffff 64bit pref]
[    1.891679] pci_bus 0000:0a: resource 0 [io  0x8000-0x8fff]
[    1.891681] pci_bus 0000:0a: resource 1 [mem 0x98400000-0x985fffff]
[    1.891682] pci_bus 0000:0a: resource 2 [mem 0x800800000-0x8008fffff 64bit pref]
[    1.891684] pci_bus 0000:0b: resource 0 [io  0x7000-0x7fff]
[    1.891686] pci_bus 0000:0b: resource 1 [mem 0x98200000-0x983fffff]
[    1.891687] pci_bus 0000:0b: resource 2 [mem 0x800900000-0x8009fffff 64bit pref]
[    1.891689] pci_bus 0000:0c: resource 0 [io  0x6000-0x6fff]
[    1.891691] pci_bus 0000:0c: resource 1 [mem 0x98000000-0x981fffff]
[    1.891692] pci_bus 0000:0c: resource 2 [mem 0x800a00000-0x800afffff 64bit pref]
[    1.891924] NET: Registered protocol family 2
[    1.893195] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    1.894364] TCP bind hash table entries: 32768 (order: 9, 2883584 bytes)
[    1.896386] TCP: Hash tables configured (established 32768 bind 32768)
[    1.897385] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    1.898343] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    1.899493] NET: Registered protocol family 1
[    1.900832] RPC: Registered named UNIX socket transport module.
[    1.901661] RPC: Registered udp transport module.
[    1.902287] RPC: Registered tcp transport module.
[    1.903032] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.903878] pci 0000:00:01.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    1.909525] ACPI: PCI Interrupt Link [GSIA] enabled at IRQ 16
[    1.924633] ACPI: PCI Interrupt Link [GSIB] enabled at IRQ 17
[    1.939398] ACPI: PCI Interrupt Link [GSIC] enabled at IRQ 18
[    1.954323] ACPI: PCI Interrupt Link [GSID] enabled at IRQ 19
[    1.964526] PCI: CLS 0 bytes, default 64
[    1.964783] Unpacking initramfs...
[    2.277487] Freeing initrd memory: 26320K
[    2.278065] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.278873] software IO TLB [mem 0x7660a000-0x7a60a000] (64MB) mapped at [000000008f6f4cd7-00000000ff4d4eeb]
[    2.280186] kvm: no hardware support
[    2.280639] has_svm: not amd
[    2.281025] kvm: no hardware support
[    2.285424] Scanning for low memory corruption every 60 seconds
[    2.288757] Initialise system trusted keyrings
[    2.289639] workingset: timestamp_bits=62 max_order=20 bucket_order=0
[    2.307507] NFS: Registering the id_resolver key type
[    2.308326] Key type id_resolver registered
[    2.308902] Key type id_legacy registered
[    2.313899] Key type asymmetric registered
[    2.314388] Asymmetric key parser 'x509' registered
[    2.314934] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    2.317431] io scheduler noop registered
[    2.317949] io scheduler deadline registered
[    2.318803] io scheduler cfq registered (default)
[    2.319437] io scheduler mq-deadline registered
[    2.320100] io scheduler kyber registered
[    2.326810] ACPI: PCI Interrupt Link [GSIG] enabled at IRQ 22
[    2.368167] ACPI: PCI Interrupt Link [GSIH] enabled at IRQ 23
[    2.384245] efifb: probing for efifb
[    2.384810] efifb: framebuffer at 0x94000000, using 1876k, total 1875k
[    2.385675] efifb: mode is 800x600x32, linelength=3200, pages=1
[    2.386560] efifb: scrolling: redraw
[    2.387072] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    2.389611] Console: switching to colour frame buffer device 100x37
[    2.391249] fb0: EFI VGA frame buffer device
[    2.392186] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.393426] ACPI: Power Button [PWRF]
[    2.456853] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.480312] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    2.496688] Non-volatile memory driver v1.3
[    2.498096] Linux agpgart interface v0.103
[    2.498316] random: crng init done
[    2.510486] loop: module loaded
[    2.516568]  vda: vda1 vda2
[    2.521065]  vdb: vdb1
[    2.525177]  vdc: vdc1
[    2.529782]  vdd: vdd1
[    2.536954]  vde: vde1
[    2.542249]  vdf: vdf1
[    2.546788]  vdg: vdg1
[    2.548900] ahci 0000:00:1f.2: version 3.0
[    2.548917] ahci 0000:00:1f.2: enabling device (0000 -> 0003)
[    2.568171] ahci 0000:00:1f.2: AHCI 0001.0000 32 slots 6 ports 1.5 Gbps 0x3f impl SATA mode
[    2.569722] ahci 0000:00:1f.2: flags: 64bit ncq only 
[    2.579121] scsi host0: ahci
[    2.580652] scsi host1: ahci
[    2.581839] scsi host2: ahci
[    2.583041] scsi host3: ahci
[    2.584861] scsi host4: ahci
[    2.586069] scsi host5: ahci
[    2.586900] ata1: SATA max UDMA/133 abar m4096@0x99606000 port 0x99606100 irq 40
[    2.587982] ata2: SATA max UDMA/133 abar m4096@0x99606000 port 0x99606180 irq 40
[    2.589110] ata3: SATA max UDMA/133 abar m4096@0x99606000 port 0x99606200 irq 40
[    2.590174] ata4: SATA max UDMA/133 abar m4096@0x99606000 port 0x99606280 irq 40
[    2.591249] ata5: SATA max UDMA/133 abar m4096@0x99606000 port 0x99606300 irq 40
[    2.592232] ata6: SATA max UDMA/133 abar m4096@0x99606000 port 0x99606380 irq 40
[    2.593750] tun: Universal TUN/TAP device driver, 1.6
[    2.598952] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    2.600414] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    2.601441] e100: Copyright(c) 1999-2006 Intel Corporation
[    2.602397] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    2.603496] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.604490] sky2: driver version 1.30
[    2.605456] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.606526] ehci-pci: EHCI PCI platform driver
[    2.618554] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    2.619546] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.620869] ehci-pci 0000:00:1d.7: irq 19, io mem 0x99607000
[    2.628245] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.630393] hub 1-0:1.0: USB hub found
[    2.631223] hub 1-0:1.0: 6 ports detected
[    2.633099] uhci_hcd: USB Universal Host Controller Interface driver
[    2.644563] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.645655] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.646764] uhci_hcd 0000:00:1d.0: detected 2 ports
[    2.647708] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00003060
[    2.649487] hub 2-0:1.0: USB hub found
[    2.651179] hub 2-0:1.0: 2 ports detected
[    2.663767] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.664786] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.665886] uhci_hcd 0000:00:1d.1: detected 2 ports
[    2.666809] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00003080
[    2.668531] hub 3-0:1.0: USB hub found
[    2.669292] hub 3-0:1.0: 2 ports detected
[    2.681697] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.683680] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.685777] uhci_hcd 0000:00:1d.2: detected 2 ports
[    2.686824] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000030a0
[    2.688652] hub 4-0:1.0: USB hub found
[    2.689590] hub 4-0:1.0: 2 ports detected
[    2.691090] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.692754] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.693698] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.695308] mousedev: PS/2 mouse device common for all mice
[    2.697219] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    2.699172] rtc_cmos 00:00: RTC can wake from S4
[    2.700514] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.701993] rtc_cmos 00:00: alarms up to one day, y3k, 114 bytes nvram
[    2.708400] i801_smbus 0000:00:1f.3: Enabling SMBus device
[    2.718568] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[    2.729785] device-mapper: uevent: version 1.0.3
[    2.731258] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initialised: dm-devel@redhat.com
[    2.732980] EFI Variables Facility v0.08 2004-May-17
[    2.736135] usbcore: registered new interface driver usbhid
[    2.737083] usbhid: USB HID core driver
[    2.738269] Initializing XFRM netlink socket
[    2.739172] NET: Registered protocol family 17
[    2.740274] Key type dns_resolver registered
[    2.743610] sched_clock: Marking stable (2743039278, 0)->(5782825921, -3039786643)
[    2.746402] registered taskstats version 1
[    2.748251] Loading compiled-in X.509 certificates
[    2.751468]   Magic number: 13:390:207
[    2.903448] ata5: SATA link down (SStatus 0 SControl 300)
[    2.908294] ata3: SATA link down (SStatus 0 SControl 300)
[    2.912332] ata2: SATA link down (SStatus 0 SControl 300)
[    2.915894] ata6: SATA link down (SStatus 0 SControl 300)
[    2.920292] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.924008] ata4: SATA link down (SStatus 0 SControl 300)
[    2.928651] ata1.00: ATAPI: QEMU DVD-ROM, 2.5+, max UDMA/100
[    2.931985] ata1.00: applying bridge limits
[    2.935125] ata1.00: configured for UDMA/100
[    2.940138] scsi 0:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.5+ PQ: 0 ANSI: 5
[    2.959459] sr 0:0:0:0: [sr0] scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    2.962571] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.965161] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    2.969058] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.970920] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.997468] Freeing unused kernel memory: 3220K
[    2.999450] Write protecting the kernel read-only data: 14336k
[    3.002691] Freeing unused kernel memory: 1104K
[    3.005295] Freeing unused kernel memory: 344K
[    3.107046] input: QEMU QEMU USB Tablet as /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/0003:0627:0001.0001/input/input4
[    3.109831] hid-generic 0003:0627:0001.0001: input: USB HID v0.01 Mouse [QEMU QEMU USB Tablet] on usb-0000:00:1d.7-1/input0
[    3.295215] tsc: Refined TSC clocksource calibration: 3192.001 MHz
[    3.297580] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2e02c62e11a, max_idle_ns: 440795368514 ns
[    3.302712] nvme nvme0: pci function 0000:06:00.0
[    3.347356] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[    3.382804] ata_id (1826) used greatest stack depth: 13120 bytes left
[    3.489082] systemd-udevd (1484) used greatest stack depth: 13024 bytes left
[    3.569598]  nvme0n1: p1
[    3.624137] SGI XFS with ACLs, security attributes, realtime, debug enabled
[    3.635788] XFS (dm-0): Mounting V5 Filesystem
[    3.648156] XFS (dm-0): Ending clean mount
[    3.652184] mount (1859) used greatest stack depth: 13016 bytes left
[    3.756058] kworker/u8:5 (1921) used greatest stack depth: 12760 bytes left
[    3.757587] modprobe (1920) used greatest stack depth: 12384 bytes left
[    3.762944] systemd[1]: systemd 235 running in system mode. (+PAM -AUDIT -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN default-hierarchy=hybrid)
[    3.766674] systemd[1]: Detected virtualization kvm.
[    3.767743] systemd[1]: Detected architecture x86-64.
[    3.770248] systemd[1]: Set hostname to <sarch>.
[    3.841156] systemd[1]: File /usr/lib/systemd/system/systemd-journald.service:33 configures an IP firewall (IPAddressDeny=any), but the local system does not support BPF/cgroup based firewalling.
[    3.844039] systemd[1]: Proceeding WITHOUT firewalling in effect!
[    3.853853] systemd[1]: File /usr/lib/systemd/system/systemd-udevd.service:32 configures an IP firewall (IPAddressDeny=any), but the local system does not support BPF/cgroup based firewalling.
[    3.856618] systemd[1]: Proceeding WITHOUT firewalling in effect!
[    3.888684] systemd[1]: File /usr/lib/systemd/system/systemd-logind.service:34 configures an IP firewall (IPAddressDeny=any), but the local system does not support BPF/cgroup based firewalling.
[    3.891600] systemd[1]: Proceeding WITHOUT firewalling in effect!
[    4.193419] systemd-journald[1941]: Received request to flush runtime journal from PID 1
[    4.268921] virtio_net virtio0 enp1s0: renamed from eth0
[    4.305477] clocksource: Switched to clocksource tsc
[    4.389019] raid6: sse2x1   gen() 11890 MB/s
[    4.409021] raid6: sse2x1   xor()  8765 MB/s
[    4.431022] raid6: sse2x2   gen() 14250 MB/s
[    4.449020] raid6: sse2x2   xor()  9980 MB/s
[    4.467031] raid6: sse2x4   gen() 15343 MB/s
[    4.485099] raid6: sse2x4   xor() 10281 MB/s
[    4.503057] raid6: avx2x1   gen() 22460 MB/s
[    4.521046] raid6: avx2x1   xor() 16656 MB/s
[    4.538121] raid6: avx2x2   gen() 29449 MB/s
[    4.542644] Adding 4190204k swap on /dev/mapper/arch_test_os-swap.  Priority:-2 extents:1 across:4190204k 
[    4.555079] raid6: avx2x2   xor() 18757 MB/s
[    4.572017] raid6: avx2x4   gen() 32605 MB/s
[    4.589019] raid6: avx2x4   xor() 19154 MB/s
[    4.589868] raid6: using algorithm avx2x4 gen() 32605 MB/s
[    4.590800] raid6: .... xor() 19154 MB/s, rmw enabled
[    4.592440] raid6: using avx2x2 recovery algorithm
[    4.603057] XFS (dm-1): Mounting V5 Filesystem
[    4.620324] xor: automatically using best checksumming function   avx       
[    4.683873] Btrfs loaded, crc32c=crc32c-generic, debug=on, assert=on
[    4.685513] BTRFS: selftest: sectorsize: 4096  nodesize: 4096
[    4.686470] BTRFS: selftest: Running btrfs free space cache tests
[    4.689143] BTRFS: selftest: Running extent only tests
[    4.690152] BTRFS: selftest: Running bitmap only tests
[    4.691102] BTRFS: selftest: Running bitmap and extent tests
[    4.692356] BTRFS: selftest: Running space stealing from bitmap to extent
[    4.694818] BTRFS: selftest: Free space cache tests finished
[    4.695646] BTRFS: selftest: Running extent buffer operation tests
[    4.696404] BTRFS: selftest: Running btrfs_split_item tests
[    4.697242] BTRFS: selftest: Running extent I/O tests
[    4.697866] BTRFS: selftest: Running find delalloc tests
[    4.816380] BTRFS: selftest: Running extent buffer bitmap tests
[    4.831557] BTRFS: selftest: Extent I/O tests finished
[    4.832350] BTRFS: selftest: Running btrfs_get_extent tests
[    4.833557] BTRFS: selftest: Running hole first btrfs_get_extent test
[    4.834572] BTRFS: selftest: Running outstanding_extents tests
[    4.835617] BTRFS: selftest: Running qgroup tests
[    4.836350] BTRFS: selftest: Qgroup basic add
[    4.837458] BTRFS: selftest: Qgroup multiple refs test
[    4.840935] XFS (dm-1): Ending clean mount
[    4.846716] BTRFS: selftest: Running free space tree tests
[    4.859819] XFS (nvme0n1p1): Mounting V5 Filesystem
[    4.865140] BTRFS: selftest: sectorsize: 4096  nodesize: 8192
[    4.866091] BTRFS: selftest: Running btrfs free space cache tests
[    4.867217] BTRFS: selftest: Running extent only tests
[    4.868513] BTRFS: selftest: Running bitmap only tests
[    4.869398] BTRFS: selftest: Running bitmap and extent tests
[    4.870414] BTRFS: selftest: Running space stealing from bitmap to extent
[    4.871654] BTRFS: selftest: Free space cache tests finished
[    4.872452] BTRFS: selftest: Running extent buffer operation tests
[    4.873307] BTRFS: selftest: Running btrfs_split_item tests
[    4.874183] BTRFS: selftest: Running extent I/O tests
[    4.874917] BTRFS: selftest: Running find delalloc tests
[    4.875850] XFS (nvme0n1p1): Ending clean mount
[    4.992119] BTRFS: selftest: Running extent buffer bitmap tests
[    5.007301] BTRFS: selftest: Extent I/O tests finished
[    5.008056] BTRFS: selftest: Running btrfs_get_extent tests
[    5.009214] BTRFS: selftest: Running hole first btrfs_get_extent test
[    5.010322] BTRFS: selftest: Running outstanding_extents tests
[    5.011391] BTRFS: selftest: Running qgroup tests
[    5.012198] BTRFS: selftest: Qgroup basic add
[    5.013122] BTRFS: selftest: Qgroup multiple refs test
[    5.018143] BTRFS: selftest: Running free space tree tests
[    5.036987] BTRFS: selftest: sectorsize: 4096  nodesize: 16384
[    5.038312] BTRFS: selftest: Running btrfs free space cache tests
[    5.039153] BTRFS: selftest: Running extent only tests
[    5.039938] BTRFS: selftest: Running bitmap only tests
[    5.040743] BTRFS: selftest: Running bitmap and extent tests
[    5.041558] BTRFS: selftest: Running space stealing from bitmap to extent
[    5.042700] BTRFS: selftest: Free space cache tests finished
[    5.043503] BTRFS: selftest: Running extent buffer operation tests
[    5.044314] BTRFS: selftest: Running btrfs_split_item tests
[    5.045126] BTRFS: selftest: Running extent I/O tests
[    5.045835] BTRFS: selftest: Running find delalloc tests
[    5.151791] BTRFS: selftest: Running extent buffer bitmap tests
[    5.165913] BTRFS: selftest: Extent I/O tests finished
[    5.166689] BTRFS: selftest: Running btrfs_get_extent tests
[    5.168607] BTRFS: selftest: Running hole first btrfs_get_extent test
[    5.169569] BTRFS: selftest: Running outstanding_extents tests
[    5.170571] BTRFS: selftest: Running qgroup tests
[    5.171257] BTRFS: selftest: Qgroup basic add
[    5.172074] BTRFS: selftest: Qgroup multiple refs test
[    5.177525] BTRFS: selftest: Running free space tree tests
[    5.192931] BTRFS: selftest: sectorsize: 4096  nodesize: 32768
[    5.193784] BTRFS: selftest: Running btrfs free space cache tests
[    5.194615] BTRFS: selftest: Running extent only tests
[    5.195393] BTRFS: selftest: Running bitmap only tests
[    5.196142] BTRFS: selftest: Running bitmap and extent tests
[    5.197205] BTRFS: selftest: Running space stealing from bitmap to extent
[    5.198744] BTRFS: selftest: Free space cache tests finished
[    5.199583] BTRFS: selftest: Running extent buffer operation tests
[    5.200417] BTRFS: selftest: Running btrfs_split_item tests
[    5.201222] BTRFS: selftest: Running extent I/O tests
[    5.201931] BTRFS: selftest: Running find delalloc tests
[    5.324503] BTRFS: selftest: Running extent buffer bitmap tests
[    5.340941] BTRFS: selftest: Extent I/O tests finished
[    5.342134] BTRFS: selftest: Running btrfs_get_extent tests
[    5.343956] BTRFS: selftest: Running hole first btrfs_get_extent test
[    5.344975] BTRFS: selftest: Running outstanding_extents tests
[    5.346591] BTRFS: selftest: Running qgroup tests
[    5.347198] BTRFS: selftest: Qgroup basic add
[    5.347919] BTRFS: selftest: Qgroup multiple refs test
[    5.351099] BTRFS: selftest: Running free space tree tests
[    5.373544] BTRFS: selftest: sectorsize: 4096  nodesize: 65536
[    5.374933] BTRFS: selftest: Running btrfs free space cache tests
[    5.376454] BTRFS: selftest: Running extent only tests
[    5.377326] BTRFS: selftest: Running bitmap only tests
[    5.378108] BTRFS: selftest: Running bitmap and extent tests
[    5.379034] BTRFS: selftest: Running space stealing from bitmap to extent
[    5.380102] BTRFS: selftest: Free space cache tests finished
[    5.381611] BTRFS: selftest: Running extent buffer operation tests
[    5.382505] BTRFS: selftest: Running btrfs_split_item tests
[    5.383636] BTRFS: selftest: Running extent I/O tests
[    5.384471] BTRFS: selftest: Running find delalloc tests
[    5.506531] BTRFS: selftest: Running extent buffer bitmap tests
[    5.521754] BTRFS: selftest: Extent I/O tests finished
[    5.522539] BTRFS: selftest: Running btrfs_get_extent tests
[    5.523766] BTRFS: selftest: Running hole first btrfs_get_extent test
[    5.524804] BTRFS: selftest: Running outstanding_extents tests
[    5.525873] BTRFS: selftest: Running qgroup tests
[    5.526645] BTRFS: selftest: Qgroup basic add
[    5.527581] BTRFS: selftest: Qgroup multiple refs test
[    5.533107] BTRFS: selftest: Running free space tree tests
[    5.567919] BTRFS: device fsid 4b4c5f58-0185-4d9d-901e-5fd635114a20 devid 2 transid 8 /dev/vdd1
[    5.578432] BTRFS: device fsid 7bb60cad-1869-499e-b8d0-0ef3b7d3f6b4 devid 1 transid 18 /dev/vdc1
[    5.579990] BTRFS: device fsid 51b4662d-4b90-4917-9082-6a2532403f5a devid 1 transid 2875 /dev/vdb1
[  171.165883] audit: type=1006 audit(1513131407.164:2): pid=2725 uid=0 old-auid=4294967295 auid=1001 tty=(none) old-ses=4294967295 ses=1 res=1
[  171.217823] audit: type=1006 audit(1513131407.216:3): pid=2728 uid=0 old-auid=4294967295 auid=1001 tty=(none) old-ses=4294967295 ses=2 res=1
[  397.755871] BTRFS info (device vdb1): disk space caching is enabled
[  397.758867] BTRFS info (device vdb1): has skinny extents
[  398.052580] BTRFS: device fsid 36c0b6e2-24e7-4530-9696-f546dd53cc4e devid 1 transid 5 /dev/vdc1
[  398.268099] BTRFS info (device vdc1): turning on flush-on-commit
[  398.269323] BTRFS info (device vdc1): disk space caching is enabled
[  398.270290] BTRFS info (device vdc1): has skinny extents
[  398.271008] BTRFS info (device vdc1): flagging fs with big metadata feature
[  398.284623] BTRFS info (device vdc1): creating UUID tree
[  398.362882] mount (3078) used greatest stack depth: 12176 bytes left
[  398.621617] umount (3121) used greatest stack depth: 12008 bytes left
[  399.060585] BTRFS info (device vdb1): turning on flush-on-commit
[  399.061909] BTRFS info (device vdb1): disk space caching is enabled
[  399.063215] BTRFS info (device vdb1): has skinny extents
[  399.174503] run fstests btrfs/001 at 2017-12-13 10:20:35
[  399.980514] BTRFS: device fsid 13a40b14-aea6-4bde-90b7-c7f15325325c devid 1 transid 5 /dev/vdc1
[  400.153177] BTRFS info (device vdc1): turning on flush-on-commit
[  400.154527] BTRFS info (device vdc1): disk space caching is enabled
[  400.156227] BTRFS info (device vdc1): has skinny extents
[  400.157770] BTRFS info (device vdc1): flagging fs with big metadata feature
[  400.169556] BTRFS info (device vdc1): creating UUID tree
[  400.276381] WARNING: CPU: 0 PID: 3371 at fs/fs-writeback.c:2339 __writeback_inodes_sb_nr+0xa1/0xb0
[  400.278947] Modules linked in: btrfs xor zstd_decompress zstd_compress xxhash raid6_pq efivarfs xfs nvme nvme_core
[  400.281241] CPU: 0 PID: 3371 Comm: btrfs Not tainted 4.15.0-rc3+ #29
[  400.282625] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  400.284342] RIP: 0010:__writeback_inodes_sb_nr+0xa1/0xb0
[  400.285335] RSP: 0018:ffffc9000193bb78 EFLAGS: 00010246
[  400.286256] RAX: 0000000000000000 RBX: ffff880163106fc8 RCX: 0000000000000000
[  400.287501] RDX: 0000000000000002 RSI: 0000000000004992 RDI: ffff88015d2f67e8
[  400.289478] RBP: ffffc9000193bb7c R08: fffffffffffffff0 R09: 000000000000000f
[  400.291097] R10: ffffc9000193bb70 R11: 0000000000000000 R12: ffff880163100008
[  400.292675] R13: ffff880177a55338 R14: ffff880177a54d48 R15: ffff880177a55438
[  400.294254] FS:  00007ff0d0c9c8c0(0000) GS:ffff88017ae00000(0000) knlGS:0000000000000000
[  400.295766] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  400.296923] CR2: 0000000001f043a8 CR3: 0000000174901005 CR4: 00000000003606f0
[  400.298240] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  400.299543] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  400.300720] Call Trace:
[  400.301400]  btrfs_commit_transaction+0x7f3/0x9d0 [btrfs]
[  400.302384]  btrfs_mksubvol+0x57d/0x590 [btrfs]
[  400.303256]  ? __sb_start_write+0x151/0x1b0
[  400.304096]  ? mnt_want_write_file+0x3b/0xb0
[  400.304935]  btrfs_ioctl_snap_create_transid+0x189/0x190 [btrfs]
[  400.305966]  btrfs_ioctl_snap_create_v2+0x102/0x150 [btrfs]
[  400.307595]  btrfs_ioctl+0x57a/0x2660 [btrfs]
[  400.308406]  ? __lock_acquire+0x761/0x1430
[  400.309189]  ? find_held_lock+0x2d/0x90
[  400.309971]  ? __handle_mm_fault+0x4c3/0x990
[  400.310770]  ? do_vfs_ioctl+0x8e/0x690
[  400.311517]  do_vfs_ioctl+0x8e/0x690
[  400.312211]  SyS_ioctl+0x74/0x80
[  400.312865]  ? __audit_syscall_entry+0x9f/0x100
[  400.313640]  do_syscall_64+0x5c/0x627
[  400.314340]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[  400.315146]  entry_SYSCALL64_slow_path+0x25/0x25
[  400.315927] RIP: 0033:0x7ff0cfaa8337
[  400.316598] RSP: 002b:00007ffdc04aec98 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[  400.317639] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff0cfaa8337
[  400.318630] RDX: 00007ffdc04aece0 RSI: 0000000050009417 RDI: 0000000000000003
[  400.319613] RBP: 0000000000000003 R08: 0000000000000000 R09: 00005578eecb226d
[  400.320584] R10: 000000000000055a R11: 0000000000000202 R12: 00005578eecb2260
[  400.321596] R13: 00007ffdc04b09ed R14: 0000000000000004 R15: 00005578eecb2280
[  400.322577] Code: 48 8b 47 70 48 85 c0 74 22 48 8d 74 24 08 48 89 df 0f b6 d1 e8 91 fc ff ff 48 89 ee 48 89 df e8 e6 fe ff ff 48 83 c4 48 5b 5d c3 <0f> ff eb da 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 31 
[  400.325291] ---[ end trace 596315b3a7f123ff ]---
[  400.516179] WARNING: CPU: 2 PID: 3379 at fs/fs-writeback.c:2339 __writeback_inodes_sb_nr+0xa1/0xb0
[  400.519097] Modules linked in: btrfs xor zstd_decompress zstd_compress xxhash raid6_pq efivarfs xfs nvme nvme_core
[  400.521402] CPU: 2 PID: 3379 Comm: btrfs Tainted: G        W        4.15.0-rc3+ #29
[  400.522815] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  400.524247] RIP: 0010:__writeback_inodes_sb_nr+0xa1/0xb0
[  400.525380] RSP: 0018:ffffc90001973a58 EFLAGS: 00010246
[  400.526498] RAX: 0000000000000000 RBX: ffff880163106fc8 RCX: 0000000000000000
[  400.527938] RDX: 0000000000000002 RSI: 0000000000004a15 RDI: ffff88015d2f67e8
[  400.529286] RBP: ffffc90001973a5c R08: fffffffffffffff0 R09: 000000000000000f
[  400.530656] R10: ffffc90001973a50 R11: 0000000000000000 R12: ffff880163101bf8
[  400.532031] R13: ffff880177a55338 R14: ffff880177d91ba8 R15: ffff880177a55438
[  400.533387] FS:  00007f98ebf478c0(0000) GS:ffff88017b200000(0000) knlGS:0000000000000000
[  400.534878] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  400.536087] CR2: 00005608847612e8 CR3: 0000000154508003 CR4: 00000000003606e0
[  400.537480] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  400.538864] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  400.540190] Call Trace:
[  400.540912]  btrfs_commit_transaction+0x7f3/0x9d0 [btrfs]
[  400.541936]  ? block_rsv_release_bytes+0x20d/0x390 [btrfs]
[  400.542980]  create_subvol+0x78c/0x7ea [btrfs]
[  400.543927]  ? block_rsv_release_bytes+0x2f/0x390 [btrfs]
[  400.544949]  ? btrfs_mksubvol+0x28d/0x590 [btrfs]
[  400.545800]  btrfs_mksubvol+0x28d/0x590 [btrfs]
[  400.546628]  ? rcu_sync_lockdep_assert+0x2b/0x60
[  400.548291]  ? __sb_start_write+0x151/0x1b0
[  400.549082]  ? mnt_want_write_file+0x3b/0xb0
[  400.549898]  btrfs_ioctl_snap_create_transid+0xb9/0x190 [btrfs]
[  400.550894]  ? _copy_from_user+0x63/0x90
[  400.551711]  btrfs_ioctl_snap_create+0x66/0x80 [btrfs]
[  400.552643]  btrfs_ioctl+0x120b/0x2660 [btrfs]
[  400.553500]  ? __lock_acquire+0x761/0x1430
[  400.554267]  ? find_held_lock+0x2d/0x90
[  400.554956]  ? __handle_mm_fault+0x4c3/0x990
[  400.555744]  ? do_vfs_ioctl+0x8e/0x690
[  400.556461]  do_vfs_ioctl+0x8e/0x690
[  400.557137]  SyS_ioctl+0x74/0x80
[  400.557752]  ? __audit_syscall_entry+0x9f/0x100
[  400.558507]  do_syscall_64+0x5c/0x627
[  400.559162]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[  400.559884]  entry_SYSCALL64_slow_path+0x25/0x25
[  400.560629] RIP: 0033:0x7f98ead53337
[  400.561257] RSP: 002b:00007ffd3b8c3458 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[  400.562263] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f98ead53337
[  400.563237] RDX: 00007ffd3b8c3470 RSI: 000000005000940e RDI: 0000000000000003
[  400.564203] RBP: 0000560884758280 R08: 0000000000000000 R09: 000056088475826d
[  400.565195] R10: 000000000000055a R11: 0000000000000202 R12: 0000560884758260
[  400.566184] R13: 0000000000000003 R14: 000056088475826d R15: 00007ffd3b8c3470
[  400.567217] Code: 48 8b 47 70 48 85 c0 74 22 48 8d 74 24 08 48 89 df 0f b6 d1 e8 91 fc ff ff 48 89 ee 48 89 df e8 e6 fe ff ff 48 83 c4 48 5b 5d c3 <0f> ff eb da 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 31 
[  400.569918] ---[ end trace 596315b3a7f12400 ]---
[  400.636338] BTRFS info (device vdc1): setting 2 feature flag
[  400.848267] BTRFS info (device vdc1): turning on flush-on-commit
[  400.852433] BTRFS info (device vdc1): disk space caching is enabled
[  400.856187] BTRFS info (device vdc1): has skinny extents
[  401.069601] BTRFS info (device vdc1): turning on flush-on-commit
[  401.073466] BTRFS info (device vdc1): disk space caching is enabled
[  401.076894] BTRFS info (device vdc1): has skinny extents
[  401.338220] BTRFS info (device vdc1): turning on flush-on-commit
[  401.342601] BTRFS info (device vdc1): disk space caching is enabled
[  401.346161] BTRFS info (device vdc1): has skinny extents
[  401.395554] btrfs (3502) used greatest stack depth: 11776 bytes left
[  401.595921] BTRFS info (device vdc1): turning on flush-on-commit
[  401.600260] BTRFS info (device vdc1): disk space caching is enabled
[  401.603425] BTRFS info (device vdc1): has skinny extents
[  401.824408] BTRFS info (device vdc1): turning on flush-on-commit
[  401.828337] BTRFS info (device vdc1): disk space caching is enabled
[  401.832753] BTRFS info (device vdc1): has skinny extents
[ 4592.608326] kworker/dying (3122) used greatest stack depth: 11456 bytes left

--raC6veAxrt5nqIoY--
