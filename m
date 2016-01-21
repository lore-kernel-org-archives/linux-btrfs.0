Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from c.mail.sonic.net ([64.142.111.80]:41485 "EHLO c.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbcAUTja (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 14:39:30 -0500
To: linux-btrfs@vger.kernel.org
From: Konstantin Svist <fry.kun@gmail.com>
Subject: "Some devices missing" only while not mounted
Message-ID: <56A13176.2050502@gmail.com>
Date: Thu, 21 Jan 2016 11:28:54 -0800
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070709040102070100050503"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070709040102070100050503
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

I have a btrfs raid10 with 4 drives on Fedora 23 x64.
Currently, the array is mountable (non-degraded) and all the content
appears accessible without any errors -- except that "btrfs dev ready"
returns 1 and "btrfs fi show -d" says "*** Some devices missing".

Originally:

1 of the drives failed (/dev/sdb; command timeouts, link reset
messages), causing a kernel panic by btrfs getting really confused.
After reboot, I got "parent transid verify failed" while trying to mount.

Booted into USB stick (fedora 23 lxde live), found /dev/sdb2 by SMART
errors, saw that I can mount degraded (without /dev/sdb2) without any
errors.
Replaced the bad drive with a new one, ran "btrfs dev add", "btrfs del
missing" using btrfs-progs v4.2.2 -- this returned an error saying no
"missing" device or something.
Upgraded to btrfs-progs 4.3.1, this time it went fine.
Reboot to main system got stuck on systemd waiting for btrfs device.

After some back and forth, I found that "ready" returns an error and "fi
show" is inconsistent.
/dev/sda2 was showing up as dev id 5 (2 missing)

Tried removing /dev/sdb2 again and "btrfs replace"ing the now-missing
/dev/sdb2 with the fresh instance of /dev/sdb2.
Now /dev/sdb2 shows up as device 6 (2 and 5 not listed).
"fi show" on mounted /dev/sda2 looks normal; on unmounted /dev/sda2
shows "Total devices 5" and "Some devices missing"


# uname -a
Linux slon 4.2.3-300.fc23.x86_64 #1 SMP Mon Oct 5 15:42:54 UTC 2015
x86_64 x86_64 x86_64 GNU/Linux

# btrfs fi df /mnt
Data, RAID10: total=1.29TiB, used=1.29TiB
System, RAID10: total=64.00MiB, used=160.00KiB
Metadata, RAID10: total=4.00GiB, used=3.12GiB
GlobalReserve, single: total=512.00MiB, used=0.00B




--------------070709040102070100050503
Content-Type: text/x-log;
 name="show.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="show.log"

[root@myhost ~]# btrfs fi show -d
Label: none  uuid: 48f0e952-a176-481e-a184-6ee51acf54b1
        Total devices 5 FS bytes used 1.29TiB
        devid    1 size 931.51GiB used 664.03GiB path /dev/sda2
        devid    3 size 931.51GiB used 664.03GiB path /dev/sdc2
        devid    4 size 931.51GiB used 664.03GiB path /dev/sdd2
        devid    6 size 931.51GiB used 664.03GiB path /dev/sdb2
        *** Some devices missing

btrfs-progs v4.2.2
[root@myhost ~]# mount /dev/sda2 /mnt/
[root@myhost ~]# btrfs fi show
Label: none  uuid: 48f0e952-a176-481e-a184-6ee51acf54b1
        Total devices 4 FS bytes used 1.29TiB
        devid    1 size 931.51GiB used 664.03GiB path /dev/sda2
        devid    3 size 931.51GiB used 664.03GiB path /dev/sdc2
        devid    4 size 931.51GiB used 664.03GiB path /dev/sdd2
        devid    6 size 931.51GiB used 664.03GiB path /dev/sdb2

btrfs-progs v4.2.2
[root@myhost ~]# btrfs fi show -d
Label: none  uuid: 48f0e952-a176-481e-a184-6ee51acf54b1
        Total devices 5 FS bytes used 1.29TiB
        devid    1 size 931.51GiB used 664.03GiB path /dev/sda2
        devid    3 size 931.51GiB used 664.03GiB path /dev/sdc2
        devid    4 size 931.51GiB used 664.03GiB path /dev/sdd2
        devid    6 size 931.51GiB used 664.03GiB path /dev/sdb2
        *** Some devices missing

btrfs-progs v4.2.2
[root@myhost ~]# umount /dev/sda2 /mnt/


******
# dnf udpate '*btrfs*
...
******

[root@myhost ~]# btrfs --version
btrfs-progs v4.3.1
[root@myhost ~]# btrfs fi show -d
Label: none  uuid: 48f0e952-a176-481e-a184-6ee51acf54b1
        Total devices 5 FS bytes used 1.29TiB
        devid    1 size 931.51GiB used 664.03GiB path /dev/sda2
        devid    3 size 931.51GiB used 664.03GiB path /dev/sdc2
        devid    4 size 931.51GiB used 664.03GiB path /dev/sdd2
        devid    6 size 931.51GiB used 664.03GiB path /dev/sdb2
        *** Some devices missing

[root@myhost ~]# mount /dev/sda2 /mnt/
[root@myhost ~]# btrfs fi show
Label: none  uuid: 48f0e952-a176-481e-a184-6ee51acf54b1
        Total devices 4 FS bytes used 1.29TiB
        devid    1 size 931.51GiB used 664.03GiB path /dev/sda2
        devid    3 size 931.51GiB used 664.03GiB path /dev/sdc2
        devid    4 size 931.51GiB used 664.03GiB path /dev/sdd2
        devid    6 size 931.51GiB used 664.03GiB path /dev/sdb2

[root@myhost ~]# btrfs fi show -d
Label: none  uuid: 48f0e952-a176-481e-a184-6ee51acf54b1
        Total devices 5 FS bytes used 1.29TiB
        devid    1 size 931.51GiB used 664.03GiB path /dev/sda2
        devid    3 size 931.51GiB used 664.03GiB path /dev/sdc2
        devid    4 size 931.51GiB used 664.03GiB path /dev/sdd2
        devid    6 size 931.51GiB used 664.03GiB path /dev/sdb2
        *** Some devices missing


--------------070709040102070100050503
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.2.3-300.fc23.x86_64 (mockbuild@bkernel02.phx2.fedoraproject.org) (gcc version 5.1.1 20150618 (Red Hat 5.1.1-4) (GCC) ) #1 SMP Mon Oct 5 15:42:54 UTC 2015
[    0.000000] Command line: BOOT_IMAGE=vmlinuz0 initrd=initrd0.img root=UUID=F334-EFE6 rootfstype=auto ro rd.live.image rd.live.dir=/multibootusb/Fedora-Live-LXDE-x86_64-23-10/LiveOS quiet  rhgb rd.luks=0 rd.md=0 rd.dm=0 nomodeset
[    0.000000] tseg: 0000000000
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'lazy' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffeffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bfff0000-0x00000000bfffdfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bfffe000-0x00000000bfffffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec02fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000103fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: empty empty/Tyan Transport GT24-B3992-E, BIOS 'V1.06.B10 ' 06/23/2009
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x1040000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000001040000000 aka 66560M
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbfff0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02042000, 0x02042fff] PGTABLE
[    0.000000] BRK [0x02043000, 0x02043fff] PGTABLE
[    0.000000] BRK [0x02044000, 0x02044fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x103fe00000-0x103fffffff]
[    0.000000]  [mem 0x103fe00000-0x103fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1020000000-0x103fdfffff]
[    0.000000]  [mem 0x1020000000-0x103fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbffeffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbfdfffff] page 2M
[    0.000000]  [mem 0xbfe00000-0xbffeffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x101fffffff]
[    0.000000]  [mem 0x100000000-0x101fffffff] page 1G
[    0.000000] RAMDISK: [mem 0x7d041000-0x7fffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F8F90 000024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 0x00000000BFFF0100 000054 (v01 062309 XSDT1333 20090623 MSFT 00000097)
[    0.000000] ACPI: FACP 0x00000000BFFF0290 0000F4 (v03 062309 FACP1333 20090623 MSFT 00000097)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe1Block: 96/64 (20150619/tbfadt-623)
[    0.000000] ACPI: DSDT 0x00000000BFFF04E0 00370B (v01 0AAAB  0AAAB001 00000001 INTL 02002026)
[    0.000000] ACPI: FACS 0x00000000BFFFE000 000040
[    0.000000] ACPI: FACS 0x00000000BFFFE000 000040
[    0.000000] ACPI: APIC 0x00000000BFFF0390 000102 (v01 062309 APIC1333 20090623 MSFT 00000097)
[    0.000000] ACPI: MCFG 0x00000000BFFF04A0 00003C (v01 062309 OEMMCFG  20090623 MSFT 00000097)
[    0.000000] ACPI: OEMB 0x00000000BFFFE040 000056 (v01 062309 OEMB1333 20090623 MSFT 00000097)
[    0.000000] ACPI: SRAT 0x00000000BFFF3BF0 000190 (v01 AMD    FAM_F_10 00000002 AMD  00000001)
[    0.000000] ACPI: SSDT 0x00000000BFFF3D80 001E48 (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x08 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x09 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0c -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x0d -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x83fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x840000000-0x103fffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xbfffffff] -> [mem 0x00000000-0xbfffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x83fffffff] -> [mem 0x00000000-0x83fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x83ffec000-0x83fffffff]
[    0.000000] NODE_DATA(1) allocated [mem 0x103ffea000-0x103fffdfff]
[    0.000000]  [ffffea0000000000-ffffea0020ffffff] PMD -> [ffff88081fe00000-ffff88083fdfffff] on node 0
[    0.000000]  [ffffea0021000000-ffffea0040ffffff] PMD -> [ffff88101f600000-ffff88103f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000103fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000bffeffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000083fffffff]
[    0.000000]   node   1: [mem 0x0000000840000000-0x000000103fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000083fffffff]
[    0.000000] On node 0 totalpages: 8388494
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12224 pages used for memmap
[    0.000000]   DMA32 zone: 782320 pages, LIFO batch:31
[    0.000000]   Normal zone: 118784 pages used for memmap
[    0.000000]   Normal zone: 7602176 pages, LIFO batch:31
[    0.000000] Initmem setup node 1 [mem 0x0000000840000000-0x000000103fffffff]
[    0.000000] On node 1 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x508
[    0.000000] ACPI: Local APIC address 0xfee00000
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
[    0.000000] IOAPIC[0]: apic_id 6, version 17, address 0xfec00000, GSI 0-15
[    0.000000] IOAPIC[1]: apic_id 7, version 17, address 0xfec01000, GSI 16-31
[    0.000000] IOAPIC[2]: apic_id 14, version 17, address 0xfec02000, GSI 32-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 12 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfff0000-0xbfffdfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfffe000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec02fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec03000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffffffff]
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:1024 nr_cpumask_bits:12 nr_cpu_ids:12 nr_node_ids:2
[    0.000000] PERCPU: Embedded 33 pages/cpu @ffff88081fc00000 s97048 r8192 d29928 u262144
[    0.000000] pcpu-alloc: s97048 r8192 d29928 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 -- -- [1] 06 07 08 09 10 11 -- -- 
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 16514937
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=vmlinuz0 initrd=initrd0.img root=UUID=F334-EFE6 rootfstype=auto ro rd.live.image rd.live.dir=/multibootusb/Fedora-Live-LXDE-x86_64-23-10/LiveOS quiet  rhgb rd.luks=0 rd.md=0 rd.dm=0 nomodeset
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 65926012K/67108408K available (7670K kernel code, 1264K rwdata, 3336K rodata, 1508K init, 1544K bss, 1182396K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=12, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=1024 to nr_cpu_ids=12.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=12
[    0.000000] NR_IRQS:65792 nr_irqs:928 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-11.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: PIT calibration matches PMTIMER. 1 loops
[    0.000000] tsc: Detected 2194.633 MHz processor
[    0.000030] Calibrating delay loop (skipped), value calculated using timer frequency.. 4389.26 BogoMIPS (lpj=2194633)
[    0.000033] pid_max: default: 32768 minimum: 301
[    0.000043] ACPI: Core revision 20150619
[    0.003320] ACPI: All ACPI Tables successfully acquired
[    0.003361] Security Framework initialized
[    0.003365] SELinux:  Initializing.
[    0.003373] SELinux:  Starting in permissive mode
[    0.003374] Yama: becoming mindful.
[    0.008976] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.035092] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.046312] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.046412] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.047394] Initializing cgroup subsys blkio
[    0.047399] Initializing cgroup subsys memory
[    0.047415] Initializing cgroup subsys devices
[    0.047418] Initializing cgroup subsys freezer
[    0.047422] Initializing cgroup subsys net_cls
[    0.047425] Initializing cgroup subsys perf_event
[    0.047428] Initializing cgroup subsys net_prio
[    0.047431] Initializing cgroup subsys hugetlb
[    0.047461] CPU: Physical Processor ID: 0
[    0.047462] CPU: Processor Core ID: 0
[    0.047464] mce: CPU supports 6 MCE banks
[    0.047470] LVT offset 0 assigned for vector 0xf9
[    0.047475] process: using AMD E400 aware idle routine
[    0.047478] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.047480] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
[    0.047606] Freeing SMP alternatives memory: 28K (ffffffff81eb7000 - ffffffff81ebe000)
[    0.049297] ftrace: allocating 28715 entries in 113 pages
[    0.065560] Switched APIC routing to physical flat.
[    0.066440] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.178209] smpboot: CPU0: Six-Core AMD Opteron(tm) Processor 2427 (fam: 10, model: 08, stepping: 00)
[    0.178238] Performance Events: AMD PMU driver.
[    0.178243] ... version:                0
[    0.178244] ... bit width:              48
[    0.178245] ... generic registers:      4
[    0.178246] ... value mask:             0000ffffffffffff
[    0.178248] ... max period:             00007fffffffffff
[    0.178249] ... fixed-purpose events:   0
[    0.178250] ... event mask:             000000000000000f
[    0.179131] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.179272] x86: Booting SMP configuration:
[    0.179274] .... node  #0, CPUs:        #1  #2  #3  #4  #5
[    0.195567] .... node  #1, CPUs:    #6  #7  #8  #9 #10 #11
[    0.292732] x86: Booted up 2 nodes, 12 CPUs
[    0.292742] smpboot: Total of 12 processors activated (52665.69 BogoMIPS)
[    0.307869] devtmpfs: initialized
[    0.307969] memory block size : 1024MB
[    0.312786] PM: Registering ACPI NVS region [mem 0xbfffe000-0xbfffffff] (8192 bytes)
[    0.312942] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.313098] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.313100] pinctrl core: initialized pinctrl subsystem
[    0.313160] RTC time: 19:00:57, date: 01/21/16
[    0.315154] NET: Registered protocol family 16
[    0.317469] cpuidle: using governor menu
[    0.317481] node 0 link 0: io port [1000, ffffff]
[    0.317484] TOM: 00000000c0000000 aka 3072M
[    0.317491] Fam 10h mmconf [mem 0xe0000000-0xefffffff]
[    0.317504] node 0 link 0: mmio [a0000, bffff]
[    0.317508] node 0 link 0: mmio [c0000000, ff70ffff] ==> [c0000000, dfffffff] and [f0000000, ff70ffff]
[    0.317511] TOM2: 0000001040000000 aka 66560M
[    0.317513] bus: [bus 00-07] on node 0 link 0
[    0.317515] bus: 00 [io  0x0000-0xffff]
[    0.317517] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.317519] bus: 00 [mem 0xc0000000-0xdfffffff]
[    0.317520] bus: 00 [mem 0xf0000000-0xffffffff]
[    0.317521] bus: 00 [mem 0x1040000000-0xfcffffffff]
[    0.317752] ACPI: bus type PCI registered
[    0.317755] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.317857] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.317860] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.317877] PCI: Using configuration type 1 for base access
[    0.322530] ACPI: Added _OSI(Module Device)
[    0.322533] ACPI: Added _OSI(Processor Device)
[    0.322535] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.322536] ACPI: Added _OSI(Processor Aggregator Device)
[    0.324190] ACPI: Executed 1 blocks of module-level executable AML code
[    0.326763] ACPI: Interpreter enabled
[    0.326775] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20150619/hwxface-580)
[    0.326779] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20150619/hwxface-580)
[    0.326790] ACPI: (supports S0 S1 S4 S5)
[    0.326792] ACPI: Using IOAPIC for interrupt routing
[    0.326832] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.333521] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.333529] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.333534] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.333709] PCI host bridge to bus 0000:00
[    0.333716] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.333719] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.333722] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.333725] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.333727] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff window]
[    0.333729] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff window]
[    0.333742] pci 0000:00:01.0: [1166:0036] type 01 class 0x060400
[    0.333790] pci 0000:00:01.0: Enabling HT MSI Mapping
[    0.333837] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.333884] pci 0000:00:02.0: [1166:0205] type 00 class 0x060000
[    0.333985] pci 0000:00:02.1: [1166:0214] type 00 class 0x01018a
[    0.334000] pci 0000:00:02.1: reg 0x10: [io  0x01f0-0x01f7]
[    0.334009] pci 0000:00:02.1: reg 0x14: [io  0x03f4-0x03f7]
[    0.334019] pci 0000:00:02.1: reg 0x18: [io  0x0170-0x0177]
[    0.334028] pci 0000:00:02.1: reg 0x1c: [io  0x0374-0x0377]
[    0.334037] pci 0000:00:02.1: reg 0x20: [io  0xffa0-0xffaf]
[    0.334056] pci 0000:00:02.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.334058] pci 0000:00:02.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.334060] pci 0000:00:02.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.334062] pci 0000:00:02.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.334120] pci 0000:00:02.2: [1166:0234] type 00 class 0x060100
[    0.334260] pci 0000:00:03.0: [1166:0223] type 00 class 0x0c0310
[    0.334283] pci 0000:00:03.0: reg 0x10: [mem 0xff6ec000-0xff6ecfff]
[    0.334293] pci 0000:00:03.0: reg 0x14: [io  0xd400-0xd4ff]
[    0.334382] pci 0000:00:03.0: System wakeup disabled by ACPI
[    0.334427] pci 0000:00:03.1: [1166:0223] type 00 class 0x0c0310
[    0.334450] pci 0000:00:03.1: reg 0x10: [mem 0xff6ed000-0xff6edfff]
[    0.334460] pci 0000:00:03.1: reg 0x14: [io  0xd800-0xd8ff]
[    0.334541] pci 0000:00:03.1: System wakeup disabled by ACPI
[    0.334586] pci 0000:00:03.2: [1166:0223] type 00 class 0x0c0320
[    0.334609] pci 0000:00:03.2: reg 0x10: [mem 0xff6ee000-0xff6eefff]
[    0.334618] pci 0000:00:03.2: reg 0x14: [io  0xe800-0xe8ff]
[    0.334674] pci 0000:00:03.2: supports D1 D2
[    0.334677] pci 0000:00:03.2: PME# supported from D0 D1 D2 D3hot
[    0.334706] pci 0000:00:03.2: System wakeup disabled by ACPI
[    0.334768] pci 0000:00:04.0: [8086:1229] type 00 class 0x020000
[    0.334790] pci 0000:00:04.0: reg 0x10: [mem 0xff6eb000-0xff6ebfff]
[    0.334799] pci 0000:00:04.0: reg 0x14: [io  0xec00-0xec3f]
[    0.334808] pci 0000:00:04.0: reg 0x18: [mem 0xff6a0000-0xff6bffff]
[    0.334854] pci 0000:00:04.0: supports D1 D2
[    0.334856] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.334884] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.334926] pci 0000:00:06.0: [1166:0130] type 01 class 0x060400
[    0.334979] pci 0000:00:06.0: System wakeup disabled by ACPI
[    0.335021] pci 0000:00:07.0: [1166:0130] type 01 class 0x060400
[    0.335070] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.335110] pci 0000:00:08.0: [1166:0132] type 01 class 0x060400
[    0.335158] pci 0000:00:08.0: System wakeup disabled by ACPI
[    0.335204] pci 0000:00:09.0: [1166:0132] type 01 class 0x060400
[    0.335252] pci 0000:00:09.0: System wakeup disabled by ACPI
[    0.335299] pci 0000:00:0a.0: [1166:0132] type 01 class 0x060400
[    0.335350] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    0.335392] pci 0000:00:0b.0: [1166:0132] type 01 class 0x060400
[    0.335477] pci 0000:00:0c.0: [1002:515e] type 00 class 0x030000
[    0.335501] pci 0000:00:0c.0: reg 0x10: [mem 0xd8000000-0xdfffffff pref]
[    0.335516] pci 0000:00:0c.0: reg 0x14: [io  0xe000-0xe0ff]
[    0.335526] pci 0000:00:0c.0: reg 0x18: [mem 0xff6f0000-0xff6fffff]
[    0.335559] pci 0000:00:0c.0: reg 0x30: [mem 0xff6c0000-0xff6dffff pref]
[    0.335577] pci 0000:00:0c.0: supports D1 D2
[    0.335643] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    0.335705] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    0.335769] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    0.335827] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    0.335889] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    0.335949] pci 0000:00:19.0: [1022:1200] type 00 class 0x060000
[    0.336021] pci 0000:00:19.1: [1022:1201] type 00 class 0x060000
[    0.336081] pci 0000:00:19.2: [1022:1202] type 00 class 0x060000
[    0.336140] pci 0000:00:19.3: [1022:1203] type 00 class 0x060000
[    0.336204] pci 0000:00:19.4: [1022:1204] type 00 class 0x060000
[    0.336336] pci 0000:01:0d.0: [1166:0104] type 01 class 0x060400
[    0.336419] pci 0000:01:0e.0: [1166:024a] type 00 class 0x010405
[    0.336439] pci 0000:01:0e.0: reg 0x10: [io  0xac00-0xac07]
[    0.336446] pci 0000:01:0e.0: reg 0x14: [io  0xa880-0xa883]
[    0.336452] pci 0000:01:0e.0: reg 0x18: [io  0xa800-0xa807]
[    0.336459] pci 0000:01:0e.0: reg 0x1c: [io  0xa480-0xa483]
[    0.336465] pci 0000:01:0e.0: reg 0x20: [io  0xa400-0xa41f]
[    0.336472] pci 0000:01:0e.0: reg 0x24: [mem 0xff2fe000-0xff2fffff]
[    0.336479] pci 0000:01:0e.0: reg 0x30: [mem 0xff2c0000-0xff2dffff pref]
[    0.336554] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.336559] pci 0000:00:01.0:   bridge window [io  0x9000-0xafff]
[    0.336562] pci 0000:00:01.0:   bridge window [mem 0xff200000-0xff2fffff]
[    0.336638] pci 0000:01:0d.0: PCI bridge to [bus 02]
[    0.336716] pci 0000:00:06.0: PCI bridge to [bus 03]
[    0.336769] pci 0000:04:04.0: [14e4:166a] type 00 class 0x020000
[    0.336788] pci 0000:04:04.0: reg 0x10: [mem 0xff3d0000-0xff3dffff 64bit]
[    0.336796] pci 0000:04:04.0: reg 0x18: [mem 0xff3c0000-0xff3cffff 64bit]
[    0.336821] pci 0000:04:04.0: PME# supported from D3hot D3cold
[    0.336837] pci 0000:04:04.0: System wakeup disabled by ACPI
[    0.336881] pci 0000:04:04.1: [14e4:166a] type 00 class 0x020000
[    0.336899] pci 0000:04:04.1: reg 0x10: [mem 0xff3f0000-0xff3fffff 64bit]
[    0.336907] pci 0000:04:04.1: reg 0x18: [mem 0xff3e0000-0xff3effff 64bit]
[    0.336932] pci 0000:04:04.1: PME# supported from D3hot D3cold
[    0.336949] pci 0000:04:04.1: System wakeup disabled by ACPI
[    0.337009] pci 0000:00:07.0: PCI bridge to [bus 04]
[    0.337014] pci 0000:00:07.0:   bridge window [mem 0xff300000-0xff3fffff]
[    0.337018] pci 0000:00:07.0:   bridge window [mem 0xcfd00000-0xcfdfffff 64bit pref]
[    0.337069] pci 0000:05:00.0: [1095:3132] type 00 class 0x010400
[    0.337125] pci 0000:05:00.0: reg 0x10: [mem 0xff5ffc00-0xff5ffc7f 64bit]
[    0.337150] pci 0000:05:00.0: reg 0x18: [mem 0xff5f8000-0xff5fbfff 64bit]
[    0.337167] pci 0000:05:00.0: reg 0x20: [io  0xbc00-0xbc7f]
[    0.337198] pci 0000:05:00.0: reg 0x30: [mem 0xff500000-0xff57ffff pref]
[    0.337238] pci 0000:05:00.0: supports D1 D2
[    0.337283] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.337293] pci 0000:00:08.0: PCI bridge to [bus 05]
[    0.337297] pci 0000:00:08.0:   bridge window [io  0xb000-0xbfff]
[    0.337300] pci 0000:00:08.0:   bridge window [mem 0xff400000-0xff5fffff]
[    0.337304] pci 0000:00:08.0:   bridge window [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.337338] pci 0000:00:09.0: PCI bridge to [bus 06]
[    0.337373] pci 0000:00:0a.0: PCI bridge to [bus 07]
[    0.337405] pci 0000:00:0b.0: PCI bridge to [bus 08]
[    0.337429] pci_bus 0000:00: on NUMA node 0
[    0.337946] ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 *9 11 12 14 15)
[    0.337996] ACPI: PCI Interrupt Link [LN01] (IRQs 1 3 4 5 6 7 9 *11 12 14 15)
[    0.338046] ACPI: PCI Interrupt Link [LN02] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338095] ACPI: PCI Interrupt Link [LN03] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338144] ACPI: PCI Interrupt Link [LN04] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338193] ACPI: PCI Interrupt Link [LN05] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338242] ACPI: PCI Interrupt Link [LN06] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338291] ACPI: PCI Interrupt Link [LN07] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338344] ACPI: PCI Interrupt Link [LN08] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338393] ACPI: PCI Interrupt Link [LN09] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338442] ACPI: PCI Interrupt Link [LN10] (IRQs 1 *3 4 5 6 7 9 11 12 14 15)
[    0.338490] ACPI: PCI Interrupt Link [LN11] (IRQs 1 3 4 *5 6 7 9 11 12 14 15)
[    0.338539] ACPI: PCI Interrupt Link [LN12] (IRQs 1 3 4 5 6 *7 9 11 12 14 15)
[    0.338587] ACPI: PCI Interrupt Link [LN13] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338636] ACPI: PCI Interrupt Link [LN14] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338685] ACPI: PCI Interrupt Link [LN15] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338734] ACPI: PCI Interrupt Link [LN16] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338783] ACPI: PCI Interrupt Link [LN17] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338832] ACPI: PCI Interrupt Link [LN18] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338881] ACPI: PCI Interrupt Link [LN19] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338930] ACPI: PCI Interrupt Link [LN20] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.338979] ACPI: PCI Interrupt Link [LN21] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.339032] ACPI: PCI Interrupt Link [LN22] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.339081] ACPI: PCI Interrupt Link [LN23] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.339130] ACPI: PCI Interrupt Link [LN24] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.339179] ACPI: PCI Interrupt Link [LN25] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.339228] ACPI: PCI Interrupt Link [LN26] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.339279] ACPI: PCI Interrupt Link [LN27] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.339332] ACPI: PCI Interrupt Link [LN28] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.339381] ACPI: PCI Interrupt Link [LN29] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.339431] ACPI: PCI Interrupt Link [LN30] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.339490] ACPI: PCI Interrupt Link [LNUS] (IRQs *10)
[    0.339541] ACPI: PCI Interrupt Link [LNSA] (IRQs *11)
[    0.339790] vgaarb: setting as boot device: PCI:0000:00:0c.0
[    0.339792] vgaarb: device added: PCI:0000:00:0c.0,decodes=io+mem,owns=io+mem,locks=none
[    0.339796] vgaarb: loaded
[    0.339798] vgaarb: bridge control possible 0000:00:0c.0
[    0.339908] SCSI subsystem initialized
[    0.340037] libata version 3.00 loaded.
[    0.340072] ACPI: bus type USB registered
[    0.340092] usbcore: registered new interface driver usbfs
[    0.340106] usbcore: registered new interface driver hub
[    0.340155] usbcore: registered new device driver usb
[    0.340348] PCI: Using ACPI for IRQ routing
[    0.348980] PCI: pci_cache_line_size set to 64 bytes
[    0.349034] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    0.349036] e820: reserve RAM buffer [mem 0xbfff0000-0xbfffffff]
[    0.349181] NetLabel: Initializing
[    0.349183] NetLabel:  domain hash size = 128
[    0.349184] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.349198] NetLabel:  unlabeled traffic allowed by default
[    0.349432] clocksource: Switched to clocksource refined-jiffies
[    0.360534] pnp: PnP ACPI init
[    0.360654] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.361162] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.361166] system 00:01: [io  0x0a80-0x0a8f] has been reserved
[    0.361170] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.361294] system 00:02: [io  0x04d0-0x04d1] has been reserved
[    0.361296] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.361299] system 00:02: [io  0x0cd6-0x0cd7] has been reserved
[    0.361301] system 00:02: [io  0x0cd4-0x0cd5] has been reserved
[    0.361303] system 00:02: [io  0x0cd8-0x0cdf] has been reserved
[    0.361305] system 00:02: [io  0x040b] has been reserved
[    0.361308] system 00:02: [io  0x04d6] has been reserved
[    0.361310] system 00:02: [io  0x0c06-0x0c07] has been reserved
[    0.361312] system 00:02: [io  0x0c14] has been reserved
[    0.361314] system 00:02: [io  0x0c49] has been reserved
[    0.361316] system 00:02: [io  0x0c4a] has been reserved
[    0.361319] system 00:02: [io  0x0c50-0x0c51] has been reserved
[    0.361321] system 00:02: [io  0x0c52] has been reserved
[    0.361323] system 00:02: [io  0x0c6c] has been reserved
[    0.361325] system 00:02: [io  0x0c6f] has been reserved
[    0.361332] system 00:02: [io  0x0500-0x057f] could not be reserved
[    0.361335] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.361471] system 00:03: [io  0x0580-0x058f] has been reserved
[    0.361474] system 00:03: [io  0x0590-0x0593] has been reserved
[    0.361476] system 00:03: [io  0x0700-0x0703] has been reserved
[    0.361478] system 00:03: [io  0x0ca0-0x0caf] has been reserved
[    0.361482] system 00:03: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.361485] system 00:03: [mem 0xfec01000-0xfec01fff] could not be reserved
[    0.361487] system 00:03: [mem 0xfec02000-0xfec02fff] could not be reserved
[    0.361490] system 00:03: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.361492] system 00:03: [mem 0xfff00000-0xffffffff] has been reserved
[    0.361495] system 00:03: [mem 0xff780000-0xffbfffff] has been reserved
[    0.361497] system 00:03: [mem 0xfebfe000-0xfebfefff] has been reserved
[    0.361500] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.361562] system 00:04: [mem 0xe0000000-0xefffffff] has been reserved
[    0.361565] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.361676] system 00:05: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.361679] system 00:05: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.361681] system 00:05: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.361684] system 00:05: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.362148] pnp: PnP ACPI: found 6 devices
[    0.369200] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.369292] clocksource: Switched to clocksource acpi_pm
[    0.369356] pci 0000:01:0d.0: PCI bridge to [bus 02]
[    0.369367] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.369370] pci 0000:00:01.0:   bridge window [io  0x9000-0xafff]
[    0.369374] pci 0000:00:01.0:   bridge window [mem 0xff200000-0xff2fffff]
[    0.369380] pci 0000:00:06.0: PCI bridge to [bus 03]
[    0.369387] pci 0000:00:07.0: PCI bridge to [bus 04]
[    0.369391] pci 0000:00:07.0:   bridge window [mem 0xff300000-0xff3fffff]
[    0.369394] pci 0000:00:07.0:   bridge window [mem 0xcfd00000-0xcfdfffff 64bit pref]
[    0.369399] pci 0000:00:08.0: PCI bridge to [bus 05]
[    0.369402] pci 0000:00:08.0:   bridge window [io  0xb000-0xbfff]
[    0.369405] pci 0000:00:08.0:   bridge window [mem 0xff400000-0xff5fffff]
[    0.369408] pci 0000:00:08.0:   bridge window [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.369412] pci 0000:00:09.0: PCI bridge to [bus 06]
[    0.369418] pci 0000:00:0a.0: PCI bridge to [bus 07]
[    0.369425] pci 0000:00:0b.0: PCI bridge to [bus 08]
[    0.369432] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.369435] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.369437] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.369439] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff window]
[    0.369442] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xffffffff window]
[    0.369444] pci_bus 0000:01: resource 0 [io  0x9000-0xafff]
[    0.369446] pci_bus 0000:01: resource 1 [mem 0xff200000-0xff2fffff]
[    0.369449] pci_bus 0000:04: resource 1 [mem 0xff300000-0xff3fffff]
[    0.369452] pci_bus 0000:04: resource 2 [mem 0xcfd00000-0xcfdfffff 64bit pref]
[    0.369454] pci_bus 0000:05: resource 0 [io  0xb000-0xbfff]
[    0.369456] pci_bus 0000:05: resource 1 [mem 0xff400000-0xff5fffff]
[    0.369458] pci_bus 0000:05: resource 2 [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.369533] NET: Registered protocol family 2
[    0.370245] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.371841] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.372212] TCP: Hash tables configured (established 524288 bind 65536)
[    0.372373] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    0.374419] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    0.375006] NET: Registered protocol family 1
[    0.375096] pci 0000:00:02.0: disabled boot interrupts on device [1166:0205]
[    1.508377] pci 0000:00:04.0: Firmware left e100 interrupts enabled; disabling
[    1.508392] pci 0000:00:08.0: Found enabled HT MSI Mapping
[    1.508398] pci 0000:00:09.0: Found enabled HT MSI Mapping
[    1.508405] pci 0000:00:0a.0: Found enabled HT MSI Mapping
[    1.508411] pci 0000:00:0b.0: Found enabled HT MSI Mapping
[    1.508418] pci 0000:00:0c.0: Video device with shadowed ROM
[    1.508454] PCI: CLS 64 bytes, default 64
[    1.508573] Unpacking initramfs...
[    2.309498] microcode: updated early to new patch_level=0x010000da
[    2.332384] Freeing initrd memory: 48892K (ffff88007d041000 - ffff880080000000)
[    2.332400] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.332403] software IO TLB [mem 0xbbff0000-0xbfff0000] (64MB) mapped at [ffff8800bbff0000-ffff8800bffeffff]
[    2.332656] microcode: CPU0: patch_level=0x010000da
[    2.332678] microcode: CPU1: patch_level=0x010000da
[    2.332699] microcode: CPU2: patch_level=0x010000da
[    2.332720] microcode: CPU3: patch_level=0x010000da
[    2.332741] microcode: CPU4: patch_level=0x010000da
[    2.332763] microcode: CPU5: patch_level=0x010000da
[    2.332794] microcode: CPU6: patch_level=0x010000da
[    2.332828] microcode: CPU7: patch_level=0x010000da
[    2.332863] microcode: CPU8: patch_level=0x010000da
[    2.332900] microcode: CPU9: patch_level=0x010000da
[    2.332936] microcode: CPU10: patch_level=0x010000da
[    2.332950] microcode: CPU11: patch_level=0x010000da
[    2.333103] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.333109] LVT offset 1 assigned for vector 0x400
[    2.333122] IBS: LVT offset 1 assigned
[    2.333165] perf: AMD IBS detected (0x0000001f)
[    2.334983] futex hash table entries: 4096 (order: 6, 262144 bytes)
[    2.335107] Initialise system trusted keyring
[    2.335148] audit: initializing netlink subsys (disabled)
[    2.335179] audit: type=2000 audit(1453402859.186:1): initialized
[    2.335686] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.337606] zpool: loaded
[    2.337609] zbud: loaded
[    2.337922] VFS: Disk quotas dquot_6.6.0
[    2.337971] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.338591] Key type big_key registered
[    2.338595] SELinux:  Registering netfilter hooks
[    2.347525] NET: Registered protocol family 38
[    2.347542] Key type asymmetric registered
[    2.347546] Asymmetric key parser 'x509' registered
[    2.347595] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    2.347752] io scheduler noop registered
[    2.347756] io scheduler deadline registered
[    2.347809] io scheduler cfq registered (default)
[    2.348309] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.348317] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.348459] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.348465] ACPI: Power Button [PWRB]
[    2.348521] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.348523] ACPI: Power Button [PWRF]
[    2.348584] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input2
[    2.348586] ACPI: Sleep Button [SLPF]
[    2.349163] GHES: HEST is not enabled!
[    2.349291] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.349915] hpet_acpi_add: no address or irqs in _CRS
[    2.349968] Non-volatile memory driver v1.3
[    2.350008] Linux agpgart interface v0.103
[    2.352073] libphy: Fixed MDIO Bus: probed
[    2.352193] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.352199] ehci-pci: EHCI PCI platform driver
[    2.352325] ehci-pci 0000:00:03.2: EHCI Host Controller
[    2.352406] ehci-pci 0000:00:03.2: new USB bus registered, assigned bus number 1
[    2.352461] ehci-pci 0000:00:03.2: irq 10, io mem 0xff6ee000
[    2.357947] ehci-pci 0000:00:03.2: USB 2.0 started, EHCI 1.00
[    2.358000] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.358002] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.358005] usb usb1: Product: EHCI Host Controller
[    2.358007] usb usb1: Manufacturer: Linux 4.2.3-300.fc23.x86_64 ehci_hcd
[    2.358009] usb usb1: SerialNumber: 0000:00:03.2
[    2.358180] hub 1-0:1.0: USB hub found
[    2.358188] hub 1-0:1.0: 4 ports detected
[    2.358400] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.358411] ohci-pci: OHCI PCI platform driver
[    2.358486] ohci-pci 0000:00:03.0: OHCI PCI host controller
[    2.358543] ohci-pci 0000:00:03.0: new USB bus registered, assigned bus number 2
[    2.358566] ohci-pci 0000:00:03.0: irq 10, io mem 0xff6ec000
[    2.413061] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.413065] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.413067] usb usb2: Product: OHCI PCI host controller
[    2.413069] usb usb2: Manufacturer: Linux 4.2.3-300.fc23.x86_64 ohci_hcd
[    2.413070] usb usb2: SerialNumber: 0000:00:03.0
[    2.413242] hub 2-0:1.0: USB hub found
[    2.413252] hub 2-0:1.0: 2 ports detected
[    2.413434] ohci-pci 0000:00:03.1: OHCI PCI host controller
[    2.413490] ohci-pci 0000:00:03.1: new USB bus registered, assigned bus number 3
[    2.413511] ohci-pci 0000:00:03.1: irq 10, io mem 0xff6ed000
[    2.468093] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.468097] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.468099] usb usb3: Product: OHCI PCI host controller
[    2.468101] usb usb3: Manufacturer: Linux 4.2.3-300.fc23.x86_64 ohci_hcd
[    2.468102] usb usb3: SerialNumber: 0000:00:03.1
[    2.468271] hub 3-0:1.0: USB hub found
[    2.468280] hub 3-0:1.0: 2 ports detected
[    2.468410] uhci_hcd: USB Universal Host Controller Interface driver
[    2.468495] usbcore: registered new interface driver usbserial
[    2.468504] usbcore: registered new interface driver usbserial_generic
[    2.468513] usbserial: USB Serial support registered for generic
[    2.468553] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    2.470336] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.470344] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.470497] mousedev: PS/2 mouse device common for all mice
[    2.470881] rtc_cmos 00:00: RTC can wake from S4
[    2.471068] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.471097] rtc_cmos 00:00: alarms up to one month, y3k, 114 bytes nvram
[    2.471213] device-mapper: uevent: version 1.0.3
[    2.471326] device-mapper: ioctl: 4.33.0-ioctl (2015-8-18) initialised: dm-devel@redhat.com
[    2.471790] hidraw: raw HID events driver (C) Jiri Kosina
[    2.471862] usbcore: registered new interface driver usbhid
[    2.471863] usbhid: USB HID core driver
[    2.472063] drop_monitor: Initializing network drop monitor service
[    2.472159] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.472270] Initializing XFRM netlink socket
[    2.472414] NET: Registered protocol family 10
[    2.472715] mip6: Mobile IPv6
[    2.472720] NET: Registered protocol family 17
[    2.473571] Loading compiled-in X.509 certificates
[    2.474945] Loaded X.509 cert 'Fedora kernel signing key: 7f1e7775d7634112359e58508de48fd4cfce0fb6'
[    2.474962] registered taskstats version 1
[    2.474981] zswap: loading zswap
[    2.474984] zswap: using zbud pool
[    2.474993] zswap: using lzo compressor
[    2.475416]   Magic number: 0:524:41
[    2.475591] rtc_cmos 00:00: setting system clock to 2016-01-21 19:00:59 UTC (1453402859)
[    2.475649] PM: Hibernation image not present or could not be loaded.
[    2.476328] Freeing unused kernel memory: 1508K (ffffffff81d3e000 - ffffffff81eb7000)
[    2.476331] Write protecting the kernel read-only data: 12288k
[    2.476778] Freeing unused kernel memory: 512K (ffff880001780000 - ffff880001800000)
[    2.477158] Freeing unused kernel memory: 760K (ffff880001b42000 - ffff880001c00000)
[    2.480787] random: systemd urandom read with 4 bits of entropy available
[    2.481786] systemd[1]: systemd 222 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    2.482141] systemd[1]: Detected architecture x86-64.
[    2.482145] systemd[1]: Running in initial RAM disk.
[    2.482158] systemd[1]: No hostname configured.
[    2.482163] systemd[1]: Set hostname to <localhost>.
[    2.482197] systemd[1]: Initializing machine ID from random generator.
[    2.536518] systemd[1]: Reached target Timers.
[    2.536533] systemd[1]: Starting Timers.
[    2.536867] systemd[1]: Created slice -.slice.
[    2.536876] systemd[1]: Starting -.slice.
[    2.536935] systemd[1]: Listening on Journal Socket.
[    2.536946] systemd[1]: Starting Journal Socket.
[    2.537028] systemd[1]: Created slice System Slice.
[    2.537039] systemd[1]: Starting System Slice.
[    2.537648] systemd[1]: Starting Setup Virtual Console...
[    2.537675] systemd[1]: Started Device-Mapper Multipath Device Controller.
[    2.537813] systemd[1]: Started Load Kernel Modules.
[    2.538763] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    2.538803] systemd[1]: Reached target Slices.
[    2.538846] systemd[1]: Starting Slices.
[    2.538953] systemd[1]: Listening on udev Control Socket.
[    2.538967] systemd[1]: Starting udev Control Socket.
[    2.538999] systemd[1]: Reached target Encrypted Volumes.
[    2.539008] systemd[1]: Starting Encrypted Volumes.
[    2.539090] systemd[1]: Reached target Swap.
[    2.539099] systemd[1]: Starting Swap.
[    2.539120] systemd[1]: Reached target Local File Systems.
[    2.539128] systemd[1]: Starting Local File Systems.
[    2.539203] systemd[1]: Started dracut ask for additional cmdline parameters.
[    2.540131] systemd[1]: Starting dracut cmdline hook...
[    2.540220] systemd[1]: Listening on Journal Socket (/dev/log).
[    2.540242] systemd[1]: Starting Journal Socket (/dev/log).
[    2.540293] systemd[1]: Listening on udev Kernel Socket.
[    2.540304] systemd[1]: Starting udev Kernel Socket.
[    2.541169] systemd[1]: Starting Apply Kernel Variables...
[    2.541275] systemd[1]: Listening on Journal Audit Socket.
[    2.541290] systemd[1]: Starting Journal Audit Socket.
[    2.541915] systemd[1]: Starting Journal Service...
[    2.541939] systemd[1]: Reached target Sockets.
[    2.541950] systemd[1]: Starting Sockets.
[    2.542714] systemd[1]: Started Setup Virtual Console.
[    2.543267] systemd[1]: Started Create list of required static device nodes for the current kernel.
[    2.545988] systemd[1]: Started Apply Kernel Variables.
[    2.546040] audit: type=1130 audit(1453402859.569:2): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.549669] systemd[1]: Starting Create Static Device Nodes in /dev...
[    2.552951] systemd[1]: Started Create Static Device Nodes in /dev.
[    2.553012] audit: type=1130 audit(1453402859.576:3): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-tmpfiles-setup-dev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.580578] systemd[1]: Started Journal Service.
[    2.580656] audit: type=1130 audit(1453402859.604:4): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.612582] loop: module loaded
[    2.715518] audit: type=1130 audit(1453402859.739:5): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-cmdline comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.763163] RPC: Registered named UNIX socket transport module.
[    2.763169] RPC: Registered udp transport module.
[    2.763170] RPC: Registered tcp transport module.
[    2.763172] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.858667] alua: device handler registered
[    2.864100] emc: device handler registered
[    2.869371] rdac: device handler registered
[    2.883367] audit: type=1130 audit(1453402859.906:6): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-udev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.890309] audit: type=1130 audit(1453402859.913:7): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-udevd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    2.922419] usb 2-2: new full-speed USB device number 2 using ohci-pci
[    2.997143] audit: type=1130 audit(1453402860.020:8): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-trigger comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    3.056058] audit: type=1130 audit(1453402860.079:9): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-udev-trigger comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    3.064347] sata_svw 0000:01:0e.0: version 2.3
[    3.065694] scsi host0: sata_svw
[    3.065696] scsi host1: pata_serverworks
[    3.065890] scsi host2: pata_serverworks
[    3.065969] ata5: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    3.065971] ata6: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    3.065985] scsi host3: sata_svw
[    3.066199] scsi host4: sata_svw
[    3.066389] scsi host5: sata_svw
[    3.066514] ata1: SATA max UDMA/133 mmio m8192@0xff2fe000 port 0xff2fe000 irq 11
[    3.066517] ata2: SATA max UDMA/133 mmio m8192@0xff2fe000 port 0xff2fe100 irq 11
[    3.066519] ata3: SATA max UDMA/133 mmio m8192@0xff2fe000 port 0xff2fe200 irq 11
[    3.066522] ata4: SATA max UDMA/133 mmio m8192@0xff2fe000 port 0xff2fe300 irq 11
[    3.068369] pps_core: LinuxPPS API ver. 1 registered
[    3.068372] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    3.070799] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    3.070802] e100: Copyright(c) 1999-2006 Intel Corporation
[    3.070851] sata_sil24 0000:05:00.0: version 1.1
[    3.071477] PTP clock support registered
[    3.073387] scsi host6: sata_sil24
[    3.073788] scsi host7: sata_sil24
[    3.073874] ata7: SATA max UDMA/100 host m128@0xff5ffc00 port 0xff5f8000 irq 17
[    3.073878] ata8: SATA max UDMA/100 host m128@0xff5ffc00 port 0xff5fa000 irq 17
[    3.084979] tg3.c:v3.137 (May 11, 2014)
[    3.091859] [drm] Initialized drm 1.1.0 20060810
[    3.111597] usb 2-2: New USB device found, idVendor=046d, idProduct=c52b
[    3.111602] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.111605] usb 2-2: Product: USB Receiver
[    3.111612] usb 2-2: Manufacturer: Logitech
[    3.137844] logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:03.0-2/input2
[    3.171272] e100 0000:00:04.0 eth0: addr 0xff6eb000, irq 16, MAC addr 00:e0:81:4e:2a:59
[    3.172219] e100 0000:00:04.0 enp0s4: renamed from eth0
[    3.174601] usb 3-1: new full-speed USB device number 2 using ohci-pci
[    3.185744] 8021q: 802.1Q VLAN Support v1.8
[    3.205917] [drm] VGACON disable radeon kernel modesetting.
[    3.205940] [drm:radeon_init [radeon]] *ERROR* No UMS support in radeon module!
[    3.221997] tg3 0000:04:04.0 eth0: Tigon3 [partno(BCM95780) rev 8100] (PCIX:133MHz:64-bit) MAC address 00:e0:81:4e:1b:d4
[    3.222003] tg3 0000:04:04.0 eth0: attached PHY is 5780 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    3.222006] tg3 0000:04:04.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    3.222008] tg3 0000:04:04.0 eth0: dma_rwctrl[76144000] dma_mask[40-bit]
[    3.236075] ata5.01: ATAPI: DV-28E-V, 1.AB, max UDMA/33
[    3.238610] tg3 0000:04:04.1 eth1: Tigon3 [partno(BCM95780) rev 8100] (PCIX:133MHz:64-bit) MAC address 00:e0:81:4e:1b:d5
[    3.238614] tg3 0000:04:04.1 eth1: attached PHY is 5780 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    3.238617] tg3 0000:04:04.1 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    3.238643] tg3 0000:04:04.1 eth1: dma_rwctrl[76144000] dma_mask[40-bit]
[    3.239910] tg3 0000:04:04.0 enp4s4f0: renamed from eth0
[    3.252023] tg3 0000:04:04.1 enp4s4f1: renamed from eth1
[    3.252887] input: Logitech K250 as /devices/pci0000:00/0000:00:03.0/usb2/2-2/2-2:1.2/0003:046D:C52B.0003/0003:046D:2015.0004/input/input6
[    3.253216] logitech-hidpp-device 0003:046D:2015.0004: input,hidraw1: USB HID v1.11 Keyboard [Logitech K250] on usb-0000:00:03.0-2:2
[    3.258051] ata5.01: configured for UDMA/33
[    3.268677] usb 1-4: new high-speed USB device number 4 using ehci-pci
[    3.270663] scsi 1:0:1:0: CD-ROM            TEAC     DV-28E-V         1.AB PQ: 0 ANSI: 5
[    3.294894] sr 1:0:1:0: [sr0] scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[    3.294898] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.295075] sr 1:0:1:0: Attached scsi CD-ROM sr0
[    3.295192] sr 1:0:1:0: Attached scsi generic sg0 type 5
[    3.334739] tsc: Refined TSC clocksource calibration: 2194.500 MHz
[    3.334745] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fa1e72917d, max_idle_ns: 440795225471 ns
[    3.371790] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.373810] usb 3-1: New USB device found, idVendor=046d, idProduct=c041
[    3.373814] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.373816] usb 3-1: Product: USB Gaming Mouse
[    3.373818] usb 3-1: Manufacturer: Logitech
[    3.375157] ata1.00: ATA-9: ST1000DX001-1CM162, CC44, max UDMA/133
[    3.375161] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.381139] ata1.00: configured for UDMA/133
[    3.384337] usb 1-4: New USB device found, idVendor=1307, idProduct=0165
[    3.384341] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.384343] usb 1-4: Product: USB Flash Disk
[    3.384345] usb 1-4: Manufacturer: General
[    3.384347] usb 1-4: SerialNumber: 5a060f23ecc74b
[    3.389225] input: Logitech USB Gaming Mouse as /devices/pci0000:00/0000:00:03.1/usb3/3-1/3-1:1.0/0003:046D:C041.0005/input/input7
[    3.389385] hid-generic 0003:046D:C041.0005: input,hidraw2: USB HID v1.11 Mouse [Logitech USB Gaming Mouse] on usb-0000:00:03.1-1/input0
[    3.400971] hid-generic 0003:046D:C041.0006: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Gaming Mouse] on usb-0000:00:03.1-1/input1
[    3.446056] scsi 0:0:0:0: Direct-Access     ATA      ST1000DX001-1CM1 CC44 PQ: 0 ANSI: 5
[    3.446382] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.446387] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    3.446413] sd 0:0:0:0: Attached scsi generic sg1 type 0
[    3.446498] sd 0:0:0:0: [sda] Write Protect is off
[    3.446509] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.446568] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.449973]  sda: sda1 sda2
[    3.450480] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.600716] usb-storage 1-4:1.0: USB Mass Storage device detected
[    3.600892] scsi host8: usb-storage 1-4:1.0
[    3.601004] usbcore: registered new interface driver usb-storage
[    3.604137] usbcore: registered new interface driver uas
[    3.751093] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.754481] ata2.00: ATA-9: ST1000DX001-1CM162, CC44, max UDMA/133
[    3.754485] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.760444] ata2.00: configured for UDMA/133
[    3.760601] scsi 3:0:0:0: Direct-Access     ATA      ST1000DX001-1CM1 CC44 PQ: 0 ANSI: 5
[    3.760883] sd 3:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.760886] sd 3:0:0:0: [sdb] 4096-byte physical blocks
[    3.760912] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    3.761013] sd 3:0:0:0: [sdb] Write Protect is off
[    3.761018] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.761102] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.764589]  sdb: sdb1 sdb2
[    3.765083] sd 3:0:0:0: [sdb] Attached SCSI disk
[    4.065339] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.068702] ata3.00: ATA-9: ST1000DX001-1CM162, CC44, max UDMA/133
[    4.068706] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.074695] ata3.00: configured for UDMA/133
[    4.074825] scsi 4:0:0:0: Direct-Access     ATA      ST1000DX001-1CM1 CC44 PQ: 0 ANSI: 5
[    4.075098] sd 4:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.075102] sd 4:0:0:0: [sdc] 4096-byte physical blocks
[    4.075126] sd 4:0:0:0: Attached scsi generic sg3 type 0
[    4.075218] sd 4:0:0:0: [sdc] Write Protect is off
[    4.075222] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.075274] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.078512]  sdc: sdc1 sdc2
[    4.078985] sd 4:0:0:0: [sdc] Attached SCSI disk
[    4.335722] clocksource: Switched to clocksource tsc
[    4.379587] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.382930] ata4.00: ATA-9: ST1000DX001-1CM162, CC44, max UDMA/133
[    4.382933] ata4.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.388936] ata4.00: configured for UDMA/133
[    4.389052] scsi 5:0:0:0: Direct-Access     ATA      ST1000DX001-1CM1 CC44 PQ: 0 ANSI: 5
[    4.389318] sd 5:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.389322] sd 5:0:0:0: [sdd] 4096-byte physical blocks
[    4.389352] sd 5:0:0:0: Attached scsi generic sg4 type 0
[    4.389407] sd 5:0:0:0: [sdd] Write Protect is off
[    4.389412] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    4.389457] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.392632]  sdd: sdd1 sdd2
[    4.392896] sd 5:0:0:0: [sdd] Attached SCSI disk
[    4.604515] scsi 8:0:0:0: Direct-Access     OCZ      RALLY2           0.00 PQ: 0 ANSI: 2
[    4.604845] sd 8:0:0:0: Attached scsi generic sg5 type 0
[    4.605888] sd 8:0:0:0: [sde] 31326208 512-byte logical blocks: (16.0 GB/14.9 GiB)
[    4.606513] sd 8:0:0:0: [sde] Write Protect is off
[    4.606517] sd 8:0:0:0: [sde] Mode Sense: 00 00 00 00
[    4.607137] sd 8:0:0:0: [sde] Asking for cache data failed
[    4.607205] sd 8:0:0:0: [sde] Assuming drive cache: write through
[    4.786937]  sde: sde1 sde2
[    4.790182] sd 8:0:0:0: [sde] Attached SCSI removable disk
[    5.096160] ata7: SATA link down (SStatus 0 SControl 0)
[    7.117802] ata8: SATA link down (SStatus 0 SControl 0)
[    7.127978] random: nonblocking pool is initialized
[    7.199859] raid6: sse2x1   gen()  2824 MB/s
[    7.216847] raid6: sse2x1   xor()  3039 MB/s
[    7.233874] raid6: sse2x2   gen()  4484 MB/s
[    7.250881] raid6: sse2x2   xor()  4939 MB/s
[    7.267894] raid6: sse2x4   gen()  4890 MB/s
[    7.284907] raid6: sse2x4   xor()  2583 MB/s
[    7.284909] raid6: using algorithm sse2x4 gen() 4890 MB/s
[    7.284911] raid6: .... xor() 2583 MB/s, rmw enabled
[    7.284912] raid6: using intx1 recovery algorithm
[    7.287262] xor: measuring software checksum speed
[    7.296912]    prefetch64-sse:  8544.000 MB/sec
[    7.306923]    generic_sse:  8120.000 MB/sec
[    7.306925] xor: using function: prefetch64-sse (8544.000 MB/sec)
[    7.375198] Btrfs loaded
[    7.376529] BTRFS: device fsid 48f0e952-a176-481e-a184-6ee51acf54b1 devid 4 transid 143415 /dev/sdd2
[    7.377219] BTRFS: device fsid 48f0e952-a176-481e-a184-6ee51acf54b1 devid 1 transid 143415 /dev/sda2
[    7.377842] BTRFS: device fsid 48f0e952-a176-481e-a184-6ee51acf54b1 devid 6 transid 143415 /dev/sdb2
[    7.378400] BTRFS: device fsid 48f0e952-a176-481e-a184-6ee51acf54b1 devid 3 transid 143415 /dev/sdc2
[    7.436104] audit: type=1130 audit(1453402864.455:10): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=plymouth-start comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    7.530208] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    8.981299] audit: type=1130 audit(1453402865.998:11): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-initqueue comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    8.999428] audit: type=1130 audit(1453402866.017:12): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-mount comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.014996] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    9.097017] audit: type=1130 audit(1453402866.114:13): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-parse-etc comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.097038] audit: type=1131 audit(1453402866.114:14): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-parse-etc comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.158448] audit: type=1130 audit(1453402866.175:15): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-mount comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.357128] audit: type=1130 audit(1453402866.374:16): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-pivot comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.364501] audit: type=1130 audit(1453402866.381:17): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-cleanup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.364519] audit: type=1131 audit(1453402866.381:18): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-cleanup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.366345] audit: type=1131 audit(1453402866.383:19): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-pivot comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    9.413341] systemd-journald[226]: Received SIGTERM from PID 1 (systemd).
[   10.128002] SELinux: 32768 avtab hash slots, 103390 rules.
[   10.145720] SELinux: 32768 avtab hash slots, 103390 rules.
[   10.175028] SELinux:  8 users, 14 roles, 4906 types, 306 bools, 1 sens, 1024 cats
[   10.175034] SELinux:  92 classes, 103390 rules
[   10.179265] SELinux:  Completing initialization.
[   10.179267] SELinux:  Setting up existing superblocks.
[   10.206263] systemd[1]: Successfully loaded SELinux policy in 220.374ms.
[   10.313390] systemd[1]: Relabelled /dev and /run in 42.675ms.
[   11.961585] EXT4-fs (dm-0): re-mounted. Opts: (null)
[   12.543269] systemd-journald[916]: Received request to flush runtime journal from PID 1
[   12.725914] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   13.071609] acpi-cpufreq: overriding BIOS provided _PSD data
[   13.233202] MCE: In-kernel MCE decoding enabled.
[   13.326256] piix4_smbus 0000:00:02.0: SMBus Host Controller at 0x580, revision 0
[   13.386863] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   13.505041] EDAC MC: Ver: 3.0.0
[   13.513197] AMD64 EDAC driver v3.4.0
[   13.513277] EDAC amd64: DRAM ECC enabled.
[   13.513297] EDAC amd64: F10h detected (node 0).
[   13.513327] EDAC MC: DCT0 chip selects:
[   13.513331] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[   13.513334] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[   13.513336] EDAC amd64: MC: 4:  2048MB 5:  2048MB
[   13.513338] EDAC amd64: MC: 6:  2048MB 7:  2048MB
[   13.513340] EDAC MC: DCT1 chip selects:
[   13.513343] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[   13.513345] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[   13.513347] EDAC amd64: MC: 4:  2048MB 5:  2048MB
[   13.513350] EDAC amd64: MC: 6:  2048MB 7:  2048MB
[   13.513352] EDAC amd64: using x8 syndromes.
[   13.513354] EDAC amd64: MCT channel count: 2
[   13.514464] EDAC MC0: Giving out device to module amd64_edac controller F10h: DEV 0000:00:18.2 (INTERRUPT)
[   13.514524] EDAC amd64: DRAM ECC enabled.
[   13.514549] EDAC amd64: F10h detected (node 1).
[   13.514567] EDAC MC: DCT0 chip selects:
[   13.514569] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[   13.514571] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[   13.514572] EDAC amd64: MC: 4:  2048MB 5:  2048MB
[   13.514574] EDAC amd64: MC: 6:  2048MB 7:  2048MB
[   13.514575] EDAC MC: DCT1 chip selects:
[   13.514576] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[   13.514577] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[   13.514579] EDAC amd64: MC: 4:  2048MB 5:  2048MB
[   13.514580] EDAC amd64: MC: 6:  2048MB 7:  2048MB
[   13.514581] EDAC amd64: using x8 syndromes.
[   13.514582] EDAC amd64: MCT channel count: 2
[   13.515124] EDAC MC1: Giving out device to module amd64_edac controller F10h: DEV 0000:00:19.2 (INTERRUPT)
[   13.515210] EDAC PCI0: Giving out device to module amd64_edac controller EDAC PCI controller: DEV 0000:00:18.2 (POLLED)
[   13.884192] k10temp 0000:00:18.3: unreliable CPU thermal sensor; monitoring disabled
[   13.884729] k10temp 0000:00:19.3: unreliable CPU thermal sensor; monitoring disabled
[   14.035054] kvm: Nested Virtualization enabled
[   14.035063] kvm: Nested Paging enabled
[   14.043256] [drm] VGACON disable radeon kernel modesetting.
[   14.043280] [drm:radeon_init [radeon]] *ERROR* No UMS support in radeon module!
[   14.405291] audit_printk_skb: 138 callbacks suppressed
[   14.405303] audit: type=1130 audit(1453402871.418:66): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-udev-settle comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   14.818930] audit: type=1130 audit(1453402871.831:67): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=dmraid-activation comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   14.818994] audit: type=1131 audit(1453402871.831:68): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=dmraid-activation comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   14.841929] audit: type=1130 audit(1453402871.854:69): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nfs-config comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   14.861901] audit: type=1130 audit(1453402871.874:70): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=plymouth-read-write comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   14.861950] audit: type=1131 audit(1453402871.874:71): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=plymouth-read-write comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   14.899954] audit: type=1130 audit(1453402871.912:72): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=dracut-shutdown comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   15.038298] audit: type=1130 audit(1453402872.051:73): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=fedora-import-state comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   15.125383] audit: type=1130 audit(1453402872.138:74): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-tmpfiles-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   15.158749] audit: type=1305 audit(1453402872.171:75): auid=4294967295 ses=4294967295 subj=system_u:system_r:auditctl_t:s0 op="add_rule" key=(null) list=1 res=1
[   21.035198] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[   21.130236] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   21.288601] Ebtables v2.0 registered
[   21.377044] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[   22.994110] IPv6: ADDRCONF(NETDEV_UP): enp0s4: link is not ready
[   23.070016] IPv6: ADDRCONF(NETDEV_UP): enp0s4: link is not ready
[   23.078759] IPv6: ADDRCONF(NETDEV_UP): enp4s4f1: link is not ready
[   23.117092] IPv6: ADDRCONF(NETDEV_UP): enp4s4f1: link is not ready
[   23.121073] IPv6: ADDRCONF(NETDEV_UP): enp4s4f0: link is not ready
[   23.159114] IPv6: ADDRCONF(NETDEV_UP): enp4s4f0: link is not ready
[   26.218247] tg3 0000:04:04.1 enp4s4f1: Link is up at 1000 Mbps, full duplex
[   26.218281] tg3 0000:04:04.1 enp4s4f1: Flow control is on for TX and on for RX
[   26.218324] IPv6: ADDRCONF(NETDEV_CHANGE): enp4s4f1: link becomes ready
[   29.873394] mtrr: no MTRR for d8000000,2000000 found
[   33.483348] fuse init (API version 7.23)
[   44.475545] FAT-fs (sde2): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[  289.625176] BTRFS info (device sdc2): disk space caching is enabled
[  289.625183] BTRFS: has skinny extents
[  374.493780] BTRFS info (device sdc2): disk space caching is enabled
[  374.493786] BTRFS: has skinny extents

--------------070709040102070100050503--
