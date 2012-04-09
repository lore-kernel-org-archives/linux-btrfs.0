From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Boot speed/mount time regression with 3.4.0-rc2
Date: Mon, 09 Apr 2012 11:53:43 -0400
Message-ID: <1333986823.2928.6.camel@ayu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-p3VqrKtci1fdrn2Ipah3"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-p3VqrKtci1fdrn2Ipah3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,

I have a system that's using a dracut-generated initramfs to mount a
btrfs root. After upgrading to kernel 3.4.0-rc2 to test it out, I've
noticed that the process of mounting the root filesystem takes much
longer with 3.4.0-rc2 than it did with 3.3.1 - nearly 30 seconds slower!

Does anyone have any ideas? I'm going to try bisecting the issue to see
if I can narrow down the cause. I've included excerpts from dmesg of the
bad and good kernels here, and attached the complete dmesg from the bad
kernel, in case it has anything interesting that I've trimmed out here.

slow:
[    0.000000] Linux version 3.4.0-rc2 (cwalton@ayu) (gcc version 4.6.3 (Exherbo gcc-4.6.3) ) #57 SMP PREEMPT Mon Apr 9 11:19:43 EDT 2012
[    0.000000] Command line: root=UUID=43969cd0-4aca-4297-bfbe-952a692f7d55 rootflags=subvolid=262,compress=lzo,autodefrag,space_cache,inode_cache,noatime mtrr_chunk_size=512M quiet
<snip>
[    1.058257] udevd[701]: starting version 182
[    1.389606] device label Linux data devid 1 transid 611923 /dev/sda4
[    1.498659] dracut: Checking, if btrfs device complete
[    1.644808] device label Linux data devid 1 transid 611923 /dev/sda4
[    1.647993] btrfs: disk space caching is enabled
[    2.180836] device label Linux data devid 1 transid 611923 /dev/sda4
[    2.181663] btrfs: use lzo compression
[    2.181667] btrfs: enabling auto defrag
[    2.181670] btrfs: enabling inode map caching
[    2.181672] btrfs: disk space caching is enabled
[    2.697845] dracut: Checking btrfs: /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55
[    2.699999] dracut: trying to mount /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55
[    2.702637] device label Linux data devid 1 transid 611923 /dev/sda4
[    2.704376] btrfs: disk space caching is enabled
[    3.081720] dracut: btrfs: /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55 is clean
[   29.934639] dracut: Remounting /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55 with -o subvolid=262,compress=lzo,autodefrag,space_cache,inode_cache,noatime,ro
[   29.936810] device label Linux data devid 1 transid 611926 /dev/sda4
[   29.937720] btrfs: use lzo compression
[   29.937726] btrfs: enabling auto defrag
[   29.937733] btrfs: enabling inode map caching
[   29.937735] btrfs: disk space caching is enabled
[   30.388066] dracut: Mounted root filesystem /dev/sda4
[   30.461884] dracut: Switching root
[   31.241729] udevd[1322]: starting version 182
[   31.422905] btrfs: use lzo compression
[   31.422909] btrfs: enabling auto defrag
[   31.422913] btrfs: enabling inode map caching
[   31.422915] btrfs: disk space caching is enabled

vs fast:
[    0.000000] Linux version 3.3.1 (cwalton@ayu) (gcc version 4.6.3 (Exherbo gcc-4.6.3) ) #53 SMP PREEMPT Wed Apr 4 01:20:47 EDT 2012
[    0.000000] Command line: root=UUID=43969cd0-4aca-4297-bfbe-952a692f7d55 rootflags=subvolid=262,compress=lzo,autodefrag,space_cache,inode_cache,noatime mtrr_chunk_size=512M quiet
<snip>
[    1.060117] udevd[695]: starting version 182
[    1.344328] device label Linux data devid 1 transid 611917 /dev/sda4
[    1.384888] dracut: Checking, if btrfs device complete
[    1.405121] device label Linux data devid 1 transid 611917 /dev/sda4
[    1.405905] btrfs: disk space caching is enabled
[    1.971953] device label Linux data devid 1 transid 611917 /dev/sda4
[    1.972519] btrfs: use lzo compression
[    1.972523] btrfs: enabling auto defrag
[    1.972526] btrfs: enabling inode map caching
[    1.972528] btrfs: disk space caching is enabled
[    2.528540] dracut: Checking btrfs: /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55
[    2.530725] dracut: trying to mount /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55
[    2.558285] device label Linux data devid 1 transid 611917 /dev/sda4
[    2.559087] btrfs: disk space caching is enabled
[    3.013103] dracut: btrfs: /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55 is clean
[    3.518807] dracut: Remounting /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55 with -o subvolid=262,compress=lzo,autodefrag,space_cache,inode_cache,noatime,ro
[    3.520031] device label Linux data devid 1 transid 611920 /dev/sda4
[    3.520680] btrfs: use lzo compression
[    3.520684] btrfs: enabling auto defrag
[    3.520688] btrfs: enabling inode map caching
[    3.520689] btrfs: disk space caching is enabled
[    4.066285] dracut: Mounted root filesystem /dev/sda4
[    4.120861] dracut: Switching root
[    4.995934] btrfs: use lzo compression
[    4.995938] btrfs: enabling auto defrag
[    4.995942] btrfs: enabling inode map caching
[    4.995943] btrfs: disk space caching is enabled
[    5.010473] udevd[1330]: starting version 182

-- 
Calvin Walton <calvin.walton@kepstin.ca>

--=-p3VqrKtci1fdrn2Ipah3
Content-Disposition: attachment; filename="3.4.0-rc2-dmesg"
Content-Type: text/plain; name="3.4.0-rc2-dmesg"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.0-rc2 (cwalton@ayu) (gcc version 4.6.3 (Exherbo gcc-4.6.3) ) #57 SMP PREEMPT Mon Apr 9 11:19:43 EDT 2012
[    0.000000] Command line: root=UUID=43969cd0-4aca-4297-bfbe-952a692f7d55 rootflags=subvolid=262,compress=lzo,autodefrag,space_cache,inode_cache,noatime mtrr_chunk_size=512M quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf6b0000 (usable)
[    0.000000]  BIOS-e820: 00000000bf6b0000 - 00000000bf6cc000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf6cc000 - 00000000bf700000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf700000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: LENOVO 77327CU/77327CU, BIOS 7LETC7WW (2.27 ) 04/08/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 13C000000 mask FFC000000 uncachable
[    0.000000]   2 base 000000000 mask F00000000 write-back
[    0.000000]   3 base 100000000 mask FC0000000 write-back
[    0.000000]   4 base 0BF700000 mask FFFF00000 uncachable
[    0.000000]   5 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 3GB, range: 1GB, type UC
[    0.000000] reg 1, base: 5056MB, range: 64MB, type UC
[    0.000000] reg 2, base: 0GB, range: 4GB, type WB
[    0.000000] reg 3, base: 4GB, range: 1GB, type WB
[    0.000000] reg 4, base: 3063MB, range: 1MB, type UC
[    0.000000] reg 5, base: 3064MB, range: 8MB, type UC
[    0.000000] total RAM covered: 4023M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3063MB, range: 1MB, type UC
[    0.000000] reg 3, base: 3064MB, range: 8MB, type UC
[    0.000000] reg 4, base: 4GB, range: 1GB, type WB
[    0.000000] reg 5, base: 5056MB, range: 64MB, type UC
[    0.000000] e820 update range: 00000000bf700000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf6b0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf6b0000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf6b0000 page 4k
[    0.000000] kernel direct mapping tables up to bf6b0000 @ 1fffb000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ bf6aa000-bf6b0000
[    0.000000] RAMDISK: 37cb4000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f68c0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bf6bb496 0009C (v01 LENOVO TP-7U    00002270  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bf6bb600 000F4 (v03 LENOVO TP-7U    00002270 LNVO 00000001)
[    0.000000] ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 (20120320/tbfadt-548)
[    0.000000] ACPI Warning: Optional field Gpe1Block has zero address or length: 0x000000000000102C/0x0 (20120320/tbfadt-579)
[    0.000000] ACPI: DSDT 00000000bf6bba1d 1003C (v01 LENOVO TP-7U    00002270 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bf6e4000 00040
[    0.000000] ACPI: SSDT 00000000bf6bb7b4 00269 (v01 LENOVO TP-7U    00002270 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bf6cba59 00052 (v01 LENOVO TP-7U    00002270 LNVO 00000001)
[    0.000000] ACPI: TCPA 00000000bf6cbaab 00032 (v02 LENOVO TP-7U    00002270 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bf6cbadd 00068 (v01 LENOVO TP-7U    00002270 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bf6cbb45 0003C (v01 LENOVO TP-7U    00002270 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bf6cbb81 00038 (v01 LENOVO TP-7U    00002270 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bf6cbbb9 00176 (v01 LENOVO TP-7U    00002270  LTP 00000000)
[    0.000000] ACPI: SLAC 00000000bf6cbdf0 00176 (v01 LENOVO TP-7U    00002270  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bf6cbf66 00028 (v01 LENOVO TP-7U    00002270  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bf6cbf8e 00072 (v16 LENOVO TP-7U    00002270 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bf6e26d9 0025F (v01 LENOVO TP-7U    00002270 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000bf6e2938 000A6 (v01 LENOVO TP-7U    00002270 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000bf6e29de 004F7 (v01 LENOVO TP-7U    00002270 INTL 20050513)
[    0.000000] ACPI: SSDT 00000000bf6e2ed5 001D8 (v01 LENOVO TP-7U    00002270 INTL 20050513)
[    0.000000] ACPI: DMI detected: Lenovo ThinkPad R61
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff880137600000-ffff88013b5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000bf6b0
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1029693
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 763632 pages, LIFO batch:31
[    0.000000]   Normal zone: 3840 pages used for memmap
[    0.000000]   Normal zone: 241920 pages, LIFO batch:31
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
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf6b0000 - 00000000bf6cc000
[    0.000000] PM: Registered nosave memory: 00000000bf6cc000 - 00000000bf700000
[    0.000000] PM: Registered nosave memory: 00000000bf700000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000fec00000
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
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:30000000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88013bc00000 s72576 r8192 d21632 u1048576
[    0.000000] pcpu-alloc: s72576 r8192 d21632 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1009464
[    0.000000] Kernel command line: root=UUID=43969cd0-4aca-4297-bfbe-952a692f7d55 rootflags=subvolid=262,compress=lzo,autodefrag,space_cache,inode_cache,noatime mtrr_chunk_size=512M quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3967628k/5177344k available (5367k kernel code, 1058572k absent, 151144k reserved, 3192k data, 452k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2094.807 MHz processor.
[    0.001003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4189.61 BogoMIPS (lpj=2094807)
[    0.001007] pid_max: default: 32768 minimum: 301
[    0.001031] Security Framework initialized
[    0.001045] Mount-cache hash table entries: 256
[    0.002046] Initializing cgroup subsys cpuacct
[    0.002048] Initializing cgroup subsys devices
[    0.002050] Initializing cgroup subsys blkio
[    0.002080] CPU: Physical Processor ID: 0
[    0.002081] CPU: Processor Core ID: 0
[    0.002083] mce: CPU supports 6 MCE banks
[    0.002090] CPU0: Thermal monitoring enabled (TM2)
[    0.002093] using mwait in idle threads.
[    0.002129] ACPI: Core revision 20120320
[    0.010389] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.020397] CPU0: Intel(R) Core(TM)2 Duo CPU     T8100  @ 2.10GHz stepping 06
[    0.020998] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.020998] ... version:                2
[    0.020998] ... bit width:              40
[    0.020998] ... generic registers:      2
[    0.020998] ... value mask:             000000ffffffffff
[    0.020998] ... max period:             000000007fffffff
[    0.020998] ... fixed-purpose events:   3
[    0.020998] ... event mask:             0000000700000003
[    0.026086] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.032013] Booting Node   0, Processors  #1 Ok.
[    0.043996] TSC synchronization [CPU#0 -> CPU#1]:
[    0.043996] Measured 385770 cycles TSC warp between CPUs, turning off TSC clock.
[    0.043996] Marking TSC unstable due to check_tsc_sync_source failed
[    0.044029] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.044074] Brought up 2 CPUs
[    0.044076] Total of 2 processors activated (8379.22 BogoMIPS).
[    0.045066] devtmpfs: initialized
[    0.045148] PM: Registering ACPI NVS region [mem 0xbf6cc000-0xbf6fffff] (212992 bytes)
[    0.045148] NET: Registered protocol family 16
[    0.045148] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.045148] ACPI: bus type pci registered
[    0.045148] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.045148] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.056811] PCI: Using configuration type 1 for base access
[    0.060068] bio: create slab <bio-0> at 0
[    0.060068] ACPI: Added _OSI(Module Device)
[    0.060068] ACPI: Added _OSI(Processor Device)
[    0.060068] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.060068] ACPI: Added _OSI(Processor Aggregator Device)
[    0.060068] ACPI: Added _OSI(Linux)
[    0.062611] ACPI: EC: EC description table is found, configuring boot EC
[    0.067908] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via DMI
[    0.074198] ACPI: SSDT 00000000bf6e1b32 002C4 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[    0.074666] ACPI: Dynamic OEM Table Load:
[    0.074670] ACPI: SSDT           (null) 002C4 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[    0.074801] ACPI: SSDT 00000000bf6e1e7b 0085E (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[    0.075292] ACPI: Dynamic OEM Table Load:
[    0.075295] ACPI: SSDT           (null) 0085E (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[    0.075309] ACPI: SSDT 00000000bf6e1a6a 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[    0.076134] ACPI: Dynamic OEM Table Load:
[    0.076137] ACPI: SSDT           (null) 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[    0.076214] ACPI: SSDT 00000000bf6e1df6 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[    0.076669] ACPI: Dynamic OEM Table Load:
[    0.076672] ACPI: SSDT           (null) 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[    0.076686] ACPI: Interpreter enabled
[    0.076686] ACPI: (supports S0 S3 S4 S5)
[    0.076686] ACPI: Using IOAPIC for interrupt routing
[    0.080067] ACPI: Power Resource [PUBS] (on)
[    0.085124] ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
[    0.087226] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.087230] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.087436] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.087459] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.087462] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.087464] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.087467] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    0.087469] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.087471] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.087474] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
[    0.087477] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.087479] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed4bfff]
[    0.087512] PCI host bridge to bus 0000:00
[    0.087512] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.087512] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.087512] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.087512] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.087512] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.087512] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.087512] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.087512] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
[    0.087512] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.087512] pci 0000:00:00.0: [8086:2a00] type 00 class 0x060000
[    0.087512] pci 0000:00:02.0: [8086:2a02] type 00 class 0x030000
[    0.087512] pci 0000:00:02.0: reg 10: [mem 0xf8100000-0xf81fffff 64bit]
[    0.087512] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.087512] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.087512] pci 0000:00:02.1: [8086:2a03] type 00 class 0x038000
[    0.087512] pci 0000:00:02.1: reg 10: [mem 0xf8200000-0xf82fffff 64bit]
[    0.088012] pci 0000:00:19.0: [8086:1049] type 00 class 0x020000
[    0.088047] pci 0000:00:19.0: reg 10: [mem 0xfe000000-0xfe01ffff]
[    0.088070] pci 0000:00:19.0: reg 14: [mem 0xfe025000-0xfe025fff]
[    0.088088] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.088235] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.088276] pci 0000:00:1a.0: [8086:2834] type 00 class 0x0c0300
[    0.088381] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.088469] pci 0000:00:1a.1: [8086:2835] type 00 class 0x0c0300
[    0.088583] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.088684] pci 0000:00:1a.7: [8086:283a] type 00 class 0x0c0320
[    0.088720] pci 0000:00:1a.7: reg 10: [mem 0xfe226c00-0xfe226fff]
[    0.088883] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.088938] pci 0000:00:1b.0: [8086:284b] type 00 class 0x040300
[    0.088967] pci 0000:00:1b.0: reg 10: [mem 0xfe020000-0xfe023fff 64bit]
[    0.089097] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.089154] pci 0000:00:1c.0: [8086:283f] type 01 class 0x060400
[    0.089286] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.089333] pci 0000:00:1c.1: [8086:2841] type 01 class 0x060400
[    0.089459] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.089510] pci 0000:00:1c.2: [8086:2843] type 01 class 0x060400
[    0.089643] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.089691] pci 0000:00:1c.3: [8086:2845] type 01 class 0x060400
[    0.089816] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.089865] pci 0000:00:1c.4: [8086:2847] type 01 class 0x060400
[    0.090001] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.090051] pci 0000:00:1d.0: [8086:2830] type 00 class 0x0c0300
[    0.090166] pci 0000:00:1d.0: reg 20: [io  0x18a0-0x18bf]
[    0.090248] pci 0000:00:1d.1: [8086:2831] type 00 class 0x0c0300
[    0.090364] pci 0000:00:1d.1: reg 20: [io  0x18c0-0x18df]
[    0.090453] pci 0000:00:1d.2: [8086:2832] type 00 class 0x0c0300
[    0.090553] pci 0000:00:1d.2: reg 20: [io  0x18e0-0x18ff]
[    0.090662] pci 0000:00:1d.7: [8086:2836] type 00 class 0x0c0320
[    0.090700] pci 0000:00:1d.7: reg 10: [mem 0xfe227000-0xfe2273ff]
[    0.090889] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.090940] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.091095] pci 0000:00:1f.0: [8086:2811] type 00 class 0x060100
[    0.091258] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.091267] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.091273] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
[    0.091280] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
[    0.091286] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
[    0.091374] pci 0000:00:1f.1: [8086:2850] type 00 class 0x01018a
[    0.091407] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.091430] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.091455] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.091478] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.091504] pci 0000:00:1f.1: reg 20: [io  0x1c00-0x1c0f]
[    0.091604] pci 0000:00:1f.2: [8086:2829] type 00 class 0x010601
[    0.091640] pci 0000:00:1f.2: reg 10: [io  0x1c50-0x1c57]
[    0.091654] pci 0000:00:1f.2: reg 14: [io  0x1c44-0x1c47]
[    0.091671] pci 0000:00:1f.2: reg 18: [io  0x1c48-0x1c4f]
[    0.091692] pci 0000:00:1f.2: reg 1c: [io  0x1c40-0x1c43]
[    0.091712] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.091725] pci 0000:00:1f.2: reg 24: [mem 0xfe226000-0xfe2267ff]
[    0.091801] pci 0000:00:1f.2: PME# supported from D3hot
[    0.091845] pci 0000:00:1f.3: [8086:283e] type 00 class 0x0c0500
[    0.091865] pci 0000:00:1f.3: reg 10: [mem 0xfe227400-0xfe2274ff]
[    0.091908] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.092059] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.092066] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.092073] pci 0000:00:1c.0:   bridge window [mem 0xfc000000-0xfdffffff]
[    0.092083] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf80fffff 64bit pref]
[    0.092225] pci 0000:03:00.0: [8086:4229] type 00 class 0x028000
[    0.092281] pci 0000:03:00.0: reg 10: [mem 0xdf3fe000-0xdf3fffff 64bit]
[    0.092499] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.094040] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.094047] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.094054] pci 0000:00:1c.1:   bridge window [mem 0xdc000000-0xdf3fffff]
[    0.094063] pci 0000:00:1c.1:   bridge window [mem 0xdfe00000-0xdfefffff 64bit pref]
[    0.094138] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    0.094147] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.094156] pci 0000:00:1c.2:   bridge window [mem 0xd8000000-0xd9ffffff]
[    0.094171] pci 0000:00:1c.2:   bridge window [mem 0xdfb00000-0xdfbfffff 64bit pref]
[    0.094248] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.094255] pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
[    0.094264] pci 0000:00:1c.3:   bridge window [mem 0xd4000000-0xd5ffffff]
[    0.094279] pci 0000:00:1c.3:   bridge window [mem 0xdf800000-0xdf8fffff 64bit pref]
[    0.094351] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.094358] pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
[    0.094365] pci 0000:00:1c.4:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.094374] pci 0000:00:1c.4:   bridge window [mem 0xdf500000-0xdf5fffff 64bit pref]
[    0.094441] pci 0000:15:00.0: [1180:0476] type 02 class 0x060700
[    0.094480] pci 0000:15:00.0: reg 10: [mem 0xf8300000-0xf8300fff]
[    0.094549] pci 0000:15:00.0: supports D1 D2
[    0.094551] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.094595] pci 0000:15:00.1: [1180:0832] type 00 class 0x0c0010
[    0.094634] pci 0000:15:00.1: reg 10: [mem 0xf8301000-0xf83017ff]
[    0.094815] pci 0000:15:00.1: supports D1 D2
[    0.094817] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.094974] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
[    0.094983] pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff]
[    0.094994] pci 0000:00:1e.0:   bridge window [mem 0xf8300000-0xfbffffff]
[    0.095003] pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xf7ffffff 64bit pref]
[    0.095006] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.095008] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.095011] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.095013] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.095016] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.095018] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.095021] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    0.095023] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
[    0.095026] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed4bfff] (subtractive decode)
[    0.095174] pci_bus 0000:00: on NUMA node 0
[    0.095177] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.095262] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.095287] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.095310] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.095334] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.095361] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.095388] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.095622]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.095934]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.101039] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 *6 7 9 10 11)
[    0.101106] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.101171] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 9 10 11)
[    0.101234] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.101297] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11)
[    0.101360] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 9 10 11)
[    0.101423] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 *4 5 6 7 9 10 11)
[    0.101486] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
[    0.101525] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.101525] vgaarb: loaded
[    0.101525] vgaarb: bridge control possible 0000:00:02.0
[    0.101525] SCSI subsystem initialized
[    0.101525] libata version 3.00 loaded.
[    0.102032] PCI: Using ACPI for IRQ routing
[    0.104529] PCI: pci_cache_line_size set to 64 bytes
[    0.104647] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    0.104649] reserve RAM buffer: 00000000bf6b0000 - 00000000bfffffff 
[    0.104668] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.104668] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.104668] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.110006] Switching to clocksource hpet
[    0.110051] pnp: PnP ACPI init
[    0.110061] ACPI: bus type pnp registered
[    0.110389] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.110392] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.110394] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.110395] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.110398] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.110400] pnp 00:00: [mem 0x000d0000-0x000cffff disabled]
[    0.110402] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    0.110404] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    0.110406] pnp 00:00: [mem 0x000dc000-0x000dbfff disabled]
[    0.110408] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.110410] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.110411] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.110413] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.110415] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.110417] pnp 00:00: [mem 0x00100000-0xbfffffff]
[    0.110419] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.110421] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.110500] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.110503] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.110506] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.110509] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.110511] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.110514] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.110517] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.110519] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.110522] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.110525] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.110528] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.110530] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.110533] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.110537] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.110557] pnp 00:01: [bus 00-ff]
[    0.110559] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.110562] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.110564] pnp 00:01: [io  0x0d00-0xffff window]
[    0.110566] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.110568] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.110570] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.110572] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.110576] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.110579] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.110581] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.110583] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.110585] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.110587] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.110589] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.110591] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.110593] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.110595] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    0.110597] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    0.110665] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.110704] pnp 00:02: [io  0x0010-0x001f]
[    0.110707] pnp 00:02: [io  0x0090-0x009f]
[    0.110708] pnp 00:02: [io  0x0024-0x0025]
[    0.110710] pnp 00:02: [io  0x0028-0x0029]
[    0.110712] pnp 00:02: [io  0x002c-0x002d]
[    0.110714] pnp 00:02: [io  0x0030-0x0031]
[    0.110715] pnp 00:02: [io  0x0034-0x0035]
[    0.110717] pnp 00:02: [io  0x0038-0x0039]
[    0.110719] pnp 00:02: [io  0x003c-0x003d]
[    0.110721] pnp 00:02: [io  0x00a4-0x00a5]
[    0.110722] pnp 00:02: [io  0x00a8-0x00a9]
[    0.110724] pnp 00:02: [io  0x00ac-0x00ad]
[    0.110726] pnp 00:02: [io  0x00b0-0x00b5]
[    0.110727] pnp 00:02: [io  0x00b8-0x00b9]
[    0.110729] pnp 00:02: [io  0x00bc-0x00bd]
[    0.110731] pnp 00:02: [io  0x0050-0x0053]
[    0.110732] pnp 00:02: [io  0x0072-0x0077]
[    0.110734] pnp 00:02: [io  0x164e-0x164f]
[    0.110736] pnp 00:02: [io  0x002e-0x002f]
[    0.110738] pnp 00:02: [io  0x1000-0x107f]
[    0.110740] pnp 00:02: [io  0x1180-0x11bf]
[    0.110742] pnp 00:02: [io  0x0800-0x080f]
[    0.110743] pnp 00:02: [io  0x15e0-0x15ef]
[    0.110745] pnp 00:02: [io  0x1600-0x165f]
[    0.110747] pnp 00:02: [mem 0xf0000000-0xf3ffffff]
[    0.110749] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    0.110751] pnp 00:02: [mem 0xfed14000-0xfed17fff]
[    0.110752] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.110754] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.110756] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    0.110886] system 00:02: [io  0x164e-0x164f] has been reserved
[    0.110889] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.110892] system 00:02: [io  0x1180-0x11bf] has been reserved
[    0.110894] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.110897] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.110899] system 00:02: [io  0x1600-0x165f] could not be reserved
[    0.110903] system 00:02: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.110905] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.110908] system 00:02: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.110911] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.110913] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.110916] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.110919] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.110955] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.111022] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.111033] pnp 00:04: [io  0x0000-0x000f]
[    0.111035] pnp 00:04: [io  0x0080-0x008f]
[    0.111037] pnp 00:04: [io  0x00c0-0x00df]
[    0.111039] pnp 00:04: [dma 4]
[    0.111090] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.111099] pnp 00:05: [io  0x0061]
[    0.111149] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.111159] pnp 00:06: [io  0x00f0]
[    0.111169] pnp 00:06: [irq 13]
[    0.111223] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.111234] pnp 00:07: [io  0x0070-0x0071]
[    0.111240] pnp 00:07: [irq 8]
[    0.111292] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.111302] pnp 00:08: [io  0x0060]
[    0.111303] pnp 00:08: [io  0x0064]
[    0.111309] pnp 00:08: [irq 1]
[    0.111364] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.111377] pnp 00:09: [irq 12]
[    0.111432] pnp 00:09: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
[    0.111774] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.111831] pnp 00:0a: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
[    0.112344] pnp: PnP ACPI: found 11 devices
[    0.112347] ACPI: ACPI bus type pnp unregistered
[    0.117062] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.117067] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.117074] pci 0000:00:1c.0:   bridge window [mem 0xfc000000-0xfdffffff]
[    0.117080] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf80fffff 64bit pref]
[    0.117088] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.117092] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.117099] pci 0000:00:1c.1:   bridge window [mem 0xdc000000-0xdf3fffff]
[    0.117104] pci 0000:00:1c.1:   bridge window [mem 0xdfe00000-0xdfefffff 64bit pref]
[    0.117112] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    0.117116] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.117122] pci 0000:00:1c.2:   bridge window [mem 0xd8000000-0xd9ffffff]
[    0.117128] pci 0000:00:1c.2:   bridge window [mem 0xdfb00000-0xdfbfffff 64bit pref]
[    0.117136] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.117139] pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
[    0.117146] pci 0000:00:1c.3:   bridge window [mem 0xd4000000-0xd5ffffff]
[    0.117151] pci 0000:00:1c.3:   bridge window [mem 0xdf800000-0xdf8fffff 64bit pref]
[    0.117160] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.117163] pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
[    0.117172] pci 0000:00:1c.4:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.117180] pci 0000:00:1c.4:   bridge window [mem 0xdf500000-0xdf5fffff 64bit pref]
[    0.117191] pci 0000:15:00.0: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
[    0.117194] pci 0000:15:00.0: res[10]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
[    0.117197] pci 0000:15:00.0: res[7]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.117199] pci 0000:15:00.0: res[8]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.117204] pci 0000:15:00.0: BAR 9: assigned [mem 0xf4000000-0xf7ffffff pref]
[    0.117208] pci 0000:15:00.0: BAR 10: assigned [mem 0xc0000000-0xc3ffffff]
[    0.117210] pci 0000:15:00.0: BAR 7: assigned [io  0x7000-0x70ff]
[    0.117213] pci 0000:15:00.0: BAR 8: assigned [io  0x7400-0x74ff]
[    0.117216] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
[    0.117218] pci 0000:15:00.0:   bridge window [io  0x7000-0x70ff]
[    0.117224] pci 0000:15:00.0:   bridge window [io  0x7400-0x74ff]
[    0.117230] pci 0000:15:00.0:   bridge window [mem 0xf4000000-0xf7ffffff pref]
[    0.117236] pci 0000:15:00.0:   bridge window [mem 0xc0000000-0xc3ffffff]
[    0.117242] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
[    0.117246] pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff]
[    0.117252] pci 0000:00:1e.0:   bridge window [mem 0xf8300000-0xfbffffff]
[    0.117257] pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xf7ffffff 64bit pref]
[    0.117312] pci 0000:00:1e.0: enabling device (0005 -> 0007)
[    0.117319] pci 0000:00:1e.0: setting latency timer to 64
[    0.117335] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.117337] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.117340] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.117342] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.117344] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.117347] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.117349] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.117351] pci_bus 0000:00: resource 11 [mem 0xc0000000-0xfebfffff]
[    0.117354] pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed4bfff]
[    0.117356] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.117359] pci_bus 0000:02: resource 1 [mem 0xfc000000-0xfdffffff]
[    0.117361] pci_bus 0000:02: resource 2 [mem 0xf8000000-0xf80fffff 64bit pref]
[    0.117364] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.117366] pci_bus 0000:03: resource 1 [mem 0xdc000000-0xdf3fffff]
[    0.117368] pci_bus 0000:03: resource 2 [mem 0xdfe00000-0xdfefffff 64bit pref]
[    0.117371] pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
[    0.117373] pci_bus 0000:04: resource 1 [mem 0xd8000000-0xd9ffffff]
[    0.117375] pci_bus 0000:04: resource 2 [mem 0xdfb00000-0xdfbfffff 64bit pref]
[    0.117378] pci_bus 0000:05: resource 0 [io  0x5000-0x5fff]
[    0.117380] pci_bus 0000:05: resource 1 [mem 0xd4000000-0xd5ffffff]
[    0.117382] pci_bus 0000:05: resource 2 [mem 0xdf800000-0xdf8fffff 64bit pref]
[    0.117385] pci_bus 0000:0d: resource 0 [io  0x6000-0x6fff]
[    0.117387] pci_bus 0000:0d: resource 1 [mem 0xd0000000-0xd1ffffff]
[    0.117389] pci_bus 0000:0d: resource 2 [mem 0xdf500000-0xdf5fffff 64bit pref]
[    0.117392] pci_bus 0000:15: resource 0 [io  0x7000-0xafff]
[    0.117394] pci_bus 0000:15: resource 1 [mem 0xf8300000-0xfbffffff]
[    0.117396] pci_bus 0000:15: resource 2 [mem 0xf4000000-0xf7ffffff 64bit pref]
[    0.117398] pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
[    0.117401] pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
[    0.117403] pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
[    0.117405] pci_bus 0000:15: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.117408] pci_bus 0000:15: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.117410] pci_bus 0000:15: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.117412] pci_bus 0000:15: resource 10 [mem 0x000dc000-0x000dffff]
[    0.117414] pci_bus 0000:15: resource 11 [mem 0xc0000000-0xfebfffff]
[    0.117417] pci_bus 0000:15: resource 12 [mem 0xfed40000-0xfed4bfff]
[    0.117419] pci_bus 0000:16: resource 0 [io  0x7000-0x70ff]
[    0.117421] pci_bus 0000:16: resource 1 [io  0x7400-0x74ff]
[    0.117423] pci_bus 0000:16: resource 2 [mem 0xf4000000-0xf7ffffff pref]
[    0.117426] pci_bus 0000:16: resource 3 [mem 0xc0000000-0xc3ffffff]
[    0.117466] NET: Registered protocol family 2
[    0.117521] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.117975] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.120152] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.120736] TCP: Hash tables configured (established 262144 bind 65536)
[    0.120738] TCP: reno registered
[    0.120742] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.120780] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.120902] NET: Registered protocol family 1
[    0.121043] RPC: Registered named UNIX socket transport module.
[    0.121045] RPC: Registered udp transport module.
[    0.121047] RPC: Registered tcp transport module.
[    0.121048] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.121064] pci 0000:00:02.0: Boot video device
[    0.121115] pci 0000:00:1a.1: power state changed by ACPI to D0
[    0.121118] pci 0000:00:1a.1: power state changed by ACPI to D0
[    0.121147] pci 0000:00:1a.7: power state changed by ACPI to D0
[    0.121152] pci 0000:00:1a.7: power state changed by ACPI to D0
[    0.121224] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.121227] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.121290] pci 0000:00:1d.2: power state changed by ACPI to D0
[    0.121292] pci 0000:00:1d.2: power state changed by ACPI to D0
[    0.121324] pci 0000:00:1d.7: power state changed by ACPI to D0
[    0.121328] pci 0000:00:1d.7: power state changed by ACPI to D0
[    0.121384] PCI: CLS mismatch (64 != 32), using 64 bytes
[    0.121437] Unpacking initramfs...
[    0.620762] Freeing initrd memory: 3312k freed
[    0.622307] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.622312] Placing 64MB software IO TLB between ffff8800bb6aa000 - ffff8800bf6aa000
[    0.622315] software IO TLB at phys 0xbb6aa000 - 0xbf6aa000
[    0.622656] Simple Boot Flag at 0x35 set to 0x1
[    0.623099] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[    0.623471] audit: initializing netlink socket (disabled)
[    0.623486] type=2000 audit(1333985773.622:1): initialized
[    0.623842] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.628384] NFS: Registering the id_resolver key type
[    0.628623] fuse init (API version 7.18)
[    0.629236] Btrfs loaded
[    0.629241] msgmni has been set to 7755
[    0.629609] NET: Registered protocol family 38
[    0.629709] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.629713] io scheduler noop registered
[    0.629822] io scheduler cfq registered (default)
[    0.630042] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.630304] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.630557] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    0.630806] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    0.631080] pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
[    0.631369] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.631375] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.631397] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.631400] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.631405] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.631426] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    0.631432] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    0.631454] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.631459] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.631480] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    0.631485] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    0.631925] ACPI: AC Adapter [AC] (on-line)
[    0.632227] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.632390] ACPI: Lid Switch [LID]
[    0.632461] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.632466] ACPI: Sleep Button [SLPB]
[    0.632545] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.632549] ACPI: Power Button [PWRF]
[    0.632682] ACPI: Requesting acpi_cpufreq
[    0.634543] Monitor-Mwait will be used to enter C-1 state
[    0.634572] Monitor-Mwait will be used to enter C-2 state
[    0.634599] Monitor-Mwait will be used to enter C-3 state
[    0.634629] ACPI: acpi_idle registered with cpuidle
[    0.640553] thermal LNXTHERM:00: registered as thermal_zone0
[    0.640556] ACPI: Thermal Zone [THM0] (53 C)
[    0.641414] thermal LNXTHERM:01: registered as thermal_zone1
[    0.641417] ACPI: Thermal Zone [THM1] (48 C)
[    0.642443] loop: module loaded
[    0.642550] ahci 0000:00:1f.2: version 3.0
[    0.642614] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    0.642796] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
[    0.642800] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc 
[    0.642806] ahci 0000:00:1f.2: setting latency timer to 64
[    0.644188] scsi0 : ahci
[    0.644359] scsi1 : ahci
[    0.644536] scsi2 : ahci
[    0.644921] ata1: SATA max UDMA/133 abar m2048@0xfe226000 port 0xfe226100 irq 45
[    0.644924] ata2: DUMMY
[    0.644979] ata3: SATA max UDMA/133 abar m2048@0xfe226000 port 0xfe226200 irq 45
[    0.645404] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.656386] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.656392] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.657227] mousedev: PS/2 mouse device common for all mice
[    0.657288] rtc_cmos 00:07: RTC can wake from S4
[    0.657449] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.657480] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.657786] cpuidle: using governor ladder
[    0.657941] cpuidle: using governor menu
[    0.658789] GACT probability on
[    0.658793] Mirror/redirect action on
[    0.658794] Simple TC action Loaded
[    0.659038] netem: version 1.3
[    0.659041] u32 classifier
[    0.659042]     Performance counters on
[    0.659044]     input device check on
[    0.659045]     Actions configured
[    0.659089] IPv4 over IPv4 tunneling driver
[    0.659426] TCP: cubic registered
[    0.659428] Initializing XFRM netlink socket
[    0.659852] NET: Registered protocol family 10
[    0.660307] Mobile IPv6
[    0.660309] IPv6 over IPv4 tunneling driver
[    0.661352] NET: Registered protocol family 17
[    0.661359] NET: Registered protocol family 15
[    0.661378] Bridge firewalling registered
[    0.664406] DCCP: Activated CCID 2 (TCP-like)
[    0.664420] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    0.666036] sctp: Hash tables configured (established 65536 bind 65536)
[    0.666417] ACPI: Battery Slot [BAT0] (battery present)
[    0.666525] Registering the dns_resolver key type
[    0.667840] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.950684] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.950712] ata3: SATA link down (SStatus 0 SControl 300)
[    0.953893] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.953897] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.953901] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.958163] ata1.00: ATA-8: ST95005620AS, SD28, max UDMA/133
[    0.958166] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    0.960129] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.960133] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.960136] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.962986] ata1.00: configured for UDMA/133
[    0.963157] scsi 0:0:0:0: Direct-Access     ATA      ST95005620AS     SD28 PQ: 0 ANSI: 5
[    0.963517] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    0.963562] sd 0:0:0:0: [sda] Write Protect is off
[    0.963565] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.963610] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.966856]  sda: sda1 sda2 sda3 sda4 sda5
[    0.967674] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.974851] registered taskstats version 1
[    0.975334] rtc_cmos 00:07: setting system clock to 2012-04-09 15:36:15 UTC (1333985775)
[    0.978223] Freeing unused kernel memory: 452k freed
[    0.978404] Write protecting the kernel read-only data: 8192k
[    0.980885] Freeing unused kernel memory: 756k freed
[    0.981445] Freeing unused kernel memory: 64k freed
[    1.058257] udevd[701]: starting version 182
[    1.127393] usbcore: registered new interface driver usbfs
[    1.130195] ata_piix 0000:00:1f.1: version 2.13
[    1.130263] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.131623] usbcore: registered new interface driver hub
[    1.138648] usbcore: registered new device driver usb
[    1.145558] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.146717] uhci_hcd: USB Universal Host Controller Interface driver
[    1.147224] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
[    1.151340] scsi3 : ata_piix
[    1.152737] scsi4 : ata_piix
[    1.153934] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1c00 irq 14
[    1.153936] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1c08 irq 15
[    1.153993] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    1.153998] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    1.154063] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.154066] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.154073] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.154702] ata5: port disabled--ignoring
[    1.157987] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.158009] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfe226c00
[    1.163669] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.163705] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.163710] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.163715] usb usb1: Product: EHCI Host Controller
[    1.163718] usb usb1: Manufacturer: Linux 3.4.0-rc2 ehci_hcd
[    1.163722] usb usb1: SerialNumber: 0000:00:1a.7
[    1.163980] hub 1-0:1.0: USB hub found
[    1.163985] hub 1-0:1.0: 4 ports detected
[    1.164084] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.164088] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.164096] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
[    1.164136] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    1.164173] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.164176] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.164178] usb usb2: Product: UHCI Host Controller
[    1.164180] usb usb2: Manufacturer: Linux 3.4.0-rc2 uhci_hcd
[    1.164183] usb usb2: SerialNumber: 0000:00:1a.0
[    1.164365] hub 2-0:1.0: USB hub found
[    1.164370] hub 2-0:1.0: 2 ports detected
[    1.164437] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[    1.164440] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[    1.164450] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.164454] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.164477] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
[    1.164513] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    1.164546] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.164548] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.164551] usb usb3: Product: UHCI Host Controller
[    1.164553] usb usb3: Manufacturer: Linux 3.4.0-rc2 uhci_hcd
[    1.164555] usb usb3: SerialNumber: 0000:00:1a.1
[    1.165081] hub 3-0:1.0: USB hub found
[    1.165085] hub 3-0:1.0: 2 ports detected
[    1.165151] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.165154] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.165167] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.165171] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.165176] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    1.165208] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
[    1.165242] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.165244] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.165246] usb usb4: Product: UHCI Host Controller
[    1.165248] usb usb4: Manufacturer: Linux 3.4.0-rc2 uhci_hcd
[    1.165250] usb usb4: SerialNumber: 0000:00:1d.0
[    1.165438] hub 4-0:1.0: USB hub found
[    1.165442] hub 4-0:1.0: 2 ports detected
[    1.165516] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.165520] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.165525] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    1.165562] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
[    1.165595] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.165597] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.165600] usb usb5: Product: UHCI Host Controller
[    1.165601] usb usb5: Manufacturer: Linux 3.4.0-rc2 uhci_hcd
[    1.165604] usb usb5: SerialNumber: 0000:00:1d.1
[    1.165774] hub 5-0:1.0: USB hub found
[    1.165778] hub 5-0:1.0: 2 ports detected
[    1.165847] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[    1.165850] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[    1.165861] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.165864] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.165870] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    1.165905] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
[    1.165938] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.165940] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.165943] usb usb6: Product: UHCI Host Controller
[    1.165945] usb usb6: Manufacturer: Linux 3.4.0-rc2 uhci_hcd
[    1.165947] usb usb6: SerialNumber: 0000:00:1d.2
[    1.166102] hub 6-0:1.0: USB hub found
[    1.166106] hub 6-0:1.0: 2 ports detected
[    1.166196] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    1.166201] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    1.166229] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.166233] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.166239] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
[    1.166271] ehci_hcd 0000:00:1d.7: debug port 1
[    1.170161] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.170175] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfe227000
[    1.175681] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.175697] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    1.175700] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.175702] usb usb7: Product: EHCI Host Controller
[    1.175704] usb usb7: Manufacturer: Linux 3.4.0-rc2 ehci_hcd
[    1.175706] usb usb7: SerialNumber: 0000:00:1d.7
[    1.175889] hub 7-0:1.0: USB hub found
[    1.175894] hub 7-0:1.0: 6 ports detected
[    1.270504] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
[    1.270508] yenta_cardbus 0000:15:00.0: Socket status: 30000006
[    1.270514] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x7000-0xafff]
[    1.270517] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xf8300000-0xfbffffff]
[    1.270521] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf8300000-0xfbffffff: excluding 0xf8300000-0xf86cffff
[    1.270533] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xf4000000-0xf7ffffff 64bit pref]
[    1.270536] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf4000000-0xf7ffffff: excluding 0xf4000000-0xf7ffffff
[    1.308153] ata4.00: ATAPI: MATSHITADVD-RAM UJ-850, RB11, max UDMA/33
[    1.314466] ata4.00: configured for UDMA/33
[    1.316771] scsi 3:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-850   RB11 PQ: 0 ANSI: 5
[    1.322958] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.322964] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.323201] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.323690] firewire_ohci 0000:15:00.1: added OHCI v1.10 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
[    1.389606] device label Linux data devid 1 transid 611923 /dev/sda4
[    1.498659] dracut: Checking, if btrfs device complete
[    1.644808] device label Linux data devid 1 transid 611923 /dev/sda4
[    1.647993] btrfs: disk space caching is enabled
[    1.773734] usb 2-1: new full-speed USB device number 2 using uhci_hcd
[    1.824778] firewire_core 0000:15:00.1: created device fw0: GUID 00061b032a11ea0c, S400
[    1.931209] usb 2-1: New USB device found, idVendor=0a5c, idProduct=2110
[    1.931218] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.931225] usb 2-1: Product: BCM2045B
[    1.931230] usb 2-1: Manufacturer: Broadcom Corp
[    2.140707] usb 2-2: new full-speed USB device number 3 using uhci_hcd
[    2.180836] device label Linux data devid 1 transid 611923 /dev/sda4
[    2.181663] btrfs: use lzo compression
[    2.181667] btrfs: enabling auto defrag
[    2.181670] btrfs: enabling inode map caching
[    2.181672] btrfs: disk space caching is enabled
[    2.305206] usb 2-2: New USB device found, idVendor=0483, idProduct=2016
[    2.305216] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.305222] usb 2-2: Product: Biometric Coprocessor
[    2.305227] usb 2-2: Manufacturer: STMicroelectronics
[    2.697845] dracut: Checking btrfs: /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55
[    2.699999] dracut: trying to mount /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55
[    2.702637] device label Linux data devid 1 transid 611923 /dev/sda4
[    2.704376] btrfs: disk space caching is enabled
[    3.081720] dracut: btrfs: /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55 is clean
[   29.934639] dracut: Remounting /dev/disk/by-uuid/43969cd0-4aca-4297-bfbe-952a692f7d55 with -o subvolid=262,compress=lzo,autodefrag,space_cache,inode_cache,noatime,ro
[   29.936810] device label Linux data devid 1 transid 611926 /dev/sda4
[   29.937720] btrfs: use lzo compression
[   29.937726] btrfs: enabling auto defrag
[   29.937733] btrfs: enabling inode map caching
[   29.937735] btrfs: disk space caching is enabled
[   30.388066] dracut: Mounted root filesystem /dev/sda4
[   30.461884] dracut: Switching root
[   31.241729] udevd[1322]: starting version 182
[   31.422905] btrfs: use lzo compression
[   31.422909] btrfs: enabling auto defrag
[   31.422913] btrfs: enabling inode map caching
[   31.422915] btrfs: disk space caching is enabled
[   31.564097] Linux agpgart interface v0.103
[   31.576862] tpm_tis 00:0a: 1.2 TPM (device-id 0x3202, rev-id 5)
[   31.578423] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[   31.578551] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[   31.579652] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[   31.583292] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[   31.598081] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[   31.598084] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   31.598124] e1000e 0000:00:19.0: setting latency timer to 64
[   31.598287] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   31.628261] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   31.651078] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
[   31.668312] [drm] Initialized drm 1.1.0 20060810
[   31.668755] Non-volatile memory driver v1.3
[   31.713785] Bluetooth: Core ver 2.16
[   31.714080] NET: Registered protocol family 31
[   31.714082] Bluetooth: HCI device and connection manager initialized
[   31.714085] Bluetooth: HCI socket layer initialized
[   31.714087] Bluetooth: L2CAP socket layer initialized
[   31.714089] Bluetooth: SCO socket layer initialized
[   31.714402] cfg80211: Calling CRDA to update world regulatory domain
[   31.769751] iwl4965: Intel(R) Wireless WiFi 4965 driver for Linux, in-tree:
[   31.769755] iwl4965: Copyright(c) 2003-2011 Intel Corporation
[   31.769904] iwl4965 0000:03:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
[   31.771749] usbcore: registered new interface driver btusb
[   31.808843] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   31.808846] thinkpad_acpi: http://ibm-acpi.sf.net/
[   31.808847] thinkpad_acpi: ThinkPad BIOS 7LETC7WW (2.27 ), EC 7KHT24WW-1.08
[   31.808849] thinkpad_acpi: Lenovo ThinkPad R61/R61i, model 77327CU
[   31.809275] iwl4965 0000:03:00.0: device EEPROM VER=0x36, CALIB=0x5
[   31.809292] iwl4965 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
[   31.809383] iwl4965 0000:03:00.0: irq 47 for MSI/MSI-X
[   31.811040] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   31.813312] thinkpad_acpi: ACPI backlight control delay disabled
[   31.813541] thinkpad_acpi: radio switch found; radios are enabled
[   31.817200] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[   31.818734] Registered led device: tpacpi::thinklight
[   31.818838] Registered led device: tpacpi::power
[   31.818918] Registered led device: tpacpi::standby
[   31.819125] Registered led device: tpacpi::thinkvantage
[   31.821758] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[   31.822439] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   31.824029] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input5
[   31.874602] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1a:6b:3a:07:e4
[   31.874606] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   31.874631] e1000e 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: FFFFFF-0FF
[   31.874675] hda_intel: probe_mask set to 0x1 for device 17aa:20ac
[   31.874770] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[   31.901733] device label Linux data devid 1 transid 611926 /dev/sda4
[   31.940058] microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
[   31.945716] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
[   31.947510] microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
[   31.953445] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   31.987858] iwl4965 0000:03:00.0: loaded firmware version 228.61.2.24
[   31.988123] Registered led device: phy0-led
[   31.988512] ieee80211 phy0: Selected rate control algorithm 'iwl-4965-rs'
[   31.994568] Adding 4194300k swap on /dev/sda3.  Priority:0 extents:1 across:4194300k 
[   32.064196] udevd[1802]: renamed network interface wlan0 to wlan2
[   32.244787] cfg80211: World regulatory domain updated:
[   32.244791] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   32.244794] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   32.244796] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   32.244799] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   32.244801] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   32.244804] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   32.257895] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
[   32.265912] i915 0000:00:02.0: power state changed by ACPI to D0
[   32.265917] i915 0000:00:02.0: power state changed by ACPI to D0
[   32.268928] i915 0000:00:02.0: setting latency timer to 64
[   32.271518] psmouse serio1: synaptics: Touchpad model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000/0x0
[   32.271525] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[   32.319154] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[   32.340827] i915 0000:00:02.0: irq 49 for MSI/MSI-X
[   32.340837] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   32.340839] [drm] Driver supports precise vblank timestamp query.
[   32.340886] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   32.380252] composite sync not supported
[   32.393552] EXT4-fs (sda2): mounted filesystem without journal. Opts: (null)
[   32.772870] [drm] initialized overlay support
[   32.778558] composite sync not supported
[   32.797107] fbcon: inteldrmfb (fb0) is primary device
[   33.043556] Console: switching to colour frame buffer device 180x56
[   33.047361] fb0: inteldrmfb frame buffer device
[   33.047363] drm: registered panic notifier
[   33.049955] acpi device:02: registered as cooling_device2
[   33.050628] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input8
[   33.051234] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   33.051540] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   33.055321] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   33.055325] Bluetooth: BNEP filters: protocol multicast
[   33.067689] Bluetooth: RFCOMM TTY layer initialized
[   33.067693] Bluetooth: RFCOMM socket layer initialized
[   33.067695] Bluetooth: RFCOMM ver 1.11
[   33.355874] syslog-ng (2019): Attempt to access syslog with CAP_SYS_ADMIN but no CAP_SYSLOG (deprecated).
[   34.176468] composite sync not supported
[   34.201146] composite sync not supported
[   34.700600] composite sync not supported
[   34.748418] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   34.799335] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   34.799934] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   35.047712] ADDRCONF(NETDEV_UP): wlan2: link is not ready
[   35.152351] ip_tables: (C) 2000-2006 Netfilter Core Team
[   35.551735] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   35.736912] ADDRCONF(NETDEV_UP): virbr0: link is not ready
[   35.977621] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   37.459444] composite sync not supported
[   37.872237] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   38.106269] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input9
[   38.480549] ata1.00: configured for UDMA/133
[   38.480556] ata1: EH complete
[   38.619111] EXT4-fs (sda2): re-mounted. Opts: commit=0
[   39.688560] wlan2: authenticate with 00:1e:e5:7a:b2:5d
[   39.688586] wlan2: send auth to 00:1e:e5:7a:b2:5d (try 1/3)
[   39.692335] wlan2: authenticated
[   39.702210] wlan2: associate with 00:1e:e5:7a:b2:5d (try 1/3)
[   39.704781] wlan2: RX AssocResp from 00:1e:e5:7a:b2:5d (capab=0x431 status=0 aid=2)
[   39.704785] wlan2: associated
[   39.733077] ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
[   50.466240] wlan2: no IPv6 routers present

--=-p3VqrKtci1fdrn2Ipah3--

