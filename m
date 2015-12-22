Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:33903 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbbLVCwr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 21:52:47 -0500
Received: by mail-qk0-f173.google.com with SMTP id p187so144506112qkd.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Dec 2015 18:52:46 -0800 (PST)
Received: from [192.168.69.110] (cpe-142-105-3-123.nyc.res.rr.com. [142.105.3.123])
        by smtp.gmail.com with ESMTPSA id h64sm5862647qgh.39.2015.12.21.18.52.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 21 Dec 2015 18:52:45 -0800 (PST)
From: Asif Youssuff <yoasif@gmail.com>
Content-Type: multipart/mixed; boundary="Apple-Mail=_A7E3863F-5E50-4932-8C85-A0FEF7D5136A"
Subject: kernel BUG at /home/kernel/COD/linux/fs/btrfs/volumes.c:5508
Message-Id: <132F2A21-2762-4EC7-9048-E9F26DB09F62@gmail.com>
Date: Mon, 21 Dec 2015 21:52:43 -0500
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_A7E3863F-5E50-4932-8C85-A0FEF7D5136A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi guys,

Have a nasty issue to report here. I have a RAID10 btrfs configuration =
where I was replacing one disk for another. Unfortunately, during the =
replace, it seems like one of my disks (not in the array) stopped =
getting powered (looks like the cable was loose) and caused the machine =
to lock up.

Since then, I have not been able to boot normally with the array in =
fstab. I=E2=80=99ve passed along =E2=80=9Crecovery=E2=80=9D in my fstab =
line and have taken to editing in the fstab line to mount, then =
immediately commenting the line out (otherwise, the machine will not =
boot successfully; it=E2=80=99s a headless box, so this is painful).=20

It seems to try to continue the replace, but dies shortly after mounting =
with

kernel BUG at /home/kernel/COD/linux/fs/btrfs/volumes.c:5508

uname -a
Linux ubuntu-server 4.4.0-040400rc6-generic #201512202030 SMP Mon Dec 21 =
01:32:09 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

btrfs --version
btrfs-progs v4.0

btrfs fi show
Label: none  uuid: 48ed8a66-731d-499b-829e-dd07dd7260cc
        Total devices 9 FS bytes used 14.59TiB
        devid    0 size 4.55TiB used 3.16TiB path /dev/sde
        devid    1 size 4.55TiB used 3.16TiB path /dev/sdn
        devid    4 size 5.46TiB used 4.07TiB path /dev/sdh
        devid    5 size 5.46TiB used 4.07TiB path /dev/sdi
        devid    7 size 5.46TiB used 4.07TiB path /dev/sdm
        devid    8 size 5.46TiB used 4.07TiB path /dev/sdl
        devid    9 size 5.46TiB used 4.07TiB path /dev/sdg
        devid   10 size 5.46TiB used 4.07TiB path /dev/sdj
        devid   11 size 5.46TiB used 1.63TiB path /dev/sdk
       =20
btrfs fi df /media/camino/
Data, RAID10: total=3D14.57TiB, used=3D14.57TiB
System, RAID10: total=3D64.00MiB, used=3D1.28MiB
Metadata, RAID10: total=3D25.47GiB, used=3D23.80GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

dmesg output attached.=20


--Apple-Mail=_A7E3863F-5E50-4932-8C85-A0FEF7D5136A
Content-Disposition: attachment;
	filename=dmesg.log
Content-Type: application/octet-stream;
	name="dmesg.log"
Content-Transfer-Encoding: 7bit

 dmesg -w
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.4.0-040400rc6-generic (kernel@tangerine) (gcc version 5.2.1 20151010 (Ubuntu 5.2.1-22ubuntu2) ) #201512202030 SMP Mon Dec 21 01:32:09 UTC 2015
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.4.0-040400rc6-generic root=/dev/mapper/ubuntu--server--vg-root ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Supporting XSAVE feature 0x01: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x02: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x04: 'AVX registers'
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000099bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000099c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cd4fbfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cd4fc000-0x00000000cd502fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cd503000-0x00000000dd7f1fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dd7f2000-0x00000000dd8d8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dd8d9000-0x00000000dd924fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dd925000-0x00000000dda5bfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dda5c000-0x00000000df7fefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000df7ff000-0x00000000df7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000081fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 04/24/2015
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x820000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7800000000 write-back
[    0.000000]   1 base 0800000000 mask 7FE0000000 write-back
[    0.000000]   2 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 32GB, type WB
[    0.000000] reg 1, base: 32GB, range: 512MB, type WB
[    0.000000] reg 2, base: 3584MB, range: 512MB, type UC
[    0.000000] total RAM covered: 32768M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 7  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 512MB, type WB
[    0.000000] reg 3, base: 4GB, range: 4GB, type WB
[    0.000000] reg 4, base: 8GB, range: 8GB, type WB
[    0.000000] reg 5, base: 16GB, range: 16GB, type WB
[    0.000000] reg 6, base: 32GB, range: 512MB, type WB
[    0.000000] e820: update [mem 0xe0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdf800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd720-0x000fd72f] mapped at [ffff8800000fd720]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000093000] 93000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x021f6000, 0x021f6fff] PGTABLE
[    0.000000] BRK [0x021f7000, 0x021f7fff] PGTABLE
[    0.000000] BRK [0x021f8000, 0x021f8fff] PGTABLE
[    0.000000] BRK [0x021f9000, 0x021f9fff] PGTABLE
[    0.000000] BRK [0x021fa000, 0x021fafff] PGTABLE
[    0.000000] BRK [0x021fb000, 0x021fbfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x34444000-0x36219fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 SUPERM)
[    0.000000] ACPI: XSDT 0x00000000DDA2D0A0 0000C4 (v01 SUPERM SMCI--MB 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DDA3C9A0 00010C (v05 SUPERM SMCI--MB 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000DDA2D200 00F799 (v02 SUPERM SMCI--MB 00000000 INTL 20120711)
[    0.000000] ACPI: FACS 0x00000000DDA5BF80 000040
[    0.000000] ACPI: APIC 0x00000000DDA3CAB0 000092 (v03 SUPERM SMCI--MB 01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000DDA3CB48 000044 (v01 SUPERM SMCI--MB 01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x00000000DDA3CB90 00009C (v01 SUPERM SMCI--MB 01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x00000000DDA3CC30 000C7D (v02 Ther_R Ther_Rvp 00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DDA3D8B0 000540 (v02 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000DDA3DDF0 000B74 (v02 CpuRef CpuSsdt  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000DDA3E968 0002F2 (v02 PmRef  Cpu0Tst  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000DDA3EC60 000348 (v02 PmRef  ApTst    00003000 INTL 20051117)
[    0.000000] ACPI: MCFG 0x00000000DDA3EFA8 00003C (v01 SUPERM SMCI--MB 01072009 MSFT 00000097)
[    0.000000] ACPI: PRAD 0x00000000DDA3EFE8 0000CE (v02 PRADID PRADTID  00000001 MSFT 03000001)
[    0.000000] ACPI: HPET 0x00000000DDA3F0B8 000038 (v01 SUPERM SMCI--MB 01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000DDA3F0F0 000397 (v01 SataRe SataTabl 00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DDA3F488 0057F6 (v02 SaSsdt SaSsdt   00003000 INTL 20120711)
[    0.000000] ACPI: SPMI 0x00000000DDA44C80 000040 (v05 A M I  OEMSPMI  00000000 AMI. 00000000)
[    0.000000] ACPI: DMAR 0x00000000DDA44CC0 000080 (v01 INTEL  BDW      00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 0x00000000DDA44D40 000130 (v01 AMI    AMI EINJ 00000000      00000000)
[    0.000000] ACPI: ERST 0x00000000DDA44E70 000230 (v01 AMIER  AMI ERST 00000000      00000000)
[    0.000000] ACPI: HEST 0x00000000DDA450A0 0000A8 (v01 AMI    AMI HEST 00000000      00000000)
[    0.000000] ACPI: BERT 0x00000000DDA45148 000030 (v01 AMI    AMI BERT 00000000      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000081fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x81fff9000-0x81fffcfff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000081fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000098fff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000cd4fbfff]
[    0.000000]   node   0: [mem 0x00000000cd503000-0x00000000dd7f1fff]
[    0.000000]   node   0: [mem 0x00000000dd8d9000-0x00000000dd924fff]
[    0.000000]   node   0: [mem 0x00000000df7ff000-0x00000000df7fffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000081fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000081fffffff]
[    0.000000] On node 0 totalpages: 8378320
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3992 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14113 pages used for memmap
[    0.000000]   DMA32 zone: 903224 pages, LIFO batch:31
[    0.000000]   Normal zone: 116736 pages used for memmap
[    0.000000]   Normal zone: 7471104 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00099000-0x00099fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcd4fc000-0xcd502fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd7f2000-0xdd8d8fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd925000-0xdda5bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdda5c000-0xdf7fefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf800000-0xf7ffffff]
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
[    0.000000] e820: [mem 0xdf800000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 33 pages/cpu @ffff88081fc00000 s97496 r8192 d29480 u262144
[    0.000000] pcpu-alloc: s97496 r8192 d29480 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 8247386
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.4.0-040400rc6-generic root=/dev/mapper/ubuntu--server--vg-root ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 32872544K/33513280K available (8198K kernel code, 1262K rwdata, 3948K rodata, 1460K init, 1292K bss, 640736K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=8
[    0.000000] NR_IRQS:16640 nr_irqs:488 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3400.276 MHz processor
[    0.000021] Calibrating delay loop (skipped), value calculated using timer frequency.. 6800.55 BogoMIPS (lpj=13601104)
[    0.000026] pid_max: default: 32768 minimum: 301
[    0.000031] ACPI: Core revision 20150930
[    0.011598] ACPI: 8 ACPI AML tables successfully acquired and loaded
[    0.011614] Security Framework initialized
[    0.011616] Yama: becoming mindful.
[    0.011623] AppArmor: AppArmor initialized
[    0.012922] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.017027] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.018762] Mount-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.018786] Mountpoint-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.019007] Initializing cgroup subsys io
[    0.019011] Initializing cgroup subsys memory
[    0.019016] Initializing cgroup subsys devices
[    0.019019] Initializing cgroup subsys freezer
[    0.019022] Initializing cgroup subsys net_cls
[    0.019025] Initializing cgroup subsys perf_event
[    0.019028] Initializing cgroup subsys net_prio
[    0.019031] Initializing cgroup subsys hugetlb
[    0.019034] Initializing cgroup subsys pids
[    0.019051] CPU: Physical Processor ID: 0
[    0.019053] CPU: Processor Core ID: 0
[    0.019058] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.019060] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.019795] mce: CPU supports 9 MCE banks
[    0.019807] CPU0: Thermal monitoring enabled (TM1)
[    0.019815] process: using mwait in idle threads
[    0.019819] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.019821] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.020078] Freeing SMP alternatives memory: 28K (ffffffff820aa000 - ffffffff820b1000)
[    0.021742] ftrace: allocating 31491 entries in 124 pages
[    0.031035] DMAR: Host address width 39
[    0.031038] DMAR: DRHD base: 0x000000fed90000 flags: 0x1
[    0.031045] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap d2008c20660462 ecap f010da
[    0.031048] DMAR: RMRR base: 0x000000df695000 end: 0x000000df6a3fff
[    0.031051] DMAR-IR: IOAPIC id 8 under DRHD base  0xfed90000 IOMMU 0
[    0.031053] DMAR-IR: HPET id 0 under DRHD base 0xfed90000
[    0.031056] DMAR-IR: x2apic is disabled because BIOS sets x2apic opt out bit.
[    0.031057] DMAR-IR: Use 'intremap=no_x2apic_optout' to override the BIOS setting.
[    0.031208] DMAR-IR: Enabled IRQ remapping in xapic mode
[    0.031210] x2apic: IRQ remapping doesn't support X2APIC mode
[    0.031626] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.071319] TSC deadline timer enabled
[    0.071321] smpboot: CPU0: Intel(R) Xeon(R) CPU E3-1231 v3 @ 3.40GHz (family: 0x6, model: 0x3c, stepping: 0x3)
[    0.071344] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.071362] ... version:                3
[    0.071363] ... bit width:              48
[    0.071365] ... generic registers:      4
[    0.071367] ... value mask:             0000ffffffffffff
[    0.071369] ... max period:             0000ffffffffffff
[    0.071371] ... fixed-purpose events:   3
[    0.071372] ... event mask:             000000070000000f
[    0.071910] x86: Booting SMP configuration:
[    0.071913] .... node  #0, CPUs:      #1
[    0.075177] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.075232]  #2 #3 #4 #5 #6 #7
[    0.094202] x86: Booted up 1 node, 8 CPUs
[    0.094208] smpboot: Total of 8 processors activated (54404.41 BogoMIPS)
[    0.101192] devtmpfs: initialized
[    0.104182] evm: security.selinux
[    0.104184] evm: security.SMACK64
[    0.104186] evm: security.SMACK64EXEC
[    0.104188] evm: security.SMACK64TRANSMUTE
[    0.104189] evm: security.SMACK64MMAP
[    0.104191] evm: security.ima
[    0.104193] evm: security.capability
[    0.104231] PM: Registering ACPI NVS region [mem 0xcd4fc000-0xcd502fff] (28672 bytes)
[    0.104234] PM: Registering ACPI NVS region [mem 0xdd925000-0xdda5bfff] (1273856 bytes)
[    0.104303] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.104366] pinctrl core: initialized pinctrl subsystem
[    0.104453] RTC time:  2:38:11, date: 12/22/15
[    0.105237] NET: Registered protocol family 16
[    0.117084] cpuidle: using governor ladder
[    0.129079] cpuidle: using governor menu
[    0.129085] PCCT header not found.
[    0.129129] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.129132] ACPI: bus type PCI registered
[    0.129135] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.129192] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.129196] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.129204] PCI: Using configuration type 1 for base access
[    0.129608] perf_event_intel: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
[    0.145319] ACPI: Added _OSI(Module Device)
[    0.145322] ACPI: Added _OSI(Processor Device)
[    0.145324] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.145326] ACPI: Added _OSI(Processor Aggregator Device)
[    0.148233] ACPI: Executed 6 blocks of module-level executable AML code
[    0.195661] ACPI: Dynamic OEM Table Load:
[    0.195665] ACPI: PRAD 0x0000000000000000 0000CE (v02 PRADID PRADTID  00000001 MSFT 03000001)
[    0.195861] ACPI: Dynamic OEM Table Load:
[    0.195866] ACPI: SSDT 0xFFFF8807FB61C000 0003D3 (v02 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.196359] ACPI: Dynamic OEM Table Load:
[    0.196364] ACPI: SSDT 0xFFFF8807FBA7A000 0005AA (v02 PmRef  ApIst    00003000 INTL 20051117)
[    0.196888] ACPI: Dynamic OEM Table Load:
[    0.196892] ACPI: SSDT 0xFFFF8807FB613200 000119 (v02 PmRef  ApCst    00003000 INTL 20051117)
[    0.198126] ACPI: Interpreter enabled
[    0.198134] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20150930/hwxface-580)
[    0.198141] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20150930/hwxface-580)
[    0.198148] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20150930/hwxface-580)
[    0.198161] ACPI: (supports S0 S4 S5)
[    0.198163] ACPI: Using IOAPIC for interrupt routing
[    0.198202] HEST: Table parsing has been initialized.
[    0.198205] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.198519] ACPI: Power Resource [PG00] (on)
[    0.198721] ACPI: Power Resource [PG01] (on)
[    0.198920] ACPI: Power Resource [PG02] (on)
[    0.203838] ACPI: Power Resource [FN00] (off)
[    0.203887] ACPI: Power Resource [FN01] (off)
[    0.203936] ACPI: Power Resource [FN02] (off)
[    0.203983] ACPI: Power Resource [FN03] (off)
[    0.204030] ACPI: Power Resource [FN04] (off)
[    0.204576] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.204582] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.204733] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.204819] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.204821] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.205095] PCI host bridge to bus 0000:00
[    0.205098] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.205101] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.205103] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.205107] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
[    0.205110] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
[    0.205113] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
[    0.205116] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
[    0.205119] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
[    0.205122] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff window]
[    0.205126] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff window]
[    0.205129] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfeafffff window]
[    0.205132] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.205139] pci 0000:00:00.0: [8086:0c08] type 00 class 0x060000
[    0.205198] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.205222] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.205272] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.205296] pci 0000:00:01.1: [8086:0c05] type 01 class 0x060400
[    0.205319] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
[    0.205364] pci 0000:00:01.1: System wakeup disabled by ACPI
[    0.205416] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.205438] pci 0000:00:14.0: reg 0x10: [mem 0xf7320000-0xf732ffff 64bit]
[    0.205482] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.205685] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.205719] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.205742] pci 0000:00:16.0: reg 0x10: [mem 0xf7338000-0xf733800f 64bit]
[    0.205788] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.205855] pci 0000:00:16.1: [8086:8c3b] type 00 class 0x078000
[    0.205878] pci 0000:00:16.1: reg 0x10: [mem 0xf7337000-0xf733700f 64bit]
[    0.205924] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
[    0.205984] pci 0000:00:19.0: [8086:153a] type 00 class 0x020000
[    0.206005] pci 0000:00:19.0: reg 0x10: [mem 0xf7300000-0xf731ffff]
[    0.206012] pci 0000:00:19.0: reg 0x14: [mem 0xf7335000-0xf7335fff]
[    0.206019] pci 0000:00:19.0: reg 0x18: [io  0xf020-0xf03f]
[    0.206060] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.206096] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.206131] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    0.206155] pci 0000:00:1a.0: reg 0x10: [mem 0xf7334000-0xf73343ff]
[    0.206217] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.206255] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.206287] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.206341] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.206384] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.206415] pci 0000:00:1c.1: [8086:8c12] type 01 class 0x060400
[    0.206470] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.206512] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.206702] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    0.206725] pci 0000:00:1d.0: reg 0x10: [mem 0xf7333000-0xf73333ff]
[    0.206789] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.206827] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.206865] pci 0000:00:1f.0: [8086:8c54] type 00 class 0x060100
[    0.207004] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
[    0.207021] pci 0000:00:1f.2: reg 0x10: [io  0xf070-0xf077]
[    0.207028] pci 0000:00:1f.2: reg 0x14: [io  0xf060-0xf063]
[    0.207034] pci 0000:00:1f.2: reg 0x18: [io  0xf050-0xf057]
[    0.207041] pci 0000:00:1f.2: reg 0x1c: [io  0xf040-0xf043]
[    0.207047] pci 0000:00:1f.2: reg 0x20: [io  0xf000-0xf01f]
[    0.207054] pci 0000:00:1f.2: reg 0x24: [mem 0xf7332000-0xf73327ff]
[    0.207077] pci 0000:00:1f.2: PME# supported from D3hot
[    0.207127] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.207141] pci 0000:00:1f.3: reg 0x10: [mem 0xf7331000-0xf73310ff 64bit]
[    0.207158] pci 0000:00:1f.3: reg 0x20: [io  0x0580-0x059f]
[    0.207223] pci 0000:00:1f.6: [8086:8c24] type 00 class 0x118000
[    0.207246] pci 0000:00:1f.6: reg 0x10: [mem 0xf7330000-0xf7330fff 64bit]
[    0.207355] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.207385] pci 0000:02:00.0: [1000:0072] type 00 class 0x010700
[    0.207401] pci 0000:02:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    0.207408] pci 0000:02:00.0: reg 0x14: [mem 0xf72c0000-0xf72c3fff 64bit]
[    0.207415] pci 0000:02:00.0: reg 0x1c: [mem 0xf7280000-0xf72bffff 64bit]
[    0.207423] pci 0000:02:00.0: reg 0x30: [mem 0xf7200000-0xf727ffff pref]
[    0.207444] pci 0000:02:00.0: supports D1 D2
[    0.207456] pci 0000:02:00.0: reg 0x174: [mem 0x00000000-0x00003fff 64bit]
[    0.207458] pci 0000:02:00.0: VF(n) BAR0 space: [mem 0x00000000-0x0003ffff 64bit] (contains BAR0 for 16 VFs)
[    0.207466] pci 0000:02:00.0: reg 0x17c: [mem 0x00000000-0x0003ffff 64bit]
[    0.207467] pci 0000:02:00.0: VF(n) BAR2 space: [mem 0x00000000-0x003fffff 64bit] (contains BAR2 for 16 VFs)
[    0.207502] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.214864] pci 0000:00:01.1: PCI bridge to [bus 02]
[    0.214868] pci 0000:00:01.1:   bridge window [io  0xe000-0xefff]
[    0.214869] pci 0000:00:01.1:   bridge window [mem 0xf7200000-0xf72fffff]
[    0.214950] pci 0000:03:00.0: [1a03:1150] type 01 class 0x060400
[    0.215061] pci 0000:03:00.0: supports D1 D2
[    0.215062] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.215097] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.222875] pci 0000:00:1c.0: PCI bridge to [bus 03-04]
[    0.222879] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.222882] pci 0000:00:1c.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.222949] pci 0000:04:00.0: [1a03:2000] type 00 class 0x030000
[    0.222988] pci 0000:04:00.0: reg 0x10: [mem 0xf6000000-0xf6ffffff]
[    0.223001] pci 0000:04:00.0: reg 0x14: [mem 0xf7000000-0xf701ffff]
[    0.223014] pci 0000:04:00.0: reg 0x18: [io  0xd000-0xd07f]
[    0.223099] pci 0000:04:00.0: supports D1 D2
[    0.223100] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.223186] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.223195] pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
[    0.223199] pci 0000:03:00.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.223303] pci 0000:05:00.0: [8086:1533] type 00 class 0x020000
[    0.223360] pci 0000:05:00.0: reg 0x10: [mem 0xf7100000-0xf717ffff]
[    0.223391] pci 0000:05:00.0: reg 0x18: [io  0xc000-0xc01f]
[    0.223408] pci 0000:05:00.0: reg 0x1c: [mem 0xf7180000-0xf7183fff]
[    0.223542] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.223598] pci 0000:05:00.0: System wakeup disabled by ACPI
[    0.230889] pci 0000:00:1c.1: PCI bridge to [bus 05]
[    0.230893] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.230896] pci 0000:00:1c.1:   bridge window [mem 0xf7100000-0xf71fffff]
[    0.231606] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.231653] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.231699] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.231744] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.231786] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.231830] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.231876] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.231918] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.232123] ACPI: Enabled 7 GPEs in block 00 to 3F
[    0.232199] vgaarb: setting as boot device: PCI:0000:04:00.0
[    0.232202] vgaarb: device added: PCI:0000:04:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.232205] vgaarb: loaded
[    0.232207] vgaarb: bridge control possible 0000:04:00.0
[    0.232365] SCSI subsystem initialized
[    0.232389] libata version 3.00 loaded.
[    0.232402] ACPI: bus type USB registered
[    0.232414] usbcore: registered new interface driver usbfs
[    0.232421] usbcore: registered new interface driver hub
[    0.232434] usbcore: registered new device driver usb
[    0.232525] PCI: Using ACPI for IRQ routing
[    0.233727] PCI: pci_cache_line_size set to 64 bytes
[    0.233791] e820: reserve RAM buffer [mem 0x00099c00-0x0009ffff]
[    0.233792] e820: reserve RAM buffer [mem 0xcd4fc000-0xcfffffff]
[    0.233793] e820: reserve RAM buffer [mem 0xdd7f2000-0xdfffffff]
[    0.233794] e820: reserve RAM buffer [mem 0xdd925000-0xdfffffff]
[    0.233795] e820: reserve RAM buffer [mem 0xdf800000-0xdfffffff]
[    0.233866] NetLabel: Initializing
[    0.233868] NetLabel:  domain hash size = 128
[    0.233869] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.233878] NetLabel:  unlabeled traffic allowed by default
[    0.233920] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.233925] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.237955] clocksource: Switched to clocksource hpet
[    0.242233] AppArmor: AppArmor Filesystem Enabled
[    0.242267] pnp: PnP ACPI init
[    0.242345] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.242349] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.242413] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.242416] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.242431] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.242454] system 00:03: [io  0x1854-0x1857] has been reserved
[    0.242457] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.242508] system 00:04: [io  0x0a00-0x0a1f] has been reserved
[    0.242511] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.242804] pnp 00:05: [dma 0 disabled]
[    0.242832] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.242962] pnp 00:06: [dma 0 disabled]
[    0.242986] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.243016] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.243020] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.243265] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.243268] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.243270] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.243272] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.243275] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.243277] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.243280] system 00:08: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.243282] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.243285] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.243287] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.243290] system 00:08: [mem 0xf7fe0000-0xf7feffff] has been reserved
[    0.243292] system 00:08: [mem 0xf7ff0000-0xf7ffffff] has been reserved
[    0.243295] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.243445] pnp: PnP ACPI: found 9 devices
[    0.249666] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.249674] pci_bus 0000:00: max bus depth: 2 pci_try_num: 3
[    0.249706] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.249715] pci 0000:02:00.0: BAR 9: no space for [mem size 0x00400000 64bit]
[    0.249718] pci 0000:02:00.0: BAR 9: failed to assign [mem size 0x00400000 64bit]
[    0.249721] pci 0000:02:00.0: BAR 7: no space for [mem size 0x00040000 64bit]
[    0.249724] pci 0000:02:00.0: BAR 7: failed to assign [mem size 0x00040000 64bit]
[    0.249727] pci 0000:00:01.1: PCI bridge to [bus 02]
[    0.249730] pci 0000:00:01.1:   bridge window [io  0xe000-0xefff]
[    0.249733] pci 0000:00:01.1:   bridge window [mem 0xf7200000-0xf72fffff]
[    0.249738] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.249748] pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
[    0.249755] pci 0000:03:00.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.249767] pci 0000:00:1c.0: PCI bridge to [bus 03-04]
[    0.249770] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.249775] pci 0000:00:1c.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.249783] pci 0000:00:1c.1: PCI bridge to [bus 05]
[    0.249786] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.249792] pci 0000:00:1c.1:   bridge window [mem 0xf7100000-0xf71fffff]
[    0.249799] pci_bus 0000:00: No. 2 try to assign unassigned res
[    0.249800] release child resource [mem 0xf7200000-0xf727ffff pref]
[    0.249801] release child resource [mem 0xf7280000-0xf72bffff 64bit]
[    0.249802] release child resource [mem 0xf72c0000-0xf72c3fff 64bit]
[    0.249803] pci 0000:00:01.1: resource 14 [mem 0xf7200000-0xf72fffff] released
[    0.249803] pci 0000:00:01.1: PCI bridge to [bus 02]
[    0.249837] pci 0000:00:01.1: BAR 14: assigned [mem 0xe0000000-0xe05fffff]
[    0.249839] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.249846] pci 0000:02:00.0: BAR 6: assigned [mem 0xe0000000-0xe007ffff pref]
[    0.249850] pci 0000:02:00.0: BAR 3: assigned [mem 0xe0080000-0xe00bffff 64bit]
[    0.249857] pci 0000:02:00.0: BAR 9: assigned [mem 0xe00c0000-0xe04bffff 64bit]
[    0.249864] pci 0000:02:00.0: BAR 1: assigned [mem 0xe04c0000-0xe04c3fff 64bit]
[    0.249871] pci 0000:02:00.0: BAR 7: assigned [mem 0xe04c4000-0xe0503fff 64bit]
[    0.249877] pci 0000:00:01.1: PCI bridge to [bus 02]
[    0.249880] pci 0000:00:01.1:   bridge window [io  0xe000-0xefff]
[    0.249883] pci 0000:00:01.1:   bridge window [mem 0xe0000000-0xe05fffff]
[    0.249888] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.249892] pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
[    0.249899] pci 0000:03:00.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.249911] pci 0000:00:1c.0: PCI bridge to [bus 03-04]
[    0.249915] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.249920] pci 0000:00:1c.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.249927] pci 0000:00:1c.1: PCI bridge to [bus 05]
[    0.249931] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.249936] pci 0000:00:1c.1:   bridge window [mem 0xf7100000-0xf71fffff]
[    0.249944] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.249945] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.249946] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.249947] pci_bus 0000:00: resource 7 [mem 0x000cc000-0x000cffff window]
[    0.249948] pci_bus 0000:00: resource 8 [mem 0x000d0000-0x000d3fff window]
[    0.249949] pci_bus 0000:00: resource 9 [mem 0x000d4000-0x000d7fff window]
[    0.249950] pci_bus 0000:00: resource 10 [mem 0x000d8000-0x000dbfff window]
[    0.249951] pci_bus 0000:00: resource 11 [mem 0x000dc000-0x000dffff window]
[    0.249962] pci_bus 0000:00: resource 12 [mem 0x000e0000-0x000e3fff window]
[    0.249963] pci_bus 0000:00: resource 13 [mem 0x000e4000-0x000e7fff window]
[    0.249964] pci_bus 0000:00: resource 14 [mem 0xe0000000-0xfeafffff window]
[    0.249965] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.249966] pci_bus 0000:02: resource 1 [mem 0xe0000000-0xe05fffff]
[    0.249967] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.249968] pci_bus 0000:03: resource 1 [mem 0xf6000000-0xf70fffff]
[    0.249969] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.249970] pci_bus 0000:04: resource 1 [mem 0xf6000000-0xf70fffff]
[    0.249971] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.249972] pci_bus 0000:05: resource 1 [mem 0xf7100000-0xf71fffff]
[    0.249990] NET: Registered protocol family 2
[    0.250156] TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.250396] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.250495] TCP: Hash tables configured (established 262144 bind 65536)
[    0.250680] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.250750] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    0.250827] NET: Registered protocol family 1
[    0.286005] pci 0000:04:00.0: Video device with shadowed ROM
[    0.286019] PCI: CLS 64 bytes, default 64
[    0.286050] Trying to unpack rootfs image as initramfs...
[    0.607168] Freeing initrd memory: 30552K (ffff880034444000 - ffff88003621a000)
[    0.607202] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.607206] software IO TLB [mem 0xd97f2000-0xdd7f2000] (64MB) mapped at [ffff8800d97f2000-ffff8800dd7f1fff]
[    0.607256] RAPL PMU detected, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
[    0.607260] hw unit of domain pp0-core 2^-14 Joules
[    0.607262] hw unit of domain package 2^-14 Joules
[    0.607264] hw unit of domain dram 2^-14 Joules
[    0.607266] hw unit of domain pp1-gpu 2^-14 Joules
[    0.607339] Scanning for low memory corruption every 60 seconds
[    0.607617] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.607644] audit: initializing netlink subsys (disabled)
[    0.607655] audit: type=2000 audit(1450751891.556:1): initialized
[    0.607864] Initialise system trusted keyring
[    0.607976] HugeTLB registered 1 GB page size, pre-allocated 0 pages
[    0.607978] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.608852] zbud: loaded
[    0.608985] VFS: Disk quotas dquot_6.6.0
[    0.609007] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.609309] fuse init (API version 7.23)
[    0.609399] Key type big_key registered
[    0.609707] Key type asymmetric registered
[    0.609710] Asymmetric key parser 'x509' registered
[    0.609732] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
[    0.609769] io scheduler noop registered
[    0.609772] io scheduler deadline registered (default)
[    0.609791] io scheduler cfq registered
[    0.610293] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.610299] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.610321] vesafb: mode is 640x480x32, linelength=2560, pages=0
[    0.610323] vesafb: scrolling: redraw
[    0.610325] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.610336] vesafb: framebuffer at 0xf6000000, mapped to 0xffffc90003600000, using 1216k, total 1216k
[    0.669233] Console: switching to colour frame buffer device 80x30
[    0.729835] fb0: VESA VGA frame buffer device
[    0.731075] intel_idle: MWAIT substates: 0x42120
[    0.731076] intel_idle: v0.4 model 0x3C
[    0.731076] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.731365] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    0.733718] ACPI: Sleep Button [SLPB]
[    0.734773] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.808371] ACPI: Power Button [PWRB]
[    0.844904] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.844905] ACPI: Power Button [PWRF]
[    0.959198] thermal LNXTHERM:00: registered as thermal_zone0
[    0.998468] ACPI: Thermal Zone [TZ00] (28 C)
[    1.037382] thermal LNXTHERM:01: registered as thermal_zone1
[    1.076466] ACPI: Thermal Zone [TZ01] (30 C)
[    1.115794] ERST: Error Record Serialization Table (ERST) support is initialized.
[    1.196751] pstore: Registered erst as persistent store backend
[    1.238185] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
[    1.320341] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.383829] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.490987] 00:06: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    1.579666] Linux agpgart interface v0.103
[    1.605892] tsc: Refined TSC clocksource calibration: 3400.004 MHz
[    1.605894] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x310252db743, max_idle_ns: 440795308826 ns
[    1.760069] brd: module loaded
[    1.804455] loop: module loaded
[    1.847324] libphy: Fixed MDIO Bus: probed
[    1.889424] tun: Universal TUN/TAP device driver, 1.6
[    1.930991] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.973343] PPP generic driver version 2.4.2
[    2.014941] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.056780] ehci-pci: EHCI PCI platform driver
[    2.098529] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    2.139691] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.220527] ehci-pci 0000:00:1a.0: debug port 2
[    2.265227] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    2.265237] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7334000
[    2.317799] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.357793] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.398305] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.476631] usb usb1: Product: EHCI Host Controller
[    2.515769] usb usb1: Manufacturer: Linux 4.4.0-040400rc6-generic ehci_hcd
[    2.555283] usb usb1: SerialNumber: 0000:00:1a.0
[    2.593905] hub 1-0:1.0: USB hub found
[    2.631640] hub 1-0:1.0: 2 ports detected
[    2.668363] clocksource: Switched to clocksource tsc
[    2.668516] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    2.668518] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.668551] ehci-pci 0000:00:1d.0: debug port 2
[    2.672503] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    2.672514] ehci-pci 0000:00:1d.0: irq 22, io mem 0xf7333000
[    2.681762] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.681781] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.681782] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.681782] usb usb2: Product: EHCI Host Controller
[    2.681783] usb usb2: Manufacturer: Linux 4.4.0-040400rc6-generic ehci_hcd
[    2.681783] usb usb2: SerialNumber: 0000:00:1d.0
[    2.681856] hub 2-0:1.0: USB hub found
[    2.681858] hub 2-0:1.0: 2 ports detected
[    2.681942] ehci-platform: EHCI generic platform driver
[    2.681948] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.681950] ohci-pci: OHCI PCI platform driver
[    2.681956] ohci-platform: OHCI generic platform driver
[    2.681960] uhci_hcd: USB Universal Host Controller Interface driver
[    2.682051] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.682054] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    2.683352] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
[    2.683366] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    2.683547] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.683548] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.683549] usb usb3: Product: xHCI Host Controller
[    2.683549] usb usb3: Manufacturer: Linux 4.4.0-040400rc6-generic xhci-hcd
[    2.683550] usb usb3: SerialNumber: 0000:00:14.0
[    2.683622] hub 3-0:1.0: USB hub found
[    2.683673] hub 3-0:1.0: 12 ports detected
[    2.686758] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.686760] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    2.686790] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    2.686790] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.686791] usb usb4: Product: xHCI Host Controller
[    2.686791] usb usb4: Manufacturer: Linux 4.4.0-040400rc6-generic xhci-hcd
[    2.686792] usb usb4: SerialNumber: 0000:00:14.0
[    2.686864] hub 4-0:1.0: USB hub found
[    2.686890] hub 4-0:1.0: 6 ports detected
[    2.688613] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.449714] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    3.449753] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    3.505992] usb 3-3: new high-speed USB device number 3 using xhci_hcd
[    3.561765] usb 4-1: new SuperSpeed USB device number 2 using xhci_hcd
[    3.578507] usb 4-1: New USB device found, idVendor=174c, idProduct=55aa
[    3.578508] usb 4-1: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[    3.578509] usb 4-1: Product: ASMT1051
[    3.578509] usb 4-1: Manufacturer: asmedia
[    3.578510] usb 4-1: SerialNumber: 12345678C6CA
[    3.582111] usb 1-1: New USB device found, idVendor=8087, idProduct=8008
[    3.582112] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.582119] usb 2-1: New USB device found, idVendor=8087, idProduct=8000
[    3.582120] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.582268] hub 2-1:1.0: USB hub found
[    3.582287] hub 1-1:1.0: USB hub found
[    3.582374] hub 2-1:1.0: 6 ports detected
[    3.582378] hub 1-1:1.0: 6 ports detected
[    3.633978] usb 3-3: New USB device found, idVendor=0000, idProduct=0001
[    3.633979] usb 3-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.634433] hub 3-3:1.0: USB hub found
[    3.634537] hub 3-3:1.0: 4 ports detected
[    3.784435] i8042: No controller found
[    3.784514] mousedev: PS/2 mouse device common for all mice
[    3.784682] rtc_cmos 00:02: RTC can wake from S4
[    3.785018] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    3.785095] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    3.785099] i2c /dev entries driver
[    3.785130] device-mapper: uevent: version 1.0.3
[    3.785178] device-mapper: ioctl: 4.34.0-ioctl (2015-10-28) initialised: dm-devel@redhat.com
[    3.785190] Intel P-state driver initializing.
[    3.789736] ledtrig-cpu: registered to indicate activity on CPUs
[    3.790237] NET: Registered protocol family 10
[    3.790396] NET: Registered protocol family 17
[    3.790402] Key type dns_resolver registered
[    3.790566] microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x1d
[    3.790570] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x1d
[    3.790585] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x1d
[    3.790612] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x1d
[    3.825404] microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x1d
[    3.825405] microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x1d
[    3.825428] microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x1d
[    3.825453] microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x1d
[    3.825542] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.825612] registered taskstats version 1
[    3.825619] Loading compiled-in X.509 certificates
[    3.826157] Loaded X.509 cert 'Build time autogenerated kernel key: 4e47d338fce2694b68505af61d12b2a72742b92a'
[    3.826170] zswap: loaded using pool lzo/zbud
[    3.827563] Key type trusted registered
[    3.830144] Key type encrypted registered
[    3.830148] AppArmor: AppArmor sha1 policy hashing enabled
[    3.830168] ima: No TPM chip found, activating TPM-bypass!
[    3.830180] evm: HMAC attrs: 0x1
[    3.830925]   Magic number: 11:480:612
[    3.830961] tty tty: hash matches
[    3.861981] rtc_cmos 00:02: setting system clock to 2015-12-22 02:38:15 UTC (1450751895)
[    3.862199] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.862200] EDD information not available.
[    3.862297] PM: Hibernation image not present or could not be loaded.
[    3.937686] usb 3-3.1: new low-speed USB device number 4 using xhci_hcd
[    4.062021] usb 3-3.1: New USB device found, idVendor=0557, idProduct=2419
[    4.062022] usb 3-3.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.062093] usb 3-3.1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    4.062096] usb 3-3.1: ep 0x82 - rounding interval to 32 microframes, ep desc says 40 microframes
[    6.386663] Freeing unused kernel memory: 1460K (ffffffff81f3d000 - ffffffff820aa000)
[    6.464032] Write protecting the kernel read-only data: 14336k
[    6.505798] Freeing unused kernel memory: 2028K (ffff880001805000 - ffff880001a00000)
[    6.588285] Freeing unused kernel memory: 148K (ffff880001ddb000 - ffff880001e00000)
[    6.761856] random: systemd-udevd urandom read with 9 bits of entropy available
[    6.848004] FUJITSU Extended Socket Network Device Driver - version 1.0 - Copyright (c) 2015 FUJITSU LIMITED
[    6.935179] pps_core: LinuxPPS API ver. 1 registered
[    6.979009] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    7.068747] usbcore: registered new interface driver usb-storage
[    7.068776] ahci 0000:00:1f.2: version 3.0
[    7.069168] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    7.069170] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    7.110055] scsi host0: ahci
[    7.110155] scsi host1: ahci
[    7.110244] scsi host2: ahci
[    7.110298] scsi host3: ahci
[    7.110350] scsi host4: ahci
[    7.110402] scsi host5: ahci
[    7.110441] ata1: SATA max UDMA/133 abar m2048@0xf7332000 port 0xf7332100 irq 28
[    7.110446] ata2: SATA max UDMA/133 abar m2048@0xf7332000 port 0xf7332180 irq 28
[    7.110451] ata3: SATA max UDMA/133 abar m2048@0xf7332000 port 0xf7332200 irq 28
[    7.110456] ata4: SATA max UDMA/133 abar m2048@0xf7332000 port 0xf7332280 irq 28
[    7.110460] ata5: SATA max UDMA/133 abar m2048@0xf7332000 port 0xf7332300 irq 28
[    7.110465] ata6: SATA max UDMA/133 abar m2048@0xf7332000 port 0xf7332380 irq 28
[    7.429463] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.429553] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.429625] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.429696] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.429767] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.429837] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.430230] ata5.00: ATA-9: WDC WD60EFRX-68MYMN1, 82.00A82, max UDMA/133
[    7.430231] ata5.00: 11721045168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.430919] ata6.00: ATA-8: Hitachi HDS721010CLA332, JP4OA3MA, max UDMA/133
[    7.430920] ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.430952] ata5.00: configured for UDMA/133
[    7.432062] ata6.00: configured for UDMA/133
[    7.435360] ata1.00: ATA-8: WDC WD30EZRX-00MMMB0, 80.00A80, max UDMA/133
[    7.435361] ata1.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.435535] ata4.00: ATA-8: WDC WD30EZRX-00MMMB0, 80.00A80, max UDMA/133
[    7.435536] ata4.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.435909] ata3.00: ATA-8: WDC WD30EZRX-00MMMB0, 80.00A80, max UDMA/133
[    7.435910] ata3.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.441361] ata1.00: configured for UDMA/133
[    7.441540] ata4.00: configured for UDMA/133
[    7.441597] scsi 0:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00M 0A80 PQ: 0 ANSI: 5
[    7.441844] sd 0:0:0:0: [sda] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    7.441846] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    7.441862] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.441864] sd 0:0:0:0: [sda] Write Protect is off
[    7.441865] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.441874] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.441989] ata3.00: configured for UDMA/133
[    7.466244] ata2.00: ATA-8: WDC WD30EZRX-00MMMB0, 80.00A80, max UDMA/133
[    7.466245] ata2.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.479785] ata2.00: configured for UDMA/133
[    7.479967] scsi 1:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00M 0A80 PQ: 0 ANSI: 5
[    7.480175] sd 1:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    7.480176] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    7.480193] sd 1:0:0:0: [sdb] Write Protect is off
[    7.480195] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    7.480201] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    7.480203] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.480393] scsi 2:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00M 0A80 PQ: 0 ANSI: 5
[    7.480521] sd 2:0:0:0: [sdc] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    7.480522] sd 2:0:0:0: [sdc] 4096-byte physical blocks
[    7.480542] sd 2:0:0:0: [sdc] Write Protect is off
[    7.480543] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    7.480544] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    7.480553] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.480668] scsi 3:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00M 0A80 PQ: 0 ANSI: 5
[    7.480739] sd 3:0:0:0: [sdd] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    7.480741] sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    7.480760] sd 3:0:0:0: [sdd] Write Protect is off
[    7.480762] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    7.480765] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    7.480772] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.480845] scsi 4:0:0:0: Direct-Access     ATA      WDC WD60EFRX-68M 0A82 PQ: 0 ANSI: 5
[    7.480924] sd 4:0:0:0: [sde] 11721045168 512-byte logical blocks: (6.00 TB/5.45 TiB)
[    7.480925] sd 4:0:0:0: [sde] 4096-byte physical blocks
[    7.480945] sd 4:0:0:0: [sde] Write Protect is off
[    7.480947] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    7.480948] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    7.480956] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.481033] scsi 5:0:0:0: Direct-Access     ATA      Hitachi HDS72101 A3MA PQ: 0 ANSI: 5
[    7.481109] sd 5:0:0:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.481130] sd 5:0:0:0: [sdf] Write Protect is off
[    7.481131] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    7.481136] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    7.481141] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.493140] sd 4:0:0:0: [sde] Attached SCSI removable disk
[    7.507421]  sdf: sdf1 sdf2 < sdf5 >
[    7.507762] sd 5:0:0:0: [sdf] Attached SCSI removable disk
[    7.511115]  sda: sda1 sda9
[    7.511376] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    7.528616]  sdb: sdb1 sdb9
[    7.528880] sd 1:0:0:0: [sdb] Attached SCSI removable disk
[    7.538274]  sdd: sdd1 sdd9
[    7.538544] sd 3:0:0:0: [sdd] Attached SCSI removable disk
[    7.547107]  sdc: sdc1 sdc9
[    7.547377] sd 2:0:0:0: [sdc] Attached SCSI removable disk
[    7.782693] [drm] Initialized drm 1.1.0 20060810
[    7.786228] hidraw: raw HID events driver (C) Jiri Kosina
[    7.808758] random: nonblocking pool is initialized
[    8.062537] PTP clock support registered
[    8.665714] dca service started, version 1.12.1
[    9.443363] mpt3sas version 09.102.00.00 loaded
[    9.443530] mpt2sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (32906760 kB)
[    9.444536] usbcore: registered new interface driver usbhid
[    9.444536] usbhid: USB HID core driver
[    9.497731] mpt2sas_cm0: MSI-X vectors supported: 1, no of cores: 8, max_msix_vectors: -1
[    9.497798] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 29
[    9.497799] mpt2sas_cm0: iomem(0x00000000e04c0000), mapped(0xffffc900035f0000), size(16384)
[    9.497799] mpt2sas_cm0: ioport(0x000000000000e000), size(256)
[    9.586283] mpt2sas_cm0: Allocated physical memory: size(7445 kB)
[    9.586284] mpt2sas_cm0: Current Controller Queue Depth(3307),Max Controller Queue Depth(3432)
[    9.586284] mpt2sas_cm0: Scatter Gather Elements per IO(128)
[    9.630329] mpt2sas_cm0: overriding NVDATA EEDPTagMode setting
[    9.632274] mpt2sas_cm0: LSISAS2008: FWVersion(15.00.00.00), ChipRevision(0x03), BiosVersion(00.00.00.00)
[    9.632275] mpt2sas_cm0: Protocol=(
[    9.632275] Initiator
[    9.632275] ,Target
[    9.632276] ), 
[    9.632276] Capabilities=(
[    9.632276] TLR
[    9.632277] ,EEDP
[    9.632277] ,Snapshot Buffer
[    9.632277] ,Diag Trace Buffer
[    9.632277] ,Task Set Full
[    9.632278] ,NCQ
[    9.632278] )
[    9.632320] scsi host6: Fusion MPT SAS Host
[    9.632502] mpt2sas_cm0: sending port enable !!
[   10.077155] input: HID 0557:2419 as /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3.1/3-3.1:1.0/0003:0557:2419.0001/input/input3
[   10.133233] hid-generic 0003:0557:2419.0001: input,hidraw0: USB HID v1.00 Keyboard [HID 0557:2419] on usb-0000:00:14.0-3.1/input0
[   10.133306] input: HID 0557:2419 as /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3.1/3-3.1:1.1/0003:0557:2419.0002/input/input4
[   10.133462] hid-generic 0003:0557:2419.0002: input,hidraw1: USB HID v1.00 Mouse [HID 0557:2419] on usb-0000:00:14.0-3.1/input1
[   10.812136] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.3.0-k
[   10.812137] igb: Copyright (c) 2007-2014 Intel Corporation.
[   10.846969] pps pps0: new PPS source ptp0
[   10.846970] igb 0000:05:00.0: added PHC on eth0
[   10.846971] igb 0000:05:00.0: Intel(R) Gigabit Ethernet Network Connection
[   10.846972] igb 0000:05:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 0c:c4:7a:79:68:62
[   10.847107] igb 0000:05:00.0: eth0: PBA No: 011000-000
[   10.847107] igb 0000:05:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[   11.134997] mpt2sas_cm0: host_add: handle(0x0001), sas_addr(0x5000000080000000), phys(8)
[   11.311545] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[   11.311546] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[   11.311732] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   11.394723] igb 0000:05:00.0 eno1: renamed from eth0
[   11.830098] [drm] AST 2400 detected
[   11.830171] [drm] Analog VGA only
[   11.830227] [drm] dram 1632000000 1 16 01000000
[   11.830293] [TTM] Zone  kernel: Available graphics memory: 16453380 kiB
[   11.830293] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   11.830294] [TTM] Initializing pool allocator
[   11.830296] [TTM] Initializing DMA pool allocator
[   11.844412] checking generic (f6000000 130000) vs hw (f6000000 1000000)
[   11.844412] fb: switching to astdrmfb from VESA VGA
[   11.883778] scsi 6:0:0:0: Direct-Access     ATA      WDC WD60EFRX-68M 0A82 PQ: 0 ANSI: 6
[   11.883780] scsi 6:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221100000000), phy(0), device_name(0x0000000000000000)
[   11.883782] scsi 6:0:0:0: SATA: enclosure_logical_id(0x5000000080000000), slot(3)
[   11.883882] scsi 6:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   12.133777] scsi 6:0:1:0: Direct-Access     ATA      WDC WD60EZRX-11M 0A80 PQ: 0 ANSI: 6
[   12.133779] scsi 6:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221101000000), phy(1), device_name(0x0000000000000000)
[   12.133780] scsi 6:0:1:0: SATA: enclosure_logical_id(0x5000000080000000), slot(2)
[   12.133884] scsi 6:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   12.384108] scsi 6:0:2:0: Direct-Access     ATA      WDC WD60EZRX-11M 0A80 PQ: 0 ANSI: 6
[   12.384110] scsi 6:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221102000000), phy(2), device_name(0x0000000000000000)
[   12.384111] scsi 6:0:2:0: SATA: enclosure_logical_id(0x5000000080000000), slot(1)
[   12.384215] scsi 6:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   12.633772] scsi 6:0:3:0: Direct-Access     ATA      WDC WD60EZRX-00M 0A80 PQ: 0 ANSI: 6
[   12.633774] scsi 6:0:3:0: SATA: handle(0x000c), sas_addr(0x4433221103000000), phy(3), device_name(0x0000000000000000)
[   12.633775] scsi 6:0:3:0: SATA: enclosure_logical_id(0x5000000080000000), slot(0)
[   12.633882] scsi 6:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   12.883752] scsi 6:0:4:0: Direct-Access     ATA      WDC WD60EZRX-00M 0A80 PQ: 0 ANSI: 6
[   12.883754] scsi 6:0:4:0: SATA: handle(0x000d), sas_addr(0x4433221104000000), phy(4), device_name(0x0000000000000000)
[   12.883755] scsi 6:0:4:0: SATA: enclosure_logical_id(0x5000000080000000), slot(7)
[   12.883858] scsi 6:0:4:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   13.133716] scsi 6:0:5:0: Direct-Access     ATA      WDC WD60EZRX-11M 0A80 PQ: 0 ANSI: 6
[   13.133718] scsi 6:0:5:0: SATA: handle(0x000e), sas_addr(0x4433221105000000), phy(5), device_name(0x0000000000000000)
[   13.133718] scsi 6:0:5:0: SATA: enclosure_logical_id(0x5000000080000000), slot(6)
[   13.133821] scsi 6:0:5:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   13.384277] scsi 6:0:6:0: Direct-Access     ATA      WDC WD60EZRX-11M 0A80 PQ: 0 ANSI: 6
[   13.384279] scsi 6:0:6:0: SATA: handle(0x000f), sas_addr(0x4433221106000000), phy(6), device_name(0x0000000000000000)
[   13.384280] scsi 6:0:6:0: SATA: enclosure_logical_id(0x5000000080000000), slot(5)
[   13.384383] scsi 6:0:6:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   13.633618] scsi 6:0:7:0: Direct-Access     ATA      TOSHIBA MD04ACA5 FP2A PQ: 0 ANSI: 6
[   13.633620] scsi 6:0:7:0: SATA: handle(0x0010), sas_addr(0x4433221107000000), phy(7), device_name(0x0000000000000000)
[   13.633621] scsi 6:0:7:0: SATA: enclosure_logical_id(0x5000000080000000), slot(4)
[   13.633725] scsi 6:0:7:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   16.768656] mpt2sas_cm0: port enable: SUCCESS
[   16.768939] sd 6:0:0:0: Attached scsi generic sg6 type 0
[   16.768943] sd 6:0:0:0: tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
[   16.768944] mpt2sas_cm0: 	sas_address(0x4433221100000000), phy(0)
[   16.768945] mpt2sas_cm0: 	enclosure_logical_id(0x5000000080000000),slot(3)
[   16.768946] mpt2sas_cm0: 	handle(0x0009), ioc_status(success)(0x0000), smid(1)
[   16.768946] mpt2sas_cm0: 	request_len(0), underflow(0), resid(0)
[   16.768947] mpt2sas_cm0: 	tag(65535), transfer_count(0), sc->result(0x00000000)
[   16.768947] mpt2sas_cm0: 	scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
[   16.768948] mpt2sas_cm0: 	[sense_key,asc,ascq]: [0x06,0x29,0x00], count(18)
[   16.769069] sd 6:0:1:0: tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
[   16.769070] sd 6:0:1:0: Attached scsi generic sg7 type 0
[   16.769070] mpt2sas_cm0: 	sas_address(0x4433221101000000), phy(1)
[   16.769071] mpt2sas_cm0: 	enclosure_logical_id(0x5000000080000000),slot(2)
[   16.769071] mpt2sas_cm0: 	handle(0x000a), ioc_status(success)(0x0000), smid(1)
[   16.769072] mpt2sas_cm0: 	request_len(0), underflow(0), resid(0)
[   16.769072] mpt2sas_cm0: 	tag(65535), transfer_count(0), sc->result(0x00000000)
[   16.769073] mpt2sas_cm0: 	scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
[   16.769073] mpt2sas_cm0: 	[sense_key,asc,ascq]: [0x06,0x29,0x00], count(18)
[   16.769189] sd 6:0:2:0: tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
[   16.769189] mpt2sas_cm0: 	sas_address(0x4433221102000000), phy(2)
[   16.769190] mpt2sas_cm0: 	enclosure_logical_id(0x5000000080000000),slot(1)
[   16.769190] mpt2sas_cm0: 	handle(0x000b), ioc_status(success)(0x0000), smid(1)
[   16.769191] mpt2sas_cm0: 	request_len(0), underflow(0), resid(0)
[   16.769191] mpt2sas_cm0: 	tag(65535), transfer_count(0), sc->result(0x00000000)
[   16.769192] mpt2sas_cm0: 	scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
[   16.769192] mpt2sas_cm0: 	[sense_key,asc,ascq]: [0x06,0x29,0x00], count(18)
[   16.769194] sd 6:0:2:0: Attached scsi generic sg8 type 0
[   16.769283] sd 6:0:3:0: tag#3 CDB: Test Unit Ready 00 00 00 00 00 00
[   16.769284] mpt2sas_cm0: 	sas_address(0x4433221103000000), phy(3)
[   16.769284] mpt2sas_cm0: 	enclosure_logical_id(0x5000000080000000),slot(0)
[   16.769285] mpt2sas_cm0: 	handle(0x000c), ioc_status(success)(0x0000), smid(4)
[   16.769285] mpt2sas_cm0: 	request_len(0), underflow(0), resid(0)
[   16.769286] mpt2sas_cm0: 	tag(65535), transfer_count(0), sc->result(0x00000000)
[   16.769286] mpt2sas_cm0: 	scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
[   16.769287] mpt2sas_cm0: 	[sense_key,asc,ascq]: [0x06,0x29,0x00], count(18)
[   16.769296] sd 6:0:3:0: Attached scsi generic sg9 type 0
[   16.769357] sd 6:0:0:0: [sdg] 11721045168 512-byte logical blocks: (6.00 TB/5.45 TiB)
[   16.769358] sd 6:0:0:0: [sdg] 4096-byte physical blocks
[   16.769407] sd 6:0:4:0: Attached scsi generic sg10 type 0
[   16.769421] sd 6:0:4:0: tag#4 CDB: Test Unit Ready 00 00 00 00 00 00
[   16.769422] mpt2sas_cm0: 	sas_address(0x4433221104000000), phy(4)
[   16.769422] mpt2sas_cm0: 	enclosure_logical_id(0x5000000080000000),slot(7)
[   16.769423] mpt2sas_cm0: 	handle(0x000d), ioc_status(success)(0x0000), smid(5)
[   16.769423] mpt2sas_cm0: 	request_len(0), underflow(0), resid(0)
[   16.769424] mpt2sas_cm0: 	tag(65535), transfer_count(0), sc->result(0x00000000)
[   16.769424] mpt2sas_cm0: 	scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
[   16.769425] mpt2sas_cm0: 	[sense_key,asc,ascq]: [0x06,0x29,0x00], count(18)
[   16.769537] sd 6:0:5:0: tag#4 CDB: Test Unit Ready 00 00 00 00 00 00
[   16.769538] mpt2sas_cm0: 	sas_address(0x4433221105000000), phy(5)
[   16.769538] sd 6:0:5:0: Attached scsi generic sg11 type 0
[   16.769539] mpt2sas_cm0: 	enclosure_logical_id(0x5000000080000000),slot(6)
[   16.769540] mpt2sas_cm0: 	handle(0x000e), ioc_status(success)(0x0000), smid(5)
[   16.769541] mpt2sas_cm0: 	request_len(0), underflow(0), resid(0)
[   16.769541] mpt2sas_cm0: 	tag(65535), transfer_count(0), sc->result(0x00000000)
[   16.769542] mpt2sas_cm0: 	scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
[   16.769543] mpt2sas_cm0: 	[sense_key,asc,ascq]: [0x06,0x29,0x00], count(18)
[   16.769560] sd 6:0:1:0: [sdh] 11720979633 512-byte logical blocks: (6.00 TB/5.45 TiB)
[   16.769561] sd 6:0:1:0: [sdh] 4096-byte physical blocks
[   16.769636] sd 6:0:6:0: tag#6 CDB: Test Unit Ready 00 00 00 00 00 00
[   16.769636] mpt2sas_cm0: 	sas_address(0x4433221106000000), phy(6)
[   16.769637] mpt2sas_cm0: 	enclosure_logical_id(0x5000000080000000),slot(5)
[   16.769637] mpt2sas_cm0: 	handle(0x000f), ioc_status(success)(0x0000), smid(7)
[   16.769638] mpt2sas_cm0: 	request_len(0), underflow(0), resid(0)
[   16.769638] mpt2sas_cm0: 	tag(65535), transfer_count(0), sc->result(0x00000000)
[   16.769639] mpt2sas_cm0: 	scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
[   16.769639] mpt2sas_cm0: 	[sense_key,asc,ascq]: [0x06,0x29,0x00], count(18)
[   16.769640] sd 6:0:6:0: Attached scsi generic sg12 type 0
[   16.769711] sd 6:0:2:0: [sdi] 11720979633 512-byte logical blocks: (6.00 TB/5.45 TiB)
[   16.769712] sd 6:0:2:0: [sdi] 4096-byte physical blocks
[   16.769734] sd 6:0:7:0: Attached scsi generic sg13 type 0
[   16.769779] sd 6:0:7:0: tag#7 CDB: Test Unit Ready 00 00 00 00 00 00
[   16.769779] mpt2sas_cm0: 	sas_address(0x4433221107000000), phy(7)
[   16.769780] mpt2sas_cm0: 	enclosure_logical_id(0x5000000080000000),slot(4)
[   16.769780] mpt2sas_cm0: 	handle(0x0010), ioc_status(success)(0x0000), smid(8)
[   16.769780] mpt2sas_cm0: 	request_len(0), underflow(0), resid(0)
[   16.769781] mpt2sas_cm0: 	tag(65535), transfer_count(0), sc->result(0x00000000)
[   16.769781] mpt2sas_cm0: 	scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
[   16.769782] mpt2sas_cm0: 	[sense_key,asc,ascq]: [0x06,0x29,0x00], count(18)
[   16.769810] sd 6:0:3:0: [sdj] 11720979633 512-byte logical blocks: (6.00 TB/5.45 TiB)
[   16.769810] sd 6:0:3:0: [sdj] 4096-byte physical blocks
[   16.769907] sd 6:0:4:0: [sdk] 11720979633 512-byte logical blocks: (6.00 TB/5.45 TiB)
[   16.769907] sd 6:0:4:0: [sdk] 4096-byte physical blocks
[   16.770047] sd 6:0:5:0: [sdl] 11720979633 512-byte logical blocks: (6.00 TB/5.45 TiB)
[   16.770048] sd 6:0:5:0: [sdl] 4096-byte physical blocks
[   16.770135] sd 6:0:6:0: [sdm] 11720979633 512-byte logical blocks: (6.00 TB/5.45 TiB)
[   16.770136] sd 6:0:6:0: [sdm] 4096-byte physical blocks
[   16.770369] sd 6:0:7:0: [sdn] 9767541168 512-byte logical blocks: (5.00 TB/4.54 TiB)
[   16.770369] sd 6:0:7:0: [sdn] 4096-byte physical blocks
[   16.774070] sd 6:0:0:0: [sdg] Write Protect is off
[   16.774071] sd 6:0:0:0: [sdg] Mode Sense: 7f 00 10 08
[   16.774631] sd 6:0:4:0: [sdk] Write Protect is off
[   16.774632] sd 6:0:4:0: [sdk] Mode Sense: 7f 00 10 08
[   16.774671] sd 6:0:1:0: [sdh] Write Protect is off
[   16.774672] sd 6:0:1:0: [sdh] Mode Sense: 7f 00 10 08
[   16.774689] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   16.774786] sd 6:0:2:0: [sdi] Write Protect is off
[   16.774787] sd 6:0:2:0: [sdi] Mode Sense: 7f 00 10 08
[   16.774840] sd 6:0:3:0: [sdj] Write Protect is off
[   16.774841] sd 6:0:3:0: [sdj] Mode Sense: 7f 00 10 08
[   16.775055] sd 6:0:5:0: [sdl] Write Protect is off
[   16.775055] sd 6:0:5:0: [sdl] Mode Sense: 7f 00 10 08
[   16.775128] sd 6:0:6:0: [sdm] Write Protect is off
[   16.775129] sd 6:0:6:0: [sdm] Mode Sense: 7f 00 10 08
[   16.775429] sd 6:0:4:0: [sdk] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   16.775523] sd 6:0:1:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   16.775560] sd 6:0:2:0: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   16.775658] sd 6:0:3:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   16.775866] sd 6:0:5:0: [sdl] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   16.775931] sd 6:0:6:0: [sdm] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   16.799876] sd 6:0:1:0: [sdh] Attached SCSI disk
[   16.800387] sd 6:0:6:0: [sdm] Attached SCSI disk
[   16.802537] sd 6:0:5:0: [sdl] Attached SCSI disk
[   16.803768] sd 6:0:0:0: [sdg] Attached SCSI disk
[   16.805549] sd 6:0:3:0: [sdj] Attached SCSI disk
[   16.806490] sd 6:0:4:0: [sdk] Attached SCSI disk
[   16.808229] sd 6:0:2:0: [sdi] Attached SCSI disk
[   17.005902] sd 6:0:7:0: [sdn] Write Protect is off
[   17.005903] sd 6:0:7:0: [sdn] Mode Sense: 7f 00 10 08
[   17.006629] sd 6:0:7:0: [sdn] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   17.465652] sd 6:0:7:0: [sdn] Attached SCSI disk
[   24.166099] Console: switching to colour dummy device 80x25
[   24.166240] fbcon: astdrmfb (fb0) is primary device
[   24.183468] Console: switching to colour frame buffer device 128x48
[   24.183681] scsi host7: uas
[   24.183996] scsi 7:0:0:0: Direct-Access     ASMT     2115             0    PQ: 0 ANSI: 6
[   24.184145] usbcore: registered new interface driver uas
[   24.184489] sd 7:0:0:0: Attached scsi generic sg14 type 0
[   24.184573] sd 7:0:0:0: [sdo] 937703088 512-byte logical blocks: (480 GB/447 GiB)
[   24.184835] sd 7:0:0:0: [sdo] Write Protect is off
[   24.184836] sd 7:0:0:0: [sdo] Mode Sense: 43 00 00 00
[   24.184955] sd 7:0:0:0: [sdo] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   24.186812]  sdo: sdo1 sdo2 < sdo5 >
[   24.187509] sd 7:0:0:0: [sdo] Attached SCSI disk
[   24.193977] e1000e 0000:00:19.0 eth0: registered PHC clock
[   24.193979] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 0c:c4:7a:79:68:63
[   24.193980] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[   24.194234] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: 0100FF-0FF
[   24.195553] e1000e 0000:00:19.0 eno2: renamed from eth0
[   24.209762] ast 0000:04:00.0: fb0: astdrmfb frame buffer device
[   24.236118] [drm] Initialized ast 0.1.0 20120228 for 0000:04:00.0 on minor 0
[   24.567298] device-mapper: table: 252:0: adding target device sdo5 caused an alignment inconsistency: physical_block_size=512, logical_block_size=512, alignment_offset=0, start=1048576
[   24.567336] device-mapper: table: 252:0: adding target device sdo5 caused an alignment inconsistency: physical_block_size=512, logical_block_size=512, alignment_offset=0, start=8330936320
[   24.567368] device-mapper: table: 252:0: adding target device sdo5 caused an alignment inconsistency: physical_block_size=512, logical_block_size=512, alignment_offset=0, start=1048576
[   24.567904] device-mapper: table: 252:0: adding target device sdo5 caused an alignment inconsistency: physical_block_size=512, logical_block_size=512, alignment_offset=0, start=8330936320
[   24.569399] device-mapper: table: 252:1: adding target device sdo5 caused an alignment inconsistency: physical_block_size=512, logical_block_size=512, alignment_offset=0, start=7525629952
[   24.570564] device-mapper: table: 252:1: adding target device sdo5 caused an alignment inconsistency: physical_block_size=512, logical_block_size=512, alignment_offset=0, start=7525629952
[   24.700014] raid6: sse2x1   gen() 10947 MB/s
[   24.768009] raid6: sse2x1   xor()  9373 MB/s
[   24.836005] raid6: sse2x2   gen() 15308 MB/s
[   24.904001] raid6: sse2x2   xor() 10196 MB/s
[   24.971992] raid6: sse2x4   gen() 17613 MB/s
[   25.039988] raid6: sse2x4   xor() 12234 MB/s
[   25.107986] raid6: avx2x1   gen() 23401 MB/s
[   25.175976] raid6: avx2x2   gen() 27277 MB/s
[   25.243970] raid6: avx2x4   gen() 31302 MB/s
[   25.243979] raid6: using algorithm avx2x4 gen() 31302 MB/s
[   25.243999] raid6: using avx2x2 recovery algorithm
[   25.244730] xor: automatically using best checksumming function:
[   25.283966]    avx       : 36858.000 MB/sec
[   25.292246] Btrfs loaded
[   25.533551] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 1 transid 219359 /dev/sdn
[   25.533950] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 7 transid 219359 /dev/sdm
[   25.534327] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 8 transid 219359 /dev/sdl
[   25.534706] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 10 transid 219359 /dev/sdj
[   25.535091] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 5 transid 219359 /dev/sdi
[   25.535480] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 4 transid 219359 /dev/sdh
[   25.535865] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 11 transid 219359 /dev/sdk
[   25.535966] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 9 transid 219359 /dev/sdg
[   25.536079] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 0 transid 219359 /dev/sde
[   25.574696] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[   25.708552] systemd[1]: Failed to insert module 'kdbus': Function not implemented
[   25.724837] systemd[1]: systemd 225 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID -ELFUTILS +KMOD -IDN)
[   25.725007] systemd[1]: Detected architecture x86-64.
[   25.725518] systemd[1]: Set hostname to <ubuntu-server>.
[   25.925292] systemd[1]: display-manager.service: Cannot add dependency job, ignoring: Unit display-manager.service failed to load: No such file or directory.
[   25.925677] systemd[1]: Reached target User and Group Name Lookups.
[   25.925877] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[   25.927845] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[   25.951771] systemd[1]: Reached target Remote File Systems (Pre).
[   25.969287] systemd[1]: Created slice Root Slice.
[   25.993149] systemd[1]: Listening on udev Control Socket.
[   26.010545] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[   26.034819] systemd[1]: Listening on LVM2 poll daemon socket.
[   26.052144] systemd[1]: Listening on Journal Socket (/dev/log).
[   26.076814] systemd[1]: Listening on Journal Audit Socket.
[   26.095623] systemd[1]: Created slice User and Session Slice.
[   26.118990] systemd[1]: Created slice System Slice.
[   26.136250] systemd[1]: Created slice system-getty.slice.
[   26.235961] systemd[1]: Starting Increase datagram queue length...
[   26.236509] systemd[1]: Reached target Slices.
[   26.253808] systemd[1]: Listening on Journal Socket.
[   26.279292] systemd[1]: Started Read required files in advance.
[   26.302199] systemd[1]: Starting Setup Virtual Console...
[   26.322036] systemd[1]: Starting Uncomplicated firewall...
[   26.339041] systemd[1]: Mounting POSIX Message Queue File System...
[   26.363903] systemd[1]: Mounting Debug File System...
[   26.380398] systemd[1]: Listening on udev Kernel Socket.
[   26.404885] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[   26.422214] systemd[1]: Listening on LVM2 metadata daemon socket.
[   26.515955] systemd[1]: Starting Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling...
[   26.517136] systemd[1]: Starting udev Coldplug all Devices...
[   26.534512] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[   26.558521] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[   26.576218] systemd[1]: Mounting Huge Pages File System...
[   26.598997] systemd[1]: Listening on fsck to fsckd communication Socket.
[   26.617200] systemd[1]: Created slice system-systemd\x2dcryptsetup.slice.
[   26.642108] systemd[1]: Starting Load Kernel Modules...
[   26.661733] systemd[1]: Mounted POSIX Message Queue File System.
[   26.683007] systemd[1]: Mounted Huge Pages File System.
[   26.700617] systemd[1]: Mounted Debug File System.
[   26.727205] systemd[1]: Started Increase datagram queue length.
[   26.744429] systemd[1]: Started Setup Virtual Console.
[   26.768522] systemd[1]: Started Uncomplicated firewall.
[   26.876554] systemd[1]: Started Create list of required static device nodes for the current kernel.
[   26.881420] systemd[1]: Started Load Kernel Modules.
[   26.917483] systemd[1]: Started udev Coldplug all Devices.
[   26.923892] systemd[1]: Starting udev Wait for Complete Device Initialization...
[   26.940229] systemd[1]: Started LVM2 metadata daemon.
[   26.964750] systemd[1]: Mounting FUSE Control File System...
[   26.981903] systemd[1]: Starting Apply Kernel Variables...
[   27.005561] systemd[1]: Starting Create Static Device Nodes in /dev...
[   27.012440] systemd[1]: Listening on Syslog Socket.
[   27.013137] systemd[1]: Starting Journal Service...
[   27.021195] systemd[1]: Mounted FUSE Control File System.
[   27.027831] systemd[1]: Started Apply Kernel Variables.
[   27.035052] systemd[1]: Started Create Static Device Nodes in /dev.
[   27.042048] systemd[1]: Started Journal Service.
[   27.172431] EXT4-fs (dm-0): re-mounted. Opts: errors=remount-ro
[   27.217187] ipmi message handler version 39.2
[   27.217393] systemd-journald[474]: Received request to flush runtime journal from PID 1
[   27.219471] ipmi_si IPI0001:00: ipmi_si: probing via ACPI
[   27.219490] ipmi_si IPI0001:00: [io  0x0ca2] regsize 1 spacing 1 irq 0
[   27.219492] ipmi_si: Adding ACPI-specified kcs state machine
[   27.219508] IPMI System Interface driver.
[   27.219523] ipmi_si: probing via SMBIOS
[   27.219524] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   27.219525] ipmi_si: Adding SMBIOS-specified kcs state machine duplicate interface
[   27.219526] ipmi_si: probing via SPMI
[   27.219527] ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
[   27.219527] ipmi_si: Adding SPMI-specified kcs state machine duplicate interface
[   27.219528] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[   27.222751] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   27.222977] EDAC MC: Ver: 3.0.0
[   27.226112] EDAC MC0: Giving out device to module ie31200_edac controller IE31200: DEV 0000:00:00.0 (POLLED)
[   27.227740] mei_me 0000:00:16.0: Device doesn't have valid ME Interface
[   27.267816] ipmi_si IPI0001:00: The BMC does not support clearing the recv irq bit, compensating, but the BMC needs to be fixed.
[   27.300650] AVX2 version of gcm_enc/dec engaged.
[   27.300654] AES CTR mode by8 optimization enabled
[   27.323795] EXT4-fs (sdo1): mounting ext2 file system using the ext4 subsystem
[   27.330431] EXT4-fs (sdo1): mounted filesystem without journal. Opts: (null)
[   27.341263] intel_rapl: Found RAPL domain package
[   27.341373] intel_rapl: Found RAPL domain core
[   27.341377] intel_rapl: Found RAPL domain dram
[   27.399843] ipmi_si IPI0001:00: Found new BMC (man_id: 0x002a7c, prod_id: 0x0811, dev_id: 0x20)
[   27.399848] ipmi_si IPI0001:00: IPMI kcs interface initialized
[   27.401542] IPMI SSIF Interface driver
[   27.465075] Adding 785916k swap on /dev/mapper/cryptswap1.  Priority:-1 extents:1 across:785916k FS
[   28.006375] audit: type=1400 audit(1450751919.671:2): apparmor="STATUS" operation="profile_load" name="docker-default" pid=946 comm="apparmor_parser"
[   28.007132] audit: type=1400 audit(1450751919.671:3): apparmor="STATUS" operation="profile_load" name="lxc-container-default" pid=946 comm="apparmor_parser"
[   28.007135] audit: type=1400 audit(1450751919.671:4): apparmor="STATUS" operation="profile_load" name="lxc-container-default-with-mounting" pid=946 comm="apparmor_parser"
[   28.007137] audit: type=1400 audit(1450751919.671:5): apparmor="STATUS" operation="profile_load" name="lxc-container-default-with-nesting" pid=946 comm="apparmor_parser"
[   28.008220] audit: type=1400 audit(1450751919.675:6): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=946 comm="apparmor_parser"
[   28.008223] audit: type=1400 audit(1450751919.675:7): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=946 comm="apparmor_parser"
[   28.008226] audit: type=1400 audit(1450751919.675:8): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=946 comm="apparmor_parser"
[   28.008228] audit: type=1400 audit(1450751919.675:9): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=946 comm="apparmor_parser"
[   28.008589] audit: type=1400 audit(1450751919.675:10): apparmor="STATUS" operation="profile_load" name="/usr/bin/lxc-start" pid=946 comm="apparmor_parser"
[   28.009180] audit: type=1400 audit(1450751919.675:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/libvirt/virt-aa-helper" pid=946 comm="apparmor_parser"
[   28.360068] IPv6: ADDRCONF(NETDEV_UP): eno2: link is not ready
[   28.509194] cgroup: new mount options do not match the existing superblock, will be ignored
[   28.525007] zram: Added device: zram0
[   28.525168] zram: Added device: zram1
[   28.526648] zram: Added device: zram2
[   28.526894] zram: Added device: zram3
[   28.527800] zram: Added device: zram4
[   28.527884] zram: Added device: zram5
[   28.527963] zram: Added device: zram6
[   28.528039] zram: Added device: zram7
[   28.531119] zram0: detected capacity change from 0 to 2106032128
[   28.533544] Adding 2056668k swap on /dev/zram0.  Priority:5 extents:1 across:2056668k SSFS
[   28.534412] zram1: detected capacity change from 0 to 2106032128
[   28.535912] Adding 2056668k swap on /dev/zram1.  Priority:5 extents:1 across:2056668k SSFS
[   28.536698] zram2: detected capacity change from 0 to 2106032128
[   28.538362] Adding 2056668k swap on /dev/zram2.  Priority:5 extents:1 across:2056668k SSFS
[   28.539072] zram3: detected capacity change from 0 to 2106032128
[   28.541859] Adding 2056668k swap on /dev/zram3.  Priority:5 extents:1 across:2056668k SSFS
[   28.542543] zram4: detected capacity change from 0 to 2106032128
[   28.544020] Adding 2056668k swap on /dev/zram4.  Priority:5 extents:1 across:2056668k SSFS
[   28.544688] zram5: detected capacity change from 0 to 2106032128
[   28.548035] Adding 2056668k swap on /dev/zram5.  Priority:5 extents:1 across:2056668k SSFS
[   28.548793] zram6: detected capacity change from 0 to 2106032128
[   28.550955] Adding 2056668k swap on /dev/zram6.  Priority:5 extents:1 across:2056668k SSFS
[   28.551802] zram7: detected capacity change from 0 to 2106032128
[   28.554369] Adding 2056668k swap on /dev/zram7.  Priority:5 extents:1 across:2056668k SSFS
[   28.822644] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[   28.830627] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[   28.833096] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready
[   28.842192] ip_tables: (C) 2000-2006 Netfilter Core Team
[   28.943741] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   28.951614] Ebtables v2.0 registered
[   29.099783] device virbr0-nic entered promiscuous mode
[   29.190611] virbr0: port 1(virbr0-nic) entered listening state
[   29.190619] virbr0: port 1(virbr0-nic) entered listening state
[   29.218825] virbr0: port 1(virbr0-nic) entered disabled state
[   31.009568] e1000e: eno2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   31.009599] IPv6: ADDRCONF(NETDEV_CHANGE): eno2: link becomes ready
[  132.577819] BTRFS info (device sde): force lzo compression
[  132.577824] BTRFS info (device sde): enabling auto recovery
[  132.577825] BTRFS info (device sde): disk space caching is enabled
[  132.577826] BTRFS: has skinny extents
[  173.177112] BTRFS info (device sde): continuing dev_replace from /dev/sdn (devid 1) to /dev/sde @7%
[  194.505762] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505766] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505768] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505770] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505772] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505784] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505786] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505788] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505789] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505791] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505793] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505794] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505796] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505798] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505800] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505802] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505803] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505805] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505807] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505809] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505810] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505817] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505818] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505820] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  194.505822] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  195.534933] BTRFS info (device sde): csum failed ino 319406 extent 55861264384 csum 87859870 wanted 0 mirror 2
[  195.534955] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  195.534958] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  195.534960] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  195.534961] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  195.534963] BTRFS info (device sde): no csum found for inode 319406 start 2752512
[  195.534992] ------------[ cut here ]------------
[  195.535008] kernel BUG at /home/kernel/COD/linux/fs/btrfs/volumes.c:5508!
[  195.535024] invalid opcode: 0000 [#1] SMP 
[  195.535036] Modules linked in: xt_CHECKSUM iptable_mangle ipt_REJECT nf_reject_ipv4 xt_tcpudp ebtable_filter ebtables ip6table_filter ip6_tables xt_addrtype xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 iptable_filter ip_tables x_tables nf_nat nf_conntrack bridge stp llc dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c zram lz4_compress drbg ansi_cprng dm_crypt ipmi_ssif intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd joydev input_leds mei_me ie31200_edac lpc_ich edac_core shpchp mei ipmi_si ipmi_msghandler 8250_fintek tpm_crb mac_hid acpi_pad kvm_intel kvm irqbypass autofs4 btrfs xor raid6_pq uas ast ttm drm_kms_helper
[  195.535263]  syscopyarea hid_generic sysfillrect igb sysimgblt e1000e usbhid fb_sys_fops dca mpt3sas ptp raid_class ahci drm i2c_algo_bit pps_core hid usb_storage libahci scsi_transport_sas fjes video
[  195.535324] CPU: 5 PID: 229 Comm: kworker/u16:5 Not tainted 4.4.0-040400rc6-generic #201512202030
[  195.535344] Hardware name: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 04/24/2015
[  195.535375] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[  195.535390] task: ffff8807f5b31b80 ti: ffff8807f4830000 task.ti: ffff8807f4830000
[  195.535407] RIP: 0010:[<ffffffffc03096d6>]  [<ffffffffc03096d6>] __btrfs_map_block+0xe26/0x1180 [btrfs]
[  195.535437] RSP: 0018:ffff8807f4833a90  EFLAGS: 00010282
[  195.535450] RAX: 00000000dad21680 RBX: 0000000000000006 RCX: 0000000000000006
[  195.535466] RDX: 0000000000000000 RSI: 0000000000005000 RDI: 0000000000000002
[  195.535481] RBP: ffff8807f4833b78 R08: 000038923fc00000 R09: 00000000dad21680
[  195.535497] R10: 0000000000010000 R11: 0000000004960000 R12: 00000000dad2167f
[  195.535513] R13: 000000000000b000 R14: ffff8807f4833bb8 R15: 0000000000000000
[  195.535529] FS:  0000000000000000(0000) GS:ffff88081fd40000(0000) knlGS:0000000000000000
[  195.535547] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  195.535560] CR2: 00007f828b9c0000 CR3: 0000000001e0a000 CR4: 00000000001406e0
[  195.535576] Stack:
[  195.535582]  ffff8807f49fa428 ffff8807f4833ac0 ffff8807f4833a90 0000000000000000
[  195.535602]  ffff8807f4833b28 ffffffffc02acd8d 0000000000000000 0000000000000496
[  195.535623]  0000000000000187 ffff8807e85b0ed8 ffff880700000000 0000000100000000
[  195.535643] Call Trace:
[  195.535655]  [<ffffffffc02acd8d>] ? btrfs_printk+0x8d/0xf0 [btrfs]
[  195.535676]  [<ffffffffc0309fa2>] btrfs_map_bio+0x82/0x320 [btrfs]
[  195.535692]  [<ffffffff811e52c7>] ? kmem_cache_alloc+0x177/0x1e0
[  195.535713]  [<ffffffffc02d56c8>] ? btrfs_bio_wq_end_io+0x28/0x70 [btrfs]
[  195.535736]  [<ffffffffc0326c99>] btrfs_submit_compressed_read+0x319/0x4c0 [btrfs]
[  195.535759]  [<ffffffffc02deab1>] btrfs_submit_bio_hook+0x1a1/0x1b0 [btrfs]
[  195.535782]  [<ffffffffc02fd1bc>] ? btrfs_create_repair_bio+0xdc/0x100 [btrfs]
[  195.535804]  [<ffffffffc02fd697>] end_bio_extent_readpage+0x4b7/0x5b0 [btrfs]
[  195.535825]  [<ffffffffc02fd1e0>] ? btrfs_create_repair_bio+0x100/0x100 [btrfs]
[  195.535843]  [<ffffffff813932ff>] bio_endio+0x3f/0x60
[  195.535860]  [<ffffffffc02d300c>] end_workqueue_fn+0x3c/0x40 [btrfs]
[  195.535882]  [<ffffffffc030e70a>] btrfs_scrubparity_helper+0xca/0x290 [btrfs]
[  195.535904]  [<ffffffffc030e9be>] btrfs_endio_helper+0xe/0x10 [btrfs]
[  195.535920]  [<ffffffff8109687a>] process_one_work+0x1aa/0x440
[  195.535934]  [<ffffffff81096b5b>] worker_thread+0x4b/0x4c0
[  195.536528]  [<ffffffff81096b10>] ? process_one_work+0x440/0x440
[  195.537045]  [<ffffffff8109ccd8>] kthread+0xd8/0xf0
[  195.537560]  [<ffffffff8109cc00>] ? kthread_create_on_node+0x1a0/0x1a0
[  195.538077]  [<ffffffff817fd38f>] ret_from_fork+0x3f/0x70
[  195.538588]  [<ffffffff8109cc00>] ? kthread_create_on_node+0x1a0/0x1a0
[  195.539099] Code: 40 ff ff ff 4c 8b 95 38 ff ff ff 48 89 85 58 ff ff ff e9 fe f3 ff ff f7 c7 00 01 00 00 b8 02 00 00 00 44 0f 45 d0 e9 f6 f8 ff ff <0f> 0b bb f4 ff ff ff e9 b7 fa ff ff be 69 16 00 00 48 c7 c7 d0 
[  195.540184] RIP  [<ffffffffc03096d6>] __btrfs_map_block+0xe26/0x1180 [btrfs]
[  195.540696]  RSP <ffff8807f4833a90>
[  195.541196] ---[ end trace 575e86086f22e41b ]---


--Apple-Mail=_A7E3863F-5E50-4932-8C85-A0FEF7D5136A
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii



Hope you guys have some ideas!

Thanks,
Asif
--Apple-Mail=_A7E3863F-5E50-4932-8C85-A0FEF7D5136A--
