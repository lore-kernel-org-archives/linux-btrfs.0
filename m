Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35012 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751297AbaEBB6l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 May 2014 21:58:41 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Unable to rebuild a 3 drive raid1 - blocked for more than 120 seconds.
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAE6A3M0zmzDmLKzRDALNeLsqx72ttC8CA74-GfuSXN1TwJW-0A@mail.gmail.com>
Date: Thu, 1 May 2014 19:58:37 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <460175EE-093C-44D8-B561-596D1D71FAAF@colorremedies.com>
References: <CAE6A3M0zmzDmLKzRDALNeLsqx72ttC8CA74-GfuSXN1TwJW-0A@mail.gmail.com>
To: Saran Neti <sarannmr@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On Apr 30, 2014, at 10:48 PM, Saran Neti <sarannmr@gmail.com> wrote:

> Hi,
> 
> I had 3 x 3 TB drives in an almost full btrfs raid1 setup containing
> only large (~20 GB) files linearly written and not modified after.
> Then one of the drives got busted. Mounting the fs in degraded mode
> and adding a new fresh drive to rebuild raid1, generated several
> "...blocked for more than 120 seconds." messages. I left it running
> for a couple of days, but "btrfs device add..." command wouldn't
> return. 

I think this is a bug. I can reproduce the hang with btrfs device add. I can't reproduce the problem with btrfs replace, which works as expected for all three devices.

3x 6G VDI's in a virtual machine (VirtualBox)
3.15.0-0.rc3.git0.1.fc21.x86_64
btrfs-progs-3.14-1.fc21.x86_64


# mkfs.btrfs -d raid1 -m raid1 /dev/sd[bcd]
# mount /dev/sdb /mnt   ## default mount options

-- populated with data until one device is nearly full
-- poweroff VM, remove /dev/sdb VDI and replace it with a newly created VDI

# mount -o degraded /dev/sdc /mnt
# btrfs device add /dev/sdb /mnt
Performing full device TRIM (6.00GiB) …

This is inside a VM so trim support shouldn't be detected. The system remains completely responsive. dmesg reports nothing at all after 15 minutes, but the command still hasn't completed.

# btrfs fi show
Label: none  uuid: 7387b661-4e72-45e4-a0a1-e6c4ad460164
	Total devices 4 FS bytes used 7.90GiB
	devid    2 size 6.00GiB used 5.99GiB path /dev/sdc
	devid    3 size 6.00GiB used 5.99GiB path /dev/sdd
	devid    4 size 6.00GiB used 0.00 path /dev/sdb
	*** Some devices missing

The device /dev/sdb has no btrfs metadata on it, when I inspect the VDI file with hexdump. So it hasn't yet been written to even though it's listed as devid 4.

The command's PID is 1112, strace -p hangs as well. dmesg with sysrq-w follows, but is wrapping rather ugly in email, so I've also put a text file here:
https://drive.google.com/file/d/0B_2Asp8DGjJ9eUwtTXQ3eFVpeGM/edit?usp=sharing



# dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.15.0-0.rc3.git0.1.fc21.x86_64 (mockbuild@bkernel02) (gcc version 4.9.0 20140422 (Red Hat 4.9.0-1) (GCC) ) #1 SMP Mon Apr 28 14:10:35 UTC 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.15.0-0.rc3.git0.1.fc21.x86_64 root=UUID=d372e5d1-386f-460c-b036-611469e0155e ro rootflags=subvol=root elevator=deadline enforcing=0 systemd.unit=multi-user.target
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009e9defff] usable
[    0.000000] BIOS-e820: [mem 0x000000009e9df000-0x000000009e9ebfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009e9ec000-0x000000009fb6bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000009fb6c000-0x000000009fbc3fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009fbc4000-0x000000009fbcbfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000009fbcc000-0x000000009fbcffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009fbd0000-0x000000009ffcffff] usable
[    0.000000] BIOS-e820: [mem 0x000000009ffd0000-0x000000009ffeffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by EDK II
[    0.000000] efi:  ACPI=0x9fbcb000  ACPI 2.0=0x9fbcb014  SMBIOS=0x9fbce000  MPS=0x9fbcd000 
[    0.000000] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
[    0.000000] efi: mem01: type=2, attr=0xf, range=[0x0000000000001000-0x0000000000002000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000002000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem03: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem04: type=2, attr=0xf, range=[0x0000000001000000-0x0000000002000000) (16MB)
[    0.000000] efi: mem05: type=4, attr=0xf, range=[0x0000000002000000-0x0000000002600000) (6MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000002600000-0x0000000003000000) (10MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x0000000003000000-0x0000000004456000) (20MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x0000000004456000-0x000000003e0c8000) (924MB)
[    0.000000] efi: mem09: type=2, attr=0xf, range=[0x000000003e0c8000-0x0000000040000000) (31MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x0000000040000000-0x0000000074ab9000) (842MB)
[    0.000000] efi: mem11: type=2, attr=0xf, range=[0x0000000074ab9000-0x000000009c000000) (629MB)
[    0.000000] efi: mem12: type=4, attr=0xf, range=[0x000000009c000000-0x000000009c020000) (0MB)
[    0.000000] efi: mem13: type=7, attr=0xf, range=[0x000000009c020000-0x000000009db34000) (27MB)
[    0.000000] efi: mem14: type=1, attr=0xf, range=[0x000000009db34000-0x000000009dc6f000) (1MB)
[    0.000000] efi: mem15: type=7, attr=0xf, range=[0x000000009dc6f000-0x000000009dcdb000) (0MB)
[    0.000000] efi: mem16: type=2, attr=0xf, range=[0x000000009dcdb000-0x000000009ddc3000) (0MB)
[    0.000000] efi: mem17: type=4, attr=0xf, range=[0x000000009ddc3000-0x000000009e1a6000) (3MB)
[    0.000000] efi: mem18: type=7, attr=0xf, range=[0x000000009e1a6000-0x000000009e1ce000) (0MB)
[    0.000000] efi: mem19: type=1, attr=0xf, range=[0x000000009e1ce000-0x000000009e309000) (1MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x000000009e309000-0x000000009e34e000) (0MB)
[    0.000000] efi: mem21: type=2, attr=0xf, range=[0x000000009e34e000-0x000000009e45d000) (1MB)
[    0.000000] efi: mem22: type=4, attr=0xf, range=[0x000000009e45d000-0x000000009e9df000) (5MB)
[    0.000000] efi: mem23: type=5, attr=0x800000000000000f, range=[0x000000009e9df000-0x000000009e9ec000) (0MB)
[    0.000000] efi: mem24: type=4, attr=0xf, range=[0x000000009e9ec000-0x000000009eaec000) (1MB)
[    0.000000] efi: mem25: type=7, attr=0xf, range=[0x000000009eaec000-0x000000009eb1e000) (0MB)
[    0.000000] efi: mem26: type=4, attr=0xf, range=[0x000000009eb1e000-0x000000009f9ec000) (14MB)
[    0.000000] efi: mem27: type=7, attr=0xf, range=[0x000000009f9ec000-0x000000009f9ef000) (0MB)
[    0.000000] efi: mem28: type=3, attr=0xf, range=[0x000000009f9ef000-0x000000009fb6c000) (1MB)
[    0.000000] efi: mem29: type=5, attr=0x800000000000000f, range=[0x000000009fb6c000-0x000000009fb9c000) (0MB)
[    0.000000] efi: mem30: type=6, attr=0x800000000000000f, range=[0x000000009fb9c000-0x000000009fbc0000) (0MB)
[    0.000000] efi: mem31: type=0, attr=0xf, range=[0x000000009fbc0000-0x000000009fbc4000) (0MB)
[    0.000000] efi: mem32: type=9, attr=0xf, range=[0x000000009fbc4000-0x000000009fbcc000) (0MB)
[    0.000000] efi: mem33: type=10, attr=0xf, range=[0x000000009fbcc000-0x000000009fbd0000) (0MB)
[    0.000000] efi: mem34: type=4, attr=0xf, range=[0x000000009fbd0000-0x000000009ffd0000) (4MB)
[    0.000000] efi: mem35: type=6, attr=0x800000000000000f, range=[0x000000009ffd0000-0x000000009fff0000) (0MB)
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x9ffd0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR variable ranges disabled:
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] CPU MTRRs all blank - virtualized system.
[    0.000000] found SMP MP-table at [mem 0x0009fff0-0x0009ffff] mapped at [ffff88000009fff0]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04034000, 0x04034fff] PGTABLE
[    0.000000] BRK [0x04035000, 0x04035fff] PGTABLE
[    0.000000] BRK [0x04036000, 0x04036fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x9da00000-0x9dbfffff]
[    0.000000]  [mem 0x9da00000-0x9dbfffff] page 2M
[    0.000000] BRK [0x04037000, 0x04037fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x9c000000-0x9d9fffff]
[    0.000000]  [mem 0x9c000000-0x9d9fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x80000000-0x9bffffff]
[    0.000000]  [mem 0x80000000-0x9bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x7fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x9dc00000-0x9e9defff]
[    0.000000]  [mem 0x9dc00000-0x9e7fffff] page 2M
[    0.000000]  [mem 0x9e800000-0x9e9defff] page 4k
[    0.000000] BRK [0x04038000, 0x04038fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x9e9ec000-0x9fb6bfff]
[    0.000000]  [mem 0x9e9ec000-0x9e9fffff] page 4k
[    0.000000]  [mem 0x9ea00000-0x9f9fffff] page 2M
[    0.000000]  [mem 0x9fa00000-0x9fb6bfff] page 4k
[    0.000000] BRK [0x04039000, 0x04039fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x9fbd0000-0x9ffcffff]
[    0.000000]  [mem 0x9fbd0000-0x9fbfffff] page 4k
[    0.000000]  [mem 0x9fc00000-0x9fdfffff] page 2M
[    0.000000]  [mem 0x9fe00000-0x9ffcffff] page 4k
[    0.000000] RAMDISK: [mem 0x3e0c8000-0x3eba4fff]
[    0.000000] ACPI: RSDP 0x000000009FBCB014 000024 (v02 VBOX  )
[    0.000000] ACPI: XSDT 0x000000009FBCA0E8 00003C (v01 VBOX   VBOXFACP 00000001      01000013)
[    0.000000] ACPI: FACP 0x000000009FBC8000 0000F4 (v04 VBOX   VBOXFACP 00000001 ASL  00000061)
[    0.000000] ACPI: DSDT 0x000000009FBC6000 001B96 (v01 VBOX   VBOXBIOS 00000002 INTL 20100528)
[    0.000000] ACPI: FACS 0x000000009FBCF000 000040
[    0.000000] ACPI: APIC 0x000000009FBC9000 000064 (v02 VBOX   VBOXAPIC 00000001 ASL  00000061)
[    0.000000] ACPI: SSDT 0x000000009FBC5000 0001CC (v01 VBOX   VBOXCPUT 00000002 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000009ffcffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x9ffcffff]
[    0.000000]   NODE_DATA [mem 0x9eb0a000-0x9eb1dfff]
[    0.000000]  [ffffea0000000000-ffffea00027fffff] PMD -> [ffff880099800000-ffff88009bffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x9e9defff]
[    0.000000]   node   0: [mem 0x9e9ec000-0x9fb6bfff]
[    0.000000]   node   0: [mem 0x9fbd0000-0x9ffcffff]
[    0.000000] On node 0 totalpages: 655102
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3999 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10176 pages used for memmap
[    0.000000]   DMA32 zone: 651103 pages, LIFO batch:31
[    0.000000] tboot: non-0 tboot_addr but it is not of type E820_RESERVED
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 3, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 3 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x9e9df000-0x9e9ebfff]
[    0.000000] PM: Registered nosave memory: [mem 0x9fb6c000-0x9fbc3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9fbc4000-0x9fbcbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x9fbcc000-0x9fbcffff]
[    0.000000] e820: [mem 0x9fff0000-0xffffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:1024 nr_cpumask_bits:3 nr_cpu_ids:3 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88009d800000 s88128 r8192 d22464 u524288
[    0.000000] pcpu-alloc: s88128 r8192 d22464 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 - 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 644840
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.15.0-0.rc3.git0.1.fc21.x86_64 root=UUID=d372e5d1-386f-460c-b036-611469e0155e ro rootflags=subvol=root elevator=deadline enforcing=0 systemd.unit=multi-user.target
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 2513236K/2620408K available (7254K kernel code, 1172K rwdata, 3080K rodata, 1440K init, 1652K bss, 107172K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=3, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=1024 to nr_cpu_ids=3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=3
[    0.000000] NR_IRQS:65792 nr_irqs:704 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 10485760 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using PMTIMER reference calibration
[    0.000000] tsc: Detected 2310.805 MHz processor
[    0.003029] Calibrating delay loop (skipped), value calculated using timer frequency.. 4621.61 BogoMIPS (lpj=2310805)
[    0.003035] pid_max: default: 32768 minimum: 301
[    0.003049] ACPI: Core revision 20140214
[    0.003787] ACPI: All ACPI Tables successfully acquired
[    0.004622] Security Framework initialized
[    0.004630] SELinux:  Initializing.
[    0.004638] SELinux:  Starting in permissive mode
[    0.005024] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.009021] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.009290] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.009303] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.009471] Initializing cgroup subsys memory
[    0.009478] Initializing cgroup subsys devices
[    0.009482] Initializing cgroup subsys freezer
[    0.009486] Initializing cgroup subsys net_cls
[    0.009489] Initializing cgroup subsys blkio
[    0.009493] Initializing cgroup subsys perf_event
[    0.009498] Initializing cgroup subsys net_prio
[    0.009502] Initializing cgroup subsys hugetlb
[    0.009593] CPU: Physical Processor ID: 0
[    0.009597] CPU: Processor Core ID: 0
[    0.009603] mce: CPU supports 0 MCE banks
[    0.009635] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
tlb_flushall_shift: 6
[    0.009804] Freeing SMP alternatives memory: 24K (ffffffff81e8f000 - ffffffff81e95000)
[    0.016869] ftrace: allocating 26546 entries in 104 pages
[    0.023379] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.034084] smpboot: CPU0: Intel(R) Core(TM) i7-2820QM CPU @ 2.30GHz (fam: 06, model: 2a, stepping: 07)
[    0.035000] Performance Events: unsupported p6 CPU model 42 no PMU driver, software events only.
[    0.035547] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.035783] x86: Booting SMP configuration:
[    0.035788] .... node  #0, CPUs:      #1
[    0.004000] mce: CPU supports 0 MCE banks
[    0.048000] TSC synchronization [CPU#0 -> CPU#1]:
[    0.048000] Measured 14805 cycles TSC warp between CPUs, turning off TSC clock.
[    0.048000] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[    0.048316]  #2
[    0.004000] mce: CPU supports 0 MCE banks
[    0.060335] x86: Booted up 1 node, 3 CPUs
[    0.060342] smpboot: Total of 3 processors activated (13864.83 BogoMIPS)
[    0.061156] devtmpfs: initialized
[    0.064253] PM: Registering ACPI NVS region [mem 0x9fbcc000-0x9fbcffff] (16384 bytes)
[    0.065748] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.065753] pinctrl core: initialized pinctrl subsystem
[    0.065829] RTC time:  1:17:50, date: 05/02/14
[    0.065877] NET: Registered protocol family 16
[    0.065956] cpuidle: using governor menu
[    0.066052] ACPI: bus type PCI registered
[    0.066057] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.066157] PCI: Using configuration type 1 for base access
[    0.069231] ACPI: Added _OSI(Module Device)
[    0.069237] ACPI: Added _OSI(Processor Device)
[    0.069240] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.069244] ACPI: Added _OSI(Processor Aggregator Device)
[    0.070066] ACPI: Executed 1 blocks of module-level executable AML code
[    0.072564] ACPI: Interpreter enabled
[    0.072572] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    0.072579] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    0.072584] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140214/hwxface-580)
[    0.072590] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20140214/hwxface-580)
[    0.072597] ACPI: (supports S0 S5)
[    0.072601] ACPI: Using IOAPIC for interrupt routing
[    0.072697] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.075557] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.075565] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.075572] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.075644] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.075648] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.075651] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.075655] acpi PNP0A03:00: host bridge window [mem 0xa0000000-0xffdfffff] (ignored)
[    0.075658] PCI: root bus 00: using default resources
[    0.075662] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.075853] PCI host bridge to bus 0000:00
[    0.075858] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.075862] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.075866] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffffff]
[    0.076008] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.076522] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.077187] pci 0000:00:01.1: [8086:7111] type 00 class 0x01018a
[    0.077568] pci 0000:00:01.1: reg 0x20: [io  0xc190-0xc19f]
[    0.077741] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.077746] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.077750] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.077754] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.077974] pci 0000:00:02.0: [80ee:beef] type 00 class 0x030000
[    0.080827] pci 0000:00:02.0: reg 0x10: [mem 0xa0000000-0xa3ffffff pref]
[    0.097072] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.097193] pci 0000:00:03.0: reg 0x10: [io  0xc160-0xc17f]
[    0.097951] pci 0000:00:04.0: [80ee:cafe] type 00 class 0x088000
[    0.099164] pci 0000:00:04.0: reg 0x10: [io  0xc140-0xc15f]
[    0.100207] pci 0000:00:04.0: reg 0x14: [mem 0xa4000000-0xa43fffff]
[    0.102467] pci 0000:00:04.0: reg 0x18: [mem 0xa4400000-0xa4403fff pref]
[    0.109183] pci 0000:00:05.0: [8086:2415] type 00 class 0x040100
[    0.109299] pci 0000:00:05.0: reg 0x10: [io  0xc000-0xc0ff]
[    0.109370] pci 0000:00:05.0: reg 0x14: [io  0xc100-0xc13f]
[    0.109904] pci 0000:00:06.0: [106b:003f] type 00 class 0x0c0310
[    0.111136] pci 0000:00:06.0: reg 0x10: [mem 0xa4407000-0xa4407fff]
[    0.121182] pci 0000:00:07.0: [8086:7113] type 00 class 0x068000
[    0.121694] pci 0000:00:07.0: quirk: [io  0x4000-0x403f] claimed by PIIX4 ACPI
[    0.122038] pci 0000:00:0b.0: [8086:265c] type 00 class 0x0c0320
[    0.124097] pci 0000:00:0b.0: reg 0x10: [mem 0xa4406000-0xa4406fff]
[    0.134084] pci 0000:00:0d.0: [8086:2829] type 00 class 0x010601
[    0.135144] pci 0000:00:0d.0: reg 0x10: [io  0xc1a8-0xc1af]
[    0.138139] pci 0000:00:0d.0: reg 0x18: [io  0xc1a0-0xc1a7]
[    0.141429] pci 0000:00:0d.0: reg 0x20: [io  0xc180-0xc18f]
[    0.142233] pci 0000:00:0d.0: reg 0x24: [mem 0xa4404000-0xa4405fff]
[    0.146807] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 9 10 *11)
[    0.147203] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *9 10 11)
[    0.147291] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 9 10 *11)
[    0.147376] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 *9 10 11)
[    0.147489] ACPI: Enabled 1 GPEs in block 00 to 07
[    0.148038] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.148046] vgaarb: loaded
[    0.148049] vgaarb: bridge control possible 0000:00:02.0
[    0.148134] SCSI subsystem initialized
[    0.148134] libata version 3.00 loaded.
[    0.148134] ACPI: bus type USB registered
[    0.148147] usbcore: registered new interface driver usbfs
[    0.148163] usbcore: registered new interface driver hub
[    0.149042] usbcore: registered new device driver usb
[    0.149158] PCI: Using ACPI for IRQ routing
[    0.149158] PCI: pci_cache_line_size set to 64 bytes
[    0.149353] e820: reserve RAM buffer [mem 0x9e9df000-0x9fffffff]
[    0.149361] e820: reserve RAM buffer [mem 0x9fb6c000-0x9fffffff]
[    0.149364] e820: reserve RAM buffer [mem 0x9ffd0000-0x9fffffff]
[    0.149477] NetLabel: Initializing
[    0.149482] NetLabel:  domain hash size = 128
[    0.149485] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.149508] NetLabel:  unlabeled traffic allowed by default
[    0.149655] Switched to clocksource refined-jiffies
[    0.157894] pnp: PnP ACPI init
[    0.157911] ACPI: bus type PNP registered
[    0.157980] pnp 00:00: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.158014] pnp 00:01: [dma 4]
[    0.158035] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.158110] pnp 00:02: Plug and Play ACPI device, IDs PNP0f03 (active)
[    0.158155] pnp 00:03: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.158952] pnp: PnP ACPI: found 4 devices
[    0.158957] ACPI: bus type PNP unregistered
[    0.174590] Switched to clocksource acpi_pm
[    0.174602] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.174606] pci_bus 0000:00: resource 5 [mem 0x00000000-0xfffffffff]
[    0.174629] NET: Registered protocol family 2
[    0.174832] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.174910] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.174910] TCP: Hash tables configured (established 32768 bind 32768)
[    0.174910] TCP: reno registered
[    0.174910] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.174910] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.174910] NET: Registered protocol family 1
[    0.174910] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.174910] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.174910] pci 0000:00:02.0: Boot video device
[    0.176446] PCI: CLS 0 bytes, default 64
[    0.176494] Unpacking initramfs...
[    0.322922] Freeing initrd memory: 11124K (ffff88003e0c8000 - ffff88003eba5000)
[    0.325339] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.327380] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.327391] Initialise system trusted keyring
[    0.327411] audit: initializing netlink subsys (disabled)
[    0.327436] audit: type=2000 audit(1398993470.327:1): initialized
[    0.346445] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.347823] zbud: loaded
[    0.348344] VFS: Disk quotas dquot_6.5.2
[    0.348377] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.348855] msgmni has been set to 5004
[    0.348906] Key type big_key registered
[    0.348910] SELinux:  Registering netfilter hooks
[    0.355261] alg: No test for stdrng (krng)
[    0.355345] NET: Registered protocol family 38
[    0.355351] Key type asymmetric registered
[    0.355355] Asymmetric key parser 'x509' registered
[    0.355397] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.355729] io scheduler noop registered
[    0.355735] io scheduler deadline registered (default)
[    0.355776] io scheduler cfq registered
[    0.355863] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.355879] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.355927] efifb: probing for efifb
[    0.356101] efifb: framebuffer at 0xa0000000, mapped to 0xffffc90000780000, using 3072k, total 3072k
[    0.356106] efifb: mode is 1024x768x32, linelength=4096, pages=1
[    0.356109] efifb: scrolling: redraw
[    0.356113] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.360065] Console: switching to colour frame buffer device 128x48
[    0.361328] fb0: EFI VGA frame buffer device
[    0.361353] intel_idle: does not run on family 6 model 42
[    0.362097] ACPI: AC Adapter [AC] (on-line)
[    0.362602] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.362629] ACPI: Power Button [PWRF]
[    0.362712] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
[    0.362738] ACPI: Sleep Button [SLPF]
[    0.363298] GHES: HEST is not enabled!
[    0.363510] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.364786] ACPI: Battery Slot [BAT0] (battery present)
[    0.365099] Non-volatile memory driver v1.3
[    0.365116] Linux agpgart interface v0.103
[    0.365268] ahci 0000:00:0d.0: version 3.0
[    0.365780] ahci 0000:00:0d.0: SSS flag set, parallel bus scan disabled
[    0.366203] ahci 0000:00:0d.0: AHCI 0001.0100 32 slots 8 ports 3 Gbps 0xff impl SATA mode
[    0.366336] ahci 0000:00:0d.0: flags: 64bit ncq stag only ccc 
[    0.368497] scsi0 : ahci
[    0.369263] scsi1 : ahci
[    0.369920] scsi2 : ahci
[    0.370592] scsi3 : ahci
[    0.375127] scsi4 : ahci
[    0.376511] scsi5 : ahci
[    0.377768] scsi6 : ahci
[    0.379003] scsi7 : ahci
[    0.379530] ata1: SATA max UDMA/133 abar m8192@0xa4404000 port 0xa4404100 irq 21
[    0.379972] ata2: SATA max UDMA/133 abar m8192@0xa4404000 port 0xa4404180 irq 21
[    0.380003] ata3: SATA max UDMA/133 abar m8192@0xa4404000 port 0xa4404200 irq 21
[    0.380480] ata4: SATA max UDMA/133 abar m8192@0xa4404000 port 0xa4404280 irq 21
[    0.380905] ata5: SATA max UDMA/133 abar m8192@0xa4404000 port 0xa4404300 irq 21
[    0.381003] ata6: SATA max UDMA/133 abar m8192@0xa4404000 port 0xa4404380 irq 21
[    0.382132] ata7: SATA max UDMA/133 abar m8192@0xa4404000 port 0xa4404400 irq 21
[    0.382583] ata8: SATA max UDMA/133 abar m8192@0xa4404000 port 0xa4404480 irq 21
[    0.383094] ata_piix 0000:00:01.1: version 2.13
[    0.384065] scsi8 : ata_piix
[    0.384843] scsi9 : ata_piix
[    0.385312] ata9: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xc190 irq 14
[    0.385725] ata10: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xc198 irq 15
[    0.386252] libphy: Fixed MDIO Bus: probed
[    0.390069] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.390495] ehci-pci: EHCI PCI platform driver
[    0.391324] ehci-pci 0000:00:0b.0: EHCI Host Controller
[    0.392098] ehci-pci 0000:00:0b.0: new USB bus registered, assigned bus number 1
[    0.392697] ehci-pci 0000:00:0b.0: irq 19, io mem 0xa4406000
[    0.399972] ehci-pci 0000:00:0b.0: USB 2.0 started, EHCI 1.00
[    0.401178] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.401585] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.401999] usb usb1: Product: EHCI Host Controller
[    0.402004] usb usb1: Manufacturer: Linux 3.15.0-0.rc3.git0.1.fc21.x86_64 ehci_hcd
[    0.402469] usb usb1: SerialNumber: 0000:00:0b.0
[    0.403503] hub 1-0:1.0: USB hub found
[    0.403903] hub 1-0:1.0: 8 ports detected
[    0.405273] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.405666] ohci-pci: OHCI PCI platform driver
[    0.406562] ohci-pci 0000:00:06.0: OHCI PCI host controller
[    0.407202] ohci-pci 0000:00:06.0: new USB bus registered, assigned bus number 2
[    0.409986] ohci-pci 0000:00:06.0: irq 22, io mem 0xa4407000
[    0.462391] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.468698] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.469472] usb usb2: Product: OHCI PCI host controller
[    0.473299] usb usb2: Manufacturer: Linux 3.15.0-0.rc3.git0.1.fc21.x86_64 ohci_hcd
[    0.474005] usb usb2: SerialNumber: 0000:00:06.0
[    0.475003] hub 2-0:1.0: USB hub found
[    0.475498] hub 2-0:1.0: 8 ports detected
[    0.476752] uhci_hcd: USB Universal Host Controller Interface driver
[    0.477846] usbcore: registered new interface driver usbserial
[    0.478001] usbcore: registered new interface driver usbserial_generic
[    0.478503] usbserial: USB Serial support registered for generic
[    0.478977] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.480867] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.481082] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.481942] mousedev: PS/2 mouse device common for all mice
[    0.483431] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    0.485594] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    0.486229] rtc_cmos rtc_cmos: alarms up to one day, 114 bytes nvram
[    0.486820] device-mapper: uevent: version 1.0.3
[    0.487641] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    0.488637] EFI Variables Facility v0.08 2004-May-17
[    0.502351] hidraw: raw HID events driver (C) Jiri Kosina
[    0.505843] usbcore: registered new interface driver usbhid
[    0.506398] usbhid: USB HID core driver
[    0.506946] drop_monitor: Initializing network drop monitor service
[    0.507151] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.507918] TCP: cubic registered
[    0.508636] Initializing XFRM netlink socket
[    0.509648] NET: Registered protocol family 10
[    0.512867] mip6: Mobile IPv6
[    0.513153] NET: Registered protocol family 17
[    0.515698] Loading compiled-in X.509 certificates
[    0.516987] Loaded X.509 cert 'Fedora kernel signing key: b605bcdfb29f4eff747076eb775e97391499f4dc'
[    0.517994] registered taskstats version 1
[    0.520098]   Magic number: 14:962:254
[    0.520895] rtc_cmos rtc_cmos: setting system clock to 2014-05-02 01:17:50 UTC (1398993470)
[    0.521201] PM: Hibernation image not present or could not be loaded.
[    0.538955] ata9.00: ATAPI: VBOX CD-ROM, 1.0, max UDMA/133
[    0.542799] ata9.00: configured for UDMA/33
[    0.688434] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.694357] ata1.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
[    0.695335] ata1.00: 167772160 sectors, multi 128: LBA48 NCQ (depth 31/32)
[    0.696678] ata1.00: configured for UDMA/133
[    0.696974] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input4
[    0.702175] scsi 0:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
[    0.703658] sd 0:0:0:0: [sda] 167772160 512-byte logical blocks: (85.8 GB/80.0 GiB)
[    0.703845] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.705268] sd 0:0:0:0: [sda] Write Protect is off
[    0.705922] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.705956] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.713069]  sda: sda1 sda2 sda3
[    0.714865] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.011770] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.018746] ata2.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
[    1.019005] ata2.00: 12582912 sectors, multi 128: LBA48 NCQ (depth 31/32)
[    1.020410] ata2.00: configured for UDMA/133
[    1.022638] scsi 1:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
[    1.024150] sd 1:0:0:0: [sdb] 12582912 512-byte logical blocks: (6.44 GB/6.00 GiB)
[    1.024184] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.028316] sd 1:0:0:0: [sdb] Write Protect is off
[    1.028906] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.028938] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.031578]  sdb: unknown partition table
[    1.032301] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.333667] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.340498] ata3.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
[    1.341005] ata3.00: 12582912 sectors, multi 128: LBA48 NCQ (depth 31/32)
[    1.342397] ata3.00: configured for UDMA/133
[    1.344786] scsi 2:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
[    1.348287] sd 2:0:0:0: [sdc] 12582912 512-byte logical blocks: (6.44 GB/6.00 GiB)
[    1.348433] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    1.350560] sd 2:0:0:0: [sdc] Write Protect is off
[    1.351173] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.351210] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.355046]  sdc: unknown partition table
[    1.355858] sd 2:0:0:0: [sdc] Attached SCSI disk
[    1.658793] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.664780] ata4.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
[    1.669335] ata4.00: 12582912 sectors, multi 128: LBA48 NCQ (depth 31/32)
[    1.670309] ata4.00: configured for UDMA/133
[    1.671582] scsi 3:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
[    1.673533] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    1.673551] sd 3:0:0:0: [sdd] 12582912 512-byte logical blocks: (6.44 GB/6.00 GiB)
[    1.674117] sd 3:0:0:0: [sdd] Write Protect is off
[    1.674121] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.674310] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.678093]  sdd: unknown partition table
[    1.678859] sd 3:0:0:0: [sdd] Attached SCSI disk
[    1.980456] ata5: SATA link down (SStatus 0 SControl 300)
[    2.292242] ata6: SATA link down (SStatus 0 SControl 300)
[    2.603917] ata7: SATA link down (SStatus 0 SControl 300)
[    2.915608] ata8: SATA link down (SStatus 0 SControl 300)
[    2.922459] scsi 8:0:0:0: CD-ROM            VBOX     CD-ROM           1.0  PQ: 0 ANSI: 5
[    2.938488] sr0: scsi3-mmc drive: 32x/32x xa/form2 tray
[    2.940007] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.941754] sr 8:0:0:0: Attached scsi CD-ROM sr0
[    2.942304] sr 8:0:0:0: Attached scsi generic sg4 type 5
[    2.945188] Freeing unused kernel memory: 1440K (ffffffff81d27000 - ffffffff81e8f000)
[    2.947714] Write protecting the kernel read-only data: 12288k
[    2.950800] Freeing unused kernel memory: 928K (ffff880003718000 - ffff880003800000)
[    2.953276] Freeing unused kernel memory: 1016K (ffff880003b02000 - ffff880003c00000)
[    2.976895] random: systemd urandom read with 110 bits of entropy available
[    2.979798] systemd[1]: systemd 212 running in system mode. (+PAM +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ +SECCOMP -APPARMOR)
[    2.981000] systemd[1]: Detected virtualization 'oracle'.
[    2.981613] systemd[1]: Detected architecture 'x86-64'.
[    2.982003] systemd[1]: Running in initial RAM disk.
[    2.986616] systemd[1]: Set hostname to <rawhide.localdomain>.
[    3.026005] systemd[1]: Expecting device dev-disk-by\x2duuid-d372e5d1\x2d386f\x2d460c\x2db036\x2d611469e0155e.device...
[    3.029887] systemd[1]: Starting Timers.
[    3.031993] systemd[1]: Reached target Timers.
[    3.032658] systemd[1]: Starting -.slice.
[    3.042250] systemd[1]: Created slice -.slice.
[    3.042847] systemd[1]: Starting udev Kernel Socket.
[    3.045124] systemd[1]: Listening on udev Kernel Socket.
[    3.047632] systemd[1]: Starting udev Control Socket.
[    3.049932] systemd[1]: Listening on udev Control Socket.
[    3.050602] systemd[1]: Starting Journal Socket.
[    3.052141] systemd[1]: Listening on Journal Socket.
[    3.052722] systemd[1]: Starting Sockets.
[    3.053774] systemd[1]: Reached target Sockets.
[    3.054420] systemd[1]: Starting System Slice.
[    3.055795] systemd[1]: Created slice System Slice.
[    3.056653] systemd[1]: Starting system-systemd\x2dfsck.slice.
[    3.057964] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[    3.058603] systemd[1]: Started dracut cmdline hook.
[    3.059144] systemd[1]: Started dracut pre-udev hook.
[    3.059750] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    3.061682] systemd[1]: Started Load Kernel Modules.
[    3.062403] systemd[1]: Starting Journal Service...
[    3.068688] systemd[1]: Started Journal Service.
[    3.104590] systemd-udevd[128]: starting version 212
[    3.181920] random: nonblocking pool is initialized
[    3.248098] raid6: sse2x1    7093 MB/s
[    3.269094] raid6: sse2x2    9164 MB/s
[    3.289073] raid6: sse2x4   10667 MB/s
[    3.293104] raid6: using algorithm sse2x4 (10667 MB/s)
[    3.293630] raid6: using ssse3x2 recovery algorithm
[    3.295909] xor: measuring software checksum speed
[    3.307061]    prefetch64-sse: 15932.000 MB/sec
[    3.319069]    generic_sse: 14820.000 MB/sec
[    3.319586] xor: using function: prefetch64-sse (15932.000 MB/sec)
[    3.344925] Btrfs loaded
[    3.351818] BTRFS: device label fedora devid 1 transid 891 /dev/sda3
[    3.353893] BTRFS: device fsid 7387b661-4e72-45e4-a0a1-e6c4ad460164 devid 3 transid 68 /dev/sdd
[    3.355502] BTRFS: device fsid 7387b661-4e72-45e4-a0a1-e6c4ad460164 devid 2 transid 68 /dev/sdc
[    3.384298] BTRFS info (device sda3): disk space caching is enabled
[    3.631702] systemd-journald[116]: Received SIGTERM from PID 1 (n/a).
[    3.737182] SELinux: 2048 avtab hash slots, 99959 rules.
[    3.751609] SELinux: 2048 avtab hash slots, 99959 rules.
[    3.778004] SELinux:  8 users, 101 roles, 4837 types, 281 bools, 1 sens, 1024 cats
[    3.778056] SELinux:  83 classes, 99959 rules
[    3.784001] SELinux:  Completing initialization.
[    3.784004] SELinux:  Setting up existing superblocks.
[    3.784055] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    3.784075] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    3.784081] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    3.784117] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.784129] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    3.784437] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    3.784981] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    3.784986] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    3.784991] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    3.784995] SELinux: initialized (dev aio, type aio), not configured for labeling
[    3.784999] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    3.785004] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    3.785074] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    3.785081] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    3.785091] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    3.785279] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    3.785283] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.785288] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.785334] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.785354] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.785360] SELinux: initialized (dev pstore, type pstore), uses genfs_contexts
[    3.785372] SELinux: initialized (dev efivarfs, type efivarfs), uses genfs_contexts
[    3.785379] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.785383] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.785386] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.785393] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.785397] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.785400] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.785404] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.785418] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.785422] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.785426] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[    3.785436] SELinux: initialized (dev sda3, type btrfs), uses xattr
[    3.811815] audit: type=1403 audit(1398993473.789:2): policy loaded auid=4294967295 ses=4294967295
[    3.818608] systemd[1]: Successfully loaded SELinux policy in 107.794ms.
[    3.859252] systemd[1]: Relabelled /dev and /run in 16.470ms.
[    4.064381] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[    4.112711] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    4.114916] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.126946] BTRFS info (device sda3): enabling auto defrag
[    4.128760] BTRFS info (device sda3): disk space caching is enabled
[    4.240188] systemd-udevd[313]: starting version 212
[    4.412307] piix4_smbus 0000:00:07.0: SMBus base address uninitialized - upgrade BIOS or use force_addr=0xaddr
[    4.421681] [drm] Initialized drm 1.1.0 20060810
[    4.438155] vboxvideo: module verification failed: signature and/or  required key missing - tainting kernel
[    4.439836] SELinux: initialized (dev drm, type drm), not configured for labeling
[    4.440955] parport_pc 00:03: reported by Plug and Play ACPI
[    4.448451] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.449206] [drm] No driver support for vblank timestamp query.
[    4.449876] [drm] Initialized vboxvideo 1.0.0 20090303 for 0000:00:02.0 on minor 0
[    4.468842] input: Unspecified device as /devices/pci0000:00/0000:00:04.0/input/input5
[    4.477033] vboxguest: major 0, IRQ 20, I/O port c140, MMIO at 00000000a4000000 (size 0x400000)
[    4.477822] vboxguest: Successfully loaded version 4.3.10 (interface 0x00010004)
[    4.505168] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x0
[    4.560935] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x0
[    4.560950] microcode: CPU0 update to revision 0x29 failed
[    4.561059] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x0
[    4.561673] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x0
[    4.561683] microcode: CPU1 update to revision 0x29 failed
[    4.561701] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x0
[    4.561749] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x0
[    4.561763] microcode: CPU2 update to revision 0x29 failed
[    4.563202] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.695672] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    4.698500] SELinux: initialized (dev sda2, type ext4), uses xattr
[    4.744550] RPC: Registered named UNIX socket transport module.
[    4.744554] RPC: Registered udp transport module.
[    4.744557] RPC: Registered tcp transport module.
[    4.744560] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.745326] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
[    4.777327] ppdev: user-space parallel port driver
[    4.799789] SELinux: initialized (dev sda1, type vfat), uses genfs_contexts
[    4.837391] systemd-udevd[323]: renamed network interface eth0 to enp0s3
[    4.869945] audit: type=1305 audit(1398993474.847:3): audit_pid=394 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[    4.907137] snd_intel8x0 0000:00:05.0: intel8x0_measure_ac97_clock: measured 50003 usecs (1671 samples)
[    4.907140] snd_intel8x0 0000:00:05.0: measured clock 33417 rejected
[    5.268728] snd_intel8x0 0000:00:05.0: intel8x0_measure_ac97_clock: measured 51466 usecs (3899 samples)
[    5.268731] snd_intel8x0 0000:00:05.0: measured clock 75758 rejected
[    5.626285] vboxsf: Successfully loaded version 4.3.10 (interface 0x00010004)
[    5.653499] snd_intel8x0 0000:00:05.0: intel8x0_measure_ac97_clock: measured 51893 usecs (3901 samples)
[    5.653503] snd_intel8x0 0000:00:05.0: measured clock 75173 rejected
[    5.653506] snd_intel8x0 0000:00:05.0: clocking to 48000
[    5.739154] SELinux: initialized (dev vboxsf, type vboxsf), uses genfs_contexts
[    5.858313] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.894435] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    5.980587] Ebtables v2.0 registered
[    6.013068] Bridge firewalling registered
[    6.242699] cfg80211: Calling CRDA to update world regulatory domain
[    6.256900] cfg80211: World regulatory domain updated:
[    6.257528] cfg80211:  DFS Master region: unset
[    6.257549] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    6.258650] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    6.259152] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    6.259689] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    6.261857] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    6.266618] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    6.267350] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[   12.065769] systemd-journald[279]: Received request to flush runtime journal from PID 1
[  121.134982] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[  128.354634] BTRFS info (device sdc): allowing degraded mounts
[  128.354791] BTRFS info (device sdc): disk space caching is enabled
[  128.367107] SELinux: initialized (dev sdc, type btrfs), uses xattr
[ 1158.692489] SysRq : Show Blocked State
[ 1158.692721]   task                        PC stack   pid father
[ 1158.692930] btrfs-transacti D ffff88009d914b00     0  1111      2 0x00000080
[ 1158.693115]  ffff88008a39fda8 0000000000000046 ffff8800023f44b0 0000000000014b00
[ 1158.693115]  ffff88008a39ffd8 0000000000014b00 ffff880099476bf0 ffff880088e25000
[ 1158.693115]  ffff8800990079e8 ffff8800990079e8 ffff880088d7b1e0 0000000000000000
[ 1158.693115] Call Trace:
[ 1158.693115]  [<ffffffff81704179>] schedule+0x29/0x70
[ 1158.693115]  [<ffffffffa00bd097>] wait_current_trans.isra.20+0xc7/0x110 [btrfs]
[ 1158.693115]  [<ffffffff810d27a0>] ? abort_exclusive_wait+0xb0/0xb0
[ 1158.693115]  [<ffffffffa00be738>] start_transaction+0x378/0x590 [btrfs]
[ 1158.693115]  [<ffffffffa00bea07>] btrfs_attach_transaction+0x17/0x20 [btrfs]
[ 1158.693115]  [<ffffffffa00b9cab>] transaction_kthread+0x8b/0x260 [btrfs]
[ 1158.693115]  [<ffffffffa00b9c20>] ? btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[ 1158.693115]  [<ffffffff810ade8a>] kthread+0xea/0x100
[ 1158.693115]  [<ffffffff810adda0>] ? insert_kthread_work+0x40/0x40
[ 1158.693115]  [<ffffffff817112fc>] ret_from_fork+0x7c/0xb0
[ 1158.693115]  [<ffffffff810adda0>] ? insert_kthread_work+0x40/0x40
[ 1158.693115] btrfs           D ffff88009d914b00     0  1112   1071 0x00000084
[ 1158.693115]  ffff88008a331818 0000000000000086 ffff88008a373ae0 0000000000014b00
[ 1158.693115]  ffff88008a331fd8 0000000000014b00 ffff880099476bf0 ffff88009d915410
[ 1158.693115]  ffff88009e4458e8 0000000000000002 ffffffff81175a50 ffff88008a331890
[ 1158.693115] Call Trace:
[ 1158.693115]  [<ffffffff81175a50>] ? wait_on_page_read+0x60/0x60
[ 1158.693115]  [<ffffffff817044af>] io_schedule+0xaf/0x150
[ 1158.693115]  [<ffffffff81175a5e>] sleep_on_page+0xe/0x20
[ 1158.693115]  [<ffffffff817048d3>] __wait_on_bit+0x83/0xa0
[ 1158.693115]  [<ffffffff81175809>] wait_on_page_bit+0x89/0xa0
[ 1158.693115]  [<ffffffff810d27e0>] ? autoremove_wake_function+0x40/0x40
[ 1158.693115]  [<ffffffff81175911>] filemap_fdatawait_range+0xf1/0x1a0
[ 1158.693115]  [<ffffffffa00d8afc>] btrfs_wait_ordered_range+0x6c/0x150 [btrfs]
[ 1158.693115]  [<ffffffffa0100990>] __btrfs_write_out_cache+0x640/0x860 [btrfs]
[ 1158.693115]  [<ffffffffa0095741>] ? btrfs_set_path_blocking+0x41/0x80 [btrfs]
[ 1158.693115]  [<ffffffffa0100eea>] btrfs_write_out_cache+0xaa/0xe0 [btrfs]
[ 1158.693115]  [<ffffffffa00ae10c>] btrfs_write_dirty_block_groups+0x68c/0x740 [btrfs]
[ 1158.693115]  [<ffffffffa012fcdf>] commit_cowonly_roots+0x17a/0x234 [btrfs]
[ 1158.693115]  [<ffffffffa00bde57>] btrfs_commit_transaction+0x437/0x9a0 [btrfs]
[ 1158.693115]  [<ffffffffa00ebb04>] btrfs_init_new_device+0x874/0xea0 [btrfs]
[ 1158.693115]  [<ffffffff811d40b3>] ? __kmalloc_track_caller+0xa3/0x270
[ 1158.693115]  [<ffffffffa00f3a31>] ? btrfs_ioctl+0xc11/0x2880 [btrfs]
[ 1158.693115]  [<ffffffffa00f3a52>] btrfs_ioctl+0xc32/0x2880 [btrfs]
[ 1158.693115]  [<ffffffff81703ca4>] ? __schedule+0x2c4/0x770
[ 1158.693115]  [<ffffffff81468b67>] ? put_device+0x17/0x20
[ 1158.693115]  [<ffffffff8148c05a>] ? scsi_device_put+0x3a/0x50
[ 1158.693115]  [<ffffffff8120b9ab>] ? iput+0x3b/0x1a0
[ 1158.693115]  [<ffffffff8122ac99>] ? __blkdev_put+0x149/0x1c0
[ 1158.693115]  [<ffffffff812032a0>] do_vfs_ioctl+0x2d0/0x4b0
[ 1158.693115]  [<ffffffff811f0ace>] ? ____fput+0xe/0x10
[ 1158.693115]  [<ffffffff81203501>] SyS_ioctl+0x81/0xa0
[ 1158.693115]  [<ffffffff817113a9>] system_call_fastpath+0x16/0x1b
[ 1158.693115] Sched Debug Version: v0.11, 3.15.0-0.rc3.git0.1.fc21.x86_64 #1
[ 1158.693115] ktime                                   : 1158708.145530
[ 1158.693115] sched_clk                               : 1156623.874160
[ 1158.693115] cpu_clk                                 : 1158693.115664
[ 1158.693115] jiffies                                 : 4295825988
[ 1158.693115] sched_clock_stable()                    : 0

[ 1158.693115] sysctl_sched
[ 1158.693115]   .sysctl_sched_latency                    : 12.000000
[ 1158.693115]   .sysctl_sched_min_granularity            : 1.500000
[ 1158.693115]   .sysctl_sched_wakeup_granularity         : 2.000000
[ 1158.693115]   .sysctl_sched_child_runs_first           : 0
[ 1158.693115]   .sysctl_sched_features                   : 77435
[ 1158.693115]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)

[ 1158.693115] cpu#0, 2310.805 MHz
[ 1158.693115]   .nr_running                    : 0
[ 1158.693115]   .load                          : 0
[ 1158.693115]   .nr_switches                   : 52355
[ 1158.693115]   .nr_load_updates               : 18816
[ 1158.693115]   .nr_uninterruptible            : -15
[ 1158.693115]   .next_balance                  : 4295.825418
[ 1158.693115]   .curr->pid                     : 0
[ 1158.693115]   .clock                         : 1158692.417655
[ 1158.693115]   .cpu_load[0]                   : 0
[ 1158.693115]   .cpu_load[1]                   : 0
[ 1158.693115]   .cpu_load[2]                   : 0
[ 1158.693115]   .cpu_load[3]                   : 0
[ 1158.693115]   .cpu_load[4]                   : 0
[ 1158.693115] 
cfs_rq[0]:/autogroup-93
[ 1158.693115]   .exec_clock                    : 0.000000
[ 1158.693115]   .MIN_vruntime                  : 0.000001
[ 1158.693115]   .min_vruntime                  : 122.009849
[ 1158.693115]   .max_vruntime                  : 0.000001
[ 1158.693115]   .spread                        : 0.000000
[ 1158.693115]   .spread0                       : -6470.297951
[ 1158.693115]   .nr_spread_over                : 0
[ 1158.693115]   .nr_running                    : 0
[ 1158.693115]   .load                          : 0
[ 1158.693115]   .runnable_load_avg             : 0
[ 1158.693115]   .blocked_load_avg              : 20
[ 1158.693115]   .tg_load_contrib               : 20
[ 1158.693115]   .tg_runnable_contrib           : 9
[ 1158.693115]   .tg_load_avg                   : 20
[ 1158.693115]   .tg->runnable_avg              : 9
[ 1158.693115]   .tg->cfs_bandwidth.timer_active: 0
[ 1158.693115]   .throttled                     : 0
[ 1158.693115]   .throttle_count                : 0
[ 1158.693115]   .se->exec_start                : 1158687.118888
[ 1158.693115]   .se->vruntime                  : 6592.307800
[ 1158.693115]   .se->sum_exec_runtime          : 124.319023
[ 1158.693115]   .se->load.weight               : 2
[ 1158.693115]   .se->avg.runnable_avg_sum      : 962
[ 1158.693115]   .se->avg.runnable_avg_period   : 47671
[ 1158.693115]   .se->avg.load_avg_contrib      : 7
[ 1158.693115]   .se->avg.decay_count           : 1105011
[ 1158.693115] 
cfs_rq[0]:/autogroup-67
[ 1158.693115]   .exec_clock                    : 0.000000
[ 1158.693115]   .MIN_vruntime                  : 0.000001
[ 1158.693115]   .min_vruntime                  : 400.478717
[ 1158.693115]   .max_vruntime                  : 0.000001
[ 1158.693115]   .spread                        : 0.000000
[ 1158.693115]   .spread0                       : -6191.829083
[ 1158.693115]   .nr_spread_over                : 0
[ 1158.693115]   .nr_running                    : 0
[ 1158.693115]   .load                          : 0
[ 1158.693115]   .runnable_load_avg             : 0
[ 1158.693115]   .blocked_load_avg              : 0
[ 1158.693115]   .tg_load_contrib               : 0
[ 1158.693115]   .tg_runnable_contrib           : 0
[ 1158.693115]   .tg_load_avg                   : 0
[ 1158.693115]   .tg->runnable_avg              : 0
[ 1158.693115]   .tg->cfs_bandwidth.timer_active: 0
[ 1158.693115]   .throttled                     : 0
[ 1158.693115]   .throttle_count                : 0
[ 1158.693115]   .se->exec_start                : 1158532.369235
[ 1158.693115]   .se->vruntime                  : 6587.924305
[ 1158.693115]   .se->sum_exec_runtime          : 607.826909
[ 1158.693115]   .se->load.weight               : 2
[ 1158.693115]   .se->avg.runnable_avg_sum      : 2
[ 1158.693115]   .se->avg.runnable_avg_period   : 47852
[ 1158.693115]   .se->avg.load_avg_contrib      : 0
[ 1158.693115]   .se->avg.decay_count           : 1104863
[ 1158.693115] 
cfs_rq[0]:/
[ 1158.693115]   .exec_clock                    : 0.000000
[ 1158.693115]   .MIN_vruntime                  : 0.000001
[ 1158.693115]   .min_vruntime                  : 6592.307800
[ 1158.693115]   .max_vruntime                  : 0.000001
[ 1158.693115]   .spread                        : 0.000000
[ 1158.693115]   .spread0                       : 0.000000
[ 1158.693115]   .nr_spread_over                : 0
[ 1158.693115]   .nr_running                    : 0
[ 1158.693115]   .load                          : 0
[ 1158.693115]   .runnable_load_avg             : 0
[ 1158.693115]   .blocked_load_avg              : 0
[ 1158.693115]   .tg_load_contrib               : 0
[ 1158.693115]   .tg_runnable_contrib           : 9
[ 1158.693115]   .tg_load_avg                   : 6
[ 1158.693115]   .tg->runnable_avg              : 30
[ 1158.693115]   .tg->cfs_bandwidth.timer_active: 0
[ 1158.693115]   .throttled                     : 0
[ 1158.693115]   .throttle_count                : 0
[ 1158.693115]   .avg->runnable_avg_sum         : 443
[ 1158.693115]   .avg->runnable_avg_period      : 47692
[ 1158.693115] 
rt_rq[0]:/
[ 1158.693115]   .rt_nr_running                 : 0
[ 1158.693115]   .rt_throttled                  : 0
[ 1158.693115]   .rt_time                       : 0.000000
[ 1158.693115]   .rt_runtime                    : 950.000000
[ 1158.693115] 
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[ 1158.693115]          systemd     1       535.683061      2220   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-1
[ 1158.693115]      ksoftirqd/0     3      6586.318222      1172   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     kworker/0:0H     5      1439.978793         6   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      migration/0     9         0.005847       263     0               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]       watchdog/0    10         0.000000       292     0               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]             ksmd    26        74.785409         2   125               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]       khugepaged    27        80.847164         2   139               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]          kswapd0    40       205.770830         3   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  acpi_thermal_pm    52       175.595842         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        scsi_eh_1    56       239.523500        24   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        scsi_eh_2    58       246.817816        24   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        scsi_eh_3    60       253.036868        25   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        scsi_eh_7    68       254.907950        21   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     kworker/u6:2    70      6585.825773       635   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     kworker/u6:4    72      6575.094380      1143   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        scsi_eh_8    73      5026.457285        57   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        scsi_eh_9    77       223.124783         4   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     kworker/u6:7    79      6576.423570      1259   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     kworker/u6:8    80      6576.777577      1287   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      kworker/0:2    88      5309.898217      2404   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-transacti   211      6564.618348       456   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]             iprt   335      1411.322051         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     kworker/0:1H   336      6558.502724       339   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      jbd2/sda2-8   373      1820.862660         2   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  ext4-rsv-conver   377      1826.176154         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]           auditd   394        25.821788       883   116               0               0               0.000000               0.000000               0.000000 0 /autogroup-40
[ 1158.693115]          audispd   405         5.091703      1020   112               0               0               0.000000               0.000000               0.000000 0 /autogroup-43
[ 1158.693115]       sedispatch   408         5.423922       451   116               0               0               0.000000               0.000000               0.000000 0 /autogroup-43
[ 1158.693115]            gmain   874       949.290539         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-47
[ 1158.693115]    rs:main Q:Reg   454        52.273198      1257   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-51
[ 1158.693115]           smartd   428         9.798675       129   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-53
[ 1158.693115]       irqbalance   436       202.099095       134   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-58
[ 1158.693115]          chronyd   441        65.123756       203   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-60
[ 1158.693115]           mcelog   471         3.873355        10   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-64
[ 1158.693115]           vminfo   513       400.478717       982   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-67
[ 1158.693115]       cpuhotplug   514        10.351587         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-67
[ 1158.693115]       memballoon   515       393.166214       240   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-67
[ 1158.693115]          vmstats   516       394.593665       386   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-67
[ 1158.693115]        automount   517       398.436182      2315   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-67
[ 1158.693115]            gmain   596        37.184511         5   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-68
[ 1158.693115]            gmain   607        18.459243         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-69
[ 1158.693115]     JS GC Helper   611        27.248023         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-69
[ 1158.693115]         libvirtd   931        28.785923         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-73
[ 1158.693115]         libvirtd   932        26.872372         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-73
[ 1158.693115]         libvirtd   933        25.909837         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-73
[ 1158.693115]         libvirtd   934        25.333158         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-73
[ 1158.693115]         libvirtd   935        24.956405         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-73
[ 1158.693115]         libvirtd   936        24.695717         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-73
[ 1158.693115]         libvirtd   937        24.520780         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-73
[ 1158.693115]         libvirtd   938        24.534104         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-73
[ 1158.693115]         libvirtd   939        24.552861         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-73
[ 1158.693115]         libvirtd   940        24.573592         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-73
[ 1158.693115]           agetty   941         2.218868         9   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-83
[ 1158.693115]          systemd  1067        26.329603         7   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-86
[ 1158.693115]  btrfs-endio-rai  1103      4888.062129         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        btrfs-rmw  1104      4894.205142         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]    btrfs-cleaner  1110      4888.374088         3   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      kworker/0:0  1154      6586.115002      1695   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]            gmain  1172       205.257697        56   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-92
[ 1158.693115]           strace  1200       236.845452         9   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-89
[ 1158.693115]             sshd  1203       122.009849       151   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-93

[ 1158.693115] cpu#1, 2310.805 MHz
[ 1158.693115]   .nr_running                    : 1
[ 1158.693115]   .load                          : 1024
[ 1158.693115]   .nr_switches                   : 32323
[ 1158.693115]   .nr_load_updates               : 16720
[ 1158.693115]   .nr_uninterruptible            : 42
[ 1158.693115]   .next_balance                  : 4295.826177
[ 1158.693115]   .curr->pid                     : 1207
[ 1158.693115]   .clock                         : 1158692.179314
[ 1158.693115]   .cpu_load[0]                   : 0
[ 1158.693115]   .cpu_load[1]                   : 0
[ 1158.693115]   .cpu_load[2]                   : 0
[ 1158.693115]   .cpu_load[3]                   : 0
[ 1158.693115]   .cpu_load[4]                   : 0
[ 1158.693115] 
cfs_rq[1]:/autogroup-94
[ 1158.693115]   .exec_clock                    : 0.000000
[ 1158.693115]   .MIN_vruntime                  : 0.000001
[ 1158.693115]   .min_vruntime                  : 65.693259
[ 1158.693115]   .max_vruntime                  : 0.000001
[ 1158.693115]   .spread                        : 0.000000
[ 1158.693115]   .spread0                       : -6526.614541
[ 1158.693115]   .nr_spread_over                : 0
[ 1158.693115]   .nr_running                    : 1
[ 1158.693115]   .load                          : 1024
[ 1158.693115]   .runnable_load_avg             : 6
[ 1158.693115]   .blocked_load_avg              : 0
[ 1158.693115]   .tg_load_contrib               : 6
[ 1158.693115]   .tg_runnable_contrib           : 6
[ 1158.693115]   .tg_load_avg                   : 6
[ 1158.693115]   .tg->runnable_avg              : 6
[ 1158.693115]   .tg->cfs_bandwidth.timer_active: 0
[ 1158.693115]   .throttled                     : 0
[ 1158.693115]   .throttle_count                : 0
[ 1158.693115]   .se->exec_start                : 1158692.127454
[ 1158.693115]   .se->vruntime                  : 8775.846521
[ 1158.693115]   .se->sum_exec_runtime          : 31.102533
[ 1158.693115]   .se->load.weight               : 1024
[ 1158.693115]   .se->avg.runnable_avg_sum      : 664
[ 1158.693115]   .se->avg.runnable_avg_period   : 47680
[ 1158.693115]   .se->avg.load_avg_contrib      : 0
[ 1158.693115]   .se->avg.decay_count           : 0
[ 1158.693115] 
cfs_rq[1]:/
[ 1158.693115]   .exec_clock                    : 0.000000
[ 1158.693115]   .MIN_vruntime                  : 0.000001
[ 1158.693115]   .min_vruntime                  : 8775.846521
[ 1158.693115]   .max_vruntime                  : 0.000001
[ 1158.693115]   .spread                        : 0.000000
[ 1158.693115]   .spread0                       : 2183.538721
[ 1158.693115]   .nr_spread_over                : 0
[ 1158.693115]   .nr_running                    : 1
[ 1158.693115]   .load                          : 1024
[ 1158.693115]   .runnable_load_avg             : 0
[ 1158.693115]   .blocked_load_avg              : 4
[ 1158.693115]   .tg_load_contrib               : 4
[ 1158.693115]   .tg_runnable_contrib           : 19
[ 1158.693115]   .tg_load_avg                   : 6
[ 1158.693115]   .tg->runnable_avg              : 30
[ 1158.693115]   .tg->cfs_bandwidth.timer_active: 0
[ 1158.693115]   .throttled                     : 0
[ 1158.693115]   .throttle_count                : 0
[ 1158.693115]   .avg->runnable_avg_sum         : 888
[ 1158.693115]   .avg->runnable_avg_period      : 47549
[ 1158.693115] 
rt_rq[1]:/
[ 1158.693115]   .rt_nr_running                 : 0
[ 1158.693115]   .rt_throttled                  : 0
[ 1158.693115]   .rt_time                       : 0.000000
[ 1158.693115]   .rt_runtime                    : 950.000000
[ 1158.693115] 
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[ 1158.693115]       watchdog/1    11        -2.945014       293     0               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      migration/1    12         0.002436       230     0               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      ksoftirqd/1    13      8763.771546       704   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     kworker/1:0H    15        27.046213         5   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]          khelper    22         5.071500         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]            netns    24        14.902137         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      kintegrityd    28        20.992308         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]           bioset    29        27.015279         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]           crypto    30        33.046213         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]          kblockd    31        39.046210         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]          ata_sff    32        45.046207         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]            khubd    33       132.917232         4   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]               md    34        57.087472         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]         kthrotld    51        92.271082         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      kworker/1:1    53      8773.636320      2215   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        scsi_eh_0    54       147.933688        24   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        scsi_eh_6    66       157.960026        21   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]       scsi_tmf_9    78       103.026882         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        kpsmoused    83       129.480077         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]   dm_bufio_cache    84       138.625648         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-worker-hi   193       684.105654         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-endio-rai   202       691.833730         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        btrfs-rmw   203       697.848057         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-endio-wri   204       703.862956         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-freespace   205       709.876798         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-delayed-m   206       715.900736         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-readahead   207       715.904940         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-qgroup-re   208       722.052741         3   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]    btrfs-cleaner   210      8761.632029        97   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  systemd-journal   279       151.251828       734   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-26
[ 1158.693115]          lvmetad   298         2.402642         6   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-31
[ 1158.693115]           rpciod   383      2149.965630         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]          alsactl   412        95.899044        20   139               0               0               0.000000               0.000000               0.000000 0 /autogroup-45
[ 1158.693115]        firewalld   414      1086.947624      1152   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-47
[ 1158.693115]         rsyslogd   421        15.871242        45   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-51
[ 1158.693115]            gmain   450         4.457238         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-54
[ 1158.693115]     avahi-daemon   439         3.972277         3   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-52
[ 1158.693115]      dbus-daemon   460         3.800661         4   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-62
[ 1158.693115]  setroubleshootd   684       415.693453         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-62
[ 1158.693115]      kworker/1:3   468      7154.597903        62   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      VBoxService   509        -4.841778        12   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-67
[ 1158.693115]         timesync   512       171.293988       117   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-67
[ 1158.693115]             sshd   922        31.840143        28   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-76
[ 1158.693115]            crond   926       378.909129        45   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-78
[ 1158.693115]     kworker/u7:1  1061      8758.579401        24   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]             sshd  1063        25.496501       239   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-85
[ 1158.693115]  btrfs-flush_del  1096      6904.203786         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      btrfs-cache  1097      6910.344412         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     btrfs-submit  1098      6916.412910         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      btrfs-fixup  1099      6922.551241         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      btrfs-endio  1100      6928.581952         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-endio-met  1101      6934.758560         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-endio-met  1102      6934.773533         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-endio-wri  1105      6940.912342         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-freespace  1106      6947.149567         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-delayed-m  1107      6953.308505         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-readahead  1108      6959.445452         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-qgroup-re  1109      6965.579651         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]             bash  1119       338.991830       343   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-89
[ 1158.693115]      kworker/1:0  1142      8769.440877       419   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     kworker/u7:3  1144      8758.590484        11   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115] R           bash  1207        65.693259        95   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-94
[ 1158.693115]     kworker/u6:3  1228      8768.616668        12   120               0               0               0.000000               0.000000               0.000000 0 /

[ 1158.693115] cpu#2, 2310.805 MHz
[ 1158.693115]   .nr_running                    : 0
[ 1158.693115]   .load                          : 0
[ 1158.693115]   .nr_switches                   : 45369
[ 1158.693115]   .nr_load_updates               : 20031
[ 1158.693115]   .nr_uninterruptible            : -25
[ 1158.693115]   .next_balance                  : 4295.825005
[ 1158.693115]   .curr->pid                     : 0
[ 1158.693115]   .clock                         : 1157705.905675
[ 1158.693115]   .cpu_load[0]                   : 0
[ 1158.693115]   .cpu_load[1]                   : 0
[ 1158.693115]   .cpu_load[2]                   : 0
[ 1158.693115]   .cpu_load[3]                   : 0
[ 1158.693115]   .cpu_load[4]                   : 0
[ 1158.693115] 
cfs_rq[2]:/
[ 1158.693115]   .exec_clock                    : 0.000000
[ 1158.693115]   .MIN_vruntime                  : 0.000001
[ 1158.693115]   .min_vruntime                  : 9460.698988
[ 1158.693115]   .max_vruntime                  : 0.000001
[ 1158.693115]   .spread                        : 0.000000
[ 1158.693115]   .spread0                       : 2868.391188
[ 1158.693115]   .nr_spread_over                : 0
[ 1158.693115]   .nr_running                    : 0
[ 1158.693115]   .load                          : 0
[ 1158.693115]   .runnable_load_avg             : 0
[ 1158.693115]   .blocked_load_avg              : 2
[ 1158.693115]   .tg_load_contrib               : 2
[ 1158.693115]   .tg_runnable_contrib           : 2
[ 1158.693115]   .tg_load_avg                   : 6
[ 1158.693115]   .tg->runnable_avg              : 21
[ 1158.693115]   .tg->cfs_bandwidth.timer_active: 0
[ 1158.693115]   .throttled                     : 0
[ 1158.693115]   .throttle_count                : 0
[ 1158.693115]   .avg->runnable_avg_sum         : 120
[ 1158.693115]   .avg->runnable_avg_period      : 48039
[ 1158.693115] 
rt_rq[2]:/
[ 1158.693115]   .rt_nr_running                 : 0
[ 1158.693115]   .rt_throttled                  : 0
[ 1158.693115]   .rt_time                       : 0.000000
[ 1158.693115]   .rt_runtime                    : 950.000000
[ 1158.693115] 
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[ 1158.693115]         kthreadd     2      9446.977590       153   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        rcu_sched     7      9458.191305      6830   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]           rcu_bh     8      6661.015103         4   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]       watchdog/2    17        -5.968002       293     0               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      migration/2    18         0.000000       261     0               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      ksoftirqd/2    19      9447.750101       683   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     kworker/2:0H    21       852.845102         7   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        kdevtmpfs    23      3384.877754       156   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        writeback    25         7.855376         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      kworker/2:1    35      4514.990475       201   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]    fsnotify_mark    41      6443.069116        15   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]       scsi_tmf_0    55       265.804705         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]       scsi_tmf_1    57       278.124017         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]       scsi_tmf_2    59       290.445312         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]       scsi_tmf_3    61       302.748015         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        scsi_eh_4    62       459.064354        21   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]       scsi_tmf_4    63       315.369817         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]        scsi_eh_5    64       460.079400        21   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]       scsi_tmf_5    65       327.841234         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]       scsi_tmf_6    67       340.239589         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]       scsi_tmf_7    69       352.663732         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]       scsi_tmf_8    74       375.173749         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     kworker/u6:5    75      9460.004296      1652   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]    ipv6_addrconf    85       441.518977         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]          deferwq    86       447.783360         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]          kauditd   117      9391.967349       476   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      kworker/2:3   155      9456.022747      7018   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     kworker/2:1H   178      4439.122780         7   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]           bioset   181       898.863285         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     btrfs-worker   191       919.685100         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]   btrfs-delalloc   194       928.345449         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-flush_del   195       934.482730         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      btrfs-cache   196       939.642832         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     btrfs-submit   197       944.725302         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      btrfs-fixup   198       949.767830         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      btrfs-endio   199       954.835667         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-endio-met   200       959.951116         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-endio-met   201       960.972574         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]    systemd-udevd   313       138.590122       474   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-35
[ 1158.693115]           auditd   404        23.282850       918   116               0               0               0.000000               0.000000               0.000000 0 /autogroup-40
[ 1158.693115]          audispd   409         5.388365      1250   112               0               0               0.000000               0.000000               0.000000 0 /autogroup-43
[ 1158.693115]            abrtd   417        19.449270       100   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-48
[ 1158.693115]   abrt-watch-log   419        39.288643       116   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-50
[ 1158.693115]     in:imjournal   452       101.564813      1336   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-51
[ 1158.693115]        in:imklog   453        92.157470        29   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-51
[ 1158.693115]     avahi-daemon   427        33.681055       204   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-52
[ 1158.693115]     ModemManager   432        33.991967       107   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-54
[ 1158.693115]            gdbus   461        27.610359         7   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-54
[ 1158.693115]   systemd-logind   438        17.379224       267   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-59
[ 1158.693115]      dbus-daemon   446       721.126819      1672   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-62
[ 1158.693115]  setroubleshootd   464       429.702717       395   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-62
[ 1158.693115]          control   511         6.534365         2   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-67
[ 1158.693115]   NetworkManager   564        69.920198       285   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-68
[ 1158.693115]   NetworkManager   582        11.818022         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-68
[ 1158.693115]            gdbus   598        64.002242        38   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-68
[ 1158.693115]         cfg80211   593      3405.140033         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]          polkitd   600        34.953649       271   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-69
[ 1158.693115]            gdbus   609        35.134110       307   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-69
[ 1158.693115]  JS Sour~ Thread   612        -1.209576         8   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-69
[ 1158.693115]  runaway-killer-   613         1.363254         7   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-69
[ 1158.693115]         dhclient   887        53.577235        38   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-68
[ 1158.693115]         libvirtd   916      1449.000816       262   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-73
[ 1158.693115]              atd   927         8.455273         7   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-79
[ 1158.693115]          dnsmasq  1059         7.616288         3   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-84
[ 1158.693115]     kworker/u7:2  1062      7418.402743        19   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]         (sd-pam)  1069        10.634651         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-86
[ 1158.693115]             bash  1071        66.891556       165   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-87
[ 1158.693115]     btrfs-worker  1093      6417.846517         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-worker-hi  1094      6421.852190         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]   btrfs-delalloc  1095      6421.855159         2   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]  btrfs-transacti  1111      6497.363387         3   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]            btrfs  1112        70.721866        81   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-87
[ 1158.693115]             sshd  1115        34.193916       868   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-88
[ 1158.693115]     kworker/u6:0  1155      9457.864383       969   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     kworker/u6:1  1156      9454.563783      1194   120               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]     kworker/u7:0  1163      9443.827263         4   100               0               0               0.000000               0.000000               0.000000 0 /
[ 1158.693115]      packagekitd  1169      1015.809276       232   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-92
[ 1158.693115]            gdbus  1170      1013.037651       270   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-92