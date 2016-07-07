Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:46785 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbcGGMqr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 08:46:47 -0400
From: Kai Herlemann <nesadaw@freenet.de>
Subject: rollback to a snapshot and delete old top volume - missing of "@"
To: linux-btrfs@vger.kernel.org
Message-ID: <96f8022e-4209-2498-62e4-50ccbee46e37@freenet.de>
Date: Thu, 7 Jul 2016 14:17:08 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------CA72DCBEBE7173AA1BD602D0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------CA72DCBEBE7173AA1BD602D0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I want to rollback a snapshot and have done this by execute "btrfs sub 
set-default / 618".
Now I want to delete the old top volume to save space, but google and 
manuals didn't helped.

I mounted for the following the root volume at /mnt/gparted with 
subvolid=0, subvol=/ has the same effect.
Usually, the top volume is saved in /@, so I would be able to delete it 
by execute "btrfs sub delete /@" (or move at first @ to @_badroot and 
the snapshot to @). But that isn't possible, the output of that command 
is "ERROR: cannot access subvolume /@: No such file or directory".
I've posted the output of "btrfs sub list /mnt/gparted" at 
http://pastebin.com/r7WNbJq8. As you can see, there's no subvolume named @.

I have the same problem with my /home/ partition.

Output of "uname -a" (self-compiled kernel):
Linux debian-linux 4.1.26 #1 SMP Wed Jun 8 18:40:04 CEST 2016 x86_64 
GNU/Linux

Output of "btrfs --version":
btrfs-progs v4.5.2

Output of "btrfs fi show":
Label: none  uuid: f778877c-d50b-48c8-8951-6635c6e23c61
           Total devices 1 FS bytes used 43.70GiB
           devid    1 size 55.62GiB used 47.03GiB path /dev/sda1

Output of "btrfs fi df /":
Data, single: total=44.00GiB, used=42.48GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=3.00GiB, used=1.22GiB
GlobalReserve, single: total=416.00MiB, used=0.00B

Output of dmesg attached.

Thank you,
Kai


--------------CA72DCBEBE7173AA1BD602D0
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] microcode: CPU0 microcode updated early to revision 0xe, date = 2013-06-26
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.1.26 (root@debian-linux) (gcc version 5.3.1 20160528 (Debian 5.3.1-21) ) #1 SMP Wed Jun 8 18:40:04 CEST 2016
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.1.26 root=UUID=f778877c-d50b-48c8-8951-6635c6e23c61 ro resume=UUID=9be0bf62-859d-42cb-b075-4bd31f41c53d init=/lib/systemd/systemd
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009f680fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009f681000-0x000000009f6befff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009f6bf000-0x000000009f735fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009f736000-0x000000009f7befff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009f7bf000-0x000000009f7defff] usable
[    0.000000] BIOS-e820: [mem 0x000000009f7df000-0x000000009f7fefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000009f7ff000-0x000000009f7fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000009f800000-0x000000009fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feb00000-0x00000000feb03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1b000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe80000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000157ffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: eMachines        eME730G         /eME730G         , BIOS V1.23 04/25/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x158000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   2 base 080000000 mask FE0000000 write-back
[    0.000000]   3 base 09F800000 mask FFF800000 uncachable
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 140000000 mask FF0000000 write-back
[    0.000000]   6 base 150000000 mask FF8000000 write-back
[    0.000000]   7 disabled
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC  
[    0.000000] e820: last_pfn = 0x9f800 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01b12000, 0x01b12fff] PGTABLE
[    0.000000] BRK [0x01b13000, 0x01b13fff] PGTABLE
[    0.000000] BRK [0x01b14000, 0x01b14fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x157e00000-0x157ffffff]
[    0.000000]  [mem 0x157e00000-0x157ffffff] page 2M
[    0.000000] BRK [0x01b15000, 0x01b15fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x140000000-0x157dfffff]
[    0.000000]  [mem 0x140000000-0x157dfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x120000000-0x13fffffff]
[    0.000000]  [mem 0x120000000-0x13fffffff] page 2M
[    0.000000] BRK [0x01b16000, 0x01b16fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x9f680fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x9f5fffff] page 2M
[    0.000000]  [mem 0x9f600000-0x9f680fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9f6bf000-0x9f735fff]
[    0.000000]  [mem 0x9f6bf000-0x9f735fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9f7bf000-0x9f7defff]
[    0.000000]  [mem 0x9f7bf000-0x9f7defff] page 4k
[    0.000000] init_memory_mapping: [mem 0x9f7ff000-0x9f7fffff]
[    0.000000]  [mem 0x9f7ff000-0x9f7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11fffffff]
[    0.000000]  [mem 0x100000000-0x11fffffff] page 2M
[    0.000000] RAMDISK: [mem 0x35e3a000-0x36f14fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FE020 000024 (v02 ACRSYS)
[    0.000000] ACPI: XSDT 0x000000009F7FE120 00007C (v01 ACRSYS ACRPRDCT 00000001      01000013)
[    0.000000] ACPI: FACP 0x000000009F7FC000 0000F4 (v04 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: DSDT 0x000000009F7EA000 00E975 (v02 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: FACS 0x000000009F75A000 000040
[    0.000000] ACPI: FACS 0x000000009F75A000 000040
[    0.000000] ACPI: ASF! 0x000000009F7FD000 0000A5 (v32 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: HPET 0x000000009F7FB000 000038 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: APIC 0x000000009F7FA000 00008C (v02 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: MCFG 0x000000009F7F9000 00003C (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: SLIC 0x000000009F7E9000 000176 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: BOOT 0x000000009F7E6000 000028 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: ASPT 0x000000009F7E2000 000034 (v04 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: SSDT 0x000000009F7E1000 0009F1 (v01 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x000000009F7E0000 000259 (v01 PmRef  Cpu0Tst  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x000000009F7DF000 00049F (v01 PmRef  ApTst    00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000157ffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x157ff9000-0x157ffcfff]
[    0.000000]  [ffffea0000000000-ffffea00055fffff] PMD -> [ffff880153800000-ffff8801575fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x0000000157ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000009f680fff]
[    0.000000]   node   0: [mem 0x000000009f6bf000-0x000000009f735fff]
[    0.000000]   node   0: [mem 0x000000009f7bf000-0x000000009f7defff]
[    0.000000]   node   0: [mem 0x000000009f7ff000-0x000000009f7fffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x0000000157ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x0000000157ffffff]
[    0.000000] On node 0 totalpages: 1013429
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10141 pages used for memmap
[    0.000000]   DMA32 zone: 648985 pages, LIFO batch:31
[    0.000000]   Normal zone: 5632 pages used for memmap
[    0.000000]   Normal zone: 360448 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x9f681000-0x9f6befff]
[    0.000000] PM: Registered nosave memory: [mem 0x9f736000-0x9f7befff]
[    0.000000] PM: Registered nosave memory: [mem 0x9f7df000-0x9f7fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x9f800000-0x9fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xa0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfeafffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeb00000-0xfeb03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeb04000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed13fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed14000-0xfed17fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed18000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1afff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1b000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffe7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffe80000-0xffffffff]
[    0.000000] e820: [mem 0xa0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 33 pages/cpu @ffff880157c00000 s95512 r8192 d31464 u262144
[    0.000000] pcpu-alloc: s95512 r8192 d31464 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 997571
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.1.26 root=UUID=f778877c-d50b-48c8-8951-6635c6e23c61 ro resume=UUID=9be0bf62-859d-42cb-b075-4bd31f41c53d init=/lib/systemd/systemd
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3894136K/4053716K available (5649K kernel code, 1016K rwdata, 1856K rodata, 1260K init, 828K bss, 159580K reserved, 0K cma-reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:33024 nr_irqs:488 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2261.228 MHz processor
[    0.000037] Calibrating delay loop (skipped), value calculated using timer frequency.. 4522.45 BogoMIPS (lpj=9044912)
[    0.000199] pid_max: default: 32768 minimum: 301
[    0.000284] ACPI: Core revision 20150410
[    0.017794] ACPI: All ACPI Tables successfully acquired
[    0.018027] Security Framework initialized
[    0.018116] AppArmor: AppArmor disabled by boot time parameter
[    0.018198] Yama: becoming mindful.
[    0.018599] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.019700] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.020213] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.020306] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.020641] Initializing cgroup subsys blkio
[    0.020726] Initializing cgroup subsys memory
[    0.020816] Initializing cgroup subsys devices
[    0.020894] Initializing cgroup subsys freezer
[    0.020975] Initializing cgroup subsys net_cls
[    0.021057] Initializing cgroup subsys perf_event
[    0.021138] Initializing cgroup subsys net_prio
[    0.021242] CPU: Physical Processor ID: 0
[    0.021320] CPU: Processor Core ID: 0
[    0.021399] mce: CPU supports 9 MCE banks
[    0.021487] CPU0: Thermal monitoring enabled (TM1)
[    0.021573] process: using mwait in idle threads
[    0.021652] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.021734] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.022167] Freeing SMP alternatives memory: 24K (ffffffff81a3b000 - ffffffff81a41000)
[    0.187331] ftrace: allocating 22633 entries in 89 pages
[    0.200306] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.347335] smpboot: CPU0: Intel(R) Core(TM) i3 CPU       M 350  @ 2.27GHz (fam: 06, model: 25, stepping: 02)
[    0.347640] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.347985] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.348071] ... version:                3
[    0.348147] ... bit width:              48
[    0.348224] ... generic registers:      4
[    0.348302] ... value mask:             0000ffffffffffff
[    0.348382] ... max period:             000000007fffffff
[    0.348462] ... fixed-purpose events:   3
[    0.348539] ... event mask:             000000070000000f
[    0.349293] x86: Booting SMP configuration:
[    0.349373] .... node  #0, CPUs:      #1
[    0.362725] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.363020]  #2
[    0.374422] microcode: CPU2 microcode updated early to revision 0xe, date = 2013-06-26
[    0.376667]  #3
[    0.391764] x86: Booted up 1 node, 4 CPUs
[    0.391850] smpboot: Total of 4 processors activated (18089.82 BogoMIPS)
[    0.394407] devtmpfs: initialized
[    0.397316] PM: Registering ACPI NVS region [mem 0x9f736000-0x9f7befff] (561152 bytes)
[    0.397517] clocksource jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.397726] pinctrl core: initialized pinctrl subsystem
[    0.397959] NET: Registered protocol family 16
[    0.407371] cpuidle: using governor ladder
[    0.416557] cpuidle: using governor menu
[    0.416703] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.416800] ACPI: bus type PCI registered
[    0.416877] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.417055] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.417159] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.417824] PCI: Using configuration type 1 for base access
[    0.418111] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.418193] mtrr: probably your BIOS does not setup all CPUs.
[    0.418274] mtrr: corrected configuration.
[    0.427867] ACPI: Added _OSI(Module Device)
[    0.427948] ACPI: Added _OSI(Processor Device)
[    0.428027] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.428108] ACPI: Added _OSI(Processor Aggregator Device)
[    0.432283] ACPI: Executed 1 blocks of module-level executable AML code
[    0.437038] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.437628] ACPI: Dynamic OEM Table Load:
[    0.437827] ACPI: SSDT 0xFFFF8801529D5400 0003F0 (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.438733] ACPI: Dynamic OEM Table Load:
[    0.438930] ACPI: SSDT 0xFFFF88015349B000 000891 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.440193] ACPI: Dynamic OEM Table Load:
[    0.440390] ACPI: SSDT 0xFFFF880152B30C00 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.441306] ACPI: Dynamic OEM Table Load:
[    0.441501] ACPI: SSDT 0xFFFF8801529CD400 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.442896] ACPI : EC: EC started
[    0.447878] ACPI: Interpreter enabled
[    0.447967] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20150410/hwxface-580)
[    0.448187] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20150410/hwxface-580)
[    0.448421] ACPI: (supports S0 S3 S4 S5)
[    0.448499] ACPI: Using IOAPIC for interrupt routing
[    0.448618] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.860630] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.860720] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.860858] \_SB_.PCI0:_OSC invalid UUID
[    0.860859] _OSC request data:1 1f 0 
[    0.860863] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.861574] PCI host bridge to bus 0000:00
[    0.861657] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.861735] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.861820] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.861905] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.861997] pci_bus 0000:00: root bus resource [mem 0xa0000000-0xfebfffff window]
[    0.862101] pci 0000:00:00.0: [8086:0044] type 00 class 0x060000
[    0.862124] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
[    0.862353] pci 0000:00:01.0: [8086:0045] type 01 class 0x060400
[    0.862388] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.862558] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.862588] pci 0000:00:16.0: reg 0x10: [mem 0xb4106100-0xb410610f 64bit]
[    0.862678] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.862833] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.863218] pci 0000:00:1a.0: reg 0x10: [mem 0xb4105c00-0xb4105fff]
[    0.865439] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.865595] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.865620] pci 0000:00:1b.0: reg 0x10: [mem 0xb4100000-0xb4103fff 64bit]
[    0.865722] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.865826] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.865960] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.866054] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.866156] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.866285] pci 0000:00:1c.1: [8086:3b44] type 01 class 0x060400
[    0.866379] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.866536] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.866912] pci 0000:00:1d.0: reg 0x10: [mem 0xb4105800-0xb4105bff]
[    0.869131] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.869248] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.869380] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.869540] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.869668] pci 0000:00:1f.0: [8086:3b09] type 00 class 0x060100
[    0.869906] pci 0000:00:1f.2: [8086:3b29] type 00 class 0x010601
[    0.869930] pci 0000:00:1f.2: reg 0x10: [io  0x4048-0x404f]
[    0.869941] pci 0000:00:1f.2: reg 0x14: [io  0x4054-0x4057]
[    0.869951] pci 0000:00:1f.2: reg 0x18: [io  0x4040-0x4047]
[    0.869962] pci 0000:00:1f.2: reg 0x1c: [io  0x4050-0x4053]
[    0.869973] pci 0000:00:1f.2: reg 0x20: [io  0x4020-0x403f]
[    0.869985] pci 0000:00:1f.2: reg 0x24: [mem 0xb4105000-0xb41057ff]
[    0.870040] pci 0000:00:1f.2: PME# supported from D3hot
[    0.870177] pci 0000:00:1f.3: [8086:3b30] type 00 class 0x0c0500
[    0.870200] pci 0000:00:1f.3: reg 0x10: [mem 0xb4106000-0xb41060ff 64bit]
[    0.870230] pci 0000:00:1f.3: reg 0x20: [io  0x4000-0x401f]
[    0.870448] pci 0000:01:00.0: [1002:68e0] type 00 class 0x030000
[    0.870469] pci 0000:01:00.0: reg 0x10: [mem 0xa0000000-0xafffffff 64bit pref]
[    0.870483] pci 0000:01:00.0: reg 0x18: [mem 0xb4000000-0xb401ffff 64bit]
[    0.870492] pci 0000:01:00.0: reg 0x20: [io  0x3000-0x30ff]
[    0.870509] pci 0000:01:00.0: reg 0x30: [mem 0xfffe0000-0xffffffff pref]
[    0.870545] pci 0000:01:00.0: supports D1 D2
[    0.870646] pci 0000:01:00.1: [1002:aa68] type 00 class 0x040300
[    0.870666] pci 0000:01:00.1: reg 0x10: [mem 0xb4020000-0xb4023fff 64bit]
[    0.870734] pci 0000:01:00.1: supports D1 D2
[    0.870808] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.870892] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.870895] pci 0000:00:01.0:   bridge window [mem 0xb4000000-0xb40fffff]
[    0.870898] pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
[    0.871016] pci 0000:02:00.0: [14e4:1692] type 00 class 0x020000
[    0.871065] pci 0000:02:00.0: reg 0x10: [mem 0xb3000000-0xb300ffff 64bit]
[    0.871298] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.875603] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.875696] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.875701] pci 0000:00:1c.0:   bridge window [mem 0xb3000000-0xb3ffffff]
[    0.875708] pci 0000:00:1c.0:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
[    0.875828] pci 0000:03:00.0: [14e4:4357] type 00 class 0x028000
[    0.875876] pci 0000:03:00.0: reg 0x10: [mem 0xb2000000-0xb2003fff 64bit]
[    0.876117] pci 0000:03:00.0: supports D1 D2
[    0.876119] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.883605] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.883696] pci 0000:00:1c.1:   bridge window [io  0x1000-0x1fff]
[    0.883700] pci 0000:00:1c.1:   bridge window [mem 0xb2000000-0xb2ffffff]
[    0.883708] pci 0000:00:1c.1:   bridge window [mem 0xb1000000-0xb1ffffff 64bit pref]
[    0.883794] pci 0000:00:1e.0: PCI bridge to [bus 04] (subtractive decode)
[    0.883887] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7 window] (subtractive decode)
[    0.883889] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff window] (subtractive decode)
[    0.883891] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
[    0.883893] pci 0000:00:1e.0:   bridge window [mem 0xa0000000-0xfebfffff window] (subtractive decode)
[    1.088332] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    1.089157] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    1.089978] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    1.090931] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.091827] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    1.092778] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    1.093599] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    1.094424] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    1.095212] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
[    1.095298] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.095401] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.095543] PCI host bridge to bus 0000:ff
[    1.095627] pci_bus 0000:ff: root bus resource [bus ff]
[    1.095708] pci 0000:ff:00.0: [8086:2c62] type 00 class 0x060000
[    1.095764] pci 0000:ff:00.1: [8086:2d01] type 00 class 0x060000
[    1.095824] pci 0000:ff:02.0: [8086:2d10] type 00 class 0x060000
[    1.095877] pci 0000:ff:02.1: [8086:2d11] type 00 class 0x060000
[    1.095931] pci 0000:ff:02.2: [8086:2d12] type 00 class 0x060000
[    1.095982] pci 0000:ff:02.3: [8086:2d13] type 00 class 0x060000
[    1.096097] ACPI: Enabled 5 GPEs in block 00 to 3F
[    1.096344] ACPI : EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    1.096558] vgaarb: setting as boot device: PCI:0000:01:00.0
[    1.096641] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.096741] vgaarb: loaded
[    1.096814] vgaarb: bridge control possible 0000:01:00.0
[    1.097015] PCI: Using ACPI for IRQ routing
[    1.106986] PCI: pci_cache_line_size set to 64 bytes
[    1.107132] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
[    1.107133] e820: reserve RAM buffer [mem 0x9f681000-0x9fffffff]
[    1.107135] e820: reserve RAM buffer [mem 0x9f736000-0x9fffffff]
[    1.107137] e820: reserve RAM buffer [mem 0x9f7df000-0x9fffffff]
[    1.107138] e820: reserve RAM buffer [mem 0x9f800000-0x9fffffff]
[    1.107320] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.107923] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.110034] Switched to clocksource hpet
[    1.116875] pnp: PnP ACPI init
[    1.318277] pnp 00:00: disabling [io  0x164e-0x164f] because it overlaps 0000:00:1c.1 BAR 13 [io  0x1000-0x1fff]
[    1.318446] system 00:00: [io  0x0680-0x069f] has been reserved
[    1.318529] system 00:00: [io  0xff2c-0xff2f] has been reserved
[    1.318612] system 00:00: [io  0x0800-0x080f] has been reserved
[    1.318696] system 00:00: [io  0xffff] has been reserved
[    1.318776] system 00:00: [io  0xffff] has been reserved
[    1.318859] system 00:00: [io  0x0400-0x047f] could not be reserved
[    1.318942] system 00:00: [io  0x0500-0x057f] has been reserved
[    1.319029] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.319071] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.319123] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.319194] pnp 00:03: Plug and Play ACPI device, IDs SYN1b16 SYN1b00 SYN0002 PNP0f13 (active)
[    1.319514] pnp 00:04: disabling [mem 0xfffff000-0xffffffff] because it overlaps 0000:01:00.0 BAR 6 [mem 0xfffe0000-0xffffffff pref]
[    1.319652] system 00:04: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.319737] system 00:04: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.319822] system 00:04: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.319906] system 00:04: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.319990] system 00:04: [mem 0xe0000000-0xefffffff] has been reserved
[    1.320074] system 00:04: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.320157] system 00:04: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.320243] system 00:04: [mem 0xff000000-0xffffffff] could not be reserved
[    1.320328] system 00:04: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.320413] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.320536] pnp: PnP ACPI: found 5 devices
[    1.328052] clocksource acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    1.328160] pci 0000:01:00.0: can't claim BAR 6 [mem 0xfffe0000-0xffffffff pref]: no compatible bridge window
[    1.328303] pci 0000:01:00.0: BAR 6: assigned [mem 0xb4040000-0xb405ffff pref]
[    1.328401] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.328484] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    1.328570] pci 0000:00:01.0:   bridge window [mem 0xb4000000-0xb40fffff]
[    1.328654] pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xafffffff 64bit pref]
[    1.328756] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    1.328839] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    1.328923] pci 0000:00:1c.0:   bridge window [mem 0xb3000000-0xb3ffffff]
[    1.329010] pci 0000:00:1c.0:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
[    1.329115] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    1.329197] pci 0000:00:1c.1:   bridge window [io  0x1000-0x1fff]
[    1.329283] pci 0000:00:1c.1:   bridge window [mem 0xb2000000-0xb2ffffff]
[    1.329369] pci 0000:00:1c.1:   bridge window [mem 0xb1000000-0xb1ffffff 64bit pref]
[    1.329474] pci 0000:00:1e.0: PCI bridge to [bus 04]
[    1.329565] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    1.329567] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    1.329569] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    1.329571] pci_bus 0000:00: resource 7 [mem 0xa0000000-0xfebfffff window]
[    1.329573] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    1.329574] pci_bus 0000:01: resource 1 [mem 0xb4000000-0xb40fffff]
[    1.329576] pci_bus 0000:01: resource 2 [mem 0xa0000000-0xafffffff 64bit pref]
[    1.329578] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    1.329580] pci_bus 0000:02: resource 1 [mem 0xb3000000-0xb3ffffff]
[    1.329582] pci_bus 0000:02: resource 2 [mem 0xb0000000-0xb0ffffff 64bit pref]
[    1.329584] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    1.329586] pci_bus 0000:03: resource 1 [mem 0xb2000000-0xb2ffffff]
[    1.329588] pci_bus 0000:03: resource 2 [mem 0xb1000000-0xb1ffffff 64bit pref]
[    1.329590] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7 window]
[    1.329592] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff window]
[    1.329594] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff window]
[    1.329596] pci_bus 0000:04: resource 7 [mem 0xa0000000-0xfebfffff window]
[    1.329682] NET: Registered protocol family 2
[    1.330003] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    1.330236] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    1.330485] TCP: Hash tables configured (established 32768 bind 32768)
[    1.330605] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.330723] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.330900] NET: Registered protocol family 1
[    1.362313] pci 0000:01:00.0: Video device with shadowed ROM
[    1.362393] PCI: CLS 64 bytes, default 64
[    1.362453] Unpacking initramfs...
[    1.709679] Freeing initrd memory: 17260K (ffff880035e3a000 - ffff880036f15000)
[    1.709817] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.709900] software IO TLB [mem 0x9b681000-0x9f681000] (64MB) mapped at [ffff88009b681000-ffff88009f680fff]
[    1.710037] Simple Boot Flag at 0x44 set to 0x1
[    1.710266] microcode: CPU0 sig=0x20652, pf=0x10, revision=0xe
[    1.710361] microcode: CPU1 sig=0x20652, pf=0x10, revision=0xe
[    1.710460] microcode: CPU2 sig=0x20652, pf=0x10, revision=0xe
[    1.710550] microcode: CPU3 sig=0x20652, pf=0x10, revision=0xe
[    1.710713] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.711234] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    1.711374] audit: initializing netlink subsys (disabled)
[    1.711479] audit: type=2000 audit(1467865125.440:1): initialized
[    1.711946] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.712055] zpool: loaded
[    1.712295] VFS: Disk quotas dquot_6.6.0
[    1.712402] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.713011] alg: No test for stdrng (krng)
[    1.713121] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.713269] io scheduler noop registered
[    1.713353] io scheduler deadline registered
[    1.713447] io scheduler cfq registered (default)
[    1.714107] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.714209] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.716025] intel_idle: MWAIT substates: 0x1120
[    1.716027] intel_idle: v0.4 model 0x25
[    1.716028] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.716254] GHES: HEST is not enabled!
[    1.716411] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.717025] Linux agpgart interface v0.103
[    1.717209] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[    1.717291] AMD IOMMUv2 functionality not available on this system
[    1.717787] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSS0] at 0x60,0x64 irq 1,12
[    1.735143] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.735228] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.735470] mousedev: PS/2 mouse device common for all mice
[    1.737390] rtc_cmos 00:01: RTC can wake from S4
[    1.737617] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    1.737733] rtc_cmos 00:01: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    1.737847] ledtrig-cpu: registered to indicate activity on CPUs
[    1.738373] NET: Registered protocol family 10
[    1.738743] mip6: Mobile IPv6
[    1.738824] NET: Registered protocol family 17
[    1.738909] mpls_gso: MPLS GSO support
[    1.739382] registered taskstats version 1
[    1.740065] rtc_cmos 00:01: setting system clock to 2016-07-07 04:18:45 UTC (1467865125)
[    1.740251] PM: Checking hibernation image partition UUID=9be0bf62-859d-42cb-b075-4bd31f41c53d
[    1.757345] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.768560] PM: Hibernation image not present or could not be loaded.
[    1.769337] Freeing unused kernel memory: 1260K (ffffffff81900000 - ffffffff81a3b000)
[    1.769458] Write protecting the kernel read-only data: 8192k
[    1.770131] Freeing unused kernel memory: 484K (ffff880001587000 - ffff880001600000)
[    1.770522] Freeing unused kernel memory: 192K (ffff8800017d0000 - ffff880001800000)
[    1.796411] random: systemd-udevd urandom read with 8 bits of entropy available
[    1.831331] pps_core: LinuxPPS API ver. 1 registered
[    1.831421] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.831961] ACPI: bus type USB registered
[    1.832022] PTP clock support registered
[    1.832170] usbcore: registered new interface driver usbfs
[    1.832276] usbcore: registered new interface driver hub
[    1.832409] usbcore: registered new device driver usb
[    1.833285] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.833626] ehci-pci: EHCI PCI platform driver
[    1.833661] tg3.c:v3.137 (May 11, 2014)
[    1.834018] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.834114] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.834221] ehci-pci 0000:00:1a.0: debug port 2
[    1.838230] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.838253] ehci-pci 0000:00:1a.0: irq 16, io mem 0xb4105c00
[    1.839819] SCSI subsystem initialized
[    1.843333] libata version 3.00 loaded.
[    1.848345] libphy: tg3 mdio bus: probed
[    1.850359] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.850535] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.850629] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.850738] usb usb1: Product: EHCI Host Controller
[    1.850837] usb usb1: Manufacturer: Linux 4.1.26 ehci_hcd
[    1.850931] usb usb1: SerialNumber: 0000:00:1a.0
[    1.851238] hub 1-0:1.0: USB hub found
[    1.851338] hub 1-0:1.0: 2 ports detected
[    1.851923] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.852033] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.852163] ehci-pci 0000:00:1d.0: debug port 2
[    1.856214] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.856301] ehci-pci 0000:00:1d.0: irq 23, io mem 0xb4105800
[    1.866369] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.866552] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.866662] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.866790] usb usb2: Product: EHCI Host Controller
[    1.866902] usb usb2: Manufacturer: Linux 4.1.26 ehci_hcd
[    1.867002] usb usb2: SerialNumber: 0000:00:1d.0
[    1.867389] hub 2-0:1.0: USB hub found
[    1.869105] hub 2-0:1.0: 2 ports detected
[    1.869450] ahci 0000:00:1f.2: version 3.0
[    1.869691] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    1.869830] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    1.869956] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems apst 
[    1.875322] scsi host0: ahci
[    1.875704] scsi host1: ahci
[    1.876017] scsi host2: ahci
[    1.876278] scsi host3: ahci
[    1.876444] ata1: SATA max UDMA/133 abar m2048@0xb4105000 port 0xb4105100 irq 25
[    1.876550] ata2: SATA max UDMA/133 abar m2048@0xb4105000 port 0xb4105180 irq 25
[    1.876658] ata3: DUMMY
[    1.876733] ata4: DUMMY
[    1.921592] tg3 0000:02:00.0 eth0: Tigon3 [partno(BCM57780) rev 57780001] (PCI Express) MAC address 88:ae:1d:62:3b:a5
[    1.921719] tg3 0000:02:00.0 eth0: attached PHY driver [Broadcom BCM57780] (mii_bus:phy_addr=200:01)
[    1.921832] tg3 0000:02:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.921949] tg3 0000:02:00.0 eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    1.924870] tg3 0000:02:00.0 enp2s0: renamed from eth0
[    2.166549] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    2.178552] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    2.194577] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.195976] ata1.00: ATA-8: WDC WD3200BPVT-22ZEST0, 01.01A01, max UDMA/133
[    2.196063] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.197743] ata1.00: configured for UDMA/133
[    2.198221] scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200BPVT-2 1A01 PQ: 0 ANSI: 5
[    2.299214] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    2.299298] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.299847] hub 1-1:1.0: USB hub found
[    2.300148] hub 1-1:1.0: 6 ports detected
[    2.310996] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    2.311090] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.311558] hub 2-1:1.0: USB hub found
[    2.311712] hub 2-1:1.0: 8 ports detected
[    2.518716] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.521951] ata2.00: ATAPI: MATSHITADVD-RAM UJ890AS, 1.00, max UDMA/100
[    2.524308] ata2.00: configured for UDMA/100
[    2.528339] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ890AS  1.00 PQ: 0 ANSI: 5
[    2.539054] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    2.539166] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    2.539337] sd 0:0:0:0: [sda] Write Protect is off
[    2.539427] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.539463] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.549515] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.549628] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.549908] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.570694] usb 1-1.1: new high-speed USB device number 3 using ehci-pci
[    2.618078]  sda: sda1 sda2 sda3 < sda5 sda6 >
[    2.619634] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.699028] usb 1-1.1: New USB device found, idVendor=064e, idProduct=a219
[    2.699126] usb 1-1.1: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    2.699230] usb 1-1.1: Product: 1.3M WebCam
[    2.699373] usb 1-1.1: Manufacturer: Suyin
[    2.699458] usb 1-1.1: SerialNumber: HF1315-S32B-OV01-VA-R02.01.05
[    2.706724] tsc: Refined TSC clocksource calibration: 2261.391 MHz
[    2.706826] clocksource tsc: mask: 0xffffffffffffffff max_cycles: 0x2098bcacd1a, max_idle_ns: 440795311585 ns
[    2.847627] psmouse serio1: synaptics: queried max coordinates: x [..5772], y [..5086]
[    2.963031] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000, board id: 0, fw id: 570026
[    3.034483] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input2
[    3.450993] raid6: sse2x1   gen()  2290 MB/s
[    3.519006] raid6: sse2x1   xor()  1775 MB/s
[    3.587053] raid6: sse2x2   gen()  2699 MB/s
[    3.655065] raid6: sse2x2   xor()  2115 MB/s
[    3.723153] raid6: sse2x4   gen()  2807 MB/s
[    3.791182] raid6: sse2x4   xor()  2252 MB/s
[    3.791279] raid6: using algorithm sse2x4 gen() 2807 MB/s
[    3.791372] raid6: .... xor() 2252 MB/s, rmw enabled
[    3.791460] raid6: using ssse3x2 recovery algorithm
[    3.791795] Switched to clocksource tsc
[    3.791946] xor: measuring software checksum speed
[    3.831122]    prefetch64-sse:  9441.000 MB/sec
[    3.871138]    generic_sse:  8312.000 MB/sec
[    3.871217] xor: using function: prefetch64-sse (9441.000 MB/sec)
[    3.875837] Btrfs loaded
[    3.943550] BTRFS: device fsid 70cab2b7-62e6-40f2-8310-9d75f523bba1 devid 1 transid 328643 /dev/sda5
[    3.943997] BTRFS: device fsid f778877c-d50b-48c8-8951-6635c6e23c61 devid 1 transid 166287 /dev/sda1
[    3.947153] PM: Starting manual resume from disk
[    3.947244] PM: Hibernation image partition 8:6 present
[    3.947246] PM: Looking for hibernation image.
[    3.947541] PM: Image not found (code -22)
[    3.947547] PM: Hibernation image not present or could not be loaded.
[    3.976567] BTRFS info (device sda1): disk space caching is enabled
[    3.976664] BTRFS: has skinny extents
[    4.071941] BTRFS: bdev /dev/sda1 errs: wr 4, rd 10, flush 0, corrupt 0, gen 0
[    4.715537] random: nonblocking pool is initialized
[    5.650894] systemd[1]: RTC configured in localtime, applying delta of 120 minutes to system time.
[    6.091819] systemd[1]: systemd 230 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN)
[    6.092284] systemd[1]: Detected architecture x86-64.
[    6.173095] systemd[1]: Set hostname to <debian-linux>.
[    9.557461] systemd[1]: Listening on RPCbind Server Activation Socket.
[    9.558132] systemd[1]: Listening on Journal Audit Socket.
[    9.558657] systemd[1]: Listening on Journal Socket (/dev/log).
[    9.559157] systemd[1]: Reached target Encrypted Volumes.
[    9.559661] systemd[1]: Listening on Syslog Socket.
[    9.560185] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    9.560724] systemd[1]: Listening on udev Control Socket.
[    9.561244] systemd[1]: Listening on Journal Socket.
[    9.561775] systemd[1]: Listening on udev Kernel Socket.
[    9.562297] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    9.562826] systemd[1]: Listening on fsck to fsckd communication Socket.
[    9.563427] systemd[1]: Created slice User and Session Slice.
[    9.563994] systemd[1]: Created slice System Slice.
[    9.583452] systemd[1]: Starting Load Kernel Modules...
[    9.584309] systemd[1]: Mounting Huge Pages File System...
[    9.584709] systemd[1]: Reached target Slices.
[    9.585705] systemd[1]: Mounting Debug File System...
[    9.586218] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[    9.587257] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    9.587770] systemd[1]: Created slice system-getty.slice.
[    9.588720] systemd[1]: Starting Remount Root and Kernel File Systems...
[    9.589126] systemd[1]: Reached target User and Group Name Lookups.
[    9.806560] lp: driver loaded but no devices found
[    9.863647] systemd[1]: Starting Set the console keyboard layout...
[    9.864238] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    9.865352] systemd[1]: Mounting POSIX Message Queue File System...
[    9.866439] systemd[1]: Starting Journal Service...
[    9.866909] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    9.868957] systemd[1]: Started Create list of required static device nodes for the current kernel.
[    9.870381] systemd[1]: Starting Create Static Device Nodes in /dev...
[    9.874005] ppdev: user-space parallel port driver
[    9.929759] systemd[1]: Started Load Kernel Modules.
[    9.930955] systemd[1]: Starting Apply Kernel Variables...
[   10.253013] systemd[1]: Started Apply Kernel Variables.
[   10.309027] BTRFS info (device sda1): disk space caching is enabled
[   10.309601] systemd[1]: Mounted Debug File System.
[   10.311096] systemd[1]: Mounted POSIX Message Queue File System.
[   10.311874] systemd[1]: Mounted Huge Pages File System.
[   10.327591] systemd[1]: Started Remount Root and Kernel File Systems.
[   10.329407] systemd[1]: Starting Load/Save Random Seed...
[   10.496541] systemd[1]: Starting udev Coldplug all Devices...
[   10.497841] systemd[1]: Started Load/Save Random Seed.
[   10.690448] systemd[1]: Started udev Coldplug all Devices.
[   10.708219] systemd[1]: Started Set the console keyboard layout.
[   10.851150] systemd[1]: Started Journal Service.
[   10.975459] systemd-journald[216]: Received request to flush runtime journal from PID 1
[   19.342766] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   19.369332] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:10/PNP0C0C:00/input/input3
[   19.369450] ACPI: Power Button [PWRB]
[   19.369588] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:10/PNP0C0D:00/input/input4
[   19.369764] ACPI: Lid Switch [LID0]
[   19.369891] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:10/PNP0C0E:00/input/input5
[   19.369993] ACPI: Sleep Button [SLPB]
[   19.370136] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
[   19.370232] ACPI: Power Button [PWRF]
[   19.448892] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042F conflicts with OpRegion 0x0000000000000400-0x000000000000047F (\PMIO) (20150410/utaddress-254)
[   19.449181] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   19.449307] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054F conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20150410/utaddress-254)
[   19.449607] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   19.449732] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053F conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20150410/utaddress-254)
[   19.450008] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053F conflicts with OpRegion 0x0000000000000500-0x000000000000053F (\_SB_.PCI0.GPIO) (20150410/utaddress-254)
[   19.450287] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   19.450405] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052F conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20150410/utaddress-254)
[   19.450682] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052F conflicts with OpRegion 0x0000000000000500-0x000000000000053F (\_SB_.PCI0.GPIO) (20150410/utaddress-254)
[   19.450957] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   19.451078] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   19.609523] ACPI Warning: SystemIO range 0x0000000000004000-0x000000000000401F conflicts with OpRegion 0x0000000000004000-0x000000000000400F (\_SB_.PCI0.SBUS.SMBI) (20150410/utaddress-254)
[   19.609812] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   19.671199] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
[   19.705038] wmi: Mapper loaded
[   19.981707] acpi device:0d: registered as cooling_device4
[   19.981898] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:09/LNXVIDEO:01/input/input7
[   20.137762] ACPI: AC Adapter [AC] (on-line)
[   20.339655] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   20.339824] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   20.358542] bcma: bus0: Found chip with id 43225, rev 0x01 and package 0x0A
[   20.358670] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
[   20.358798] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
[   20.358964] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
[   20.371984] bcma: bus0: Bus registered
[   20.521912] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[   20.580018] [drm] Initialized drm 1.1.0 20060810
[   20.776182] input: PC Speaker as /devices/platform/pcspkr/input/input8
[   21.376801] snd_hda_intel 0000:01:00.1: Handle VGA-switcheroo audio client
[   21.541803] Error: Driver 'pcspkr' is already registered, aborting...
[   21.694474] ACPI: Battery Slot [BAT0] (battery present)
[   22.209167] iTCO_vendor_support: vendor-support=0
[   22.512652] acer_wmi: Acer Laptop ACPI-WMI Extras
[   22.512790] acer_wmi: Function bitmap for Communication Button: 0x1
[   22.512898] acer_wmi: Brightness must be controlled by acpi video driver
[   22.513850] input: Acer WMI hotkeys as /devices/virtual/input/input9
[   22.514366] input: Acer BMA150 accelerometer as /devices/virtual/input/input10
[   22.962217] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   22.962357] iTCO_wdt: Found a HM55 TCO device (Version=2, TCOBASE=0x0460)
[   22.962589] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   23.020995] [drm] radeon kernel modesetting enabled.
[   23.021474] [drm] initializing kernel modesetting (CEDAR 0x1002:0x68E0 0x1025:0x036D).
[   23.021592] [drm] register mmio base: 0xB4000000
[   23.021674] [drm] register mmio size: 131072
[   23.021845] ATOM BIOS: Acer
[   23.021987] radeon 0000:01:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
[   23.022086] radeon 0000:01:00.0: GTT: 1024M 0x0000000020000000 - 0x000000005FFFFFFF
[   23.022184] [drm] Detected VRAM RAM=512M, BAR=256M
[   23.022263] [drm] RAM width 64bits DDR
[   23.022407] [TTM] Zone  kernel: Available graphics memory: 1956678 kiB
[   23.022493] [TTM] Initializing pool allocator
[   23.022580] [TTM] Initializing DMA pool allocator
[   23.022683] [drm] radeon: 512M of VRAM memory ready
[   23.022764] [drm] radeon: 1024M of GTT memory ready.
[   23.022877] [drm] Loading CEDAR Microcode
[   23.044815] input: HDA ATI HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input11
[   23.383332] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC272X: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[   23.383444] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   23.383545] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
[   23.383643] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[   23.383727] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[   23.383810] snd_hda_codec_realtek hdaudioC0D0:      Internal Mic=0x19
[   23.383894] snd_hda_codec_realtek hdaudioC0D0:      Mic=0x18
[   23.393871] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   23.394242] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   23.394458] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   24.012208] media: Linux media interface: v0.10
[   24.290210] Linux video capture interface: v2.00
[   24.495188] cfg80211: Calling CRDA to update world regulatory domain
[   24.786077] [drm] Internal thermal controller with fan control
[   24.808823] [drm] radeon: dpm initialized
[   25.742455] [drm] GART: num cpu pages 262144, num gpu pages 262144
[   25.755507] [drm] PCIE GART of 1024M enabled (table at 0x000000000025E000).
[   25.755738] radeon 0000:01:00.0: WB enabled
[   25.755821] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xffff880096f06c00
[   25.755936] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000020000c0c and cpu addr 0xffff880096f06c0c
[   25.756775] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x000000000005c418 and cpu addr 0xffffc90000c1c418
[   25.756882] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   25.756967] [drm] Driver supports precise vblank timestamp query.
[   25.757050] radeon 0000:01:00.0: radeon: MSI limited to 32-bit
[   25.757174] radeon 0000:01:00.0: radeon: using MSI.
[   25.757282] [drm] radeon: irq initialized.
[   25.774346] [drm] ring test on 0 succeeded in 1 usecs
[   25.774453] [drm] ring test on 3 succeeded in 2 usecs
[   25.944596] Support for cores revisions 0x17 and 0x18 disabled by module param allhwsupport=0. Try b43.allhwsupport=1
[   25.944766] b43: probe of bcma0:1 failed with error -524
[   25.944876] Broadcom 43xx driver loaded [ Features: PMNLS ]
[   25.950824] [drm] ring test on 5 succeeded in 1 usecs
[   25.950913] [drm] UVD initialized successfully.
[   25.951329] [drm] ib test on ring 0 succeeded in 0 usecs
[   25.951442] [drm] ib test on ring 3 succeeded in 0 usecs
[   26.600333] [drm] ib test on ring 5 succeeded
[   26.656418] [drm] radeon atom DIG backlight initialized
[   26.656517] [drm] Radeon Display Connectors
[   26.656597] [drm] Connector 0:
[   26.656672] [drm]   LVDS-1
[   26.656749] [drm]   DDC: 0x6560 0x6560 0x6564 0x6564 0x6568 0x6568 0x656c 0x656c
[   26.656845] [drm]   Encoders:
[   26.656921] [drm]     LCD1: INTERNAL_UNIPHY
[   26.656999] [drm] Connector 1:
[   26.657075] [drm]   HDMI-A-1
[   26.657149] [drm]   HPD1
[   26.657225] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[   26.657322] [drm]   Encoders:
[   26.657395] [drm]     DFP1: INTERNAL_UNIPHY1
[   26.657475] [drm] Connector 2:
[   26.657550] [drm]   VGA-1
[   26.657626] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 0x646c
[   26.657723] [drm]   Encoders:
[   26.657799] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   26.970095] uvcvideo: Found UVC 1.00 device 1.3M WebCam (064e:a219)
[   26.980466] input: 1.3M WebCam as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.0/input/input15
[   26.980876] usbcore: registered new interface driver uvcvideo
[   26.980967] USB Video Class driver (1.1.1)
[   27.318359] brcmsmac bcma0:1: mfg 4bf core 812 rev 23 class 0 irq 17
[   27.644721] cfg80211: Calling CRDA to update world regulatory domain
[   27.873525] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   27.873809] cfg80211: Calling CRDA to update world regulatory domain
[   27.874883] brcmsmac bcma0:1 wlp3s0b1: renamed from wlan0
[   28.707816] Adding 7340028k swap on /dev/sda6.  Priority:-1 extents:1 across:7340028k FS
[   29.079512] [drm] fb mappable at 0xA045F000
[   29.079612] [drm] vram apper at 0xA0000000
[   29.079704] [drm] size 4325376
[   29.079794] [drm] fb depth is 24
[   29.079882] [drm]    pitch is 5632
[   29.080196] fbcon: radeondrmfb (fb0) is primary device
[   29.142488] BTRFS info (device sda5): disk space caching is enabled
[   29.142489] BTRFS: has skinny extents
[   29.201188] BTRFS: bdev /dev/sda5 errs: wr 46, rd 1, flush 0, corrupt 0, gen 0
[   29.308510] fuse init (API version 7.23)
[   29.321470] cfg80211: World regulatory domain updated:
[   29.321472] cfg80211:  DFS Master region: unset
[   29.321472] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[   29.321474] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   29.321475] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   29.321476] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[   29.321478] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[   29.321480] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[   29.321481] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[   29.321482] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[   29.321483] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[   29.321493] cfg80211: Calling CRDA for country: US
[   29.334273] cfg80211: Regulatory domain changed to country: US
[   29.334275] cfg80211:  DFS Master region: FCC
[   29.334276] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[   29.334279] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 3000 mBm), (N/A)
[   29.334281] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 1700 mBm), (N/A)
[   29.334284] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2300 mBm), (0 s)
[   29.334286] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2300 mBm), (0 s)
[   29.334288] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 3000 mBm), (N/A)
[   29.334290] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 4000 mBm), (N/A)
[   36.258908] Console: switching to colour frame buffer device 170x48
[   36.270877] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[   36.270878] radeon 0000:01:00.0: registered panic notifier
[   37.308854] [drm] Initialized radeon 2.42.0 20080528 for 0000:01:00.0 on minor 0
[   39.070390] RPC: Registered named UNIX socket transport module.
[   39.072241] RPC: Registered udp transport module.
[   39.073931] RPC: Registered tcp transport module.
[   39.075569] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   39.112678] FS-Cache: Loaded
[   39.203480] FS-Cache: Netfs 'nfs' registered for caching
[   39.278019] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   39.766359] cgroup: new mount options do not match the existing superblock, will be ignored
[   57.816130] IPv6: ADDRCONF(NETDEV_UP): wlp3s0b1: link is not ready
[   58.099616] brcmsmac bcma0:1: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   58.100871] brcmsmac bcma0:1: brcms_ops_config: change power-save mode: false (implement)
[   58.103869] IPv6: ADDRCONF(NETDEV_UP): wlp3s0b1: link is not ready
[   58.118843] IPv6: ADDRCONF(NETDEV_UP): enp2s0: link is not ready
[   58.146455] IPv6: ADDRCONF(NETDEV_UP): enp2s0: link is not ready
[   58.962305] tg3 0000:02:00.0 enp2s0: Link is down
[   59.089547] IPv6: ADDRCONF(NETDEV_UP): wlp3s0b1: link is not ready
[   59.752208] wlp3s0b1: authenticate with c0:ff:d4:a3:a3:22
[   59.755796] wlp3s0b1: send auth to c0:ff:d4:a3:a3:22 (try 1/3)
[   59.759143] wlp3s0b1: authenticated
[   59.761542] wlp3s0b1: associate with c0:ff:d4:a3:a3:22 (try 1/3)
[   59.768323] wlp3s0b1: RX AssocResp from c0:ff:d4:a3:a3:22 (capab=0x1411 status=0 aid=6)
[   59.770609] brcmsmac bcma0:1: brcmsmac: brcms_ops_bss_info_changed: associated
[   59.772267] brcmsmac bcma0:1: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   59.773983] wlp3s0b1: associated
[   59.775616] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0b1: link becomes ready
[   59.787943] brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 245/256 dur 2466/1504
[   59.821247] brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 250/256 dur 2506/1504
[   59.845503] brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 138/256 dur 1610/1504
[   59.858182] brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 186/256 dur 1994/1504
[   59.888753] brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 159/256 dur 1778/1504
[   59.897425] brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 137/256 dur 1602/1504
[   63.535172] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[  291.721211] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[  528.151786] perf interrupt took too long (2505 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[  587.872949] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[  839.738986] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 1081.466235] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 1311.178258] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 1591.020005] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 1657.621834] brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 153/256 dur 1730/1504
[ 1839.802208] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 2068.237303] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 2328.427485] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 2629.253966] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 2928.055398] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 3166.504854] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 3430.925756] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 3513.872922] BTRFS: could not find root 8
[ 3694.765269] BTRFS info (device sda1): qgroup scan completed (inconsistency flag cleared)
[ 3700.413553] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 3774.489937] perf interrupt took too long (5055 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[ 3994.332504] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 4290.246091] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 4552.796687] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 4790.897667] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 4891.862858] JFS: nTxBlock = 8192, nTxLock = 65536
[ 4892.015016] SGI XFS with ACLs, security attributes, realtime, no debug enabled
[ 4937.735671] BTRFS: device fsid ab574715-dcdd-4b8c-8804-ad6a38fcc5d4 devid 1 transid 3 /dev/sda7
[ 4958.972744] BTRFS info (device sda7): disk space caching is enabled
[ 4958.972753] BTRFS: has skinny extents
[ 4958.972756] BTRFS: flagging fs with big metadata feature
[ 4959.019007] BTRFS: creating UUID tree
[ 5005.436580] BTRFS info (device sda7): disk space caching is enabled
[ 5005.436586] BTRFS: has skinny extents
[ 5081.752006] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 5268.620754] brcmsmac bcma0:1: wl0: brcms_c_d11hdrs_mac80211:  txop exceeded phylen 153/256 dur 1730/1504
[ 5330.656083] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 5594.096518] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 5825.060858] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 6103.313175] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 6359.758001] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 6644.231858] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 6924.130529] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 7201.106740] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 7456.726211] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 7714.666396] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 7968.817977] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 8229.736093] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)
[ 8519.335816] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp filtering: 1 addresses (implement)



--------------CA72DCBEBE7173AA1BD602D0--
