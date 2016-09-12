Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:53922 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751260AbcILV1e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 17:27:34 -0400
Received: from sandl.hnstr58.local ([88.67.15.65]) by smtp.web.de (mrweb101)
 with ESMTPSA (Nemesis) id 0Lky6L-1b97Po1jmv-00amwi for
 <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 23:27:30 +0200
From: Heinz Werner Kramski-Grote <kramski@web.de>
To: linux-btrfs@vger.kernel.org
Subject: Unable to repair "bad key order": Cyclic bad block flip-flop
Date: Mon, 12 Sep 2016 23:27:28 +0200
Message-ID: <4818221.8fBhXcTYy5@sandl.hnstr58.local>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart6091891.Exu2zIbWiW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart6091891.Exu2zIbWiW
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Due to bad RAM (now fixed), my (single disk) root partition got corrupted and 
no longer mounts with "corrupt leaf, bad key order":

    root@archiso ~ # mount /dev/sdh2 /mnt
    mount: wrong fs type, bad option, bad superblock on /dev/sdh2,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.

    root@archiso ~ # dmesg | grep -i btrfs                  
    [    8.513028] Btrfs loaded, crc32c=crc32c-generic
    [    8.513033] BTRFS: selftest: sectorsize: 4096  nodesize: 4096
    [    8.513035] BTRFS: selftest: sectorsize: 4096  nodesize: 8192
    [    8.513037] BTRFS: selftest: sectorsize: 4096  nodesize: 16384
    [    8.513039] BTRFS: selftest: sectorsize: 4096  nodesize: 32768
    [    8.513041] BTRFS: selftest: sectorsize: 4096  nodesize: 65536
    [    8.514927] BTRFS: device label btrfs devid 1 transid 36706 /dev/sdh2
    [    8.515047] BTRFS: device label data01 devid 1 transid 645 /dev/sdg1
    [  546.218691] BTRFS info (device sdh2): disk space caching is enabled
    [  546.218697] BTRFS info (device sdh2): has skinny extents
    [  546.225228] BTRFS critical (device sdh2): corrupt leaf, bad key order: 
block=75182981120,root=1, slot=0
    [  546.225303] BTRFS error (device sdh2): failed to recover balance: -5
    [  546.253399] BTRFS: open_ctree failed

Trying to repair the FS gets into a loop of two alternating bad blocks but 
never succeeds:

    root@archiso ~ # btrfs check --repair /dev/sdh2
    enabling repair mode
    Checking filesystem on /dev/sdh2
    UUID: e961bc76-09bb-4616-9263-dab61b8d0ef6
    checking extents
    bad key ordering 0 1
    bad block 75182981120
    Errors found in extent allocation tree or chunk allocation
    bad key ordering 0 1

    root@archiso ~ # btrfs check --repair /dev/sdh2
    enabling repair mode
    Checking filesystem on /dev/sdh2
    UUID: e961bc76-09bb-4616-9263-dab61b8d0ef6
    checking extents
    bad key ordering 0 1
    bad block 75183144960
    Errors found in extent allocation tree or chunk allocation
    bad key ordering 0 1

    root@archiso ~ # btrfs check --repair /dev/sdh2
    enabling repair mode
    Checking filesystem on /dev/sdh2
    UUID: e961bc76-09bb-4616-9263-dab61b8d0ef6
    checking extents
    bad key ordering 0 1
    bad block 75182981120
    Errors found in extent allocation tree or chunk allocation
    bad key ordering 0 1

    root@archiso ~ # btrfs check --repair /dev/sdh2
    enabling repair mode
    Checking filesystem on /dev/sdh2
    UUID: e961bc76-09bb-4616-9263-dab61b8d0ef6
    checking extents
    bad key ordering 0 1
    bad block 75183144960
    Errors found in extent allocation tree or chunk allocation
    bad key ordering 0 1

    [etc...]

According to smartctl, the disk itself (a quite new Samsung SSD) is healthy.

This is not a critical machine, but I would prefer to solve this issue over a 
new install. (I'm quite new to btrfs, though)

TIA
   Heinz
--nextPart6091891.Exu2zIbWiW
Content-Disposition: attachment; filename="dmesg.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="utf-8"; name="dmesg.log"

[    0.000000] microcode: microcode updated early to revision 0xd0, date = 2010-09-30
[    0.000000] Linux version 4.7.2-1-ARCH (builduser@tobias) (gcc version 6.1.1 20160802 (GCC) ) #1 SMP PREEMPT Sat Aug 20 23:02:56 CEST 2016
[    0.000000] Command line: BOOT_IMAGE=boot/x86_64/vmlinuz archisobasedir=arch archisolabel=ARCH_201609 initrd=boot/intel_ucode.img,boot/x86_64/archiso.img
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e4000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ff8ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ff90000-0x000000007ff9dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007ff9e000-0x000000007ffdffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007ffe0000-0x000000007fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000027fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: System manufacturer System Product Name/P5B-E, BIOS 1202    03/28/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x280000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 080000000 mask F80000000 uncachable
[    0.000000]   1 base 000000000 mask E00000000 write-back
[    0.000000]   2 base 200000000 mask F80000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] e820: update [mem 0x80000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x7ff90 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] BRK [0x01b58000, 0x01b58fff] PGTABLE
[    0.000000] BRK [0x01b59000, 0x01b59fff] PGTABLE
[    0.000000] BRK [0x01b5a000, 0x01b5afff] PGTABLE
[    0.000000] BRK [0x01b5b000, 0x01b5bfff] PGTABLE
[    0.000000] BRK [0x01b5c000, 0x01b5cfff] PGTABLE
[    0.000000] BRK [0x01b5d000, 0x01b5dfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x7e515000-0x7ff8ffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FA980 000024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 0x000000007FF90100 000054 (v01 KOZIRO FRONTIER 03000728 MSFT 00000097)
[    0.000000] ACPI: FACP 0x000000007FF90290 0000F4 (v03 MSTEST OEMFACP  03000728 MSFT 00000097)
[    0.000000] ACPI: DSDT 0x000000007FF905C0 008FA9 (v01 A0637  A0637000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 0x000000007FF9E000 000040
[    0.000000] ACPI: FACS 0x000000007FF9E000 000040
[    0.000000] ACPI: APIC 0x000000007FF90390 00006C (v01 MSTEST OEMAPIC  03000728 MSFT 00000097)
[    0.000000] ACPI: MCFG 0x000000007FF90400 00003C (v01 MSTEST OEMMCFG  03000728 MSFT 00000097)
[    0.000000] ACPI: SLIC 0x000000007FF90440 000176 (v01 KOZIRO FRONTIER 03000728 MSFT 00000097)
[    0.000000] ACPI: OEMB 0x000000007FF9E040 00007B (v01 MSTEST AMI_OEM  03000728 MSFT 00000097)
[    0.000000] ACPI: HPET 0x000000007FF99570 000038 (v01 MSTEST OEMHPET  03000728 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000027fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x27fff7000-0x27fffafff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000027fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009dfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000007ff8ffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000027fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000027fffffff]
[    0.000000] On node 0 totalpages: 2096941
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8127 pages used for memmap
[    0.000000]   DMA32 zone: 520080 pages, LIFO batch:31
[    0.000000]   Normal zone: 24576 pages used for memmap
[    0.000000]   Normal zone: 1572864 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a202 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e4000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ff90000-0x7ff9dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ff9e000-0x7ffdffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ffe0000-0x7fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x80000000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffafffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffb00000-0xffffffff]
[    0.000000] e820: [mem 0x80000000-0xfedfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370452778343963 ns
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] percpu: Embedded 33 pages/cpu @ffff88027fc00000 s97944 r8192 d29032 u524288
[    0.000000] pcpu-alloc: s97944 r8192 d29032 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 2064153
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=boot/x86_64/vmlinuz archisobasedir=arch archisolabel=ARCH_201609 initrd=boot/intel_ucode.img,boot/x86_64/archiso.img
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8150988K/8387764K available (6028K kernel code, 977K rwdata, 1836K rodata, 1244K init, 1164K bss, 236776K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=4
[    0.000000] NR_IRQS:8448 nr_irqs:456 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1868.050 MHz processor
[    0.003347] Calibrating delay loop (skipped), value calculated using timer frequency.. 3737.77 BogoMIPS (lpj=6226833)
[    0.003351] pid_max: default: 32768 minimum: 301
[    0.003362] ACPI: Core revision 20160422
[    0.013567] ACPI: 1 ACPI AML tables successfully acquired and loaded

[    0.013603] Security Framework initialized
[    0.013606] Yama: becoming mindful.
[    0.014434] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.018341] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.020226] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.020244] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.020735] CPU: Physical Processor ID: 0
[    0.020738] CPU: Processor Core ID: 0
[    0.020740] mce: CPU supports 6 MCE banks
[    0.020749] CPU0: Thermal monitoring enabled (TM2)
[    0.020755] process: using mwait in idle threads
[    0.020761] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.020763] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
[    0.021192] Freeing SMP alternatives memory: 24K (ffffffff81a2d000 - ffffffff81a33000)
[    0.023341] ftrace: allocating 23806 entries in 93 pages
[    0.033462] smpboot: Max logical packages: 2
[    0.033468] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.033846] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.069999] smpboot: CPU0: Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz (family: 0x6, model: 0xf, stepping: 0x6)
[    0.069999] Performance Events: PEBS fmt0-, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.069999] core: PEBS disabled due to CPU errata
[    0.069999] ... version:                2
[    0.069999] ... bit width:              40
[    0.069999] ... generic registers:      2
[    0.069999] ... value mask:             000000ffffffffff
[    0.069999] ... max period:             000000007fffffff
[    0.069999] ... fixed-purpose events:   3
[    0.069999] ... event mask:             0000000700000003
[    0.090125] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.106689] x86: Booting SMP configuration:
[    0.106693] .... node  #0, CPUs:      #1
[    0.192027] x86: Booted up 1 node, 2 CPUs
[    0.192027] smpboot: Total of 2 processors activated (7475.76 BogoMIPS)
[    0.193725] devtmpfs: initialized
[    0.193725] x86/mm: Memory block size: 128MB
[    0.198974] PM: Registering ACPI NVS region [mem 0x7ff9e000-0x7ffdffff] (270336 bytes)
[    0.198974] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370867519511994 ns
[    0.198974] pinctrl core: initialized pinctrl subsystem
[    0.198974] RTC time: 18:47:36, date: 09/12/16
[    0.198974] NET: Registered protocol family 16
[    0.213340] cpuidle: using governor ladder
[    0.226672] cpuidle: using governor menu
[    0.226707] ACPI: bus type PCI registered
[    0.226710] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.226809] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.226813] PCI: not using MMCONFIG
[    0.226815] PCI: Using configuration type 1 for base access
[    0.240056] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.240065] ACPI: Added _OSI(Module Device)
[    0.240068] ACPI: Added _OSI(Processor Device)
[    0.240070] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.240072] ACPI: Added _OSI(Processor Aggregator Device)
[    0.240270] ACPI: Executed 1 blocks of module-level executable AML code
[    0.245770] ACPI: Dynamic OEM Table Load:
[    0.245779] ACPI: SSDT 0xFFFF8802763F4800 0001C6 (v01 AMI    CPU1PM   00000001 INTL 20060113)
[    0.246359] ACPI: Dynamic OEM Table Load:
[    0.246366] ACPI: SSDT 0xFFFF8802763F4A00 00013A (v01 AMI    CPU2PM   00000001 INTL 20060113)
[    0.247281] ACPI: Interpreter enabled
[    0.247305] ACPI: (supports S0 S3 S4 S5)
[    0.247308] ACPI: Using IOAPIC for interrupt routing
[    0.247346] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.248091] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.248098] pmd_set_huge: Cannot satisfy [mem 0xe0000000-0xe0200000] with a huge-page mapping due to MTRR override.
[    0.249247] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.257848] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.257855] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.257863] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.258136] PCI host bridge to bus 0000:00
[    0.258140] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.258143] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.258146] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.258149] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff window]
[    0.258152] pci_bus 0000:00: root bus resource [mem 0x80000000-0xffffffff window]
[    0.258156] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.258167] pci 0000:00:00.0: [8086:29a0] type 00 class 0x060000
[    0.258299] pci 0000:00:01.0: [8086:29a1] type 01 class 0x060400
[    0.258347] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.258401] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.258485] pci 0000:00:1a.0: [8086:2834] type 00 class 0x0c0300
[    0.258527] pci 0000:00:1a.0: reg 0x20: [io  0xe000-0xe01f]
[    0.258618] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.258681] pci 0000:00:1a.1: [8086:2835] type 00 class 0x0c0300
[    0.258722] pci 0000:00:1a.1: reg 0x20: [io  0xe080-0xe09f]
[    0.258812] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    0.258885] pci 0000:00:1a.7: [8086:283a] type 00 class 0x0c0320
[    0.258904] pci 0000:00:1a.7: reg 0x10: [mem 0xffaff400-0xffaff7ff]
[    0.258986] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.259039] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    0.259105] pci 0000:00:1b.0: [8086:284b] type 00 class 0x040300
[    0.259123] pci 0000:00:1b.0: reg 0x10: [mem 0xffaf8000-0xffafbfff 64bit]
[    0.259198] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.259310] pci 0000:00:1c.0: [8086:283f] type 01 class 0x060400
[    0.259383] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.259441] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.259509] pci 0000:00:1c.1: [8086:2841] type 01 class 0x060400
[    0.259582] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.259637] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.259703] pci 0000:00:1c.3: [8086:2845] type 01 class 0x060400
[    0.259776] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.259834] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.259898] pci 0000:00:1d.0: [8086:2830] type 00 class 0x0c0300
[    0.259939] pci 0000:00:1d.0: reg 0x20: [io  0xd800-0xd81f]
[    0.260035] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.260099] pci 0000:00:1d.1: [8086:2831] type 00 class 0x0c0300
[    0.260140] pci 0000:00:1d.1: reg 0x20: [io  0xd880-0xd89f]
[    0.260230] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.260292] pci 0000:00:1d.2: [8086:2832] type 00 class 0x0c0300
[    0.260333] pci 0000:00:1d.2: reg 0x20: [io  0xdc00-0xdc1f]
[    0.260422] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.260491] pci 0000:00:1d.7: [8086:2836] type 00 class 0x0c0320
[    0.260509] pci 0000:00:1d.7: reg 0x10: [mem 0xffaff000-0xffaff3ff]
[    0.260592] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.260644] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.260708] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.260804] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.260868] pci 0000:00:1f.0: [8086:2810] type 00 class 0x060100
[    0.260949] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.260955] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
[    0.260959] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
[    0.261088] pci 0000:00:1f.2: [8086:2821] type 00 class 0x010601
[    0.261105] pci 0000:00:1f.2: reg 0x10: [io  0xec00-0xec07]
[    0.261114] pci 0000:00:1f.2: reg 0x14: [io  0xe880-0xe883]
[    0.261122] pci 0000:00:1f.2: reg 0x18: [io  0xe800-0xe807]
[    0.261131] pci 0000:00:1f.2: reg 0x1c: [io  0xe480-0xe483]
[    0.261140] pci 0000:00:1f.2: reg 0x20: [io  0xe400-0xe41f]
[    0.261149] pci 0000:00:1f.2: reg 0x24: [mem 0xffaff800-0xffafffff]
[    0.261191] pci 0000:00:1f.2: PME# supported from D3hot
[    0.261299] pci 0000:00:1f.3: [8086:283e] type 00 class 0x0c0500
[    0.261313] pci 0000:00:1f.3: reg 0x10: [mem 0x00000000-0x000000ff]
[    0.261341] pci 0000:00:1f.3: reg 0x20: [io  0x0400-0x041f]
[    0.261501] pci 0000:01:00.0: [1002:954f] type 00 class 0x030000
[    0.261518] pci 0000:01:00.0: reg 0x10: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.261530] pci 0000:01:00.0: reg 0x18: [mem 0xff6f0000-0xff6fffff 64bit]
[    0.261539] pci 0000:01:00.0: reg 0x20: [io  0xb000-0xb0ff]
[    0.261553] pci 0000:01:00.0: reg 0x30: [mem 0xff6c0000-0xff6dffff pref]
[    0.261592] pci 0000:01:00.0: supports D1 D2
[    0.261656] pci 0000:01:00.1: [1002:aa38] type 00 class 0x040300
[    0.261672] pci 0000:01:00.1: reg 0x10: [mem 0xff6ec000-0xff6effff 64bit]
[    0.261739] pci 0000:01:00.1: supports D1 D2
[    0.261815] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.261819] pci 0000:00:01.0:   bridge window [io  0x9000-0xbfff]
[    0.261823] pci 0000:00:01.0:   bridge window [mem 0xff600000-0xff6fffff]
[    0.261828] pci 0000:00:01.0:   bridge window [mem 0xbfe00000-0xdfdfffff 64bit pref]
[    0.261887] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    0.261898] pci 0000:00:1c.0:   bridge window [mem 0xdfe00000-0xdfefffff 64bit pref]
[    0.261979] pci 0000:03:00.0: [1912:0015] type 00 class 0x0c0330
[    0.262020] pci 0000:03:00.0: reg 0x10: [mem 0xff8fe000-0xff8fffff 64bit]
[    0.262216] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.266694] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.266702] pci 0000:00:1c.1:   bridge window [mem 0xff800000-0xff8fffff]
[    0.266785] pci 0000:02:00.0: [1969:1048] type 00 class 0x020000
[    0.266814] pci 0000:02:00.0: reg 0x10: [mem 0xff7c0000-0xff7fffff 64bit]
[    0.266871] pci 0000:02:00.0: reg 0x30: [mem 0xff7a0000-0xff7bffff pref]
[    0.266951] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.267031] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.267041] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    0.267048] pci 0000:00:1c.3:   bridge window [mem 0xff700000-0xff7fffff]
[    0.267107] pci 0000:05:01.0: [1106:3038] type 00 class 0x0c0300
[    0.267156] pci 0000:05:01.0: reg 0x20: [io  0xc880-0xc89f]
[    0.267261] pci 0000:05:01.1: [1106:3038] type 00 class 0x0c0300
[    0.267309] pci 0000:05:01.1: reg 0x20: [io  0xcc00-0xcc1f]
[    0.267415] pci 0000:05:01.2: [1106:3104] type 00 class 0x0c0320
[    0.267433] pci 0000:05:01.2: reg 0x10: [mem 0xff9ffc00-0xff9ffcff]
[    0.267512] pci 0000:05:01.2: PME# supported from D0 D3hot
[    0.267589] pci 0000:05:02.0: [1131:7146] type 00 class 0x048000
[    0.267604] pci 0000:05:02.0: reg 0x10: [mem 0xff9ff800-0xff9ff9ff]
[    0.267723] pci 0000:05:03.0: [1106:3044] type 00 class 0x0c0010
[    0.267741] pci 0000:05:03.0: reg 0x10: [mem 0xff9ff000-0xff9ff7ff]
[    0.267752] pci 0000:05:03.0: reg 0x14: [io  0xc800-0xc87f]
[    0.267827] pci 0000:05:03.0: supports D2
[    0.267830] pci 0000:05:03.0: PME# supported from D2 D3hot D3cold
[    0.267931] pci 0000:00:1e.0: PCI bridge to [bus 05] (subtractive decode)
[    0.267936] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    0.267941] pci 0000:00:1e.0:   bridge window [mem 0xff900000-0xff9fffff]
[    0.267947] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7 window] (subtractive decode)
[    0.267950] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff window] (subtractive decode)
[    0.267953] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
[    0.267956] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff window] (subtractive decode)
[    0.267959] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xffffffff window] (subtractive decode)
[    0.268864] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.268939] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.269011] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.269082] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.269153] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.269225] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.269296] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.269367] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
[    0.269447] ACPI: Enabled 2 GPEs in block 00 to 1F
[    0.269580] vgaarb: setting as boot device: PCI:0000:01:00.0
[    0.269580] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.269580] vgaarb: loaded
[    0.269580] vgaarb: bridge control possible 0000:01:00.0
[    0.269580] PCI: Using ACPI for IRQ routing
[    0.275667] PCI: pci_cache_line_size set to 64 bytes
[    0.275737] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    0.275740] e820: reserve RAM buffer [mem 0x7ff90000-0x7fffffff]
[    0.275894] NetLabel: Initializing
[    0.275897] NetLabel:  domain hash size = 128
[    0.275898] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.275917] NetLabel:  unlabeled traffic allowed by default
[    0.276038] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.276043] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.276049] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.283348] amd_nb: Cannot enumerate AMD northbridges
[    0.283366] clocksource: Switched to clocksource hpet
[    0.293253] VFS: Disk quotas dquot_6.6.0
[    0.293284] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.293432] pnp: PnP ACPI init
[    0.293561] system 00:00: [mem 0xfed14000-0xfed19fff] has been reserved
[    0.293569] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.293662] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.293937] pnp 00:02: [dma 0 disabled]
[    0.294029] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.294329] pnp 00:03: [dma 2]
[    0.294395] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.294491] system 00:04: [io  0x0290-0x0297] has been reserved
[    0.294496] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.294695] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.294699] system 00:05: [io  0x0800-0x087f] has been reserved
[    0.294702] system 00:05: [io  0x0480-0x04bf] has been reserved
[    0.294706] system 00:05: [mem 0xffafe000-0xffb0cbff] could not be reserved
[    0.294710] system 00:05: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.294713] system 00:05: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.294716] system 00:05: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.294719] system 00:05: [mem 0xfff00000-0xfffffffe] has been reserved
[    0.294722] system 00:05: [mem 0xfebfe000-0xfebfec00] has been reserved
[    0.294727] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.295143] pnp 00:06: [dma 3]
[    0.295297] pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.295407] system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.295411] system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.295416] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.295555] system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
[    0.295560] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.295791] system 00:09: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.295795] system 00:09: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.295799] system 00:09: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.295802] system 00:09: [mem 0x00100000-0x7fffffff] could not be reserved
[    0.295807] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.295964] pnp: PnP ACPI: found 10 devices
[    0.303549] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.303574] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[    0.303578] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 04] add_size 400000 add_align 100000
[    0.303588] pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.303592] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000 add_align 100000
[    0.303601] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.303604] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000 add_align 100000
[    0.303620] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] res_to_dev_res add_size 400000 min_align 100000
[    0.303623] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x004fffff] res_to_dev_res add_size 400000 min_align 100000
[    0.303627] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.303630] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.303633] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.303636] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.303640] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.303643] pci 0000:00:1c.0: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.303646] pci 0000:00:1c.1: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.303649] pci 0000:00:1c.1: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.303652] pci 0000:00:1c.3: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.303655] pci 0000:00:1c.3: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.303662] pci 0000:00:1c.0: BAR 14: assigned [mem 0x80000000-0x803fffff]
[    0.303669] pci 0000:00:1c.1: BAR 15: assigned [mem 0x80400000-0x805fffff 64bit pref]
[    0.303675] pci 0000:00:1c.3: BAR 15: assigned [mem 0x80600000-0x807fffff 64bit pref]
[    0.303679] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.303682] pci 0000:00:1c.1: BAR 13: assigned [io  0x2000-0x2fff]
[    0.303686] pci 0000:00:1c.3: BAR 13: assigned [io  0x3000-0x3fff]
[    0.303690] pci 0000:00:1f.3: BAR 0: assigned [mem 0x80800000-0x808000ff]
[    0.303697] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.303700] pci 0000:00:01.0:   bridge window [io  0x9000-0xbfff]
[    0.303705] pci 0000:00:01.0:   bridge window [mem 0xff600000-0xff6fffff]
[    0.303709] pci 0000:00:01.0:   bridge window [mem 0xbfe00000-0xdfdfffff 64bit pref]
[    0.303714] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    0.303718] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.303723] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x803fffff]
[    0.303728] pci 0000:00:1c.0:   bridge window [mem 0xdfe00000-0xdfefffff 64bit pref]
[    0.303734] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.303738] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.303743] pci 0000:00:1c.1:   bridge window [mem 0xff800000-0xff8fffff]
[    0.303747] pci 0000:00:1c.1:   bridge window [mem 0x80400000-0x805fffff 64bit pref]
[    0.303754] pci 0000:00:1c.3: PCI bridge to [bus 02]
[    0.303758] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.303763] pci 0000:00:1c.3:   bridge window [mem 0xff700000-0xff7fffff]
[    0.303767] pci 0000:00:1c.3:   bridge window [mem 0x80600000-0x807fffff 64bit pref]
[    0.303775] pci 0000:00:1e.0: PCI bridge to [bus 05]
[    0.303779] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    0.303784] pci 0000:00:1e.0:   bridge window [mem 0xff900000-0xff9fffff]
[    0.303793] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.303796] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.303799] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.303802] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff window]
[    0.303805] pci_bus 0000:00: resource 8 [mem 0x80000000-0xffffffff window]
[    0.303808] pci_bus 0000:01: resource 0 [io  0x9000-0xbfff]
[    0.303811] pci_bus 0000:01: resource 1 [mem 0xff600000-0xff6fffff]
[    0.303814] pci_bus 0000:01: resource 2 [mem 0xbfe00000-0xdfdfffff 64bit pref]
[    0.303817] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.303820] pci_bus 0000:04: resource 1 [mem 0x80000000-0x803fffff]
[    0.303823] pci_bus 0000:04: resource 2 [mem 0xdfe00000-0xdfefffff 64bit pref]
[    0.303825] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    0.303828] pci_bus 0000:03: resource 1 [mem 0xff800000-0xff8fffff]
[    0.303831] pci_bus 0000:03: resource 2 [mem 0x80400000-0x805fffff 64bit pref]
[    0.303834] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.303837] pci_bus 0000:02: resource 1 [mem 0xff700000-0xff7fffff]
[    0.303839] pci_bus 0000:02: resource 2 [mem 0x80600000-0x807fffff 64bit pref]
[    0.303842] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.303845] pci_bus 0000:05: resource 1 [mem 0xff900000-0xff9fffff]
[    0.303848] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7 window]
[    0.303851] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff window]
[    0.303854] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.303857] pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000dffff window]
[    0.303859] pci_bus 0000:05: resource 8 [mem 0x80000000-0xffffffff window]
[    0.303896] NET: Registered protocol family 2
[    0.304137] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.304373] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.304692] TCP: Hash tables configured (established 65536 bind 65536)
[    0.304744] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.304799] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.304933] NET: Registered protocol family 1
[    0.554977] pci 0000:01:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.554991] pci 0000:00:1c.1: enabling device (0106 -> 0107)
[    0.555162] pci 0000:02:00.0: [Firmware Bug]: VPD access disabled
[    0.555520] PCI: CLS 32 bytes, default 64
[    0.555603] Unpacking initramfs...
[    4.704149] Freeing initrd memory: 27116K (ffff88007e515000 - ffff88007ff90000)
[    4.704158] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.704162] software IO TLB [mem 0x7a515000-0x7e515000] (64MB) mapped at [ffff88007a515000-ffff88007e514fff]
[    4.704315] Scanning for low memory corruption every 60 seconds
[    4.704795] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    4.705278] Initialise system trusted keyrings
[    4.705411] workingset: timestamp_bits=38 max_order=21 bucket_order=0
[    4.708432] zbud: loaded
[    4.708741] Key type big_key registered
[    4.709009] Key type asymmetric registered
[    4.709066] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
[    4.709111] io scheduler noop registered
[    4.709114] io scheduler deadline registered
[    4.709167] io scheduler cfq registered (default)
[    4.709480] pcieport 0000:00:1c.0: enabling device (0106 -> 0107)
[    4.709714] pcieport 0000:00:1c.3: enabling device (0106 -> 0107)
[    4.709899] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.709909] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.709930] intel_idle: does not run on family 6 model 15
[    4.710439] GHES: HEST is not enabled!
[    4.710510] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.731019] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    4.731551] Linux agpgart interface v0.103
[    4.731805] rtc_cmos 00:01: RTC can wake from S4
[    4.731946] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    4.731975] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.731994] ledtrig-cpu: registered to indicate activity on CPUs
[    4.732530] NET: Registered protocol family 10
[    4.732793] NET: Registered protocol family 17
[    4.732998] microcode: CPU0 sig=0x6f6, pf=0x1, revision=0xd0
[    4.733008] microcode: CPU1 sig=0x6f6, pf=0x1, revision=0xd0
[    4.733058] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.733246] registered taskstats version 1
[    4.733250] Loading compiled-in X.509 certificates
[    4.733266] zswap: loaded using pool lzo/zbud
[    4.735570]   Magic number: 0:67:797
[    4.735671] rtc_cmos 00:01: setting system clock to 2016-09-12 18:47:40 UTC (1473706060)
[    4.735733] PM: Hibernation image not present or could not be loaded.
[    4.737435] Freeing unused kernel memory: 1244K (ffffffff818f6000 - ffffffff81a2d000)
[    4.737438] Write protecting the kernel read-only data: 8192k
[    4.737640] Freeing unused kernel memory: 100K (ffff8800015e7000 - ffff880001600000)
[    4.738409] Freeing unused kernel memory: 212K (ffff8800017cb000 - ffff880001800000)
[    4.749338] random: systemd-tmpfile: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    4.749468] random: systemd-tmpfile: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    4.749495] random: systemd-tmpfile: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    4.749523] random: systemd-tmpfile: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    4.752085] random: systemd-udevd: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    4.752163] random: systemd-udevd: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    4.752182] random: systemd-udevd: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    4.753907] random: udevadm: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    4.753946] random: udevadm: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    4.758924] random: systemd-udevd: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    4.806397] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    4.806405] ACPI: Power Button [PWRB]
[    4.806500] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.806504] ACPI: Power Button [PWRF]
[    4.808760] FUJITSU Extended Socket Network Device Driver - version 1.1 - Copyright (c) 2015 FUJITSU LIMITED
[    4.811746] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    4.814823] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.814832] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.815773] Floppy drive(s): fd0 is 1.44M
[    4.821457] [drm] Initialized drm 1.1.0 20060810
[    4.826505] ACPI: bus type USB registered
[    4.826566] usbcore: registered new interface driver usbfs
[    4.826587] usbcore: registered new interface driver hub
[    4.826648] usbcore: registered new device driver usb
[    4.827557] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.827812] ehci-pci: EHCI PCI platform driver
[    4.828079] ehci-pci 0000:00:1a.7: EHCI Host Controller
[    4.828097] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    4.828117] ehci-pci 0000:00:1a.7: debug port 1
[    4.830527] FDC 0 is a post-1991 82077
[    4.832980] ehci-pci 0000:00:1a.7: cache line size of 32 is not supported
[    4.833008] ehci-pci 0000:00:1a.7: irq 18, io mem 0xffaff400
[    4.836286] [drm] radeon kernel modesetting enabled.
[    4.838078] atl1 0000:02:00.0: version 2.1.3
[    4.838580] [drm] initializing kernel modesetting (RV710 0x1002:0x954F 0x174B:0xE113 0x00).
[    4.838591] [drm] register mmio base: 0xFF6F0000
[    4.838593] [drm] register mmio size: 65536
[    4.839322] ATOM BIOS: HD4350
[    4.839363] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    4.839367] radeon 0000:01:00.0: GTT: 1024M 0x0000000040000000 - 0x000000007FFFFFFF
[    4.839370] [drm] Detected VRAM RAM=1024M, BAR=256M
[    4.839372] [drm] RAM width 64bits DDR
[    4.839443] [TTM] Zone  kernel: Available graphics memory: 4089842 kiB
[    4.839446] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    4.839448] [TTM] Initializing pool allocator
[    4.839456] [TTM] Initializing DMA pool allocator
[    4.839483] [drm] radeon: 1024M of VRAM memory ready
[    4.839485] [drm] radeon: 1024M of GTT memory ready.
[    4.839504] [drm] Loading RV710 Microcode
[    4.839957] [drm] Internal thermal controller with fan control
[    4.840047] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.840299] hub 1-0:1.0: USB hub found
[    4.840311] hub 1-0:1.0: 4 ports detected
[    4.840525] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    4.840534] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 2
[    4.842718] [drm] radeon: dpm initialized
[    4.842835] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    4.845877] xhci_hcd 0000:03:00.0: hcc params 0x014050cf hci version 0x100 quirks 0x00000090
[    4.850269] hub 2-0:1.0: USB hub found
[    4.850695] hub 2-0:1.0: 2 ports detected
[    4.850892] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    4.850902] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 3
[    4.850918] ehci-pci 0000:00:1d.7: debug port 1
[    4.854836] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
[    4.854854] ehci-pci 0000:00:1d.7: irq 23, io mem 0xffaff000
[    4.854873] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    4.854878] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 4
[    4.854933] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
[    4.855131] hub 4-0:1.0: USB hub found
[    4.855147] hub 4-0:1.0: 2 ports detected
[    4.864197] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.864452] hub 3-0:1.0: USB hub found
[    4.864464] hub 3-0:1.0: 6 ports detected
[    4.864855] ehci-pci 0000:05:01.2: EHCI Host Controller
[    4.864865] ehci-pci 0000:05:01.2: new USB bus registered, assigned bus number 5
[    4.864914] ehci-pci 0000:05:01.2: irq 20, io mem 0xff9ffc00
[    4.869216] [drm] PCIE GART of 1024M enabled (table at 0x000000000014C000).
[    4.869270] radeon 0000:01:00.0: WB enabled
[    4.869276] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff880270392c00
[    4.869279] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000040000c0c and cpu addr 0xffff880270392c0c
[    4.869673] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x000000000005c598 and cpu addr 0xffffc9000101c598
[    4.869676] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.869678] [drm] Driver supports precise vblank timestamp query.
[    4.869681] radeon 0000:01:00.0: radeon: MSI limited to 32-bit
[    4.869719] radeon 0000:01:00.0: radeon: using MSI.
[    4.869753] [drm] radeon: irq initialized.
[    4.873422] ehci-pci 0000:05:01.2: USB 2.0 started, EHCI 0.95
[    4.873681] hub 5-0:1.0: USB hub found
[    4.873693] hub 5-0:1.0: 4 ports detected
[    4.874434] uhci_hcd: USB Universal Host Controller Interface driver
[    4.874587] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.874597] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 6
[    4.874606] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.874636] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e000
[    4.875347] hub 6-0:1.0: USB hub found
[    4.875359] hub 6-0:1.0: 2 ports detected
[    4.875634] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.875643] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 7
[    4.875651] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.875680] uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000e080
[    4.875897] hub 7-0:1.0: USB hub found
[    4.875908] hub 7-0:1.0: 2 ports detected
[    4.876150] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.876159] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 8
[    4.876166] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.876185] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d800
[    4.876400] hub 8-0:1.0: USB hub found
[    4.876414] hub 8-0:1.0: 2 ports detected
[    4.876660] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.876690] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 9
[    4.876698] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.877386] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d880
[    4.877602] hub 9-0:1.0: USB hub found
[    4.877612] hub 9-0:1.0: 2 ports detected
[    4.877849] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.877857] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 10
[    4.877865] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.877884] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000dc00
[    4.878099] hub 10-0:1.0: USB hub found
[    4.878110] hub 10-0:1.0: 2 ports detected
[    4.878346] uhci_hcd 0000:05:01.0: UHCI Host Controller
[    4.878354] uhci_hcd 0000:05:01.0: new USB bus registered, assigned bus number 11
[    4.878361] uhci_hcd 0000:05:01.0: detected 2 ports
[    4.878387] uhci_hcd 0000:05:01.0: irq 22, io base 0x0000c880
[    4.878600] hub 11-0:1.0: USB hub found
[    4.878610] hub 11-0:1.0: 2 ports detected
[    4.878828] uhci_hcd 0000:05:01.1: UHCI Host Controller
[    4.878836] uhci_hcd 0000:05:01.1: new USB bus registered, assigned bus number 12
[    4.878843] uhci_hcd 0000:05:01.1: detected 2 ports
[    4.878864] uhci_hcd 0000:05:01.1: irq 23, io base 0x0000cc00
[    4.879080] hub 12-0:1.0: USB hub found
[    4.879090] hub 12-0:1.0: 2 ports detected
[    4.884996] SCSI subsystem initialized
[    4.892730] libata version 3.00 loaded.
[    4.894425] ahci 0000:00:1f.2: version 3.0
[    4.894619] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    4.894654] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    4.894659] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum part ccc ems 
[    4.929726] [drm] ring test on 0 succeeded in 1 usecs
[    4.929735] [drm] ring test on 3 succeeded in 2 usecs
[    4.933358] scsi host0: ahci
[    4.940022] scsi host1: ahci
[    4.946724] firewire_ohci 0000:05:03.0: added OHCI v1.0 device as card 0, 4 IR + 8 IT contexts, quirks 0x11
[    4.946775] scsi host2: ahci
[    4.947334] scsi host3: ahci
[    4.950185] scsi host4: ahci
[    4.953439] scsi host5: ahci
[    4.953534] ata1: SATA max UDMA/133 abar m2048@0xffaff800 port 0xffaff900 irq 32
[    4.953538] ata2: SATA max UDMA/133 abar m2048@0xffaff800 port 0xffaff980 irq 32
[    4.953542] ata3: SATA max UDMA/133 abar m2048@0xffaff800 port 0xffaffa00 irq 32
[    4.953545] ata4: SATA max UDMA/133 abar m2048@0xffaff800 port 0xffaffa80 irq 32
[    4.953548] ata5: SATA max UDMA/133 abar m2048@0xffaff800 port 0xffaffb00 irq 32
[    4.953550] ata6: SATA max UDMA/133 abar m2048@0xffaff800 port 0xffaffb80 irq 32
[    4.996693] blk_update_request: I/O error, dev fd0, sector 0
[    4.996727] floppy: error -5 while reading block 0
[    5.116044] [drm] ring test on 5 succeeded in 1 usecs
[    5.116049] [drm] UVD initialized successfully.
[    5.116459] [drm] ib test on ring 0 succeeded in 0 usecs
[    5.116478] [drm] ib test on ring 3 succeeded in 0 usecs
[    5.146683] usb 1-2: new high-speed USB device number 2 using ehci-pci
[    5.180012] usb 5-1: new high-speed USB device number 2 using ehci-pci
[    5.274471] usb-storage 1-2:1.0: USB Mass Storage device detected
[    5.278061] scsi host6: usb-storage 1-2:1.0
[    5.278192] usbcore: registered new interface driver usb-storage
[    5.278629] usbcore: registered new interface driver uas
[    5.303414] usb 8-1: new low-speed USB device number 2 using uhci_hcd
[    5.305417] hub 5-1:1.0: USB hub found
[    5.305739] hub 5-1:1.0: 4 ports detected
[    5.376700] usb 1-4: new high-speed USB device number 3 using ehci-pci
[    5.416716] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.419697] ata1.00: ATAPI: HL-DT-ST DVDRAM GH22LS50, TL01, max UDMA/100
[    5.423503] ata1.00: configured for UDMA/100
[    5.435853] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH22LS50  TL01 PQ: 0 ANSI: 5
[    5.446803] firewire_core 0000:05:03.0: created device fw0: GUID 0011d80000e8220c, S400
[    5.475817] hidraw: raw HID events driver (C) Jiri Kosina
[    5.491597] usbcore: registered new interface driver usbhid
[    5.491601] usbhid: USB HID core driver
[    5.492737] input: Logitech USB Mouse as /devices/pci0000:00/0000:00:1d.0/usb8/8-1/8-1:1.0/0003:046D:C00C.0001/input/input4
[    5.492801] hid-generic 0003:046D:C00C.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB Mouse] on usb-0000:00:1d.0-1/input0
[    5.700240] usb 8-2: new full-speed USB device number 3 using uhci_hcd
[    5.706702] tsc: Refined TSC clocksource calibration: 1868.159 MHz
[    5.706707] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x35db5a63b89, max_idle_ns: 881590710307 ns
[    5.773409] [drm] ib test on ring 5 succeeded
[    5.777425] [drm] Radeon Display Connectors
[    5.777429] [drm] Connector 0:
[    5.777431] [drm]   DVI-I-1
[    5.777433] [drm]   HPD1
[    5.777436] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    5.777438] [drm]   Encoders:
[    5.777440] [drm]     DFP1: INTERNAL_UNIPHY
[    5.777442] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    5.777444] [drm] Connector 1:
[    5.777446] [drm]   DIN-1
[    5.777448] [drm]   Encoders:
[    5.777449] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[    5.777462] [drm] Connector 2:
[    5.777463] [drm]   DVI-I-2
[    5.777465] [drm]   HPD4
[    5.777467] [drm]   DDC: 0x7f10 0x7f10 0x7f14 0x7f14 0x7f18 0x7f18 0x7f1c 0x7f1c
[    5.777469] [drm]   Encoders:
[    5.777470] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    5.777472] [drm]     DFP2: INTERNAL_UNIPHY2
[    5.853444] [drm] fb mappable at 0xC034D000
[    5.853452] [drm] vram apper at 0xC0000000
[    5.853454] [drm] size 5242880
[    5.853456] [drm] fb depth is 24
[    5.853457] [drm]    pitch is 5120
[    5.853544] fbcon: radeondrmfb (fb0) is primary device
[    5.906691] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.912273] Console: switching to colour frame buffer device 160x64
[    5.916231] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[    5.938800] input: Fujitsu Siemens Computers SmartCard Keyboard USB 2A as /devices/pci0000:00/0000:00:1d.0/usb8/8-2/8-2:1.0/0003:0BF8:1005.0002/input/input5
[    5.939509] [drm] Initialized radeon 2.45.0 20080528 for 0000:01:00.0 on minor 0
[    5.967905] usb-storage 1-4:1.0: USB Mass Storage device detected
[    5.968099] scsi host7: usb-storage 1-4:1.0
[    5.990118] hid-generic 0003:0BF8:1005.0002: input,hidraw1: USB HID v1.11 Keyboard [Fujitsu Siemens Computers SmartCard Keyboard USB 2A] on usb-0000:00:1d.0-2/input0
[    5.998342] input: Fujitsu Siemens Computers SmartCard Keyboard USB 2A as /devices/pci0000:00/0000:00:1d.0/usb8/8-2/8-2:1.2/0003:0BF8:1005.0003/input/input6
[    6.050103] hid-generic 0003:0BF8:1005.0003: input,hidraw2: USB HID v1.11 Device [Fujitsu Siemens Computers SmartCard Keyboard USB 2A] on usb-0000:00:1d.0-2/input2
[    6.281001] scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[    6.281617] scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[    6.282366] scsi 6:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[    6.282990] scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[    6.289863] sd 6:0:0:1: [sdb] Attached SCSI removable disk
[    6.291739] sd 6:0:0:0: [sda] Attached SCSI removable disk
[    6.297987] sd 6:0:0:2: [sdc] Attached SCSI removable disk
[    6.299619] sd 6:0:0:3: [sdd] Attached SCSI removable disk
[    6.397407] ata2.00: ATA-8: WDC WD15EADS-00P8B0, 01.00A01, max UDMA/133
[    6.397412] ata2.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    6.400856] ata2.00: configured for UDMA/133
[    6.401063] scsi 1:0:0:0: Direct-Access     ATA      WDC WD15EADS-00P 0A01 PQ: 0 ANSI: 5
[    6.426947] sd 1:0:0:0: [sde] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    6.427022] sd 1:0:0:0: [sde] Write Protect is off
[    6.427026] sd 1:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    6.427063] sd 1:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.459327]  sde: sde1 sde2 sde3
[    6.459794] sd 1:0:0:0: [sde] Attached SCSI disk
[    6.706753] clocksource: Switched to clocksource tsc
[    6.736706] ata3: SATA link down (SStatus 0 SControl 300)
[    6.970889] scsi 7:0:0:0: Direct-Access     ChipsBnk   Multi-Reader   4082 PQ: 0 ANSI: 2
[    6.972634] sd 7:0:0:0: [sdf] 1964032 512-byte logical blocks: (1.01 GB/959 MiB)
[    6.973254] sd 7:0:0:0: [sdf] Write Protect is off
[    6.973258] sd 7:0:0:0: [sdf] Mode Sense: 0b 00 00 08
[    6.973878] sd 7:0:0:0: [sdf] No Caching mode page found
[    6.973920] sd 7:0:0:0: [sdf] Assuming drive cache: write through
[    6.977515]  sdf: sdf1 sdf2
[    6.981433] sd 7:0:0:0: [sdf] Attached SCSI removable disk
[    7.200040] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.201051] ata4.00: ATA-8: Hitachi HDS5C3020BLE630, MZ4OAAB0, max UDMA/133
[    7.201056] ata4.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    7.202122] ata4.00: configured for UDMA/133
[    7.202323] scsi 3:0:0:0: Direct-Access     ATA      Hitachi HDS5C302 AAB0 PQ: 0 ANSI: 5
[    7.226979] sd 3:0:0:0: [sdg] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
[    7.226984] sd 3:0:0:0: [sdg] 4096-byte physical blocks
[    7.227059] sd 3:0:0:0: [sdg] Write Protect is off
[    7.227063] sd 3:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    7.227101] sd 3:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.239004]  sdg: sdg1
[    7.239342] sd 3:0:0:0: [sdg] Attached SCSI disk
[    7.536697] ata5: SATA link down (SStatus 0 SControl 300)
[    8.000056] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    8.001695] ata6.00: supports DRM functions and may not be fully accessible
[    8.002392] ata6.00: disabling queued TRIM support
[    8.002396] ata6.00: ATA-9: Samsung SSD 850 EVO 500GB, EMT02B6Q, max UDMA/133
[    8.002400] ata6.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[    8.003024] ata6.00: supports DRM functions and may not be fully accessible
[    8.003599] ata6.00: disabling queued TRIM support
[    8.003970] ata6.00: configured for UDMA/133
[    8.004155] scsi 5:0:0:0: Direct-Access     ATA      Samsung SSD 850  2B6Q PQ: 0 ANSI: 5
[    8.030318] sd 5:0:0:0: [sdh] 976773168 512-byte logical blocks: (500 GB/466 GiB)
[    8.030399] sd 5:0:0:0: [sdh] Write Protect is off
[    8.030403] sd 5:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    8.030430] sd 5:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.031086]  sdh: sdh1 sdh2
[    8.031505] sd 5:0:0:0: [sdh] Attached SCSI disk
[    8.053763] sr 0:0:0:0: [sr0] scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    8.053769] cdrom: Uniform CD-ROM driver Revision: 3.20
[    8.054070] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    8.126678] raid6: sse2x1   gen()  3390 MB/s
[    8.183346] raid6: sse2x1   xor()  3182 MB/s
[    8.218604] random: nonblocking pool is initialized
[    8.240030] raid6: sse2x2   gen()  3687 MB/s
[    8.296672] raid6: sse2x2   xor()  3853 MB/s
[    8.353350] raid6: sse2x4   gen()  5530 MB/s
[    8.410008] raid6: sse2x4   xor()  4344 MB/s
[    8.410011] raid6: using algorithm sse2x4 gen() 5530 MB/s
[    8.410013] raid6: .... xor() 4344 MB/s, rmw enabled
[    8.410015] raid6: using ssse3x2 recovery algorithm
[    8.410337] xor: measuring software checksum speed
[    8.443339]    prefetch64-sse:  7167.600 MB/sec
[    8.476680]    generic_sse:  6436.800 MB/sec
[    8.476684] xor: using function: prefetch64-sse (7167.600 MB/sec)
[    8.513028] Btrfs loaded, crc32c=crc32c-generic
[    8.513033] BTRFS: selftest: sectorsize: 4096  nodesize: 4096
[    8.513035] BTRFS: selftest: sectorsize: 4096  nodesize: 8192
[    8.513037] BTRFS: selftest: sectorsize: 4096  nodesize: 16384
[    8.513039] BTRFS: selftest: sectorsize: 4096  nodesize: 32768
[    8.513041] BTRFS: selftest: sectorsize: 4096  nodesize: 65536
[    8.514927] BTRFS: device label btrfs devid 1 transid 36706 /dev/sdh2
[    8.515047] BTRFS: device label data01 devid 1 transid 645 /dev/sdg1
[    8.625305] ISO 9660 Extensions: RRIP_1991A
[    8.659096] loop: module loaded
[    8.807716] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    9.689014] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.721309] systemd[1]: systemd 231 running in system mode. (+PAM -AUDIT -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    9.721475] systemd[1]: Detected architecture x86-64.
[    9.733300] systemd[1]: Set hostname to <archiso>.
[    9.734307] systemd[1]: Initializing machine ID from random generator.
[   10.026789] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[   10.026990] systemd[1]: Reached target Remote File Systems.
[   10.027142] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[   10.027302] systemd[1]: Listening on Journal Socket (/dev/log).
[   10.027440] systemd[1]: Listening on udev Control Socket.
[   10.027564] systemd[1]: Listening on udev Kernel Socket.
[   10.031004] systemd[1]: Listening on Process Core Dump Socket.
[   10.031122] systemd[1]: Reached target Encrypted Volumes.
[   10.031252] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[   10.031393] systemd[1]: Listening on LVM2 metadata daemon socket.
[   10.031547] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[   10.031699] systemd[1]: Listening on Journal Socket.
[   10.031809] systemd[1]: Reached target Paths.
[   10.031934] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[   10.032539] systemd[1]: Created slice User and Session Slice.
[   10.032652] systemd[1]: Reached target Swap.
[   10.064593] systemd[1]: Created slice System Slice.
[   10.076859] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[   10.081654] systemd[1]: Mounting Configuration File System...
[   10.081817] systemd[1]: Reached target Slices.
[   10.082706] systemd[1]: Mounting Huge Pages File System...
[   10.083704] systemd[1]: Starting Journal Service...
[   10.084549] systemd[1]: Mounting Debug File System...
[   10.085400] systemd[1]: Starting Setup Virtual Console...
[   10.085693] systemd[1]: Created slice system-getty.slice.
[   10.118191] systemd[1]: Starting Apply Kernel Variables...
[   10.119086] systemd[1]: Starting Remount Root and Kernel File Systems...
[   10.120063] systemd[1]: Mounting POSIX Message Queue File System...
[   10.121152] systemd[1]: Mounting Temporary Directory...
[   10.128260] systemd[1]: Started Create list of required static device nodes for the current kernel.
[   10.149242] systemd[1]: Started Remount Root and Kernel File Systems.
[   10.166173] systemd[1]: Starting Rebuild Hardware Database...
[   10.167295] systemd[1]: Starting Create System Users...
[   10.168240] systemd[1]: Starting Load/Save Random Seed...
[   10.193406] systemd[1]: Started Load/Save Random Seed.
[   10.206623] systemd[1]: Started Journal Service.
[   10.300655] systemd-journald[227]: Received request to flush runtime journal from PID 1
[   11.461313] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   11.517036] parport_pc 00:06: reported by Plug and Play ACPI
[   11.517132] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE,EPP]
[   11.634214] snd_hda_intel 0000:01:00.1: Handle vga_switcheroo audio client
[   11.790522] input: HDA ATI HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input7
[   11.883518] mousedev: PS/2 mouse device common for all mice
[   11.932953] i801_smbus 0000:00:1f.3: enabling device (0001 -> 0003)
[   11.933068] ACPI Warning: SystemIO range 0x0000000000000400-0x000000000000041F conflicts with OpRegion 0x0000000000000400-0x000000000000040F (\SMRG) (20160422/utaddress-255)
[   11.933076] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   12.028806] blk_update_request: I/O error, dev fd0, sector 0
[   12.030007] floppy: error -5 while reading block 0
[   12.052651] atl1 0000:02:00.0 enp2s0: renamed from eth0
[   12.087915] snd_hda_codec_analog hdaudioC0D0: autoconfig for AD1988: line_outs=4 (0x12/0x16/0x24/0x25/0x0) type:line
[   12.087922] snd_hda_codec_analog hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   12.087926] snd_hda_codec_analog hdaudioC0D0:    hp_outs=1 (0x11/0x0/0x0/0x0/0x0)
[   12.087929] snd_hda_codec_analog hdaudioC0D0:    mono: mono_out=0x0
[   12.087931] snd_hda_codec_analog hdaudioC0D0:    dig-out=0x1b/0x0
[   12.087934] snd_hda_codec_analog hdaudioC0D0:    inputs:
[   12.087938] snd_hda_codec_analog hdaudioC0D0:      Front Mic=0x14
[   12.087941] snd_hda_codec_analog hdaudioC0D0:      Rear Mic=0x17
[   12.087944] snd_hda_codec_analog hdaudioC0D0:      Line=0x15
[   12.087947] snd_hda_codec_analog hdaudioC0D0:      Line=0x1a
[   12.087949] snd_hda_codec_analog hdaudioC0D0:      CD=0x18
[   12.129485] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   12.130515] input: HDA Intel Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   12.130626] input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   12.130723] input: HDA Intel Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   12.130819] input: HDA Intel Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   12.130912] input: HDA Intel Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   12.131009] input: HDA Intel Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[   12.131620] input: PC Speaker as /devices/platform/pcspkr/input/input16
[   12.339425] ppdev: user-space parallel port driver
[   12.383649] gpio_ich: GPIO from 462 to 511 on gpio_ich
[   12.402620] iTCO_vendor_support: vendor-support=0
[   12.404513] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   12.404564] iTCO_wdt: Found a ICH8 or ICH8R TCO device (Version=2, TCOBASE=0x0860)
[   12.404734] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   12.505778] coretemp coretemp.0: Using relative temperature scale!
[   12.505798] coretemp coretemp.0: Using relative temperature scale!
[   12.513747] saa7146: register extension 'budget_ci dvb'
[   12.513913] saa7146: found saa7146 @ mem ffffc90000e5e800 (revision 1, irq 23) (0x13c2,0x1010)
[   12.513917] saa7146 (0): dma buffer size 192512
[   12.513919] DVB: registering new adapter (TT-Budget-C-CI PCI)
[   12.542634] intel_powerclamp: No package C-state available
[   12.544670] adapter has MAC addr = 00:d0:5c:04:77:60
[   12.567683] intel_powerclamp: No package C-state available
[   12.590034] Registered IR keymap rc-tt-1500
[   12.590163] input: Budget-CI dvb ir receiver saa7146 (0) as /devices/pci0000:00/0000:00:1e.0/0000:05:02.0/rc/rc0/input17
[   12.590241] rc rc0: Budget-CI dvb ir receiver saa7146 (0) as /devices/pci0000:00/0000:00:1e.0/0000:05:02.0/rc/rc0
[   12.648705] budget_ci dvb 0000:05:02.0: DVB: registering adapter 0 frontend 0 (ST STV0297 DVB-C)...
[   15.016079] atl1 0000:02:00.0: enp2s0 link is up 100 Mbps full duplex
[  485.299979] blk_update_request: I/O error, dev fd0, sector 0
[  485.300025] floppy: error -5 while reading block 0
[  546.218691] BTRFS info (device sdh2): disk space caching is enabled
[  546.218697] BTRFS info (device sdh2): has skinny extents
[  546.225228] BTRFS critical (device sdh2): corrupt leaf, bad key order: block=75182981120,root=1, slot=0
[  546.225303] BTRFS error (device sdh2): failed to recover balance: -5
[  546.253399] BTRFS: open_ctree failed

--nextPart6091891.Exu2zIbWiW--

