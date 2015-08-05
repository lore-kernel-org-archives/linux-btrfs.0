Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from d.mail.sonic.net ([64.142.111.50]:42752 "EHLO d.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbbHEV4p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Aug 2015 17:56:45 -0400
To: linux-btrfs@vger.kernel.org
From: Konstantin Svist <fry.kun@gmail.com>
Subject: bedup --defrag freezing
Message-ID: <55C2840E.4030909@gmail.com>
Date: Wed, 5 Aug 2015 14:45:50 -0700
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040209010306080600010105"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040209010306080600010105
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

I've been running btrfs on Fedora for a while now, with bedup --defrag
running in a night-time cronjob.
Last few runs seem to have gotten stuck, without possibility of even
killing the process (kill -9 doesn't work) -- all I could do is hard
power cycle.

Did something change recently? Is bedup simply too out of date? What
should I use to de-duplicate across snapshots instead? Etc.?


Thanks,
Konstantin



# uname -a
Linux mireille.svist.net 4.0.8-200.fc21.x86_64 #1 SMP Fri Jul 10
21:09:54 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.1

# btrfs fi show
Label: none  uuid: 5ac56e7d-3d04-4ffa-8160-5a47f46c2939
    Total devices 1 FS bytes used 243.43GiB
    devid    1 size 465.76GiB used 318.05GiB path /dev/sda2

btrfs-progs v4.1

# btrfs fi df /
Data, single: total=309.01GiB, used=238.24GiB
System, single: total=32.00MiB, used=64.00KiB
Metadata, single: total=9.01GiB, used=5.19GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

dmseg attached


--------------040209010306080600010105
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] CPU0 microcode updated early to revision 0x1c, date = 2014-07-03
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.0.8-200.fc21.x86_64 (mockbuild@bkernel02.phx2.fedoraproject.org) (gcc version 4.9.2 20150212 (Red Hat 4.9.2-6) (GCC) ) #1 SMP Fri Jul 10 21:09:54 UTC 2015
[    0.000000] Command line: BOOT_IMAGE=/main/boot/vmlinuz-4.0.8-200.fc21.x86_64 root=/dev/sda2 ro rootflags=subvol=main vconsole.font=latarcyrheb-sun16 quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000ba14ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ba150000-0x00000000ba156fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ba157000-0x00000000ba94ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ba950000-0x00000000babedfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000babee000-0x00000000cac0afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cac0b000-0x00000000cb10afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cb10b000-0x00000000cb63dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cb63e000-0x00000000cb7aafff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cb7ab000-0x00000000cbffefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cbfff000-0x00000000cbffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cd000000-0x00000000cf1fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000022fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: Notebook                         P15SM-A/SM1-A                    /P15SM-A/SM1-A                    , BIOS 4.6.5 03/27/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x22fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7E00000000 write-back
[    0.000000]   1 base 0200000000 mask 7FE0000000 write-back
[    0.000000]   2 base 0220000000 mask 7FF0000000 write-back
[    0.000000]   3 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   4 base 00D0000000 mask 7FF0000000 uncachable
[    0.000000]   5 base 00CE000000 mask 7FFE000000 uncachable
[    0.000000]   6 base 00CD000000 mask 7FFF000000 uncachable
[    0.000000]   7 base 022FE00000 mask 7FFFE00000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC  
[    0.000000] e820: update [mem 0xcd000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcc000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd830-0x000fd83f] mapped at [ffff8800000fd830]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02034000, 0x02034fff] PGTABLE
[    0.000000] BRK [0x02035000, 0x02035fff] PGTABLE
[    0.000000] BRK [0x02036000, 0x02036fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x22fc00000-0x22fdfffff]
[    0.000000]  [mem 0x22fc00000-0x22fdfffff] page 2M
[    0.000000] BRK [0x02037000, 0x02037fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x220000000-0x22fbfffff]
[    0.000000]  [mem 0x220000000-0x22fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x21fffffff]
[    0.000000]  [mem 0x200000000-0x21fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xba14ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xb9ffffff] page 2M
[    0.000000]  [mem 0xba000000-0xba14ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0xba157000-0xba94ffff]
[    0.000000]  [mem 0xba157000-0xba1fffff] page 4k
[    0.000000]  [mem 0xba200000-0xba7fffff] page 2M
[    0.000000]  [mem 0xba800000-0xba94ffff] page 4k
[    0.000000] BRK [0x02038000, 0x02038fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbabee000-0xcac0afff]
[    0.000000]  [mem 0xbabee000-0xbabfffff] page 4k
[    0.000000]  [mem 0xbac00000-0xcabfffff] page 2M
[    0.000000]  [mem 0xcac00000-0xcac0afff] page 4k
[    0.000000] BRK [0x02039000, 0x02039fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xcb10b000-0xcb63dfff]
[    0.000000]  [mem 0xcb10b000-0xcb1fffff] page 4k
[    0.000000]  [mem 0xcb200000-0xcb5fffff] page 2M
[    0.000000]  [mem 0xcb600000-0xcb63dfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xcbfff000-0xcbffffff]
[    0.000000]  [mem 0xcbfff000-0xcbffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x35f7d000-0x36fb6fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000CB746088 000094 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000CB754F70 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000CB7461B8 00EDB6 (v02 ALASKA A M I    00000030 INTL 20120711)
[    0.000000] ACPI: FACS 0x00000000CB7A9080 000040
[    0.000000] ACPI: APIC 0x00000000CB755080 000092 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000CB755118 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: ASF! 0x00000000CB755160 0000A5 (v32 INTEL   HCG     00000001 TFSM 000F4240)
[    0.000000] ACPI: SSDT 0x00000000CB755208 000F92 (v01 TrmRef PtidDevc 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000CB7561A0 000539 (v01 PmRef  Cpu0Ist  00003000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000CB7566E0 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20120711)
[    0.000000] ACPI: MCFG 0x00000000CB7571B8 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000CB7571F8 000038 (v01 ALASKA A M I    01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000CB757230 000315 (v01 SataRe SataTabl 00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000CB757548 001C4D (v01 SaSsdt SaSsdt   00003000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000CB759198 000E8A (v01 SgRef  SgPeg    00001000 INTL 20120711)
[    0.000000] ACPI: DMAR 0x00000000CB75A028 0000B8 (v01 INTEL  HSW      00000001 INTL 00000001)
[    0.000000] ACPI: SSDT 0x00000000CB75A0E0 001468 (v01 OptRef OptTabl  00001000 INTL 20120711)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000022fdfffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x22fde5000-0x22fdf8fff]
[    0.000000]  [ffffea0000000000-ffffea0008bfffff] PMD -> [ffff880227400000-ffff88022f3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000022fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000ba14ffff]
[    0.000000]   node   0: [mem 0x00000000ba157000-0x00000000ba94ffff]
[    0.000000]   node   0: [mem 0x00000000babee000-0x00000000cac0afff]
[    0.000000]   node   0: [mem 0x00000000cb10b000-0x00000000cb63dfff]
[    0.000000]   node   0: [mem 0x00000000cbfff000-0x00000000cbffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000022fdfffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000022fdfffff]
[    0.000000] On node 0 totalpages: 2075702
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12923 pages used for memmap
[    0.000000]   DMA32 zone: 827034 pages, LIFO batch:31
[    0.000000]   Normal zone: 19448 pages used for memmap
[    0.000000]   Normal zone: 1244672 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xcd200000-0xcf1fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xba150000-0xba156fff]
[    0.000000] PM: Registered nosave memory: [mem 0xba950000-0xbabedfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcac0b000-0xcb10afff]
[    0.000000] PM: Registered nosave memory: [mem 0xcb63e000-0xcb7aafff]
[    0.000000] PM: Registered nosave memory: [mem 0xcb7ab000-0xcbffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xcc000000-0xccffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcd000000-0xcf1fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf200000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xcf200000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:1024 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 32 pages/cpu @ffff88022fa00000 s92952 r8192 d29928 u262144
[    0.000000] pcpu-alloc: s92952 r8192 d29928 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 2043246
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/main/boot/vmlinuz-4.0.8-200.fc21.x86_64 root=/dev/sda2 ro rootflags=subvol=main vconsole.font=latarcyrheb-sun16 quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] Memory: 8070984K/8302808K available (7714K kernel code, 1222K rwdata, 3360K rodata, 1508K init, 1532K bss, 231824K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=1024 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:65792 nr_irqs:488 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2793.428 MHz processor
[    0.000020] Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.85 BogoMIPS (lpj=2793428)
[    0.000022] pid_max: default: 32768 minimum: 301
[    0.000026] ACPI: Core revision 20150204
[    0.007764] ACPI: All ACPI Tables successfully acquired
[    0.017405] Security Framework initialized
[    0.017410] SELinux:  Initializing.
[    0.017414] SELinux:  Starting in permissive mode
[    0.017770] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.019378] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.020104] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.020110] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.020280] Initializing cgroup subsys blkio
[    0.020283] Initializing cgroup subsys memory
[    0.020287] Initializing cgroup subsys devices
[    0.020288] Initializing cgroup subsys freezer
[    0.020290] Initializing cgroup subsys net_cls
[    0.020291] Initializing cgroup subsys perf_event
[    0.020293] Initializing cgroup subsys net_prio
[    0.020294] Initializing cgroup subsys hugetlb
[    0.020312] CPU: Physical Processor ID: 0
[    0.020313] CPU: Processor Core ID: 0
[    0.020316] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.020316] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.021037] mce: CPU supports 9 MCE banks
[    0.021046] CPU0: Thermal monitoring enabled (TM1)
[    0.021054] process: using mwait in idle threads
[    0.021056] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.021056] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.021128] Freeing SMP alternatives memory: 28K (ffffffff81eac000 - ffffffff81eb3000)
[    0.021768] ftrace: allocating 27933 entries in 110 pages
[    0.029666] dmar: Host address width 39
[    0.029668] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.029674] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020660462 ecap f0101a
[    0.029675] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.029678] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap d2008020660462 ecap f010da
[    0.029679] dmar: RMRR base: 0x000000cbe7a000 end: 0x000000cbe88fff
[    0.029680] dmar: RMRR base: 0x000000cd000000 end: 0x000000cf1fffff
[    0.029681] IOAPIC id 8 under DRHD base  0xfed91000 IOMMU 1
[    0.029682] HPET id 0 under DRHD base 0xfed91000
[    0.029923] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.029929] Enabled IRQ remapping in x2apic mode
[    0.029930] x2apic enabled
[    0.029934] Switched APIC routing to cluster x2apic.
[    0.030330] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.040345] TSC deadline timer enabled
[    0.040347] smpboot: CPU0: Intel(R) Core(TM) i7-4810MQ CPU @ 2.80GHz (fam: 06, model: 3c, stepping: 03)
[    0.040363] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.040376] ... version:                3
[    0.040377] ... bit width:              48
[    0.040377] ... generic registers:      4
[    0.040378] ... value mask:             0000ffffffffffff
[    0.040378] ... max period:             0000ffffffffffff
[    0.040379] ... fixed-purpose events:   3
[    0.040379] ... event mask:             000000070000000f
[    0.040874] x86: Booting SMP configuration:
[    0.040875] .... node  #0, CPUs:      #1
[    0.052675] CPU1 microcode updated early to revision 0x1c, date = 2014-07-03
[    0.055569] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.055632]  #2
[    0.067427] CPU2 microcode updated early to revision 0x1c, date = 2014-07-03
[    0.070333]  #3
[    0.082130] CPU3 microcode updated early to revision 0x1c, date = 2014-07-03
[    0.085031]  #4 #5 #6 #7
[    0.140585] x86: Booted up 1 node, 8 CPUs
[    0.140588] smpboot: Total of 8 processors activated (44694.84 BogoMIPS)
[    0.146067] devtmpfs: initialized
[    0.147473] PM: Registering ACPI NVS region [mem 0xba150000-0xba156fff] (28672 bytes)
[    0.147474] PM: Registering ACPI NVS region [mem 0xcb63e000-0xcb7aafff] (1495040 bytes)
[    0.147592] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.147594] pinctrl core: initialized pinctrl subsystem
[    0.147624] RTC time: 19:18:08, date: 08/05/15
[    0.147703] NET: Registered protocol family 16
[    0.149935] cpuidle: using governor menu
[    0.149984] ACPI: bus type PCI registered
[    0.149986] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.150041] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.150043] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.150107] PCI: Using configuration type 1 for base access
[    0.154198] ACPI: Added _OSI(Module Device)
[    0.154199] ACPI: Added _OSI(Processor Device)
[    0.154200] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.154201] ACPI: Added _OSI(Processor Aggregator Device)
[    0.156890] ACPI: Executed 2 blocks of module-level executable AML code
[    0.158575] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.159033] ACPI: Dynamic OEM Table Load:
[    0.159037] ACPI: SSDT 0xFFFF8802258E3C00 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20120711)
[    0.159439] ACPI: Dynamic OEM Table Load:
[    0.159443] ACPI: SSDT 0xFFFF8802258CA800 0005AA (v01 PmRef  ApIst    00003000 INTL 20120711)
[    0.159869] ACPI: Dynamic OEM Table Load:
[    0.159871] ACPI: SSDT 0xFFFF88022590AA00 000119 (v01 PmRef  ApCst    00003000 INTL 20120711)
[    0.161074] ACPI: Interpreter enabled
[    0.161080] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20150204/hwxface-580)
[    0.161083] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20150204/hwxface-580)
[    0.161094] ACPI: (supports S0 S3 S4 S5)
[    0.161095] ACPI: Using IOAPIC for interrupt routing
[    0.161111] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.164368] ACPI: Power Resource [NVP3] (on)
[    0.164382] ACPI: Power Resource [NVP2] (on)
[    0.165698] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.165702] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.165980] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.166186] PCI host bridge to bus 0000:00
[    0.166188] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.166190] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.166191] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.166192] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.166193] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
[    0.166193] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
[    0.166194] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
[    0.166195] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
[    0.166196] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff window]
[    0.166197] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff window]
[    0.166198] pci_bus 0000:00: root bus resource [mem 0xcf200000-0xfeafffff window]
[    0.166203] pci 0000:00:00.0: [8086:0c04] type 00 class 0x060000
[    0.166255] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.166280] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.166307] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.166332] pci 0000:00:02.0: [8086:0416] type 00 class 0x030000
[    0.166339] pci 0000:00:02.0: reg 0x10: [mem 0xf7400000-0xf77fffff 64bit]
[    0.166343] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.166346] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.166392] pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
[    0.166397] pci 0000:00:03.0: reg 0x10: [mem 0xf7b14000-0xf7b17fff 64bit]
[    0.166466] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.166481] pci 0000:00:14.0: reg 0x10: [mem 0xf7b00000-0xf7b0ffff 64bit]
[    0.166532] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.166553] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.166576] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.166592] pci 0000:00:16.0: reg 0x10: [mem 0xf7b1e000-0xf7b1e00f 64bit]
[    0.166645] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.166696] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    0.166713] pci 0000:00:1a.0: reg 0x10: [mem 0xf7b1c000-0xf7b1c3ff]
[    0.166789] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.166819] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.166844] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    0.166857] pci 0000:00:1b.0: reg 0x10: [mem 0xf7b10000-0xf7b13fff 64bit]
[    0.166915] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.166938] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.166959] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.167018] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.167044] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.167065] pci 0000:00:1c.1: [8086:8c12] type 01 class 0x060400
[    0.167122] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.167146] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.167166] pci 0000:00:1c.2: [8086:8c14] type 01 class 0x060400
[    0.167223] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.167247] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.167268] pci 0000:00:1c.3: [8086:8c16] type 01 class 0x060400
[    0.167324] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.167348] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.167377] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    0.167394] pci 0000:00:1d.0: reg 0x10: [mem 0xf7b1b000-0xf7b1b3ff]
[    0.167470] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.167501] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.167525] pci 0000:00:1f.0: [8086:8c4b] type 00 class 0x060100
[    0.167653] pci 0000:00:1f.2: [8086:8c03] type 00 class 0x010601
[    0.167665] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    0.167670] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    0.167676] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
[    0.167681] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
[    0.167686] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.167692] pci 0000:00:1f.2: reg 0x24: [mem 0xf7b1a000-0xf7b1a7ff]
[    0.167723] pci 0000:00:1f.2: PME# supported from D3hot
[    0.167761] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.167772] pci 0000:00:1f.3: reg 0x10: [mem 0xf7b19000-0xf7b190ff 64bit]
[    0.167789] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.167866] pci 0000:01:00.0: [10de:1199] type 00 class 0x030000
[    0.167873] pci 0000:01:00.0: reg 0x10: [mem 0xf6000000-0xf6ffffff]
[    0.167879] pci 0000:01:00.0: reg 0x14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.167885] pci 0000:01:00.0: reg 0x1c: [mem 0xf0000000-0xf1ffffff 64bit pref]
[    0.167889] pci 0000:01:00.0: reg 0x24: [io  0xe000-0xe07f]
[    0.167893] pci 0000:01:00.0: reg 0x30: [mem 0xf7000000-0xf707ffff pref]
[    0.167928] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.168990] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.168992] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.168993] pci 0000:00:01.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.168995] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
[    0.169042] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.169128] pci 0000:03:00.0: [104c:823e] type 01 class 0x060400
[    0.169260] pci 0000:03:00.0: supports D1 D2
[    0.169285] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.171000] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.171005] pci 0000:00:1c.1:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.171090] pci 0000:04:00.0: [104c:823f] type 00 class 0x0c0010
[    0.171116] pci 0000:04:00.0: reg 0x10: [mem 0xf7a04000-0xf7a047ff]
[    0.171130] pci 0000:04:00.0: reg 0x14: [mem 0xf7a00000-0xf7a03fff]
[    0.171240] pci 0000:04:00.0: supports D1 D2
[    0.171241] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot
[    0.171329] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.171340] pci 0000:03:00.0:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.171426] pci 0000:05:00.0: [10ec:5289] type 00 class 0xff0000
[    0.171444] pci 0000:05:00.0: reg 0x10: [mem 0xf7900000-0xf790ffff]
[    0.171582] pci 0000:05:00.0: supports D1 D2
[    0.171583] pci 0000:05:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.171612] pci 0000:05:00.0: System wakeup disabled by ACPI
[    0.171652] pci 0000:05:00.2: [10ec:8168] type 00 class 0x020000
[    0.171670] pci 0000:05:00.2: reg 0x10: [io  0xd000-0xd0ff]
[    0.171697] pci 0000:05:00.2: reg 0x18: [mem 0xf2104000-0xf2104fff 64bit pref]
[    0.171714] pci 0000:05:00.2: reg 0x20: [mem 0xf2100000-0xf2103fff 64bit pref]
[    0.171795] pci 0000:05:00.2: supports D1 D2
[    0.171796] pci 0000:05:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.171822] pci 0000:05:00.2: System wakeup disabled by ACPI
[    0.173009] pci 0000:00:1c.2: PCI bridge to [bus 05]
[    0.173012] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.173015] pci 0000:00:1c.2:   bridge window [mem 0xf7900000-0xf79fffff]
[    0.173019] pci 0000:00:1c.2:   bridge window [mem 0xf2100000-0xf21fffff 64bit pref]
[    0.173098] pci 0000:06:00.0: [8086:08b1] type 00 class 0x028000
[    0.173135] pci 0000:06:00.0: reg 0x10: [mem 0xf7800000-0xf7801fff 64bit]
[    0.173322] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.173359] pci 0000:06:00.0: System wakeup disabled by ACPI
[    0.175014] pci 0000:00:1c.3: PCI bridge to [bus 06]
[    0.175018] pci 0000:00:1c.3:   bridge window [mem 0xf7800000-0xf78fffff]
[    0.175576] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.175610] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.175642] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.175673] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.175705] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.175736] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.175767] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.175798] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.175987] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.176020] ACPI : EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.176086] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.176088] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.176091] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    0.176092] vgaarb: loaded
[    0.176093] vgaarb: bridge control possible 0000:01:00.0
[    0.176094] vgaarb: no bridge control possible 0000:00:02.0
[    0.176141] SCSI subsystem initialized
[    0.176173] libata version 3.00 loaded.
[    0.176191] ACPI: bus type USB registered
[    0.176201] usbcore: registered new interface driver usbfs
[    0.176206] usbcore: registered new interface driver hub
[    0.176217] usbcore: registered new device driver usb
[    0.176273] PCI: Using ACPI for IRQ routing
[    0.177415] PCI: pci_cache_line_size set to 64 bytes
[    0.177467] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.177468] e820: reserve RAM buffer [mem 0xba150000-0xbbffffff]
[    0.177469] e820: reserve RAM buffer [mem 0xba950000-0xbbffffff]
[    0.177469] e820: reserve RAM buffer [mem 0xcac0b000-0xcbffffff]
[    0.177470] e820: reserve RAM buffer [mem 0xcb63e000-0xcbffffff]
[    0.177471] e820: reserve RAM buffer [mem 0x22fe00000-0x22fffffff]
[    0.177540] NetLabel: Initializing
[    0.177541] NetLabel:  domain hash size = 128
[    0.177541] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.177548] NetLabel:  unlabeled traffic allowed by default
[    0.177574] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.177577] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.179601] Switched to clocksource hpet
[    0.183561] pnp: PnP ACPI init
[    0.183612] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.183614] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.183773] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.183775] system 00:01: [io  0xffff] has been reserved
[    0.183775] system 00:01: [io  0xffff] has been reserved
[    0.183776] system 00:01: [io  0xffff] has been reserved
[    0.183777] system 00:01: [io  0x1c00-0x1cfe] has been reserved
[    0.183778] system 00:01: [io  0x1d00-0x1dfe] has been reserved
[    0.183779] system 00:01: [io  0x1e00-0x1efe] has been reserved
[    0.183780] system 00:01: [io  0x1f00-0x1ffe] has been reserved
[    0.183781] system 00:01: [io  0x1800-0x18fe] could not be reserved
[    0.183782] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.183783] system 00:01: [io  0x3322-0x3323] has been reserved
[    0.183785] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.183802] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.183828] system 00:03: [io  0x1854-0x1857] has been reserved
[    0.183830] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.183847] pnp 00:04: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.183892] pnp 00:05: Plug and Play ACPI device, IDs SYN1212 PNP0f13 (active)
[    0.183918] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.183920] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.184094] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.184095] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.184096] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.184097] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.184098] system 00:07: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.184099] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.184100] system 00:07: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.184101] system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.184103] system 00:07: [mem 0xff000000-0xffffffff] has been reserved
[    0.184104] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.184105] system 00:07: [mem 0xf7fdf000-0xf7fdffff] has been reserved
[    0.184106] system 00:07: [mem 0xf7fe0000-0xf7feffff] has been reserved
[    0.184107] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.184222] pnp: PnP ACPI: found 8 devices
[    0.189856] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.189858] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.189859] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
[    0.189885] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.189886] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.189887] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.189890] pci 0000:00:1c.0: BAR 14: assigned [mem 0xcf200000-0xcf3fffff]
[    0.189895] pci 0000:00:1c.0: BAR 15: assigned [mem 0xcf400000-0xcf5fffff 64bit pref]
[    0.189896] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.189898] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.189899] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.189901] pci 0000:00:01.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.189903] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
[    0.189905] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.189907] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.189910] pci 0000:00:1c.0:   bridge window [mem 0xcf200000-0xcf3fffff]
[    0.189912] pci 0000:00:1c.0:   bridge window [mem 0xcf400000-0xcf5fffff 64bit pref]
[    0.189916] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.189922] pci 0000:03:00.0:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.189932] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.189935] pci 0000:00:1c.1:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.189941] pci 0000:00:1c.2: PCI bridge to [bus 05]
[    0.189942] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.189945] pci 0000:00:1c.2:   bridge window [mem 0xf7900000-0xf79fffff]
[    0.189947] pci 0000:00:1c.2:   bridge window [mem 0xf2100000-0xf21fffff 64bit pref]
[    0.189951] pci 0000:00:1c.3: PCI bridge to [bus 06]
[    0.189954] pci 0000:00:1c.3:   bridge window [mem 0xf7800000-0xf78fffff]
[    0.189960] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.189961] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.189962] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.189963] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff window]
[    0.189964] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff window]
[    0.189965] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff window]
[    0.189966] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff window]
[    0.189967] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff window]
[    0.189968] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff window]
[    0.189969] pci_bus 0000:00: resource 13 [mem 0xcf200000-0xfeafffff window]
[    0.189970] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.189970] pci_bus 0000:01: resource 1 [mem 0xf6000000-0xf70fffff]
[    0.189971] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xf1ffffff 64bit pref]
[    0.189972] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.189973] pci_bus 0000:02: resource 1 [mem 0xcf200000-0xcf3fffff]
[    0.189974] pci_bus 0000:02: resource 2 [mem 0xcf400000-0xcf5fffff 64bit pref]
[    0.189975] pci_bus 0000:03: resource 1 [mem 0xf7a00000-0xf7afffff]
[    0.189976] pci_bus 0000:04: resource 1 [mem 0xf7a00000-0xf7afffff]
[    0.189977] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.189978] pci_bus 0000:05: resource 1 [mem 0xf7900000-0xf79fffff]
[    0.189979] pci_bus 0000:05: resource 2 [mem 0xf2100000-0xf21fffff 64bit pref]
[    0.189980] pci_bus 0000:06: resource 1 [mem 0xf7800000-0xf78fffff]
[    0.190003] NET: Registered protocol family 2
[    0.190130] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.190251] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.190422] TCP: Hash tables configured (established 65536 bind 65536)
[    0.190439] TCP: reno registered
[    0.190446] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.190473] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.190524] NET: Registered protocol family 1
[    0.190534] pci 0000:00:02.0: Video device with shadowed ROM
[    0.190831] PCI: CLS 64 bytes, default 64
[    0.190864] Unpacking initramfs...
[    0.344115] Freeing initrd memory: 16616K (ffff880035f7d000 - ffff880036fb7000)
[    0.344142] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.344144] software IO TLB [mem 0xc6c0b000-0xcac0b000] (64MB) mapped at [ffff8800c6c0b000-ffff8800cac0afff]
[    0.344331] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
[    0.344369] microcode: CPU0 sig=0x306c3, pf=0x10, revision=0x1c
[    0.344374] microcode: CPU1 sig=0x306c3, pf=0x10, revision=0x1c
[    0.344380] microcode: CPU2 sig=0x306c3, pf=0x10, revision=0x1c
[    0.344385] microcode: CPU3 sig=0x306c3, pf=0x10, revision=0x1c
[    0.344390] microcode: CPU4 sig=0x306c3, pf=0x10, revision=0x1c
[    0.344395] microcode: CPU5 sig=0x306c3, pf=0x10, revision=0x1c
[    0.344399] microcode: CPU6 sig=0x306c3, pf=0x10, revision=0x1c
[    0.344404] microcode: CPU7 sig=0x306c3, pf=0x10, revision=0x1c
[    0.344436] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.344782] AVX2 version of gcm_enc/dec engaged.
[    0.344783] AES CTR mode by8 optimization enabled
[    0.345995] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.346286] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.346313] Initialise system trusted keyring
[    0.346327] audit: initializing netlink subsys (disabled)
[    0.346340] audit: type=2000 audit(1438802287.317:1): initialized
[    0.346584] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.347622] zpool: loaded
[    0.347623] zbud: loaded
[    0.347723] VFS: Disk quotas dquot_6.5.2
[    0.347743] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.347987] Key type big_key registered
[    0.347989] SELinux:  Registering netfilter hooks
[    0.348721] alg: No test for stdrng (krng)
[    0.348726] NET: Registered protocol family 38
[    0.348731] Key type asymmetric registered
[    0.348732] Asymmetric key parser 'x509' registered
[    0.348753] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.348790] io scheduler noop registered
[    0.348792] io scheduler deadline registered
[    0.348816] io scheduler cfq registered (default)
[    0.349359] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    0.349360] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.349362] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    0.349372] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.349374] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.349383] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.349384] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.349385] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    0.349387] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.349396] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    0.349396] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    0.349397] pci 0000:05:00.2: Signaling PME through PCIe PME interrupt
[    0.349400] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    0.349409] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.349410] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    0.349412] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.349416] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.349448] pciehp 0000:00:1c.0:pcie04: Slot #0 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl+ LLActRep+
[    0.349473] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    0.349476] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.349497] intel_idle: MWAIT substates: 0x42120
[    0.349498] intel_idle: v0.4 model 0x3C
[    0.349499] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.350033] ACPI: AC Adapter [AC] (on-line)
[    0.350229] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.350232] ACPI: Power Button [PWRB]
[    0.350253] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.350254] ACPI: Sleep Button [SLPB]
[    0.350275] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
[    0.350288] ACPI: Lid Switch [LID0]
[    0.350309] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.350310] ACPI: Power Button [PWRF]
[    0.350552] thermal LNXTHERM:00: registered as thermal_zone0
[    0.350553] ACPI: Thermal Zone [TZ0] (25 C)
[    0.350571] GHES: HEST is not enabled!
[    0.350631] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.350853] ACPI: Battery Slot [BAT0] (battery present)
[    0.351018] Non-volatile memory driver v1.3
[    0.351039] Linux agpgart interface v0.103
[    0.351140] ahci 0000:00:1f.2: version 3.0
[    0.351213] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    0.351232] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0xd impl SATA mode
[    0.351234] ahci 0000:00:1f.2: flags: 64bit ncq stag led clo pio slum part ems sxs apst 
[    0.355218] scsi host0: ahci
[    0.355297] scsi host1: ahci
[    0.355370] scsi host2: ahci
[    0.355440] scsi host3: ahci
[    0.355509] scsi host4: ahci
[    0.355576] scsi host5: ahci
[    0.355604] ata1: SATA max UDMA/133 abar m2048@0xf7b1a000 port 0xf7b1a100 irq 31
[    0.355605] ata2: DUMMY
[    0.355606] ata3: SATA max UDMA/133 abar m2048@0xf7b1a000 port 0xf7b1a200 irq 31
[    0.355608] ata4: SATA max UDMA/133 abar m2048@0xf7b1a000 port 0xf7b1a280 irq 31
[    0.355608] ata5: DUMMY
[    0.355609] ata6: DUMMY
[    0.355668] libphy: Fixed MDIO Bus: probed
[    0.355781] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.355817] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    0.355902] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
[    0.355907] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.355966] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.355967] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.355969] usb usb1: Product: xHCI Host Controller
[    0.355970] usb usb1: Manufacturer: Linux 4.0.8-200.fc21.x86_64 xhci-hcd
[    0.355971] usb usb1: SerialNumber: 0000:00:14.0
[    0.356051] hub 1-0:1.0: USB hub found
[    0.356067] hub 1-0:1.0: 14 ports detected
[    0.358287] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.358310] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    0.358334] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    0.358335] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.358336] usb usb2: Product: xHCI Host Controller
[    0.358337] usb usb2: Manufacturer: Linux 4.0.8-200.fc21.x86_64 xhci-hcd
[    0.358338] usb usb2: SerialNumber: 0000:00:14.0
[    0.358399] hub 2-0:1.0: USB hub found
[    0.358408] hub 2-0:1.0: 6 ports detected
[    0.359045] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.359049] ehci-pci: EHCI PCI platform driver
[    0.359102] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.359142] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.359150] ehci-pci 0000:00:1a.0: debug port 2
[    0.363038] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.363047] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7b1c000
[    0.368837] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.368861] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.368862] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.368863] usb usb3: Product: EHCI Host Controller
[    0.368864] usb usb3: Manufacturer: Linux 4.0.8-200.fc21.x86_64 ehci_hcd
[    0.368865] usb usb3: SerialNumber: 0000:00:1a.0
[    0.368955] hub 3-0:1.0: USB hub found
[    0.368958] hub 3-0:1.0: 2 ports detected
[    0.369098] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.369146] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    0.369155] ehci-pci 0000:00:1d.0: debug port 2
[    0.373060] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.373068] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7b1b000
[    0.378848] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.378868] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    0.378869] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.378870] usb usb4: Product: EHCI Host Controller
[    0.378871] usb usb4: Manufacturer: Linux 4.0.8-200.fc21.x86_64 ehci_hcd
[    0.378872] usb usb4: SerialNumber: 0000:00:1d.0
[    0.378961] hub 4-0:1.0: USB hub found
[    0.378965] hub 4-0:1.0: 2 ports detected
[    0.379045] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.379049] ohci-pci: OHCI PCI platform driver
[    0.379060] uhci_hcd: USB Universal Host Controller Interface driver
[    0.379090] usbcore: registered new interface driver usbserial
[    0.379094] usbcore: registered new interface driver usbserial_generic
[    0.379099] usbserial: USB Serial support registered for generic
[    0.379125] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:SYNM] at 0x60,0x64 irq 1,12
[    0.384547] i8042: Detected active multiplexing controller, rev 1.1
[    0.386757] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.386762] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.386766] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.386767] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.386768] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.386895] mousedev: PS/2 mouse device common for all mice
[    0.387088] rtc_cmos 00:02: RTC can wake from S4
[    0.387189] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.387214] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.387240] device-mapper: uevent: version 1.0.3
[    0.387290] device-mapper: ioctl: 4.30.0-ioctl (2014-12-22) initialised: dm-devel@redhat.com
[    0.387369] Intel P-state driver initializing.
[    0.388011] hidraw: raw HID events driver (C) Jiri Kosina
[    0.388312] usbcore: registered new interface driver usbhid
[    0.388315] usbhid: USB HID core driver
[    0.388456] drop_monitor: Initializing network drop monitor service
[    0.388635] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.388776] TCP: cubic registered
[    0.388788] Initializing XFRM netlink socket
[    0.389082] NET: Registered protocol family 10
[    0.389623] mip6: Mobile IPv6
[    0.389632] NET: Registered protocol family 17
[    0.390222] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    0.390735] Loading compiled-in X.509 certificates
[    0.393106] Loaded X.509 cert 'Fedora kernel signing key: 82fa38f13029ea3c9418f0565b83582f0f623c61'
[    0.393138] registered taskstats version 1
[    0.394706]   Magic number: 11:673:343
[    0.394721] usb usb1-port14: hash matches
[    0.394744] tty tty60: hash matches
[    0.394887] rtc_cmos 00:02: setting system clock to 2015-08-05 19:18:08 UTC (1438802288)
[    0.395071] PM: Hibernation image not present or could not be loaded.
[    0.660219] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.671233] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    0.681233] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    0.711278] usb 1-3: new full-speed USB device number 2 using xhci_hcd
[    0.744139] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[    0.744141] ata1.00: ATA-9: Samsung SSD 840 EVO 500GB, EXT0BB0Q, max UDMA/133
[    0.744142] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.744429] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[    0.744432] ata1.00: configured for UDMA/133
[    0.744595] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD 840  BB0Q PQ: 0 ANSI: 5
[    0.744853] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    0.744872] sd 0:0:0:0: [sda] Write Protect is off
[    0.744874] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.744880] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.744889] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.746316]  sda: sda1 sda2
[    0.746630] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.785736] usb 3-1: New USB device found, idVendor=8087, idProduct=8008
[    0.785739] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    0.786005] hub 3-1:1.0: USB hub found
[    0.786109] hub 3-1:1.0: 6 ports detected
[    0.795742] usb 4-1: New USB device found, idVendor=8087, idProduct=8000
[    0.795744] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    0.796013] hub 4-1:1.0: USB hub found
[    0.796122] hub 4-1:1.0: 8 ports detected
[    0.877500] usb 1-3: New USB device found, idVendor=1c7a, idProduct=0603
[    0.877515] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    0.877516] usb 1-3: Product: EgisTec_ES603
[    0.877517] usb 1-3: Manufacturer: EgisTec
[    1.030659] usb 1-4: new full-speed USB device number 3 using xhci_hcd
[    1.049671] ata3: SATA link down (SStatus 0 SControl 300)
[    1.195869] usb 1-4: New USB device found, idVendor=8087, idProduct=07dc
[    1.195871] usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.348040] tsc: Refined TSC clocksource calibration: 2793.531 MHz
[    1.349074] usb 1-6: new full-speed USB device number 4 using xhci_hcd
[    1.355045] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.356731] ata4.00: ATAPI: MATSHITABD-MLT UJ260AF, 1.01, max UDMA/133
[    1.357962] ata4.00: configured for UDMA/133
[    1.358999] scsi 3:0:0:0: CD-ROM            MATSHITA BD-MLT UJ260AF   1.01 PQ: 0 ANSI: 5
[    1.448591] sr 3:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.448594] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.448743] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.448816] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    1.449425] Freeing unused kernel memory: 1508K (ffffffff81d33000 - ffffffff81eac000)
[    1.449427] Write protecting the kernel read-only data: 12288k
[    1.449630] Freeing unused kernel memory: 468K (ffff88000178b000 - ffff880001800000)
[    1.449764] Freeing unused kernel memory: 736K (ffff880001b48000 - ffff880001c00000)
[    1.450939] random: systemd urandom read with 20 bits of entropy available
[    1.515842] usb 1-6: New USB device found, idVendor=046d, idProduct=c529
[    1.515844] usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.515845] usb 1-6: Product: USB Receiver
[    1.515846] usb 1-6: Manufacturer: Logitech
[    1.515938] usb 1-6: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    1.518704] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:046D:C529.0001/input/input11
[    1.569444] hid-generic 0003:046D:C529.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb-0000:00:14.0-6/input0
[    1.572296] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.1/0003:046D:C529.0002/input/input12
[    1.581691] psmouse serio2: synaptics: queried max coordinates: x [..5692], y [..4680]
[    1.627744] hid-generic 0003:046D:C529.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:14.0-6/input1
[    1.670117] rtsx_pci 0000:05:00.0: rtsx_pci_acquire_irq: pcr->msi_en = 1, pci->irq = 33
[    1.670907] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.671614] r8169 0000:05:00.2 eth0: RTL8411 at 0xffffc90000c7a000, 80:fa:5b:03:4b:5d, XID 08800800 IRQ 34
[    1.671617] r8169 0000:05:00.2 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    1.675490] r8169 0000:05:00.2 p2p1: renamed from eth0
[    1.684416] raid6: sse2x1    8984 MB/s
[    1.701437] raid6: sse2x2   14289 MB/s
[    1.718443] raid6: sse2x4   16699 MB/s
[    1.725837] psmouse serio2: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000, board id: 0, fw id: 582762
[    1.726510] firewire_ohci 0000:04:00.0: added OHCI v1.10 device as card 0, 8 IR + 8 IT contexts, quirks 0x2
[    1.735463] raid6: avx2x1   22425 MB/s
[    1.752495] raid6: avx2x2   26167 MB/s
[    1.765092] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio2/input/input10
[    1.769505] raid6: avx2x4   30140 MB/s
[    1.769516] raid6: using algorithm avx2x4 (30140 MB/s)
[    1.769517] raid6: using avx2x2 recovery algorithm
[    1.770621] xor: automatically using best checksumming function:
[    1.780529]    avx       : 37000.000 MB/sec
[    1.780571] usb 1-10: new high-speed USB device number 5 using xhci_hcd
[    1.815032] Btrfs loaded
[    1.817628] BTRFS: device fsid 5ac56e7d-3d04-4ffa-8160-5a47f46c2939 devid 1 transid 1220402 /dev/sda2
[    1.831071] BTRFS info (device sda2): disk space caching is enabled
[    2.023157] usb 1-10: New USB device found, idVendor=5986, idProduct=055c
[    2.023160] usb 1-10: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    2.023161] usb 1-10: Product: BisonCam, NB Pro
[    2.023162] usb 1-10: Manufacturer: Generic
[    2.023163] usb 1-10: SerialNumber: 200901010001
[    2.199865] BTRFS: detected SSD devices, enabling SSD mode
[    2.228163] firewire_core 0000:04:00.0: created device fw0: GUID 0000000000000000, S800
[    2.349420] Switched to clocksource tsc
[    2.422540] systemd-journald[182]: Received SIGTERM from PID 1 (systemd).
[    2.600456] SELinux: 2048 avtab hash slots, 105212 rules.
[    2.611205] SELinux: 2048 avtab hash slots, 105212 rules.
[    2.627176] SELinux:  8 users, 103 roles, 4998 types, 294 bools, 1 sens, 1024 cats
[    2.627179] SELinux:  83 classes, 105212 rules
[    2.629620] SELinux:  Permission audit_read in class capability2 not defined in policy.
[    2.629623] SELinux:  Class binder not defined in policy.
[    2.629623] SELinux: the above unknown classes and permissions will be allowed
[    2.629627] SELinux:  Completing initialization.
[    2.629627] SELinux:  Setting up existing superblocks.
[    2.634697] audit: type=1403 audit(1438802290.736:2): policy loaded auid=4294967295 ses=4294967295
[    2.637937] systemd[1]: Successfully loaded SELinux policy in 57.885ms.
[    2.657807] systemd[1]: Relabelled /dev and /run in 10.489ms.
[    2.725092] systemd-sysv-generator[438]: Could not find init script for pmmgr.service
[    2.725099] systemd-sysv-generator[438]: Could not find init script for pmwebd.service
[    2.725103] systemd-sysv-generator[438]: Could not find init script for pmcd.service
[    2.725106] systemd-sysv-generator[438]: Could not find init script for pmlogger.service
[    2.725110] systemd-sysv-generator[438]: Could not find init script for pmie.service
[    2.725113] systemd-sysv-generator[438]: Could not find init script for pmproxy.service
[    2.725144] systemd-sysv-generator[438]: Could not find init script for pmmgr.service
[    2.725148] systemd-sysv-generator[438]: Could not find init script for pmwebd.service
[    2.725152] systemd-sysv-generator[438]: Could not find init script for pmcd.service
[    2.725155] systemd-sysv-generator[438]: Could not find init script for pmlogger.service
[    2.725157] systemd-sysv-generator[438]: Could not find init script for pmie.service
[    2.725160] systemd-sysv-generator[438]: Could not find init script for pmproxy.service
[    2.725186] systemd-sysv-generator[438]: Could not find init script for pmmgr.service
[    2.725188] systemd-sysv-generator[438]: Could not find init script for pmwebd.service
[    2.725190] systemd-sysv-generator[438]: Could not find init script for pmcd.service
[    2.725192] systemd-sysv-generator[438]: Could not find init script for pmlogger.service
[    2.725194] systemd-sysv-generator[438]: Could not find init script for pmie.service
[    2.725196] systemd-sysv-generator[438]: Could not find init script for pmproxy.service
[    2.725214] systemd-sysv-generator[438]: Could not find init script for pmmgr.service
[    2.725216] systemd-sysv-generator[438]: Could not find init script for pmwebd.service
[    2.725218] systemd-sysv-generator[438]: Could not find init script for pmcd.service
[    2.725220] systemd-sysv-generator[438]: Could not find init script for pmlogger.service
[    2.725222] systemd-sysv-generator[438]: Could not find init script for pmie.service
[    2.725224] systemd-sysv-generator[438]: Could not find init script for pmproxy.service
[    2.725240] systemd-sysv-generator[438]: Could not find init script for pmmgr.service
[    2.725242] systemd-sysv-generator[438]: Could not find init script for pmwebd.service
[    2.725244] systemd-sysv-generator[438]: Could not find init script for pmcd.service
[    2.725246] systemd-sysv-generator[438]: Could not find init script for pmlogger.service
[    2.725248] systemd-sysv-generator[438]: Could not find init script for pmie.service
[    2.725250] systemd-sysv-generator[438]: Could not find init script for pmproxy.service
[    2.725267] systemd-sysv-generator[438]: Could not find init script for pmmgr.service
[    2.725269] systemd-sysv-generator[438]: Could not find init script for pmwebd.service
[    2.725270] systemd-sysv-generator[438]: Could not find init script for pmcd.service
[    2.725272] systemd-sysv-generator[438]: Could not find init script for pmlogger.service
[    2.725274] systemd-sysv-generator[438]: Could not find init script for pmie.service
[    2.725276] systemd-sysv-generator[438]: Could not find init script for pmproxy.service
[    2.725293] systemd-sysv-generator[438]: Could not find init script for pmmgr.service
[    2.725295] systemd-sysv-generator[438]: Could not find init script for pmwebd.service
[    2.725297] systemd-sysv-generator[438]: Could not find init script for pmcd.service
[    2.725299] systemd-sysv-generator[438]: Could not find init script for pmlogger.service
[    2.725301] systemd-sysv-generator[438]: Could not find init script for pmie.service
[    2.725303] systemd-sysv-generator[438]: Could not find init script for pmproxy.service
[    2.973349] BTRFS info (device sda2): disk space caching is enabled
[    3.160593] RPC: Registered named UNIX socket transport module.
[    3.160595] RPC: Registered udp transport module.
[    3.160596] RPC: Registered tcp transport module.
[    3.160596] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.299004] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    3.355181] systemd-journald[448]: Received request to flush runtime journal from PID 1
[    3.613305] wmi: Mapper loaded
[    3.615856] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.643467] ACPI Warning: SystemIO range 0x000000000000F040-0x000000000000F05F conflicts with OpRegion 0x000000000000F040-0x000000000000F04F (\_SB_.PCI0.SBUS.SMBI) (20150204/utaddress-254)
[    3.643473] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.657357] EDAC MC: Ver: 3.0.0
[    3.662648] [drm] Initialized drm 1.1.0 20060810
[    3.663255] EDAC ie31200: No ECC support
[    3.705342] cfg80211: Calling CRDA to update world regulatory domain
[    3.706653] alg: No test for crc32 (crc32-pclmul)
[    3.755721] Intel(R) Wireless WiFi driver for Linux
[    3.755725] Copyright(c) 2003- 2014 Intel Corporation
[    3.756258] iTCO_vendor_support: vendor-support=0
[    3.766123] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    3.766293] iTCO_wdt: Found a Lynx Point TCO device (Version=2, TCOBASE=0x1860)
[    3.766546] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    3.768920] Bluetooth: Core ver 2.20
[    3.768932] NET: Registered protocol family 31
[    3.768933] Bluetooth: HCI device and connection manager initialized
[    3.768936] Bluetooth: HCI socket layer initialized
[    3.768939] Bluetooth: L2CAP socket layer initialized
[    3.768943] Bluetooth: SCO socket layer initialized
[    3.772496] media: Linux media interface: v0.10
[    3.774006] usbcore: registered new interface driver btusb
[    3.786619] cfg80211: World regulatory domain updated:
[    3.786623] cfg80211:  DFS Master region: unset
[    3.786624] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    3.786626] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    3.786628] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    3.786629] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    3.786631] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[    3.786633] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[    3.786635] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    3.786636] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    3.786638] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    3.787246] Linux video capture interface: v2.00
[    3.789476] iwlwifi 0000:06:00.0: loaded firmware version 25.17.12.0 op_mode iwlmvm
[    3.789928] Bluetooth: hci0: read Intel version: 370710018002030d00
[    3.792582] i915: unknown parameter 'i915_enable_rc6' ignored
[    3.792585] i915: unknown parameter 'i915_enable_fbc' ignored
[    3.793162] [drm] Memory usable by graphics device = 2048M
[    3.793165] [drm] Replacing VGA console driver
[    3.793693] Console: switching to colour dummy device 80x25
[    3.801009] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    3.801011] [drm] Driver supports precise vblank timestamp query.
[    3.801110] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    3.811903] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
[    3.824257] uvcvideo: Found UVC 1.00 device BisonCam, NB Pro (5986:055c)
[    3.828610] input: BisonCam, NB Pro as /devices/pci0000:00/0000:00:14.0/usb1/1-10/1-10:1.0/input/input15
[    3.828694] usbcore: registered new interface driver uvcvideo
[    3.828696] USB Video Class driver (1.1.1)
[    3.831860] intel_rapl: Found RAPL domain package
[    3.831864] intel_rapl: Found RAPL domain core
[    3.831866] intel_rapl: Found RAPL domain uncore
[    3.831867] intel_rapl: Found RAPL domain dram
[    3.866704] iwlwifi 0000:06:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
[    3.866754] iwlwifi 0000:06:00.0: L1 Disabled - LTR Disabled
[    3.866977] iwlwifi 0000:06:00.0: L1 Disabled - LTR Disabled
[    3.890321] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
[    3.890351] ACPI: Video Device [PEGP] (multi-head: yes  rom: yes  post: no)
[    3.890400] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:4d/LNXVIDEO:00/input/input16
[    3.890510] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    3.890692] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input17
[    3.890761] [drm] Initialized i915 1.6.0 20150130 for 0000:00:02.0 on minor 0
[    3.891169] snd_hda_intel 0000:00:03.0: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
[    3.905033] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input18
[    3.905140] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input19
[    3.905187] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input20
[    3.913723] sound hdaudioC1D0: autoconfig for ALC892: line_outs=1 (0x17/0x0/0x0/0x0/0x0) type:line
[    3.913726] sound hdaudioC1D0:    speaker_outs=1 (0x14/0x0/0x0/0x0/0x0)
[    3.913727] sound hdaudioC1D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    3.913728] sound hdaudioC1D0:    mono: mono_out=0x0
[    3.913729] sound hdaudioC1D0:    dig-out=0x1e/0x0
[    3.913730] sound hdaudioC1D0:    inputs:
[    3.913732] sound hdaudioC1D0:      Mic=0x18
[    3.913733] sound hdaudioC1D0:      Internal Mic=0x12
[    3.913734] sound hdaudioC1D0:      Line=0x1a
[    3.923631] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input21
[    3.923687] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card1/input22
[    3.923734] input: HDA Intel PCH Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card1/input23
[    3.923787] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input24
[    3.941142] Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
[    3.951148] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[    4.024215] fbcon: inteldrmfb (fb0) is primary device
[    4.081856] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[    4.085867] iwlwifi 0000:06:00.0 wlp6s0: renamed from wlan0
[    4.128368] cfg80211: Calling CRDA for country: US
[    4.144477] random: nonblocking pool is initialized
[    4.150654] cfg80211: Regulatory domain changed to country: US
[    4.150656] cfg80211:  DFS Master region: FCC
[    4.150656] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    4.150657] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 3000 mBm), (N/A)
[    4.150658] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 1700 mBm), (N/A)
[    4.150659] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2300 mBm), (0 s)
[    4.150660] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2300 mBm), (0 s)
[    4.150660] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 3000 mBm), (N/A)
[    4.150661] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 4000 mBm), (N/A)
[    6.150865] Console: switching to colour frame buffer device 240x67
[    6.179178] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    6.179179] i915 0000:00:02.0: registered panic notifier
[    6.434190] audit: type=1305 audit(1438802294.531:3): audit_pid=705 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[    6.495325] bbswitch: module verification failed: signature and/or required key missing - tainting kernel
[    6.495470] bbswitch: version 0.8
[    6.495475] bbswitch: Found integrated VGA device 0000:00:02.0: \_SB_.PCI0.GFX0
[    6.495479] bbswitch: Found discrete VGA device 0000:01:00.0: \_SB_.PCI0.PEG0.PEGP
[    6.495491] ACPI Warning: \_SB_.PCI0.PEG0.PEGP._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20150204/nsarguments-95)
[    6.495568] bbswitch: detected an Optimus _DSM function
[    6.495577] pci 0000:01:00.0: enabling device (0006 -> 0007)
[    6.495621] bbswitch: Succesfully loaded. Discrete card 0000:01:00.0 is on
[    6.498601] bbswitch: disabling discrete graphics
[    6.498609] ACPI Warning: \_SB_.PCI0.PEG0.PEGP._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20150204/nsarguments-95)
[    6.515120] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.515124] Bluetooth: BNEP filters: protocol multicast
[    6.515128] Bluetooth: BNEP socket layer initialized
[    6.640235] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[    6.653577] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    6.681762] Ebtables v2.0 registered
[    6.693488] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[    6.912550] r8169 0000:05:00.2 p2p1: link down
[    6.912567] r8169 0000:05:00.2 p2p1: link down
[    6.914563] iwlwifi 0000:06:00.0: L1 Disabled - LTR Disabled
[    6.914807] iwlwifi 0000:06:00.0: L1 Disabled - LTR Disabled
[    8.473437] r8169 0000:05:00.2 p2p1: link up
[   89.891439] fuse init (API version 7.23)
[   90.509645] Bluetooth: RFCOMM TTY layer initialized
[   90.509651] Bluetooth: RFCOMM socket layer initialized
[   90.509680] Bluetooth: RFCOMM ver 1.11

--------------040209010306080600010105--
