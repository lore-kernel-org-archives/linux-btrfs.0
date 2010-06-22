From: Brian Rogers <brian@xyzw.org>
Subject: Oops from bad sector during ls
Date: Tue, 22 Jun 2010 08:22:38 -0700
Message-ID: <4C20D53E.7020009@xyzw.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080504060801010907080708"
To: The development of BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080504060801010907080708
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello btrfs list,

I have been using btrfs as /home on my laptop for a couple weeks now, 
and just hit my first problem with it on this laptop. My far-too-young 
hard drive has decided to develop three bad sectors, and now running 
'ls' in the '.git/objects' directory of a certain git repo is hitting at 
least one of those bad sectors and generating an oops in 
extent_range_uptodate. After that, most filesystem operations in /home 
stall indefinitely. I am able to save things to / after the oops, so I'm 
attaching a dmesg where I trigger the problem.

Theoretically, I should be able to zero out this sector and btrfs will 
use a backup since everything is checksummed and all metadata is 
duplicated by default, right? But since it's just data I can download 
again, I'll leave the directory and that bad sector there for a while so 
I can test out any patch for this issue.

Of course, the most important thing is for btrfs to not crash, but it'd 
really be nice if it would also use the backup data to rewrite the bad 
sector with fresh data, allowing the drive to relocate the sector if 
necessary.

This crash is on 2.6.35-rc3. I also tested Ubuntu's 2.6.32 kernel as 
well and it also had an oops, but the system was not as functional 
afterwards and I couldn't save the dmesg.

Brian


--------------080504060801010907080708
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35rc3-test-generic (buildd@berkelium) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #1-Ubuntu SMP Sat Jun 19 10:07:21 UTC 2010 (Ubuntu 2.6.35rc3-test.1-generic 2.6.35rc3-rc3)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35rc3-test-generic root=UUID=d5e83da1-1182-41ff-9688-8b5b53cc65fd ro crashkernel=384M-2G:64M,2G-:128M quiet splash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf6d0000 (usable)
[    0.000000]  BIOS-e820: 00000000bf6d0000 - 00000000bf6e3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf6e3000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
[    0.000000] DMI present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 000000000 mask F00000000 write-back
[    0.000000]   2 base 100000000 mask FC0000000 write-back
[    0.000000]   3 base 0BF700000 mask FFFF00000 uncachable
[    0.000000]   4 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bf700000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf6d0 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf6d0000 (usable)
[    0.000000]  modified: 00000000bf6d0000 - 00000000bf6e3000 (ACPI NVS)
[    0.000000]  modified: 00000000bf6e3000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f7bc0] f7bc0
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf6d0000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf6d0000 page 4k
[    0.000000] kernel direct mapping tables up to bf6d0000 @ 16000-1b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ 19000-1f000
[    0.000000] RAMDISK: 3766c000 - 37ff0000
[    0.000000] Reserving 128MB of memory at 32MB for crashkernel (System RAM: 5120MB)
[    0.000000] ACPI: RSDP 00000000000f7b40 00024 (v02 Compal)
[    0.000000] ACPI: XSDT 00000000bf6d86a6 0008C (v01 Compal CRESTLNE 06040000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bf6dfbd2 000F4 (v03 INTEL  CRESTLNE 06040000 ALAN 00000001)
[    0.000000] ACPI: DSDT 00000000bf6d9b51 0600D (v02 Compal CRESTLNE 06040000 INTL 20061109)
[    0.000000] ACPI: FACS 00000000bf6e2fc0 00040
[    0.000000] ACPI: APIC 00000000bf6dfcc6 00068 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: HPET 00000000bf6dfd2e 00038 (v01 Compal CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: MCFG 00000000bf6dfd66 0003C (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: TCPA 00000000bf6dfda2 00032 (v01 Intel  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: TMOR 00000000bf6dfdd4 00026 (v01 PTLTD           06040000 PTL  00000003)
[    0.000000] ACPI: SLIC 00000000bf6dfdfa 00176 (v01 Compal CRESTLNE 06040000 TBD  00000001)
[    0.000000] ACPI: APIC 00000000bf6dff70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bf6dffd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SSDT 00000000bf6d988c 002C5 (v01 SataRe SataAhci 00001000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bf6d8cbe 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bf6d8c18 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bf6d8732 004E6 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000140000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000140000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880100200000-ffff8801039fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bf6d0
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1046111
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765704 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [1a000 - 1a7ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf6d0000 - 00000000bf6e3000
[    0.000000] PM: Registered nosave memory: 00000000bf6e3000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ec00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91520 r8192 d23168 u1048576
[    0.000000] pcpu-alloc: s91520 r8192 d23168 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1028191
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35rc3-test-generic root=UUID=d5e83da1-1182-41ff-9688-8b5b53cc65fd ro crashkernel=384M-2G:64M,2G-:128M quiet splash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] early_res array is doubled to 128 at [1a800 - 1b7ff]
[    0.000000] Subtract (59 early reservations)
[    0.000000]   #1 [0001000000 - 0001d1b654]   TEXT DATA BSS
[    0.000000]   #2 [003766c000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001d1c000 - 0001d1c1a8]             BRK
[    0.000000]   #4 [00000f7bd0 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f7bc0 - 00000f7bd0]    MP-table mpf
[    0.000000]   #6 [000009f800 - 000009fd71]   BIOS reserved
[    0.000000]   #7 [000009ff1d - 00000f7bc0]   BIOS reserved
[    0.000000]   #8 [000009fd71 - 000009ff1d]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000019000]         PGTABLE
[    0.000000]   #12 [0000019000 - 000001a000]         PGTABLE
[    0.000000]   #13 [0002000000 - 000a000000]    CRASH KERNEL
[    0.000000]   #14 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #15 [0001d1c1c0 - 0001d1d1c0]         BOOTMEM
[    0.000000]   #16 [0001d1b680 - 0001d1b980]         BOOTMEM
[    0.000000]   #17 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #18 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #19 [0100200000 - 0103a00000]        MEMMAP 0
[    0.000000]   #20 [0001d1b980 - 0001d1bb00]         BOOTMEM
[    0.000000]   #21 [0001d1d1c0 - 0001d351c0]         BOOTMEM
[    0.000000]   #22 [0001d351c0 - 0001d3b1c0]         BOOTMEM
[    0.000000]   #23 [0001d3c000 - 0001d3d000]         BOOTMEM
[    0.000000]   #24 [0001d1bb00 - 0001d1bb41]         BOOTMEM
[    0.000000]   #25 [0001d1bb80 - 0001d1bbc3]         BOOTMEM
[    0.000000]   #26 [0001d1bc00 - 0001d1bf48]         BOOTMEM
[    0.000000]   #27 [0001d1bf80 - 0001d1bfe8]         BOOTMEM
[    0.000000]   #28 [0001d3b1c0 - 0001d3b228]         BOOTMEM
[    0.000000]   #29 [0001d3b240 - 0001d3b2a8]         BOOTMEM
[    0.000000]   #30 [0001d3b2c0 - 0001d3b328]         BOOTMEM
[    0.000000]   #31 [0001d3b340 - 0001d3b3a8]         BOOTMEM
[    0.000000]   #32 [0001d3b3c0 - 0001d3b428]         BOOTMEM
[    0.000000]   #33 [0001d3b440 - 0001d3b4a8]         BOOTMEM
[    0.000000]   #34 [0001d3b4c0 - 0001d3b528]         BOOTMEM
[    0.000000]   #35 [0001d3b540 - 0001d3b5a8]         BOOTMEM
[    0.000000]   #36 [0001d3b5c0 - 0001d3b628]         BOOTMEM
[    0.000000]   #37 [0001d3b640 - 0001d3b6a8]         BOOTMEM
[    0.000000]   #38 [0001d3b6c0 - 0001d3b728]         BOOTMEM
[    0.000000]   #39 [0001d3b740 - 0001d3b7a8]         BOOTMEM
[    0.000000]   #40 [0001d3b7c0 - 0001d3b828]         BOOTMEM
[    0.000000]   #41 [0001d3b840 - 0001d3b860]         BOOTMEM
[    0.000000]   #42 [0001d3b880 - 0001d3b8a0]         BOOTMEM
[    0.000000]   #43 [0001d3b8c0 - 0001d3b950]         BOOTMEM
[    0.000000]   #44 [0001d3b980 - 0001d3ba10]         BOOTMEM
[    0.000000]   #45 [0001e00000 - 0001e1e000]         BOOTMEM
[    0.000000]   #46 [0001f00000 - 0001f1e000]         BOOTMEM
[    0.000000]   #47 [0001d3ba40 - 0001d3ba48]         BOOTMEM
[    0.000000]   #48 [0001d3ba80 - 0001d3ba88]         BOOTMEM
[    0.000000]   #49 [0001d3bac0 - 0001d3bac8]         BOOTMEM
[    0.000000]   #50 [0001d3bb00 - 0001d3bb10]         BOOTMEM
[    0.000000]   #51 [0001d3bb40 - 0001d3bc80]         BOOTMEM
[    0.000000]   #52 [0001d3bc80 - 0001d3bce0]         BOOTMEM
[    0.000000]   #53 [0001d3bd00 - 0001d3bd60]         BOOTMEM
[    0.000000]   #54 [0001d3d000 - 0001d45000]         BOOTMEM
[    0.000000]   #55 [000a000000 - 000e000000]         BOOTMEM
[    0.000000]   #56 [0001d45000 - 0001d65000]         BOOTMEM
[    0.000000]   #57 [0001d65000 - 0001da5000]         BOOTMEM
[    0.000000]   #58 [000001b800 - 0000023800]         BOOTMEM
[    0.000000] Memory: 3906432k/5242880k available (5689k kernel code, 1058436k absent, 278012k reserved, 5435k data, 896k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1795.515 MHz processor.
[    0.010011] Calibrating delay loop (skipped), value calculated using timer frequency.. 3591.03 BogoMIPS (lpj=17955150)
[    0.010016] pid_max: default: 32768 minimum: 301
[    0.010042] Security Framework initialized
[    0.010064] AppArmor: AppArmor initialized
[    0.010577] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.012937] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.014003] Mount-cache hash table entries: 256
[    0.020133] Initializing cgroup subsys ns
[    0.020140] Initializing cgroup subsys cpuacct
[    0.020144] Initializing cgroup subsys memory
[    0.020154] Initializing cgroup subsys devices
[    0.020157] Initializing cgroup subsys freezer
[    0.020159] Initializing cgroup subsys net_cls
[    0.020186] CPU: Physical Processor ID: 0
[    0.020188] CPU: Processor Core ID: 0
[    0.020190] mce: CPU supports 6 MCE banks
[    0.020198] CPU0: Thermal monitoring handled by SMI
[    0.020203] using mwait in idle threads.
[    0.020205] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.020211] PEBS disabled due to CPU errata.
[    0.020216] ... version:                2
[    0.020218] ... bit width:              40
[    0.020220] ... generic registers:      2
[    0.020222] ... value mask:             000000ffffffffff
[    0.020224] ... max period:             000000007fffffff
[    0.020225] ... fixed-purpose events:   3
[    0.020227] ... event mask:             0000000700000003
[    0.022906] ACPI: Core revision 20100428
[    0.040011] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.040018] ftrace: allocating 22519 entries in 89 pages
[    0.050062] Setting APIC routing to flat
[    0.050419] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.158980] CPU0: Intel(R) Core(TM)2 Duo CPU     T7100  @ 1.80GHz stepping 0d
[    0.160000] Booting Node   0, Processors  #1 Ok.
[    0.020000] CPU1: Thermal monitoring handled by SMI
[    0.320019] Brought up 2 CPUs
[    0.320023] Total of 2 processors activated (7182.03 BogoMIPS).
[    0.320551] devtmpfs: initialized
[    0.320827] regulator: core version 0.5
[    0.320865] Time:  7:11:09  Date: 06/22/10
[    0.320906] NET: Registered protocol family 16
[    0.320933] Trying to unpack rootfs image as initramfs...
[    0.321059] ACPI: bus type pci registered
[    0.321141] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.321144] PCI: not using MMCONFIG
[    0.321147] PCI: Using configuration type 1 for base access
[    0.330147] bio: create slab <bio-0> at 0
[    0.331895] ACPI: EC: Look up EC in DSDT
[    0.335312] ACPI: BIOS _OSI(Linux) query ignored
[    0.350478] ACPI: SSDT 00000000bf6d958c 00238 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.356376] ACPI: Dynamic OEM Table Load:
[    0.356376] ACPI: SSDT (null) 00238 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.356376] ACPI: SSDT 00000000bf6d8f1d 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.356376] ACPI: Dynamic OEM Table Load:
[    0.356376] ACPI: SSDT (null) 005EA (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.356376] ACPI: SSDT 00000000bf6d97c4 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.356376] ACPI: Dynamic OEM Table Load:
[    0.356376] ACPI: SSDT (null) 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.356376] ACPI: SSDT 00000000bf6d9507 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.356376] ACPI: Dynamic OEM Table Load:
[    0.356376] ACPI: SSDT (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.356376] ACPI: Interpreter enabled
[    0.356376] ACPI: (supports S0 S3 S4 S5)
[    0.356376] ACPI: Using IOAPIC for interrupt routing
[    0.356376] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.360399] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.470936] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.471256] ACPI: No dock devices found.
[    0.471260] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.471936] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.473253] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.473257] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.473260] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.473264] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.473267] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.473272] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    0.473275] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.473351] pci 0000:00:02.0: reg 10: [mem 0xf8000000-0xf80fffff 64bit]
[    0.473359] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.473365] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.473407] pci 0000:00:02.1: reg 10: [mem 0xf8100000-0xf81fffff 64bit]
[    0.473529] pci 0000:00:1a.0: reg 20: [io  0x1820-0x183f]
[    0.473600] pci 0000:00:1a.1: reg 20: [io  0x1840-0x185f]
[    0.473675] pci 0000:00:1a.7: reg 10: [mem 0xf8604800-0xf8604bff]
[    0.473745] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.473752] pci 0000:00:1a.7: PME# disabled
[    0.473801] pci 0000:00:1b.0: reg 10: [mem 0xf8400000-0xf8403fff 64bit]
[    0.473869] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.473874] pci 0000:00:1b.0: PME# disabled
[    0.473984] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.473989] pci 0000:00:1c.0: PME# disabled
[    0.474101] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.474107] pci 0000:00:1c.1: PME# disabled
[    0.474219] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.474224] pci 0000:00:1c.2: PME# disabled
[    0.474335] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.474340] pci 0000:00:1c.3: PME# disabled
[    0.474451] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.474457] pci 0000:00:1c.4: PME# disabled
[    0.474569] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.474575] pci 0000:00:1c.5: PME# disabled
[    0.474646] pci 0000:00:1d.0: reg 20: [io  0x1860-0x187f]
[    0.474717] pci 0000:00:1d.1: reg 20: [io  0x1880-0x189f]
[    0.474787] pci 0000:00:1d.2: reg 20: [io  0x18a0-0x18bf]
[    0.474859] pci 0000:00:1d.7: reg 10: [mem 0xf8604c00-0xf8604fff]
[    0.474928] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.474934] pci 0000:00:1d.7: PME# disabled
[    0.475115] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.475120] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.475125] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.475132] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0068 (mask 0007)
[    0.475137] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 1640 (mask 007f)
[    0.475192] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.475201] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.475210] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.475219] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.475228] pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
[    0.475298] pci 0000:00:1f.2: reg 10: [io  0x1c00-0x1c07]
[    0.475307] pci 0000:00:1f.2: reg 14: [io  0x18d4-0x18d7]
[    0.475315] pci 0000:00:1f.2: reg 18: [io  0x18d8-0x18df]
[    0.475324] pci 0000:00:1f.2: reg 1c: [io  0x18d0-0x18d3]
[    0.475333] pci 0000:00:1f.2: reg 20: [io  0x18e0-0x18ff]
[    0.475341] pci 0000:00:1f.2: reg 24: [mem 0xf8604000-0xf86047ff]
[    0.475389] pci 0000:00:1f.2: PME# supported from D3hot
[    0.475394] pci 0000:00:1f.2: PME# disabled
[    0.475432] pci 0000:00:1f.3: reg 10: [mem 0x00000000-0x000000ff]
[    0.475460] pci 0000:00:1f.3: reg 20: [io  0x1c20-0x1c3f]
[    0.475558] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.475564] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.475570] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc3ffffff]
[    0.475578] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.475810] pci 0000:04:00.0: reg 10: [mem 0xf0000000-0xf000ffff 64bit]
[    0.476055] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    0.476068] pci 0000:04:00.0: PME# disabled
[    0.476210] pci 0000:00:1c.1: PCI bridge to [bus 04-04]
[    0.476216] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.476221] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.476231] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.476298] pci 0000:00:1c.2: PCI bridge to [bus 06-06]
[    0.476304] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.476310] pci 0000:00:1c.2:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.476319] pci 0000:00:1c.2:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.476385] pci 0000:00:1c.3: PCI bridge to [bus 08-08]
[    0.476391] pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
[    0.476396] pci 0000:00:1c.3:   bridge window [mem 0xb8000000-0xbbffffff]
[    0.476405] pci 0000:00:1c.3:   bridge window [mem 0xc8000000-0xc9ffffff 64bit pref]
[    0.476475] pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
[    0.476481] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.476487] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.476496] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.476705] pci 0000:0c:00.0: reg 10: [mem 0xf8200000-0xf8200fff]
[    0.476955] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.476969] pci 0000:0c:00.0: PME# disabled
[    0.477041] pci 0000:0c:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.477070] pci 0000:00:1c.5: PCI bridge to [bus 0c-0c]
[    0.477075] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.477081] pci 0000:00:1c.5:   bridge window [mem 0xf8200000-0xf82fffff]
[    0.477090] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.477173] pci 0000:0e:06.0: reg 10: [mem 0xf8300000-0xf83007ff]
[    0.477241] pci 0000:0e:06.0: supports D1 D2
[    0.477244] pci 0000:0e:06.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.477249] pci 0000:0e:06.0: PME# disabled
[    0.477291] pci 0000:0e:06.1: reg 10: [mem 0xf8300800-0xf83008ff]
[    0.477357] pci 0000:0e:06.1: supports D1 D2
[    0.477360] pci 0000:0e:06.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.477365] pci 0000:0e:06.1: PME# disabled
[    0.477409] pci 0000:0e:06.2: reg 10: [mem 0xf8300c00-0xf8300cff]
[    0.477474] pci 0000:0e:06.2: supports D1 D2
[    0.477476] pci 0000:0e:06.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.477482] pci 0000:0e:06.2: PME# disabled
[    0.477553] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive decode)
[    0.477559] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.477564] pci 0000:00:1e.0:   bridge window [mem 0xf8300000-0xf83fffff]
[    0.477573] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.477577] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.477580] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.477583] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.477586] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.477589] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.477592] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    0.477595] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.477651] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.477926] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.478012] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.478098] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.478181] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.478264] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.478349] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.478468] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.486723] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.486841] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.486954] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *7 10 12 14 15)
[    0.487068] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.487183] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.487295] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.487409] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.487522] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.487577] HEST: Table is not found!
[    0.487670] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.487691] vgaarb: loaded
[    0.487882] SCSI subsystem initialized
[    0.487995] libata version 3.00 loaded.
[    0.488052] usbcore: registered new interface driver usbfs
[    0.488065] usbcore: registered new interface driver hub
[    0.488093] usbcore: registered new device driver usb
[    0.488318] ACPI: WMI: Mapper loaded
[    0.488321] PCI: Using ACPI for IRQ routing
[    0.488324] PCI: pci_cache_line_size set to 64 bytes
[    0.488333] pci 0000:00:1c.3: no compatible bridge window for [mem 0xb8000000-0xbbffffff]
[    0.488565] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.488568] reserve RAM buffer: 00000000bf6d0000 - 00000000bfffffff 
[    0.488677] NetLabel: Initializing
[    0.488680] NetLabel:  domain hash size = 128
[    0.488681] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.488699] NetLabel:  unlabeled traffic allowed by default
[    0.488739] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.488746] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.488752] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.500038] Switching to clocksource tsc
[    0.511914] AppArmor: AppArmor Filesystem Enabled
[    0.511935] pnp: PnP ACPI init
[    0.511957] ACPI: bus type pnp registered
[    0.529969] pnp: PnP ACPI: found 10 devices
[    0.529973] ACPI: ACPI bus type pnp unregistered
[    0.529993] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.529997] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.530001] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.530004] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.530008] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.530011] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.530014] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.530018] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.530027] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.530036] system 00:06: [io  0x0680-0x069f] has been reserved
[    0.530040] system 00:06: [io  0x0800-0x080f] has been reserved
[    0.530043] system 00:06: [io  0x1000-0x107f] has been reserved
[    0.530046] system 00:06: [io  0x1180-0x11bf] has been reserved
[    0.530050] system 00:06: [io  0x1640-0x164f] has been reserved
[    0.530055] system 00:06: [io  0xfe00] has been reserved
[    0.530058] system 00:06: [io  0xff00-0xff7f] has been reserved
[    0.534922] pci 0000:00:1c.3: BAR 14: assigned [mem 0xc4000000-0xc43fffff]
[    0.534927] pci 0000:00:1c.4: BAR 14: assigned [mem 0xc4400000-0xc45fffff]
[    0.534931] pci 0000:00:1c.4: BAR 15: assigned [mem 0xc4600000-0xc47fffff 64bit pref]
[    0.534935] pci 0000:00:1c.5: BAR 15: assigned [mem 0xc4800000-0xc49fffff 64bit pref]
[    0.534939] pci 0000:00:1c.4: BAR 13: assigned [io  0x6000-0x6fff]
[    0.534943] pci 0000:00:1c.5: BAR 13: assigned [io  0x7000-0x7fff]
[    0.534946] pci 0000:00:1f.3: BAR 0: assigned [mem 0xc4a00000-0xc4a000ff]
[    0.534954] pci 0000:00:1f.3: BAR 0: set to [mem 0xc4a00000-0xc4a000ff] (PCI address [0xc4a00000-0xc4a000ff]
[    0.534958] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.534962] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.534969] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc3ffffff]
[    0.534975] pci 0000:00:1c.0:   bridge window [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.534985] pci 0000:00:1c.1: PCI bridge to [bus 04-04]
[    0.534988] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.534996] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.535001] pci 0000:00:1c.1:   bridge window [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.535010] pci 0000:00:1c.2: PCI bridge to [bus 06-06]
[    0.535014] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.535021] pci 0000:00:1c.2:   bridge window [mem 0xf4000000-0xf7ffffff]
[    0.535027] pci 0000:00:1c.2:   bridge window [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.535035] pci 0000:00:1c.3: PCI bridge to [bus 08-08]
[    0.535039] pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
[    0.535046] pci 0000:00:1c.3:   bridge window [mem 0xc4000000-0xc43fffff]
[    0.535052] pci 0000:00:1c.3:   bridge window [mem 0xc8000000-0xc9ffffff 64bit pref]
[    0.535061] pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
[    0.535065] pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
[    0.535072] pci 0000:00:1c.4:   bridge window [mem 0xc4400000-0xc45fffff]
[    0.535078] pci 0000:00:1c.4:   bridge window [mem 0xc4600000-0xc47fffff 64bit pref]
[    0.535087] pci 0000:00:1c.5: PCI bridge to [bus 0c-0c]
[    0.535091] pci 0000:00:1c.5:   bridge window [io  0x7000-0x7fff]
[    0.535098] pci 0000:00:1c.5:   bridge window [mem 0xf8200000-0xf82fffff]
[    0.535104] pci 0000:00:1c.5:   bridge window [mem 0xc4800000-0xc49fffff 64bit pref]
[    0.535114] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
[    0.535116] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.535123] pci 0000:00:1e.0:   bridge window [mem 0xf8300000-0xf83fffff]
[    0.535128] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.535151]   alloc irq_desc for 17 on node -1
[    0.535153]   alloc kstat_irqs on node -1
[    0.535159] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.535166] pci 0000:00:1c.0: setting latency timer to 64
[    0.535181]   alloc irq_desc for 16 on node -1
[    0.535182]   alloc kstat_irqs on node -1
[    0.535187] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.535192] pci 0000:00:1c.1: setting latency timer to 64
[    0.535204]   alloc irq_desc for 18 on node -1
[    0.535206]   alloc kstat_irqs on node -1
[    0.535210] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.535216] pci 0000:00:1c.2: setting latency timer to 64
[    0.535227]   alloc irq_desc for 19 on node -1
[    0.535229]   alloc kstat_irqs on node -1
[    0.535233] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.535238] pci 0000:00:1c.3: setting latency timer to 64
[    0.535250] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.535256] pci 0000:00:1c.4: setting latency timer to 64
[    0.535267] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.535273] pci 0000:00:1c.5: setting latency timer to 64
[    0.535282] pci 0000:00:1e.0: setting latency timer to 64
[    0.535287] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.535290] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.535293] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.535295] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.535298] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.535301] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xdfffffff]
[    0.535303] pci_bus 0000:00: resource 10 [mem 0xf0000000-0xfebfffff]
[    0.535306] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.535309] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc3ffffff]
[    0.535312] pci_bus 0000:02: resource 2 [mem 0xcc000000-0xcdffffff 64bit pref]
[    0.535315] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    0.535317] pci_bus 0000:04: resource 1 [mem 0xf0000000-0xf3ffffff]
[    0.535320] pci_bus 0000:04: resource 2 [mem 0xfa000000-0xfbffffff 64bit pref]
[    0.535323] pci_bus 0000:06: resource 0 [io  0x4000-0x4fff]
[    0.535325] pci_bus 0000:06: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.535328] pci_bus 0000:06: resource 2 [mem 0xfc000000-0xfdffffff 64bit pref]
[    0.535331] pci_bus 0000:08: resource 0 [io  0x5000-0x5fff]
[    0.535333] pci_bus 0000:08: resource 1 [mem 0xc4000000-0xc43fffff]
[    0.535336] pci_bus 0000:08: resource 2 [mem 0xc8000000-0xc9ffffff 64bit pref]
[    0.535339] pci_bus 0000:0a: resource 0 [io  0x6000-0x6fff]
[    0.535341] pci_bus 0000:0a: resource 1 [mem 0xc4400000-0xc45fffff]
[    0.535344] pci_bus 0000:0a: resource 2 [mem 0xc4600000-0xc47fffff 64bit pref]
[    0.535347] pci_bus 0000:0c: resource 0 [io  0x7000-0x7fff]
[    0.535350] pci_bus 0000:0c: resource 1 [mem 0xf8200000-0xf82fffff]
[    0.535352] pci_bus 0000:0c: resource 2 [mem 0xc4800000-0xc49fffff 64bit pref]
[    0.535355] pci_bus 0000:0e: resource 1 [mem 0xf8300000-0xf83fffff]
[    0.535358] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    0.535361] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    0.535363] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    0.535366] pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.535368] pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.535371] pci_bus 0000:0e: resource 9 [mem 0xc0000000-0xdfffffff]
[    0.535374] pci_bus 0000:0e: resource 10 [mem 0xf0000000-0xfebfffff]
[    0.535416] NET: Registered protocol family 2
[    0.535616] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.537185] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.542004] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.542604] TCP: Hash tables configured (established 524288 bind 65536)
[    0.542607] TCP reno registered
[    0.542620] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.542666] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.542837] NET: Registered protocol family 1
[    0.542859] pci 0000:00:02.0: Boot video device
[    0.543124] PCI: CLS 64 bytes, default 64
[    0.543127] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.543131] Placing 64MB software IO TLB between ffff88000a000000 - ffff88000e000000
[    0.543133] software IO TLB at phys 0xa000000 - 0xe000000
[    0.543179] Simple Boot Flag at 0x38 set to 0x1
[    0.543382] Scanning for low memory corruption every 60 seconds
[    0.543568] audit: initializing netlink socket (disabled)
[    0.543584] type=2000 audit(1277190669.530:1): initialized
[    0.560978] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.562616] VFS: Disk quotas dquot_6.5.2
[    0.562683] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.563338] fuse init (API version 7.14)
[    0.563435] msgmni has been set to 7629
[    0.563661] alg: No test for stdrng (krng)
[    0.563726] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.563730] io scheduler noop registered
[    0.563732] io scheduler deadline registered
[    0.563772] io scheduler cfq registered (default)
[    0.563919] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.563972]   alloc irq_desc for 40 on node -1
[    0.563975]   alloc kstat_irqs on node -1
[    0.563991] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.564101] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.564151]   alloc irq_desc for 41 on node -1
[    0.564153]   alloc kstat_irqs on node -1
[    0.564163] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.564272] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.564323]   alloc irq_desc for 42 on node -1
[    0.564325]   alloc kstat_irqs on node -1
[    0.564335] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    0.564439] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.564489]   alloc irq_desc for 43 on node -1
[    0.564491]   alloc kstat_irqs on node -1
[    0.564501] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    0.564611] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.564661]   alloc irq_desc for 44 on node -1
[    0.564663]   alloc kstat_irqs on node -1
[    0.564672] pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
[    0.564776] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.564827]   alloc irq_desc for 45 on node -1
[    0.564829]   alloc kstat_irqs on node -1
[    0.564839] pcieport 0000:00:1c.5: irq 45 for MSI/MSI-X
[    0.564958] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    0.564970] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    0.564975] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    0.564979] pcieport 0000:00:1c.1: Requesting control of PCIe PME from ACPI BIOS
[    0.564983] pcieport 0000:00:1c.1: Failed to receive control of PCIe PME service: no _OSC support
[    0.564986] pcie_pme: probe of 0000:00:1c.1:pcie01 failed with error -13
[    0.564991] pcieport 0000:00:1c.2: Requesting control of PCIe PME from ACPI BIOS
[    0.564994] pcieport 0000:00:1c.2: Failed to receive control of PCIe PME service: no _OSC support
[    0.564998] pcie_pme: probe of 0000:00:1c.2:pcie01 failed with error -13
[    0.565002] pcieport 0000:00:1c.3: Requesting control of PCIe PME from ACPI BIOS
[    0.565006] pcieport 0000:00:1c.3: Failed to receive control of PCIe PME service: no _OSC support
[    0.565009] pcie_pme: probe of 0000:00:1c.3:pcie01 failed with error -13
[    0.565014] pcieport 0000:00:1c.4: Requesting control of PCIe PME from ACPI BIOS
[    0.565017] pcieport 0000:00:1c.4: Failed to receive control of PCIe PME service: no _OSC support
[    0.565020] pcie_pme: probe of 0000:00:1c.4:pcie01 failed with error -13
[    0.565025] pcieport 0000:00:1c.5: Requesting control of PCIe PME from ACPI BIOS
[    0.565028] pcieport 0000:00:1c.5: Failed to receive control of PCIe PME service: no _OSC support
[    0.565032] pcie_pme: probe of 0000:00:1c.5:pcie01 failed with error -13
[    0.565053] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.565233] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.567256] ACPI: AC Adapter [ACAD] (on-line)
[    0.567335] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.567380] ACPI: Lid Switch [LID0]
[    0.567428] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.567431] ACPI: Power Button [PWRB]
[    0.567495] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.567498] ACPI: Power Button [PWRF]
[    0.567807] ACPI: acpi_idle registered with cpuidle
[    0.570334] Monitor-Mwait will be used to enter C-1 state
[    0.570371] Monitor-Mwait will be used to enter C-2 state
[    0.570398] Monitor-Mwait will be used to enter C-3 state
[    0.570405] Marking TSC unstable due to TSC halts in idle
[    0.570807] Switching to clocksource hpet
[    0.597299] Freeing initrd memory: 9744k freed
[    0.630406] ERST: Table is not found!
[    0.632059] Linux agpgart interface v0.103
[    0.632145] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.633623] brd: module loaded
[    0.634186] loop: module loaded
[    0.634397] ata_piix 0000:00:1f.1: version 2.13
[    0.634413] ata_piix 0000:00:1f.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.634459] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.634576] scsi0 : ata_piix
[    0.634668] scsi1 : ata_piix
[    0.635343] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
[    0.635346] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
[    0.635716] Fixed MDIO Bus: probed
[    0.635751] PPP generic driver version 2.4.2
[    0.635793] tun: Universal TUN/TAP device driver, 1.6
[    0.635795] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.635887] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.635909] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.635931] ACPI: Battery Slot [BAT1] (battery present)
[    0.635935] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.635940] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.635995] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.636041] ehci_hcd 0000:00:1a.7: debug port 1
[    0.639922] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    0.639943] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf8604800
[    0.670020] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.670148] hub 1-0:1.0: USB hub found
[    0.670154] hub 1-0:1.0: 4 ports detected
[    0.670238]   alloc irq_desc for 23 on node -1
[    0.670241]   alloc kstat_irqs on node -1
[    0.670248] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.670262] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.670266] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.670302] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.670337] ehci_hcd 0000:00:1d.7: debug port 1
[    0.674224] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    0.674239] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf8604c00
[    0.690017] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.690120] hub 2-0:1.0: USB hub found
[    0.690125] hub 2-0:1.0: 6 ports detected
[    0.690208] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.690224] uhci_hcd: USB Universal Host Controller Interface driver
[    0.690283] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.690291] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.690295] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.690336] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.690375] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    0.690502] hub 3-0:1.0: USB hub found
[    0.690508] hub 3-0:1.0: 2 ports detected
[    0.690579]   alloc irq_desc for 21 on node -1
[    0.690581]   alloc kstat_irqs on node -1
[    0.690586] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.690593] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.690597] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.690630] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.690670] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
[    0.690795] hub 4-0:1.0: USB hub found
[    0.690800] hub 4-0:1.0: 2 ports detected
[    0.690872] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.690880] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.690884] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.690919] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    0.690949] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001860
[    0.691074] hub 5-0:1.0: USB hub found
[    0.691079] hub 5-0:1.0: 2 ports detected
[    0.691150] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.691158] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.691162] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.691204] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    0.691243] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001880
[    0.691366] hub 6-0:1.0: USB hub found
[    0.691371] hub 6-0:1.0: 2 ports detected
[    0.691447] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.691455] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.691459] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.691498] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    0.691528] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018a0
[    0.691653] hub 7-0:1.0: USB hub found
[    0.691658] hub 7-0:1.0: 2 ports detected
[    0.691786] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.730362] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.730369] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.730439] mice: PS/2 mouse device common for all mice
[    0.730556] rtc_cmos 00:07: RTC can wake from S4
[    0.730603] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.730637] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.730739] device-mapper: uevent: version 1.0.3
[    0.730818] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    0.730893] device-mapper: multipath: version 1.1.1 loaded
[    0.730896] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.731126] cpuidle: using governor ladder
[    0.732535] cpuidle: using governor menu
[    0.732826] TCP cubic registered
[    0.732966] NET: Registered protocol family 10
[    0.733349] lo: Disabled Privacy Extensions
[    0.733571] NET: Registered protocol family 17
[    0.734409] PM: Resume from disk failed.
[    0.734423] registered taskstats version 1
[    0.734955]   Magic number: 14:10:168
[    0.735091] rtc_cmos 00:07: setting system clock to 2010-06-22 07:11:10 UTC (1277190670)
[    0.735095] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.735097] EDD information not available.
[    0.768057] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.840434] ata1.00: ATAPI: SlimtypeDVD A  DS8A1P, CX12, max UDMA/33
[    0.900316] ata1.00: configured for UDMA/33
[    0.904257] scsi 0:0:0:0: CD-ROM            Slimtype DVD A  DS8A1P    CX12 PQ: 0 ANSI: 5
[    0.915219] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    0.915224] Uniform CD-ROM driver Revision: 3.20
[    0.915379] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    0.915454] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    0.915544] Freeing unused kernel memory: 896k freed
[    0.915857] Write protecting the kernel read-only data: 10240k
[    0.916054] Freeing unused kernel memory: 436k freed
[    0.916396] Freeing unused kernel memory: 1612k freed
[    0.934496] udev: starting version 151
[    1.077094] ahci 0000:00:1f.2: version 3.0
[    1.077119] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.077183]   alloc irq_desc for 46 on node -1
[    1.077185]   alloc kstat_irqs on node -1
[    1.077199] ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
[    1.077270] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
[    1.077274] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc 
[    1.077281] ahci 0000:00:1f.2: setting latency timer to 64
[    1.077668] tg3.c:v3.110 (April 9, 2010)
[    1.077730] tg3 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.077744] tg3 0000:04:00.0: setting latency timer to 64
[    1.077940] scsi2 : ahci
[    1.078099] scsi3 : ahci
[    1.078206] scsi4 : ahci
[    1.078368] ata3: SATA max UDMA/133 abar m2048@0xf8604000 port 0xf8604100 irq 46
[    1.078373] ata4: SATA max UDMA/133 abar m2048@0xf8604000 port 0xf8604180 irq 46
[    1.078377] ata5: SATA max UDMA/133 abar m2048@0xf8604000 port 0xf8604200 irq 46
[    1.196811] tg3 0000:04:00.0: eth0: Tigon3 [partno(BCM95906) rev c002] (PCI Express) MAC address 00:1b:38:4c:68:46
[    1.196816] tg3 0000:04:00.0: eth0: attached PHY is 5906 (10/100Base-TX Ethernet) (WireSpeed[0])
[    1.196819] tg3 0000:04:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.196822] tg3 0000:04:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    1.320067] usb 4-1: new full speed USB device using uhci_hcd and address 2
[    1.420080] ata5: SATA link down (SStatus 0 SControl 300)
[    1.420118] ata4: SATA link down (SStatus 0 SControl 300)
[    1.420125] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.422258] ata3.00: unexpected _GTF length (8)
[    1.422519] ata3.00: ATA-8: WDC WD6400BEVT-00A0RT0, 01.01A01, max UDMA/133
[    1.422525] ata3.00: 1250263728 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.424820] ata3.00: unexpected _GTF length (8)
[    1.425419] ata3.00: configured for UDMA/133
[    1.442755] scsi 2:0:0:0: Direct-Access     ATA      WDC WD6400BEVT-0 01.0 PQ: 0 ANSI: 5
[    1.442931] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    1.442964] sd 2:0:0:0: [sda] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
[    1.443034] sd 2:0:0:0: [sda] Write Protect is off
[    1.443038] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.443064] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.443218]  sda: sda1 sda2 < sda5 > sda3
[    1.511184] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.514499]   alloc irq_desc for 22 on node -1
[    1.514503]   alloc kstat_irqs on node -1
[    1.514511] ohci1394 0000:0e:06.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.572129] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[f8300000-f83007ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    2.138254] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
[    2.138260] EXT4-fs (sda1): write access will be enabled during recovery
[    2.188316] EXT4-fs (sda1): recovery complete
[    2.188696] EXT4-fs (sda1): mounted filesystem with writeback data mode. Opts: (null)
[    2.890481] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f78b3400515]
[   14.283728] udev: starting version 151
[   14.331966] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[   14.332815] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[   14.361968] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[   14.368890] Adding 16779856k swap on /dev/sda5.  Priority:-1 extents:1 across:16779856k 
[   14.466633] sdhci: Secure Digital Host Controller Interface driver
[   14.466637] sdhci: Copyright(c) Pierre Ossman
[   14.500607] lp: driver loaded but no devices found
[   14.537263] sdhci-pci 0000:0e:06.1: SDHCI controller found [1180:0822] (rev 22)
[   14.537286] sdhci-pci 0000:0e:06.1: PCI INT B -> GSI 23 (level, low) -> IRQ 23
[   14.538334] sdhci-pci 0000:0e:06.1: Will use DMA mode even though HW doesn't fully claim to support it.
[   14.539393] Registered led device: mmc0::
[   14.540436] mmc0: SDHCI controller on PCI [0000:0e:06.1] using DMA
[   14.639845] Bluetooth: Core ver 2.15
[   14.639900] NET: Registered protocol family 31
[   14.639903] Bluetooth: HCI device and connection manager initialized
[   14.639906] Bluetooth: HCI socket layer initialized
[   14.642837] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   14.646264] [drm] Initialized drm 1.1.0 20060810
[   14.657157] cfg80211: Calling CRDA to update world regulatory domain
[   14.658624] usbcore: registered new interface driver btusb
[   14.748361] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   14.748367] i915 0000:00:02.0: setting latency timer to 64
[   14.773332] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
[   14.773336] iwl3945: Copyright(c) 2003-2010 Intel Corporation
[   14.773427] iwl3945 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.773442] iwl3945 0000:0c:00.0: setting latency timer to 64
[   14.833938] cfg80211: World regulatory domain updated:
[   14.833942]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   14.833946]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.833949]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.833952]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   14.833956]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.833959]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   14.849356] iwl3945 0000:0c:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
[   14.849361] iwl3945 0000:0c:00.0: Detected Intel Wireless WiFi Link 3945ABG
[   14.849479]   alloc irq_desc for 47 on node -1
[   14.849482]   alloc kstat_irqs on node -1
[   14.849517] iwl3945 0000:0c:00.0: irq 47 for MSI/MSI-X
[   14.862188] phy0: Selected rate control algorithm 'iwl-3945-rs'
[   14.871148] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[   14.871153] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   14.871217]   alloc irq_desc for 48 on node -1
[   14.871220]   alloc kstat_irqs on node -1
[   14.871231] i915 0000:00:02.0: irq 48 for MSI/MSI-X
[   14.871244] [drm] set up 7M of stolen space
[   14.931996] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=3600
[   14.948202] type=1505 audit(1277215884.700:2):  operation="profile_load" pid=716 name="/sbin/dhclient3"
[   14.948955] type=1505 audit(1277215884.700:3):  operation="profile_load" pid=716 name="/usr/lib/NetworkManager/nm-dhcp-client.action"
[   14.949357] type=1505 audit(1277215884.700:4):  operation="profile_load" pid=716 name="/usr/lib/connman/scripts/dhclient-script"
[   14.978504] [drm] initialized overlay support
[   15.089728] Btrfs loaded
[   15.109574] device label extended devid 1 transid 20669 /dev/sda3
[   15.109930] btrfs: use compression
[   15.302548] Skipping EDID probe due to cached edid
[   15.390983] elantech: assuming hardware version 1, firmware version 2.0.4
[   15.483060] elantech: Synaptics capabilities query result 0x10, 0x02, 0x64.
[   15.715724] Console: switching to colour frame buffer device 160x50
[   15.718859] fb0: inteldrmfb frame buffer device
[   15.718861] drm: registered panic notifier
[   15.718865] Slow work thread pool: Starting up
[   15.718945] Slow work thread pool: Ready
[   15.754158] acpi device:07: registered as cooling_device2
[   15.754439] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input4
[   15.754494] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   15.754532] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   15.754728]   alloc irq_desc for 20 on node -1
[   15.754731]   alloc kstat_irqs on node -1
[   15.754741] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   15.754817]   alloc irq_desc for 49 on node -1
[   15.754819]   alloc kstat_irqs on node -1
[   15.754832] HDA Intel 0000:00:1b.0: irq 49 for MSI/MSI-X
[   15.754872] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   15.847844] hda_codec: ALC268: BIOS auto-probing.
[   15.924552] Skipping EDID probe due to cached edid
[   16.149483] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input5
[   18.762880] btrfs: unlinked 6 orphans
[   18.849028]   alloc irq_desc for 50 on node -1
[   18.849032]   alloc kstat_irqs on node -1
[   18.849066] tg3 0000:04:00.0: irq 50 for MSI/MSI-X
[   18.854126] type=1505 audit(1277215888.610:5):  operation="profile_load" pid=943 name="/usr/share/gdm/guest-session/Xsession"
[   18.855952] type=1505 audit(1277215888.610:6):  operation="profile_replace" pid=944 name="/sbin/dhclient3"
[   18.856714] type=1505 audit(1277215888.610:7):  operation="profile_replace" pid=944 name="/usr/lib/NetworkManager/nm-dhcp-client.action"
[   18.857137] type=1505 audit(1277215888.610:8):  operation="profile_replace" pid=944 name="/usr/lib/connman/scripts/dhclient-script"
[   18.860374] type=1505 audit(1277215888.620:9):  operation="profile_load" pid=945 name="/usr/bin/evince"
[   18.870167] type=1505 audit(1277215888.630:10):  operation="profile_load" pid=945 name="/usr/bin/evince-previewer"
[   18.876170] type=1505 audit(1277215888.630:11):  operation="profile_load" pid=945 name="/usr/bin/evince-thumbnailer"
[   18.900628] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.978255] iwl3945 0000:0c:00.0: loaded firmware version 15.32.2.9
[   19.000677] microcode: CPU0 sig=0x6fd, pf=0x80, revision=0xa3
[   19.002657] microcode: CPU1 sig=0x6fd, pf=0x80, revision=0xa3
[   19.005122] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   19.085422] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   19.197465] Bridge firewalling registered
[   19.230510] ip_tables: (C) 2000-2006 Netfilter Core Team
[   19.356952] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   19.357386] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   19.357390] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[   19.357392] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   19.552671] Skipping EDID probe due to cached edid
[   19.767806] lo: Disabled Privacy Extensions
[   20.010109] Skipping EDID probe due to cached edid
[   20.375252] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   20.375256] vboxdrv: Successfully done.
[   20.375258] vboxdrv: Found 2 processor cores.
[   20.375341] VBoxDrv: dbg - g_abExecMemory=ffffffffa04bad60
[   20.375629] vboxdrv: fAsync=0 offMin=0x1cb offMax=0x693
[   20.376040] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   20.376043] vboxdrv: Successfully loaded version 3.2.0_OSE (interface 0x00140001).
[   20.407629] Bluetooth: L2CAP ver 2.14
[   20.407634] Bluetooth: L2CAP socket layer initialized
[   20.413059] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   20.413063] Bluetooth: BNEP filters: protocol multicast
[   20.420974] Bluetooth: SCO (Voice Link) ver 0.6
[   20.420978] Bluetooth: SCO socket layer initialized
[   20.451328] ppdev: user-space parallel port driver
[   20.536709] Bluetooth: RFCOMM TTY layer initialized
[   20.536717] Bluetooth: RFCOMM socket layer initialized
[   20.536720] Bluetooth: RFCOMM ver 1.11
[   23.882691] Skipping EDID probe due to cached edid
[   24.340257] Skipping EDID probe due to cached edid
[   24.820235] Skipping EDID probe due to cached edid
[   25.860540] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   27.032600] Skipping EDID probe due to cached edid
[   27.417179] wlan0: deauthenticating from 00:18:4d:39:1c:01 by local choice (reason=3)
[   27.418584] wlan0: authenticate with 00:18:4d:39:1c:01 (try 1)
[   27.420399] wlan0: authenticated
[   27.421151] wlan0: associate with 00:18:4d:39:1c:01 (try 1)
[   27.423577] wlan0: RX AssocResp from 00:18:4d:39:1c:01 (capab=0x431 status=0 aid=2)
[   27.423582] wlan0: associated
[   27.426526] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   30.030015] virbr0: no IPv6 routers present
[   30.732601] Skipping EDID probe due to cached edid
[   38.112709] wlan0: no IPv6 routers present
[   88.551385] ata3.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
[   88.551392] ata3.00: irq_stat 0x40000001
[   88.551398] ata3.00: failed command: READ FPDMA QUEUED
[   88.551409] ata3.00: cmd 60/08:00:81:87:ed/00:00:2b:00:00/40 tag 0 ncq 4096 in
[   88.551411]          res 41/40:00:82:87:ed/00:00:2b:00:00/40 Emask 0x409 (media error) <F>
[   88.551416] ata3.00: status: { DRDY ERR }
[   88.551420] ata3.00: error: { UNC }
[   88.551424] ata3.00: failed command: READ FPDMA QUEUED
[   88.551434] ata3.00: cmd 60/08:08:27:19:48/00:00:1d:00:00/40 tag 1 ncq 4096 in
[   88.551436]          res 41/40:00:88:87:ed/00:00:2b:00:00/40 Emask 0x9 (media error)
[   88.551441] ata3.00: status: { DRDY ERR }
[   88.551444] ata3.00: error: { UNC }
[   88.557928] ata3.00: configured for UDMA/133
[   88.557942] ata3: EH complete
[   91.174958] ata3.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
[   91.174965] ata3.00: irq_stat 0x40000008
[   91.174971] ata3.00: failed command: READ FPDMA QUEUED
[   91.174982] ata3.00: cmd 60/08:08:81:87:ed/00:00:2b:00:00/40 tag 1 ncq 4096 in
[   91.174984]          res 41/40:00:82:87:ed/00:00:2b:00:00/40 Emask 0x409 (media error) <F>
[   91.174989] ata3.00: status: { DRDY ERR }
[   91.174993] ata3.00: error: { UNC }
[   91.182767] ata3.00: configured for UDMA/133
[   91.182782] ata3: EH complete
[   93.798634] ata3.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
[   93.798641] ata3.00: irq_stat 0x40000008
[   93.798647] ata3.00: failed command: READ FPDMA QUEUED
[   93.798657] ata3.00: cmd 60/08:00:81:87:ed/00:00:2b:00:00/40 tag 0 ncq 4096 in
[   93.798660]          res 41/40:00:82:87:ed/00:00:2b:00:00/40 Emask 0x409 (media error) <F>
[   93.798665] ata3.00: status: { DRDY ERR }
[   93.798669] ata3.00: error: { UNC }
[   93.806730] ata3.00: configured for UDMA/133
[   93.806745] ata3: EH complete
[   96.422129] ata3.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
[   96.422136] ata3.00: irq_stat 0x40000008
[   96.422142] ata3.00: failed command: READ FPDMA QUEUED
[   96.422153] ata3.00: cmd 60/08:08:81:87:ed/00:00:2b:00:00/40 tag 1 ncq 4096 in
[   96.422155]          res 41/40:00:82:87:ed/00:00:2b:00:00/40 Emask 0x409 (media error) <F>
[   96.422160] ata3.00: status: { DRDY ERR }
[   96.422164] ata3.00: error: { UNC }
[   96.429681] ata3.00: configured for UDMA/133
[   96.429694] ata3: EH complete
[   99.045668] ata3.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
[   99.045675] ata3.00: irq_stat 0x40000008
[   99.045681] ata3.00: failed command: READ FPDMA QUEUED
[   99.045691] ata3.00: cmd 60/08:00:81:87:ed/00:00:2b:00:00/40 tag 0 ncq 4096 in
[   99.045693]          res 41/40:00:82:87:ed/00:00:2b:00:00/40 Emask 0x409 (media error) <F>
[   99.045699] ata3.00: status: { DRDY ERR }
[   99.045702] ata3.00: error: { UNC }
[   99.053647] ata3.00: configured for UDMA/133
[   99.053661] ata3: EH complete
[  101.669206] ata3.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
[  101.669213] ata3.00: irq_stat 0x40000008
[  101.669219] ata3.00: failed command: READ FPDMA QUEUED
[  101.669229] ata3.00: cmd 60/08:08:81:87:ed/00:00:2b:00:00/40 tag 1 ncq 4096 in
[  101.669231]          res 41/40:00:82:87:ed/00:00:2b:00:00/40 Emask 0x409 (media error) <F>
[  101.669237] ata3.00: status: { DRDY ERR }
[  101.669240] ata3.00: error: { UNC }
[  101.675726] ata3.00: configured for UDMA/133
[  101.675743] sd 2:0:0:0: [sda] Unhandled sense code
[  101.675747] sd 2:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  101.675753] sd 2:0:0:0: [sda] Sense Key : Medium Error [current] [descriptor]
[  101.675761] Descriptor sense data with sense descriptors (in hex):
[  101.675765]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[  101.675781]         2b ed 87 82 
[  101.675788] sd 2:0:0:0: [sda] Add. Sense: Unrecovered read error - auto reallocate failed
[  101.675796] sd 2:0:0:0: [sda] CDB: Read(10): 28 00 2b ed 87 81 00 00 08 00
[  101.675811] end_request: I/O error, dev sda, sector 736987010
[  101.675831] ata3: EH complete
[  101.675872] BUG: unable to handle kernel NULL pointer dereference at (null)
[  101.675880] IP: [<ffffffffa0341861>] extent_range_uptodate+0x51/0xa0 [btrfs]
[  101.675909] PGD 0 
[  101.675914] Oops: 0000 [#1] SMP 
[  101.675919] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/PNP0C0A:00/power_supply/BAT1/voltage_now
[  101.675926] CPU 1 
[  101.675928] Modules linked in: hidp hid binfmt_misc rfcomm ppdev sco bnep l2cap vboxnetadp vboxnetflt vboxdrv ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel kvm microcode joydev snd_hda_codec_si3054 snd_hda_codec_realtek btrfs zlib_deflate crc32c libcrc32c snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi arc4 snd_seq_midi_event snd_seq iwl3945 i915 iwlcore mac80211 snd_timer snd_seq_device drm_kms_helper btusb uinput psmouse serio_raw bluetooth snd sdhci_pci cfg80211 drm sdhci led_class i2c_algo_bit soundcore lp video snd_page_alloc output intel_agp intel_gtt parport ohci1394 ieee1394 ahci tg3 libahci
[  101.676023] 
[  101.676029] Pid: 844, comm: btrfs-endio-met Not tainted 2.6.35rc3-test-generic #1-Ubuntu IFT01         /N/A                                            
[  101.676034] RIP: 0010:[<ffffffffa0341861>]  [<ffffffffa0341861>] extent_range_uptodate+0x51/0xa0 [btrfs]
[  101.676055] RSP: 0018:ffff8801284dbdd0  EFLAGS: 00010246
[  101.676058] RAX: 0000000000000000 RBX: 0000000d3213d000 RCX: 0000000000000000
[  101.676061] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000000
[  101.676064] RBP: ffff8801284dbdf0 R08: 0000000000000001 R09: 0000000000000000
[  101.676067] R10: 0000000000001000 R11: 0000000000000000 R12: ffff880136030038
[  101.676070] R13: 0000000d3213d1ff R14: ffff880128f7c000 R15: ffff880128f78668
[  101.676073] FS:  0000000000000000(0000) GS:ffff880001f00000(0000) knlGS:0000000000000000
[  101.676076] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  101.676079] CR2: 0000000000000000 CR3: 0000000001a2a000 CR4: 00000000000006e0
[  101.676082] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  101.676085] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  101.676088] Process btrfs-endio-met (pid: 844, threadinfo ffff8801284da000, task ffff880128fc96d0)
[  101.676090] Stack:
[  101.676092]  0000000000000000 ffff880119e01f38 ffff880115ff4d80 ffff880119e01f00
[  101.676097] <0> ffff8801284dbe20 ffffffffa031b1a6 ffff880119e01f60 ffff880128f78660
[  101.676102] <0> ffff880128f78678 ffff8801284dbe80 ffff8801284dbee0 ffffffffa034b2dc
[  101.676108] Call Trace:
[  101.676122]  [<ffffffffa031b1a6>] end_workqueue_fn+0x116/0x130 [btrfs]
[  101.676135]  [<ffffffffa034b2dc>] worker_loop+0x15c/0x4c0 [btrfs]
[  101.676147]  [<ffffffffa034b180>] ? worker_loop+0x0/0x4c0 [btrfs]
[  101.676154]  [<ffffffff8107d2e6>] kthread+0x96/0xa0
[  101.676159]  [<ffffffff8100aee4>] kernel_thread_helper+0x4/0x10
[  101.676163]  [<ffffffff8107d250>] ? kthread+0x0/0xa0
[  101.676166]  [<ffffffff8100aee0>] ? kernel_thread_helper+0x0/0x10
[  101.676169] Code: 49 89 d5 e8 32 fc ff ff 85 c0 75 38 4c 39 eb 77 33 66 0f 1f 84 00 00 00 00 00 49 8b 7c 24 20 48 89 de 48 c1 ee 0c e8 2f d7 db e0 <f6> 00 08 74 22 48 89 c7 48 81 c3 00 10 00 00 e8 4b 84 dc e0 49 
[  101.676210] RIP  [<ffffffffa0341861>] extent_range_uptodate+0x51/0xa0 [btrfs]
[  101.676223]  RSP <ffff8801284dbdd0>
[  101.676225] CR2: 0000000000000000
[  101.676229] ---[ end trace b152fa246141a06f ]---

--------------080504060801010907080708--
