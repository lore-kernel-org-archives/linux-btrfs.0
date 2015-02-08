Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:52182 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758872AbbBHVG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 16:06:26 -0500
Received: by mail-lb0-f175.google.com with SMTP id n10so22050447lbv.6
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 13:06:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
 <CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com>
From: constantine <costas.magnuse@gmail.com>
Date: Sun, 8 Feb 2015 21:06:03 +0000
Message-ID: <CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have Arch Linux:

# uname -a
Linux hostname 3.19.0-1-mainline #1 SMP PREEMPT Wed Dec 24 00:27:17
WET 2014 x86_64 GNU/Linux

btrfs-progs 3.17.3-1

dmesg:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.19.0-1-mainline (username@censored)
(gcc version 4.9.2 (GCC) ) #1 SMP PREEMPT Wed Dec 24 00:27:17 WET 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-linux-mainline
root=UUID=6c6da07e-0da7-475e-84cc-2b968971f18c rw quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x000000009d0c6fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009d0c7000-0x000000009d871fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009d872000-0x000000009d8fcfff] usable
[    0.000000] BIOS-e820: [mem 0x000000009d8fd000-0x000000009d99bfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009d99c000-0x000000009e16efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009e16f000-0x000000009e16ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000009e170000-0x000000009e1b2fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009e1b3000-0x000000009ebfbfff] usable
[    0.000000] BIOS-e820: [mem 0x000000009ebfc000-0x000000009eff1fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009eff2000-0x000000009effffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000df800000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000031f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./Z77
Pro4-M, BIOS P2.00 07/11/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x31f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask F00000000 write-back
[    0.000000]   2 base 300000000 mask FE0000000 write-back
[    0.000000]   3 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   4 base 0A0000000 mask FE0000000 uncachable
[    0.000000]   5 base 09F800000 mask FFF800000 uncachable
[    0.000000]   6 base 31F800000 mask FFF800000 uncachable
[    0.000000]   7 base 31F600000 mask FFFE00000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC
[    0.000000] e820: update [mem 0x9f800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x9f000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd810-0x000fd81f]
mapped at [ffff8800000fd810]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01b31000, 0x01b31fff] PGTABLE
[    0.000000] BRK [0x01b32000, 0x01b32fff] PGTABLE
[    0.000000] BRK [0x01b33000, 0x01b33fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x31f400000-0x31f5fffff]
[    0.000000]  [mem 0x31f400000-0x31f5fffff] page 2M
[    0.000000] BRK [0x01b34000, 0x01b34fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x31c000000-0x31f3fffff]
[    0.000000]  [mem 0x31c000000-0x31f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x300000000-0x31bffffff]
[    0.000000]  [mem 0x300000000-0x31bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] BRK [0x01b35000, 0x01b35fff] PGTABLE
[    0.000000] BRK [0x01b36000, 0x01b36fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x40005000-0x9d0c6fff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0x9cffffff] page 2M
[    0.000000]  [mem 0x9d000000-0x9d0c6fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9d872000-0x9d8fcfff]
[    0.000000]  [mem 0x9d872000-0x9d8fcfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9e16f000-0x9e16ffff]
[    0.000000]  [mem 0x9e16f000-0x9e16ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9e1b3000-0x9ebfbfff]
[    0.000000]  [mem 0x9e1b3000-0x9e1fffff] page 4k
[    0.000000]  [mem 0x9e200000-0x9e9fffff] page 2M
[    0.000000]  [mem 0x9ea00000-0x9ebfbfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9eff2000-0x9effffff]
[    0.000000]  [mem 0x9eff2000-0x9effffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x2ffffffff]
[    0.000000]  [mem 0x100000000-0x2ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x375aa000-0x37accfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x000000009D98C080 00007C (v01 ALASKA A M I
  01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x000000009D995DF0 00010C (v05 ALASKA A M I
  01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x000000009D98C190 009C5D (v02 ALASKA A M I
  00000022 INTL 20051117)
[    0.000000] ACPI: FACS 0x000000009D99A080 000040
[    0.000000] ACPI: APIC 0x000000009D995F00 000072 (v03 ALASKA A M I
  01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x000000009D995F78 000044 (v01 ALASKA A M I
  01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x000000009D995FC0 00003C (v01 ALASKA A M I
  01072009 MSFT 00000097)
[    0.000000] ACPI: SSDT 0x000000009D996000 0007E1 (v01 Intel_
AoacTabl 00001000 INTL 20091112)
[    0.000000] ACPI: AAFT 0x000000009D9967E8 000112 (v01 ALASKA
OEMAAFT  01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x000000009D996900 000038 (v01 ALASKA A M I
  01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x000000009D996938 00036D (v01 SataRe
SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x000000009D996CA8 0009AA (v01 PmRef
Cpu0Ist  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x000000009D997658 000A92 (v01 PmRef  CpuPm
  00003000 INTL 20051117)
[    0.000000] ACPI: DMAR 0x000000009D9980F0 0000B8 (v01 INTEL  SNB
  00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000031f5fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x31f5ee000-0x31f5f1fff]
[    0.000000]  [ffffea0000000000-ffffea000c7fffff] PMD ->
[ffff880313c00000-ffff88031ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x31f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0x9d0c6fff]
[    0.000000]   node   0: [mem 0x9d872000-0x9d8fcfff]
[    0.000000]   node   0: [mem 0x9e16f000-0x9e16ffff]
[    0.000000]   node   0: [mem 0x9e1b3000-0x9ebfbfff]
[    0.000000]   node   0: [mem 0x9eff2000-0x9effffff]
[    0.000000]   node   0: [mem 0x100000000-0x31f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x31f5fffff]
[    0.000000] On node 0 totalpages: 2871109
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10023 pages used for memmap
[    0.000000]   DMA32 zone: 641449 pages, LIFO batch:31
[    0.000000]   Normal zone: 34776 pages used for memmap
[    0.000000]   Normal zone: 2225664 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0x9fa00000-0xc19fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9d0c7000-0x9d871fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9d8fd000-0x9d99bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x9d99c000-0x9e16efff]
[    0.000000] PM: Registered nosave memory: [mem 0x9e170000-0x9e1b2fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9ebfc000-0x9eff1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9f000000-0x9f9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x9fa00000-0xc19fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc1a00000-0xdf7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf800000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xc1a00000-0xdf7fffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128
nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff88031f200000 s87232
r8192 d31552 u524288
[    0.000000] pcpu-alloc: s87232 r8192 d31552 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 2826225
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-linux-mainline
root=UUID=6c6da07e-0da7-475e-84cc-2b968971f18c rw quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using
standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 11220512K/11484436K available (5528K kernel
code, 915K rwdata, 1732K rodata, 1164K init, 1156K bss, 263924K
reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:8448 nr_irqs:456 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3199.778 MHz processor
[    0.000027] Calibrating delay loop (skipped), value calculated
using timer frequency.. 6402.20 BogoMIPS (lpj=10665926)
[    0.000029] pid_max: default: 32768 minimum: 301
[    0.000032] ACPI: Core revision 20141107
[    0.005447] ACPI: All ACPI Tables successfully acquired
[    0.007706] Security Framework initialized
[    0.007710] Yama: becoming mindful.
[    0.008429] Dentry cache hash table entries: 2097152 (order: 12,
16777216 bytes)
[    0.011467] Inode-cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.012816] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.012831] Mountpoint-cache hash table entries: 32768 (order: 6,
262144 bytes)
[    0.013030] Initializing cgroup subsys memory
[    0.013034] Initializing cgroup subsys devices
[    0.013035] Initializing cgroup subsys freezer
[    0.013037] Initializing cgroup subsys net_cls
[    0.013039] Initializing cgroup subsys blkio
[    0.013056] CPU: Physical Processor ID: 0
[    0.013057] CPU: Processor Core ID: 0
[    0.013061] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.013357] mce: CPU supports 9 MCE banks
[    0.013367] CPU0: Thermal monitoring enabled (TM1)
[    0.013374] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.013465] Freeing SMP alternatives memory: 20K (ffffffff81a09000
- ffffffff81a0e000)
[    0.014223] ftrace: allocating 21080 entries in 83 pages
[    0.021723] dmar: Host address width 36
[    0.021725] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.021732] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap
c0000020e60262 ecap f0101a
[    0.021733] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.021736] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap
c9008020660262 ecap f0105a
[    0.021737] dmar: RMRR base: 0x0000009d7d4000 end: 0x0000009d805fff
[    0.021738] dmar: RMRR base: 0x000000df800000 end: 0x000000df9fffff
[    0.021808] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.021809] HPET id 0 under DRHD base 0xfed91000
[    0.021809] Queued invalidation will be enabled to support x2apic
and Intr-remapping.
[    0.021923] Enabled IRQ remapping in x2apic mode
[    0.021924] Enabling x2apic
[    0.021925] Enabled x2apic
[    0.021929] Switched APIC routing to cluster x2apic.
[    0.022349] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.055350] smpboot: CPU0: Intel(R) Core(TM) i5-3470 CPU @ 3.20GHz
(fam: 06, model: 3a, stepping: 09)
[    0.055355] TSC deadline timer enabled
[    0.055371] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge
events, full-width counters, Intel PMU driver.
[    0.055386] ... version:                3
[    0.055387] ... bit width:              48
[    0.055387] ... generic registers:      8
[    0.055388] ... value mask:             0000ffffffffffff
[    0.055389] ... max period:             0000ffffffffffff
[    0.055389] ... fixed-purpose events:   3
[    0.055390] ... event mask:             00000007000000ff
[    0.075440] x86: Booting SMP configuration:
[    0.075442] .... node  #0, CPUs:      #1
[    0.088926] NMI watchdog: enabled on all CPUs, permanently consumes
one hw-PMU counter.
[    0.095613]  #2 #3
[    0.129210] x86: Booted up 1 node, 4 CPUs
[    0.129213] smpboot: Total of 4 processors activated (25608.81 BogoMIPS)
[    0.131707] devtmpfs: initialized
[    0.133889] PM: Registering ACPI NVS region [mem
0x9d8fd000-0x9d99bfff] (651264 bytes)
[    0.133895] PM: Registering ACPI NVS region [mem
0x9e170000-0x9e1b2fff] (274432 bytes)
[    0.134012] pinctrl core: initialized pinctrl subsystem
[    0.134047] RTC time: 16:30:39, date: 02/08/15
[    0.134126] NET: Registered protocol family 16
[    0.149210] cpuidle: using governor ladder
[    0.162547] cpuidle: using governor menu
[    0.162592] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    0.162594] ACPI: bus type PCI registered
[    0.162596] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.162673] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.162676] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.162742] PCI: Using configuration type 1 for base access
[    0.176178] ACPI: Added _OSI(Module Device)
[    0.176179] ACPI: Added _OSI(Processor Device)
[    0.176180] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.176181] ACPI: Added _OSI(Processor Aggregator Device)
[    0.178194] ACPI: Executed 1 blocks of module-level executable AML code
[    0.180031] ACPI: Dynamic OEM Table Load:
[    0.180036] ACPI: SSDT 0xFFFF880311B03000 00083B (v01 PmRef
Cpu0Cst  00003001 INTL 20051117)
[    0.180408] ACPI: Dynamic OEM Table Load:
[    0.180411] ACPI: SSDT 0xFFFF880311ACE000 000303 (v01 PmRef  ApIst
  00003000 INTL 20051117)
[    0.180731] ACPI: Dynamic OEM Table Load:
[    0.180733] ACPI: SSDT 0xFFFF880311AC1A00 000119 (v01 PmRef  ApCst
  00003000 INTL 20051117)
[    0.181358] ACPI: Interpreter enabled
[    0.181362] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S1_] (20141107/hwxface-580)
[    0.181365] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S2_] (20141107/hwxface-580)
[    0.181375] ACPI: (supports S0 S3 S4 S5)
[    0.181376] ACPI: Using IOAPIC for interrupt routing
[    0.181415] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.186254] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.186259] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    0.186413] acpi PNP0A08:00: _OSC: platform does not support
[PCIeHotplug PME]
[    0.186507] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.186931] PCI host bridge to bus 0000:00
[    0.186934] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.186935] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.186937] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.186938] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.186939] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.186940] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.186941] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.186942] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.186943] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.186945] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.186951] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.187018] pci 0000:00:02.0: [8086:0152] type 00 class 0x030000
[    0.187026] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.187031] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff
64bit pref]
[    0.187034] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.187116] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.187136] pci 0000:00:14.0: reg 0x10: [mem 0xf7e00000-0xf7e0ffff 64bit]
[    0.187204] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.187238] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.187270] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.187291] pci 0000:00:16.0: reg 0x10: [mem 0xf7e1a000-0xf7e1a00f 64bit]
[    0.187362] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.187431] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.187450] pci 0000:00:1a.0: reg 0x10: [mem 0xf7e18000-0xf7e183ff]
[    0.187537] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.187580] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.187612] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.187626] pci 0000:00:1b.0: reg 0x10: [mem 0xf7e10000-0xf7e13fff 64bit]
[    0.187697] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.187732] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.187766] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.187903] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.187948] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.187978] pci 0000:00:1c.4: [8086:1e18] type 01 class 0x060400
[    0.188056] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.188093] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.188120] pci 0000:00:1c.5: [8086:1e1a] type 01 class 0x060400
[    0.188198] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.188234] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.188263] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
[    0.188341] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.188377] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    0.188408] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.188427] pci 0000:00:1d.0: reg 0x10: [mem 0xf7e17000-0xf7e173ff]
[    0.188513] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.188556] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.188586] pci 0000:00:1f.0: [8086:1e44] type 00 class 0x060100
[    0.188741] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.188757] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    0.188764] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    0.188770] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
[    0.188777] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
[    0.188783] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.188790] pci 0000:00:1f.2: reg 0x24: [mem 0xf7e16000-0xf7e167ff]
[    0.188832] pci 0000:00:1f.2: PME# supported from D3hot
[    0.188886] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.188900] pci 0000:00:1f.3: reg 0x10: [mem 0xf7e15000-0xf7e150ff 64bit]
[    0.188918] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.189054] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.189136] pci 0000:02:00.0: [197b:2363] type 00 class 0x010601
[    0.189245] pci 0000:02:00.0: reg 0x24: [mem 0xf7d10000-0xf7d11fff]
[    0.189261] pci 0000:02:00.0: reg 0x30: [mem 0xf7d00000-0xf7d0ffff pref]
[    0.189336] pci 0000:02:00.0: PME# supported from D3hot
[    0.189390] pci 0000:02:00.1: [197b:2363] type 00 class 0x010185
[    0.189413] pci 0000:02:00.1: reg 0x10: [io  0xe040-0xe047]
[    0.189424] pci 0000:02:00.1: reg 0x14: [io  0xe030-0xe033]
[    0.189435] pci 0000:02:00.1: reg 0x18: [io  0xe020-0xe027]
[    0.189446] pci 0000:02:00.1: reg 0x1c: [io  0xe010-0xe013]
[    0.189457] pci 0000:02:00.1: reg 0x20: [io  0xe000-0xe00f]
[    0.189579] pci 0000:00:1c.4: PCI bridge to [bus 02]
[    0.189582] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.189585] pci 0000:00:1c.4:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    0.189658] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.189679] pci 0000:03:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.189712] pci 0000:03:00.0: reg 0x18: [mem 0xf0004000-0xf0004fff
64bit pref]
[    0.189732] pci 0000:03:00.0: reg 0x20: [mem 0xf0000000-0xf0003fff
64bit pref]
[    0.189848] pci 0000:03:00.0: supports D1 D2
[    0.189850] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.195919] pci 0000:00:1c.5: PCI bridge to [bus 03]
[    0.195925] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.195934] pci 0000:00:1c.5:   bridge window [mem
0xf0000000-0xf00fffff 64bit pref]
[    0.196022] pci 0000:04:00.0: [1b21:0612] type 00 class 0x010601
[    0.196043] pci 0000:04:00.0: reg 0x10: [io  0xc050-0xc057]
[    0.196056] pci 0000:04:00.0: reg 0x14: [io  0xc040-0xc043]
[    0.196068] pci 0000:04:00.0: reg 0x18: [io  0xc030-0xc037]
[    0.196081] pci 0000:04:00.0: reg 0x1c: [io  0xc020-0xc023]
[    0.196094] pci 0000:04:00.0: reg 0x20: [io  0xc000-0xc01f]
[    0.196107] pci 0000:04:00.0: reg 0x24: [mem 0xf7c00000-0xf7c001ff]
[    0.202587] pci 0000:00:1c.7: PCI bridge to [bus 04]
[    0.202592] pci 0000:00:1c.7:   bridge window [io  0xc000-0xcfff]
[    0.202596] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.202642] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is
unsupported)
[    0.203096] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.203130] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.203163] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.203195] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.203227] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12
14 15) *0, disabled.
[    0.203260] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12
14 15) *0, disabled.
[    0.203293] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.203325] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.203407] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.203477] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.203478] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.203481] vgaarb: loaded
[    0.203481] vgaarb: bridge control possible 0000:00:02.0
[    0.203526] PCI: Using ACPI for IRQ routing
[    0.204930] PCI: pci_cache_line_size set to 64 bytes
[    0.204979] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.204980] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.204981] e820: reserve RAM buffer [mem 0x9d0c7000-0x9fffffff]
[    0.204982] e820: reserve RAM buffer [mem 0x9d8fd000-0x9fffffff]
[    0.204983] e820: reserve RAM buffer [mem 0x9e170000-0x9fffffff]
[    0.204984] e820: reserve RAM buffer [mem 0x9ebfc000-0x9fffffff]
[    0.204985] e820: reserve RAM buffer [mem 0x9f000000-0x9fffffff]
[    0.204986] e820: reserve RAM buffer [mem 0x31f600000-0x31fffffff]
[    0.205068] NetLabel: Initializing
[    0.205069] NetLabel:  domain hash size = 128
[    0.205070] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.205080] NetLabel:  unlabeled traffic allowed by default
[    0.205097] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.205100] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.207118] Switched to clocksource hpet
[    0.210755] pnp: PnP ACPI init
[    0.210821] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.210823] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.210880] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.210882] system 00:01: [io  0x1000-0x100f] has been reserved
[    0.210883] system 00:01: [io  0xffff] has been reserved
[    0.210884] system 00:01: [io  0xffff] has been reserved
[    0.210886] system 00:01: [io  0x0400-0x0453] could not be reserved
[    0.210887] system 00:01: [io  0x0458-0x047f] has been reserved
[    0.210888] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.210889] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.210891] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.210913] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.210947] system 00:03: [io  0x0454-0x0457] has been reserved
[    0.210949] system 00:03: Plug and Play ACPI device, IDs INT3f0d
PNP0c02 (active)
[    0.211001] system 00:04: [io  0x0290-0x029f] has been reserved
[    0.211003] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.211194] pnp 00:05: [dma 3]
[    0.211267] pnp 00:05: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.211397] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.211399] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.211499] pnp 00:07: [dma 0 disabled]
[    0.211524] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.211674] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.211676] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.211677] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.211678] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.211680] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.211681] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.211682] system 00:08: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.211684] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.211685] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.211686] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.211688] system 00:08: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.211689] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.211792] system 00:09: [mem 0x20000000-0x201fffff] has been reserved
[    0.211794] system 00:09: [mem 0x40004000-0x40004fff] has been reserved
[    0.211795] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.211814] pnp: PnP ACPI: found 10 devices
[    0.217776] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.217794] pci 0000:00:1c.4: PCI bridge to [bus 02]
[    0.217796] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.217800] pci 0000:00:1c.4:   bridge window [mem 0xf7d00000-0xf7dfffff]
[    0.217807] pci 0000:00:1c.5: PCI bridge to [bus 03]
[    0.217809] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.217815] pci 0000:00:1c.5:   bridge window [mem
0xf0000000-0xf00fffff 64bit pref]
[    0.217820] pci 0000:00:1c.7: PCI bridge to [bus 04]
[    0.217822] pci 0000:00:1c.7:   bridge window [io  0xc000-0xcfff]
[    0.217826] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.217834] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.217835] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.217836] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.217838] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.217839] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.217840] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]
[    0.217841] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000e3fff]
[    0.217842] pci_bus 0000:00: resource 11 [mem 0x000e4000-0x000e7fff]
[    0.217843] pci_bus 0000:00: resource 12 [mem 0xdfa00000-0xfeafffff]
[    0.217845] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.217846] pci_bus 0000:02: resource 1 [mem 0xf7d00000-0xf7dfffff]
[    0.217847] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.217849] pci_bus 0000:03: resource 2 [mem 0xf0000000-0xf00fffff
64bit pref]
[    0.217850] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    0.217851] pci_bus 0000:04: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.217872] NET: Registered protocol family 2
[    0.218022] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.218192] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.218311] TCP: Hash tables configured (established 131072 bind 65536)
[    0.218322] TCP: reno registered
[    0.218335] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.218378] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.218436] NET: Registered protocol family 1
[    0.218465] pci 0000:00:02.0: Video device with shadowed ROM
[    0.253898] PCI: CLS mismatch (64 != 32), using 64 bytes
[    0.253937] Unpacking initramfs...
[    0.319358] Freeing initrd memory: 5260K (ffff8800375aa000 -
ffff880037acd000)
[    0.319381] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.319383] software IO TLB [mem 0x990c7000-0x9d0c7000] (64MB)
mapped at [ffff8800990c7000-ffff88009d0c6fff]
[    0.319515] RAPL PMU detected, hw unit 2^-16 Joules, API unit is
2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.319598] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x15
[    0.319604] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x15
[    0.319610] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x15
[    0.319616] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x15
[    0.319658] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.319677] Scanning for low memory corruption every 60 seconds
[    0.319850] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.319863] Initialise system trusted keyring
[    0.320137] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.321052] zpool: loaded
[    0.321054] zbud: loaded
[    0.321166] VFS: Disk quotas dquot_6.5.2
[    0.321189] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.321304] Key type big_key registered
[    0.321452] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[    0.321486] io scheduler noop registered
[    0.321489] io scheduler deadline registered
[    0.321509] io scheduler cfq registered (default)
[    0.321965] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.321976] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.321984] vesafb: mode is 1920x1200x32, linelength=7680, pages=0
[    0.321985] vesafb: scrolling: redraw
[    0.321986] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.322001] vesafb: framebuffer at 0xe0000000, mapped to
0xffffc90005c00000, using 9024k, total 9024k
[    0.449826] Console: switching to colour frame buffer device 240x75
[    0.577580] fb0: VESA VGA frame buffer device
[    0.577592] intel_idle: MWAIT substates: 0x1120
[    0.577593] intel_idle: v0.4 model 0x3A
[    0.577594] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.577706] GHES: HEST is not enabled!
[    0.577757] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.598328] serial 00:07: ttyS0 at I/O 0x3f8 (irq = 4, base_baud =
115200) is a 16550A
[    0.598592] Linux agpgart interface v0.103
[    0.598632] rtc_cmos 00:02: RTC can wake from S4
[    0.598740] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.598769] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes
nvram, hpet irqs
[    0.598777] Intel P-state driver initializing.
[    0.598866] ledtrig-cpu: registered to indicate activity on CPUs
[    0.599195] TCP: cubic registered
[    0.599317] NET: Registered protocol family 10
[    0.599574] NET: Registered protocol family 17
[    0.600101] Loading compiled-in X.509 certificates
[    0.600117] registered taskstats version 1
[    0.600775]   Magic number: 3:749:539
[    0.600882] rtc_cmos 00:02: setting system clock to 2015-02-08
16:30:40 UTC (1423413040)
[    0.600998] PM: Hibernation image not present or could not be loaded.
[    0.601398] Freeing unused kernel memory: 1164K (ffffffff818e6000 -
ffffffff81a09000)
[    0.601400] Write protecting the kernel read-only data: 8192k
[    0.601811] Freeing unused kernel memory: 604K (ffff880001569000 -
ffff880001600000)
[    0.601955] Freeing unused kernel memory: 316K (ffff8800017b1000 -
ffff880001800000)
[    0.610123] random: systemd-tmpfile urandom read with 1 bits of
entropy available
[    0.616831] [drm] Initialized drm 1.1.0 20060810
[    0.618940] wmi: Mapper loaded
[    0.619675] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.619681] ACPI: Power Button [PWRB]
[    0.619754] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.619757] ACPI: Power Button [PWRF]
[    0.624357] ACPI Warning: \_SB_.PCI0.GFX0._DSM: Argument #4 type
mismatch - Found [Buffer], ACPI requires [Package]
(20141107/nsarguments-95)
[    0.624378] ACPI: \_SB_.PCI0.GFX0: failed to evaluate _DSM
[    0.639398] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.642061] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.642114] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.645603] ACPI: bus type USB registered
[    0.645632] usbcore: registered new interface driver usbfs
[    0.645644] usbcore: registered new interface driver hub
[    0.646388] usbcore: registered new device driver usb
[    0.646460] SCSI subsystem initialized
[    0.647553] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.647562] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 1
[    0.647589] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.647665] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.648313] ehci-pci: EHCI PCI platform driver
[    0.648353] libata version 3.00 loaded.
[    0.648646] hub 1-0:1.0: USB hub found
[    0.648658] hub 1-0:1.0: 4 ports detected
[    0.649380] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.649384] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 2
[    0.649556] hub 2-0:1.0: USB hub found
[    0.649567] hub 2-0:1.0: 4 ports detected
[    0.650069] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.650075] ehci-pci 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[    0.650089] ehci-pci 0000:00:1a.0: debug port 2
[    0.654000] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.654017] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7e18000
[    0.663804] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.663982] hub 3-0:1.0: USB hub found
[    0.663989] hub 3-0:1.0: 2 ports detected
[    0.664248] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.664255] ehci-pci 0000:00:1d.0: new USB bus registered, assigned
bus number 4
[    0.664267] ehci-pci 0000:00:1d.0: debug port 2
[    0.668160] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.668174] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7e17000
[    0.677216] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.677494] hub 4-0:1.0: USB hub found
[    0.677504] hub 4-0:1.0: 2 ports detected
[    0.677692] ahci 0000:00:1f.2: version 3.0
[    0.690538] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6
Gbps 0x3f impl SATA mode
[    0.690542] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum
part ems apst
[    0.724537] scsi host0: ahci
[    0.724782] scsi host1: ahci
[    0.725070] scsi host2: ahci
[    0.725337] scsi host3: ahci
[    0.725561] scsi host4: ahci
[    0.725764] scsi host5: ahci
[    0.725840] ata1: SATA max UDMA/133 abar m2048@0xf7e16000 port
0xf7e16100 irq 27
[    0.725843] ata2: SATA max UDMA/133 abar m2048@0xf7e16000 port
0xf7e16180 irq 27
[    0.725845] ata3: SATA max UDMA/133 abar m2048@0xf7e16000 port
0xf7e16200 irq 27
[    0.725847] ata4: SATA max UDMA/133 abar m2048@0xf7e16000 port
0xf7e16280 irq 27
[    0.725849] ata5: SATA max UDMA/133 abar m2048@0xf7e16000 port
0xf7e16300 irq 27
[    0.725851] ata6: SATA max UDMA/133 abar m2048@0xf7e16000 port
0xf7e16380 irq 27
[    0.726009] ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3
Gbps 0x3 impl SATA mode
[    0.726012] ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part
[    0.726348] scsi host6: ahci
[    0.726476] scsi host7: ahci
[    0.726531] ata7: SATA max UDMA/133 abar m8192@0xf7d10000 port
0xf7d10100 irq 16
[    0.726535] ata8: SATA max UDMA/133 abar m8192@0xf7d10000 port
0xf7d10180 irq 16
[    0.726671] ahci 0000:04:00.0: SSS flag set, parallel bus scan disabled
[    0.726708] ahci 0000:04:00.0: AHCI 0001.0200 32 slots 2 ports 6
Gbps 0x3 impl SATA mode
[    0.726711] ahci 0000:04:00.0: flags: 64bit ncq sntf stag led clo
pmp pio slum part ccc sxs
[    0.726993] scsi host8: ahci
[    0.727133] scsi host9: ahci
[    0.727178] ata9: SATA max UDMA/133 abar m512@0xf7c00000 port
0xf7c00100 irq 28
[    0.727181] ata10: SATA max UDMA/133 abar m512@0xf7c00000 port
0xf7c00180 irq 28
[    0.970508] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    0.983851] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    1.007171] usb 1-1: new low-speed USB device number 2 using xhci_hcd
[    1.043868] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.043895] ata8: SATA link down (SStatus 0 SControl 300)
[    1.043905] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.043928] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.043949] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.043966] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.043982] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.045452] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.045457] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.045460] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.045469] ata4.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.045474] ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.045477] ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.045485] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.045490] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.045493] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.045502] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.045507] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.045509] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.045514] ata3.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.045517] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.045519] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.046168] ata1.00: ATA-9: WDC WD60EFRX-68MYMN1, 82.00A82, max UDMA/133
[    1.046172] ata1.00: 11721045168 sectors, multi 16: LBA48 NCQ
(depth 31/32), AA
[    1.046191] ata4.00: ATA-8: ST2000DL003-9VT166, CC32, max UDMA/133
[    1.046196] ata4.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.046208] ata2.00: ATA-9: WDC WD60EFRX-68MYMN1, 82.00A82, max UDMA/133
[    1.046212] ata2.00: 11721045168 sectors, multi 16: LBA48 NCQ
(depth 31/32), AA
[    1.046226] ata6.00: ATA-8: ST2000DL003-9VT166, CC32, max UDMA/133
[    1.046231] ata6.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.046448] ata3.00: ATA-8: WDC WD20EARX-008FB0, 51.0AB51, max UDMA/133
[    1.046452] ata3.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.047719] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.047724] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.047727] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.047909] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.047914] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.047917] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.047925] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.047930] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.047932] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.047940] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.047955] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.047958] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.047966] ata4.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.047970] ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.047973] ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.047985] ata3.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.047990] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.047993] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.048442] ata2.00: configured for UDMA/133
[    1.048541] ata6.00: configured for UDMA/133
[    1.048604] ata1.00: configured for UDMA/133
[    1.048634] ata4.00: configured for UDMA/133
[    1.048823] scsi 0:0:0:0: Direct-Access     ATA      WDC
WD60EFRX-68M 0A82 PQ: 0 ANSI: 5
[    1.048911] ata3.00: configured for UDMA/133
[    1.049234] scsi 1:0:0:0: Direct-Access     ATA      WDC
WD60EFRX-68M 0A82 PQ: 0 ANSI: 5
[    1.049611] scsi 2:0:0:0: Direct-Access     ATA      WDC
WD20EFRX-008 AB51 PQ: 0 ANSI: 5
[    1.049912] scsi 3:0:0:0: Direct-Access     ATA
ST2000DL004-9VT4 CC32 PQ: 0 ANSI: 5
[    1.051259] ata5.00: ATA-8: WDC WD15EARS-00Z5B1, 80.00A80, max UDMA/133
[    1.051262] ata5.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.055178] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.055181] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    1.055184] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.059293] ata5.00: configured for UDMA/133
[    1.059502] scsi 4:0:0:0: Direct-Access     ATA      WDC
WD15EFRX-00Z 0A80 PQ: 0 ANSI: 5
[    1.060103] scsi 5:0:0:0: Direct-Access     ATA
ST2000DL004-9VT4 CC32 PQ: 0 ANSI: 5
[    1.094672] hub 3-1:1.0: USB hub found
[    1.094878] hub 3-1:1.0: 6 ports detected
[    1.107905] hub 4-1:1.0: USB hub found
[    1.108101] hub 4-1:1.0: 8 ports detected
[    1.186274] usb 1-1: ep 0x81 - rounding interval to 64 microframes,
ep desc says 80 microframes
[    1.188154] hidraw: raw HID events driver (C) Jiri Kosina
[    1.191081] usbcore: registered new interface driver usbhid
[    1.191083] usbhid: USB HID core driver
[    1.191684] input: Forward USB Optical Mouse as
/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/0003:05BC:0102.0001/input/input4
[    1.191738] hid-generic 0003:05BC:0102.0001: input,hidraw0: USB HID
v1.10 Mouse [Forward USB Optical Mouse] on usb-0000:00:14.0-1/input0
[    1.210526] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.211482] ata7.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
[    1.211487] ata7.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.212423] ata7.00: configured for UDMA/133
[    1.212639] scsi 6:0:0:0: Direct-Access     ATA
ST3000DM004-1CH1 CC27 PQ: 0 ANSI: 5
[    1.213851] ata9: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.213949] sd 0:0:0:0: [sda] 11721045168 512-byte logical blocks:
(6.00 TB/5.45 TiB)
[    1.213952] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.213967] sd 1:0:0:0: [sdb] 11721045168 512-byte logical blocks:
(6.00 TB/5.45 TiB)
[    1.213970] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    1.214010] sd 0:0:0:0: [sda] Write Protect is off
[    1.214013] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.214023] sd 1:0:0:0: [sdb] Write Protect is off
[    1.214026] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.214035] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.214068] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.214078] sd 2:0:0:0: [sdc] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    1.214082] sd 2:0:0:0: [sdc] 4096-byte physical blocks
[    1.214156] sd 3:0:0:0: [sdd] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    1.214201] sd 2:0:0:0: [sdc] Write Protect is off
[    1.214204] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.214215] sd 3:0:0:0: [sdd] Write Protect is off
[    1.214218] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.214241] sd 3:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.214259] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.214542] sd 5:0:0:0: [sdf] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    1.214546] sd 4:0:0:0: [sde] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[    1.214572] sd 6:0:0:0: [sdg] 5860533168 512-byte logical blocks:
(3.00 TB/2.72 TiB)
[    1.214575] sd 6:0:0:0: [sdg] 4096-byte physical blocks
[    1.214585] sd 4:0:0:0: [sde] Write Protect is off
[    1.214588] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    1.214608] sd 4:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.214644] sd 5:0:0:0: [sdf] Write Protect is off
[    1.214647] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    1.214664] sd 6:0:0:0: [sdg] Write Protect is off
[    1.214668] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    1.214672] sd 5:0:0:0: [sdf] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.214699] sd 6:0:0:0: [sdg] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.218765]  sdc: sdc1
[    1.219050] sd 2:0:0:0: [sdc] Attached SCSI disk
[    1.219494]  sdb: unknown partition table
[    1.219697] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.223040]  sda: unknown partition table
[    1.223494] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.224890] ata9.00: ATA-9: INTEL SSDSC2CW120A3, 400i, max UDMA/133
[    1.224893] ata9.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.234782] ata9.00: configured for UDMA/133
[    1.235005] scsi 8:0:0:0: Direct-Access     ATA      INTEL
SSDSC2CW12 400i PQ: 0 ANSI: 5
[    1.235228]  sdd: sdd1
[    1.235402] sd 8:0:0:0: [sdh] 234441648 512-byte logical blocks:
(120 GB/111 GiB)
[    1.235475] sd 8:0:0:0: [sdh] Write Protect is off
[    1.235477] sd 8:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    1.235492] sd 3:0:0:0: [sdd] Attached SCSI disk
[    1.235506] sd 8:0:0:0: [sdh] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.235969]  sdh: sdh1 sdh2
[    1.236660] sd 8:0:0:0: [sdh] Attached SCSI disk
[    1.236912]  sde: sde1
[    1.237153] sd 4:0:0:0: [sde] Attached SCSI disk
[    1.266877]  sdf: sdf1 sdf2 sdf3
[    1.267711] sd 5:0:0:0: [sdf] Attached SCSI disk
[    1.289602]  sdg: sdg1
[    1.290322] sd 6:0:0:0: [sdg] Attached SCSI disk
[    1.320519] tsc: Refined TSC clocksource calibration: 3200.022 MHz
[    1.360642] usb 3-1.5: new high-speed USB device number 3 using ehci-pci
[    1.373981] usb 4-1.5: new low-speed USB device number 3 using ehci-pci
[    1.475198] input: Microsoft Comfort Mouse 6000 as
/devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.5/4-1.5:1.0/0003:045E:077D.0002/input/input5
[    1.514006] usb 3-1.6: new high-speed USB device number 4 using ehci-pci
[    1.527342] hid-generic 0003:045E:077D.0002: input,hidraw1: USB HID
v1.11 Mouse [Microsoft Comfort Mouse 6000] on
usb-0000:00:1d.0-1.5/input0
[    1.593982] usb 4-1.6: new high-speed USB device number 4 using ehci-pci
[    1.679412] hub 4-1.6:1.0: USB hub found
[    1.679730] hub 4-1.6:1.0: 4 ports detected
[    1.720541] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.721185] ata10.00: ATA-9: WDC WD30EZRX-00D8PB0, 80.00A80, max UDMA/133
[    1.721190] ata10.00: 5860533168 sectors, multi 16: LBA48 NCQ
(depth 31/32), AA
[    1.721879] ata10.00: configured for UDMA/133
[    1.722112] scsi 9:0:0:0: Direct-Access     ATA      WDC
WD30EZRX-00D 0A80 PQ: 0 ANSI: 5
[    1.722494] sd 9:0:0:0: [sdi] 5860533168 512-byte logical blocks:
(3.00 TB/2.72 TiB)
[    1.722498] sd 9:0:0:0: [sdi] 4096-byte physical blocks
[    1.722621] sd 9:0:0:0: [sdi] Write Protect is off
[    1.722627] sd 9:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[    1.722718] sd 9:0:0:0: [sdi] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.791431]  sdi: sdi1
[    1.792061] sd 9:0:0:0: [sdi] Attached SCSI disk
[    1.797882] random: nonblocking pool is initialized
[    1.917160] raid6: sse2x1    6341 MB/s
[    1.973834] raid6: sse2x2    9371 MB/s
[    1.974086] usb 4-1.6.3: new low-speed USB device number 5 using ehci-pci
[    2.030470] raid6: sse2x4   12829 MB/s
[    2.030471] raid6: using algorithm sse2x4 (12829 MB/s)
[    2.030472] raid6: using ssse3x2 recovery algorithm
[    2.030708] xor: automatically using best checksumming function:
[    2.063800]    avx       : 26508.000 MB/sec
[    2.067789] Btrfs loaded
[    2.068524] BTRFS: device label mahon devid 5 transid 305365 /dev/sdg1
[    2.068657] BTRFS: device label Downloads devid 1 transid 208429 /dev/sde1
[    2.068762] BTRFS: device label mahon devid 1 transid 305365 /dev/sdi1
[    2.068805] BTRFS: device label mahon devid 6 transid 305365 /dev/sda
[    2.068828] BTRFS: device fsid 9dd789bf-9980-4c90-923d-19630ba9c6d2
devid 2 transid 89541 /dev/sdc
[    2.068853] BTRFS: device label mahon devid 7 transid 305365 /dev/sdb
[    2.069948] BTRFS: device label mahon devid 3 transid 305365 /dev/sdd1
[    2.070002] BTRFS: device fsid 8b085d80-3816-4b75-b26d-c9cdf73718a1
devid 3 transid 25001 /dev/sdf
[    2.073974] BTRFS: device label mahon devid 4 transid 305365 /dev/sdc1
[    2.096678] input: Microsoft Natural® Ergonomic Keyboard 4000 as
/devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.6/4-1.6.3/4-1.6.3:1.0/0003:045E:00DB.0003/input/input6
[    2.147323] microsoft 0003:045E:00DB.0003: input,hidraw2: USB HID
v1.11 Keyboard [Microsoft Natural® Ergonomic Keyboard 4000] on
usb-0000:00:1d.0-1.6.3/input0
[    2.148577] input: Microsoft Natural® Ergonomic Keyboard 4000 as
/devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.6/4-1.6.3/4-1.6.3:1.1/0003:045E:00DB.0004/input/input7
[    2.160852] usb 4-1.6.4: new full-speed USB device number 6 using ehci-pci
[    2.195234] BTRFS: device label Downloads devid 2 transid 208429 /dev/sdf1
[    2.200638] microsoft 0003:045E:00DB.0004: input,hidraw3: USB HID
v1.11 Device [Microsoft Natural® Ergonomic Keyboard 4000] on
usb-0000:00:1d.0-1.6.3/input1
[    2.317207] BTRFS: device label Downloads devid 3 transid 208429 /dev/sdf2
[    2.320689] Switched to clocksource tsc
[    2.344413] EXT4-fs (sdh1): mounted filesystem with ordered data
mode. Opts: (null)
[    2.591761] systemd[1]:
[/etc/systemd/system/cacti_poller.service:6] Failed to parse service
type, ignoring: =simple
[    2.605010] systemd[1]: Cannot add dependency job for unit
redis.service, ignoring: Unit redis.service failed to load: No such
file or directory.
[    2.622560] EXT4-fs (sdh1): re-mounted. Opts: data=ordered,discard
[    2.630001] vboxdrv: Found 4 processor cores.
[    2.630210] vboxdrv: fAsync=0 offMin=0x27c offMax=0x78f8
[    2.630281] vboxdrv: TSC mode is 'synchronous', kernel timer mode
is 'normal'.
[    2.630283] vboxdrv: Successfully loaded version 4.3.20_OSE
(interface 0x001a0008).
[    2.638294] vboxpci: IOMMU not found (not registered)
[    2.704361] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.708717] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.716151] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.719378] systemd-journald[197]: Received request to flush
runtime journal from PID 1
[    2.991248] parport_pc 00:05: reported by Plug and Play ACPI
[    2.991294] parport0: PC-style at 0x378 (0x778), irq 5 [PCSPP,TRISTATE,EPP]
[    3.011055] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.011686] EDAC MC: Ver: 3.0.0
[    3.012534] ACPI Warning: SystemIO range
0x0000000000000428-0x000000000000042f conflicts with OpRegion
0x0000000000000400-0x000000000000047f (\PMIO) (20141107/utaddress-258)
[    3.012541] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    3.012544] ACPI Warning: SystemIO range
0x0000000000000540-0x000000000000054f conflicts with OpRegion
0x0000000000000500-0x000000000000057f (\GPR2) (20141107/utaddress-258)
[    3.012547] ACPI Warning: SystemIO range
0x0000000000000540-0x000000000000054f conflicts with OpRegion
0x0000000000000500-0x0000000000000563 (\GPIO) (20141107/utaddress-258)
[    3.012550] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    3.012551] ACPI Warning: SystemIO range
0x0000000000000530-0x000000000000053f conflicts with OpRegion
0x0000000000000500-0x000000000000057f (\GPR2) (20141107/utaddress-258)
[    3.012554] ACPI Warning: SystemIO range
0x0000000000000530-0x000000000000053f conflicts with OpRegion
0x0000000000000500-0x0000000000000563 (\GPIO) (20141107/utaddress-258)
[    3.012556] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    3.012557] ACPI Warning: SystemIO range
0x0000000000000500-0x000000000000052f conflicts with OpRegion
0x0000000000000500-0x000000000000057f (\GPR2) (20141107/utaddress-258)
[    3.012560] ACPI Warning: SystemIO range
0x0000000000000500-0x000000000000052f conflicts with OpRegion
0x0000000000000500-0x0000000000000563 (\GPIO) (20141107/utaddress-258)
[    3.012562] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    3.012563] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    3.034666] pata_jmicron 0000:02:00.1: enabling device (0100 -> 0101)
[    3.038490] scsi host10: pata_jmicron
[    3.040638] scsi host11: pata_jmicron
[    3.040729] ata11: PATA max UDMA/100 cmd 0xe040 ctl 0xe030 bmdma
0xe000 irq 17
[    3.040731] ata12: PATA max UDMA/100 cmd 0xe020 ctl 0xe010 bmdma
0xe008 irq 17
[    3.043901] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.043908] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have
ASPM control
[    3.044442] r8169 0000:03:00.0 eth0: RTL8168evl/8111evl at
0xffffc900018be000, bc:5f:f4:97:b1:6e, XID 0c900800 IRQ 30
[    3.044445] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200
bytes, tx checksumming: ko]
[    3.049769] [drm] Memory usable by graphics device = 2048M
[    3.049773] checking generic (e0000000 8d0000) vs hw (e0000000 10000000)
[    3.049775] fb: switching to inteldrmfb from VESA VGA
[    3.049791] Console: switching to colour dummy device 80x25
[    3.050871] [drm] Replacing VGA console driver
[    3.052870] media: Linux media interface: v0.10
[    3.057535] Linux video capture interface: v2.00
[    3.060103] mousedev: PS/2 mouse device common for all mice
[    3.068678] input: PC Speaker as /devices/platform/pcspkr/input/input8
[    3.070561] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    3.070563] [drm] Driver supports precise vblank timestamp query.
[    3.070654] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    3.079712] AVX version of gcm_enc/dec engaged.
[    3.079714] AES CTR mode by8 optimization enabled
[    3.082175] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    3.082371] acpi device:41: registered as cooling_device4
[    3.082428] input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input10
[    3.083060] [drm] Initialized i915 1.6.0 20141121 for 0000:00:02.0 on minor 0
[    3.083312] ACPI Warning: SystemIO range
0x000000000000f040-0x000000000000f05f conflicts with OpRegion
0x000000000000f040-0x000000000000f04f (\_SB_.PCI0.SBUS.SMBI)
(20141107/utaddress-258)
[    3.083317] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    3.107011] sound hdaudioC1D0: autoconfig: line_outs=3
(0x14/0x15/0x16/0x0/0x0) type:line
[    3.107014] sound hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.107015] sound hdaudioC1D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    3.107016] sound hdaudioC1D0:    mono: mono_out=0x0
[    3.107018] sound hdaudioC1D0:    dig-out=0x1e/0x0
[    3.107018] sound hdaudioC1D0:    inputs:
[    3.107020] sound hdaudioC1D0:      Front Mic=0x19
[    3.107022] sound hdaudioC1D0:      Rear Mic=0x18
[    3.107023] sound hdaudioC1D0:      Line=0x1a
[    3.114377] intel_rapl: Found RAPL domain package
[    3.114381] intel_rapl: Found RAPL domain core
[    3.114382] intel_rapl: Found RAPL domain uncore
[    3.120171] input: HDA Intel PCH Front Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card1/input11
[    3.120219] input: HDA Intel PCH Rear Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card1/input12
[    3.120257] input: HDA Intel PCH Line as
/devices/pci0000:00/0000:00:1b.0/sound/card1/input13
[    3.120306] input: HDA Intel PCH Line Out Front as
/devices/pci0000:00/0000:00:1b.0/sound/card1/input14
[    3.120345] input: HDA Intel PCH Line Out Surround as
/devices/pci0000:00/0000:00:1b.0/sound/card1/input15
[    3.120383] input: HDA Intel PCH Line Out CLFE as
/devices/pci0000:00/0000:00:1b.0/sound/card1/input16
[    3.120419] input: HDA Intel PCH Front Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card1/input17
[    3.129174] BTRFS info (device sdf2): disk space caching is enabled
[    3.130933] r8169 0000:03:00.0 enp3s0: renamed from eth0
[    3.134566] iTCO_vendor_support: vendor-support=0
[    3.134689] ppdev: user-space parallel port driver
[    3.134959] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    3.134990] iTCO_wdt: Found a Panther Point TCO device (Version=2,
TCOBASE=0x0460)
[    3.135056] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    3.147144] [drm] GMBUS [i915 gmbus dpc] timed out, falling back to
bit banging on pin 4
[    3.211597] fbcon: inteldrmfb (fb0) is primary device
[    3.240183] [drm:intel_set_pch_fifo_underrun_reporting [i915]]
*ERROR* uncleared pch fifo underrun on pch transcoder A
[    3.240197] [drm:intel_pch_fifo_underrun_irq_handler [i915]]
*ERROR* PCH transcoder A FIFO underrun
[    3.240254] Console: switching to colour frame buffer device 240x75
[    3.244750] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.244751] i915 0000:00:02.0: registered panic notifier
[    3.278262] usb 3-1.6: current rate 0 is different from the runtime
rate 16000
[    3.296775] usb 3-1.6: current rate 0 is different from the runtime
rate 24000
[    3.315254] usb 3-1.6: current rate 0 is different from the runtime
rate 32000
[    3.344913] uvcvideo: Found UVC 1.00 device <unnamed> (046d:0821)
[    3.365484] usbcore: registered new interface driver snd-usb-audio
[    3.368282] input: UVC Camera (046d:0821) as
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.6/3-1.6:1.2/input/input18
[    3.369226] usbcore: registered new interface driver uvcvideo
[    3.369229] USB Video Class driver (1.1.1)
[   34.001675] cfg80211: Calling CRDA to update world regulatory domain
[   34.382785] r8169 0000:03:00.0 enp3s0: link down
[   34.382802] r8169 0000:03:00.0 enp3s0: link down
[   36.043850] r8169 0000:03:00.0 enp3s0: link up
[   78.039253] BTRFS info (device sdc1): disk space caching is enabled
[   78.056020] BTRFS: failed to read chunk tree on sdc1
[   78.091062] BTRFS: open_ctree failed
[   84.729944] BTRFS info (device sdc1): allowing degraded mounts
[   84.729950] BTRFS info (device sdc1): disk space caching is enabled
[   84.754301] BTRFS warning (device sdc1): devid 2 missing
[   84.856408] BTRFS: bdev (null) errs: wr 13, rd 0, flush 0, corrupt 63, gen 5
[   84.856415] BTRFS: bdev /dev/sdc1 errs: wr 1176932, rd 99072, flush
5946, corrupt 2178961, gen 7557
[   84.856419] BTRFS: bdev /dev/sdd1 errs: wr 0, rd 0, flush 0,
corrupt 17, gen 0
[   84.856425] BTRFS: bdev /dev/sdi1 errs: wr 0, rd 0, flush 0,
corrupt 60, gen 0
[   84.856428] BTRFS: bdev /dev/sdg1 errs: wr 0, rd 0, flush 0,
corrupt 57, gen 0
[   93.111105] Bluetooth: Core ver 2.20
[   93.111127] NET: Registered protocol family 31
[   93.111128] Bluetooth: HCI device and connection manager initialized
[   93.111133] Bluetooth: HCI socket layer initialized
[   93.111136] Bluetooth: L2CAP socket layer initialized
[   93.111142] Bluetooth: SCO socket layer initialized
[   93.116333] Netfilter messages via NETLINK v0.30.
[  117.535217] BTRFS info (device sdc1): relocating block group
10792241987584 flags 17
[  133.386996] BTRFS info (device sdc1): csum failed ino 257 off
541310976 csum 4144645530 expected csum 4144645376
[  133.413795] BTRFS info (device sdc1): csum failed ino 257 off
541310976 csum 4144645530 expected csum 4144645376
[  133.423884] BTRFS info (device sdc1): csum failed ino 257 off
541310976 csum 4144645530 expected csum 4144645376
[  165.990563] usb 3-1.6: current rate 0 is different from the runtime
rate 32000
[  165.995065] usb 3-1.6: current rate 0 is different from the runtime
rate 32000
[  166.018576] usb 3-1.6: current rate 0 is different from the runtime
rate 32000
[  166.022943] usb 3-1.6: current rate 0 is different from the runtime
rate 32000
[  166.043983] usb 3-1.6: current rate 0 is different from the runtime
rate 32000
[  166.048316] usb 3-1.6: current rate 0 is different from the runtime
rate 32000
[  166.802599] fuse init (API version 7.23)
[  190.423918] nf_conntrack: automatic helper assignment is deprecated
and it will be removed soon. Use the iptables CT target to attach
helpers instead.
[  303.627547] BTRFS info (device sdc1): relocating block group
10792241987584 flags 17
[  308.604231] BTRFS info (device sdc1): csum failed ino 258 off
541310976 csum 4144645530 expected csum 4144645376
[  308.631229] BTRFS info (device sdc1): csum failed ino 258 off
541310976 csum 4144645530 expected csum 4144645376
[  308.641205] BTRFS info (device sdc1): csum failed ino 258 off
541310976 csum 4144645530 expected csum 4144645376
[ 1240.379575] BTRFS info (device sdc1): relocating block group
10792241987584 flags 17
[ 1247.867399] BTRFS info (device sdc1): csum failed ino 259 off
541310976 csum 4144645530 expected csum 4144645376
[ 1247.894211] BTRFS info (device sdc1): csum failed ino 259 off
541310976 csum 4144645530 expected csum 4144645376
[ 1247.904300] BTRFS info (device sdc1): csum failed ino 259 off
541310976 csum 4144645530 expected csum 4144645376
[ 9705.076883] i2c /dev entries driver
[ 9709.616337] nct6775: Found NCT6776D/F or compatible chip at 0x2e:0x290
[10658.959326] usb 3-1.5: USB disconnect, device number 3
[10673.991756] usb 3-1.5: new high-speed USB device number 5 using ehci-pci
[10923.998258] perf interrupt took too long (2558 > 2495), lowering
kernel.perf_event_max_sample_rate to 50100
