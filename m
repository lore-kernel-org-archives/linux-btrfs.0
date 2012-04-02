From: Dave Jones <davej@redhat.com>
Subject: Re: btrfs io errors on 3.4rc1
Date: Mon, 2 Apr 2012 17:40:51 -0400
Message-ID: <20120402214051.GB2487@redhat.com>
References: <20120402180214.GA1830@redhat.com>
 <20120402194814.GA10965@shiny.msi.event>
 <20120402211622.GA2487@redhat.com>
 <20120402212608.GA14958@shiny.msi.event>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120402212608.GA14958@shiny.msi.event>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 02, 2012 at 05:26:08PM -0400, Chris Mason wrote:
 > On Mon, Apr 02, 2012 at 05:16:22PM -0400, Dave Jones wrote:
 > > On Mon, Apr 02, 2012 at 03:48:14PM -0400, Chris Mason wrote:
 > >  > On Mon, Apr 02, 2012 at 02:02:14PM -0400, Dave Jones wrote:
 > >  > > Updated to rc1 this morning, and my machines with btrfs are all freaking out..
 > >  > > 
 > >  > > I got this from my cron email ..
 > >  > > 
 > >  > > /etc/cron.daily/prelink: line 41: /var/lib/prelink/full: Input/output error
 > >  > > cp: cannot create regular file `/var/lib/prelink/quick': Input/output error
 > >  > > /etc/cron.daily/prelink: line 45: /var/log/prelink/prelink.log: Input/output error
 > >  > 
 > >  > That's not good.  Can you please try my for-linus branch against 3.3?
 > >  > That will rules out all the shiny new btrfs code.
 > >  > 
 > >  > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
 > >  > 
 > >  > -chris
 > > 
 > > Broken.
 > > 
 > > (17:14:52:davej@dhcp-189-232:~)$ fsx foo
 > > truncating to largest ever: 0x13e76
 > > truncating to largest ever: 0x2e52c
 > > ftruncate1: 2e52c
 > > dotruncate: ftruncate: Input/output error
 > > Segmentation fault (core dumped)
 > 
 > Huh.  x86-32 or x86-64?  I know you said there were no interesting
 > messages, but could you please send the messages you did get?

x86-64.

dmesg below.  (ignore the rpc oops, reported elsewhere, it's unrelated)

	Dave


[    0.000000] Linux version 3.4.0-rc1+ (davej@gelk.kernelslacker.org) (gcc version 4.6.3 20120306 (Red Hat 4.6.3-2) (GCC) ) #28 SMP PREEMPT Sun Apr 1 17:41:59 EDT 2012
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.4.0-rc1+ root=UUID=1e0563a9-9105-43ef-b7ec-5cbbc76b28ab ro rd.md=0 rd.lvm=0 rd.dm=0 KEYTABLE=us console=ttyS0,115200 console=tty0 SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 LANG=en_US.UTF-8 debug_guardpage_minorder=2
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bee37000 (usable)
[    0.000000]  BIOS-e820: 00000000bee37000 - 00000000beef1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000beef1000 - 00000000bfea2000 (usable)
[    0.000000]  BIOS-e820: 00000000bfea2000 - 00000000bfee9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfee9000 - 00000000bfeed000 (usable)
[    0.000000]  BIOS-e820: 00000000bfeed000 - 00000000bfeff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfeff000 - 00000000bff00000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.3 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0xbff00 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] total RAM covered: 3071M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 2M 	num_reg: 3  	lose cover RAM: 0G
[    0.000000] found SMP MP-table at [ffff8800000fe680] fe680
[    0.000000] init_memory_mapping: 0000000000000000-00000000bff00000
[    0.000000] RAMDISK: 356c2000 - 36b59000
[    0.000000] ACPI: RSDP 00000000000fe020 00014 (v00 INTEL )
[    0.000000] ACPI: RSDT 00000000bfefde48 00050 (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
[    0.000000] ACPI: FACP 00000000bfefcf10 00074 (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
[    0.000000] ACPI: DSDT 00000000bfef8010 03E70 (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
[    0.000000] ACPI: FACS 00000000bfedfc40 00040
[    0.000000] ACPI: APIC 00000000bfefce10 00078 (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
[    0.000000] ACPI: WDDT 00000000bfef7f90 00040 (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
[    0.000000] ACPI: MCFG 00000000bfef7f10 0003C (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
[    0.000000] ACPI: ASF! 00000000bfefcd10 000A6 (v32 INTEL  D975XBX  000004B9 MSFT 01000013)
[    0.000000] ACPI: HPET 00000000bfef7e90 00038 (v01 INTEL  D975XBX  000004B9 MSFT 01000013)
[    0.000000] ACPI: SSDT 00000000bfefdc10 001BC (v01 INTEL     CpuPm 000004B9 MSFT 01000013)
[    0.000000] ACPI: SSDT 00000000bfefda10 001B7 (v01 INTEL   Cpu0Ist 000004B9 MSFT 01000013)
[    0.000000] ACPI: SSDT 00000000bfefd810 001B7 (v01 INTEL   Cpu1Ist 000004B9 MSFT 01000013)
[    0.000000] ACPI: SSDT 00000000bfefd610 001B7 (v01 INTEL   Cpu2Ist 000004B9 MSFT 01000013)
[    0.000000] ACPI: SSDT 00000000bfefd410 001B7 (v01 INTEL   Cpu3Ist 000004B9 MSFT 01000013)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000000bff00000
[    0.000000] Initmem setup node 0 0000000000000000-00000000bff00000
[    0.000000]   NODE_DATA [00000000bfe7b000 - 00000000bfea1fff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bee37
[    0.000000]     0: 0x000beef1 -> 0x000bfea2
[    0.000000]     0: 0x000bfee9 -> 0x000bfeed
[    0.000000]     0: 0x000bfeff -> 0x000bff00
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bee37000 - 00000000beef1000
[    0.000000] PM: Registered nosave memory: 00000000bfea2000 - 00000000bfee9000
[    0.000000] PM: Registered nosave memory: 00000000bfeed000 - 00000000bfeff000
[    0.000000] Allocating PCI resources starting at bff00000 (gap: bff00000:40100000)
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff8800bf600000 s1916608 r8192 d20800 u2097152
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 773498
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.4.0-rc1+ root=UUID=1e0563a9-9105-43ef-b7ec-5cbbc76b28ab ro rd.md=0 rd.lvm=0 rd.dm=0 KEYTABLE=us console=ttyS0,115200 console=tty0 SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 LANG=en_US.UTF-8 debug_guardpage_minorder=2
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3034920k/3144704k available (6512k kernel code, 1556k absent, 108228k reserved, 7032k data, 3104k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:262400 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 12582912 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2933.300 MHz processor.
[    0.002003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5866.60 BogoMIPS (lpj=2933300)
[    0.004004] pid_max: default: 32768 minimum: 301
[    0.005349] Security Framework initialized
[    0.006012] SELinux:  Initializing.
[    0.008136] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.011784] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.014168] Mount-cache hash table entries: 256
[    0.018763] Initializing cgroup subsys cpuacct
[    0.019005] Initializing cgroup subsys memory
[    0.020170] Initializing cgroup subsys devices
[    0.021015] Initializing cgroup subsys freezer
[    0.022009] Initializing cgroup subsys blkio
[    0.023082] Initializing cgroup subsys perf_event
[    0.025228] CPU: Physical Processor ID: 0
[    0.026003] CPU: Processor Core ID: 0
[    0.027004] mce: CPU supports 6 MCE banks
[    0.028013] CPU0: Thermal monitoring enabled (TM2)
[    0.029008] using mwait in idle threads.
[    0.030117] ACPI: Core revision 20120320
[    0.119038] ftrace: allocating 21587 entries in 85 pages
[    0.125243] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.136291] CPU0: Intel(R) Core(TM)2 CPU         E6800  @ 2.93GHz stepping 05
[    0.139986] Performance Events: PEBS fmt0-, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.143989] PEBS disabled due to CPU errata.
[    0.145011] ... version:                2
[    0.145989] ... bit width:              40
[    0.146988] ... generic registers:      2
[    0.147988] ... value mask:             000000ffffffffff
[    0.148988] ... max period:             000000007fffffff
[    0.149988] ... fixed-purpose events:   3
[    0.150988] ... event mask:             0000000700000003
[    0.160948] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.165150] lockdep: fixing up alternatives.
[    0.168333] Booting Node   0, Processors  #1
[    0.181132] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.182157] Brought up 2 CPUs
[    0.182985] Total of 2 processors activated (11733.20 BogoMIPS).
[    0.189279] devtmpfs: initialized
[    0.193874] PM: Registering ACPI NVS region [mem 0xbee37000-0xbeef0fff] (761856 bytes)
[    0.202248] PM: Registering ACPI NVS region [mem 0xbfea2000-0xbfee8fff] (290816 bytes)
[    0.211408] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.217997] RTC time: 13:23:59, date: 04/02/12
[    0.226873] ACPI: bus type pci registered
[    0.231653] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.240976] PCI: not using MMCONFIG
[    0.244980] PCI: Using configuration type 1 for base access
[    0.269077] bio: create slab <bio-0> at 0
[    0.270387] ACPI: Added _OSI(Module Device)
[    0.274983] ACPI: Added _OSI(Processor Device)
[    0.278980] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.283983] ACPI: Added _OSI(Processor Aggregator Device)
[    0.358863] ACPI: Interpreter enabled
[    0.358959] ACPI: (supports S0 S1 S3 S4 S5)
[    0.362634] ACPI: Using IOAPIC for interrupt routing
[    0.363228] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.377899] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in ACPI motherboard resources
[    0.377956] PCI: MMCONFIG for 0000 [bus00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000) (size reduced!)
[    0.510229] ACPI: No dock devices found.
[    0.510937] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.557732] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.650263] PCI host bridge to bus 0000:00
[    0.650922] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.651921] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffffff]
[    0.657350] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.657998] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.660112] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.660933] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.662010] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.663010] pci 0000:00:1c.4: PCI bridge to [bus 04-04]
[    0.664433] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.664939] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    0.667037] pci 0000:00:1e.0: PCI bridge to [bus 06-06] (subtractive decode)
[    0.697271]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.697925]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.698906] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.911496] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.916477] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *9 10 11 12)
[    0.921451] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12)
[    0.926431] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.931407] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.937595] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[    0.942567] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.948750] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 *10 11 12)
[    0.953207] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.953952] vgaarb: loaded
[    0.954866] vgaarb: bridge control possible 0000:01:00.0
[    0.958304] SCSI subsystem initialized
[    0.959482] usbcore: registered new interface driver usbfs
[    0.965024] usbcore: registered new interface driver hub
[    0.971169] usbcore: registered new device driver usb
[    0.973071] PCI: Using ACPI for IRQ routing
[    0.981384] NetLabel: Initializing
[    0.984863] NetLabel:  domain hash size = 128
[    0.989861] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.995054] NetLabel:  unlabeled traffic allowed by default
[    0.999905] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.006867] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.012080] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.023967] Switching to clocksource hpet
[    1.201105] pnp: PnP ACPI init
[    1.204380] ACPI: bus type pnp registered
[    1.251624] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    1.258295] system 00:01: [mem 0xfed13000-0xfed13fff] has been reserved
[    1.264963] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    1.271627] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.278293] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.284959] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.291623] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.298289] system 00:01: [mem 0xfed45000-0xfed99fff] has been reserved
[    1.304969] system 00:01: [mem 0x000c0000-0x000dffff] could not be reserved
[    1.311995] system 00:01: [mem 0x000e0000-0x000fffff] could not be reserved
[    1.326733] system 00:06: [io  0x0500-0x053f] has been reserved
[    1.332708] system 00:06: [io  0x0400-0x047f] has been reserved
[    1.338681] system 00:06: [io  0x0680-0x06ff] has been reserved
[    1.363280] pnp: PnP ACPI: found 12 devices
[    1.367503] ACPI: ACPI bus type pnp unregistered
[    1.399606] pci 0000:01:00.0: no compatible bridge window for [mem 0xd0000000-0xd001ffff pref]
[    1.408622] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc8500000-0xc86fffff]
[    1.415531] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc8700000-0xc88fffff 64bit pref]
[    1.423410] pci 0000:00:1c.4: BAR 14: assigned [mem 0xc8900000-0xc8afffff]
[    1.430318] pci 0000:00:1c.4: BAR 15: assigned [mem 0xc8b00000-0xc8cfffff 64bit pref]
[    1.438196] pci 0000:00:1c.5: BAR 15: assigned [mem 0xc8d00000-0xc8efffff 64bit pref]
[    1.446074] pci 0000:00:1c.0: BAR 13: assigned [io  0x5000-0x5fff]
[    1.452289] pci 0000:00:1c.4: BAR 13: assigned [io  0x6000-0x6fff]
[    1.458616] pci 0000:01:00.0: BAR 6: assigned [mem 0xc8320000-0xc833ffff pref]
[    1.465893] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.471154] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    1.477286] pci 0000:00:01.0:   bridge window [mem 0xc8300000-0xc83fffff]
[    1.484109] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc7ffffff 64bit pref]
[    1.491903] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    1.497168] pci 0000:00:03.0:   bridge window [mem 0xc8200000-0xc82fffff]
[    1.503997] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    1.509259] pci 0000:00:1c.0:   bridge window [io  0x5000-0x5fff]
[    1.515392] pci 0000:00:1c.0:   bridge window [mem 0xc8500000-0xc86fffff]
[    1.522217] pci 0000:00:1c.0:   bridge window [mem 0xc8700000-0xc88fffff 64bit pref]
[    1.530020] pci 0000:00:1c.4: PCI bridge to [bus 04-04]
[    1.535283] pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
[    1.541415] pci 0000:00:1c.4:   bridge window [mem 0xc8900000-0xc8afffff]
[    1.548240] pci 0000:00:1c.4:   bridge window [mem 0xc8b00000-0xc8cfffff 64bit pref]
[    1.556039] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    1.561302] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    1.567433] pci 0000:00:1c.5:   bridge window [mem 0xc8100000-0xc81fffff]
[    1.574256] pci 0000:00:1c.5:   bridge window [mem 0xc8d00000-0xc8efffff 64bit pref]
[    1.582053] pci 0000:00:1e.0: PCI bridge to [bus 06-06]
[    1.587315] pci 0000:00:1e.0:   bridge window [io  0x1000-0x1fff]
[    1.593447] pci 0000:00:1e.0:   bridge window [mem 0xc8000000-0xc80fffff]
[    1.601319] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.611063] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.623885] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    1.634838] TCP: Hash tables configured (established 524288 bind 65536)
[    1.641558] TCP: reno registered
[    1.644906] UDP hash table entries: 2048 (order: 6, 393216 bytes)
[    1.651360] UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
[    1.660683] Unpacking initramfs...
[    2.150642] Freeing initrd memory: 21084k freed
[    2.345401] DMA-API: preallocated 32768 debug entries
[    2.350500] DMA-API: debugging enabled by kernel config
[    2.360852] cryptomgr_test used greatest stack depth: 5984 bytes left
[    2.362521] audit: initializing netlink socket (disabled)
[    2.362624] type=2000 audit(1333373039.361:1): initialized
[    2.380278] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.428905] VFS: Disk quotas dquot_6.5.2
[    2.433402] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.447674] msgmni has been set to 5968
[    2.456031] cryptomgr_test used greatest stack depth: 5552 bytes left
[    2.463810] cryptomgr_test used greatest stack depth: 5408 bytes left
[    2.463957] alg: No test for stdrng (krng)
[    2.464515] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.464748] io scheduler noop registered
[    2.464750] io scheduler deadline registered
[    2.465533] io scheduler cfq registered (default)
[    2.465536] start plist test
[    2.466381] end plist test
[    2.478021] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.478371] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.478373] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    2.521302] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    2.529998] ACPI: Sleep Button [SLPB]
[    2.534543] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.542268] ACPI: Power Button [PWRF]
[    2.551398] ACPI: Requesting acpi_cpufreq
[    2.574263] modprobe used greatest stack depth: 4792 bytes left
[    2.650047] GHES: HEST is not enabled!
[    2.654494] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.681917] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.712043] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.720324] Non-volatile memory driver v1.3
[    2.724829] Linux agpgart interface v0.103
[    2.740723] loop: module loaded
[    2.745748] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    2.753888] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
[    2.768896] scsi0 : ahci
[    2.773950] scsi1 : ahci
[    2.777578] scsi2 : ahci
[    2.781193] scsi3 : ahci
[    2.789552] ata1: SATA max UDMA/133 abar m1024@0xc8400000 port 0xc8400100 irq 45
[    2.796996] ata2: SATA max UDMA/133 abar m1024@0xc8400000 port 0xc8400180 irq 45
[    2.804441] ata3: SATA max UDMA/133 abar m1024@0xc8400000 port 0xc8400200 irq 45
[    2.811884] ata4: SATA max UDMA/133 abar m1024@0xc8400000 port 0xc8400280 irq 45
[    2.825766] scsi4 : ata_piix
[    2.829692] scsi5 : ata_piix
[    2.846785] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
[    2.853783] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
[    2.861892] Fixed MDIO Bus: probed
[    2.866316] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.873074] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.879328] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.886986] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    2.893299] ehci_hcd 0000:00:1d.7: debug port 1
[    2.902022] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xc8400400
[    2.913077] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.919502] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.926326] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.933597] usb usb1: Product: EHCI Host Controller
[    2.938511] usb usb1: Manufacturer: Linux 3.4.0-rc1+ ehci_hcd
[    2.944292] usb usb1: SerialNumber: 0000:00:1d.7
[    2.950784] hub 1-0:1.0: USB hub found
[    2.954986] hub 1-0:1.0: 8 ports detected
[    2.961113] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.967450] uhci_hcd: USB Universal Host Controller Interface driver
[    2.974324] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.980246] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.987795] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[    2.994172] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.000999] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.008270] usb usb2: Product: UHCI Host Controller
[    3.013190] usb usb2: Manufacturer: Linux 3.4.0-rc1+ uhci_hcd
[    3.019012] usb usb2: SerialNumber: 0000:00:1d.0
[    3.025244] hub 2-0:1.0: USB hub found
[    3.029320] hub 2-0:1.0: 2 ports detected
[    3.034857] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.041037] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    3.048795] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[    3.055119] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.062389] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.069662] usb usb3: Product: UHCI Host Controller
[    3.074576] usb usb3: Manufacturer: Linux 3.4.0-rc1+ uhci_hcd
[    3.080356] usb usb3: SerialNumber: 0000:00:1d.1
[    3.086467] hub 3-0:1.0: USB hub found
[    3.090505] hub 3-0:1.0: 2 ports detected
[    3.095997] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.101912] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    3.109678] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[    3.116022] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.122845] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.130050] ata1: SATA link down (SStatus 0 SControl 300)
[    3.130140] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.130213] ata4: SATA link down (SStatus 0 SControl 300)
[    3.147354] ata2.00: ATA-8: G.SKILL 64GB SSD, 02.10104, max UDMA/100
[    3.147439] usb usb4: Product: UHCI Host Controller
[    3.147441] usb usb4: Manufacturer: Linux 3.4.0-rc1+ uhci_hcd
[    3.147443] usb usb4: SerialNumber: 0000:00:1d.2
[    3.149095] hub 4-0:1.0: USB hub found
[    3.149247] hub 4-0:1.0: 2 ports detected
[    3.150692] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.151344] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    3.151657] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[    3.152335] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.152337] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.152339] usb usb5: Product: UHCI Host Controller
[    3.152341] usb usb5: Manufacturer: Linux 3.4.0-rc1+ uhci_hcd
[    3.152344] usb usb5: SerialNumber: 0000:00:1d.3
[    3.153765] hub 5-0:1.0: USB hub found
[    3.153914] hub 5-0:1.0: 2 ports detected
[    3.156171] usbcore: registered new interface driver usbserial
[    3.156315] usbcore: registered new interface driver usbserial_generic
[    3.156481] USB Serial support registered for generic
[    3.156497] usbserial: USB Serial Driver core
[    3.156730] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    3.156732] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    3.157793] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.158878] mousedev: PS/2 mouse device common for all mice
[    3.160936] rtc_cmos 00:03: RTC can wake from S4
[    3.161931] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.162065] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    3.163897] device-mapper: uevent: version 1.0.3
[    3.165189] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    3.166756] cpuidle: using governor ladder
[    3.166759] cpuidle: using governor menu
[    3.171850] usbcore: registered new interface driver usbhid
[    3.171852] usbhid: USB HID core driver
[    3.172668] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.335139] ata2.00: 125206528 sectors, multi 0: LBA 
[    3.335157] TCP: cubic registered
[    3.335158] Initializing XFRM netlink socket
[    3.340773] Mobile IPv6
[    3.340804] Registering the dns_resolver key type
[    3.341673] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.344438] registered taskstats version 1
[    3.348984]   Magic number: 8:337:381
[    3.371517] Refined TSC clocksource calibration: 2933.328 MHz.
[    3.371734] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.371811] rtc_cmos 00:03: setting system clock to 2012-04-02 13:24:02 UTC (1333373042)
[    3.391941] Switching to clocksource tsc
[    3.395945] ata2.00: configured for UDMA/100
[    3.401782] scsi 1:0:0:0: Direct-Access     ATA      G.SKILL 64GB SSD 02.1 PQ: 0 ANSI: 5
[    3.402049] Initializing network drop monitor service
[    3.417379] sd 1:0:0:0: [sda] 125206528 512-byte logical blocks: (64.1 GB/59.7 GiB)
[    3.418400] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    3.431500] sd 1:0:0:0: [sda] Write Protect is off
[    3.436665] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    3.652146] usb 3-2: new low-speed USB device number 2 using uhci_hcd
[    3.654732] ata3.00: ATAPI: PLEXTOR DVDR   PX-755A, 1.04, max UDMA/66
[    3.656290] ata3.00: configured for UDMA/66
[    3.657953] scsi 2:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-755A   1.04 PQ: 0 ANSI: 5
[    3.660335] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    3.660347] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.663853] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    3.864785] usb 3-2: New USB device found, idVendor=045e, idProduct=0053
[    3.871580] usb 3-2: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[    3.878771] usb 3-2: Product: Microsoft 3-Button Mouse with IntelliEye(TM)
[    3.885692] usb 3-2: Manufacturer: Microsoft
[    3.911149] input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.0/input/input3
[    3.926079] generic-usb 0003:045E:0053.0001: input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1d.1-2/input0
[    3.949745]  sda: sda1 sda2 sda3 sda4 sda5
[    3.959805] sd 1:0:0:0: [sda] Attached SCSI disk
[    3.966466] Freeing unused kernel memory: 3104k freed
[    3.973183] Write protecting the kernel read-only data: 12288k
[    3.984363] Freeing unused kernel memory: 1660k freed
[    3.994499] Freeing unused kernel memory: 1436k freed
[    4.030955] systemd-timesta used greatest stack depth: 4680 bytes left
[    4.759564] [drm] Initialized drm 1.1.0 20060810
[    4.864449] [drm] radeon defaulting to kernel modesetting.
[    4.870105] [drm] radeon kernel modesetting enabled.
[    4.879692] [drm] initializing kernel modesetting (RV380 0x1002:0x5B60 0x1002:0x0302).
[    4.887774] [drm] register mmio base: 0xC8310000
[    4.892427] [drm] register mmio size: 65536
[    4.897647] [drm] Generation 2 PCI interface, using max accessible memory
[    4.904486] radeon 0000:01:00.0: VRAM: 128M 0x00000000C0000000 - 0x00000000C7FFFFFF (128M used)
[    4.913244] radeon 0000:01:00.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[    4.921148] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.927811] [drm] Driver supports precise vblank timestamp query.
[    4.934313] radeon 0000:01:00.0: radeon: using MSI.
[    4.939593] [drm] radeon: irq initialized.
[    4.945312] [drm] Detected VRAM RAM=128M, BAR=128M
[    4.950147] [drm] RAM width 64bits DDR
[    4.954663] [TTM] Zone  kernel: Available graphics memory: 1531102 kiB
[    4.961232] [TTM] Initializing pool allocator
[    4.965772] [TTM] Initializing DMA pool allocator
[    4.971333] [drm] radeon: 128M of VRAM memory ready
[    4.976282] [drm] radeon: 512M of GTT memory ready.
[    4.981649] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    4.988869] [drm] radeon: ib pool ready.
[    4.995524] [drm] radeon: 1 quad pipes, 1 Z pipes initialized.
[    5.002243] [drm] PCIE GART of 512M enabled (table at 0x00000000C0040000).
[    5.009440] radeon 0000:01:00.0: WB enabled
[    5.013678] [drm] fence driver on ring 0 use gpu addr 0xa0000000 and cpu addr 0xffff8800af0b2000
[    5.023266] [drm] Loading R300 Microcode
[    5.042804] [drm] radeon: ring at 0x00000000A0001000
[    5.048160] [drm] ring test succeeded in 0 usecs
[    5.056532] [drm] ib test succeeded in 0 usecs
[    5.067305] [drm] Radeon Display Connectors
[    5.071528] [drm] Connector 0:
[    5.074638] [drm]   VGA
[    5.077126] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    5.083182] [drm]   Encoders:
[    5.086189] [drm]     CRT1: INTERNAL_DAC1
[    5.090604] [drm] Connector 1:
[    5.093711] [drm]   DVI-I
[    5.096371] [drm]   HPD1
[    5.098943] [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
[    5.104995] [drm]   Encoders:
[    5.108008] [drm]     CRT2: INTERNAL_DAC2
[    5.112054] [drm]     DFP1: INTERNAL_TMDS1
[    5.116200] [drm] Connector 2:
[    5.119293] [drm]   S-video
[    5.122126] [drm]   Encoders:
[    5.125147] [drm]     TV1: INTERNAL_DAC2
[    5.211311] [drm] fb mappable at 0xC00C0000
[    5.215550] [drm] vram apper at 0xC0000000
[    5.219686] [drm] size 7057408
[    5.222778] [drm] fb depth is 24
[    5.226060] [drm]    pitch is 6720
[    5.230805] fbcon: radeondrmfb (fb0) is primary device
[    5.351196] Console: switching to colour frame buffer device 210x65
[    5.368898] fb0: radeondrmfb frame buffer device
[    5.373566] drm: registered panic notifier
[    5.377748] [drm] Initialized radeon 2.15.0 20080528 for 0000:01:00.0 on minor 0
[    5.394456] modprobe used greatest stack depth: 3520 bytes left
[    5.900426] Floppy drive(s): fd0 is 1.44M
[    5.928897] FDC 0 is a post-1991 82077
[    5.997910] sata_sil 0000:06:05.0: Applying R_ERR on DMA activate FIS errata fix
[    6.056791] scsi6 : sata_sil
[    6.093543] scsi7 : sata_sil
[    6.132646] scsi8 : sata_sil
[    6.146093] scsi9 : sata_sil
[    6.186642] ata7: SATA max UDMA/100 mmio m1024@0xc8004800 tf 0xc8004880 irq 17
[    6.197831] ata8: SATA max UDMA/100 mmio m1024@0xc8004800 tf 0xc80048c0 irq 17
[    6.205498] ata9: SATA max UDMA/100 mmio m1024@0xc8004800 tf 0xc8004a80 irq 17
[    6.213526] ata10: SATA max UDMA/100 mmio m1024@0xc8004800 tf 0xc8004ac0 irq 17
[    6.291364] firewire_ohci 0000:06:04.0: added OHCI v1.10 device as card 0, 4 IR + 8 IT contexts, quirks 0x2
[    6.543080] ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    6.793403] firewire_core 0000:06:04.0: created device fw0: GUID 0090270001ab6d25, S400
[    6.857676] ata7.00: ATA-8: WDC WD10EACS-00D6B0, 01.01A01, max UDMA/133
[    6.864398] ata7.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    6.874859] ata7.00: configured for UDMA/100
[    6.891079] scsi 6:0:0:0: Direct-Access     ATA      WDC WD10EACS-00D 01.0 PQ: 0 ANSI: 5
[    6.902579] sd 6:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    6.903706] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    6.916468] sd 6:0:0:0: [sdb] Write Protect is off
[    6.921609] sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.940133]  sdb: sdb1
[    6.945265] sd 6:0:0:0: [sdb] Attached SCSI disk
[    7.209071] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    7.218473] ata8.00: ATA-8: Hitachi HDS721010CLA332, JP4OA25C, max UDMA/133
[    7.225545] ata8.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    7.238471] ata8.00: configured for UDMA/100
[    7.243867] scsi 7:0:0:0: Direct-Access     ATA      Hitachi HDS72101 JP4O PQ: 0 ANSI: 5
[    7.254327] sd 7:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.254918] sd 7:0:0:0: Attached scsi generic sg3 type 0
[    7.268169] sd 7:0:0:0: [sdc] Write Protect is off
[    7.273339] sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.307956]  sdc: unknown partition table
[    7.314212] sd 7:0:0:0: [sdc] Attached SCSI disk
[    7.560077] ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    7.572499] ata9.00: ATA-8: Hitachi HDT721010SLA360, ST6OA31B, max UDMA/133
[    7.582134] ata9.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    7.598506] ata9.00: configured for UDMA/100
[    7.607413] scsi 8:0:0:0: Direct-Access     ATA      Hitachi HDT72101 ST6O PQ: 0 ANSI: 5
[    7.620389] sd 8:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.620996] sd 8:0:0:0: Attached scsi generic sg4 type 0
[    7.640572] sd 8:0:0:0: [sdd] Write Protect is off
[    7.648348] sd 8:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.683949]  sdd: sdd1
[    7.692253] sd 8:0:0:0: [sdd] Attached SCSI disk
[    7.926076] ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    7.938498] ata10.00: ATA-8: Hitachi HDT721010SLA360, ST6OA31B, max UDMA/133
[    7.948883] ata10.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    7.964515] ata10.00: configured for UDMA/100
[    7.972885] scsi 9:0:0:0: Direct-Access     ATA      Hitachi HDT72101 ST6O PQ: 0 ANSI: 5
[    7.986122] sd 9:0:0:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.987907] sd 9:0:0:0: Attached scsi generic sg5 type 0
[    8.006995] sd 9:0:0:0: [sde] Write Protect is off
[    8.015642] sd 9:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.051773]  sde: sde1
[    8.060434] sd 9:0:0:0: [sde] Attached SCSI disk
[    8.153562] Btrfs loaded
[    8.190117] device fsid 1e0563a9-9105-43ef-b7ec-5cbbc76b28ab devid 1 transid 64910 /dev/sda5
[    8.551669] device fsid 1e0563a9-9105-43ef-b7ec-5cbbc76b28ab devid 1 transid 64910 /dev/sda5
[    8.686426] device fsid 1e0563a9-9105-43ef-b7ec-5cbbc76b28ab devid 1 transid 64910 /dev/sda5
[    8.885039] device fsid 1e0563a9-9105-43ef-b7ec-5cbbc76b28ab devid 1 transid 64910 /dev/sda5
[   10.247307] umount used greatest stack depth: 2952 bytes left
[   10.281411] device fsid 1e0563a9-9105-43ef-b7ec-5cbbc76b28ab devid 1 transid 64913 /dev/sda5
[   10.706858] type=1404 audit(1333373049.856:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[   16.076376] type=1403 audit(1333373055.226:3): policy loaded auid=4294967295 ses=4294967295
[   16.454457] systemd-cryptse used greatest stack depth: 2936 bytes left
[   16.465206] systemd-rc-loca used greatest stack depth: 2840 bytes left
[   17.612859] mount used greatest stack depth: 2712 bytes left
[   17.852889] modprobe used greatest stack depth: 2696 bytes left
[   17.878501] ------------[ cut here ]------------
[   17.878854] RPC: Registered named UNIX socket transport module.
[   17.878856] RPC: Registered udp transport module.
[   17.878858] RPC: Registered tcp transport module.
[   17.878859] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   17.879009] kernel BUG at include/net/netns/generic.h:41!
[   17.879009] invalid opcode: 0000 [#1] PREEMPT SMP 
[   17.879009] CPU 1 
[   17.879009] Modules linked in: sunrpc btrfs zlib_deflate libcrc32c firewire_ohci firewire_core sata_sil crc_itu_t floppy radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[   17.879009] 
[   17.879009] Pid: 415, comm: mount Not tainted 3.4.0-rc1+ #28                  /D975XBX
[   17.879009] RIP: 0010:[<ffffffffa029e0fb>]  [<ffffffffa029e0fb>] rpc_fill_super+0x29b/0x2a0 [sunrpc]
[   17.879009] RSP: 0018:ffff8800a4d1bcf8  EFLAGS: 00010246
[   17.879009] RAX: 0000000000000001 RBX: ffff8800b8651290 RCX: 0000000000000000
[   17.879009] RDX: ffff8800b3e926a0 RSI: ffffffff81c2d340 RDI: ffff8800b3e92fb8
[   17.879009] RBP: ffff8800a4d1bd38 R08: 0000000000000001 R09: 0000000000000000
[   17.879009] R10: 0000000000000001 R11: 0000000000000002 R12: 0000000000000000
[   17.879009] R13: ffffffff82d0f340 R14: ffff8800ba54c000 R15: 0000000000000000
[   17.879009] FS:  00007f0075ddd800(0000) GS:ffff8800bf800000(0000) knlGS:0000000000000000
[   17.879009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   17.879009] CR2: 0000000000405ca5 CR3: 00000000a4c16000 CR4: 00000000000007e0
[   17.879009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   17.879009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   17.879009] Process mount (pid: 415, threadinfo ffff8800a4d1a000, task ffff8800b3e926a0)
[   17.879009] Stack:
[   17.879009]  ffffffffa029de60 00000000000000d0 000060ff40001c58 ffffffff82d0f340
[   17.879009]  0000000000000000 ffffffffa029de60 ffff8800b8651290 0000000000000000
[   17.879009]  ffff8800a4d1bd88 ffffffff811a930c 0000000000000002 ffffffff00000001
[   17.879009] Call Trace:
[   17.879009]  [<ffffffffa029de60>] ? rpc_mkpipe_dentry+0x180/0x180 [sunrpc]
[   17.879009]  [<ffffffffa029de60>] ? rpc_mkpipe_dentry+0x180/0x180 [sunrpc]
[   17.879009]  [<ffffffff811a930c>] mount_ns+0xac/0xe0
[   17.879009]  [<ffffffffa029c4a9>] rpc_mount+0x29/0x30 [sunrpc]
[   17.879009]  [<ffffffff811aa033>] mount_fs+0x43/0x1b0
[   17.879009]  [<ffffffff8115d350>] ? __alloc_percpu+0x10/0x20
[   17.879009]  [<ffffffff811c7192>] vfs_kern_mount+0x72/0x100
[   17.879009]  [<ffffffff811c7974>] do_kern_mount+0x54/0x110
[   17.879009]  [<ffffffff811c90e4>] do_mount+0x1a4/0x830
[   17.879009]  [<ffffffff81156c2b>] ? memdup_user+0x4b/0x90
[   17.879009]  [<ffffffff81156ccb>] ? strndup_user+0x5b/0x80
[   17.879009]  [<ffffffff811c98b0>] sys_mount+0x90/0xe0
[   17.879009]  [<ffffffff81658292>] system_call_fastpath+0x16/0x1b
[   17.879009] Code: e8 ab 95 e5 e0 84 c0 74 c9 48 c7 c7 40 d3 c2 81 e8 0b 01 e1 e0 85 c0 0f 85 f4 fd ff ff eb b3 90 41 bf f4 ff ff ff e9 ce fe ff ff <0f> 0b 0f 0b 90 55 48 89 e5 41 54 53 48 83 ec 10 66 66 66 66 90 
[   17.879009] RIP  [<ffffffffa029e0fb>] rpc_fill_super+0x29b/0x2a0 [sunrpc]
[   17.879009]  RSP <ffff8800a4d1bcf8>
[   18.378103] ---[ end trace c6f8fb8c18539c49 ]---
[   18.385580] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[   18.396223] in_atomic(): 0, irqs_disabled(): 0, pid: 415, name: mount
[   18.405682] INFO: lockdep is turned off.
[   18.412744] Pid: 415, comm: mount Tainted: G      D      3.4.0-rc1+ #28
[   18.422509] Call Trace:
[   18.428000]  [<ffffffff8107d24c>] __might_sleep+0x13c/0x1f0
[   18.436822]  [<ffffffff8164db46>] down_read+0x26/0x93
[   18.444885]  [<ffffffff81060944>] exit_signals+0x24/0x130
[   18.453311]  [<ffffffff8104cbdf>] do_exit+0xbf/0xb60
[   18.461706]  [<ffffffff81049c53>] ? kmsg_dump+0x1c3/0x2c0
[   18.470555]  [<ffffffff81049b0f>] ? kmsg_dump+0x7f/0x2c0
[   18.479376]  [<ffffffff81651914>] oops_end+0xa4/0xf0
[   18.487437]  [<ffffffff81005ab8>] die+0x58/0x90
[   18.494999]  [<ffffffff81651234>] do_trap+0xc4/0x170
[   18.503061]  [<ffffffff81002e05>] ? do_invalid_op+0xa5/0xb0
[   18.511639]  [<ffffffff81002df5>] do_invalid_op+0x95/0xb0
[   18.520145]  [<ffffffffa029e0fb>] ? rpc_fill_super+0x29b/0x2a0 [sunrpc]
[   18.530321]  [<ffffffff8165430d>] ? sub_preempt_count+0x9d/0xd0
[   18.539135]  [<ffffffff813188ad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   18.548703]  [<ffffffff81650b8d>] ? restore_args+0x30/0x30
[   18.557076]  [<ffffffff81659515>] invalid_op+0x15/0x20
[   18.565707]  [<ffffffffa029e0fb>] ? rpc_fill_super+0x29b/0x2a0 [sunrpc]
[   18.575364]  [<ffffffffa029e0e5>] ? rpc_fill_super+0x285/0x2a0 [sunrpc]
[   18.585179]  [<ffffffffa029de60>] ? rpc_mkpipe_dentry+0x180/0x180 [sunrpc]
[   18.595285]  [<ffffffffa029de60>] ? rpc_mkpipe_dentry+0x180/0x180 [sunrpc]
[   18.605611]  [<ffffffff811a930c>] mount_ns+0xac/0xe0
[   18.613523]  [<ffffffffa029c4a9>] rpc_mount+0x29/0x30 [sunrpc]
[   18.622132]  [<ffffffff811aa033>] mount_fs+0x43/0x1b0
[   18.630050]  [<ffffffff8115d350>] ? __alloc_percpu+0x10/0x20
[   18.638197]  [<ffffffff811c7192>] vfs_kern_mount+0x72/0x100
[   18.646940]  [<ffffffff811c7974>] do_kern_mount+0x54/0x110
[   18.655050]  [<ffffffff811c90e4>] do_mount+0x1a4/0x830
[   18.663352]  [<ffffffff81156c2b>] ? memdup_user+0x4b/0x90
[   18.671537]  [<ffffffff81156ccb>] ? strndup_user+0x5b/0x80
[   18.679761]  [<ffffffff811c98b0>] sys_mount+0x90/0xe0
[   18.687428]  [<ffffffff81658292>] system_call_fastpath+0x16/0x1b
[   19.229376] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   20.576382] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   20.635253] iTCO_vendor_support: vendor-support=0
[   20.651229] tun: Universal TUN/TAP device driver, 1.6
[   20.667082] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   21.286503] microcode: CPU0 sig=0x6f5, pf=0x1, revision=0x33
[   21.343635] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[   21.415368] microcode: CPU1 sig=0x6f5, pf=0x1, revision=0x33
[   21.435556] iTCO_wdt: Found a ICH7DH TCO device (Version=2, TCOBASE=0x0460)
[   21.448576] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   21.477234] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[   21.513461] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   21.523454] e1000e 0000:05:00.0: Disabling ASPM L0s L1
[   21.546840] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   21.559066] leds_ss4200: no LED devices found
[   21.662237] e1000e 0000:05:00.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:16:76:ab:41:34
[   21.674044] e1000e 0000:05:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   21.686198] e1000e 0000:05:00.0: eth0: MAC: 2, PHY: 2, PBA No: FFFFFF-0FF
[   21.787376] EXT4-fs (sdc): warning: maximal mount count reached, running e2fsck is recommended
[   21.940318] EXT4-fs (sdb1): mounting ext3 file system using the ext4 subsystem
[   21.951622] EXT4-fs (sde1): mounting ext3 file system using the ext4 subsystem
[   22.032113] EXT4-fs (sde1): warning: maximal mount count reached, running e2fsck is recommended
[   22.058842] Adding 5193724k swap on /dev/sda3.  Priority:0 extents:1 across:5193724k 
[   22.092569] EXT4-fs (sdc): mounted filesystem with ordered data mode. Opts: (null)
[   22.104189] EXT4-fs (sdd1): mounting ext3 file system using the ext4 subsystem
[   22.162107] EXT4-fs (sdb1): warning: maximal mount count reached, running e2fsck is recommended
[   22.260972] EXT4-fs (sde1): mounted filesystem with ordered data mode. Opts: (null)
[   22.303508] EXT4-fs (sdd1): warning: maximal mount count reached, running e2fsck is recommended
[   22.411552] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
[   22.494827] EXT4-fs (sdd1): mounted filesystem with ordered data mode. Opts: (null)
[   22.498432] EXT4-fs (sda2): mounting ext2 file system using the ext4 subsystem
[   22.545517] EXT4-fs (sda2): mounted filesystem without journal. Opts: (null)
[   22.559466] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
[   25.986451] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   26.296247] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   28.653627] ADDRCONF(NETDEV_UP): p6p1: link is not ready
[   29.260307] Bridge firewalling registered
[   29.357462] device virbr0-nic entered promiscuous mode
[   29.876598] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   29.905672] NFSD: starting 90-second grace period
[   30.843918] ADDRCONF(NETDEV_UP): virbr0: link is not ready
[   31.176962] e1000e: p6p1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   31.195547] ADDRCONF(NETDEV_CHANGE): p6p1: link becomes ready
[   31.607492] Ebtables v2.0 registered
