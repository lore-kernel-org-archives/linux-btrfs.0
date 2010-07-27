From: Brian Rogers <brian@xyzw.org>
Subject: bio too big device sdd1 (1024 > 256)
Date: Tue, 27 Jul 2010 03:10:50 -0700
Message-ID: <4C4EB0AA.10205@xyzw.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020206090309020902070906"
To: The development of BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020206090309020902070906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I created a multi-device btrfs filesystem across two drives:

80 GB SATA 2.5 inch drive (sdb)
120 GB PATA 3.5 inch drive (sdd)

If I copy a decent-sized file to the filesystem, there are "bio too big" 
messages in dmesg, and I get read errors (along with 'btrfs csum 
failed') when trying to read them again. The process writing the files 
is unaware the data was not saved correctly.

The exact message while writing is this (with the 1024 sometimes varying):
bio too big device sdd1 (1024 > 256)

The 120 GB drive (sdd) works fine for single-device btrfs, so my guess 
is that btrfs trying to use one set of parameters for all devices on a 
filesystem and is therefore submitting out-of-spec write requests to the 
older 120 GB PATA drive. As I understand it, the relevant parameters are 
these:

$ cat /sys/block/sdb/queue/max_sectors_kb
512
$ cat /sys/block/sdd/queue/max_sectors_kb
128

Is this a known issue? Is it specifically a btrfs issue? dmesg is attached.

--------------020206090309020902070906
Content-Type: text/plain;
 name="btrfs.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btrfs.dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35rc6-latest3-generic (brian@rumblered) (gcc version 4.4.5 20100723 (prerelease) (Ubuntu/Linaro 4.4.4-7ubuntu3) ) #127g1a041a2 SMP Mon Jul 26 17:58:51 PDT 2010 (Ubuntu 2.6.35rc6-latest3.127g1a041a2-generic 2.6.35rc6-rc6)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35rc6-latest3-generic root=UUID=87050cee-e9c4-4381-8753-17615d08427b ro nouveau.tv_norm=NTSC-M nouveau.modeset=1 quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
[    0.000000]  BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.2 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7fff0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f400 (usable)
[    0.000000]  modified: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007fff0000 (usable)
[    0.000000]  modified: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
[    0.000000]  modified: 000000007fff3000 - 0000000080000000 (ACPI data)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f3e70] f3e70
[    0.000000] init_memory_mapping: 0000000000000000-000000007fff0000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 7fff0000 @ 16000-1a000
[    0.000000] RAMDISK: 37734000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7e00 00014 (v00 Nvidia)
[    0.000000] ACPI: RSDT 000000007fff3040 00034 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 000000007fff30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 000000007fff3180 06422 (v01 NVIDIA AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 000000007fff0000 00040
[    0.000000] ACPI: SSDT 000000007fff96c0 001C4 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: MCFG 000000007fff9900 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 000000007fff9600 00072 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007fff0000
[    0.000000] Initmem setup node 0 0000000000000000-000000007fff0000
[    0.000000]   NODE_DATA [0000000001d21100 - 0000000001d260ff]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002600000-ffff8800041fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007fff0
[    0.000000] On node 0 totalpages: 524159
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7112 pages used for memmap
[    0.000000]   DMA32 zone: 513064 pages, LIFO batch:31
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [18000 - 187ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91392 r8192 d23296 u1048576
[    0.000000] pcpu-alloc: s91392 r8192 d23296 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 516991
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35rc6-latest3-generic root=UUID=87050cee-e9c4-4381-8753-17615d08427b ro nouveau.tv_norm=NTSC-M nouveau.modeset=1 quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ a1fe000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Subtract (44 early reservations)
[    0.000000]   #1 [0001000000 - 0001d20114]   TEXT DATA BSS
[    0.000000]   #2 [0037734000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001d21000 - 0001d210cd]             BRK
[    0.000000]   #4 [00000f3e80 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f3e70 - 00000f3e80]    MP-table mpf
[    0.000000]   #6 [000009f000 - 00000f23a4]   BIOS reserved
[    0.000000]   #7 [00000f2500 - 00000f3e70]   BIOS reserved
[    0.000000]   #8 [00000f23a4 - 00000f2500]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #12 [0001d21100 - 0001d26100]       NODE_DATA
[    0.000000]   #13 [0001d26100 - 0001d27100]         BOOTMEM
[    0.000000]   #14 [0001d20140 - 0001d202c0]         BOOTMEM
[    0.000000]   #15 [0002528000 - 0002529000]         BOOTMEM
[    0.000000]   #16 [0002529000 - 000252a000]         BOOTMEM
[    0.000000]   #17 [0002600000 - 0004200000]        MEMMAP 0
[    0.000000]   #18 [0001d202c0 - 0001d20440]         BOOTMEM
[    0.000000]   #19 [0001d27100 - 0001d33100]         BOOTMEM
[    0.000000]   #20 [0001d34000 - 0001d35000]         BOOTMEM
[    0.000000]   #21 [0001d20440 - 0001d20483]         BOOTMEM
[    0.000000]   #22 [0001d204c0 - 0001d206b8]         BOOTMEM
[    0.000000]   #23 [0001d206c0 - 0001d20728]         BOOTMEM
[    0.000000]   #24 [0001d20740 - 0001d207a8]         BOOTMEM
[    0.000000]   #25 [0001d207c0 - 0001d20828]         BOOTMEM
[    0.000000]   #26 [0001d20840 - 0001d208a8]         BOOTMEM
[    0.000000]   #27 [0001d208c0 - 0001d20928]         BOOTMEM
[    0.000000]   #28 [0001d20940 - 0001d209a8]         BOOTMEM
[    0.000000]   #29 [0001d209c0 - 0001d20a28]         BOOTMEM
[    0.000000]   #30 [0001d20a40 - 0001d20aa8]         BOOTMEM
[    0.000000]   #31 [0001d20ac0 - 0001d20ae0]         BOOTMEM
[    0.000000]   #32 [0001d20b00 - 0001d20b94]         BOOTMEM
[    0.000000]   #33 [0001d20bc0 - 0001d20c54]         BOOTMEM
[    0.000000]   #34 [0001e00000 - 0001e1e000]         BOOTMEM
[    0.000000]   #35 [0001f00000 - 0001f1e000]         BOOTMEM
[    0.000000]   #36 [0001d20c80 - 0001d20c88]         BOOTMEM
[    0.000000]   #37 [0001d20cc0 - 0001d20cc8]         BOOTMEM
[    0.000000]   #38 [0001d20d00 - 0001d20d08]         BOOTMEM
[    0.000000]   #39 [0001d20d40 - 0001d20d50]         BOOTMEM
[    0.000000]   #40 [0001d20d80 - 0001d20ec0]         BOOTMEM
[    0.000000]   #41 [0001d20ec0 - 0001d20f20]         BOOTMEM
[    0.000000]   #42 [0001d20f40 - 0001d20fa0]         BOOTMEM
[    0.000000]   #43 [0001d35000 - 0001d3d000]         BOOTMEM
[    0.000000] Memory: 2045184k/2097088k available (5707k kernel code, 452k absent, 51452k reserved, 5420k data, 904k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 20971520 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1999.675 MHz processor.
[    0.010008] Calibrating delay loop (skipped), value calculated using timer frequency.. 3999.35 BogoMIPS (lpj=19996750)
[    0.010013] pid_max: default: 32768 minimum: 301
[    0.010040] Security Framework initialized
[    0.010062] AppArmor: AppArmor initialized
[    0.010064] Yama: becoming mindful.
[    0.010371] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.020568] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.021069] Mount-cache hash table entries: 256
[    0.021213] Initializing cgroup subsys ns
[    0.021218] Initializing cgroup subsys cpuacct
[    0.021222] Initializing cgroup subsys memory
[    0.021233] Initializing cgroup subsys devices
[    0.021235] Initializing cgroup subsys freezer
[    0.021238] Initializing cgroup subsys net_cls
[    0.021264] tseg: 0000000000
[    0.021281] CPU: Physical Processor ID: 0
[    0.021283] CPU: Processor Core ID: 0
[    0.021285] mce: CPU supports 5 MCE banks
[    0.021298] using C1E aware idle routine
[    0.021301] Performance Events: AMD PMU driver.
[    0.021306] ... version:                0
[    0.021307] ... bit width:              48
[    0.021309] ... generic registers:      4
[    0.021311] ... value mask:             0000ffffffffffff
[    0.021313] ... max period:             00007fffffffffff
[    0.021315] ... fixed-purpose events:   0
[    0.021317] ... event mask:             000000000000000f
[    0.022992] ACPI: Core revision 20100428
[    0.030013] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.030019] ftrace: allocating 22647 entries in 89 pages
[    0.040092] Setting APIC routing to flat
[    0.040414] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.143250] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.150000] Booting Node   0, Processors  #1 Ok.
[    0.300128] Brought up 2 CPUs
[    0.300131] Total of 2 processors activated (7999.43 BogoMIPS).
[    0.300338] devtmpfs: initialized
[    0.300845] regulator: core version 0.5
[    0.300874] Time:  6:44:40  Date: 07/27/10
[    0.300919] NET: Registered protocol family 16
[    0.301040] node 0 link 0: io port [6000, ffff]
[    0.301044] TOM: 0000000080000000 aka 2048M
[    0.301047] node 0 link 0: mmio [a0000, bffff]
[    0.301050] node 0 link 0: mmio [feb00000, fec0ffff]
[    0.301053] node 0 link 0: mmio [80000000, dfffffff]
[    0.301056] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.301059] node 0 link 0: mmio [e0000000, e05fffff]
[    0.301062] bus: [00, 05] on node 0 link 0
[    0.301065] bus: 00 index 0 [io  0x0000-0xffff]
[    0.301068] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.301070] bus: 00 index 2 [mem 0xfe030000-0xfcffffffff]
[    0.301073] bus: 00 index 3 [mem 0x80000000-0xefffffff]
[    0.301075] bus: 00 index 4 [mem 0xf0000000-0xfe02ffff]
[    0.301082] ACPI: bus type pci registered
[    0.301148] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.301152] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.321107] Trying to unpack rootfs image as initramfs...
[    0.321843] PCI: Using configuration type 1 for base access
[    0.330297] bio: create slab <bio-0> at 0
[    0.331557] ACPI: EC: Look up EC in DSDT
[    0.337655] ACPI: Interpreter enabled
[    0.337659] ACPI: (supports S0 S3 S4 S5)
[    0.337688] ACPI: Using IOAPIC for interrupt routing
[    0.348042] ACPI: No dock devices found.
[    0.348046] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.349182] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-05])
[    0.351426] pci_root PNP0A08:00: host bridge window [io  0x0000-0x03af] (ignored)
[    0.351430] pci_root PNP0A08:00: host bridge window [io  0x03e0-0x0cf7] (ignored)
[    0.351432] pci_root PNP0A08:00: host bridge window [io  0x6000-0xffff] (ignored)
[    0.351435] pci_root PNP0A08:00: host bridge window [io  0x03b0-0x03df] (ignored)
[    0.351438] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.351440] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xdfffffff] (ignored)
[    0.351443] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfe02ffff] (ignored)
[    0.351446] pci_root PNP0A08:00: host bridge window [mem 0xfeb00000-0xfebfffff] (ignored)
[    0.351449] pci_root PNP0A08:00: host bridge window [io  0x1c00-0x1c80] (ignored)
[    0.351521] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.351536] pci 0000:00:01.1: reg 10: [io  0xfc00-0xfc1f]
[    0.351544] pci 0000:00:01.1: reg 20: [io  0x1c00-0x1c3f]
[    0.351548] pci 0000:00:01.1: reg 24: [io  0x1c40-0x1c7f]
[    0.351558] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.351561] pci 0000:00:01.1: PME# disabled
[    0.351580] pci 0000:00:02.0: reg 10: [mem 0xfe02f000-0xfe02ffff]
[    0.351597] pci 0000:00:02.0: supports D1 D2
[    0.351599] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.351602] pci 0000:00:02.0: PME# disabled
[    0.351621] pci 0000:00:02.1: reg 10: [mem 0xfeb00000-0xfeb000ff]
[    0.351640] pci 0000:00:02.1: supports D1 D2
[    0.351643] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.351646] pci 0000:00:02.1: PME# disabled
[    0.351666] pci 0000:00:04.0: reg 10: [io  0xf000-0xf0ff]
[    0.351670] pci 0000:00:04.0: reg 14: [io  0xec00-0xecff]
[    0.351674] pci 0000:00:04.0: reg 18: [mem 0xfe02d000-0xfe02dfff]
[    0.351688] pci 0000:00:04.0: supports D1 D2
[    0.351707] pci 0000:00:06.0: reg 20: [io  0xe800-0xe80f]
[    0.351730] pci 0000:00:07.0: reg 10: [io  0x09f0-0x09f7]
[    0.351734] pci 0000:00:07.0: reg 14: [io  0x0bf0-0x0bf3]
[    0.351737] pci 0000:00:07.0: reg 18: [io  0x0970-0x0977]
[    0.351741] pci 0000:00:07.0: reg 1c: [io  0x0b70-0x0b73]
[    0.351745] pci 0000:00:07.0: reg 20: [io  0xd400-0xd40f]
[    0.351749] pci 0000:00:07.0: reg 24: [mem 0xfe02c000-0xfe02cfff]
[    0.351770] pci 0000:00:08.0: reg 10: [io  0x09e0-0x09e7]
[    0.351774] pci 0000:00:08.0: reg 14: [io  0x0be0-0x0be3]
[    0.351778] pci 0000:00:08.0: reg 18: [io  0x0960-0x0967]
[    0.351782] pci 0000:00:08.0: reg 1c: [io  0x0b60-0x0b63]
[    0.351786] pci 0000:00:08.0: reg 20: [io  0xc000-0xc00f]
[    0.351790] pci 0000:00:08.0: reg 24: [mem 0xfe02b000-0xfe02bfff]
[    0.351822] pci 0000:00:0a.0: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.351826] pci 0000:00:0a.0: reg 14: [io  0xbc00-0xbc07]
[    0.351841] pci 0000:00:0a.0: supports D1 D2
[    0.351843] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.351847] pci 0000:00:0a.0: PME# disabled
[    0.351875] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.351878] pci 0000:00:0b.0: PME# disabled
[    0.351910] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.351913] pci 0000:00:0c.0: PME# disabled
[    0.351942] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.351945] pci 0000:00:0d.0: PME# disabled
[    0.351974] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.351977] pci 0000:00:0e.0: PME# disabled
[    0.352058] PCI: peer root bus 00 res updated from pci conf
[    0.352089] pci 0000:01:08.0: reg 10: [mem 0xfdeff000-0xfdeff7ff]
[    0.352116] pci 0000:01:08.0: supports D1 D2
[    0.352143] pci 0000:01:0a.0: reg 10: [mem 0xfdefc000-0xfdefdfff]
[    0.352190] pci 0000:00:09.0: PCI bridge to [bus 01-01] (subtractive decode)
[    0.352193] pci 0000:00:09.0:   bridge window [io  0xa000-0xafff]
[    0.352197] pci 0000:00:09.0:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.352200] pci 0000:00:09.0:   bridge window [mem 0xfdf00000-0xfdffffff pref]
[    0.352203] pci 0000:00:09.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.352206] pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.352209] pci 0000:00:09.0:   bridge window [mem 0xfe030000-0xfcffffffff] (subtractive decode)
[    0.352212] pci 0000:00:09.0:   bridge window [mem 0x80000000-0xefffffff] (subtractive decode)
[    0.352215] pci 0000:00:09.0:   bridge window [mem 0xf0000000-0xfe02ffff] (subtractive decode)
[    0.352237] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    0.352241] pci 0000:00:0b.0:   bridge window [io  0x9000-0x9fff]
[    0.352244] pci 0000:00:0b.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.352248] pci 0000:00:0b.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.352268] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    0.352272] pci 0000:00:0c.0:   bridge window [io  0x8000-0x8fff]
[    0.352275] pci 0000:00:0c.0:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.352279] pci 0000:00:0c.0:   bridge window [mem 0xfda00000-0xfdafffff 64bit pref]
[    0.352298] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    0.352302] pci 0000:00:0d.0:   bridge window [io  0x7000-0x7fff]
[    0.352305] pci 0000:00:0d.0:   bridge window [mem 0xfd900000-0xfd9fffff]
[    0.352309] pci 0000:00:0d.0:   bridge window [mem 0xfd800000-0xfd8fffff 64bit pref]
[    0.352341] pci 0000:05:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
[    0.352348] pci 0000:05:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.352355] pci 0000:05:00.0: reg 1c: [mem 0xfb000000-0xfbffffff 64bit]
[    0.352362] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.352383] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.352390] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    0.352394] pci 0000:00:0e.0:   bridge window [io  0x6000-0x6fff]
[    0.352397] pci 0000:00:0e.0:   bridge window [mem 0xfa000000-0xfcffffff]
[    0.352401] pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.352415] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.352710] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.429798] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 *10 11)
[    0.429972] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 10 11) *0, disabled.
[    0.430151] ACPI: PCI Interrupt Link [LNK3] (IRQs *5 10 11)
[    0.430324] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 10 11) *0, disabled.
[    0.430497] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 10 11) *0, disabled.
[    0.430671] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 *10 11)
[    0.430842] ACPI: PCI Interrupt Link [LUBB] (IRQs 5 10 11) *0, disabled.
[    0.431016] ACPI: PCI Interrupt Link [LMAC] (IRQs *5 10 11)
[    0.431194] ACPI: PCI Interrupt Link [LACI] (IRQs 5 10 *11)
[    0.431366] ACPI: PCI Interrupt Link [LMCI] (IRQs 5 10 11) *0, disabled.
[    0.431540] ACPI: PCI Interrupt Link [LSMB] (IRQs *5 10 11)
[    0.431719] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 10 *11)
[    0.431890] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 10 11) *0, disabled.
[    0.432075] ACPI: PCI Interrupt Link [LSID] (IRQs 5 *10 11)
[    0.432262] ACPI: PCI Interrupt Link [LFID] (IRQs 5 10 *11)
[    0.432448] ACPI: PCI Interrupt Link [LPCA] (IRQs 5 10 11) *0, disabled.
[    0.432648] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
[    0.432845] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[    0.433043] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
[    0.433240] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    0.433365] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[    0.433573] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
[    0.433780] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
[    0.433988] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    0.434195] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
[    0.434402] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
[    0.434611] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
[    0.434818] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
[    0.435025] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    0.435242] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[    0.435460] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
[    0.435678] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    0.435737] HEST: Table is not found!
[    0.435841] vgaarb: device added: PCI:0000:05:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.435844] vgaarb: loaded
[    0.436012] SCSI subsystem initialized
[    0.436121] libata version 3.00 loaded.
[    0.436174] usbcore: registered new interface driver usbfs
[    0.436187] usbcore: registered new interface driver hub
[    0.436215] usbcore: registered new device driver usb
[    0.436378] ACPI: WMI: Mapper loaded
[    0.436380] PCI: Using ACPI for IRQ routing
[    0.436384] PCI: pci_cache_line_size set to 64 bytes
[    0.436454] reserve RAM buffer: 000000000009f400 - 000000000009ffff 
[    0.436457] reserve RAM buffer: 000000007fff0000 - 000000007fffffff 
[    0.436562] NetLabel: Initializing
[    0.436564] NetLabel:  domain hash size = 128
[    0.436565] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.436579] NetLabel:  unlabeled traffic allowed by default
[    0.447748] AppArmor: AppArmor Filesystem Enabled
[    0.447768] pnp: PnP ACPI init
[    0.447786] ACPI: bus type pnp registered
[    0.453047] pnp: PnP ACPI: found 9 devices
[    0.453049] ACPI: ACPI bus type pnp unregistered
[    0.453069] system 00:01: [io  0x1000-0x107f] has been reserved
[    0.453072] system 00:01: [io  0x1080-0x10ff] has been reserved
[    0.453075] system 00:01: [io  0x1400-0x147f] has been reserved
[    0.453079] system 00:01: [io  0x1480-0x14ff] has been reserved
[    0.453082] system 00:01: [io  0x1800-0x187f] has been reserved
[    0.453085] system 00:01: [io  0x1880-0x18ff] has been reserved
[    0.453091] system 00:02: [io  0x0b78-0x0b7b] has been reserved
[    0.453094] system 00:02: [io  0x0f78-0x0f7b] has been reserved
[    0.453097] system 00:02: [io  0x0a78-0x0a7b] has been reserved
[    0.453100] system 00:02: [io  0x0e78-0x0e7b] has been reserved
[    0.453103] system 00:02: [io  0x0bbc-0x0bbf] has been reserved
[    0.453106] system 00:02: [io  0x0fbc-0x0fbf] has been reserved
[    0.453109] system 00:02: [io  0x04d0-0x04d1] has been reserved
[    0.453112] system 00:02: [io  0x0294-0x0297] has been reserved
[    0.453115] system 00:02: [io  0x0295-0x0296] has been reserved
[    0.453123] system 00:07: [mem 0xe0000000-0xefffffff] has been reserved
[    0.453129] system 00:08: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.453132] system 00:08: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.453135] system 00:08: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.453139] system 00:08: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.453142] system 00:08: [mem 0x7fff0000-0x7fffffff] could not be reserved
[    0.453145] system 00:08: [mem 0xffff0000-0xffffffff] has been reserved
[    0.453149] system 00:08: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.453152] system 00:08: [mem 0x00100000-0x7ffeffff] could not be reserved
[    0.453156] system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.453159] system 00:08: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.453162] system 00:08: [mem 0xfefff000-0xfeffffff] has been reserved
[    0.453166] system 00:08: [mem 0xfff80000-0xfff80fff] has been reserved
[    0.453169] system 00:08: [mem 0xfff90000-0xfffbffff] has been reserved
[    0.453172] system 00:08: [mem 0xfffed000-0xfffeffff] has been reserved
[    0.457885] Switching to clocksource acpi_pm
[    0.458135] pci 0000:00:09.0: PCI bridge to [bus 01-01]
[    0.458139] pci 0000:00:09.0:   bridge window [io  0xa000-0xafff]
[    0.458142] pci 0000:00:09.0:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.458146] pci 0000:00:09.0:   bridge window [mem 0xfdf00000-0xfdffffff pref]
[    0.458150] pci 0000:00:0b.0: PCI bridge to [bus 02-02]
[    0.458152] pci 0000:00:0b.0:   bridge window [io  0x9000-0x9fff]
[    0.458156] pci 0000:00:0b.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.458159] pci 0000:00:0b.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.458163] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    0.458166] pci 0000:00:0c.0:   bridge window [io  0x8000-0x8fff]
[    0.458169] pci 0000:00:0c.0:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.458172] pci 0000:00:0c.0:   bridge window [mem 0xfda00000-0xfdafffff 64bit pref]
[    0.458176] pci 0000:00:0d.0: PCI bridge to [bus 04-04]
[    0.458179] pci 0000:00:0d.0:   bridge window [io  0x7000-0x7fff]
[    0.458182] pci 0000:00:0d.0:   bridge window [mem 0xfd900000-0xfd9fffff]
[    0.458185] pci 0000:00:0d.0:   bridge window [mem 0xfd800000-0xfd8fffff 64bit pref]
[    0.458192] pci 0000:05:00.0: BAR 6: assigned [mem 0xfc000000-0xfc01ffff pref]
[    0.458195] pci 0000:00:0e.0: PCI bridge to [bus 05-05]
[    0.458198] pci 0000:00:0e.0:   bridge window [io  0x6000-0x6fff]
[    0.458202] pci 0000:00:0e.0:   bridge window [mem 0xfa000000-0xfcffffff]
[    0.458205] pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.458214] pci 0000:00:09.0: setting latency timer to 64
[    0.458220] pci 0000:00:0b.0: setting latency timer to 64
[    0.458225] pci 0000:00:0c.0: setting latency timer to 64
[    0.458231] pci 0000:00:0d.0: setting latency timer to 64
[    0.458236] pci 0000:00:0e.0: setting latency timer to 64
[    0.458239] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.458242] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
[    0.458245] pci_bus 0000:00: resource 6 [mem 0xfe030000-0xfcffffffff]
[    0.458247] pci_bus 0000:00: resource 7 [mem 0x80000000-0xefffffff]
[    0.458250] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfe02ffff]
[    0.458253] pci_bus 0000:01: resource 0 [io  0xa000-0xafff]
[    0.458255] pci_bus 0000:01: resource 1 [mem 0xfde00000-0xfdefffff]
[    0.458258] pci_bus 0000:01: resource 2 [mem 0xfdf00000-0xfdffffff pref]
[    0.458261] pci_bus 0000:01: resource 4 [io  0x0000-0xffff]
[    0.458263] pci_bus 0000:01: resource 5 [mem 0x000a0000-0x000bffff]
[    0.458266] pci_bus 0000:01: resource 6 [mem 0xfe030000-0xfcffffffff]
[    0.458269] pci_bus 0000:01: resource 7 [mem 0x80000000-0xefffffff]
[    0.458271] pci_bus 0000:01: resource 8 [mem 0xf0000000-0xfe02ffff]
[    0.458274] pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]
[    0.458277] pci_bus 0000:02: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.458280] pci_bus 0000:02: resource 2 [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.458282] pci_bus 0000:03: resource 0 [io  0x8000-0x8fff]
[    0.458285] pci_bus 0000:03: resource 1 [mem 0xfdb00000-0xfdbfffff]
[    0.458288] pci_bus 0000:03: resource 2 [mem 0xfda00000-0xfdafffff 64bit pref]
[    0.458290] pci_bus 0000:04: resource 0 [io  0x7000-0x7fff]
[    0.458293] pci_bus 0000:04: resource 1 [mem 0xfd900000-0xfd9fffff]
[    0.458296] pci_bus 0000:04: resource 2 [mem 0xfd800000-0xfd8fffff 64bit pref]
[    0.458298] pci_bus 0000:05: resource 0 [io  0x6000-0x6fff]
[    0.458301] pci_bus 0000:05: resource 1 [mem 0xfa000000-0xfcffffff]
[    0.458303] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.458339] NET: Registered protocol family 2
[    0.458463] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.459450] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.459998] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.459998] TCP: Hash tables configured (established 262144 bind 65536)
[    0.459998] TCP reno registered
[    0.459998] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.459998] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.459998] NET: Registered protocol family 1
[    0.482585] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.482591] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    0.482598] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.482602] pci 0000:00:0b.0: Linking AER extended capability
[    0.482639] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.482644] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    0.482652] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.482654] pci 0000:00:0c.0: Linking AER extended capability
[    0.482694] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.482699] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    0.482706] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.482709] pci 0000:00:0d.0: Linking AER extended capability
[    0.482752] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.482757] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    0.482764] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.482767] pci 0000:00:0e.0: Linking AER extended capability
[    0.482790] pci 0000:05:00.0: Boot video device
[    0.482793] PCI: CLS 64 bytes, default 64
[    0.521334] Scanning for low memory corruption every 60 seconds
[    0.521474] audit: initializing netlink socket (disabled)
[    0.521496] type=2000 audit(1280213079.519:1): initialized
[    0.536251] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.537843] VFS: Disk quotas dquot_6.5.2
[    0.537902] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.538532] fuse init (API version 7.14)
[    0.538620] msgmni has been set to 3994
[    0.538860] alg: No test for stdrng (krng)
[    0.538917] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.538920] io scheduler noop registered
[    0.538922] io scheduler deadline registered
[    0.538965] io scheduler cfq registered (default)
[    0.539109] pcieport 0000:00:0b.0: setting latency timer to 64
[    0.539125]   alloc irq_desc for 40 on node 0
[    0.539128]   alloc kstat_irqs on node 0
[    0.539139] pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
[    0.539213] pcieport 0000:00:0c.0: setting latency timer to 64
[    0.539227]   alloc irq_desc for 41 on node 0
[    0.539228]   alloc kstat_irqs on node 0
[    0.539234] pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
[    0.539298] pcieport 0000:00:0d.0: setting latency timer to 64
[    0.539312]   alloc irq_desc for 42 on node 0
[    0.539313]   alloc kstat_irqs on node 0
[    0.539318] pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
[    0.539388] pcieport 0000:00:0e.0: setting latency timer to 64
[    0.539401]   alloc irq_desc for 43 on node 0
[    0.539403]   alloc kstat_irqs on node 0
[    0.539408] pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
[    0.539477] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.539501] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.539683] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.539687] ACPI: Power Button [PWRB]
[    0.539751] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.539754] ACPI: Power Button [PWRF]
[    0.539810] ACPI: Fan [FAN] (on)
[    0.540462] ACPI: acpi_idle registered with cpuidle
[    0.545880] thermal LNXTHERM:01: registered as thermal_zone0
[    0.545888] ACPI: Thermal Zone [THRM] (50 C)
[    0.545944] ERST: Table is not found!
[    0.547389] Linux agpgart interface v0.103
[    0.547394] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.548846] brd: module loaded
[    0.549439] loop: module loaded
[    0.549829] pata_acpi 0000:00:06.0: setting latency timer to 64
[    0.550391] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23
[    0.550397]   alloc irq_desc for 23 on node 0
[    0.550400]   alloc kstat_irqs on node 0
[    0.550413] pata_acpi 0000:00:07.0: PCI INT A -> Link[APSI] -> GSI 23 (level, low) -> IRQ 23
[    0.550430] pata_acpi 0000:00:07.0: setting latency timer to 64
[    0.550438] pata_acpi 0000:00:07.0: PCI INT A disabled
[    0.550883] ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 22
[    0.550888]   alloc irq_desc for 22 on node 0
[    0.550890]   alloc kstat_irqs on node 0
[    0.550896] pata_acpi 0000:00:08.0: PCI INT A -> Link[APSJ] -> GSI 22 (level, low) -> IRQ 22
[    0.550921] pata_acpi 0000:00:08.0: setting latency timer to 64
[    0.550928] pata_acpi 0000:00:08.0: PCI INT A disabled
[    0.551349] Fixed MDIO Bus: probed
[    0.551386] PPP generic driver version 2.4.2
[    0.551437] tun: Universal TUN/TAP device driver, 1.6
[    0.551439] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.551531] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.551891] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 21
[    0.551895]   alloc irq_desc for 21 on node 0
[    0.551897]   alloc kstat_irqs on node 0
[    0.551904] ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 21 (level, low) -> IRQ 21
[    0.551924] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    0.551927] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    0.551969] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    0.551995] ehci_hcd 0000:00:02.1: debug port 1
[    0.552001] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    0.552022] ehci_hcd 0000:00:02.1: irq 21, io mem 0xfeb00000
[    0.566458] Freeing initrd memory: 8944k freed
[    0.570020] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    0.570170] hub 1-0:1.0: USB hub found
[    0.570177] hub 1-0:1.0: 10 ports detected
[    0.570287] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.570690] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 20
[    0.570694]   alloc irq_desc for 20 on node 0
[    0.570696]   alloc kstat_irqs on node 0
[    0.570703] ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 20 (level, low) -> IRQ 20
[    0.570718] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    0.570720] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    0.570760] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    0.570785] ohci_hcd 0000:00:02.0: irq 20, io mem 0xfe02f000
[    0.632145] hub 2-0:1.0: USB hub found
[    0.632151] hub 2-0:1.0: 10 ports detected
[    0.632260] uhci_hcd: USB Universal Host Controller Interface driver
[    0.632408] PNP: No PS/2 controller found. Probing ports directly.
[    0.634883] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.634891] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.634984] mice: PS/2 mouse device common for all mice
[    0.635081] rtc_cmos 00:04: RTC can wake from S4
[    0.635125] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.635149] rtc0: alarms up to one year, y3k, 242 bytes nvram
[    0.635256] device-mapper: uevent: version 1.0.3
[    0.635392] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    0.635538] device-mapper: multipath: version 1.1.1 loaded
[    0.635542] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.635816] cpuidle: using governor ladder
[    0.635818] cpuidle: using governor menu
[    0.636123] TCP cubic registered
[    0.636279] NET: Registered protocol family 10
[    0.636682] lo: Disabled Privacy Extensions
[    0.636934] NET: Registered protocol family 17
[    0.636974] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ (2 cpu cores) (version 2.20.00)
[    0.637029] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0xe
[    0.637032] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x10
[    0.637034] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[    0.637168] PM: Resume from disk failed.
[    0.637181] registered taskstats version 1
[    0.637403]   Magic number: 2:354:722
[    0.637413] block loop2: hash matches
[    0.637503] rtc_cmos 00:04: setting system clock to 2010-07-27 06:44:40 UTC (1280213080)
[    0.637506] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.637508] EDD information not available.
[    0.637602] Freeing unused kernel memory: 904k freed
[    0.637972] Write protecting the kernel read-only data: 10240k
[    0.638159] Freeing unused kernel memory: 416k freed
[    0.638492] Freeing unused kernel memory: 1604k freed
[    0.660405] udev: starting version 151
[    0.734329] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    0.734785] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
[    0.734792] forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 23 (level, low) -> IRQ 23
[    0.734797] forcedeth 0000:00:0a.0: setting latency timer to 64
[    0.734857] nv_probe: set workaround bit for reversed mac addr
[    0.812336] Btrfs loaded
[    1.260732] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:50:8d:98:3d:31
[    1.260738] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[    1.260820] sata_nv 0000:00:07.0: version 3.5
[    1.260836] sata_nv 0000:00:07.0: PCI INT A -> Link[APSI] -> GSI 23 (level, low) -> IRQ 23
[    1.260890] sata_nv 0000:00:07.0: setting latency timer to 64
[    1.261029] scsi0 : sata_nv
[    1.261146] scsi1 : sata_nv
[    1.261401] ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd400 irq 23
[    1.261405] ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd408 irq 23
[    1.261499] sata_nv 0000:00:08.0: PCI INT A -> Link[APSJ] -> GSI 22 (level, low) -> IRQ 22
[    1.261536] sata_nv 0000:00:08.0: setting latency timer to 64
[    1.261606] scsi2 : sata_nv
[    1.261673] scsi3 : sata_nv
[    1.261870] ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc000 irq 22
[    1.261873] ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc008 irq 22
[    1.261967] pata_amd 0000:00:06.0: version 0.4.1
[    1.261998] pata_amd 0000:00:06.0: setting latency timer to 64
[    1.262068] scsi4 : pata_amd
[    1.262147] scsi5 : pata_amd
[    1.263201] ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xe800 irq 14
[    1.263204] ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xe808 irq 15
[    1.352520] usb 2-3: new full speed USB device using ohci_hcd and address 2
[    1.460432] ata5.00: ATA-7: Maxtor 6Y160P0, YAR41BW0, max UDMA/133
[    1.460436] ata5.00: 320173056 sectors, multi 16: LBA48 
[    1.461300] ata5.01: ATA-5: WDC WD1200JB-00CRA1, 17.07W17, max UDMA/100
[    1.461303] ata5.01: 234441648 sectors, multi 16: LBA 
[    1.461328] ata5: nv_mode_filter: 0x7f39f&0x7f39f->0x7f39f, BIOS=0x7f000 (0xc7c6c500) ACPI=0x7f01f (15:20:0x1f)
[    1.461334] ata5: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=0x3f000 (0xc7c6c500) ACPI=0x3f01f (15:20:0x1f)
[    1.500356] ata5.00: configured for UDMA/133
[    1.541073] ata5.01: configured for UDMA/100
[    1.580070] ata3: SATA link down (SStatus 0 SControl 300)
[    1.740051] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.760307] ata1.00: ATA-8: Hitachi HDP725050GLA360, GM4OA52A, max UDMA/133
[    1.760311] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.800293] ata1.00: configured for UDMA/133
[    1.800463] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDP72505 GM4O PQ: 0 ANSI: 5
[    1.800667] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.800764] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.800828] sd 0:0:0:0: [sda] Write Protect is off
[    1.800831] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.800857] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.801029]  sda: sda1
[    1.843421] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.920025] usb 2-4: new low speed USB device using ohci_hcd and address 3
[    2.290046] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.312738] ata2.00: ATA-7: ST980811AS, 3.ALC, max UDMA/133
[    2.312742] ata2.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.350238] ata2.00: configured for UDMA/133
[    2.350394] scsi 1:0:0:0: Direct-Access     ATA      ST980811AS       3.AL PQ: 0 ANSI: 5
[    2.350581] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.350611] sd 1:0:0:0: [sdb] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    2.350766] sd 1:0:0:0: [sdb] Write Protect is off
[    2.350769] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.350822] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.351110]  sdb: sdb1
[    2.381203] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.490027] usb 2-6: new low speed USB device using ohci_hcd and address 4
[    2.680025] ata4: SATA link down (SStatus 0 SControl 300)
[    2.680143] scsi 4:0:0:0: Direct-Access     ATA      Maxtor 6Y160P0   YAR4 PQ: 0 ANSI: 5
[    2.680294] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    2.680319] sd 4:0:0:0: [sdc] 320173056 512-byte logical blocks: (163 GB/152 GiB)
[    2.680391] scsi 4:0:1:0: Direct-Access     ATA      WDC WD1200JB-00C 17.0 PQ: 0 ANSI: 5
[    2.680424] sd 4:0:0:0: [sdc] Write Protect is off
[    2.680428] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.680454] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.680520] sd 4:0:1:0: Attached scsi generic sg3 type 0
[    2.680564] sd 4:0:1:0: [sdd] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    2.680622] sd 4:0:1:0: [sdd] Write Protect is off
[    2.680625] sd 4:0:1:0: [sdd] Mode Sense: 00 3a 00 00
[    2.680677] sd 4:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.680789]  sdc:
[    2.695148]  sdd: sdc1 sdc2 sdc3
[    2.730788] usbcore: registered new interface driver hiddev
[    2.736427] input: LITEON Technology USB Multimedia Keyboard as /devices/pci0000:00/0000:00:02.0/usb2/2-4/2-4:1.0/input/input2
[    2.736520] generic-usb 0003:046D:C312.0001: input,hidraw0: USB HID v1.10 Keyboard [LITEON Technology USB Multimedia Keyboard] on usb-0000:00:02.0-4/input0
[    2.742359] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:02.0/usb2/2-6/2-6:1.0/input/input3
[    2.742448] generic-usb 0003:046D:C00E.0002: input,hidraw1: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.0-6/input0
[    2.742467] usbcore: registered new interface driver usbhid
[    2.742469] usbhid: USB HID core driver
[    2.756277] sd 4:0:0:0: [sdc] Attached SCSI disk
[    2.756288]  sdd1
[    2.756619] sd 4:0:1:0: [sdd] Attached SCSI disk
[    2.860354] ata6.00: ATAPI: HL-DT-STDVD-RAM GSA-H55N, 1.03, max UDMA/66
[    2.860381] ata6: nv_mode_filter: 0x1f39f&0x1f39f->0x1f39f, BIOS=0x1f000 (0xc7c6c500) ACPI=0x1f01f (30:600:0x13)
[    2.900331] ata6.00: configured for UDMA/66
[    2.902681] scsi 5:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H55N 1.03 PQ: 0 ANSI: 5
[    2.906661] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.906664] Uniform CD-ROM driver Revision: 3.20
[    2.906776] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    2.906841] sr 5:0:0:0: Attached scsi generic sg4 type 5
[    3.244004] device label Storage devid 1 transid 25 /dev/sdd1
[    3.297301] device label Storage devid 2 transid 25 /dev/sdb1
[    3.326388] device label Aux devid 1 transid 11141 /dev/sda1
[    8.383700] EXT4-fs (sdc2): INFO: recovery required on readonly filesystem
[    8.383705] EXT4-fs (sdc2): write access will be enabled during recovery
[   13.323811] EXT4-fs (sdc2): recovery complete
[   13.324258] EXT4-fs (sdc2): mounted filesystem with ordered data mode. Opts: (null)
[   15.410204] Adding 2929280k swap on /dev/sdc3.  Priority:-1 extents:1 across:2929280k 
[   15.916769] udev: starting version 151
[   17.970727] Bluetooth: Core ver 2.15
[   17.970785] NET: Registered protocol family 31
[   17.970787] Bluetooth: HCI device and connection manager initialized
[   17.970790] Bluetooth: HCI socket layer initialized
[   18.380188] lp: driver loaded but no devices found
[   18.456793] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[   18.471388] EDAC MC: Ver: 2.1.0 Jul 26 2010
[   18.474921] EDAC amd64_edac:  Ver: 3.3.0 Jul 26 2010
[   18.475096] EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
[   18.475108] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[   18.475110]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[   18.475112]  (Note that use of the override may cause unknown side effects.)
[   18.475263] amd64_edac: probe of 0000:00:18.2 failed with error -22
[   18.577246] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   18.579400] usbcore: registered new interface driver btusb
[   18.704297] cfg80211: Calling CRDA to update world regulatory domain
[   18.754881] i2c i2c-0: nForce2 SMBus adapter at 0x1c00
[   18.754984] i2c i2c-1: nForce2 SMBus adapter at 0x1c40
[   18.888627] Linux video capture interface: v2.00
[   19.124368] IR NEC protocol handler initialized
[   19.637024] saa7130/34: v4l2 driver version 0.2.16 loaded
[   19.637678] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
[   19.637683]   alloc irq_desc for 16 on node 0
[   19.637686]   alloc kstat_irqs on node 0
[   19.637698] saa7134 0000:01:08.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> IRQ 16
[   19.637704] saa7133[0]: found at 0000:01:08.0, rev: 209, irq: 16, latency: 16, mmio: 0xfdeff000
[   19.637710] saa7133[0]: subsystem: 1462:6231, board: MSI TV@Anywhere plus [card=82,autodetected]
[   19.637730] saa7133[0]: board init: gpio is 40
[   19.724016] IR RC5(x) protocol handler initialized
[   19.810018] saa7133[0]: i2c eeprom 00: 62 14 31 62 10 28 ff ff ff ff ff ff ff ff ff ff
[   19.810031] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810042] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810052] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810063] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810073] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810084] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810094] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810105] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810115] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810126] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810137] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810147] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810157] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810168] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   19.810178] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.173840] IR RC6 protocol handler initialized
[   20.237045] cfg80211: World regulatory domain updated:
[   20.237049]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   20.237052]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.237055]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   20.237059]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   20.237061]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.237064]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.403155] IR JVC protocol handler initialized
[   20.420598] ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 22
[   20.420606] Intel ICH 0000:00:04.0: PCI INT A -> Link[APCJ] -> GSI 22 (level, low) -> IRQ 22
[   20.420641] Intel ICH 0000:00:04.0: setting latency timer to 64
[   20.540517] IR Sony protocol handler initialized
[   20.770023] intel8x0_measure_ac97_clock: measured 60700 usecs (2976 samples)
[   20.770027] intel8x0: clocking to 46993
[   20.970147] tuner 2-004b: chip found @ 0x96 (saa7133[0])
[   21.127981] nvidia: module license 'NVIDIA' taints kernel.
[   21.127986] Disabling lock debugging due to kernel taint
[   21.140020] tda829x 2-004b: setting tuner address to 61
[   21.876113] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[   21.876121]   alloc irq_desc for 18 on node 0
[   21.876123]   alloc kstat_irqs on node 0
[   21.876136] nvidia 0000:05:00.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
[   21.876144] nvidia 0000:05:00.0: setting latency timer to 64
[   21.876149] vgaarb: device changed decodes: PCI:0000:05:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   21.876369] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  195.36.24  Thu Apr 22 19:10:14 PDT 2010
[   21.940017] tda829x 2-004b: type set to tda8290+75a
[   27.652584] Registered IR keymap rc-msi-tvanywhere-plus
[   27.652687] input: i2c IR (MSI TV@nywhere Plus) as /devices/virtual/rc/rc0/input4
[   27.652752] rc0: i2c IR (MSI TV@nywhere Plus) as /devices/virtual/rc/rc0
[   27.652755] ir-kbd-i2c: i2c IR (MSI TV@nywhere Plus) detected at i2c-2/2-0030/ir0 [saa7133[0]]
[   27.780103] saa7133[0]: registered device video0 [v4l2]
[   27.780137] saa7133[0]: registered device vbi0
[   27.780172] saa7133[0]: registered device radio0
[   27.781004] rt2500pci 0000:01:0a.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
[   27.781012] rt2500pci 0000:01:0a.0: setting latency timer to 64
[   27.821109] phy0: Selected rate control algorithm 'minstrel'
[   27.822006] Registered led device: rt2500pci-phy0::radio
[   27.822024] Registered led device: rt2500pci-phy0::quality
[   27.828374] saa7134 ALSA driver for DMA sound loaded
[   27.828411] saa7133[0]/alsa: saa7133[0] at 0xfdeff000 irq 16 registered as card 2
[   27.865929] WDT driver for Advantech single board computer initialising.
[   27.866052] advantechwdt: initialized. timeout=60 sec (nowayout=0)
[   43.082006] EXT4-fs (sdc2): re-mounted. Opts: errors=remount-ro
[   43.115247] device label Aux devid 1 transid 11141 /dev/sda1
[   43.115501] btrfs: use compression
[   51.973583] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   62.370110] Bluetooth: L2CAP ver 2.14
[   62.370114] Bluetooth: L2CAP socket layer initialized
[   62.682523] eth0: no IPv6 routers present
[   62.736481] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   62.736485] Bluetooth: BNEP filters: protocol multicast
[   62.745625] ppdev: user-space parallel port driver
[   62.790357] Bridge firewalling registered
[   63.458808] Bluetooth: SCO (Voice Link) ver 0.6
[   63.458812] Bluetooth: SCO socket layer initialized
[   63.818480] Bluetooth: RFCOMM TTY layer initialized
[   63.818486] Bluetooth: RFCOMM socket layer initialized
[   63.818488] Bluetooth: RFCOMM ver 1.11
[  137.019282] device label Storage devid 1 transid 25 /dev/sdd1
[  137.027223] btrfs: use compression
[  155.187575] btrfs csum failed ino 259 off 65536000 csum 1503146862 private 2016402431
[  155.187644] btrfs csum failed ino 259 off 65540096 csum 1401145579 private 364146580
[  155.187670] btrfs csum failed ino 259 off 65544192 csum 3221800731 private 3729418983
[  155.187695] btrfs csum failed ino 259 off 65548288 csum 1082349860 private 132340568
[  155.189369] btrfs csum failed ino 259 off 65536000 csum 1503146862 private 2016402431
[  155.189535] btrfs csum failed ino 259 off 65540096 csum 1401145579 private 364146580
[  155.189555] btrfs csum failed ino 259 off 65544192 csum 3221800731 private 3729418983
[  155.189574] btrfs csum failed ino 259 off 65548288 csum 1082349860 private 132340568
[  155.189632] btrfs csum failed ino 259 off 65536000 csum 1503146862 private 2016402431
[  155.192683] btrfs csum failed ino 259 off 65536000 csum 1503146862 private 2016402431
[  195.716215] bio too big device sdd1 (512 > 256)
[  195.716755] bio too big device sdd1 (1024 > 256)
[  195.718439] bio too big device sdd1 (1024 > 256)
[  195.722188] bio too big device sdd1 (1024 > 256)
[  195.724734] bio too big device sdd1 (1024 > 256)
[  195.735975] bio too big device sdd1 (1024 > 256)
[  195.738620] bio too big device sdd1 (1024 > 256)
[  195.741152] bio too big device sdd1 (1024 > 256)
[  195.743714] bio too big device sdd1 (1024 > 256)
[  195.746238] bio too big device sdd1 (1024 > 256)
[  195.764504] bio too big device sdd1 (1024 > 256)
[  195.767117] bio too big device sdd1 (1024 > 256)
[  195.769660] bio too big device sdd1 (1024 > 256)
[  195.782349] bio too big device sdd1 (1024 > 256)
[  195.785027] bio too big device sdd1 (1024 > 256)
[  195.787658] bio too big device sdd1 (1024 > 256)
[  195.790208] bio too big device sdd1 (1024 > 256)
[  195.804685] bio too big device sdd1 (1024 > 256)
[  195.807238] bio too big device sdd1 (1024 > 256)
[  195.809797] bio too big device sdd1 (1024 > 256)
[  195.820165] bio too big device sdd1 (1024 > 256)
[  195.843344] bio too big device sdd1 (1024 > 256)
[  195.843351] bio too big device sdd1 (1024 > 256)
[  195.843355] bio too big device sdd1 (1024 > 256)
[  195.843363] bio too big device sdd1 (1024 > 256)
[  195.843366] bio too big device sdd1 (1024 > 256)
[  195.843369] bio too big device sdd1 (1024 > 256)
[  195.843372] bio too big device sdd1 (1024 > 256)
[  195.843375] bio too big device sdd1 (1024 > 256)
[  195.843377] bio too big device sdd1 (1024 > 256)
[  195.843380] bio too big device sdd1 (1024 > 256)
[  195.843383] bio too big device sdd1 (1024 > 256)
[  195.843386] bio too big device sdd1 (1024 > 256)
[  195.892785] bio too big device sdd1 (1024 > 256)
[  195.895340] bio too big device sdd1 (1024 > 256)
[  195.898274] bio too big device sdd1 (1024 > 256)
[  195.913794] bio too big device sdd1 (1024 > 256)
[  195.916514] bio too big device sdd1 (1024 > 256)
[  195.929364] bio too big device sdd1 (1024 > 256)
[  195.932354] bio too big device sdd1 (1024 > 256)
[  195.934954] bio too big device sdd1 (1024 > 256)
[  195.954566] bio too big device sdd1 (1024 > 256)
[  195.957108] bio too big device sdd1 (1024 > 256)
[  195.959651] bio too big device sdd1 (1024 > 256)
[  195.964815] bio too big device sdd1 (1024 > 256)
[  195.967469] bio too big device sdd1 (1024 > 256)
[  195.970077] bio too big device sdd1 (1024 > 256)
[  195.972707] bio too big device sdd1 (1024 > 256)
[  195.975250] bio too big device sdd1 (1024 > 256)
[  195.977813] bio too big device sdd1 (1024 > 256)
[  195.989340] bio too big device sdd1 (1024 > 256)
[  195.991843] bio too big device sdd1 (1024 > 256)
[  195.994634] bio too big device sdd1 (1024 > 256)
[  195.997192] bio too big device sdd1 (1024 > 256)
[  196.000085] bio too big device sdd1 (1024 > 256)
[  196.009700] bio too big device sdd1 (1024 > 256)
[  196.012201] bio too big device sdd1 (1024 > 256)
[  196.014801] bio too big device sdd1 (1024 > 256)
[  196.022532] bio too big device sdd1 (1024 > 256)
[  196.025493] bio too big device sdd1 (1024 > 256)
[  196.028112] bio too big device sdd1 (1024 > 256)
[  196.030721] bio too big device sdd1 (1024 > 256)
[  196.048740] bio too big device sdd1 (1024 > 256)
[  196.051451] bio too big device sdd1 (1024 > 256)
[  196.064320] bio too big device sdd1 (1024 > 256)
[  196.067248] bio too big device sdd1 (1024 > 256)
[  196.069888] bio too big device sdd1 (1024 > 256)
[  196.070829] bio too big device sdd1 (1024 > 256)
[  196.071686] bio too big device sdd1 (1024 > 256)
[  196.072614] bio too big device sdd1 (1024 > 256)
[  196.073475] bio too big device sdd1 (1024 > 256)
[  196.074267] bio too big device sdd1 (1024 > 256)
[  196.074276] bio too big device sdd1 (1024 > 256)
[  196.074284] bio too big device sdd1 (1024 > 256)
[  196.074296] bio too big device sdd1 (1024 > 256)
[  196.074304] bio too big device sdd1 (1024 > 256)
[  196.075139] bio too big device sdd1 (1024 > 256)
[  196.075320] bio too big device sdd1 (1024 > 256)
[  196.075336] bio too big device sdd1 (1024 > 256)
[  196.078119] bio too big device sdd1 (1024 > 256)
[  196.081543] bio too big device sdd1 (1024 > 256)
[  196.081551] bio too big device sdd1 (1024 > 256)
[  196.081559] bio too big device sdd1 (1024 > 256)
[  196.084140] bio too big device sdd1 (1024 > 256)
[  196.086611] bio too big device sdd1 (1024 > 256)
[  196.094254] bio too big device sdd1 (1024 > 256)
[  196.096786] bio too big device sdd1 (1024 > 256)
[  196.104077] bio too big device sdd1 (1024 > 256)
[  196.104938] bio too big device sdd1 (1024 > 256)
[  196.105739] bio too big device sdd1 (1024 > 256)
[  196.106573] bio too big device sdd1 (1024 > 256)
[  196.107401] bio too big device sdd1 (1024 > 256)
[  196.107409] bio too big device sdd1 (1024 > 256)
[  196.107417] bio too big device sdd1 (1024 > 256)
[  196.108220] bio too big device sdd1 (1024 > 256)
[  196.109043] bio too big device sdd1 (1024 > 256)
[  196.111604] bio too big device sdd1 (1024 > 256)
[  196.111613] bio too big device sdd1 (1024 > 256)
[  196.111620] bio too big device sdd1 (1024 > 256)
[  196.112437] bio too big device sdd1 (1024 > 256)
[  196.113266] bio too big device sdd1 (1024 > 256)
[  196.113274] bio too big device sdd1 (1024 > 256)
[  196.113282] bio too big device sdd1 (1024 > 256)
[  196.113293] bio too big device sdd1 (1024 > 256)
[  196.119095] bio too big device sdd1 (1024 > 256)
[  196.120900] bio too big device sdd1 (1024 > 256)
[  196.129662] bio too big device sdd1 (1024 > 256)
[  196.132550] bio too big device sdd1 (1024 > 256)
[  196.135115] bio too big device sdd1 (1024 > 256)
[  196.142616] bio too big device sdd1 (1024 > 256)
[  196.145482] bio too big device sdd1 (1024 > 256)
[  196.148167] bio too big device sdd1 (1024 > 256)
[  196.156160] bio too big device sdd1 (1024 > 256)
[  196.158623] bio too big device sdd1 (1024 > 256)
[  196.161129] bio too big device sdd1 (1024 > 256)
[  196.192998] bio too big device sdd1 (1024 > 256)
[  196.193008] bio too big device sdd1 (1024 > 256)
[  196.193012] bio too big device sdd1 (1024 > 256)
[  196.193016] bio too big device sdd1 (1024 > 256)
[  196.193019] bio too big device sdd1 (1024 > 256)
[  196.193025] bio too big device sdd1 (1024 > 256)
[  196.193028] bio too big device sdd1 (1024 > 256)
[  196.193030] bio too big device sdd1 (1024 > 256)
[  196.193033] bio too big device sdd1 (1024 > 256)
[  196.193036] bio too big device sdd1 (1024 > 256)
[  196.193039] bio too big device sdd1 (1024 > 256)
[  196.193041] bio too big device sdd1 (1024 > 256)
[  196.193044] bio too big device sdd1 (1024 > 256)
[  196.193047] bio too big device sdd1 (1024 > 256)
[  196.193049] bio too big device sdd1 (1024 > 256)
[  196.193052] bio too big device sdd1 (1024 > 256)
[  196.193055] bio too big device sdd1 (1024 > 256)
[  196.193057] bio too big device sdd1 (1024 > 256)
[  196.193060] bio too big device sdd1 (1024 > 256)
[  196.193063] bio too big device sdd1 (1024 > 256)
[  196.193065] bio too big device sdd1 (1024 > 256)
[  196.193068] bio too big device sdd1 (1024 > 256)
[  196.193071] bio too big device sdd1 (1024 > 256)
[  196.193074] bio too big device sdd1 (1024 > 256)
[  196.193076] bio too big device sdd1 (1024 > 256)
[  196.193079] bio too big device sdd1 (1024 > 256)
[  196.193082] bio too big device sdd1 (1024 > 256)
[  196.193085] bio too big device sdd1 (1024 > 256)
[  196.193087] bio too big device sdd1 (1024 > 256)
[  196.193090] bio too big device sdd1 (1024 > 256)
[  196.193092] bio too big device sdd1 (1024 > 256)
[  196.193095] bio too big device sdd1 (1024 > 256)
[  196.193098] bio too big device sdd1 (1024 > 256)
[  196.193100] bio too big device sdd1 (1024 > 256)
[  196.193103] bio too big device sdd1 (1024 > 256)
[  196.193106] bio too big device sdd1 (1024 > 256)
[  196.193108] bio too big device sdd1 (1024 > 256)
[  196.193111] bio too big device sdd1 (1024 > 256)
[  196.193114] bio too big device sdd1 (1024 > 256)
[  196.193116] bio too big device sdd1 (1024 > 256)
[  196.193119] bio too big device sdd1 (1024 > 256)
[  196.193122] bio too big device sdd1 (1024 > 256)
[  196.193124] bio too big device sdd1 (1024 > 256)
[  196.193127] bio too big device sdd1 (1024 > 256)
[  196.193130] bio too big device sdd1 (1024 > 256)
[  196.193132] bio too big device sdd1 (1024 > 256)
[  196.193135] bio too big device sdd1 (1024 > 256)
[  196.193138] bio too big device sdd1 (1024 > 256)
[  196.241834] bio too big device sdd1 (1024 > 256)
[  196.243552] bio too big device sdd1 (1024 > 256)
[  196.245235] bio too big device sdd1 (1024 > 256)
[  196.254589] bio too big device sdd1 (1024 > 256)
[  196.257100] bio too big device sdd1 (1024 > 256)
[  196.259582] bio too big device sdd1 (1024 > 256)
[  196.262114] bio too big device sdd1 (1024 > 256)
[  196.270580] bio too big device sdd1 (1024 > 256)
[  196.273838] bio too big device sdd1 (1024 > 256)
[  196.278150] bio too big device sdd1 (1024 > 256)
[  196.278168] bio too big device sdd1 (1024 > 256)
[  196.278176] bio too big device sdd1 (1024 > 256)
[  196.278186] bio too big device sdd1 (1024 > 256)
[  196.278194] bio too big device sdd1 (1024 > 256)
[  196.279039] bio too big device sdd1 (1024 > 256)
[  196.279785] bio too big device sdd1 (1024 > 256)
[  196.280629] bio too big device sdd1 (1024 > 256)
[  196.281483] bio too big device sdd1 (1024 > 256)
[  196.281787] bio too big device sdd1 (1024 > 256)
[  196.283746] bio too big device sdd1 (1024 > 256)
[  196.283760] bio too big device sdd1 (1024 > 256)
[  196.283768] bio too big device sdd1 (1024 > 256)
[  196.283776] bio too big device sdd1 (1024 > 256)
[  196.283784] bio too big device sdd1 (1024 > 256)
[  196.283792] bio too big device sdd1 (1024 > 256)
[  196.283800] bio too big device sdd1 (1024 > 256)
[  196.283807] bio too big device sdd1 (1024 > 256)
[  196.283815] bio too big device sdd1 (1024 > 256)
[  196.283822] bio too big device sdd1 (1024 > 256)
[  196.283829] bio too big device sdd1 (1024 > 256)
[  196.283837] bio too big device sdd1 (1024 > 256)
[  196.283845] bio too big device sdd1 (1024 > 256)
[  196.283852] bio too big device sdd1 (1024 > 256)
[  196.283860] bio too big device sdd1 (1024 > 256)
[  196.283867] bio too big device sdd1 (1024 > 256)
[  196.283874] bio too big device sdd1 (1024 > 256)
[  196.283882] bio too big device sdd1 (1024 > 256)
[  196.283889] bio too big device sdd1 (1024 > 256)
[  196.283897] bio too big device sdd1 (1024 > 256)
[  196.283904] bio too big device sdd1 (1024 > 256)
[  196.283913] bio too big device sdd1 (1024 > 256)
[  196.312827] bio too big device sdd1 (1024 > 256)
[  196.312833] bio too big device sdd1 (1024 > 256)
[  196.312836] bio too big device sdd1 (1024 > 256)
[  196.312839] bio too big device sdd1 (1024 > 256)
[  196.312842] bio too big device sdd1 (1024 > 256)
[  196.312845] bio too big device sdd1 (1024 > 256)
[  196.312847] bio too big device sdd1 (1024 > 256)
[  196.312850] bio too big device sdd1 (1024 > 256)
[  196.312853] bio too big device sdd1 (1024 > 256)
[  196.312856] bio too big device sdd1 (1024 > 256)
[  196.312859] bio too big device sdd1 (1024 > 256)
[  196.312861] bio too big device sdd1 (1024 > 256)
[  196.312864] bio too big device sdd1 (1024 > 256)
[  196.312867] bio too big device sdd1 (1024 > 256)
[  196.312870] bio too big device sdd1 (1024 > 256)
[  196.312873] bio too big device sdd1 (1024 > 256)
[  196.312876] bio too big device sdd1 (1024 > 256)
[  196.312878] bio too big device sdd1 (1024 > 256)
[  196.312881] bio too big device sdd1 (1024 > 256)
[  196.312884] bio too big device sdd1 (1024 > 256)
[  196.312887] bio too big device sdd1 (1024 > 256)
[  196.312889] bio too big device sdd1 (1024 > 256)
[  196.312892] bio too big device sdd1 (1024 > 256)
[  196.312895] bio too big device sdd1 (1024 > 256)
[  196.312898] bio too big device sdd1 (1024 > 256)
[  196.312900] bio too big device sdd1 (1024 > 256)
[  196.312903] bio too big device sdd1 (1024 > 256)
[  196.312906] bio too big device sdd1 (1024 > 256)
[  196.312909] bio too big device sdd1 (1024 > 256)
[  196.312912] bio too big device sdd1 (1024 > 256)
[  196.312914] bio too big device sdd1 (1024 > 256)
[  196.312917] bio too big device sdd1 (1024 > 256)
[  196.312920] bio too big device sdd1 (1024 > 256)
[  196.312923] bio too big device sdd1 (1024 > 256)
[  196.312926] bio too big device sdd1 (1024 > 256)
[  196.312929] bio too big device sdd1 (1024 > 256)
[  196.312931] bio too big device sdd1 (1024 > 256)
[  196.312934] bio too big device sdd1 (1024 > 256)
[  196.312937] bio too big device sdd1 (1024 > 256)
[  196.312940] bio too big device sdd1 (1024 > 256)
[  196.312942] bio too big device sdd1 (1024 > 256)
[  196.312945] bio too big device sdd1 (1024 > 256)
[  196.312948] bio too big device sdd1 (1024 > 256)
[  196.312951] bio too big device sdd1 (1024 > 256)
[  196.312954] bio too big device sdd1 (1024 > 256)
[  196.312956] bio too big device sdd1 (1024 > 256)
[  196.312959] bio too big device sdd1 (1024 > 256)
[  196.312962] bio too big device sdd1 (1024 > 256)
[  196.398542] bio too big device sdd1 (1024 > 256)
[  196.401119] bio too big device sdd1 (1024 > 256)
[  196.403659] bio too big device sdd1 (1024 > 256)
[  196.406287] bio too big device sdd1 (1024 > 256)
[  196.408874] bio too big device sdd1 (1024 > 256)
[  196.411434] bio too big device sdd1 (1024 > 256)
[  196.444706] bio too big device sdd1 (1024 > 256)
[  196.447275] bio too big device sdd1 (1024 > 256)
[  196.449917] bio too big device sdd1 (1024 > 256)
[  196.452460] bio too big device sdd1 (1024 > 256)
[  196.455049] bio too big device sdd1 (1024 > 256)
[  196.457599] bio too big device sdd1 (1024 > 256)
[  196.460156] bio too big device sdd1 (1024 > 256)
[  196.462764] bio too big device sdd1 (1024 > 256)
[  196.465581] bio too big device sdd1 (1024 > 256)
[  196.468136] bio too big device sdd1 (1024 > 256)
[  196.468986] bio too big device sdd1 (1024 > 256)
[  196.469849] bio too big device sdd1 (1024 > 256)
[  196.470717] bio too big device sdd1 (1024 > 256)
[  196.471640] bio too big device sdd1 (1024 > 256)
[  196.472558] bio too big device sdd1 (1024 > 256)
[  196.472567] bio too big device sdd1 (1024 > 256)
[  196.472576] bio too big device sdd1 (1024 > 256)
[  196.473392] bio too big device sdd1 (1024 > 256)
[  196.474247] bio too big device sdd1 (1024 > 256)
[  196.475113] bio too big device sdd1 (1024 > 256)
[  196.477684] bio too big device sdd1 (1024 > 256)
[  196.477692] bio too big device sdd1 (1024 > 256)
[  196.477700] bio too big device sdd1 (1024 > 256)
[  196.480347] bio too big device sdd1 (1024 > 256)
[  196.480356] bio too big device sdd1 (1024 > 256)
[  196.480364] bio too big device sdd1 (1024 > 256)
[  196.480372] bio too big device sdd1 (1024 > 256)
[  196.480380] bio too big device sdd1 (1024 > 256)
[  196.481219] bio too big device sdd1 (1024 > 256)
[  196.482015] bio too big device sdd1 (1024 > 256)
[  196.482855] bio too big device sdd1 (1024 > 256)
[  196.485384] bio too big device sdd1 (1024 > 256)
[  196.485393] bio too big device sdd1 (1024 > 256)
[  196.485401] bio too big device sdd1 (1024 > 256)
[  196.486187] bio too big device sdd1 (1024 > 256)
[  196.486195] bio too big device sdd1 (1024 > 256)
[  196.486203] bio too big device sdd1 (1024 > 256)
[  196.486211] bio too big device sdd1 (1024 > 256)
[  196.486218] bio too big device sdd1 (1024 > 256)
[  196.486226] bio too big device sdd1 (1024 > 256)
[  196.491203] bio too big device sdd1 (1024 > 256)
[  196.491213] bio too big device sdd1 (1024 > 256)
[  196.492917] bio too big device sdd1 (1024 > 256)
[  196.495417] bio too big device sdd1 (1024 > 256)
[  196.497881] bio too big device sdd1 (1024 > 256)
[  196.505925] bio too big device sdd1 (1024 > 256)
[  196.508445] bio too big device sdd1 (1024 > 256)
[  196.511027] bio too big device sdd1 (1024 > 256)
[  196.520037] bio too big device sdd1 (1024 > 256)
[  196.522729] bio too big device sdd1 (1024 > 256)
[  196.525282] bio too big device sdd1 (1024 > 256)
[  196.527836] bio too big device sdd1 (1024 > 256)
[  196.530330] bio too big device sdd1 (1024 > 256)
[  196.539649] bio too big device sdd1 (1024 > 256)
[  196.542191] bio too big device sdd1 (1024 > 256)
[  196.553353] bio too big device sdd1 (1024 > 256)
[  196.553359] bio too big device sdd1 (1024 > 256)
[  196.553362] bio too big device sdd1 (1024 > 256)
[  196.553368] bio too big device sdd1 (1024 > 256)
[  196.553370] bio too big device sdd1 (1024 > 256)
[  196.553374] bio too big device sdd1 (1024 > 256)
[  196.553377] bio too big device sdd1 (1024 > 256)
[  196.553380] bio too big device sdd1 (1024 > 256)
[  196.553382] bio too big device sdd1 (1024 > 256)
[  196.553385] bio too big device sdd1 (1024 > 256)
[  196.553388] bio too big device sdd1 (1024 > 256)
[  196.553391] bio too big device sdd1 (1024 > 256)
[  196.553393] bio too big device sdd1 (1024 > 256)
[  196.553396] bio too big device sdd1 (1024 > 256)
[  196.553399] bio too big device sdd1 (1024 > 256)
[  196.553401] bio too big device sdd1 (1024 > 256)
[  196.553404] bio too big device sdd1 (1024 > 256)
[  196.553407] bio too big device sdd1 (704 > 256)
[  196.553409] bio too big device sdd1 (1024 > 256)
[  196.553412] bio too big device sdd1 (1024 > 256)
[  196.553415] bio too big device sdd1 (1024 > 256)
[  196.553418] bio too big device sdd1 (1024 > 256)
[  196.553421] bio too big device sdd1 (1024 > 256)
[  196.553423] bio too big device sdd1 (1024 > 256)
[  196.553426] bio too big device sdd1 (1024 > 256)
[  196.553429] bio too big device sdd1 (1024 > 256)
[  196.553432] bio too big device sdd1 (1024 > 256)
[  196.553434] bio too big device sdd1 (1024 > 256)
[  196.553437] bio too big device sdd1 (1024 > 256)
[  196.553440] bio too big device sdd1 (1024 > 256)
[  196.553443] bio too big device sdd1 (1024 > 256)
[  196.553445] bio too big device sdd1 (1024 > 256)
[  196.553448] bio too big device sdd1 (1024 > 256)
[  196.553451] bio too big device sdd1 (1024 > 256)
[  196.553454] bio too big device sdd1 (1024 > 256)
[  196.553456] bio too big device sdd1 (1024 > 256)
[  196.553459] bio too big device sdd1 (1024 > 256)
[  196.583237] bio too big device sdd1 (1024 > 256)
[  196.585108] bio too big device sdd1 (1024 > 256)
[  196.586916] bio too big device sdd1 (1024 > 256)
[  196.593905] bio too big device sdd1 (1024 > 256)
[  196.595737] bio too big device sdd1 (1024 > 256)
[  196.597553] bio too big device sdd1 (1024 > 256)
[  196.609814] bio too big device sdd1 (1024 > 256)
[  196.611646] bio too big device sdd1 (1024 > 256)
[  196.613492] bio too big device sdd1 (1024 > 256)
[  196.615339] bio too big device sdd1 (1024 > 256)
[  196.617313] bio too big device sdd1 (1024 > 256)
[  196.619132] bio too big device sdd1 (1024 > 256)
[  196.620958] bio too big device sdd1 (1024 > 256)
[  196.629151] bio too big device sdd1 (1024 > 256)
[  196.629298] bio too big device sdd1 (1024 > 256)
[  196.629441] bio too big device sdd1 (1024 > 256)
[  196.629580] bio too big device sdd1 (1024 > 256)
[  196.629716] bio too big device sdd1 (1024 > 256)
[  196.629855] bio too big device sdd1 (1024 > 256)
[  196.629993] bio too big device sdd1 (1024 > 256)
[  196.630132] bio too big device sdd1 (1024 > 256)
[  196.630270] bio too big device sdd1 (1024 > 256)
[  196.630405] bio too big device sdd1 (1024 > 256)
[  196.630543] bio too big device sdd1 (1024 > 256)
[  196.630672] bio too big device sdd1 (1024 > 256)
[  196.630800] bio too big device sdd1 (1024 > 256)
[  196.630928] bio too big device sdd1 (1024 > 256)
[  196.631056] bio too big device sdd1 (1024 > 256)
[  196.631184] bio too big device sdd1 (1024 > 256)
[  196.631315] bio too big device sdd1 (1024 > 256)
[  196.631443] bio too big device sdd1 (1024 > 256)
[  196.631572] bio too big device sdd1 (1024 > 256)
[  196.631701] bio too big device sdd1 (1024 > 256)
[  196.632238] bio too big device sdd1 (1024 > 256)
[  196.632376] bio too big device sdd1 (1024 > 256)
[  196.632540] bio too big device sdd1 (1024 > 256)
[  196.632669] bio too big device sdd1 (1024 > 256)
[  196.632798] bio too big device sdd1 (1024 > 256)
[  196.632926] bio too big device sdd1 (1024 > 256)
[  196.633053] bio too big device sdd1 (1024 > 256)
[  196.633188] bio too big device sdd1 (1024 > 256)
[  196.633314] bio too big device sdd1 (1024 > 256)
[  196.633441] bio too big device sdd1 (1024 > 256)
[  196.633569] bio too big device sdd1 (1024 > 256)
[  196.633700] bio too big device sdd1 (1024 > 256)
[  196.633825] bio too big device sdd1 (1024 > 256)
[  196.635637] bio too big device sdd1 (1024 > 256)
[  196.637448] bio too big device sdd1 (1024 > 256)
[  196.648047] bio too big device sdd1 (1024 > 256)
[  196.650021] bio too big device sdd1 (1024 > 256)
[  196.651833] bio too big device sdd1 (1024 > 256)
[  196.663813] bio too big device sdd1 (1024 > 256)
[  196.663821] bio too big device sdd1 (1024 > 256)
[  196.663824] bio too big device sdd1 (1024 > 256)
[  196.663828] bio too big device sdd1 (1024 > 256)
[  196.663831] bio too big device sdd1 (1024 > 256)
[  196.663835] bio too big device sdd1 (1024 > 256)
[  196.679084] bio too big device sdd1 (1024 > 256)
[  196.680941] bio too big device sdd1 (1024 > 256)
[  196.682824] bio too big device sdd1 (1024 > 256)
[  196.684746] bio too big device sdd1 (1024 > 256)
[  196.686551] bio too big device sdd1 (1024 > 256)
[  196.694892] bio too big device sdd1 (1024 > 256)
[  196.695029] bio too big device sdd1 (1024 > 256)
[  196.695164] bio too big device sdd1 (1024 > 256)
[  196.695288] bio too big device sdd1 (1024 > 256)
[  196.695410] bio too big device sdd1 (1024 > 256)
[  196.695533] bio too big device sdd1 (1024 > 256)
[  196.695657] bio too big device sdd1 (1024 > 256)
[  196.695782] bio too big device sdd1 (1024 > 256)
[  196.695899] bio too big device sdd1 (1024 > 256)
[  196.696064] bio too big device sdd1 (1024 > 256)
[  196.696181] bio too big device sdd1 (1024 > 256)
[  196.696297] bio too big device sdd1 (1024 > 256)
[  196.696413] bio too big device sdd1 (1024 > 256)
[  196.696529] bio too big device sdd1 (1024 > 256)
[  196.696646] bio too big device sdd1 (1024 > 256)
[  196.696763] bio too big device sdd1 (1024 > 256)
[  196.696880] bio too big device sdd1 (1024 > 256)
[  196.696997] bio too big device sdd1 (1024 > 256)
[  196.697114] bio too big device sdd1 (1024 > 256)
[  196.697243] bio too big device sdd1 (1024 > 256)
[  196.697373] bio too big device sdd1 (1024 > 256)
[  196.697499] bio too big device sdd1 (1024 > 256)
[  196.697625] bio too big device sdd1 (1024 > 256)
[  196.697755] bio too big device sdd1 (1024 > 256)
[  196.697884] bio too big device sdd1 (1024 > 256)
[  196.698009] bio too big device sdd1 (1024 > 256)
[  196.698135] bio too big device sdd1 (1024 > 256)
[  196.698262] bio too big device sdd1 (1024 > 256)
[  196.698386] bio too big device sdd1 (1024 > 256)
[  196.698855] bio too big device sdd1 (1024 > 256)
[  196.698988] bio too big device sdd1 (1024 > 256)
[  196.699115] bio too big device sdd1 (1024 > 256)
[  196.700951] bio too big device sdd1 (1024 > 256)
[  196.702788] bio too big device sdd1 (1024 > 256)
[  196.704602] bio too big device sdd1 (1024 > 256)
[  196.706508] bio too big device sdd1 (1024 > 256)
[  196.708322] bio too big device sdd1 (1024 > 256)
[  196.715757] bio too big device sdd1 (1024 > 256)
[  196.717686] bio too big device sdd1 (1024 > 256)
[  196.719499] bio too big device sdd1 (1024 > 256)
[  196.729564] bio too big device sdd1 (1024 > 256)
[  196.731379] bio too big device sdd1 (1024 > 256)
[  196.733514] bio too big device sdd1 (1024 > 256)
[  196.735337] bio too big device sdd1 (1024 > 256)
[  196.737159] bio too big device sdd1 (1024 > 256)
[  196.745382] bio too big device sdd1 (1024 > 256)
[  196.747184] bio too big device sdd1 (1024 > 256)
[  196.755145] bio too big device sdd1 (1024 > 256)
[  196.755281] bio too big device sdd1 (1024 > 256)
[  196.755408] bio too big device sdd1 (1024 > 256)
[  196.755530] bio too big device sdd1 (1024 > 256)
[  196.755654] bio too big device sdd1 (1024 > 256)
[  196.755771] bio too big device sdd1 (1024 > 256)
[  196.755889] bio too big device sdd1 (1024 > 256)
[  196.756005] bio too big device sdd1 (1024 > 256)
[  196.756124] bio too big device sdd1 (1024 > 256)
[  196.756242] bio too big device sdd1 (1024 > 256)
[  196.756358] bio too big device sdd1 (1024 > 256)
[  196.756474] bio too big device sdd1 (1024 > 256)
[  196.756590] bio too big device sdd1 (1024 > 256)
[  196.756705] bio too big device sdd1 (1024 > 256)
[  196.756820] bio too big device sdd1 (1024 > 256)
[  196.756936] bio too big device sdd1 (1024 > 256)
[  196.757052] bio too big device sdd1 (1024 > 256)
[  196.757168] bio too big device sdd1 (1024 > 256)
[  196.757286] bio too big device sdd1 (1024 > 256)
[  196.757409] bio too big device sdd1 (1024 > 256)
[  196.757525] bio too big device sdd1 (1024 > 256)
[  196.757646] bio too big device sdd1 (1024 > 256)
[  196.757766] bio too big device sdd1 (1024 > 256)
[  196.757887] bio too big device sdd1 (1024 > 256)
[  196.758007] bio too big device sdd1 (1024 > 256)
[  196.758128] bio too big device sdd1 (1024 > 256)
[  196.758251] bio too big device sdd1 (1024 > 256)
[  196.758372] bio too big device sdd1 (1024 > 256)
[  196.758493] bio too big device sdd1 (1024 > 256)
[  196.758614] bio too big device sdd1 (1024 > 256)
[  196.758734] bio too big device sdd1 (1024 > 256)
[  196.758856] bio too big device sdd1 (1024 > 256)
[  196.758979] bio too big device sdd1 (1024 > 256)
[  196.760858] bio too big device sdd1 (1024 > 256)
[  196.762690] bio too big device sdd1 (1024 > 256)
[  196.773014] bio too big device sdd1 (1024 > 256)
[  196.773023] bio too big device sdd1 (1024 > 256)
[  196.773026] bio too big device sdd1 (1024 > 256)
[  196.773030] bio too big device sdd1 (1024 > 256)
[  196.773033] bio too big device sdd1 (1024 > 256)
[  196.788541] bio too big device sdd1 (1024 > 256)
[  196.790356] bio too big device sdd1 (1024 > 256)
[  196.792227] bio too big device sdd1 (1024 > 256)
[  196.794106] bio too big device sdd1 (1024 > 256)
[  196.795938] bio too big device sdd1 (1024 > 256)
[  196.806002] bio too big device sdd1 (1024 > 256)
[  196.807814] bio too big device sdd1 (1024 > 256)
[  196.809685] bio too big device sdd1 (1024 > 256)
[  196.811490] bio too big device sdd1 (1024 > 256)
[  196.811616] bio too big device sdd1 (1024 > 256)
[  196.811742] bio too big device sdd1 (1024 > 256)
[  196.811867] bio too big device sdd1 (1024 > 256)
[  196.811991] bio too big device sdd1 (1024 > 256)
[  196.812118] bio too big device sdd1 (1024 > 256)
[  196.812245] bio too big device sdd1 (1024 > 256)
[  196.812363] bio too big device sdd1 (1024 > 256)
[  196.812491] bio too big device sdd1 (1024 > 256)
[  196.812638] bio too big device sdd1 (1024 > 256)
[  196.812762] bio too big device sdd1 (1024 > 256)
[  196.812888] bio too big device sdd1 (1024 > 256)
[  196.813009] bio too big device sdd1 (1024 > 256)
[  196.813129] bio too big device sdd1 (1024 > 256)
[  196.813250] bio too big device sdd1 (1024 > 256)
[  196.813370] bio too big device sdd1 (1024 > 256)
[  196.813491] bio too big device sdd1 (1024 > 256)
[  196.813616] bio too big device sdd1 (1024 > 256)
[  196.813740] bio too big device sdd1 (1024 > 256)
[  196.813868] bio too big device sdd1 (1024 > 256)
[  196.813992] bio too big device sdd1 (1024 > 256)
[  196.814117] bio too big device sdd1 (1024 > 256)
[  196.814241] bio too big device sdd1 (1024 > 256)
[  196.814380] bio too big device sdd1 (1024 > 256)
[  196.814504] bio too big device sdd1 (1024 > 256)
[  196.814628] bio too big device sdd1 (1024 > 256)
[  196.818334] bio too big device sdd1 (1024 > 256)
[  196.818484] bio too big device sdd1 (1024 > 256)
[  196.818614] bio too big device sdd1 (1024 > 256)
[  196.818750] bio too big device sdd1 (1024 > 256)
[  196.818888] bio too big device sdd1 (1024 > 256)
[  196.819017] bio too big device sdd1 (1024 > 256)
[  196.819145] bio too big device sdd1 (1024 > 256)
[  196.820962] bio too big device sdd1 (1024 > 256)
[  196.822886] bio too big device sdd1 (1024 > 256)
[  196.832351] bio too big device sdd1 (1024 > 256)
[  196.834216] bio too big device sdd1 (1024 > 256)
[  196.836040] bio too big device sdd1 (1024 > 256)
[  196.837876] bio too big device sdd1 (1024 > 256)
[  196.844879] bio too big device sdd1 (1024 > 256)
[  196.846714] bio too big device sdd1 (1024 > 256)
[  196.848536] bio too big device sdd1 (1024 > 256)
[  196.855573] bio too big device sdd1 (1024 > 256)
[  196.857456] bio too big device sdd1 (1024 > 256)
[  196.859272] bio too big device sdd1 (1024 > 256)
[  196.866198] bio too big device sdd1 (1024 > 256)
[  196.868053] bio too big device sdd1 (1024 > 256)
[  196.869877] bio too big device sdd1 (1024 > 256)
[  196.882598] bio too big device sdd1 (1024 > 256)
[  196.882748] bio too big device sdd1 (1024 > 256)
[  196.882891] bio too big device sdd1 (1024 > 256)
[  196.883032] bio too big device sdd1 (1024 > 256)
[  196.883170] bio too big device sdd1 (1024 > 256)
[  196.883310] bio too big device sdd1 (1024 > 256)
[  196.883561] bio too big device sdd1 (1024 > 256)
[  196.883701] bio too big device sdd1 (1024 > 256)
[  196.883840] bio too big device sdd1 (1024 > 256)
[  196.883976] bio too big device sdd1 (1024 > 256)
[  196.884112] bio too big device sdd1 (1024 > 256)
[  196.884252] bio too big device sdd1 (1024 > 256)
[  196.884381] bio too big device sdd1 (1024 > 256)
[  196.884519] bio too big device sdd1 (1024 > 256)
[  196.884645] bio too big device sdd1 (1024 > 256)
[  196.884771] bio too big device sdd1 (1024 > 256)
[  196.884897] bio too big device sdd1 (1024 > 256)
[  196.885024] bio too big device sdd1 (1024 > 256)
[  196.885151] bio too big device sdd1 (1024 > 256)
[  196.885276] bio too big device sdd1 (1024 > 256)
[  196.885402] bio too big device sdd1 (1024 > 256)
[  196.885529] bio too big device sdd1 (1024 > 256)
[  196.885655] bio too big device sdd1 (1024 > 256)
[  196.885780] bio too big device sdd1 (1024 > 256)
[  196.885909] bio too big device sdd1 (1024 > 256)
[  196.886047] bio too big device sdd1 (1024 > 256)
[  196.886185] bio too big device sdd1 (1024 > 256)
[  196.886326] bio too big device sdd1 (1024 > 256)
[  196.886462] bio too big device sdd1 (1024 > 256)
[  196.886600] bio too big device sdd1 (1024 > 256)
[  196.886739] bio too big device sdd1 (1024 > 256)
[  196.886876] bio too big device sdd1 (1024 > 256)
[  196.887014] bio too big device sdd1 (1024 > 256)
[  196.889013] bio too big device sdd1 (1024 > 256)
[  196.890833] bio too big device sdd1 (1024 > 256)
[  196.892666] bio too big device sdd1 (1024 > 256)
[  196.894507] bio too big device sdd1 (1024 > 256)
[  196.896336] bio too big device sdd1 (1024 > 256)
[  196.898165] bio too big device sdd1 (1024 > 256)
[  196.905817] bio too big device sdd1 (1024 > 256)
[  196.907639] bio too big device sdd1 (1024 > 256)
[  196.909461] bio too big device sdd1 (1024 > 256)
[  196.917755] bio too big device sdd1 (1024 > 256)
[  196.918856] bio too big device sdd1 (576 > 256)
[  219.331149] btrfs csum failed ino 260 off 27525120 csum 2873797665 private 2821269912
[  219.331338] btrfs csum failed ino 260 off 27525120 csum 2873797665 private 2821269912
[  220.973241] bio too big device sdd1 (1024 > 256)
[  220.973248] bio too big device sdd1 (1024 > 256)
[  220.973252] bio too big device sdd1 (1024 > 256)
[  220.973256] bio too big device sdd1 (1024 > 256)
[  220.973259] bio too big device sdd1 (1024 > 256)
[  220.973263] bio too big device sdd1 (1024 > 256)
[  220.973266] bio too big device sdd1 (1024 > 256)
[  220.973268] bio too big device sdd1 (1024 > 256)
[  220.973271] bio too big device sdd1 (1024 > 256)
[  220.973274] bio too big device sdd1 (1024 > 256)
[  220.973277] bio too big device sdd1 (1024 > 256)
[  220.973280] bio too big device sdd1 (1024 > 256)
[  220.973282] bio too big device sdd1 (1024 > 256)
[  220.973285] bio too big device sdd1 (1024 > 256)
[  220.987313] bio too big device sdd1 (1024 > 256)
[  220.989171] bio too big device sdd1 (1024 > 256)
[  220.991018] bio too big device sdd1 (1024 > 256)
[  220.991188] bio too big device sdd1 (1024 > 256)
[  220.991361] bio too big device sdd1 (1024 > 256)
[  220.991524] bio too big device sdd1 (1024 > 256)
[  220.991687] bio too big device sdd1 (1024 > 256)
[  220.991847] bio too big device sdd1 (1024 > 256)
[  220.992011] bio too big device sdd1 (1024 > 256)
[  220.992172] bio too big device sdd1 (1024 > 256)
[  220.992663] bio too big device sdd1 (1024 > 256)
[  220.992831] bio too big device sdd1 (1024 > 256)
[  221.021789] bio too big device sdd1 (1024 > 256)
[  221.023463] bio too big device sdd1 (1024 > 256)
[  221.044251] bio too big device sdd1 (1024 > 256)
[  221.044261] bio too big device sdd1 (1024 > 256)
[  221.044265] bio too big device sdd1 (1024 > 256)
[  221.044268] bio too big device sdd1 (1024 > 256)
[  221.044271] bio too big device sdd1 (1024 > 256)
[  221.044275] bio too big device sdd1 (1024 > 256)
[  221.045388] bio too big device sdd1 (1024 > 256)
[  221.047070] bio too big device sdd1 (1024 > 256)
[  221.048761] bio too big device sdd1 (1024 > 256)
[  221.060520] bio too big device sdd1 (1024 > 256)
[  221.062191] bio too big device sdd1 (1024 > 256)
[  221.063877] bio too big device sdd1 (1024 > 256)
[  221.065564] bio too big device sdd1 (1024 > 256)
[  221.067248] bio too big device sdd1 (1024 > 256)
[  221.067252] bio too big device sdd1 (1024 > 256)
[  221.067256] bio too big device sdd1 (1024 > 256)
[  221.067260] bio too big device sdd1 (1024 > 256)
[  221.067264] bio too big device sdd1 (1024 > 256)
[  221.067268] bio too big device sdd1 (1024 > 256)
[  221.067271] bio too big device sdd1 (1024 > 256)
[  221.067274] bio too big device sdd1 (1024 > 256)
[  221.067277] bio too big device sdd1 (1024 > 256)
[  221.067280] bio too big device sdd1 (1024 > 256)
[  221.067283] bio too big device sdd1 (1024 > 256)
[  221.067286] bio too big device sdd1 (1024 > 256)
[  221.067289] bio too big device sdd1 (1024 > 256)
[  221.067292] bio too big device sdd1 (1024 > 256)
[  221.067294] bio too big device sdd1 (1024 > 256)
[  221.067297] bio too big device sdd1 (1024 > 256)
[  221.067300] bio too big device sdd1 (1024 > 256)
[  221.067303] bio too big device sdd1 (1024 > 256)
[  221.067306] bio too big device sdd1 (1024 > 256)
[  221.067309] bio too big device sdd1 (1024 > 256)
[  221.067312] bio too big device sdd1 (1024 > 256)
[  221.067315] bio too big device sdd1 (1024 > 256)
[  221.067318] bio too big device sdd1 (1024 > 256)
[  221.067320] bio too big device sdd1 (1024 > 256)
[  221.067323] bio too big device sdd1 (1024 > 256)
[  221.067326] bio too big device sdd1 (1024 > 256)
[  221.069394] bio too big device sdd1 (1024 > 256)
[  221.080729] bio too big device sdd1 (1024 > 256)
[  221.082421] bio too big device sdd1 (1024 > 256)
[  221.084107] bio too big device sdd1 (1024 > 256)
[  221.085916] bio too big device sdd1 (1024 > 256)
[  221.087732] bio too big device sdd1 (1024 > 256)
[  221.102989] bio too big device sdd1 (1024 > 256)
[  221.104688] bio too big device sdd1 (1024 > 256)
[  221.106387] bio too big device sdd1 (1024 > 256)
[  221.108078] bio too big device sdd1 (1024 > 256)
[  221.109772] bio too big device sdd1 (1024 > 256)
[  221.111481] bio too big device sdd1 (1024 > 256)
[  221.113173] bio too big device sdd1 (1024 > 256)
[  221.114873] bio too big device sdd1 (1024 > 256)
[  221.133358] bio too big device sdd1 (1024 > 256)
[  221.135060] bio too big device sdd1 (1024 > 256)
[  221.135074] bio too big device sdd1 (1024 > 256)
[  221.135083] bio too big device sdd1 (1024 > 256)
[  221.135293] bio too big device sdd1 (1024 > 256)
[  221.135481] bio too big device sdd1 (1024 > 256)
[  221.135492] bio too big device sdd1 (1024 > 256)
[  221.135501] bio too big device sdd1 (1024 > 256)
[  221.135717] bio too big device sdd1 (1024 > 256)
[  221.135909] bio too big device sdd1 (1024 > 256)
[  221.135920] bio too big device sdd1 (1024 > 256)
[  221.135929] bio too big device sdd1 (1024 > 256)
[  221.136119] bio too big device sdd1 (1024 > 256)
[  221.136289] bio too big device sdd1 (1024 > 256)
[  221.136300] bio too big device sdd1 (1024 > 256)
[  221.136308] bio too big device sdd1 (1024 > 256)
[  221.136508] bio too big device sdd1 (1024 > 256)
[  221.136693] bio too big device sdd1 (1024 > 256)
[  221.136703] bio too big device sdd1 (1024 > 256)
[  221.136712] bio too big device sdd1 (1024 > 256)
[  221.136909] bio too big device sdd1 (1024 > 256)
[  221.137085] bio too big device sdd1 (1024 > 256)
[  221.137096] bio too big device sdd1 (1024 > 256)
[  221.137104] bio too big device sdd1 (1024 > 256)
[  221.137305] bio too big device sdd1 (1024 > 256)
[  221.137488] bio too big device sdd1 (1024 > 256)
[  221.137498] bio too big device sdd1 (1024 > 256)
[  221.137507] bio too big device sdd1 (1024 > 256)
[  221.137713] bio too big device sdd1 (1024 > 256)
[  221.137909] bio too big device sdd1 (1024 > 256)
[  221.137920] bio too big device sdd1 (1024 > 256)
[  221.137928] bio too big device sdd1 (1024 > 256)
[  221.138144] bio too big device sdd1 (1024 > 256)
[  221.138436] bio too big device sdd1 (1024 > 256)
[  221.140152] bio too big device sdd1 (1024 > 256)
[  221.141847] bio too big device sdd1 (1024 > 256)
[  221.143539] bio too big device sdd1 (1024 > 256)
[  221.145238] bio too big device sdd1 (1024 > 256)
[  221.146927] bio too big device sdd1 (1024 > 256)
[  221.148617] bio too big device sdd1 (1024 > 256)
[  221.150325] bio too big device sdd1 (1024 > 256)
[  221.152014] bio too big device sdd1 (1024 > 256)
[  221.162095] bio too big device sdd1 (1024 > 256)
[  221.163895] bio too big device sdd1 (1024 > 256)
[  221.165703] bio too big device sdd1 (1024 > 256)
[  221.167507] bio too big device sdd1 (1024 > 256)
[  221.169307] bio too big device sdd1 (1024 > 256)
[  221.182925] bio too big device sdd1 (1024 > 256)
[  221.184746] bio too big device sdd1 (1024 > 256)
[  221.186557] bio too big device sdd1 (1024 > 256)
[  221.186688] bio too big device sdd1 (1024 > 256)
[  221.186816] bio too big device sdd1 (1024 > 256)
[  221.186945] bio too big device sdd1 (1024 > 256)
[  221.187073] bio too big device sdd1 (1024 > 256)
[  221.187199] bio too big device sdd1 (1024 > 256)
[  221.187333] bio too big device sdd1 (1024 > 256)
[  221.187456] bio too big device sdd1 (1024 > 256)
[  221.187576] bio too big device sdd1 (1024 > 256)
[  221.187699] bio too big device sdd1 (1024 > 256)
[  221.187822] bio too big device sdd1 (1024 > 256)
[  221.187947] bio too big device sdd1 (1024 > 256)
[  221.188071] bio too big device sdd1 (1024 > 256)
[  221.188192] bio too big device sdd1 (1024 > 256)
[  221.188320] bio too big device sdd1 (1024 > 256)
[  221.188449] bio too big device sdd1 (1024 > 256)
[  221.188576] bio too big device sdd1 (1024 > 256)
[  221.188700] bio too big device sdd1 (1024 > 256)
[  221.188817] bio too big device sdd1 (1024 > 256)
[  221.188932] bio too big device sdd1 (1024 > 256)
[  221.189064] bio too big device sdd1 (1024 > 256)
[  221.189195] bio too big device sdd1 (1024 > 256)
[  221.189324] bio too big device sdd1 (1024 > 256)
[  221.189451] bio too big device sdd1 (1024 > 256)
[  221.189579] bio too big device sdd1 (1024 > 256)
[  221.189706] bio too big device sdd1 (1024 > 256)
[  221.189833] bio too big device sdd1 (1024 > 256)
[  221.189962] bio too big device sdd1 (1024 > 256)
[  221.190118] bio too big device sdd1 (1024 > 256)
[  221.190260] bio too big device sdd1 (1024 > 256)
[  221.190398] bio too big device sdd1 (1024 > 256)
[  221.190535] bio too big device sdd1 (1024 > 256)
[  221.190675] bio too big device sdd1 (1024 > 256)
[  221.192510] bio too big device sdd1 (1024 > 256)
[  221.194348] bio too big device sdd1 (1024 > 256)
[  221.196185] bio too big device sdd1 (1024 > 256)
[  221.198007] bio too big device sdd1 (1024 > 256)
[  221.213316] bio too big device sdd1 (1024 > 256)
[  221.215150] bio too big device sdd1 (1024 > 256)
[  221.216982] bio too big device sdd1 (1024 > 256)
[  221.218800] bio too big device sdd1 (1024 > 256)
[  221.220635] bio too big device sdd1 (1024 > 256)
[  221.222442] bio too big device sdd1 (1024 > 256)
[  221.224263] bio too big device sdd1 (1024 > 256)
[  221.226100] bio too big device sdd1 (1024 > 256)
[  221.228050] bio too big device sdd1 (1024 > 256)
[  221.229890] bio too big device sdd1 (1024 > 256)
[  221.231750] bio too big device sdd1 (1024 > 256)
[  221.233586] bio too big device sdd1 (1024 > 256)
[  221.233733] bio too big device sdd1 (1024 > 256)
[  221.233875] bio too big device sdd1 (1024 > 256)
[  221.234019] bio too big device sdd1 (1024 > 256)
[  221.234163] bio too big device sdd1 (1024 > 256)
[  221.234298] bio too big device sdd1 (1024 > 256)
[  221.234427] bio too big device sdd1 (1024 > 256)
[  221.234555] bio too big device sdd1 (1024 > 256)
[  221.234685] bio too big device sdd1 (1024 > 256)
[  221.234813] bio too big device sdd1 (1024 > 256)
[  221.234940] bio too big device sdd1 (1024 > 256)
[  221.235070] bio too big device sdd1 (1024 > 256)
[  221.235199] bio too big device sdd1 (1024 > 256)
[  221.235327] bio too big device sdd1 (1024 > 256)
[  221.235455] bio too big device sdd1 (1024 > 256)

--------------020206090309020902070906--
