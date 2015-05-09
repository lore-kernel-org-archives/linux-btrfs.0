Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out.abv.bg ([194.153.145.99]:39014 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbbEIGMd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 May 2015 02:12:33 -0400
Received: from nm33.abv.bg (nm33.ni.bg [192.168.151.4])
	by smtp-out.abv.bg (Postfix) with ESMTP id 4717C14EC21
	for <linux-btrfs@vger.kernel.org>; Sat,  9 May 2015 09:03:04 +0300 (EEST)
Received: from nm33.abv.bg (localhost.localdomain [127.0.0.1])
	by nm33.abv.bg (Postfix) with ESMTP id 56847BDF5C
	for <linux-btrfs@vger.kernel.org>; Sat,  9 May 2015 09:03:04 +0300 (EEST)
Date: Sat, 9 May 2015 09:03:04 +0300 (EEST)
From: =?utf-8?B?0JzQuNC70LXQvSDQpdGA0LjRgdGC0L7Qsg==?= <milen_hr@abv.bg>
To: linux-btrfs@vger.kernel.org
Message-ID: <1798034232.614027.1431151384353.JavaMail.apache@nm33.abv.bg>
Subject: Btrfs changes (issues?) on OS upgrade
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_614025_2063127118.1431151384347"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

------=_Part_614025_2063127118.1431151384347
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Hi btrfs team,

I'm using btrfs on a Ubuntu 14.10 server which I recently upgraded to 15.04:

milen@server ~/Desktop> uname -a
Linux server 3.19.0-16-generic #16-Ubuntu SMP Thu Apr 30 16:09:58 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

The server has 5 HDDs, 4 of them dedicated to a btrfs filesystem in Raid 1 layout:

milen@server ~/Desktop> sudo btrfs fi show
Label: none  uuid: 684a6bda-4fb5-420d-a2d1-019e38fdc1ee
	Total devices 4 FS bytes used 3.95TiB
	devid    1 size 2.73TiB used 2.50TiB path /dev/sdd
	devid    2 size 2.73TiB used 2.50TiB path /dev/sde
	devid    3 size 931.51GiB used 699.00GiB path /dev/sdb
	devid    4 size 2.73TiB used 2.50TiB path /dev/sdc

Btrfs v3.17

milen@server ~/Desktop> sudo btrfs fi df /mnt/d
Data, RAID1: total=4.08TiB, used=3.95TiB
System, RAID1: total=32.00MiB, used=624.00KiB
Metadata, RAID1: total=7.00GiB, used=5.30GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


After the recent OS upgrade I noticed a couple of issues I wanted to ask about:

1. Before the upgrade, the size of the entire array was reported as 9TB (roughly), both on the server (I use conky to monitor server status) and via samba on Windows clients. After the upgrade, the size is reduced to 4.55 TB which seems to better reflect what the actual usable space is, but is unexpected to me (I read some articles on the web about the difficulties in calculating free space on a btrfs filesystem). Is this expected?

2. After the upgrade I see the following entries in the kernel log(attached):

[   78.717743]  sdb: unknown partition table
[   78.735588]  sdc: unknown partition table
[   78.736279]  sdd: unknown partition table
[   78.781962]  sde: unknown partition table

These correspond to the btrfs drives. How can I check that there is no problem with my filesystem? These messages did not appear on 14.10. When reading data the server still seems to access all drives but I wanted to be sure.

I know btrfs is still considered experimental but I did put some important data I don't want to loose on the fs so I just want to make sure everything's OK. Any help is greatly appreciated.

Milen
------=_Part_614025_2063127118.1431151384347
Content-Type: application/octet-stream; name=dmesg.log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg.log

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.19.0-16-generic (buildd@komainu) (gcc version 4.9.2 (Ubuntu 4.9.2-10ubuntu13) ) #16-Ubuntu SMP Thu Apr 30 16:09:58 UTC 2015 (Ubuntu 3.19.0-16.16-generic 3.19.3)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.19.0-16-generic root=UUID=0df15882-e9c6-472b-8889-5d709d3ccb03 ro splash quiet acpi_enforce_resources=lax vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009dc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e3000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bb77ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bb780000-0x00000000bb78dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bb78e000-0x00000000bb7cffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bb7d0000-0x00000000bb7dffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bb7ed000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013bffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: ECS H55H-M/H55H-M, BIOS 080016  09/13/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 000000000 mask F00000000 write-back
[    0.000000]   2 base 100000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   4 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC  
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 5056MB, range: 64MB, type UC
[    0.000000] reg 1, base: 0GB, range: 4GB, type WB
[    0.000000] reg 2, base: 4GB, range: 1GB, type WB
[    0.000000] reg 3, base: 3GB, range: 1GB, type UC
[    0.000000] reg 4, base: 3008MB, range: 64MB, type UC
[    0.000000] total RAM covered: 3968M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 5  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3008MB, range: 64MB, type UC
[    0.000000] reg 3, base: 4GB, range: 1GB, type WB
[    0.000000] reg 4, base: 5056MB, range: 64MB, type UC
[    0.000000] e820: update [mem 0xbc000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbb780 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fe5000, 0x01fe5fff] PGTABLE
[    0.000000] BRK [0x01fe6000, 0x01fe6fff] PGTABLE
[    0.000000] BRK [0x01fe7000, 0x01fe7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13be00000-0x13bffffff]
[    0.000000]  [mem 0x13be00000-0x13bffffff] page 2M
[    0.000000] BRK [0x01fe8000, 0x01fe8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x120000000-0x13bdfffff]
[    0.000000]  [mem 0x120000000-0x13bdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11fffffff]
[    0.000000]  [mem 0x100000000-0x11fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbb77ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbb5fffff] page 2M
[    0.000000]  [mem 0xbb600000-0xbb77ffff] page 4k
[    0.000000] RAMDISK: [mem 0x3574a000-0x36b9cfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F9BF0 000014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 0x00000000BB780000 000044 (v01 091310 RSDT1844 20100913 MSFT 00000097)
[    0.000000] ACPI: FACP 0x00000000BB780200 000084 (v01 091310 FACP1844 20100913 MSFT 00000097)
[    0.000000] ACPI: DSDT 0x00000000BB780460 0093C4 (v01 1AAAA  1AAAA000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000BB78E000 000040
[    0.000000] ACPI: APIC 0x00000000BB780390 00008C (v01 091310 APIC1844 20100913 MSFT 00000097)
[    0.000000] ACPI: MCFG 0x00000000BB780420 00003C (v01 091310 OEMMCFG  20100913 MSFT 00000097)
[    0.000000] ACPI: OEMB 0x00000000BB78E040 000072 (v01 091310 OEMB1844 20100913 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000BB78B460 000038 (v01 091310 OEMHPET  20100913 MSFT 00000097)
[    0.000000] ACPI: EWMI 0x00000000BB78E0C0 00004E (v01 091310 OEMB1844 20100913 MSFT 00000097)
[    0.000000] ACPI: GSCI 0x00000000BB78E110 002024 (v01 091310 GMCHSCI  20100913 MSFT 00000097)
[    0.000000] ACPI: SSDT 0x00000000BB791BB0 000363 (v01 DpgPmm CpuPm    00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013bffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13bff8000-0x13bffcfff]
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff880137600000-ffff88013b5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13bffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xbb77ffff]
[    0.000000]   node   0: [mem 0x100000000-0x13bffffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13bffffff]
[    0.000000] On node 0 totalpages: 1013532
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11934 pages used for memmap
[    0.000000]   DMA32 zone: 763776 pages, LIFO batch:31
[    0.000000]   Normal zone: 3840 pages used for memmap
[    0.000000]   Normal zone: 245760 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xbe000000-0xbfffffff
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 6, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e2fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e3000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb780000-0xbb78dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb78e000-0xbb7cffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb7d0000-0xbb7dffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb7e0000-0xbb7ecfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb7ed000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffafffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffb00000-0xffffffff]
[    0.000000] e820: [mem 0xc0000000-0xfedfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff88013bc00000 s87040 r8192 d31744 u262144
[    0.000000] pcpu-alloc: s87040 r8192 d31744 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 997673
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.19.0-16-generic root=UUID=0df15882-e9c6-472b-8889-5d709d3ccb03 ro splash quiet acpi_enforce_resources=lax vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3884072K/4054128K available (7993K kernel code, 1232K rwdata, 3752K rodata, 1408K init, 1300K bss, 170056K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:16640 nr_irqs:488 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] vt handoff: transparent VT on vt#7
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3072.708 MHz processor
[    0.000032] Calibrating delay loop (skipped), value calculated using timer frequency.. 6145.41 BogoMIPS (lpj=12290832)
[    0.000034] pid_max: default: 32768 minimum: 301
[    0.000040] ACPI: Core revision 20141107
[    0.005699] ACPI: All ACPI Tables successfully acquired
[    0.005816] Security Framework initialized
[    0.005835] AppArmor: AppArmor initialized
[    0.005836] Yama: becoming mindful.
[    0.006124] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.006999] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.007388] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.007395] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.007610] Initializing cgroup subsys memory
[    0.007617] Initializing cgroup subsys devices
[    0.007620] Initializing cgroup subsys freezer
[    0.007623] Initializing cgroup subsys net_cls
[    0.007626] Initializing cgroup subsys blkio
[    0.007628] Initializing cgroup subsys perf_event
[    0.007631] Initializing cgroup subsys net_prio
[    0.007634] Initializing cgroup subsys hugetlb
[    0.007656] CPU: Physical Processor ID: 0
[    0.007657] CPU: Processor Core ID: 0
[    0.007663] mce: CPU supports 9 MCE banks
[    0.007674] CPU0: Thermal monitoring enabled (TM1)
[    0.007684] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.007780] Freeing SMP alternatives memory: 32K (ffffffff81e96000 - ffffffff81e9e000)
[    0.008974] ftrace: allocating 30078 entries in 118 pages
[    0.023930] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.063585] smpboot: CPU0: Intel(R) Core(TM) i3 CPU         540  @ 3.07GHz (fam: 06, model: 25, stepping: 05)
[    0.170836] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.170852] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.170855] ... version:                3
[    0.170856] ... bit width:              48
[    0.170857] ... generic registers:      4
[    0.170858] ... value mask:             0000ffffffffffff
[    0.170859] ... max period:             000000007fffffff
[    0.170859] ... fixed-purpose events:   3
[    0.170860] ... event mask:             000000070000000f
[    0.171737] x86: Booting SMP configuration:
[    0.171739] .... node  #0, CPUs:      #1
[    0.184892] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.185016]  #2 #3
[    0.211424] x86: Booted up 1 node, 4 CPUs
[    0.211428] smpboot: Total of 4 processors activated (24581.66 BogoMIPS)
[    0.213900] devtmpfs: initialized
[    0.215973] evm: security.selinux
[    0.215974] evm: security.SMACK64
[    0.215975] evm: security.SMACK64EXEC
[    0.215976] evm: security.SMACK64TRANSMUTE
[    0.215977] evm: security.SMACK64MMAP
[    0.215977] evm: security.ima
[    0.215978] evm: security.capability
[    0.216039] PM: Registering ACPI NVS region [mem 0xbb78e000-0xbb7cffff] (270336 bytes)
[    0.216179] pinctrl core: initialized pinctrl subsystem
[    0.216278] RTC time:  5:35:52, date: 05/09/15
[    0.216368] NET: Registered protocol family 16
[    0.218796] cpuidle: using governor ladder
[    0.222787] cpuidle: using governor menu
[    0.222890] ACPI: bus type PCI registered
[    0.222893] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.222956] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.222958] PCI: not using MMCONFIG
[    0.222960] PCI: Using configuration type 1 for base access
[    0.227184] ACPI: Added _OSI(Module Device)
[    0.227186] ACPI: Added _OSI(Processor Device)
[    0.227187] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.227188] ACPI: Added _OSI(Processor Aggregator Device)
[    0.228791] ACPI: Executed 1 blocks of module-level executable AML code
[    0.230625] ACPI: Dynamic OEM Table Load:
[    0.230633] ACPI: SSDT 0xFFFF880136718000 001340 (v01 DpgPmm P001Ist  00000011 INTL 20051117)
[    0.230988] ACPI: Dynamic OEM Table Load:
[    0.230992] ACPI: SSDT 0xFFFF880136692800 0004F4 (v01 PmRef  P001Cst  00003001 INTL 20051117)
[    0.231289] ACPI: Dynamic OEM Table Load:
[    0.231293] ACPI: SSDT 0xFFFF8801366D2400 000226 (v01 PmRef  Cpu0Tst  00003000 INTL 20051117)
[    0.231635] ACPI: Interpreter enabled
[    0.231643] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20141107/hwxface-580)
[    0.231655] ACPI: (supports S0 S1 S3 S4 S5)
[    0.231656] ACPI: Using IOAPIC for interrupt routing
[    0.231673] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.232389] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.232825] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.237674] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.237679] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.237805] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
[    0.237867] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.237870] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.237871] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    0.237873] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.238110] PCI host bridge to bus 0000:00
[    0.238113] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.238114] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.238116] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.238117] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.238119] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.238120] pci_bus 0000:00: root bus resource [mem 0xbc000000-0xdfffffff]
[    0.238122] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfed8ffff]
[    0.238130] pci 0000:00:00.0: [8086:0040] type 00 class 0x060000
[    0.238147] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
[    0.238208] pci 0000:00:02.0: [8086:0042] type 00 class 0x030000
[    0.238217] pci 0000:00:02.0: reg 0x10: [mem 0xfb800000-0xfbbfffff 64bit]
[    0.238222] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.238226] pci 0000:00:02.0: reg 0x20: [io  0xdc00-0xdc07]
[    0.238318] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.238335] pci 0000:00:1a.0: reg 0x10: [mem 0xfbef8000-0xfbef83ff]
[    0.238410] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.238447] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.238482] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.238495] pci 0000:00:1b.0: reg 0x10: [mem 0xfbef4000-0xfbef7fff 64bit]
[    0.238555] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.238616] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.238671] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.238706] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.238738] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    0.238795] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.238831] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.238863] pci 0000:00:1c.2: [8086:3b46] type 01 class 0x060400
[    0.238921] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.238957] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.238988] pci 0000:00:1c.3: [8086:3b48] type 01 class 0x060400
[    0.239042] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.239077] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.239108] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
[    0.239162] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.239197] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.239227] pci 0000:00:1c.5: [8086:3b4c] type 01 class 0x060400
[    0.239281] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.239316] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.239352] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.239369] pci 0000:00:1d.0: reg 0x10: [mem 0xfbef2000-0xfbef23ff]
[    0.239444] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.239480] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.239510] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.239573] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.239606] pci 0000:00:1f.0: [8086:3b06] type 00 class 0x060100
[    0.239753] pci 0000:00:1f.2: [8086:3b22] type 00 class 0x010601
[    0.239768] pci 0000:00:1f.2: reg 0x10: [io  0xd880-0xd887]
[    0.239774] pci 0000:00:1f.2: reg 0x14: [io  0xd800-0xd803]
[    0.239780] pci 0000:00:1f.2: reg 0x18: [io  0xd480-0xd487]
[    0.239786] pci 0000:00:1f.2: reg 0x1c: [io  0xd400-0xd403]
[    0.239792] pci 0000:00:1f.2: reg 0x20: [io  0xd080-0xd09f]
[    0.239798] pci 0000:00:1f.2: reg 0x24: [mem 0xfbef0000-0xfbef07ff]
[    0.239834] pci 0000:00:1f.2: PME# supported from D3hot
[    0.239894] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
[    0.239906] pci 0000:00:1f.3: reg 0x10: [mem 0xfbeee000-0xfbeee0ff 64bit]
[    0.239923] pci 0000:00:1f.3: reg 0x20: [io  0x0400-0x041f]
[    0.240027] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.240072] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.240134] pci 0000:03:00.0: [1969:1063] type 00 class 0x020000
[    0.240157] pci 0000:03:00.0: reg 0x10: [mem 0xfbfc0000-0xfbffffff 64bit]
[    0.240167] pci 0000:03:00.0: reg 0x18: [io  0xec00-0xec7f]
[    0.240267] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.246779] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.246785] pci 0000:00:1c.2:   bridge window [io  0xe000-0xefff]
[    0.246791] pci 0000:00:1c.2:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.246866] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.246911] pci 0000:00:1c.4: PCI bridge to [bus 05]
[    0.246957] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    0.247018] pci 0000:00:1e.0: PCI bridge to [bus 07] (subtractive decode)
[    0.247025] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.247026] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.247028] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.247029] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.247030] pci 0000:00:1e.0:   bridge window [mem 0xbc000000-0xdfffffff] (subtractive decode)
[    0.247032] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[    0.247555] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.247596] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.247634] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.247673] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.247713] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    0.247752] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    0.247792] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.247831] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 6 7 10 11 12 14 15)
[    0.247890] ACPI: Enabled 2 GPEs in block 00 to 3F
[    0.247972] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.247974] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.247976] vgaarb: loaded
[    0.247977] vgaarb: bridge control possible 0000:00:02.0
[    0.248163] SCSI subsystem initialized
[    0.248206] libata version 3.00 loaded.
[    0.248229] ACPI: bus type USB registered
[    0.248243] usbcore: registered new interface driver usbfs
[    0.248250] usbcore: registered new interface driver hub
[    0.248265] usbcore: registered new device driver usb
[    0.248378] PCI: Using ACPI for IRQ routing
[    0.253247] PCI: Discovered peer bus ff
[    0.253248] PCI: root bus ff: using default resources
[    0.253249] PCI: Probing PCI hardware (bus ff)
[    0.253270] PCI host bridge to bus 0000:ff
[    0.253272] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    0.253274] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xfffffffff]
[    0.253275] pci_bus 0000:ff: No busn resource found for root bus, will use [bus ff-ff]
[    0.253277] pci_bus 0000:ff: busn_res: can not insert [bus ff] under domain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    0.253281] pci 0000:ff:00.0: [8086:2c61] type 00 class 0x060000
[    0.253318] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
[    0.253353] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
[    0.253386] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
[    0.253419] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
[    0.253452] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
[    0.253492] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
[    0.253494] pci_bus 0000:ff: busn_res: can not insert [bus ff] under domain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    0.253496] PCI: pci_cache_line_size set to 64 bytes
[    0.253529] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.253531] e820: reserve RAM buffer [mem 0x0009dc00-0x0009ffff]
[    0.253532] e820: reserve RAM buffer [mem 0xbb780000-0xbbffffff]
[    0.253632] NetLabel: Initializing
[    0.253633] NetLabel:  domain hash size = 128
[    0.253634] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.253645] NetLabel:  unlabeled traffic allowed by default
[    0.253709] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.253713] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.255744] Switched to clocksource hpet
[    0.260844] AppArmor: AppArmor Filesystem Enabled
[    0.260916] pnp: PnP ACPI init
[    0.260995] system 00:00: [mem 0xfc000000-0xfcffffff] has been reserved
[    0.260997] system 00:00: [mem 0xfd000000-0xfdffffff] has been reserved
[    0.260998] system 00:00: [mem 0xfe000000-0xfebfffff] has been reserved
[    0.261000] system 00:00: [mem 0xfed14000-0xfed19fff] has been reserved
[    0.261003] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.261071] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.261385] pnp 00:02: [dma 0 disabled]
[    0.261426] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.261551] system 00:03: [io  0x0a00-0x0a0f] has been reserved
[    0.261553] system 00:03: [io  0x0a10-0x0a1f] has been reserved
[    0.261555] system 00:03: [io  0x0a20-0x0a2f] has been reserved
[    0.261557] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.261675] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    0.261677] system 00:04: [io  0x0800-0x087f] could not be reserved
[    0.261679] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.261681] system 00:04: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.261682] system 00:04: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.261684] system 00:04: [mem 0xfed40000-0xfed8ffff] has been reserved
[    0.261686] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.261758] system 00:05: [mem 0xffc00000-0xffefffff] has been reserved
[    0.261761] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.261835] system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.261837] system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.261840] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.261883] system 00:07: [mem 0xe0000000-0xefffffff] has been reserved
[    0.261885] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.262040] system 00:08: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.262042] system 00:08: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.262043] system 00:08: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.262045] system 00:08: [mem 0x00100000-0xbbffffff] could not be reserved
[    0.262047] system 00:08: [mem 0xfed90000-0xffffffff] could not be reserved
[    0.262049] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.262144] pnp: PnP ACPI: found 9 devices
[    0.268243] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    0.268247] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000
[    0.268248] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 01] add_size 200000
[    0.268255] pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.268256] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.268258] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
[    0.268265] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[    0.268271] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[    0.268273] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[    0.268274] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff] to [bus 04] add_size 200000
[    0.268280] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 05] add_size 1000
[    0.268282] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 05] add_size 200000
[    0.268284] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff] to [bus 05] add_size 200000
[    0.268290] pci 0000:00:1c.5: bridge window [io  0x1000-0x0fff] to [bus 06] add_size 1000
[    0.268292] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 06] add_size 200000
[    0.268293] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff] to [bus 06] add_size 200000
[    0.268305] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.268307] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.268308] pci 0000:00:1c.1: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.268310] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.268311] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.268313] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.268314] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.268316] pci 0000:00:1c.4: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.268317] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.268319] pci 0000:00:1c.5: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.268320] pci 0000:00:1c.5: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.268322] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.268323] pci 0000:00:1c.1: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.268325] pci 0000:00:1c.3: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.268326] pci 0000:00:1c.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.268328] pci 0000:00:1c.5: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.268333] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
[    0.268337] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.268339] pci 0000:00:1c.1: BAR 14: assigned [mem 0xc0400000-0xc05fffff]
[    0.268342] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0600000-0xc07fffff 64bit pref]
[    0.268345] pci 0000:00:1c.2: BAR 15: assigned [mem 0xc0800000-0xc09fffff 64bit pref]
[    0.268347] pci 0000:00:1c.3: BAR 14: assigned [mem 0xc0a00000-0xc0bfffff]
[    0.268350] pci 0000:00:1c.3: BAR 15: assigned [mem 0xc0c00000-0xc0dfffff 64bit pref]
[    0.268352] pci 0000:00:1c.4: BAR 14: assigned [mem 0xc0e00000-0xc0ffffff]
[    0.268355] pci 0000:00:1c.4: BAR 15: assigned [mem 0xc1000000-0xc11fffff 64bit pref]
[    0.268357] pci 0000:00:1c.5: BAR 14: assigned [mem 0xc1200000-0xc13fffff]
[    0.268360] pci 0000:00:1c.5: BAR 15: assigned [mem 0xc1400000-0xc15fffff 64bit pref]
[    0.268362] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.268364] pci 0000:00:1c.1: BAR 13: assigned [io  0x2000-0x2fff]
[    0.268366] pci 0000:00:1c.3: BAR 13: assigned [io  0x3000-0x3fff]
[    0.268367] pci 0000:00:1c.4: BAR 13: assigned [io  0x4000-0x4fff]
[    0.268369] pci 0000:00:1c.5: BAR 13: assigned [io  0x5000-0x5fff]
[    0.268372] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.268375] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.268378] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    0.268381] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.268385] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.268387] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.268391] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff]
[    0.268394] pci 0000:00:1c.1:   bridge window [mem 0xc0600000-0xc07fffff 64bit pref]
[    0.268398] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.268400] pci 0000:00:1c.2:   bridge window [io  0xe000-0xefff]
[    0.268403] pci 0000:00:1c.2:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.268406] pci 0000:00:1c.2:   bridge window [mem 0xc0800000-0xc09fffff 64bit pref]
[    0.268410] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.268412] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.268415] pci 0000:00:1c.3:   bridge window [mem 0xc0a00000-0xc0bfffff]
[    0.268418] pci 0000:00:1c.3:   bridge window [mem 0xc0c00000-0xc0dfffff 64bit pref]
[    0.268422] pci 0000:00:1c.4: PCI bridge to [bus 05]
[    0.268424] pci 0000:00:1c.4:   bridge window [io  0x4000-0x4fff]
[    0.268428] pci 0000:00:1c.4:   bridge window [mem 0xc0e00000-0xc0ffffff]
[    0.268430] pci 0000:00:1c.4:   bridge window [mem 0xc1000000-0xc11fffff 64bit pref]
[    0.268434] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    0.268436] pci 0000:00:1c.5:   bridge window [io  0x5000-0x5fff]
[    0.268439] pci 0000:00:1c.5:   bridge window [mem 0xc1200000-0xc13fffff]
[    0.268442] pci 0000:00:1c.5:   bridge window [mem 0xc1400000-0xc15fffff 64bit pref]
[    0.268447] pci 0000:00:1e.0: PCI bridge to [bus 07]
[    0.268455] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.268457] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.268458] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.268460] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.268461] pci_bus 0000:00: resource 8 [mem 0xbc000000-0xdfffffff]
[    0.268462] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[    0.268464] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    0.268465] pci_bus 0000:01: resource 1 [mem 0xc0000000-0xc01fffff]
[    0.268467] pci_bus 0000:01: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.268468] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.268470] pci_bus 0000:02: resource 1 [mem 0xc0400000-0xc05fffff]
[    0.268471] pci_bus 0000:02: resource 2 [mem 0xc0600000-0xc07fffff 64bit pref]
[    0.268473] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.268474] pci_bus 0000:03: resource 1 [mem 0xfbf00000-0xfbffffff]
[    0.268475] pci_bus 0000:03: resource 2 [mem 0xc0800000-0xc09fffff 64bit pref]
[    0.268477] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    0.268478] pci_bus 0000:04: resource 1 [mem 0xc0a00000-0xc0bfffff]
[    0.268480] pci_bus 0000:04: resource 2 [mem 0xc0c00000-0xc0dfffff 64bit pref]
[    0.268481] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.268483] pci_bus 0000:05: resource 1 [mem 0xc0e00000-0xc0ffffff]
[    0.268484] pci_bus 0000:05: resource 2 [mem 0xc1000000-0xc11fffff 64bit pref]
[    0.268485] pci_bus 0000:06: resource 0 [io  0x5000-0x5fff]
[    0.268487] pci_bus 0000:06: resource 1 [mem 0xc1200000-0xc13fffff]
[    0.268488] pci_bus 0000:06: resource 2 [mem 0xc1400000-0xc15fffff 64bit pref]
[    0.268490] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.268491] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.268493] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.268494] pci_bus 0000:07: resource 7 [mem 0x000d0000-0x000dffff]
[    0.268495] pci_bus 0000:07: resource 8 [mem 0xbc000000-0xdfffffff]
[    0.268497] pci_bus 0000:07: resource 9 [mem 0xf0000000-0xfed8ffff]
[    0.268499] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    0.268500] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xfffffffff]
[    0.268524] NET: Registered protocol family 2
[    0.268699] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.268771] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.268864] TCP: Hash tables configured (established 32768 bind 32768)
[    0.268889] TCP: reno registered
[    0.268896] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.268912] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.268958] NET: Registered protocol family 1
[    0.268971] pci 0000:00:02.0: Video device with shadowed ROM
[    0.319835] PCI: CLS 32 bytes, default 64
[    0.319887] Trying to unpack rootfs image as initramfs...
[    0.601455] Freeing initrd memory: 20812K (ffff88003574a000 - ffff880036b9d000)
[    0.601485] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.601487] software IO TLB [mem 0xb7780000-0xbb780000] (64MB) mapped at [ffff8800b7780000-ffff8800bb77ffff]
[    0.601734] microcode: CPU0 sig=0x20655, pf=0x2, revision=0x2
[    0.601741] microcode: CPU1 sig=0x20655, pf=0x2, revision=0x2
[    0.601745] microcode: CPU2 sig=0x20655, pf=0x2, revision=0x2
[    0.601749] microcode: CPU3 sig=0x20655, pf=0x2, revision=0x2
[    0.601813] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.601835] Scanning for low memory corruption every 60 seconds
[    0.602166] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.602197] Initialise system trusted keyring
[    0.602220] audit: initializing netlink subsys (disabled)
[    0.602240] audit: type=2000 audit(1431149752.492:1): initialized
[    0.602545] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.603772] zpool: loaded
[    0.603774] zbud: loaded
[    0.603916] VFS: Disk quotas dquot_6.5.2
[    0.603947] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.604340] fuse init (API version 7.23)
[    0.604458] Key type big_key registered
[    0.604822] Key type asymmetric registered
[    0.604826] Asymmetric key parser 'x509' registered
[    0.604859] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.604895] io scheduler noop registered
[    0.604898] io scheduler deadline registered (default)
[    0.604924] io scheduler cfq registered
[    0.604989] pcieport 0000:00:1c.0: enabling device (0104 -> 0107)
[    0.605134] pcieport 0000:00:1c.1: enabling device (0104 -> 0107)
[    0.605301] pcieport 0000:00:1c.3: enabling device (0104 -> 0107)
[    0.605385] pcieport 0000:00:1c.4: enabling device (0104 -> 0107)
[    0.605464] pcieport 0000:00:1c.5: enabling device (0104 -> 0107)
[    0.605556] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.605569] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.605594] vesafb: mode is 640x480x32, linelength=2560, pages=0
[    0.605595] vesafb: scrolling: redraw
[    0.605597] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.605610] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90010780000, using 1216k, total 1216k
[    0.605678] Console: switching to colour frame buffer device 80x30
[    0.605688] fb0: VESA VGA frame buffer device
[    0.605700] intel_idle: MWAIT substates: 0x1120
[    0.605701] intel_idle: v0.4 model 0x25
[    0.605702] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.605886] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.605890] ACPI: Power Button [PWRB]
[    0.605921] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.605923] ACPI: Power Button [PWRF]
[    0.606344] GHES: HEST is not enabled!
[    0.606425] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.626776] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.628129] Linux agpgart interface v0.103
[    0.628178] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    0.628192] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.628755] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    0.628896] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.630030] brd: module loaded
[    0.630581] loop: module loaded
[    0.630770] libphy: Fixed MDIO Bus: probed
[    0.630774] tun: Universal TUN/TAP device driver, 1.6
[    0.630774] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.630814] PPP generic driver version 2.4.2
[    0.630878] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.630882] ehci-pci: EHCI PCI platform driver
[    0.631013] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.631019] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.631030] ehci-pci 0000:00:1a.0: debug port 2
[    0.634972] ehci-pci 0000:00:1a.0: cache line size of 32 is not supported
[    0.634988] ehci-pci 0000:00:1a.0: irq 16, io mem 0xfbef8000
[    0.643466] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.643540] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.643542] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.643543] usb usb1: Product: EHCI Host Controller
[    0.643545] usb usb1: Manufacturer: Linux 3.19.0-16-generic ehci_hcd
[    0.643546] usb usb1: SerialNumber: 0000:00:1a.0
[    0.643648] hub 1-0:1.0: USB hub found
[    0.643654] hub 1-0:1.0: 2 ports detected
[    0.643826] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.643831] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.643841] ehci-pci 0000:00:1d.0: debug port 2
[    0.647781] ehci-pci 0000:00:1d.0: cache line size of 32 is not supported
[    0.647795] ehci-pci 0000:00:1d.0: irq 23, io mem 0xfbef2000
[    0.659450] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.659477] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.659479] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.659480] usb usb2: Product: EHCI Host Controller
[    0.659482] usb usb2: Manufacturer: Linux 3.19.0-16-generic ehci_hcd
[    0.659483] usb usb2: SerialNumber: 0000:00:1d.0
[    0.659578] hub 2-0:1.0: USB hub found
[    0.659584] hub 2-0:1.0: 2 ports detected
[    0.659674] ehci-platform: EHCI generic platform driver
[    0.659682] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.659686] ohci-pci: OHCI PCI platform driver
[    0.659694] ohci-platform: OHCI generic platform driver
[    0.659699] uhci_hcd: USB Universal Host Controller Interface driver
[    0.659739] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.660175] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.660179] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.660286] mousedev: PS/2 mouse device common for all mice
[    0.660415] rtc_cmos 00:01: RTC can wake from S4
[    0.660526] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    0.660550] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.660565] i2c /dev entries driver
[    0.660621] device-mapper: uevent: version 1.0.3
[    0.660681] device-mapper: ioctl: 4.29.0-ioctl (2014-10-28) initialised: dm-devel@redhat.com
[    0.660696] ledtrig-cpu: registered to indicate activity on CPUs
[    0.660899] PCCT header not found.
[    0.660901] ACPI PCC probe failed.
[    0.660992] TCP: cubic registered
[    0.661082] NET: Registered protocol family 10
[    0.661291] NET: Registered protocol family 17
[    0.661302] Key type dns_resolver registered
[    0.661586] Loading compiled-in X.509 certificates
[    0.662445] Loaded X.509 cert 'Magrathea: Glacier signing key: cbfb67d2a378d185c4a06f9f73605e849d86185d'
[    0.662465] registered taskstats version 1
[    0.664382] Key type trusted registered
[    0.667349] Key type encrypted registered
[    0.667355] AppArmor: AppArmor sha1 policy hashing enabled
[    0.667358] ima: No TPM chip found, activating TPM-bypass!
[    0.667380] evm: HMAC attrs: 0x1
[    0.667711]   Magic number: 15:226:567
[    0.667716] misc network_latency: hash matches
[    0.667820] rtc_cmos 00:01: setting system clock to 2015-05-09 05:35:52 UTC (1431149752)
[    0.668538] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.668539] EDD information not available.
[    0.668582] PM: Hibernation image not present or could not be loaded.
[    0.668924] Freeing unused kernel memory: 1408K (ffffffff81d36000 - ffffffff81e96000)
[    0.668926] Write protecting the kernel read-only data: 12288k
[    0.669232] Freeing unused kernel memory: 188K (ffff8800017d1000 - ffff880001800000)
[    0.669447] Freeing unused kernel memory: 344K (ffff880001baa000 - ffff880001c00000)
[    0.679465] random: systemd-udevd urandom read with 4 bits of entropy available
[    0.699530] ahci 0000:00:1f.2: version 3.0
[    0.699814] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    0.715443] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.715449] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
[    0.723767] atl1c 0000:03:00.0: version 1.0.1.1-NAPI
[    0.727230] atl1c 0000:03:00.0 p130p1: renamed from eth0
[    0.760307] scsi host0: ahci
[    0.760473] scsi host1: ahci
[    0.760586] scsi host2: ahci
[    0.760676] scsi host3: ahci
[    0.760758] scsi host4: ahci
[    0.760846] scsi host5: ahci
[    0.760886] ata1: SATA max UDMA/133 abar m2048@0xfbef0000 port 0xfbef0100 irq 24
[    0.760888] ata2: SATA max UDMA/133 abar m2048@0xfbef0000 port 0xfbef0180 irq 24
[    0.760890] ata3: SATA max UDMA/133 abar m2048@0xfbef0000 port 0xfbef0200 irq 24
[    0.760892] ata4: SATA max UDMA/133 abar m2048@0xfbef0000 port 0xfbef0280 irq 24
[    0.760893] ata5: SATA max UDMA/133 abar m2048@0xfbef0000 port 0xfbef0300 irq 24
[    0.760895] ata6: SATA max UDMA/133 abar m2048@0xfbef0000 port 0xfbef0380 irq 24
[    0.955312] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    0.971301] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.079228] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.080775] ata1.00: ATA-8: Hitachi HDS721010CLA330, JP4OA3MA, max UDMA/133
[    1.080780] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.082503] ata1.00: configured for UDMA/133
[    1.082717] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72101 A3MA PQ: 0 ANSI: 5
[    1.082936] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    1.082975] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.083003] sd 0:0:0:0: [sda] Write Protect is off
[    1.083007] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.083032] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.087424] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    1.087426] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.087575] hub 1-1:1.0: USB hub found
[    1.087684] hub 1-1:1.0: 6 ports detected
[    1.103762] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    1.103767] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.104144] hub 2-1:1.0: USB hub found
[    1.104355] hub 2-1:1.0: 8 ports detected
[    1.130354]  sda: sda1 sda2 < sda5 sda6 sda7 >
[    1.130903] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.398945] ata2: SATA link down (SStatus 0 SControl 300)
[    1.598812] tsc: Refined TSC clocksource calibration: 3072.764 MHz
[    1.718732] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.719896] ata3.00: ATA-8: Hitachi HDS721010CLA332, JP4OA3EA, max UDMA/133
[    1.719901] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.721210] ata3.00: configured for UDMA/133
[    1.721365] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDS72101 A3EA PQ: 0 ANSI: 5
[    1.721512] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    1.721530] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    1.721560] sd 2:0:0:0: [sdb] Write Protect is off
[    1.721563] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.721586] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.728173]  sdb: unknown partition table
[    1.728570] sd 2:0:0:0: [sdb] Attached SCSI disk
[    2.042488] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.043979] ata4.00: ATA-8: TOSHIBA DT01ACA300, MX6OABB0, max UDMA/133
[    2.043984] ata4.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.045614] ata4.00: configured for UDMA/133
[    2.045965] scsi 3:0:0:0: Direct-Access     ATA      TOSHIBA DT01ACA3 ABB0 PQ: 0 ANSI: 5
[    2.046532] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    2.046613] sd 3:0:0:0: [sdc] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.046622] sd 3:0:0:0: [sdc] 4096-byte physical blocks
[    2.046856] sd 3:0:0:0: [sdc] Write Protect is off
[    2.046862] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.047030] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.067276]  sdc: unknown partition table
[    2.067536] sd 3:0:0:0: [sdc] Attached SCSI disk
[    2.366245] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.366966] ata5.00: ATA-9: WDC WD30EZRX-22D8PB0, 80.00A80, max UDMA/133
[    2.366971] ata5.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.367799] ata5.00: configured for UDMA/133
[    2.368150] scsi 4:0:0:0: Direct-Access     ATA      WDC WD30EZRX-22D 0A80 PQ: 0 ANSI: 5
[    2.368678] sd 4:0:0:0: [sdd] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.368679] sd 4:0:0:0: Attached scsi generic sg3 type 0
[    2.368682] sd 4:0:0:0: [sdd] 4096-byte physical blocks
[    2.368766] sd 4:0:0:0: [sdd] Write Protect is off
[    2.368772] sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.368833] sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.401122]  sdd: unknown partition table
[    2.401513] sd 4:0:0:0: [sdd] Attached SCSI disk
[    2.598290] Switched to clocksource tsc
[    2.686001] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.686743] ata6.00: ATA-9: WDC WD30EZRX-19D8PB0, 81.00A81, max UDMA/133
[    2.686748] ata6.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.687572] ata6.00: configured for UDMA/133
[    2.687767] scsi 5:0:0:0: Direct-Access     ATA      WDC WD30EZRX-19D 0A81 PQ: 0 ANSI: 5
[    2.688094] sd 5:0:0:0: [sde] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.688097] sd 5:0:0:0: [sde] 4096-byte physical blocks
[    2.688121] sd 5:0:0:0: Attached scsi generic sg4 type 0
[    2.688139] sd 5:0:0:0: [sde] Write Protect is off
[    2.688141] sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    2.688223] sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.713854]  sde: unknown partition table
[    2.714040] sd 5:0:0:0: [sde] Attached SCSI disk
[    2.868876] random: nonblocking pool is initialized
[    3.061642] raid6: sse2x1    7376 MB/s
[    3.129588] raid6: sse2x2    8617 MB/s
[    3.197534] raid6: sse2x4    9644 MB/s
[    3.197535] raid6: using algorithm sse2x4 (9644 MB/s)
[    3.197536] raid6: using ssse3x2 recovery algorithm
[    3.198718] xor: measuring software checksum speed
[    3.237502]    prefetch64-sse: 12779.000 MB/sec
[    3.277472]    generic_sse: 11281.000 MB/sec
[    3.277473] xor: using function: prefetch64-sse (12779.000 MB/sec)
[    3.289533] Btrfs loaded
[    3.632823] BTRFS: device fsid 684a6bda-4fb5-420d-a2d1-019e38fdc1ee devid 3 transid 151928 /dev/sdb
[    3.633105] BTRFS: device fsid 684a6bda-4fb5-420d-a2d1-019e38fdc1ee devid 4 transid 151928 /dev/sdc
[    3.633425] BTRFS: device fsid 684a6bda-4fb5-420d-a2d1-019e38fdc1ee devid 1 transid 151928 /dev/sdd
[    3.633802] BTRFS: device fsid 684a6bda-4fb5-420d-a2d1-019e38fdc1ee devid 2 transid 151928 /dev/sde
[    3.679880] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    4.515677] systemd[1]: Inserted module 'autofs4'
[    4.615573] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT -GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID -ELFUTILS +KMOD -IDN)
[    4.615699] systemd[1]: Detected architecture x86-64.
[    4.626906] systemd[1]: Set hostname to <server>.
[    5.797312] systemd[1]: Created slice Root Slice.
[    5.797323] systemd[1]: Starting Root Slice.
[    5.797333] systemd[1]: Reached target Remote File Systems (Pre).
[    5.797339] systemd[1]: Starting Remote File Systems (Pre).
[    5.797365] systemd[1]: Listening on udev Kernel Socket.
[    5.797372] systemd[1]: Starting udev Kernel Socket.
[    5.797448] systemd[1]: Created slice User and Session Slice.
[    5.797455] systemd[1]: Starting User and Session Slice.
[    5.797491] systemd[1]: Listening on Journal Socket.
[    5.797502] systemd[1]: Starting Journal Socket.
[    5.797526] systemd[1]: Listening on Journal Audit Socket.
[    5.797532] systemd[1]: Starting Journal Audit Socket.
[    5.797600] systemd[1]: Created slice System Slice.
[    5.797613] systemd[1]: Starting System Slice.
[    5.798026] systemd[1]: Starting Setup Virtual Console...
[    5.798461] systemd[1]: Started Read required files in advance.
[    5.798600] systemd[1]: Starting Read required files in advance...
[    5.799067] systemd[1]: Starting Uncomplicated firewall...
[    5.799118] systemd[1]: Listening on udev Control Socket.
[    5.799131] systemd[1]: Starting udev Control Socket.
[    5.799551] systemd[1]: Starting udev Coldplug all Devices...
[    5.799623] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    5.799637] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    5.800105] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    5.800150] systemd[1]: Listening on Journal Socket (/dev/log).
[    5.800171] systemd[1]: Starting Journal Socket (/dev/log).
[    5.800256] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[    5.800264] systemd[1]: Starting system-systemd\x2dfsck.slice.
[    5.800707] systemd[1]: Mounting Huge Pages File System...
[    5.800744] systemd[1]: Listening on fsck to fsckd communication Socket.
[    5.800759] systemd[1]: Starting fsck to fsckd communication Socket.
[    5.801206] systemd[1]: Mounting POSIX Message Queue File System...
[    5.801336] systemd[1]: Created slice system-getty.slice.
[    5.801352] systemd[1]: Starting system-getty.slice.
[    5.801949] systemd[1]: Starting Increase datagram queue length...
[    5.801996] systemd[1]: Listening on Delayed Shutdown Socket.
[    5.802008] systemd[1]: Starting Delayed Shutdown Socket.
[    5.802450] systemd[1]: Starting Nameserver information manager...
[    5.802534] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    5.802545] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    5.803001] systemd[1]: Started Braille Device Support.
[    5.803070] systemd[1]: Starting Braille Device Support...
[    5.803093] systemd[1]: Reached target Encrypted Volumes.
[    5.803101] systemd[1]: Starting Encrypted Volumes.
[    5.803547] systemd[1]: Mounting Debug File System...
[    5.803570] systemd[1]: Reached target Slices.
[    5.803596] systemd[1]: Starting Slices.
[    6.110648] systemd[1]: Starting Load Kernel Modules...
[    6.110863] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    6.110880] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    6.144787] systemd[1]: Started Set Up Additional Binary Formats.
[    6.145460] systemd[1]: Mounted POSIX Message Queue File System.
[    6.145487] systemd[1]: Mounted Huge Pages File System.
[    6.145503] systemd[1]: Mounted Debug File System.
[    6.145678] systemd[1]: Started Setup Virtual Console.
[    6.145865] systemd[1]: Started Uncomplicated firewall.
[    6.146349] systemd[1]: Started Create list of required static device nodes for the current kernel.
[    6.146667] systemd[1]: Started Increase datagram queue length.
[    6.216874] systemd[1]: Started udev Coldplug all Devices.
[    6.229189] systemd[1]: Starting udev Wait for Complete Device Initialization...
[    6.229246] systemd[1]: Listening on Syslog Socket.
[    6.229262] systemd[1]: Starting Syslog Socket.
[    6.229692] systemd[1]: Starting Journal Service...
[    6.230167] systemd[1]: Starting Create Static Device Nodes in /dev...
[    6.245252] systemd[1]: Started Nameserver information manager.
[    6.594579] lp: driver loaded but no devices found
[    6.653705] ppdev: user-space parallel port driver
[    6.960583] systemd[1]: Started Journal Service.
[    7.020518] it87: Found IT8720F chip at 0xa10, revision 8
[    7.020562] ACPI Warning: SystemIO range 0x0000000000000a15-0x0000000000000a16 conflicts with OpRegion 0x0000000000000a10-0x0000000000000b0f (\ECIO) (20141107/utaddress-258)
[    7.020566] ACPI: This conflict may cause random problems and system instability
[    7.020567] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    9.888991] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    9.927885] ACPI Warning: SystemIO range 0x0000000000000828-0x000000000000082f conflicts with OpRegion 0x0000000000000800-0x000000000000084f (\PMRG) (20141107/utaddress-258)
[    9.927894] ACPI: This conflict may cause random problems and system instability
[    9.927895] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    9.933952] wmi: Mapper loaded
[    9.989378] [drm] Initialized drm 1.1.0 20060810
[   10.127231] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[   10.283769] gpio_ich: GPIO from 436 to 511 on gpio_ich
[   10.291979] [drm] Memory usable by graphics device = 2048M
[   10.291983] checking generic (d0000000 130000) vs hw (d0000000 10000000)
[   10.291985] fb: switching to inteldrmfb from VESA VGA
[   10.292017] Console: switching to colour dummy device 80x25
[   10.292069] [drm] Replacing VGA console driver
[   10.299000] sound hdaudioC0D0: autoconfig: line_outs=1 (0x1c/0x0/0x0/0x0/0x0) type:line
[   10.299004] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   10.299006] sound hdaudioC0D0:    hp_outs=1 (0x1d/0x0/0x0/0x0/0x0)
[   10.299007] sound hdaudioC0D0:    mono: mono_out=0x0
[   10.299008] sound hdaudioC0D0:    dig-out=0x20/0x0
[   10.299009] sound hdaudioC0D0:    inputs:
[   10.299011] sound hdaudioC0D0:      Rear Mic=0x1a
[   10.299013] sound hdaudioC0D0:      Front Mic=0x1e
[   10.299015] sound hdaudioC0D0:      Line=0x1b
[   10.316302] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   10.316307] [drm] Driver supports precise vblank timestamp query.
[   10.316400] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   10.319147] [drm] Initialized i915 1.6.0 20141121 for 0000:00:02.0 on minor 0
[   10.336921] i915 0000:00:02.0: No connectors reported connected with modes
[   10.336932] [drm] Cannot find any crtc or sizes - going 1024x768
[   10.337718] fbcon: inteldrmfb (fb0) is primary device
[   10.337770] Console: switching to colour frame buffer device 128x48
[   10.337792] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   10.337793] i915 0000:00:02.0: registered panic notifier
[   10.396452] input: HDA Intel MID Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[   10.396538] input: HDA Intel MID Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[   10.396620] input: HDA Intel MID Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   10.396696] input: HDA Intel MID Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   10.396774] input: HDA Intel MID Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   10.396854] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   11.100455] Adding 4100092k swap on /dev/sda6.  Priority:-1 extents:1 across:4100092k FS
[   12.007023] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   12.129444] systemd-journald[246]: Received request to flush runtime journal from PID 1
[   12.138010] BTRFS info (device sde): disk space caching is enabled
[   12.235876] BTRFS: bdev /dev/sdc errs: wr 14255, rd 0, flush 4205, corrupt 0, gen 0
[   12.671693] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[   13.080487] EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
[   33.874890] audit: type=1400 audit(1431149785.727:2): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/lightdm/lightdm-guest-session" pid=567 comm="apparmor_parser"
[   33.874898] audit: type=1400 audit(1431149785.727:3): apparmor="STATUS" operation="profile_load" profile="unconfined" name="chromium" pid=567 comm="apparmor_parser"
[   33.895631] audit: type=1400 audit(1431149785.747:4): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/sbin/dhclient" pid=567 comm="apparmor_parser"
[   33.895637] audit: type=1400 audit(1431149785.747:5): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=567 comm="apparmor_parser"
[   33.895641] audit: type=1400 audit(1431149785.747:6): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=567 comm="apparmor_parser"
[   33.895645] audit: type=1400 audit(1431149785.747:7): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/connman/scripts/dhclient-script" pid=567 comm="apparmor_parser"
[   33.962203] audit: type=1400 audit(1431149785.811:8): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/evince" pid=567 comm="apparmor_parser"
[   33.962212] audit: type=1400 audit(1431149785.811:9): apparmor="STATUS" operation="profile_load" profile="unconfined" name="sanitized_helper" pid=567 comm="apparmor_parser"
[   33.962216] audit: type=1400 audit(1431149785.811:10): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/evince-previewer" pid=567 comm="apparmor_parser"
[   33.962220] audit: type=1400 audit(1431149785.811:11): apparmor="STATUS" operation="profile_load" profile="unconfined" name="sanitized_helper" pid=567 comm="apparmor_parser"
[   34.211598] atl1c 0000:03:00.0: atl1c: p130p1 NIC Link is Up<1000 Mbps Full Duplex>
[   38.360301] cfg80211: Calling CRDA to update world regulatory domain
[   38.521519] cfg80211: World regulatory domain updated:
[   38.521523] cfg80211:  DFS Master region: unset
[   38.521524] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[   38.521527] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[   38.521528] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[   38.521530] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
[   38.521531] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[   38.521533] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[   42.589875] vboxdrv: module verification failed: signature and/or  required key missing - tainting kernel
[   42.593167] vboxdrv: Found 4 processor cores.
[   42.593352] vboxdrv: fAsync=0 offMin=0x20c offMax=0x11b0
[   42.593713] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   42.593715] vboxdrv: Successfully loaded version 4.3.26_Ubuntu (interface 0x001a000a).
[   43.138467] vboxpci: IOMMU not found (not registered)
[   47.869225] ip_tables: (C) 2000-2006 Netfilter Core Team
[   47.894162] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   48.100855] Ebtables v2.0 registered
[   48.479598] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[   48.555754] device virbr0-nic entered promiscuous mode
[   48.728611] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   48.876343] virbr0: port 1(virbr0-nic) entered listening state
[   48.876354] virbr0: port 1(virbr0-nic) entered listening state
[   48.926322] virbr0: port 1(virbr0-nic) entered disabled state
[   78.717743]  sdb: unknown partition table
[   78.735588]  sdc: unknown partition table
[   78.736279]  sdd: unknown partition table
[   78.781962]  sde: unknown partition table

------=_Part_614025_2063127118.1431151384347--
