From: Bruce Guenter <bruce@untroubled.org>
Subject: Cross-subvolume link causes kernel BUG
Date: Mon, 8 Mar 2010 11:24:38 -0600
Message-ID: <20100308172438.GA5506@untroubled.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

While testing subvolumes in btrfs on 2.6.32.9, I hit a kernel BUG:

[  492.164012] kernel BUG at fs/btrfs/inode.c:4365!

The commands to reproduce this bug are as follows:

# mount -t btrfs /dev/sda5 /scratch
# btrfsctl -S subvol /scratch
# date > /scratch/date
# ln /scratch/date /scratch/subvol/

ln segfaults, and the bug above is found in dmesg.  Subsequent accesses
to the subvolume result in a D state hung process.  Full dmesg follows.
I first observed this on a Gentoo system and reproduced it on Ubuntu.
Both were running unpatched 2.6.32.9 kernels.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32.9 (administrator@lennier) (gcc version =
4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #1 SMP Mon Mar 8 00:49:35 CST 2010
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000005fff0000 (usable)
[    0.000000]  BIOS-e820: 000000005fff0000 - 000000005fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000005fff3000 - 0000000060000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working aro=
und it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0x5fff0 max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 base 0040000000 mask FFE0000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000005fff0000 (usable)
[    0.000000]  modified: 000000005fff0000 - 000000005fff3000 (ACPI NVS)
[    0.000000]  modified: 000000005fff3000 - 0000000060000000 (ACPI data)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 00c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-15000
[    0.000000] ACPI: RSDP 000f76f0 00014 (v00 Nvidia)
[    0.000000] ACPI: RSDT 5fff3040 00038 (v01 Nvidia AWRDACPI 42302E31 AWRD=
 00000000)
[    0.000000] ACPI: FACP 5fff30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD=
 00000000)
[    0.000000] ACPI: DSDT 5fff3180 06264 (v01 NVIDIA AWRDACPI 00001000 MSFT=
 0100000E)
[    0.000000] ACPI: FACS 5fff0000 00040
[    0.000000] ACPI: SSDT 5fff9500 000D6 (v01 PTLTD  POWERNOW 00000001  LTP=
 00000001)
[    0.000000] ACPI: SRAT 5fff9640 00090 (v01 AMD    HAMMER   00000001 AMD =
 00000001)
[    0.000000] ACPI: MCFG 5fff9740 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD=
 00000000)
[    0.000000] ACPI: APIC 5fff9440 0007C (v01 Nvidia AWRDACPI 42302E31 AWRD=
 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 647MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00011000 - 00017f00
[    0.000000] (8 early reservations) =3D=3D> bootmem [0000000000 - 00377fe=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE =3D=3D> [000=
0001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00008474dc]    TEXT DATA BSS =3D=3D> [000=
0100000 - 00008474dc]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved =3D=3D> [000=
009f800 - 0000100000]
[    0.000000]   #5 [0000848000 - 000084b149]              BRK =3D=3D> [000=
0848000 - 000084b149]
[    0.000000]   #6 [0000010000 - 0000011000]          PGTABLE =3D=3D> [000=
0010000 - 0000011000]
[    0.000000]   #7 [0000011000 - 0000018000]          BOOTMAP =3D=3D> [000=
0011000 - 0000018000]
[    0.000000] found SMP MP-table at [c00f5680] f5680
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0005fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0005fff0
[    0.000000] On node 0 totalpages: 393087
[    0.000000] free_area_init_node: node 0, pgdat c07314c0, node_mem_map c1=
001200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1296 pages used for memmap
[    0.000000]   HighMem zone: 164578 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 1 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] Allocating PCI resources starting at 60000000 (gap: 60000000=
:80000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @c2000000 s34360 r0 d22984 u20=
97152
[    0.000000] pcpu-alloc: s34360 r0 d22984 u2097152 alloc=3D1*4194304
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 390015
[    0.000000] Kernel command line: root=3D/dev/sda4 ro text
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 7863680 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:0005fff0)
[    0.000000] Memory: 1542900k/1572800k available (4376k kernel code, 2840=
0k reserved, 2004k data, 440k init, 663496k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1e000 - 0xfffff000   ( 900 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc073c000 - 0xc07aa000   ( 440 kB)
[    0.000000]       .data : 0xc05462e8 - 0xc073b3a0   (2004 kB)
[    0.000000]       .text : 0xc0100000 - 0xc05462e8   (4376 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:512
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.293 MHz processor.
[    0.008007] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4020.58 BogoMIPS (lpj=3D8041172)
[    0.008099] Security Framework initialized
[    0.008143] SELinux:  Disabled at boot.
[    0.008186] Mount-cache hash table entries: 512
[    0.008389] Initializing cgroup subsys ns
[    0.008429] Initializing cgroup subsys cpuacct
[    0.008468] Initializing cgroup subsys memory
[    0.008509] Initializing cgroup subsys freezer
[    0.008564] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.008603] CPU: L2 Cache: 512K (64 bytes/line)
[    0.008651] Performance Events: AMD PMU driver.
[    0.008723] ... version:                0
[    0.008760] ... bit width:              48
[    0.008796] ... generic registers:      4
[    0.008832] ... value mask:             0000ffffffffffff
[    0.008870] ... max period:             00007fffffffffff
[    0.008907] ... fixed-purpose events:   0
[    0.008943] ... event mask:             000000000000000f
[    0.008983] Checking 'hlt' instruction... OK.
[    0.024698] SMP alternatives: switching to UP code
[    0.030486] ACPI: Core revision 20090903
[    0.042546] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D0 apic2=3D-1 pin2=3D=
-1
[    0.082273] CPU0: AMD Athlon(tm) 64 Processor 3200+ stepping 02
[    0.084001] Brought up 1 CPUs
[    0.084001] Total of 1 processors activated (4020.58 BogoMIPS).
[    0.084001] CPU0 attaching NULL sched-domain.
[    0.084001] Time: 16:39:29  Date: 03/08/10
[    0.084001] NET: Registered protocol family 16
[    0.084001] ACPI: bus type pci registered
[    0.084001] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.084001] PCI: MCFG area at e0000000 reserved in E820
[    0.084001] PCI: Using MMCONFIG for extended config space
[    0.084001] PCI: Using configuration type 1 for base access
[    0.084001] bio: create slab <bio-0> at 0
[    0.084001] ACPI: EC: Look up EC in DSDT
[    0.091433] ACPI: Interpreter enabled
[    0.091476] ACPI: (supports S0 S1 S3 S4 S5)
[    0.091695] ACPI: Using IOAPIC for interrupt routing
[    0.099708] ACPI: No dock devices found.
[    0.099846] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.099978] HPET not enabled in BIOS. You might try hpet=3Dforce boot op=
tion
[    0.100016] pci 0000:00:01.1: reg 10 io port: [0xe400-0xe41f]
[    0.100025] pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
[    0.100029] pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
[    0.100039] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.100078] pci 0000:00:01.1: PME# disabled
[    0.100131] pci 0000:00:02.0: reg 10 32bit mmio: [0xd2004000-0xd2004fff]
[    0.100147] pci 0000:00:02.0: supports D1 D2
[    0.100149] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.100188] pci 0000:00:02.0: PME# disabled
[    0.100240] pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
[    0.100260] pci 0000:00:02.1: supports D1 D2
[    0.100262] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.100301] pci 0000:00:02.1: PME# disabled
[    0.100355] pci 0000:00:04.0: reg 10 io port: [0xdc00-0xdcff]
[    0.100359] pci 0000:00:04.0: reg 14 io port: [0xe000-0xe0ff]
[    0.100364] pci 0000:00:04.0: reg 18 32bit mmio: [0xd2003000-0xd2003fff]
[    0.100377] pci 0000:00:04.0: supports D1 D2
[    0.100399] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
[    0.100421] pci 0000:00:07.0: reg 10 io port: [0x9f0-0x9f7]
[    0.100425] pci 0000:00:07.0: reg 14 io port: [0xbf0-0xbf3]
[    0.100429] pci 0000:00:07.0: reg 18 io port: [0x970-0x977]
[    0.100433] pci 0000:00:07.0: reg 1c io port: [0xb70-0xb73]
[    0.100437] pci 0000:00:07.0: reg 20 io port: [0xd800-0xd80f]
[    0.100441] pci 0000:00:07.0: reg 24 32bit mmio: [0xd2002000-0xd2002fff]
[    0.100462] pci 0000:00:08.0: reg 10 io port: [0x9e0-0x9e7]
[    0.100466] pci 0000:00:08.0: reg 14 io port: [0xbe0-0xbe3]
[    0.100470] pci 0000:00:08.0: reg 18 io port: [0x960-0x967]
[    0.100474] pci 0000:00:08.0: reg 1c io port: [0xb60-0xb63]
[    0.100478] pci 0000:00:08.0: reg 20 io port: [0xc400-0xc40f]
[    0.100482] pci 0000:00:08.0: reg 24 32bit mmio: [0xd2001000-0xd2001fff]
[    0.100513] pci 0000:00:0a.0: reg 10 32bit mmio: [0xd2000000-0xd2000fff]
[    0.100517] pci 0000:00:0a.0: reg 14 io port: [0xb000-0xb007]
[    0.100532] pci 0000:00:0a.0: supports D1 D2
[    0.100535] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.100573] pci 0000:00:0a.0: PME# disabled
[    0.100638] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.100676] pci 0000:00:0b.0: PME# disabled
[    0.100741] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.100779] pci 0000:00:0c.0: PME# disabled
[    0.100844] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.100882] pci 0000:00:0d.0: PME# disabled
[    0.100946] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.100984] pci 0000:00:0e.0: PME# disabled
[    0.101116] pci 0000:00:09.0: transparent bridge
[    0.101931] pci 0000:01:00.0: reg 10 64bit mmio pref: [0xc0000000-0xcfff=
ffff]
[    0.101939] pci 0000:01:00.0: reg 18 64bit mmio: [0xd1000000-0xd100ffff]
[    0.101944] pci 0000:01:00.0: reg 20 io port: [0xa000-0xa0ff]
[    0.101952] pci 0000:01:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.101967] pci 0000:01:00.0: supports D1 D2
[    0.101993] pci 0000:01:00.1: reg 10 64bit mmio: [0xd1010000-0xd1013fff]
[    0.102020] pci 0000:01:00.1: supports D1 D2
[    0.102055] pci 0000:00:0e.0: bridge io port: [0xa000-0xafff]
[    0.102058] pci 0000:00:0e.0: bridge 32bit mmio: [0xd0000000-0xd1ffffff]
[    0.102062] pci 0000:00:0e.0: bridge 64bit mmio pref: [0xc0000000-0xcfff=
ffff]
[    0.102072] pci_bus 0000:00: on NUMA node 0
[    0.102077] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.102305] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.171712] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 =
15) *0, disabled.
[    0.172335] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 11 12 14 =
15) *0, disabled.
[    0.172959] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 *7 9 10 11 12 14=
 15)
[    0.173516] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 *4 5 7 9 10 11 12 14=
 15)
[    0.174076] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 =
15) *0, disabled.
[    0.174699] ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 =
15) *0, disabled.
[    0.175327] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 =
15) *0, disabled.
[    0.175951] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14=
 15)
[    0.176493] ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14=
 15)
[    0.177052] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 =
15) *0, disabled.
[    0.177673] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 =
15) *0, disabled.
[    0.178295] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 =
15) *0, disabled.
[    0.178916] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 =
15) *0, disabled.
[    0.179548] ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 *11 12 14=
 15)
[    0.180150] ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 *5 7 9 10 11 12 14=
 15)
[    0.180718] ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 =
15) *0, disabled.
[    0.181363] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    0.181717] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[    0.182070] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
[    0.182395] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
[    0.182656] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[    0.182985] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disab=
led.
[    0.183441] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disab=
led.
[    0.183896] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    0.184295] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
[    0.184718] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disab=
led.
[    0.185174] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disab=
led.
[    0.185629] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disab=
led.
[    0.186084] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disab=
led.
[    0.186549] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[    0.186981] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
[    0.187413] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disab=
led.
[    0.187797] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.187838] vgaarb: loaded
[    0.188019] SCSI subsystem initialized
[    0.188134] libata version 3.00 loaded.
[    0.188220] usbcore: registered new interface driver usbfs
[    0.188273] usbcore: registered new interface driver hub
[    0.188331] usbcore: registered new device driver usb
[    0.188430] PCI: Using ACPI for IRQ routing
[    0.188591] NetLabel: Initializing
[    0.188627] NetLabel:  domain hash size =3D 128
[    0.188664] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.188714] NetLabel:  unlabeled traffic allowed by default
[    0.188756] Switching to clocksource jiffies
[    0.190546] pnp: PnP ACPI init
[    0.190604] ACPI: bus type pnp registered
[    0.195109] pnp: PnP ACPI: found 13 devices
[    0.195147] ACPI: ACPI bus type pnp unregistered
[    0.195186] PnPBIOS: Disabled by ACPI PNP
[    0.195232] system 00:01: ioport range 0x4000-0x407f has been reserved
[    0.195271] system 00:01: ioport range 0x4080-0x40ff has been reserved
[    0.195310] system 00:01: ioport range 0x4400-0x447f has been reserved
[    0.195349] system 00:01: ioport range 0x4480-0x44ff has been reserved
[    0.195387] system 00:01: ioport range 0x4800-0x487f has been reserved
[    0.195426] system 00:01: ioport range 0x4880-0x48ff has been reserved
[    0.195467] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.195505] system 00:02: ioport range 0x800-0x805 has been reserved
[    0.195544] system 00:02: ioport range 0x290-0x297 has been reserved
[    0.195588] system 00:0b: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.195629] system 00:0c: iomem range 0xf0000-0xf3fff could not be reser=
ved
[    0.195668] system 00:0c: iomem range 0xf4000-0xf7fff could not be reser=
ved
[    0.195707] system 00:0c: iomem range 0xf8000-0xfbfff could not be reser=
ved
[    0.195746] system 00:0c: iomem range 0xfc000-0xfffff could not be reser=
ved
[    0.195785] system 00:0c: iomem range 0x5fff0000-0x5fffffff could not be=
 reserved
[    0.195826] system 00:0c: iomem range 0xffff0000-0xffffffff has been res=
erved
[    0.195865] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.195904] system 00:0c: iomem range 0x100000-0x5ffeffff could not be r=
eserved
[    0.195945] system 00:0c: iomem range 0xfec00000-0xfec00fff could not be=
 reserved
[    0.196004] system 00:0c: iomem range 0xfee00000-0xfeefffff has been res=
erved
[    0.196043] system 00:0c: iomem range 0xfefff000-0xfeffffff has been res=
erved
[    0.196082] system 00:0c: iomem range 0xfff80000-0xfff80fff has been res=
erved
[    0.196121] system 00:0c: iomem range 0xfff90000-0xfffbffff has been res=
erved
[    0.196160] system 00:0c: iomem range 0xfffed000-0xfffeffff has been res=
erved
[    0.230828] Switching to clocksource acpi_pm
[    0.230994] pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
[    0.231032] pci 0000:00:09.0:   IO window: disabled
[    0.231070] pci 0000:00:09.0:   MEM window: disabled
[    0.231107] pci 0000:00:09.0:   PREFETCH window: disabled
[    0.231146] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    0.231183] pci 0000:00:0b.0:   IO window: disabled
[    0.231221] pci 0000:00:0b.0:   MEM window: disabled
[    0.231258] pci 0000:00:0b.0:   PREFETCH window: disabled
[    0.231297] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
[    0.231335] pci 0000:00:0c.0:   IO window: disabled
[    0.231372] pci 0000:00:0c.0:   MEM window: disabled
[    0.231410] pci 0000:00:0c.0:   PREFETCH window: disabled
[    0.231450] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
[    0.231487] pci 0000:00:0d.0:   IO window: disabled
[    0.231525] pci 0000:00:0d.0:   MEM window: disabled
[    0.231562] pci 0000:00:0d.0:   PREFETCH window: disabled
[    0.231606] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
[    0.231644] pci 0000:00:0e.0:   IO window: 0xa000-0xafff
[    0.231685] pci 0000:00:0e.0:   MEM window: 0xd0000000-0xd1ffffff
[    0.231725] pci 0000:00:0e.0:   PREFETCH window: 0x000000c0000000-0x0000=
00cfffffff
[    0.231773] pci 0000:00:09.0: setting latency timer to 64
[    0.231778] pci 0000:00:0b.0: setting latency timer to 64
[    0.231783] pci 0000:00:0c.0: setting latency timer to 64
[    0.231788] pci 0000:00:0d.0: setting latency timer to 64
[    0.231792] pci 0000:00:0e.0: setting latency timer to 64
[    0.231797] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.231800] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.231803] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.231806] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffff]
[    0.231809] pci_bus 0000:01: resource 0 io:  [0xa000-0xafff]
[    0.231812] pci_bus 0000:01: resource 1 mem: [0xd0000000-0xd1ffffff]
[    0.231815] pci_bus 0000:01: resource 2 pref mem [0xc0000000-0xcfffffff]
[    0.231855] NET: Registered protocol family 2
[    0.231989] IP route cache hash table entries: 32768 (order: 5, 131072 b=
ytes)
[    0.232001] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.232001] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.232001] TCP: Hash tables configured (established 131072 bind 65536)
[    0.232001] TCP reno registered
[    0.232001] NET: Registered protocol family 1
[    0.248093] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.248135] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    0.248177] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.248217] pci 0000:00:0b.0: Linking AER extended capability
[    0.248288] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.248328] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    0.248370] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.248408] pci 0000:00:0c.0: Linking AER extended capability
[    0.248481] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.248522] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    0.248564] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.248602] pci 0000:00:0d.0: Linking AER extended capability
[    0.248678] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.248718] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    0.248760] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.248798] pci 0000:00:0e.0: Linking AER extended capability
[    0.248843] pci 0000:01:00.0: Boot video device
[    0.249003] cpufreq-nforce2: No nForce2 chipset.
[    0.249070] Scanning for low memory corruption every 60 seconds
[    0.249219] audit: initializing netlink socket (disabled)
[    0.249266] type=3D2000 audit(1268066369.248:1): initialized
[    0.258121] highmem bounce pool size: 64 pages
[    0.258164] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.259574] VFS: Disk quotas dquot_6.5.2
[    0.259667] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.260278] fuse init (API version 7.13)
[    0.260390] msgmni has been set to 1719
[    0.260618] alg: No test for stdrng (krng)
[    0.260661] io scheduler noop registered
[    0.260698] io scheduler anticipatory registered
[    0.260735] io scheduler deadline registered
[    0.260815] io scheduler cfq registered (default)
[    0.260946] pcieport 0000:00:0b.0: irq 24 for MSI/MSI-X
[    0.260952] pcieport 0000:00:0b.0: setting latency timer to 64
[    0.261015] pcieport 0000:00:0c.0: irq 25 for MSI/MSI-X
[    0.261019] pcieport 0000:00:0c.0: setting latency timer to 64
[    0.261077] pcieport 0000:00:0d.0: irq 26 for MSI/MSI-X
[    0.261081] pcieport 0000:00:0d.0: setting latency timer to 64
[    0.261138] pcieport 0000:00:0e.0: irq 27 for MSI/MSI-X
[    0.261142] pcieport 0000:00:0e.0: setting latency timer to 64
[    0.261197] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.261256] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.261429] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input0
[    0.261471] ACPI: Power Button [PWRB]
[    0.261569] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1
[    0.261610] ACPI: Power Button [PWRF]
[    0.261692] fan PNP0C0B:00: registered as cooling_device0
[    0.261733] ACPI: Fan [FAN] (on)
[    0.262282] processor LNXCPU:00: registered as cooling_device1
[    0.266830] thermal LNXTHERM:01: registered as thermal_zone0
[    0.266879] ACPI: Thermal Zone [THRM] (40 C)
[    0.266982] isapnp: Scanning for PnP cards...
[    0.619477] isapnp: No Plug & Play device found
[    0.620585] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.621769] brd: module loaded
[    0.622218] loop: module loaded
[    0.622495] sata_nv 0000:00:07.0: version 3.5
[    0.622884] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23
[    0.622933] sata_nv 0000:00:07.0: PCI INT A -> Link[APSI] -> GSI 23 (lev=
el, low) -> IRQ 23
[    0.623034] sata_nv 0000:00:07.0: setting latency timer to 64
[    0.623131] scsi0 : sata_nv
[    0.623240] scsi1 : sata_nv
[    0.623430] ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd800 irq=
 23
[    0.623469] ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd808 irq=
 23
[    0.623832] ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 22
[    0.623873] sata_nv 0000:00:08.0: PCI INT A -> Link[APSJ] -> GSI 22 (lev=
el, low) -> IRQ 22
[    0.623957] sata_nv 0000:00:08.0: setting latency timer to 64
[    0.624069] scsi2 : sata_nv
[    0.624152] scsi3 : sata_nv
[    0.624329] ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc400 irq=
 22
[    0.624368] ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc408 irq=
 22
[    0.625145] pata_amd 0000:00:06.0: version 0.4.1
[    0.625189] pata_amd 0000:00:06.0: setting latency timer to 64
[    0.625257] scsi4 : pata_amd
[    0.625370] scsi5 : pata_amd
[    0.626090] ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq=
 14
[    0.626129] ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq=
 15
[    0.626485] Fixed MDIO Bus: probed
[    0.626615] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.626916] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 21
[    0.626962] ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 21 (le=
vel, low) -> IRQ 21
[    0.627013] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    0.627016] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    0.627105] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus =
number 1
[    0.627171] ehci_hcd 0000:00:02.1: debug port 1
[    0.627211] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    0.627225] ehci_hcd 0000:00:02.1: irq 21, io mem 0xfeb00000
[    0.636034] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    0.636153] usb usb1: configuration #1 chosen from 1 choice
[    0.636217] hub 1-0:1.0: USB hub found
[    0.636262] hub 1-0:1.0: 10 ports detected
[    0.636360] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.636666] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 20
[    0.636708] ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 20 (le=
vel, low) -> IRQ 20
[    0.636756] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    0.636759] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    0.636824] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus =
number 2
[    0.636882] ohci_hcd 0000:00:02.0: irq 20, io mem 0xd2004000
[    0.694056] usb usb2: configuration #1 chosen from 1 choice
[    0.694115] hub 2-0:1.0: USB hub found
[    0.694159] hub 2-0:1.0: 10 ports detected
[    0.694246] uhci_hcd: USB Universal Host Controller Interface driver
[    0.694380] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.694418] PNP: PS/2 appears to have AUX port disabled, if this is inco=
rrect please boot with i8042.nopnp
[    0.695560] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.695667] mice: PS/2 mouse device common for all mice
[    0.695796] rtc_cmos 00:04: RTC can wake from S4
[    0.695869] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.695927] rtc0: alarms up to one year, y3k, 242 bytes nvram
[    0.696079] device-mapper: uevent: version 1.0.3
[    0.696204] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised:=
 dm-devel@redhat.com
[    0.696295] device-mapper: multipath: version 1.1.0 loaded
[    0.696333] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.696500] cpuidle: using governor ladder
[    0.696537] cpuidle: using governor menu
[    0.697001] TCP cubic registered
[    0.697186] NET: Registered protocol family 10
[    0.697620] lo: Disabled Privacy Extensions
[    0.697934] NET: Registered protocol family 17
[    0.697975] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3200+ proce=
ssors (1 cpu cores) (version 2.20.00)
[    0.698061] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x6
[    0.698099] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x8
[    0.698136] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[    0.698208] Using IPI No-Shortcut mode
[    0.698307] PM: Resume from disk failed.
[    0.698319] registered taskstats version 1
[    0.698613]   Magic number: 2:411:691
[    0.698765] rtc_cmos 00:04: setting system clock to 2010-03-08 16:39:30 =
UTC (1268066370)
[    0.698807] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.698844] EDD information not available.
[    0.715385] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input2
[    0.788399] ata5.00: ATA-5: ST380021A, 3.19, max UDMA/100
[    0.788438] ata5.00: 156301488 sectors, multi 1: LBA=20
[    0.788497] ata5: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=3D0x3f0=
00 (0xc60000c0) ACPI=3D0x3f01f (20:600:0x13)
[    0.804320] ata5.00: configured for UDMA/100
[    0.936025] ata3: SATA link down (SStatus 0 SControl 300)
[    0.936076] ata1: SATA link down (SStatus 0 SControl 300)
[    1.004022] usb 1-9: new high speed USB device using ehci_hcd and addres=
s 3
[    1.138706] usb 1-9: configuration #1 chosen from 1 choice
[    1.248021] ata2: SATA link down (SStatus 0 SControl 300)
[    1.440020] usb 2-2: new low speed USB device using ohci_hcd and address=
 2
[    1.560021] ata4: SATA link down (SStatus 0 SControl 300)
[    1.560188] scsi 4:0:0:0: Direct-Access     ATA      ST380021A        3.=
19 PQ: 0 ANSI: 5
[    1.560343] sd 4:0:0:0: Attached scsi generic sg0 type 0
[    1.560508] sd 4:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 G=
B/74.5 GiB)
[    1.560587] sd 4:0:0:0: [sda] Write Protect is off
[    1.560625] sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.560645] sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.560805]  sda: sda1 sda2 < sda5 sda6 sda7 > sda3 sda4
[    1.622860] sd 4:0:0:0: [sda] Attached SCSI disk
[    1.652093] usb 2-2: configuration #1 chosen from 1 choice
[    1.732251] ata6.01: ATAPI: HL-DT-STDVD-ROM GDR8164B, 0L06, max UDMA/33
[    1.732312] ata6: nv_mode_filter: 0x739f&0x739f->0x739f, BIOS=3D0x7000 (=
0xc60000c0) ACPI=3D0x701f (600:60:0x1c)
[    1.748199] ata6.01: configured for UDMA/33
[    1.752066] scsi 5:0:1:0: CD-ROM            HL-DT-ST DVD-ROM GDR8164B 0L=
06 PQ: 0 ANSI: 5
[    1.760072] sr0: scsi3-mmc drive: 52x/52x cd/rw xa/form2 cdda tray
[    1.760112] Uniform CD-ROM driver Revision: 3.20
[    1.760221] sr 5:0:1:0: Attached scsi CD-ROM sr0
[    1.760260] sr 5:0:1:0: Attached scsi generic sg1 type 5
[    1.760320] md: Waiting for all devices to be available before autodetect
[    1.760358] md: If you don't use raid, use raid=3Dnoautodetect
[    1.760485] md: Autodetecting RAID arrays.
[    1.760522] md: Scanned 0 and added 0 devices.
[    1.760559] md: autorun ...
[    1.760594] md: ... autorun DONE.
[    1.797114] kjournald starting.  Commit interval 5 seconds
[    1.797160] EXT3-fs: mounted filesystem with writeback data mode.
[    1.797206] VFS: Mounted root (ext3 filesystem) readonly on device 8:4.
[    1.797263] Freeing unused kernel memory: 440k freed
[    1.797679] Write protecting the kernel text: 4380k
[    1.797742] Write protecting the kernel read-only data: 1652k
[    9.708291] Initializing USB Mass Storage driver...
[    9.722261] scsi6 : SCSI emulation for USB Mass Storage devices
[    9.750555] usbcore: registered new interface driver usb-storage
[    9.750602] USB Mass Storage support registered.
[    9.751046] usb-storage: device found at 3
[    9.751048] usb-storage: waiting for device to settle before scanning
[    9.842682] usbcore: registered new interface driver hiddev
[    9.848572] input: Logitech Optical USB Mouse as /devices/pci0000:00/000=
0:00:02.0/usb2/2-2/2-2:1.0/input/input3
[    9.848788] generic-usb 0003:046D:C016.0001: input,hidraw0: USB HID v1.1=
0 Mouse [Logitech Optical USB Mouse] on usb-0000:00:02.0-2/input0
[    9.848881] usbcore: registered new interface driver usbhid
[    9.848920] usbhid: v2.6:USB HID core driver
[    9.861558] i2c i2c-0: nForce2 SMBus adapter at 0x4c00
[    9.861619] i2c i2c-1: nForce2 SMBus adapter at 0x4c40
[    9.876872] forcedeth: Reverse Engineered nForce ethernet driver. Versio=
n 0.64.
[    9.877258] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
[    9.877300] forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 23 (l=
evel, low) -> IRQ 23
[    9.877344] forcedeth 0000:00:0a.0: setting latency timer to 64
[    9.877399] nv_probe: set workaround bit for reversed mac addr
[    9.914918] Floppy drive(s): fd0 is 1.44M
[    9.922547] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    9.931853] FDC 0 is a post-1991 82077
[   10.396791] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 9, add=
r 00:15:f2:3f:8f:bd
[   10.396839] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[   10.591605] udev: renamed network interface eth0 to eth1
[   10.912575] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[   10.912631] HDA Intel 0000:01:00.1: PCI INT B -> Link[APC4] -> GSI 19 (l=
evel, low) -> IRQ 19
[   10.912707] HDA Intel 0000:01:00.1: setting latency timer to 64
[   10.955061] ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 22
[   10.955110] Intel ICH 0000:00:04.0: PCI INT A -> Link[APCJ] -> GSI 22 (l=
evel, low) -> IRQ 22
[   10.955186] Intel ICH 0000:00:04.0: setting latency timer to 64
[   11.312304] intel8x0_measure_ac97_clock: measured 53624 usecs (2632 samp=
les)
[   11.312349] intel8x0: clocking to 46941
[   11.865841] Adding 1020088k swap on /dev/sda1.  Priority:-1 extents:1 ac=
ross:1020088k=20
[   12.273027] EXT3 FS on sda4, internal journal
[   12.759553] kjournald starting.  Commit interval 5 seconds
[   12.759562] EXT3-fs warning: maximal mount count reached, running e2fsck=
 is recommended
[   12.760023] EXT3 FS on sda5, internal journal
[   12.760028] EXT3-fs: mounted filesystem with writeback data mode.
[   12.790310] kjournald starting.  Commit interval 5 seconds
[   12.790316] EXT3-fs warning: maximal mount count reached, running e2fsck=
 is recommended
[   12.790515] EXT3 FS on sda6, internal journal
[   12.790518] EXT3-fs: mounted filesystem with writeback data mode.
[   12.826290] kjournald starting.  Commit interval 5 seconds
[   12.826295] EXT3-fs warning: maximal mount count reached, running e2fsck=
 is recommended
[   12.826529] EXT3 FS on sda7, internal journal
[   12.826532] EXT3-fs: mounted filesystem with writeback data mode.
[   13.419921] RPC: Registered udp transport module.
[   13.419925] RPC: Registered tcp transport module.
[   13.419927] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   13.588110] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   14.750894] usb-storage: device scan complete
[   14.752570] scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.=
00 PQ: 0 ANSI: 0
[   14.753070] scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader    1.=
01 PQ: 0 ANSI: 0
[   14.753569] scsi 6:0:0:2: Direct-Access     Generic  USB SM Reader    1.=
02 PQ: 0 ANSI: 0
[   14.754074] scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader    1.=
03 PQ: 0 ANSI: 0
[   14.755144] sd 6:0:0:0: Attached scsi generic sg2 type 0
[   14.755439] sd 6:0:0:1: Attached scsi generic sg3 type 0
[   14.755701] sd 6:0:0:2: Attached scsi generic sg4 type 0
[   14.755949] sd 6:0:0:3: Attached scsi generic sg5 type 0
[   14.763429] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[   14.767110] sd 6:0:0:1: [sdc] Attached SCSI removable disk
[   14.771253] sd 6:0:0:2: [sdd] Attached SCSI removable disk
[   14.773366] sd 6:0:0:3: [sde] Attached SCSI removable disk
[   45.212018] eth1: no IPv6 routers present
[   92.580025] Clocksource tsc unstable (delta =3D -163988709 ns)
[  396.065147] Btrfs loaded
[  396.065481] device fsid 874dfadf1d697672-ce62e6710d183d88 devid 1 transi=
d 7 /dev/loop0
[  492.163963] ------------[ cut here ]------------
[  492.164012] kernel BUG at fs/btrfs/inode.c:4365!
[  492.164012] invalid opcode: 0000 [#1] SMP=20
[  492.164012] last sysfs file: /sys/devices/pci0000:00/0000:00:02.0/pools
[  492.164012] Modules linked in: btrfs zlib_deflate crc32c libcrc32c binfm=
t_misc video output nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc dm_c=
rypt snd_wavefront snd_cs4236 snd_wss_lib snd_opl3_lib snd_hda_codec_atihdm=
i snd_intel8x0 snd_hwdep snd_mpu401 snd_hda_intel snd_mpu401_uart snd_ac97_=
codec snd_hda_codec ac97_bus snd_seq_dummy snd_pcm_oss snd_mixer_oss snd_se=
q_oss snd_seq_midi snd_pcm snd_rawmidi snd_seq_midi_event snd_seq snd_timer=
 snd_seq_device snd pcspkr floppy forcedeth i2c_nforce2 soundcore snd_page_=
alloc k8temp usbhid usb_storage
[  492.164012]=20
[  492.164012] Pid: 3919, comm: ln Not tainted (2.6.32.9 #1) System Product=
 Name
[  492.164012] EIP: 0060:[<f87a646a>] EFLAGS: 00010282 CPU: 0
[  492.164012] EIP is at btrfs_link+0x17a/0x180 [btrfs]
[  492.164012] EAX: fffffffe EBX: f5df9000 ECX: c20051a8 EDX: 00000000
[  492.164012] ESI: fffffffe EDI: f4e60918 EBP: f5037ee4 ESP: f5037eb0
[  492.164012]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  492.164012] Process ln (pid: 3919, ti=3Df5036000 task=3Df5088000 task.ti=
=3Df5036000)
[  492.164012] Stack:
[  492.164012]  00000001 00000002 00000000 f4e664c8 f67c1800 f4e60918 00000=
001 f4e60540
[  492.164012] <0> 00000002 00000000 f87de380 f4e5d7f8 f4e60918 f5037f10 c0=
1f3d2d 00000000
[  492.164012] <0> f5037f20 f5037f00 f4e664c8 f4e60678 f4e60990 00000000 f5=
037f78 f5037f20
[  492.164012] Call Trace:
[  492.164012]  [<c01f3d2d>] ? vfs_link+0x10d/0x210
[  492.164012]  [<c01f6f43>] ? sys_linkat+0xe3/0xf0
[  492.164012]  [<c01eeaf2>] ? sys_lstat64+0x22/0x30
[  492.164012]  [<c01f6f80>] ? sys_link+0x30/0x40
[  492.164012]  [<c0102ef0>] ? sysenter_do_call+0x12/0x22
[  492.164012] Code: e0 8b 45 dc e8 88 30 ff ff e9 d8 fe ff ff 8d 76 00 8b =
45 dc ba 03 00 00 00 e8 73 37 fe ff c7 45 e0 00 00 00 00 8d 74 26 00 eb d3 =
<0f> 0b eb fe 66 90 55 89 e5 83 ec 5c 89 75 f8 89 c6 8d 80 c8 fe=20
[  492.164012] EIP: [<f87a646a>] btrfs_link+0x17a/0x180 [btrfs] SS:ESP 0068=
:f5037eb0
[  492.170162] ---[ end trace 2c24404282a55ea4 ]---

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkuVMtYACgkQ6W+y3GmZgOjNHACggeu3+0DnN5flY7F17DU9qYAR
uVQAn2AcP9inrAvw9EgcdKxIpagA8W8b
=yT/f
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
