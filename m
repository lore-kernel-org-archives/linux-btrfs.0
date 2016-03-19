Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54017 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143AbcCSWPl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Mar 2016 18:15:41 -0400
MIME-Version: 1.0
Message-ID: <trinity-168495fe-1b45-46b7-bd18-d68fb686437e-1458425733744@3capp-gmx-bs02>
From: "Patrick Tschackert" <Killing-Time@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: unable to mount btrfs partition, please help :(
Content-Type: multipart/mixed;
 boundary=rekcebs-ae00360e-beeb-47d3-9d7d-bafe2856fae9
Date: Sat, 19 Mar 2016 23:15:33 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--rekcebs-ae00360e-beeb-47d3-9d7d-bafe2856fae9
Content-Type: text/plain; charset=UTF-8

Hi,

Apologies if this eMail reaches the mailing list multiple times, i can't seem to get throught to the mailing list, so I'm sending it through a different account now...

I'm having problems mounting my BTRFS filesystem. Here's what happened:

My BTRFS filesystem sits in an encrypted container on a linux software
RAID 6. A VirtualBox crash (while writing to the filesystem I
presume), and I rebooted the machine with "shutdown -r now", becaue a
reboot was necessary due to upgraded VirtualBox drivers.
When the system was running again, I couldn't mount the filesystem.
This is what I did:

$ cryptsetup luksOpen /dev/md0 storage (this worked fine)
$ mount /dev/mapper/storage /media/storage
mount: wrong fs type, bad option, bad superblock on /dev/mapper/storage,
missing codepage or helper program, or other error

In some cases useful info is found in syslog - try
dmesg | tail or so.

I then saw that one of the RAID's disks was no longer present in the
array, so I started a rebuild/recover by executing mdadm --run. The
RAID rebuilt itself using one of the spare disks. After the rebuild,
the problem persists, I cannot mount my file system. Mounting with
options "ro" and/or "recovery" makes no difference. I am unable to do
a backup of the metadata:

$ btrfs-image -c9 /dev/mapper/storage ~/btrfs_img
checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
bytenr mismatch, want=36340960788480, have=4530277753793296986
Couldn't read chunk tree
Open ctree failed
create failed (Success)

I'm growing increasingly desperate, can anyone help me? I'm thinking
of trying one or more of the following, but would like an informed
opinion:
1) btrfs check --fix-crc
2) btrfs-check --init-csum-tree
3) btrfs rescue chunk-recover
4) btrfs-check --repair
5) btrfs rescue zero-log

Here is various info about my system as it is now, including the info
requested on https://btrfs.wiki.kernel.org/index.php/Btrfs_mailing_list.
The full DMESG is attached to this eMail.

$ btrfs restore -D /dev/mapper/storage /media/rest
checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
bytenr mismatch, want=36340960788480, have=4530277753793296986
Couldn't read chunk tree
Could not open root, trying backup super
checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
bytenr mismatch, want=36340960788480, have=4530277753793296986
Couldn't read chunk tree
Could not open root, trying backup super
checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
bytenr mismatch, want=36340960788480, have=4530277753793296986
Couldn't read chunk tree
Could not open root, trying backup super

$ btrfs check --readonly /dev/mapper/storage
checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
checksum verify failed on 36340960788480 found 8F8E1006 wanted 4AA1BC89
bytenr mismatch, want=36340960788480, have=4530277753793296986
Couldn't read chunk tree
Couldn't open file system

$ btrfs-show-super /dev/mapper/storage
superblock: bytenr=65536, device=/dev/mapper/storage
---------------------------------------------------------
csum 0xf3887f83 [match]
bytenr 65536
flags 0x1
( WRITTEN )
magic _BHRfS_M [match]
fsid 9868d803-78d1-40c3-b1ee-a4ce3363df87
label
generation 1322969
root 24022309593088
sys_array_size 97
chunk_root_generation 1275381
root_level 2
chunk_root 36340959809536
chunk_root_level 2
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 21003208163328
bytes_used 17670843191296
sectorsize 4096
nodesize 4096
leafsize 4096
stripesize 4096
root_dir 6
num_devices 1
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0x1
( MIXED_BACKREF )
csum_type 0
csum_size 4
cache_generation 1322969
uuid_tree_generation 1322969
dev_item.uuid c1123f55-46ce-4931-8722-7387fee07608
dev_item.fsid 9868d803-78d1-40c3-b1ee-a4ce3363df87 [match]
dev_item.type 0
dev_item.total_bytes 21003208163328
dev_item.bytes_used 17886424858624
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 1
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active (auto-read-only) raid6 sda[0] sdg[11](S) sdf[12](S)
sdj[9] sdh[7] sdi[6] sdk[10] sde[4] sdd[3] sdc[2] sdb[1]
20510948416 blocks super 1.2 level 6, 64k chunk, algorithm 2
[9/9] [UUUUUUUUU]

unused devices: <none>

$ mdadm -D /dev/md0
/dev/md0:
Version : 1.2
Creation Time : Sat Jun 14 18:47:44 2014
Raid Level : raid6
Array Size : 20510948416 (19560.77 GiB 21003.21 GB)
Used Dev Size : 2930135488 (2794.40 GiB 3000.46 GB)
Raid Devices : 9
Total Devices : 11
Persistence : Superblock is persistent

Update Time : Sat Mar 19 13:59:54 2016
State : clean
Active Devices : 9
Working Devices : 11
Failed Devices : 0
Spare Devices : 2

Layout : left-symmetric
Chunk Size : 64K

Name : brain:0
UUID : e45daf8f:99d0ff7f:e8244429:827e7c71
Events : 2388

Number Major Minor RaidDevice State
0 8 0 0 active sync /dev/sda
1 8 16 1 active sync /dev/sdb
2 8 32 2 active sync /dev/sdc
3 8 48 3 active sync /dev/sdd
4 8 64 4 active sync /dev/sde
10 8 160 5 active sync /dev/sdk
6 8 128 6 active sync /dev/sdi
7 8 112 7 active sync /dev/sdh
9 8 144 8 active sync /dev/sdj

11 8 96 - spare /dev/sdg
12 8 80 - spare /dev/sdf

$ uname -a
Linux vmhost 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u4
(2016-02-29) x86_64 GNU/Linux

$ btrfs --version
btrfs-progs v4.4

$ btrfs fi show
Label: none uuid: 9868d803-78d1-40c3-b1ee-a4ce3363df87
Total devices 1 FS bytes used 16.07TiB
devid 1 size 19.10TiB used 16.27TiB path /dev/mapper/storage

excerpt from DMESG:
[ 151.970916] BTRFS: device fsid 9868d803-78d1-40c3-b1ee-a4ce3363df87
devid 1 transid 1322969 /dev/dm-0
[ 163.105784] BTRFS info (device dm-0): disk space caching is enabled
[ 165.304968] BTRFS: bad tree block start 4530277753793296986 36340960788480
[ 165.305233] BTRFS: bad tree block start 4530277753793296986 36340960788480
[ 165.305281] BTRFS: failed to read chunk tree on dm-0
[ 165.331407] BTRFS: open_ctree failed
--rekcebs-ae00360e-beeb-47d3-9d7d-bafe2856fae9
Content-Type: text/x-log
Content-Disposition: attachment; filename=dmesg.log

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-4-amd64 (debian-kernel@lists.debian.org) (gcc version 4.8.4 (Debian 4.8.4-1) ) #1 SMP Debian 3.16.7-ckt20-1+deb8u4 (2016-02-29)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.16.0-4-amd64 root=UUID=a8523eac-7377-4aa3-a226-8757838ae7b8 ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000cc499fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cc49a000-0x00000000cca73fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cca74000-0x00000000cca84fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cca85000-0x00000000ccba9fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ccbaa000-0x00000000cd7e9fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cd7ea000-0x00000000cd7eafff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cd7eb000-0x00000000cd82dfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cd82e000-0x00000000cdc55fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cdc56000-0x00000000cdff3fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cdff4000-0x00000000cdffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf000000-0x00000000df1fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: System manufacturer System Product Name/P8Z77-V, BIOS 1805 12/19/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x41fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 400000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   4 base 0CF000000 mask FFF000000 uncachable
[    0.000000]   5 base 41FE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xcf000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xce000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd8c0-0x000fd8cf] mapped at [ffff8800000fd8c0]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01af4000, 0x01af4fff] PGTABLE
[    0.000000] BRK [0x01af5000, 0x01af5fff] PGTABLE
[    0.000000] BRK [0x01af6000, 0x01af6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41fc00000-0x41fdfffff]
[    0.000000]  [mem 0x41fc00000-0x41fdfffff] page 2M
[    0.000000] BRK [0x01af7000, 0x01af7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41fbfffff]
[    0.000000]  [mem 0x41c000000-0x41fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] BRK [0x01af8000, 0x01af8fff] PGTABLE
[    0.000000] BRK [0x01af9000, 0x01af9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x40005000-0xcc499fff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0xcc3fffff] page 2M
[    0.000000]  [mem 0xcc400000-0xcc499fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xcd7ea000-0xcd7eafff]
[    0.000000]  [mem 0xcd7ea000-0xcd7eafff] page 4k
[    0.000000] init_memory_mapping: [mem 0xcd82e000-0xcdc55fff]
[    0.000000]  [mem 0xcd82e000-0xcd9fffff] page 4k
[    0.000000]  [mem 0xcda00000-0xcdbfffff] page 2M
[    0.000000]  [mem 0xcdc00000-0xcdc55fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xcdff4000-0xcdffffff]
[    0.000000]  [mem 0xcdff4000-0xcdffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x35f8a000-0x36fbcfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000CCA77078 00006C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000CCA82818 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000CCA77180 00B693 (v02 ALASKA A M I    00000022 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000CCBA8080 000040
[    0.000000] ACPI: APIC 0x00000000CCA82928 000072 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000CCA829A0 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000CCA829E8 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000CCA82A28 000038 (v01 ALASKA A M I    01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000CCA82A60 00036D (v01 SataRe SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: BGRT 0x00000000CCA84270 000038 (v00 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x00000000CCA82E28 0009AA (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000CCA837D8 000A92 (v01 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041fdfffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x41fdfffff]
[    0.000000]   NODE_DATA [mem 0x41fde8000-0x41fdecfff]
[    0.000000]  [ffffea0000000000-ffffea000e7fffff] PMD -> [ffff88040f800000-ffff88041d5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xcc499fff]
[    0.000000]   node   0: [mem 0xcd7ea000-0xcd7eafff]
[    0.000000]   node   0: [mem 0xcd82e000-0xcdc55fff]
[    0.000000]   node   0: [mem 0xcdff4000-0xcdffffff]
[    0.000000]   node   0: [mem 0x100000000-0x41fdfffff]
[    0.000000] On node 0 totalpages: 4113513
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11392 pages used for memmap
[    0.000000]   DMA32 zone: 833230 pages, LIFO batch:31
[    0.000000]   Normal zone: 44793 pages used for memmap
[    0.000000]   Normal zone: 3276288 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xcf200000-0xdf1fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0xcc49a000-0xcca73fff]
[    0.000000] PM: Registered nosave memory: [mem 0xcca74000-0xcca84fff]
[    0.000000] PM: Registered nosave memory: [mem 0xcca85000-0xccba9fff]
[    0.000000] PM: Registered nosave memory: [mem 0xccbaa000-0xcd7e9fff]
[    0.000000] PM: Registered nosave memory: [mem 0xcd7eb000-0xcd82dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcdc56000-0xcdff3fff]
[    0.000000] PM: Registered nosave memory: [mem 0xce000000-0xceffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf000000-0xdf1fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf200000-0xf7ffffff]
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
[    0.000000] e820: [mem 0xdf200000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88041fa00000 s80896 r8192 d21504 u524288
[    0.000000] pcpu-alloc: s80896 r8192 d21504 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4057251
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.16.0-4-amd64 root=UUID=a8523eac-7377-4aa3-a226-8757838ae7b8 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 16131976K/16454052K available (5219K kernel code, 947K rwdata, 1836K rodata, 1204K init, 840K bss, 322076K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3410.026 MHz processor
[    0.000024] Calibrating delay loop (skipped), value calculated using timer frequency.. 6820.05 BogoMIPS (lpj=13640104)
[    0.000026] pid_max: default: 32768 minimum: 301
[    0.000031] ACPI: Core revision 20140424
[    0.005098] ACPI: All ACPI Tables successfully acquired
[    0.005117] Security Framework initialized
[    0.005123] AppArmor: AppArmor disabled by boot time parameter
[    0.005124] Yama: disabled by default; enable with sysctl kernel.yama.*
[    0.005765] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.008637] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.009911] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.009923] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.010128] Initializing cgroup subsys memory
[    0.010132] Initializing cgroup subsys devices
[    0.010136] Initializing cgroup subsys freezer
[    0.010138] Initializing cgroup subsys net_cls
[    0.010141] Initializing cgroup subsys blkio
[    0.010144] Initializing cgroup subsys perf_event
[    0.010145] Initializing cgroup subsys net_prio
[    0.010162] CPU: Physical Processor ID: 0
[    0.010163] CPU: Processor Core ID: 0
[    0.010166] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.010426] mce: CPU supports 9 MCE banks
[    0.010436] CPU0: Thermal monitoring enabled (TM1)
[    0.010442] process: using mwait in idle threads
[    0.010445] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
tlb_flushall_shift: 2
[    0.010528] Freeing SMP alternatives memory: 20K (ffffffff81a1b000 - ffffffff81a20000)
[    0.080947] ftrace: allocating 21679 entries in 85 pages
[    0.087954] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.127599] smpboot: CPU0: Intel(R) Core(TM) i5-3570K CPU @ 3.40GHz (fam: 06, model: 3a, stepping: 09)
[    0.127603] TSC deadline timer enabled
[    0.127618] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.127633] ... version:                3
[    0.127633] ... bit width:              48
[    0.127634] ... generic registers:      8
[    0.127634] ... value mask:             0000ffffffffffff
[    0.127635] ... max period:             0000ffffffffffff
[    0.127635] ... fixed-purpose events:   3
[    0.127636] ... event mask:             00000007000000ff
[    0.128611] x86: Booting SMP configuration:
[    0.128613] .... node  #0, CPUs:      #1
[    0.141868] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.141942]  #2 #3
[    0.168865] x86: Booted up 1 node, 4 CPUs
[    0.168867] smpboot: Total of 4 processors activated (27280.20 BogoMIPS)
[    0.171079] devtmpfs: initialized
[    0.173726] PM: Registering ACPI NVS region [mem 0xcca85000-0xccba9fff] (1200128 bytes)
[    0.173744] PM: Registering ACPI NVS region [mem 0xcd7eb000-0xcd82dfff] (274432 bytes)
[    0.174382] pinctrl core: initialized pinctrl subsystem
[    0.174433] NET: Registered protocol family 16
[    0.174516] cpuidle: using governor ladder
[    0.174518] cpuidle: using governor menu
[    0.174545] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.174546] ACPI: bus type PCI registered
[    0.174547] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.174604] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.174606] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.174666] PCI: Using configuration type 1 for base access
[    0.185088] ACPI: Added _OSI(Module Device)
[    0.185090] ACPI: Added _OSI(Processor Device)
[    0.185090] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.185091] ACPI: Added _OSI(Processor Aggregator Device)
[    0.186766] ACPI: Executed 1 blocks of module-level executable AML code
[    0.197078] ACPI: Dynamic OEM Table Load:
[    0.197083] ACPI: SSDT 0xFFFF88040F13C000 00083B (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.208983] ACPI: Dynamic OEM Table Load:
[    0.208987] ACPI: SSDT 0xFFFF88040F6B9400 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.218961] ACPI: Dynamic OEM Table Load:
[    0.218965] ACPI: SSDT 0xFFFF88040F76EE00 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.227743] ACPI: Interpreter enabled
[    0.227748] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
[    0.227751] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    0.227760] ACPI: (supports S0 S3 S4 S5)
[    0.227761] ACPI: Using IOAPIC for interrupt routing
[    0.227782] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.232184] ACPI: Power Resource [FN00] (off)
[    0.232240] ACPI: Power Resource [FN01] (off)
[    0.232295] ACPI: Power Resource [FN02] (off)
[    0.232349] ACPI: Power Resource [FN03] (off)
[    0.232402] ACPI: Power Resource [FN04] (off)
[    0.232808] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.232811] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.232963] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.233054] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.233494] PCI host bridge to bus 0000:00
[    0.233496] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.233498] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.233499] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.233500] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.233501] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.233502] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.233503] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.233504] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.233505] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.233506] pci_bus 0000:00: root bus resource [mem 0xdf200000-0xfeafffff]
[    0.233512] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.233576] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
[    0.233600] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.233629] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.233660] pci 0000:00:02.0: [8086:0162] type 00 class 0x030000
[    0.233667] pci 0000:00:02.0: reg 0x10: [mem 0xf7400000-0xf77fffff 64bit]
[    0.233671] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.233674] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.233753] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.233772] pci 0000:00:14.0: reg 0x10: [mem 0xf7c20000-0xf7c2ffff 64bit]
[    0.233837] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.233870] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.233902] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.233922] pci 0000:00:16.0: reg 0x10: [mem 0xf7c3b000-0xf7c3b00f 64bit]
[    0.233990] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.234057] pci 0000:00:19.0: [8086:1503] type 00 class 0x020000
[    0.234072] pci 0000:00:19.0: reg 0x10: [mem 0xf7c00000-0xf7c1ffff]
[    0.234080] pci 0000:00:19.0: reg 0x14: [mem 0xf7c39000-0xf7c39fff]
[    0.234087] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    0.234143] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.234176] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.234209] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.234227] pci 0000:00:1a.0: reg 0x10: [mem 0xf7c38000-0xf7c383ff]
[    0.234310] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.234354] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.234386] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.234400] pci 0000:00:1b.0: reg 0x10: [mem 0xf7c30000-0xf7c33fff 64bit]
[    0.234468] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.234503] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.234532] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.234607] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.234643] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.234673] pci 0000:00:1c.3: [8086:1e16] type 01 class 0x060400
[    0.234748] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.234786] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.234814] pci 0000:00:1c.4: [8086:244e] type 01 class 0x060401
[    0.234889] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.234925] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.234955] pci 0000:00:1c.6: [8086:1e1c] type 01 class 0x060400
[    0.235030] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.235066] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    0.235095] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
[    0.235170] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.235206] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    0.235239] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.235258] pci 0000:00:1d.0: reg 0x10: [mem 0xf7c37000-0xf7c373ff]
[    0.235340] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.235383] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.235415] pci 0000:00:1f.0: [8086:1e44] type 00 class 0x060100
[    0.235568] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.235583] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    0.235590] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    0.235596] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    0.235602] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    0.235609] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.235615] pci 0000:00:1f.2: reg 0x24: [mem 0xf7c36000-0xf7c367ff]
[    0.235655] pci 0000:00:1f.2: PME# supported from D3hot
[    0.235711] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.235724] pci 0000:00:1f.3: reg 0x10: [mem 0xf7c35000-0xf7c350ff 64bit]
[    0.235742] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.235839] pci 0000:01:00.0: [1b4b:9230] type 00 class 0x010601
[    0.235846] pci 0000:01:00.0: reg 0x10: [io  0xe050-0xe057]
[    0.235851] pci 0000:01:00.0: reg 0x14: [io  0xe040-0xe043]
[    0.235855] pci 0000:01:00.0: reg 0x18: [io  0xe030-0xe037]
[    0.235860] pci 0000:01:00.0: reg 0x1c: [io  0xe020-0xe023]
[    0.235864] pci 0000:01:00.0: reg 0x20: [io  0xe000-0xe01f]
[    0.235869] pci 0000:01:00.0: reg 0x24: [mem 0xf7b10000-0xf7b107ff]
[    0.235874] pci 0000:01:00.0: reg 0x30: [mem 0xf7b00000-0xf7b0ffff pref]
[    0.235897] pci 0000:01:00.0: PME# supported from D3hot
[    0.240804] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.240806] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.240808] pci 0000:00:01.0:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    0.240865] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.240944] pci 0000:03:00.0: [1b21:0612] type 00 class 0x010601
[    0.240964] pci 0000:03:00.0: reg 0x10: [io  0xd050-0xd057]
[    0.240977] pci 0000:03:00.0: reg 0x14: [io  0xd040-0xd043]
[    0.240989] pci 0000:03:00.0: reg 0x18: [io  0xd030-0xd037]
[    0.241001] pci 0000:03:00.0: reg 0x1c: [io  0xd020-0xd023]
[    0.241013] pci 0000:03:00.0: reg 0x20: [io  0xd000-0xd01f]
[    0.241026] pci 0000:03:00.0: reg 0x24: [mem 0xf7a00000-0xf7a001ff]
[    0.241126] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.248803] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.248806] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.248809] pci 0000:00:1c.3:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.248881] pci 0000:04:00.0: [1b21:1080] type 01 class 0x060401
[    0.248996] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.249019] pci 0000:00:1c.4: PCI bridge to [bus 04-05] (subtractive decode)
[    0.249028] pci 0000:00:1c.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.249029] pci 0000:00:1c.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.249030] pci 0000:00:1c.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.249032] pci 0000:00:1c.4:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.249033] pci 0000:00:1c.4:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.249034] pci 0000:00:1c.4:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    0.249035] pci 0000:00:1c.4:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    0.249036] pci 0000:00:1c.4:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
[    0.249037] pci 0000:00:1c.4:   bridge window [mem 0xdf200000-0xfeafffff] (subtractive decode)
[    0.249149] pci 0000:04:00.0: PCI bridge to [bus 05] (subtractive decode)
[    0.249169] pci 0000:04:00.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.249171] pci 0000:04:00.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.249172] pci 0000:04:00.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.249173] pci 0000:04:00.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.249174] pci 0000:04:00.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.249175] pci 0000:04:00.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    0.249176] pci 0000:04:00.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    0.249177] pci 0000:04:00.0:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
[    0.249178] pci 0000:04:00.0:   bridge window [mem 0xdf200000-0xfeafffff] (subtractive decode)
[    0.249259] pci 0000:06:00.0: [168c:0032] type 00 class 0x028000
[    0.249288] pci 0000:06:00.0: reg 0x10: [mem 0xf7900000-0xf797ffff 64bit]
[    0.249348] pci 0000:06:00.0: reg 0x30: [mem 0xf7980000-0xf798ffff pref]
[    0.249428] pci 0000:06:00.0: supports D1 D2
[    0.249429] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.249457] pci 0000:06:00.0: System wakeup disabled by ACPI
[    0.256797] pci 0000:00:1c.6: PCI bridge to [bus 06]
[    0.256802] pci 0000:00:1c.6:   bridge window [mem 0xf7900000-0xf79fffff]
[    0.256884] pci 0000:07:00.0: [1b21:1042] type 00 class 0x0c0330
[    0.256915] pci 0000:07:00.0: reg 0x10: [mem 0xf7800000-0xf7807fff 64bit]
[    0.257065] pci 0000:07:00.0: PME# supported from D3hot D3cold
[    0.257096] pci 0000:07:00.0: System wakeup disabled by ACPI
[    0.264791] pci 0000:00:1c.7: PCI bridge to [bus 07]
[    0.264796] pci 0000:00:1c.7:   bridge window [mem 0xf7800000-0xf78fffff]
[    0.264831] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.265200] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.265235] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.265269] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.265301] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.265334] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.265367] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.265399] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.265431] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.265598] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.265613] ACPI : EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.265680] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.265681] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.265683] vgaarb: loaded
[    0.265684] vgaarb: bridge control possible 0000:00:02.0
[    0.265724] PCI: Using ACPI for IRQ routing
[    0.267050] PCI: pci_cache_line_size set to 64 bytes
[    0.267101] e820: reserve RAM buffer [mem 0x0009c000-0x0009ffff]
[    0.267102] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.267103] e820: reserve RAM buffer [mem 0xcc49a000-0xcfffffff]
[    0.267104] e820: reserve RAM buffer [mem 0xcd7eb000-0xcfffffff]
[    0.267106] e820: reserve RAM buffer [mem 0xcdc56000-0xcfffffff]
[    0.267106] e820: reserve RAM buffer [mem 0xce000000-0xcfffffff]
[    0.267107] e820: reserve RAM buffer [mem 0x41fe00000-0x41fffffff]
[    0.267196] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.267199] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.269215] Switched to clocksource hpet
[    0.272631] pnp: PnP ACPI init
[    0.272639] ACPI: bus type PNP registered
[    0.272695] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.272697] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.272753] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.272754] system 00:01: [io  0x1000-0x100f] has been reserved
[    0.272755] system 00:01: [io  0xffff] has been reserved
[    0.272757] system 00:01: [io  0xffff] has been reserved
[    0.272758] system 00:01: [io  0x0400-0x0453] could not be reserved
[    0.272759] system 00:01: [io  0x0458-0x047f] has been reserved
[    0.272760] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.272762] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.272763] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.272787] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.272820] system 00:03: [io  0x0454-0x0457] has been reserved
[    0.272822] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.272882] system 00:04: [io  0x0290-0x029f] has been reserved
[    0.272884] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.272922] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.272924] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.273061] pnp 00:06: [dma 0 disabled]
[    0.273095] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.273274] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.273276] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.273277] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.273278] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.273280] system 00:07: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.273281] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.273282] system 00:07: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.273283] system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.273285] system 00:07: [mem 0xff000000-0xffffffff] has been reserved
[    0.273286] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.273287] system 00:07: [mem 0xdf200000-0xdf200fff] has been reserved
[    0.273289] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.273397] system 00:08: [mem 0x20000000-0x201fffff] has been reserved
[    0.273398] system 00:08: [mem 0x40004000-0x40004fff] has been reserved
[    0.273400] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.273414] pnp: PnP ACPI: found 9 devices
[    0.273415] ACPI: bus type PNP unregistered
[    0.279255] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.279257] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.279258] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
[    0.279297] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.279298] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.279299] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.279302] pci 0000:00:1c.0: BAR 14: assigned [mem 0xdf300000-0xdf4fffff]
[    0.279307] pci 0000:00:1c.0: BAR 15: assigned [mem 0xdf500000-0xdf6fffff 64bit pref]
[    0.279309] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.279310] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.279312] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.279314] pci 0000:00:01.0:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    0.279316] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.279318] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.279322] pci 0000:00:1c.0:   bridge window [mem 0xdf300000-0xdf4fffff]
[    0.279325] pci 0000:00:1c.0:   bridge window [mem 0xdf500000-0xdf6fffff 64bit pref]
[    0.279330] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.279332] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.279336] pci 0000:00:1c.3:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.279342] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.279361] pci 0000:00:1c.4: PCI bridge to [bus 04-05]
[    0.279370] pci 0000:00:1c.6: PCI bridge to [bus 06]
[    0.279374] pci 0000:00:1c.6:   bridge window [mem 0xf7900000-0xf79fffff]
[    0.279381] pci 0000:00:1c.7: PCI bridge to [bus 07]
[    0.279385] pci 0000:00:1c.7:   bridge window [mem 0xf7800000-0xf78fffff]
[    0.279392] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.279393] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.279394] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.279395] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.279396] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.279397] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]
[    0.279398] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000e3fff]
[    0.279399] pci_bus 0000:00: resource 11 [mem 0x000e4000-0x000e7fff]
[    0.279400] pci_bus 0000:00: resource 12 [mem 0xdf200000-0xfeafffff]
[    0.279401] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.279402] pci_bus 0000:01: resource 1 [mem 0xf7b00000-0xf7bfffff]
[    0.279404] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.279405] pci_bus 0000:02: resource 1 [mem 0xdf300000-0xdf4fffff]
[    0.279406] pci_bus 0000:02: resource 2 [mem 0xdf500000-0xdf6fffff 64bit pref]
[    0.279407] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.279408] pci_bus 0000:03: resource 1 [mem 0xf7a00000-0xf7afffff]
[    0.279409] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.279410] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.279411] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.279412] pci_bus 0000:04: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.279413] pci_bus 0000:04: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.279414] pci_bus 0000:04: resource 9 [mem 0x000dc000-0x000dffff]
[    0.279415] pci_bus 0000:04: resource 10 [mem 0x000e0000-0x000e3fff]
[    0.279416] pci_bus 0000:04: resource 11 [mem 0x000e4000-0x000e7fff]
[    0.279417] pci_bus 0000:04: resource 12 [mem 0xdf200000-0xfeafffff]
[    0.279418] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.279419] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.279420] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.279421] pci_bus 0000:05: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.279422] pci_bus 0000:05: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.279423] pci_bus 0000:05: resource 9 [mem 0x000dc000-0x000dffff]
[    0.279424] pci_bus 0000:05: resource 10 [mem 0x000e0000-0x000e3fff]
[    0.279425] pci_bus 0000:05: resource 11 [mem 0x000e4000-0x000e7fff]
[    0.279426] pci_bus 0000:05: resource 12 [mem 0xdf200000-0xfeafffff]
[    0.279427] pci_bus 0000:06: resource 1 [mem 0xf7900000-0xf79fffff]
[    0.279428] pci_bus 0000:07: resource 1 [mem 0xf7800000-0xf78fffff]
[    0.279469] NET: Registered protocol family 2
[    0.279654] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.279816] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.279927] TCP: Hash tables configured (established 131072 bind 65536)
[    0.279938] TCP: reno registered
[    0.279950] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.279989] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.280057] NET: Registered protocol family 1
[    0.280068] pci 0000:00:02.0: Video device with shadowed ROM
[    0.317342] PCI: CLS 64 bytes, default 64
[    0.317377] Unpacking initramfs...
[    0.514937] Freeing initrd memory: 16588K (ffff880035f8a000 - ffff880036fbd000)
[    0.514946] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.514947] software IO TLB [mem 0xc849a000-0xcc49a000] (64MB) mapped at [ffff8800c849a000-ffff8800cc499fff]
[    0.515095] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.515130] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x16
[    0.515135] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x16
[    0.515140] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x16
[    0.515145] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x16
[    0.515186] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.515374] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.515400] audit: initializing netlink subsys (disabled)
[    0.515413] audit: type=2000 audit(1458418791.448:1): initialized
[    0.515635] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.515652] zbud: loaded
[    0.515785] VFS: Disk quotas dquot_6.5.2
[    0.515797] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.515840] msgmni has been set to 31540
[    0.516035] alg: No test for stdrng (krng)
[    0.516057] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.516089] io scheduler noop registered
[    0.516091] io scheduler deadline registered
[    0.516116] io scheduler cfq registered (default)
[    0.516255] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.516600] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.516612] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.516627] intel_idle: MWAIT substates: 0x1120
[    0.516628] intel_idle: v0.4 model 0x3A
[    0.516629] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.516756] GHES: HEST is not enabled!
[    0.516800] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.537196] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.537589] Linux agpgart interface v0.103
[    0.537663] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.540102] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.540105] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.540285] mousedev: PS/2 mouse device common for all mice
[    0.540327] rtc_cmos 00:02: RTC can wake from S4
[    0.540490] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.540517] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.540526] Intel P-state driver initializing.
[    0.540535] Intel pstate controlling: cpu 0
[    0.540550] Intel pstate controlling: cpu 1
[    0.540563] Intel pstate controlling: cpu 2
[    0.540576] Intel pstate controlling: cpu 3
[    0.540614] ledtrig-cpu: registered to indicate activity on CPUs
[    0.541329] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
[    0.541330] AMD IOMMUv2 functionality not available on this system
[    0.541448] TCP: cubic registered
[    0.541522] NET: Registered protocol family 10
[    0.541775] mip6: Mobile IPv6
[    0.541780] NET: Registered protocol family 17
[    0.541790] mpls_gso: MPLS GSO support
[    0.542240] registered taskstats version 1
[    0.542979] rtc_cmos 00:02: setting system clock to 2016-03-19 20:19:51 UTC (1458418791)
[    0.543117] PM: Hibernation image not present or could not be loaded.
[    0.544081] Freeing unused kernel memory: 1204K (ffffffff818ee000 - ffffffff81a1b000)
[    0.544083] Write protecting the kernel read-only data: 8192k
[    0.544520] Freeing unused kernel memory: 912K (ffff88000151c000 - ffff880001600000)
[    0.545111] Freeing unused kernel memory: 212K (ffff8800017cb000 - ffff880001800000)
[    0.584100] systemd-udevd[75]: starting version 215
[    0.584308] random: systemd-udevd urandom read with 1 bits of entropy available
[    0.594644] pps_core: LinuxPPS API ver. 1 registered
[    0.594646] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.594916] PTP clock support registered
[    0.595349] ACPI: bus type USB registered
[    0.595372] usbcore: registered new interface driver usbfs
[    0.595383] usbcore: registered new interface driver hub
[    0.595454] SCSI subsystem initialized
[    0.595541] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    0.595541] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    0.595736] usbcore: registered new device driver usb
[    0.596321] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.596378] libata version 3.00 loaded.
[    0.596454] ehci-pci: EHCI PCI platform driver
[    0.621129] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    0.621143] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    0.621262] thermal LNXTHERM:00: registered as thermal_zone0
[    0.621264] ACPI: Thermal Zone [TZ00] (28 C)
[    0.621394] thermal LNXTHERM:01: registered as thermal_zone1
[    0.621395] ACPI: Thermal Zone [TZ01] (30 C)
[    0.621468] ACPI: Fan [FAN0] (off)
[    0.621497] ACPI: Fan [FAN1] (off)
[    0.621519] ACPI: Fan [FAN2] (off)
[    0.621541] ACPI: Fan [FAN3] (off)
[    0.621562] ACPI: Fan [FAN4] (off)
[    0.886902] e1000e 0000:00:19.0 eth0: registered PHC clock
[    0.886906] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 08:60:6e:e8:6b:69
[    0.886908] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    0.886952] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    0.887104] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.887110] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    0.887210] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.887225] xhci_hcd 0000:00:14.0: irq 42 for MSI/MSI-X
[    0.887343] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.887354] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.887355] usb usb1: Product: xHCI Host Controller
[    0.887356] usb usb1: Manufacturer: Linux 3.16.0-4-amd64 xhci_hcd
[    0.887357] usb usb1: SerialNumber: 0000:00:14.0
[    0.887621] hub 1-0:1.0: USB hub found
[    0.887657] hub 1-0:1.0: 4 ports detected
[    0.888302] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.888308] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    0.888668] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    0.888673] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.888675] usb usb2: Product: xHCI Host Controller
[    0.888677] usb usb2: Manufacturer: Linux 3.16.0-4-amd64 xhci_hcd
[    0.888679] usb usb2: SerialNumber: 0000:00:14.0
[    0.888850] hub 2-0:1.0: USB hub found
[    0.888892] hub 2-0:1.0: 4 ports detected
[    0.889443] xhci_hcd 0000:07:00.0: xHCI Host Controller
[    0.889447] xhci_hcd 0000:07:00.0: new USB bus registered, assigned bus number 3
[    0.948793] xhci_hcd 0000:07:00.0: irq 43 for MSI/MSI-X
[    0.948797] xhci_hcd 0000:07:00.0: irq 44 for MSI/MSI-X
[    0.948800] xhci_hcd 0000:07:00.0: irq 45 for MSI/MSI-X
[    0.948803] xhci_hcd 0000:07:00.0: irq 46 for MSI/MSI-X
[    0.948806] xhci_hcd 0000:07:00.0: irq 47 for MSI/MSI-X
[    0.948917] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.948919] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.948921] usb usb3: Product: xHCI Host Controller
[    0.948923] usb usb3: Manufacturer: Linux 3.16.0-4-amd64 xhci_hcd
[    0.948924] usb usb3: SerialNumber: 0000:07:00.0
[    0.949133] hub 3-0:1.0: USB hub found
[    0.949144] hub 3-0:1.0: 2 ports detected
[    0.949241] xhci_hcd 0000:07:00.0: xHCI Host Controller
[    0.949245] xhci_hcd 0000:07:00.0: new USB bus registered, assigned bus number 4
[    0.949284] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.949293] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
[    0.949311] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    0.949313] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.949314] usb usb4: Product: xHCI Host Controller
[    0.949316] usb usb4: Manufacturer: Linux 3.16.0-4-amd64 xhci_hcd
[    0.949317] usb usb4: SerialNumber: 0000:07:00.0
[    0.949464] hub 4-0:1.0: USB hub found
[    0.949474] hub 4-0:1.0: 2 ports detected
[    0.949594] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 5
[    0.949615] ehci-pci 0000:00:1a.0: debug port 2
[    0.953508] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.953523] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7c38000
[    0.964578] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.964620] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    0.964622] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.964624] usb usb5: Product: EHCI Host Controller
[    0.964625] usb usb5: Manufacturer: Linux 3.16.0-4-amd64 ehci_hcd
[    0.964627] usb usb5: SerialNumber: 0000:00:1a.0
[    0.964795] hub 5-0:1.0: USB hub found
[    0.964802] hub 5-0:1.0: 2 ports detected
[    0.965017] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.965022] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    0.965035] ehci-pci 0000:00:1d.0: debug port 2
[    0.968935] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.968948] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7c37000
[    0.980570] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.980616] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[    0.980618] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.980620] usb usb6: Product: EHCI Host Controller
[    0.980621] usb usb6: Manufacturer: Linux 3.16.0-4-amd64 ehci_hcd
[    0.980623] usb usb6: SerialNumber: 0000:00:1d.0
[    0.980812] hub 6-0:1.0: USB hub found
[    0.980819] hub 6-0:1.0: 2 ports detected
[    0.980987] ahci 0000:00:1f.2: version 3.0
[    0.981108] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
[    0.996582] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    0.996587] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part ems apst 
[    1.037282] scsi0 : ahci
[    1.037572] scsi1 : ahci
[    1.037825] scsi2 : ahci
[    1.038039] scsi3 : ahci
[    1.038168] scsi4 : ahci
[    1.038400] scsi5 : ahci
[    1.038474] ata1: SATA max UDMA/133 abar m2048@0xf7c36000 port 0xf7c36100 irq 48
[    1.038476] ata2: SATA max UDMA/133 abar m2048@0xf7c36000 port 0xf7c36180 irq 48
[    1.038479] ata3: SATA max UDMA/133 abar m2048@0xf7c36000 port 0xf7c36200 irq 48
[    1.038481] ata4: SATA max UDMA/133 abar m2048@0xf7c36000 port 0xf7c36280 irq 48
[    1.038483] ata5: SATA max UDMA/133 abar m2048@0xf7c36000 port 0xf7c36300 irq 48
[    1.038485] ata6: SATA max UDMA/133 abar m2048@0xf7c36000 port 0xf7c36380 irq 48
[    1.038565] ahci 0000:01:00.0: controller can do FBS, turning on CAP_FBS
[    1.038584] ahci 0000:01:00.0: irq 49 for MSI/MSI-X
[    1.052502] ahci 0000:01:00.0: AHCI 0001.0200 32 slots 8 ports 6 Gbps 0xff impl SATA mode
[    1.052506] ahci 0000:01:00.0: flags: 64bit ncq fbs pio 
[    1.053486] scsi6 : ahci
[    1.053845] scsi7 : ahci
[    1.054140] scsi8 : ahci
[    1.054431] scsi9 : ahci
[    1.054637] scsi10 : ahci
[    1.054832] scsi11 : ahci
[    1.054990] scsi12 : ahci
[    1.055165] scsi13 : ahci
[    1.055236] ata7: SATA max UDMA/133 abar m2048@0xf7b10000 port 0xf7b10100 irq 49
[    1.055239] ata8: SATA max UDMA/133 abar m2048@0xf7b10000 port 0xf7b10180 irq 49
[    1.055241] ata9: SATA max UDMA/133 abar m2048@0xf7b10000 port 0xf7b10200 irq 49
[    1.055243] ata10: SATA max UDMA/133 abar m2048@0xf7b10000 port 0xf7b10280 irq 49
[    1.055245] ata11: SATA max UDMA/133 abar m2048@0xf7b10000 port 0xf7b10300 irq 49
[    1.055248] ata12: SATA max UDMA/133 abar m2048@0xf7b10000 port 0xf7b10380 irq 49
[    1.055250] ata13: SATA max UDMA/133 abar m2048@0xf7b10000 port 0xf7b10400 irq 49
[    1.055253] ata14: SATA max UDMA/133 abar m2048@0xf7b10000 port 0xf7b10480 irq 49
[    1.055412] ahci 0000:03:00.0: irq 50 for MSI/MSI-X
[    1.055442] ahci 0000:03:00.0: SSS flag set, parallel bus scan disabled
[    1.055514] ahci 0000:03:00.0: AHCI 0001.0200 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    1.055517] ahci 0000:03:00.0: flags: 64bit ncq sntf stag led clo pmp pio slum part ccc sxs 
[    1.055849] scsi14 : ahci
[    1.055947] scsi15 : ahci
[    1.055995] ata15: SATA max UDMA/133 abar m512@0xf7a00000 port 0xf7a00100 irq 50
[    1.055998] ata16: SATA max UDMA/133 abar m512@0xf7a00000 port 0xf7a00180 irq 50
[    1.196364] usb 1-2: new full-speed USB device number 2 using xhci_hcd
[    1.326308] usb 1-2: New USB device found, idVendor=03eb, idProduct=204b
[    1.326312] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.326314] usb 1-2: Product: CUL868
[    1.326316] usb 1-2: Manufacturer: busware.de
[    1.326488] usb 1-2: ep 0x82 - rounding interval to 1024 microframes, ep desc says 2040 microframes
[    1.356218] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.356240] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.356261] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.356283] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.356302] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.356317] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.356719] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    1.356726] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT2._GTF] (Node ffff88041f05e3d8), AE_NOT_FOUND (20140424/psparse-536)
[    1.356770] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    1.356777] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT3._GTF] (Node ffff88041f05e360), AE_NOT_FOUND (20140424/psparse-536)
[    1.356819] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    1.356826] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node ffff88041f05e450), AE_NOT_FOUND (20140424/psparse-536)
[    1.356868] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    1.356875] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT5._GTF] (Node ffff88041f05e270), AE_NOT_FOUND (20140424/psparse-536)
[    1.356904] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    1.356907] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff88041f05e4c8), AE_NOT_FOUND (20140424/psparse-536)
[    1.356938] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    1.356942] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT4._GTF] (Node ffff88041f05e2e8), AE_NOT_FOUND (20140424/psparse-536)
[    1.357019] ata3.00: ATA-9: WDC WD30EZRX-00DC0B0, 80.00A80, max UDMA/133
[    1.357026] ata3.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.357038] ata2.00: ATA-9: WDC WD30EZRX-00DC0B0, 80.00A80, max UDMA/133
[    1.357042] ata2.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.357054] ata1.00: ATA-9: WDC WD30EZRX-00DC0B0, 80.00A80, max UDMA/133
[    1.357058] ata1.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.357077] ata6.00: ATA-9: WDC WD30EFRX-68EUZN0, 80.00A80, max UDMA/133
[    1.357081] ata6.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.357090] ata4.00: ATA-9: WDC WD30EZRX-00DC0B0, 80.00A80, max UDMA/133
[    1.357092] ata4.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.357118] ata5.00: ATA-9: WDC WD30EZRX-00DC0B0, 80.00A80, max UDMA/133
[    1.357120] ata5.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.357573] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    1.357580] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff88041f05e4c8), AE_NOT_FOUND (20140424/psparse-536)
[    1.357624] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    1.357631] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT3._GTF] (Node ffff88041f05e360), AE_NOT_FOUND (20140424/psparse-536)
[    1.357673] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    1.357679] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT5._GTF] (Node ffff88041f05e270), AE_NOT_FOUND (20140424/psparse-536)
[    1.357722] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    1.357728] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node ffff88041f05e450), AE_NOT_FOUND (20140424/psparse-536)
[    1.357762] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    1.357765] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT4._GTF] (Node ffff88041f05e2e8), AE_NOT_FOUND (20140424/psparse-536)
[    1.357791] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140424/psargs-359)
[    1.357795] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT2._GTF] (Node ffff88041f05e3d8), AE_NOT_FOUND (20140424/psparse-536)
[    1.357861] ata1.00: configured for UDMA/133
[    1.357893] ata4.00: configured for UDMA/133
[    1.357905] ata5.00: configured for UDMA/133
[    1.357917] ata6.00: configured for UDMA/133
[    1.358044] ata3.00: configured for UDMA/133
[    1.358064] scsi 0:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00D 0A80 PQ: 0 ANSI: 5
[    1.358541] ata2.00: configured for UDMA/133
[    1.358723] scsi 1:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00D 0A80 PQ: 0 ANSI: 5
[    1.359128] scsi 2:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00D 0A80 PQ: 0 ANSI: 5
[    1.359456] scsi 3:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00D 0A80 PQ: 0 ANSI: 5
[    1.359800] scsi 4:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00D 0A80 PQ: 0 ANSI: 5
[    1.360049] scsi 5:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68E 0A80 PQ: 0 ANSI: 5
[    1.372178] ata11: SATA link down (SStatus 0 SControl 300)
[    1.372200] ata13: SATA link down (SStatus 0 SControl 300)
[    1.372231] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.372246] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.372260] ata12: SATA link down (SStatus 0 SControl 300)
[    1.380195] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.492056] usb 3-2: new full-speed USB device number 2 using xhci_hcd
[    1.512046] tsc: Refined TSC clocksource calibration: 3410.015 MHz
[    1.540018] ata9: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.544039] ata15: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.544691] ata15.00: ATA-9: WDC WD30EFRX-68EUZN0, 80.00A80, max UDMA/133
[    1.544695] ata15.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.545379] ata15.00: configured for UDMA/133
[    1.719826] ata14.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[    1.719985] ata14.00: configured for UDMA/66
[    1.720664] ata7.00: ATA-9: WDC WD30EURX-63T0FY0, 80.00A80, max UDMA/133
[    1.720668] ata7.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.720694] ata9.00: ATA-9: WDC WD30EFRX-68EUZN0, 80.00A80, max UDMA/133
[    1.720696] ata9.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.720709] ata8.00: ATA-9: WDC WD30EFRX-68EUZN0, 80.00A80, max UDMA/133
[    1.720714] ata8.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.721648] ata7.00: configured for UDMA/133
[    1.721667] ata8.00: configured for UDMA/133
[    1.721686] ata9.00: configured for UDMA/133
[    1.721839] scsi 6:0:0:0: Direct-Access     ATA      WDC WD30EURX-63T 0A80 PQ: 0 ANSI: 5
[    1.722381] scsi 7:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68E 0A80 PQ: 0 ANSI: 5
[    1.722873] scsi 8:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68E 0A80 PQ: 0 ANSI: 5
[    1.763794] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.764531] ata10.00: ATA-9: WDC WD30EFRX-68EUZN0, 80.00A80, max UDMA/133
[    1.764535] ata10.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.764794] usb 3-2: New USB device found, idVendor=05ac, idProduct=1002
[    1.764799] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.764801] usb 3-2: Product: Hub in Apple Extended USB Keyboard
[    1.764803] usb 3-2: Manufacturer: Mitsumi Electric
[    1.764923] usb 3-2: ep 0x81 - rounding interval to 1024 microframes, ep desc says 2040 microframes
[    1.765260] ata10.00: configured for UDMA/133
[    1.765374] scsi 9:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68E 0A80 PQ: 0 ANSI: 5
[    1.765595] hub 3-2:1.0: USB hub found
[    1.765731] scsi 13:0:0:0: Processor         Marvell  Console          1.01 PQ: 0 ANSI: 5
[    1.765733] hub 3-2:1.0: 3 ports detected
[    1.779791] ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[    1.779855] ata14.00: irq_stat 0x40000001
[    1.779904] scsi 13:0:0:0: CDB: 
[    1.779906] Inquiry: 12 01 00 00 ff 00
[    1.779915] ata14.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 3 dma 16640 in
         res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)
[    1.779985] ata14: hard resetting link
[    1.875705] usb 5-1: new high-speed USB device number 2 using ehci-pci
[    2.007947] usb 5-1: New USB device found, idVendor=8087, idProduct=0024
[    2.007951] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.008264] hub 5-1:1.0: USB hub found
[    2.008435] hub 5-1:1.0: 6 ports detected
[    2.107474] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.107731] ata14.00: configured for UDMA/66
[    2.107786] ata14: EH complete
[    2.108191] scsi 14:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68E 0A80 PQ: 0 ANSI: 5
[    2.119439] usb 6-1: new high-speed USB device number 2 using ehci-pci
[    2.251713] usb 6-1: New USB device found, idVendor=8087, idProduct=0024
[    2.251717] usb 6-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.252018] hub 6-1:1.0: USB hub found
[    2.252196] hub 6-1:1.0: 8 ports detected
[    2.323238] usb 3-2.1: new full-speed USB device number 3 using xhci_hcd
[    2.500108] usb 3-2.1: New USB device found, idVendor=05ac, idProduct=0205
[    2.500112] usb 3-2.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[    2.500114] usb 3-2.1: Product: Apple Extended USB Keyboard
[    2.500116] usb 3-2.1: Manufacturer: Mitsumi Electric
[    2.500306] usb 3-2.1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    2.500314] usb 3-2.1: ep 0x82 - rounding interval to 1024 microframes, ep desc says 2040 microframes
[    2.502369] hidraw: raw HID events driver (C) Jiri Kosina
[    2.503906] usbcore: registered new interface driver usbhid
[    2.503909] usbhid: USB HID core driver
[    2.507015] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    2.507074] scsi 1:0:0:0: Attached scsi generic sg1 type 0
[    2.507138] scsi 2:0:0:0: Attached scsi generic sg2 type 0
[    2.507171] input: Mitsumi Electric Apple Extended USB Keyboard as /devices/pci0000:00/0000:00:1c.7/0000:07:00.0/usb3/3-2/3-2.1/3-2.1:1.0/0003:05AC:0205.0001/input/input2
[    2.507176] scsi 3:0:0:0: Attached scsi generic sg3 type 0
[    2.507215] scsi 4:0:0:0: Attached scsi generic sg4 type 0
[    2.507285] scsi 5:0:0:0: Attached scsi generic sg5 type 0
[    2.507295] hid-generic 0003:05AC:0205.0001: input,hidraw0: USB HID v1.10 Keyboard [Mitsumi Electric Apple Extended USB Keyboard] on usb-0000:07:00.0-2.1/input0
[    2.507353] scsi 6:0:0:0: Attached scsi generic sg6 type 0
[    2.507397] scsi 7:0:0:0: Attached scsi generic sg7 type 0
[    2.507453] scsi 8:0:0:0: Attached scsi generic sg8 type 0
[    2.507504] scsi 9:0:0:0: Attached scsi generic sg9 type 0
[    2.507606] scsi 13:0:0:0: Attached scsi generic sg10 type 3
[    2.507689] scsi 14:0:0:0: Attached scsi generic sg11 type 0
[    2.507754] input: Mitsumi Electric Apple Extended USB Keyboard as /devices/pci0000:00/0000:00:1c.7/0000:07:00.0/usb3/3-2/3-2.1/3-2.1:1.1/0003:05AC:0205.0002/input/input3
[    2.508533] sd 0:0:0:0: [sda] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.508536] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    2.508586] sd 2:0:0:0: [sdc] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.508589] sd 0:0:0:0: [sda] Write Protect is off
[    2.508590] sd 2:0:0:0: [sdc] 4096-byte physical blocks
[    2.508594] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.508616] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.508623] sd 3:0:0:0: [sdd] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.508626] sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    2.508655] sd 4:0:0:0: [sde] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.508657] sd 4:0:0:0: [sde] 4096-byte physical blocks
[    2.508676] sd 1:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.508678] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    2.508793] sd 4:0:0:0: [sde] Write Protect is off
[    2.508796] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    2.508804] sd 3:0:0:0: [sdd] Write Protect is off
[    2.508806] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.508827] sd 2:0:0:0: [sdc] Write Protect is off
[    2.508830] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.508848] sd 1:0:0:0: [sdb] Write Protect is off
[    2.508850] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.508878] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.508903] sd 6:0:0:0: [sdg] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.508906] sd 6:0:0:0: [sdg] 4096-byte physical blocks
[    2.508931] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.508952] sd 6:0:0:0: [sdg] Write Protect is off
[    2.508955] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    2.508975] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.508997] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.509013] hid-generic 0003:05AC:0205.0002: input,hidraw1: USB HID v1.10 Device [Mitsumi Electric Apple Extended USB Keyboard] on usb-0000:07:00.0-2.1/input1
[    2.509057] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.509065] sd 5:0:0:0: [sdf] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.509068] sd 5:0:0:0: [sdf] 4096-byte physical blocks
[    2.509113] sd 5:0:0:0: [sdf] Write Protect is off
[    2.509116] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    2.509136] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.509385] sd 7:0:0:0: [sdh] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.509388] sd 7:0:0:0: [sdh] 4096-byte physical blocks
[    2.509415] sd 8:0:0:0: [sdi] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.509417] sd 8:0:0:0: [sdi] 4096-byte physical blocks
[    2.509433] sd 9:0:0:0: [sdj] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.509435] sd 9:0:0:0: [sdj] 4096-byte physical blocks
[    2.509446] sd 14:0:0:0: [sdk] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.509448] sd 14:0:0:0: [sdk] 4096-byte physical blocks
[    2.509467] sd 8:0:0:0: [sdi] Write Protect is off
[    2.509469] sd 8:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[    2.509491] sd 8:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.509502] sd 9:0:0:0: [sdj] Write Protect is off
[    2.509505] sd 9:0:0:0: [sdj] Mode Sense: 00 3a 00 00
[    2.509532] sd 9:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.509596] sd 14:0:0:0: [sdk] Write Protect is off
[    2.509599] sd 14:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[    2.509619] sd 14:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.509708] sd 7:0:0:0: [sdh] Write Protect is off
[    2.509711] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    2.509731] sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.511638]  sdh: unknown partition table
[    2.511826] sd 7:0:0:0: [sdh] Attached SCSI disk
[    2.512765] Switched to clocksource tsc
[    2.517411]  sdk: unknown partition table
[    2.518079] sd 14:0:0:0: [sdk] Attached SCSI disk
[    2.519040]  sdj: unknown partition table
[    2.519475] sd 9:0:0:0: [sdj] Attached SCSI disk
[    2.522043]  sdg: unknown partition table
[    2.522436] sd 6:0:0:0: [sdg] Attached SCSI disk
[    2.523428]  sdi: unknown partition table
[    2.523676] sd 8:0:0:0: [sdi] Attached SCSI disk
[    2.525166]  sdb: sdb1
[    2.525425]  sdc: sdc1
[    2.525443] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.525557]  sdd: sdd1
[    2.525787] sd 3:0:0:0: [sdd] Attached SCSI disk
[    2.525954] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.531037]  sde: sde1
[    2.531313] sd 4:0:0:0: [sde] Attached SCSI disk
[    2.532607]  sda: sda1
[    2.532850] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.536792]  sdf: unknown partition table
[    2.537134] sd 5:0:0:0: [sdf] Attached SCSI disk
[    2.565514] random: nonblocking pool is initialized
[    2.599020] ata16: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.599966] ata16.00: failed to get NCQ Send/Recv Log Emask 0x1
[    2.599970] ata16.00: ATA-9: Samsung SSD 840 PRO Series, DXM03B0Q, max UDMA/133
[    2.599972] ata16.00: 250069680 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.600381] ata16.00: failed to get NCQ Send/Recv Log Emask 0x1
[    2.600446] ata16.00: configured for UDMA/133
[    2.600647] scsi 15:0:0:0: Direct-Access     ATA      Samsung SSD 840  3B0Q PQ: 0 ANSI: 5
[    2.600884] sd 15:0:0:0: [sdl] 250069680 512-byte logical blocks: (128 GB/119 GiB)
[    2.600961] sd 15:0:0:0: Attached scsi generic sg12 type 0
[    2.601059] sd 15:0:0:0: [sdl] Write Protect is off
[    2.601063] sd 15:0:0:0: [sdl] Mode Sense: 00 3a 00 00
[    2.601129] sd 15:0:0:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.601754]  sdl: sdl1 sdl2 < sdl5 >
[    2.602212] sd 15:0:0:0: [sdl] Attached SCSI disk
[    2.726447] md: md0 stopped.
[    2.727240]  sdh: unknown partition table
[    2.727806] md: bind<sdb>
[    2.727893]  sdf: unknown partition table
[    2.728016] md: bind<sdc>
[    2.728172] md: bind<sdd>
[    2.728315] md: bind<sde>
[    2.728672]  sdk: unknown partition table
[    2.728789] md: bind<sdk>
[    2.728988] md: bind<sdi>
[    2.729145] md: bind<sdh>
[    2.729483]  sdj: unknown partition table
[    2.729606] md: bind<sdj>
[    2.729741] md: bind<sdf>
[    2.729849] md: bind<sdg>
[    2.730016] md: bind<sda>
[    2.730276]  sdi: unknown partition table
[    2.730682]  sda: sda1
[    2.731314]  sdc: sdc1
[    2.731843]  sdb: sdb1
[    2.732318]  sde: sde1
[    2.732934]  sdg: unknown partition table
[    2.733320]  sdd: sdd1
[    2.798757] raid6: sse2x1    6271 MB/s
[    2.866691] raid6: sse2x2    9717 MB/s
[    2.934624] raid6: sse2x4   13709 MB/s
[    2.934625] raid6: using algorithm sse2x4 (13709 MB/s)
[    2.934626] raid6: using ssse3x2 recovery algorithm
[    2.934830]  sdc: sdc1
[    2.934831] xor: automatically using best checksumming function:
[    2.974582]    avx       : 28639.000 MB/sec
[    2.974813]  sdd: sdd1
[    2.974827] async_tx: api initialized (async)
[    2.975305]  sde: sde1
[    2.975537] md: raid6 personality registered for level 6
[    2.975539] md: raid5 personality registered for level 5
[    2.975539] md: raid4 personality registered for level 4
[    2.975710] md/raid:md0: device sda operational as raid disk 0
[    2.975711] md/raid:md0: device sdj operational as raid disk 8
[    2.975712] md/raid:md0: device sdh operational as raid disk 7
[    2.975713] md/raid:md0: device sdi operational as raid disk 6
[    2.975713] md/raid:md0: device sdk operational as raid disk 5
[    2.975714] md/raid:md0: device sde operational as raid disk 4
[    2.975714] md/raid:md0: device sdd operational as raid disk 3
[    2.975715] md/raid:md0: device sdc operational as raid disk 2
[    2.975716] md/raid:md0: device sdb operational as raid disk 1
[    2.975833]  sdk: unknown partition table
[    2.976028] md/raid:md0: allocated 0kB
[    2.976039] md/raid:md0: raid level 6 active with 9 out of 9 devices, algorithm 2
[    2.976040] RAID conf printout:
[    2.976040]  --- level:6 rd:9 wd:9
[    2.976041]  disk 0, o:1, dev:sda
[    2.976042]  disk 1, o:1, dev:sdb
[    2.976042]  disk 2, o:1, dev:sdc
[    2.976043]  disk 3, o:1, dev:sdd
[    2.976043]  disk 4, o:1, dev:sde
[    2.976044]  disk 5, o:1, dev:sdk
[    2.976045]  disk 6, o:1, dev:sdi
[    2.976045]  disk 7, o:1, dev:sdh
[    2.976046]  disk 8, o:1, dev:sdj
[    2.976066] md0: detected capacity change from 0 to 21003211177984
[    2.976227]  sdi: unknown partition table
[    2.976618]  sdj: unknown partition table
[    2.976992]  sdf: unknown partition table
[    2.983173]  md0: unknown partition table
[    2.988107]  sdg: unknown partition table
[    2.988444]  sda: sda1
[    3.011817] Btrfs loaded
[    3.109157] PM: Starting manual resume from disk
[    3.109159] PM: Hibernation image partition 8:181 present
[    3.109160] PM: Looking for hibernation image.
[    3.109297] PM: Image not found (code -22)
[    3.109298] PM: Hibernation image not present or could not be loaded.
[    3.206186] EXT4-fs (sdl1): mounted filesystem with ordered data mode. Opts: (null)
[    3.328306] systemd[1]: [/lib/systemd/system/sec.service:1] Assignment outside of section. Ignoring.
[    3.328318] systemd[1]: [/lib/systemd/system/sec.service:2] Assignment outside of section. Ignoring.
[    3.332210] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory.
[    3.347760] lp: driver loaded but no devices found
[    3.349015] ppdev: user-space parallel port driver
[    3.352060] fuse init (API version 7.23)
[    3.359856] systemd-udevd[294]: starting version 215
[    3.408217] EDAC MC: Ver: 3.0.0
[    3.408786] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.409174] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input4
[    3.409178] ACPI: Power Button [PWRB]
[    3.409216] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[    3.409217] ACPI: Power Button [PWRF]
[    3.409320] EDAC ie31200: No ECC support
[    3.410626] wmi: Mapper loaded
[    3.417336] [drm] Initialized drm 1.1.0 20060810
[    3.426170] mei_me 0000:00:16.0: irq 51 for MSI/MSI-X
[    3.442988] [drm] Memory usable by graphics device = 2048M
[    3.442992] [drm] Replacing VGA console driver
[    3.443911] Console: switching to colour dummy device 80x25
[    3.446315] EXT4-fs (sdl1): re-mounted. Opts: errors=remount-ro
[    3.450762] cfg80211: Calling CRDA to update world regulatory domain
[    3.453725] cdc_acm 1-2:1.0: ttyACM0: USB ACM device
[    3.454403] usbcore: registered new interface driver cdc_acm
[    3.454404] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    3.464854] ath: phy0: Disable PLL PowerSave
[    3.466147] i915 0000:00:02.0: irq 52 for MSI/MSI-X
[    3.466156] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    3.466157] [drm] Driver supports precise vblank timestamp query.
[    3.466231] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    3.473114] ath: EEPROM regdomain: 0x60
[    3.473116] ath: EEPROM indicates we should expect a direct regpair map
[    3.473117] ath: Country alpha2 being used: 00
[    3.473118] ath: Regpair used: 0x60
[    3.473605] systemd-journald[288]: Received request to flush runtime journal from PID 1
[    3.485643] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    3.485795] ieee80211 phy0: Atheros AR9485 Rev:1 mem=0xffffc90016280000, irq=18
[    3.515792] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    3.519496] fbcon: inteldrmfb (fb0) is primary device
[    3.523234] AVX version of gcm_enc/dec engaged.
[    3.526131] Adding 5105660k swap on /dev/sdl5.  Priority:-1 extents:1 across:5105660k SSFS
[    3.526426] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    3.537561] asus_wmi: ASUS WMI generic driver loaded
[    3.537687] alg: No test for crc32 (crc32-pclmul)
[    3.538041] asus_wmi: Initialization: 0x0
[    3.538052] asus_wmi: BIOS WMI version: 0.9
[    3.538073] asus_wmi: SFUN value: 0x0
[    3.538250] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/input/input8
[    3.538958] asus_wmi: Backlight controlled by ACPI video driver
[    3.545229] intel_rapl: Found RAPL domain package
[    3.545230] intel_rapl: Found RAPL domain core
[    3.545238] intel_rapl: Found RAPL domain uncore
[    3.553089] Console: switching to colour frame buffer device 210x65
[    3.553129] [drm:cpt_set_fifo_underrun_reporting] *ERROR* uncleared pch fifo underrun on pch transcoder A
[    3.553130] [drm:cpt_serr_int_handler] *ERROR* PCH transcoder A FIFO underrun
[    3.555814] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.555815] i915 0000:00:02.0: registered panic notifier
[    3.556813] cfg80211: World regulatory domain updated:
[    3.556815] cfg80211:  DFS Master region: unset
[    3.556816] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    3.556817] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    3.556818] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    3.556819] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    3.556820] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[    3.556822] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[    3.556822] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    3.556823] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    3.556824] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    3.586222] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    3.586340] acpi device:4d: registered as cooling_device10
[    3.586399] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input9
[    3.586484] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.586723] snd_hda_intel 0000:00:1b.0: irq 53 for MSI/MSI-X
[    3.586782] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042F conflicts with OpRegion 0x0000000000000400-0x000000000000047F (\PMIO) (20140424/utaddress-254)
[    3.586786] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.586789] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054F conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140424/utaddress-254)
[    3.586791] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054F conflicts with OpRegion 0x0000000000000500-0x000000000000057F (\_SB_.PCI0.LPCB.GPBX) (20140424/utaddress-254)
[    3.586793] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.586794] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053F conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140424/utaddress-254)
[    3.586795] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053F conflicts with OpRegion 0x0000000000000500-0x000000000000057F (\_SB_.PCI0.LPCB.GPBX) (20140424/utaddress-254)
[    3.586797] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.586798] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052F conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140424/utaddress-254)
[    3.586800] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052F conflicts with OpRegion 0x0000000000000500-0x000000000000057F (\_SB_.PCI0.LPCB.GPBX) (20140424/utaddress-254)
[    3.586801] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.586802] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    3.586863] ACPI Warning: SystemIO range 0x000000000000F040-0x000000000000F05F conflicts with OpRegion 0x000000000000F040-0x000000000000F04F (\_SB_.PCI0.SBUS.SMBI) (20140424/utaddress-254)
[    3.586867] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.588275] iTCO_vendor_support: vendor-support=0
[    3.588540] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    3.588562] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
[    3.588646] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    3.600702] sound hdaudioC0D0: autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
[    3.600704] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.600705] sound hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    3.600706] sound hdaudioC0D0:    mono: mono_out=0x0
[    3.600707] sound hdaudioC0D0:    dig-out=0x11/0x1e
[    3.600707] sound hdaudioC0D0:    inputs:
[    3.600709] sound hdaudioC0D0:      Front Mic=0x19
[    3.600710] sound hdaudioC0D0:      Rear Mic=0x18
[    3.600711] sound hdaudioC0D0:      Line=0x1a
[    3.606329] RPC: Registered named UNIX socket transport module.
[    3.606330] RPC: Registered udp transport module.
[    3.606331] RPC: Registered tcp transport module.
[    3.606331] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.608047] FS-Cache: Loaded
[    3.612305] FS-Cache: Netfs 'nfs' registered for caching
[    3.615717] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    3.615757] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    3.615793] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    3.616814] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    3.616867] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    3.616971] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[    3.617009] input: HDA Intel PCH Line Out Side as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[    3.617048] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
[    3.617285] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
[    3.617321] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input19
[    3.617662] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    3.705297] vboxdrv: Found 4 processor cores.
[    3.705624] vboxdrv: fAsync=0 offMin=0x1ba offMax=0xa71
[    3.705670] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[    3.705671] vboxdrv: Successfully loaded version 4.3.36_Debian (interface 0x001a000b).
[    3.724364] tun: Universal TUN/TAP device driver, 1.6
[    3.724366] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.743790] vboxpci: IOMMU not found (not registered)
[    3.984194] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    4.085569] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[    4.085680] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.101774] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    4.300081] aufs: module is from the staging directory, the quality is unknown, you have been warned.
[    4.300931] aufs 3.16-20140908
[    4.758378] Bridge firewalling registered
[    4.760238] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    4.766826] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready
[    4.771633] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.853170] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    4.942042] aufs au_opts_verify:1570:docker[1165]: dirperm1 breaks the protection by the permission bits on the lower branch
[    4.974806] aufs au_opts_verify:1570:docker[1165]: dirperm1 breaks the protection by the permission bits on the lower branch
[    5.016677] aufs au_opts_verify:1570:docker[1165]: dirperm1 breaks the protection by the permission bits on the lower branch
[    5.068675] aufs au_opts_verify:1570:docker[1165]: dirperm1 breaks the protection by the permission bits on the lower branch
[    5.084412] auplink[1455]: segfault at 7ffdacd9fc18 ip 00007fa5b5eb7029 sp 00007ffdacd9fc20 error 6 in libc-2.19.so[7fa5b5dd9000+1a2000]
[    5.122394] aufs au_opts_verify:1570:docker[1165]: dirperm1 breaks the protection by the permission bits on the lower branch
[    5.170273] device vethf5b8b05 entered promiscuous mode
[    5.170306] IPv6: ADDRCONF(NETDEV_UP): vethf5b8b05: link is not ready
[    5.170309] docker0: port 1(vethf5b8b05) entered forwarding state
[    5.170314] docker0: port 1(vethf5b8b05) entered forwarding state
[    5.193125] IPv6: ADDRCONF(NETDEV_CHANGE): docker0: link becomes ready
[    5.207285] IPv6: ADDRCONF(NETDEV_CHANGE): vethf5b8b05: link becomes ready
[    5.238220] aufs au_opts_verify:1570:docker[1400]: dirperm1 breaks the protection by the permission bits on the lower branch
[    6.948769] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[    6.948806] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   20.169862] docker0: port 1(vethf5b8b05) entered forwarding state
[  139.718688] device-mapper: uevent: version 1.0.3
[  139.718771] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[  151.093932] NET: Registered protocol family 38
[  151.903401] sha256_ssse3: Using AVX optimized SHA-256 implementation
[  151.970916] BTRFS: device fsid 9868d803-78d1-40c3-b1ee-a4ce3363df87 devid 1 transid 1322969 /dev/dm-0
[  163.105784] BTRFS info (device dm-0): disk space caching is enabled
[  165.304968] BTRFS: bad tree block start 4530277753793296986 36340960788480
[  165.305233] BTRFS: bad tree block start 4530277753793296986 36340960788480
[  165.305281] BTRFS: failed to read chunk tree on dm-0
[  165.331407] BTRFS: open_ctree failed

--rekcebs-ae00360e-beeb-47d3-9d7d-bafe2856fae9--
