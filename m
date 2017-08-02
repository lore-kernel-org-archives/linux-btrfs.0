Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:33707 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752319AbdHBI3p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 04:29:45 -0400
Received: by mail-wr0-f177.google.com with SMTP id v105so15758015wrb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 01:29:44 -0700 (PDT)
From: Thomas Wurfbaum <thomas@wurfbaum.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: Crashed filesystem, nothing helps
Date: Wed, 02 Aug 2017 10:29:41 +0200
Message-ID: <5308666.XLvLE5gX27@nimrod.thomas.wurfbaum.net>
In-Reply-To: <1569935.QpkscbukDQ@nimrod.thomas.wurfbaum.net>
References: <1569935.QpkscbukDQ@nimrod.thomas.wurfbaum.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3985627.nAAz5UcWEY"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart3985627.nAAz5UcWEY
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Please find attached my dmesg.log

Regards,
Thomas
--nextPart3985627.nAAz5UcWEY
Content-Disposition: attachment; filename="dmesg.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="dmesg.log"

[    0.000000] Linux version 4.11.8-2-default (geeko@buildhost) (gcc version 7.1.1 20170629 [gcc-7-branch revision 249772] (SUSE Linux) ) #1 SMP PREEMPT Thu Jun 29 14:37:33 UTC 2017 (42bd7a0)
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.11.8-2-default root=UUID=6b92e93a-86f2-4007-b374-4c7ad6a57063 resume=/dev/disk/by-id/scsi-1AMCC_J0827296748EC30067A8-part2 splash=silent quiet showopts
[    0.000000] x86/fpu: x87 FPU will use FXSAVE
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bfeaffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bfeb0000-0x00000000bfee2fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfee3000-0x00000000bfeeffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bfef0000-0x00000000bfefffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: System manufacturer System Product Name/M2N32 WS Professional, BIOS ASUS M2N32 WS Pro ACPI BIOS Revision 2001 05/05/2008
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x240000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 00BFF00000 mask FFFFF00000 uncachable
[    0.000000]   3 base 0100000000 mask FF00000000 write-back
[    0.000000]   4 base 0200000000 mask FFC0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000240000000 aka 9216M
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] e820: update [mem 0xbff00000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbfeb0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f6040-0x000f604f] mapped at [ffff8808000f6040]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880800098000] 98000 size 24576
[    0.000000] BRK [0x1b3269000, 0x1b3269fff] PGTABLE
[    0.000000] BRK [0x1b326a000, 0x1b326afff] PGTABLE
[    0.000000] BRK [0x1b326b000, 0x1b326bfff] PGTABLE
[    0.000000] BRK [0x1b326c000, 0x1b326cfff] PGTABLE
[    0.000000] BRK [0x1b326d000, 0x1b326dfff] PGTABLE
[    0.000000] BRK [0x1b326e000, 0x1b326efff] PGTABLE
[    0.000000] BRK [0x1b326f000, 0x1b326ffff] PGTABLE
[    0.000000] BRK [0x1b3270000, 0x1b3270fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x36b91000-0x375bffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F7F20 000024 (v02 Nvidia)
[    0.000000] ACPI: XSDT 0x00000000BFEE3100 000054 (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 0x00000000BFEEB480 0000F4 (v03 Nvidia ASUSACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aEventBlock: 32/8 (20170119/tbfadt-603)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/8 (20170119/tbfadt-603)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/PmTimerBlock: 32/8 (20170119/tbfadt-603)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe0Block: 64/8 (20170119/tbfadt-603)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe1Block: 128/8 (20170119/tbfadt-603)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aEventBlock: 8, using default 32 (20170119/tbfadt-708)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 8, using default 16 (20170119/tbfadt-708)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/PmTimerBlock: 8, using default 32 (20170119/tbfadt-708)
[    0.000000] ACPI: DSDT 0x00000000BFEE3280 008189 (v01 NVIDIA AWRDACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 0x00000000BFEB0000 000040
[    0.000000] ACPI: FACS 0x00000000BFEB0000 000040
[    0.000000] ACPI: TCPA 0x00000000BFEEB6C0 000032 (v01 HTC    HTCACPI  42302E31 AWRD 00000000)
[    0.000000] ACPI: SSDT 0x00000000BFEEB740 000350 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 0x00000000BFEEBB00 000038 (v01 Nvidia ASUSACPI 42302E31 AWRD 00000098)
[    0.000000] ACPI: MCFG 0x00000000BFEEBB80 00003C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 0x00000000BFEEB5C0 000098 (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x23ffe6000-0x23fffbfff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000023fffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009dfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000bfeaffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000023fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000023fffffff]
[    0.000000] On node 0 totalpages: 2096717
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12219 pages used for memmap
[    0.000000]   DMA32 zone: 782000 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfefff000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfeb0000-0xbfee2fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfee3000-0xbfeeffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfef0000-0xbfefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbff00000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xf3ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf4000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xffffffff]
[    0.000000] e820: [mem 0xbff00000-0xefffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] percpu: Embedded 38 pages/cpu @ffff880a3fc00000 s117464 r8192 d29992 u524288
[    0.000000] pcpu-alloc: s117464 r8192 d29992 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 2063933
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.11.8-2-default root=UUID=6b92e93a-86f2-4007-b374-4c7ad6a57063 resume=/dev/disk/by-id/scsi-1AMCC_J0827296748EC30067A8-part2 splash=silent quiet showopts
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] AGP: Node 0: aperture [bus addr 0xb4000000-0xb5ffffff] (32MB)
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] AGP: Your BIOS doesn't leave an aperture memory hole
[    0.000000] AGP: Please enable the IOMMU option in the BIOS setup
[    0.000000] AGP: This costs you 64MB of RAM
[    0.000000] AGP: Mapping aperture over RAM [mem 0xb4000000-0xb7ffffff] (65536KB)
[    0.000000] PM: Registered nosave memory: [mem 0xb4000000-0xb7ffffff]
[    0.000000] Memory: 5361668K/8386868K available (7448K kernel code, 1307K rwdata, 5256K rodata, 1828K init, 1340K bss, 292744K reserved, 0K cma-reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=4
[    0.000000] NR_IRQS:33024 nr_irqs:456 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 76450417870 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3214.549 MHz processor
[    0.004000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6429.09 BogoMIPS (lpj=12858196)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004000] ACPI: Core revision 20170119
[    0.017142] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    0.017190] Security Framework initialized
[    0.017209] AppArmor: AppArmor initialized
[    0.017727] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.021535] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.023352] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.023362] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.023683] CPU: Physical Processor ID: 0
[    0.023684] CPU: Processor Core ID: 0
[    0.023685] mce: CPU supports 5 MCE banks
[    0.023691] LVT offset 0 assigned for vector 0xf9
[    0.023693] process: using AMD E400 aware idle routine
[    0.023694] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.023695] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4, 1GB 0
[    0.023812] Freeing SMP alternatives memory: 28K
[    0.025800] ftrace: allocating 29398 entries in 115 pages
[    0.032133] smpboot: Max logical packages: 2
[    0.032658] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.076000] smpboot: CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 6400+ (family: 0xf, model: 0x43, stepping: 0x3)
[    0.088009] Performance Events: AMD PMU driver.
[    0.088013] ... version:                0
[    0.088014] ... bit width:              48
[    0.088015] ... generic registers:      4
[    0.088015] ... value mask:             0000ffffffffffff
[    0.088016] ... max period:             00007fffffffffff
[    0.088016] ... fixed-purpose events:   0
[    0.088017] ... event mask:             000000000000000f
[    0.112057] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.120002] smp: Bringing up secondary CPUs ...
[    0.152035] x86: Booting SMP configuration:
[    0.152036] .... node  #0, CPUs:      #1
[    0.232062] smp: Brought up 1 node, 2 CPUs
[    0.232062] smpboot: Total of 2 processors activated (12858.36 BogoMIPS)
[    0.255305] node 0 initialised, 683114 pages in 20ms
[    0.255332] devtmpfs: initialized
[    0.255332] x86/mm: Memory block size: 128MB
[    0.259680] PM: Registering ACPI NVS region [mem 0xbfeb0000-0xbfee2fff] (208896 bytes)
[    0.259680] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.259680] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.259680] pinctrl core: initialized pinctrl subsystem
[    0.259680] RTC time: 16:15:45, date: 08/01/17
[    0.259680] NET: Registered protocol family 16
[    0.260177] cpuidle: using governor ladder
[    0.260177] cpuidle: using governor menu
[    0.260177] PCCT header not found.
[    0.260177] node 0 link 0: io port [8000, ffff]
[    0.260177] TOM: 00000000c0000000 aka 3072M
[    0.260177] node 0 link 0: mmio [a0000, bffff]
[    0.260177] node 0 link 0: mmio [c0000000, efffffff]
[    0.260177] node 0 link 0: mmio [f4000000, fe02ffff]
[    0.260177] node 0 link 0: mmio [f0000000, f09fffff]
[    0.260177] TOM2: 0000000240000000 aka 9216M
[    0.260177] bus: [bus 00-09] on node 0 link 0
[    0.260177] bus: 00 [io  0x0000-0xffff]
[    0.260177] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.260177] bus: 00 [mem 0xc0000000-0xf3ffffff]
[    0.260177] bus: 00 [mem 0xf4000000-0xffffffff]
[    0.260177] bus: 00 [mem 0x240000000-0xfcffffffff]
[    0.260177] ACPI: bus type PCI registered
[    0.260177] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.260177] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.260177] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.260177] PCI: Using configuration type 1 for base access
[    0.260177] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.260177] mtrr: probably your BIOS does not setup all CPUs.
[    0.260177] mtrr: corrected configuration.
[    0.261110] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.261110] ACPI: Added _OSI(Module Device)
[    0.261110] ACPI: Added _OSI(Processor Device)
[    0.261110] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.261110] ACPI: Added _OSI(Processor Aggregator Device)
[    0.268734] ACPI: Interpreter enabled
[    0.268757] ACPI: (supports S0 S1 S3 S4 S5)
[    0.268758] ACPI: Using IOAPIC for interrupt routing
[    0.268786] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.281334] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.281340] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.281344] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.281356] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.281412] acpi PNP0A08:00: host bridge window expanded to [io  0x0d00-0xffff window]; [io  0x4700-0x470c window] ignored
[    0.281742] PCI host bridge to bus 0000:00
[    0.281744] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.281745] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.281747] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.281748] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
[    0.281749] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff window]
[    0.281750] pci_bus 0000:00: root bus resource [mem 0xbff00000-0xfebfffff window]
[    0.281752] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.281759] pci 0000:00:00.0: [10de:02f4] type 00 class 0x050000
[    0.281895] pci 0000:00:00.1: [10de:02fa] type 00 class 0x050000
[    0.282015] pci 0000:00:00.2: [10de:02fe] type 00 class 0x050000
[    0.282139] pci 0000:00:00.3: [10de:02f8] type 00 class 0x050000
[    0.282263] pci 0000:00:00.4: [10de:02f9] type 00 class 0x050000
[    0.282393] pci 0000:00:00.5: [10de:02ff] type 00 class 0x050000
[    0.282517] pci 0000:00:00.6: [10de:027f] type 00 class 0x050000
[    0.282637] pci 0000:00:00.7: [10de:027e] type 00 class 0x050000
[    0.282765] pci 0000:00:04.0: [10de:02fb] type 01 class 0x060400
[    0.282788] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.282881] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.282926] pci 0000:00:08.0: [10de:0369] type 00 class 0x050000
[    0.283184] pci 0000:00:09.0: [10de:0360] type 00 class 0x060100
[    0.283326] pci 0000:00:09.1: [10de:0368] type 00 class 0x0c0500
[    0.283352] pci 0000:00:09.1: reg 0x20: [io  0x1c00-0x1c3f]
[    0.283357] pci 0000:00:09.1: reg 0x24: [io  0x1c40-0x1c7f]
[    0.283386] pci 0000:00:09.1: PME# supported from D3hot D3cold
[    0.283513] pci 0000:00:0a.0: [10de:036c] type 00 class 0x0c0310
[    0.283520] pci 0000:00:0a.0: reg 0x10: [mem 0xfe02f000-0xfe02ffff]
[    0.283553] pci 0000:00:0a.0: supports D1 D2
[    0.283554] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.283644] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    0.283676] pci 0000:00:0a.1: [10de:036d] type 00 class 0x0c0320
[    0.283683] pci 0000:00:0a.1: reg 0x10: [mem 0xfe02e000-0xfe02e0ff]
[    0.283715] pci 0000:00:0a.1: supports D1 D2
[    0.283716] pci 0000:00:0a.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.283822] pci 0000:00:0a.1: System wakeup disabled by ACPI
[    0.283859] pci 0000:00:0c.0: [10de:036e] type 00 class 0x01018a
[    0.283875] pci 0000:00:0c.0: reg 0x20: [io  0xf400-0xf40f]
[    0.283883] pci 0000:00:0c.0: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.283884] pci 0000:00:0c.0: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.283885] pci 0000:00:0c.0: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.283886] pci 0000:00:0c.0: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.284018] pci 0000:00:0d.0: [10de:037f] type 00 class 0x010185
[    0.284025] pci 0000:00:0d.0: reg 0x10: [io  0x09f0-0x09f7]
[    0.284029] pci 0000:00:0d.0: reg 0x14: [io  0x0bf0-0x0bf3]
[    0.284033] pci 0000:00:0d.0: reg 0x18: [io  0x0970-0x0977]
[    0.284036] pci 0000:00:0d.0: reg 0x1c: [io  0x0b70-0x0b73]
[    0.284040] pci 0000:00:0d.0: reg 0x20: [io  0xe000-0xe00f]
[    0.284044] pci 0000:00:0d.0: reg 0x24: [mem 0xfe02d000-0xfe02dfff]
[    0.284175] pci 0000:00:0d.1: [10de:037f] type 00 class 0x010185
[    0.284182] pci 0000:00:0d.1: reg 0x10: [io  0x09e0-0x09e7]
[    0.284186] pci 0000:00:0d.1: reg 0x14: [io  0x0be0-0x0be3]
[    0.284190] pci 0000:00:0d.1: reg 0x18: [io  0x0960-0x0967]
[    0.284194] pci 0000:00:0d.1: reg 0x1c: [io  0x0b60-0x0b63]
[    0.284197] pci 0000:00:0d.1: reg 0x20: [io  0xcc00-0xcc0f]
[    0.284201] pci 0000:00:0d.1: reg 0x24: [mem 0xfe02c000-0xfe02cfff]
[    0.284330] pci 0000:00:0d.2: [10de:037f] type 00 class 0x010185
[    0.284337] pci 0000:00:0d.2: reg 0x10: [io  0xc800-0xc807]
[    0.284341] pci 0000:00:0d.2: reg 0x14: [io  0xc400-0xc403]
[    0.284344] pci 0000:00:0d.2: reg 0x18: [io  0xc000-0xc007]
[    0.284348] pci 0000:00:0d.2: reg 0x1c: [io  0xbc00-0xbc03]
[    0.284352] pci 0000:00:0d.2: reg 0x20: [io  0xb800-0xb80f]
[    0.284356] pci 0000:00:0d.2: reg 0x24: [mem 0xfe02b000-0xfe02bfff]
[    0.284487] pci 0000:00:0e.0: [10de:0370] type 01 class 0x060401
[    0.284593] pci 0000:00:0e.0: System wakeup disabled by ACPI
[    0.284625] pci 0000:00:0e.1: [10de:0371] type 00 class 0x040300
[    0.284633] pci 0000:00:0e.1: reg 0x10: [mem 0xfe020000-0xfe023fff]
[    0.284671] pci 0000:00:0e.1: PME# supported from D3hot D3cold
[    0.284758] pci 0000:00:0e.1: System wakeup disabled by ACPI
[    0.284795] pci 0000:00:10.0: [10de:0373] type 00 class 0x068000
[    0.284804] pci 0000:00:10.0: reg 0x10: [mem 0xfe02a000-0xfe02afff]
[    0.284808] pci 0000:00:10.0: reg 0x14: [io  0xb400-0xb407]
[    0.284811] pci 0000:00:10.0: reg 0x18: [mem 0xfe029000-0xfe0290ff]
[    0.284815] pci 0000:00:10.0: reg 0x1c: [mem 0xfe028000-0xfe02800f]
[    0.284847] pci 0000:00:10.0: supports D1 D2
[    0.284848] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.284938] pci 0000:00:10.0: System wakeup disabled by ACPI
[    0.284969] pci 0000:00:11.0: [10de:0373] type 00 class 0x068000
[    0.284978] pci 0000:00:11.0: reg 0x10: [mem 0xfe027000-0xfe027fff]
[    0.284981] pci 0000:00:11.0: reg 0x14: [io  0xb000-0xb007]
[    0.284985] pci 0000:00:11.0: reg 0x18: [mem 0xfe026000-0xfe0260ff]
[    0.284989] pci 0000:00:11.0: reg 0x1c: [mem 0xfe025000-0xfe02500f]
[    0.285021] pci 0000:00:11.0: supports D1 D2
[    0.285022] pci 0000:00:11.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.285110] pci 0000:00:11.0: System wakeup disabled by ACPI
[    0.285144] pci 0000:00:12.0: [10de:0376] type 01 class 0x060400
[    0.285174] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.285263] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.285295] pci 0000:00:14.0: [10de:0374] type 01 class 0x060400
[    0.285324] pci 0000:00:14.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.285412] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.285443] pci 0000:00:15.0: [10de:0378] type 01 class 0x060400
[    0.285472] pci 0000:00:15.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.285559] pci 0000:00:15.0: System wakeup disabled by ACPI
[    0.285592] pci 0000:00:16.0: [10de:0375] type 01 class 0x060400
[    0.285623] pci 0000:00:16.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.285710] pci 0000:00:16.0: System wakeup disabled by ACPI
[    0.285744] pci 0000:00:17.0: [10de:0377] type 01 class 0x060400
[    0.285774] pci 0000:00:17.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.285862] pci 0000:00:17.0: System wakeup disabled by ACPI
[    0.285892] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.286003] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.286116] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.286226] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.286368] pci 0000:00:04.0: PCI bridge to [bus 01]
[    0.286407] pci 0000:02:0b.0: [104c:8023] type 00 class 0x0c0010
[    0.286417] pci 0000:02:0b.0: reg 0x10: [mem 0xfdfff000-0xfdfff7ff]
[    0.286423] pci 0000:02:0b.0: reg 0x14: [mem 0xfdff8000-0xfdffbfff]
[    0.286469] pci 0000:02:0b.0: supports D1 D2
[    0.286470] pci 0000:02:0b.0: PME# supported from D0 D1 D2 D3hot
[    0.286517] pci 0000:00:0e.0: PCI bridge to [bus 02] (subtractive decode)
[    0.286520] pci 0000:00:0e.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.286522] pci 0000:00:0e.0:   bridge window [io  0x0000-0x0cf7 window] (subtractive decode)
[    0.286523] pci 0000:00:0e.0:   bridge window [io  0x0d00-0xffff window] (subtractive decode)
[    0.286524] pci 0000:00:0e.0:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
[    0.286526] pci 0000:00:0e.0:   bridge window [mem 0x000c0000-0x000dffff window] (subtractive decode)
[    0.286527] pci 0000:00:0e.0:   bridge window [mem 0xfed40000-0xfed44fff window] (subtractive decode)
[    0.286528] pci 0000:00:0e.0:   bridge window [mem 0xbff00000-0xfebfffff window] (subtractive decode)
[    0.286562] pci 0000:03:00.0: [1033:0125] type 01 class 0x060400
[    0.286622] pci 0000:03:00.0: supports D1
[    0.286623] pci 0000:03:00.0: PME# supported from D0 D1 D3hot D3cold
[    0.286675] pci 0000:03:00.1: [1033:0125] type 01 class 0x060400
[    0.286694] pci 0000:03:00.1: reg 0x10: [mem 0xfdeff000-0xfdeff07f 64bit]
[    0.286759] pci 0000:03:00.1: supports D1
[    0.286760] pci 0000:03:00.1: PME# supported from D0 D1 D3hot D3cold
[    0.286813] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.286821] pci 0000:00:12.0: PCI bridge to [bus 03-05]
[    0.286824] pci 0000:00:12.0:   bridge window [io  0xa000-0xafff]
[    0.286825] pci 0000:00:12.0:   bridge window [mem 0xfdc00000-0xfdefffff]
[    0.286828] pci 0000:00:12.0:   bridge window [mem 0xf8000000-0xf9ffffff 64bit pref]
[    0.286868] pci 0000:04:01.0: [13c1:1003] type 00 class 0x010400
[    0.286884] pci 0000:04:01.0: reg 0x10: [mem 0xf8000000-0xf9ffffff 64bit pref]
[    0.286895] pci 0000:04:01.0: reg 0x18: [mem 0xfddff000-0xfddfffff 64bit]
[    0.286903] pci 0000:04:01.0: reg 0x20: [io  0xac00-0xac3f]
[    0.286916] pci 0000:04:01.0: reg 0x30: [mem 0xfdcc0000-0xfdcdffff pref]
[    0.286950] pci 0000:04:01.0: supports D1 D2
[    0.286987] pci 0000:04:02.0: [8086:1079] type 00 class 0x020000
[    0.287005] pci 0000:04:02.0: reg 0x10: [mem 0xfddc0000-0xfdddffff 64bit]
[    0.287016] pci 0000:04:02.0: reg 0x18: [mem 0xfdd40000-0xfdd7ffff 64bit]
[    0.287023] pci 0000:04:02.0: reg 0x20: [io  0xa800-0xa83f]
[    0.287037] pci 0000:04:02.0: reg 0x30: [mem 0xfdcc0000-0xfdcfffff pref]
[    0.287072] pci 0000:04:02.0: PME# supported from D0 D3hot D3cold
[    0.287115] pci 0000:04:02.1: [8086:1079] type 00 class 0x020000
[    0.287133] pci 0000:04:02.1: reg 0x10: [mem 0xfdda0000-0xfddbffff 64bit]
[    0.287144] pci 0000:04:02.1: reg 0x18: [mem 0xfdd00000-0xfdd3ffff 64bit]
[    0.287151] pci 0000:04:02.1: reg 0x20: [io  0xa400-0xa43f]
[    0.287164] pci 0000:04:02.1: reg 0x30: [mem 0xfdcc0000-0xfdcfffff pref]
[    0.287199] pci 0000:04:02.1: PME# supported from D0 D3hot D3cold
[    0.287267] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.287271] pci 0000:03:00.0:   bridge window [io  0xa000-0xafff]
[    0.287274] pci 0000:03:00.0:   bridge window [mem 0xfdc00000-0xfddfffff]
[    0.287279] pci 0000:03:00.0:   bridge window [mem 0xf8000000-0xf9ffffff 64bit pref]
[    0.287356] pci 0000:03:00.1: PCI bridge to [bus 05]
[    0.287403] pci 0000:00:14.0: PCI bridge to [bus 06]
[    0.287434] pci 0000:00:15.0: PCI bridge to [bus 07]
[    0.287473] pci 0000:08:00.0: [11ab:6141] type 00 class 0x010681
[    0.287486] pci 0000:08:00.0: reg 0x10: [io  0x9c00-0x9c07]
[    0.287493] pci 0000:08:00.0: reg 0x14: [io  0x9800-0x9803]
[    0.287500] pci 0000:08:00.0: reg 0x18: [io  0x9400-0x943f]
[    0.287514] pci 0000:08:00.0: reg 0x20: [io  0x9000-0x901f]
[    0.287521] pci 0000:08:00.0: reg 0x24: [mem 0xfdbff000-0xfdbff3ff]
[    0.287529] pci 0000:08:00.0: reg 0x30: [mem 0xfdb80000-0xfdbbffff pref]
[    0.287569] pci 0000:08:00.0: supports D1
[    0.287570] pci 0000:08:00.0: PME# supported from D0 D1 D3hot
[    0.287615] pci 0000:08:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.287620] pci 0000:00:16.0: PCI bridge to [bus 08]
[    0.287623] pci 0000:00:16.0:   bridge window [io  0x9000-0x9fff]
[    0.287625] pci 0000:00:16.0:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.287657] pci 0000:09:00.0: [10de:0393] type 00 class 0x030000
[    0.287666] pci 0000:09:00.0: reg 0x10: [mem 0xfa000000-0xfaffffff]
[    0.287673] pci 0000:09:00.0: reg 0x14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.287680] pci 0000:09:00.0: reg 0x1c: [mem 0xfb000000-0xfbffffff 64bit]
[    0.287686] pci 0000:09:00.0: reg 0x24: [io  0x8c00-0x8c7f]
[    0.287691] pci 0000:09:00.0: reg 0x30: [mem 0xfcfe0000-0xfcffffff pref]
[    0.287753] pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.287757] pci 0000:00:17.0: PCI bridge to [bus 09]
[    0.287760] pci 0000:00:17.0:   bridge window [io  0x8000-0x8fff]
[    0.287761] pci 0000:00:17.0:   bridge window [mem 0xfa000000-0xfcffffff]
[    0.287764] pci 0000:00:17.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.288711] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.288783] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.288854] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.288927] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 *10 11 14 15)
[    0.288999] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 *11 14 15)
[    0.289071] ACPI: PCI Interrupt Link [LNK6] (IRQs *5 7 9 10 11 14 15)
[    0.289142] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 *10 11 14 15)
[    0.289215] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 *11 14 15)
[    0.289286] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.289359] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.289431] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 *11 14 15)
[    0.289503] ACPI: PCI Interrupt Link [LMC1] (IRQs *5 7 9 10 11 14 15)
[    0.289575] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 *10 11 14 15)
[    0.289646] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.289717] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.289788] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.289860] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.289932] ACPI: PCI Interrupt Link [LSID] (IRQs *5 7 9 10 11 14 15)
[    0.290004] ACPI: PCI Interrupt Link [LFID] (IRQs *5 7 9 10 11 14 15)
[    0.290076] ACPI: PCI Interrupt Link [LSA2] (IRQs *5 7 9 10 11 14 15)
[    0.290198] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    0.290316] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[    0.290433] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[    0.290550] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    0.290667] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[    0.290784] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
[    0.290901] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
[    0.291018] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[    0.291135] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[    0.291252] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0, disabled.
[    0.291370] ACPI: PCI Interrupt Link [AMC1] (IRQs 20 21 22 23) *0, disabled.
[    0.291488] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
[    0.291606] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0, disabled.
[    0.291724] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[    0.291841] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[    0.291959] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
[    0.292082] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    0.292200] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
[    0.292318] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
[    0.292436] ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0, disabled.
[    0.292515] ACPI: Enabled 1 GPEs in block 20 to 5F
[    0.292613] pci 0000:09:00.0: vgaarb: setting as boot VGA device
[    0.292613] pci 0000:09:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.292613] pci 0000:09:00.0: vgaarb: bridge control possible
[    0.292613] vgaarb: loaded
[    0.292613] SCSI subsystem initialized
[    0.292613] libata version 3.00 loaded.
[    0.292613] PCI: Using ACPI for IRQ routing
[    0.293162] PCI: pci_cache_line_size set to 64 bytes
[    0.293223] e820: reserve RAM buffer [mem 0x0009e800-0x0009ffff]
[    0.293224] e820: reserve RAM buffer [mem 0xbfeb0000-0xbfffffff]
[    0.293316] NetLabel: Initializing
[    0.293316] NetLabel:  domain hash size = 128
[    0.293317] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.293331] NetLabel:  unlabeled traffic allowed by default
[    0.293353] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.293353] hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
[    0.293353] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.296042] clocksource: Switched to clocksource hpet
[    0.310650] VFS: Disk quotas dquot_6.6.0
[    0.310679] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.310771] AppArmor: AppArmor Filesystem Enabled
[    0.310813] pnp: PnP ACPI init
[    0.311000] system 00:00: [io  0x1000-0x107f] has been reserved
[    0.311001] system 00:00: [io  0x1080-0x10ff] has been reserved
[    0.311003] system 00:00: [io  0x1400-0x147f] has been reserved
[    0.311004] system 00:00: [io  0x1480-0x14ff] has been reserved
[    0.311006] system 00:00: [io  0x1800-0x187f] has been reserved
[    0.311007] system 00:00: [io  0x1880-0x18ff] has been reserved
[    0.311011] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.311123] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.311124] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.311126] system 00:01: [io  0x0290-0x0297] has been reserved
[    0.311128] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.311210] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.311633] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.312230] pnp 00:04: [dma 3]
[    0.312267] pnp 00:04: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.312337] pnp 00:05: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.312384] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.313248] system 00:07: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.313251] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.313459] system 00:08: [mem 0x000d2000-0x000d3fff] has been reserved
[    0.313461] system 00:08: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.313462] system 00:08: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.313463] system 00:08: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.313465] system 00:08: [mem 0xfefff000-0xfefff0ff] has been reserved
[    0.313466] system 00:08: [mem 0xbfeb0000-0xbfefffff] could not be reserved
[    0.313468] system 00:08: [mem 0xffff0000-0xffffffff] has been reserved
[    0.313469] system 00:08: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.313470] system 00:08: [mem 0x00100000-0xbfeaffff] could not be reserved
[    0.313472] system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.313473] system 00:08: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.313475] system 00:08: [mem 0xfefff000-0xfeffffff] could not be reserved
[    0.313476] system 00:08: [mem 0xfff80000-0xfff80fff] has been reserved
[    0.313477] system 00:08: [mem 0xfff90000-0xfffbffff] has been reserved
[    0.313479] system 00:08: [mem 0xfffed000-0xfffeffff] has been reserved
[    0.313481] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.313491] pnp: PnP ACPI: found 9 devices
[    0.320184] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.320190] pci 0000:04:02.0: can't claim BAR 6 [mem 0xfdcc0000-0xfdcfffff pref]: address conflict with 0000:04:01.0 [mem 0xfdcc0000-0xfdcdffff pref]
[    0.320192] pci 0000:04:02.1: can't claim BAR 6 [mem 0xfdcc0000-0xfdcfffff pref]: address conflict with 0000:04:01.0 [mem 0xfdcc0000-0xfdcdffff pref]
[    0.320229] pci 0000:00:04.0: PCI bridge to [bus 01]
[    0.320234] pci 0000:00:0e.0: PCI bridge to [bus 02]
[    0.320237] pci 0000:00:0e.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.320244] pci 0000:04:02.0: BAR 6: assigned [mem 0xfdc00000-0xfdc3ffff pref]
[    0.320245] pci 0000:04:02.1: BAR 6: assigned [mem 0xfdc40000-0xfdc7ffff pref]
[    0.320247] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.320249] pci 0000:03:00.0:   bridge window [io  0xa000-0xafff]
[    0.320252] pci 0000:03:00.0:   bridge window [mem 0xfdc00000-0xfddfffff]
[    0.320255] pci 0000:03:00.0:   bridge window [mem 0xf8000000-0xf9ffffff 64bit pref]
[    0.320260] pci 0000:03:00.1: PCI bridge to [bus 05]
[    0.320272] pci 0000:00:12.0: PCI bridge to [bus 03-05]
[    0.320273] pci 0000:00:12.0:   bridge window [io  0xa000-0xafff]
[    0.320275] pci 0000:00:12.0:   bridge window [mem 0xfdc00000-0xfdefffff]
[    0.320277] pci 0000:00:12.0:   bridge window [mem 0xf8000000-0xf9ffffff 64bit pref]
[    0.320280] pci 0000:00:14.0: PCI bridge to [bus 06]
[    0.320284] pci 0000:00:15.0: PCI bridge to [bus 07]
[    0.320288] pci 0000:00:16.0: PCI bridge to [bus 08]
[    0.320290] pci 0000:00:16.0:   bridge window [io  0x9000-0x9fff]
[    0.320292] pci 0000:00:16.0:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.320295] pci 0000:00:17.0: PCI bridge to [bus 09]
[    0.320296] pci 0000:00:17.0:   bridge window [io  0x8000-0x8fff]
[    0.320298] pci 0000:00:17.0:   bridge window [mem 0xfa000000-0xfcffffff]
[    0.320300] pci 0000:00:17.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.320304] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.320305] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.320306] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.320307] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff window]
[    0.320309] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff window]
[    0.320310] pci_bus 0000:00: resource 9 [mem 0xbff00000-0xfebfffff window]
[    0.320311] pci_bus 0000:02: resource 1 [mem 0xfdf00000-0xfdffffff]
[    0.320312] pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7 window]
[    0.320314] pci_bus 0000:02: resource 5 [io  0x0d00-0xffff window]
[    0.320315] pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.320316] pci_bus 0000:02: resource 7 [mem 0x000c0000-0x000dffff window]
[    0.320317] pci_bus 0000:02: resource 8 [mem 0xfed40000-0xfed44fff window]
[    0.320318] pci_bus 0000:02: resource 9 [mem 0xbff00000-0xfebfffff window]
[    0.320319] pci_bus 0000:03: resource 0 [io  0xa000-0xafff]
[    0.320321] pci_bus 0000:03: resource 1 [mem 0xfdc00000-0xfdefffff]
[    0.320322] pci_bus 0000:03: resource 2 [mem 0xf8000000-0xf9ffffff 64bit pref]
[    0.320323] pci_bus 0000:04: resource 0 [io  0xa000-0xafff]
[    0.320324] pci_bus 0000:04: resource 1 [mem 0xfdc00000-0xfddfffff]
[    0.320325] pci_bus 0000:04: resource 2 [mem 0xf8000000-0xf9ffffff 64bit pref]
[    0.320327] pci_bus 0000:08: resource 0 [io  0x9000-0x9fff]
[    0.320328] pci_bus 0000:08: resource 1 [mem 0xfdb00000-0xfdbfffff]
[    0.320329] pci_bus 0000:09: resource 0 [io  0x8000-0x8fff]
[    0.320330] pci_bus 0000:09: resource 1 [mem 0xfa000000-0xfcffffff]
[    0.320331] pci_bus 0000:09: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
[    0.320471] NET: Registered protocol family 2
[    0.320651] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.320882] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.321275] TCP: Hash tables configured (established 65536 bind 65536)
[    0.321362] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.321422] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.321544] NET: Registered protocol family 1
[    0.321588] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.322001] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
[    0.400537] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
[    0.400731] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.400767] pci 0000:00:0d.1: Enabling HT MSI Mapping
[    0.400803] pci 0000:00:0d.2: Enabling HT MSI Mapping
[    0.400838] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.400877] pci 0000:00:0e.1: Enabling HT MSI Mapping
[    0.400920] pci 0000:00:10.0: Enabling HT MSI Mapping
[    0.400968] pci 0000:00:11.0: Enabling HT MSI Mapping
[    0.401016] pci 0000:00:12.0: Enabling HT MSI Mapping
[    0.401068] pci 0000:00:14.0: Enabling HT MSI Mapping
[    0.401123] pci 0000:00:15.0: Enabling HT MSI Mapping
[    0.401181] pci 0000:00:16.0: Enabling HT MSI Mapping
[    0.401242] pci 0000:00:17.0: Enabling HT MSI Mapping
[    0.401277] pci 0000:09:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.401278] PCI: CLS 32 bytes, default 64
[    0.401335] Unpacking initramfs...
[    1.269271] Freeing initrd memory: 10428K
[    1.269580] PCI-DMA: Disabling AGP.
[    1.269644] PCI-DMA: aperture base @ b4000000 size 65536 KB
[    1.269644] PCI-DMA: using GART IOMMU.
[    1.269647] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.273093] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2e55f9e92a5, max_idle_ns: 440795306426 ns
[    1.273134] Scanning for low memory corruption every 60 seconds
[    1.273430] audit: initializing netlink subsys (disabled)
[    1.273499] audit: type=2000 audit(1501604146.272:1): state=initialized audit_enabled=0 res=1
[    1.273794] workingset: timestamp_bits=37 max_order=21 bucket_order=0
[    1.273828] zbud: loaded
[    1.275678] Key type asymmetric registered
[    1.275679] Asymmetric key parser 'x509' registered
[    1.275690] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    1.275721] io scheduler noop registered
[    1.275722] io scheduler deadline registered
[    1.275734] io scheduler cfq registered (default)
[    1.275735] io scheduler mq-deadline registered
[    1.276182] vesafb: mode is 640x480x32, linelength=2560, pages=0
[    1.276183] vesafb: scrolling: redraw
[    1.276184] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.276196] vesafb: framebuffer at 0xe0000000, mapped to 0xffffb03ac1200000, using 1216k, total 1216k
[    1.283257] Console: switching to colour frame buffer device 80x30
[    1.290237] fb0: VESA VGA frame buffer device
[    1.290342] GHES: HEST is not enabled!
[    1.290426] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.310852] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.312348] Non-volatile memory driver v1.3
[    1.312374] Linux agpgart interface v0.103
[    1.312660] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.313058] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.313088] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.313172] mousedev: PS/2 mouse device common for all mice
[    1.313249] rtc_cmos 00:02: RTC can wake from S4
[    1.313383] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.313418] rtc_cmos 00:02: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    1.313440] ledtrig-cpu: registered to indicate activity on CPUs
[    1.313451] hidraw: raw HID events driver (C) Jiri Kosina
[    1.313601] NET: Registered protocol family 10
[    1.317721] Segment Routing with IPv6
[    1.317924] microcode: AMD CPU family 0xf not supported
[    1.318052] registered taskstats version 1
[    1.318071] zswap: loaded using pool lzo/zbud
[    1.333475] Key type big_key registered
[    1.335181] Key type encrypted registered
[    1.335184] AppArmor: AppArmor sha1 policy hashing enabled
[    1.335526]   Magic number: 13:502:286
[    1.335645] rtc_cmos 00:02: setting system clock to 2017-08-01 16:15:46 UTC (1501604146)
[    1.335683] PM: Checking hibernation image partition /dev/disk/by-id/scsi-1AMCC_J0827296748EC30067A8-part2
[    1.346803] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.564039] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input2
[    2.566954] PM: Hibernation image not present or could not be loaded.
[    2.569106] Freeing unused kernel memory: 1828K
[    2.569109] Write protecting the kernel read-only data: 14336k
[    2.569506] Freeing unused kernel memory: 728K
[    2.571483] Freeing unused kernel memory: 888K
[    2.574566] random: systemd: uninitialized urandom read (16 bytes read)
[    2.574762] random: systemd: uninitialized urandom read (16 bytes read)
[    2.574773] random: systemd: uninitialized urandom read (16 bytes read)
[    2.576091] systemd[1]: systemd 228 running in system mode. (+PAM -AUDIT +SELINUX -IMA +APPARMOR -SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID -ELFUTILS +KMOD +IDN)
[    2.576193] systemd[1]: Detected architecture x86-64.
[    2.576195] systemd[1]: Running in initial RAM disk.
[    2.576208] systemd[1]: Set hostname to <mainframe>.
[    2.608980] random: systemd: uninitialized urandom read (16 bytes read)
[    2.609001] random: systemd: uninitialized urandom read (16 bytes read)
[    2.609032] random: systemd: uninitialized urandom read (16 bytes read)
[    2.609090] random: systemd: uninitialized urandom read (16 bytes read)
[    2.609634] random: systemd: uninitialized urandom read (16 bytes read)
[    2.609858] random: systemd: uninitialized urandom read (16 bytes read)
[    2.610257] random: systemd: uninitialized urandom read (16 bytes read)
[    2.614546] systemd[1]: Listening on Journal Socket (/dev/log).
[    2.614595] systemd[1]: Reached target Swap.
[    2.614636] systemd[1]: Listening on udev Kernel Socket.
[    2.614651] systemd[1]: Reached target Timers.
[    2.614713] systemd[1]: Listening on Journal Audit Socket.
[    2.614747] systemd[1]: Listening on udev Control Socket.
[    2.636135] alua: device handler registered
[    2.636418] emc: device handler registered
[    2.636610] rdac: device handler registered
[    2.645180] device-mapper: uevent: version 1.0.3
[    2.645257] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel@redhat.com
[    2.839225] ACPI: bus type USB registered
[    2.839251] usbcore: registered new interface driver usbfs
[    2.839260] usbcore: registered new interface driver hub
[    2.839295] usbcore: registered new device driver usb
[    2.839790] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.841191] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.841420] ehci-pci: EHCI PCI platform driver
[    2.841666] ehci-pci 0000:00:0a.1: EHCI Host Controller
[    2.841674] ehci-pci 0000:00:0a.1: new USB bus registered, assigned bus number 1
[    2.841683] ehci-pci 0000:00:0a.1: debug port 1
[    2.841715] ehci-pci 0000:00:0a.1: cache line size of 32 is not supported
[    2.841734] ehci-pci 0000:00:0a.1: irq 22, io mem 0xfe02e000
[    2.842118] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[    2.842159] ACPI: Power Button [PWRB]
[    2.842236] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    2.842261] ACPI: Power Button [PWRF]
[    2.856030] ehci-pci 0000:00:0a.1: USB 2.0 started, EHCI 1.00
[    2.856093] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.856094] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.856096] usb usb1: Product: EHCI Host Controller
[    2.856097] usb usb1: Manufacturer: Linux 4.11.8-2-default ehci_hcd
[    2.856097] usb usb1: SerialNumber: 0000:00:0a.1
[    2.856221] hub 1-0:1.0: USB hub found
[    2.856228] hub 1-0:1.0: 10 ports detected
[    2.856449] sata_nv 0000:00:0d.0: version 3.5
[    2.856809] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 21
[    2.856828] sata_nv 0000:00:0d.0: Using SWNCQ mode
[    2.857786] ohci-pci: OHCI PCI platform driver
[    2.868685] 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
[    2.869086] ACPI: PCI Interrupt Link [APC8] enabled at IRQ 16
[    2.872160] scsi host0: sata_nv
[    2.882172] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[    2.895121] scsi host2: sata_nv
[    2.895191] ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xe000 irq 21
[    2.895193] ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xe008 irq 21
[    2.895572] ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 20
[    2.895592] sata_nv 0000:00:0d.1: Using SWNCQ mode
[    2.914529] scsi host3: sata_nv
[    2.925310] scsi host4: sata_nv
[    2.925380] ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xcc00 irq 20
[    2.925381] ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xcc08 irq 20
[    2.925415] pata_amd 0000:00:0c.0: version 0.4.1
[    2.932977] wmi: Mapper loaded
[    2.940085] firewire_ohci 0000:02:0b.0: added OHCI v1.10 device as card 0, 4 IR + 8 IT contexts, quirks 0x2
[    2.955565] scsi host5: pata_amd
[    2.968124] scsi host6: pata_amd
[    2.968179] ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf400 irq 14
[    2.968180] ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf408 irq 15
[    2.968442] ohci-pci 0000:00:0a.0: OHCI PCI host controller
[    2.968448] ohci-pci 0000:00:0a.0: new USB bus registered, assigned bus number 2
[    2.968490] ohci-pci 0000:00:0a.0: irq 23, io mem 0xfe02f000
[    2.973519] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
[    2.973663] checking generic (e0000000 130000) vs hw (e0000000 10000000)
[    2.973664] fb: switching to nouveaufb from VESA VGA
[    2.973684] Console: switching to colour dummy device 80x25
[    2.977186] nouveau 0000:09:00.0: NVIDIA G73 (04b300a2)
[    3.030082] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.030085] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.030086] usb usb2: Product: OHCI PCI host controller
[    3.030087] usb usb2: Manufacturer: Linux 4.11.8-2-default ohci_hcd
[    3.030088] usb usb2: SerialNumber: 0000:00:0a.0
[    3.030219] hub 2-0:1.0: USB hub found
[    3.030227] hub 2-0:1.0: 10 ports detected
[    3.030792] ACPI: PCI Interrupt Link [ASA2] enabled at IRQ 23
[    3.030799] sata_nv 0000:00:0d.2: Using SWNCQ mode
[    3.048055] scsi host7: sata_nv
[    3.068036] scsi host8: sata_nv
[    3.068077] ata7: SATA max UDMA/133 cmd 0xc800 ctl 0xc400 bmdma 0xb800 irq 23
[    3.068079] ata8: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb808 irq 23
[    3.142775] ata5.00: ATAPI: HL-DT-STDVD-ROM GDR8164B, 0L06, max UDMA/33
[    3.142780] ata5: nv_mode_filter: 0x739f&0x739f->0x739f, BIOS=0x7000 (0xc0000000) ACPI=0x701f (60:600:0x13)
[    3.147626] ata5.00: configured for UDMA/33
[    3.196027] 3w-9xxx: scsi1: AEN: INFO (0x04:0x0053): Battery capacity test is overdue:.
[    3.211984] nouveau 0000:09:00.0: bios: version 05.73.22.33.00
[    3.213249] nouveau 0000:09:00.0: fb: 256 MiB DDR2
[    3.214297] ata1: SATA link down (SStatus 0 SControl 300)
[    3.254301] ata3: SATA link down (SStatus 0 SControl 300)
[    3.269042] [TTM] Zone  kernel: Available graphics memory: 4086988 kiB
[    3.269043] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    3.269044] [TTM] Initializing pool allocator
[    3.269047] [TTM] Initializing DMA pool allocator
[    3.269064] nouveau 0000:09:00.0: DRM: VRAM: 252 MiB
[    3.269065] nouveau 0000:09:00.0: DRM: GART: 512 MiB
[    3.269067] nouveau 0000:09:00.0: DRM: TMDS table version 1.1
[    3.269069] nouveau 0000:09:00.0: DRM: TMDS table script pointers not stubbed
[    3.269070] nouveau 0000:09:00.0: DRM: DCB version 3.0
[    3.269072] nouveau 0000:09:00.0: DRM: DCB outp 00: 01000300 00000028
[    3.269073] nouveau 0000:09:00.0: DRM: DCB outp 01: 03000302 00000000
[    3.269075] nouveau 0000:09:00.0: DRM: DCB outp 02: 04011310 00000028
[    3.269076] nouveau 0000:09:00.0: DRM: DCB outp 03: 020223f1 00c0c083
[    3.269077] nouveau 0000:09:00.0: DRM: DCB conn 00: 0030
[    3.269078] nouveau 0000:09:00.0: DRM: DCB conn 01: 0100
[    3.269080] nouveau 0000:09:00.0: DRM: DCB conn 02: 0210
[    3.269081] nouveau 0000:09:00.0: DRM: DCB conn 03: 0211
[    3.269082] nouveau 0000:09:00.0: DRM: DCB conn 04: 0213
[    3.274723] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    3.274725] [drm] Driver supports precise vblank timestamp query.
[    3.278388] nouveau 0000:09:00.0: hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    3.279557] nouveau 0000:09:00.0: DRM: MM: using M2MF for buffer copies
[    3.279568] nouveau 0000:09:00.0: DRM: Setting dpms mode 3 on TV encoder (output 3)
[    3.316020] scsi host1: 3ware 9000 Storage Controller
[    3.316072] 3w-9xxx: scsi1: Found a 3ware 9000 Storage Controller at 0xfddff000, IRQ: 16.
[    3.382301] ata7: SATA link down (SStatus 0 SControl 300)
[    3.388181] nouveau 0000:09:00.0: DRM: allocated 1280x1024 fb: 0x9000, bo ffff880a3095d000
[    3.388577] fbcon: nouveaufb (fb0) is primary device
[    3.424018] usb 2-1: new low-speed USB device number 2 using ohci-pci
[    3.456097] firewire_core 0000:02:0b.0: created device fw0: GUID 0011d80000d9ef56, S400
[    3.518541] Console: switching to colour frame buffer device 160x64
[    3.526221] ata2: SATA link down (SStatus 0 SControl 300)
[    3.624848] nouveau 0000:09:00.0: fb0: nouveaufb frame buffer device
[    3.640048] [drm] Initialized nouveau 1.3.1 20120801 for 0000:09:00.0 on minor 0
[    3.676018] 3w-9xxx: scsi1: Firmware FE9X 3.08.00.029, BIOS BE9X 3.10.00.003, Ports: 8.
[    3.680545] scsi 1:0:0:0: Direct-Access     AMCC     9550SX-8LP DISK  3.08 PQ: 0 ANSI: 5
[    3.692017] usb 2-1: New USB device found, idVendor=06da, idProduct=0003
[    3.692019] usb 2-1: New USB device strings: Mfr=3, Product=1, SerialNumber=0
[    3.692020] usb 2-1: Product: USB UPS
[    3.692021] usb 2-1: Manufacturer: CTN
[    3.709177] usbcore: registered new interface driver usbhid
[    3.709179] usbhid: USB HID core driver
[    3.712622] hid-generic 0003:06DA:0003.0001: hiddev0,hidraw0: USB HID v1.11 Device [CTN USB UPS] on usb-0000:00:0a.0-1/input0
[    3.712704] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    3.713315] sd 1:0:0:0: [sda] 41943039 512-byte logical blocks: (21.5 GB/20.0 GiB)
[    3.713559] sd 1:0:0:0: [sda] Write Protect is off
[    3.713560] sd 1:0:0:0: [sda] Mode Sense: 23 00 00 00
[    3.713995] sd 1:0:0:0: [sda] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
[    3.728967] scsi 1:0:0:1: Direct-Access     AMCC     9550SX-8LP DISK  3.08 PQ: 0 ANSI: 5
[    3.761837]  sda: sda1 sda2 sda3
[    3.763471] sd 1:0:0:0: [sda] Attached SCSI disk
[    3.764289] sd 1:0:0:1: Attached scsi generic sg1 type 0
[    3.765050] sd 1:0:0:1: [sdb] 9723576321 512-byte logical blocks: (4.98 TB/4.53 TiB)
[    3.765279] sd 1:0:0:1: [sdb] Write Protect is off
[    3.765281] sd 1:0:0:1: [sdb] Mode Sense: 23 00 00 00
[    3.765895] sd 1:0:0:1: [sdb] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
[    3.788174] random: fast init done
[    3.813915]  sdb: sdb1
[    3.815337] sd 1:0:0:1: [sdb] Attached SCSI disk
[    3.838285] ata4: SATA link down (SStatus 0 SControl 300)
[    3.845592] scsi 5:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDR8164B 0L06 PQ: 0 ANSI: 5
[    3.857576] scsi 5:0:0:0: Attached scsi generic sg2 type 5
[    3.857683] ata6: port disabled--ignoring
[    3.940017] usb 1-5: new high-speed USB device number 3 using ehci-pci
[    4.090752] usb 1-5: New USB device found, idVendor=0bc2, idProduct=ab44
[    4.090754] usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.090755] usb 1-5: Product: Backup+ Hub
[    4.090756] usb 1-5: Manufacturer: Seagate
[    4.090757] usb 1-5: SerialNumber: 01CB6485B1Z1
[    4.091062] hub 1-5:1.0: USB hub found
[    4.091377] hub 1-5:1.0: 3 ports detected
[    4.170283] ata8: SATA link down (SStatus 0 SControl 300)
[    4.187150] sr 5:0:0:0: [sr0] scsi3-mmc drive: 52x/52x cd/rw xa/form2 cdda tray
[    4.187154] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.187381] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    4.269607] random: crng init done
[    4.380032] usb 1-5.1: new high-speed USB device number 4 using ehci-pci
[    4.533756] usb 1-5.1: New USB device found, idVendor=0bc2, idProduct=ab38
[    4.533758] usb 1-5.1: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[    4.533760] usb 1-5.1: Product: Backup+ Hub BK
[    4.533761] usb 1-5.1: Manufacturer: Seagate
[    4.533762] usb 1-5.1: SerialNumber: NA8THNZH
[    4.535534] usbcore: registered new interface driver usb-storage
[    4.536730] scsi host9: uas
[    4.539381] scsi 9:0:0:0: Direct-Access     Seagate  Backup+ Hub BK   D781 PQ: 0 ANSI: 6
[    4.576185] sd 9:0:0:0: Attached scsi generic sg3 type 0
[    4.577895] usbcore: registered new interface driver uas
[    4.579013] sd 9:0:0:0: [sdc] 11721045167 512-byte logical blocks: (6.00 TB/5.46 TiB)
[    4.579015] sd 9:0:0:0: [sdc] 4096-byte physical blocks
[    4.579380] sd 9:0:0:0: [sdc] Write Protect is off
[    4.579382] sd 9:0:0:0: [sdc] Mode Sense: 4f 00 00 00
[    4.580016] sd 9:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.596029]  sdc: sdc1
[    4.598893] sd 9:0:0:0: [sdc] Attached SCSI disk
[    4.673234] PM: Starting manual resume from disk
[    4.673237] PM: Hibernation image partition 8:2 present
[    4.673238] PM: Looking for hibernation image.
[    4.673472] PM: Image not found (code -22)
[    4.673473] PM: Hibernation image not present or could not be loaded.
[    4.836630] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    5.042965] systemd-journald[133]: Received SIGTERM from PID 1 (systemd).
[    5.181489] systemd: 15 output lines suppressed due to ratelimiting
[    6.175300] systemd-sysv-generator[476]: Overwriting existing symlink /run/systemd/generator.late/3dm2.service with real service.
[    7.028911] EXT4-fs (sda3): re-mounted. Opts: acl,user_xattr
[    7.160680] RPC: Registered named UNIX socket transport module.
[    7.160682] RPC: Registered udp transport module.
[    7.160682] RPC: Registered tcp transport module.
[    7.160683] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    7.288644] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    7.667196] systemd-journald[486]: Received request to flush runtime journal from PID 1
[    9.428132] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    9.508748] ACPI: Invalid passive threshold
[    9.508922] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    9.509034] thermal LNXTHERM:00: registered as thermal_zone0
[    9.509036] ACPI: Thermal Zone [THRM] (40 C)
[    9.555016] ATK0110 ATK0110:00: hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    9.572511] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[    9.572519] k8temp 0000:00:18.3: hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    9.590487] ACPI Warning: SystemIO range 0x0000000000001C00-0x0000000000001C3F conflicts with OpRegion 0x0000000000001C00-0x0000000000001C05 (\_SB.PCI0.SM00) (20170119/utaddress-247)
[    9.590493] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    9.590529] i2c i2c-3: nForce2 SMBus adapter at 0x1c40
[    9.609375] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    9.609455] nv_tco: Watchdog reboot not detected
[    9.609505] nv_tco: initialized (0x1440). heartbeat=30 sec (nowayout=0)
[    9.618757] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    9.623616] IT8716 SuperIO detected.
[    9.623813] parport_pc 00:04: reported by Plug and Play ACPI
[    9.623872] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[    9.638511] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    9.638513] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    9.638898] ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
[    9.720627] ppdev: user-space parallel port driver
[    9.912437] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    9.912838] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
[    9.991398] e1000 0000:04:02.0 eth0: (PCI-X:133MHz:64-bit) 00:04:23:bd:33:50
[    9.991403] e1000 0000:04:02.0 eth0: Intel(R) PRO/1000 Network Connection
[   10.220893] kvm: Nested Virtualization enabled
[   10.241225] EDAC MC: Ver: 3.0.0
[   10.255155] MCE: In-kernel MCE decoding enabled.
[   10.262121] EDAC amd64: Node 0: DRAM ECC disabled.
[   10.262123] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
                Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
                (Note that use of the override may cause unknown side effects.)
[   10.323474] e1000 0000:04:02.1 eth1: (PCI-X:133MHz:64-bit) 00:04:23:bd:33:51
[   10.323478] e1000 0000:04:02.1 eth1: Intel(R) PRO/1000 Network Connection
[   10.345306] powernow_k8: fid 0x18 (3200 MHz), vid 0x8
[   10.345308] powernow_k8: fid 0x16 (3000 MHz), vid 0xa
[   10.345309] powernow_k8: fid 0x14 (2800 MHz), vid 0xc
[   10.345309] powernow_k8: fid 0x12 (2600 MHz), vid 0xe
[   10.345310] powernow_k8: fid 0x10 (2400 MHz), vid 0x10
[   10.345310] powernow_k8: fid 0xe (2200 MHz), vid 0x10
[   10.345311] powernow_k8: fid 0xc (2000 MHz), vid 0x10
[   10.345312] powernow_k8: fid 0xa (1800 MHz), vid 0x10
[   10.345312] powernow_k8: fid 0x2 (1000 MHz), vid 0x12
[   10.345365] powernow_k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6400+ (2 cpu cores) (version 2.20.00)
[   10.425783] e1000 0000:04:02.1 enp4s2f1: renamed from eth1
[   10.429892] audit: type=1400 audit(1501604155.592:2): apparmor="STATUS" operation="profile_load" name="/{usr/,}bin/ping" pid=621 comm="apparmor_parser"
[   10.440543] e1000 0000:04:02.0 enp4s2f0: renamed from eth0
[   10.456486] forcedeth 0000:00:10.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:18:f3:5a:2a:99
[   10.456490] forcedeth 0000:00:10.0: highdma csum vlan pwrctl mgmt gbit lnktim msi desc-v3
[   10.456921] ACPI: PCI Interrupt Link [AMC1] enabled at IRQ 21
[   10.722962] audit: type=1400 audit(1501604155.884:3): apparmor="STATUS" operation="profile_load" name="klogd" pid=800 comm="apparmor_parser"
[   10.996626] forcedeth 0000:00:11.0: ifname eth1, PHY OUI 0x5043 @ 1, addr 00:18:f3:5a:2e:7b
[   10.996631] forcedeth 0000:00:11.0: highdma csum vlan pwrctl mgmt gbit lnktim msi desc-v3
[   10.997322] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 20
[   10.997336] snd_hda_intel 0000:00:0e.1: msi for device 1043:81f6 set to 0
[   10.999462] forcedeth 0000:00:11.0 enp0s17: renamed from eth1
[   11.013053] forcedeth 0000:00:10.0 enp0s16: renamed from eth0
[   11.299291] audit: type=1400 audit(1501604156.460:4): apparmor="STATUS" operation="profile_load" name="syslog-ng" pid=814 comm="apparmor_parser"
[   11.351006] Adding 2096124k swap on /dev/sda2.  Priority:-1 extents:1 across:2096124k FS
[   11.472172] raid6: sse2x1   gen()  3709 MB/s
[   11.503944] audit: type=1400 audit(1501604156.664:5): apparmor="STATUS" operation="profile_load" name="syslogd" pid=827 comm="apparmor_parser"
[   11.540025] raid6: sse2x1   xor()  3450 MB/s
[   11.584405] audit: type=1400 audit(1501604156.748:6): apparmor="STATUS" operation="profile_load" name="/usr/bin/lessopen.sh" pid=833 comm="apparmor_parser"
[   11.608036] raid6: sse2x2   gen()  5403 MB/s
[   11.676024] raid6: sse2x2   xor()  4157 MB/s
[   11.744422] raid6: sse2x4   gen()  5286 MB/s
[   11.813146] raid6: sse2x4   xor()  2404 MB/s
[   11.813148] raid6: using algorithm sse2x2 gen() 5403 MB/s
[   11.813148] raid6: .... xor() 4157 MB/s, rmw enabled
[   11.813149] raid6: using intx1 recovery algorithm
[   11.837445] xor: measuring software checksum speed
[   11.876209]    prefetch64-sse:  9342.000 MB/sec
[   11.916079]    generic_sse:  9322.000 MB/sec
[   11.916080] xor: using function: prefetch64-sse (9342.000 MB/sec)
[   11.960122] Btrfs loaded, crc32c=crc32c-generic, assert=on
[   11.960693] BTRFS: device fsid 22aaaa76-0885-4683-ac04-477c27cfab80 devid 1 transid 1486834 /dev/sdb1
[   12.217464] audit: type=1400 audit(1501604157.380:7): apparmor="STATUS" operation="profile_load" name="/usr/lib/apache2/mpm-prefork/apache2" pid=837 comm="apparmor_parser"
[   12.217660] audit: type=1400 audit(1501604157.380:8): apparmor="STATUS" operation="profile_load" name="/usr/lib/apache2/mpm-prefork/apache2//DEFAULT_URI" pid=837 comm="apparmor_parser"
[   12.217832] audit: type=1400 audit(1501604157.380:9): apparmor="STATUS" operation="profile_load" name="/usr/lib/apache2/mpm-prefork/apache2//HANDLING_UNTRUSTED_INPUT" pid=837 comm="apparmor_parser"
[   12.218343] audit: type=1400 audit(1501604157.380:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/apache2/mpm-prefork/apache2//phpsysinfo" pid=837 comm="apparmor_parser"
[   12.276155] audit: type=1400 audit(1501604157.440:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/dovecot/anvil" pid=842 comm="apparmor_parser"
[   12.564021] snd_hda_codec_analog hdaudioC0D0: autoconfig for AD1988B: line_outs=4 (0x12/0x16/0x24/0x25/0x0) type:line
[   12.564024] snd_hda_codec_analog hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   12.564025] snd_hda_codec_analog hdaudioC0D0:    hp_outs=1 (0x11/0x0/0x0/0x0/0x0)
[   12.564026] snd_hda_codec_analog hdaudioC0D0:    mono: mono_out=0x0
[   12.564027] snd_hda_codec_analog hdaudioC0D0:    dig-out=0x1b/0x0
[   12.564028] snd_hda_codec_analog hdaudioC0D0:    inputs:
[   12.564030] snd_hda_codec_analog hdaudioC0D0:      Front Mic=0x14
[   12.564031] snd_hda_codec_analog hdaudioC0D0:      Rear Mic=0x17
[   12.564032] snd_hda_codec_analog hdaudioC0D0:      Line=0x15
[   12.564033] snd_hda_codec_analog hdaudioC0D0:      CD=0x18
[   12.769348] floppy0: no floppy controllers found
[   12.769364] work still pending
[   15.163186] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:0e.1/sound/card0/input6
[   15.163541] input: HDA NVidia Rear Mic as /devices/pci0000:00/0000:00:0e.1/sound/card0/input7
[   15.163596] input: HDA NVidia Line as /devices/pci0000:00/0000:00:0e.1/sound/card0/input8
[   15.163650] input: HDA NVidia Line Out Front as /devices/pci0000:00/0000:00:0e.1/sound/card0/input9
[   15.163703] input: HDA NVidia Line Out Surround as /devices/pci0000:00/0000:00:0e.1/sound/card0/input10
[   15.163758] input: HDA NVidia Line Out CLFE as /devices/pci0000:00/0000:00:0e.1/sound/card0/input11
[   15.163811] input: HDA NVidia Line Out Side as /devices/pci0000:00/0000:00:0e.1/sound/card0/input12
[   15.566113] EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem
[   15.588871] EXT4-fs (sda1): warning: mounting unchecked fs, running e2fsck is recommended
[   15.589082] EXT4-fs (sda1): mounted filesystem without journal. Opts: acl,user_xattr
[   15.675492] kauditd_printk_skb: 23 callbacks suppressed
[   15.675495] audit: type=1400 audit(1501604160.836:35): apparmor="STATUS" operation="profile_load" name="/usr/sbin/dovecot" pid=947 comm="apparmor_parser"
[   16.233868] audit: type=1400 audit(1501604161.396:36): apparmor="STATUS" operation="profile_load" name="/usr/sbin/identd" pid=980 comm="apparmor_parser"
[   16.344025] audit: type=1400 audit(1501604161.504:37): apparmor="STATUS" operation="profile_load" name="/usr/sbin/libvirtd" pid=997 comm="apparmor_parser"
[   16.344329] audit: type=1400 audit(1501604161.508:38): apparmor="STATUS" operation="profile_load" name="/usr/sbin/libvirtd//qemu_bridge_helper" pid=997 comm="apparmor_parser"
[   16.465871] audit: type=1400 audit(1501604161.628:39): apparmor="STATUS" operation="profile_load" name="/usr/sbin/mdnsd" pid=1003 comm="apparmor_parser"
[   16.610288] audit: type=1400 audit(1501604161.772:40): apparmor="STATUS" operation="profile_load" name="/usr/sbin/nmbd" pid=1007 comm="apparmor_parser"
[   16.765434] audit: type=1400 audit(1501604161.928:41): apparmor="STATUS" operation="profile_load" name="/usr/sbin/nscd" pid=1011 comm="apparmor_parser"
[   16.950398] audit: type=1400 audit(1501604162.112:42): apparmor="STATUS" operation="profile_load" name="/usr/sbin/ntpd" pid=1015 comm="apparmor_parser"
[   17.168619] audit: type=1400 audit(1501604162.332:43): apparmor="STATUS" operation="profile_load" name="/usr/sbin/smbd" pid=1019 comm="apparmor_parser"
[   17.447675] audit: type=1400 audit(1501604162.608:44): apparmor="STATUS" operation="profile_load" name="/usr/sbin/smbldap-useradd" pid=1023 comm="apparmor_parser"
[   20.223125] No iBFT detected.
[   20.358780] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
[   20.413147] Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
[   20.413988] bond0 (uninitialized): Setting MII monitoring interval to 100
[   20.413996] bond0 (uninitialized): Setting LACP rate to fast (1)
[   20.551469] br1: port 1(enp4s2f0) entered blocking state
[   20.551473] br1: port 1(enp4s2f0) entered disabled state
[   20.551580] device enp4s2f0 entered promiscuous mode
[   20.554992] forcedeth 0000:00:10.0 enp0s16: MSI enabled
[   20.557090] bond0: Enslaving enp0s16 as a backup interface with an up link
[   20.560473] e1000: enp4s2f0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   20.565168] forcedeth 0000:00:11.0 enp0s17: MSI enabled
[   20.566725] bond0: Enslaving enp0s17 as a backup interface with an up link
[   20.569591] br1: port 1(enp4s2f0) entered blocking state
[   20.569594] br1: port 1(enp4s2f0) entered forwarding state
[   20.576365] br0: port 1(bond0) entered blocking state
[   20.576379] br0: port 1(bond0) entered disabled state
[   20.577438] device bond0 entered promiscuous mode
[   20.577439] device enp0s16 entered promiscuous mode
[   20.577656] device enp0s17 entered promiscuous mode
[   20.586855] IPv6: ADDRCONF(NETDEV_UP): br0: link is not ready
[   21.440392] br0: port 1(bond0) entered blocking state
[   21.440395] br0: port 1(bond0) entered forwarding state
[   21.440479] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
[   24.568063] kauditd_printk_skb: 3 callbacks suppressed
[   24.568066] audit: type=1400 audit(1501604169.728:48): apparmor="DENIED" operation="capable" profile="/usr/sbin/ntpd" pid=1705 comm="ntpd" capability=12  capname="net_admin"
[   24.891807] audit: type=1400 audit(1501604170.051:49): apparmor="DENIED" operation="capable" profile="/usr/sbin/nmbd" pid=1671 comm="nmbd" capability=12  capname="net_admin"
[   24.893523] audit: type=1400 audit(1501604170.055:50): apparmor="DENIED" operation="rename_src" profile="/usr/sbin/nmbd" name="/var/log/samba/log.nmbd" pid=1713 comm="nmbd" requested_mask="r" denied_mask="r" fsuid=0 ouid=0
[   25.100548] NFSD: starting 90-second grace period (net ffffffffa1ef6580)
[   26.296058] audit: type=1400 audit(1501604171.459:51): apparmor="DENIED" operation="capable" profile="/usr/sbin/smbd" pid=1744 comm="smbd" capability=12  capname="net_admin"
[   26.608079] audit: type=1400 audit(1501604171.771:52): apparmor="DENIED" operation="capable" profile="/usr/sbin/smbd" pid=1776 comm="smbd" capability=12  capname="net_admin"
[   26.608509] audit: type=1400 audit(1501604171.771:53): apparmor="DENIED" operation="rename_src" profile="/usr/sbin/smbd" name="/var/log/samba/log.smbd" pid=1776 comm="smbd" requested_mask="r" denied_mask="r" fsuid=0 ouid=0
[   28.300046] NET: Registered protocol family 17
[   28.536188] ip_tables: (C) 2000-2006 Netfilter Core Team
[   28.574776] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   29.012900] Ebtables v2.0 registered
[   57.756492] SGI XFS with ACLs, security attributes, no debug enabled
[   57.765682] XFS (sdc1): Mounting V5 Filesystem
[   57.843017] XFS (sdc1): Ending clean mount
[  159.365720] audit: type=1400 audit(1501604304.850:54): apparmor="DENIED" operation="capable" profile="/usr/sbin/nmbd" pid=1713 comm="nmbd" capability=12  capname="net_admin"
[  758.108408] audit: type=1400 audit(1501604903.597:55): apparmor="DENIED" operation="capable" profile="/usr/sbin/nmbd" pid=1713 comm="nmbd" capability=12  capname="net_admin"
[ 9104.841365] audit: type=1400 audit(1501613250.329:56): apparmor="DENIED" operation="rename_src" profile="/usr/sbin/nmbd" name="/var/log/samba/log.nmbd" pid=1713 comm="nmbd" requested_mask="r" denied_mask="r" fsuid=0 ouid=0
[18131.259411] BTRFS warning (device sdb1): 'recovery' is deprecated, use 'usebackuproot' instead
[18131.259417] BTRFS info (device sdb1): trying to use backup root at mount time
[18131.259424] BTRFS info (device sdb1): disabling disk space caching
[18131.259430] BTRFS info (device sdb1): force clearing of disk cache
[18131.259434] BTRFS info (device sdb1): has skinny extents
[18131.332905] BTRFS error (device sdb1): parent transid verify failed on 29392896 wanted 1486833 found 1486836
[18131.340976] BTRFS error (device sdb1): parent transid verify failed on 29392896 wanted 1486833 found 1486836
[18131.372068] BTRFS error (device sdb1): open_ctree failed
[20836.972274] audit: type=1400 audit(1501624982.455:57): apparmor="DENIED" operation="rename_src" profile="/usr/sbin/nmbd" name="/var/log/samba/log.nmbd" pid=1713 comm="nmbd" requested_mask="r" denied_mask="r" fsuid=0 ouid=0
[31666.088054] audit: type=1400 audit(1501635811.572:58): apparmor="DENIED" operation="rename_src" profile="/usr/sbin/nmbd" name="/var/log/samba/log.nmbd" pid=1713 comm="nmbd" requested_mask="r" denied_mask="r" fsuid=0 ouid=0
[43409.437677] audit: type=1400 audit(1501647554.923:59): apparmor="DENIED" operation="rename_src" profile="/usr/sbin/nmbd" name="/var/log/samba/log.nmbd" pid=1713 comm="nmbd" requested_mask="r" denied_mask="r" fsuid=0 ouid=0
[54235.956270] audit: type=1400 audit(1501658381.440:60): apparmor="DENIED" operation="rename_src" profile="/usr/sbin/nmbd" name="/var/log/samba/log.nmbd" pid=1713 comm="nmbd" requested_mask="r" denied_mask="r" fsuid=0 ouid=0

--nextPart3985627.nAAz5UcWEY--

