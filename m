Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60220 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab2JSQzw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 12:55:52 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so504680pad.19
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 09:55:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvj4_vknNaKnpFG+Q+Tpg1dxA+W+g9xWhDPMLrmt2_Lk3A@mail.gmail.com>
References: <CAK0PdAk3+wPR_MerCNFgCvCC01c1RJ31=Z=G9=hT5eyYfn=iNg@mail.gmail.com>
	<20121018132850.GA22010@shiny>
	<CAK0PdAkbtT=PynBi0KjEsDBGy4U1RhBmWf5uQRQYQ3Z-M__nvg@mail.gmail.com>
	<CAE5mzvi6B_KqmVBSsNRyK6==k9f_MgYK1y4Aw-5jxZ1AhoxxOg@mail.gmail.com>
	<CAK0PdAk+Q=bY8OMn8mP8HB4iorgLYLYQv6bJM_uLkBozFJwQcg@mail.gmail.com>
	<CAK0PdA=DSoWV-8RDFy10guE1QEL4VegUwrM4JwC5HNpQF8eK5w@mail.gmail.com>
	<CAE5mzvj4_vknNaKnpFG+Q+Tpg1dxA+W+g9xWhDPMLrmt2_Lk3A@mail.gmail.com>
Date: Fri, 19 Oct 2012 10:55:51 -0600
Message-ID: <CAE5mzvh9VFUxdsRehuZdTC-0VYdwbEL=cmtoU=gqTs8Ne29m8A@mail.gmail.com>
Subject: Re: initramfs take a long time to load[135s]
From: cwillu <cwillu@cwillu.com>
To: Marguerite Su <i@marguerite.su>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 19, 2012 at 10:48 AM, Marguerite Su <i@marguerite.su> wrote:
> On Sat, Oct 20, 2012 at 12:29 AM, cwillu <cwillu@cwillu.com> wrote:
>> More useful every time!
>>
>> Can you post the full output of dmesg, or at least the first couple
>> hundred seconds of it?
>
> here it is:
>
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.6.2-2-desktop (geeko@buildhost) (gcc
> version 4.6.2 (SUSE Linux) ) #1 SMP PREEMPT Sat Oct 13 09:48:04 UTC
> 2012 (1c7cb70)
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.6.2-2-desktop
> root=UUID=9b9aa9d9-760e-445c-a0ab-68e102d9f02e
> resume=/dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part1
> splash=silent quiet showopts vga=0x317
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000d2000-0x00000000000d3fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000beeaffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000beeb0000-0x00000000beecbfff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000beecc000-0x00000000beefffff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bef00000-0x00000000beffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI present.
> [    0.000000] DMI: LENOVO 8889CG1/8889CG1, BIOS 7LETB7WW (2.17 ) 04/25/2008
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0xbeeb0 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CFFFF write-protect
> [    0.000000]   D0000-DFFFF uncachable
> [    0.000000]   E0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0BF000000 mask FFF000000 uncachable
> [    0.000000]   1 base 000000000 mask F80000000 write-back
> [    0.000000]   2 base 080000000 mask FC0000000 write-back
> [    0.000000]   3 base 0BEF00000 mask FFFF00000 uncachable
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] found SMP MP-table at [mem 0x000f6900-0x000f690f]
> mapped at [ffff8800000f6900]
> [    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0xbeeaffff]
> [    0.000000]  [mem 0x00000000-0xbedfffff] page 2M
> [    0.000000]  [mem 0xbee00000-0xbeeaffff] page 4k
> [    0.000000] kernel direct mapping tables up to 0xbeeaffff @ [mem
> 0x1fa04000-0x1fffffff]
> [    0.000000] RAMDISK: [mem 0x35e4e000-0x36f1efff]
> [    0.000000] ACPI: RSDP 00000000000f68d0 00024 (v02 LENOVO)
> [    0.000000] ACPI: XSDT 00000000beebb77f 00094 (v01 LENOVO TP-7L
> 00002170  LTP 00000000)
> [    0.000000] ACPI: FACP 00000000beebb900 000F4 (v03 LENOVO TP-7L
> 00002170 LNVO 00000001)
> [    0.000000] ACPI BIOS Bug: Warning: 32/64X length mismatch in
> FADT/Gpe1Block: 0/32 (20120711/tbfadt-567)
> [    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Gpe1Block
> has zero address or length: 0x000000000000102C/0x0
> (20120711/tbfadt-598)
> [    0.000000] ACPI: DSDT 00000000beebbd1d 0FED1 (v01 LENOVO TP-7L
> 00002170 MSFT 03000000)
> [    0.000000] ACPI: FACS 00000000beee4000 00040
> [    0.000000] ACPI: SSDT 00000000beebbab4 00269 (v01 LENOVO TP-7L
> 00002170 MSFT 03000000)
> [    0.000000] ACPI: ECDT 00000000beecbbee 00052 (v01 LENOVO TP-7L
> 00002170 LNVO 00000001)
> [    0.000000] ACPI: TCPA 00000000beecbc40 00032 (v02 LENOVO TP-7L
> 00002170 LNVO 00000001)
> [    0.000000] ACPI: APIC 00000000beecbc72 00068 (v01 LENOVO TP-7L
> 00002170 LNVO 00000001)
> [    0.000000] ACPI: MCFG 00000000beecbcda 0003C (v01 LENOVO TP-7L
> 00002170 LNVO 00000001)
> [    0.000000] ACPI: HPET 00000000beecbd16 00038 (v01 LENOVO TP-7L
> 00002170 LNVO 00000001)
> [    0.000000] ACPI: SLIC 00000000beecbdf0 00176 (v01 LENOVO TP-7L
> 00002170  LTP 00000000)
> [    0.000000] ACPI: BOOT 00000000beecbf66 00028 (v01 LENOVO TP-7L
> 00002170  LTP 00000001)
> [    0.000000] ACPI: ASF! 00000000beecbf8e 00072 (v16 LENOVO TP-7L
> 00002170 PTL  00000001)
> [    0.000000] ACPI: SSDT 00000000beee2697 0025F (v01 LENOVO TP-7L
> 00002170 INTL 20050513)
> [    0.000000] ACPI: SSDT 00000000beee28f6 000A6 (v01 LENOVO TP-7L
> 00002170 INTL 20050513)
> [    0.000000] ACPI: SSDT 00000000beee299c 004F7 (v01 LENOVO TP-7L
> 00002170 INTL 20050513)
> [    0.000000] ACPI: SSDT 00000000beee2e93 001D8 (v01 LENOVO TP-7L
> 00002170 INTL 20050513)
> [    0.000000] ACPI: DMI detected: Lenovo ThinkPad T61
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x00000000beeaffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0xbeeaffff]
> [    0.000000]   NODE_DATA [mem 0xbee9c000-0xbeeaffff]
> [    0.000000]  [ffffea0000000000-ffffea00029fffff] PMD ->
> [ffff8800bb600000-ffff8800bdffffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
> [    0.000000]   node   0: [mem 0x00100000-0xbeeaffff]
> [    0.000000] On node 0 totalpages: 781885
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 6 pages reserved
> [    0.000000]   DMA zone: 3919 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 10636 pages used for memmap
> [    0.000000]   DMA32 zone: 767268 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
> [    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
> [    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] e820: [mem 0xbf000000-0xefffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512
> nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 27 pages/cpu @ffff8800bec00000 s81728
> r8192 d20672 u1048576
> [    0.000000] pcpu-alloc: s81728 r8192 d20672 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.
> Total pages: 771187
> [    0.000000] Policy zone: DMA32
> [    0.000000] Kernel command line:
> BOOT_IMAGE=/vmlinuz-3.6.2-2-desktop
> root=UUID=9b9aa9d9-760e-445c-a0ab-68e102d9f02e
> resume=/dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part1
> splash=silent quiet showopts vga=0x317
> [    0.000000] bootsplash: silent mode.
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] __ex_table already sorted, skipping sort
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Memory: 3050888k/3128000k available (5980k kernel code,
> 460k absent, 76652k reserved, 7013k data, 960k init)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=2.
> [    0.000000] NR_IRQS:33024 nr_irqs:512 16
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] allocated 12582912 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't
> want memory cgroups
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.000000] tsc: Detected 1795.416 MHz processor
> [    0.001004] Calibrating delay loop (skipped), value calculated
> using timer frequency.. 3590.83 BogoMIPS (lpj=1795416)
> [    0.001008] pid_max: default: 32768 minimum: 301
> [    0.001052] Security Framework initialized
> [    0.001074] AppArmor: AppArmor initialized
> [    0.001492] Dentry cache hash table entries: 524288 (order: 10,
> 4194304 bytes)
> [    0.004836] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.006344] Mount-cache hash table entries: 256
> [    0.006616] Initializing cgroup subsys cpuacct
> [    0.006619] Initializing cgroup subsys memory
> [    0.006645] Initializing cgroup subsys devices
> [    0.006647] Initializing cgroup subsys freezer
> [    0.006648] Initializing cgroup subsys net_cls
> [    0.006650] Initializing cgroup subsys blkio
> [    0.006652] Initializing cgroup subsys perf_event
> [    0.006655] Initializing cgroup subsys hugetlb
> [    0.006691] CPU: Physical Processor ID: 0
> [    0.006693] CPU: Processor Core ID: 0
> [    0.006695] mce: CPU supports 6 MCE banks
> [    0.006705] CPU0: Thermal monitoring enabled (TM2)
> [    0.006710] process: using mwait in idle threads
> [    0.006715] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
> [    0.006715] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
> [    0.006715] tlb_flushall_shift is 0xffffffff
> [    0.007951] ACPI: Core revision 20120711
> [    0.021224] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.031233] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     T7100  @
> 1.80GHz stepping 0d
> [    0.031995] Performance Events: PEBS fmt0+, 4-deep LBR, Core2
> events, Intel PMU driver.
> [    0.031995] perf_event_intel: PEBS disabled due to CPU errata
> [    0.031995] ... version:                2
> [    0.031995] ... bit width:              40
> [    0.031995] ... generic registers:      2
> [    0.031995] ... value mask:             000000ffffffffff
> [    0.031995] ... max period:             000000007fffffff
> [    0.031995] ... fixed-purpose events:   3
> [    0.031995] ... event mask:             0000000700000003
> [    0.041786] NMI watchdog: enabled on all CPUs, permanently consumes
> one hw-PMU counter.
> [    0.045001] smpboot: Booting Node   0, Processors  #1 OK
> [    0.056991] TSC synchronization [CPU#0 -> CPU#1]:
> [    0.056991] Measured 293859 cycles TSC warp between CPUs, turning
> off TSC clock.
> [    0.056991] tsc: Marking TSC unstable due to check_tsc_sync_source failed
> [    0.057069] Brought up 2 CPUs
> [    0.057073] smpboot: Total of 2 processors activated (7181.66 BogoMIPS)
> [    0.058099] devtmpfs: initialized
> [    0.060211] PM: Registering ACPI NVS region [mem
> 0xbeecc000-0xbeefffff] (212992 bytes)
> [    0.060211] RTC time: 15:55:20, date: 10/19/12
> [    0.060211] NET: Registered protocol family 16
> [    0.060395] ACPI FADT declares the system doesn't support PCIe
> ASPM, so disable it
> [    0.060398] ACPI: bus type pci registered
> [    0.060476] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
> 0xf0000000-0xf3ffffff] (base 0xf0000000)
> [    0.060479] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
> [    0.067381] PCI: Using configuration type 1 for base access
> [    0.067535] mtrr: your CPUs had inconsistent variable MTRR settings
> [    0.067537] mtrr: probably your BIOS does not setup all CPUs.
> [    0.067538] mtrr: corrected configuration.
> [    0.068505] bio: create slab <bio-0> at 0
> [    0.068505] ACPI: Added _OSI(Module Device)
> [    0.068505] ACPI: Added _OSI(Processor Device)
> [    0.068505] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.068505] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.068505] ACPI: Added _OSI(Linux)
> [    0.072200] ACPI: EC: EC description table is found, configuring boot EC
> [    0.081143] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via DMI
> [    0.088513] ACPI: SSDT 00000000beee1b32 00282 (v01  PmRef  Cpu0Ist
> 00000100 INTL 20050513)
> [    0.089363] ACPI: Dynamic OEM Table Load:
> [    0.089367] ACPI: SSDT           (null) 00282 (v01  PmRef  Cpu0Ist
> 00000100 INTL 20050513)
> [    0.089607] ACPI: SSDT 00000000beee1e39 0085E (v01  PmRef  Cpu0Cst
> 00000100 INTL 20050513)
> [    0.090506] ACPI: Dynamic OEM Table Load:
> [    0.090509] ACPI: SSDT           (null) 0085E (v01  PmRef  Cpu0Cst
> 00000100 INTL 20050513)
> [    0.090530] ACPI: SSDT 00000000beee1a6a 000C8 (v01  PmRef  Cpu1Ist
> 00000100 INTL 20050513)
> [    0.091613] ACPI: Dynamic OEM Table Load:
> [    0.091617] ACPI: SSDT           (null) 000C8 (v01  PmRef  Cpu1Ist
> 00000100 INTL 20050513)
> [    0.091759] ACPI: SSDT 00000000beee1db4 00085 (v01  PmRef  Cpu1Cst
> 00000100 INTL 20050513)
> [    0.092587] ACPI: Dynamic OEM Table Load:
> [    0.092591] ACPI: SSDT           (null) 00085 (v01  PmRef  Cpu1Cst
> 00000100 INTL 20050513)
> [    0.092611] ACPI: Interpreter enabled
> [    0.092611] ACPI: (supports S0 S3 S4 S5)
> [    0.092611] ACPI: Using IOAPIC for interrupt routing
> [    0.097035] ACPI: Power Resource [PUBS] (on)
> [    0.103172] ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
> [    0.105177] ACPI: ACPI Dock Station Driver: 3 docks/bays found
> [    0.105182] PCI: Using host bridge windows from ACPI; if necessary,
> use "pci=nocrs" and report a bug
> [    0.105566] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.105609] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for
> domain 0000 [bus 00-3f] only partially covers this bridge
> [    0.105649] PCI host bridge to bus 0000:00
> [    0.105653] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted
> under domain [bus 00-ff]
> [    0.105656] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.105660] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.105662] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.105665] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.105668] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
> [    0.105671] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
> [    0.105674] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
> [    0.105676] pci_bus 0000:00: root bus resource [mem 0xbf000000-0xfebfffff]
> [    0.105689] pci 0000:00:00.0: [8086:2a00] type 00 class 0x060000
> [    0.105746] pci 0000:00:01.0: [8086:2a01] type 01 class 0x060400
> [    0.105798] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    0.105930] pci 0000:00:19.0: [8086:1049] type 00 class 0x020000
> [    0.105991] pci 0000:00:19.0: reg 10: [mem 0xfe200000-0xfe21ffff]
> [    0.106018] pci 0000:00:19.0: reg 14: [mem 0xfe225000-0xfe225fff]
> [    0.106041] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
> [    0.106239] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
> [    0.106289] pci 0000:00:1a.0: [8086:2834] type 00 class 0x0c0300
> [    0.106424] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
> [    0.106522] pci 0000:00:1a.1: [8086:2835] type 00 class 0x0c0300
> [    0.106647] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
> [    0.106773] pci 0000:00:1a.7: [8086:283a] type 00 class 0x0c0320
> [    0.106819] pci 0000:00:1a.7: reg 10: [mem 0xfe226c00-0xfe226fff]
> [    0.107037] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    0.107104] pci 0000:00:1b.0: [8086:284b] type 00 class 0x040300
> [    0.107155] pci 0000:00:1b.0: reg 10: [mem 0xfe220000-0xfe223fff 64bit]
> [    0.107392] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.107460] pci 0000:00:1c.0: [8086:283f] type 01 class 0x060400
> [    0.107720] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.107798] pci 0000:00:1c.1: [8086:2841] type 01 class 0x060400
> [    0.108062] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.108145] pci 0000:00:1c.2: [8086:2843] type 01 class 0x060400
> [    0.108414] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.108483] pci 0000:00:1c.3: [8086:2845] type 01 class 0x060400
> [    0.108729] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.108807] pci 0000:00:1c.4: [8086:2847] type 01 class 0x060400
> [    0.109051] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.109132] pci 0000:00:1d.0: [8086:2830] type 00 class 0x0c0300
> [    0.109261] pci 0000:00:1d.0: reg 20: [io  0x18a0-0x18bf]
> [    0.109359] pci 0000:00:1d.1: [8086:2831] type 00 class 0x0c0300
> [    0.109489] pci 0000:00:1d.1: reg 20: [io  0x18c0-0x18df]
> [    0.109590] pci 0000:00:1d.2: [8086:2832] type 00 class 0x0c0300
> [    0.109725] pci 0000:00:1d.2: reg 20: [io  0x18e0-0x18ff]
> [    0.109860] pci 0000:00:1d.7: [8086:2836] type 00 class 0x0c0320
> [    0.109908] pci 0000:00:1d.7: reg 10: [mem 0xfe227000-0xfe2273ff]
> [    0.110131] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.110190] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
> [    0.110411] pci 0000:00:1f.0: [8086:2811] type 00 class 0x060100
> [    0.110607] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by
> ICH6 ACPI/GPIO/TCO
> [    0.110618] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
> [    0.110625] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
> 1600 (mask 007f)
> [    0.110632] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at
> 15e0 (mask 000f)
> [    0.110639] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at
> 1680 (mask 001f)
> [    0.110742] pci 0000:00:1f.1: [8086:2850] type 00 class 0x01018a
> [    0.110781] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
> [    0.110808] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
> [    0.110836] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
> [    0.110865] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
> [    0.110893] pci 0000:00:1f.1: reg 20: [io  0x1830-0x183f]
> [    0.111010] pci 0000:00:1f.2: [8086:2829] type 00 class 0x010601
> [    0.111072] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
> [    0.111091] pci 0000:00:1f.2: reg 14: [io  0x1c1c-0x1c1f]
> [    0.111113] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
> [    0.111132] pci 0000:00:1f.2: reg 1c: [io  0x1c18-0x1c1b]
> [    0.111151] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
> [    0.111178] pci 0000:00:1f.2: reg 24: [mem 0xfe226000-0xfe2267ff]
> [    0.111315] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.111369] pci 0000:00:1f.3: [8086:283e] type 00 class 0x0c0500
> [    0.111407] pci 0000:00:1f.3: reg 10: [mem 0xfe227400-0xfe2274ff]
> [    0.111501] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
> [    0.111621] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-ff]
> [    0.111649] pci 0000:01:00.0: [10de:0429] type 00 class 0x030000
> [    0.111669] pci 0000:01:00.0: reg 10: [mem 0xd6000000-0xd6ffffff]
> [    0.111692] pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
> [    0.111714] pci 0000:01:00.0: reg 1c: [mem 0xd4000000-0xd5ffffff 64bit]
> [    0.111729] pci 0000:01:00.0: reg 24: [io  0x2000-0x207f]
> [    0.111744] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> [    0.111849] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.111853] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
> [    0.111857] pci 0000:00:01.0:   bridge window [mem 0xd4000000-0xd6ffffff]
> [    0.111862] pci 0000:00:01.0:   bridge window [mem
> 0xe0000000-0xefffffff 64bit pref]
> [    0.112001] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-ff]
> [    0.112007] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.112015] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
> [    0.112025] pci 0000:00:1c.0:   bridge window [mem 0xfc000000-0xfdffffff]
> [    0.112041] pci 0000:00:1c.0:   bridge window [mem
> 0xf8000000-0xf80fffff 64bit pref]
> [    0.112186] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-ff]
> [    0.112301] pci 0000:03:00.0: [8086:4227] type 00 class 0x028000
> [    0.112359] pci 0000:03:00.0: reg 10: [mem 0xdf2ff000-0xdf2fffff]
> [    0.112792] pci 0000:03:00.0: PME# supported from D0 D3hot
> [    0.115065] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.115072] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
> [    0.115078] pci 0000:00:1c.1:   bridge window [mem 0xdc100000-0xdf2fffff]
> [    0.115087] pci 0000:00:1c.1:   bridge window [mem
> 0xdfd00000-0xdfdfffff 64bit pref]
> [    0.115171] pci_bus 0000:04: busn_res: [bus 04] is inserted under [bus 00-ff]
> [    0.115178] pci 0000:00:1c.2: PCI bridge to [bus 04]
> [    0.115188] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
> [    0.115198] pci 0000:00:1c.2:   bridge window [mem 0xd8000000-0xd9ffffff]
> [    0.115213] pci 0000:00:1c.2:   bridge window [mem
> 0xdfa00000-0xdfafffff 64bit pref]
> [    0.115347] pci_bus 0000:05: busn_res: [bus 05-0c] is inserted
> under [bus 00-ff]
> [    0.115354] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
> [    0.115362] pci 0000:00:1c.3:   bridge window [io  0x6000-0x6fff]
> [    0.115370] pci 0000:00:1c.3:   bridge window [mem 0xd0000000-0xd1ffffff]
> [    0.115387] pci 0000:00:1c.3:   bridge window [mem
> 0xdf700000-0xdf7fffff 64bit pref]
> [    0.115520] pci_bus 0000:0d: busn_res: [bus 0d-14] is inserted
> under [bus 00-ff]
> [    0.115526] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
> [    0.115534] pci 0000:00:1c.4:   bridge window [io  0x7000-0x7fff]
> [    0.115542] pci 0000:00:1c.4:   bridge window [mem 0xcc000000-0xcdffffff]
> [    0.115560] pci 0000:00:1c.4:   bridge window [mem
> 0xdf400000-0xdf4fffff 64bit pref]
> [    0.115635] pci_bus 0000:15: busn_res: [bus 15-18] is inserted
> under [bus 00-ff]
> [    0.115666] pci 0000:15:00.0: [1180:0476] type 02 class 0x060700
> [    0.115720] pci 0000:15:00.0: reg 10: [mem 0xf8100000-0xf8100fff]
> [    0.115802] pci 0000:15:00.0: supports D1 D2
> [    0.115805] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.115975] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
> [    0.115985] pci 0000:00:1e.0:   bridge window [io  0x8000-0xbfff]
> [    0.115995] pci 0000:00:1e.0:   bridge window [mem 0xf8100000-0xfbffffff]
> [    0.116011] pci 0000:00:1e.0:   bridge window [mem
> 0xf4000000-0xf7ffffff 64bit pref]
> [    0.116014] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7]
> (subtractive decode)
> [    0.116017] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff]
> (subtractive decode)
> [    0.116020] pci 0000:00:1e.0:   bridge window [mem
> 0x000a0000-0x000bffff] (subtractive decode)
> [    0.116022] pci 0000:00:1e.0:   bridge window [mem
> 0x000d4000-0x000d7fff] (subtractive decode)
> [    0.116025] pci 0000:00:1e.0:   bridge window [mem
> 0x000d8000-0x000dbfff] (subtractive decode)
> [    0.116028] pci 0000:00:1e.0:   bridge window [mem
> 0x000dc000-0x000dffff] (subtractive decode)
> [    0.116031] pci 0000:00:1e.0:   bridge window [mem
> 0xbf000000-0xfebfffff] (subtractive decode)
> [    0.116114] pci_bus 0000:16: busn_res: can not insert [bus 16-ff]
> under [bus 15-18] (conflicts with (null) [bus 15-18])
> [    0.116122] pci_bus 0000:16: busn_res: [bus 16-ff] end is updated to 17
> [    0.116125] pci_bus 0000:16: busn_res: [bus 16-17] is inserted
> under [bus 15-18]
> [    0.116217] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.116363] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
> [    0.116414] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
> [    0.116458] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
> [    0.116501] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
> [    0.116544] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
> [    0.116593] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
> [    0.116642] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
> [    0.117097]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> [    0.117725]  pci0000:00: ACPI _OSC control (0x1d) granted
> [    0.125909] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
> [    0.126024] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.126132] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.126239] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.126346] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.126452] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.126558] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.126663] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.126746] vgaarb: device added:
> PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.126746] vgaarb: loaded
> [    0.126746] vgaarb: bridge control possible 0000:01:00.0
> [    0.126746] SCSI subsystem initialized
> [    0.126746] ACPI: bus type scsi registered
> [    0.127011] libata version 3.00 loaded.
> [    0.127037] ACPI: bus type usb registered
> [    0.127064] usbcore: registered new interface driver usbfs
> [    0.127077] usbcore: registered new interface driver hub
> [    0.127083] usbcore: registered new device driver usb
> [    0.127083] PCI: Using ACPI for IRQ routing
> [    0.129969] PCI: pci_cache_line_size set to 64 bytes
> [    0.130110] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
> [    0.130113] e820: reserve RAM buffer [mem 0xbeeb0000-0xbfffffff]
> [    0.130248] NetLabel: Initializing
> [    0.130250] NetLabel:  domain hash size = 128
> [    0.130252] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.130268] NetLabel:  unlabeled traffic allowed by default
> [    0.130298] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    0.130304] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    0.130310] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> [    0.137001] Switching to clocksource hpet
> [    0.140802] AppArmor: AppArmor Filesystem Enabled
> [    0.140848] pnp: PnP ACPI init
> [    0.140868] ACPI: bus type pnp registered
> [    0.141560] pnp 00:00: [mem 0x00000000-0x0009ffff]
> [    0.141564] pnp 00:00: [mem 0x000c0000-0x000c3fff]
> [    0.141567] pnp 00:00: [mem 0x000c4000-0x000c7fff]
> [    0.141569] pnp 00:00: [mem 0x000c8000-0x000cbfff]
> [    0.141572] pnp 00:00: [mem 0x000cc000-0x000cffff]
> [    0.141575] pnp 00:00: [mem 0x000d0000-0x000d3fff]
> [    0.141577] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
> [    0.141580] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
> [    0.141583] pnp 00:00: [mem 0x000dc000-0x000dbfff disabled]
> [    0.141585] pnp 00:00: [mem 0x000e0000-0x000e3fff]
> [    0.141588] pnp 00:00: [mem 0x000e4000-0x000e7fff]
> [    0.141591] pnp 00:00: [mem 0x000e8000-0x000ebfff]
> [    0.141593] pnp 00:00: [mem 0x000ec000-0x000effff]
> [    0.141596] pnp 00:00: [mem 0x000f0000-0x000fffff]
> [    0.141598] pnp 00:00: [mem 0x00100000-0xbeffffff]
> [    0.141601] pnp 00:00: [mem 0xfec00000-0xffffffff]
> [    0.141604] pnp 00:00: [mem 0xfed4c000-0xfed4bfff disabled]
> [    0.141710] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
> [    0.141714] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
> [    0.141718] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
> [    0.141721] system 00:00: [mem 0x000c8000-0x000cbfff] could not be reserved
> [    0.141724] system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
> [    0.141728] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
> [    0.141731] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
> [    0.141735] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
> [    0.141738] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
> [    0.141742] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
> [    0.141745] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
> [    0.141748] system 00:00: [mem 0x00100000-0xbeffffff] could not be reserved
> [    0.141752] system 00:00: [mem 0xfec00000-0xffffffff] could not be reserved
> [    0.141757] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.141789] pnp 00:01: [bus 00-ff]
> [    0.141793] pnp 00:01: [io  0x0cf8-0x0cff]
> [    0.141796] pnp 00:01: [io  0x0000-0x0cf7 window]
> [    0.141799] pnp 00:01: [io  0x0d00-0xffff window]
> [    0.141802] pnp 00:01: [mem 0x000a0000-0x000bffff window]
> [    0.141806] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
> [    0.141809] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
> [    0.141812] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
> [    0.141815] pnp 00:01: [mem 0x000cc000-0x000cffff window]
> [    0.141817] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
> [    0.141820] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
> [    0.141823] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
> [    0.141825] pnp 00:01: [mem 0x000dc000-0x000dffff window]
> [    0.141828] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
> [    0.141831] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
> [    0.141834] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
> [    0.141836] pnp 00:01: [mem 0x000ec000-0x000effff window]
> [    0.141839] pnp 00:01: [mem 0xbf000000-0xfebfffff window]
> [    0.141842] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
> [    0.141919] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08
> PNP0a03 (active)
> [    0.142047] pnp 00:02: [io  0x0010-0x001f]
> [    0.142050] pnp 00:02: [io  0x0090-0x009f]
> [    0.142053] pnp 00:02: [io  0x0024-0x0025]
> [    0.142055] pnp 00:02: [io  0x0028-0x0029]
> [    0.142058] pnp 00:02: [io  0x002c-0x002d]
> [    0.142060] pnp 00:02: [io  0x0030-0x0031]
> [    0.142063] pnp 00:02: [io  0x0034-0x0035]
> [    0.142065] pnp 00:02: [io  0x0038-0x0039]
> [    0.142067] pnp 00:02: [io  0x003c-0x003d]
> [    0.142070] pnp 00:02: [io  0x00a4-0x00a5]
> [    0.142072] pnp 00:02: [io  0x00a8-0x00a9]
> [    0.142075] pnp 00:02: [io  0x00ac-0x00ad]
> [    0.142077] pnp 00:02: [io  0x00b0-0x00b5]
> [    0.142080] pnp 00:02: [io  0x00b8-0x00b9]
> [    0.142082] pnp 00:02: [io  0x00bc-0x00bd]
> [    0.142086] pnp 00:02: [io  0x0050-0x0053]
> [    0.142088] pnp 00:02: [io  0x0072-0x0077]
> [    0.142091] pnp 00:02: [io  0x164e-0x164f]
> [    0.142093] pnp 00:02: [io  0x002e-0x002f]
> [    0.142096] pnp 00:02: [io  0x1000-0x107f]
> [    0.142098] pnp 00:02: [io  0x1180-0x11bf]
> [    0.142101] pnp 00:02: [io  0x0800-0x080f]
> [    0.142103] pnp 00:02: [io  0x15e0-0x15ef]
> [    0.142106] pnp 00:02: [io  0x1600-0x165f]
> [    0.142109] pnp 00:02: [mem 0xf0000000-0xf3ffffff]
> [    0.142111] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
> [    0.142114] pnp 00:02: [mem 0xfed14000-0xfed17fff]
> [    0.142116] pnp 00:02: [mem 0xfed18000-0xfed18fff]
> [    0.142119] pnp 00:02: [mem 0xfed19000-0xfed19fff]
> [    0.142121] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
> [    0.142124] pnp 00:02: [mem 0xfed40000-0xfed44fff]
> [    0.142237] system 00:02: [io  0x164e-0x164f] has been reserved
> [    0.142241] system 00:02: [io  0x1000-0x107f] has been reserved
> [    0.142244] system 00:02: [io  0x1180-0x11bf] has been reserved
> [    0.142248] system 00:02: [io  0x0800-0x080f] has been reserved
> [    0.142252] system 00:02: [io  0x15e0-0x15ef] has been reserved
> [    0.142255] system 00:02: [io  0x1600-0x165f] could not be reserved
> [    0.142259] system 00:02: [mem 0xf0000000-0xf3ffffff] has been reserved
> [    0.142262] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.142265] system 00:02: [mem 0xfed14000-0xfed17fff] has been reserved
> [    0.142269] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.142272] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.142276] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
> [    0.142279] system 00:02: [mem 0xfed40000-0xfed44fff] has been reserved
> [    0.142283] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.142339] pnp 00:03: [mem 0xfed00000-0xfed003ff]
> [    0.142372] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.142387] pnp 00:04: [io  0x0000-0x000f]
> [    0.142390] pnp 00:04: [io  0x0080-0x008f]
> [    0.142393] pnp 00:04: [io  0x00c0-0x00df]
> [    0.142395] pnp 00:04: [dma 4]
> [    0.142429] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.142442] pnp 00:05: [io  0x0061]
> [    0.142476] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.142489] pnp 00:06: [io  0x00f0]
> [    0.142506] pnp 00:06: [irq 13]
> [    0.142540] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.142555] pnp 00:07: [io  0x0070-0x0071]
> [    0.142562] pnp 00:07: [irq 8]
> [    0.142595] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.142609] pnp 00:08: [io  0x0060]
> [    0.142612] pnp 00:08: [io  0x0064]
> [    0.142618] pnp 00:08: [irq 1]
> [    0.142654] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.142671] pnp 00:09: [irq 12]
> [    0.142708] pnp 00:09: Plug and Play ACPI device, IDs IBM0057
> PNP0f13 (active)
> [    0.143997] pnp: PnP ACPI: found 10 devices
> [    0.144000] ACPI: ACPI bus type pnp unregistered
> [    0.151487] pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x20000)
> [    0.151493] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.151497] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
> [    0.151502] pci 0000:00:01.0:   bridge window [mem 0xd4000000-0xd6ffffff]
> [    0.151507] pci 0000:00:01.0:   bridge window [mem
> 0xe0000000-0xefffffff 64bit pref]
> [    0.151512] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.151517] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
> [    0.151524] pci 0000:00:1c.0:   bridge window [mem 0xfc000000-0xfdffffff]
> [    0.151530] pci 0000:00:1c.0:   bridge window [mem
> 0xf8000000-0xf80fffff 64bit pref]
> [    0.151539] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.151544] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
> [    0.151551] pci 0000:00:1c.1:   bridge window [mem 0xdc100000-0xdf2fffff]
> [    0.151557] pci 0000:00:1c.1:   bridge window [mem
> 0xdfd00000-0xdfdfffff 64bit pref]
> [    0.151566] pci 0000:00:1c.2: PCI bridge to [bus 04]
> [    0.151570] pci 0000:00:1c.2:   bridge window [io  0x5000-0x5fff]
> [    0.151577] pci 0000:00:1c.2:   bridge window [mem 0xd8000000-0xd9ffffff]
> [    0.151583] pci 0000:00:1c.2:   bridge window [mem
> 0xdfa00000-0xdfafffff 64bit pref]
> [    0.151592] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
> [    0.151596] pci 0000:00:1c.3:   bridge window [io  0x6000-0x6fff]
> [    0.151604] pci 0000:00:1c.3:   bridge window [mem 0xd0000000-0xd1ffffff]
> [    0.151610] pci 0000:00:1c.3:   bridge window [mem
> 0xdf700000-0xdf7fffff 64bit pref]
> [    0.151619] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
> [    0.151623] pci 0000:00:1c.4:   bridge window [io  0x7000-0x7fff]
> [    0.151630] pci 0000:00:1c.4:   bridge window [mem 0xcc000000-0xcdffffff]
> [    0.151636] pci 0000:00:1c.4:   bridge window [mem
> 0xdf400000-0xdf4fffff 64bit pref]
> [    0.151648] pci 0000:15:00.0: res[15]=[mem 0x04000000-0x03ffffff
> pref] get_res_add_size add_size 4000000
> [    0.151651] pci 0000:15:00.0: res[16]=[mem 0x04000000-0x03ffffff]
> get_res_add_size add_size 4000000
> [    0.151654] pci 0000:15:00.0: res[13]=[io  0x0100-0x00ff]
> get_res_add_size add_size 100
> [    0.151657] pci 0000:15:00.0: res[14]=[io  0x0100-0x00ff]
> get_res_add_size add_size 100
> [    0.151661] pci 0000:15:00.0: BAR 15: assigned [mem
> 0xf4000000-0xf7ffffff pref]
> [    0.151666] pci 0000:15:00.0: BAR 16: assigned [mem 0xc0000000-0xc3ffffff]
> [    0.151669] pci 0000:15:00.0: BAR 13: assigned [io  0x8000-0x80ff]
> [    0.151672] pci 0000:15:00.0: BAR 14: assigned [io  0x8400-0x84ff]
> [    0.151675] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
> [    0.151678] pci 0000:15:00.0:   bridge window [io  0x8000-0x80ff]
> [    0.151685] pci 0000:15:00.0:   bridge window [io  0x8400-0x84ff]
> [    0.151692] pci 0000:15:00.0:   bridge window [mem
> 0xf4000000-0xf7ffffff pref]
> [    0.151698] pci 0000:15:00.0:   bridge window [mem 0xc0000000-0xc3ffffff]
> [    0.151705] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
> [    0.151709] pci 0000:00:1e.0:   bridge window [io  0x8000-0xbfff]
> [    0.151717] pci 0000:00:1e.0:   bridge window [mem 0xf8100000-0xfbffffff]
> [    0.151723] pci 0000:00:1e.0:   bridge window [mem
> 0xf4000000-0xf7ffffff 64bit pref]
> [    0.151791] pci 0000:00:1e.0: enabling device (0005 -> 0007)
> [    0.151799] pci 0000:00:1e.0: setting latency timer to 64
> [    0.151812] pci 0000:15:00.0: setting latency timer to 64
> [    0.151818] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.151821] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.151824] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.151827] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
> [    0.151830] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
> [    0.151832] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]
> [    0.151835] pci_bus 0000:00: resource 10 [mem 0xbf000000-0xfebfffff]
> [    0.151838] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
> [    0.151841] pci_bus 0000:01: resource 1 [mem 0xd4000000-0xd6ffffff]
> [    0.151844] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff
> 64bit pref]
> [    0.151847] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
> [    0.151850] pci_bus 0000:02: resource 1 [mem 0xfc000000-0xfdffffff]
> [    0.151853] pci_bus 0000:02: resource 2 [mem 0xf8000000-0xf80fffff
> 64bit pref]
> [    0.151856] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
> [    0.151858] pci_bus 0000:03: resource 1 [mem 0xdc100000-0xdf2fffff]
> [    0.151861] pci_bus 0000:03: resource 2 [mem 0xdfd00000-0xdfdfffff
> 64bit pref]
> [    0.151864] pci_bus 0000:04: resource 0 [io  0x5000-0x5fff]
> [    0.151867] pci_bus 0000:04: resource 1 [mem 0xd8000000-0xd9ffffff]
> [    0.151870] pci_bus 0000:04: resource 2 [mem 0xdfa00000-0xdfafffff
> 64bit pref]
> [    0.151872] pci_bus 0000:05: resource 0 [io  0x6000-0x6fff]
> [    0.151875] pci_bus 0000:05: resource 1 [mem 0xd0000000-0xd1ffffff]
> [    0.151878] pci_bus 0000:05: resource 2 [mem 0xdf700000-0xdf7fffff
> 64bit pref]
> [    0.151881] pci_bus 0000:0d: resource 0 [io  0x7000-0x7fff]
> [    0.151883] pci_bus 0000:0d: resource 1 [mem 0xcc000000-0xcdffffff]
> [    0.151886] pci_bus 0000:0d: resource 2 [mem 0xdf400000-0xdf4fffff
> 64bit pref]
> [    0.151889] pci_bus 0000:15: resource 0 [io  0x8000-0xbfff]
> [    0.151892] pci_bus 0000:15: resource 1 [mem 0xf8100000-0xfbffffff]
> [    0.151894] pci_bus 0000:15: resource 2 [mem 0xf4000000-0xf7ffffff
> 64bit pref]
> [    0.151897] pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
> [    0.151900] pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
> [    0.151903] pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.151905] pci_bus 0000:15: resource 7 [mem 0x000d4000-0x000d7fff]
> [    0.151908] pci_bus 0000:15: resource 8 [mem 0x000d8000-0x000dbfff]
> [    0.151911] pci_bus 0000:15: resource 9 [mem 0x000dc000-0x000dffff]
> [    0.151913] pci_bus 0000:15: resource 10 [mem 0xbf000000-0xfebfffff]
> [    0.151916] pci_bus 0000:16: resource 0 [io  0x8000-0x80ff]
> [    0.151919] pci_bus 0000:16: resource 1 [io  0x8400-0x84ff]
> [    0.151922] pci_bus 0000:16: resource 2 [mem 0xf4000000-0xf7ffffff pref]
> [    0.151925] pci_bus 0000:16: resource 3 [mem 0xc0000000-0xc3ffffff]
> [    0.151987] NET: Registered protocol family 2
> [    0.152991] TCP established hash table entries: 524288 (order: 11,
> 8388608 bytes)
> [    0.158688] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.159437] TCP: Hash tables configured (established 524288 bind 65536)
> [    0.159528] TCP: reno registered
> [    0.159542] UDP hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.159595] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.159770] NET: Registered protocol family 1
> [    0.159847] pci 0000:00:1a.1: power state changed by ACPI to D0
> [    0.159939] pci 0000:00:1d.0: power state changed by ACPI to D0
> [    0.160023] pci 0000:00:1d.2: power state changed by ACPI to D0
> [    0.160113] pci 0000:01:00.0: Boot video device
> [    0.160131] PCI: CLS 64 bytes, default 64
> [    0.160202] Unpacking initramfs...
> [    0.519025] Freeing initrd memory: 17220k freed
> [    0.529447] Simple Boot Flag at 0x35 set to 0x1
> [    0.530042] audit: initializing netlink socket (disabled)
> [    0.530064] type=2000 audit(1350662120.529:1): initialized
> [    0.555074] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.555780] VFS: Disk quotas dquot_6.5.2
> [    0.555809] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.556068] msgmni has been set to 5992
> [    0.556389] Block layer SCSI generic (bsg) driver version 0.4
> loaded (major 252)
> [    0.556436] io scheduler noop registered
> [    0.556439] io scheduler deadline registered
> [    0.556455] io scheduler cfq registered (default)
> [    0.556610] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
> [    0.556770] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
> [    0.556966] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
> [    0.557173] pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
> [    0.557358] pcieport 0000:00:1c.3: irq 44 for MSI/MSI-X
> [    0.557542] pcieport 0000:00:1c.4: irq 45 for MSI/MSI-X
> [    0.557694] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
> [    0.557697] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
> [    0.557702] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
> [    0.557728] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
> [    0.557734] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
> [    0.557759] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
> [    0.557762] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
> [    0.557768] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
> [    0.557794] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
> [    0.557800] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
> [    0.557826] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
> [    0.557832] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
> [    0.557860] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
> [    0.557866] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
> [    0.557957] vesafb: mode is 1024x768x16, linelength=2048, pages=0
> [    0.557958] vesafb: scrolling: redraw
> [    0.557961] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
> [    0.558186] vesafb: framebuffer at 0xd5000000, mapped to
> 0xffffc90005000000, using 1536k, total 1536k
> [    0.582364] Console: switching to colour frame buffer device 128x48
> [    0.606397] fb0: VESA VGA frame buffer device
> [    0.606409] intel_idle: does not run on family 6 model 15
> [    0.606453] GHES: HEST is not enabled!
> [    0.606510] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
> [    0.607209] Non-volatile memory driver v1.3
> [    0.607211] Linux agpgart interface v0.103
> [    0.607609] ahci 0000:00:1f.2: version 3.0
> [    0.607666] ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
> [    0.607736] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5
> Gbps 0x5 impl SATA mode
> [    0.607741] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio
> slum part ccc
> [    0.607746] ahci 0000:00:1f.2: setting latency timer to 64
> [    0.608239] scsi0 : ahci
> [    0.608350] scsi1 : ahci
> [    0.608445] scsi2 : ahci
> [    0.608498] ata1: SATA max UDMA/133 abar m2048@0xfe226000 port
> 0xfe226100 irq 46
> [    0.608501] ata2: DUMMY
> [    0.608505] ata3: SATA max UDMA/133 abar m2048@0xfe226000 port
> 0xfe226200 irq 46
> [    0.608610] libphy: Fixed MDIO Bus: probed
> [    0.608613] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.608654] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [    0.608658] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    0.608667] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
> bus number 1
> [    0.612580] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
> [    0.612599] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfe226c00
> [    0.618024] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    0.618070] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.618073] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.618076] usb usb1: Product: EHCI Host Controller
> [    0.618079] usb usb1: Manufacturer: Linux 3.6.2-2-desktop ehci_hcd
> [    0.618081] usb usb1: SerialNumber: 0000:00:1a.7
> [    0.618253] hub 1-0:1.0: USB hub found
> [    0.618259] hub 1-0:1.0: 4 ports detected
> [    0.618363] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    0.618368] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    0.618374] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
> bus number 2
> [    0.622279] ehci_hcd 0000:00:1d.7: debug port 1
> [    0.622289] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
> [    0.622309] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfe227000
> [    0.628023] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    0.628043] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.628046] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.628049] usb usb2: Product: EHCI Host Controller
> [    0.628052] usb usb2: Manufacturer: Linux 3.6.2-2-desktop ehci_hcd
> [    0.628054] usb usb2: SerialNumber: 0000:00:1d.7
> [    0.628191] hub 2-0:1.0: USB hub found
> [    0.628197] hub 2-0:1.0: 6 ports detected
> [    0.628290] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.628314] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.628341] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    0.628345] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    0.628352] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
> bus number 3
> [    0.628394] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
> [    0.628437] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.628440] usb usb3: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.628443] usb usb3: Product: UHCI Host Controller
> [    0.628446] usb usb3: Manufacturer: Linux 3.6.2-2-desktop uhci_hcd
> [    0.628448] usb usb3: SerialNumber: 0000:00:1a.0
> [    0.628570] hub 3-0:1.0: USB hub found
> [    0.628575] hub 3-0:1.0: 2 ports detected
> [    0.628661] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [    0.628665] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    0.628671] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
> bus number 4
> [    0.628710] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
> [    0.628753] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.628756] usb usb4: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.628759] usb usb4: Product: UHCI Host Controller
> [    0.628762] usb usb4: Manufacturer: Linux 3.6.2-2-desktop uhci_hcd
> [    0.628765] usb usb4: SerialNumber: 0000:00:1a.1
> [    0.628895] hub 4-0:1.0: USB hub found
> [    0.628901] hub 4-0:1.0: 2 ports detected
> [    0.628988] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    0.628993] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    0.628999] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
> bus number 5
> [    0.629055] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
> [    0.629099] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.629102] usb usb5: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.629105] usb usb5: Product: UHCI Host Controller
> [    0.629108] usb usb5: Manufacturer: Linux 3.6.2-2-desktop uhci_hcd
> [    0.629111] usb usb5: SerialNumber: 0000:00:1d.0
> [    0.629223] hub 5-0:1.0: USB hub found
> [    0.629229] hub 5-0:1.0: 2 ports detected
> [    0.629315] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    0.629319] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    0.629325] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
> bus number 6
> [    0.629364] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
> [    0.629407] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.629410] usb usb6: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.629413] usb usb6: Product: UHCI Host Controller
> [    0.629416] usb usb6: Manufacturer: Linux 3.6.2-2-desktop uhci_hcd
> [    0.629418] usb usb6: SerialNumber: 0000:00:1d.1
> [    0.629559] hub 6-0:1.0: USB hub found
> [    0.629566] hub 6-0:1.0: 2 ports detected
> [    0.629655] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    0.629659] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    0.629665] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
> bus number 7
> [    0.629705] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
> [    0.629748] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.629752] usb usb7: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.629755] usb usb7: Product: UHCI Host Controller
> [    0.629757] usb usb7: Manufacturer: Linux 3.6.2-2-desktop uhci_hcd
> [    0.629760] usb usb7: SerialNumber: 0000:00:1d.2
> [    0.629868] hub 7-0:1.0: USB hub found
> [    0.629874] hub 7-0:1.0: 2 ports detected
> [    0.629998] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU]
> at 0x60,0x64 irq 1,12
> [    0.639034] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.639069] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.639184] mousedev: PS/2 mouse device common for all mice
> [    0.639314] rtc_cmos 00:07: RTC can wake from S4
> [    0.639492] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
> [    0.639527] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    0.639536] cpuidle: using governor ladder
> [    0.639538] cpuidle: using governor menu
> [    0.639540] EFI Variables Facility v0.08 2004-May-17
> [    0.639767] usbcore: registered new interface driver usbhid
> [    0.639769] usbhid: USB HID core driver
> [    0.639946] TCP: cubic registered
> [    0.639985] NET: Registered protocol family 10
> [    0.640213] lib80211: common routines for IEEE802.11 drivers
> [    0.640216] lib80211_crypt: registered algorithm 'NULL'
> [    0.640227] Key type dns_resolver registered
> [    0.640517] PM: Checking hibernation image partition
> /dev/disk/by-id/ata-SAMSUNG_HN-M101MBB_S2R8J9BB808817-part1
> [    0.644840] input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input0
> [    0.913037] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    0.913065] ata3: SATA link down (SStatus 0 SControl 300)
> [    0.919416] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    0.919421] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
> LOCK) filtered out
> [    0.919424] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
> filtered out
> [    0.925651] ata1.00: ATA-8: SAMSUNG HN-M101MBB, 2AR10001, max UDMA/133
> [    0.925655] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth
> 31/32), AA
> [    0.932009] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    0.932013] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
> LOCK) filtered out
> [    0.932016] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
> filtered out
> [    0.938238] ata1.00: configured for UDMA/133
> [    0.938385] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
> HN-M101M 2AR1 PQ: 0 ANSI: 5
> [    0.938574] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks:
> (1.00 TB/931 GiB)
> [    0.938663] sd 0:0:0:0: [sda] Write Protect is off
> [    0.938667] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    0.938704] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    1.006704]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 > sda4
> [    1.007290] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.229030] usb 3-1: new full-speed USB device number 2 using uhci_hcd
> [    1.387392] psmouse serio1: synaptics: Touchpad model: 1, fw: 6.2,
> id: 0x81a0b1, caps: 0xa04793/0x300000/0x0, board id: 71, fw id: 67352
> [    1.387399] psmouse serio1: synaptics: serio: Synaptics
> pass-through port at isa0060/serio1/input0
> [    1.387587] usb 3-1: New USB device found, idVendor=0a5c, idProduct=2110
> [    1.387591] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    1.387594] usb 3-1: Product: BCM2045B
> [    1.387597] usb 3-1: Manufacturer: Broadcom Corp
> [    1.429252] input: SynPS/2 Synaptics TouchPad as
> /devices/platform/i8042/serio1/input/input1
> [    1.431897] PM: Hibernation image not present or could not be loaded.
> [    1.431922] registered taskstats version 1
> [    1.432670]   Magic number: 0:933:942
> [    1.432805] rtc_cmos 00:07: setting system clock to 2012-10-19
> 15:55:22 UTC (1350662122)
> [    1.434823] Freeing unused kernel memory: 960k freed
> [    1.435150] Write protecting the kernel read-only data: 12288k
> [    1.435902] Freeing unused kernel memory: 152k freed
> [    1.443256] Freeing unused kernel memory: 1908k freed
> [    1.493536] Btrfs 2012-10-10_21:55:00_+0800 loaded
> [    1.498949] alua: device handler registered
> [    1.500857] emc: device handler registered
> [    1.502788] hp_sw: device handler registered
> [    1.504733] rdac: device handler registered
> [    1.510411] udevd[105]: starting version 182
> [    1.547229] Monitor-Mwait will be used to enter C-1 state
> [    1.547240] Monitor-Mwait will be used to enter C-2 state
> [    1.547245] Monitor-Mwait will be used to enter C-3 state
> [    1.547262] ACPI: acpi_idle registered with cpuidle
> [    1.552405] thermal LNXTHERM:00: registered as thermal_zone0
> [    1.552412] ACPI: Thermal Zone [THM0] (67 C)
> [    1.553798] thermal LNXTHERM:01: registered as thermal_zone1
> [    1.553802] ACPI: Thermal Zone [THM1] (65 C)
> [    1.596070] usb 3-2: new full-speed USB device number 3 using uhci_hcd
> [    1.756469] usb 3-2: New USB device found, idVendor=0483, idProduct=2016
> [    1.756478] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    1.756483] usb 3-2: Product: Biometric Coprocessor
> [    1.756487] usb 3-2: Manufacturer: STMicroelectronics
> [    0.938605] ACPI: Invalid Power Resource to register!
> [    3.225504] device fsid 559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid
> 1 transid 521998 /dev/sda5
> [    3.253014] device fsid 9b9aa9d9-760e-445c-a0ab-68e102d9f02e devid
> 1 transid 358268 /dev/sda6
> [    3.337717] PM: Marking nosave pages: [mem 0x0009d000-0x000fffff]
> [    3.337725] PM: Basic memory bitmaps created
> [    7.270076] psmouse serio2: trackpoint: IBM TrackPoint firmware:
> 0x0e, buttons: 3/3
> [    7.503118] input: TPPS/2 IBM TrackPoint as
> /devices/platform/i8042/serio1/serio2/input/input2
> [    7.619949] PM: Basic memory bitmaps freed
> [    7.706765] PM: Starting manual resume from disk
> [    7.706772] PM: Hibernation image partition 8:1 present
> [    7.706774] PM: Looking for hibernation image.
> [    7.706941] PM: Image not found (code -22)
> [    7.706943] PM: Hibernation image not present or could not be loaded.
> [    7.728366] device fsid 9b9aa9d9-760e-445c-a0ab-68e102d9f02e devid
> 1 transid 358268 /dev/sda6
> [   25.623660] SysRq : Show Blocked State
> [   25.623667]   task                        PC stack   pid father
> [   25.623682] btrfs-cache-1   D ffffffff81608240     0   223      2 0x00000000
> [   25.623687]  ffff880036b09a70 0000000000000046 00000000000000d7
> ffff880036b09fd8
> [   25.623691]  0000000000000008 ffff880036b09fd8 ffff880036b09fd8
> ffff880036b09fd8
> [   25.623695]  ffffffff81c13420 ffff880036a56840 0000000000000000
> ffff8800bec13b20
> [   25.623699] Call Trace:
> [   25.623713]  [<ffffffff815cb2ea>] io_schedule+0x8a/0xd0
> [   25.623720]  [<ffffffff81110669>] sleep_on_page+0x9/0x10
> [   25.623725]  [<ffffffff815c9c9f>] __wait_on_bit+0x4f/0x80
> [   25.623730]  [<ffffffff8111079f>] wait_on_page_bit+0x6f/0x80
> [   25.623757]  [<ffffffffa0067455>]
> read_extent_buffer_pages+0x265/0x340 [btrfs]
> [   25.623844]  [<ffffffffa00418fe>]
> btree_read_extent_buffer_pages.constprop.119+0xae/0x110 [btrfs]
> [   25.623889]  [<ffffffffa0043453>] read_tree_block+0x33/0x50 [btrfs]
> [   25.623932]  [<ffffffffa0026665>]
> read_block_for_search.isra.48+0x165/0x420 [btrfs]
> [   25.623957]  [<ffffffffa002c47d>] btrfs_next_old_leaf+0x29d/0x4a0 [btrfs]
> [   25.623984]  [<ffffffffa0030e02>] caching_thread+0x1f2/0x3c0 [btrfs]
> [   25.624018]  [<ffffffffa0071f03>] worker_loop+0x153/0x560 [btrfs]
> [   25.624087]  [<ffffffff810688d5>] kthread+0x85/0x90
> [   25.624093]  [<ffffffff815d47b4>] kernel_thread_helper+0x4/0x10
> [   25.624097] mount           D ffffffff81608240     0   232      1 0x00000000
> [   25.624100]  ffff880036ff37a0 0000000000000086 ffffffff81077798
> ffff880036ff3fd8
> [   25.624104]  0000000081080557 ffff880036ff3fd8 ffff880036ff3fd8
> ffff880036ff3fd8
> [   25.624107]  ffffffff81c13420 ffff8800b6f4e600 ffffffff8107380b
> ffff8800b6f4e600
> [   25.624111] Call Trace:
> [   25.624116]  [<ffffffff815cbfc5>] rwsem_down_failed_common+0xc5/0x160
> [   25.624122]  [<ffffffff812f38a3>] call_rwsem_down_write_failed+0x13/0x20
> [   25.624126]  [<ffffffff815ca53c>] down_write+0x1c/0x1d
> [   25.624138]  [<ffffffffa002ec61>]
> cache_block_group.isra.44+0x241/0x380 [btrfs]
> [   25.624167]  [<ffffffffa0033f4a>] find_free_extent+0xaea/0xbb0 [btrfs]
> [   25.624200]  [<ffffffffa00378f7>] btrfs_reserve_extent+0x97/0x1d0 [btrfs]
> [   25.624235]  [<ffffffffa0037ea2>] btrfs_alloc_free_block+0xe2/0x3c0 [btrfs]
> [   25.624269]  [<ffffffffa0024327>] __btrfs_cow_block+0x137/0x570 [btrfs]
> [   25.624291]  [<ffffffffa002485f>] btrfs_cow_block+0xff/0x250 [btrfs]
> [   25.624313]  [<ffffffffa0028e59>] btrfs_search_slot+0x429/0x990 [btrfs]
> [   25.624340]  [<ffffffffa003fc55>] btrfs_lookup_inode+0x25/0xa0 [btrfs]
> [   25.624384]  [<ffffffffa0092286>]
> btrfs_update_delayed_inode+0x76/0x160 [btrfs]
> [   25.624484]  [<ffffffffa009341e>]
> __btrfs_run_delayed_items+0x13e/0x1a0 [btrfs]
> [   25.624584]  [<ffffffffa00496e7>]
> btrfs_commit_transaction+0x3b7/0xb40 [btrfs]
> [   25.624625]  [<ffffffff8119f9a0>] __sync_filesystem+0x30/0x60
> [   25.624631]  [<ffffffff81172d2b>] __do_remount_sb+0x5b/0x1a0
> [   25.624636]  [<ffffffff8118e87a>] do_remount+0xfa/0x160
> [   25.624641]  [<ffffffff811917aa>] do_mount+0x20a/0x260
> [   25.624646]  [<ffffffff8119189a>] sys_mount+0x9a/0xf0
> [   25.624649]  [<ffffffff815d36b9>] system_call_fastpath+0x16/0x1b
> [   25.624649]  [<00007f91f7141a3a>] 0x7f91f7141a39
> [   25.624649] Sched Debug Version: v0.10, 3.6.2-2-desktop #1
> [   25.624649] ktime                                   : 25624.659099
> [   25.624649] sched_clk                               : 7064.337499
> [   25.624649] cpu_clk                                 : 25624.649041
> [   25.624649] jiffies                                 : 4294692919
> [   25.624649] sched_clock_stable                      : 0
> [   25.624649]
> [   25.624649] sysctl_sched
> [   25.624649]   .sysctl_sched_latency                    : 12.000000
> [   25.624649]   .sysctl_sched_min_granularity            : 1.500000
> [   25.624649]   .sysctl_sched_wakeup_granularity         : 2.000000
> [   25.624649]   .sysctl_sched_child_runs_first           : 0
> [   25.624649]   .sysctl_sched_features                   : 24119
> [   25.624649]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
> [   25.624649]
> [   25.624649] cpu#0, 1795.416 MHz
> [   25.624649]   .nr_running                    : 0
> [   25.624649]   .load                          : 0
> [   25.624649]   .nr_switches                   : 15640
> [   25.624649]   .nr_load_updates               : 6257
> [   25.624649]   .nr_uninterruptible            : -3
> [   25.624649]   .next_balance                  : 4294.692918
> [   25.624649]   .curr->pid                     : 0
> [   25.624649]   .clock                         : 25618.786824
> [   25.624649]   .cpu_load[0]                   : 0
> [   25.624649]   .cpu_load[1]                   : 0
> [   25.624649]   .cpu_load[2]                   : 0
> [   25.624649]   .cpu_load[3]                   : 0
> [   25.624649]   .cpu_load[4]                   : 0
> [   25.624649]   .yld_count                     : 0
> [   25.624649]   .sched_count                   : 17355
> [   25.624649]   .sched_goidle                  : 6154
> [   25.624649]   .avg_idle                      : 898778
> [   25.624649]   .ttwu_count                    : 7843
> [   25.624649]   .ttwu_local                    : 6132
> [   25.624649]
> [   25.624649] cfs_rq[0]:/
> [   25.624649]   .exec_clock                    : 1882.913755
> [   25.624649]   .MIN_vruntime                  : 0.000001
> [   25.624649]   .min_vruntime                  : 2133.320027
> [   25.624649]   .max_vruntime                  : 0.000001
> [   25.624649]   .spread                        : 0.000000
> [   25.624649]   .spread0                       : 0.000000
> [   25.624649]   .nr_spread_over                : 47
> [   25.624649]   .nr_running                    : 0
> [   25.624649]   .load                          : 0
> [   25.624649]   .load_avg                      : 0.000000
> [   25.624649]   .load_period                   : 0.000000
> [   25.624649]   .load_contrib                  : 0
> [   25.624649]   .load_tg                       : 0
> [   25.624649]
> [   25.624649] rt_rq[0]:/
> [   25.624649]   .rt_nr_running                 : 0
> [   25.624649]   .rt_throttled                  : 0
> [   25.624649]   .rt_time                       : 0.000000
> [   25.624649]   .rt_runtime                    : 950.000000
> [   25.624649]
> [   25.624649] runnable tasks:
> [   25.624649]             task   PID         tree-key  switches  prio
>     exec-runtime         sum-exec        sum-sleep
> [   25.624649] ----------------------------------------------------------------------------------------------------------
> [   25.624649]
> [   25.624649] cpu#1, 1795.416 MHz
> [   25.624649]   .nr_running                    : 0
> [   25.624649]   .load                          : 0
> [   25.624649]   .nr_switches                   : 14240
> [   25.624649]   .nr_load_updates               : 7029
> [   25.624649]   .nr_uninterruptible            : 5
> [   25.624649]   .next_balance                  : 4294.693064
> [   25.624649]   .curr->pid                     : 0
> [   25.624649]   .clock                         : 25620.774323
> [   25.624649]   .cpu_load[0]                   : 0
> [   25.624649]   .cpu_load[1]                   : 128
> [   25.624649]   .cpu_load[2]                   : 144
> [   25.624649]   .cpu_load[3]                   : 104
> [   25.624649]   .cpu_load[4]                   : 82
> [   25.624649]   .yld_count                     : 0
> [   25.624649]   .sched_count                   : 15721
> [   25.624649]   .sched_goidle                  : 5413
> [   25.624649]   .avg_idle                      : 1000000
> [   25.624649]   .ttwu_count                    : 8077
> [   25.624649]   .ttwu_local                    : 5875
> [   25.624649]
> [   25.624649] cfs_rq[1]:/
> [   25.624649]   .exec_clock                    : 3328.821504
> [   25.624649]   .MIN_vruntime                  : 0.000001
> [   25.624649]   .min_vruntime                  : 4011.902391
> [   25.624649]   .max_vruntime                  : 0.000001
> [   25.624649]   .spread                        : 0.000000
> [   25.624649]   .spread0                       : 1878.582364
> [   25.624649]   .nr_spread_over                : 75
> [   25.624649]   .nr_running                    : 0
> [   25.624649]   .load                          : 0
> [   25.624649]   .load_avg                      : 0.000000
> [   25.624649]   .load_period                   : 0.000000
> [   25.624649]   .load_contrib                  : 0
> [   25.624649]   .load_tg                       : 0
> [   25.624649]
> [   25.624649] rt_rq[1]:/
> [   25.624649]   .rt_nr_running                 : 0
> [   25.624649]   .rt_throttled                  : 0
> [   25.624649]   .rt_time                       : 0.000000
> [   25.624649]   .rt_runtime                    : 950.000000
> [   25.624649]
> [   25.624649] runnable tasks:
> [   25.624649]             task   PID         tree-key  switches  prio
>     exec-runtime         sum-exec        sum-sleep
> [   25.624649] ----------------------------------------------------------------------------------------------------------
> [   25.624649]
> [   36.120328] SysRq : Show Blocked State
> [   36.120334]   task                        PC stack   pid father
> [   36.120349] btrfs-cache-1   D ffffffff81608240     0   223      2 0x00000000
> [   36.120354]  ffff880036b09a70 0000000000000046 00000000000005a5
> ffff880036b09fd8
> [   36.120358]  0000000000000008 ffff880036b09fd8 ffff880036b09fd8
> ffff880036b09fd8
> [   36.120362]  ffff8800ba3323c0 ffff880036a56840 0000000000000000
> ffff8800bed13b20
> [   36.120366] Call Trace:
> [   36.120380]  [<ffffffff815cb2ea>] io_schedule+0x8a/0xd0
> [   36.120387]  [<ffffffff81110669>] sleep_on_page+0x9/0x10
> [   36.120393]  [<ffffffff815c9c9f>] __wait_on_bit+0x4f/0x80
> [   36.120398]  [<ffffffff8111079f>] wait_on_page_bit+0x6f/0x80
> [   36.120424]  [<ffffffffa0067455>]
> read_extent_buffer_pages+0x265/0x340 [btrfs]
> [   36.120506]  [<ffffffffa00418fe>]
> btree_read_extent_buffer_pages.constprop.119+0xae/0x110 [btrfs]
> [   36.120551]  [<ffffffffa0043453>] read_tree_block+0x33/0x50 [btrfs]
> [   36.120594]  [<ffffffffa0026665>]
> read_block_for_search.isra.48+0x165/0x420 [btrfs]
> [   36.120618]  [<ffffffffa002c47d>] btrfs_next_old_leaf+0x29d/0x4a0 [btrfs]
> [   36.120646]  [<ffffffffa0030e02>] caching_thread+0x1f2/0x3c0 [btrfs]
> [   36.120680]  [<ffffffffa0071f03>] worker_loop+0x153/0x560 [btrfs]
> [   36.120749]  [<ffffffff810688d5>] kthread+0x85/0x90
> [   36.120754]  [<ffffffff815d47b4>] kernel_thread_helper+0x4/0x10
> [   36.120758] mount           D ffffffff81608240     0   232      1 0x00000000
> [   36.120762]  ffff880036ff37a0 0000000000000086 ffffffff81077798
> ffff880036ff3fd8
> [   36.120765]  0000000081080557 ffff880036ff3fd8 ffff880036ff3fd8
> ffff880036ff3fd8
> [   36.120769]  ffffffff81c13420 ffff8800b6f4e600 ffffffff8107380b
> ffff8800b6f4e600
> [   36.120772] Call Trace:
> [   36.120777]  [<ffffffff815cbfc5>] rwsem_down_failed_common+0xc5/0x160
> [   36.120783]  [<ffffffff812f38a3>] call_rwsem_down_write_failed+0x13/0x20
> [   36.120787]  [<ffffffff815ca53c>] down_write+0x1c/0x1d
> [   36.120799]  [<ffffffffa002ec61>]
> cache_block_group.isra.44+0x241/0x380 [btrfs]
> [   36.120828]  [<ffffffffa0033f4a>] find_free_extent+0xaea/0xbb0 [btrfs]
> [   36.120862]  [<ffffffffa00378f7>] btrfs_reserve_extent+0x97/0x1d0 [btrfs]
> [   36.120897]  [<ffffffffa0037ea2>] btrfs_alloc_free_block+0xe2/0x3c0 [btrfs]
> [   36.120931]  [<ffffffffa0024327>] __btrfs_cow_block+0x137/0x570 [btrfs]
> [   36.120953]  [<ffffffffa002485f>] btrfs_cow_block+0xff/0x250 [btrfs]
> [   36.120975]  [<ffffffffa0028e59>] btrfs_search_slot+0x429/0x990 [btrfs]
> [   36.121002]  [<ffffffffa003fc55>] btrfs_lookup_inode+0x25/0xa0 [btrfs]
> [   36.121045]  [<ffffffffa0092286>]
> btrfs_update_delayed_inode+0x76/0x160 [btrfs]
> [   36.121145]  [<ffffffffa009341e>]
> __btrfs_run_delayed_items+0x13e/0x1a0 [btrfs]
> [   36.121245]  [<ffffffffa00496e7>]
> btrfs_commit_transaction+0x3b7/0xb40 [btrfs]
> [   36.121286]  [<ffffffff8119f9a0>] __sync_filesystem+0x30/0x60
> [   36.121292]  [<ffffffff81172d2b>] __do_remount_sb+0x5b/0x1a0
> [   36.121297]  [<ffffffff8118e87a>] do_remount+0xfa/0x160
> [   36.121302]  [<ffffffff811917aa>] do_mount+0x20a/0x260
> [   36.121307]  [<ffffffff8119189a>] sys_mount+0x9a/0xf0
> [   36.121311]  [<ffffffff815d36b9>] system_call_fastpath+0x16/0x1b
> [   36.121316]  [<00007f91f7141a3a>] 0x7f91f7141a39
> [   36.121318] Sched Debug Version: v0.10, 3.6.2-2-desktop #1
> [   36.121318] ktime                                   : 36121.320077
> [   36.121318] sched_clk                               : 8391.291398
> [   36.121318] cpu_clk                                 : 36121.318470
> [   36.121318] jiffies                                 : 4294703416
> [   36.121318] sched_clock_stable                      : 0
> [   36.121318]
> [   36.121318] sysctl_sched
> [   36.121318]   .sysctl_sched_latency                    : 12.000000
> [   36.121318]   .sysctl_sched_min_granularity            : 1.500000
> [   36.121318]   .sysctl_sched_wakeup_granularity         : 2.000000
> [   36.121318]   .sysctl_sched_child_runs_first           : 0
> [   36.121318]   .sysctl_sched_features                   : 24119
> [   36.121318]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
> [   36.121318]
> [   36.121318] cpu#0, 1795.416 MHz
> [   36.121318]   .nr_running                    : 0
> [   36.121318]   .load                          : 0
> [   36.121318]   .nr_switches                   : 20280
> [   36.121318]   .nr_load_updates               : 8517
> [   36.121318]   .nr_uninterruptible            : -3
> [   36.121318]   .next_balance                  : 4294.703418
> [   36.121318]   .curr->pid                     : 0
> [   36.121318]   .clock                         : 36118.067602
> [   36.121318]   .cpu_load[0]                   : 0
> [   36.121318]   .cpu_load[1]                   : 0
> [   36.121318]   .cpu_load[2]                   : 0
> [   36.121318]   .cpu_load[3]                   : 0
> [   36.121318]   .cpu_load[4]                   : 0
> [   36.121318]   .yld_count                     : 0
> [   36.121318]   .sched_count                   : 22925
> [   36.121318]   .sched_goidle                  : 8213
> [   36.121318]   .avg_idle                      : 717345
> [   36.121318]   .ttwu_count                    : 10297
> [   36.121318]   .ttwu_local                    : 7984
> [   36.121318]
> [   36.121318] cfs_rq[0]:/
> [   36.121318]   .exec_clock                    : 2417.624169
> [   36.121318]   .MIN_vruntime                  : 0.000001
> [   36.121318]   .min_vruntime                  : 2599.573906
> [   36.121318]   .max_vruntime                  : 0.000001
> [   36.121318]   .spread                        : 0.000000
> [   36.121318]   .spread0                       : 0.000000
> [   36.121318]   .nr_spread_over                : 47
> [   36.121318]   .nr_running                    : 0
> [   36.121318]   .load                          : 0
> [   36.121318]   .load_avg                      : 0.000000
> [   36.121318]   .load_period                   : 0.000000
> [   36.121318]   .load_contrib                  : 0
> [   36.121318]   .load_tg                       : 0
> [   36.121318]
> [   36.121318] rt_rq[0]:/
> [   36.121318]   .rt_nr_running                 : 0
> [   36.121318]   .rt_throttled                  : 0
> [   36.121318]   .rt_time                       : 0.030199
> [   36.121318]   .rt_runtime                    : 950.000000
> [   36.121318]
> [   36.121318] runnable tasks:
> [   36.121318]             task   PID         tree-key  switches  prio
>     exec-runtime         sum-exec        sum-sleep
> [   36.121318] ----------------------------------------------------------------------------------------------------------
> [   36.121318]
> [   36.121318] cpu#1, 1795.416 MHz
> [   36.121318]   .nr_running                    : 0
> [   36.121318]   .load                          : 0
> [   36.121318]   .nr_switches                   : 18668
> [   36.121318]   .nr_load_updates               : 9064
> [   36.121318]   .nr_uninterruptible            : 5
> [   36.121318]   .next_balance                  : 4294.703493
> [   36.121318]   .curr->pid                     : 0
> [   36.121318]   .clock                         : 36111.032064
> [   36.121318]   .cpu_load[0]                   : 1024
> [   36.121318]   .cpu_load[1]                   : 560
> [   36.121318]   .cpu_load[2]                   : 403
> [   36.121318]   .cpu_load[3]                   : 293
> [   36.121318]   .cpu_load[4]                   : 204
> [   36.121318]   .yld_count                     : 0
> [   36.121318]   .sched_count                   : 21114
> [   36.121318]   .sched_goidle                  : 7366
> [   36.121318]   .avg_idle                      : 709543
> [   36.121318]   .ttwu_count                    : 10475
> [   36.121318]   .ttwu_local                    : 7655
> [   36.121318]
> [   36.121318] cfs_rq[1]:/
> [   36.121318]   .exec_clock                    : 3757.233371
> [   36.121318]   .MIN_vruntime                  : 0.000001
> [   36.121318]   .min_vruntime                  : 4373.535480
> [   36.121318]   .max_vruntime                  : 0.000001
> [   36.121318]   .spread                        : 0.000000
> [   36.121318]   .spread0                       : 1773.961574
> [   36.121318]   .nr_spread_over                : 75
> [   36.121318]   .nr_running                    : 0
> [   36.121318]   .load                          : 0
> [   36.121318]   .load_avg                      : 0.000000
> [   36.121318]   .load_period                   : 0.000000
> [   36.121318]   .load_contrib                  : 0
> [   36.121318]   .load_tg                       : 0
> [   36.121318]
> [   36.121318] rt_rq[1]:/
> [   36.121318]   .rt_nr_running                 : 0
> [   36.121318]   .rt_throttled                  : 0
> [   36.121318]   .rt_time                       : 0.017123
> [   36.121318]   .rt_runtime                    : 950.000000
> [   36.121318]
> [   36.121318] runnable tasks:
> [   36.121318]             task   PID         tree-key  switches  prio
>     exec-runtime         sum-exec        sum-sleep
> [   36.121318] ----------------------------------------------------------------------------------------------------------
> [   36.121318]
> [   95.634151] SysRq : Show Blocked State
> [   95.634344]   task                        PC stack   pid father
> [   95.634358] btrfs-cache-1   D ffffffff81608240     0   223      2 0x00000000
> [   95.634363]  ffff880036b09a70 0000000000000046 000000000000016e
> ffff880036b09fd8
> [   95.634367]  0000000000000008 ffff880036b09fd8 ffff880036b09fd8
> ffff880036b09fd8
> [   95.634370]  ffff8800ba3323c0 ffff880036a56840 0000000000000000
> ffff8800bed13b20
> [   95.634374] Call Trace:
> [   95.634389]  [<ffffffff815cb2ea>] io_schedule+0x8a/0xd0
> [   95.634395]  [<ffffffff81110669>] sleep_on_page+0x9/0x10
> [   95.634400]  [<ffffffff815c9c9f>] __wait_on_bit+0x4f/0x80
> [   95.634404]  [<ffffffff8111079f>] wait_on_page_bit+0x6f/0x80
> [   95.634430]  [<ffffffffa0067455>]
> read_extent_buffer_pages+0x265/0x340 [btrfs]
> [   95.634504]  [<ffffffffa00418fe>]
> btree_read_extent_buffer_pages.constprop.119+0xae/0x110 [btrfs]
> [   95.634549]  [<ffffffffa0043453>] read_tree_block+0x33/0x50 [btrfs]
> [   95.634592]  [<ffffffffa0026665>]
> read_block_for_search.isra.48+0x165/0x420 [btrfs]
> [   95.634617]  [<ffffffffa002c47d>] btrfs_next_old_leaf+0x29d/0x4a0 [btrfs]
> [   95.634645]  [<ffffffffa0030e02>] caching_thread+0x1f2/0x3c0 [btrfs]
> [   95.634679]  [<ffffffffa0071f03>] worker_loop+0x153/0x560 [btrfs]
> [   95.634747]  [<ffffffff810688d5>] kthread+0x85/0x90
> [   95.634753]  [<ffffffff815d47b4>] kernel_thread_helper+0x4/0x10
> [   95.634757] btrfs-transacti D ffffffff81608240     0   226      2 0x00000000
> [   95.634760]  ffff880036f37db0 0000000000000046 0000000000000000
> ffff880036f37fd8
> [   95.634764]  ffff88003688e1c0 ffff880036f37fd8 ffff880036f37fd8
> ffff880036f37fd8
> [   95.634767]  ffff8800ba3323c0 ffff88003688e1c0 0000000000000246
> ffff88003645fe70
> [   95.634771] Call Trace:
> [   95.634786]  [<ffffffffa0047c55>] wait_for_commit.isra.19+0x55/0x90 [btrfs]
> [   95.634835]  [<ffffffffa0049c31>]
> btrfs_commit_transaction+0x901/0xb40 [btrfs]
> [   95.634885]  [<ffffffffa00425fd>] transaction_kthread+0x19d/0x220 [btrfs]
> [   95.634920]  [<ffffffff810688d5>] kthread+0x85/0x90
> [   95.634924]  [<ffffffff815d47b4>] kernel_thread_helper+0x4/0x10
> [   95.634927] mount           D ffffffff81608240     0   232      1 0x00000000
> [   95.634930]  ffff880036ff37a0 0000000000000086 ffffffff81077798
> ffff880036ff3fd8
> [   95.634934]  ffff880036a56e74 ffff880036ff3fd8 ffff880036ff3fd8
> ffff880036ff3fd8
> [   95.634937]  ffffffff81c13420 ffff8800b6f4e600 ffffffff8107380b
> ffff8800b6f4e600
> [   95.634940] Call Trace:
> [   95.634945]  [<ffffffff815cbfc5>] rwsem_down_failed_common+0xc5/0x160
> [   95.634951]  [<ffffffff812f38a3>] call_rwsem_down_write_failed+0x13/0x20
> [   95.634955]  [<ffffffff815ca53c>] down_write+0x1c/0x1d
> [   95.634967]  [<ffffffffa002ec61>]
> cache_block_group.isra.44+0x241/0x380 [btrfs]
> [   95.634996]  [<ffffffffa0033f4a>] find_free_extent+0xaea/0xbb0 [btrfs]
> [   95.635029]  [<ffffffffa00378f7>] btrfs_reserve_extent+0x97/0x1d0 [btrfs]
> [   95.635065]  [<ffffffffa0037ea2>] btrfs_alloc_free_block+0xe2/0x3c0 [btrfs]
> [   95.635098]  [<ffffffffa0024327>] __btrfs_cow_block+0x137/0x570 [btrfs]
> [   95.635120]  [<ffffffffa002485f>] btrfs_cow_block+0xff/0x250 [btrfs]
> [   95.635141]  [<ffffffffa0028e59>] btrfs_search_slot+0x429/0x990 [btrfs]
> [   95.635141]  [<ffffffffa003fc55>] btrfs_lookup_inode+0x25/0xa0 [btrfs]
> [   95.635141]  [<ffffffffa0092286>]
> btrfs_update_delayed_inode+0x76/0x160 [btrfs]
> [   95.635141]  [<ffffffffa009341e>]
> __btrfs_run_delayed_items+0x13e/0x1a0 [btrfs]
> [   95.635141]  [<ffffffffa00496e7>]
> btrfs_commit_transaction+0x3b7/0xb40 [btrfs]
> [   95.635141]  [<ffffffff8119f9a0>] __sync_filesystem+0x30/0x60
> [   95.635141]  [<ffffffff81172d2b>] __do_remount_sb+0x5b/0x1a0
> [   95.635141]  [<ffffffff8118e87a>] do_remount+0xfa/0x160
> [   95.635141]  [<ffffffff811917aa>] do_mount+0x20a/0x260
> [   95.635141]  [<ffffffff8119189a>] sys_mount+0x9a/0xf0
> [   95.635141]  [<ffffffff815d36b9>] system_call_fastpath+0x16/0x1b
> [   95.635141]  [<00007f91f7141a3a>] 0x7f91f7141a39
> [   95.635141] Sched Debug Version: v0.10, 3.6.2-2-desktop #1
> [   95.635141] ktime                                   : 95635.487872
> [   95.635141] sched_clk                               : 11797.958510
> [   95.635141] cpu_clk                                 : 95635.141180
> [   95.635141] jiffies                                 : 4294762930
> [   95.635141] sched_clock_stable                      : 0
> [   95.635141]
> [   95.635141] sysctl_sched
> [   95.635141]   .sysctl_sched_latency                    : 12.000000
> [   95.635141]   .sysctl_sched_min_granularity            : 1.500000
> [   95.635141]   .sysctl_sched_wakeup_granularity         : 2.000000
> [   95.635141]   .sysctl_sched_child_runs_first           : 0
> [   95.635141]   .sysctl_sched_features                   : 24119
> [   95.635141]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
> [   95.635141]
> [   95.635141] cpu#0, 1795.416 MHz
> [   95.635141]   .nr_running                    : 0
> [   95.635141]   .load                          : 0
> [   95.635141]   .nr_switches                   : 40507
> [   95.635141]   .nr_load_updates               : 17782
> [   95.635141]   .nr_uninterruptible            : -3
> [   95.635141]   .next_balance                  : 4294.762900
> [   95.635141]   .curr->pid                     : 0
> [   95.635141]   .clock                         : 95631.914946
> [   95.635141]   .cpu_load[0]                   : 0
> [   95.635141]   .cpu_load[1]                   : 0
> [   95.635141]   .cpu_load[2]                   : 0
> [   95.635141]   .cpu_load[3]                   : 0
> [   95.635141]   .cpu_load[4]                   : 0
> [   95.635141]   .yld_count                     : 0
> [   95.635141]   .sched_count                   : 47787
> [   95.635141]   .sched_goidle                  : 17131
> [   95.635141]   .avg_idle                      : 889340
> [   95.635141]   .ttwu_count                    : 21460
> [   95.635141]   .ttwu_local                    : 15717
> [   95.635141]
> [   95.635141] cfs_rq[0]:/
> [   95.635141]   .exec_clock                    : 3245.515102
> [   95.635141]   .MIN_vruntime                  : 0.000001
> [   95.635141]   .min_vruntime                  : 3320.081027
> [   95.635141]   .max_vruntime                  : 0.000001
> [   95.635141]   .spread                        : 0.000000
> [   95.635141]   .spread0                       : 0.000000
> [   95.635141]   .nr_spread_over                : 47
> [   95.635141]   .nr_running                    : 0
> [   95.635141]   .load                          : 0
> [   95.635141]   .load_avg                      : 0.000000
> [   95.635141]   .load_period                   : 0.000000
> [   95.635141]   .load_contrib                  : 0
> [   95.635141]   .load_tg                       : 0
> [   95.635141]
> [   95.635141] rt_rq[0]:/
> [   95.635141]   .rt_nr_running                 : 0
> [   95.635141]   .rt_throttled                  : 0
> [   95.635141]   .rt_time                       : 0.000000
> [   95.635141]   .rt_runtime                    : 950.000000
> [   95.635141]
> [   95.635141] runnable tasks:
> [   95.635141]             task   PID         tree-key  switches  prio
>     exec-runtime         sum-exec        sum-sleep
> [   95.635141] ----------------------------------------------------------------------------------------------------------
> [   95.635141]
> [   95.635141] cpu#1, 1795.416 MHz
> [   95.635141]   .nr_running                    : 0
> [   95.635141]   .load                          : 0
> [   95.635141]   .nr_switches                   : 38358
> [   95.635141]   .nr_load_updates               : 17854
> [   95.635141]   .nr_uninterruptible            : 6
> [   95.635141]   .next_balance                  : 4294.762929
> [   95.635141]   .curr->pid                     : 0
> [   95.635141]   .clock                         : 95631.964813
> [   95.635141]   .cpu_load[0]                   : 0
> [   95.635141]   .cpu_load[1]                   : 0
> [   95.635141]   .cpu_load[2]                   : 0
> [   95.635141]   .cpu_load[3]                   : 0
> [   95.635141]   .cpu_load[4]                   : 0
> [   95.635141]   .yld_count                     : 0
> [   95.635141]   .sched_count                   : 45459
> [   95.635141]   .sched_goidle                  : 16039
> [   95.635141]   .avg_idle                      : 902589
> [   95.635141]   .ttwu_count                    : 21363
> [   95.635141]   .ttwu_local                    : 15125
> [   95.635141]
> [   95.635141] cfs_rq[1]:/
> [   95.635141]   .exec_clock                    : 4548.674243
> [   95.635141]   .MIN_vruntime                  : 0.000001
> [   95.635141]   .min_vruntime                  : 5061.497501
> [   95.635141]   .max_vruntime                  : 0.000001
> [   95.635141]   .spread                        : 0.000000
> [   95.635141]   .spread0                       : 1741.416474
> [   95.635141]   .nr_spread_over                : 75
> [   95.635141]   .nr_running                    : 0
> [   95.635141]   .load                          : 0
> [   95.635141]   .load_avg                      : 0.000000
> [   95.635141]   .load_period                   : 0.000000
> [   95.635141]   .load_contrib                  : 0
> [   95.635141]   .load_tg                       : 0
> [   95.635141]
> [   95.635141] rt_rq[1]:/
> [   95.635141]   .rt_nr_running                 : 0
> [   95.635141]   .rt_throttled                  : 0
> [   95.635141]   .rt_time                       : 0.000000
> [   95.635141]   .rt_runtime                    : 950.000000
> [   95.635141]
> [   95.635141] runnable tasks:
> [   95.635141]             task   PID         tree-key  switches  prio
>     exec-runtime         sum-exec        sum-sleep
> [   95.635141] ----------------------------------------------------------------------------------------------------------
> [   95.635141]
> [  129.014483] microcode: CPU0 sig=0x6fd, pf=0x80, revision=0xa3
> [  132.309219] udevd[313]: starting version 182
> [  136.204791] firmware microcode: firmware_loading_store: unexpected value (0)
> [  136.205231] microcode: CPU1 sig=0x6fd, pf=0x80, revision=0xa3
> [  136.206020] microcode: CPU1 updated to revision 0xa4, date = 2010-10-02
> [  136.206076] microcode: Microcode Update Driver: v2.00
> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [  136.312520] ACPI: Deprecated procfs I/F for AC is loaded, please
> retry with CONFIG_ACPI_PROCFS_POWER cleared
> [  136.312741] ACPI: AC Adapter [AC] (on-line)
> [  136.313057] ACPI: Deprecated procfs I/F for battery is loaded,
> please retry with CONFIG_ACPI_PROCFS_POWER cleared
> [  136.313064] ACPI: Battery Slot [BAT0] (battery absent)
> [  136.331853] input: Lid Switch as
> /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input3
> [  136.332151] ACPI: Lid Switch [LID]
> [  136.332215] input: Sleep Button as
> /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input4
> [  136.332267] ACPI: Sleep Button [SLPB]
> [  136.332347] input: Power Button as
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
> [  136.332393] ACPI: Power Button [PWRF]
> [  137.381780] acpi device:06: registered as cooling_device2
> [  137.381845] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
> [  137.381918] input: Video Bus as
> /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:05/LNXVIDEO:01/input/input6
> [  138.307158] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
> [  138.307163] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
> [  138.307210] e1000e 0000:00:19.0: setting latency timer to 64
> [  138.307301] e1000e 0000:00:19.0: Interrupt Throttling Rate
> (ints/sec) set to dynamic conservative mode
> [  138.307360] e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
> [  138.621169] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width
> x1) 00:1e:37:d4:77:b5
> [  138.621174] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
> [  138.621203] e1000e 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: 1008FF-0FF
> [  138.685292] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [  138.703228] wmi: Mapper loaded
> [  139.026652] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c4]
> [  139.148856] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
> [  139.148863] yenta_cardbus 0000:15:00.0: Socket status: 30000006
> [  139.148871] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge
> window: [io  0x8000-0xbfff]
> [  139.148875] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge
> window: [mem 0xf8100000-0xfbffffff]
> [  139.148879] pcmcia_socket pcmcia_socket0: cs: memory probe
> 0xf8100000-0xfbffffff:
> [  139.148884]  excluding 0xf8100000-0xf84effff
> [  139.148898] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge
> window: [mem 0xf4000000-0xf7ffffff 64bit pref]
> [  139.148901] pcmcia_socket pcmcia_socket0: cs: memory probe
> 0xf4000000-0xf7ffffff:
> [  139.148920]  excluding 0xf4000000-0xf7ffffff
> [  139.269542] ACPI Warning: 0x0000000000001028-0x000000000000102f
> SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1
> (20120711/utaddress-251)
> [  139.269551] ACPI: If an ACPI driver is available for this device,
> you should use it instead of the native driver
> [  139.269556] ACPI Warning: 0x0000000000001180-0x00000000000011bf
> SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1
> (20120711/utaddress-251)
> [  139.269561] ACPI: If an ACPI driver is available for this device,
> you should use it instead of the native driver
> [  139.269563] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [  139.341118] Bluetooth: Core ver 2.16
> [  139.341159] NET: Registered protocol family 31
> [  139.341161] Bluetooth: HCI device and connection manager initialized
> [  139.341164] Bluetooth: HCI socket layer initialized
> [  139.341166] Bluetooth: L2CAP socket layer initialized
> [  139.341178] Bluetooth: SCO socket layer initialized
> [  139.349126] cfg80211: Calling CRDA to update world regulatory domain
> [  139.742216] ata_piix 0000:00:1f.1: version 2.13
> [  139.742299] ata_piix 0000:00:1f.1: setting latency timer to 64
> [  139.742694] scsi3 : ata_piix
> [  139.743078] scsi4 : ata_piix
> [  139.743150] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1830 irq 14
> [  139.743154] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1838 irq 15
> [  139.743344] ata5: port disabled--ignoring
> [  139.897703] ata4.00: ATAPI: MATSHITADVD-RAM UJ-852, RB02, max UDMA/33
> [  139.903542] ata4.00: configured for UDMA/33
> [  139.906003] scsi 3:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-852
>   RB02 PQ: 0 ANSI: 5
> [  139.906326] scsi 3:0:0:0: Attached scsi generic sg1 type 5
> [  140.188941] input: PC Speaker as /devices/platform/pcspkr/input/input7
> [  140.240327] iTCO_vendor_support: vendor-support=0
> [  140.241190] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
> [  140.241232] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
> [  140.241477] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [  140.289508] thinkpad_acpi: ThinkPad ACPI Extras v0.24
> [  140.289512] thinkpad_acpi: http://ibm-acpi.sf.net/
> [  140.289514] thinkpad_acpi: ThinkPad BIOS 7LETB7WW (2.17 ), EC 7KHT24WW-1.08
> [  140.289516] thinkpad_acpi: Lenovo ThinkPad T61, model 8889CG1
> [  140.289980] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
> [  140.291140] thinkpad_acpi: ACPI backlight control delay disabled
> [  140.291302] thinkpad_acpi: radio switch found; radios are enabled
> [  140.291323] thinkpad_acpi: This ThinkPad has standard ACPI
> backlight brightness control, supported by the ACPI video driver
> [  140.291325] thinkpad_acpi: Disabling thinkpad-acpi brightness
> events by default...
> [  140.292545] thinkpad_acpi: setting the hotkey mask to 0x00ffffff is
> likely not the best way to go about it
> [  140.292548] thinkpad_acpi: please consider using the driver
> defaults, and refer to up-to-date thinkpad-acpi documentation
> [  140.295579] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio
> is unblocked
> [  140.296299] Registered led device: tpacpi::thinklight
> [  140.296648] Registered led device: tpacpi::power
> [  140.296676] Registered led device: tpacpi::standby
> [  140.296697] Registered led device: tpacpi::thinkvantage
> [  140.299373] thinkpad_acpi: Standard ACPI backlight interface
> available, not loading native one
> [  140.299707] thinkpad_acpi: Console audio control enabled, mode:
> monitor (read only)
> [  140.301761] input: ThinkPad Extra Buttons as
> /devices/platform/thinkpad_acpi/input/input8
> [  140.678059] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network
> Connection driver for Linux, in-tree:s
> [  140.678063] iwl3945: Copyright(c) 2003-2011 Intel Corporation
> [  140.699150] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
> [  140.733878] iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13
> 802.11a channels
> [  140.733885] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
> [  140.734070] iwl3945 0000:03:00.0: irq 48 for MSI/MSI-X
> [  140.734378] Registered led device: phy0-led
> [  140.957203] usbcore: registered new interface driver btusb
> [  141.010854] hda_intel: probe_mask set to 0x1 for device 17aa:20ac
> [  141.010934] snd_hda_intel 0000:00:1b.0: irq 49 for MSI/MSI-X
> [  141.020378] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff:
> [  139.906562] ACPI: Invalid Power Resource to register!
> [  141.020388]  excluding 0xc0000-0xd3fff 0xe0000-0xfffff
> [  141.020443] pcmcia_socket pcmcia_socket0: cs: memory probe
> 0xa0000000-0xa0ffffff:
> [  141.020454]  excluding 0xa0000000-0xa0ffffff
> [  141.020543] pcmcia_socket pcmcia_socket0: cs: memory probe
> 0x60000000-0x60ffffff:
> [  141.020554]  excluding 0x60000000-0x60ffffff
> [  141.164600] ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
> [  141.449876] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
> xa/form2 cdda tray
> [  141.449880] cdrom: Uniform CD-ROM driver Revision: 3.20
> [  141.450140] sr 3:0:0:0: Attached scsi CD-ROM sr0
> [  141.614257] input: HDA Digital PCBeep as
> /devices/pci0000:00/0000:00:1b.0/input/input9
> [  141.722201] nvidia: module license 'NVIDIA' taints kernel.
> [  141.722207] Disabling lock debugging due to kernel taint
> [  141.749381] vgaarb: device changed decodes:
> PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
> [  141.749694] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  304.51
> Tue Sep 18 17:16:56 PDT 2012
> [  142.768707] cfg80211: World regulatory domain updated:
> [  142.768712] cfg80211:   (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [  142.768715] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> [  142.768717] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz),
> (300 mBi, 2000 mBm)
> [  142.768719] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
> (300 mBi, 2000 mBm)
> [  142.768721] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> [  142.768723] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> [  146.019762] Adding 2103292k swap on /dev/sda1.  Priority:-1
> extents:1 across:2103292k
> [  151.359987] EXT4-fs (sda2): mounted filesystem with ordered data
> mode. Opts: acl,user_xattr
> [  376.819352] e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
> [  376.920168] e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
> [  376.920335] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [  377.289963] iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
> [  377.357128] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  377.388511] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [  377.388516] Bluetooth: BNEP filters: protocol multicast
> [  377.623561] Bluetooth: RFCOMM TTY layer initialized
> [  377.623568] Bluetooth: RFCOMM socket layer initialized
> [  377.623570] Bluetooth: RFCOMM ver 1.11
> [  377.669635] NET: Registered protocol family 17
> [  382.971642] NVRM: GPU at 0000:01:00: GPU-dd980f70-0cf3-5f28-9ca8-728ac781814e
> [  382.971657] NVRM: Your system is not currently configured to drive
> a VGA console
> [  382.971664] NVRM: on the primary VGA device. The NVIDIA Linux graphics driver
> [  382.971669] NVRM: requires the use of a text-mode VGA console. Use
> of other console
> [  382.971673] NVRM: drivers including, but not limited to, vesafb,
> may result in
> [  382.971677] NVRM: corruption and stability problems, and is not supported.
> [  387.909141] device fsid 559dec06-4fd0-47c1-97b8-cc4fa6153fa0 devid
> 1 transid 521998 /dev/sda5
> [  387.909941] btrfs: disk space caching is enabled
> [  392.369777] wlan0: authenticate with 00:e5:41:3a:ed:e3
> [  392.371500] wlan0: send auth to 00:e5:41:3a:ed:e3 (try 1/3)
> [  392.373352] wlan0: authenticated
> [  392.373511] iwl3945 0000:03:00.0: wlan0: disabling HT as WMM/QoS is
> not supported
> [  392.375029] wlan0: associate with 00:e5:41:3a:ed:e3 (try 1/3)
> [  392.377264] wlan0: RX AssocResp from 00:e5:41:3a:ed:e3 (capab=0x401
> status=0 aid=3)
> [  392.378587] wlan0: associated
> [  392.378621] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  422.563905] EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr,commit=0
> [  466.021093] fuse init (API version 7.20)

It appears space_cache isn't enabled on your rootfs; can you do a
"mount / -o remount,space_cache", sync a couple times, make some
coffee, and then reboot, and see if it's better?

You should see two instances of "btrfs: disk space caching is enabled"
in your dmesg, one for / and the second for /home.

Also, make sure to reply-all so that others interested can still follow along.
