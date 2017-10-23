Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wolfsden.cz ([37.205.8.62]:40524 "EHLO wolfsden.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751116AbdJWIq3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 04:46:29 -0400
Received: from localhost (unknown [128.0.188.242])
        by wolfsden.cz (Postfix) with ESMTPSA id 4E3133BA82
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Oct 2017 08:39:34 +0000 (UTC)
Date: Mon, 23 Oct 2017 10:39:33 +0200
From: Wolf <wolf@wolfsden.cz>
To: linux-btrfs@vger.kernel.org
Subject: Scrub doesn't correct coruption
Message-ID: <20171023083933.wlm2ar5u44yjgmuq@wolfsden.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xvhozdi5oq3pj3ul"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xvhozdi5oq3pj3ul
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
I'm having problem with corruption in one file on my disk array. This is
third time it happened (probably). First time I didn't checked the
offending file so I'm not sure but it's likely. Btrfs scrub finds the
corruption, according to both dmesg and it's output it fixes it.
However, next run finds it too.

However, according to SMART the disk appears to be healthy (see below).
Plus the corruption is limited to one file.

Is this and issue somewhere inside btrfs or is disk HW related problem?

Thank you for your help :)

W.

smartctl -a /dev/sde
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  =
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   100   100   016    Pre-fail  Always   =
    -       0
  2 Throughput_Performance  0x0005   131   131   054    Pre-fail  Offline  =
    -       116
  3 Spin_Up_Time            0x0007   100   100   024    Pre-fail  Always   =
    -       0
  4 Start_Stop_Count        0x0012   100   100   000    Old_age   Always   =
    -       8
  5 Reallocated_Sector_Ct   0x0033   100   100   005    Pre-fail  Always   =
    -       0
  7 Seek_Error_Rate         0x000b   100   100   067    Pre-fail  Always   =
    -       0
  8 Seek_Time_Performance   0x0005   140   140   020    Pre-fail  Offline  =
    -       15
  9 Power_On_Hours          0x0012   100   100   000    Old_age   Always   =
    -       401
 10 Spin_Retry_Count        0x0013   100   100   060    Pre-fail  Always   =
    -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always   =
    -       8
 22 Unknown_Attribute       0x0023   100   100   025    Pre-fail  Always   =
    -       100
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always   =
    -       33
193 Load_Cycle_Count        0x0012   100   100   000    Old_age   Always   =
    -       33
194 Temperature_Celsius     0x0002   147   147   000    Old_age   Always   =
    -       44 (Min/Max 23/46)
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always   =
    -       0
197 Current_Pending_Sector  0x0022   100   100   000    Old_age   Always   =
    -       0
198 Offline_Uncorrectable   0x0008   100   100   000    Old_age   Offline  =
    -       0
199 UDMA_CRC_Error_Count    0x000a   200   200   000    Old_age   Always   =
    -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)=
  LBA_of_first_error
# 1  Extended offline    Completed without error       00%       357       =
  -
# 2  Short offline       Completed without error       00%       335       =
  -

uname -a
=3D=3D=3D=3D=3D=3D=3D=3D

Linux ws 4.13.8-1-ARCH #1 SMP PREEMPT Wed Oct 18 11:49:44 CEST 2017 x86_64 =
GNU/Linux

btrfs --version
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

btrfs-progs v4.13

btrfs fi show
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Label: none  uuid: db7e86f5-649d-44ce-9514-53c7ee0fbe09
	Total devices 2 FS bytes used 9.91GiB
	devid    1 size 103.79GiB used 20.03GiB path /dev/mapper/storage1-root
	devid    2 size 103.79GiB used 20.03GiB path /dev/mapper/storage2-root

Label: 'RAID'  uuid: 9a4be3ac-e942-4e6a-bb24-2c4009a42572
	Total devices 7 FS bytes used 6.48TiB
	devid    1 size 1.82TiB used 715.03GiB path /dev/mapper/data3
	devid    2 size 1.82TiB used 715.00GiB path /dev/mapper/data4
	devid    3 size 2.73TiB used 1.40TiB path /dev/mapper/data2
	devid    4 size 2.73TiB used 1.40TiB path /dev/mapper/data1
	devid    5 size 2.73TiB used 1.40TiB path /dev/mapper/data5
	devid    6 size 2.73TiB used 1.40TiB path /dev/mapper/data6
	devid    7 size 7.28TiB used 5.95TiB path /dev/mapper/data7

btrfs fi df /raid
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Data, RAID1: total=3D6.47TiB, used=3D6.47TiB
System, RAID1: total=3D64.00MiB, used=3D944.00KiB
Metadata, RAID1: total=3D9.00GiB, used=3D7.56GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

dmesg
=3D=3D=3D=3D=3D

[    0.000000] microcode: microcode updated early to revision 0xba, date =
=3D 2017-04-09
[    0.000000] random: get_random_bytes called from start_kernel+0x42/0x4b7=
 with crng_init=3D0
[    0.000000] Linux version 4.13.8-1-ARCH (builduser@tobias) (gcc version =
7.2.0 (GCC)) #1 SMP PREEMPT Wed Oct 18 11:49:44 CEST 2017
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-linux root=3DUUID=
=3Ddb7e86f5-649d-44ce-9514-53c7ee0fbe09 rw cryptdevice=3DUUID=3Deb4011d2-38=
cd-467d-b515-7acf3ef68f01:storage1:allow-discards cryptkey=3Drootfs:/boot/c=
rypto_keyfile.bin cryptdevice2=3DUUID=3Ddd0821ae-8fc4-41d2-aab8-f313e2f6d0e=
8:storage2:allow-discards cryptkey2=3Drootfs:/boot/crypto_keyfile2.bin root=
=3D/dev/mapper/storage1-root
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point=
 registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registe=
rs'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.000000] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.000000] x86/fpu: Enabled xstate features 0x1f, context size is 960 b=
ytes, using 'compacted' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009abff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000002a1e8fff] usable
[    0.000000] BIOS-e820: [mem 0x000000002a1e9000-0x000000002a1e9fff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x000000002a1ea000-0x000000002a213fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000002a214000-0x000000002a267fff] usable
[    0.000000] BIOS-e820: [mem 0x000000002a268000-0x000000002af88fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x000000002af89000-0x00000000468e7fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000468e8000-0x00000000477affff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000477b0000-0x0000000047f99fff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x0000000047f9a000-0x0000000047ffefff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x0000000047fff000-0x0000000047ffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000048000000-0x00000000480fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fe010fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000475ffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] random: fast init done
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./Z170 Extr=
eme7+, BIOS P7.40 05/04/2017
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x476000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask 7F80000000 uncachable
[    0.000000]   1 base 0060000000 mask 7FE0000000 uncachable
[    0.000000]   2 base 0050000000 mask 7FF0000000 uncachable
[    0.000000]   3 base 004C000000 mask 7FFC000000 uncachable
[    0.000000]   4 base 004A000000 mask 7FFE000000 uncachable
[    0.000000]   5 base 0049000000 mask 7FFF000000 uncachable
[    0.000000]   6 base 0048800000 mask 7FFF800000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT
[    0.000000] e820: last_pfn =3D 0x48000 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fc780-0x000fc78f] mapped at =
[ffff9970800fc780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff997080094000] 94000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x445d64000, 0x445d64fff] PGTABLE
[    0.000000] BRK [0x445d65000, 0x445d65fff] PGTABLE
[    0.000000] BRK [0x445d66000, 0x445d66fff] PGTABLE
[    0.000000] BRK [0x445d67000, 0x445d67fff] PGTABLE
[    0.000000] BRK [0x445d68000, 0x445d68fff] PGTABLE
[    0.000000] BRK [0x445d69000, 0x445d69fff] PGTABLE
[    0.000000] BRK [0x445d6a000, 0x445d6afff] PGTABLE
[    0.000000] BRK [0x445d6b000, 0x445d6bfff] PGTABLE
[    0.000000] BRK [0x445d6c000, 0x445d6cfff] PGTABLE
[    0.000000] BRK [0x445d6d000, 0x445d6dfff] PGTABLE
[    0.000000] BRK [0x445d6e000, 0x445d6efff] PGTABLE
[    0.000000] RAMDISK: [mem 0x320db000-0x35064fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F05B0 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x0000000047F2D098 0000B4 (v01 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x0000000047F50380 00010C (v05 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x0000000047F2D1E8 023191 (v02 ALASKA A M I    01=
072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x0000000047F99F80 000040
[    0.000000] ACPI: APIC 0x0000000047F50490 000084 (v03 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x0000000047F50518 000044 (v01 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x0000000047F50560 00009C (v01 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x0000000047F50600 00003C (v01 ALASKA A M I    01=
072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x0000000047F50640 000038 (v01 ALASKA A M I    01=
072009 AMI. 0005000B)
[    0.000000] ACPI: SSDT 0x0000000047F50678 00036D (v01 SataRe SataTabl 00=
001000 INTL 20120913)
[    0.000000] ACPI: LPIT 0x0000000047F509E8 000094 (v01 INTEL  SKL      00=
000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x0000000047F50A80 00002B (v02 INTEL  UsbCTabl 00=
001000 INTL 20120913)
[    0.000000] ACPI: DBGP 0x0000000047F50AB0 000034 (v01 INTEL           00=
000000 MSFT 0000005F)
[    0.000000] ACPI: DBG2 0x0000000047F50AE8 000054 (v00 INTEL           00=
000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x0000000047F50B40 000614 (v02 INTEL  xh_rvp08 00=
000000 INTL 20120913)
[    0.000000] ACPI: AAFT 0x0000000047F51158 000334 (v01 ALASKA OEMAAFT  01=
072009 MSFT 00000097)
[    0.000000] ACPI: SSDT 0x0000000047F51490 005212 (v02 SaSsdt SaSsdt   00=
003000 INTL 20120913)
[    0.000000] ACPI: UEFI 0x0000000047F566A8 000042 (v01                 00=
000000      00000000)
[    0.000000] ACPI: SSDT 0x0000000047F566F0 000E58 (v02 CpuRef CpuSsdt  00=
003000 INTL 20120913)
[    0.000000] ACPI: DMAR 0x0000000047F57548 0000A8 (v01 INTEL  SKL      00=
000001 INTL 00000001)
[    0.000000] ACPI: ASF! 0x0000000047F575F0 0000A5 (v32 INTEL   HCG     00=
000001 TFSM 000F4240)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000475ffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x475ffb000-0x475ffffff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x0000000475ffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000099fff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000002a1e8fff]
[    0.000000]   node   0: [mem 0x000000002a214000-0x000000002a267fff]
[    0.000000]   node   0: [mem 0x000000002af89000-0x00000000468e7fff]
[    0.000000]   node   0: [mem 0x0000000047fff000-0x0000000047ffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x0000000475ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x0000000475fff=
fff]
[    0.000000] On node 0 totalpages: 3914550
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3993 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 4399 pages used for memmap
[    0.000000]   DMA32 zone: 281501 pages, LIFO batch:31
[    0.000000]   Normal zone: 56704 pages used for memmap
[    0.000000]   Normal zone: 3629056 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics memory at 0x0000000049000000-0x0000=
000088ffffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009afff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x2a1e9000-0x2a1e9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x2a1ea000-0x2a213fff]
[    0.000000] PM: Registered nosave memory: [mem 0x2a268000-0x2af88fff]
[    0.000000] PM: Registered nosave memory: [mem 0x468e8000-0x477affff]
[    0.000000] PM: Registered nosave memory: [mem 0x477b0000-0x47f99fff]
[    0.000000] PM: Registered nosave memory: [mem 0x47f9a000-0x47ffefff]
[    0.000000] PM: Registered nosave memory: [mem 0x48000000-0x480fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x48100000-0x48ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x49000000-0x88ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x89000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfdffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe000000-0xfe010fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe011000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0x89000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 6370452778343963 ns
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] percpu: Embedded 36 pages/cpu @ffff9974f5c00000 s106520 r819=
2 d32744 u524288
[    0.000000] pcpu-alloc: s106520 r8192 d32744 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 3853362
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-linux root=
=3DUUID=3Ddb7e86f5-649d-44ce-9514-53c7ee0fbe09 rw cryptdevice=3DUUID=3Deb40=
11d2-38cd-467d-b515-7acf3ef68f01:storage1:allow-discards cryptkey=3Drootfs:=
/boot/crypto_keyfile.bin cryptdevice2=3DUUID=3Ddd0821ae-8fc4-41d2-aab8-f313=
e2f6d0e8:storage2:allow-discards cryptkey2=3Drootfs:/boot/crypto_keyfile2.b=
in root=3D/dev/mapper/storage1-root
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 15283304K/15658200K available (6644K kernel code, 11=
34K rwdata, 2048K rodata, 1336K init, 908K bss, 374896K reserved, 0K cma-re=
served)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] ftrace: allocating 28353 entries in 111 pages
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D128 to nr_cpu_ids=3D4.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D4
[    0.000000] NR_IRQS: 8448, nr_irqs: 1024, preallocated irqs: 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, =
max_idle_ns: 79635855245 ns
[    0.000000] hpet clockevent registered
[    0.003333] tsc: Detected 3200.000 MHz processor
[    0.003333] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6386.00 BogoMIPS (lpj=3D10640000)
[    0.003333] pid_max: default: 32768 minimum: 301
[    0.003333] ACPI: Core revision 20170531
[    0.021894] ACPI Error: [\_SB_.PCI0.XHC_.RHUB.HS11] Namespace lookup fai=
lure, AE_NOT_FOUND (20170531/dswload-210)
[    0.021900] ACPI Exception: AE_NOT_FOUND, During name lookup/catalog (20=
170531/psobject-252)
[    0.021928] ACPI Exception: AE_NOT_FOUND, (SSDT:xh_rvp08) while loading =
table (20170531/tbxfload-228)
[    0.027940] ACPI Error: 1 table load failures, 5 successful (20170531/tb=
xfload-246)
[    0.027958] Security Framework initialized
[    0.027959] Yama: becoming mindful.
[    0.029517] Dentry cache hash table entries: 2097152 (order: 12, 1677721=
6 bytes)
[    0.030355] Inode-cache hash table entries: 1048576 (order: 11, 8388608 =
bytes)
[    0.030383] Mount-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.030408] Mountpoint-cache hash table entries: 32768 (order: 6, 262144=
 bytes)
[    0.030533] CPU: Physical Processor ID: 0
[    0.030533] CPU: Processor Core ID: 0
[    0.030536] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.030536] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.030540] mce: CPU supports 8 MCE banks
[    0.030547] CPU0: Thermal monitoring enabled (TM1)
[    0.030558] process: using mwait in idle threads
[    0.030560] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.030560] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.030622] Freeing SMP alternatives memory: 24K
[    0.031209] smpboot: Max logical packages: 2
[    0.031212] DMAR: Host address width 39
[    0.031213] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.031217] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660=
462 ecap 7e3ff0505e
[    0.031218] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.031221] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008c406604=
62 ecap f050da
[    0.031222] DMAR: RMRR base: 0x00000047552000 end: 0x00000047571fff
[    0.031222] DMAR: RMRR base: 0x00000048800000 end: 0x00000088ffffff
[    0.031224] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.031224] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.031225] DMAR-IR: x2apic is disabled because BIOS sets x2apic opt out=
 bit.
[    0.031225] DMAR-IR: Use 'intremap=3Dno_x2apic_optout' to override the B=
IOS setting.
[    0.032568] DMAR-IR: Enabled IRQ remapping in xapic mode
[    0.032569] x2apic: IRQ remapping doesn't support X2APIC mode
[    0.036610] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.069647] TSC deadline timer enabled
[    0.069652] smpboot: CPU0: Intel(R) Core(TM) i3-6100T CPU @ 3.20GHz (fam=
ily: 0x6, model: 0x5e, stepping: 0x3)
[    0.080004] Performance Events: PEBS fmt3+, Skylake events, 32-deep LBR,=
 full-width counters, Intel PMU driver.
[    0.080026] ... version:                4
[    0.080026] ... bit width:              48
[    0.080027] ... generic registers:      4
[    0.080027] ... value mask:             0000ffffffffffff
[    0.080027] ... max period:             00007fffffffffff
[    0.080028] ... fixed-purpose events:   3
[    0.080028] ... event mask:             000000070000000f
[    0.086668] Hierarchical SRCU implementation.
[    0.100045] NMI watchdog: enabled on all CPUs, permanently consumes one =
hw-PMU counter.
[    0.106668] smp: Bringing up secondary CPUs ...
[    0.133341] x86: Booting SMP configuration:
[    0.133341] .... node  #0, CPUs:      #1 #2 #3
[    0.436689] smp: Brought up 1 node, 4 CPUs
[    0.436689] smpboot: Total of 4 processors activated (25550.68 BogoMIPS)
[    0.439557] devtmpfs: initialized
[    0.439557] x86/mm: Memory block size: 128MB
[    0.440430] PM: Registering ACPI NVS region [mem 0x2a1e9000-0x2a1e9fff] =
(4096 bytes)
[    0.440430] PM: Registering ACPI NVS region [mem 0x477b0000-0x47f99fff] =
(8298496 bytes)
[    0.440430] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 6370867519511994 ns
[    0.440430] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.440430] pinctrl core: initialized pinctrl subsystem
[    0.440430] RTC time: 20:17:11, date: 10/22/17
[    0.440430] NET: Registered protocol family 16
[    0.440430] cpuidle: using governor ladder
[    0.440430] cpuidle: using governor menu
[    0.440430] PCCT header not found.
[    0.440430] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.440430] ACPI: bus type PCI registered
[    0.440430] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.440430] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000=
-0xefffffff] (base 0xe0000000)
[    0.440430] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.440430] PCI: Using configuration type 1 for base access
[    0.440504] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.440504] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.440504] ACPI: Added _OSI(Module Device)
[    0.440504] ACPI: Added _OSI(Processor Device)
[    0.440504] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.440504] ACPI: Added _OSI(Processor Aggregator Device)
[    0.440609] ACPI: Executed 21 blocks of module-level executable AML code
[    0.449813] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.452445] ACPI: Dynamic OEM Table Load:
[    0.452449] ACPI: SSDT 0xFFFF9974E42D8000 0006A2 (v02 PmRef  Cpu0Ist  00=
003000 INTL 20120913)
[    0.452639] ACPI: \_PR_.CPU0: _OSC native thermal LVT Acked
[    0.455511] ACPI: Dynamic OEM Table Load:
[    0.455514] ACPI: SSDT 0xFFFF9974E42D8800 0005AA (v02 PmRef  ApIst    00=
003000 INTL 20120913)
[    0.458006] ACPI: Interpreter enabled
[    0.458036] ACPI: (supports S0 S4 S5)
[    0.458037] ACPI: Using IOAPIC for interrupt routing
[    0.458094] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.462531] ACPI: Power Resource [WRST] (off)
[    0.462787] ACPI: Power Resource [WRST] (off)
[    0.463021] ACPI: Power Resource [WRST] (off)
[    0.463253] ACPI: Power Resource [WRST] (off)
[    0.463490] ACPI: Power Resource [WRST] (off)
[    0.463811] ACPI: Power Resource [WRST] (off)
[    0.464061] ACPI: Power Resource [WRST] (off)
[    0.464317] ACPI: Power Resource [WRST] (off)
[    0.464788] ACPI: Power Resource [WRST] (off)
[    0.465020] ACPI: Power Resource [WRST] (off)
[    0.465269] ACPI: Power Resource [WRST] (off)
[    0.465503] ACPI: Power Resource [WRST] (off)
[    0.465734] ACPI: Power Resource [WRST] (off)
[    0.465965] ACPI: Power Resource [WRST] (off)
[    0.466213] ACPI: Power Resource [WRST] (off)
[    0.466443] ACPI: Power Resource [WRST] (off)
[    0.466682] ACPI: Power Resource [WRST] (off)
[    0.466914] ACPI: Power Resource [WRST] (off)
[    0.467146] ACPI: Power Resource [WRST] (off)
[    0.467378] ACPI: Power Resource [WRST] (off)
[    0.476808] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.476812] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cloc=
kPM Segments MSI]
[    0.478001] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER =
PCIeCapability]
[    0.478001] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using B=
IOS configuration
[    0.478494] PCI host bridge to bus 0000:00
[    0.478495] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.478496] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.478497] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f window]
[    0.478497] pci_bus 0000:00: root bus resource [mem 0x89000000-0xdffffff=
f window]
[    0.478498] pci_bus 0000:00: root bus resource [mem 0xfd000000-0xfe7ffff=
f window]
[    0.478499] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.478504] pci 0000:00:00.0: [8086:190f] type 00 class 0x060000
[    0.478749] pci 0000:00:02.0: [8086:1912] type 00 class 0x030000
[    0.478757] pci 0000:00:02.0: reg 0x10: [mem 0xde000000-0xdeffffff 64bit]
[    0.478761] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit=
 pref]
[    0.478764] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.478915] pci 0000:00:14.0: [8086:a12f] type 00 class 0x0c0330
[    0.478934] pci 0000:00:14.0: reg 0x10: [mem 0xdf430000-0xdf43ffff 64bit]
[    0.478989] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.479087] pci 0000:00:14.2: [8086:a131] type 00 class 0x118000
[    0.479104] pci 0000:00:14.2: reg 0x10: [mem 0xdf44e000-0xdf44efff 64bit]
[    0.479235] pci 0000:00:16.0: [8086:a13a] type 00 class 0x078000
[    0.479257] pci 0000:00:16.0: reg 0x10: [mem 0xdf44d000-0xdf44dfff 64bit]
[    0.479314] pci 0000:00:16.0: PME# supported from D3hot
[    0.479424] pci 0000:00:17.0: [8086:a102] type 00 class 0x010601
[    0.479438] pci 0000:00:17.0: reg 0x10: [mem 0xdf448000-0xdf449fff]
[    0.479443] pci 0000:00:17.0: reg 0x14: [mem 0xdf44c000-0xdf44c0ff]
[    0.479449] pci 0000:00:17.0: reg 0x18: [io  0xf090-0xf097]
[    0.479455] pci 0000:00:17.0: reg 0x1c: [io  0xf080-0xf083]
[    0.479460] pci 0000:00:17.0: reg 0x20: [io  0xf060-0xf07f]
[    0.479466] pci 0000:00:17.0: reg 0x24: [mem 0xdf44b000-0xdf44b7ff]
[    0.479497] pci 0000:00:17.0: PME# supported from D3hot
[    0.479599] pci 0000:00:1c.0: [8086:a110] type 01 class 0x060400
[    0.479651] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.479762] pci 0000:00:1c.2: [8086:a112] type 01 class 0x060400
[    0.479814] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.479946] pci 0000:00:1f.0: [8086:a145] type 00 class 0x060100
[    0.480131] pci 0000:00:1f.2: [8086:a121] type 00 class 0x058000
[    0.480144] pci 0000:00:1f.2: reg 0x10: [mem 0xdf444000-0xdf447fff]
[    0.480278] pci 0000:00:1f.3: [8086:a170] type 00 class 0x040300
[    0.480302] pci 0000:00:1f.3: reg 0x10: [mem 0xdf440000-0xdf443fff 64bit]
[    0.480330] pci 0000:00:1f.3: reg 0x20: [mem 0xdf420000-0xdf42ffff 64bit]
[    0.480372] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.480513] pci 0000:00:1f.4: [8086:a123] type 00 class 0x0c0500
[    0.480572] pci 0000:00:1f.4: reg 0x10: [mem 0xdf44a000-0xdf44a0ff 64bit]
[    0.480641] pci 0000:00:1f.4: reg 0x20: [io  0xf040-0xf05f]
[    0.480806] pci 0000:00:1f.6: [8086:15b8] type 00 class 0x020000
[    0.480831] pci 0000:00:1f.6: reg 0x10: [mem 0xdf400000-0xdf41ffff]
[    0.480931] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
[    0.481088] pci 0000:01:00.0: [1b4b:9130] type 00 class 0x010601
[    0.481105] pci 0000:01:00.0: reg 0x10: [io  0xe050-0xe057]
[    0.481112] pci 0000:01:00.0: reg 0x14: [io  0xe040-0xe043]
[    0.481119] pci 0000:01:00.0: reg 0x18: [io  0xe030-0xe037]
[    0.481126] pci 0000:01:00.0: reg 0x1c: [io  0xe020-0xe023]
[    0.481134] pci 0000:01:00.0: reg 0x20: [io  0xe000-0xe01f]
[    0.481141] pci 0000:01:00.0: reg 0x24: [mem 0xdf310000-0xdf3107ff]
[    0.481148] pci 0000:01:00.0: reg 0x30: [mem 0xdf300000-0xdf30ffff pref]
[    0.481159] pci 0000:01:00.0: Enabling fixed DMA alias to 00.1
[    0.481193] pci 0000:01:00.0: PME# supported from D3hot
[    0.481265] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.481267] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[    0.481269] pci 0000:00:1c.0:   bridge window [mem 0xdf300000-0xdf3fffff]
[    0.481338] pci 0000:02:00.0: [1b21:1187] type 01 class 0x060400
[    0.481434] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.481515] pci 0000:00:1c.2: PCI bridge to [bus 02-07]
[    0.481516] pci 0000:00:1c.2:   bridge window [io  0xb000-0xdfff]
[    0.481518] pci 0000:00:1c.2:   bridge window [mem 0xdf000000-0xdf2fffff]
[    0.481567] pci 0000:03:04.0: [1b21:1187] type 01 class 0x060400
[    0.481663] pci 0000:03:04.0: PME# supported from D0 D3hot D3cold
[    0.481709] pci 0000:03:05.0: [1b21:1187] type 01 class 0x060400
[    0.481804] pci 0000:03:05.0: PME# supported from D0 D3hot D3cold
[    0.481849] pci 0000:03:06.0: [1b21:1187] type 01 class 0x060400
[    0.481944] pci 0000:03:06.0: PME# supported from D0 D3hot D3cold
[    0.481990] pci 0000:03:07.0: [1b21:1187] type 01 class 0x060400
[    0.482084] pci 0000:03:07.0: PME# supported from D0 D3hot D3cold
[    0.482144] pci 0000:02:00.0: PCI bridge to [bus 03-07]
[    0.482148] pci 0000:02:00.0:   bridge window [io  0xb000-0xdfff]
[    0.482151] pci 0000:02:00.0:   bridge window [mem 0xdf000000-0xdf2fffff]
[    0.482187] pci 0000:03:04.0: PCI bridge to [bus 04]
[    0.482247] pci 0000:05:00.0: [1b21:0612] type 00 class 0x010601
[    0.482275] pci 0000:05:00.0: reg 0x10: [io  0xd050-0xd057]
[    0.482287] pci 0000:05:00.0: reg 0x14: [io  0xd040-0xd043]
[    0.482300] pci 0000:05:00.0: reg 0x18: [io  0xd030-0xd037]
[    0.482312] pci 0000:05:00.0: reg 0x1c: [io  0xd020-0xd023]
[    0.482324] pci 0000:05:00.0: reg 0x20: [io  0xd000-0xd01f]
[    0.482336] pci 0000:05:00.0: reg 0x24: [mem 0xdf200000-0xdf2001ff]
[    0.490017] pci 0000:03:05.0: PCI bridge to [bus 05]
[    0.490021] pci 0000:03:05.0:   bridge window [io  0xd000-0xdfff]
[    0.490024] pci 0000:03:05.0:   bridge window [mem 0xdf200000-0xdf2fffff]
[    0.490078] pci 0000:06:00.0: [1b21:0612] type 00 class 0x010601
[    0.490106] pci 0000:06:00.0: reg 0x10: [io  0xc050-0xc057]
[    0.490118] pci 0000:06:00.0: reg 0x14: [io  0xc040-0xc043]
[    0.490129] pci 0000:06:00.0: reg 0x18: [io  0xc030-0xc037]
[    0.490141] pci 0000:06:00.0: reg 0x1c: [io  0xc020-0xc023]
[    0.490153] pci 0000:06:00.0: reg 0x20: [io  0xc000-0xc01f]
[    0.490165] pci 0000:06:00.0: reg 0x24: [mem 0xdf100000-0xdf1001ff]
[    0.500015] pci 0000:03:06.0: PCI bridge to [bus 06]
[    0.500019] pci 0000:03:06.0:   bridge window [io  0xc000-0xcfff]
[    0.500022] pci 0000:03:06.0:   bridge window [mem 0xdf100000-0xdf1fffff]
[    0.500076] pci 0000:07:00.0: [1b4b:9130] type 00 class 0x010601
[    0.500102] pci 0000:07:00.0: reg 0x10: [io  0xb050-0xb057]
[    0.500113] pci 0000:07:00.0: reg 0x14: [io  0xb040-0xb043]
[    0.500124] pci 0000:07:00.0: reg 0x18: [io  0xb030-0xb037]
[    0.500135] pci 0000:07:00.0: reg 0x1c: [io  0xb020-0xb023]
[    0.500146] pci 0000:07:00.0: reg 0x20: [io  0xb000-0xb01f]
[    0.500157] pci 0000:07:00.0: reg 0x24: [mem 0xdf010000-0xdf0107ff]
[    0.500168] pci 0000:07:00.0: reg 0x30: [mem 0xdf000000-0xdf00ffff pref]
[    0.500183] pci 0000:07:00.0: Enabling fixed DMA alias to 00.1
[    0.500237] pci 0000:07:00.0: PME# supported from D3hot
[    0.510014] pci 0000:03:07.0: PCI bridge to [bus 07]
[    0.510019] pci 0000:03:07.0:   bridge window [io  0xb000-0xbfff]
[    0.510021] pci 0000:03:07.0:   bridge window [mem 0xdf000000-0xdf0fffff]
[    0.511452] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    0.511489] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 1=
5)
[    0.511525] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    0.511560] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    0.511595] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    0.511629] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    0.511664] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    0.511698] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    0.511911] ACPI: Enabled 5 GPEs in block 00 to 7F
[    0.511967] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.511967] pci 0000:00:02.0: vgaarb: VGA device added: decodes=3Dio+mem=
,owns=3Dio+mem,locks=3Dnone
[    0.511967] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.511967] vgaarb: loaded
[    0.511967] EDAC MC: Ver: 3.0.0
[    0.511967] PCI: Using ACPI for IRQ routing
[    0.539626] PCI: pci_cache_line_size set to 64 bytes
[    0.539683] e820: reserve RAM buffer [mem 0x0009ac00-0x0009ffff]
[    0.539688] e820: reserve RAM buffer [mem 0x2a1e9000-0x2bffffff]
[    0.539689] e820: reserve RAM buffer [mem 0x2a268000-0x2bffffff]
[    0.539690] e820: reserve RAM buffer [mem 0x468e8000-0x47ffffff]
[    0.539690] e820: reserve RAM buffer [mem 0x476000000-0x477ffffff]
[    0.539742] NetLabel: Initializing
[    0.539742] NetLabel:  domain hash size =3D 128
[    0.539742] NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
[    0.539752] NetLabel:  unlabeled traffic allowed by default
[    0.540027] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.540031] hpet0: 8 comparators, 64-bit 24.000000 MHz counter
[    0.542071] clocksource: Switched to clocksource hpet
[    0.545443] VFS: Disk quotas dquot_6.6.0
[    0.545453] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)
[    0.545496] pnp: PnP ACPI init
[    0.545741] system 00:00: [io  0x0280-0x028f] has been reserved
[    0.545742] system 00:00: [io  0x0290-0x029f] has been reserved
[    0.545743] system 00:00: [io  0x02a0-0x02af] has been reserved
[    0.545744] system 00:00: [io  0x02b0-0x02bf] has been reserved
[    0.545746] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.545922] pnp 00:01: [dma 0 disabled]
[    0.545950] pnp 00:01: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.546044] system 00:02: [io  0x0680-0x069f] has been reserved
[    0.546045] system 00:02: [io  0xffff] has been reserved
[    0.546046] system 00:02: [io  0xffff] has been reserved
[    0.546047] system 00:02: [io  0xffff] has been reserved
[    0.546048] system 00:02: [io  0x1800-0x18fe] has been reserved
[    0.546048] system 00:02: [io  0x164e-0x164f] has been reserved
[    0.546050] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.546113] system 00:03: [io  0x0800-0x087f] has been reserved
[    0.546114] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.546126] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.546150] system 00:05: [io  0x1854-0x1857] has been reserved
[    0.546151] system 00:05: Plug and Play ACPI device, IDs INT3f0d PNP0c02=
 (active)
[    0.546318] system 00:06: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.546319] system 00:06: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.546320] system 00:06: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.546321] system 00:06: [mem 0xe0000000-0xefffffff] has been reserved
[    0.546322] system 00:06: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.546323] system 00:06: [mem 0xfed90000-0xfed93fff] could not be reser=
ved
[    0.546323] system 00:06: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.546324] system 00:06: [mem 0xff000000-0xffffffff] has been reserved
[    0.546325] system 00:06: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    0.546326] system 00:06: [mem 0xdffc0000-0xdffdffff] has been reserved
[    0.546327] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.546354] system 00:07: [mem 0xfd000000-0xfdabffff] has been reserved
[    0.546355] system 00:07: [mem 0xfdad0000-0xfdadffff] has been reserved
[    0.546356] system 00:07: [mem 0xfdb00000-0xfdffffff] has been reserved
[    0.546357] system 00:07: [mem 0xfe000000-0xfe01ffff] could not be reser=
ved
[    0.546358] system 00:07: [mem 0xfe036000-0xfe03bfff] has been reserved
[    0.546358] system 00:07: [mem 0xfe03d000-0xfe3fffff] has been reserved
[    0.546359] system 00:07: [mem 0xfe410000-0xfe7fffff] has been reserved
[    0.546360] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.546571] system 00:08: [io  0xff00-0xfffe] has been reserved
[    0.546573] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.547383] system 00:09: [mem 0xfdaf0000-0xfdafffff] has been reserved
[    0.547384] system 00:09: [mem 0xfdae0000-0xfdaeffff] has been reserved
[    0.547385] system 00:09: [mem 0xfdac0000-0xfdacffff] has been reserved
[    0.547386] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.547983] pnp: PnP ACPI: found 10 devices
[    0.555471] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, m=
ax_idle_ns: 2085701024 ns
[    0.555518] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.555520] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[    0.555522] pci 0000:00:1c.0:   bridge window [mem 0xdf300000-0xdf3fffff]
[    0.555527] pci 0000:03:04.0: PCI bridge to [bus 04]
[    0.555538] pci 0000:03:05.0: PCI bridge to [bus 05]
[    0.555539] pci 0000:03:05.0:   bridge window [io  0xd000-0xdfff]
[    0.555543] pci 0000:03:05.0:   bridge window [mem 0xdf200000-0xdf2fffff]
[    0.555550] pci 0000:03:06.0: PCI bridge to [bus 06]
[    0.555552] pci 0000:03:06.0:   bridge window [io  0xc000-0xcfff]
[    0.555556] pci 0000:03:06.0:   bridge window [mem 0xdf100000-0xdf1fffff]
[    0.555563] pci 0000:03:07.0: PCI bridge to [bus 07]
[    0.555564] pci 0000:03:07.0:   bridge window [io  0xb000-0xbfff]
[    0.555568] pci 0000:03:07.0:   bridge window [mem 0xdf000000-0xdf0fffff]
[    0.555575] pci 0000:02:00.0: PCI bridge to [bus 03-07]
[    0.555577] pci 0000:02:00.0:   bridge window [io  0xb000-0xdfff]
[    0.555580] pci 0000:02:00.0:   bridge window [mem 0xdf000000-0xdf2fffff]
[    0.555587] pci 0000:00:1c.2: PCI bridge to [bus 02-07]
[    0.555588] pci 0000:00:1c.2:   bridge window [io  0xb000-0xdfff]
[    0.555591] pci 0000:00:1c.2:   bridge window [mem 0xdf000000-0xdf2fffff]
[    0.555596] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.555596] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.555597] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff windo=
w]
[    0.555598] pci_bus 0000:00: resource 7 [mem 0x89000000-0xdfffffff windo=
w]
[    0.555599] pci_bus 0000:00: resource 8 [mem 0xfd000000-0xfe7fffff windo=
w]
[    0.555599] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.555600] pci_bus 0000:01: resource 1 [mem 0xdf300000-0xdf3fffff]
[    0.555601] pci_bus 0000:02: resource 0 [io  0xb000-0xdfff]
[    0.555602] pci_bus 0000:02: resource 1 [mem 0xdf000000-0xdf2fffff]
[    0.555602] pci_bus 0000:03: resource 0 [io  0xb000-0xdfff]
[    0.555603] pci_bus 0000:03: resource 1 [mem 0xdf000000-0xdf2fffff]
[    0.555604] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.555604] pci_bus 0000:05: resource 1 [mem 0xdf200000-0xdf2fffff]
[    0.555605] pci_bus 0000:06: resource 0 [io  0xc000-0xcfff]
[    0.555606] pci_bus 0000:06: resource 1 [mem 0xdf100000-0xdf1fffff]
[    0.555607] pci_bus 0000:07: resource 0 [io  0xb000-0xbfff]
[    0.555607] pci_bus 0000:07: resource 1 [mem 0xdf000000-0xdf0fffff]
[    0.555716] NET: Registered protocol family 2
[    0.555821] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.555945] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.556021] TCP: Hash tables configured (established 131072 bind 65536)
[    0.556042] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.556077] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.556118] NET: Registered protocol family 1
[    0.556127] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x0=
00c0000-0x000dffff]
[    0.556980] PCI: CLS 0 bytes, default 64
[    0.557000] Unpacking initramfs...
[    0.570589] Freeing initrd memory: 48680K
[    0.570611] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.570613] software IO TLB [mem 0x428e8000-0x468e8000] (64MB) mapped at=
 [ffff9970c28e8000-ffff9970c68e7fff]
[    0.570761] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2e0=
2c4a121d, max_idle_ns: 440795236083 ns
[    0.570859] Scanning for low memory corruption every 60 seconds
[    0.571223] Initialise system trusted keyrings
[    0.571229] Key type blacklist registered
[    0.571284] workingset: timestamp_bits=3D40 max_order=3D22 bucket_order=
=3D0
[    0.571917] zbud: loaded
[    0.574164] Key type asymmetric registered
[    0.574182] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    0.574223] io scheduler noop registered
[    0.574224] io scheduler deadline registered
[    0.574238] io scheduler cfq registered (default)
[    0.574239] io scheduler mq-deadline registered
[    0.574239] io scheduler kyber registered
[    0.574252] io scheduler bfq registered
[    0.575239] pcieport 0000:00:1c.0: Signaling PME with IRQ 122
[    0.575248] pcieport 0000:00:1c.2: Signaling PME with IRQ 123
[    0.575268] vesafb: mode is 1920x1080x32, linelength=3D7680, pages=3D0
[    0.575268] vesafb: scrolling: redraw
[    0.575269] vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    0.575276] vesafb: framebuffer at 0xc0000000, mapped to 0xffffb4d982000=
000, using 8128k, total 8128k
[    0.712407] Console: switching to colour frame buffer device 240x67
[    0.848941] fb0: VESA VGA frame buffer device
[    0.848949] intel_idle: MWAIT substates: 0x142120
[    0.848949] intel_idle: v0.4.1 model 0x5E
[    0.849135] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.849210] GHES: HEST is not enabled!
[    0.849292] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.869997] 00:01: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    0.870806] rtc_cmos 00:04: RTC can wake from S4
[    0.871197] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.871278] rtc_cmos 00:04: alarms up to one month, y3k, 242 bytes nvram=
, hpet irqs
[    0.871282] intel_pstate: Intel P-state driver initializing
[    0.871609] intel_pstate: HWP enabled
[    0.871741] ledtrig-cpu: registered to indicate activity on CPUs
[    0.871769] vlv2_plat_clk vlv2_plat_clk: vlv2_plat_clk initialized
[    0.871899] NET: Registered protocol family 10
[    0.874365] Segment Routing with IPv6
[    0.874378] NET: Registered protocol family 17
[    0.874655] RAS: Correctable Errors collector initialized.
[    0.874684] microcode: sig=3D0x506e3, pf=3D0x2, revision=3D0xba
[    0.874770] microcode: Microcode Update Driver: v2.2.
[    0.874776] sched_clock: Marking stable (874758794, 0)->(876593170, -183=
4376)
[    0.875110] registered taskstats version 1
[    0.875114] Loading compiled-in X.509 certificates
[    0.875123] zswap: loaded using pool lzo/zbud
[    0.876863] Key type big_key registered
[    0.877483]   Magic number: 5:520:296
[    0.877495] tty tty29: hash matches
[    0.877653] rtc_cmos 00:04: setting system clock to 2017-10-22 20:17:12 =
UTC (1508703432)
[    0.878068] PM: Hibernation image not present or could not be loaded.
[    0.878832] Freeing unused kernel memory: 1336K
[    0.878833] Write protecting the kernel read-only data: 10240k
[    0.879076] Freeing unused kernel memory: 1536K
[    0.890448] Linux agpgart interface v0.103
[    0.893441] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0E:00/input/input0
[    0.893452] ACPI: Sleep Button [SLPB]
[    0.893490] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input1
[    0.893497] ACPI: Power Button [PWRB]
[    0.893532] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input2
[    0.893564] ACPI: Power Button [PWRF]
[    0.901249] [drm] Memory usable by graphics device =3D 4096M
[    0.901250] checking generic (c0000000 7f0000) vs hw (c0000000 10000000)
[    0.901251] fb: switching to inteldrmfb from VESA VGA
[    0.901264] Console: switching to colour dummy device 80x25
[    0.901448] [drm] Replacing VGA console driver
[    0.906847] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.906848] [drm] Driver supports precise vblank timestamp query.
[    0.913815] [drm] Finished loading DMC firmware i915/skl_dmc_ver1_26.bin=
 (v1.26)
[    0.914341] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[    0.915780] [drm] Initialized i915 1.6.0 20170619 for 0000:00:02.0 on mi=
nor 0
[    0.917191] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: n=
o)
[    0.917650] acpi device:0f: registered as cooling_device4
[    0.917716] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08=
:00/LNXVIDEO:00/input/input3
[    1.004704] fbcon: inteldrmfb (fb0) is primary device
[    1.047320] Console: switching to colour frame buffer device 240x67
[    1.075016] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.161111] i8042: PNP: No PS/2 controller found.
[    1.173053] SCSI subsystem initialized
[    1.173070] ACPI: bus type USB registered
[    1.173086] usbcore: registered new interface driver usbfs
[    1.173093] usbcore: registered new interface driver hub
[    1.173112] usbcore: registered new device driver usb
[    1.174326] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.174331] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus =
number 1
[    1.175452] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x1=
00 quirks 0x00109810
[    1.175468] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.175691] hub 1-0:1.0: USB hub found
[    1.175719] hub 1-0:1.0: 16 ports detected
[    1.176028] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.176030] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus =
number 2
[    1.176137] hub 2-0:1.0: USB hub found
[    1.176149] hub 2-0:1.0: 10 ports detected
[    1.176719] libata version 3.00 loaded.
[    1.187082] i8042: PNP: No PS/2 controller found.
[    1.187299] ahci 0000:00:17.0: version 3.0
[    1.188434] AVX2 version of gcm_enc/dec engaged.
[    1.188435] AES CTR mode by8 optimization enabled
[    1.197665] ahci 0000:00:17.0: AHCI 0001.0301 32 slots 6 ports 6 Gbps 0x=
3f impl SATA mode
[    1.197667] ahci 0000:00:17.0: flags: 64bit ncq sntf pm led clo only pio=
 slum part ems deso sadm sds apst
[    1.250984] scsi host0: ahci
[    1.251181] scsi host1: ahci
[    1.251387] scsi host2: ahci
[    1.251567] scsi host3: ahci
[    1.251717] scsi host4: ahci
[    1.251869] scsi host5: ahci
[    1.251927] ata1: SATA max UDMA/133 abar m2048@0xdf44b000 port 0xdf44b10=
0 irq 131
[    1.251929] ata2: SATA max UDMA/133 abar m2048@0xdf44b000 port 0xdf44b18=
0 irq 131
[    1.251932] ata3: SATA max UDMA/133 abar m2048@0xdf44b000 port 0xdf44b20=
0 irq 131
[    1.251935] ata4: SATA max UDMA/133 abar m2048@0xdf44b000 port 0xdf44b28=
0 irq 131
[    1.251936] ata5: SATA max UDMA/133 abar m2048@0xdf44b000 port 0xdf44b30=
0 irq 131
[    1.251938] ata6: SATA max UDMA/133 abar m2048@0xdf44b000 port 0xdf44b38=
0 irq 131
[    1.262373] ahci 0000:01:00.0: AHCI 0001.0200 32 slots 8 ports 6 Gbps 0x=
ff impl SATA mode
[    1.262376] ahci 0000:01:00.0: flags: 64bit ncq pio
[    1.263884] scsi host6: ahci
[    1.264108] scsi host7: ahci
[    1.264295] scsi host8: ahci
[    1.264485] scsi host9: ahci
[    1.264680] scsi host10: ahci
[    1.264914] scsi host11: ahci
[    1.265173] scsi host12: ahci
[    1.265460] scsi host13: ahci
[    1.265582] ata7: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf31010=
0 irq 132
[    1.265586] ata8: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf31018=
0 irq 132
[    1.265591] ata9: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf31020=
0 irq 132
[    1.265595] ata10: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf3102=
80 irq 132
[    1.265599] ata11: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf3103=
00 irq 132
[    1.265603] ata12: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf3103=
80 irq 132
[    1.265606] ata13: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf3104=
00 irq 132
[    1.265610] ata14: SATA max UDMA/133 abar m2048@0xdf310000 port 0xdf3104=
80 irq 132
[    1.266030] ahci 0000:05:00.0: SSS flag set, parallel bus scan disabled
[    1.266089] ahci 0000:05:00.0: AHCI 0001.0200 32 slots 2 ports 6 Gbps 0x=
3 impl SATA mode
[    1.266095] ahci 0000:05:00.0: flags: 64bit ncq sntf stag led clo pmp pi=
o slum part ccc sxs
[    1.266835] scsi host14: ahci
[    1.267063] scsi host15: ahci
[    1.267209] ata15: SATA max UDMA/133 abar m512@0xdf200000 port 0xdf20010=
0 irq 133
[    1.267214] ata16: SATA max UDMA/133 abar m512@0xdf200000 port 0xdf20018=
0 irq 133
[    1.267589] ahci 0000:06:00.0: SSS flag set, parallel bus scan disabled
[    1.267678] ahci 0000:06:00.0: AHCI 0001.0200 32 slots 2 ports 6 Gbps 0x=
3 impl SATA mode
[    1.267683] ahci 0000:06:00.0: flags: 64bit ncq sntf stag led clo pmp pi=
o slum part ccc sxs
[    1.268303] scsi host16: ahci
[    1.268526] scsi host17: ahci
[    1.268626] ata17: SATA max UDMA/133 abar m512@0xdf100000 port 0xdf10010=
0 irq 134
[    1.268630] ata18: SATA max UDMA/133 abar m512@0xdf100000 port 0xdf10018=
0 irq 134
[    1.279171] ahci 0000:07:00.0: AHCI 0001.0200 32 slots 8 ports 6 Gbps 0x=
ff impl SATA mode
[    1.279176] ahci 0000:07:00.0: flags: 64bit ncq pio
[    1.280913] scsi host18: ahci
[    1.281196] scsi host19: ahci
[    1.281456] scsi host20: ahci
[    1.281754] scsi host21: ahci
[    1.282039] scsi host22: ahci
[    1.282292] scsi host23: ahci
[    1.282527] scsi host24: ahci
[    1.282750] scsi host25: ahci
[    1.282843] ata19: SATA max UDMA/133 abar m2048@0xdf010000 port 0xdf0101=
00 irq 135
[    1.282848] ata20: SATA max UDMA/133 abar m2048@0xdf010000 port 0xdf0101=
80 irq 135
[    1.282852] ata21: SATA max UDMA/133 abar m2048@0xdf010000 port 0xdf0102=
00 irq 135
[    1.282855] ata22: SATA max UDMA/133 abar m2048@0xdf010000 port 0xdf0102=
80 irq 135
[    1.282859] ata23: SATA max UDMA/133 abar m2048@0xdf010000 port 0xdf0103=
00 irq 135
[    1.282862] ata24: SATA max UDMA/133 abar m2048@0xdf010000 port 0xdf0103=
80 irq 135
[    1.282866] ata25: SATA max UDMA/133 abar m2048@0xdf010000 port 0xdf0104=
00 irq 135
[    1.282869] ata26: SATA max UDMA/133 abar m2048@0xdf010000 port 0xdf0104=
80 irq 135
[    1.493398] usb 1-3: new low-speed USB device number 2 using xhci_hcd
[    1.564422] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.564449] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.564474] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.564498] ata3: SATA link down (SStatus 4 SControl 300)
[    1.564528] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.564551] ata2: SATA link down (SStatus 4 SControl 300)
[    1.565160] ata5.00: ATA-9: WDC WD30EFRX-68EUZN0, 82.00A82, max UDMA/133
[    1.565165] ata5.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.565181] ata6.00: ATA-9: WDC WD30EFRX-68EUZN0, 82.00A82, max UDMA/133
[    1.565185] ata6.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.565857] ata6.00: configured for UDMA/133
[    1.565889] ata5.00: configured for UDMA/133
[    1.568576] ata4.00: ATA-9: KINGSTON SM2280S3G2120G, SAFM01.W, max UDMA/=
133
[    1.568579] ata4.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 31/32)=
, AA
[    1.568725] ata1.00: ATA-9: KINGSTON SM2280S3G2120G, SAFM01.W, max UDMA/=
133
[    1.568727] ata1.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 31/32)=
, AA
[    1.568789] ata4.00: configured for UDMA/133
[    1.568903] ata1.00: configured for UDMA/133
[    1.569299] scsi 0:0:0:0: Direct-Access     ATA      KINGSTON SM2280S 01=
=2EW PQ: 0 ANSI: 5
[    1.573620] clocksource: Switched to clocksource tsc
[    1.580991] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 330)
[    1.581025] ata7: SATA link down (SStatus 0 SControl 310)
[    1.581054] ata13: SATA link down (SStatus 0 SControl 310)
[    1.581094] ata11: SATA link down (SStatus 0 SControl 310)
[    1.581123] ata10: SATA link down (SStatus 0 SControl 310)
[    1.581150] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 330)
[    1.581175] ata9: SATA link down (SStatus 0 SControl 310)
[    1.581199] ata12: SATA link down (SStatus 0 SControl 310)
[    1.581221] ata14.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[    1.581467] ata14.00: configured for UDMA/66
[    1.584562] ata8.00: ATA-9: WDC WD80EFZX-68UW8N0, 83.H0A83, max UDMA/133
[    1.584566] ata8.00: 15628053168 sectors, multi 0: LBA48 NCQ (depth 31/3=
2), AA
[    1.590243] ata8.00: configured for UDMA/133
[    1.597504] ata21: SATA link down (SStatus 0 SControl 310)
[    1.597543] ata19: SATA link down (SStatus 0 SControl 310)
[    1.597582] ata23: SATA link down (SStatus 0 SControl 310)
[    1.597620] ata20: SATA link down (SStatus 0 SControl 310)
[    1.597654] ata25: SATA link down (SStatus 0 SControl 310)
[    1.597687] ata22: SATA link down (SStatus 0 SControl 310)
[    1.597720] ata24: SATA link down (SStatus 0 SControl 310)
[    1.597757] ata26: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.597914] ata26.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[    1.598198] ata26.00: configured for UDMA/66
[    1.604098] scsi 3:0:0:0: Direct-Access     ATA      KINGSTON SM2280S 01=
=2EW PQ: 0 ANSI: 5
[    1.637953] hidraw: raw HID events driver (C) Jiri Kosina
[    1.643072] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB=
/112 GiB)
[    1.643079] sd 0:0:0:0: [sda] Write Protect is off
[    1.643081] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.643095] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.643364]  sda: sda1
[    1.643498] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.646767] sd 3:0:0:0: [sdb] 234441648 512-byte logical blocks: (120 GB=
/112 GiB)
[    1.646774] sd 3:0:0:0: [sdb] Write Protect is off
[    1.646775] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.646799] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.646858] scsi 4:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68E 0A=
82 PQ: 0 ANSI: 5
[    1.647072]  sdb: sdb1
[    1.647193] sd 3:0:0:0: [sdb] Attached SCSI disk
[    1.690116] usbcore: registered new interface driver usbhid
[    1.690119] usbhid: USB HID core driver
[    1.692644] hid-generic 0003:051D:0002.0001: hiddev0,hidraw0: USB HID v1=
=2E10 Device [American Power Conversion Back-UPS XS 700U   FW:924.Z3 .I USB=
 FW:Z3 ] on usb-0000:00:14.0-3/input0
[    1.693755] sd 4:0:0:0: [sdc] 5860533168 512-byte logical blocks: (3.00 =
TB/2.73 TiB)
[    1.693761] sd 4:0:0:0: [sdc] 4096-byte physical blocks
[    1.693785] sd 4:0:0:0: [sdc] Write Protect is off
[    1.693789] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.693869] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.694146] scsi 5:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68E 0A=
82 PQ: 0 ANSI: 5
[    1.727065] sd 5:0:0:0: [sdd] 5860533168 512-byte logical blocks: (3.00 =
TB/2.73 TiB)
[    1.727071] sd 5:0:0:0: [sdd] 4096-byte physical blocks
[    1.727133] sd 5:0:0:0: [sdd] Write Protect is off
[    1.727138] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.727180] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.727410] scsi 7:0:0:0: Direct-Access     ATA      WDC WD80EFZX-68U 0A=
83 PQ: 0 ANSI: 5
[    1.736767] ata17: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.736772] ata15: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.736854] usb 2-5: new SuperSpeed USB device number 2 using xhci_hcd
[    1.737376] ata17.00: ATA-9: WDC WD20EZRZ-00Z5HB0, 80.00A80, max UDMA/133
[    1.737380] ata15.00: ATA-9: WDC WD30EFRX-68EUZN0, 82.00A82, max UDMA/133
[    1.737384] ata15.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/=
32), AA
[    1.737387] ata17.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/=
32), AA
[    1.737885] ata17.00: configured for UDMA/133
[    1.737970] ata15.00: configured for UDMA/133
[    1.741212]  sdc: sdc1
[    1.741876] sd 4:0:0:0: [sdc] Attached SCSI disk
[    1.755783] hub 2-5:1.0: USB hub found
[    1.755904] hub 2-5:1.0: 4 ports detected
[    1.773250]  sdd: sdd1
[    1.773854] sd 7:0:0:0: [sde] 15628053168 512-byte logical blocks: (8.00=
 TB/7.28 TiB)
[    1.773860] sd 7:0:0:0: [sde] 4096-byte physical blocks
[    1.773883] sd 7:0:0:0: [sde] Write Protect is off
[    1.773888] sd 7:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    1.773910] sd 5:0:0:0: [sdd] Attached SCSI disk
[    1.773923] sd 7:0:0:0: [sde] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.774541] scsi 13:0:0:0: Processor         Marvell  91xx Config      1=
=2E01 PQ: 0 ANSI: 5
[    1.775078] scsi 14:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68E 0=
A82 PQ: 0 ANSI: 5
[    1.823778] sd 14:0:0:0: [sdf] 5860533168 512-byte logical blocks: (3.00=
 TB/2.73 TiB)
[    1.823784] sd 14:0:0:0: [sdf] 4096-byte physical blocks
[    1.823809] sd 14:0:0:0: [sdf] Write Protect is off
[    1.823814] sd 14:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    1.823850] sd 14:0:0:0: [sdf] Write cache: enabled, read cache: enabled=
, doesn't support DPO or FUA
[    1.836063]  sde: sde1
[    1.836651] sd 7:0:0:0: [sde] Attached SCSI disk
[    1.866708] usb 1-4: new full-speed USB device number 3 using xhci_hcd
[    1.880609]  sdf: sdf1
[    1.881195] sd 14:0:0:0: [sdf] Attached SCSI disk
[    2.010429] logitech-djreceiver 0003:046D:C52B.0004: hiddev1,hidraw1: US=
B HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:14.0-4/input2
[    2.120073] usb 1-5: new high-speed USB device number 4 using xhci_hcd
[    2.132972] input: Logitech K400 Plus as /devices/pci0000:00/0000:00:14.=
0/usb1/1-4/1-4:1.2/0003:046D:C52B.0004/0003:046D:404D.0005/input/input4
[    2.133063] logitech-hidpp-device 0003:046D:404D.0005: input,hidraw2: US=
B HID v1.11 Keyboard [Logitech K400 Plus] on usb-0000:00:14.0-4:1
[    2.252512] hub 1-5:1.0: USB hub found
[    2.252678] hub 1-5:1.0: 4 ports detected
[    2.293416] ata16: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.293981] ata16.00: ATA-9: WDC WD30EFRX-68EUZN0, 82.00A82, max UDMA/133
[    2.293986] ata16.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/=
32), AA
[    2.294555] ata16.00: configured for UDMA/133
[    2.294845] scsi 15:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68E 0=
A82 PQ: 0 ANSI: 5
[    2.330425] sd 15:0:0:0: [sdg] 5860533168 512-byte logical blocks: (3.00=
 TB/2.73 TiB)
[    2.330431] sd 15:0:0:0: [sdg] 4096-byte physical blocks
[    2.330460] sd 15:0:0:0: [sdg] Write Protect is off
[    2.330465] sd 15:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    2.330500] sd 15:0:0:0: [sdg] Write cache: enabled, read cache: enabled=
, doesn't support DPO or FUA
[    2.330654] scsi 16:0:0:0: Direct-Access     ATA      WDC WD20EZRZ-00Z 0=
A80 PQ: 0 ANSI: 5
[    2.347129] [drm] RC6 on
[    2.370407] sd 16:0:0:0: [sdh] 3907029168 512-byte logical blocks: (2.00=
 TB/1.82 TiB)
[    2.370413] sd 16:0:0:0: [sdh] 4096-byte physical blocks
[    2.370438] sd 16:0:0:0: [sdh] Write Protect is off
[    2.370443] sd 16:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    2.370477] sd 16:0:0:0: [sdh] Write cache: enabled, read cache: enabled=
, doesn't support DPO or FUA
[    2.392212]  sdg: sdg1
[    2.392944] sd 15:0:0:0: [sdg] Attached SCSI disk
[    2.840090] ata18: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.840704] ata18.00: ATA-9: WDC WD20EZRZ-00Z5HB0, 80.00A80, max UDMA/133
[    2.840710] ata18.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/=
32), AA
[    2.841389] ata18.00: configured for UDMA/133
[    2.841709] scsi 17:0:0:0: Direct-Access     ATA      WDC WD20EZRZ-00Z 0=
A80 PQ: 0 ANSI: 5
[    2.877174] sd 17:0:0:0: [sdi] 3907029168 512-byte logical blocks: (2.00=
 TB/1.82 TiB)
[    2.877180] sd 17:0:0:0: [sdi] 4096-byte physical blocks
[    2.877211] sd 17:0:0:0: [sdi] Write Protect is off
[    2.877216] sd 17:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[    2.877261] sd 17:0:0:0: [sdi] Write cache: enabled, read cache: enabled=
, doesn't support DPO or FUA
[    2.877527] scsi 25:0:0:0: Processor         Marvell  91xx Config      1=
=2E01 PQ: 0 ANSI: 5
[    2.973061]  sdh: sdh1
[    2.973898] sd 16:0:0:0: [sdh] Attached SCSI disk
[    3.519420]  sdi: sdi1
[    3.520385] sd 17:0:0:0: [sdi] Attached SCSI disk
[    3.527627] random: crng init done
[    3.786761] device-mapper: uevent: version 1.0.3
[    3.786935] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initialised:=
 dm-devel@redhat.com
[    8.511538] NET: Registered protocol family 38
[   11.666678] raid6: sse2x1   gen() 11813 MB/s
[   11.723333] raid6: sse2x1   xor()  8671 MB/s
[   11.780003] raid6: sse2x2   gen() 14714 MB/s
[   11.836668] raid6: sse2x2   xor()  9848 MB/s
[   11.893334] raid6: sse2x4   gen() 17009 MB/s
[   11.950000] raid6: sse2x4   xor() 10494 MB/s
[   12.006666] raid6: avx2x1   gen() 23804 MB/s
[   12.063333] raid6: avx2x1   xor() 16386 MB/s
[   12.120003] raid6: avx2x2   gen() 29490 MB/s
[   12.176666] raid6: avx2x2   xor() 17950 MB/s
[   12.233333] raid6: avx2x4   gen() 33083 MB/s
[   12.289999] raid6: avx2x4   xor() 20438 MB/s
[   12.290000] raid6: using algorithm avx2x4 gen() 33083 MB/s
[   12.290000] raid6: .... xor() 20438 MB/s, rmw enabled
[   12.290001] raid6: using avx2x2 recovery algorithm
[   12.290204] xor: automatically using best checksumming function   avx
[   12.293360] Btrfs loaded, crc32c=3Dcrc32c-intel
[   12.297694] BTRFS: device fsid db7e86f5-649d-44ce-9514-53c7ee0fbe09 devi=
d 1 transid 180051 /dev/dm-2
[   20.099947] BTRFS: device fsid db7e86f5-649d-44ce-9514-53c7ee0fbe09 devi=
d 2 transid 180051 /dev/dm-5
[   20.162391] BTRFS info (device dm-5): disk space caching is enabled
[   20.162393] BTRFS info (device dm-5): has skinny extents
[   20.168987] BTRFS info (device dm-5): detected SSD devices, enabling SSD=
 mode
[   20.327686] ip_tables: (C) 2000-2006 Netfilter Core Team
[   20.340305] systemd[1]: systemd 235 running in system mode. (+PAM -AUDIT=
 -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNU=
TLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN default-hierar=
chy=3Dhybrid)
[   20.340503] systemd[1]: Detected architecture x86-64.
[   20.341673] systemd[1]: Set hostname to <dennas>.
[   20.384958] systemd[1]: Reached target Remote File Systems.
[   20.385101] systemd[1]: Started Dispatch Password Requests to Console Di=
rectory Watch.
[   20.385299] systemd[1]: Set up automount Arbitrary Executable File Forma=
ts File System Automount Point.
[   20.385395] systemd[1]: Started Forward Password Requests to Wall Direct=
ory Watch.
[   20.385464] systemd[1]: Reached target Paths.
[   20.386035] systemd[1]: Created slice User and Session Slice.
[   20.386281] systemd[1]: Created slice System Slice.
[   20.426137] BTRFS info (device dm-5): disk space caching is enabled
[   20.466516] systemd-journald[438]: Received request to flush runtime jou=
rnal from PID 1
[   20.580394] i8042: PNP: No PS/2 controller found.
[   20.580469] (NULL device *): hwmon_device_register() is deprecated. Plea=
se convert the driver to use hwmon_device_register_with_info().
[   20.582730] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   20.597353] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[   20.598065] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 655360=
 ms ovfl timer
[   20.598066] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[   20.598067] RAPL PMU: hw unit of domain package 2^-14 Joules
[   20.598068] RAPL PMU: hw unit of domain dram 2^-14 Joules
[   20.598068] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[   20.598069] RAPL PMU: hw unit of domain psys 2^-14 Joules
[   20.611145] mei_me 0000:00:16.0: enabling device (0000 -> 0002)
[   20.611367] mousedev: PS/2 mouse device common for all mice
[   20.613538] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   20.642923] Bluetooth: Core ver 2.22
[   20.642934] NET: Registered protocol family 31
[   20.642934] Bluetooth: HCI device and connection manager initialized
[   20.642936] Bluetooth: HCI socket layer initialized
[   20.642938] Bluetooth: L2CAP socket layer initialized
[   20.642942] Bluetooth: SCO socket layer initialized
[   20.646005] pps_core: LinuxPPS API ver. 1 registered
[   20.646006] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[   20.646457] i8042: PNP: No PS/2 controller found.
[   20.646781] PTP clock support registered
[   20.664040] Bluetooth: HCI UART driver ver 2.3
[   20.664041] Bluetooth: HCI UART protocol H4 registered
[   20.664042] Bluetooth: HCI UART protocol BCSP registered
[   20.664056] Bluetooth: HCI UART protocol LL registered
[   20.664056] Bluetooth: HCI UART protocol ATH3K registered
[   20.664057] Bluetooth: HCI UART protocol Three-wire (H5) registered
[   20.664072] Bluetooth: HCI UART protocol Intel registered
[   20.664082] Bluetooth: HCI UART protocol Broadcom registered
[   20.664082] Bluetooth: HCI UART protocol QCA registered
[   20.664083] Bluetooth: HCI UART protocol AG6XX registered
[   20.664084] Bluetooth: HCI UART protocol Marvell registered
[   20.692903] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[   20.692904] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[   20.693212] e1000e 0000:00:1f.6: Interrupt Throttling Rate (ints/sec) se=
t to dynamic conservative mode
[   20.705870] intel_rapl: Found RAPL domain package
[   20.705872] intel_rapl: Found RAPL domain core
[   20.705872] intel_rapl: Found RAPL domain uncore
[   20.705873] intel_rapl: Found RAPL domain dram
[   20.845331] Adding 8388604k swap on /dev/mapper/storage1-swap.  Priority=
:-1 extents:1 across:8388604k SSFS
[   20.854734] Adding 8388604k swap on /dev/mapper/storage2-swap.  Priority=
:-2 extents:1 across:8388604k SSFS
[   20.884805] iTCO_vendor_support: vendor-support=3D0
[   20.885712] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   20.885836] iTCO_wdt: Found a Intel PCH TCO device (Version=3D4, TCOBASE=
=3D0x0400)
[   20.887066] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[   21.023591] e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): registered=
 PHC clock
[   21.116913] e1000e 0000:00:1f.6 eth0: (PCI Express:2.5GT/s:Width x1) 70:=
85:c2:0b:a3:4a
[   21.116918] e1000e 0000:00:1f.6 eth0: Intel(R) PRO/1000 Network Connecti=
on
[   21.116995] e1000e 0000:00:1f.6 eth0: MAC: 12, PHY: 12, PBA No: FFFFFF-0=
FF
[   21.117166] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops vgt_ball=
oon_space [i915])
[   21.120626] e1000e 0000:00:1f.6 enp0s31f6: renamed from eth0
[   21.157389] snd_hda_codec_realtek hdaudioC0D0: ALC1150: SKU not ready 0x=
00000000
[   21.157858] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC1150: l=
ine_outs=3D3 (0x14/0x15/0x16/0x0/0x0) type:line
[   21.157860] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=3D0 (0x0/=
0x0/0x0/0x0/0x0)
[   21.157861] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=3D1 (0x1b/0x0/=
0x0/0x0/0x0)
[   21.157862] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=3D0x0
[   21.157863] snd_hda_codec_realtek hdaudioC0D0:    dig-out=3D0x1e/0x0
[   21.157864] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[   21.157866] snd_hda_codec_realtek hdaudioC0D0:      Front Mic=3D0x19
[   21.157867] snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=3D0x18
[   21.157868] snd_hda_codec_realtek hdaudioC0D0:      Line=3D0x1a
[   21.187043] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1f.=
3/sound/card0/input6
[   21.187725] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:0=
0:1f.3/sound/card0/input7
[   21.187763] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00=
:1f.3/sound/card0/input8
[   21.187799] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1f.=
3/sound/card0/input9
[   21.187835] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0=
000:00:1f.3/sound/card0/input10
[   21.187872] input: HDA Intel PCH Line Out Surround as /devices/pci0000:0=
0/0000:00:1f.3/sound/card0/input11
[   21.187909] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/00=
00:00:1f.3/sound/card0/input12
[   21.187946] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input13
[   21.187982] input: HDA Intel PCH HDMI/DP,pcm=3D3 as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input14
[   21.188016] input: HDA Intel PCH HDMI/DP,pcm=3D7 as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input15
[   21.188051] input: HDA Intel PCH HDMI/DP,pcm=3D8 as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input16
[   21.188086] input: HDA Intel PCH HDMI/DP,pcm=3D9 as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input17
[   21.188128] input: HDA Intel PCH HDMI/DP,pcm=3D10 as /devices/pci0000:00=
/0000:00:1f.3/sound/card0/input18
[   27.744454] BTRFS: device label RAID devid 3 transid 722079 /dev/dm-7
[   27.943843] BTRFS: device label RAID devid 4 transid 722079 /dev/dm-8
[   28.126853] BTRFS: device label RAID devid 2 transid 722079 /dev/dm-6
[   28.526207] BTRFS: device label RAID devid 1 transid 722079 /dev/dm-9
[   33.021211] BTRFS: device label RAID devid 6 transid 722079 /dev/dm-10
[   33.249980] BTRFS: device label RAID devid 5 transid 722079 /dev/dm-11
[   40.256427] BTRFS: device label RAID devid 7 transid 722079 /dev/dm-12
[   40.308464] BTRFS info (device dm-12): enabling auto defrag
[   40.308471] BTRFS info (device dm-12): disk space caching is enabled
[   40.308474] BTRFS info (device dm-12): has skinny extents
[   65.016124] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[   65.073655] bridge: filtering via arp/ip/ip6tables is no longer availabl=
e by default. Update your scripts to load br_netfilter if you need this.
[   65.290218] device enp0s31f6 entered promiscuous mode
[   65.290255] IPv6: ADDRCONF(NETDEV_UP): enp0s31f6: link is not ready
[   65.300099] lxc_bridge: port 1(enp0s31f6) entered blocking state
[   65.300121] lxc_bridge: port 1(enp0s31f6) entered disabled state
[   65.302800] IPv6: ADDRCONF(NETDEV_UP): lxc_bridge: link is not ready
[   65.396110] lxc_bridge: port 2(vethXWGDI9) entered blocking state
[   65.396123] lxc_bridge: port 2(vethXWGDI9) entered disabled state
[   65.396151] device vethXWGDI9 entered promiscuous mode
[   65.396368] IPv6: ADDRCONF(NETDEV_UP): vethXWGDI9: link is not ready
[   65.396369] lxc_bridge: port 2(vethXWGDI9) entered blocking state
[   65.396370] lxc_bridge: port 2(vethXWGDI9) entered forwarding state
[   65.396465] lxc_bridge: port 2(vethXWGDI9) entered disabled state
[   65.397003] lxc_bridge: port 3(veth5U332P) entered blocking state
[   65.397011] lxc_bridge: port 3(veth5U332P) entered disabled state
[   65.397044] device veth5U332P entered promiscuous mode
[   65.397093] IPv6: ADDRCONF(NETDEV_UP): veth5U332P: link is not ready
[   65.397095] lxc_bridge: port 3(veth5U332P) entered blocking state
[   65.397096] lxc_bridge: port 3(veth5U332P) entered forwarding state
[   65.397125] lxc_bridge: port 3(veth5U332P) entered disabled state
[   65.420481] eth0: renamed from vethRMR6U5
[   65.463823] IPv6: ADDRCONF(NETDEV_CHANGE): veth5U332P: link becomes ready
[   65.463838] lxc_bridge: port 3(veth5U332P) entered blocking state
[   65.463839] lxc_bridge: port 3(veth5U332P) entered forwarding state
[   65.463883] IPv6: ADDRCONF(NETDEV_CHANGE): lxc_bridge: link becomes ready
[   65.464268] eth0: renamed from vethH9FI6R
[   65.483693] IPv6: ADDRCONF(NETDEV_CHANGE): vethXWGDI9: link becomes ready
[   65.483712] lxc_bridge: port 2(vethXWGDI9) entered blocking state
[   65.483714] lxc_bridge: port 2(vethXWGDI9) entered forwarding state
[   68.045662] e1000e: enp0s31f6 NIC Link is Up 1000 Mbps Full Duplex, Flow=
 Control: Rx/Tx
[   68.045721] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s31f6: link becomes ready
[   68.045790] lxc_bridge: port 1(enp0s31f6) entered blocking state
[   68.045796] lxc_bridge: port 1(enp0s31f6) entered forwarding state
[   72.152706] logitech-hidpp-device 0003:046D:404D.0005: HID++ 4.1 device =
connected.
[   73.403756] tun: Universal TUN/TAP device driver, 1.6
[ 5401.283656] lxc_bridge: port 2(vethXWGDI9) entered disabled state
[ 5401.284092] device vethXWGDI9 left promiscuous mode
[ 5401.284101] lxc_bridge: port 2(vethXWGDI9) entered disabled state
[ 5404.440315] lxc_bridge: port 3(veth5U332P) entered disabled state
[ 5404.440709] device veth5U332P left promiscuous mode
[ 5404.440718] lxc_bridge: port 3(veth5U332P) entered disabled state
[ 5412.947492] lxc_bridge: port 2(vethIGO2QO) entered blocking state
[ 5412.947518] lxc_bridge: port 2(vethIGO2QO) entered disabled state
[ 5412.947590] device vethIGO2QO entered promiscuous mode
[ 5412.947962] IPv6: ADDRCONF(NETDEV_UP): vethIGO2QO: link is not ready
[ 5412.969548] eth0: renamed from vethC7XGWT
[ 5412.983202] IPv6: ADDRCONF(NETDEV_CHANGE): vethIGO2QO: link becomes ready
[ 5412.983229] lxc_bridge: port 2(vethIGO2QO) entered blocking state
[ 5412.983230] lxc_bridge: port 2(vethIGO2QO) entered forwarding state
[ 5414.918094] lxc_bridge: port 3(vethLOPH6S) entered blocking state
[ 5414.918103] lxc_bridge: port 3(vethLOPH6S) entered disabled state
[ 5414.918142] device vethLOPH6S entered promiscuous mode
[ 5414.918518] IPv6: ADDRCONF(NETDEV_UP): vethLOPH6S: link is not ready
[ 5414.943172] eth0: renamed from vethH21R74
[ 5414.963286] IPv6: ADDRCONF(NETDEV_CHANGE): vethLOPH6S: link becomes ready
[ 5414.963309] lxc_bridge: port 3(vethLOPH6S) entered blocking state
[ 5414.963310] lxc_bridge: port 3(vethLOPH6S) entered forwarding state
[ 5431.739787] lxc_bridge: port 2(vethIGO2QO) entered disabled state
[ 5431.740146] device vethIGO2QO left promiscuous mode
[ 5431.740156] lxc_bridge: port 2(vethIGO2QO) entered disabled state
[ 5434.512948] lxc_bridge: port 3(vethLOPH6S) entered disabled state
[ 5434.513152] device vethLOPH6S left promiscuous mode
[ 5434.513156] lxc_bridge: port 3(vethLOPH6S) entered disabled state
[ 5480.268605] lxc_bridge: port 2(veth0O8UFB) entered blocking state
[ 5480.268613] lxc_bridge: port 2(veth0O8UFB) entered disabled state
[ 5480.268646] device veth0O8UFB entered promiscuous mode
[ 5480.268762] IPv6: ADDRCONF(NETDEV_UP): veth0O8UFB: link is not ready
[ 5480.296404] eth0: renamed from vethP9B8YH
[ 5480.321483] IPv6: ADDRCONF(NETDEV_CHANGE): veth0O8UFB: link becomes ready
[ 5480.321541] lxc_bridge: port 2(veth0O8UFB) entered blocking state
[ 5480.321544] lxc_bridge: port 2(veth0O8UFB) entered forwarding state
[ 5499.268721] lxc_bridge: port 3(vethRUY5VX) entered blocking state
[ 5499.268729] lxc_bridge: port 3(vethRUY5VX) entered disabled state
[ 5499.268759] device vethRUY5VX entered promiscuous mode
[ 5499.268863] IPv6: ADDRCONF(NETDEV_UP): vethRUY5VX: link is not ready
[ 5499.296331] eth0: renamed from vethTO2H20
[ 5499.321534] IPv6: ADDRCONF(NETDEV_CHANGE): vethRUY5VX: link becomes ready
[ 5499.321603] lxc_bridge: port 3(vethRUY5VX) entered blocking state
[ 5499.321608] lxc_bridge: port 3(vethRUY5VX) entered forwarding state
[22671.887860] perf: interrupt took too long (2508 > 2500), lowering kernel=
=2Eperf_event_max_sample_rate to 79500
[24159.239247] perf: interrupt took too long (3154 > 3135), lowering kernel=
=2Eperf_event_max_sample_rate to 63300
[27240.680874] perf: interrupt took too long (3952 > 3942), lowering kernel=
=2Eperf_event_max_sample_rate to 50400
[30658.875802] BTRFS warning (device dm-12): checksum error at logical 3788=
9245122560 on dev /dev/mapper/data7, sector 2743145096, root 23674, inode 2=
06751, offset 762638336, length 4096, links 1 (path: =E3=82=A2=E3=83=8B=E3=
=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku Tatakae=
ri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
[30658.875806] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs: wr =
0, rd 0, flush 0, corrupt 1, gen 0
[30658.900322] BTRFS error (device dm-12): fixed up error at logical 378892=
45122560 on dev /dev/mapper/data7
[30658.902461] BTRFS warning (device dm-12): checksum error at logical 3788=
9245126656 on dev /dev/mapper/data7, sector 2743145104, root 23674, inode 2=
06751, offset 762642432, length 4096, links 1 (path: =E3=82=A2=E3=83=8B=E3=
=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku Tatakae=
ri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
[30658.902471] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs: wr =
0, rd 0, flush 0, corrupt 2, gen 0
[30658.904943] BTRFS error (device dm-12): fixed up error at logical 378892=
45126656 on dev /dev/mapper/data7
[30658.905427] BTRFS warning (device dm-12): checksum error at logical 3788=
9245130752 on dev /dev/mapper/data7, sector 2743145112, root 23674, inode 2=
06751, offset 762646528, length 4096, links 1 (path: =E3=82=A2=E3=83=8B=E3=
=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku Tatakae=
ri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
[30658.905435] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs: wr =
0, rd 0, flush 0, corrupt 3, gen 0
[30658.908247] BTRFS error (device dm-12): fixed up error at logical 378892=
45130752 on dev /dev/mapper/data7
[30658.912217] BTRFS warning (device dm-12): checksum error at logical 3788=
9245134848 on dev /dev/mapper/data7, sector 2743145120, root 23674, inode 2=
06751, offset 762650624, length 4096, links 1 (path: =E3=82=A2=E3=83=8B=E3=
=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku Tatakae=
ri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
[30658.912226] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs: wr =
0, rd 0, flush 0, corrupt 4, gen 0
[30658.922809] BTRFS error (device dm-12): fixed up error at logical 378892=
45134848 on dev /dev/mapper/data7
[30658.924887] BTRFS warning (device dm-12): checksum error at logical 3788=
9245138944 on dev /dev/mapper/data7, sector 2743145128, root 23674, inode 2=
06751, offset 762654720, length 4096, links 1 (path: =E3=82=A2=E3=83=8B=E3=
=83=A1/!waiting_for_better_quality/Gate: Jieitai Kanochi nite, Kaku Tatakae=
ri/GATE Jieitai Kanochi nite, Kaku Tatakaeri 05v2.mp4)
[30658.924894] BTRFS error (device dm-12): bdev /dev/mapper/data7 errs: wr =
0, rd 0, flush 0, corrupt 5, gen 0
[30658.926522] BTRFS error (device dm-12): fixed up error at logical 378892=
45138944 on dev /dev/mapper/data7
[33389.149353] perf: interrupt took too long (4945 > 4940), lowering kernel=
=2Eperf_event_max_sample_rate to 40200

--=20
There are only two hard things in Computer Science:
cache invalidation, naming things and off-by-one errors.

--xvhozdi5oq3pj3ul
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEKUV4RjubkPramXVZs4umGUJTxRIFAlntqsUACgkQs4umGUJT
xRLUkw//c+uY3yMCN15+HYpQigYPhBukZF+BmOuVBHOgREvF7a291ZT7l0RQYqGO
toOPrTbrozMYj1NszkHDlAbE6Al7tLXj+FahuslsMqU9GXnaJw/oLGqEEtzmFsgM
FQJrNdBJ5TppU7B6AdmciLPpL9Qo9bubBJDuNna37vvRXSocI8JaV68XPCPPvW4G
meIsMFmGQBkOsF/DKpGBuUJ17zs/HoZrYPGbvxdq5Pn8CMcjrIVX6vfKF/reha1E
oouFFgC0mqyp6d19Rr/NaKRUYr7wRb3ZeCC5b09gztMgWrZGQr6K0Baxusgc1UCc
G7gNzqMxkkxTJJq9n9HW+PQsInyVUiJyyh4It6445BiLn+FyS1TjXNpBOKwcVbx5
vN/M6jvqDk3ryIuJPenWXO9mOhjVbAVtgo6fQEcZ4xrlTVNFRToTLlfxPJG72wls
v1zOKJw35El7hRHw/uD5ZiqB2pMKOCEJpkGuipXOvyda/VhYe0WLbyrtN4rovb0P
GFYolLFlsNArH8IggazUWTUuaBcYFbHXMeJowEZ+ulVkwd57m0T2S7uWMliQ4Woi
8MaaqzJJP+DRNYZOO0JTYyPlZS6x0tZQRIT/QvQ4KjPfpryTPmD+3prHAW2jlz/5
M2TgOCjMaWFhwinAmDcPlgVC/W/8czAFON89iUS52Kaxg1btNJM=
=iLcI
-----END PGP SIGNATURE-----

--xvhozdi5oq3pj3ul--
