From: Chester <somethingsome2000@gmail.com>
Subject: Re: btrfs unmountable after failed suspend
Date: Tue, 7 Feb 2012 18:10:15 -0600
Message-ID: <CAAE6i0hXA7rzZ=VCnezfyHQFn=+UcfrmUsfR-GQZcgvxFW+qJQ@mail.gmail.com>
References: <CAAE6i0g4VVpy7FduBHCY33Nt_iSOh39-9i2KWqA0fXETQUKLPA@mail.gmail.com>
 <CAAE6i0jEaXmgmnmyUOrOr+5RyvPce25QZFALan+JBQ80K=UwNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0jEaXmgmnmyUOrOr+5RyvPce25QZFALan+JBQ80K=UwNQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is dmesg mounted with -o ro,recovery

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
[    0.000000] Detected 1896.490 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3792.98 BogoMIPS (lpj=7585960)
[    0.004289] pid_max: default: 32768 minimum: 301
[    0.004455] Security Framework initialized
[    0.004598] SELinux:  Disabled at boot.
[    0.005665] Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.010046] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.011451] Mount-cache hash table entries: 256
[    0.011799] Initializing cgroup subsys cpuacct
[    0.012009] Initializing cgroup subsys devices
[    0.012164] Initializing cgroup subsys freezer
[    0.012301] tseg: 00bff00000
[    0.012303] CPU: Physical Processor ID: 0
[    0.012456] CPU: Processor Core ID: 0
[    0.012611] mce: CPU supports 6 MCE banks
[    0.013650] ACPI: Core revision 20110623
[    0.024474] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.065886] CPU0: AMD A8-3530MX APU with Radeon(tm) HD Graphics stepping 00
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
[    0.160084]  #2
[    0.160144] smpboot cpu 2: start_ip = 9a000
[    0.252089]  #3 Ok.
[    0.252242] smpboot cpu 3: start_ip = 9a000
[    0.344026] Brought up 4 CPUs
[    0.344167] Total of 4 processors activated (15172.33 BogoMIPS).
[    0.345580] devtmpfs: initialized
[    0.345580] PM: Registering ACPI NVS region at bfbbf000 (3145728 bytes)
[    0.345580] kworker/u:0 used greatest stack depth: 6536 bytes left
[    0.345580] RTC time: 17:25:39, date: 02/07/12
[    0.345580] NET: Registered protocol family 16
[    0.345580] kworker/u:0 used greatest stack depth: 5600 bytes left
[    0.348159] Extended Config Space enabled on 0 nodes
[    0.348355] ACPI: bus type pci registered
[    0.348599] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.348599] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.357711] PCI: Using configuration type 1 for base access
[    0.372206] bio: create slab <bio-0> at 0
[    0.372420] ACPI: Added _OSI(Module Device)
[    0.372420] ACPI: Added _OSI(Processor Device)
[    0.372420] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.376029] ACPI: Added _OSI(Processor Aggregator Device)
[    0.378166] ACPI: EC: Look up EC in DSDT
[    0.380450] ACPI: Executed 1 blocks of module-level executable AML code
[    0.386414] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.400191] ACPI: Interpreter enabled
[    0.400397] ACPI: (supports S0 S3 S4 S5)
[    0.404204] ACPI: Using IOAPIC for interrupt routing
[    0.426592] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.428288] ACPI: No dock devices found.
[    0.428489] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.428899] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.429148] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.429148] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.429148] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    0.429148] pci_root PNP0A08:00: host bridge window [mem
0x000c0000-0x000c3fff]
[    0.432033] pci_root PNP0A08:00: host bridge window [mem
0x000c4000-0x000c7fff]
[    0.432234] pci_root PNP0A08:00: host bridge window [mem
0x000c8000-0x000cbfff]
[    0.432387] pci_root PNP0A08:00: host bridge window [mem
0x000cc000-0x000cffff]
[    0.432585] pci_root PNP0A08:00: host bridge window [mem
0x000d0000-0x000d3fff]
[    0.432783] pci_root PNP0A08:00: host bridge window [mem
0x000d4000-0x000d7fff]
[    0.432981] pci_root PNP0A08:00: host bridge window [mem
0x000d8000-0x000dbfff]
[    0.433181] pci_root PNP0A08:00: host bridge window [mem
0x000dc000-0x000dffff]
[    0.433338] pci_root PNP0A08:00: host bridge window [mem
0x000e0000-0x000e3fff]
[    0.433540] pci_root PNP0A08:00: host bridge window [mem
0x000e4000-0x000e7fff]
[    0.433742] pci_root PNP0A08:00: host bridge window [mem
0x000e8000-0x000ebfff]
[    0.433940] pci_root PNP0A08:00: host bridge window [mem
0x000ec000-0x000effff]
[    0.434138] pci_root PNP0A08:00: host bridge window [mem
0xe0000000-0xf7ffffff]
[    0.434298] pci_root PNP0A08:00: host bridge window [mem
0xfc000000-0xfed3ffff]
[    0.434495] pci_root PNP0A08:00: host bridge window [mem
0xfed45000-0xffffffff]
[    0.434699] pci_root PNP0A08:00: ignoring host bridge window [mem
0x000cc000-0x000cffff] (conflicts with Video ROM [mem
0x000c0000-0x000cf1ff])
[    0.434918] pci 0000:00:00.0: [1022:1705] type 0 class 0x000600
[    0.434959] pci 0000:00:01.0: [1002:9641] type 0 class 0x000300
[    0.434969] pci 0000:00:01.0: reg 10: [mem 0xe0000000-0xefffffff pref]
[    0.434976] pci 0000:00:01.0: reg 14: [io  0x3000-0x30ff]
[    0.434983] pci 0000:00:01.0: reg 18: [mem 0xf0300000-0xf033ffff]
[    0.435018] pci 0000:00:01.0: supports D1 D2
[    0.435036] pci 0000:00:01.1: [1002:1714] type 0 class 0x000403
[    0.435045] pci 0000:00:01.1: reg 10: [mem 0xf0344000-0xf0347fff]
[    0.435087] pci 0000:00:01.1: supports D1 D2
[    0.435157] pci 0000:00:04.0: [1022:1709] type 1 class 0x000604
[    0.435198] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.435203] pci 0000:00:04.0: PME# disabled
[    0.435222] pci 0000:00:05.0: [1022:170a] type 1 class 0x000604
[    0.436060] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.436063] pci 0000:00:05.0: PME# disabled
[    0.436080] pci 0000:00:06.0: [1022:170b] type 1 class 0x000604
[    0.436116] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.436119] pci 0000:00:06.0: PME# disabled
[    0.436168] pci 0000:00:10.0: [1022:7812] type 0 class 0x000c03
[    0.436193] pci 0000:00:10.0: reg 10: [mem 0xf0348000-0xf0349fff 64bit]
[    0.436299] pci 0000:00:10.0: PME# supported from D0 D3hot D3cold
[    0.436304] pci 0000:00:10.0: PME# disabled
[    0.436357] pci 0000:00:10.1: [1022:7812] type 0 class 0x000c03
[    0.436381] pci 0000:00:10.1: reg 10: [mem 0xf034a000-0xf034bfff 64bit]
[    0.436492] pci 0000:00:10.1: PME# supported from D0 D3hot D3cold
[    0.436497] pci 0000:00:10.1: PME# disabled
[    0.436541] pci 0000:00:11.0: [1022:7804] type 0 class 0x000106
[    0.436560] pci 0000:00:11.0: reg 10: [io  0x3138-0x313f]
[    0.436570] pci 0000:00:11.0: reg 14: [io  0x314c-0x314f]
[    0.436580] pci 0000:00:11.0: reg 18: [io  0x3130-0x3137]
[    0.436590] pci 0000:00:11.0: reg 1c: [io  0x3148-0x314b]
[    0.436599] pci 0000:00:11.0: reg 20: [io  0x3110-0x311f]
[    0.436609] pci 0000:00:11.0: reg 24: [mem 0xf0350000-0xf03507ff]
[    0.436656] pci 0000:00:12.0: [1022:7807] type 0 class 0x000c03
[    0.436669] pci 0000:00:12.0: reg 10: [mem 0xf034f000-0xf034ffff]
[    0.436743] pci 0000:00:12.2: [1022:7808] type 0 class 0x000c03
[    0.437425] pci 0000:00:12.2: reg 10: [mem 0xf034e000-0xf034e0ff]
[    0.441324] pci 0000:00:12.2: supports D1 D2
[    0.441329] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.441335] pci 0000:00:12.2: PME# disabled
[    0.441364] pci 0000:00:13.0: [1022:7807] type 0 class 0x000c03
[    0.441380] pci 0000:00:13.0: reg 10: [mem 0xf034d000-0xf034dfff]
[    0.441460] pci 0000:00:13.2: [1022:7808] type 0 class 0x000c03
[    0.442120] pci 0000:00:13.2: reg 10: [mem 0xf034c000-0xf034c0ff]
[    0.446036] pci 0000:00:13.2: supports D1 D2
[    0.446040] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.446052] pci 0000:00:13.2: PME# disabled
[    0.446080] pci 0000:00:14.0: [1022:780b] type 0 class 0x000c05
[    0.446163] pci 0000:00:14.1: [1022:780c] type 0 class 0x000101
[    0.446180] pci 0000:00:14.1: reg 10: [io  0x3128-0x312f]
[    0.446191] pci 0000:00:14.1: reg 14: [io  0x3144-0x3147]
[    0.446202] pci 0000:00:14.1: reg 18: [io  0x3120-0x3127]
[    0.446214] pci 0000:00:14.1: reg 1c: [io  0x3140-0x3143]
[    0.446225] pci 0000:00:14.1: reg 20: [io  0x3100-0x310f]
[    0.446267] pci 0000:00:14.2: [1022:780d] type 0 class 0x000403
[    0.446292] pci 0000:00:14.2: reg 10: [mem 0xf0340000-0xf0343fff 64bit]
[    0.446358] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.446363] pci 0000:00:14.2: PME# disabled
[    0.446388] pci 0000:00:14.3: [1022:780e] type 0 class 0x000601
[    0.446473] pci 0000:00:14.4: [1022:780f] type 1 class 0x000604
[    0.446527] pci 0000:00:18.0: [1022:1700] type 0 class 0x000600
[    0.446563] pci 0000:00:18.1: [1022:1701] type 0 class 0x000600
[    0.446594] pci 0000:00:18.2: [1022:1702] type 0 class 0x000600
[    0.446628] pci 0000:00:18.3: [1022:1703] type 0 class 0x000600
[    0.446667] pci 0000:00:18.4: [1022:1704] type 0 class 0x000600
[    0.446699] pci 0000:00:18.5: [1022:1718] type 0 class 0x000600
[    0.446732] pci 0000:00:18.6: [1022:1716] type 0 class 0x000600
[    0.446760] pci 0000:00:18.7: [1022:1719] type 0 class 0x000600
[    0.446894] pci 0000:01:00.0: [10ec:8168] type 0 class 0x000200
[    0.446908] pci 0000:01:00.0: reg 10: [io  0x2000-0x20ff]
[    0.446933] pci 0000:01:00.0: reg 18: [mem 0xf0004000-0xf0004fff 64bit pref]
[    0.446949] pci 0000:01:00.0: reg 20: [mem 0xf0000000-0xf0003fff 64bit pref]
[    0.446993] pci 0000:01:00.0: supports D1 D2
[    0.446995] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.446999] pci 0000:01:00.0: PME# disabled
[    0.452094] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.452269] pci 0000:00:04.0:   bridge window [io  0x2000-0x2fff]
[    0.452276] pci 0000:00:04.0:   bridge window [mem
0xf0000000-0xf00fffff 64bit pref]
[    0.452355] pci 0000:02:00.0: [14e4:4727] type 0 class 0x000280
[    0.452378] pci 0000:02:00.0: reg 10: [mem 0xf0200000-0xf0203fff 64bit]
[    0.452466] pci 0000:02:00.0: supports D1 D2
[    0.460105] pci 0000:00:05.0: PCI bridge to [bus 02-02]
[    0.460277] pci 0000:00:05.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.460342] pci 0000:03:00.0: [10ec:5209] type 0 class 0x00ff00
[    0.460360] pci 0000:03:00.0: reg 10: [mem 0xf0100000-0xf0100fff]
[    0.460451] pci 0000:03:00.0: supports D1 D2
[    0.460453] pci 0000:03:00.0: PME# supported from D1 D2 D3hot
[    0.460459] pci 0000:03:00.0: PME# disabled
[    0.468096] pci 0000:00:06.0: PCI bridge to [bus 03-03]
[    0.468271] pci 0000:00:06.0:   bridge window [mem 0xf0100000-0xf01fffff]
[    0.468344] pci 0000:00:14.4: PCI bridge to [bus 04-04] (subtractive decode)
[    0.468506] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.468509] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.468511] pci 0000:00:14.4:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.468513] pci 0000:00:14.4:   bridge window [mem
0x000c0000-0x000c3fff] (subtractive decode)
[    0.468516] pci 0000:00:14.4:   bridge window [mem
0x000c4000-0x000c7fff] (subtractive decode)
[    0.468518] pci 0000:00:14.4:   bridge window [mem
0x000c8000-0x000cbfff] (subtractive decode)
[    0.468520] pci 0000:00:14.4:   bridge window [mem
0x000d0000-0x000d3fff] (subtractive decode)
[    0.468522] pci 0000:00:14.4:   bridge window [mem
0x000d4000-0x000d7fff] (subtractive decode)
[    0.468525] pci 0000:00:14.4:   bridge window [mem
0x000d8000-0x000dbfff] (subtractive decode)
[    0.468527] pci 0000:00:14.4:   bridge window [mem
0x000dc000-0x000dffff] (subtractive decode)
[    0.468529] pci 0000:00:14.4:   bridge window [mem
0x000e0000-0x000e3fff] (subtractive decode)
[    0.468531] pci 0000:00:14.4:   bridge window [mem
0x000e4000-0x000e7fff] (subtractive decode)
[    0.468534] pci 0000:00:14.4:   bridge window [mem
0x000e8000-0x000ebfff] (subtractive decode)
[    0.468536] pci 0000:00:14.4:   bridge window [mem
0x000ec000-0x000effff] (subtractive decode)
[    0.468538] pci 0000:00:14.4:   bridge window [mem
0xe0000000-0xf7ffffff] (subtractive decode)
[    0.468541] pci 0000:00:14.4:   bridge window [mem
0xfc000000-0xfed3ffff] (subtractive decode)
[    0.468543] pci 0000:00:14.4:   bridge window [mem
0xfed45000-0xffffffff] (subtractive decode)
[    0.468616] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.468785] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB4_._PRT]
[    0.468815] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
[    0.468842] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
[    0.468920] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.469049]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.469345]  pci0000:00: ACPI _OSC control (0x19) granted
[    0.480456] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.480720] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.481326] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.481913] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.484072] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.484636] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.485181] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.485733] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    0.486494] vgaarb: device added:
PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.486494] vgaarb: loaded
[    0.486494] vgaarb: bridge control possible 0000:00:01.0
[    0.486494] SCSI subsystem initialized
[    0.488248] libata version 3.00 loaded.
[    0.488248] usbcore: registered new interface driver usbfs
[    0.488294] usbcore: registered new interface driver hub
[    0.488332] usbcore: registered new device driver usb
[    0.488332] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.488332] PCI: Using ACPI for IRQ routing
[    0.492975] PCI: pci_cache_line_size set to 64 bytes
[    0.493094] reserve RAM buffer: 000000000009f800 - 000000000009ffff
[    0.493097] reserve RAM buffer: 00000000bfb3f000 - 00000000bfffffff
[    0.493099] reserve RAM buffer: 00000000bff00000 - 00000000bfffffff
[    0.493101] reserve RAM buffer: 000000019f000000 - 000000019fffffff
[    0.493318] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma
Technologies Inc.
[    0.493318] NET: Registered protocol family 8
[    0.493318] NET: Registered protocol family 20
[    0.493318] cfg80211: Calling CRDA to update world regulatory domain
[    0.493318] NetLabel: Initializing
[    0.493318] NetLabel:  domain hash size = 128
[    0.493318] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.493318] NetLabel:  unlabeled traffic allowed by default
[    0.493318] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.496037] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.498217] Switching to clocksource hpet
[    0.498820] pnp: PnP ACPI init
[    0.498998] ACPI: bus type pnp registered
[    0.499258] pnp 00:00: [bus 00-ff]
[    0.499261] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.499263] pnp 00:00: [io  0x0d00-0xffff window]
[    0.499265] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.499267] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.499269] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.499271] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.499273] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.499275] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.499277] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.499278] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.499280] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.499282] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.499284] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.499286] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.499288] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.499290] pnp 00:00: [mem 0xe0000000-0xf7ffffff window]
[    0.499292] pnp 00:00: [mem 0xfc000000-0xfed3ffff window]
[    0.499294] pnp 00:00: [mem 0xfed45000-0xffffffff window]
[    0.499296] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.499657] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08
PNP0a03 (active)
[    0.499737] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    0.499740] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    0.499742] pnp 00:01: [mem 0xf8000000-0xfbffffff]
[    0.499743] pnp 00:01: [mem 0xfed80000-0xfed80fff]
[    0.499745] pnp 00:01: [mem 0xfed40000-0xfed44fff]
[    0.500067] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.500228] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.500382] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.500536] system 00:01: [mem 0xfed80000-0xfed80fff] has been reserved
[    0.500691] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.500849] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.501109] pnp 00:02: [irq 0 disabled]
[    0.501120] pnp 00:02: [irq 8]
[    0.501124] pnp 00:02: [mem 0xfed00000-0xfed003ff]
[    0.501333] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.501446] pnp 00:03: [io  0x0000-0x000f]
[    0.501449] pnp 00:03: [io  0x0081-0x008f]
[    0.501451] pnp 00:03: [io  0x00c0-0x00df]
[    0.501454] pnp 00:03: [dma 4]
[    0.501662] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.501690] pnp 00:04: [io  0x00f0-0x00fe]
[    0.501727] pnp 00:04: [irq 13]
[    0.501914] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.502030] pnp 00:05: [io  0x0070-0x0071]
[    0.502198] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.502207] pnp 00:06: [io  0x0060]
[    0.502209] pnp 00:06: [io  0x0064]
[    0.502220] pnp 00:06: [irq 1]
[    0.502308] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.502319] pnp 00:07: [irq 12]
[    0.502456] pnp 00:07: Plug and Play ACPI device, IDs SYN1e46
SYN1e00 SYN0002 PNP0f13 (active)
[    0.502483] pnp 00:08: [io  0x0010-0x001f]
[    0.502485] pnp 00:08: [io  0x002e-0x002f]
[    0.502493] pnp 00:08: [io  0x0072-0x0073]
[    0.502495] pnp 00:08: [io  0x0080]
[    0.502496] pnp 00:08: [io  0x00b0-0x00b1]
[    0.502498] pnp 00:08: [io  0x0092]
[    0.502500] pnp 00:08: [io  0x0400-0x04cf]
[    0.502501] pnp 00:08: [io  0x04d0-0x04d1]
[    0.502503] pnp 00:08: [io  0x04d6]
[    0.502504] pnp 00:08: [io  0x0680-0x06ff]
[    0.502506] pnp 00:08: [io  0x077a]
[    0.502507] pnp 00:08: [io  0x0c00-0x0c01]
[    0.502509] pnp 00:08: [io  0x0c14]
[    0.502510] pnp 00:08: [io  0x0c50-0x0c52]
[    0.502512] pnp 00:08: [io  0x0c6c]
[    0.502513] pnp 00:08: [io  0x0c6f]
[    0.502515] pnp 00:08: [io  0x0cd0-0x0cdb]
[    0.502516] pnp 00:08: [io  0x0840-0x0847]
[    0.502841] system 00:08: [io  0x0400-0x04cf] has been reserved
[    0.503000] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.503155] system 00:08: [io  0x04d6] has been reserved
[    0.503311] system 00:08: [io  0x0680-0x06ff] has been reserved
[    0.503465] system 00:08: [io  0x077a] has been reserved
[    0.503618] system 00:08: [io  0x0c00-0x0c01] has been reserved
[    0.503740] system 00:08: [io  0x0c14] has been reserved
[    0.503893] system 00:08: [io  0x0c50-0x0c52] has been reserved
[    0.504076] system 00:08: [io  0x0c6c] has been reserved
[    0.504229] system 00:08: [io  0x0c6f] has been reserved
[    0.504385] system 00:08: [io  0x0cd0-0x0cdb] has been reserved
[    0.504529] system 00:08: [io  0x0840-0x0847] has been reserved
[    0.504672] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.504745] pnp 00:09: [mem 0x000e0000-0x000fffff]
[    0.504748] pnp 00:09: [mem 0xffe00000-0xffffffff]
[    0.504900] system 00:09: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.505046] system 00:09: [mem 0xffe00000-0xffffffff] has been reserved
[    0.505189] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.507185] pnp 00:0a: [irq 23]
[    0.507531] pnp 00:0a: Plug and Play ACPI device, IDs HPQ0004 (active)
[    0.507552] pnp: PnP ACPI: found 11 devices
[    0.507692] ACPI: ACPI bus type pnp unregistered
[    0.522178] PCI: max bus depth: 1 pci_try_num: 2
[    0.522255] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.522412] pci 0000:00:04.0:   bridge window [io  0x2000-0x2fff]
[    0.522569] pci 0000:00:04.0:   bridge window [mem
0xf0000000-0xf00fffff 64bit pref]
[    0.522749] pci 0000:00:05.0: PCI bridge to [bus 02-02]
[    0.522903] pci 0000:00:05.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.523061] pci 0000:00:06.0: PCI bridge to [bus 03-03]
[    0.523218] pci 0000:00:06.0:   bridge window [mem 0xf0100000-0xf01fffff]
[    0.523377] pci 0000:00:14.4: PCI bridge to [bus 04-04]
[    0.523562] pci 0000:00:04.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.523694] pci 0000:00:04.0: setting latency timer to 64
[    0.523701] pci 0000:00:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.523840] pci 0000:00:05.0: setting latency timer to 64
[    0.523845] pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.523983] pci 0000:00:06.0: setting latency timer to 64
[    0.523990] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.523992] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.523994] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.523996] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.524016] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.524019] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.524020] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff]
[    0.524023] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff]
[    0.524024] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff]
[    0.524026] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff]
[    0.524028] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff]
[    0.524030] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff]
[    0.524032] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff]
[    0.524034] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff]
[    0.524036] pci_bus 0000:00: resource 18 [mem 0xe0000000-0xf7ffffff]
[    0.524038] pci_bus 0000:00: resource 19 [mem 0xfc000000-0xfed3ffff]
[    0.524040] pci_bus 0000:00: resource 20 [mem 0xfed45000-0xffffffff]
[    0.524043] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.524045] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf00fffff
64bit pref]
[    0.524047] pci_bus 0000:02: resource 1 [mem 0xf0200000-0xf02fffff]
[    0.524049] pci_bus 0000:03: resource 1 [mem 0xf0100000-0xf01fffff]
[    0.524051] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.524053] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.524055] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.524057] pci_bus 0000:04: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.524059] pci_bus 0000:04: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.524061] pci_bus 0000:04: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.524063] pci_bus 0000:04: resource 10 [mem 0x000d0000-0x000d3fff]
[    0.524065] pci_bus 0000:04: resource 11 [mem 0x000d4000-0x000d7fff]
[    0.524067] pci_bus 0000:04: resource 12 [mem 0x000d8000-0x000dbfff]
[    0.524069] pci_bus 0000:04: resource 13 [mem 0x000dc000-0x000dffff]
[    0.524071] pci_bus 0000:04: resource 14 [mem 0x000e0000-0x000e3fff]
[    0.524073] pci_bus 0000:04: resource 15 [mem 0x000e4000-0x000e7fff]
[    0.524075] pci_bus 0000:04: resource 16 [mem 0x000e8000-0x000ebfff]
[    0.524077] pci_bus 0000:04: resource 17 [mem 0x000ec000-0x000effff]
[    0.524079] pci_bus 0000:04: resource 18 [mem 0xe0000000-0xf7ffffff]
[    0.524081] pci_bus 0000:04: resource 19 [mem 0xfc000000-0xfed3ffff]
[    0.524083] pci_bus 0000:04: resource 20 [mem 0xfed45000-0xffffffff]
[    0.524128] NET: Registered protocol family 2
[    0.524579] IP route cache hash table entries: 262144 (order: 9,
2097152 bytes)
[    0.526381] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    0.529478] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.530059] TCP: Hash tables configured (established 524288 bind 65536)
[    0.530262] TCP reno registered
[    0.530436] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.530654] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.530905] NET: Registered protocol family 1
[    0.531503] RPC: Registered named UNIX socket transport module.
[    0.531693] RPC: Registered udp transport module.
[    0.531845] RPC: Registered tcp transport module.
[    0.531997] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.532188] pci 0000:00:01.0: Boot video device
[    1.236318] PCI: CLS 64 bytes, default 64
[    1.236386] Trying to unpack rootfs image as initramfs...
[    1.270350] Freeing initrd memory: 1920k freed
[    1.271100] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.271302] Placing 64MB software IO TLB between ffff8800bbb3f000 -
ffff8800bfb3f000
[    1.271525] software IO TLB at phys 0xbbb3f000 - 0xbfb3f000
[    1.272057] kvm: Nested Virtualization enabled
[    1.272216] kvm: Nested Paging enabled
[    1.273079] Simple Boot Flag at 0x44 set to 0x1
[    1.275201] perf: AMD IBS detected (0x000000ff)
[    1.276385] microcode: CPU0: patch_level=0x0300000f
[    1.276592] microcode: CPU1: patch_level=0x0300000f
[    1.276777] microcode: CPU2: patch_level=0x0300000f
[    1.276944] microcode: CPU3: patch_level=0x0300000f
[    1.277222] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.277849] audit: initializing netlink socket (disabled)
[    1.278058] type=2000 audit(1328635539.272:1): initialized
[    1.314886] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.348099] VFS: Disk quotas dquot_6.5.2
[    1.348602] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.350568] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    1.350727] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.351527] fuse init (API version 7.17)
[    1.352653] NILFS version 2 loaded
[    1.353444] Btrfs loaded
[    1.353599] msgmni has been set to 10886
[    1.354921] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    1.355148] io scheduler noop registered
[    1.355300] io scheduler deadline registered
[    1.355536] io scheduler cfq registered (default)
[    1.356259] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.356734] ALI M7101 PMU not found.
[    1.357028] i2c-core: driver [adp8860_bl] using legacy suspend method
[    1.357181] i2c-core: driver [adp8860_bl] using legacy resume method
[    1.357419] i2c-core: driver [adp8870_bl] using legacy suspend method
[    1.357576] i2c-core: driver [adp8870_bl] using legacy resume method
[    2.272254] Refined TSC clocksource calibration: 1896.550 MHz.
[    2.272417] Switching to clocksource tsc
[    5.452298] ACPI: Deprecated procfs I/F for AC is loaded, please
retry with CONFIG_ACPI_PROCFS_POWER cleared
[    5.708559] ACPI: AC Adapter [AC] (off-line)
[    5.709377] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    5.709657] ACPI: Power Button [PWRB]
[    5.710111] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    5.788512] ACPI: Lid Switch [LID]
[    5.789106] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    5.789383] ACPI: Power Button [PWRF]
[    6.310985] acpi device:02: registered as cooling_device0
[    6.311519] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    6.311801] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    6.312399] ACPI: acpi_idle registered with cpuidle
[    6.326507] ACPI Warning: For \_TZ_.THRM._AL0: Return Package has
no elements (empty) (20110623/nspredef-463)
[    6.326898] ACPI: [Package] has zero elements (ffff880197482a00)
[    6.327051] ACPI: Invalid active0 threshold
[    6.336834] thermal LNXTHERM:00: registered as thermal_zone0
[    6.337039] ACPI: Thermal Zone [THRM] (34 C)
[    6.339484] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    6.407384] ACPI: Deprecated procfs I/F for battery is loaded,
please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    6.410268] ACPI: Battery Slot [BAT0] (battery present)
[    6.534505] Non-volatile memory driver v1.3
[    6.546454] brd: module loaded
[    6.552952] loop: module loaded
[    6.555318] ahci 0000:00:11.0: version 3.0
[    6.555393] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    6.555690] ahci 0000:00:11.0: irq 40 for MSI/MSI-X
[    6.555758] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 2 ports 6
Gbps 0x5 impl SATA mode
[    6.555986] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led
clo pmp pio slum part sxs
[    6.559208] scsi0 : ahci
[    6.560181] scsi1 : ahci
[    6.561151] scsi2 : ahci
[    6.562172] ata1: SATA max UDMA/133 abar m2048@0xf0350000 port
0xf0350100 irq 40
[    6.562401] ata2: DUMMY
[    6.562555] ata3: SATA max UDMA/133 abar m2048@0xf0350000 port
0xf0350200 irq 40
[    6.563853] pata_atiixp 0000:00:14.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[    6.566651] scsi3 : pata_atiixp
[    6.567538] scsi4 : pata_atiixp
[    6.568940] ata4: PATA max UDMA/100 cmd 0x3128 ctl 0x3144 bmdma 0x3100 irq 17
[    6.569147] ata5: PATA max UDMA/100 cmd 0x3120 ctl 0x3140 bmdma 0x3108 irq 17
[    6.570237] tun: Universal TUN/TAP device driver, 1.6
[    6.570442] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    6.572302] 116x: driver isp116x-hcd, 03 Nov 2005
[    6.573791] usbcore: registered new interface driver libusual
[    6.574254] usbcore: registered new interface driver usbled
[    6.574721] usbcore: registered new interface driver trancevibrator
[    6.574926] trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
[    6.575635] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:PS2M]
at 0x60,0x64 irq 1,12
[    6.585425] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.585591] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.586891] mousedev: PS/2 mouse device common for all mice
[    6.589263] rtc_cmos 00:05: RTC can wake from S4
[    6.589883] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    6.590131] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    6.590796] Linux media interface: v0.10
[    6.591262] Linux video capture interface: v2.00
[    6.591983] usbcore: registered new interface driver uvcvideo
[    6.592215] USB Video Class driver (1.1.1)
[    6.594135] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19)
initialised: dm-devel@redhat.com
[    6.594860] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input4
[    6.597533] cpuidle: using governor ladder
[    6.603286] cpuidle: using governor menu
[    6.613121] usbcore: registered new interface driver usbhid
[    6.613281] usbhid: USB HID core driver
[    6.618907] usbcore: registered new interface driver snd-usb-audio
[    6.619069] ALSA device list:
[    6.619221]   No soundcards found.
[    6.619407] Netfilter messages via NETLINK v0.30.
[    6.619582] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    6.620878] ctnetlink v0.93: registering with nfnetlink.
[    6.621094] ip_set: protocol 6
[    6.621481] IPv4 over IPv4 tunneling driver
[    6.623548] ip_tables: (C) 2000-2006 Netfilter Core Team
[    6.623768] TCP cubic registered
[    6.623925] Initializing XFRM netlink socket
[    6.626638] NET: Registered protocol family 10
[    6.628186] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    6.628467] IPv6 over IPv4 tunneling driver
[    6.630543] NET: Registered protocol family 17
[    6.630804] Bridge firewalling registered
[    6.631447] lec:lane_module_init: lec.c: initialized
[    6.631653] mpoa:atm_mpoa_init: mpc.c: initialized
[    6.631772] 8021q: 802.1Q VLAN Support v1.8
[    6.634555] DCCP: Activated CCID 2 (TCP-like)
[    6.634773] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    6.636719] lib80211: common routines for IEEE802.11 drivers
[    6.636925] lib80211_crypt: registered algorithm 'NULL'
[    6.636928] Registering the dns_resolver key type
[    6.638915] PM: Checking hibernation image partition /dev/sda5
[    7.052302] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.052490] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.053098] ata1.00: ATA-8: TOSHIBA MK1059GSM, GL002C, max UDMA/100
[    7.053268] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    7.053519] ata3.00: ATAPI: hp BD ROM BC-5541H, 2.81, max UDMA/100
[    7.054183] ata1.00: configured for UDMA/100
[    7.054791] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA
MK1059GS GL00 PQ: 0 ANSI: 5
[    7.054821] ata3.00: configured for UDMA/100
[    7.056551] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    7.056832] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    7.057031] sd 0:0:0:0: [sda] Write Protect is off
[    7.057188] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.057208] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    7.057661] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.076851] scsi 2:0:0:0: CD-ROM            hp       BD ROM
BC-5541H  2.81 PQ: 0 ANSI: 5
[    7.079954] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
[    7.080247] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.081683] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    7.082743] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    7.161626]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    7.167549] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.505292] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.5,
id: 0x1e0b1, caps: 0xd00073/0x240000/0xa0400
[    7.560623] input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio1/input/input5
[    7.566182] PM: Hibernation image partition 8:5 present
[    7.566186] PM: Looking for hibernation image.
[    7.598477] PM: Image not found (code -22)
[    7.598482] PM: Hibernation image not present or could not be loaded.
[    7.598506] registered taskstats version 1
[    7.612555]   Magic number: 0:677:440
[    7.612822] console [netcon0] enabled
[    7.613018] netconsole: network logging started
[    7.613296] powernow-k8: Found 1 AMD A8-3530MX APU with Radeon(tm)
HD Graphics (4 cpu cores) (version 2.20.00)
[    7.613577] powernow-k8: Core Performance Boosting: on.
[    7.613804] powernow-k8:    0 : pstate 0 (1900 MHz)
[    7.614003] powernow-k8:    1 : pstate 1 (1700 MHz)
[    7.614155] powernow-k8:    2 : pstate 2 (1600 MHz)
[    7.614308] powernow-k8:    3 : pstate 3 (1400 MHz)
[    7.614460] powernow-k8:    4 : pstate 4 (1200 MHz)
[    7.614612] powernow-k8:    5 : pstate 5 (1000 MHz)
[    7.614763] powernow-k8:    6 : pstate 6 (800 MHz)
[    7.619078] Freeing unused kernel memory: 632k freed
[    7.619424] Write protecting the kernel read-only data: 12288k
[    7.628150] Freeing unused kernel memory: 1668k freed
[    7.635616] Freeing unused kernel memory: 1336k freed
[   20.954679] EXT4-fs (sda3): warning: maximal mount count reached,
running e2fsck is recommended
[   20.956792] EXT4-fs (sda3): mounted filesystem with ordered data
mode. Opts: (null)
[   20.957392] exe used greatest stack depth: 4920 bytes left
[  145.340317] device label BtrfsLinux devid 1 transid 332442 /dev/sda6
[  145.341702] btrfs: enabling auto recovery
[  145.341803] btrfs: disk space caching is enabled
[  152.457967] btrfs: corrupt leaf, bad key order:
block=653297209344,root=1, slot=7
[  152.487933] btrfs: corrupt leaf, bad key order:
block=653297209344,root=1, slot=7
[  152.488326] ------------[ cut here ]------------
[  152.488549] kernel BUG at fs/btrfs/extent-tree.c:5797!
[  152.488717] invalid opcode: 0000 [#1] SMP
[  152.488956] CPU 1
[  152.488998] Modules linked in:
[  152.489351]
[  152.489515] Pid: 1184, comm: exe Not tainted 3.2.0 #7
Hewlett-Packard HP Pavilion dv6 Notebook PC/358B
[  152.489918] RIP: 0010:[<ffffffff81262d85>]  [<ffffffff81262d85>]
run_clustered_refs+0x371/0x678
[  152.490210] RSP: 0018:ffff880195d8d8c8  EFLAGS: 00010282
[  152.490377] RAX: 00000000fffffffb RBX: ffff880195853540 RCX: 0000000000001000
[  152.490538] RDX: 000000981b8c5000 RSI: 0000000000000000 RDI: 0000000000000000
[  152.490695] RBP: ffff880195d8d9a8 R08: ffff880195d8c000 R09: 0000000000000000
[  152.490852] R10: 0000000000000001 R11: ffff880195d8d963 R12: ffff880195fdbf80
[  152.491009] R13: ffff8801974b7e80 R14: ffff8801965c7000 R15: ffff88019858a000
[  152.491168] FS:  00007fafe4f53700(0000) GS:ffff88019ec80000(0000)
knlGS:0000000000000000
[  152.491390] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  152.491545] CR2: 00000000014d0040 CR3: 0000000195d48000 CR4: 00000000000006e0
[  152.491703] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  152.491860] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  152.492018] Process exe (pid: 1184, threadinfo ffff880195d8c000,
task ffff880196493b80)
[  152.492238] Stack:
[  152.492289]  0000000000000000 0000000000000000 ffff880100000001
0000000000000000
[  152.492289]  ffff8801986a1000 ffff880197419000 ffff8801986980b8
ffff880195d8d9d8
[  152.492289]  0000000000000000 0000000000000b9f ffff8801986980c0
0000000000000002
[  152.492289] Call Trace:
[  152.492289]  [<ffffffff81263158>] btrfs_run_delayed_refs+0xcc/0x183
[  152.492289]  [<ffffffff8127059e>] btrfs_commit_transaction+0x8d/0x735
[  152.492289]  [<ffffffff8105894c>] ? __wake_up+0x3f/0x48
[  152.492289]  [<ffffffff81081e39>] ? add_wait_queue+0x44/0x44
[  152.492289]  [<ffffffff8110fd13>] ? virt_to_head_page+0x9/0x2c
[  152.492289]  [<ffffffff811119c2>] ? kmem_cache_free+0x18/0xa8
[  152.492289]  [<ffffffff812994f3>] btrfs_recover_log_trees+0x23a/0x293
[  152.492289]  [<ffffffff81298197>] ? replay_one_dir_item+0xb8/0xb8
[  152.492289]  [<ffffffff8126f165>] open_ctree+0x1178/0x14bb
[  152.492289]  [<ffffffff812fe456>] ? string.isra.2+0x3d/0xa4
[  152.492289]  [<ffffffff8104ce49>] ? default_spin_lock_flags+0x9/0x10
[  152.492289]  [<ffffffff81255649>] btrfs_mount+0x393/0x505
[  152.492289]  [<ffffffff811097b5>] ? alloc_pages_current+0xc2/0xd2
[  152.492289]  [<ffffffff8111deeb>] mount_fs+0x64/0x14d
[  152.492289]  [<ffffffff810f1ab4>] ? __alloc_percpu+0xb/0xd
[  152.492289]  [<ffffffff81131dea>] vfs_kern_mount+0x5e/0x98
[  152.492289]  [<ffffffff8113221d>] do_kern_mount+0x48/0xda
[  152.492289]  [<ffffffff81133952>] do_mount+0x651/0x6b4
[  152.492289]  [<ffffffff8113326b>] ? copy_mount_options+0xc6/0x129
[  152.492289]  [<ffffffff81133c6c>] sys_mount+0x83/0xbd
[  152.492289]  [<ffffffff81656592>] system_call_fastpath+0x16/0x1b
[  152.492289] Code: 00 08 4c 8d 45 cc 48 8d 4d bb 48 8b 72 20 48 8b
7d a0 41 b9 01 00 00 00 48 89 c2 c7 45 cc 33 00 00 00 e8 e4 85 ff ff
85 c0 74 02 <0f> 0b 49 8b 17 41 8b 77 40 48 89 d7 48 89 55 a8 e8 12 9c
ff ff
[  152.492289] RIP  [<ffffffff81262d85>] run_clustered_refs+0x371/0x678
[  152.492289]  RSP <ffff880195d8d8c8>
[  152.502669] ---[ end trace 62f5169b4743eea9 ]---
[  152.503090] exe used greatest stack depth: 3656 bytes left
[  182.380949] btrfs: corrupt leaf, bad key order:
block=653311889408,root=1, slot=31
[  182.394750] btrfs: corrupt leaf, bad key order:
block=653311889408,root=1, slot=31
[  182.395182] ------------[ cut here ]------------
[  182.395413] WARNING: at fs/btrfs/extent-tree.c:4771
__btrfs_free_extent+0x268/0x55a()
[  182.395656] Hardware name: HP Pavilion dv6 Notebook PC
[  182.395822] Modules linked in:
[  182.396051] Pid: 1200, comm: btrfs-transacti Tainted: G      D      3.2.0 #7
[  182.396220] Call Trace:
[  182.396391]  [<ffffffff81067fcf>] warn_slowpath_common+0x7e/0x96
[  182.396563]  [<ffffffff81067ffc>] warn_slowpath_null+0x15/0x17
[  182.396734]  [<ffffffff8125fc24>] __btrfs_free_extent+0x268/0x55a
[  182.396903]  [<ffffffff8125c11e>] ? spin_unlock+0x9/0xd
[  182.397059]  [<ffffffff8125c69e>] ? block_group_cache_tree_search+0x96/0xa2
[  182.397219]  [<ffffffff8110fd13>] ? virt_to_head_page+0x9/0x2c
[  182.397377]  [<ffffffff81111b06>] ? kfree+0x50/0xc6
[  182.397535]  [<ffffffff81263042>] run_clustered_refs+0x62e/0x678
[  182.397695]  [<ffffffff8129f78f>] ? btrfs_find_ref_cluster+0xf6/0x137
[  182.397855]  [<ffffffff81263158>] btrfs_run_delayed_refs+0xcc/0x183
[  182.398015]  [<ffffffff81650498>] ? _raw_spin_unlock_irqrestore+0x15/0x18
[  182.398175]  [<ffffffff812705c1>] btrfs_commit_transaction+0xb0/0x735
[  182.398333]  [<ffffffff8126f4ba>] ? spin_unlock+0x9/0xd
[  182.398490]  [<ffffffff81270025>] ? join_transaction.isra.24+0x1f9/0x20a
[  182.398649]  [<ffffffff81081e39>] ? add_wait_queue+0x44/0x44
[  182.398806]  [<ffffffff812710a0>] ? start_transaction+0x1f9/0x251
[  182.398964]  [<ffffffff81057a73>] ? should_resched+0x9/0x28
[  182.399122]  [<ffffffff8126a95c>] transaction_kthread+0x174/0x22b
[  182.399281]  [<ffffffff81650498>] ? _raw_spin_unlock_irqrestore+0x15/0x18
[  182.399439]  [<ffffffff8126a7e8>] ? btrfs_congested_fn+0x81/0x81
[  182.399596]  [<ffffffff81081766>] kthread+0x7f/0x87
[  182.399755]  [<ffffffff81657af4>] kernel_thread_helper+0x4/0x10
[  182.399913]  [<ffffffff810816e7>] ? kthread_worker_fn+0x141/0x141
[  182.400091]  [<ffffffff81657af0>] ? gs_change+0x13/0x13
[  182.400246] ---[ end trace 62f5169b4743eeaa ]---
[  182.400401] btrfs unable to find ref byte nr 653310922752 parent 0
root 2  owner 0 offset 0
[  182.400629] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[  182.400919] IP: [<ffffffff8128a392>] map_private_extent_buffer+0x14/0xe4
[  182.401115] PGD 195d55067 PUD 195d5b067 PMD 0
[  182.401372] Oops: 0000 [#2] SMP
[  182.401592] CPU 0
[  182.401631] Modules linked in:
[  182.401955]
[  182.402106] Pid: 1200, comm: btrfs-transacti Tainted: G      D W
3.2.0 #7 Hewlett-Packard HP Pavilion dv6 Notebook PC/358B
[  182.402481] RIP: 0010:[<ffffffff8128a392>]  [<ffffffff8128a392>]
map_private_extent_buffer+0x14/0xe4
[  182.402743] RSP: 0018:ffff880195859af0  EFLAGS: 00010286
[  182.402898] RAX: 0000000000000000 RBX: ffff880195859b20 RCX: ffff880195859b20
[  182.403055] RDX: 0000000000000004 RSI: 000000000000007a RDI: 0000000000000000
[  182.403212] RBP: ffff880195859b10 R08: ffff880195859b28 R09: ffff880195859b30
[  182.403369] R10: 000000000000007a R11: 0000000000000004 R12: 0000000000000065
[  182.403526] R13: 000000000000007a R14: 0000000000000000 R15: 0000000000000000
[  182.403684] FS:  00007f22ab099700(0000) GS:ffff88019ec00000(0000)
knlGS:0000000000000000
[  182.403904] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  182.404057] CR2: 0000000000000000 CR3: 000000019792e000 CR4: 00000000000006f0
[  182.404078] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  182.404078] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  182.404078] Process btrfs-transacti (pid: 1200, threadinfo
ffff880195858000, task ffff880197bf9dc0)
[  182.404078] Stack:
[  182.404078]  00000000fffffffb 000000981c5d9000 0000000000000000
0000000000000065
[  182.404078]  ffff880195859b60 ffffffff8128220b ffff880195859b60
ffffffff00000030
[  182.404078]  ffff880195859b80 ffff880195859b40 00000000fffffffb
ffff880198418000
[  182.404078] Call Trace:
[  182.404078]  [<ffffffff8128220b>] btrfs_item_size+0x30/0x65
[  182.404078]  [<ffffffff8125cc9c>] btrfs_item_size_nr+0x14/0x16
[  182.404078]  [<ffffffff8125fc5b>] __btrfs_free_extent+0x29f/0x55a
[  182.404078]  [<ffffffff8125c11e>] ? spin_unlock+0x9/0xd
[  182.404078]  [<ffffffff8125c69e>] ? block_group_cache_tree_search+0x96/0xa2
[  182.404078]  [<ffffffff81111b06>] ? kfree+0x50/0xc6
[  182.404078]  [<ffffffff81263042>] run_clustered_refs+0x62e/0x678
[  182.404078]  [<ffffffff8129f78f>] ? btrfs_find_ref_cluster+0xf6/0x137
[  182.404078]  [<ffffffff81263158>] btrfs_run_delayed_refs+0xcc/0x183
[  182.404078]  [<ffffffff81650498>] ? _raw_spin_unlock_irqrestore+0x15/0x18
[  182.404078]  [<ffffffff812705c1>] btrfs_commit_transaction+0xb0/0x735
[  182.404078]  [<ffffffff8126f4ba>] ? spin_unlock+0x9/0xd
[  182.404078]  [<ffffffff81270025>] ? join_transaction.isra.24+0x1f9/0x20a
[  182.404078]  [<ffffffff81081e39>] ? add_wait_queue+0x44/0x44
[  182.404078]  [<ffffffff812710a0>] ? start_transaction+0x1f9/0x251
[  182.404078]  [<ffffffff81057a73>] ? should_resched+0x9/0x28
[  182.404078]  [<ffffffff8126a95c>] transaction_kthread+0x174/0x22b
[  182.404078]  [<ffffffff81650498>] ? _raw_spin_unlock_irqrestore+0x15/0x18
[  182.404078]  [<ffffffff8126a7e8>] ? btrfs_congested_fn+0x81/0x81
[  182.404078]  [<ffffffff81081766>] kthread+0x7f/0x87
[  182.404078]  [<ffffffff81657af4>] kernel_thread_helper+0x4/0x10
[  182.404078]  [<ffffffff810816e7>] ? kthread_worker_fn+0x141/0x141
[  182.404078]  [<ffffffff81657af0>] ? gs_change+0x13/0x13
[  182.404078] Code: ff ff 48 81 c4 88 00 00 00 44 89 e8 5b 41 5c 41
5d 41 5e 41 5f 5d c3 55 49 89 d3 49 89 f2 48 89 e5 41 54 53 48 89 cb
48 83 ec 10 <4c> 8b 27 41 81 e4 ff 0f 00 00 4a 8d 04 26 48 8d 54 10 ff
48 89
[  182.404078] RIP  [<ffffffff8128a392>] map_private_extent_buffer+0x14/0xe4
[  182.404078]  RSP <ffff880195859af0>
[  182.404078] CR2: 0000000000000000
[  182.413015] ---[ end trace 62f5169b4743eeab ]---
