Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out-2.talktalk.net ([62.24.135.66]:21654 "EHLO
        smtp-out-2.talktalk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759561AbcLPOQD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 09:16:03 -0500
Date: Fri, 16 Dec 2016 14:06:30 +0000
From: Graham Young <gcyoung@talktalk.net>
To: linux-btrfs@vger.kernel.org
Subject: btrfs file recovery
Message-ID: <20161216140630.17e89612@mainbox.homenet>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/vZ5wlG./kdSTb368emjF2oZ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--MP_/vZ5wlG./kdSTb368emjF2oZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I am hoping you can help or inform me if the following is a vain hope.
	
I have mistakenly deleted all files from a pair of disks formated into
a btrfs system. (pressed  the wrong function key on midnight
commander in error!). I have not written anything to the disks since
the deletion, and would be grateful if you could avise me if it is
possible to restore the system to the state it was in before the
deletion.

I have tried using "btrfs-undelete" on some files with no success.

I am appending a dmesg.log file which I understand you  may require.
The disks used are an extended partition /dev/sda7 and /dev/sdb, and
they were mounted as "/data"
************************************************
The following is futher information which I believe may also be needed.
uname -a
Linux lollo 4.4.0-53-generic #74-Ubuntu SMP Fri Dec 2 15:59:10 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
#
btrfs --version
btrfs-progs v4.4
#
btrfs filesystem df /data
Data, RAID1: total=1.00GiB, used=512.00KiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=1.00GiB, used=112.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B
#
btrfs filesystem show
Label: none  uuid: 45b03ab1-cf2e-46db-b3e1-9e170d916701
        Total devices 2 FS bytes used 640.00KiB
        devid    1 size 307.42GiB used 2.03GiB path /dev/sda7
        devid 
--MP_/vZ5wlG./kdSTb368emjF2oZ
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg.log

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.4.0-53-generic (buildd@lcy01-28) (gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.4) ) #74-Ubuntu SMP Fri Dec 2 15:59:10 UTC 2016 (Ubuntu 4.4.0-53.74-generic 4.4.30)
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.4.0-53-generic root=UUID=994993ce-9ab3-473a-bda0-90db514a5ef9 ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] tseg: 0000000000
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'lazy' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffbffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ffc0000-0x000000007ffcdfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007ffce000-0x000000007ffeffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007fff0000-0x000000007fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000feefffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: ECS GeForce6100PM-M2/GeForce6100PM-M2, BIOS 080015  04/29/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x7ffc0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x02202000, 0x02202fff] PGTABLE
[    0.000000] BRK [0x02203000, 0x02203fff] PGTABLE
[    0.000000] BRK [0x02204000, 0x02204fff] PGTABLE
[    0.000000] BRK [0x02205000, 0x02205fff] PGTABLE
[    0.000000] BRK [0x02206000, 0x02206fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x336ae000-0x35b4efff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FAE70 000014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 0x000000007FFC0000 000044 (v01 042910 RSDT1402 20100429 MSFT 00000097)
[    0.000000] ACPI: FACP 0x000000007FFC0200 000084 (v01 042910 FACP1402 20100429 MSFT 00000097)
[    0.000000] ACPI: DSDT 0x000000007FFC04B0 005004 (v01 1AAAA  1AAAA000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 0x000000007FFCE000 000040
[    0.000000] ACPI: APIC 0x000000007FFC0390 000090 (v01 042910 APIC1402 20100429 MSFT 00000097)
[    0.000000] ACPI: MCFG 0x000000007FFC0420 00003C (v01 042910 OEMMCFG  20100429 MSFT 00000097)
[    0.000000] ACPI: WDRT 0x000000007FFC0460 000047 (v01 042910 NV-WDRT  20100429 MSFT 00000097)
[    0.000000] ACPI: OEMB 0x000000007FFCE040 000072 (v01 042910 OEMB1402 20100429 MSFT 00000097)
[    0.000000] ACPI: SRAT 0x000000007FFC54C0 0000A0 (v03 AMD    FAM_F_10 00000002 AMD  00000001)
[    0.000000] ACPI: HPET 0x000000007FFC5560 000038 (v01 042910 OEMHPET0 20100429 MSFT 00000097)
[    0.000000] ACPI: SSDT 0x000000007FFC55A0 000458 (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0x7fffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0x7ffbffff] -> [mem 0x00000000-0x7ffbffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x7ffbb000-0x7ffbffff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x000000007ffbffff]
[    0.000000]   Normal   empty
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000007ffbffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000007ffbffff]
[    0.000000] On node 0 totalpages: 524126
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8127 pages used for memmap
[    0.000000]   DMA32 zone: 520128 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfeff0000
[    0.000000] smpboot: Allowing 6 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] e820: [mem 0x80000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:6 nr_node_ids:1
[    0.000000] PERCPU: Embedded 33 pages/cpu @ffff88007fc00000 s98008 r8192 d28968 u262144
[    0.000000] pcpu-alloc: s98008 r8192 d28968 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - - 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 515914
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.4.0-53-generic root=UUID=994993ce-9ab3-473a-bda0-90db514a5ef9 ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] AGP: Node 0: aperture [bus addr 0x468000000-0x469ffffff] (32MB)
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Memory: 2006616K/2096504K available (8427K kernel code, 1285K rwdata, 3956K rodata, 1480K init, 1292K bss, 89888K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=6.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=6
[    0.000000] NR_IRQS:16640 nr_irqs:472 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] vt handoff: transparent VT on vt#7
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 76450417870 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: PIT calibration matches HPET. 1 loops
[    0.000000] tsc: Detected 2712.332 MHz processor
[    0.000034] Calibrating delay loop (skipped), value calculated using timer frequency.. 5424.66 BogoMIPS (lpj=10849328)
[    0.000037] pid_max: default: 32768 minimum: 301
[    0.000043] ACPI: Core revision 20150930
[    0.003024] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    0.003049] Security Framework initialized
[    0.003052] Yama: becoming mindful.
[    0.003072] AppArmor: AppArmor initialized
[    0.003225] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004038] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004448] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.004452] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.004710] Initializing cgroup subsys io
[    0.004715] Initializing cgroup subsys memory
[    0.004726] Initializing cgroup subsys devices
[    0.004730] Initializing cgroup subsys freezer
[    0.004733] Initializing cgroup subsys net_cls
[    0.004736] Initializing cgroup subsys perf_event
[    0.004739] Initializing cgroup subsys net_prio
[    0.004744] Initializing cgroup subsys hugetlb
[    0.004747] Initializing cgroup subsys pids
[    0.004769] CPU: Physical Processor ID: 0
[    0.004770] CPU: Processor Core ID: 0
[    0.004773] mce: CPU supports 6 MCE banks
[    0.004779] LVT offset 0 assigned for vector 0xf9
[    0.004784] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.004786] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
[    0.005041] Freeing SMP alternatives memory: 32K (ffffffff820b5000 - ffffffff820bd000)
[    0.006679] ftrace: allocating 32053 entries in 126 pages
[    0.020544] smpboot: Max logical packages: 3
[    0.020548] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.021051] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.165959] smpboot: CPU0: AMD Athlon(tm) II X2 215 Processor (family: 0x10, model: 0x6, stepping: 0x2)
[    0.165980] Performance Events: AMD PMU driver.
[    0.165985] ... version:                0
[    0.165986] ... bit width:              48
[    0.165987] ... generic registers:      4
[    0.165988] ... value mask:             0000ffffffffffff
[    0.165989] ... max period:             00007fffffffffff
[    0.165990] ... fixed-purpose events:   0
[    0.165991] ... event mask:             000000000000000f
[    0.166764] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.166854] x86: Booting SMP configuration:
[    0.166856] .... node  #0, CPUs:      #1
[    0.168949] TSC synchronization [CPU#0 -> CPU#1]:
[    0.168951] Measured 26403110130 cycles TSC warp between CPUs, turning off TSC clock.
[    0.168955] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[    0.169000] x86: Booted up 1 node, 2 CPUs
[    0.169002] smpboot: Total of 2 processors activated (10849.32 BogoMIPS)
[    0.068045] devtmpfs: initialized
[    0.071097] evm: security.selinux
[    0.071099] evm: security.SMACK64
[    0.071100] evm: security.SMACK64EXEC
[    0.071101] evm: security.SMACK64TRANSMUTE
[    0.071102] evm: security.SMACK64MMAP
[    0.071102] evm: security.ima
[    0.071103] evm: security.capability
[    0.072025] PM: Registering ACPI NVS region [mem 0x7ffce000-0x7ffeffff] (139264 bytes)
[    0.072025] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.072042] pinctrl core: initialized pinctrl subsystem
[    0.072138] RTC time: 11:42:20, date: 12/16/16
[    0.072274] NET: Registered protocol family 16
[    0.084026] cpuidle: using governor ladder
[    0.096016] cpuidle: using governor menu
[    0.096025] PCCT header not found.
[    0.096033] node 0 link 0: io port [1000, ffffff]
[    0.096036] TOM: 0000000080000000 aka 2048M
[    0.096038] Fam 10h mmconf [mem 0xe0000000-0xefffffff]
[    0.096040] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.096043] node 0 link 0: mmio [a0000, bffff]
[    0.096045] node 0 link 0: mmio [80000000, fe0bffff] ==> [80000000, dfffffff] and [f0000000, fe0bffff]
[    0.096048] bus: [bus 00-07] on node 0 link 0
[    0.096049] bus: 00 [io  0x0000-0xffff]
[    0.096051] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.096052] bus: 00 [mem 0x80000000-0xdfffffff]
[    0.096053] bus: 00 [mem 0xf0000000-0xfcffffffff]
[    0.096148] ACPI: bus type PCI registered
[    0.096151] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.096243] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.096246] PCI: not using MMCONFIG
[    0.096248] PCI: Using configuration type 1 for base access
[    0.096248] PCI: Using configuration type 1 for extended access
[    0.096402] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.096403] mtrr: probably your BIOS does not setup all CPUs.
[    0.096404] mtrr: corrected configuration.
[    0.112114] ACPI: Added _OSI(Module Device)
[    0.112119] ACPI: Added _OSI(Processor Device)
[    0.112120] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.112122] ACPI: Added _OSI(Processor Aggregator Device)
[    0.113853] ACPI: Executed 1 blocks of module-level executable AML code
[    0.116043] ACPI: Interpreter enabled
[    0.116060] ACPI: (supports S0 S3 S4 S5)
[    0.116062] ACPI: Using IOAPIC for interrupt routing
[    0.116091] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.117615] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.117629] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.124307] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.124315] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.124509] acpi PNP0A03:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.124684] PCI host bridge to bus 0000:00
[    0.124688] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.124690] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.124692] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.124694] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff window]
[    0.124696] pci_bus 0000:00: root bus resource [mem 0x80000000-0xdfffffff window]
[    0.124698] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff window]
[    0.124700] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.124719] pci 0000:00:00.0: [10de:03ea] type 00 class 0x050000
[    0.124920] pci 0000:00:01.0: [10de:03e0] type 00 class 0x060100
[    0.124928] pci 0000:00:01.0: reg 0x10: [io  0x4f00-0x4fff]
[    0.125005] pci 0000:00:01.1: [10de:03eb] type 00 class 0x0c0500
[    0.125019] pci 0000:00:01.1: reg 0x10: [io  0x4900-0x493f]
[    0.125033] pci 0000:00:01.1: reg 0x20: [io  0x4d00-0x4d3f]
[    0.125038] pci 0000:00:01.1: reg 0x24: [io  0x4e00-0x4e3f]
[    0.125058] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.125091] pci 0000:00:01.1: System wakeup disabled by ACPI
[    0.125125] pci 0000:00:01.2: [10de:03f5] type 00 class 0x050000
[    0.125199] pci 0000:00:02.0: [10de:03f1] type 00 class 0x0c0310
[    0.125210] pci 0000:00:02.0: reg 0x10: [mem 0xfdd7f000-0xfdd7ffff]
[    0.125240] pci 0000:00:02.0: supports D1 D2
[    0.125241] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.125267] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.125301] pci 0000:00:02.1: [10de:03f2] type 00 class 0x0c0320
[    0.125314] pci 0000:00:02.1: reg 0x10: [mem 0xfdd7ec00-0xfdd7ecff]
[    0.125347] pci 0000:00:02.1: supports D1 D2
[    0.125349] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.125375] pci 0000:00:02.1: System wakeup disabled by ACPI
[    0.125415] pci 0000:00:04.0: [10de:03f3] type 01 class 0x060401
[    0.125464] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.125500] pci 0000:00:05.0: [10de:03f0] type 00 class 0x040300
[    0.125514] pci 0000:00:05.0: reg 0x10: [mem 0xfdd78000-0xfdd7bfff]
[    0.125547] pci 0000:00:05.0: PME# supported from D3hot D3cold
[    0.125574] pci 0000:00:05.0: System wakeup disabled by ACPI
[    0.125614] pci 0000:00:06.0: [10de:03ec] type 00 class 0x01018a
[    0.125636] pci 0000:00:06.0: reg 0x20: [io  0xffa0-0xffaf]
[    0.125646] pci 0000:00:06.0: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.125648] pci 0000:00:06.0: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.125649] pci 0000:00:06.0: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.125651] pci 0000:00:06.0: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.125711] pci 0000:00:07.0: [10de:03ef] type 00 class 0x068000
[    0.125723] pci 0000:00:07.0: reg 0x10: [mem 0xfdd7d000-0xfdd7dfff]
[    0.125727] pci 0000:00:07.0: reg 0x14: [io  0xc480-0xc487]
[    0.125752] pci 0000:00:07.0: supports D1 D2
[    0.125754] pci 0000:00:07.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.125781] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.125815] pci 0000:00:08.0: [10de:03f6] type 00 class 0x010185
[    0.125825] pci 0000:00:08.0: reg 0x10: [io  0xc400-0xc407]
[    0.125829] pci 0000:00:08.0: reg 0x14: [io  0xc080-0xc083]
[    0.125833] pci 0000:00:08.0: reg 0x18: [io  0xc000-0xc007]
[    0.125837] pci 0000:00:08.0: reg 0x1c: [io  0xbc00-0xbc03]
[    0.125841] pci 0000:00:08.0: reg 0x20: [io  0xb880-0xb88f]
[    0.125845] pci 0000:00:08.0: reg 0x24: [mem 0xfdd7c000-0xfdd7cfff]
[    0.125906] pci 0000:00:08.1: [10de:03f6] type 00 class 0x010185
[    0.125917] pci 0000:00:08.1: reg 0x10: [io  0xb800-0xb807]
[    0.125921] pci 0000:00:08.1: reg 0x14: [io  0xb480-0xb483]
[    0.125924] pci 0000:00:08.1: reg 0x18: [io  0xb400-0xb407]
[    0.125928] pci 0000:00:08.1: reg 0x1c: [io  0xb080-0xb083]
[    0.125932] pci 0000:00:08.1: reg 0x20: [io  0xb000-0xb00f]
[    0.125936] pci 0000:00:08.1: reg 0x24: [mem 0xfdd77000-0xfdd77fff]
[    0.126006] pci 0000:00:09.0: [10de:03e8] type 01 class 0x060400
[    0.126032] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.126058] pci 0000:00:09.0: System wakeup disabled by ACPI
[    0.126094] pci 0000:00:0b.0: [10de:03e9] type 01 class 0x060400
[    0.126117] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.126143] pci 0000:00:0b.0: System wakeup disabled by ACPI
[    0.126178] pci 0000:00:0c.0: [10de:03e9] type 01 class 0x060400
[    0.126202] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.126228] pci 0000:00:0c.0: System wakeup disabled by ACPI
[    0.126271] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    0.126327] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    0.126382] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    0.126435] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    0.126489] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    0.126583] pci 0000:01:06.0: [1106:3044] type 00 class 0x0c0010
[    0.126600] pci 0000:01:06.0: reg 0x10: [mem 0xfdeff800-0xfdefffff]
[    0.126607] pci 0000:01:06.0: reg 0x14: [io  0xdc00-0xdc7f]
[    0.126652] pci 0000:01:06.0: PME# supported from D3hot
[    0.126708] pci 0000:00:04.0: PCI bridge to [bus 01] (subtractive decode)
[    0.126711] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.126714] pci 0000:00:04.0:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.126717] pci 0000:00:04.0:   bridge window [io  0x0000-0x0cf7 window] (subtractive decode)
[    0.126719] pci 0000:00:04.0:   bridge window [io  0x0d00-0xffff window] (subtractive decode)
[    0.126721] pci 0000:00:04.0:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
[    0.126723] pci 0000:00:04.0:   bridge window [mem 0x000d0000-0x000dffff window] (subtractive decode)
[    0.126725] pci 0000:00:04.0:   bridge window [mem 0x80000000-0xdfffffff window] (subtractive decode)
[    0.126727] pci 0000:00:04.0:   bridge window [mem 0xf0000000-0xfebfffff window] (subtractive decode)
[    0.126761] pci 0000:02:00.0: [1002:68e1] type 00 class 0x030000
[    0.126779] pci 0000:02:00.0: reg 0x10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.126787] pci 0000:02:00.0: reg 0x18: [mem 0xfdfe0000-0xfdffffff 64bit]
[    0.126792] pci 0000:02:00.0: reg 0x20: [io  0xe000-0xe0ff]
[    0.126802] pci 0000:02:00.0: reg 0x30: [mem 0xfdfc0000-0xfdfdffff pref]
[    0.126823] pci 0000:02:00.0: supports D1 D2
[    0.126866] pci 0000:02:00.1: [1002:aa68] type 00 class 0x040300
[    0.126884] pci 0000:02:00.1: reg 0x10: [mem 0xfdfbc000-0xfdfbffff 64bit]
[    0.126923] pci 0000:02:00.1: supports D1 D2
[    0.132033] pci 0000:00:09.0: PCI bridge to [bus 02]
[    0.132041] pci 0000:00:09.0:   bridge window [io  0xe000-0xefff]
[    0.132044] pci 0000:00:09.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.132047] pci 0000:00:09.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.132101] pci 0000:00:0b.0: PCI bridge to [bus 03]
[    0.132137] pci 0000:00:0c.0: PCI bridge to [bus 04]
[    0.132140] pci 0000:00:0c.0:   bridge window [mem 0xfe000000-0xfe0fffff]
[    0.133631] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
[    0.133718] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[    0.133799] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[    0.133880] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.133963] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *10
[    0.134043] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *0, disabled.
[    0.134124] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[    0.134206] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[    0.134288] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *10
[    0.134370] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *11
[    0.134452] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *10
[    0.134533] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *5
[    0.134614] ACPI: PCI Interrupt Link [LMC9] (IRQs 20 21 22 23) *0, disabled.
[    0.134696] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.134777] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *5
[    0.134863] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *10
[    0.134950] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *11
[    0.135045] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[    0.135097] ACPI: Enabled 1 GPEs in block 00 to 1F
[    0.135239] vgaarb: setting as boot device: PCI:0000:02:00.0
[    0.135239] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.135239] vgaarb: loaded
[    0.135239] vgaarb: bridge control possible 0000:02:00.0
[    0.135239] SCSI subsystem initialized
[    0.135239] libata version 3.00 loaded.
[    0.135239] ACPI: bus type USB registered
[    0.135239] usbcore: registered new interface driver usbfs
[    0.135239] usbcore: registered new interface driver hub
[    0.135239] usbcore: registered new device driver usb
[    0.135239] PCI: Using ACPI for IRQ routing
[    0.141947] PCI: pci_cache_line_size set to 64 bytes
[    0.141986] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.141988] e820: reserve RAM buffer [mem 0x7ffc0000-0x7fffffff]
[    0.142117] NetLabel: Initializing
[    0.142119] NetLabel:  domain hash size = 128
[    0.142120] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.142132] NetLabel:  unlabeled traffic allowed by default
[    0.142159] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.142159] hpet0: at MMIO 0xfeff0000, IRQs 2, 8, 31
[    0.142159] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.144036] clocksource: Switched to clocksource hpet
[    0.151444] AppArmor: AppArmor Filesystem Enabled
[    0.151530] pnp: PnP ACPI init
[    0.151637] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.151997] pnp 00:01: [dma 0 disabled]
[    0.152086] pnp 00:01: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.153028] pnp 00:02: [dma 3]
[    0.153203] pnp 00:02: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.153849] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    0.153851] system 00:03: [io  0x0800-0x080f] has been reserved
[    0.153854] system 00:03: [io  0x4000-0x407f] could not be reserved
[    0.153856] system 00:03: [io  0x4080-0x40ff] has been reserved
[    0.153858] system 00:03: [io  0x4400-0x447f] has been reserved
[    0.153860] system 00:03: [io  0x4480-0x44ff] has been reserved
[    0.153862] system 00:03: [io  0x4800-0x487f] has been reserved
[    0.153864] system 00:03: [io  0x4880-0x48ff] has been reserved
[    0.153866] system 00:03: [io  0x4c00-0x4c7f] has been reserved
[    0.153868] system 00:03: [io  0x4c80-0x4cff] has been reserved
[    0.153871] system 00:03: [mem 0x000d0000-0x000d3fff window] has been reserved
[    0.153873] system 00:03: [mem 0x000d4000-0x000d7fff window] has been reserved
[    0.153875] system 00:03: [mem 0x000de000-0x000dffff window] has been reserved
[    0.153878] system 00:03: [mem 0xfec80000-0x1fd93ffff] could not be reserved
[    0.153880] system 00:03: [mem 0xfefe0000-0xfefe01ff] has been reserved
[    0.153882] system 00:03: [mem 0xfefe1000-0xfefe1fff] has been reserved
[    0.153884] system 00:03: [mem 0xfee01000-0xfeefffff] has been reserved
[    0.153887] system 00:03: [mem 0xffb80000-0xffffffff] could not be reserved
[    0.153890] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.154000] system 00:04: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.154002] system 00:04: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.154005] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.154167] system 00:05: [io  0x0a00-0x0a0f] has been reserved
[    0.154169] system 00:05: [io  0x0a10-0x0a1f] has been reserved
[    0.154171] system 00:05: [io  0x0a20-0x0a2f] has been reserved
[    0.154173] system 00:05: [io  0x0a30-0x0a3f] has been reserved
[    0.154176] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.154236] system 00:06: [mem 0xe0000000-0xefffffff] has been reserved
[    0.154239] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.154380] system 00:07: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.154382] system 00:07: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.154384] system 00:07: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.154386] system 00:07: [mem 0x00100000-0x7fffffff] could not be reserved
[    0.154388] system 00:07: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.154391] system 00:07: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.154616] pnp: PnP ACPI: found 8 devices
[    0.161527] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.161559] pci 0000:00:04.0: PCI bridge to [bus 01]
[    0.161562] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.161566] pci 0000:00:04.0:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.161572] pci 0000:00:09.0: PCI bridge to [bus 02]
[    0.161574] pci 0000:00:09.0:   bridge window [io  0xe000-0xefff]
[    0.161576] pci 0000:00:09.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.161579] pci 0000:00:09.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.161582] pci 0000:00:0b.0: PCI bridge to [bus 03]
[    0.161587] pci 0000:00:0c.0: PCI bridge to [bus 04]
[    0.161589] pci 0000:00:0c.0:   bridge window [mem 0xfe000000-0xfe0fffff]
[    0.161595] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.161597] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.161599] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.161601] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff window]
[    0.161602] pci_bus 0000:00: resource 8 [mem 0x80000000-0xdfffffff window]
[    0.161604] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff window]
[    0.161606] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.161608] pci_bus 0000:01: resource 1 [mem 0xfde00000-0xfdefffff]
[    0.161610] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7 window]
[    0.161612] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff window]
[    0.161614] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.161616] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff window]
[    0.161618] pci_bus 0000:01: resource 8 [mem 0x80000000-0xdfffffff window]
[    0.161620] pci_bus 0000:01: resource 9 [mem 0xf0000000-0xfebfffff window]
[    0.161622] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.161624] pci_bus 0000:02: resource 1 [mem 0xfdf00000-0xfdffffff]
[    0.161626] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.161628] pci_bus 0000:04: resource 1 [mem 0xfe000000-0xfe0fffff]
[    0.161670] NET: Registered protocol family 2
[    0.161866] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.161928] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.162014] TCP: Hash tables configured (established 16384 bind 16384)
[    0.162071] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.162087] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.162181] NET: Registered protocol family 1
[    0.162457] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 23
[    0.232324] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    0.232432] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.232475] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.232524] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.232571] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.232618] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.232668] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.232720] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.232774] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.232789] pci 0000:02:00.0: Video device with shadowed ROM
[    0.232793] PCI: CLS 64 bytes, default 64
[    0.232858] Trying to unpack rootfs image as initramfs...
[    0.843768] Freeing initrd memory: 37508K (ffff8800336ae000 - ffff880035b4f000)
[    0.844143] LVT offset 1 assigned for vector 0x400
[    0.844150] IBS: LVT offset 1 assigned
[    0.844178] perf: AMD IBS detected (0x0000001f)
[    0.844202] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2718bffdb7f, max_idle_ns: 440795277146 ns
[    0.844262] Scanning for low memory corruption every 60 seconds
[    0.844658] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.844705] audit: initializing netlink subsys (disabled)
[    0.844724] audit: type=2000 audit(1481888540.844:1): initialized
[    0.845041] Initialise system trusted keyring
[    0.845240] HugeTLB registered 1 GB page size, pre-allocated 0 pages
[    0.845245] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.846797] zbud: loaded
[    0.847169] VFS: Disk quotas dquot_6.6.0
[    0.847209] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.847478] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.847837] fuse init (API version 7.23)
[    0.848162] Key type big_key registered
[    0.848184] Allocating IMA MOK and blacklist keyrings.
[    0.848853] Key type asymmetric registered
[    0.848858] Asymmetric key parser 'x509' registered
[    0.848913] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
[    0.848965] io scheduler noop registered
[    0.848968] io scheduler deadline registered (default)
[    0.849004] io scheduler cfq registered
[    0.849317] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[    0.849319] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    0.849321] pci 0000:02:00.1: Signaling PME through PCIe PME interrupt
[    0.849323] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
[    0.849335] pcieport 0000:00:0b.0: Signaling PME through PCIe PME interrupt
[    0.849337] pcie_pme 0000:00:0b.0:pcie01: service driver pcie_pme loaded
[    0.849348] pcieport 0000:00:0c.0: Signaling PME through PCIe PME interrupt
[    0.849350] pcie_pme 0000:00:0c.0:pcie01: service driver pcie_pme loaded
[    0.849356] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.849362] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.849388] vesafb: mode is 1400x1050x32, linelength=5632, pages=0
[    0.849390] vesafb: scrolling: redraw
[    0.849391] vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
[    0.849409] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90000800000, using 5824k, total 5824k
[    0.849564] Console: switching to colour frame buffer device 175x65
[    0.849588] fb0: VESA VGA frame buffer device
[    0.849672] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.849676] ACPI: Power Button [PWRB]
[    0.849716] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.849718] ACPI: Power Button [PWRF]
[    0.850051] thermal LNXTHERM:00: registered as thermal_zone0
[    0.850053] ACPI: Thermal Zone [THRM] (30 C)
[    0.850084] GHES: HEST is not enabled!
[    0.850217] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.870563] 00:01: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.872463] Linux agpgart interface v0.103
[    0.876194] brd: module loaded
[    0.878223] loop: module loaded
[    0.878505] libphy: Fixed MDIO Bus: probed
[    0.878509] tun: Universal TUN/TAP device driver, 1.6
[    0.878510] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.878625] PPP generic driver version 2.4.2
[    0.878739] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.878748] ehci-pci: EHCI PCI platform driver
[    0.878883] ehci-pci 0000:00:02.1: EHCI Host Controller
[    0.878889] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus number 1
[    0.878899] ehci-pci 0000:00:02.1: debug port 1
[    0.878928] ehci-pci 0000:00:02.1: cache line size of 64 is not supported
[    0.878948] ehci-pci 0000:00:02.1: irq 22, io mem 0xfdd7ec00
[    0.888066] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    0.888125] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.888127] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.888129] usb usb1: Product: EHCI Host Controller
[    0.888131] usb usb1: Manufacturer: Linux 4.4.0-53-generic ehci_hcd
[    0.888132] usb usb1: SerialNumber: 0000:00:02.1
[    0.888355] hub 1-0:1.0: USB hub found
[    0.888365] hub 1-0:1.0: 10 ports detected
[    0.888572] ehci-platform: EHCI generic platform driver
[    0.888590] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.888599] ohci-pci: OHCI PCI platform driver
[    0.888716] ohci-pci 0000:00:02.0: OHCI PCI host controller
[    0.888722] ohci-pci 0000:00:02.0: new USB bus registered, assigned bus number 2
[    0.888754] ohci-pci 0000:00:02.0: irq 23, io mem 0xfdd7f000
[    0.946105] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.946109] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.946111] usb usb2: Product: OHCI PCI host controller
[    0.946113] usb usb2: Manufacturer: Linux 4.4.0-53-generic ohci_hcd
[    0.946114] usb usb2: SerialNumber: 0000:00:02.0
[    0.946331] hub 2-0:1.0: USB hub found
[    0.946339] hub 2-0:1.0: 10 ports detected
[    0.946542] ohci-platform: OHCI generic platform driver
[    0.946557] uhci_hcd: USB Universal Host Controller Interface driver
[    0.946633] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.947073] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.947078] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.947312] mousedev: PS/2 mouse device common for all mice
[    0.947501] rtc_cmos 00:00: RTC can wake from S4
[    0.947691] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    0.947732] rtc_cmos 00:00: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    0.947740] i2c /dev entries driver
[    0.947801] device-mapper: uevent: version 1.0.3
[    0.947906] device-mapper: ioctl: 4.34.0-ioctl (2015-10-28) initialised: dm-devel@redhat.com
[    0.947923] ledtrig-cpu: registered to indicate activity on CPUs
[    0.948373] NET: Registered protocol family 10
[    0.948736] NET: Registered protocol family 17
[    0.948754] Key type dns_resolver registered
[    0.949064] microcode: CPU0: patch_level=0x010000b7
[    0.949073] microcode: CPU1: patch_level=0x010000b7
[    0.949142] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.949337] registered taskstats version 1
[    0.949353] Loading compiled-in X.509 certificates
[    0.950407] Loaded X.509 cert 'Build time autogenerated kernel key: e9dbd2fef92418dc580496786c7b3d419aa7d17d'
[    0.950427] zswap: loaded using pool lzo/zbud
[    0.952829] Key type trusted registered
[    0.957057] Key type encrypted registered
[    0.957070] AppArmor: AppArmor sha1 policy hashing enabled
[    0.957075] ima: No TPM chip found, activating TPM-bypass!
[    0.957133] evm: HMAC attrs: 0x1
[    0.957386]   Magic number: 12:90:732
[    0.957508] rtc_cmos 00:00: setting system clock to 2016-12-16 11:42:21 UTC (1481888541)
[    0.957611] acpi-cpufreq: overriding BIOS provided _PSD data
[    0.957687] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.957688] EDD information not available.
[    0.957745] PM: Hibernation image not present or could not be loaded.
[    0.959411] Freeing unused kernel memory: 1480K (ffffffff81f43000 - ffffffff820b5000)
[    0.959415] Write protecting the kernel read-only data: 14336k
[    0.960470] Freeing unused kernel memory: 1800K (ffff88000183e000 - ffff880001a00000)
[    0.960915] Freeing unused kernel memory: 140K (ffff880001ddd000 - ffff880001e00000)
[    0.978332] random: systemd-udevd: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    0.978419] random: systemd-udevd: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    0.978433] random: systemd-udevd: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    0.979325] random: udevadm: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    0.979387] random: udevadm: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    0.979550] random: udevadm: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    0.979603] random: udevadm: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    0.979657] random: udevadm: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    0.979709] random: udevadm: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    0.979759] random: udevadm: uninitialized urandom read (16 bytes read, 2 bits of entropy available)
[    1.018994] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 19
[    1.021769] pata_amd 0000:00:06.0: version 0.4.1
[    1.031498] scsi host0: pata_amd
[    1.031612] scsi host1: pata_amd
[    1.031657] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.031660] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.031705] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    1.031931] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 21
[    1.047633] [drm] Initialized drm 1.1.0 20060810
[    1.082369] [drm] radeon kernel modesetting enabled.
[    1.082452] firewire_ohci 0000:01:06.0: added OHCI v1.0 device as card 0, 4 IR + 8 IT contexts, quirks 0x41
[    1.106064] FUJITSU Extended Socket Network Device Driver - version 1.0 - Copyright (c) 2015 FUJITSU LIMITED
[    1.159401] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[    1.159406] AMD IOMMUv2 functionality not available on this system
[    1.162753] CRAT table not found
[    1.162757] Finished initializing topology ret=0
[    1.162807] kfd kfd: Initialized module
[    1.163065] checking generic (d0000000 5b0000) vs hw (d0000000 10000000)
[    1.163068] fb: switching to radeondrmfb from VESA VGA
[    1.163103] Console: switching to colour dummy device 80x25
[    1.163412] ACPI: PCI Interrupt Link [LNED] enabled at IRQ 18
[    1.163566] [drm] initializing kernel modesetting (CEDAR 0x1002:0x68E1 0x1787:0x3000).
[    1.163577] [drm] register mmio base: 0xFDFE0000
[    1.163578] [drm] register mmio size: 131072
[    1.164251] ATOM BIOS: PARK
[    1.164301] radeon 0000:02:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    1.164303] radeon 0000:02:00.0: GTT: 1024M 0x0000000040000000 - 0x000000007FFFFFFF
[    1.164305] [drm] Detected VRAM RAM=1024M, BAR=256M
[    1.164307] [drm] RAM width 64bits DDR
[    1.164364] [TTM] Zone  kernel: Available graphics memory: 1023788 kiB
[    1.164365] [TTM] Initializing pool allocator
[    1.164371] [TTM] Initializing DMA pool allocator
[    1.164392] [drm] radeon: 1024M of VRAM memory ready
[    1.164393] [drm] radeon: 1024M of GTT memory ready.
[    1.164409] [drm] Loading CEDAR Microcode
[    1.164497] [drm] Internal thermal controller with fan control
[    1.193040] [drm] radeon: dpm initialized
[    1.193175] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    1.211443] [drm] PCIE GART of 1024M enabled (table at 0x000000000025E000).
[    1.211537] radeon 0000:02:00.0: WB enabled
[    1.211541] radeon 0000:02:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff8800346edc00
[    1.211543] radeon 0000:02:00.0: fence driver on ring 3 use gpu addr 0x0000000040000c0c and cpu addr 0xffff8800346edc0c
[    1.212307] radeon 0000:02:00.0: fence driver on ring 5 use gpu addr 0x000000000005c418 and cpu addr 0xffffc9000101c418
[    1.212396] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.212397] [drm] Driver supports precise vblank timestamp query.
[    1.212399] radeon 0000:02:00.0: radeon: MSI limited to 32-bit
[    1.212434] radeon 0000:02:00.0: radeon: using MSI.
[    1.212457] [drm] radeon: irq initialized.
[    1.228516] [drm] ring test on 0 succeeded in 1 usecs
[    1.228521] [drm] ring test on 3 succeeded in 2 usecs
[    1.304087] ata2: port disabled--ignoring
[    1.414238] [drm] ring test on 5 succeeded in 1 usecs
[    1.414246] [drm] UVD initialized successfully.
[    1.414406] [drm] ib test on ring 0 succeeded in 0 usecs
[    1.414432] [drm] ib test on ring 3 succeeded in 0 usecs
[    1.556568] forcedeth 0000:00:07.0: ifname eth0, PHY OUI 0x50ef @ 1, addr 44:87:fc:5f:02:27
[    1.556574] forcedeth 0000:00:07.0: highdma pwrctl mgmt lnktim msi desc-v3
[    1.556725] sata_nv 0000:00:08.0: version 3.5
[    1.556939] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 20
[    1.557874] forcedeth 0000:00:07.0 enp0s7: renamed from eth0
[    1.558545] scsi host2: sata_nv
[    1.558756] scsi host3: sata_nv
[    1.558801] ata3: SATA max UDMA/133 cmd 0xc400 ctl 0xc080 bmdma 0xb880 irq 20
[    1.558803] ata4: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb888 irq 20
[    1.559041] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 23
[    1.559754] scsi host4: sata_nv
[    1.559939] scsi host5: sata_nv
[    1.559982] ata5: SATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb000 irq 23
[    1.559984] ata6: SATA max UDMA/133 cmd 0xb400 ctl 0xb080 bmdma 0xb008 irq 23
[    1.664194] firewire_core 0000:01:06.0: created device fw0: GUID ff2584e39b078a2e, S400
[    1.716055] usb 2-3: new low-speed USB device number 2 using ohci-pci
[    1.972275] usb 2-3: New USB device found, idVendor=040b, idProduct=2013
[    1.972280] usb 2-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    1.972282] usb 2-3: Product: 2.4HGzkeyboard and mouse
[    1.979211] hidraw: raw HID events driver (C) Jiri Kosina
[    2.005581] usbcore: registered new interface driver usbhid
[    2.005585] usbhid: USB HID core driver
[    2.007583] input: 2.4HGzkeyboard and mouse as /devices/pci0000:00/0000:00:02.0/usb2/2-3/2-3:1.0/0003:040B:2013.0001/input/input5
[    2.032088] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.032093] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.040190] ata5.00: ATAPI: TSSTcorp CDDVDW SH-S223C, SB06, max UDMA/100
[    2.040490] ata3.00: ATA-8: ST500DM002-1BD142, KC48, max UDMA/133
[    2.040494] ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.056190] ata5.00: configured for UDMA/100
[    2.056484] ata3.00: configured for UDMA/133
[    2.056792] scsi 2:0:0:0: Direct-Access     ATA      ST500DM002-1BD14 KC48 PQ: 0 ANSI: 5
[    2.057237] sd 2:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/466 GiB)
[    2.057241] sd 2:0:0:0: [sda] 4096-byte physical blocks
[    2.057265] sd 2:0:0:0: [sda] Write Protect is off
[    2.057268] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.057279] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.057699] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    2.060381] hid-generic 0003:040B:2013.0001: input,hidraw0: USB HID v1.10 Keyboard [2.4HGzkeyboard and mouse] on usb-0000:00:02.0-3/input0
[    2.060807] input: 2.4HGzkeyboard and mouse as /devices/pci0000:00/0000:00:02.0/usb2/2-3/2-3:1.1/0003:040B:2013.0002/input/input6
[    2.084096] [drm] ib test on ring 5 succeeded
[    2.085727] [drm] Radeon Display Connectors
[    2.085731] [drm] Connector 0:
[    2.085732] [drm]   HDMI-A-1
[    2.085733] [drm]   HPD2
[    2.085735] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 0x646c
[    2.085736] [drm]   Encoders:
[    2.085737] [drm]     DFP1: INTERNAL_UNIPHY1
[    2.085738] [drm] Connector 1:
[    2.085739] [drm]   DVI-I-1
[    2.085740] [drm]   HPD4
[    2.085742] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 0x644c
[    2.085742] [drm]   Encoders:
[    2.085743] [drm]     DFP2: INTERNAL_UNIPHY
[    2.085745] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    2.085745] [drm] Connector 2:
[    2.085746] [drm]   VGA-1
[    2.085748] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[    2.085749] [drm]   Encoders:
[    2.085750] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    2.116821] hid-generic 0003:040B:2013.0002: input,hiddev0,hidraw1: USB HID v1.10 Mouse [2.4HGzkeyboard and mouse] on usb-0000:00:02.0-3/input1
[    2.120962]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
[    2.121928] sd 2:0:0:0: [sda] Attached SCSI disk
[    2.162709] [drm] fb mappable at 0xD045F000
[    2.162711] [drm] vram apper at 0xD0000000
[    2.162712] [drm] size 8294400
[    2.162713] [drm] fb depth is 24
[    2.162714] [drm]    pitch is 7680
[    2.162821] fbcon: radeondrmfb (fb0) is primary device
[    2.162920] Console: switching to colour frame buffer device 240x67
[    2.162955] radeon 0000:02:00.0: fb0: radeondrmfb frame buffer device
[    2.172174] [drm] Initialized radeon 2.43.0 20080528 for 0000:02:00.0 on minor 0
[    2.524073] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.548377] ata4.00: ATA-8: Hitachi HDT721025SLA380, STBOA3AA, max UDMA/133
[    2.548382] ata4.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.564376] ata4.00: configured for UDMA/133
[    2.564704] scsi 3:0:0:0: Direct-Access     ATA      Hitachi HDT72102 A3AA PQ: 0 ANSI: 5
[    2.565179] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    2.565241] sd 3:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/233 GiB)
[    2.565305] sd 3:0:0:0: [sdb] Write Protect is off
[    2.565308] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.565324] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.566925] scsi 4:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S223C  SB06 PQ: 0 ANSI: 5
[    2.583062] sr 4:0:0:0: [sr0] scsi3-mmc drive: 52x/52x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.583067] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.583246] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    2.583564] sr 4:0:0:0: Attached scsi generic sg2 type 5
[    2.590442] sd 3:0:0:0: [sdb] Attached SCSI disk
[    2.902320] ata6: SATA link down (SStatus 0 SControl 300)
[    4.140100] floppy0: no floppy controllers found
[    4.266145] microcode: CPU0: new patch_level=0x010000c7
[    4.266168] microcode: CPU1: new patch_level=0x010000c7
[    4.336038] raid6: sse2x1   gen()  3543 MB/s
[    4.404019] raid6: sse2x1   xor()  3763 MB/s
[    4.472027] raid6: sse2x2   gen()  6232 MB/s
[    4.540016] raid6: sse2x2   xor()  6112 MB/s
[    4.608024] raid6: sse2x4   gen()  7120 MB/s
[    4.676015] raid6: sse2x4   xor()  3855 MB/s
[    4.676016] raid6: using algorithm sse2x4 gen() 7120 MB/s
[    4.676018] raid6: .... xor() 3855 MB/s, rmw enabled
[    4.676020] raid6: using intx1 recovery algorithm
[    4.677557] xor: measuring software checksum speed
[    4.716017]    prefetch64-sse: 10441.000 MB/sec
[    4.756016]    generic_sse: 10041.000 MB/sec
[    4.756018] xor: using function: prefetch64-sse (10441.000 MB/sec)
[    4.774106] Btrfs loaded
[    4.953147] random: nonblocking pool is initialized
[    5.300536] BTRFS: device fsid 45b03ab1-cf2e-46db-b3e1-9e170d916701 devid 2 transid 2551 /dev/sdb
[    5.300857] BTRFS: device fsid 45b03ab1-cf2e-46db-b3e1-9e170d916701 devid 1 transid 2551 /dev/sda7
[    5.517290] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    6.322436] systemd[1]: systemd 229 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN)
[    6.322583] systemd[1]: Detected architecture x86-64.
[    6.332447] systemd[1]: Set hostname to <lollo>.
[    7.513689] systemd[1]: Listening on Journal Audit Socket.
[    7.513757] systemd[1]: PNFS blkmaping enablement. is not active.
[    7.513842] systemd[1]: Dependency failed for pNFS block layout mapping daemon.
[    7.513871] systemd[1]: nfs-blkmap.service: Job nfs-blkmap.service/start failed with result 'dependency'.
[    7.513887] systemd[1]: Reached target Encrypted Volumes.
[    7.513947] systemd[1]: Listening on udev Kernel Socket.
[    7.514016] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    7.514080] systemd[1]: Listening on udev Control Socket.
[    7.514159] systemd[1]: Listening on Journal Socket.
[    7.514214] systemd[1]: Listening on fsck to fsckd communication Socket.
[    7.514359] systemd[1]: Created slice User and Session Slice.
[    7.514447] systemd[1]: Created slice System Slice.
[    7.524202] systemd[1]: Mounting NFSD configuration filesystem...
[    7.525061] systemd[1]: Started Read required files in advance.
[    7.525428] systemd[1]: Reached target Slices.
[    7.526252] systemd[1]: Mounting Huge Pages File System...
[    7.526628] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[    7.527387] systemd[1]: Mounting RPC Pipe File System...
[    7.528463] systemd[1]: Started Braille Device Support.
[    7.529520] systemd[1]: Starting Uncomplicated firewall...
[    7.529880] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    7.636300] systemd[1]: Starting Set console keymap...
[    7.636522] systemd[1]: Listening on Journal Socket (/dev/log).
[    7.708299] systemd[1]: Starting Load Kernel Modules...
[    7.709215] systemd[1]: Starting Nameserver information manager...
[    7.709336] systemd[1]: Reached target User and Group Name Lookups.
[    7.710274] systemd[1]: Mounting Debug File System...
[    7.711410] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    7.712496] systemd[1]: Mounting POSIX Message Queue File System...
[    7.712723] systemd[1]: Listening on Syslog Socket.
[    7.713730] systemd[1]: Starting Journal Service...
[    7.713898] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    7.746479] systemd[1]: Started Uncomplicated firewall.
[    7.899178] systemd[1]: Started Create list of required static device nodes for the current kernel.
[    7.908365] systemd[1]: Starting Create Static Device Nodes in /dev...
[    7.972505] systemd[1]: Mounted Huge Pages File System.
[    7.972713] systemd[1]: Mounted Debug File System.
[    7.972822] systemd[1]: Mounted POSIX Message Queue File System.
[    8.052316] systemd[1]: Started Nameserver information manager.
[    8.166582] lp: driver loaded but no devices found
[    8.184238] ppdev: user-space parallel port driver
[    8.233424] parport_pc 00:02: reported by Plug and Play ACPI
[    8.233519] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    8.307100] RPC: Registered named UNIX socket transport module.
[    8.307104] RPC: Registered udp transport module.
[    8.307106] RPC: Registered tcp transport module.
[    8.307107] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    8.308228] systemd[1]: Mounted RPC Pipe File System.
[    8.328293] lp0: using parport0 (interrupt-driven).
[    8.377140] systemd[1]: Started Load Kernel Modules.
[    8.389321] systemd[1]: Mounting FUSE Control File System...
[    8.390215] systemd[1]: Starting Apply Kernel Variables...
[    8.394334] systemd[1]: Mounted FUSE Control File System.
[    8.580264] systemd[1]: Started Journal Service.
[    8.635937] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    9.475069] EXT4-fs (sda5): re-mounted. Opts: errors=remount-ro
[    9.541182] systemd-journald[271]: Received request to flush runtime journal from PID 1
[    9.998851] i2c i2c-8: nForce2 SMBus adapter at 0x4d00
[    9.999328] i2c i2c-9: nForce2 SMBus adapter at 0x4e00
[   10.179229] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   10.287762] EDAC MC: Ver: 3.0.0
[   10.382118] MCE: In-kernel MCE decoding enabled.
[   10.439471] AMD64 EDAC driver v3.4.0
[   10.439513] EDAC amd64: DRAM ECC disabled.
[   10.439519] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
                Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
                (Note that use of the override may cause unknown side effects.)
[   10.494878] MPU-401 device not found or device busy
[   10.529008] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 22
[   10.529022] snd_hda_intel 0000:00:05.0: Disabling MSI
[   10.529282] ACPI: PCI Interrupt Link [LNEA] enabled at IRQ 17
[   10.529305] snd_hda_intel 0000:02:00.1: Handle vga_switcheroo audio client
[   10.603049] input: HDA ATI HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:09.0/0000:02:00.1/sound/card1/input7
[   10.950852] kvm: Nested Virtualization enabled
[   10.950860] kvm: Nested Paging enabled
[   11.264062] snd_hda_codec_realtek hdaudioC0D0: ignore pin 0x1b with mismatching assoc# 0x2 vs 0x1
[   11.272078] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC662 rev1: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[   11.272085] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   11.272087] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   11.272089] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[   11.272091] snd_hda_codec_realtek hdaudioC0D0:    dig-out=0x1e/0x0
[   11.272092] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[   11.272095] snd_hda_codec_realtek hdaudioC0D0:      Front Mic=0x19
[   11.272097] snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=0x18
[   11.272099] snd_hda_codec_realtek hdaudioC0D0:      Line=0x1a
[   11.843283] Adding 1473532k swap on /dev/sda2.  Priority:-1 extents:1 across:1473532k FS
[   12.597470] EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem
[   12.664738] input: HDA NVidia Front Mic as /devices/pci0000:00/0000:00:05.0/sound/card0/input8
[   12.664880] input: HDA NVidia Rear Mic as /devices/pci0000:00/0000:00:05.0/sound/card0/input9
[   12.664989] input: HDA NVidia Line as /devices/pci0000:00/0000:00:05.0/sound/card0/input10
[   12.665093] input: HDA NVidia Line Out as /devices/pci0000:00/0000:00:05.0/sound/card0/input11
[   12.700905] EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
[   12.865384] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[   12.924099] floppy0: no floppy controllers found
[   14.634096] audit: type=1400 audit(1481888555.172:2): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/sbin/dhclient" pid=654 comm="apparmor_parser"
[   14.634107] audit: type=1400 audit(1481888555.172:3): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=654 comm="apparmor_parser"
[   14.634112] audit: type=1400 audit(1481888555.172:4): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=654 comm="apparmor_parser"
[   14.634116] audit: type=1400 audit(1481888555.172:5): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/connman/scripts/dhclient-script" pid=654 comm="apparmor_parser"
[   14.646689] audit: type=1400 audit(1481888555.184:6): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/lightdm/lightdm-guest-session" pid=653 comm="apparmor_parser"
[   14.646703] audit: type=1400 audit(1481888555.184:7): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/lightdm/lightdm-guest-session//chromium" pid=653 comm="apparmor_parser"
[   14.678115] audit: type=1400 audit(1481888555.216:8): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/ubuntu-core-launcher" pid=657 comm="apparmor_parser"
[   14.701825] audit: type=1400 audit(1481888555.240:9): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/sbin/cups-browsed" pid=658 comm="apparmor_parser"
[   14.716775] audit: type=1400 audit(1481888555.256:10): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/cups/backend/cups-pdf" pid=659 comm="apparmor_parser"
[   14.716787] audit: type=1400 audit(1481888555.256:11): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/sbin/cupsd" pid=659 comm="apparmor_parser"
[   18.631685] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   18.640967] NFSD: starting 90-second grace period (net ffffffff81ef4680)
[   19.290894] IPv6: ADDRCONF(NETDEV_UP): enp0s7: link is not ready
[   19.291445] forcedeth 0000:00:07.0 enp0s7: MSI enabled
[  964.130826] FS-Cache: Loaded
[  964.153610] FS-Cache: Netfs 'nfs' registered for caching
[  964.189235] NFS: Registering the id_resolver key type
[  964.189258] Key type id_resolver registered
[  964.189260] Key type id_legacy registered

--MP_/vZ5wlG./kdSTb368emjF2oZ--
