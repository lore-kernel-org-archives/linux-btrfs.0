Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:44652 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab3HVGrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 02:47:49 -0400
Received: by mail-qa0-f44.google.com with SMTP id hu16so136437qab.3
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 23:47:48 -0700 (PDT)
From: Nicholas Lee <email@nickle.es>
Content-Type: text/plain; charset=us-ascii
Subject: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
Message-Id: <79471CD1-CDDD-4EDD-B255-40568B8446E2@nickle.es>
Date: Thu, 22 Aug 2013 02:47:38 -0400
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list! I recently butchered my filesystem, and I was wondering if anyone knows how to help.

Problem: My filesystem is screwed up, and I can't mount it at all right now. In the logs, the problem begins around 45s. 

Background: I'm running a 6x4TB RAID5 array using md. I have a few virtual machines using said array, and one of them is a btrfs storage server. I ran into some issues where FS errors would cause the host system to enter a read-only state, which led to the corruption of the guest's file system. Adding insult to injury, this occurred right as I began the initial backup to another system with rsync. :(

What I've done so far: I've made a few attempts to mount the partition in read-only recovery mode to no avail. I created another virtual disk and installed ArchBang to use as a recovery environment. I also tried running find-root, but I got no console output after two days of it running, and it just sat there burning CPU time. 

I would be seriously grateful to anyone that can figure out a way to mount/fix this partition, and I'd be willing to send some bitcoin over to anyone that can help me get partition mounted and/or repaired!


dmesg's output:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.8-1-ARCH (tobias@testing-i686) (gcc version 4.8.1 (GCC) ) #1 SMP PREEMPT Fri Jun 28 07:43:59 CEST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fffe000-0x000000007fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x7fffe max_arch_pfn = 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] found SMP MP-table at [mem 0x000fdaa0-0x000fdaaf] mapped at [c00fdaa0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x00bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37000000-0x373fffff]
[    0.000000]  [mem 0x37000000-0x373fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x30000000-0x36ffffff]
[    0.000000]  [mem 0x30000000-0x36ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x2fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x2fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37400000-0x377fdfff]
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] BRK [0x0083e000, 0x0083efff] PGTABLE
[    0.000000] RAMDISK: [mem 0x7eff7000-0x7ffdcfff]
[    0.000000] Allocated new RAMDISK: [mem 0x36818000-0x377fdb2f]
[    0.000000] Move RAMDISK from [mem 0x7eff7000-0x7ffdcb2f] to [mem 0x36818000-0x377fdb2f]
[    0.000000] ACPI: RSDP 000fd8c0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 7fffe380 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 7fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 7fffe3c0 011A9 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 7fffff40 00040
[    0.000000] ACPI: SSDT 7ffff6e0 00858 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 7ffff5b0 00090 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 7ffff570 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1160MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:36817001, boot clock
[    0.000000] BRK [0x0083f000, 0x0083ffff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x7fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x7fffdfff]
[    0.000000] On node 0 totalpages: 524188
[    0.000000] free_area_init_node: node 0, pgdat c06aeb00, node_mem_map f5817020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 223230 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2320 pages used for memmap
[    0.000000]   HighMem zone: 296960 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x80000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f57d3000 s33280 r0 d24064 u57344
[    0.000000] pcpu-alloc: s33280 r0 d24064 u57344 alloc=14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] kvm-clock: cpu 0, msr 0:36817001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 357d58c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 522412
[    0.000000] Kernel command line: archisobasedir=arch archisolabel=ARCH_201307 initrd=boot/i686/archiso.img BOOT_IMAGE=boot/i686/vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] allocated 4194280 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:0007fffe)
[    0.000000] Memory: 2051424k/2097144k available (4178k kernel code, 45328k reserved, 1705k data, 572k init, 1187840k highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc06bf000 - 0xc074e000   ( 572 kB)
      .data : 0xc0514854 - 0xc06bee00   (1705 kB)
      .text : 0xc0100000 - 0xc0514854   (4178 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:2304 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f4c08000 soft=f4c0a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3292.518 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 6587.41 BogoMIPS (lpj=10975060)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006666] Security Framework initialized
[    0.006666] AppArmor: AppArmor disabled by boot time parameter
[    0.006666] Mount-cache hash table entries: 512
[    0.006666] Initializing cgroup subsys cpuacct
[    0.006666] Initializing cgroup subsys memory
[    0.006666] Initializing cgroup subsys devices
[    0.006666] Initializing cgroup subsys freezer
[    0.006666] Initializing cgroup subsys net_cls
[    0.006666] Initializing cgroup subsys blkio
[    0.006666] mce: CPU supports 10 MCE banks
[    0.006666] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
tlb_flushall_shift: 6
[    0.006666] Freeing SMP alternatives: 16k freed
[    0.006666] ACPI: Core revision 20130117
[    0.006666] ACPI: All ACPI Tables successfully acquired
[    0.006666] ftrace: allocating 18432 entries in 37 pages
[    0.010116] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.010906] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.010908] smpboot: CPU0: Intel QEMU Virtual CPU version 1.4.0 (fam: 06, model: 02, stepping: 03)
[    0.013333] Performance Events: unsupported p6 CPU model 2 no PMU driver, software events only.
[    0.040094] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.046786] CPU 1 irqstacks, hard=f4cde000 soft=f4ce0000
[    0.003333] Initializing CPU#1
[    0.006666] kvm-clock: cpu 1, msr 0:36817041, secondary cpu clock
[    0.063354] KVM setup async PF for cpu 1
[    0.063362] kvm-stealtime: cpu 1, msr 357e38c0
[    0.046788] smpboot: Booting Node   0, Processors  #1
[    0.070133] CPU 2 irqstacks, hard=f4d00000 soft=f4d02000
[    0.003333] Initializing CPU#2
[    0.006666] kvm-clock: cpu 2, msr 0:36817081, secondary cpu clock
[    0.086699] KVM setup async PF for cpu 2
[    0.086707] kvm-stealtime: cpu 2, msr 357f18c0
[    0.070136]  #2
[    0.093456] CPU 3 irqstacks, hard=f4d1e000 soft=f4d20000
[    0.093458]  #3 OK
[    0.003333] Initializing CPU#3
[    0.006666] kvm-clock: cpu 3, msr 0:368170c1, secondary cpu clock
[    0.110048] Brought up 4 CPUs
[    0.110040] KVM setup async PF for cpu 3
[    0.110053] smpboot: Total of 4 processors activated (26350.65 BogoMIPS)
[    0.110046] kvm-stealtime: cpu 3, msr 357ff8c0
[    0.110459] devtmpfs: initialized
[    0.111181] RTC time: 16:07:43, date: 08/19/13
[    0.111287] NET: Registered protocol family 16
[    0.113779] ACPI: bus type PCI registered
[    0.113779] PCI: PCI BIOS revision 2.10 entry at 0xfc6d2, last bus=0
[    0.113779] PCI: Using configuration type 1 for base access
[    0.114146] bio: create slab <bio-0> at 0
[    0.114146] ACPI: Added _OSI(Module Device)
[    0.114146] ACPI: Added _OSI(Processor Device)
[    0.114146] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.114146] ACPI: Added _OSI(Processor Aggregator Device)
[    0.114146] ACPI: EC: Look up EC in DSDT
[    0.115243] ACPI: Interpreter enabled
[    0.115253] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.115259] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.115272] ACPI: (supports S0 S3 S4 S5)
[    0.115274] ACPI: Using IOAPIC for interrupt routing
[    0.115292] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.119342] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.119405] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.119423] PCI host bridge to bus 0000:00
[    0.119426] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.119427] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.119429] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.119430] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.119431] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.119461] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.119803] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.120406] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.126673] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.129217] pci 0000:00:01.2: [8086:7020] type 00 class 0x0c0300
[    0.135153] pci 0000:00:01.2: reg 20: [io  0xc140-0xc15f]
[    0.137387] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.137613] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.137620] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.137743] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.141248] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.143352] pci 0000:00:02.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.155789] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.155975] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.157849] pci 0000:00:03.0: reg 10: [io  0xc160-0xc17f]
[    0.160004] pci 0000:00:03.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.172317] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.172570] pci 0000:00:04.0: [8086:2922] type 00 class 0x010601
[    0.183339] pci 0000:00:04.0: reg 20: [io  0xc180-0xc19f]
[    0.186672] pci 0000:00:04.0: reg 24: [mem 0xfebf4000-0xfebf4fff]
[    0.189288] pci 0000:00:05.0: [1000:0012] type 00 class 0x010000
[    0.191743] pci 0000:00:05.0: reg 10: [io  0xc000-0xc0ff]
[    0.195064] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf53ff]
[    0.198385] pci 0000:00:05.0: reg 18: [mem 0xfebf0000-0xfebf1fff]
[    0.216805] pci 0000:00:06.0: [1af4:1002] type 00 class 0x00ff00
[    0.218000] pci 0000:00:06.0: reg 10: [io  0xc1a0-0xc1bf]
[    0.226885] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.229230] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    0.231224] pci 0000:00:07.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.243591] pci_bus 0000:00: on NUMA node 0
[    0.243599] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.243601] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.244007] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.244075] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.244131] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.244186] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.244218] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.244435] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.244439] acpi root: \_SB_.PCI0 notify handler is installed
[    0.244453] Found 1 acpi root devices
[    0.244662] ACPI: No dock devices found.
[    0.244746] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.244747] vgaarb: loaded
[    0.244748] vgaarb: bridge control possible 0000:00:02.0
[    0.244785] PCI: Using ACPI for IRQ routing
[    0.244788] PCI: pci_cache_line_size set to 64 bytes
[    0.244902] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.244904] e820: reserve RAM buffer [mem 0x7fffe000-0x7fffffff]
[    0.245016] NetLabel: Initializing
[    0.245017] NetLabel:  domain hash size = 128
[    0.245018] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.245030] NetLabel:  unlabeled traffic allowed by default
[    0.245082] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.245097] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.245101] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.253408] Switching to clocksource kvm-clock
[    0.258121] pnp: PnP ACPI init
[    0.258136] ACPI: bus type PNP registered
[    0.258228] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.258280] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.258321] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.258364] pnp 00:03: [dma 2]
[    0.258381] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.258480] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.258602] pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.258708] pnp: PnP ACPI: found 6 devices
[    0.258710] ACPI: bus type PNP unregistered
[    0.294865] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.294868] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.294870] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.294872] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.294928] NET: Registered protocol family 2
[    0.295077] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.295108] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.295132] TCP: Hash tables configured (established 8192 bind 8192)
[    0.295164] TCP: reno registered
[    0.295166] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.295173] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.295229] NET: Registered protocol family 1
[    0.295240] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.295256] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.295270] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.295448] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.296138] pci 0000:00:02.0: Boot video device
[    0.296172] PCI: CLS 0 bytes, default 64
[    0.296214] Unpacking initramfs...
[    1.880352] Freeing initrd memory: 16280k freed
[    1.882125] apm: BIOS not found.
[    1.882163] Scanning for low memory corruption every 60 seconds
[    1.882334] audit: initializing netlink socket (disabled)
[    1.882348] type=2000 audit(1376928464.879:1): initialized
[    1.890622] bounce pool size: 64 pages
[    1.890637] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.891711] VFS: Disk quotas dquot_6.5.2
[    1.891747] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.891878] msgmni has been set to 1718
[    1.892518] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.892603] io scheduler noop registered
[    1.892607] io scheduler deadline registered
[    1.892636] io scheduler cfq registered (default)
[    1.892754] intel_idle: does not run on family 6 model 2
[    1.892769] GHES: HEST is not enabled!
[    1.892776] isapnp: Scanning for PnP cards...
[    2.252145] isapnp: No Plug & Play device found
[    2.252216] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.273542] 00:04: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.273919] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.274659] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.274694] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.274936] mousedev: PS/2 mouse device common for all mice
[    2.275033] rtc_cmos 00:00: RTC can wake from S4
[    2.275480] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.275715] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet irqs
[    2.275747] cpuidle: using governor ladder
[    2.275749] cpuidle: using governor menu
[    2.275751] EFI Variables Facility v0.08 2004-May-17
[    2.275796] drop_monitor: Initializing network drop monitor service
[    2.275936] TCP: cubic registered
[    2.276086] NET: Registered protocol family 10
[    2.276360] NET: Registered protocol family 17
[    2.276377] Key type dns_resolver registered
[    2.276785] Using IPI No-Shortcut mode
[    2.277055] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.277112] PM: Hibernation image not present or could not be loaded.
[    2.277130] registered taskstats version 1
[    2.277773]   Magic number: 9:202:136
[    2.277780] misc autofs: hash matches
[    2.278007] rtc_cmos 00:00: setting system clock to 2013-08-19 16:07:46 UTC (1376928466)
[    2.278357] Freeing unused kernel memory: 572k freed
[    2.278579] Write protecting the kernel text: 4180k
[    2.278656] Write protecting the kernel read-only data: 1300k
[    2.289664] systemd-udevd[56]: starting version 204
[    2.321595] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.321605] ACPI: Power Button [PWRF]
[    2.333638] Linux agpgart interface v0.103
[    2.336640] SCSI subsystem initialized
[    2.338995] ACPI: bus type USB registered
[    2.339013] usbcore: registered new interface driver usbfs
[    2.339020] usbcore: registered new interface driver hub
[    2.339370] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    2.339477] ACPI: bus type ATA registered
[    2.339556] libata version 3.00 loaded.
[    2.340379] virtio-pci 0000:00:03.0: setting latency timer to 64
[    2.340542] usbcore: registered new device driver usb
[    2.340949] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.341212] uhci_hcd: USB Universal Host Controller Interface driver
[    2.342990] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    2.344302] FDC 0 is a S82078B
[    2.344330] virtio-pci 0000:00:06.0: setting latency timer to 64
[    2.346235] virtio-pci 0000:00:07.0: setting latency timer to 64
[    2.347387] ata_piix 0000:00:01.1: version 2.13
[    2.348835] ata_piix 0000:00:01.1: setting latency timer to 64
[    2.349497] scsi0 : ata_piix
[    2.349650] scsi1 : ata_piix
[    2.349700] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1c0 irq 14
[    2.349701] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1c8 irq 15
[    2.351137] uhci_hcd 0000:00:01.2: setting latency timer to 64
[    2.351146] uhci_hcd 0000:00:01.2: UHCI Host Controller
[    2.351152] uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
[    2.351257] uhci_hcd 0000:00:01.2: irq 11, io base 0x0000c140
[    2.351428] hub 1-0:1.0: USB hub found
[    2.351431] hub 1-0:1.0: 2 ports detected
[    2.352073] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    2.353482] sym0: <895a> rev 0x0 at pci 0000:00:05.0 irq 11
[    2.355767] sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
[    2.361853] virtio-pci 0000:00:03.0: irq 40 for MSI/MSI-X
[    2.361890] virtio-pci 0000:00:03.0: irq 41 for MSI/MSI-X
[    2.361918] virtio-pci 0000:00:03.0: irq 43 for MSI/MSI-X
[    2.361922] virtio-pci 0000:00:07.0: irq 42 for MSI/MSI-X
[    2.361955] virtio-pci 0000:00:07.0: irq 44 for MSI/MSI-X
[    2.362375] sym0: SCSI BUS has been reset.
[    2.408870] scsi2 : sym-2.2.3
[    2.413614]  vda: vda1 vda2 < vda5 >
[    2.504166] ata2.01: NODEV after polling detection
[    2.504473] ata2.00: ATAPI: QEMU DVD-ROM, 1.4.0, max UDMA/100
[    2.504982] ata2.00: configured for MWDMA2
[    2.508824] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.4. PQ: 0 ANSI: 5
[    2.883460] tsc: Refined TSC clocksource calibration: 3292.540 MHz
[    5.359903] ahci 0000:00:04.0: version 3.0
[    5.360662] ahci 0000:00:04.0: irq 45 for MSI/MSI-X
[    5.361330] ahci 0000:00:04.0: AHCI 0001.0000 32 slots 6 ports 1.5 Gbps 0x3f impl SATA mode
[    5.361334] ahci 0000:00:04.0: flags: ncq only 
[    5.361358] ahci 0000:00:04.0: setting latency timer to 64
[    5.362855] scsi3 : ahci
[    5.363157] scsi4 : ahci
[    5.363322] scsi5 : ahci
[    5.363557] scsi6 : ahci
[    5.363764] scsi7 : ahci
[    5.363930] scsi8 : ahci
[    5.364037] ata3: SATA max UDMA/133 abar m4096@0xfebf4000 port 0xfebf4100 irq 45
[    5.364048] ata4: SATA max UDMA/133 abar m4096@0xfebf4000 port 0xfebf4180 irq 45
[    5.364058] ata5: SATA max UDMA/133 abar m4096@0xfebf4000 port 0xfebf4200 irq 45
[    5.364067] ata6: SATA max UDMA/133 abar m4096@0xfebf4000 port 0xfebf4280 irq 45
[    5.364077] ata7: SATA max UDMA/133 abar m4096@0xfebf4000 port 0xfebf4300 irq 45
[    5.364086] ata8: SATA max UDMA/133 abar m4096@0xfebf4000 port 0xfebf4380 irq 45
[    5.369235] sr0: scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    5.369241] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.369777] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.683594] ata8: SATA link down (SStatus 0 SControl 300)
[    5.687961] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.688350] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.688494] ata3.00: ATA-7: QEMU HARDDISK, 1.4.0, max UDMA/100
[    5.688499] ata3.00: 11901337600 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    5.688504] ata3.00: applying bridge limits
[    5.688815] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.689056] ata6: SATA link down (SStatus 0 SControl 300)
[    5.689292] ata7: SATA link down (SStatus 0 SControl 300)
[    5.689405] ata4.00: ATA-7: QEMU HARDDISK, 1.4.0, max UDMA/100
[    5.689411] ata4.00: 11901337600 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    5.689417] ata4.00: applying bridge limits
[    5.689553] ata5.00: ATA-7: QEMU HARDDISK, 1.4.0, max UDMA/100
[    5.689558] ata5.00: 11901337600 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    5.689563] ata5.00: applying bridge limits
[    5.689702] ata3.00: configured for UDMA/100
[    5.689936] ata4.00: configured for UDMA/100
[    5.690123] scsi 3:0:0:0: Direct-Access     ATA      QEMU HARDDISK    1.4. PQ: 0 ANSI: 5
[    5.690527] ata5.00: configured for UDMA/100
[    5.690968] scsi 4:0:0:0: Direct-Access     ATA      QEMU HARDDISK    1.4. PQ: 0 ANSI: 5
[    5.691408] scsi 5:0:0:0: Direct-Access     ATA      QEMU HARDDISK    1.4. PQ: 0 ANSI: 5
[    5.706329] sd 3:0:0:0: [sda] 11901337600 512-byte logical blocks: (6.09 TB/5.54 TiB)
[    5.706483] sd 4:0:0:0: [sdb] 11901337600 512-byte logical blocks: (6.09 TB/5.54 TiB)
[    5.706570] sd 4:0:0:0: [sdb] Write Protect is off
[    5.706575] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.706614] sd 3:0:0:0: [sda] Write Protect is off
[    5.706617] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.706657] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.706799] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.707145] sd 5:0:0:0: [sdc] 11901337600 512-byte logical blocks: (6.09 TB/5.54 TiB)
[    5.707232] sd 5:0:0:0: [sdc] Write Protect is off
[    5.707236] sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.707274] sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.715157]  sdb: sdb1
[    5.715215]  sda: sda1 sda2 sda3
[    5.715550]  sdc: sdc1
[    5.716102] sd 4:0:0:0: [sdb] Attached SCSI disk
[    5.716262] sd 3:0:0:0: [sda] Attached SCSI disk
[    5.716964] sd 5:0:0:0: [sdc] Attached SCSI disk
[    5.875518] ISO 9660 Extensions: RRIP_1991A
[    5.909078] loop: module loaded
[    5.935659] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    5.954038] device-mapper: uevent: version 1.0.3
[    5.954232] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[    5.962231] bio: create slab <bio-1> at 1
[    5.979798] EXT4-fs (dm-0): mounted filesystem without journal. Opts: (null)
[    6.367982] systemd[1]: systemd 204 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    6.368016] systemd[1]: Detected virtualization 'kvm'.
[    6.376281] systemd[1]: Set hostname to <archiso>.
[    6.428400] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    6.428495] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    6.428519] systemd[1]: Starting Remote File Systems.
[    6.429618] systemd[1]: Reached target Remote File Systems.
[    6.429642] systemd[1]: Starting Delayed Shutdown Socket.
[    6.430794] systemd[1]: Listening on Delayed Shutdown Socket.
[    6.430813] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    6.432018] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    6.432035] systemd[1]: Starting LVM2 metadata daemon socket.
[    6.433084] systemd[1]: Listening on LVM2 metadata daemon socket.
[    6.433102] systemd[1]: Starting Device-mapper event daemon FIFOs.
[    6.434182] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    6.434236] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    6.435587] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    6.435608] systemd[1]: Starting Encrypted Volumes.
[    6.436616] systemd[1]: Reached target Encrypted Volumes.
[    6.436643] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    6.436745] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    6.436761] systemd[1]: Starting Paths.
[    6.437719] systemd[1]: Reached target Paths.
[    6.437848] systemd[1]: Starting udev Kernel Socket.
[    6.440680] systemd[1]: Listening on udev Kernel Socket.
[    6.440842] systemd[1]: Starting udev Control Socket.
[    6.441977] systemd[1]: Listening on udev Control Socket.
[    6.442004] systemd[1]: Starting Journal Socket.
[    6.443235] systemd[1]: Listening on Journal Socket.
[    6.444121] systemd[1]: Starting Load Kernel Modules...
[    6.446087] systemd[1]: Mounting POSIX Message Queue File System...
[    6.452313] systemd[1]: Starting udev Coldplug all Devices...
[    6.463186] systemd[1]: Started Set Up Additional Binary Formats.
[    6.463213] systemd[1]: Starting Setup Virtual Console...
[    6.464320] systemd[1]: Mounting Debug File System...
[    6.465024] systemd[1]: Mounting Huge Pages File System...
[    6.484380] systemd[1]: Starting Apply Kernel Variables...
[    6.487238] systemd[1]: Starting Create static device nodes in /dev...
[    6.488300] systemd[1]: Starting Journal Service...
[    6.492394] systemd[1]: Started Journal Service.
[    6.492436] systemd[1]: Starting Swap.
[    6.493121] systemd[1]: Reached target Swap.
[    6.493145] systemd[1]: Mounting Temporary Directory...
[    6.504665] systemd[1]: Started File System Check on Root Device.
[    6.504685] systemd[1]: Starting Remount Root and Kernel File Systems...
[    6.770282] FS-Cache: Loaded
[    6.791770] systemd-udevd[187]: starting version 204
[    6.818666] RPC: Registered named UNIX socket transport module.
[    6.818667] RPC: Registered udp transport module.
[    6.818667] RPC: Registered tcp transport module.
[    6.818668] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    6.907767] FS-Cache: Netfs 'nfs' registered for caching
[    7.253840] microcode: CPU0 sig=0x623, pf=0x0, revision=0x1
[    7.334238] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    7.347274] microcode: CPU1 sig=0x623, pf=0x0, revision=0x1
[    7.347310] microcode: CPU2 sig=0x623, pf=0x0, revision=0x1
[    7.347340] microcode: CPU3 sig=0x623, pf=0x0, revision=0x1
[    7.350125] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.560486] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[    7.759967] [drm] Initialized drm 1.1.0 20060810
[    7.849035] [TTM] Zone  kernel: Available graphics memory: 440226 kiB
[    7.849038] [TTM] Zone highmem: Available graphics memory: 1034146 kiB
[    7.849040] [TTM] Initializing pool allocator
[    7.872562] [drm] fb mappable at 0x0
[    7.872566] [drm] vram aper at 0x0
[    7.872567] [drm] size 0
[    7.872568] [drm] fb depth is 24
[    7.872569] [drm]    pitch is 3840
[    7.872647] fbcon: cirrusdrmfb (fb0) is primary device
[    7.904473] psmouse serio1: hgpk: ID: 10 00 64
[    7.909114] Console: switching to colour frame buffer device 160x64
[    7.924861] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    7.924863] cirrus 0000:00:02.0: registered panic notifier
[    7.924869] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
[    8.225879] bio: create slab <bio-2> at 2
[    8.309369] xor: measuring software checksum speed
[    8.340071]    pIII_sse  : 12313.200 MB/sec
[    8.353096] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[    8.373362]    prefetch64-sse: 18412.800 MB/sec
[    8.373364] xor: using function: prefetch64-sse (18412.800 MB/sec)
[    8.446693] raid6: mmxx1     3220 MB/s
[    8.503360] raid6: mmxx2     3527 MB/s
[    8.560035] raid6: sse1x1    2778 MB/s
[    8.616700] raid6: sse1x2    3494 MB/s
[    8.673355] raid6: sse2x1    5658 MB/s
[    8.730023] raid6: sse2x2    7134 MB/s
[    8.730026] raid6: using algorithm sse2x2 (7134 MB/s)
[    8.730028] raid6: using intx1 recovery algorithm
[    8.751405] Btrfs loaded
[    8.751977] device fsid 2ffb2450-f74f-4cfb-a3be-bb5e3c6d32ec devid 1 transid 23568 /dev/dm-3
[   45.905228] device fsid 2ffb2450-f74f-4cfb-a3be-bb5e3c6d32ec devid 1 transid 23568 /dev/mapper/main--storage--vg-root
[   45.907315] btrfs: enabling auto recovery
[   45.907322] btrfs: disk space caching is enabled
[   45.914105] btrfs: unable to find logical 1781900460032 len 4096
[   45.914275] ------------[ cut here ]------------
[   45.914406] kernel BUG at fs/btrfs/volumes.c:4417!
[   45.914489] invalid opcode: 0000 [#1] PREEMPT SMP 
[   45.914588] Modules linked in: btrfs raid6_pq crc32c libcrc32c zlib_deflate xor cirrus ttm drm_kms_helper drm syscopyarea sysfillrect sysimgblt kvm_intel kvm i2c_piix4 i2c_core psmouse processor pcspkr serio_raw evdev microcode nfs lockd sunrpc fscache ext4 crc16 mbcache jbd2 dm_snapshot dm_mod squashfs loop isofs sd_mod sr_mod cdrom ata_generic pata_acpi virtio_blk virtio_balloon virtio_net ahci libahci sym53c8xx scsi_transport_spi uhci_hcd ehci_hcd ata_piix virtio_pci usbcore usb_common libata scsi_mod intel_agp intel_gtt agpgart floppy button
[   45.915599] Pid: 510, comm: mount Not tainted 3.9.8-1-ARCH #1 Bochs Bochs
[   45.915701] EIP: 0060:[<f9d0f4fe>] EFLAGS: 00010282 CPU: 3
[   45.915805] EIP is at __btrfs_map_block+0x13de/0x13f0 [btrfs]
[   45.915936] EAX: 00000034 EBX: f6d8f0cc ECX: 00000000 EDX: f57ff9a0
[   45.916033] ESI: 00000000 EDI: 0000019e EBP: f6fb9bc4 ESP: f6fb9afc
[   45.916129]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   45.916217] CR0: 8005003b CR2: b7717ce0 CR3: 3413c000 CR4: 000006d0
[   45.916320] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   45.916419] DR6: ffff0ff0 DR7: 00000400
[   45.916491] Process mount (pid: 510, ti=f6fb8000 task=f6eb1b30 task.ti=f6fb8000)
[   45.916597] Stack:
[   45.916648]  f9d5ec00 e18b4000 0000019e 00001000 00000000 000028d0 fa83b2da 00000000
[   45.916810]  0000b800 0000b800 00000000 00000001 f6fb9b5c c0230185 00000000 00000008
[   45.916962]  f9d03bde c01f4683 00000080 00011220 f38a3000 f6d8f000 00000000 00000286
[   45.917115] Call Trace:
[   45.917188]  [<c0230185>] ? kmem_cache_alloc+0x65/0x1b0
[   45.917188]  [<f9d03bde>] ? tree_insert+0x4e/0x80 [btrfs]
[   45.917188]  [<c01f4683>] ? mempool_alloc_slab+0x13/0x20
[   45.917188]  [<f83e6860>] ? dm_target_exit+0x20/0x20 [dm_mod]
[   45.917188]  [<f83e24b1>] ? dm_merge_bvec+0x91/0xf0 [dm_mod]
[   45.917188]  [<f83e6860>] ? dm_target_exit+0x20/0x20 [dm_mod]
[   45.917188]  [<f83e2420>] ? dm_get_live_table+0x40/0x40 [dm_mod]
[   45.917188]  [<c0271bc4>] ? __bio_add_page+0xd4/0x200
[   45.917188]  [<c0272430>] ? bio_alloc_bioset+0x130/0x180
[   45.917188]  [<f83e2420>] ? dm_get_live_table+0x40/0x40 [dm_mod]
[   45.917188]  [<f9d14e98>] btrfs_map_bio+0x78/0x450 [btrfs]
[   45.917188]  [<f9d0868b>] ? submit_extent_page.isra.38+0xeb/0x1d0 [btrfs]
[   45.917188]  [<f9d06f60>] ? test_range_bit+0x80/0x180 [btrfs]
[   45.917188]  [<f9d08c67>] ? __extent_read_full_page+0x4f7/0x7f0 [btrfs]
[   45.917188]  [<f9ce1e79>] ? btrfs_bio_wq_end_io+0x29/0x70 [btrfs]
[   45.917188]  [<f9ce20aa>] btree_submit_bio_hook+0x5a/0x100 [btrfs]
[   45.917188]  [<f9ce2050>] ? btrfs_wq_submit_bio+0x170/0x170 [btrfs]
[   45.917188]  [<f9d03c90>] submit_one_bio+0x80/0xb0 [btrfs]
[   45.917188]  [<f9ce2050>] ? btrfs_wq_submit_bio+0x170/0x170 [btrfs]
[   45.917188]  [<f9d0b848>] read_extent_buffer_pages+0x1f8/0x2b0 [btrfs]
[   45.917188]  [<f9ce1af8>] btree_read_extent_buffer_pages.constprop.52+0xc8/0x140 [btrfs]
[   45.917188]  [<f9cdff10>] ? run_one_async_done+0xd0/0xd0 [btrfs]
[   45.917188]  [<f9ce23f7>] read_tree_block+0x47/0x50 [btrfs]
[   45.917188]  [<f9ce5f5c>] open_ctree+0x13bc/0x1b60 [btrfs]
[   45.917188]  [<c030b163>] ? strlcpy+0x33/0x50
[   45.917188]  [<f9cbe89b>] btrfs_mount+0x77b/0x8c0 [btrfs]
[   45.917188]  [<c0231ef0>] ? __kmalloc_track_caller+0x80/0x1d0
[   45.917188]  [<c0246351>] mount_fs+0x31/0x180
[   45.917188]  [<c020e3df>] ? __alloc_percpu+0xf/0x20
[   45.917188]  [<c025c6b5>] vfs_kern_mount+0x45/0xc0
[   45.917188]  [<c025e402>] do_mount+0x1e2/0x840
[   45.917188]  [<c025e10f>] ? copy_mount_options+0x2f/0x100
[   45.917188]  [<c025eacb>] sys_mount+0x6b/0xa0
[   45.917188]  [<c050d54b>] syscall_call+0x7/0xb
[   45.917188] Code: ff 8b 45 10 8b 50 04 8b 00 c7 04 24 00 ec d5 f9 89 54 24 10 8b 55 0c 89 44 24 0c 8b 45 08 89 54 24 08 89 44 24 04 e8 4b 6e 7f c6 <0f> 0b bb f4 ff ff ff e9 1b f4 ff ff 8d b6 00 00 00 00 55 89 e5
[   45.917188] EIP: [<f9d0f4fe>] __btrfs_map_block+0x13de/0x13f0 [btrfs] SS:ESP 0068:f6fb9afc
[   45.961103] ---[ end trace 9d69bb5afeaa2a52 ]---
[  110.572033] device fsid 2ffb2450-f74f-4cfb-a3be-bb5e3c6d32ec devid 1 transid 23568 /dev/mapper/main--storage--vg-root
[ 5010.523571] device fsid 2ffb2450-f74f-4cfb-a3be-bb5e3c6d32ec devid 1 transid 23568 /dev/mapper/main--storage--vg-root