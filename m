Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60770 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2GJTEg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 15:04:36 -0400
Received: by wgbdr13 with SMTP id dr13so275253wgb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2012 12:04:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAE6i0iDfedgvW=EpoMS58z5PigCveRU-b3Prm3LNxj9=A3wnw@mail.gmail.com>
References: <CAAE6i0jGqbOcRbhEYQiLdSUyxaKkFZKQTqb82shaSYdF9jFEqg@mail.gmail.com>
 <CAAE6i0jcfJvBq_JJhO-DVWqBrtEJe1nA7t8k-fqF0BtQY15N4w@mail.gmail.com>
 <CAAE6i0hxv2t0-df+JLtCTC7k8VKTuH-DkUQ7saOSGWSKEV7C2Q@mail.gmail.com>
 <CAAE6i0i7etUgKgGEAzDR6BSruz4AWhaw-0_zvHxwqDAQnyBQ3g@mail.gmail.com>
 <20120627134723.GB2819@localhost.localdomain> <CAAE6i0iN_nv+NfLZ7Tb7e-QVT2oxb7tUC-wnkHdQRxM9sxENiw@mail.gmail.com>
 <20120627164535.GA2940@localhost.localdomain> <CAAE6i0gVcPX3_Q7XxFZT=tf+tZSTLsitf7NgbS0O95L0Rmn2uw@mail.gmail.com>
 <CAAE6i0iDfedgvW=EpoMS58z5PigCveRU-b3Prm3LNxj9=A3wnw@mail.gmail.com>
From: Chester <somethingsome2000@gmail.com>
Date: Tue, 10 Jul 2012 14:04:14 -0500
Message-ID: <CAAE6i0jHtsCNZPwJXFgO1D88XirfYi6KEdyrDz1-4TvS7UEkjg@mail.gmail.com>
Subject: Re: btrfs volume suddenly becomes read-only
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So, I got the sysq-w + the whole dmesg until crash

<6>[    0.000000] Initializing cgroup subsys cpuset
<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 3.4.0-00091-gcb77fcd (root@navilaptop)
(gcc version 4.6.2 (Gentoo 4.6.2-r1 p1.4, pie-0.5.0) ) #1 SMP Thu Jun
21 18:25:21 CDT 2012
<6>[    0.000000] Command line: BOOT_IMAGE=/bzImage-btrfs-3.4.0 =
root=/dev/sda6 rootflags=subvolid=264,thread_pool=32 rootfstype=btrfs
radeon.modeset=1 funtoo-ati raid=noautodetect selinux=0 rescue
<6>[    0.000000] BIOS-provided physical RAM map:
<6>[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
<6>[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
<6>[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfb3f000 (usable)
<6>[    0.000000]  BIOS-e820: 00000000bfb3f000 - 00000000bfbbf000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000bfbbf000 - 00000000bfebf000 (ACPI NVS)
<6>[    0.000000]  BIOS-e820: 00000000bfebf000 - 00000000bfef6000 (ACPI data)
<6>[    0.000000]  BIOS-e820: 00000000bfef6000 - 00000000bff00000 (usable)
<6>[    0.000000]  BIOS-e820: 00000000bff00000 - 00000000e0000000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
<6>[    0.000000]  BIOS-e820: 0000000100000000 - 000000019f000000 (usable)
<6>[    0.000000] NX (Execute Disable) protection: active
<6>[    0.000000] DMI 2.7 present.
<7>[    0.000000] DMI: Hewlett-Packard HP Pavilion dv6 Notebook
PC/358B, BIOS F.21 09/13/2011
<7>[    0.000000] e820 update range: 0000000000000000 -
0000000000010000 (usable) ==> (reserved)
<7>[    0.000000] e820 remove range: 00000000000a0000 -
0000000000100000 (usable)
<6>[    0.000000] No AGP bridge found
<6>[    0.000000] last_pfn = 0x19f000 max_arch_pfn = 0x400000000
<7>[    0.000000] MTRR default type: uncachable
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-BFFFF uncachable
<7>[    0.000000]   C0000-FFFFF write-through
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 base 0000000000 mask FF80000000 write-back
<7>[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
<7>[    0.000000]   2 base 00BFEBD000 mask FFFFFFF000 uncachable
<7>[    0.000000]   3 base 00FFE00000 mask FFFFE00000 write-protect
<7>[    0.000000]   4 disabled
<7>[    0.000000]   5 disabled
<7>[    0.000000]   6 disabled
<7>[    0.000000]   7 disabled
<7>[    0.000000] TOM2: 000000019f000000 aka 6640M
<6>[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
<6>[    0.000000] last_pfn = 0xbff00 max_arch_pfn = 0x400000000
<6>[    0.000000] found SMP MP-table at [ffff8800000fe1b0] fe1b0
<7>[    0.000000] initial memory mapped : 0 - 20000000
<7>[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
<6>[    0.000000] Using GB pages for direct mapping
<6>[    0.000000] init_memory_mapping: 0000000000000000-00000000bff00000
<7>[    0.000000]  0000000000 - 0080000000 page 1G
<7>[    0.000000]  0080000000 - 00bfe00000 page 2M
<7>[    0.000000]  00bfe00000 - 00bff00000 page 4k
<7>[    0.000000] kernel direct mapping tables up to bff00000 @
1fffd000-20000000
<6>[    0.000000] init_memory_mapping: 0000000100000000-000000019f000000
<7>[    0.000000]  0100000000 - 0180000000 page 1G
<7>[    0.000000]  0180000000 - 019f000000 page 2M
<7>[    0.000000] kernel direct mapping tables up to 19f000000 @
bfefe000-bff00000
<6>[    0.000000] RAMDISK: 37dc7000 - 37ff0000
<4>[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 HPQOEM)
<4>[    0.000000] ACPI: XSDT 00000000bfef5120 0007C (v01 HPQOEM
SLIC-MPC 00000001      01000013)
<4>[    0.000000] ACPI: FACP 00000000bfef4000 000F4 (v04 HPQOEM
SLIC-MPC 00000001 ACPI 00040000)
<4>[    0.000000] ACPI: DSDT 00000000bfede000 11490 (v01 HP     INSYDE
  F0000000 ACPI 00040000)
<4>[    0.000000] ACPI: FACS 00000000bfc95000 00040
<4>[    0.000000] ACPI: HPET 00000000bfef3000 00038 (v01 HP     INSYDE
  00000001 ACPI 00040000)
<4>[    0.000000] ACPI: APIC 00000000bfef2000 00084 (v02 HP     INSYDE
  00000001 ACPI 00040000)
<4>[    0.000000] ACPI: MCFG 00000000bfef1000 0003C (v01 HP     INSYDE
  00000001 ACPI 00040000)
<4>[    0.000000] ACPI: ASF! 00000000bfef0000 000A5 (v32 HP     INSYDE
  00000001 ACPI 00040000)
<4>[    0.000000] ACPI: BOOT 00000000bfedd000 00028 (v01 HP     INSYDE
  00000001 ACPI 00040000)
<4>[    0.000000] ACPI: SLIC 00000000bfedc000 00176 (v01 HPQOEM
SLIC-MPC 00000001 ACPI 00040000)
<4>[    0.000000] ACPI: WDRT 00000000bfedb000 00047 (v01 HP     INSYDE
  00000001 ACPI 00040000)
<4>[    0.000000] ACPI: MSDM 00000000bfeda000 00055 (v03 HP     INSYDE
  00000001 ACPI 00040000)
<4>[    0.000000] ACPI: SSDT 00000000bfed9000 00E28 (v01 HP     INSYDE
  00000001 AMD  00000001)
<4>[    0.000000] ACPI: SSDT 00000000bfed7000 0190A (v02 HP     INSYDE
  00000001 MSFT 04000000)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] No NUMA configuration found
<6>[    0.000000] Faking a node at 0000000000000000-000000019f000000
<6>[    0.000000] Initmem setup node 0 0000000000000000-000000019f000000
<6>[    0.000000]   NODE_DATA [000000019effc000 - 000000019effffff]
<7>[    0.000000]  [ffffea0000000000-ffffea00067fffff] PMD ->
[ffff880198e00000-ffff88019e5fffff] on node 0
<4>[    0.000000] Zone PFN ranges:
<4>[    0.000000]   DMA      0x00000010 -> 0x00001000
<4>[    0.000000]   DMA32    0x00001000 -> 0x00100000
<4>[    0.000000]   Normal   0x00100000 -> 0x0019f000
<4>[    0.000000] Movable zone start PFN for each node
<4>[    0.000000] Early memory PFN ranges
<4>[    0.000000]     0: 0x00000010 -> 0x0000009f
<4>[    0.000000]     0: 0x00000100 -> 0x000bfb3f
<4>[    0.000000]     0: 0x000bfef6 -> 0x000bff00
<4>[    0.000000]     0: 0x00100000 -> 0x0019f000
<7>[    0.000000] On node 0 totalpages: 1436376
<7>[    0.000000]   DMA zone: 64 pages used for memmap
<7>[    0.000000]   DMA zone: 5 pages reserved
<7>[    0.000000]   DMA zone: 3914 pages, LIFO batch:0
<7>[    0.000000]   DMA32 zone: 16320 pages used for memmap
<7>[    0.000000]   DMA32 zone: 764809 pages, LIFO batch:31
<7>[    0.000000]   Normal zone: 10176 pages used for memmap
<7>[    0.000000]   Normal zone: 641088 pages, LIFO batch:31
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x408
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
<7>[    0.000000] ACPI: IRQ0 used by override.
<7>[    0.000000] ACPI: IRQ2 used by override.
<7>[    0.000000] ACPI: IRQ9 used by override.
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>[    0.000000] ACPI: HPET id: 0x10228210 base: 0xfed00000
<6>[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
<7>[    0.000000] nr_irqs_gsi: 40
<6>[    0.000000] PM: Registered nosave memory: 000000000009f000 -
00000000000a0000
<6>[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000e0000
<6>[    0.000000] PM: Registered nosave memory: 00000000000e0000 -
0000000000100000
<6>[    0.000000] PM: Registered nosave memory: 00000000bfb3f000 -
00000000bfbbf000
<6>[    0.000000] PM: Registered nosave memory: 00000000bfbbf000 -
00000000bfebf000
<6>[    0.000000] PM: Registered nosave memory: 00000000bfebf000 -
00000000bfef6000
<6>[    0.000000] PM: Registered nosave memory: 00000000bff00000 -
00000000e0000000
<6>[    0.000000] PM: Registered nosave memory: 00000000e0000000 -
00000000f8000000
<6>[    0.000000] PM: Registered nosave memory: 00000000f8000000 -
00000000fc000000
<6>[    0.000000] PM: Registered nosave memory: 00000000fc000000 -
00000000fec00000
<6>[    0.000000] PM: Registered nosave memory: 00000000fec00000 -
00000000fec01000
<6>[    0.000000] PM: Registered nosave memory: 00000000fec01000 -
00000000fec10000
<6>[    0.000000] PM: Registered nosave memory: 00000000fec10000 -
00000000fec11000
<6>[    0.000000] PM: Registered nosave memory: 00000000fec11000 -
00000000fee00000
<6>[    0.000000] PM: Registered nosave memory: 00000000fee00000 -
00000000fee01000
<6>[    0.000000] PM: Registered nosave memory: 00000000fee01000 -
00000000ffe00000
<6>[    0.000000] PM: Registered nosave memory: 00000000ffe00000 -
0000000100000000
<6>[    0.000000] Allocating PCI resources starting at e0000000 (gap:
e0000000:18000000)
<6>[    0.000000] Booting paravirtualized kernel on bare hardware
<6>[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8
nr_cpu_ids:4 nr_node_ids:1
<6>[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88019ec00000
s77568 r8192 d20736 u524288
<7>[    0.000000] pcpu-alloc: s77568 r8192 d20736 u524288 alloc=1*2097152
<7>[    0.000000] pcpu-alloc: [0] 0 1 2 3
<4>[    0.000000] Built 1 zonelists in Node order, mobility grouping
on.  Total pages: 1409811
<4>[    0.000000] Policy zone: Normal
<5>[    0.000000] Kernel command line: BOOT_IMAGE=/bzImage-btrfs-3.4.0
= root=/dev/sda6 rootflags=subvolid=264,thread_pool=32
rootfstype=btrfs radeon.modeset=1 funtoo-ati raid=noautodetect
selinux=0 rescue
<6>[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.000000] Checking aperture...
<6>[    0.000000] No AGP bridge found
<6>[    0.000000] Memory: 5571880k/6799360k available (6689k kernel
code, 1053856k absent, 173624k reserved, 6327k data, 560k init)
<6>[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3,
MinObjects=0, CPUs=4, Nodes=1
<6>[    0.000000] Hierarchical RCU implementation.
<6>[    0.000000] NR_IRQS:4352 nr_irqs:712 16
<7>[    0.000000] spurious 8259A interrupt: IRQ7.
<6>[    0.000000] Console: colour VGA+ 80x25
<6>[    0.000000] console [tty0] enabled
<7>[    0.000000] hpet clockevent registered
<4>[    0.000000] Fast TSC calibration using PIT
<4>[    0.004000] Detected 1896.436 MHz processor.
<6>[    0.000003] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3792.87 BogoMIPS (lpj=7585744)
<6>[    0.000288] pid_max: default: 32768 minimum: 301
<6>[    0.000454] Security Framework initialized
<6>[    0.000584] SELinux:  Disabled at boot.
<6>[    0.001484] Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes)
<6>[    0.004394] Inode-cache hash table entries: 524288 (order: 10,
4194304 bytes)
<6>[    0.005798] Mount-cache hash table entries: 256
<6>[    0.006182] Initializing cgroup subsys cpuacct
<6>[    0.006384] Initializing cgroup subsys devices
<6>[    0.006539] Initializing cgroup subsys freezer
<6>[    0.006647] Initializing cgroup subsys net_prio
<7>[    0.006795] tseg: 00bff00000
<6>[    0.006797] CPU: Physical Processor ID: 0
<6>[    0.006950] CPU: Processor Core ID: 0
<6>[    0.007104] mce: CPU supports 6 MCE banks
<6>[    0.008124] ACPI: Core revision 20120320
<6>[    0.024529] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.064301] CPU0: AMD A8-3530MX APU with Radeon(tm) HD Graphics
stepping 00
<6>[    0.169674] Performance Events: AMD PMU driver.
<6>[    0.169862] ... version:                0
<6>[    0.170014] ... bit width:              48
<6>[    0.170166] ... generic registers:      4
<6>[    0.170290] ... value mask:             0000ffffffffffff
<6>[    0.170442] ... max period:             00007fffffffffff
<6>[    0.170595] ... fixed-purpose events:   0
<6>[    0.170746] ... event mask:             000000000000000f
<6>[    0.171009] MCE: In-kernel MCE decoding enabled.
<6>[    0.171283] Booting Node   0, Processors  #1 #2 #3 Ok.
<6>[    0.210803] Brought up 4 CPUs
<6>[    0.210999] Total of 4 processors activated (15171.48 BogoMIPS).
<6>[    0.212722] devtmpfs: initialized
<6>[    0.213324] PM: Registering ACPI NVS region [mem
0xbfbbf000-0xbfebefff] (3145728 bytes)
<6>[    0.213750] RTC time: 13:50:31, date: 07/10/12
<6>[    0.213932] NET: Registered protocol family 16
<4>[    0.214526] kworker/u:0 used greatest stack depth: 6552 bytes left
<4>[    0.214774] kworker/u:0 used greatest stack depth: 5520 bytes left
<6>[    0.215649] ACPI: bus type pci registered
<6>[    0.216040] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
<6>[    0.216225] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
<6>[    0.223524] PCI: Using configuration type 1 for base access
<6>[    0.241443] bio: create slab <bio-0> at 0
<6>[    0.242219] ACPI: Added _OSI(Module Device)
<6>[    0.242377] ACPI: Added _OSI(Processor Device)
<6>[    0.242529] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>[    0.242682] ACPI: Added _OSI(Processor Aggregator Device)
<7>[    0.244715] ACPI: EC: Look up EC in DSDT
<4>[    0.246881] ACPI: Executed 1 blocks of module-level executable AML code
<5>[    0.252265] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
<6>[    0.276459] ACPI: Interpreter enabled
<6>[    0.276666] ACPI: (supports S0 S3 S4 S5)
<6>[    0.276979] ACPI: Using IOAPIC for interrupt routing
<6>[    0.299071] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
<6>[    0.299533] ACPI: No dock devices found.
<6>[    0.299739] PCI: Using host bridge windows from ACPI; if
necessary, use "pci=nocrs" and report a bug
<6>[    0.300178] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
<6>[    0.300467] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
<6>[    0.300668] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
<6>[    0.300822] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
<6>[    0.301046] pci_root PNP0A08:00: host bridge window [mem
0x000c0000-0x000c3fff]
<6>[    0.301270] pci_root PNP0A08:00: host bridge window [mem
0x000c4000-0x000c7fff]
<6>[    0.303970] pci_root PNP0A08:00: host bridge window [mem
0x000c8000-0x000cbfff]
<6>[    0.304122] pci_root PNP0A08:00: host bridge window [mem
0x000cc000-0x000cffff]
<6>[    0.304319] pci_root PNP0A08:00: host bridge window [mem
0x000d0000-0x000d3fff]
<6>[    0.304517] pci_root PNP0A08:00: host bridge window [mem
0x000d4000-0x000d7fff]
<6>[    0.304716] pci_root PNP0A08:00: host bridge window [mem
0x000d8000-0x000dbfff]
<6>[    0.304914] pci_root PNP0A08:00: host bridge window [mem
0x000dc000-0x000dffff]
<6>[    0.305070] pci_root PNP0A08:00: host bridge window [mem
0x000e0000-0x000e3fff]
<6>[    0.305268] pci_root PNP0A08:00: host bridge window [mem
0x000e4000-0x000e7fff]
<6>[    0.305468] pci_root PNP0A08:00: host bridge window [mem
0x000e8000-0x000ebfff]
<6>[    0.305666] pci_root PNP0A08:00: host bridge window [mem
0x000ec000-0x000effff]
<6>[    0.305864] pci_root PNP0A08:00: host bridge window [mem
0xe0000000-0xf7ffffff]
<6>[    0.306055] pci_root PNP0A08:00: host bridge window [mem
0xfc000000-0xfed3ffff]
<6>[    0.306253] pci_root PNP0A08:00: host bridge window [mem
0xfed45000-0xffffffff]
<6>[    0.306456] pci_root PNP0A08:00: ignoring host bridge window
[mem 0x000cc000-0x000cffff] (conflicts with Video ROM [mem
0x000c0000-0x000cf1ff])
<6>[    0.307050] PCI host bridge to bus 0000:00
<6>[    0.307200] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
<6>[    0.307340] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
<6>[    0.307480] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
<6>[    0.307620] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
<6>[    0.307760] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
<6>[    0.307900] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
<6>[    0.308040] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
<6>[    0.308134] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
<6>[    0.308274] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
<6>[    0.308414] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
<6>[    0.308554] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
<6>[    0.308694] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
<6>[    0.308834] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
<6>[    0.308974] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
<6>[    0.309082] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xf7ffffff]
<6>[    0.309222] pci_bus 0000:00: root bus resource [mem 0xfc000000-0xfed3ffff]
<6>[    0.309362] pci_bus 0000:00: root bus resource [mem 0xfed45000-0xffffffff]
<7>[    0.309525] pci 0000:00:00.0: [1022:1705] type 00 class 0x060000
<7>[    0.309571] pci 0000:00:01.0: [1002:9641] type 00 class 0x030000
<7>[    0.309580] pci 0000:00:01.0: reg 10: [mem 0xe0000000-0xefffffff pref]
<7>[    0.309586] pci 0000:00:01.0: reg 14: [io  0x3000-0x30ff]
<7>[    0.309592] pci 0000:00:01.0: reg 18: [mem 0xf0300000-0xf033ffff]
<7>[    0.309634] pci 0000:00:01.0: supports D1 D2
<7>[    0.309650] pci 0000:00:01.1: [1002:1714] type 00 class 0x040300
<7>[    0.309657] pci 0000:00:01.1: reg 10: [mem 0xf0344000-0xf0347fff]
<7>[    0.309706] pci 0000:00:01.1: supports D1 D2
<7>[    0.309773] pci 0000:00:04.0: [1022:1709] type 01 class 0x060400
<7>[    0.309823] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
<7>[    0.309841] pci 0000:00:05.0: [1022:170a] type 01 class 0x060400
<7>[    0.309890] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
<7>[    0.309908] pci 0000:00:06.0: [1022:170b] type 01 class 0x060400
<7>[    0.309957] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
<7>[    0.310053] pci 0000:00:10.0: [1022:7812] type 00 class 0x0c0330
<7>[    0.310079] pci 0000:00:10.0: reg 10: [mem 0xf0348000-0xf0349fff 64bit]
<7>[    0.310215] pci 0000:00:10.0: PME# supported from D0 D3hot D3cold
<7>[    0.310271] pci 0000:00:10.1: [1022:7812] type 00 class 0x0c0330
<7>[    0.310296] pci 0000:00:10.1: reg 10: [mem 0xf034a000-0xf034bfff 64bit]
<7>[    0.310432] pci 0000:00:10.1: PME# supported from D0 D3hot D3cold
<7>[    0.310477] pci 0000:00:11.0: [1022:7804] type 00 class 0x010601
<7>[    0.310497] pci 0000:00:11.0: reg 10: [io  0x3138-0x313f]
<7>[    0.310507] pci 0000:00:11.0: reg 14: [io  0x314c-0x314f]
<7>[    0.310516] pci 0000:00:11.0: reg 18: [io  0x3130-0x3137]
<7>[    0.310526] pci 0000:00:11.0: reg 1c: [io  0x3148-0x314b]
<7>[    0.310536] pci 0000:00:11.0: reg 20: [io  0x3110-0x311f]
<7>[    0.310546] pci 0000:00:11.0: reg 24: [mem 0xf0350000-0xf03507ff]
<7>[    0.310606] pci 0000:00:12.0: [1022:7807] type 00 class 0x0c0310
<7>[    0.310620] pci 0000:00:12.0: reg 10: [mem 0xf034f000-0xf034ffff]
<7>[    0.310692] pci 0000:00:12.2: [1022:7808] type 00 class 0x0c0320
<7>[    0.311166] pci 0000:00:12.2: reg 10: [mem 0xf034e000-0xf034e0ff]
<7>[    0.314099] pci 0000:00:12.2: supports D1 D2
<7>[    0.314101] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
<7>[    0.314125] pci 0000:00:13.0: [1022:7807] type 00 class 0x0c0310
<7>[    0.314138] pci 0000:00:13.0: reg 10: [mem 0xf034d000-0xf034dfff]
<7>[    0.314213] pci 0000:00:13.2: [1022:7808] type 00 class 0x0c0320
<7>[    0.314647] pci 0000:00:13.2: reg 10: [mem 0xf034c000-0xf034c0ff]
<7>[    0.317595] pci 0000:00:13.2: supports D1 D2
<7>[    0.317596] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
<7>[    0.317621] pci 0000:00:14.0: [1022:780b] type 00 class 0x0c0500
<7>[    0.317696] pci 0000:00:14.1: [1022:780c] type 00 class 0x01018f
<7>[    0.317710] pci 0000:00:14.1: reg 10: [io  0x3128-0x312f]
<7>[    0.317720] pci 0000:00:14.1: reg 14: [io  0x3144-0x3147]
<7>[    0.317730] pci 0000:00:14.1: reg 18: [io  0x3120-0x3127]
<7>[    0.317739] pci 0000:00:14.1: reg 1c: [io  0x3140-0x3143]
<7>[    0.317749] pci 0000:00:14.1: reg 20: [io  0x3100-0x310f]
<7>[    0.317789] pci 0000:00:14.2: [1022:780d] type 00 class 0x040300
<7>[    0.317811] pci 0000:00:14.2: reg 10: [mem 0xf0340000-0xf0343fff 64bit]
<7>[    0.317879] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
<7>[    0.317895] pci 0000:00:14.3: [1022:780e] type 00 class 0x060100
<7>[    0.317974] pci 0000:00:14.4: [1022:780f] type 01 class 0x060401
<7>[    0.318025] pci 0000:00:18.0: [1022:1700] type 00 class 0x060000
<7>[    0.318060] pci 0000:00:18.1: [1022:1701] type 00 class 0x060000
<7>[    0.318091] pci 0000:00:18.2: [1022:1702] type 00 class 0x060000
<7>[    0.318123] pci 0000:00:18.3: [1022:1703] type 00 class 0x060000
<7>[    0.318164] pci 0000:00:18.4: [1022:1704] type 00 class 0x060000
<7>[    0.318194] pci 0000:00:18.5: [1022:1718] type 00 class 0x060000
<7>[    0.318225] pci 0000:00:18.6: [1022:1716] type 00 class 0x060000
<7>[    0.318256] pci 0000:00:18.7: [1022:1719] type 00 class 0x060000
<7>[    0.318385] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
<7>[    0.318399] pci 0000:01:00.0: reg 10: [io  0x2000-0x20ff]
<7>[    0.318422] pci 0000:01:00.0: reg 18: [mem 0xf0004000-0xf0004fff
64bit pref]
<7>[    0.318438] pci 0000:01:00.0: reg 20: [mem 0xf0000000-0xf0003fff
64bit pref]
<7>[    0.318499] pci 0000:01:00.0: supports D1 D2
<7>[    0.318501] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<6>[    0.325593] pci 0000:00:04.0: PCI bridge to [bus 01-01]
<7>[    0.325808] pci 0000:00:04.0:   bridge window [io  0x2000-0x2fff]
<7>[    0.325815] pci 0000:00:04.0:   bridge window [mem
0xf0000000-0xf00fffff 64bit pref]
<7>[    0.325895] pci 0000:02:00.0: [14e4:4727] type 00 class 0x028000
<7>[    0.325918] pci 0000:02:00.0: reg 10: [mem 0xf0200000-0xf0203fff 64bit]
<7>[    0.326032] pci 0000:02:00.0: supports D1 D2
<6>[    0.333595] pci 0000:00:05.0: PCI bridge to [bus 02-02]
<7>[    0.333812] pci 0000:00:05.0:   bridge window [mem 0xf0200000-0xf02fffff]
<7>[    0.333876] pci 0000:03:00.0: [10ec:5209] type 00 class 0xff0000
<7>[    0.333893] pci 0000:03:00.0: reg 10: [mem 0xf0100000-0xf0100fff]
<7>[    0.334003] pci 0000:03:00.0: supports D1 D2
<7>[    0.334005] pci 0000:03:00.0: PME# supported from D1 D2 D3hot
<6>[    0.341566] pci 0000:00:06.0: PCI bridge to [bus 03-03]
<7>[    0.341782] pci 0000:00:06.0:   bridge window [mem 0xf0100000-0xf01fffff]
<6>[    0.341863] pci 0000:00:14.4: PCI bridge to [bus 04-04]
(subtractive decode)
<7>[    0.342003] pci 0000:00:14.4:   bridge window [io
0x0000-0x0cf7] (subtractive decode)
<7>[    0.342005] pci 0000:00:14.4:   bridge window [io
0x0d00-0xffff] (subtractive decode)
<7>[    0.342007] pci 0000:00:14.4:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
<7>[    0.342010] pci 0000:00:14.4:   bridge window [mem
0x000c0000-0x000c3fff] (subtractive decode)
<7>[    0.342012] pci 0000:00:14.4:   bridge window [mem
0x000c4000-0x000c7fff] (subtractive decode)
<7>[    0.342014] pci 0000:00:14.4:   bridge window [mem
0x000c8000-0x000cbfff] (subtractive decode)
<7>[    0.342016] pci 0000:00:14.4:   bridge window [mem
0x000d0000-0x000d3fff] (subtractive decode)
<7>[    0.342018] pci 0000:00:14.4:   bridge window [mem
0x000d4000-0x000d7fff] (subtractive decode)
<7>[    0.342021] pci 0000:00:14.4:   bridge window [mem
0x000d8000-0x000dbfff] (subtractive decode)
<7>[    0.342023] pci 0000:00:14.4:   bridge window [mem
0x000dc000-0x000dffff] (subtractive decode)
<7>[    0.342025] pci 0000:00:14.4:   bridge window [mem
0x000e0000-0x000e3fff] (subtractive decode)
<7>[    0.342027] pci 0000:00:14.4:   bridge window [mem
0x000e4000-0x000e7fff] (subtractive decode)
<7>[    0.342029] pci 0000:00:14.4:   bridge window [mem
0x000e8000-0x000ebfff] (subtractive decode)
<7>[    0.342031] pci 0000:00:14.4:   bridge window [mem
0x000ec000-0x000effff] (subtractive decode)
<7>[    0.342034] pci 0000:00:14.4:   bridge window [mem
0xe0000000-0xf7ffffff] (subtractive decode)
<7>[    0.342036] pci 0000:00:14.4:   bridge window [mem
0xfc000000-0xfed3ffff] (subtractive decode)
<7>[    0.342038] pci 0000:00:14.4:   bridge window [mem
0xfed45000-0xffffffff] (subtractive decode)
<7>[    0.342062] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<7>[    0.342231] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB4_._PRT]
<7>[    0.342262] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
<7>[    0.342290] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
<7>[    0.342363] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
<6>[    0.342490]  pci0000:00: Requesting ACPI _OSC control (0x1d)
<6>[    0.342831]  pci0000:00: ACPI _OSC control (0x19) granted
<6>[    0.355798] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11
12 14 15) *0
<6>[    0.356379] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11
12 14 15) *0
<6>[    0.356983] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11
12 14 15) *0
<6>[    0.357568] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11
12 14 15) *0
<6>[    0.358136] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11
12 14 15) *0
<6>[    0.358718] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11
12 14 15) *0
<6>[    0.359270] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11
12 14 15) *0
<6>[    0.359853] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11
12 14 15) *0
<6>[    0.361103] vgaarb: device added:
PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
<6>[    0.361404] vgaarb: loaded
<6>[    0.361555] vgaarb: bridge control possible 0000:00:01.0
<5>[    0.361949] SCSI subsystem initialized
<7>[    0.362513] libata version 3.00 loaded.
<6>[    0.363209] usbcore: registered new interface driver usbfs
<6>[    0.363480] usbcore: registered new interface driver hub
<6>[    0.363773] usbcore: registered new device driver usb
<6>[    0.364147] Linux media interface: v0.10
<6>[    0.364410] Linux video capture interface: v2.00
<6>[    0.365185] Advanced Linux Sound Architecture Driver Version 1.0.25.
<6>[    0.365383] PCI: Using ACPI for IRQ routing
<7>[    0.367747] PCI: pci_cache_line_size set to 64 bytes
<7>[    0.367866] reserve RAM buffer: 000000000009f800 - 000000000009ffff
<7>[    0.367869] reserve RAM buffer: 00000000bfb3f000 - 00000000bfffffff
<7>[    0.367871] reserve RAM buffer: 00000000bff00000 - 00000000bfffffff
<7>[    0.367873] reserve RAM buffer: 000000019f000000 - 000000019fffffff
<6>[    0.368413] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma
Technologies Inc.
<6>[    0.368694] NET: Registered protocol family 8
<6>[    0.368846] NET: Registered protocol family 20
<6>[    0.369260] cfg80211: Calling CRDA to update world regulatory domain
<6>[    0.369366] NetLabel: Initializing
<6>[    0.369368] NetLabel:  domain hash size = 128
<6>[    0.369369] NetLabel:  protocols = UNLABELED CIPSOv4
<6>[    0.369386] NetLabel:  unlabeled traffic allowed by default
<6>[    0.369763] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
<6>[    0.369767] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
<6>[    0.372796] Switching to clocksource hpet
<6>[    0.376044] pnp: PnP ACPI init
<6>[    0.376230] ACPI: bus type pnp registered
<7>[    0.376483] pnp 00:00: [bus 00-ff]
<7>[    0.376486] pnp 00:00: [io  0x0000-0x0cf7 window]
<7>[    0.376488] pnp 00:00: [io  0x0d00-0xffff window]
<7>[    0.376490] pnp 00:00: [mem 0x000a0000-0x000bffff window]
<7>[    0.376492] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
<7>[    0.376493] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
<7>[    0.376495] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
<7>[    0.376497] pnp 00:00: [mem 0x000cc000-0x000cffff window]
<7>[    0.376499] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
<7>[    0.376501] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
<7>[    0.376503] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
<7>[    0.376505] pnp 00:00: [mem 0x000dc000-0x000dffff window]
<7>[    0.376506] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
<7>[    0.376508] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
<7>[    0.376510] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
<7>[    0.376512] pnp 00:00: [mem 0x000ec000-0x000effff window]
<7>[    0.376514] pnp 00:00: [mem 0xe0000000-0xf7ffffff window]
<7>[    0.376516] pnp 00:00: [mem 0xfc000000-0xfed3ffff window]
<7>[    0.376518] pnp 00:00: [mem 0xfed45000-0xffffffff window]
<7>[    0.376519] pnp 00:00: [io  0x0cf8-0x0cff]
<7>[    0.376892] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08
PNP0a03 (active)
<7>[    0.376993] pnp 00:01: [mem 0xfec00000-0xfec00fff]
<7>[    0.376996] pnp 00:01: [mem 0xfee00000-0xfee00fff]
<7>[    0.376998] pnp 00:01: [mem 0xf8000000-0xfbffffff]
<7>[    0.377000] pnp 00:01: [mem 0xfed80000-0xfed80fff]
<7>[    0.377002] pnp 00:01: [mem 0xfed40000-0xfed44fff]
<6>[    0.377250] system 00:01: [mem 0xfec00000-0xfec00fff] could not
be reserved
<6>[    0.377412] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
<6>[    0.377567] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
<6>[    0.377721] system 00:01: [mem 0xfed80000-0xfed80fff] has been reserved
<6>[    0.377875] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
<7>[    0.378000] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    0.378206] pnp 00:02: [irq 0 disabled]
<7>[    0.378217] pnp 00:02: [irq 8]
<7>[    0.378220] pnp 00:02: [mem 0xfed00000-0xfed003ff]
<7>[    0.378395] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
<7>[    0.378482] pnp 00:03: [io  0x0000-0x000f]
<7>[    0.378484] pnp 00:03: [io  0x0081-0x008f]
<7>[    0.378486] pnp 00:03: [io  0x00c0-0x00df]
<7>[    0.378494] pnp 00:03: [dma 4]
<7>[    0.378680] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
<7>[    0.378706] pnp 00:04: [io  0x00f0-0x00fe]
<7>[    0.378762] pnp 00:04: [irq 13]
<7>[    0.378954] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
<7>[    0.379027] pnp 00:05: [io  0x0070-0x0071]
<7>[    0.379210] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
<7>[    0.379235] pnp 00:06: [io  0x0060]
<7>[    0.379237] pnp 00:06: [io  0x0064]
<7>[    0.379295] pnp 00:06: [irq 1]
<7>[    0.379519] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
<7>[    0.379600] pnp 00:07: [irq 12]
<7>[    0.379822] pnp 00:07: Plug and Play ACPI device, IDs SYN1e46
SYN1e00 SYN0002 PNP0f13 (active)
<7>[    0.379846] pnp 00:08: [io  0x0010-0x001f]
<7>[    0.379848] pnp 00:08: [io  0x002e-0x002f]
<7>[    0.379850] pnp 00:08: [io  0x0072-0x0073]
<7>[    0.379852] pnp 00:08: [io  0x0080]
<7>[    0.379854] pnp 00:08: [io  0x00b0-0x00b1]
<7>[    0.379856] pnp 00:08: [io  0x0092]
<7>[    0.379859] pnp 00:08: [io  0x0400-0x04cf]
<7>[    0.379861] pnp 00:08: [io  0x04d0-0x04d1]
<7>[    0.379863] pnp 00:08: [io  0x04d6]
<7>[    0.379865] pnp 00:08: [io  0x0680-0x06ff]
<7>[    0.379867] pnp 00:08: [io  0x077a]
<7>[    0.379869] pnp 00:08: [io  0x0c00-0x0c01]
<7>[    0.379871] pnp 00:08: [io  0x0c14]
<7>[    0.379873] pnp 00:08: [io  0x0c50-0x0c52]
<7>[    0.379875] pnp 00:08: [io  0x0c6c]
<7>[    0.379877] pnp 00:08: [io  0x0c6f]
<7>[    0.379879] pnp 00:08: [io  0x0cd0-0x0cdb]
<7>[    0.379881] pnp 00:08: [io  0x0840-0x0847]
<6>[    0.380015] system 00:08: [io  0x0400-0x04cf] has been reserved
<6>[    0.380172] system 00:08: [io  0x04d0-0x04d1] has been reserved
<6>[    0.380326] system 00:08: [io  0x04d6] has been reserved
<6>[    0.380478] system 00:08: [io  0x0680-0x06ff] has been reserved
<6>[    0.380632] system 00:08: [io  0x077a] has been reserved
<6>[    0.380782] system 00:08: [io  0x0c00-0x0c01] has been reserved
<6>[    0.380945] system 00:08: [io  0x0c14] has been reserved
<6>[    0.381096] system 00:08: [io  0x0c50-0x0c52] has been reserved
<6>[    0.381248] system 00:08: [io  0x0c6c] has been reserved
<6>[    0.381400] system 00:08: [io  0x0c6f] has been reserved
<6>[    0.381544] system 00:08: [io  0x0cd0-0x0cdb] has been reserved
<6>[    0.381684] system 00:08: [io  0x0840-0x0847] has been reserved
<7>[    0.381826] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    0.381901] pnp 00:09: [mem 0x000e0000-0x000fffff]
<7>[    0.381904] pnp 00:09: [mem 0xffe00000-0xffffffff]
<6>[    0.382078] system 00:09: [mem 0x000e0000-0x000fffff] could not
be reserved
<6>[    0.382221] system 00:09: [mem 0xffe00000-0xffffffff] has been reserved
<7>[    0.382364] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
<7>[    0.384122] pnp 00:0a: [irq 23]
<7>[    0.384500] pnp 00:0a: Plug and Play ACPI device, IDs HPQ0004 (active)
<6>[    0.384522] pnp: PnP ACPI: found 11 devices
<6>[    0.384664] ACPI: ACPI bus type pnp unregistered
<6>[    0.398775] pci 0000:00:04.0: PCI bridge to [bus 01-01]
<6>[    0.398901] pci 0000:00:04.0:   bridge window [io  0x2000-0x2fff]
<6>[    0.399056] pci 0000:00:04.0:   bridge window [mem
0xf0000000-0xf00fffff 64bit pref]
<6>[    0.399277] pci 0000:00:05.0: PCI bridge to [bus 02-02]
<6>[    0.399433] pci 0000:00:05.0:   bridge window [mem 0xf0200000-0xf02fffff]
<6>[    0.399590] pci 0000:00:06.0: PCI bridge to [bus 03-03]
<6>[    0.399745] pci 0000:00:06.0:   bridge window [mem 0xf0100000-0xf01fffff]
<6>[    0.399899] pci 0000:00:14.4: PCI bridge to [bus 04-04]
<7>[    0.400098] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>[    0.400100] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
<7>[    0.400102] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    0.400104] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
<7>[    0.400106] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
<7>[    0.400107] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
<7>[    0.400109] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff]
<7>[    0.400111] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff]
<7>[    0.400113] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff]
<7>[    0.400118] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff]
<7>[    0.400121] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff]
<7>[    0.400123] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff]
<7>[    0.400126] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff]
<7>[    0.400129] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff]
<7>[    0.400131] pci_bus 0000:00: resource 18 [mem 0xe0000000-0xf7ffffff]
<7>[    0.400134] pci_bus 0000:00: resource 19 [mem 0xfc000000-0xfed3ffff]
<7>[    0.400136] pci_bus 0000:00: resource 20 [mem 0xfed45000-0xffffffff]
<7>[    0.400139] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
<7>[    0.400142] pci_bus 0000:01: resource 2 [mem
0xf0000000-0xf00fffff 64bit pref]
<7>[    0.400145] pci_bus 0000:02: resource 1 [mem 0xf0200000-0xf02fffff]
<7>[    0.400148] pci_bus 0000:03: resource 1 [mem 0xf0100000-0xf01fffff]
<7>[    0.400151] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
<7>[    0.400153] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
<7>[    0.400155] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    0.400158] pci_bus 0000:04: resource 7 [mem 0x000c0000-0x000c3fff]
<7>[    0.400161] pci_bus 0000:04: resource 8 [mem 0x000c4000-0x000c7fff]
<7>[    0.400163] pci_bus 0000:04: resource 9 [mem 0x000c8000-0x000cbfff]
<7>[    0.400166] pci_bus 0000:04: resource 10 [mem 0x000d0000-0x000d3fff]
<7>[    0.400168] pci_bus 0000:04: resource 11 [mem 0x000d4000-0x000d7fff]
<7>[    0.400171] pci_bus 0000:04: resource 12 [mem 0x000d8000-0x000dbfff]
<7>[    0.400173] pci_bus 0000:04: resource 13 [mem 0x000dc000-0x000dffff]
<7>[    0.400176] pci_bus 0000:04: resource 14 [mem 0x000e0000-0x000e3fff]
<7>[    0.400178] pci_bus 0000:04: resource 15 [mem 0x000e4000-0x000e7fff]
<7>[    0.400181] pci_bus 0000:04: resource 16 [mem 0x000e8000-0x000ebfff]
<7>[    0.400184] pci_bus 0000:04: resource 17 [mem 0x000ec000-0x000effff]
<7>[    0.400186] pci_bus 0000:04: resource 18 [mem 0xe0000000-0xf7ffffff]
<7>[    0.400189] pci_bus 0000:04: resource 19 [mem 0xfc000000-0xfed3ffff]
<7>[    0.400191] pci_bus 0000:04: resource 20 [mem 0xfed45000-0xffffffff]
<6>[    0.400245] NET: Registered protocol family 2
<6>[    0.400664] IP route cache hash table entries: 262144 (order: 9,
2097152 bytes)
<6>[    0.402228] TCP established hash table entries: 524288 (order:
11, 8388608 bytes)
<6>[    0.405160] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
<6>[    0.405691] TCP: Hash tables configured (established 524288 bind 65536)
<6>[    0.405885] TCP: reno registered
<6>[    0.406056] UDP hash table entries: 4096 (order: 5, 131072 bytes)
<6>[    0.406276] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
<6>[    0.406599] NET: Registered protocol family 1
<6>[    0.407155] RPC: Registered named UNIX socket transport module.
<6>[    0.407361] RPC: Registered udp transport module.
<6>[    0.407515] RPC: Registered tcp transport module.
<6>[    0.407668] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>[    0.407831] pci 0000:00:01.0: Boot video device
<7>[    0.600844] PCI: CLS 64 bytes, default 64
<6>[    0.600896] Trying to unpack rootfs image as initramfs...
<6>[    0.636175] Freeing initrd memory: 2212k freed
<6>[    0.637063] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
<6>[    0.637267] Placing 64MB software IO TLB between
ffff8800bbb3f000 - ffff8800bfb3f000
<6>[    0.637491] software IO TLB at phys 0xbbb3f000 - 0xbfb3f000
<3>[    0.638018] kvm: disabled by bios
<6>[    0.638234] Simple Boot Flag at 0x44 set to 0x1
<6>[    0.640103] LVT offset 0 assigned for vector 0x400
<6>[    0.640284] perf: AMD IBS detected (0x000000ff)
<6>[    0.641675] microcode: CPU0: patch_level=0x0300000f
<6>[    0.641841] microcode: CPU1: patch_level=0x0300000f
<6>[    0.642013] microcode: CPU2: patch_level=0x0300000f
<6>[    0.642183] microcode: CPU3: patch_level=0x0300000f
<6>[    0.642539] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
<6>[    0.643919] audit: initializing netlink socket (disabled)
<5>[    0.644143] type=2000 audit(1341928231.528:1): initialized
<6>[    0.668497] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<5>[    0.674817] VFS: Disk quotas dquot_6.5.2
<4>[    0.675163] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<5>[    0.676420] NFS: Registering the id_resolver key type
<6>[    0.676789] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
<6>[    0.676944] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
<6>[    0.677623] fuse init (API version 7.18)
<6>[    0.678745] NILFS version 2 loaded
<6>[    0.679503] Btrfs loaded
<6>[    0.679661] msgmni has been set to 10886
<6>[    0.680801] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
<6>[    0.681022] io scheduler noop registered
<6>[    0.681171] io scheduler deadline registered
<6>[    0.681472] io scheduler cfq registered (default)
<6>[    0.682032] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
<6>[    0.682182] crc32: self tests passed, processed 225944 bytes in
201911 nsec
<6>[    0.682585] crc32c: CRC_LE_BITS = 64
<6>[    0.682734] crc32c: self tests passed, processed 225944 bytes in
124667 nsec
<6>[    0.683484] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<4>[    0.683939] ALI M7101 PMU not found.
<4>[    0.684226] i2c-core: driver [adp8860_bl] using legacy suspend method
<4>[    0.684399] i2c-core: driver [adp8860_bl] using legacy resume method
<4>[    0.684611] i2c-core: driver [adp8870_bl] using legacy suspend method
<4>[    0.684765] i2c-core: driver [adp8870_bl] using legacy resume method
<6>[    1.634945] Refined TSC clocksource calibration: 1896.551 MHz.
<6>[    1.635108] Switching to clocksource tsc
<4>[    2.733144] ACPI: Deprecated procfs I/F for AC is loaded, please
retry with CONFIG_ACPI_PROCFS_POWER cleared
<6>[    2.861253] ACPI: AC Adapter [AC] (off-line)
<6>[    2.862147] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
<6>[    2.865287] ACPI: Power Button [PWRB]
<6>[    2.893281] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
<6>[    2.956997] ACPI: Lid Switch [LID]
<6>[    2.957628] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
<6>[    2.957908] ACPI: Power Button [PWRF]
<6>[    3.175492] acpi device:02: registered as cooling_device0
<6>[    3.176059] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
<6>[    3.176356] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
<7>[    3.177002] ACPI: acpi_idle registered with cpuidle
<4>[    3.191193] ACPI Warning: For \_TZ_.THRM._AL0: Return Package
has no elements (empty) (20120320/nspredef-463)
<3>[    3.191589] ACPI: [Package] has zero elements (ffff880197b96740)
<4>[    3.191744] ACPI: Invalid active0 threshold
<6>[    3.205694] thermal LNXTHERM:00: registered as thermal_zone0
<6>[    3.205900] ACPI: Thermal Zone [THRM] (46 C)
<6>[    3.207800] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<6>[    3.211974] Non-volatile memory driver v1.3
<6>[    3.223073] brd: module loaded
<6>[    3.229057] loop: module loaded
<7>[    3.231343] ahci 0000:00:11.0: version 3.0
<7>[    3.231503] ahci 0000:00:11.0: irq 40 for MSI/MSI-X
<6>[    3.231591] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 2 ports 6
Gbps 0x5 impl SATA mode
<6>[    3.231799] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led
clo pmp pio slum part sxs
<6>[    3.234978] scsi0 : ahci
<6>[    3.235905] scsi1 : ahci
<6>[    3.236759] scsi2 : ahci
<6>[    3.237782] ata1: SATA max UDMA/133 abar m2048@0xf0350000 port
0xf0350100 irq 40
<6>[    3.237990] ata2: DUMMY
<6>[    3.238150] ata3: SATA max UDMA/133 abar m2048@0xf0350000 port
0xf0350200 irq 40
<6>[    3.242079] scsi3 : pata_atiixp
<6>[    3.242941] scsi4 : pata_atiixp
<6>[    3.244429] ata4: PATA max UDMA/100 cmd 0x3128 ctl 0x3144 bmdma
0x3100 irq 17
<6>[    3.244603] ata5: PATA max UDMA/100 cmd 0x3120 ctl 0x3140 bmdma
0x3108 irq 17
<4>[    3.247859] ACPI: Deprecated procfs I/F for battery is loaded,
please retry with CONFIG_ACPI_PROCFS_POWER cleared
<6>[    3.248161] ACPI: Battery Slot [BAT0] (battery present)
<6>[    3.248186] tun: Universal TUN/TAP device driver, 1.6
<6>[    3.248190] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
<6>[    3.251383] usbcore: registered new interface driver libusual
<6>[    3.251854] usbcore: registered new interface driver usbled
<6>[    3.252313] usbcore: registered new interface driver trancevibrator
<6>[    3.253030] i8042: PNP: PS/2 Controller
[PNP0303:KBC0,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
<6>[    3.261240] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[    3.261408] serio: i8042 AUX port at 0x60,0x64 irq 12
<6>[    3.262574] mousedev: PS/2 mouse device common for all mice
<6>[    3.264569] rtc_cmos 00:05: RTC can wake from S4
<6>[    3.265180] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
<6>[    3.265372] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
<6>[    3.266320] usbcore: registered new interface driver uvcvideo
<6>[    3.266523] USB Video Class driver (1.1.1)
<6>[    3.268448] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19)
initialised: dm-devel@redhat.com
<6>[    3.269061] cpuidle: using governor ladder
<6>[    3.269329] cpuidle: using governor menu
<6>[    3.270776] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input4
<6>[    3.278494] usbcore: registered new interface driver usbhid
<6>[    3.278653] usbhid: USB HID core driver
<6>[    3.278809] fujitsu-tablet: Unknown (using defaults)
<6>[    3.279283] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
<6>[    3.279444] AMD IOMMUv2 functionality not available on this sytem
<6>[    3.282397] usbcore: registered new interface driver snd-usb-audio
<6>[    3.282652] Netfilter messages via NETLINK v0.30.
<6>[    3.282853] nfnl_acct: registering with nfnetlink.
<6>[    3.283019] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
<6>[    3.284027] ctnetlink v0.93: registering with nfnetlink.
<5>[    3.284246] ip_set: protocol 6
<6>[    3.284445] IPv4 over IPv4 tunneling driver
<6>[    3.286110] ip_tables: (C) 2000-2006 Netfilter Core Team
<6>[    3.286359] TCP: cubic registered
<6>[    3.286558] Initializing XFRM netlink socket
<6>[    3.288129] NET: Registered protocol family 10
<6>[    3.289089] ip6_tables: (C) 2000-2006 Netfilter Core Team
<6>[    3.289344] IPv6 over IPv4 tunneling driver
<6>[    3.290520] NET: Registered protocol family 17
<5>[    3.290759] Bridge firewalling registered
<6>[    3.290933] lec:lane_module_init: lec.c: initialized
<6>[    3.291088] mpoa:atm_mpoa_init: mpc.c: initialized
<6>[    3.291242] 8021q: 802.1Q VLAN Support v1.8
<6>[    3.294156] DCCP: Activated CCID 2 (TCP-like)
<6>[    3.294328] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
<6>[    3.296215] lib80211: common routines for IEEE802.11 drivers
<7>[    3.296424] lib80211_crypt: registered algorithm 'NULL'
<5>[    3.296426] Registering the dns_resolver key type
<7>[    3.298312] PM: Checking hibernation image partition /dev/sda5
<6>[    3.727438] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<6>[    3.727626] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<6>[    3.728481] ata3.00: ATAPI: hp BD ROM BC-5541H, 2.81, max UDMA/100
<6>[    3.728700] ata1.00: ATA-8: TOSHIBA MK1059GSM, GL002C, max UDMA/100
<6>[    3.728861] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ
(depth 31/32), AA
<6>[    3.730732] ata1.00: configured for UDMA/100
<5>[    3.731394] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA
MK1059GS GL00 PQ: 0 ANSI: 5
<5>[    3.733376] sd 0:0:0:0: [sda] 1953525168 512-byte logical
blocks: (1.00 TB/931 GiB)
<5>[    3.733653] sd 0:0:0:0: [sda] 4096-byte physical blocks
<5>[    3.733849] sd 0:0:0:0: [sda] Write Protect is off
<7>[    3.734007] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>[    3.734026] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
<5>[    3.734275] sd 0:0:0:0: Attached scsi generic sg0 type 0
<6>[    3.748626] ata3.00: configured for UDMA/100
<5>[    3.788318] scsi 2:0:0:0: CD-ROM            hp       BD ROM
BC-5541H  2.81 PQ: 0 ANSI: 5
<6>[    3.808263]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
<4>[    3.808560] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
<6>[    3.808803] cdrom: Uniform CD-ROM driver Revision: 3.20
<7>[    3.810028] sr 2:0:0:0: Attached scsi CD-ROM sr0
<5>[    3.810831] sr 2:0:0:0: Attached scsi generic sg1 type 5
<5>[    3.813418] sd 0:0:0:0: [sda] Attached SCSI disk
<7>[    3.813685] PM: Hibernation image partition 8:5 present
<7>[    3.813689] PM: Looking for hibernation image.
<7>[    3.822861] PM: Image not found (code -22)
<7>[    3.822865] PM: Hibernation image not present or could not be loaded.
<6>[    3.822889] registered taskstats version 1
<6>[    3.824198]   Magic number: 4:921:836
<6>[    3.824429] console [netcon0] enabled
<6>[    3.824628] netconsole: network logging started
<6>[    3.824878] powernow-k8: Found 1 AMD A8-3530MX APU with
Radeon(tm) HD Graphics (4 cpu cores) (version 2.20.00)
<6>[    3.825148] powernow-k8: Core Performance Boosting: on.
<6>[    3.825388] powernow-k8:    0 : pstate 0 (1900 MHz)
<6>[    3.825588] powernow-k8:    1 : pstate 1 (1700 MHz)
<6>[    3.825742] powernow-k8:    2 : pstate 2 (1600 MHz)
<6>[    3.825896] powernow-k8:    3 : pstate 3 (1400 MHz)
<6>[    3.826050] powernow-k8:    4 : pstate 4 (1200 MHz)
<6>[    3.826204] powernow-k8:    5 : pstate 5 (1000 MHz)
<6>[    3.826357] powernow-k8:    6 : pstate 6 (800 MHz)
<6>[    3.827014] ALSA device list:
<6>[    3.827200]   No soundcards found.
<6>[    3.828875] Freeing unused kernel memory: 560k freed
<6>[    3.829203] Write protecting the kernel read-only data: 12288k
<6>[    3.836729] Freeing unused kernel memory: 1484k freed
<6>[    3.843483] Freeing unused kernel memory: 1280k freed
<4>[   21.571528] EXT4-fs (sda3): warning: maximal mount count
reached, running e2fsck is recommended
<6>[   21.573075] EXT4-fs (sda3): recovery complete
<6>[   21.638451] EXT4-fs (sda3): mounted filesystem with ordered data
mode. Opts: (null)
<4>[   21.639069] exe used greatest stack depth: 4888 bytes left
<4>[   46.011140] exe: sending ioctl 5310 to a partition!
<4>[   46.011243] exe: sending ioctl 5310 to a partition!
<4>[   46.094958] exe: sending ioctl 5310 to a partition!
<4>[   46.095180] exe: sending ioctl 5310 to a partition!
<4>[   46.095707] exe: sending ioctl 5395 to a partition!
<4>[   46.095931] exe: sending ioctl 5395 to a partition!
<4>[   46.143754] exe: sending ioctl 5395 to a partition!
<4>[   46.143978] exe: sending ioctl 5395 to a partition!
<4>[   46.241940] UDF-fs: warning (device sda6): udf_fill_super: No
partition found (1)
<3>[   46.302085] NILFS: Can't find nilfs on dev sda6.
<6>[   46.338879] device label BtrfsLinux devid 1 transid 84774 /dev/sda6
<6>[   46.340957] btrfs: disk space caching is enabled
<6>[   46.407373] btrfs: bdev /dev/sda6 errs: wr 0, rd 0, flush 0,
corrupt 0, gen 0
<4>[   47.347484] exe used greatest stack depth: 3720 bytes left
<4>[  119.540481] ------------[ cut here ]------------
<2>[  119.540639] kernel BUG at fs/btrfs/extent-tree.c:1484!
<4>[  119.540811] invalid opcode: 0000 [#1] SMP
<4>[  119.541036] CPU 2
<4>[  119.541076] Modules linked in:
<4>[  119.541402]
<4>[  119.541553] Pid: 1153, comm: btrfs-transacti Not tainted
3.4.0-00091-gcb77fcd #1 Hewlett-Packard HP Pavilion dv6 Notebook
PC/358B
<4>[  119.541930] RIP: 0010:[<ffffffff81268491>]  [<ffffffff81268491>]
lookup_inline_extent_backref+0xb7/0x337
<4>[  119.542199] RSP: 0018:ffff880195aa9a50  EFLAGS: 00010246
<4>[  119.542353] RAX: 0000000000000001 RBX: ffff880198447090 RCX:
0000000000000001
<4>[  119.542510] RDX: ffff880194c8d178 RSI: 0000000000000000 RDI:
ffff8801987945e0
<4>[  119.542667] RBP: ffff880195aa9af0 R08: ffff880195aa9a0c R09:
0000000000000011
<4>[  119.542824] R10: 0000000000000004 R11: 0000000000000001 R12:
ffff88019606e800
<4>[  119.542981] R13: ffff880198469000 R14: 00000000000000b8 R15:
000000a1d43cc000
<4>[  119.543140] FS:  00007f930cbd8700(0000)
GS:ffff88019ed00000(0000) knlGS:0000000000000000
<4>[  119.543361] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<4>[  119.543515] CR2: 0000000001860040 CR3: 0000000001c0b000 CR4:
00000000000007e0
<4>[  119.543672] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
<4>[  119.543830] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
<4>[  119.543988] Process btrfs-transacti (pid: 1153, threadinfo
ffff880195aa8000, task ffff880196620ee0)
<4>[  119.544209] Stack:
<4>[  119.544358]  0000000000014b27 0000000000002ab6 ffff880195aa9b48
ffffffff81278431
<4>[  119.544761]  0000009a9bc00000 ffff880198447090 ffff88019606e800
0000000d000000b8
<4>[  119.545166]  ffff880195aa9af0 ffff880198469000 ffff88019606e800
0000000000000000
<4>[  119.545570] Call Trace:
<4>[  119.545727]  [<ffffffff81278431>] ? btrfs_mark_buffer_dirty+0x77/0xbe
<4>[  119.545887]  [<ffffffff8126901b>] insert_inline_extent_backref+0x57/0xd4
<4>[  119.546048]  [<ffffffff811219a4>] ? kmem_cache_alloc+0x2c/0xfd
<4>[  119.546207]  [<ffffffff8126912b>] __btrfs_inc_extent_ref+0x93/0x1c0
<4>[  119.546366]  [<ffffffff8126b16a>] ? btrfs_reduce_alloc_profile+0x95/0xff
<4>[  119.546526]  [<ffffffff8126da1c>] run_clustered_refs+0x676/0x748
<4>[  119.546686]  [<ffffffff812b2e00>] ? btrfs_check_delayed_seq+0x36/0x39
<4>[  119.546845]  [<ffffffff8126dd26>] btrfs_run_delayed_refs+0x238/0x34b
<4>[  119.547006]  [<ffffffff81260a32>] ? btrfs_free_path+0x22/0x26
<4>[  119.547165]  [<ffffffff812bace8>] ? btrfs_run_delayed_items+0x116/0x130
<4>[  119.547325]  [<ffffffff8127bc8c>] btrfs_commit_transaction+0x3c6/0x8d9
<4>[  119.547485]  [<ffffffff8107d7ad>] ? add_wait_queue+0x44/0x44
<4>[  119.547643]  [<ffffffff810838c7>] ? should_resched+0x9/0x28
<4>[  119.547800]  [<ffffffff8127650c>] transaction_kthread+0x174/0x230
<4>[  119.547960]  [<ffffffff8167e868>] ? _raw_spin_unlock_irqrestore+0x15/0x18
<4>[  119.548119]  [<ffffffff81276398>] ? try_to_freeze+0x38/0x38
<4>[  119.548276]  [<ffffffff8107d0c0>] kthread+0x86/0x8e
<4>[  119.548435]  [<ffffffff81685c64>] kernel_thread_helper+0x4/0x10
<4>[  119.548593]  [<ffffffff8107d03a>] ?
kthread_freezable_should_stop+0x43/0x43
<4>[  119.548753]  [<ffffffff81685c60>] ? gs_change+0x13/0x13
<4>[  119.548907] Code: 00 00 48 89 d9 e8 dd ba ff ff 83 f8 00 0f 8c
54 02 00 00 0f 95 c0 83 7d 30 00 41 0f 94 c4 84 c0 74 0b 45 84 e4 0f
85 5b 02 00 00 <0f> 0b 4c 8b 2b 8b 73 40 4c 89 ef e8 8b e9 ff ff 41 89
c7 49 83
<1>[  119.551560] RIP  [<ffffffff81268491>]
lookup_inline_extent_backref+0xb7/0x337
<4>[  119.551755]  RSP <ffff880195aa9a50>
<4>[  119.551948] ---[ end trace 3d2073fd0732e874 ]---
<4>[  119.552163] btrfs-transacti used greatest stack depth: 3568 bytes left
<6>[  136.029693] SysRq : Show Blocked State
<6>[  136.029906]   task                        PC stack   pid father
<6>[  136.030083] sh              D ffff880197615ce0  4088  1120
1 0x00000000
<4>[  136.030334]  ffff880196215ba8 0000000000000082 ffff880197615940
ffff880196215fd8
<4>[  136.030772]  ffff880196215fd8 0000000000012280 ffff88019789ca60
ffff880197615940
<4>[  136.031211]  ffff880196215bb8 ffff8801986dc000 ffff8801960c9120
ffff880196215bd0
<4>[  136.031649] Call Trace:
<4>[  136.031823]  [<ffffffff8167e031>] schedule+0x5f/0x61
<4>[  136.031995]  [<ffffffff8127b3b2>] wait_current_trans.isra.26+0xb1/0xe7
<4>[  136.032168]  [<ffffffff8107d7ad>] ? add_wait_queue+0x44/0x44
<4>[  136.032338]  [<ffffffff8127c6cc>] start_transaction+0x2a4/0x2b9
<4>[  136.032511]  [<ffffffff81260a32>] ? btrfs_free_path+0x22/0x26
<4>[  136.032682]  [<ffffffff81139363>] ? dentry_cmp+0x31/0x7d
<4>[  136.032852]  [<ffffffff8127c936>] btrfs_start_transaction+0xe/0x10
<4>[  136.033023]  [<ffffffff81286597>] btrfs_create+0x36/0x1b4
<4>[  136.033181]  [<ffffffff811341fe>] vfs_create+0x6b/0x8b
<4>[  136.033338]  [<ffffffff81134cc6>] do_last+0x23a/0x56f
<4>[  136.033493]  [<ffffffff811351c7>] path_openat+0xcb/0x309
<4>[  136.033650]  [<ffffffff8113547c>] ? user_path_at_empty+0x5c/0x8d
<4>[  136.033809]  [<ffffffff811354ee>] do_filp_open+0x33/0x81
<4>[  136.033967]  [<ffffffff811219a4>] ? kmem_cache_alloc+0x2c/0xfd
<4>[  136.034125]  [<ffffffff8113e63d>] ? spin_unlock+0x9/0xd
<4>[  136.034282]  [<ffffffff8113ed47>] ? alloc_fd+0xef/0x101
<4>[  136.034439]  [<ffffffff81128d37>] do_sys_open+0x6a/0xfc
<4>[  136.034595]  [<ffffffff81128de5>] sys_open+0x1c/0x1e
<4>[  136.034752]  [<ffffffff81684af9>] system_call_fastpath+0x16/0x1b
<6>[  145.977623] SysRq : Emergency Sync
<4>[  145.978782] Emergency Sync complete
<6>[  152.869556] SysRq : Emergency Sync
<4>[  152.870486] Emergency Sync complete
<6>[  154.110185] SysRq : Emergency Remount R/O
