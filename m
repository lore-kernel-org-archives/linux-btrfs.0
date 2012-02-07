From: Chester <somethingsome2000@gmail.com>
Subject: Re: btrfs unmountable after failed suspend
Date: Tue, 7 Feb 2012 17:22:14 -0600
Message-ID: <CAAE6i0jEaXmgmnmyUOrOr+5RyvPce25QZFALan+JBQ80K=UwNQ@mail.gmail.com>
References: <CAAE6i0g4VVpy7FduBHCY33Nt_iSOh39-9i2KWqA0fXETQUKLPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0g4VVpy7FduBHCY33Nt_iSOh39-9i2KWqA0fXETQUKLPA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

whole dmesg pasted inline:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0 (root@localhost) (gcc version 4.6.2
(Gentoo 4.6.2 p1.1, pie-0.4.5) ) #7 SMP Thu Feb 2 17:22:14 CST 2012
[    0.000000] Command line: BOOT_IMAGE=/bzImage-3.2 root=/dev/sda6
rootflags=subvolid=256 rootfstype=btrfs selinux=0 radeon.modeset=0
pcie_aspm=force i842.noacpi raid=noautodetect rescue
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfb3f000 (usable)
[    0.000000]  BIOS-e820: 00000000bfb3f000 - 00000000bfbbf000 (reserved)
[    0.000000]  BIOS-e820: 00000000bfbbf000 - 00000000bfebf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfebf000 - 00000000bfef6000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfef6000 - 00000000bff00000 (usable)
[    0.000000]  BIOS-e820: 00000000bff00000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000019f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: Hewlett-Packard HP Pavilion dv6 Notebook PC/358B,
BIOS F.20 07/13/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x19f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 00BFEBD000 mask FFFFFFF000 uncachable
[    0.000000]   3 base 00FFE00000 mask FFFFE00000 write-protect
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000019f000000 aka 6640M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbff00 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fe1b0] fe1b0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000bff00000
[    0.000000]  0000000000 - 0080000000 page 1G
[    0.000000]  0080000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bff00000 page 4k
[    0.000000] kernel direct mapping tables up to bff00000 @ 1fffd000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000019f000000
[    0.000000]  0100000000 - 0180000000 page 1G
[    0.000000]  0180000000 - 019f000000 page 2M
[    0.000000] kernel direct mapping tables up to 19f000000 @ bfefe000-bff00000
[    0.000000] RAMDISK: 37e10000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 HPQOEM)
[    0.000000] ACPI: XSDT 00000000bfef5120 0007C (v01 HPQOEM SLIC-MPC
00000001      01000013)
[    0.000000] ACPI: FACP 00000000bfef4000 000F4 (v04 HPQOEM SLIC-MPC
00000001 ACPI 00040000)
[    0.000000] ACPI: DSDT 00000000bfede000 1149A (v01 HP     INSYDE
F0000000 ACPI 00040000)
[    0.000000] ACPI: FACS 00000000bfc95000 00040
[    0.000000] ACPI: HPET 00000000bfef3000 00038 (v01 HP     INSYDE
00000001 ACPI 00040000)
[    0.000000] ACPI: APIC 00000000bfef2000 00084 (v02 HP     INSYDE
00000001 ACPI 00040000)
[    0.000000] ACPI: MCFG 00000000bfef1000 0003C (v01 HP     INSYDE
00000001 ACPI 00040000)
[    0.000000] ACPI: ASF! 00000000bfef0000 000A5 (v32 HP     INSYDE
00000001 ACPI 00040000)
[    0.000000] ACPI: BOOT 00000000bfedd000 00028 (v01 HP     INSYDE
00000001 ACPI 00040000)
[    0.000000] ACPI: SLIC 00000000bfedc000 00176 (v01 HPQOEM SLIC-MPC
00000001 ACPI 00040000)
[    0.000000] ACPI: WDRT 00000000bfedb000 00047 (v01 HP     INSYDE
00000001 ACPI 00040000)
[    0.000000] ACPI: MSDM 00000000bfeda000 00055 (v03 HP     INSYDE
00000001 ACPI 00040000)
[    0.000000] ACPI: SSDT 00000000bfed9000 00E28 (v01 HP     INSYDE
00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000bfed7000 0190A (v02 HP     INSYDE
00000001 MSFT 04000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000019f000000
[    0.000000] Initmem setup node 0 0000000000000000-000000019f000000
[    0.000000]   NODE_DATA [000000019effb000 - 000000019effffff]
[    0.000000]  [ffffea0000000000-ffffea00067fffff] PMD ->
[ffff880198e00000-ffff88019e5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0019f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bfb3f
[    0.000000]     0: 0x000bfef6 -> 0x000bff00
[    0.000000]     0: 0x00100000 -> 0x0019f000
[    0.000000] On node 0 totalpages: 1436376
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3914 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 764809 pages, LIFO batch:31
[    0.000000]   Normal zone: 10176 pages used for memmap
[    0.000000]   Normal zone: 641088 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10228210 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bfb3f000 - 00000000bfbbf000
[    0.000000] PM: Registered nosave memory: 00000000bfbbf000 - 00000000bfebf000
[    0.000000] PM: Registered nosave memory: 00000000bfebf000 - 00000000bfef6000
[    0.000000] PM: Registered nosave memory: 00000000bff00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fec11000
[    0.000000] PM: Registered nosave memory: 00000000fec11000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap:
e0000000:18000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4
nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88019ec00000 s77632
r8192 d20672 u524288
[    0.000000] pcpu-alloc: s77632 r8192 d20672 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 1409811
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/bzImage-3.2
root=/dev/sda6 rootflags=subvolid=256 rootfstype=btrfs selinux=0
radeon.modeset=0 pcie_aspm=force i842.noacpi raid=noautodetect rescue
[    0.000000] PCIe ASPM is forcibly enabled
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 5572172k/6799360k available (6504k kernel code,
1053856k absent, 173332k reserved, 6457k data, 632k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1896.605 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3793.21 BogoMIPS (lpj=7586420)
[    0.004288] pid_max: default: 32768 minimum: 301
[    0.004455] Security Framework initialized
[    0.004598] SELinux:  Disabled at boot.
[    0.005634] Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.010105] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.011623] Mount-cache hash table entries: 256
[    0.011974] Initializing cgroup subsys cpuacct
[    0.012010] Initializing cgroup subsys devices
[    0.012164] Initializing cgroup subsys freezer
[    0.012345] tseg: 00bff00000
[    0.012348] CPU: Physical Processor ID: 0
[    0.012499] CPU: Processor Core ID: 0
[    0.012650] mce: CPU supports 6 MCE banks
[    0.013691] ACPI: Core revision 20110623
[    0.024476] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066639] CPU0: AMD A8-3530MX APU with Radeon(tm) HD Graphics stepping 00
[    0.068003] APIC calibration not consistent with PM-Timer: 447ms
instead of 100ms
[    0.068003] APIC delta adjusted to PM-Timer: 1247729 (5589764)
[    0.068003] Performance Events: AMD PMU driver.
[    0.068003] ... version:                0
[    0.068003] ... bit width:              48
[    0.068003] ... generic registers:      4
[    0.068003] ... value mask:             0000ffffffffffff
[    0.068003] ... max period:             00007fffffffffff
[    0.068003] ... fixed-purpose events:   0
[    0.068003] ... event mask:             000000000000000f
[    0.068003] MCE: In-kernel MCE decoding enabled.
[    0.068003] Booting Node   0, Processors  #1
[    0.068003] smpboot cpu 1: start_ip = 9a000
[    0.160085]  #2
[    0.160168] smpboot cpu 2: start_ip = 9a000
[    0.252090]  #3 Ok.
[    0.252289] smpboot cpu 3: start_ip = 9a000
[    0.344026] Brought up 4 CPUs
[    0.344226] Total of 4 processors activated (15172.54 BogoMIPS).
[    0.345639] devtmpfs: initialized
[    0.345639] PM: Registering ACPI NVS region at bfbbf000 (3145728 bytes)
[    0.345639] kworker/u:0 used greatest stack depth: 6536 bytes left
[    0.345639] RTC time: 15:58:12, date: 02/07/12
[    0.345639] NET: Registered protocol family 16
[    0.345639] kworker/u:0 used greatest stack depth: 5600 bytes left
[    0.348157] Extended Config Space enabled on 0 nodes
[    0.348324] ACPI: bus type pci registered
[    0.348565] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.348565] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.357740] PCI: Using configuration type 1 for base access
[    0.372201] bio: create slab <bio-0> at 0
[    0.372387] ACPI: Added _OSI(Module Device)
[    0.372387] ACPI: Added _OSI(Processor Device)
[    0.372387] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.372489] ACPI: Added _OSI(Processor Aggregator Device)
[    0.378026] ACPI: EC: Look up EC in DSDT
[    0.380205] ACPI: Executed 1 blocks of module-level executable AML code
[    0.386120] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.404099] ACPI: Interpreter enabled
[    0.404305] ACPI: (supports S0 S3 S4 S5)
[    0.404585] ACPI: Using IOAPIC for interrupt routing
[    0.424646] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.424646] ACPI: No dock devices found.
[    0.424646] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.424913] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.425220] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.425220] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.425220] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    0.428034] pci_root PNP0A08:00: host bridge window [mem
0x000c0000-0x000c3fff]
[    0.428237] pci_root PNP0A08:00: host bridge window [mem
0x000c4000-0x000c7fff]
[    0.428440] pci_root PNP0A08:00: host bridge window [mem
0x000c8000-0x000cbfff]
[    0.428638] pci_root PNP0A08:00: host bridge window [mem
0x000cc000-0x000cffff]
[    0.428836] pci_root PNP0A08:00: host bridge window [mem
0x000d0000-0x000d3fff]
[    0.429021] pci_root PNP0A08:00: host bridge window [mem
0x000d4000-0x000d7fff]
[    0.429219] pci_root PNP0A08:00: host bridge window [mem
0x000d8000-0x000dbfff]
[    0.429420] pci_root PNP0A08:00: host bridge window [mem
0x000dc000-0x000dffff]
[    0.432028] pci_root PNP0A08:00: host bridge window [mem
0x000e0000-0x000e3fff]
[    0.432232] pci_root PNP0A08:00: host bridge window [mem
0x000e4000-0x000e7fff]
[    0.432422] pci_root PNP0A08:00: host bridge window [mem
0x000e8000-0x000ebfff]
[    0.432621] pci_root PNP0A08:00: host bridge window [mem
0x000ec000-0x000effff]
[    0.432819] pci_root PNP0A08:00: host bridge window [mem
0xe0000000-0xf7ffffff]
[    0.433017] pci_root PNP0A08:00: host bridge window [mem
0xfc000000-0xfed3ffff]
[    0.433215] pci_root PNP0A08:00: host bridge window [mem
0xfed45000-0xffffffff]
[    0.433420] pci_root PNP0A08:00: ignoring host bridge window [mem
0x000cc000-0x000cffff] (conflicts with Video ROM [mem
0x000c0000-0x000cf1ff])
[    0.433638] pci 0000:00:00.0: [1022:1705] type 0 class 0x000600
[    0.433679] pci 0000:00:01.0: [1002:9641] type 0 class 0x000300
[    0.433690] pci 0000:00:01.0: reg 10: [mem 0xe0000000-0xefffffff pref]
[    0.433697] pci 0000:00:01.0: reg 14: [io  0x3000-0x30ff]
[    0.433704] pci 0000:00:01.0: reg 18: [mem 0xf0300000-0xf033ffff]
[    0.433739] pci 0000:00:01.0: supports D1 D2
[    0.433756] pci 0000:00:01.1: [1002:1714] type 0 class 0x000403
[    0.433765] pci 0000:00:01.1: reg 10: [mem 0xf0344000-0xf0347fff]
[    0.433808] pci 0000:00:01.1: supports D1 D2
[    0.433877] pci 0000:00:04.0: [1022:1709] type 1 class 0x000604
[    0.433918] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.433922] pci 0000:00:04.0: PME# disabled
[    0.433941] pci 0000:00:05.0: [1022:170a] type 1 class 0x000604
[    0.433982] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.433985] pci 0000:00:05.0: PME# disabled
[    0.434002] pci 0000:00:06.0: [1022:170b] type 1 class 0x000604
[    0.434038] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.434041] pci 0000:00:06.0: PME# disabled
[    0.434136] pci 0000:00:10.0: [1022:7812] type 0 class 0x000c03
[    0.434161] pci 0000:00:10.0: reg 10: [mem 0xf0348000-0xf0349fff 64bit]
[    0.434267] pci 0000:00:10.0: PME# supported from D0 D3hot D3cold
[    0.434271] pci 0000:00:10.0: PME# disabled
[    0.434323] pci 0000:00:10.1: [1022:7812] type 0 class 0x000c03
[    0.434349] pci 0000:00:10.1: reg 10: [mem 0xf034a000-0xf034bfff 64bit]
[    0.434461] pci 0000:00:10.1: PME# supported from D0 D3hot D3cold
[    0.434466] pci 0000:00:10.1: PME# disabled
[    0.434510] pci 0000:00:11.0: [1022:7804] type 0 class 0x000106
[    0.434529] pci 0000:00:11.0: reg 10: [io  0x3138-0x313f]
[    0.434539] pci 0000:00:11.0: reg 14: [io  0x314c-0x314f]
[    0.434549] pci 0000:00:11.0: reg 18: [io  0x3130-0x3137]
[    0.434559] pci 0000:00:11.0: reg 1c: [io  0x3148-0x314b]
[    0.434568] pci 0000:00:11.0: reg 20: [io  0x3110-0x311f]
[    0.434578] pci 0000:00:11.0: reg 24: [mem 0xf0350000-0xf03507ff]
[    0.434625] pci 0000:00:12.0: [1022:7807] type 0 class 0x000c03
[    0.434638] pci 0000:00:12.0: reg 10: [mem 0xf034f000-0xf034ffff]
[    0.434713] pci 0000:00:12.2: [1022:7808] type 0 class 0x000c03
[    0.435405] pci 0000:00:12.2: reg 10: [mem 0xf034e000-0xf034e0ff]
[    0.439315] pci 0000:00:12.2: supports D1 D2
[    0.439320] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.439331] pci 0000:00:12.2: PME# disabled
[    0.439360] pci 0000:00:13.0: [1022:7807] type 0 class 0x000c03
[    0.439376] pci 0000:00:13.0: reg 10: [mem 0xf034d000-0xf034dfff]
[    0.439453] pci 0000:00:13.2: [1022:7808] type 0 class 0x000c03
[    0.440045] pci 0000:00:13.2: reg 10: [mem 0xf034c000-0xf034c0ff]
[    0.444092] pci 0000:00:13.2: supports D1 D2
[    0.444096] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.444102] pci 0000:00:13.2: PME# disabled
[    0.444131] pci 0000:00:14.0: [1022:780b] type 0 class 0x000c05
[    0.444209] pci 0000:00:14.1: [1022:780c] type 0 class 0x000101
[    0.444225] pci 0000:00:14.1: reg 10: [io  0x3128-0x312f]
[    0.444235] pci 0000:00:14.1: reg 14: [io  0x3144-0x3147]
[    0.444246] pci 0000:00:14.1: reg 18: [io  0x3120-0x3127]
[    0.444256] pci 0000:00:14.1: reg 1c: [io  0x3140-0x3143]
[    0.444266] pci 0000:00:14.1: reg 20: [io  0x3100-0x310f]
[    0.444305] pci 0000:00:14.2: [1022:780d] type 0 class 0x000403
[    0.444329] pci 0000:00:14.2: reg 10: [mem 0xf0340000-0xf0343fff 64bit]
[    0.444396] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.444401] pci 0000:00:14.2: PME# disabled
[    0.444426] pci 0000:00:14.3: [1022:780e] type 0 class 0x000601
[    0.444512] pci 0000:00:14.4: [1022:780f] type 1 class 0x000604
[    0.444566] pci 0000:00:18.0: [1022:1700] type 0 class 0x000600
[    0.444603] pci 0000:00:18.1: [1022:1701] type 0 class 0x000600
[    0.444635] pci 0000:00:18.2: [1022:1702] type 0 class 0x000600
[    0.444669] pci 0000:00:18.3: [1022:1703] type 0 class 0x000600
[    0.444709] pci 0000:00:18.4: [1022:1704] type 0 class 0x000600
[    0.444741] pci 0000:00:18.5: [1022:1718] type 0 class 0x000600
[    0.444775] pci 0000:00:18.6: [1022:1716] type 0 class 0x000600
[    0.444807] pci 0000:00:18.7: [1022:1719] type 0 class 0x000600
[    0.444949] pci 0000:01:00.0: [10ec:8168] type 0 class 0x000200
[    0.444967] pci 0000:01:00.0: reg 10: [io  0x2000-0x20ff]
[    0.444992] pci 0000:01:00.0: reg 18: [mem 0xf0004000-0xf0004fff 64bit pref]
[    0.445008] pci 0000:01:00.0: reg 20: [mem 0xf0000000-0xf0003fff 64bit pref]
[    0.445052] pci 0000:01:00.0: supports D1 D2
[    0.445054] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.445059] pci 0000:01:00.0: PME# disabled
[    0.452095] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.452310] pci 0000:00:04.0:   bridge window [io  0x2000-0x2fff]
[    0.452317] pci 0000:00:04.0:   bridge window [mem
0xf0000000-0xf00fffff 64bit pref]
[    0.452396] pci 0000:02:00.0: [14e4:4727] type 0 class 0x000280
[    0.452419] pci 0000:02:00.0: reg 10: [mem 0xf0200000-0xf0203fff 64bit]
[    0.452506] pci 0000:02:00.0: supports D1 D2
[    0.460106] pci 0000:00:05.0: PCI bridge to [bus 02-02]
[    0.460320] pci 0000:00:05.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.460384] pci 0000:03:00.0: [10ec:5209] type 0 class 0x00ff00
[    0.460402] pci 0000:03:00.0: reg 10: [mem 0xf0100000-0xf0100fff]
[    0.460491] pci 0000:03:00.0: supports D1 D2
[    0.460493] pci 0000:03:00.0: PME# supported from D1 D2 D3hot
[    0.460499] pci 0000:03:00.0: PME# disabled
[    0.468095] pci 0000:00:06.0: PCI bridge to [bus 03-03]
[    0.468312] pci 0000:00:06.0:   bridge window [mem 0xf0100000-0xf01fffff]
[    0.468384] pci 0000:00:14.4: PCI bridge to [bus 04-04] (subtractive decode)
[    0.468515] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.468518] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.468520] pci 0000:00:14.4:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.468522] pci 0000:00:14.4:   bridge window [mem
0x000c0000-0x000c3fff] (subtractive decode)
[    0.468525] pci 0000:00:14.4:   bridge window [mem
0x000c4000-0x000c7fff] (subtractive decode)
[    0.468527] pci 0000:00:14.4:   bridge window [mem
0x000c8000-0x000cbfff] (subtractive decode)
[    0.468529] pci 0000:00:14.4:   bridge window [mem
0x000d0000-0x000d3fff] (subtractive decode)
[    0.468531] pci 0000:00:14.4:   bridge window [mem
0x000d4000-0x000d7fff] (subtractive decode)
[    0.468534] pci 0000:00:14.4:   bridge window [mem
0x000d8000-0x000dbfff] (subtractive decode)
[    0.468536] pci 0000:00:14.4:   bridge window [mem
0x000dc000-0x000dffff] (subtractive decode)
[    0.468538] pci 0000:00:14.4:   bridge window [mem
0x000e0000-0x000e3fff] (subtractive decode)
[    0.468541] pci 0000:00:14.4:   bridge window [mem
0x000e4000-0x000e7fff] (subtractive decode)
[    0.468543] pci 0000:00:14.4:   bridge window [mem
0x000e8000-0x000ebfff] (subtractive decode)
[    0.468545] pci 0000:00:14.4:   bridge window [mem
0x000ec000-0x000effff] (subtractive decode)
[    0.468548] pci 0000:00:14.4:   bridge window [mem
0xe0000000-0xf7ffffff] (subtractive decode)
[    0.468550] pci 0000:00:14.4:   bridge window [mem
0xfc000000-0xfed3ffff] (subtractive decode)
[    0.468552] pci 0000:00:14.4:   bridge window [mem
0xfed45000-0xffffffff] (subtractive decode)
[    0.468578] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.468745] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB4_._PRT]
[    0.468775] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
[    0.468802] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
[    0.468880] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.469009]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.469351]  pci0000:00: ACPI _OSC control (0x19) granted
[    0.480509] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.480718] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.481344] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.484045] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.484619] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.485213] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.485764] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.486359] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.487107] vgaarb: device added:
PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.487107] vgaarb: loaded
[    0.488036] vgaarb: bridge control possible 0000:00:01.0
[    0.488301] SCSI subsystem initialized
[    0.488824] libata version 3.00 loaded.
[    0.488824] usbcore: registered new interface driver usbfs
[    0.488824] usbcore: registered new interface driver hub
[    0.488824] usbcore: registered new device driver usb
[    0.488824] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.488824] PCI: Using ACPI for IRQ routing
[    0.493572] PCI: pci_cache_line_size set to 64 bytes
[    0.493692] reserve RAM buffer: 000000000009f800 - 000000000009ffff
[    0.493695] reserve RAM buffer: 00000000bfb3f000 - 00000000bfffffff
[    0.493697] reserve RAM buffer: 00000000bff00000 - 00000000bfffffff
[    0.493699] reserve RAM buffer: 000000019f000000 - 000000019fffffff
[    0.493870] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma
Technologies Inc.
[    0.493870] NET: Registered protocol family 8
[    0.493870] NET: Registered protocol family 20
[    0.493870] cfg80211: Calling CRDA to update world regulatory domain
[    0.493870] NetLabel: Initializing
[    0.493870] NetLabel:  domain hash size = 128
[    0.493870] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.493870] NetLabel:  unlabeled traffic allowed by default
[    0.496125] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.496345] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.498521] Switching to clocksource hpet
[    0.498841] pnp: PnP ACPI init
[    0.499019] ACPI: bus type pnp registered
[    0.499280] pnp 00:00: [bus 00-ff]
[    0.499283] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.499285] pnp 00:00: [io  0x0d00-0xffff window]
[    0.499287] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.499289] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.499290] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.499292] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.499294] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.499296] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.499298] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.499300] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.499302] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.499304] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.499306] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.499307] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.499309] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.499311] pnp 00:00: [mem 0xe0000000-0xf7ffffff window]
[    0.499313] pnp 00:00: [mem 0xfc000000-0xfed3ffff window]
[    0.499315] pnp 00:00: [mem 0xfed45000-0xffffffff window]
[    0.499317] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.499666] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08
PNP0a03 (active)
[    0.499761] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    0.499765] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    0.499767] pnp 00:01: [mem 0xf8000000-0xfbffffff]
[    0.499770] pnp 00:01: [mem 0xfed80000-0xfed80fff]
[    0.499772] pnp 00:01: [mem 0xfed40000-0xfed44fff]
[    0.500118] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.500281] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.500436] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.500583] system 00:01: [mem 0xfed80000-0xfed80fff] has been reserved
[    0.500741] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.500899] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.501101] pnp 00:02: [irq 0 disabled]
[    0.501111] pnp 00:02: [irq 8]
[    0.501113] pnp 00:02: [mem 0xfed00000-0xfed003ff]
[    0.501415] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.501528] pnp 00:03: [io  0x0000-0x000f]
[    0.501531] pnp 00:03: [io  0x0081-0x008f]
[    0.501534] pnp 00:03: [io  0x00c0-0x00df]
[    0.501536] pnp 00:03: [dma 4]
[    0.501830] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.501856] pnp 00:04: [io  0x00f0-0x00fe]
[    0.501914] pnp 00:04: [irq 13]
[    0.502110] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.502229] pnp 00:05: [io  0x0070-0x0071]
[    0.502418] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.502427] pnp 00:06: [io  0x0060]
[    0.502429] pnp 00:06: [io  0x0064]
[    0.502440] pnp 00:06: [irq 1]
[    0.502570] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.502581] pnp 00:07: [irq 12]
[    0.502675] pnp 00:07: Plug and Play ACPI device, IDs SYN1e46
SYN1e00 SYN0002 PNP0f13 (active)
[    0.502685] pnp 00:08: [io  0x0010-0x001f]
[    0.502687] pnp 00:08: [io  0x002e-0x002f]
[    0.502690] pnp 00:08: [io  0x0072-0x0073]
[    0.502692] pnp 00:08: [io  0x0080]
[    0.502694] pnp 00:08: [io  0x00b0-0x00b1]
[    0.502696] pnp 00:08: [io  0x0092]
[    0.502697] pnp 00:08: [io  0x0400-0x04cf]
[    0.502699] pnp 00:08: [io  0x04d0-0x04d1]
[    0.502701] pnp 00:08: [io  0x04d6]
[    0.502703] pnp 00:08: [io  0x0680-0x06ff]
[    0.502704] pnp 00:08: [io  0x077a]
[    0.502706] pnp 00:08: [io  0x0c00-0x0c01]
[    0.502708] pnp 00:08: [io  0x0c14]
[    0.502709] pnp 00:08: [io  0x0c50-0x0c52]
[    0.502711] pnp 00:08: [io  0x0c6c]
[    0.502713] pnp 00:08: [io  0x0c6f]
[    0.502714] pnp 00:08: [io  0x0cd0-0x0cdb]
[    0.502716] pnp 00:08: [io  0x0840-0x0847]
[    0.502838] system 00:08: [io  0x0400-0x04cf] has been reserved
[    0.502998] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.503154] system 00:08: [io  0x04d6] has been reserved
[    0.503309] system 00:08: [io  0x0680-0x06ff] has been reserved
[    0.503465] system 00:08: [io  0x077a] has been reserved
[    0.503587] system 00:08: [io  0x0c00-0x0c01] has been reserved
[    0.503741] system 00:08: [io  0x0c14] has been reserved
[    0.503894] system 00:08: [io  0x0c50-0x0c52] has been reserved
[    0.504079] system 00:08: [io  0x0c6c] has been reserved
[    0.504232] system 00:08: [io  0x0c6f] has been reserved
[    0.504377] system 00:08: [io  0x0cd0-0x0cdb] has been reserved
[    0.504521] system 00:08: [io  0x0840-0x0847] has been reserved
[    0.504633] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.504687] pnp 00:09: [mem 0x000e0000-0x000fffff]
[    0.504690] pnp 00:09: [mem 0xffe00000-0xffffffff]
[    0.504904] system 00:09: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.505050] system 00:09: [mem 0xffe00000-0xffffffff] has been reserved
[    0.505192] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.506955] pnp 00:0a: [irq 23]
[    0.507308] pnp 00:0a: Plug and Play ACPI device, IDs HPQ0004 (active)
[    0.507322] pnp: PnP ACPI: found 11 devices
[    0.507463] ACPI: ACPI bus type pnp unregistered
[    0.521069] PCI: max bus depth: 1 pci_try_num: 2
[    0.521146] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.521303] pci 0000:00:04.0:   bridge window [io  0x2000-0x2fff]
[    0.521460] pci 0000:00:04.0:   bridge window [mem
0xf0000000-0xf00fffff 64bit pref]
[    0.521640] pci 0000:00:05.0: PCI bridge to [bus 02-02]
[    0.521792] pci 0000:00:05.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.521948] pci 0000:00:06.0: PCI bridge to [bus 03-03]
[    0.522100] pci 0000:00:06.0:   bridge window [mem 0xf0100000-0xf01fffff]
[    0.522255] pci 0000:00:14.4: PCI bridge to [bus 04-04]
[    0.522437] pci 0000:00:04.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.522583] pci 0000:00:04.0: setting latency timer to 64
[    0.522592] pci 0000:00:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.522734] pci 0000:00:05.0: setting latency timer to 64
[    0.522740] pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.522882] pci 0000:00:06.0: setting latency timer to 64
[    0.522890] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.522893] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.522896] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.522899] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.522901] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.522904] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.522907] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff]
[    0.522909] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff]
[    0.522912] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff]
[    0.522914] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff]
[    0.522917] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff]
[    0.522920] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff]
[    0.522923] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff]
[    0.522925] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff]
[    0.522928] pci_bus 0000:00: resource 18 [mem 0xe0000000-0xf7ffffff]
[    0.522931] pci_bus 0000:00: resource 19 [mem 0xfc000000-0xfed3ffff]
[    0.522933] pci_bus 0000:00: resource 20 [mem 0xfed45000-0xffffffff]
[    0.522936] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.522939] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf00fffff
64bit pref]
[    0.522942] pci_bus 0000:02: resource 1 [mem 0xf0200000-0xf02fffff]
[    0.522945] pci_bus 0000:03: resource 1 [mem 0xf0100000-0xf01fffff]
[    0.522948] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.522950] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.522953] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.522955] pci_bus 0000:04: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.522958] pci_bus 0000:04: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.522961] pci_bus 0000:04: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.522963] pci_bus 0000:04: resource 10 [mem 0x000d0000-0x000d3fff]
[    0.522966] pci_bus 0000:04: resource 11 [mem 0x000d4000-0x000d7fff]
[    0.522968] pci_bus 0000:04: resource 12 [mem 0x000d8000-0x000dbfff]
[    0.522971] pci_bus 0000:04: resource 13 [mem 0x000dc000-0x000dffff]
[    0.522974] pci_bus 0000:04: resource 14 [mem 0x000e0000-0x000e3fff]
[    0.522976] pci_bus 0000:04: resource 15 [mem 0x000e4000-0x000e7fff]
[    0.522979] pci_bus 0000:04: resource 16 [mem 0x000e8000-0x000ebfff]
[    0.522982] pci_bus 0000:04: resource 17 [mem 0x000ec000-0x000effff]
[    0.522984] pci_bus 0000:04: resource 18 [mem 0xe0000000-0xf7ffffff]
[    0.522987] pci_bus 0000:04: resource 19 [mem 0xfc000000-0xfed3ffff]
[    0.522990] pci_bus 0000:04: resource 20 [mem 0xfed45000-0xffffffff]
[    0.523044] NET: Registered protocol family 2
[    0.523441] IP route cache hash table entries: 262144 (order: 9,
2097152 bytes)
[    0.525296] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    0.528295] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.528865] TCP: Hash tables configured (established 524288 bind 65536)
[    0.529068] TCP reno registered
[    0.529241] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.529462] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.529760] NET: Registered protocol family 1
[    0.530354] RPC: Registered named UNIX socket transport module.
[    0.530560] RPC: Registered udp transport module.
[    0.530666] RPC: Registered tcp transport module.
[    0.530818] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.530981] pci 0000:00:01.0: Boot video device
[    0.716316] PCI: CLS 64 bytes, default 64
[    0.716382] Trying to unpack rootfs image as initramfs...
[    0.750358] Freeing initrd memory: 1920k freed
[    0.751102] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.751304] Placing 64MB software IO TLB between ffff8800bbb3f000 -
ffff8800bfb3f000
[    0.751528] software IO TLB at phys 0xbbb3f000 - 0xbfb3f000
[    0.752036] kvm: Nested Virtualization enabled
[    0.752200] kvm: Nested Paging enabled
[    0.753053] Simple Boot Flag at 0x44 set to 0x1
[    0.755236] perf: AMD IBS detected (0x000000ff)
[    0.756440] microcode: CPU0: patch_level=0x0300000f
[    0.756643] microcode: CPU1: patch_level=0x0300000f
[    0.756828] microcode: CPU2: patch_level=0x0300000f
[    0.756996] microcode: CPU3: patch_level=0x0300000f
[    0.757234] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.757892] audit: initializing netlink socket (disabled)
[    0.758105] type=2000 audit(1328630291.752:1): initialized
[    0.795330] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.828345] VFS: Disk quotas dquot_6.5.2
[    0.828847] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.830655] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    0.830810] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.831625] fuse init (API version 7.17)
[    0.832653] NILFS version 2 loaded
[    0.833646] Btrfs loaded
[    0.833806] msgmni has been set to 10886
[    0.835033] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    0.835261] io scheduler noop registered
[    0.835413] io scheduler deadline registered
[    0.835689] io scheduler cfq registered (default)
[    0.836432] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.837014] ALI M7101 PMU not found.
[    0.837313] i2c-core: driver [adp8860_bl] using legacy suspend method
[    0.837467] i2c-core: driver [adp8860_bl] using legacy resume method
[    0.837677] i2c-core: driver [adp8870_bl] using legacy suspend method
[    0.837830] i2c-core: driver [adp8870_bl] using legacy resume method
[    1.752221] Refined TSC clocksource calibration: 1896.550 MHz.
[    1.752384] Switching to clocksource tsc
[    4.952299] ACPI: Deprecated procfs I/F for AC is loaded, please
retry with CONFIG_ACPI_PROCFS_POWER cleared
[    5.208559] ACPI: AC Adapter [AC] (off-line)
[    5.209387] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    5.209666] ACPI: Power Button [PWRB]
[    5.210428] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    5.336532] ACPI: Lid Switch [LID]
[    5.337123] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    5.337400] ACPI: Power Button [PWRF]
[    5.796772] acpi device:02: registered as cooling_device0
[    5.797283] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    5.797564] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    5.798148] ACPI: acpi_idle registered with cpuidle
[    5.816228] ACPI Warning: For \_TZ_.THRM._AL0: Return Package has
no elements (empty) (20110623/nspredef-463)
[    5.816623] ACPI: [Package] has zero elements (ffff8801979fba00)
[    5.816778] ACPI: Invalid active0 threshold
[    5.824259] thermal LNXTHERM:00: registered as thermal_zone0
[    5.827022] ACPI: Thermal Zone [THRM] (41 C)
[    5.829469] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.887346] ACPI: Deprecated procfs I/F for battery is loaded,
please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    5.887635] ACPI: Battery Slot [BAT0] (battery present)
[    6.082451] Non-volatile memory driver v1.3
[    6.094174] brd: module loaded
[    6.100533] loop: module loaded
[    6.102863] ahci 0000:00:11.0: version 3.0
[    6.102938] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    6.103249] ahci 0000:00:11.0: irq 40 for MSI/MSI-X
[    6.103322] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 2 ports 6
Gbps 0x5 impl SATA mode
[    6.103550] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led
clo pmp pio slum part sxs
[    6.106774] scsi0 : ahci
[    6.107768] scsi1 : ahci
[    6.108729] scsi2 : ahci
[    6.109748] ata1: SATA max UDMA/133 abar m2048@0xf0350000 port
0xf0350100 irq 40
[    6.109978] ata2: DUMMY
[    6.110131] ata3: SATA max UDMA/133 abar m2048@0xf0350000 port
0xf0350200 irq 40
[    6.111428] pata_atiixp 0000:00:14.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[    6.113636] scsi3 : pata_atiixp
[    6.114419] scsi4 : pata_atiixp
[    6.115748] ata4: PATA max UDMA/100 cmd 0x3128 ctl 0x3144 bmdma 0x3100 irq 17
[    6.115955] ata5: PATA max UDMA/100 cmd 0x3120 ctl 0x3140 bmdma 0x3108 irq 17
[    6.116867] tun: Universal TUN/TAP device driver, 1.6
[    6.117071] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    6.119038] 116x: driver isp116x-hcd, 03 Nov 2005
[    6.120548] usbcore: registered new interface driver libusual
[    6.121014] usbcore: registered new interface driver usbled
[    6.121486] usbcore: registered new interface driver trancevibrator
[    6.121691] trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
[    6.122412] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:PS2M]
at 0x60,0x64 irq 1,12
[    6.132291] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.132459] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.133738] mousedev: PS/2 mouse device common for all mice
[    6.136117] rtc_cmos 00:05: RTC can wake from S4
[    6.136725] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    6.136960] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    6.137617] Linux media interface: v0.10
[    6.138057] Linux video capture interface: v2.00
[    6.138760] usbcore: registered new interface driver uvcvideo
[    6.138926] USB Video Class driver (1.1.1)
[    6.140929] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19)
initialised: dm-devel@redhat.com
[    6.141881] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input4
[    6.144297] cpuidle: using governor ladder
[    6.150110] cpuidle: using governor menu
[    6.159515] usbcore: registered new interface driver usbhid
[    6.159678] usbhid: USB HID core driver
[    6.163988] usbcore: registered new interface driver snd-usb-audio
[    6.164215] ALSA device list:
[    6.164367]   No soundcards found.
[    6.164553] Netfilter messages via NETLINK v0.30.
[    6.164728] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    6.165881] ctnetlink v0.93: registering with nfnetlink.
[    6.166115] ip_set: protocol 6
[    6.166514] IPv4 over IPv4 tunneling driver
[    6.168312] ip_tables: (C) 2000-2006 Netfilter Core Team
[    6.168565] TCP cubic registered
[    6.168764] Initializing XFRM netlink socket
[    6.170780] NET: Registered protocol family 10
[    6.172352] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    6.172626] IPv6 over IPv4 tunneling driver
[    6.174608] NET: Registered protocol family 17
[    6.174826] Bridge firewalling registered
[    6.175485] lec:lane_module_init: lec.c: initialized
[    6.175689] mpoa:atm_mpoa_init: mpc.c: initialized
[    6.175843] 8021q: 802.1Q VLAN Support v1.8
[    6.178763] DCCP: Activated CCID 2 (TCP-like)
[    6.178981] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    6.181363] lib80211: common routines for IEEE802.11 drivers
[    6.181569] lib80211_crypt: registered algorithm 'NULL'
[    6.181572] Registering the dns_resolver key type
[    6.183641] PM: Checking hibernation image partition /dev/sda5
[    6.600304] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.600493] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.601278] ata3.00: ATAPI: hp BD ROM BC-5541H, 2.81, max UDMA/100
[    6.601459] ata1.00: ATA-8: TOSHIBA MK1059GSM, GL002C, max UDMA/100
[    6.601620] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    6.602611] ata1.00: configured for UDMA/100
[    6.603257] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA
MK1059GS GL00 PQ: 0 ANSI: 5
[    6.605132] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    6.605429] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    6.605582] sd 0:0:0:0: [sda] Write Protect is off
[    6.605738] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.605757] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.606203] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.621335] ata3.00: configured for UDMA/100
[    6.686097] scsi 2:0:0:0: CD-ROM            hp       BD ROM
BC-5541H  2.81 PQ: 0 ANSI: 5
[    6.705000]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    6.710038] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.721303] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
[    6.721580] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.722928] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    6.724086] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    7.068693] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.5,
id: 0x1e0b1, caps: 0xd00073/0x240000/0xa0400
[    7.124143] input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio1/input/input5
[    7.129750] PM: Hibernation image partition 8:5 present
[    7.129754] PM: Looking for hibernation image.
[    7.164067] PM: Image not found (code -22)
[    7.164071] PM: Hibernation image not present or could not be loaded.
[    7.164097] registered taskstats version 1
[    7.178331]   Magic number: 0:533:992
[    7.178598] console [netcon0] enabled
[    7.178797] netconsole: network logging started
[    7.179121] powernow-k8: Found 1 AMD A8-3530MX APU with Radeon(tm)
HD Graphics (4 cpu cores) (version 2.20.00)
[    7.179405] powernow-k8: Core Performance Boosting: on.
[    7.179640] powernow-k8:    0 : pstate 0 (1900 MHz)
[    7.179840] powernow-k8:    1 : pstate 1 (1700 MHz)
[    7.179994] powernow-k8:    2 : pstate 2 (1600 MHz)
[    7.180157] powernow-k8:    3 : pstate 3 (1400 MHz)
[    7.180310] powernow-k8:    4 : pstate 4 (1200 MHz)
[    7.180464] powernow-k8:    5 : pstate 5 (1000 MHz)
[    7.180618] powernow-k8:    6 : pstate 6 (800 MHz)
[    7.184564] Freeing unused kernel memory: 632k freed
[    7.184916] Write protecting the kernel read-only data: 12288k
[    7.193692] Freeing unused kernel memory: 1668k freed
[    7.201175] Freeing unused kernel memory: 1336k freed
[   23.389308] EXT4-fs (sda3): warning: maximal mount count reached,
running e2fsck is recommended
[   23.391012] EXT4-fs (sda3): recovery complete
[   23.391450] EXT4-fs (sda3): mounted filesystem with ordered data
mode. Opts: (null)
[   23.392123] exe used greatest stack depth: 4664 bytes left
[   48.309298] device label BtrfsLinux devid 1 transid 332442 /dev/sda6
[   48.310593] btrfs: disk space caching is enabled
[   55.504700] btrfs: corrupt leaf, bad key order:
block=653297209344,root=1, slot=7
[   55.534711] btrfs: corrupt leaf, bad key order:
block=653297209344,root=1, slot=7
[   55.535157] ------------[ cut here ]------------
[   55.535380] kernel BUG at fs/btrfs/extent-tree.c:5797!
[   55.535548] invalid opcode: 0000 [#1] SMP
[   55.535786] CPU 1
[   55.535829] Modules linked in:
[   55.536182]
[   55.536345] Pid: 1183, comm: exe Not tainted 3.2.0 #7
Hewlett-Packard HP Pavilion dv6 Notebook PC/358B
[   55.536749] RIP: 0010:[<ffffffff81262d85>]  [<ffffffff81262d85>]
run_clustered_refs+0x371/0x678
[   55.537042] RSP: 0018:ffff880195daf8c8  EFLAGS: 00010282
[   55.537209] RAX: 00000000fffffffb RBX: ffff880195d29960 RCX: 0000000000001000
[   55.537379] RDX: 000000981b8c5000 RSI: 0000000000000000 RDI: 0000000000000000
[   55.537547] RBP: ffff880195daf9a8 R08: ffff880195dae000 R09: 0000000000000000
[   55.537704] R10: 0000000000000001 R11: ffff880195daf963 R12: ffff88019580d880
[   55.537861] R13: ffff8801974be480 R14: ffff8801967f5000 R15: ffff880198586000
[   55.538020] FS:  00007f07a2c8f700(0000) GS:ffff88019ec80000(0000)
knlGS:0000000000000000
[   55.538241] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   55.538396] CR2: 000000000132f040 CR3: 0000000195d61000 CR4: 00000000000006e0
[   55.538554] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   55.538711] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   55.538870] Process exe (pid: 1183, threadinfo ffff880195dae000,
task ffff880197597700)
[   55.539090] Stack:
[   55.539121]  0000000000000000 0000000000000000 ffff880100000001
0000000000000000
[   55.539121]  ffff8801986b1000 ffff8801964b1000 ffff8801986a80b8
ffff880195daf9d8
[   55.539121]  0000000000000000 0000000000000b9f ffff8801986a80c0
0000000000000002
[   55.539121] Call Trace:
[   55.539121]  [<ffffffff81263158>] btrfs_run_delayed_refs+0xcc/0x183
[   55.539121]  [<ffffffff8127059e>] btrfs_commit_transaction+0x8d/0x735
[   55.539121]  [<ffffffff8105894c>] ? __wake_up+0x3f/0x48
[   55.539121]  [<ffffffff81081e39>] ? add_wait_queue+0x44/0x44
[   55.539121]  [<ffffffff81111a16>] ? kmem_cache_free+0x6c/0xa8
[   55.539121]  [<ffffffff812994f3>] btrfs_recover_log_trees+0x23a/0x293
[   55.539121]  [<ffffffff81298197>] ? replay_one_dir_item+0xb8/0xb8
[   55.539121]  [<ffffffff8126f165>] open_ctree+0x1178/0x14bb
[   55.539121]  [<ffffffff812fe456>] ? string.isra.2+0x3d/0xa4
[   55.539121]  [<ffffffff8104ce49>] ? default_spin_lock_flags+0x9/0x10
[   55.539121]  [<ffffffff81255649>] btrfs_mount+0x393/0x505
[   55.539121]  [<ffffffff810f0a12>] ? pcpu_next_pop+0x38/0x45
[   55.539121]  [<ffffffff8111deeb>] mount_fs+0x64/0x14d
[   55.539121]  [<ffffffff810f1ab4>] ? __alloc_percpu+0xb/0xd
[   55.539121]  [<ffffffff81131dea>] vfs_kern_mount+0x5e/0x98
[   55.539121]  [<ffffffff8113221d>] do_kern_mount+0x48/0xda
[   55.539121]  [<ffffffff81133952>] do_mount+0x651/0x6b4
[   55.539121]  [<ffffffff810ed954>] ? memdup_user+0x3d/0x65
[   55.539121]  [<ffffffff810ed9b2>] ? strndup_user+0x36/0x4c
[   55.539121]  [<ffffffff81133c6c>] sys_mount+0x83/0xbd
[   55.539121]  [<ffffffff81656592>] system_call_fastpath+0x16/0x1b
[   55.539121] Code: 00 08 4c 8d 45 cc 48 8d 4d bb 48 8b 72 20 48 8b
7d a0 41 b9 01 00 00 00 48 89 c2 c7 45 cc 33 00 00 00 e8 e4 85 ff ff
85 c0 74 02 <0f> 0b 49 8b 17 41 8b 77 40 48 89 d7 48 89 55 a8 e8 12 9c
ff ff
[   55.539121] RIP  [<ffffffff81262d85>] run_clustered_refs+0x371/0x678
[   55.539121]  RSP <ffff880195daf8c8>
[   55.549612] ---[ end trace 1191ec4991027c15 ]---
[   55.550078] exe used greatest stack depth: 3448 bytes left
[   85.405501] btrfs: corrupt leaf, bad key order:
block=653311889408,root=1, slot=31
[   85.419312] btrfs: corrupt leaf, bad key order:
block=653311889408,root=1, slot=31
[   85.419743] ------------[ cut here ]------------
[   85.419973] WARNING: at fs/btrfs/extent-tree.c:4771
__btrfs_free_extent+0x268/0x55a()
[   85.420238] Hardware name: HP Pavilion dv6 Notebook PC
[   85.420402] Modules linked in:
[   85.420604] Pid: 1199, comm: btrfs-transacti Tainted: G      D      3.2.0 #7
[   85.420772] Call Trace:
[   85.420941]  [<ffffffff81067fcf>] warn_slowpath_common+0x7e/0x96
[   85.421111]  [<ffffffff81067ffc>] warn_slowpath_null+0x15/0x17
[   85.421281]  [<ffffffff8125fc24>] __btrfs_free_extent+0x268/0x55a
[   85.421441]  [<ffffffff8125c11e>] ? spin_unlock+0x9/0xd
[   85.421594]  [<ffffffff8125c69e>] ? block_group_cache_tree_search+0x96/0xa2
[   85.421753]  [<ffffffff8110fd13>] ? virt_to_head_page+0x9/0x2c
[   85.421908]  [<ffffffff81111b06>] ? kfree+0x50/0xc6
[   85.422064]  [<ffffffff81263042>] run_clustered_refs+0x62e/0x678
[   85.422222]  [<ffffffff8129f78f>] ? btrfs_find_ref_cluster+0xf6/0x137
[   85.422380]  [<ffffffff81263158>] btrfs_run_delayed_refs+0xcc/0x183
[   85.422539]  [<ffffffff81650498>] ? _raw_spin_unlock_irqrestore+0x15/0x18
[   85.422696]  [<ffffffff812705c1>] btrfs_commit_transaction+0xb0/0x735
[   85.422852]  [<ffffffff8126f4ba>] ? spin_unlock+0x9/0xd
[   85.423007]  [<ffffffff81270025>] ? join_transaction.isra.24+0x1f9/0x20a
[   85.423165]  [<ffffffff81081e39>] ? add_wait_queue+0x44/0x44
[   85.423320]  [<ffffffff812710a0>] ? start_transaction+0x1f9/0x251
[   85.423476]  [<ffffffff81057a73>] ? should_resched+0x9/0x28
[   85.423633]  [<ffffffff8126a95c>] transaction_kthread+0x174/0x22b
[   85.423792]  [<ffffffff81650498>] ? _raw_spin_unlock_irqrestore+0x15/0x18
[   85.423951]  [<ffffffff8126a7e8>] ? btrfs_congested_fn+0x81/0x81
[   85.424121]  [<ffffffff81081766>] kthread+0x7f/0x87
[   85.424280]  [<ffffffff81657af4>] kernel_thread_helper+0x4/0x10
[   85.424438]  [<ffffffff810816e7>] ? kthread_worker_fn+0x141/0x141
[   85.424597]  [<ffffffff81657af0>] ? gs_change+0x13/0x13
[   85.424751] ---[ end trace 1191ec4991027c16 ]---
[   85.424907] btrfs unable to find ref byte nr 653310922752 parent 0
root 2  owner 0 offset 0
[   85.425134] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[   85.425425] IP: [<ffffffff8128a392>] map_private_extent_buffer+0x14/0xe4
[   85.425621] PGD 0
[   85.425804] Oops: 0000 [#2] SMP
[   85.426023] CPU 0
[   85.426063] Modules linked in:
[   85.426387]
[   85.426538] Pid: 1199, comm: btrfs-transacti Tainted: G      D W
3.2.0 #7 Hewlett-Packard HP Pavilion dv6 Notebook PC/358B
[   85.426913] RIP: 0010:[<ffffffff8128a392>]  [<ffffffff8128a392>]
map_private_extent_buffer+0x14/0xe4
[   85.427175] RSP: 0018:ffff88019585daf0  EFLAGS: 00010286
[   85.427330] RAX: 0000000000000000 RBX: ffff88019585db20 RCX: ffff88019585db20
[   85.427486] RDX: 0000000000000004 RSI: 000000000000007a RDI: 0000000000000000
[   85.427643] RBP: ffff88019585db10 R08: ffff88019585db28 R09: ffff88019585db30
[   85.427800] R10: 000000000000007a R11: 0000000000000004 R12: 0000000000000065
[   85.427957] R13: 000000000000007a R14: 0000000000000000 R15: 0000000000000000
[   85.428115] FS:  00007fa201579700(0000) GS:ffff88019ec00000(0000)
knlGS:0000000000000000
[   85.428115] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   85.428115] CR2: 0000000000000000 CR3: 0000000001c05000 CR4: 00000000000006f0
[   85.428115] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   85.428115] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   85.428115] Process btrfs-transacti (pid: 1199, threadinfo
ffff88019585c000, task ffff8801964960b0)
[   85.428115] Stack:
[   85.428115]  00000000fffffffb 000000981c5d9000 0000000000000000
0000000000000065
[   85.428115]  ffff88019585db60 ffffffff8128220b ffff88019585db60
ffffffff00000030
[   85.428115]  ffff88019585db80 ffff88019585db40 00000000fffffffb
ffff8801984171b0
[   85.428115] Call Trace:
[   85.428115]  [<ffffffff8128220b>] btrfs_item_size+0x30/0x65
[   85.428115]  [<ffffffff8125cc9c>] btrfs_item_size_nr+0x14/0x16
[   85.428115]  [<ffffffff8125fc5b>] __btrfs_free_extent+0x29f/0x55a
[   85.428115]  [<ffffffff8125c11e>] ? spin_unlock+0x9/0xd
[   85.428115]  [<ffffffff8125c69e>] ? block_group_cache_tree_search+0x96/0xa2
[   85.428115]  [<ffffffff81111b06>] ? kfree+0x50/0xc6
[   85.428115]  [<ffffffff81263042>] run_clustered_refs+0x62e/0x678
[   85.428115]  [<ffffffff8129f78f>] ? btrfs_find_ref_cluster+0xf6/0x137
[   85.428115]  [<ffffffff81263158>] btrfs_run_delayed_refs+0xcc/0x183
[   85.428115]  [<ffffffff81650498>] ? _raw_spin_unlock_irqrestore+0x15/0x18
[   85.428115]  [<ffffffff812705c1>] btrfs_commit_transaction+0xb0/0x735
[   85.428115]  [<ffffffff8126f4ba>] ? spin_unlock+0x9/0xd
[   85.428115]  [<ffffffff81270025>] ? join_transaction.isra.24+0x1f9/0x20a
[   85.428115]  [<ffffffff81081e39>] ? add_wait_queue+0x44/0x44
[   85.428115]  [<ffffffff812710a0>] ? start_transaction+0x1f9/0x251
[   85.428115]  [<ffffffff81057a73>] ? should_resched+0x9/0x28
[   85.428115]  [<ffffffff8126a95c>] transaction_kthread+0x174/0x22b
[   85.428115]  [<ffffffff81650498>] ? _raw_spin_unlock_irqrestore+0x15/0x18
[   85.428115]  [<ffffffff8126a7e8>] ? btrfs_congested_fn+0x81/0x81
[   85.428115]  [<ffffffff81081766>] kthread+0x7f/0x87
[   85.428115]  [<ffffffff81657af4>] kernel_thread_helper+0x4/0x10
[   85.428115]  [<ffffffff810816e7>] ? kthread_worker_fn+0x141/0x141
[   85.428115]  [<ffffffff81657af0>] ? gs_change+0x13/0x13
[   85.428115] Code: ff ff 48 81 c4 88 00 00 00 44 89 e8 5b 41 5c 41
5d 41 5e 41 5f 5d c3 55 49 89 d3 49 89 f2 48 89 e5 41 54 53 48 89 cb
48 83 ec 10 <4c> 8b 27 41 81 e4 ff 0f 00 00 4a 8d 04 26 48 8d 54 10 ff
48 89
[   85.428115] RIP  [<ffffffff8128a392>] map_private_extent_buffer+0x14/0xe4
[   85.428115]  RSP <ffff88019585daf0>
[   85.428115] CR2: 0000000000000000
[   85.437509] ---[ end trace 1191ec4991027c17 ]---
