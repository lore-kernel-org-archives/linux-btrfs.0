Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.storix.com ([64.87.16.70]:40219 "EHLO storix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbaJaQ2d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 12:28:33 -0400
Received: from dhcp101.storix (office [24.43.251.42])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by storix.com (Postfix) with ESMTPSA id 3590D2986
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Oct 2014 09:23:28 -0700 (PDT)
From: Rich Turner <rturner@storix.com>
Content-Type: multipart/mixed; boundary="Apple-Mail=_2B1B42C4-CAF0-435F-A5B9-B9028934806B"
Subject: which subvolume is mounted? 
Message-Id: <CFAACED5-055D-4586-A474-CA610881F367@storix.com>
Date: Fri, 31 Oct 2014 09:23:27 -0700
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_2B1B42C4-CAF0-435F-A5B9-B9028934806B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

let=92s first assume the contents of /etc/fstab are either not used or =
invalid in mounting the subvolumes. given the following =91df=92 =
command, how do i know which subvolume of the btrfs filesystem on =
/dev/sda3 is mounted at each mount point (/, /var, /opt, /home)? i would =
have expected to see the mount option used to define the subvolume =
(subvolid or subvol option) in /proc/mounts.

# df
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/sda3        6839296 1698564   4903212  26% /
devtmpfs          501464       0    501464   0% /dev
tmpfs             507316       0    507316   0% /dev/shm
tmpfs             507316    6720    500596   2% /run
tmpfs             507316       0    507316   0% /sys/fs/cgroup
/dev/sda3        6839296 1698564   4903212  26% /var
/dev/sda3        6839296 1698564   4903212  26% /opt
/dev/sda3        6839296 1698564   4903212  26% /home
/dev/sda1         517868   93040    424828  18% /boot

# btrfs subvolume list -a --sort=3D+rootid /
ID 257 gen 7800 top level 5 path <FS_TREE>/root
ID 258 gen 4127 top level 5 path <FS_TREE>/home
ID 259 gen 7801 top level 5 path <FS_TREE>/var
ID 260 gen 7795 top level 5 path <FS_TREE>/opt

# uname -a
Linux turner11.storix 3.10.0-123.el7.x86_64 #1 SMP Mon May 5 11:16:57 =
EDT 2014 x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
Btrfs v3.12

# btrfs fi show
Label: rhel_turner11  uuid: cd3c0e50-d726-44e2-9bfa-19b11614136a
	Total devices 1 FS bytes used 1.62GiB
	devid    1 size 6.52GiB used 2.24GiB path /dev/sda3

Btrfs v3.12

# btrfs fi df /
Data, single: total=3D1.98GiB, used=3D1.58GiB
System, single: total=3D4.00MiB, used=3D16.00KiB
Metadata, single: total=3D264.00MiB, used=3D36.03MiB


--Apple-Mail=_2B1B42C4-CAF0-435F-A5B9-B9028934806B
Content-Disposition: attachment;
	filename=dmesg.log
Content-Type: application/octet-stream;
	name="dmesg.log"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.0-123.el7.x86_64 (mockbuild@x86-017.build.eng.bos.redhat.com) (gcc version 4.8.2 20140120 (Red Hat 4.8.2-16) (GCC) ) #1 SMP Mon May 5 11:16:57 EDT 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.10.0-123.el7.x86_64 root=UUID=cd3c0e50-d726-44e2-9bfa-19b11614136a ro rootflags=subvol=root vconsole.keymap=us crashkernel=auto vconsole.font=latarcyrheb-sun16 rhgb quiet LANG=en_US.UTF-8
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003ffeffff] usable
[    0.000000] BIOS-e820: [mem 0x000000003fff0000-0x000000003fffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000003ffff000-0x000000003fffffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000fd000000-0x00000000fd7fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Parallels Software International Inc. Parallels Virtual Platform/Parallels Virtual Platform, BIOS 9.0.24251.1052177 Thu, 28 Aug
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x3fff0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [mem 0x000ff100-0x000ff10f] mapped at [ffff8800000ff100]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01e1d000, 0x01e1dfff] PGTABLE
[    0.000000] BRK [0x01e1e000, 0x01e1efff] PGTABLE
[    0.000000] BRK [0x01e1f000, 0x01e1ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x3fc00000-0x3fdfffff]
[    0.000000]  [mem 0x3fc00000-0x3fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x3c000000-0x3fbfffff]
[    0.000000]  [mem 0x3c000000-0x3fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x3bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x3fe00000-0x3ffeffff]
[    0.000000]  [mem 0x3fe00000-0x3ffeffff] page 4k
[    0.000000] BRK [0x01e20000, 0x01e20fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x36c2c000-0x3760dfff]
[    0.000000] crashkernel=auto resulted in zero bytes of reserved memory.
[    0.000000] ACPI: RSDP 00000000000e8000 00024 (v02 PRLS  )
[    0.000000] ACPI: XSDT 000000003fff0040 0003C (v01 PRLS   PRLS_OEM 00000001 INTL 20051216)
[    0.000000] ACPI: FACP 000000003fff0100 000F4 (v03 PRLS   PRLS_OEM 00000001 INTL 20051216)
[    0.000000] ACPI: DSDT 000000003fff0480 04364 (v02 PRLS   PRLSACPI 00001001 INTL 20051216)
[    0.000000] ACPI: FACS 000000003fff0200 00040
[    0.000000] ACPI: APIC 000000003fff0240 00216 (v01 PRLS   PRLS_OEM 00000001 INTL 20051216)
[    0.000000] ACPI: HPET 000000003fff4800 00038 (v00 PRLS   PRLS_OEM 00000001 INTL 20051216)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000003ffeffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x3ffeffff]
[    0.000000]   NODE_DATA [mem 0x3ffc9000-0x3ffeffff]
[    0.000000]  [ffffea0000000000-ffffea0000ffffff] PMD -> [ffff88003e600000-ffff88003f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x3ffeffff]
[    0.000000] On node 0 totalpages: 262030
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 4032 pages used for memmap
[    0.000000]   DMA32 zone: 258032 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x12] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x13] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x15] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x16] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x17] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x18] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x19] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x1c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x1d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x1e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x1f] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 dfl edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 dfl edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 32 CPUs, 31 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
[    0.000000] e820: [mem 0x40000000-0xfcffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:5120 nr_cpumask_bits:32 nr_cpu_ids:32 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88003e200000 s86592 r8192 d24000 u131072
[    0.000000] pcpu-alloc: s86592 r8192 d24000 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] pcpu-alloc: [0] 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 257913
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.10.0-123.el7.x86_64 root=UUID=cd3c0e50-d726-44e2-9bfa-19b11614136a ro rootflags=subvol=root vconsole.keymap=us crashkernel=auto vconsole.font=latarcyrheb-sun16 rhgb quiet LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 1002932k/1048512k available (6105k kernel code, 392k absent, 45188k reserved, 4065k data, 1584k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=5120 to nr_cpu_ids=32.
[    0.000000] 	Experimental no-CBs for all CPUs
[    0.000000] 	Experimental no-CBs CPUs: 0-31.
[    0.000000] NR_IRQS:327936 nr_irqs:936 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 4194304 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.001000] tsc: Fast TSC calibration using PIT
[    0.002000] tsc: Detected 2500.206 MHz processor
[    0.000059] Calibrating delay loop (skipped), value calculated using timer frequency.. 5000.41 BogoMIPS (lpj=2500206)
[    0.000067] pid_max: default: 32768 minimum: 301
[    0.000269] Security Framework initialized
[    0.000293] SELinux:  Initializing.
[    0.000313] SELinux:  Starting in permissive mode
[    0.000831] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.008717] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.012678] Mount-cache hash table entries: 4096
[    0.014564] Initializing cgroup subsys memory
[    0.014588] Initializing cgroup subsys devices
[    0.014596] Initializing cgroup subsys freezer
[    0.014603] Initializing cgroup subsys net_cls
[    0.014612] Initializing cgroup subsys blkio
[    0.014618] Initializing cgroup subsys perf_event
[    0.014623] Initializing cgroup subsys hugetlb
[    0.014945] Disabled fast string operations
[    0.014950] CPU: Physical Processor ID: 0
[    0.015275] mce: CPU supports 0 MCE banks
[    0.015316] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 2
[    0.033475] ACPI: Core revision 20130517
[    0.035486] ACPI: All ACPI Tables successfully acquired
[    0.035499] ftrace: allocating 23383 entries in 92 pages
[    0.064656] Switched APIC routing to physical flat.
[    0.066139] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.076180] smpboot: CPU0: Intel(R) Core(TM) i5-3210M CPU @ 2.50GHz (fam: 06, model: 3a, stepping: 09)
[    0.177982] Performance Events: unsupported p6 CPU model 58 no PMU driver, software events only.
[    0.194973] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.195086] Brought up 1 CPUs
[    0.195090] smpboot: Total of 1 processors activated (5000.41 BogoMIPS)
[    0.198749] devtmpfs: initialized
[    0.199823] EVM: security.selinux
[    0.199827] EVM: security.ima
[    0.199829] EVM: security.capability
[    0.199998] PM: Registering ACPI NVS region [mem 0x3ffff000-0x3fffffff] (4096 bytes)
[    0.201845] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.202247] NET: Registered protocol family 16
[    0.202721] ACPI: bus type PCI registered
[    0.202729] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.202850] PCI: Using configuration type 1 for base access
[    0.204287] bio: create slab <bio-0> at 0
[    0.204859] ACPI: Added _OSI(Module Device)
[    0.204863] ACPI: Added _OSI(Processor Device)
[    0.204866] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.204869] ACPI: Added _OSI(Processor Aggregator Device)
[    0.205364] ACPI: EC: Look up EC in DSDT
[    0.205824] ACPI: Executed 1 blocks of module-level executable AML code
[    0.206974] ACPI: Interpreter enabled
[    0.206986] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130517/hwxface-571)
[    0.206997] ACPI: (supports S0 S1 S3 S4 S5)
[    0.207001] ACPI: Using IOAPIC for interrupt routing
[    0.207025] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.207093] ACPI: No dock devices found.
[    0.215127] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
[    0.215139] acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.215145] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.215165] acpi PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.215167] acpi PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.215170] acpi PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.215173] acpi PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.215175] acpi PNP0A08:00: host bridge window [mem 0x000c0000-0x000cffff] (ignored)
[    0.215177] acpi PNP0A08:00: host bridge window [mem 0xb0000000-0xfbffffff] (ignored)
[    0.215180] acpi PNP0A08:00: host bridge window [mem 0xfd000000-0xfd7fffff] (ignored)
[    0.215184] PCI: root bus 00: using default resources
[    0.215188] acpi PNP0A08:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.215367] PCI host bridge to bus 0000:00
[    0.215372] pci_bus 0000:00: root bus resource [bus 00-7f]
[    0.215374] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.215377] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffffff]
[    0.215401] pci 0000:00:00.0: [8086:29a0] type 00 class 0x060000
[    0.215581] pci 0000:00:01.0: [8086:2981] type 01 class 0x060401
[    0.215711] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.215817] pci 0000:00:03.0: [1ab8:4000] type 00 class 0xff0000
[    0.215847] pci 0000:00:03.0: reg 0x10: [io  0x8000-0x801f]
[    0.216072] pci 0000:00:05.0: [8086:100f] type 00 class 0x020000
[    0.216165] pci 0000:00:05.0: reg 0x10: [mem 0xee000000-0xee01ffff]
[    0.216349] pci 0000:00:05.0: reg 0x1c: [io  0x8200-0x821f]
[    0.216825] pci 0000:00:0a.0: [1011:0022] type 01 class 0x060400
[    0.217012] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060400
[    0.217232] pci 0000:00:1f.0: [8086:2810] type 00 class 0x060100
[    0.217393] pci 0000:00:1f.0: address space collision: [io  0x4000-0x407f] conflicts with ACPI CPU throttle [??? 0x00004010-0x00004015 flags 0x80000000]
[    0.217564] pci 0000:00:1f.1: [8086:244b] type 00 class 0x010180
[    0.217677] pci 0000:00:1f.1: reg 0x20: [io  0xd000-0xd00f]
[    0.217916] pci 0000:00:1f.2: [8086:2821] type 00 class 0x010601
[    0.218021] pci 0000:00:1f.2: reg 0x10: [io  0xd200-0xd207]
[    0.218074] pci 0000:00:1f.2: reg 0x14: [io  0xd400-0xd403]
[    0.218130] pci 0000:00:1f.2: reg 0x18: [io  0xd600-0xd607]
[    0.218183] pci 0000:00:1f.2: reg 0x1c: [io  0xd800-0xd803]
[    0.218236] pci 0000:00:1f.2: reg 0x20: [io  0xda00-0xda0f]
[    0.218288] pci 0000:00:1f.2: reg 0x24: [mem 0xf0100000-0xf0101fff]
[    0.218429] pci 0000:00:1f.2: PME# supported from D3hot
[    0.218575] pci 0000:00:1f.4: [8086:2445] type 00 class 0x040100
[    0.218633] pci 0000:00:1f.4: reg 0x10: [io  0xdc00-0xdcff]
[    0.218678] pci 0000:00:1f.4: reg 0x14: [io  0xde00-0xdeff]
[    0.219163] pci 0000:01:00.0: [1ab8:4005] type 00 class 0x030000
[    0.219788] pci 0000:01:00.0: reg 0x10: [io  0x6000-0x601f]
[    0.220186] pci 0000:01:00.0: reg 0x14: [mem 0xb0000000-0xb1ffffff pref]
[    0.222588] pci 0000:01:00.0: reg 0x30: [mem 0xe2000000-0xe200ffff pref]
[    0.222876] pci 0000:00:01.0: PCI bridge to [bus 01] (subtractive decode)
[    0.222887] pci 0000:00:01.0:   bridge window [io  0x6000-0x7fff]
[    0.222896] pci 0000:00:01.0:   bridge window [mem 0xe2000000-0xedffffff]
[    0.222909] pci 0000:00:01.0:   bridge window [mem 0xb0000000-0xdfffffff 64bit pref]
[    0.222913] pci 0000:00:01.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.222917] pci 0000:00:01.0:   bridge window [mem 0x00000000-0xfffffffff] (subtractive decode)
[    0.223071] pci 0000:00:0a.0: PCI bridge to [bus 02]
[    0.223081] pci 0000:00:0a.0:   bridge window [io  0x9000-0xafff]
[    0.223090] pci 0000:00:0a.0:   bridge window [mem 0xee100000-0xef0fffff]
[    0.223100] pci 0000:00:0a.0:   bridge window [mem 0xe0000000-0xe0ffffff pref]
[    0.223297] pci 0000:00:1e.0: PCI bridge to [bus 03] (subtractive decode)
[    0.223307] pci 0000:00:1e.0:   bridge window [io  0xb000-0xcfff]
[    0.223317] pci 0000:00:1e.0:   bridge window [mem 0xef100000-0xf00fffff]
[    0.223331] pci 0000:00:1e.0:   bridge window [mem 0xe1000000-0x4001ab8e1ffffff 64bit pref]
[    0.223335] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.223340] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xfffffffff] (subtractive decode)
[    0.223414] ACPI Exception: AE_NOT_FOUND, Evaluating _PRS (20130517/pci_link-180)
[    0.226485] ACPI: Enabled 2 GPEs in block 00 to 0F
[    0.226499] ACPI: \_SB_.PCI0: notify handler is installed
[    0.226545] Found 1 acpi root devices
[    0.226575] ACPI: EC: GPE = 0xa, I/O: command/status = 0x66, data = 0x62
[    0.226767] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.226772] vgaarb: loaded
[    0.226775] vgaarb: bridge control possible 0000:01:00.0
[    0.227285] SCSI subsystem initialized
[    0.227374] ACPI: bus type USB registered
[    0.227455] usbcore: registered new interface driver usbfs
[    0.227473] usbcore: registered new interface driver hub
[    0.227853] usbcore: registered new device driver usb
[    0.228099] PCI: Using ACPI for IRQ routing
[    0.228106] PCI: pci_cache_line_size set to 64 bytes
[    0.228117] pci 0000:00:1e.0: no compatible bridge window for [mem 0xe1000000-0x4001ab8e1ffffff 64bit pref]
[    0.228199] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.228205] e820: reserve RAM buffer [mem 0x3fff0000-0x3fffffff]
[    0.228485] NetLabel: Initializing
[    0.228491] NetLabel:  domain hash size = 128
[    0.228494] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.228509] NetLabel:  unlabeled traffic allowed by default
[    0.228596] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.228603] hpet0: 8 comparators, 64-bit 16.000000 MHz counter
[    0.230693] Switching to clocksource hpet
[    0.273012] pnp: PnP ACPI init
[    0.273156] ACPI: bus type PNP registered
[    0.273369] pnp 00:00: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.273420] pnp 00:01: Plug and Play ACPI device, IDs PNP0f03 (active)
[    0.273507] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.273556] pnp 00:03: [dma 2]
[    0.273597] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.273710] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.273753] system 00:05: [mem 0xffc00000-0xffffffff] has been reserved
[    0.273756] system 00:05: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.273757] pnp 00:06: [dma 4]
[    0.273929] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.273967] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.273972] system 00:07: [io  0x1000-0x107f] has been reserved
[    0.273976] system 00:07: [io  0x1300-0x133f] has been reserved
[    0.273981] system 00:07: [mem 0xfc000000-0xfcffffff] has been reserved
[    0.273985] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.274035] pnp 00:08: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.274109] pnp 00:09: Plug and Play ACPI device, IDs INT0800 (active)
[    0.274274] pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.276618] pnp: PnP ACPI: found 11 devices
[    0.276625] ACPI: bus type PNP unregistered
[    0.286389] pci 0000:00:1f.0: BAR 13: [io  0x4000-0x407f] has bogus alignment
[    0.286397] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.286404] pci 0000:00:01.0:   bridge window [io  0x6000-0x7fff]
[    0.286418] pci 0000:00:01.0:   bridge window [mem 0xe2000000-0xedffffff]
[    0.286427] pci 0000:00:01.0:   bridge window [mem 0xb0000000-0xdfffffff 64bit pref]
[    0.286443] pci 0000:00:0a.0: PCI bridge to [bus 02]
[    0.286450] pci 0000:00:0a.0:   bridge window [io  0x9000-0xafff]
[    0.286461] pci 0000:00:0a.0:   bridge window [mem 0xee100000-0xef0fffff]
[    0.286470] pci 0000:00:0a.0:   bridge window [mem 0xe0000000-0xe0ffffff pref]
[    0.286483] pci 0000:00:1e.0: PCI bridge to [bus 03]
[    0.286489] pci 0000:00:1e.0:   bridge window [io  0xb000-0xcfff]
[    0.286500] pci 0000:00:1e.0:   bridge window [mem 0xef100000-0xf00fffff]
[    0.286520] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.286524] pci_bus 0000:00: resource 5 [mem 0x00000000-0xfffffffff]
[    0.286530] pci_bus 0000:01: resource 0 [io  0x6000-0x7fff]
[    0.286534] pci_bus 0000:01: resource 1 [mem 0xe2000000-0xedffffff]
[    0.286538] pci_bus 0000:01: resource 2 [mem 0xb0000000-0xdfffffff 64bit pref]
[    0.286542] pci_bus 0000:01: resource 4 [io  0x0000-0xffff]
[    0.286546] pci_bus 0000:01: resource 5 [mem 0x00000000-0xfffffffff]
[    0.286549] pci_bus 0000:02: resource 0 [io  0x9000-0xafff]
[    0.286553] pci_bus 0000:02: resource 1 [mem 0xee100000-0xef0fffff]
[    0.286556] pci_bus 0000:02: resource 2 [mem 0xe0000000-0xe0ffffff pref]
[    0.286560] pci_bus 0000:03: resource 0 [io  0xb000-0xcfff]
[    0.286564] pci_bus 0000:03: resource 1 [mem 0xef100000-0xf00fffff]
[    0.286567] pci_bus 0000:03: resource 4 [io  0x0000-0xffff]
[    0.286571] pci_bus 0000:03: resource 5 [mem 0x00000000-0xfffffffff]
[    0.286681] NET: Registered protocol family 2
[    0.287619] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.288254] TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
[    0.289207] TCP: Hash tables configured (established 8192 bind 8192)
[    0.290183] TCP: reno registered
[    0.290277] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.290433] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.291004] NET: Registered protocol family 1
[    0.291144] pci 0000:01:00.0: Boot video device
[    0.291156] PCI: CLS 0 bytes, default 64
[    0.291278] Unpacking initramfs...
[    0.744105] Freeing initrd memory: 10120k freed
[    0.746123] microcode: CPU0 sig=0x306a9, pf=0x1, revision=0x0
[    0.746352] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.746906] futex hash table entries: 8192 (order: 7, 524288 bytes)
[    0.749999] Initialise system trusted keyring
[    0.750053] audit: initializing netlink socket (disabled)
[    0.750073] type=2000 audit(1414770267.630:1): initialized
[    0.770543] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.774228] zbud: loaded
[    0.774545] VFS: Disk quotas dquot_6.5.2
[    0.774679] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.775434] msgmni has been set to 1978
[    0.775863] Key type big_key registered
[    0.775870] SELinux:  Registering netfilter hooks
[    0.778611] alg: No test for stdrng (krng)
[    0.778619] NET: Registered protocol family 38
[    0.778623] Key type asymmetric registered
[    0.778628] Asymmetric key parser 'x509' registered
[    0.778674] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.778792] io scheduler noop registered
[    0.778795] io scheduler deadline registered (default)
[    0.778818] io scheduler cfq registered
[    0.778970] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.778982] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.779050] intel_idle: does not run on family 6 model 58
[    0.780399] ACPI: AC Adapter [ADP0] (on-line)
[    0.780450] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.780454] ACPI: Power Button [PWRF]
[    0.780527] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
[    0.780532] ACPI: Sleep Button [SLPF]
[    0.782199] GHES: HEST is not enabled!
[    0.782292] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.784111] Non-volatile memory driver v1.3
[    0.784115] Linux agpgart interface v0.103
[    0.784193] crash memory driver: version 1.1
[    0.784244] rdac: device handler registered
[    0.790250] hp_sw: device handler registered
[    0.790258] emc: device handler registered
[    0.790259] alua: device handler registered
[    0.790339] libphy: Fixed MDIO Bus: probed
[    0.790541] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.790551] ehci-pci: EHCI PCI platform driver
[    0.790572] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.790578] ohci-pci: OHCI PCI platform driver
[    0.790593] uhci_hcd: USB Universal Host Controller Interface driver
[    0.791575] usbcore: registered new interface driver usbserial
[    0.791590] usbcore: registered new interface driver usbserial_generic
[    0.791608] usbserial: USB Serial support registered for generic
[    0.791691] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.792125] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.792139] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.792680] mousedev: PS/2 mouse device common for all mice
[    0.793345] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    0.799019] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.799106] rtc_cmos 00:02: alarms up to one day, y3k, 242 bytes nvram, hpet irqs
[    0.799123] cpuidle: using governor menu
[    0.799533] hidraw: raw HID events driver (C) Jiri Kosina
[    0.799795] usbcore: registered new interface driver usbhid
[    0.799800] usbhid: USB HID core driver
[    0.799883] drop_monitor: Initializing network drop monitor service
[    0.800599] TCP: cubic registered
[    0.800604] Initializing XFRM netlink socket
[    0.800826] NET: Registered protocol family 10
[    0.802205] NET: Registered protocol family 17
[    0.803318] Loading compiled-in X.509 certificates
[    0.804163] Loaded X.509 cert 'Red Hat Enterprise Linux Driver Update Program (key 3): bf57f3e87362bc7229d9f465321773dfd1f77a80'
[    0.808786] Loaded X.509 cert 'Red Hat Enterprise Linux kpatch signing key: 4d38fd864ebe18c5f0b72e3852e2014c3a676fc8'
[    0.809464] Loaded X.509 cert 'Red Hat Enterprise Linux kernel signing key: 00aa5f56c587bd82f2f99d64ba83dd1e9e0d334a'
[    0.809537] registered taskstats version 1
[    0.818357] ACPI: Battery Slot [BAT0] (battery present)
[    0.820288] Key type trusted registered
[    0.823484] Key type encrypted registered
[    0.825932] IMA: No TPM chip found, activating TPM-bypass!
[    0.826611] rtc_cmos 00:02: setting system clock to 2014-10-31 15:44:28 UTC (1414770268)
[    0.827489] Freeing unused kernel memory: 1584k freed
[    0.835971] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    0.836591] systemd[1]: Detected virtualization 'other'.
[    0.836597] systemd[1]: Running in initial RAM disk.
[    0.836699] systemd[1]: Set hostname to <turner11.storix>.
[    0.880525] systemd[1]: Expecting device dev-disk-by\x2duuid-cd3c0e50\x2dd726\x2d44e2\x2d9bfa\x2d19b11614136a.device...
[    0.880556] systemd[1]: Starting -.slice.
[    0.880797] systemd[1]: Created slice -.slice.
[    0.880875] systemd[1]: Starting System Slice.
[    0.881116] systemd[1]: Created slice System Slice.
[    0.881184] systemd[1]: Starting Slices.
[    0.881278] systemd[1]: Reached target Slices.
[    0.881339] systemd[1]: Starting Timers.
[    0.881361] systemd[1]: Reached target Timers.
[    0.881417] systemd[1]: Starting Journal Socket.
[    0.881555] systemd[1]: Listening on Journal Socket.
[    0.881839] systemd[1]: Started dracut cmdline hook.
[    0.882118] systemd[1]: Started dracut pre-udev hook.
[    0.882415] systemd[1]: Started Load Kernel Modules.
[    0.882444] systemd[1]: Starting Setup Virtual Console...
[    0.883014] systemd[1]: Starting Journal Service...
[    0.883853] systemd[1]: Started Journal Service.
[    0.908929] systemd-journald[143]: Vacuuming done, freed 0 bytes
[    0.978058] systemd-udevd[160]: starting version 208
[    1.101467] Floppy drive(s): fd0 is 1.44M
[    1.113833] FDC 0 is an 8272A
[    1.128595] ACPI: bus type ATA registered
[    1.143422] libata version 3.00 loaded.
[    1.144822] ata_piix 0000:00:1f.1: version 2.13
[    1.158916] scsi0 : ata_piix
[    1.169276] scsi1 : ata_piix
[    1.169342] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xd000 irq 14
[    1.169344] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xd008 irq 15
[    1.169599] ahci 0000:00:1f.2: version 3.0
[    1.169770] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    1.169811] ahci: SSS flag set, parallel bus scan disabled
[    1.169895] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.169898] ahci 0000:00:1f.2: flags: 64bit ncq stag pm led only slum part 
[    1.195492] scsi2 : ahci
[    1.205072] scsi3 : ahci
[    1.210621] scsi4 : ahci
[    1.211937] scsi5 : ahci
[    1.213893] scsi6 : ahci
[    1.216750] scsi7 : ahci
[    1.216979] ata3: SATA max UDMA/133 abar m8192@0xf0100000 port 0xf0100100 irq 40
[    1.216982] ata4: SATA max UDMA/133 abar m8192@0xf0100000 port 0xf0100180 irq 40
[    1.216985] ata5: SATA max UDMA/133 abar m8192@0xf0100000 port 0xf0100200 irq 40
[    1.216986] ata6: SATA max UDMA/133 abar m8192@0xf0100000 port 0xf0100280 irq 40
[    1.216988] ata7: SATA max UDMA/133 abar m8192@0xf0100000 port 0xf0100300 irq 40
[    1.216990] ata8: SATA max UDMA/133 abar m8192@0xf0100000 port 0xf0100380 irq 40
[    1.320145] ata1.01: ATAPI: Virtual DVD-ROM [1], FWR1, max UDMA/25
[    1.320452] ata1.01: configured for UDMA/25
[    1.321088] scsi 0:0:1:0: CD-ROM                     Virtual DVD-ROM  R103 PQ: 0 ANSI: 5
[    1.523687] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.523837] ata3.00: ATA-8: rhel7x64_btrfs-0 SSD, F.TKTWDC, max UDMA/100
[    1.523839] ata3.00: 16777216 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.523956] ata3.00: configured for UDMA/100
[    1.524191] scsi 2:0:0:0: Direct-Access     ATA      rhel7x64_btrfs-0 F.TK PQ: 0 ANSI: 5
[    1.627978] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[    1.747465] tsc: Refined TSC clocksource calibration: 2497.399 MHz
[    1.747482] Switching to clocksource tsc
[    1.830297] ata4: SATA link down (SStatus 0 SControl 300)
[    2.135659] ata5: SATA link down (SStatus 0 SControl 300)
[    2.440873] ata6: SATA link down (SStatus 0 SControl 300)
[    2.746993] ata7: SATA link down (SStatus 0 SControl 300)
[    3.052156] ata8: SATA link down (SStatus 0 SControl 300)
[    3.077670] sr0: scsi3-mmc drive: 44x/44x cd/rw xa/form2 cdda tray
[    3.077675] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.078137] sr 0:0:1:0: Attached scsi CD-ROM sr0
[    3.079724] sd 2:0:0:0: [sda] 16777216 512-byte logical blocks: (8.58 GB/8.00 GiB)
[    3.079726] sd 2:0:0:0: [sda] 4096-byte physical blocks
[    3.079767] sd 2:0:0:0: [sda] Write Protect is off
[    3.079769] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.079782] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.082651]  sda: sda1 sda2 sda3
[    3.083162] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.150969] raid6: sse2x1    7390 MB/s
[    3.167947] raid6: sse2x2    9394 MB/s
[    3.184956] raid6: sse2x4   10519 MB/s
[    3.184959] raid6: using algorithm sse2x4 (10519 MB/s)
[    3.184960] raid6: using ssse3x2 recovery algorithm
[    3.187496] xor: automatically using best checksumming function:
[    3.196955]    avx       : 16324.000 MB/sec
[    3.214277] bio: create slab <bio-1> at 1
[    3.216134] Btrfs loaded
[    3.216590] btrfs: device label rhel_turner11 devid 1 transid 7781 /dev/sda3
[    3.246479] btrfs: device label rhel_turner11 devid 1 transid 7781 /dev/sda3
[    3.247418] btrfs: disk space caching is enabled
[    3.252347] Btrfs detected SSD devices, enabling SSD mode
[    3.408555] systemd-journald[143]: Received SIGTERM
[    3.413133] systemd-cgroups-agent[305]: Failed to get D-Bus connection: Failed to connect to socket /run/systemd/private: No such file or directory
[    3.539564] type=1404 audit(1414770271.212:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    3.843953] SELinux: 2048 avtab hash slots, 106409 rules.
[    3.855976] SELinux: 2048 avtab hash slots, 106409 rules.
[    3.881757] SELinux:  8 users, 86 roles, 4801 types, 280 bools, 1 sens, 1024 cats
[    3.881762] SELinux:  83 classes, 106409 rules
[    3.884939] SELinux:  Completing initialization.
[    3.884942] SELinux:  Setting up existing superblocks.
[    3.884950] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    3.884954] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    3.884969] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    3.884972] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    3.885063] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.885076] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    3.885566] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    3.885570] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    3.885976] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    3.885981] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    3.885983] SELinux: initialized (dev aio, type aio), not configured for labeling
[    3.885985] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    3.885999] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    3.886004] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    3.886010] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    3.886016] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    3.886019] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    3.886144] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.886148] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.886216] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.886241] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.886248] SELinux: initialized (dev pstore, type pstore), uses genfs_contexts
[    3.886250] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.886253] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.886255] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.886259] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.886261] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.886263] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.886265] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.886268] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.886270] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.886273] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[    3.886283] SELinux: initialized (dev sda3, type btrfs), uses xattr
[    3.890590] type=1403 audit(1414770271.563:3): policy loaded auid=4294967295 ses=4294967295
[    3.898625] systemd[1]: Successfully loaded SELinux policy in 361.033ms.
[    3.941078] systemd[1]: Relabelled /dev and /run in 18.456ms.
[    4.072330] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[    4.123252] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    4.207242] RPC: Registered named UNIX socket transport module.
[    4.207244] RPC: Registered udp transport module.
[    4.207246] RPC: Registered tcp transport module.
[    4.207246] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.252265] btrfs: disk space caching is enabled
[    4.275678] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    4.276038] SELinux: initialized (dev nfsd, type nfsd), uses genfs_contexts
[    4.292986] systemd-journald[340]: Vacuuming done, freed 0 bytes
[    4.395774] systemd-udevd[355]: starting version 208
[    4.468620] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    4.476054] lpc_ich 0000:00:1f.0: RCBA is disabled by hardware/BIOS, device disabled
[    4.476062] ACPI Warning: SystemIO range 0x0000000000004028-0x000000000000402f conflicts with OpRegion 0x0000000000004000-0x000000000000404e (\PMIO) (20130517/utaddress-254)
[    4.476066] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.476070] lpc_ich 0000:00:1f.0: I/O space for GPIO uninitialized
[    4.476071] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    4.476072] lpc_ich 0000:00:1f.0: No MFD cells added
[    4.486991] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    4.486994] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.761443] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    4.913669] btrfs: device label rhel_turner11 devid 1 transid 7781 /dev/sda3
[    4.976587] Adding 1023996k swap on /dev/sda2.  Priority:-1 extents:1 across:1023996k SSFS
[    4.992774] btrfs: device label rhel_turner11 devid 1 transid 7781 /dev/sda3
[    5.014544] btrfs: device label rhel_turner11 devid 1 transid 7781 /dev/sda3
[    5.015285] btrfs: device label rhel_turner11 devid 1 transid 7781 /dev/sda3
[    5.018209] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    5.087940] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
[    5.110876] alg: No test for crc32 (crc32-pclmul)
[    5.146100] e1000 0000:00:05.0 eth0: (PCI:33MHz:32-bit) 00:1c:42:65:72:09
[    5.146109] e1000 0000:00:05.0 eth0: Intel(R) PRO/1000 Network Connection
[    5.146377] intel8x0: enable Parallels VM optimization
[    5.180225] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    5.186032] systemd-udevd[357]: renamed network interface eth0 to enp0s5
[    5.191946] XFS (sda1): Mounting Filesystem
[    5.217496] XFS (sda1): Ending clean mount
[    5.217514] SELinux: initialized (dev sda1, type xfs), uses xattr
[    5.256646] systemd-journald[340]: Received request to flush runtime journal from PID 1
[    5.317024] type=1305 audit(1414770272.990:4): audit_pid=445 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[    6.179271] sr 0:0:1:0: Attached scsi generic sg0 type 5
[    6.183346] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    6.796052] intel8x0_measure_ac97_clock: measured 51581 usecs (2552 samples)
[    6.796056] intel8x0: clocking to 46568
[    7.137729] ip_tables: (C) 2000-2006 Netfilter Core Team
[    7.295734] nf_conntrack version 0.5.0 (7926 buckets, 31704 max)
[    7.366458] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    7.503104] Ebtables v2.0 registered
[    7.520746] Bridge firewalling registered
[    8.281224] IPv6: ADDRCONF(NETDEV_UP): enp0s5: link is not ready
[    8.298027] e1000: enp0s5 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[    8.298333] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s5: link becomes ready
[   16.704653] Adjusting tsc more than 11% (7472431 vs 7456842)
[  430.556243] Ebtables v2.0 unregistered

--Apple-Mail=_2B1B42C4-CAF0-435F-A5B9-B9028934806B
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii




--Apple-Mail=_2B1B42C4-CAF0-435F-A5B9-B9028934806B--
