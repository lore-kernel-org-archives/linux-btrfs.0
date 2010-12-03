From: C Anthony Risinger <anthony@extof.me>
Subject: Re: disk space caching generation missmatch
Date: Thu, 2 Dec 2010 18:44:49 -0600
Message-ID: <-8250243552832740456@unknownmsgid>
References: <201012011746.14458.johannes.hirte@fem.tu-ilmenau.de>
 <201012012240.29525.johannes.hirte@fem.tu-ilmenau.de> <20101202203410.GC8805@dhcp231-156.rdu.redhat.com>
 <201012030107.54983.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0 (iPhone Mail 7D11)
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012030107.54983.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Did you fix that typo I posted?

C Anthony [mobile]

On Dec 2, 2010, at 6:05 PM, Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de
 > wrote:

> On Thursday 02 December 2010 21:34:10 Josef Bacik wrote:
>> On Wed, Dec 01, 2010 at 10:40:29PM +0100, Johannes Hirte wrote:
>>> On Wednesday 01 December 2010 22:22:45 Johannes Hirte wrote:
>>>> On Wednesday 01 December 2010 21:03:13 Josef Bacik wrote:
>>>>> On Wed, Dec 01, 2010 at 08:56:14PM +0100, Johannes Hirte wrote:
>>>>>> On Wednesday 01 December 2010 18:40:18 Josef Bacik wrote:
>>>>>>> On Wed, Dec 01, 2010 at 05:46:14PM +0100, Johannes Hirte wrote:
>>>>>>>> After enabling disk space caching I've observed several log
>>>>>>>> entries like this:
>>>>>>>>
>>>>>>>> btrfs: free space inode generation (0) did not match free
>>>>>>>> space cache generation (169594) for block group 15464398848
>>>>>>>>
>>>>>>>> I'm not sure, but it seems this happens on every reboot. Is
>>>>>>>> this something to
>>>>>>>> worry about?
>>>>>>>>
>>>>>>>
>>>>>>> So that usually means 1 of a couple of things
>>>>>>>
>>>>>>> 1) You didn't have space for us to save the free space cache
>>>>>>> 2) When trying to write out the cache we hit one of those
>>>>>>> cases where we would
>>>>>>> deadlock so we couldn't write the cache out
>>>>>>>
>>>>>>> It's nothing to worry about, it's doing what it is supposed
>>>>>>> to.  However I'd
>>>>>>> like to know why we're not able to write out the cache.  Are
>>>>>>> you running close
>>>>>>> to full?  Thanks,
>>>>>>>
>>>>>>> Josef
>>>>>>>
>>>>>>
>>>>>> I think there should be enough free space:
>>>>>>
>>>>>
>>
>> Ok it doesn't look like theres an actual problem, we're just being
>> sub-optimal.
>> Take out the other patch and apply this one, boot into that kernel
>> and then
>> reboot and then give me the dmesg.
>
> Here it comes:
>
> Initializing cgroup subsys cpuset
> Linux version 2.6.37-rc4-space-cache-dbg-00022-g620731b-dirty
> (root@netbook) (gcc version 4.5.1 (Gentoo 4.5.1-r1 p1.3,
> pie-0.4.5) ) #126 SMP PREEMPT Fri Dec 3 00:40:04 CET 2010
> Atom PSE erratum detected, BIOS microcode update recommended
> BIOS-provided physical RAM map:
> BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> BIOS-e820: 00000000000dc000 - 00000000000e4000 (reserved)
> BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
> BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
> BIOS-e820: 000000007f6d0000 - 000000007f6e2000 (ACPI data)
> BIOS-e820: 000000007f6e2000 - 000000007f6e3000 (ACPI NVS)
> BIOS-e820: 000000007f6e3000 - 0000000080000000 (reserved)
> BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
> BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
> BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
> BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
> BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
> NX (Execute Disable) protection: active
> DMI present.
> DMI: M912/M912, BIOS R02 05/04/2009
> e820 update range: 0000000000000000 - 0000000000010000 (usable) ==>
> (reserved)
> e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> last_pfn = 0x7f6d0 max_arch_pfn = 0x1000000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
>  00000-9FFFF write-back
>  A0000-BFFFF uncachable
>  C0000-CFFFF write-protect
>  D0000-DFFFF uncachable
>  E0000-FFFFF write-protect
> MTRR variable ranges enabled:
>  0 base 000000000 mask 080000000 write-back
>  1 base 07F700000 mask 0FFF00000 uncachable
>  2 base 07F800000 mask 0FF800000 uncachable
>  3 disabled
>  4 disabled
>  5 disabled
>  6 disabled
>  7 disabled
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> Scanning 0 areas for low memory corruption
> initial memory mapped : 0 - 01a00000
> init_memory_mapping: 0000000000000000-0000000037bfe000
> 0000000000 - 0037bfe000 page 4k
> kernel direct mapping tables up to 37bfe000 @ 183f000-1a00000
> ACPI: RSDP 000f7e40 00024 (v02 GBT   )
> ACPI: XSDT 7f6dc705 00084 (v01 GBT    GBTUACPI 06040000  LTP 00000000)
> ACPI: FACP 7f6e1bd2 000F4 (v03 INTEL  CALISTGA 06040000 ALAN 00000001)
> ACPI: DSDT 7f6dd907 04257 (v01 INTEL  CALISTGA 06040000 INTL 20050624)
> ACPI: FACS 7f6e2fc0 00040
> ACPI: APIC 7f6e1cc6 00068 (v01 INTEL  CALISTGA 06040000 LOHR 0000005A)
> ACPI: HPET 7f6e1d2e 00038 (v01 INTEL  CALISTGA 06040000 LOHR 0000005A)
> ACPI: MCFG 7f6e1d66 0003C (v01 INTEL  CALISTGA 06040000 LOHR 0000005A)
> ACPI: SLIC 7f6e1da2 00176 (v01 GBT    GBTUACPI 06040000 TBD  00000001)
> ACPI: TCPA 7f6e1f18 00032 (v01 PTLTD  CALISTGA 06040000  PTL 00000001)
> ACPI: TMOR 7f6e1f4a 00026 (v01 PTLTD           06040000 PTL  00000003)
> ACPI: APIC 7f6e1f70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
> ACPI: BOOT 7f6e1fd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
> ACPI: SSDT 7f6dcd25 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
> ACPI: SSDT 7f6dcc7f 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050624)
> ACPI: SSDT 7f6dc789 004F6 (v02  PmRef    CpuPm 00003000 INTL 20050624)
> ACPI: BIOS bug: multiple APIC/MADT found, using 0
> ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
> ACPI: Local APIC address 0xfee00000
> 1146MB HIGHMEM available.
> 891MB LOWMEM available.
>  mapped low ram: 0 - 37bfe000
>  low ram: 0 - 37bfe000
> Zone PFN ranges:
>  DMA      0x00000010 -> 0x00001000
>  Normal   0x00001000 -> 0x00037bfe
>  HighMem  0x00037bfe -> 0x0007f6d0
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>    0: 0x00000010 -> 0x0000009f
>    0: 0x00000100 -> 0x0007f6d0
> On node 0 totalpages: 521823
> free_area_init_node: node 0, pgdat c143a9c0, node_mem_map f6c0d200
>  DMA zone: 32 pages used for memmap
>  DMA zone: 0 pages reserved
>  DMA zone: 3951 pages, LIFO batch:0
>  Normal zone: 1752 pages used for memmap
>  Normal zone: 222502 pages, LIFO batch:31
>  HighMem zone: 2294 pages used for memmap
>  HighMem zone: 291292 pages, LIFO batch:31
> Using APIC driver default
> ACPI: PM-Timer IO Port: 0x1008
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x8086a201 base: 0xfed00000
> SMP: Allowing 2 CPUs, 0 hotplug CPUs
> nr_irqs_gsi: 40
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
> PM: Registered nosave memory: 00000000000dc000 - 00000000000e4000
> PM: Registered nosave memory: 00000000000e4000 - 00000000000e8000
> PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
> Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
> setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> PERCPU: Embedded 12 pages/cpu @f6be9000 s25344 r0 d23808 u49152
> pcpu-alloc: s25344 r0 d23808 u49152 alloc=12*4096
> pcpu-alloc: [0] 0 [0] 1
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
> 517745
> Kernel command line: root=/dev/sda1
> PID hash table entries: 4096 (order: 2, 16384 bytes)
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Initializing CPU#0
> Initializing HighMem for node 0 (00037bfe:0007f6d0)
> Memory: 2063060k/2087744k available (3060k kernel code, 24232k
> reserved, 1302k data, 320k init, 1174344k highmem)
> virtual kernel memory layout:
>    fixmap  : 0xfff8f000 - 0xfffff000   ( 448 kB)
>    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
>    vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
>    lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
>      .init : 0xc1443000 - 0xc1493000   ( 320 kB)
>      .data : 0xc12fd1c2 - 0xc1442b44   (1302 kB)
>      .text : 0xc1000000 - 0xc12fd1c2   (3060 kB)
> Checking if this processor honours the WP bit even in supervisor
> mode...Ok.
> SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2,
> Nodes=1
> Preemptable hierarchical RCU implementation.
>        RCU-based detection of stalled CPUs is disabled.
>        Verbose stalled-CPUs detection is disabled.
> NR_IRQS:320
> CPU 0 irqstacks, hard=f6408000 soft=f640a000
> Extended CMOS year: 2000
> Console: colour VGA+ 80x25
> console [tty0] enabled
> hpet clockevent registered
> Fast TSC calibration using PIT
> Detected 1596.309 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer
> frequency.. 3192.61 BogoMIPS (lpj=1596309)
> pid_max: default: 32768 minimum: 301
> Mount-cache hash table entries: 512
> Initializing cgroup subsys ns
> ns_cgroup deprecated: consider using the 'clone_children' flag
> without the ns_cgroup.
> Initializing cgroup subsys cpuacct
> Initializing cgroup subsys freezer
> Atom PSE erratum detected, BIOS microcode update recommended
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> mce: CPU supports 5 MCE banks
> CPU0: Thermal monitoring enabled (TM1)
> using mwait in idle threads.
> Performance Events: PEBS fmt0+, Atom events, Intel PMU driver.
> ... version:                3
> ... bit width:              40
> ... generic registers:      2
> ... value mask:             000000ffffffffff
> ... max period:             000000007fffffff
> ... fixed-purpose events:   3
> ... event mask:             0000000700000003
> ACPI: Core revision 20101013
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
> CPU 1 irqstacks, hard=f645e000 soft=f6460000
> Booting Node   0, Processors  #1 Ok.
> Initializing CPU#1
> Atom PSE erratum detected, BIOS microcode update recommended
> Brought up 2 CPUs
> Total of 2 processors activated (6384.83 BogoMIPS).
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
> 0xe0000000-0xefffffff] (base 0xe0000000)
> PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
> PCI: Using MMCONFIG for extended config space
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> ACPI: EC: Look up EC in DSDT
> [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> ACPI: SSDT 7f6dd5ee 00245 (v02  PmRef  Cpu0Ist 00003000 INTL 20050624)
> ACPI: Dynamic OEM Table Load:
> ACPI: SSDT   (null) 00245 (v02  PmRef  Cpu0Ist 00003000 INTL 20050624)
> ACPI: SSDT 7f6dcf84 005E5 (v02  PmRef  Cpu0Cst 00003001 INTL 20050624)
> ACPI: Dynamic OEM Table Load:
> ACPI: SSDT   (null) 005E5 (v02  PmRef  Cpu0Cst 00003001 INTL 20050624)
> ACPI: SSDT 7f6dd833 000D4 (v02  PmRef  Cpu1Ist 00003000 INTL 20050624)
> ACPI: Dynamic OEM Table Load:
> ACPI: SSDT   (null) 000D4 (v02  PmRef  Cpu1Ist 00003000 INTL 20050624)
> ACPI: SSDT 7f6dd569 00085 (v02  PmRef  Cpu1Cst 00003000 INTL 20050624)
> ACPI: Dynamic OEM Table Load:
> ACPI: SSDT   (null) 00085 (v02  PmRef  Cpu1Cst 00003000 INTL 20050624)
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> ACPI: No dock devices found.
> PCI: Using host bridge windows from ACPI; if necessary, use
> "pci=nocrs" and report a bug
> ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
> pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
> pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
> pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
> pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
> pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
> pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff]
> pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff]
> pci 0000:00:00.0: [8086:27ac] type 0 class 0x000600
> pci 0000:00:02.0: [8086:27ae] type 0 class 0x000300
> pci 0000:00:02.0: reg 10: [mem 0xf2200000-0xf227ffff]
> pci 0000:00:02.0: reg 14: [io  0x1800-0x1807]
> pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
> pci 0000:00:02.0: reg 1c: [mem 0xf2300000-0xf233ffff]
> pci 0000:00:02.1: [8086:27a6] type 0 class 0x000380
> pci 0000:00:02.1: reg 10: [mem 0xf2280000-0xf22fffff]
> pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
> pci 0000:00:1b.0: reg 10: [mem 0xf2540000-0xf2543fff 64bit]
> pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:1b.0: PME# disabled
> pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
> pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:1c.0: PME# disabled
> pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
> pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> pci 0000:00:1c.1: PME# disabled
> pci 0000:00:1c.2: [8086:27d4] type 1 class 0x000604
> pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> pci 0000:00:1c.2: PME# disabled
> pci 0000:00:1c.3: [8086:27d6] type 1 class 0x000604
> pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> pci 0000:00:1c.3: PME# disabled
> pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
> pci 0000:00:1d.0: reg 20: [io  0x1820-0x183f]
> pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
> pci 0000:00:1d.1: reg 20: [io  0x1840-0x185f]
> pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
> pci 0000:00:1d.2: reg 20: [io  0x1860-0x187f]
> pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
> pci 0000:00:1d.3: reg 20: [io  0x1880-0x189f]
> pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
> pci 0000:00:1d.7: reg 10: [mem 0xf2544000-0xf25443ff]
> pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> pci 0000:00:1d.7: PME# disabled
> pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
> pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
> pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/
> GPIO/TCO
> pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
> pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
> pci 0000:00:1f.1: [8086:27df] type 0 class 0x000101
> pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
> pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
> pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
> pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
> pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
> pci 0000:00:1f.2: [8086:27c4] type 0 class 0x000101
> pci 0000:00:1f.2: reg 10: [io  0x18c8-0x18cf]
> pci 0000:00:1f.2: reg 14: [io  0x18c0-0x18c3]
> pci 0000:00:1f.2: reg 18: [io  0x18a8-0x18af]
> pci 0000:00:1f.2: reg 1c: [io  0x180c-0x180f]
> pci 0000:00:1f.2: reg 20: [io  0x18b0-0x18bf]
> pci 0000:00:1f.2: reg 24: [mem 0xf2544400-0xf25447ff]
> pci 0000:00:1f.2: PME# supported from D3hot
> pci 0000:00:1f.2: PME# disabled
> pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
> pci 0000:00:1f.3: reg 20: [io  0x18e0-0x18ff]
> pci 0000:02:00.0: [10ec:8136] type 0 class 0x000200
> pci 0000:02:00.0: reg 10: [io  0x2000-0x20ff]
> pci 0000:02:00.0: reg 18: [mem 0xf2010000-0xf2010fff 64bit pref]
> pci 0000:02:00.0: reg 20: [mem 0xf2000000-0xf200ffff 64bit pref]
> pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> pci 0000:02:00.0: supports D1 D2
> pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot
> pci 0000:02:00.0: PME# disabled
> pci 0000:00:1c.0: PCI bridge to [bus 02-04]
> pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
> pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff]
> (disabled)
> pci 0000:00:1c.0:   bridge window [mem 0xf2000000-0xf20fffff 64bit
> pref]
> pci 0000:05:00.0: [8086:4222] type 0 class 0x000280
> pci 0000:05:00.0: reg 10: [mem 0xf2100000-0xf2100fff]
> pci 0000:05:00.0: PME# supported from D0 D3hot
> pci 0000:05:00.0: PME# disabled
> pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
> enable it with 'pcie_aspm=force'
> pci 0000:00:1c.1: PCI bridge to [bus 05-07]
> pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
> pci 0000:00:1c.1:   bridge window [mem 0xf2100000-0xf21fffff]
> pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref]
> (disabled)
> pci 0000:00:1c.2: PCI bridge to [bus 08-0a]
> pci 0000:00:1c.2:   bridge window [io  0xf000-0x0000] (disabled)
> pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff]
> (disabled)
> pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref]
> (disabled)
> pci 0000:00:1c.3: PCI bridge to [bus 0b-0d]
> pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
> pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf5ffffff]
> pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff 64bit
> pref]
> pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive decode)
> pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
> pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff]
> (disabled)
> pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref]
> (disabled)
> pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive
> decode)
> pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive
> decode)
> pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff]
> (subtractive decode)
> pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff]
> (subtractive decode)
> pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff]
> (subtractive decode)
> pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff]
> (subtractive decode)
> pci 0000:00:1e.0:   bridge window [mem 0x000e4000-0x000e7fff]
> (subtractive decode)
> pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfebfffff]
> (subtractive decode)
> pci_bus 0000:00: on NUMA node 0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 *4 5 6 7 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 1 *3 4 5 6 7 10 12 14 15)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
> ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0,
> disabled.
> ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0,
> disabled.
> ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 *7 10 12 14 15)
> ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 *5 6 7 11 12 14 15)
> vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io
> +mem,locks=none
> vgaarb: loaded
> SCSI subsystem initialized
> libata version 3.00 loaded.
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> PCI: pci_cache_line_size set to 64 bytes
> reserve RAM buffer: 000000000009f800 - 000000000009ffff
> reserve RAM buffer: 000000007f6d0000 - 000000007fffffff
> HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> Switching to clocksource tsc
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp 00:00: [bus 00-ff]
> pnp 00:00: [io  0x0000-0x0cf7 window]
> pnp 00:00: [io  0x0cf8-0x0cff]
> pnp 00:00: [io  0x0d00-0xffff window]
> pnp 00:00: [mem 0x000a0000-0x000bffff window]
> pnp 00:00: [mem 0x000c0000-0x000c3fff window]
> pnp 00:00: [mem 0x000c4000-0x000c7fff window]
> pnp 00:00: [mem 0x000c8000-0x000cbfff window]
> pnp 00:00: [mem 0x000cc000-0x000cffff window]
> pnp 00:00: [mem 0x000d0000-0x000d3fff window]
> pnp 00:00: [mem 0x000d4000-0x000d7fff window]
> pnp 00:00: [mem 0x000d8000-0x000dbfff window]
> pnp 00:00: [mem 0x000dc000-0x000dffff window]
> pnp 00:00: [mem 0x000e0000-0x000e3fff window]
> pnp 00:00: [mem 0x000e4000-0x000e7fff window]
> pnp 00:00: [mem 0x000e8000-0x000ebfff window]
> pnp 00:00: [mem 0x000ec000-0x000effff window]
> pnp 00:00: [mem 0x000f0000-0x000fffff window]
> pnp 00:00: [mem 0x80000000-0xfebfffff window]
> pnp 00:00: [mem 0xfed40000-0xfed44fff window]
> pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
> pnp 00:01: [mem 0xe0000000-0xefffffff]
> pnp 00:01: [mem 0xfed14000-0xfed17fff]
> pnp 00:01: [mem 0xfed18000-0xfed18fff]
> pnp 00:01: [mem 0xfed19000-0xfed19fff]
> pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
> pnp 00:01: [mem 0xfed20000-0xfed3ffff]
> pnp 00:01: [mem 0xfed40000-0xfed44fff]
> pnp 00:01: [mem 0xfed45000-0xfed8ffff]
> pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> pnp 00:02: [io  0x0000-0x001f]
> pnp 00:02: [io  0x0081-0x0091]
> pnp 00:02: [io  0x0093-0x009f]
> pnp 00:02: [io  0x00c0-0x00df]
> pnp 00:02: [dma 4]
> pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
> pnp 00:03: [mem 0xfed00000-0xfed003ff]
> pnp 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
> pnp 00:04: [io  0x00f0]
> pnp 00:04: [irq 13]
> pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
> pnp 00:05: [io  0x002e-0x002f]
> pnp 00:05: [io  0x0061]
> pnp 00:05: [io  0x0063]
> pnp 00:05: [io  0x0065]
> pnp 00:05: [io  0x0067]
> pnp 00:05: [io  0x0070]
> pnp 00:05: [io  0x0080]
> pnp 00:05: [io  0x0092]
> pnp 00:05: [io  0x00b2-0x00b3]
> pnp 00:05: [io  0x0680-0x069f]
> pnp 00:05: [io  0x0800-0x080f]
> pnp 00:05: [io  0x1000-0x107f]
> pnp 00:05: [io  0x1180-0x11bf]
> pnp 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
> pnp 00:06: [io  0x0070-0x0077]
> pnp 00:06: [irq 8]
> pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
> pnp 00:07: [io  0x0060]
> pnp 00:07: [io  0x0064]
> pnp 00:07: [irq 1]
> pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
> pnp 00:08: [irq 12]
> pnp 00:08: Plug and Play ACPI device, IDs PNP0f13 (active)
> pnp: PnP ACPI: found 9 devices
> ACPI: ACPI bus type pnp unregistered
> system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
> system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
> system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
> system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
> system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
> system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
> system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
> system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
> system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
> system 00:05: [io  0x0680-0x069f] has been reserved
> system 00:05: [io  0x0800-0x080f] has been reserved
> system 00:05: [io  0x1000-0x107f] has been reserved
> system 00:05: [io  0x1180-0x11bf] has been reserved
> pci 0000:00:1c.0: BAR 8: assigned [mem 0xfe800000-0xfebfffff]
> pci 0000:00:1c.1: BAR 9: assigned [mem 0xfe600000-0xfe7fffff 64bit
> pref]
> pci 0000:00:1c.2: BAR 8: assigned [mem 0xfe400000-0xfe5fffff]
> pci 0000:00:1c.2: BAR 9: assigned [mem 0xfe200000-0xfe3fffff 64bit
> pref]
> pci 0000:00:1c.1: BAR 7: assigned [io  0xf000-0xffff]
> pci 0000:00:1c.2: BAR 7: assigned [io  0xe000-0xefff]
> pci 0000:02:00.0: BAR 6: assigned [mem 0xf20e0000-0xf20fffff pref]
> pci 0000:00:1c.0: PCI bridge to [bus 02-04]
> pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
> pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfebfffff]
> pci 0000:00:1c.0:   bridge window [mem 0xf2000000-0xf20fffff 64bit
> pref]
> pci 0000:00:1c.1: PCI bridge to [bus 05-07]
> pci 0000:00:1c.1:   bridge window [io  0xf000-0xffff]
> pci 0000:00:1c.1:   bridge window [mem 0xf2100000-0xf21fffff]
> pci 0000:00:1c.1:   bridge window [mem 0xfe600000-0xfe7fffff 64bit
> pref]
> pci 0000:00:1c.2: PCI bridge to [bus 08-0a]
> pci 0000:00:1c.2:   bridge window [io  0xe000-0xefff]
> pci 0000:00:1c.2:   bridge window [mem 0xfe400000-0xfe5fffff]
> pci 0000:00:1c.2:   bridge window [mem 0xfe200000-0xfe3fffff 64bit
> pref]
> pci 0000:00:1c.3: PCI bridge to [bus 0b-0d]
> pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
> pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf5ffffff]
> pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff 64bit
> pref]
> pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
> pci 0000:00:1e.0:   bridge window [io  disabled]
> pci 0000:00:1e.0:   bridge window [mem disabled]
> pci 0000:00:1e.0:   bridge window [mem pref disabled]
> pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> pci 0000:00:1c.0: setting latency timer to 64
> pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
> pci 0000:00:1c.1: setting latency timer to 64
> pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> pci 0000:00:1c.2: setting latency timer to 64
> pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> pci 0000:00:1c.3: setting latency timer to 64
> pci 0000:00:1e.0: setting latency timer to 64
> pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
> pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
> pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
> pci_bus 0000:00: resource 10 [mem 0x000e4000-0x000e7fff]
> pci_bus 0000:00: resource 11 [mem 0x80000000-0xfebfffff]
> pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
> pci_bus 0000:02: resource 1 [mem 0xfe800000-0xfebfffff]
> pci_bus 0000:02: resource 2 [mem 0xf2000000-0xf20fffff 64bit pref]
> pci_bus 0000:05: resource 0 [io  0xf000-0xffff]
> pci_bus 0000:05: resource 1 [mem 0xf2100000-0xf21fffff]
> pci_bus 0000:05: resource 2 [mem 0xfe600000-0xfe7fffff 64bit pref]
> pci_bus 0000:08: resource 0 [io  0xe000-0xefff]
> pci_bus 0000:08: resource 1 [mem 0xfe400000-0xfe5fffff]
> pci_bus 0000:08: resource 2 [mem 0xfe200000-0xfe3fffff 64bit pref]
> pci_bus 0000:0b: resource 0 [io  0x3000-0x3fff]
> pci_bus 0000:0b: resource 1 [mem 0xf4000000-0xf5ffffff]
> pci_bus 0000:0b: resource 2 [mem 0xf0000000-0xf1ffffff 64bit pref]
> pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
> pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
> pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
> pci_bus 0000:0e: resource 7 [mem 0x000d0000-0x000d3fff]
> pci_bus 0000:0e: resource 8 [mem 0x000d4000-0x000d7fff]
> pci_bus 0000:0e: resource 9 [mem 0x000d8000-0x000dbfff]
> pci_bus 0000:0e: resource 10 [mem 0x000e4000-0x000e7fff]
> pci_bus 0000:0e: resource 11 [mem 0x80000000-0xfebfffff]
> NET: Registered protocol family 2
> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> UDP hash table entries: 512 (order: 2, 16384 bytes)
> UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> NET: Registered protocol family 1
> pci 0000:00:02.0: Boot video device
> PCI: CLS 64 bytes, default 64
> Simple Boot Flag at 0x36 set to 0x80
> Scanning for low memory corruption every 60 seconds
> highmem bounce pool size: 64 pages
> HugeTLB registered 2 MB page size, pre-allocated 0 pages
> Btrfs loaded
> msgmni has been set to 1735
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> io scheduler noop registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> intel_idle: MWAIT substates: 0x20220
> intel_idle: v0.4 model 0x1C
> intel_idle: lapic_timer_reliable_states 0x2
> Marking TSC unstable due to TSC halts in idle states deeper than C2
> Switching to clocksource hpet
> ACPI: AC Adapter [ADP1] (on-line)
> input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/
> input0
> ACPI: Lid Switch [LID0]
> input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/
> input/input1
> ACPI: Power Button [PWRB]
> input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/
> input/input2
> ACPI: Sleep Button [SLPB]
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
> ACPI: Power Button [PWRF]
> acpi device:04: registered as cooling_device0
> input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/
> LNXVIDEO:00/input/input4
> ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> ACPI: acpi_idle yielding to intel_idle
> thermal LNXTHERM:00: registered as thermal_zone0
> ACPI: Thermal Zone [TZ00] (58 C)
> Non-volatile memory driver v1.3
> intel_rng: FWH not detected
> Linux agpgart interface v0.103
> agpgart-intel 0000:00:00.0: Intel 945GME Chipset
> agpgart-intel 0000:00:00.0: detected gtt size: 262144K total,
> 262144K mappable
> agpgart-intel 0000:00:00.0: detected 8192K stolen memory
> agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> [drm] Initialized drm 1.1.0 20060810
> i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> i915 0000:00:02.0: setting latency timer to 64
> ACPI: Battery Slot [BAT0] (battery present)
> vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io
> +mem,decodes=io+mem:owns=io+mem
> [drm] initialized overlay support
> Console: switching to colour frame buffer device 160x48
> fb0: inteldrmfb frame buffer device
> drm: registered panic notifier
> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> brd: module loaded
> loop: module loaded
> ata_piix 0000:00:1f.1: version 2.13
> ata_piix 0000:00:1f.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> ata_piix 0000:00:1f.1: setting latency timer to 64
> scsi0 : ata_piix
> scsi1 : ata_piix
> ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
> ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
> ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> ata_piix 0000:00:1f.2: MAP [
> ata2: port disabled. ignoring.
> P0 P2 -- -- ]
> ata_piix 0000:00:1f.2: setting latency timer to 64
> scsi2 : ata_piix
> scsi3 : ata_piix
> ata3: SATA max UDMA/133 cmd 0x18c8 ctl 0x18c0 bmdma 0x18b0 irq 19
> ata4: SATA max UDMA/133 cmd 0x18a8 ctl 0x180c bmdma 0x18b8 irq 19
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> ehci_hcd 0000:00:1d.7: setting latency timer to 64
> ehci_hcd 0000:00:1d.7: EHCI Host Controller
> ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> ehci_hcd 0000:00:1d.7: using broken periodic workaround
> ehci_hcd 0000:00:1d.7: debug port 1
> ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
> ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf2544000
> ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb1: Product: EHCI Host Controller
> usb usb1: Manufacturer: Linux 2.6.37-rc4-space-cache-dbg-00022-
> g620731b-dirty ehci_hcd
> usb usb1: SerialNumber: 0000:00:1d.7
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 8 ports detected
> usbcore: registered new interface driver libusual
> PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> rtc_cmos 00:06: RTC can wake from S4
> input: AT Translated Set 2 keyboard as /devices/platform/i8042/
> serio0/input/input5
> rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
> rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
> cpuidle: using governor ladder
> cpuidle: using governor menu
> usbcore: registered new interface driver usbhid
> usbhid: USB HID core driver
> Netfilter messages via NETLINK v0.30.
> nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> ata3.00: ATA-8: FUJITSU MHZ2160BH G2, 00000009, max UDMA/100
> ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ctnetlink v0.93: registering with nfnetlink.
> ip_tables: (C) 2000-2006 Netfilter Core Team
> ata3.00: configured for UDMA/100
> scsi 2:0:0:0: Direct-Access     ATA      FUJITSU MHZ2160B 0000 PQ: 0
> ANSI: 5
> sd 2:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> TCP cubic registered
> Initializing XFRM netlink socket
> sda: sda1 sda2 sda3
> NET: Registered protocol family 10
> sd 2:0:0:0: [sda] Attached SCSI disk
> ip6_tables: (C) 2000-2006 Netfilter Core Team
> IPv6 over IPv4 tunneling driver
> NET: Registered protocol family 17
> Registering the dns_resolver key type
> Using IPI No-Shortcut mode
> PM: Hibernation image not present or could not be loaded.
> usb 1-4: new high speed USB device using ehci_hcd and address 4
> usb 1-4: New USB device found, idVendor=04b4, idProduct=6560
> usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> hub 1-4:1.0: USB hub found
> hub 1-4:1.0: 4 ports detected
> usb 1-5: new high speed USB device using ehci_hcd and address 5
> usb 1-5: New USB device found, idVendor=0bda, idProduct=0158
> usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-5: Product: USB2.0-CRW
> usb 1-5: Manufacturer: Generic
> usb 1-5: SerialNumber: 20071114173400000
> usb 1-8: new high speed USB device using ehci_hcd and address 6
> Synaptics Touchpad, model: 1, fw: 6.5, id: 0x1c0b1, caps:
> 0xa04711/0xa00000/0x0
> input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/
> input/input6
> device fsid 934f652e9ceed7bf-d450164d90359d9f devid 1 transid
> 119198 /dev/root
> btrfs: disk space caching is enabled
> usb 1-8: New USB device found, idVendor=05e3, idProduct=0505
> usb 1-8: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> usb 1-8: Product: USB 2.0 Camera
> usb 1-4.1: new full speed USB device using ehci_hcd and address 7
> usb 1-4.1: New USB device found, idVendor=14e1, idProduct=6000
> usb 1-4.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 1-4.1: Product: PenMount USB
> usb 1-4.1: Manufacturer: DIALOGUE INC
> input: DIALOGUE INC PenMount USB as /devices/pci0000:00/0000:00:1d.7/
> usb1/1-4/1-4.1/1-4.1:1.0/input/input7
> generic-usb 0003:14E1:6000.0001: input,hidraw0: USB HID v0.01 Mouse
> [DIALOGUE INC PenMount USB] on usb-0000:00:1d.7-4.1/input0
> usb 1-4.2: new full speed USB device using ehci_hcd and address 8
> usb 1-4.2: New USB device found, idVendor=13d3, idProduct=3250
> usb 1-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-4.2: Product: Bluetooth2.1module
> usb 1-4.2: Manufacturer: Broadcom Corp
> usb 1-4.2: SerialNumber: 002243A85BBA
> VFS: Mounted root (btrfs filesystem) readonly on device 0:11.
> Freeing unused kernel memory: 320k freed
> Write protecting the kernel text: 3064k
> Write protecting the kernel read-only data: 1036k
> udev[886]: starting version 164
> sd 2:0:0:0: Attached scsi generic sg0 type 0
> i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> ACPI: resource 0000:00:1f.3 [io  0x18e0-0x18ff] conflicts with ACPI
> region SMBI [??? 0x000018e0-0x000018ef flags 0x49]
> ACPI: If an ACPI driver is available for this device, you should use
> it instead of the native driver
> uhci_hcd: USB Universal Host Controller Interface driver
> uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> uhci_hcd 0000:00:1d.0: setting latency timer to 64
> uhci_hcd 0000:00:1d.0: UHCI Host Controller
> uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001820
> usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb2: Product: UHCI Host Controller
> usb usb2: Manufacturer: Linux 2.6.37-rc4-space-cache-dbg-00022-
> g620731b-dirty uhci_hcd
> usb usb2: SerialNumber: 0000:00:1d.0
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> uhci_hcd 0000:00:1d.1: setting latency timer to 64
> uhci_hcd 0000:00:1d.1: UHCI Host Controller
> uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001840
> usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb3: Product: UHCI Host Controller
> usb usb3: Manufacturer: Linux 2.6.37-rc4-space-cache-dbg-00022-
> g620731b-dirty uhci_hcd
> usb usb3: SerialNumber: 0000:00:1d.1
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 2 ports detected
> uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> uhci_hcd 0000:00:1d.2: setting latency timer to 64
> uhci_hcd 0000:00:1d.2: UHCI Host Controller
> uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
> usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb4: Product: UHCI Host Controller
> usb usb4: Manufacturer: Linux 2.6.37-rc4-space-cache-dbg-00022-
> g620731b-dirty uhci_hcd
> usb usb4: SerialNumber: 0000:00:1d.2
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 2 ports detected
> uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
> uhci_hcd 0000:00:1d.3: setting latency timer to 64
> uhci_hcd 0000:00:1d.3: UHCI Host Controller
> uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001880
> usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb5: Product: UHCI Host Controller
> usb usb5: Manufacturer: Linux 2.6.37-rc4-space-cache-dbg-00022-
> g620731b-dirty uhci_hcd
> usb usb5: SerialNumber: 0000:00:1d.3
> hub 5-0:1.0: USB hub found
> hub 5-0:1.0: 2 ports detected
> r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> r8169 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> r8169 0000:02:00.0: setting latency timer to 64
> r8169 0000:02:00.0: irq 40 for MSI/MSI-X
> r8169 0000:02:00.0: eth0: RTL8102e at 0xf87fe000, 00:1f:d0:ad:f6:29,
> XID 14a00000 IRQ 40
> cfg80211: Calling CRDA to update world regulatory domain
> usb 2-1: new low speed USB device using uhci_hcd and address 2
> Bluetooth: Core ver 2.15
> NET: Registered protocol family 31
> Bluetooth: HCI device and connection manager initialized
> Bluetooth: HCI socket layer initialized
> HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
> HDA Intel 0000:00:1b.0: setting latency timer to 64
> usb 2-1: New USB device found, idVendor=413c, idProduct=2003
> usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 2-1: Product: Dell USB Keyboard
> usb 2-1: Manufacturer: Dell
> input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1d.0/
> usb2/2-1/2-1:1.0/input/input8
> generic-usb 0003:413C:2003.0002: input,hidraw1: USB HID v1.10
> Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.0-1/input0
> usb 2-2: new low speed USB device using uhci_hcd and address 3
> usb 2-2: New USB device found, idVendor=0461, idProduct=4d51
> usb 2-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
> usb 2-2: Product: DELL Laser Mouse
> input: DELL Laser Mouse as /devices/pci0000:00/0000:00:1d.0/
> usb2/2-2/2-2:1.0/input/input9
> generic-usb 0003:0461:4D51.0003: input,hidraw2: USB HID v1.11 Mouse
> [DELL Laser Mouse] on usb-0000:00:1d.0-2/input0
> hda_codec: ALC269: BIOS auto-probing.
> Bluetooth: Generic Bluetooth USB driver ver 0.6
> usbcore: registered new interface driver btusb
> iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver
> for Linux, in-tree:s
> iwl3945: Copyright(c) 2003-2010 Intel Corporation
> iwl3945 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwl3945 0000:05:00.0: setting latency timer to 64
> iwl3945 0000:05:00.0: Tunable channels: 13 802.11bg, 23 802.11a
> channels
> iwl3945 0000:05:00.0: Detected Intel Wireless WiFi Link 3945ABG
> iwl3945 0000:05:00.0: irq 42 for MSI/MSI-X
> ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
> coretemp coretemp.0: Unable to read TjMax from CPU.
> Initializing USB Mass Storage driver...
> scsi4 : usb-storage 1-5:1.0
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> device fsid 1143b84e02ecf5c3-b8665e19d796ec82 devid 1 transid
> 180885 /dev/sda3
> btrfs: disk space caching is enabled
> scsi 4:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0
> ANSI: 0 CCS
> sd 4:0:0:0: Attached scsi generic sg1 type 0
> sd 4:0:0:0: [sdb] Attached SCSI removable disk
> microcode: CPU0 sig=0x106c2, pf=0x4, revision=0x208
> microcode: CPU1 sig=0x106c2, pf=0x4, revision=0x208
> microcode: Microcode Update Driver: v2.00
> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> microcode: CPU0 updated to revision 0x218, date = 2009-04-10
> microcode: CPU1 updated to revision 0x218, date = 2009-04-10
> microcode: Microcode Update Driver: v2.00 removed.
> Adding 2104508k swap on /dev/sda2.  Priority:-1 extents:1 across:
> 2104508k
> r8169 0000:02:00.0: eth0: link up
> r8169 0000:02:00.0: eth0: link up
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> sshd (2001): /proc/2001/oom_adj is deprecated, please use /proc/2001/
> oom_score_adj instead.
> eth0: no IPv6 routers present
> btrfs: free space inode generation (0) did not match free space
> cache generation (180814) for block group 3250585600
> btrfs: free space inode generation (0) did not match free space
> cache generation (169594) for block group 15464398848
> block group 3250585600 not cached
> block group 8619294720 not cached
> block group 15464398848 not cached
> block group 17611882496 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 3250585600 not cached
> block group 17611882496 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 97739866112 not cached
> block group 17611882496 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 97739866112 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 88747278336 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 8619294720 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 37341888512 not cached
> block group 17611882496 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 9827254272 not cached
> block group 17611882496 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 14256439296 not cached
> block group 3250585600 not cached
> block group 8619294720 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 17611882496 not cached
> block group 88747278336 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 17611882496 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 17611882496 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 8619294720 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 8619294720 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 86465576960 not cached
> block group 17611882496 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 88747278336 not cached
> block group 37341888512 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 17611882496 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 8619294720 not cached
> block group 17611882496 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 8619294720 not cached
> block group 17611882496 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> block group 88747278336 not cached
> block group 17611882496 not cached
> block group 86465576960 not cached
> block group 88747278336 not cached
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
