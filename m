Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:48501 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab2JWExR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 00:53:17 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so2679240iag.19
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 21:53:17 -0700 (PDT)
MIME-Version: 1.0
From: Shaun Reich <sreich@kde.org>
Date: Tue, 23 Oct 2012 00:52:35 -0400
Message-ID: <CADVynFA7BNjBQqPABwf+OY+JzY+pyJ0J84JtB_9AtbvnzjYdFA@mail.gmail.com>
Subject: IO error after s2ram resume; device stays open
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

dmesg output after a resume from a suspend.

the device in question was /dev/sdb mounted on /home. after a device
failure to resume properly, the link is then reset by the kernel but
comes back as /dev/sde. /dev/sdb disappeared entirely, and is now
referred to as sde.

attempted to remount rw of sde, seemed to succeed, mount/mtab said
that it was rw now but i couldn't write to the volume as it was still
acting like it was ro

(also, the relocates at the tail are due to me attempting to run a
balance on /  --- entirely unrelated)

(please keep me cc'd as i'm not sub'ed)

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.1-1.fc17.x86_64 (mockbuild@) (gcc
version 4.7.2 20120921 (Red Hat 4.7.2-2) (GCC) ) #1 SMP Wed Oct 10
12:13:05 UTC 2012
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.6.1-1.fc17.x86_64
root=UUID=27e70e78-63ff-4a98-bbae-8d02c5db505e ro rd.md=0 rd.lvm=0
rd.dm=0 SYSFONT=True KEYTABLE=us rd.luks=0 LANG=en_US.UTF-8 rhgb quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000cd9c3fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cd9c4000-0x00000000cdf3bfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cdf3c000-0x00000000ce1bbfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ce1bc000-0x00000000ce1c0fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000ce1c1000-0x00000000ce203fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ce204000-0x00000000cec03fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cec04000-0x00000000ceff1fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ceff2000-0x00000000ceffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf800000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./H77
Pro4/MVP, BIOS P1.10 03/19/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x21f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EBFFF uncachable
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   4 base 0CF800000 mask FFF800000 uncachable
[    0.000000]   5 base 21F800000 mask FFF800000 uncachable
[    0.000000]   6 base 21F600000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 8GB, type WB
[    0.000000] reg 1, base: 8GB, range: 512MB, type WB
[    0.000000] reg 2, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 3, base: 3328MB, range: 256MB, type UC
[    0.000000] reg 4, base: 3320MB, range: 8MB, type UC
[    0.000000] reg 5, base: 8696MB, range: 8MB, type UC
[    0.000000] reg 6, base: 8694MB, range: 2MB, type UC
[    0.000000] total RAM covered: 7918M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 256MB, type WB
[    0.000000] reg 3, base: 3320MB, range: 8MB, type UC
[    0.000000] reg 4, base: 4GB, range: 4GB, type WB
[    0.000000] reg 5, base: 8GB, range: 512MB, type WB
[    0.000000] reg 6, base: 8694MB, range: 2MB, type UC
[    0.000000] reg 7, base: 8696MB, range: 8MB, type UC
[    0.000000] e820: update [mem 0xcf800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcf000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fcd00-0x000fcd0f]
mapped at [ffff8800000fcd00]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xceffffff]
[    0.000000]  [mem 0x00000000-0xceffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0xceffffff @ [mem
0x1f983000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x21f5fffff]
[    0.000000]  [mem 0x100000000-0x21f5fffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x21f5fffff @ [mem
0xceff6000-0xceffffff]
[    0.000000] RAMDISK: [mem 0x35eb8000-0x36f53fff]
[    0.000000] ACPI: RSDP 00000000000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000ce1a3080 0007C (v01 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000ce1ac9d8 000F4 (v04 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000ce1a3190 09842 (v02 ALASKA    A M I
00000014 INTL 20051117)
[    0.000000] ACPI: FACS 00000000ce1baf80 00040
[    0.000000] ACPI: APIC 00000000ce1acad0 00092 (v03 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI: ASF! 00000000ce1acb68 000A5 (v32 INTEL       HCG
00000001 TFSM 000F4240)
[    0.000000] ACPI: MCFG 00000000ce1acc10 0003C (v01 ALASKA    A M I
01072009 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000ce1acc50 004A6 (v01 Intel_ AoacTabl
00001000 INTL 20091112)
[    0.000000] ACPI: AAFT 00000000ce1ad0f8 000C2 (v01 ALASKA OEMAAFT
01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000ce1ad1c0 00038 (v01 ALASKA    A M I
01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 00000000ce1ad1f8 0036D (v01 SataRe SataTabl
00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 00000000ce1ad568 009AA (v01  PmRef  Cpu0Ist
00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000ce1adf18 00A92 (v01  PmRef    CpuPm
00003000 INTL 20051117)
[    0.000000] ACPI: BGRT 00000000ce1ae9b0 0003C (v00 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x21f5fffff]
[    0.000000]   NODE_DATA [mem 0x21f5ec000-0x21f5fffff]
[    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD ->
[ffff880217000000-ffff88021ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xcd9c3fff]
[    0.000000]   node   0: [mem 0xce204000-0xcec03fff]
[    0.000000]   node   0: [mem 0xceff2000-0xceffffff]
[    0.000000]   node   0: [mem 0x100000000-0x21f5fffff]
[    0.000000] On node 0 totalpages: 2021214
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 823825 pages, LIFO batch:31
[    0.000000]   Normal zone: 18392 pages used for memmap
[    0.000000]   Normal zone: 1158696 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040004000 - 0000000040005000
[    0.000000] PM: Registered nosave memory: 00000000cd9c4000 - 00000000cdf3c000
[    0.000000] PM: Registered nosave memory: 00000000cdf3c000 - 00000000ce1bc000
[    0.000000] PM: Registered nosave memory: 00000000ce1bc000 - 00000000ce1c1000
[    0.000000] PM: Registered nosave memory: 00000000ce1c1000 - 00000000ce204000
[    0.000000] PM: Registered nosave memory: 00000000cec04000 - 00000000ceff2000
[    0.000000] PM: Registered nosave memory: 00000000cf000000 - 00000000cf800000
[    0.000000] PM: Registered nosave memory: 00000000cf800000 - 00000000dfa00000
[    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed04000
[    0.000000] PM: Registered nosave memory: 00000000fed04000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128
nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88021f200000 s84288
r8192 d22208 u262144
[    0.000000] pcpu-alloc: s84288 r8192 d22208 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 1986432
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:
BOOT_IMAGE=/vmlinuz-3.6.1-1.fc17.x86_64
root=UUID=27e70e78-63ff-4a98-bbae-8d02c5db505e ro rd.md=0 rd.lvm=0
rd.dm=0 SYSFONT=True KEYTABLE=us rd.luks=0 LANG=en_US.UTF-8 rhgb quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 7857612k/8902656k available (6297k kernel code,
817800k absent, 227244k reserved, 6905k data, 1032k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:8448 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 32505856 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 3392.227 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated
using timer frequency.. 6784.45 BogoMIPS (lpj=3392227)
[    0.000003] pid_max: default: 32768 minimum: 301
[    0.000031] Security Framework initialized
[    0.000035] SELinux:  Initializing.
[    0.000040] SELinux:  Starting in permissive mode
[    0.000454] Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.001933] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002578] Mount-cache hash table entries: 256
[    0.002697] Initializing cgroup subsys cpuacct
[    0.002699] Initializing cgroup subsys memory
[    0.002705] Initializing cgroup subsys devices
[    0.002706] Initializing cgroup subsys freezer
[    0.002706] Initializing cgroup subsys net_cls
[    0.002707] Initializing cgroup subsys blkio
[    0.002708] Initializing cgroup subsys perf_event
[    0.002727] CPU: Physical Processor ID: 0
[    0.002727] CPU: Processor Core ID: 0
[    0.002731] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.002731] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.002991] mce: CPU supports 9 MCE banks
[    0.003009] CPU0: Thermal monitoring enabled (TM1)
[    0.003016] process: using mwait in idle threads
[    0.003018] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.003018] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.003018] tlb_flushall_shift is 0x1
[    0.003838] ACPI: Core revision 20120711
[    0.012088] ftrace: allocating 23422 entries in 92 pages
[    0.020300] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.030273] smpboot: CPU0: Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
stepping 09
[    0.131635] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge
events, Intel PMU driver.
[    0.131639] ... version:                3
[    0.131639] ... bit width:              48
[    0.131640] ... generic registers:      4
[    0.131641] ... value mask:             0000ffffffffffff
[    0.131641] ... max period:             000000007fffffff
[    0.131642] ... fixed-purpose events:   3
[    0.131642] ... event mask:             000000070000000f
[    0.132000] NMI watchdog: enabled on all CPUs, permanently consumes
one hw-PMU counter.
[    0.132068] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 OK
[    0.226765] Brought up 8 CPUs
[    0.226767] smpboot: Total of 8 processors activated (54275.63 BogoMIPS)
[    0.233254] devtmpfs: initialized
[    0.233376] PM: Registering ACPI NVS region [mem
0xcdf3c000-0xce1bbfff] (2621440 bytes)
[    0.233400] PM: Registering ACPI NVS region [mem
0xce1c1000-0xce203fff] (274432 bytes)
[    0.233810] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.233834] RTC time:  1:31:06, date: 10/23/12
[    0.233862] NET: Registered protocol family 16
[    0.233966] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    0.233967] ACPI: bus type pci registered
[    0.234004] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.234006] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.239043] PCI: Using configuration type 1 for base access
[    0.239537] bio: create slab <bio-0> at 0
[    0.239580] ACPI: Added _OSI(Module Device)
[    0.239581] ACPI: Added _OSI(Processor Device)
[    0.239581] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.239582] ACPI: Added _OSI(Processor Aggregator Device)
[    0.240436] ACPI: EC: Look up EC in DSDT
[    0.241348] ACPI: Executed 1 blocks of module-level executable AML code
[    0.245578] ACPI: SSDT 00000000cdee9018 0083B (v01  PmRef  Cpu0Cst
00003001 INTL 20051117)
[    0.245790] ACPI: Dynamic OEM Table Load:
[    0.245792] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst
00003001 INTL 20051117)
[    0.248460] ACPI: SSDT 00000000cdeeaa98 00303 (v01  PmRef    ApIst
00003000 INTL 20051117)
[    0.248688] ACPI: Dynamic OEM Table Load:
[    0.248689] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst
00003000 INTL 20051117)
[    0.251372] ACPI: SSDT 00000000cdeebc18 00119 (v01  PmRef    ApCst
00003000 INTL 20051117)
[    0.251583] ACPI: Dynamic OEM Table Load:
[    0.251584] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst
00003000 INTL 20051117)
[    0.254990] ACPI: Interpreter enabled
[    0.254992] ACPI: (supports S0 S1 S3 S4 S5)
[    0.255005] ACPI: Using IOAPIC for interrupt routing
[    0.258380] ACPI: No dock devices found.
[    0.258382] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.258559] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.258809] PCI host bridge to bus 0000:00
[    0.258812] pci_bus 0000:00: busn_res: [bus 00-3e] is inserted
under domain [bus 00-ff]
[    0.258813] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.258814] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.258815] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.258816] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.258817] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.258818] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.258819] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.258820] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.258821] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.258822] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.258823] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    0.258824] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.258830] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.258857] pci 0000:00:02.0: [8086:0162] type 00 class 0x030000
[    0.258864] pci 0000:00:02.0: reg 10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.258868] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.258871] pci 0000:00:02.0: reg 20: [io  0xf000-0xf03f]
[    0.258913] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.258933] pci 0000:00:14.0: reg 10: [mem 0xf7d00000-0xf7d0ffff 64bit]
[    0.259000] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.259021] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.259041] pci 0000:00:16.0: reg 10: [mem 0xf7d1a000-0xf7d1a00f 64bit]
[    0.259112] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.259142] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.259161] pci 0000:00:1a.0: reg 10: [mem 0xf7d18000-0xf7d183ff]
[    0.259245] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.259272] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.259286] pci 0000:00:1b.0: reg 10: [mem 0xf7d10000-0xf7d13fff 64bit]
[    0.259349] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.259374] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.259503] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.259536] pci 0000:00:1c.4: [8086:244e] type 01 class 0x060401
[    0.259610] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.259633] pci 0000:00:1c.5: [8086:1e1a] type 01 class 0x060400
[    0.259707] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.259731] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
[    0.259804] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.259830] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.259850] pci 0000:00:1d.0: reg 10: [mem 0xf7d17000-0xf7d173ff]
[    0.259935] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.259958] pci 0000:00:1f.0: [8086:1e4a] type 00 class 0x060100
[    0.260073] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.260089] pci 0000:00:1f.2: reg 10: [io  0xf0b0-0xf0b7]
[    0.260096] pci 0000:00:1f.2: reg 14: [io  0xf0a0-0xf0a3]
[    0.260103] pci 0000:00:1f.2: reg 18: [io  0xf090-0xf097]
[    0.260111] pci 0000:00:1f.2: reg 1c: [io  0xf080-0xf083]
[    0.260118] pci 0000:00:1f.2: reg 20: [io  0xf060-0xf07f]
[    0.260125] pci 0000:00:1f.2: reg 24: [mem 0xf7d16000-0xf7d167ff]
[    0.260167] pci 0000:00:1f.2: PME# supported from D3hot
[    0.260182] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.260196] pci 0000:00:1f.3: reg 10: [mem 0xf7d15000-0xf7d150ff 64bit]
[    0.260214] pci 0000:00:1f.3: reg 20: [io  0xf040-0xf05f]
[    0.260309] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-3e]
[    0.260311] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.260366] pci_bus 0000:02: busn_res: [bus 02-03] is inserted
under [bus 00-3e]
[    0.260386] pci 0000:02:00.0: [1b21:1080] type 01 class 0x060401
[    0.260538] pci 0000:00:1c.4: PCI bridge to [bus 02-03] (subtractive decode)
[    0.260548] pci 0000:00:1c.4:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.260549] pci 0000:00:1c.4:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.260550] pci 0000:00:1c.4:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.260551] pci 0000:00:1c.4:   bridge window [mem
0x000d0000-0x000d3fff] (subtractive decode)
[    0.260552] pci 0000:00:1c.4:   bridge window [mem
0x000d4000-0x000d7fff] (subtractive decode)
[    0.260553] pci 0000:00:1c.4:   bridge window [mem
0x000d8000-0x000dbfff] (subtractive decode)
[    0.260554] pci 0000:00:1c.4:   bridge window [mem
0x000dc000-0x000dffff] (subtractive decode)
[    0.260555] pci 0000:00:1c.4:   bridge window [mem
0x000e0000-0x000e3fff] (subtractive decode)
[    0.260556] pci 0000:00:1c.4:   bridge window [mem
0x000e4000-0x000e7fff] (subtractive decode)
[    0.260557] pci 0000:00:1c.4:   bridge window [mem
0x000e8000-0x000ebfff] (subtractive decode)
[    0.260558] pci 0000:00:1c.4:   bridge window [mem
0xdfa00000-0xfeafffff] (subtractive decode)
[    0.260606] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 02-03]
[    0.260696] pci 0000:02:00.0: PCI bridge to [bus 03] (subtractive decode)
[    0.260722] pci 0000:02:00.0:   bridge window [??? 0x00000000 flags
0x0] (subtractive decode)
[    0.260723] pci 0000:02:00.0:   bridge window [??? 0x00000000 flags
0x0] (subtractive decode)
[    0.260724] pci 0000:02:00.0:   bridge window [??? 0x00000000 flags
0x0] (subtractive decode)
[    0.260725] pci 0000:02:00.0:   bridge window [??? 0x00000000 flags
0x0] (subtractive decode)
[    0.260726] pci 0000:02:00.0:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.260727] pci 0000:02:00.0:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.260728] pci 0000:02:00.0:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.260729] pci 0000:02:00.0:   bridge window [mem
0x000d0000-0x000d3fff] (subtractive decode)
[    0.260731] pci 0000:02:00.0:   bridge window [mem
0x000d4000-0x000d7fff] (subtractive decode)
[    0.260732] pci 0000:02:00.0:   bridge window [mem
0x000d8000-0x000dbfff] (subtractive decode)
[    0.260733] pci 0000:02:00.0:   bridge window [mem
0x000dc000-0x000dffff] (subtractive decode)
[    0.260734] pci 0000:02:00.0:   bridge window [mem
0x000e0000-0x000e3fff] (subtractive decode)
[    0.260735] pci 0000:02:00.0:   bridge window [mem
0x000e4000-0x000e7fff] (subtractive decode)
[    0.260736] pci 0000:02:00.0:   bridge window [mem
0x000e8000-0x000ebfff] (subtractive decode)
[    0.260737] pci 0000:02:00.0:   bridge window [mem
0xdfa00000-0xfeafffff] (subtractive decode)
[    0.260788] pci_bus 0000:04: busn_res: [bus 04] is inserted under [bus 00-3e]
[    0.260811] pci 0000:04:00.0: [10ec:8168] type 00 class 0x020000
[    0.260829] pci 0000:04:00.0: reg 10: [io  0xe000-0xe0ff]
[    0.260862] pci 0000:04:00.0: reg 18: [mem 0xf0004000-0xf0004fff 64bit pref]
[    0.260882] pci 0000:04:00.0: reg 20: [mem 0xf0000000-0xf0003fff 64bit pref]
[    0.260969] pci 0000:04:00.0: supports D1 D2
[    0.260970] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.262267] pci 0000:00:1c.5: PCI bridge to [bus 04]
[    0.262273] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
[    0.262283] pci 0000:00:1c.5:   bridge window [mem
0xf0000000-0xf00fffff 64bit pref]
[    0.262338] pci_bus 0000:05: busn_res: [bus 05] is inserted under [bus 00-3e]
[    0.262360] pci 0000:05:00.0: [1b21:0612] type 00 class 0x010601
[    0.262377] pci 0000:05:00.0: reg 10: [io  0xd050-0xd057]
[    0.262390] pci 0000:05:00.0: reg 14: [io  0xd040-0xd043]
[    0.262403] pci 0000:05:00.0: reg 18: [io  0xd030-0xd037]
[    0.262416] pci 0000:05:00.0: reg 1c: [io  0xd020-0xd023]
[    0.262428] pci 0000:05:00.0: reg 20: [io  0xd000-0xd01f]
[    0.262441] pci 0000:05:00.0: reg 24: [mem 0xf7c00000-0xf7c001ff]
[    0.264257] pci 0000:00:1c.7: PCI bridge to [bus 05]
[    0.264262] pci 0000:00:1c.7:   bridge window [io  0xd000-0xdfff]
[    0.264268] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.264310] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.264381] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.264400] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.264416] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05.BR40._PRT]
[    0.264440] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.264456] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
[    0.264530]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.264638]  pci0000:00: ACPI _OSC control (0x1c) granted
[    0.267021] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.267050] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.267076] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.267103] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.267129] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12
14 15) *0, disabled.
[    0.267155] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12
14 15) *0, disabled.
[    0.267181] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.267207] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.267255] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.267258] vgaarb: loaded
[    0.267259] vgaarb: bridge control possible 0000:00:02.0
[    0.267297] SCSI subsystem initialized
[    0.267298] ACPI: bus type scsi registered
[    0.267312] libata version 3.00 loaded.
[    0.267326] ACPI: bus type usb registered
[    0.267336] usbcore: registered new interface driver usbfs
[    0.267340] usbcore: registered new interface driver hub
[    0.267349] usbcore: registered new device driver usb
[    0.267376] PCI: Using ACPI for IRQ routing
[    0.268758] PCI: pci_cache_line_size set to 64 bytes
[    0.268814] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.268815] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.268816] e820: reserve RAM buffer [mem 0xcd9c4000-0xcfffffff]
[    0.268817] e820: reserve RAM buffer [mem 0xcec04000-0xcfffffff]
[    0.268818] e820: reserve RAM buffer [mem 0xcf000000-0xcfffffff]
[    0.268819] e820: reserve RAM buffer [mem 0x21f600000-0x21fffffff]
[    0.268869] NetLabel: Initializing
[    0.268869] NetLabel:  domain hash size = 128
[    0.268870] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.268875] NetLabel:  unlabeled traffic allowed by default
[    0.268909] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.268912] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.270919] Switching to clocksource hpet
[    0.274329] pnp: PnP ACPI init
[    0.274335] ACPI: bus type pnp registered
[    0.274470] pnp 00:00: [bus 00-3e]
[    0.274471] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.274472] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.274473] pnp 00:00: [io  0x0d00-0xffff window]
[    0.274475] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.274475] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.274476] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.274477] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.274478] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.274479] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.274480] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.274481] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.274482] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.274483] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.274484] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.274485] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.274486] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.274487] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.274488] pnp 00:00: [mem 0xdfa00000-0xfeafffff window]
[    0.274489] pnp 00:00: [mem 0x00010000-0x0001ffff window]
[    0.274512] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08
PNP0a03 (active)
[    0.274526] pnp 00:01: [mem 0xfed40000-0xfed44fff]
[    0.274543] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.274545] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.274551] pnp 00:02: [io  0x0000-0x001f]
[    0.274552] pnp 00:02: [io  0x0081-0x0091]
[    0.274553] pnp 00:02: [io  0x0093-0x009f]
[    0.274554] pnp 00:02: [io  0x00c0-0x00df]
[    0.274555] pnp 00:02: [dma 4]
[    0.274565] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.274570] pnp 00:03: [mem 0xff000000-0xffffffff]
[    0.274578] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
[    0.274623] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.274634] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.274640] pnp 00:05: [io  0x002e-0x002f]
[    0.274641] pnp 00:05: [io  0x004e-0x004f]
[    0.274642] pnp 00:05: [io  0x0061]
[    0.274643] pnp 00:05: [io  0x0063]
[    0.274644] pnp 00:05: [io  0x0065]
[    0.274645] pnp 00:05: [io  0x0067]
[    0.274645] pnp 00:05: [io  0x0070]
[    0.274646] pnp 00:05: [io  0x0080]
[    0.274647] pnp 00:05: [io  0x0092]
[    0.274648] pnp 00:05: [io  0x00b2-0x00b3]
[    0.274649] pnp 00:05: [io  0x0680-0x069f]
[    0.274650] pnp 00:05: [io  0x0200-0x020f]
[    0.274650] pnp 00:05: [io  0xffff]
[    0.274651] pnp 00:05: [io  0xffff]
[    0.274652] pnp 00:05: [io  0x0400-0x0453]
[    0.274653] pnp 00:05: [io  0x0458-0x047f]
[    0.274654] pnp 00:05: [io  0x0500-0x057f]
[    0.274655] pnp 00:05: [io  0x164e-0x164f]
[    0.274674] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.274675] system 00:05: [io  0x0200-0x020f] has been reserved
[    0.274676] system 00:05: [io  0xffff] has been reserved
[    0.274677] system 00:05: [io  0xffff] has been reserved
[    0.274678] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.274679] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.274680] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.274681] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.274683] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.274687] pnp 00:06: [io  0x0070-0x0077]
[    0.274693] pnp 00:06: [irq 8]
[    0.274703] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.274717] pnp 00:07: [io  0x0454-0x0457]
[    0.274735] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.274736] system 00:07: Plug and Play ACPI device, IDs INT3f0d
PNP0c02 (active)
[    0.274765] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.274766] pnp 00:08: [io  0x0290-0x029f]
[    0.274767] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.274783] system 00:08: [io  0x0290-0x029f] has been reserved
[    0.274785] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.274906] pnp 00:09: [io  0x0010-0x001f]
[    0.274907] pnp 00:09: [io  0x0022-0x003f]
[    0.274908] pnp 00:09: [io  0x0044-0x005f]
[    0.274909] pnp 00:09: [io  0x0062-0x0063]
[    0.274910] pnp 00:09: [io  0x0065-0x006f]
[    0.274910] pnp 00:09: [io  0x0072-0x007f]
[    0.274911] pnp 00:09: [io  0x0080]
[    0.274912] pnp 00:09: [io  0x0084-0x0086]
[    0.274913] pnp 00:09: [io  0x0088]
[    0.274914] pnp 00:09: [io  0x008c-0x008e]
[    0.274916] pnp 00:09: [io  0x0090-0x009f]
[    0.274917] pnp 00:09: [io  0x00a2-0x00bf]
[    0.274917] pnp 00:09: [io  0x00e0-0x00ef]
[    0.274918] pnp 00:09: [io  0x04d0-0x04d1]
[    0.274946] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.274947] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.274952] pnp 00:0a: [io  0x00f0-0x00ff]
[    0.274956] pnp 00:0a: [irq 13]
[    0.274966] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.275067] pnp 00:0b: [io  0x03f8-0x03ff]
[    0.275071] pnp 00:0b: [irq 4]
[    0.275072] pnp 00:0b: [dma 0 disabled]
[    0.275103] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.275223] pnp 00:0c: [mem 0xfed1c000-0xfed1ffff]
[    0.275224] pnp 00:0c: [mem 0xfed10000-0xfed17fff]
[    0.275225] pnp 00:0c: [mem 0xfed18000-0xfed18fff]
[    0.275226] pnp 00:0c: [mem 0xfed19000-0xfed19fff]
[    0.275226] pnp 00:0c: [mem 0xf8000000-0xfbffffff]
[    0.275227] pnp 00:0c: [mem 0xfed20000-0xfed3ffff]
[    0.275228] pnp 00:0c: [mem 0xfed90000-0xfed93fff]
[    0.275229] pnp 00:0c: [mem 0xfed45000-0xfed8ffff]
[    0.275230] pnp 00:0c: [mem 0xff000000-0xffffffff]
[    0.275231] pnp 00:0c: [mem 0xfee00000-0xfeefffff]
[    0.275232] pnp 00:0c: [mem 0xdfa00000-0xdfa00fff]
[    0.275258] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.275259] system 00:0c: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.275260] system 00:0c: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.275262] system 00:0c: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.275263] system 00:0c: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.275264] system 00:0c: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.275265] system 00:0c: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.275266] system 00:0c: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.275267] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    0.275268] system 00:0c: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.275270] system 00:0c: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.275271] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.275356] pnp 00:0d: [mem 0x20000000-0x201fffff]
[    0.275357] pnp 00:0d: [mem 0x40004000-0x40004fff]
[    0.275383] system 00:0d: [mem 0x20000000-0x201fffff] has been reserved
[    0.275384] system 00:0d: [mem 0x40004000-0x40004fff] has been reserved
[    0.275386] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.275400] pnp: PnP ACPI: found 14 devices
[    0.275401] ACPI: ACPI bus type pnp unregistered
[    0.281092] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to
[bus 01] add_size 1000
[    0.281094] pci 0000:00:1c.0: bridge window [mem
0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000
[    0.281095] pci 0000:00:1c.0: bridge window [mem
0x00100000-0x000fffff] to [bus 01] add_size 200000
[    0.281133] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff]
get_res_add_size add_size 200000
[    0.281134] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff
64bit pref] get_res_add_size add_size 200000
[    0.281136] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    0.281138] pci 0000:00:1c.0: BAR 14: assigned [mem 0xdfb00000-0xdfcfffff]
[    0.281141] pci 0000:00:1c.0: BAR 15: assigned [mem
0xdfd00000-0xdfefffff 64bit pref]
[    0.281142] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.281144] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.281146] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.281152] pci 0000:00:1c.0:   bridge window [mem 0xdfb00000-0xdfcfffff]
[    0.281157] pci 0000:00:1c.0:   bridge window [mem
0xdfd00000-0xdfefffff 64bit pref]
[    0.281165] pci 0000:02:00.0: PCI bridge to [bus 03]
[    0.281189] pci 0000:00:1c.4: PCI bridge to [bus 02-03]
[    0.281199] pci 0000:00:1c.5: PCI bridge to [bus 04]
[    0.281202] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
[    0.281208] pci 0000:00:1c.5:   bridge window [mem
0xf0000000-0xf00fffff 64bit pref]
[    0.281214] pci 0000:00:1c.7: PCI bridge to [bus 05]
[    0.281217] pci 0000:00:1c.7:   bridge window [io  0xd000-0xdfff]
[    0.281221] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.281250] pci 0000:02:00.0: setting latency timer to 64
[    0.281264] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.281265] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.281266] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.281267] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.281268] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.281269] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.281270] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.281271] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.281272] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.281273] pci_bus 0000:00: resource 13 [mem 0x000e8000-0x000ebfff]
[    0.281274] pci_bus 0000:00: resource 14 [mem 0xdfa00000-0xfeafffff]
[    0.281275] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.281276] pci_bus 0000:01: resource 1 [mem 0xdfb00000-0xdfcfffff]
[    0.281277] pci_bus 0000:01: resource 2 [mem 0xdfd00000-0xdfefffff
64bit pref]
[    0.281278] pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
[    0.281279] pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
[    0.281280] pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
[    0.281281] pci_bus 0000:02: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.281282] pci_bus 0000:02: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.281283] pci_bus 0000:02: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.281284] pci_bus 0000:02: resource 10 [mem 0x000dc000-0x000dffff]
[    0.281285] pci_bus 0000:02: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.281286] pci_bus 0000:02: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.281287] pci_bus 0000:02: resource 13 [mem 0x000e8000-0x000ebfff]
[    0.281288] pci_bus 0000:02: resource 14 [mem 0xdfa00000-0xfeafffff]
[    0.281289] pci_bus 0000:03: resource 8 [io  0x0000-0x0cf7]
[    0.281290] pci_bus 0000:03: resource 9 [io  0x0d00-0xffff]
[    0.281291] pci_bus 0000:03: resource 10 [mem 0x000a0000-0x000bffff]
[    0.281292] pci_bus 0000:03: resource 11 [mem 0x000d0000-0x000d3fff]
[    0.281293] pci_bus 0000:03: resource 12 [mem 0x000d4000-0x000d7fff]
[    0.281294] pci_bus 0000:03: resource 13 [mem 0x000d8000-0x000dbfff]
[    0.281295] pci_bus 0000:03: resource 14 [mem 0x000dc000-0x000dffff]
[    0.281296] pci_bus 0000:03: resource 15 [mem 0x000e0000-0x000e3fff]
[    0.281297] pci_bus 0000:03: resource 16 [mem 0x000e4000-0x000e7fff]
[    0.281298] pci_bus 0000:03: resource 17 [mem 0x000e8000-0x000ebfff]
[    0.281299] pci_bus 0000:03: resource 18 [mem 0xdfa00000-0xfeafffff]
[    0.281300] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    0.281302] pci_bus 0000:04: resource 2 [mem 0xf0000000-0xf00fffff
64bit pref]
[    0.281303] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.281304] pci_bus 0000:05: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.281326] NET: Registered protocol family 2
[    0.281756] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    0.282612] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.282711] TCP: Hash tables configured (established 524288 bind 65536)
[    0.282719] TCP: reno registered
[    0.282727] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.282747] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.282810] NET: Registered protocol family 1
[    0.282817] pci 0000:00:02.0: Boot video device
[    0.314875] PCI: CLS 64 bytes, default 64
[    0.314918] Unpacking initramfs...
[    0.507439] Freeing initrd memory: 17008k freed
[    0.508962] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.508966] software IO TLB [mem 0xc99c4000-0xcd9c3fff] (64MB)
mapped at [ffff8800c99c4000-ffff8800cd9c3fff]
[    0.511064] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.511241] audit: initializing netlink socket (disabled)
[    0.511252] type=2000 audit(1350955866.391:1): initialized
[    0.523908] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.525008] VFS: Disk quotas dquot_6.5.2
[    0.525032] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.525293] msgmni has been set to 15380
[    0.525327] SELinux:  Registering netfilter hooks
[    0.525771] alg: No test for stdrng (krng)
[    0.525777] NET: Registered protocol family 38
[    0.525797] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[    0.525813] io scheduler noop registered
[    0.525814] io scheduler deadline registered
[    0.525830] io scheduler cfq registered (default)
[    0.525955] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.526076] pcieport 0000:00:1c.5: irq 41 for MSI/MSI-X
[    0.526166] pcieport 0000:00:1c.7: irq 42 for MSI/MSI-X
[    0.526266] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.526271] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.526285] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
[    0.526286] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    0.526290] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
[    0.526303] pcieport 0000:00:1c.7: Signaling PME through PCIe PME interrupt
[    0.526304] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    0.526308] pcie_pme 0000:00:1c.7:pcie01: service driver pcie_pme loaded
[    0.526314] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.526324] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.526324] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.526525] intel_idle: MWAIT substates: 0x1120
[    0.526526] intel_idle: v0.4 model 0x3A
[    0.526527] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.526574] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.526577] ACPI: Power Button [PWRB]
[    0.526594] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.526595] ACPI: Power Button [PWRF]
[    0.526727] ACPI: Requesting acpi_cpufreq
[    0.529074] GHES: HEST is not enabled!
[    0.529108] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.549614] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.570287] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.570476] Non-volatile memory driver v1.3
[    0.570478] Linux agpgart interface v0.103
[    0.570875] loop: module loaded
[    0.570904] ahci 0000:00:1f.2: version 3.0
[    0.570951] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    0.581115] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6
Gbps 0x3f impl SATA mode
[    0.581119] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum
part ems apst
[    0.581134] ahci 0000:00:1f.2: setting latency timer to 64
[    0.591286] scsi0 : ahci
[    0.591327] scsi1 : ahci
[    0.591358] scsi2 : ahci
[    0.591388] scsi3 : ahci
[    0.591420] scsi4 : ahci
[    0.591448] scsi5 : ahci
[    0.591467] ata1: SATA max UDMA/133 abar m2048@0xf7d16000 port
0xf7d16100 irq 43
[    0.591469] ata2: SATA max UDMA/133 abar m2048@0xf7d16000 port
0xf7d16180 irq 43
[    0.591471] ata3: SATA max UDMA/133 abar m2048@0xf7d16000 port
0xf7d16200 irq 43
[    0.591474] ata4: SATA max UDMA/133 abar m2048@0xf7d16000 port
0xf7d16280 irq 43
[    0.591476] ata5: SATA max UDMA/133 abar m2048@0xf7d16000 port
0xf7d16300 irq 43
[    0.591478] ata6: SATA max UDMA/133 abar m2048@0xf7d16000 port
0xf7d16380 irq 43
[    0.591544] ahci 0000:05:00.0: irq 44 for MSI/MSI-X
[    0.591574] ahci: SSS flag set, parallel bus scan disabled
[    0.591627] ahci 0000:05:00.0: AHCI 0001.0200 32 slots 2 ports 6
Gbps 0x3 impl SATA mode
[    0.591629] ahci 0000:05:00.0: flags: 64bit ncq sntf stag led clo
pmp pio slum part ccc sxs
[    0.591775] scsi6 : ahci
[    0.591808] scsi7 : ahci
[    0.591826] ata7: SATA max UDMA/133 abar m512@0xf7c00000 port
0xf7c00100 irq 44
[    0.591829] ata8: SATA max UDMA/133 abar m512@0xf7c00000 port
0xf7c00180 irq 44
[    0.591869] libphy: Fixed MDIO Bus: probed
[    0.591903] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.591921] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.591924] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.591950] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 1
[    0.595823] ehci_hcd 0000:00:1a.0: debug port 2
[    0.595830] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.595841] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7d18000
[    0.601027] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.601048] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.601050] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    0.601052] usb usb1: Product: EHCI Host Controller
[    0.601054] usb usb1: Manufacturer: Linux 3.6.1-1.fc17.x86_64 ehci_hcd
[    0.601056] usb usb1: SerialNumber: 0000:00:1a.0
[    0.601130] hub 1-0:1.0: USB hub found
[    0.601132] hub 1-0:1.0: 2 ports detected
[    0.601172] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.601175] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.601196] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    0.605075] ehci_hcd 0000:00:1d.0: debug port 2
[    0.605081] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.605091] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7d17000
[    0.610998] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.611012] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.611014] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    0.611016] usb usb2: Product: EHCI Host Controller
[    0.611018] usb usb2: Manufacturer: Linux 3.6.1-1.fc17.x86_64 ehci_hcd
[    0.611020] usb usb2: SerialNumber: 0000:00:1d.0
[    0.611088] hub 2-0:1.0: USB hub found
[    0.611090] hub 2-0:1.0: 2 ports detected
[    0.611119] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.611123] uhci_hcd: USB Universal Host Controller Interface driver
[    0.611151] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    0.611154] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.611175] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 3
[    0.611255] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.611257] xhci_hcd 0000:00:14.0: irq 16, io mem 0xf7d00000
[    0.611293] xhci_hcd 0000:00:14.0: irq 45 for MSI/MSI-X
[    0.611329] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.611330] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    0.611331] usb usb3: Product: xHCI Host Controller
[    0.611332] usb usb3: Manufacturer: Linux 3.6.1-1.fc17.x86_64 xhci_hcd
[    0.611333] usb usb3: SerialNumber: 0000:00:14.0
[    0.611372] xHCI xhci_add_endpoint called for root hub
[    0.611373] xHCI xhci_check_bandwidth called for root hub
[    0.611383] hub 3-0:1.0: USB hub found
[    0.611389] hub 3-0:1.0: 4 ports detected
[    0.611422] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.611445] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 4
[    0.611460] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    0.611461] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    0.611462] usb usb4: Product: xHCI Host Controller
[    0.611463] usb usb4: Manufacturer: Linux 3.6.1-1.fc17.x86_64 xhci_hcd
[    0.611464] usb usb4: SerialNumber: 0000:00:14.0
[    0.611499] xHCI xhci_add_endpoint called for root hub
[    0.611500] xHCI xhci_check_bandwidth called for root hub
[    0.611512] hub 4-0:1.0: USB hub found
[    0.611518] hub 4-0:1.0: 4 ports detected
[    0.617005] usbcore: registered new interface driver usbserial
[    0.617014] usbcore: registered new interface driver usbserial_generic
[    0.617030] USB Serial support registered for generic
[    0.617031] usbserial: USB Serial Driver core
[    0.617048] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.619502] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.619505] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.619539] mousedev: PS/2 mouse device common for all mice
[    0.619634] rtc_cmos 00:06: RTC can wake from S4
[    0.619740] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.619766] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.619809] device-mapper: uevent: version 1.0.3
[    0.619842] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25)
initialised: dm-devel@redhat.com
[    0.619937] cpuidle: using governor ladder
[    0.620031] cpuidle: using governor menu
[    0.620080] EFI Variables Facility v0.08 2004-May-17
[    0.620132] usbcore: registered new interface driver usbhid
[    0.620132] usbhid: USB HID core driver
[    0.620147] drop_monitor: Initializing network drop monitor service
[    0.620192] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.620222] TCP: cubic registered
[    0.620225] Initializing XFRM netlink socket
[    0.620291] NET: Registered protocol family 10
[    0.620391] mip6: Mobile IPv6
[    0.620392] NET: Registered protocol family 17
[    0.620698] PM: Hibernation image not present or could not be loaded.
[    0.620704] registered taskstats version 1
[    0.621163]   Magic number: 0:334:509
[    0.621264] rtc_cmos 00:06: setting system clock to 2012-10-23
01:31:06 UTC (1350955866)
[    0.895249] ata6: SATA link down (SStatus 0 SControl 300)
[    0.895257] ata7: SATA link down (SStatus 0 SControl 300)
[    0.895282] ata3: SATA link down (SStatus 0 SControl 300)
[    0.895313] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.895338] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.895359] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.895377] ata5: SATA link down (SStatus 0 SControl 300)
[    0.896302] ata4.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.896307] ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    0.896310] ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    0.896908] ata4.00: HPA detected: current 488395055, native 488397168
[    0.896914] ata4.00: ATA-7: WDC WD2500KS-00MJB0, 02.01C03, max UDMA/133
[    0.896916] ata4.00: 488395055 sectors, multi 16: LBA48
[    0.897936] ata4.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.897941] ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    0.897944] ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    0.898534] ata4.00: configured for UDMA/133
[    0.902211] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    0.907157] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.907164] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    0.907169] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    0.907195] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.907201] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    0.907206] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    0.917001] ata1.00: ATA-8: MKNSSDCR120GB, 501ABBF0, max UDMA/133
[    0.917005] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.917174] ata2.00: ATA-8: MKNSSDCL120GB-DX, 332ABBF0, max UDMA/133
[    0.917178] ata2.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.927070] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.927100] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    0.927105] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    0.927113] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.927118] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    0.927123] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    0.936947] ata1.00: configured for UDMA/133
[    0.937111] ata2.00: configured for UDMA/133
[    0.937213] scsi 0:0:0:0: Direct-Access     ATA      MKNSSDCR120GB
  501A PQ: 0 ANSI: 5
[    0.937452] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks:
(120 GB/111 GiB)
[    0.937504] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.937509] sd 0:0:0:0: [sda] Write Protect is off
[    0.937512] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.937530] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    0.937922] scsi 1:0:0:0: Direct-Access     ATA
MKNSSDCL120GB-DX 332A PQ: 0 ANSI: 5
[    0.937990]  sda: sda1 sda2
[    0.938239] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    0.937729] ACPI: Invalid Power Resource to register!
[    0.938276] sd 1:0:0:0: [sdb] 234441648 512-byte logical blocks:
(120 GB/111 GiB)
[    0.938407] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.938423] sd 1:0:0:0: [sdb] Write Protect is off
[    0.938429] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.938480] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    0.938633] scsi 3:0:0:0: Direct-Access     ATA      WDC
WD2500KS-00M 02.0 PQ: 0 ANSI: 5
[    0.938812] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    0.938815] sd 3:0:0:0: [sdc] 488395055 512-byte logical blocks:
(250 GB/232 GiB)
[    0.938438] ACPI: Invalid Power Resource to register!
[    0.938947] ACPI: Invalid Power Resource to register!<5>[
0.939004] sd 3:0:0:0: [sdc] Write Protect is off
[    0.939009] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    0.939062] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    0.939274]  sdb: unknown partition table
[    0.939704] sd 1:0:0:0: [sdb] Attached SCSI disk
[    0.946933]  sdc: sdc1
[    0.947510] sd 3:0:0:0: [sdc] Attached SCSI disk
[    1.016309] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.016314] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.016629] hub 1-1:1.0: USB hub found
[    1.016723] hub 1-1:1.0: 6 ports detected
[    1.118606] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.232598] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.232602] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.232884] hub 2-1:1.0: USB hub found
[    1.232979] hub 2-1:1.0: 8 ports detected
[    1.242253] ata8: SATA link down (SStatus 0 SControl 300)
[    1.244346] Freeing unused kernel memory: 1032k freed
[    1.244501] Write protecting the kernel read-only data: 12288k
[    1.251237] Freeing unused kernel memory: 1884k freed
[    1.256608] Freeing unused kernel memory: 1428k freed
[    1.307112] usb 1-1.5: new low-speed USB device number 3 using ehci_hcd
[    1.311725] dracut: dracut-018-98.git20120813.fc17
[    1.341418] dracut: rd.luks=0: removing cryptoluks activation
[    1.350146] udevd[170]: starting version 182
[    1.372845] [drm] Initialized drm 1.1.0 20060810
[    1.376559] pci 0000:00:00.0: Intel Ivybridge Chipset
[    1.376676] pci 0000:00:00.0: detected gtt size: 2097152K total,
262144K mappable
[    1.379005] pci 0000:00:00.0: detected 262144K stolen memory
[    1.379079] i915 0000:00:02.0: setting latency timer to 64
[    1.413672] usb 1-1.5: New USB device found, idVendor=04f2, idProduct=0402
[    1.413676] usb 1-1.5: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    1.413679] usb 1-1.5: Product: USB Keyboard
[    1.413698] usb 1-1.5: Manufacturer: Chicony
[    1.423421] input: Chicony USB Keyboard as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5:1.0/input/input2
[    1.423566] hid-generic 0003:04F2:0402.0001: input,hidraw0: USB HID
v1.11 Keyboard [Chicony USB Keyboard] on usb-0000:00:1a.0-1.5/input0
[    1.432320] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[    1.432330] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.432331] [drm] Driver supports precise vblank timestamp query.
[    1.432369] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.444630] input: Chicony USB Keyboard as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5:1.1/input/input3
[    1.444749] hid-generic 0003:04F2:0402.0002: input,hiddev0,hidraw1:
USB HID v1.11 Device [Chicony USB Keyboard] on
usb-0000:00:1a.0-1.5/input1
[    1.507460] tsc: Refined TSC clocksource calibration: 3392.293 MHz
[    1.507465] Switching to clocksource tsc
[    1.528347] usb 1-1.6: new full-speed USB device number 4 using ehci_hcd
[    1.529771] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    1.614872] usb 1-1.6: New USB device found, idVendor=e0ff, idProduct=0002
[    1.614877] usb 1-1.6: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    1.614879] usb 1-1.6: Product: G3
[    1.614881] usb 1-1.6: Manufacturer: A.....
[    1.616457] input: A..... G3 as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input4
[    1.616718] hid-generic 0003:E0FF:0002.0003: input,hidraw2: USB HID
v1.00 Mouse [A..... G3] on usb-0000:00:1a.0-1.6/input0
[    1.618727] input: A..... G3 as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.1/input/input5
[    1.619128] hid-generic 0003:E0FF:0002.0004: input,hiddev0,hidraw3:
USB HID v1.00 Keyboard [A..... G3] on usb-0000:00:1a.0-1.6/input1
[    1.642078] [drm] GMBUS [i915 gmbus dpc] timed out, falling back to
bit banging on pin 4
[    1.692025] usb 2-1.8: new high-speed USB device number 3 using ehci_hcd
[    1.790370] usb 2-1.8: New USB device found, idVendor=0bc2, idProduct=3000
[    1.790375] usb 2-1.8: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[    1.790377] usb 2-1.8: Product: FreeAgentDesktop
[    1.790379] usb 2-1.8: Manufacturer: Seagate
[    1.790381] usb 2-1.8: SerialNumber:             6QE0W5FN
[    1.797921] Initializing USB Mass Storage driver...
[    1.798176] scsi8 : usb-storage 2-1.8:1.0
[    1.798269] usbcore: registered new interface driver usb-storage
[    1.798271] USB Mass Storage support registered.
[    1.828862] fbcon: inteldrmfb (fb0) is primary device
[    1.994262] Console: switching to colour frame buffer device 240x67
[    2.000158] fb0: inteldrmfb frame buffer device
[    2.000160] drm: registered panic notifier
[    2.005316] acpi device:43: registered as cooling_device8
[    2.005397] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.005427] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
[    2.005576] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.009233] dracut: Starting plymouth daemon
[    2.345860] dracut: rd.dm=0: removing DM RAID activation
[    2.355378] dracut: rd.md=0: removing MD RAID activation
[    2.424243] Btrfs loaded
[    2.425456] device label HOME devid 1 transid 67037 /dev/sdb
[    2.431397] device label ROOT devid 1 transid 25347 /dev/sda2
[    2.559587] dracut: Checking, if btrfs device complete
[    2.569593] device label ROOT devid 1 transid 25347 /dev/sda2
[    2.569897] btrfs: disk space caching is enabled
[    2.571873] btrfs: bdev /dev/sda2 errs: wr 0, rd 0, flush 0, corrupt 7, gen 0
[    2.600756] Btrfs detected SSD devices, enabling SSD mode
[    2.638326] device label ROOT devid 1 transid 25347 /dev/sda2
[    2.638659] btrfs: disk space caching is enabled
[    2.640625] btrfs: bdev /dev/sda2 errs: wr 0, rd 0, flush 0, corrupt 7, gen 0
[    2.671313] Btrfs detected SSD devices, enabling SSD mode
[    2.716435] dracut: Checking btrfs:
/dev/disk/by-uuid/27e70e78-63ff-4a98-bbae-8d02c5db505e
[    2.716711] dracut: Remounting
/dev/disk/by-uuid/27e70e78-63ff-4a98-bbae-8d02c5db505e with -o ro
[    2.719935] device label ROOT devid 1 transid 25347 /dev/sda2
[    2.720260] btrfs: disk space caching is enabled
[    2.722345] btrfs: bdev /dev/sda2 errs: wr 0, rd 0, flush 0, corrupt 7, gen 0
[    2.751960] Btrfs detected SSD devices, enabling SSD mode
[    2.757055] dracut: Mounted root filesystem /dev/sda2
[    2.792753] dracut: Switching root
[    2.798587] scsi 8:0:0:0: Direct-Access     Seagate
FreeAgentDesktop 100D PQ: 0 ANSI: 4
[    2.799452] sd 8:0:0:0: Attached scsi generic sg3 type 0
[    2.801596] sd 8:0:0:0: [sdd] 488397168 512-byte logical blocks:
(250 GB/232 GiB)
[    2.803100] sd 8:0:0:0: [sdd] Write Protect is off
[    2.803106] sd 8:0:0:0: [sdd] Mode Sense: 1c 00 00 00
[    2.804685] sd 8:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.812696]  sdd: sdd1 sdd2
[    2.819035] sd 8:0:0:0: [sdd] Attached SCSI disk
[    2.845190] SELinux:  Disabled at runtime.
[    2.845202] SELinux:  Unregistering netfilter hooks
[    2.892481] type=1404 audit(1350955868.777:2): selinux=0
auid=4294967295 ses=4294967295
[    3.226698] udevd[437]: starting version 182
[    3.304194] mei 0000:00:16.0: setting latency timer to 64
[    3.304270] mei 0000:00:16.0: irq 47 for MSI/MSI-X
[    3.310466] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.310692] r8169 0000:04:00.0: irq 48 for MSI/MSI-X
[    3.310837] r8169 0000:04:00.0: eth0: RTL8168evl/8111evl at
0xffffc900055e4000, bc:5f:f4:2b:f0:2f, XID 0c900800 IRQ 48
[    3.310840] r8169 0000:04:00.0: eth0: jumbo features [frames: 9200
bytes, tx checksumming: ko]
[    3.311250] mei 0000:00:16.0: wd: failed to find the client
[    3.312674] ACPI Warning: 0x0000000000000428-0x000000000000042f
SystemIO conflicts with Region \PMIO 1 (20120711/utaddress-251)
[    3.312689] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    3.312692] ACPI Warning: 0x0000000000000500-0x000000000000053f
SystemIO conflicts with Region \GPR2 1 (20120711/utaddress-251)
[    3.312695] ACPI Warning: 0x0000000000000500-0x000000000000053f
SystemIO conflicts with Region \GPIO 2 (20120711/utaddress-251)
[    3.312698] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    3.312699] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    3.315529] ACPI Warning: 0x000000000000f040-0x000000000000f05f
SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1
(20120711/utaddress-251)
[    3.315534] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    3.315552] ALSA sound/pci/hda/hda_intel.c:2748 Using COMBO position fix
[    3.315595] snd_hda_intel 0000:00:1b.0: irq 49 for MSI/MSI-X
[    3.319124] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x10
[    3.340953] iTCO_vendor_support: vendor-support=0
[    3.341096] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    3.341123] iTCO_wdt: Found a Panther Point TCO device (Version=2,
TCOBASE=0x0460)
[    3.341195] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    3.348710] microcode: CPU0 updated to revision 0x12, date = 2012-04-12
[    3.348719] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x10
[    3.349104] microcode: CPU1 updated to revision 0x12, date = 2012-04-12
[    3.349109] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x10
[    3.349479] microcode: CPU2 updated to revision 0x12, date = 2012-04-12
[    3.349502] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x10
[    3.349903] microcode: CPU3 updated to revision 0x12, date = 2012-04-12
[    3.349908] microcode: CPU4 sig=0x306a9, pf=0x2, revision=0x10
[    3.350441] microcode: CPU4 updated to revision 0x12, date = 2012-04-12
[    3.350447] microcode: CPU5 sig=0x306a9, pf=0x2, revision=0x10
[    3.350930] microcode: CPU5 updated to revision 0x12, date = 2012-04-12
[    3.350954] microcode: CPU6 sig=0x306a9, pf=0x2, revision=0x10
[    3.351454] microcode: CPU6 updated to revision 0x12, date = 2012-04-12
[    3.351460] microcode: CPU7 sig=0x306a9, pf=0x2, revision=0x10
[    3.351861] microcode: CPU7 updated to revision 0x12, date = 2012-04-12
[    3.352003] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.368359] btrfs: disk space caching is enabled
[    3.374034] btrfs: unlinked 18 orphans
[    3.609558] device label HOME devid 1 transid 67037 /dev/sdb
[    3.609833] btrfs: disk space caching is enabled
[    3.612137] btrfs: bdev /dev/sdb errs: wr 0, rd 0, flush 0, corrupt 24, gen 0
[    3.647002] Btrfs detected SSD devices, enabling SSD mode
[    3.650323] btrfs: unlinked 3 orphans
[    3.655040] device label ROOT devid 1 transid 25347 /dev/sda2
[    3.835770] ALSA sound/pci/hda/patch_realtek.c:1271 SKU: Nid=0x1d
sku_cfg=0x4005e601
[    3.835772] ALSA sound/pci/hda/patch_realtek.c:1273 SKU:
port_connectivity=0x1
[    3.835773] ALSA sound/pci/hda/patch_realtek.c:1274 SKU: enable_pcbeep=0x0
[    3.835774] ALSA sound/pci/hda/patch_realtek.c:1275 SKU: check_sum=0x00000005
[    3.835775] ALSA sound/pci/hda/patch_realtek.c:1276 SKU:
customization=0x000000e6
[    3.835775] ALSA sound/pci/hda/patch_realtek.c:1277 SKU: external_amp=0x0
[    3.835776] ALSA sound/pci/hda/patch_realtek.c:1278 SKU: platform_type=0x0
[    3.835777] ALSA sound/pci/hda/patch_realtek.c:1279 SKU: swap=0x0
[    3.835778] ALSA sound/pci/hda/patch_realtek.c:1280 SKU: override=0x1
[    3.835781] ALSA sound/pci/hda/hda_auto_parser.c:322 autoconfig:
line_outs=3 (0x14/0x15/0x16/0x0/0x0) type:line
[    3.835782] ALSA sound/pci/hda/hda_auto_parser.c:326
speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.835782] ALSA sound/pci/hda/hda_auto_parser.c:330    hp_outs=1
(0x1b/0x0/0x0/0x0/0x0)
[    3.835783] ALSA sound/pci/hda/hda_auto_parser.c:331    mono: mono_out=0x0
[    3.835784] ALSA sound/pci/hda/hda_auto_parser.c:334    dig-out=0x1e/0x0
[    3.835785] ALSA sound/pci/hda/hda_auto_parser.c:335    inputs:
[    3.835786] ALSA sound/pci/hda/hda_auto_parser.c:339      Rear Mic=0x18
[    3.835787] ALSA sound/pci/hda/hda_auto_parser.c:339      Front Mic=0x19
[    3.835788] ALSA sound/pci/hda/hda_auto_parser.c:339      Line=0x1a
[    3.837797] ALSA sound/pci/hda/patch_realtek.c:1334 realtek: No
valid SSID, checking pincfg 0x4005e601 for NID 0x1d
[    3.837798] ALSA sound/pci/hda/patch_realtek.c:1350 realtek:
Enabling init ASM_ID=0xe601 CODEC_ID=10ec0892
[    3.848364] input: HDA Intel PCH HDMI/DP,pcm=7 as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    3.848417] input: HDA Intel PCH HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    3.848443] input: HDA Intel PCH Line as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    3.848469] input: HDA Intel PCH Rear Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    3.848495] input: HDA Intel PCH Line Out CLFE as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    3.848521] input: HDA Intel PCH Line Out Surround as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    3.848546] input: HDA Intel PCH Line Out Front as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    4.043923] EXT4-fs (sda1): mounted filesystem with ordered data
mode. Opts: (null)
[    5.227878] EXT4-fs (sdc1): mounted filesystem with ordered data
mode. Opts: (null)
[    5.361885] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.377993] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    6.005690] r8169 0000:04:00.0: p5p1: link down
[    6.005719] r8169 0000:04:00.0: p5p1: link down
[    6.005734] IPv6: ADDRCONF(NETDEV_UP): p5p1: link is not ready
[    6.142146] Bluetooth: Core ver 2.16
[    6.142176] NET: Registered protocol family 31
[    6.142179] Bluetooth: HCI device and connection manager initialized
[    6.142181] Bluetooth: HCI socket layer initialized
[    6.142183] Bluetooth: L2CAP socket layer initialized
[    6.142188] Bluetooth: SCO socket layer initialized
[    6.145712] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.145716] Bluetooth: BNEP filters: protocol multicast
[    6.146503] RPC: Registered named UNIX socket transport module.
[    6.146507] RPC: Registered udp transport module.
[    6.146509] RPC: Registered tcp transport module.
[    6.146511] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    7.655383] r8169 0000:04:00.0: p5p1: link up
[    7.655394] IPv6: ADDRCONF(NETDEV_CHANGE): p5p1: link becomes ready
[   10.880592] fuse init (API version 7.20)
[14576.243398] r8169 0000:04:00.0: p5p1: link down
[14581.013125] r8169 0000:04:00.0: p5p1: link up
[23776.969280] ip6_tables: (C) 2000-2006 Netfilter Core Team
[23779.086265] lp: driver loaded but no devices found
[24874.418626] ip6_tables: (C) 2000-2006 Netfilter Core Team
[25910.179837] ip6_tables: (C) 2000-2006 Netfilter Core Team
[32009.660958] PM: Syncing filesystems ... done.
[32009.665619] PM: Preparing system for mem sleep
[32009.744370] Freezing user space processes ... (elapsed 0.01 seconds) done.
[32009.755369] Freezing remaining freezable tasks ... (elapsed 0.01
seconds) done.
[32009.766328] PM: Entering mem sleep
[32009.766443] Suspending console(s) (use no_console_suspend to debug)
[32009.766581] sd 8:0:0:0: [sdd] Synchronizing SCSI cache
[32009.767167] sd 3:0:0:0: [sdc] Synchronizing SCSI cache
[32009.767244] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[32009.767285] sd 3:0:0:0: [sdc] Stopping disk
[32009.767286] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[32009.768271] sd 1:0:0:0: [sdb] Stopping disk
[32009.768506] sd 0:0:0:0: [sda] Stopping disk
[32009.769722] serial 00:0b: disabled
[32009.769725] serial 00:0b: wake-up capability disabled by ACPI
[32010.002687] PM: suspend of devices complete after 236.846 msecs
[32010.002745] PM: late suspend of devices complete after 0.057 msecs
[32010.013708] ehci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
[32010.024614] ehci_hcd 0000:00:1a.0: wake-up capability enabled by ACPI
[32010.046479] xhci_hcd 0000:00:14.0: wake-up capability enabled by ACPI
[32010.057442] PM: noirq suspend of devices complete after 54.850 msecs
[32010.058093] ACPI: Preparing to enter system sleep state S3
[32010.456451] PM: Saving platform NVS memory
[32010.464634] Disabling non-boot CPUs ...
[32010.465936] smpboot: CPU 1 is now offline
[32010.467516] smpboot: CPU 2 is now offline
[32010.468942] smpboot: CPU 3 is now offline
[32010.470720] smpboot: CPU 4 is now offline
[32010.471132] Broke affinity for irq 16
[32010.471141] Broke affinity for irq 23
[32010.471144] Broke affinity for irq 43
[32010.472155] smpboot: CPU 5 is now offline
[32010.473565] smpboot: CPU 6 is now offline
[32010.475164] smpboot: CPU 7 is now offline
[32010.475460] Extended CMOS year: 2000
[32010.476578] ACPI: Low-level resume complete
[32010.476616] PM: Restoring platform NVS memory
[32010.477155] Extended CMOS year: 2000
[32010.477701] microcode: CPU0 updated to revision 0x12, date = 2012-04-12
[32010.477717] Enabling non-boot CPUs ...
[32010.477786] smpboot: Booting Node 0 Processor 1 APIC 0x2
[32010.491745] microcode: CPU1 updated to revision 0x12, date = 2012-04-12
[32010.491748] CPU1 is up
[32010.491784] smpboot: Booting Node 0 Processor 2 APIC 0x4
[32010.505681] microcode: CPU2 updated to revision 0x12, date = 2012-04-12
[32010.505684] CPU2 is up
[32010.505715] smpboot: Booting Node 0 Processor 3 APIC 0x6
[32010.519619] microcode: CPU3 updated to revision 0x12, date = 2012-04-12
[32010.519622] CPU3 is up
[32010.519652] smpboot: Booting Node 0 Processor 4 APIC 0x1
[32010.533525] microcode: CPU4 updated to revision 0x12, date = 2012-04-12
[32010.533528] CPU4 is up
[32010.533559] smpboot: Booting Node 0 Processor 5 APIC 0x3
[32010.547383] microcode: CPU5 updated to revision 0x12, date = 2012-04-12
[32010.547385] CPU5 is up
[32010.547413] smpboot: Booting Node 0 Processor 6 APIC 0x5
[32010.561332] microcode: CPU6 updated to revision 0x12, date = 2012-04-12
[32010.561334] CPU6 is up
[32010.561361] smpboot: Booting Node 0 Processor 7 APIC 0x7
[32010.575336] microcode: CPU7 updated to revision 0x12, date = 2012-04-12
[32010.575338] CPU7 is up
[32010.581829] ACPI: Waking up from system sleep state S3
[32010.603628] xhci_hcd 0000:00:14.0: wake-up capability disabled by ACPI
[32010.625578] ehci_hcd 0000:00:1a.0: wake-up capability disabled by ACPI
[32010.647501] ehci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
[32010.680507] PM: noirq resume of devices complete after 98.599 msecs
[32010.680551] PM: early resume of devices complete after 0.025 msecs
[32010.680568] i915 0000:00:02.0: setting latency timer to 64
[32010.680579] xhci_hcd 0000:00:14.0: setting latency timer to 64
[32010.680594] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[32010.680639] mei 0000:00:16.0: irq 47 for MSI/MSI-X
[32010.680673] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[32010.680677] ahci 0000:00:1f.2: setting latency timer to 64
[32010.680686] pci 0000:02:00.0: setting latency timer to 64
[32010.680690] snd_hda_intel 0000:00:1b.0: irq 49 for MSI/MSI-X
[32010.681109] serial 00:0b: activated
[32010.686076] mei 0000:00:16.0: wd: failed to find the client
[32010.711817] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[32010.984501] ata8: SATA link down (SStatus 0 SControl 300)
[32010.984539] ata7: SATA link down (SStatus 0 SControl 300)
[32010.997456] ata2: SATA link down (SStatus 0 SControl 300)
[32015.983597] ata5: SATA link down (SStatus 0 SControl 300)
[32015.983615] ata6: SATA link down (SStatus 0 SControl 300)
[32015.983634] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[32015.983662] ata3: SATA link down (SStatus 0 SControl 300)
[32015.983736] ata4: link is slow to respond, please be patient (ready=0)
[32015.995051] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[32015.995054] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[32015.995056] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[32016.015025] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[32016.015028] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[32016.015030] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[32016.025412] ata1.00: configured for UDMA/133
[32016.025563] sd 0:0:0:0: [sda] Starting disk
[32016.287387] ata2: SATA link down (SStatus 0 SControl 300)
[32016.287395] ata2: limiting SATA link speed to 1.5 Gbps
[32021.273579] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[32021.274348] ata4.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[32021.274351] ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[32021.274354] ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[32021.275779] ata4.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[32021.275782] ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[32021.275784] ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[32021.276371] ata4.00: configured for UDMA/133
[32021.276629] sd 3:0:0:0: [sdc] Starting disk
[32021.577318] ata2: SATA link down (SStatus 0 SControl 310)
[32021.577325] ata2.00: disabled
[32021.577413] ata2.00: detaching (SCSI 1:0:0:0)
[32021.577507] sd 1:0:0:0: [sdb] Starting disk
[32021.577526] sd 1:0:0:0: [sdb] START_STOP FAILED
[32021.577527] sd 1:0:0:0: [sdb]
[32021.577527] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[32021.577531] dpm_run_callback(): scsi_bus_resume_common+0x0/0x90
returns 262144
[32021.577534] PM: Device 1:0:0:0 failed to resume async: error 262144
[32021.580630] PM: resume of devices complete after 10931.128 msecs
[32021.580720] PM: Finishing wakeup.
[32021.583417] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[32021.583448] sd 1:0:0:0: [sdb]
[32021.583449] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[32021.583451] sd 1:0:0:0: [sdb] Stopping disk
[32021.583455] sd 1:0:0:0: [sdb] START_STOP FAILED
[32021.583457] sd 1:0:0:0: [sdb]
[32021.583457] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[32021.580720] Restarting tasks ... done.
[32021.584697] video LNXVIDEO:00: Restoring backlight state
[32021.730977] r8169 0000:04:00.0: p5p1: link down
[32021.731034] IPv6: ADDRCONF(NETDEV_UP): p5p1: link is not ready
[32021.731047] r8169 0000:04:00.0: p5p1: link down
[32021.732752] ------------[ cut here ]------------
[32021.732778] WARNING: at fs/btrfs/super.c:246
__btrfs_abort_transaction+0xad/0xc0 [btrfs]()
[32021.732781] Hardware name: To Be Filled By O.E.M.
[32021.732782] btrfs: Transaction aborted
[32021.732784] Modules linked in: ip6table_filter ip6_tables
nf_conntrack_netbios_ns nf_conntrack_broadcast lp parport fuse lockd
bnep sunrpc bluetooth rfkill ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
snd_hda_codec_hdmi snd_hda_codec_realtek iTCO_wdt iTCO_vendor_support
coretemp kvm_intel kvm microcode snd_hda_intel i2c_i801 serio_raw
snd_hda_codec snd_hwdep snd_seq snd_seq_device lpc_ich mfd_core r8169
snd_pcm mii uinput snd_page_alloc snd_timer snd soundcore mei btrfs
libcrc32c zlib_deflate crc32c_intel ghash_clmulni_intel usb_storage
i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded:
ip6_tables]
[32021.732830] Pid: 1785, comm: zeitgeist-daemo Not tainted
3.6.1-1.fc17.x86_64 #1
[32021.732832] Call Trace:
[32021.732841]  [<ffffffff8105b84f>] warn_slowpath_common+0x7f/0xc0
[32021.732903]  [<ffffffff8105b946>] warn_slowpath_fmt+0x46/0x50
[32021.732924]  [<ffffffffa017533a>] ?
btrfs_wait_marked_extents+0x9a/0xc0 [btrfs]
[32021.732937]  [<ffffffffa014de4d>] __btrfs_abort_transaction+0xad/0xc0 [btrfs]
[32021.732957]  [<ffffffffa01a8225>] btrfs_sync_log+0x545/0x5d0 [btrfs]
[32021.732976]  [<ffffffffa0184b5f>] btrfs_sync_file+0x1ef/0x220 [btrfs]
[32021.732982]  [<ffffffff811bc310>] do_fsync+0x50/0x80
[32021.732987]  [<ffffffff811bc580>] sys_fsync+0x10/0x20
[32021.732992]  [<ffffffff816226e9>] system_call_fastpath+0x16/0x1b
[32021.732995] ---[ end trace 1fde2d3b6a07b44a ]---
[32021.732998] BTRFS error (device sdb) in btrfs_sync_log:2149: IO failure
[32021.733000] btrfs is forced readonly
[32021.733076] BTRFS warning (device sdb): Skipping commit of aborted
transaction.
[32021.733079] BTRFS error (device sdb) in cleanup_transaction:1284: IO failure
[32023.378823] r8169 0000:04:00.0: p5p1: link up
[32023.378840] IPv6: ADDRCONF(NETDEV_CHANGE): p5p1: link becomes ready
[32023.382579] btrfs no csum found for inode 1003377 start 520192
[32024.425378] btrfs no csum found for inode 1003377 start 520192
[32029.383487] btrfs no csum found for inode 13960 start 1724416
[32051.856391] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[32051.856394] ata2: irq_stat 0x00000040, connection status changed
[32051.856395] ata2: SError: { CommWake DevExch }
[32051.856399] ata2: hard resetting link
[32052.576623] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[32052.581962] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[32052.581965] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[32052.581968] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[32052.591943] ata2.00: ATA-8: MKNSSDCL120GB-DX, 332ABBF0, max UDMA/133
[32052.591946] ata2.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[32052.601902] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[32052.601906] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[32052.601908] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[32052.611881] ata2.00: configured for UDMA/133
[32052.611889] ata2: EH complete
[32052.611978] scsi 1:0:0:0: Direct-Access     ATA
MKNSSDCL120GB-DX 332A PQ: 0 ANSI: 5
[32052.612177] sd 1:0:0:0: [sde] 234441648 512-byte logical blocks:
(120 GB/111 GiB)
[32052.612212] sd 1:0:0:0: Attached scsi generic sg1 type 0
[32052.612340] sd 1:0:0:0: [sde] Write Protect is off
[32052.612345] sd 1:0:0:0: [sde] Mode Sense: 00 3a 00 00
[32052.612431] sd 1:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[32052.613301]  sde: unknown partition table
[32052.613434] sd 1:0:0:0: [sde] Attached SCSI disk
[32101.061123] btrfs no csum found for inode 15948 start 4096
[32101.061166] btrfs no csum found for inode 15948 start 4096
[32101.061263] btrfs no csum found for inode 15948 start 4096
[32101.061426] btrfs no csum found for inode 15948 start 4096
[32101.061734] btrfs no csum found for inode 15948 start 4096
[32261.047958] btrfs no csum found for inode 13960 start 290816
[32261.048379] btrfs no csum found for inode 13960 start 290816
[32263.655948] btrfs no csum found for inode 292541 start 24576
[32263.655977] btrfs no csum found for inode 292541 start 24576
[32263.656160] btrfs no csum found for inode 292541 start 24576
[32267.699915] btrfs no csum found for inode 13973 start 0
[32267.699953] btrfs no csum found for inode 13973 start 8192
[32267.699974] btrfs no csum found for inode 13973 start 0
[32346.476956] btrfs no csum found for inode 2704481 start 28672
[32346.476980] btrfs no csum found for inode 2704481 start 28672
[32355.358095] btrfs no csum found for inode 15948 start 4096
[32355.358284] btrfs no csum found for inode 15948 start 4096
[32355.358405] btrfs no csum found for inode 15948 start 4096
[32355.358513] btrfs no csum found for inode 15948 start 4096
[32389.648200] btrfs no csum found for inode 2704481 start 28672
[32460.855427] btrfs: relocating block group 179314884608 flags 1
[32461.877704] btrfs: found 343 extents
[32462.508745] btrfs: found 342 extents
[32462.528106] btrfs: relocating block group 117037858816 flags 2
[32462.547308] btrfs: relocating block group 53003419648 flags 4
[32462.564750] btrfs: relocating block group 51929677824 flags 4
[32464.163740] btrfs: free space inode generation (0) did not match
free space cache generation (15480)
[32464.285392] btrfs: found 1814 extents
[32464.305191] btrfs: relocating block group 46382186496 flags 4
[32464.326274] btrfs: found 10 extents
[32464.428813] btrfs: found 10 extents
[32464.444704] btrfs: relocating block group 45308444672 flags 4
[32467.368853] btrfs: found 8886 extents
[32467.392131] btrfs: relocating block group 39760953344 flags 4
[32467.515721] btrfs: found 36 extents
[32467.538649] btrfs: relocating block group 38687211520 flags 4
[32467.828864] btrfs: found 544 extents
[32467.850268] btrfs: relocating block group 32065978368 flags 4
[32467.980299] btrfs: found 496 extents
[32468.283691] btrfs: found 496 extents
[32468.313069] btrfs: relocating block group 26518487040 flags 4
[32469.468182] btrfs: found 3416 extents
[32469.489649] btrfs: relocating block group 19897253888 flags 4
[32469.583394] btrfs: found 11 extents
[32478.184996] btrfs: relocating block group 185757335552 flags 1
[32478.203382] btrfs: relocating block group 184650039296 flags 1
[32478.221881] btrfs: relocating block group 183576297472 flags 1
[32478.241185] btrfs: relocating block group 182502555648 flags 1
[32478.259999] btrfs: relocating block group 181428813824 flags 1
[32478.279134] btrfs: relocating block group 181395259392 flags 1
[32478.297522] btrfs: relocating block group 181072297984 flags 1
[32478.317308] btrfs: relocating block group 180388626432 flags 1
[32478.338146] btrfs: relocating block group 179314884608 flags 1
[32478.359908] btrfs: relocating block group 177200955392 flags 1
[32478.488798] btrfs: found 475 extents
[32478.797650] btrfs: found 475 extents
[32052.612444] ACPI: Invalid Power Resource to register!
[32513.815843] device label HOME devid 1 transid 67193 /dev/sde

-- 
Shaun Reich,
KDE Software Developer (kde.org)
