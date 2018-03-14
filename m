Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:47141 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932809AbeCNCHN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 22:07:13 -0400
Received: from couracado.motaleite.net ([5.249.86.255]) by mail.gmx.com
 (mrgmx002 [212.227.17.190]) with ESMTPSA (Nemesis) id
 0LfSeH-1eGKYA0tzN-00p0qD for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018
 03:07:11 +0100
Date: Wed, 14 Mar 2018 02:07:06 +0000
From: higuita <higuita@GMX.net>
To: linux-btrfs@vger.kernel.org
Subject: btrfs errors
Message-ID: <20180314020313.2f444787@couracado.motaleite.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/nBpo7nQk45aG0flloK5OkM3"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/nBpo7nQk45aG0flloK5OkM3
Content-Type: multipart/mixed; boundary="MP_/ezjvi6UHFFEwn.PQHcjXCLG"

--MP_/ezjvi6UHFFEwn.PQHcjXCLG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

When recompiling the kernel a few weeks ago i got some error and
after some research notices some checksum errors in the dmesg in my root
filesystem, with btrfs

Doing a btrfs check i got many errors in the linux source tree *.o
and several other files in /usr/*. So i umounted, rebooted from a CD and
tried to do a btrfs check but the repair end in a loop and never ended.

The smart didn't reported any error in the hardware, read tests to the
devices returned successful, so as i had my backups up to date, i
reformated the disk and restored the backup.

A new quick test reported to the restore showed everything working fine.

Some week later, again after when recompiling the kernel i got again some
errors and again i had some checksum errors. btrfs check showed again many
errors in the new *.o files, so i did a make clean. After that e get
a lot cleaner btrfs check, it no longer reports errors directly on=20
files and files in /usr/* that were not touched in weeks were again
aparently fine.

So here is the current btrfs check:

# btrfs check --force /dev/vdisk/root =20
WARNING: filesystem mounted, continuing because of --force
Checking filesystem on /dev/vdisk/root
UUID: c6cbf25f-f020-4247-822d-d9a85ec3c09f
checking extents
bad key ordering 9 10
bad block 999014400
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
bad key ordering 9 10
bad key ordering 9 10
bad key ordering 9 10
bad key ordering 9 10
bad key ordering 9 10
bad key ordering 9 10
bad key ordering 9 10
bad key ordering 9 10
bad key ordering 9 10
bad key ordering 9 10
checking csums
there are no extents for csum range 45688356864-45689131008
csum exists for 45688352768-45689131008 but there is no extent record
there are no extents for csum range 45689135104-45689561088
csum exists for 45689135104-45689561088 but there is no extent record
there are no extents for csum range 45690290176-45690789888
Right section didn't have a record
there are no extents for csum range 45689565184-45690789888
csum exists for 45689565184-45690789888 but there is no extent record
there are no extents for csum range 45691084800-45691613184
Right section didn't have a record
there are no extents for csum range 45690798080-45691613184
csum exists for 45690798080-45691613184 but there is no extent record
there are no extents for csum range 45691621376-45691695104
csum exists for 45691621376-45691695104 but there is no extent record
there are no extents for csum range 45690789888-45690908672
csum exists for 45690789888-45690908672 but there is no extent record
there are no extents for csum range 45691613184-45691633664
csum exists for 45691613184-45691633664 but there is no extent record
there are no extents for csum range 45691695104-45691719680
csum exists for 45691695104-45691719680 but there is no extent record
there are no extents for csum range 45691723776-45691793408
csum exists for 45691723776-45691793408 but there is no extent record
there are no extents for csum range 45691797504-45692260352
csum exists for 45691797504-45692260352 but there is no extent record
there are no extents for csum range 45692698624-45693382656
Right section didn't have a record
there are no extents for csum range 45692272640-45693382656
csum exists for 45692268544-45693382656 but there is no extent record
there are no extents for csum range 45693652992-45694271488
Right section didn't have a record
there are no extents for csum range 45693419520-45694271488
csum exists for 45693411328-45694271488 but there is no extent record
there are no extents for csum range 45694275584-45694799872
csum exists for 45694275584-45694799872 but there is no extent record
there are no extents for csum range 45695393792-45695815680
Right section didn't have a record
there are no extents for csum range 45694803968-45695815680
csum exists for 45694803968-45695815680 but there is no extent record
there are no extents for csum range 45696925696-45701804032
Right section didn't have a record
there are no extents for csum range 45695819776-45701804032
csum exists for 45695819776-45701804032 but there is no extent record
there are no extents for csum range 45701816320-45702488064
csum exists for 45701808128-45702488064 but there is no extent record
there are no extents for csum range 45702492160-45703356416
csum exists for 45702492160-45703356416 but there is no extent record
ERROR: errors found in csum tree
found 46027468800 bytes used, error(s) found
total csum bytes: 35738676
total tree bytes: 1077346304
total fs tree bytes: 980303872
total extent tree bytes: 54738944
btree space waste bytes: 197970889
file data blocks allocated: 44945944576
 referenced 59372814336

Doing a btrfs scrub:

# btrfs scrub start -Bd /dev/mapper/vdisk-root=20
ERROR: scrubbing /dev/mapper/vdisk-root failed for device id 1: ret=3D-1, e=
rrno=3D5 (Input/output error)
scrub device /dev/mapper/vdisk-root (id 1) canceled
	scrub started at Wed Mar 14 01:32:51 2018 and was aborted after 00:02:25
	total bytes scrubbed: 39.28GiB with 0 errors


full current dmesg attached and lvm and ssd info. i'm using lvm because
i build this setup several years ago, before trusting the btrfs raid1 :)

btrfs root filesystem is using lzo compression. in the same ssd i also
have the home partition, but that one i'm not using lzo compression
and i also have no problem... but i also only compile small programs
there.

i have been using btrfs for several years and only now i have this
problem. memtest86 running for several hours reports no errors, but my
bios only lets me test with one CPU, it reports that multiple CPUs are
disabled by default and it can not activate them... so i'm not totally
sure if
under heavy load there is any memory corruption or not... but compiling
the kernel under a tmpfs, i get no problem

Finally, i usually suspend my machine and, due to a amdgpu problem,
sometime the machine crashes/freezes

so 2 questions:=20

- might this be a btrfs bug or any hardware problem? yes, i know this one
is hard to reply, but i may be able to do some tests.

- how to fix the above problems? should i run a umounted=20
"btrfs check --repair" ?

Thanks in advance for the help
higuita
--=20
Naturally the common people don't want war... but after all it is the
leaders of a country who determine the policy, and it is always a=20
simple matter to drag the people along, whether it is a democracy, or
a fascist dictatorship, or a parliament, or a communist dictatorship.
Voice or no voice, the people can always be brought to the bidding of
the leaders. That is easy. All you have to do is tell them they are=20
being attacked, and denounce the pacifists for lack of patriotism and
exposing the country to danger.  It works the same in every country.
           -- Hermann Goering, Nazi and war criminal, 1883-1946

--MP_/ezjvi6UHFFEwn.PQHcjXCLG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=dmesg.4.15.9.txt

[    0.000000] Linux version 4.15.9-slack (root@Couracado.homelinux.net) (g=
cc version 7.3.0 (GCC)) #1 SMP PREEMPT Tue Mar 13 04:03:54 WET 2018
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-4.15.9-slack-smp root=3D=
/dev/mapper/vdisk-root ro vt.default_utf8=3D1 resume=3D/dev/sda1 memory_cor=
ruption_check=3D1 usbcore.autosuspend=3D1 zcache zswap.enabled=3D1 zswap.zp=
ool=3Dz3fold zswap.max_pool_percent=3D20 iommu=3Dpt console=3Dtty0 console=
=3DttyS0,38400n8 no_console_suspend radeon.bapm=3D1 amdgpu.bapm=3D1
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] random: get_random_u32 called from bsp_init_amd+0x29f/0x520 =
with crng_init=3D0
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point=
 registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 by=
tes, using 'standard' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000000fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000001000-0x000000000008ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x0000000000090fff] type =
20
[    0.000000] BIOS-e820: [mem 0x0000000000091000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] unusa=
ble
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dd233fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dd234000-0x00000000dd263fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000dd264000-0x00000000dd2c4fff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x00000000dd2c5000-0x00000000dd800fff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000dd801000-0x00000000de352fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000de353000-0x00000000de3adfff] type =
20
[    0.000000] BIOS-e820: [mem 0x00000000de3ae000-0x00000000de3aefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de3af000-0x00000000de5b4fff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000de5b5000-0x00000000de9f2fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de9f3000-0x00000000deff3fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000deff4000-0x00000000deffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feb80000-0x00000000fec01fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000061effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v32.31 by American Megatrends
[    0.000000] efi:  ACPI 2.0=3D0xdd2adc68  SMBIOS=3D0xde351418=20
[    0.000000] random: fast init done
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: System manufacturer System Product Name/A88X-PLUS, BIOS=
 3003 03/10/2016
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x61f000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFE0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000061f000000 aka 25072M
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT=
 =20
[    0.000000] e820: update [mem 0xe0000000-0xffffffff] usable =3D=3D> rese=
rved
[    0.000000] e820: last_pfn =3D 0xdf000 max_arch_pfn =3D 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [        (ptrval)] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x317bcf000, 0x317bcffff] PGTABLE
[    0.000000] BRK [0x317bd0000, 0x317bd0fff] PGTABLE
[    0.000000] BRK [0x317bd1000, 0x317bd1fff] PGTABLE
[    0.000000] BRK [0x317bd2000, 0x317bd2fff] PGTABLE
[    0.000000] BRK [0x317bd3000, 0x317bd3fff] PGTABLE
[    0.000000] BRK [0x317bd4000, 0x317bd4fff] PGTABLE
[    0.000000] BRK [0x317bd5000, 0x317bd5fff] PGTABLE
[    0.000000] BRK [0x317bd6000, 0x317bd6fff] PGTABLE
[    0.000000] BRK [0x317bd7000, 0x317bd7fff] PGTABLE
[    0.000000] BRK [0x317bd8000, 0x317bd8fff] PGTABLE
[    0.000000] Secure boot could not be determined
[    0.000000] RAMDISK: [mem 0x35f43000-0x36f98fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000DD2ADC68 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000DD2ADBEC 00007C (v01 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x00000000DD29DE42 000346 (v02 AMD    BANTRY   00=
000002 MSFT 04000000)
[    0.000000] ACPI: SSDT 0x00000000DD29E188 000B9C (v01 AMD    BANTRY   00=
000001 AMD  00000001)
[    0.000000] ACPI: VFCT 0x00000000DD29ED24 00E684 (v01 ALASKA A M I    00=
000001 AMD  31504F47)
[    0.000000] ACPI: IVRS 0x00000000DD2AD3A8 0000D0 (v02 AMD    BANTRY   00=
000001 AMD  00000000)
[    0.000000] ACPI: UEFI 0x00000000DD2AD478 000042 (v01 ALASKA A M I    01=
072009      00000000)
[    0.000000] ACPI: HPET 0x00000000DD2AD4BA 000038 (v01 ALASKA A M I    01=
072009 AMI  00000005)
[    0.000000] ACPI: CRAT 0x00000000DD2AD4F2 000528 (v01 AMD    BANTRY   00=
000001 AMD  00000001)
[    0.000000] ACPI: MCFG 0x00000000DD2ADA1A 00003C (v01 ALASKA A M I    01=
072009 MSFT 00010013)
[    0.000000] ACPI: FPDT 0x00000000DD2ADA56 000044 (v01 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI: APIC 0x00000000DD2ADA9A 00007E (v03 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DD2ADB18 000084 (v02 ALASKA A M I    01=
072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock=
 has valid Length but zero Address: 0x0000000000000000/0x1 (20170831/tbfadt=
-658)
[    0.000000] ACPI: DSDT 0x00000000DD297000 006E42 (v02 ALASKA A M I    00=
000000 INTL 20170531)
[    0.000000] ACPI: FACS 0x00000000DD7F6040 000040
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000061effffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x61effc000-0x61effffff]
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000061effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000008ffff]
[    0.000000]   node   0: [mem 0x0000000000091000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000dd233fff]
[    0.000000]   node   0: [mem 0x00000000de3ae000-0x00000000de3aefff]
[    0.000000]   node   0: [mem 0x00000000de5b5000-0x00000000de9f2fff]
[    0.000000]   node   0: [mem 0x00000000deff4000-0x00000000deffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000061effffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000061efff=
fff]
[    0.000000] On node 0 totalpages: 6276636
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14106 pages used for memmap
[    0.000000]   DMA32 zone: 902783 pages, LIFO batch:31
[    0.000000]   Normal zone: 83904 pages used for memmap
[    0.000000]   Normal zone: 5369856 pages, LIFO batch:31
[    0.000000] Reserved but unavailable: 98 pages
[    0.000000] kasan: KernelAddressSanitizer initialized
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 0, version 33, address 0xfec00000, GSI 0-=
23
[    0.000000] IOAPIC[1]: apic_id 1, version 33, address 0xfec01000, GSI 24=
-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10228210 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00090000-0x00090fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd234000-0xdd263fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd264000-0xdd2c4fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd2c5000-0xdd800fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd801000-0xde352fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde353000-0xde3adfff]
[    0.000000] PM: Registered nosave memory: [mem 0xde3af000-0xde5b4fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde9f3000-0xdeff3fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfeb7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeb80000-0xfec01fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec02000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec11000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed80000-0xfed8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdf000000-0xf7ffffff] available for PCI devices
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:4 nr_=
node_ids:1
[    0.000000] percpu: Embedded 53 pages/cpu @        (ptrval) s177432 r819=
2 d31464 u524288
[    0.000000] pcpu-alloc: s177432 r8192 d31464 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 61785=
39
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-4.15.9-slack-smp =
root=3D/dev/mapper/vdisk-root ro vt.default_utf8=3D1 resume=3D/dev/sda1 mem=
ory_corruption_check=3D1 usbcore.autosuspend=3D1 zcache zswap.enabled=3D1 z=
swap.zpool=3Dz3fold zswap.max_pool_percent=3D20 iommu=3Dpt console=3Dtty0 c=
onsole=3DttyS0,38400n8 no_console_suspend radeon.bapm=3D1 amdgpu.bapm=3D1
[    0.000000] Memory: 21356620K/25106544K available (32780K kernel code, 4=
538K rwdata, 5764K rodata, 1948K init, 9176K bss, 3749924K reserved, 0K cma=
-reserved)
[    0.000000] ftrace: allocating 36515 entries in 143 pages
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D16 to nr_cpu_ids=3D4.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D4
[    0.000000] NR_IRQS: 4352, nr_irqs: 1000, preallocated irqs: 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] ACPI: Core revision 20170831
[    0.000000] ACPI: 3 ACPI AML tables successfully acquired and loaded
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, =
max_idle_ns: 133484873504 ns
[    0.000000] hpet clockevent registered
[    0.000000] APIC: Switch to symmetric I/O mode setup
[    0.012000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.032000] tsc: Fast TSC calibration using PIT
[    0.036000] tsc: Detected 3999.991 MHz processor
[    0.040000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 7999.98 BogoMIPS (lpj=3D15999964)
[    0.044002] pid_max: default: 32768 minimum: 301
[    0.052300] Security Framework initialized
[    0.065094] Dentry cache hash table entries: 4194304 (order: 13, 3355443=
2 bytes)
[    0.075079] Inode-cache hash table entries: 2097152 (order: 12, 16777216=
 bytes)
[    0.076204] Mount-cache hash table entries: 65536 (order: 7, 524288 byte=
s)
[    0.080140] Mountpoint-cache hash table entries: 65536 (order: 7, 524288=
 bytes)
[    0.088506] CPU: Physical Processor ID: 0
[    0.092002] CPU: Processor Core ID: 0
[    0.096002] mce: CPU supports 7 MCE banks
[    0.100020] LVT offset 1 assigned for vector 0xf9
[    0.104006] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
[    0.108001] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512, 1GB 0
[    0.112003] Spectre V2 : Spectre mitigation: kernel not compiled with re=
tpoline; no mitigation available!
[    0.112432] Freeing SMP alternatives memory: 40K
[    0.128000] smpboot: CPU0: AMD A10-7850K Radeon R7, 12 Compute Cores 4C+=
8G (family: 0x15, model: 0x30, stepping: 0x1)
[    0.144133] Performance Events: Fam15h core perfctr, AMD PMU driver.
[    0.148013] ... version:                0
[    0.152005] ... bit width:              48
[    0.156001] ... generic registers:      6
[    0.160001] ... value mask:             0000ffffffffffff
[    0.164001] ... max period:             00007fffffffffff
[    0.168001] ... fixed-purpose events:   0
[    0.172001] ... event mask:             000000000000003f
[    0.184029] Hierarchical SRCU implementation.
[    0.196181] MCE: In-kernel MCE decoding enabled.
[    0.208352] NMI watchdog: Enabled. Permanently consumes one hw-PMU count=
er.
[    0.216041] smp: Bringing up secondary CPUs ...
[    0.252625] x86: Booting SMP configuration:
[    0.256013] .... node  #0, CPUs:      #1 #2 #3
[    0.322713] smp: Brought up 1 node, 4 CPUs
[    0.328008] smpboot: Max logical packages: 1
[    0.332007] smpboot: Total of 4 processors activated (31999.92 BogoMIPS)
[    0.337691] devtmpfs: initialized
[    0.348468] x86/mm: Memory block size: 128MB
[    0.384123] PM: Registering ACPI NVS region [mem 0xdd2c5000-0xdd800fff] =
(5488640 bytes)
[    0.410478] PM: Registering ACPI NVS region [mem 0xde3af000-0xde5b4fff] =
(2121728 bytes)
[    0.436110] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 7645041785100000 ns
[    0.468026] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.484088] xor: automatically using best checksumming function   avx   =
   =20
[    0.508003] pinctrl core: initialized pinctrl subsystem
[    0.526301] NET: Registered protocol family 16
[    0.536823] audit: initializing netlink subsys (disabled)
[    0.556073] audit: type=3D2000 audit(1520980441.556:1): state=3Dinitiali=
zed audit_enabled=3D0 res=3D1
[    0.580016] cpuidle: using governor ladder
[    0.592071] cpuidle: using governor menu
[    0.596207] ACPI: bus type PCI registered
[    0.600006] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.604519] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    0.608007] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.612032] PCI: Using configuration type 1 for base access
[    0.704005] raid6: sse2x1   gen()  7695 MB/s
[    0.776001] raid6: sse2x1   xor()  4999 MB/s
[    0.848004] raid6: sse2x2   gen() 11506 MB/s
[    0.920004] raid6: sse2x2   xor()  7819 MB/s
[    0.992005] raid6: sse2x4   gen() 13321 MB/s
[    1.064004] raid6: sse2x4   xor()  6117 MB/s
[    1.068002] raid6: using algorithm sse2x4 gen() 13321 MB/s
[    1.072001] raid6: .... xor() 6117 MB/s, rmw enabled
[    1.076002] raid6: using ssse3x2 recovery algorithm
[    1.080324] ACPI: Added _OSI(Module Device)
[    1.084002] ACPI: Added _OSI(Processor Device)
[    1.088002] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.092002] ACPI: Added _OSI(Processor Aggregator Device)
[    1.100153] ACPI: Executed 2 blocks of module-level executable AML code
[    1.202710] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    1.216180] ACPI: Interpreter enabled
[    1.228105] ACPI: (supports S0 S3 S4 S5)
[    1.240003] ACPI: Using IOAPIC for interrupt routing
[    1.258064] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.286713] ACPI: Enabled 8 GPEs in block 00 to 1F
[    1.468194] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.488025] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM Cloc=
kPM Segments MSI]
[    1.516970] acpi PNP0A03:00: _OSC: platform does not support [PCIeHotplu=
g PME]
[    1.544302] acpi PNP0A03:00: _OSC: OS now controls [AER PCIeCapability]
[    1.564120] acpi PNP0A03:00: [Firmware Info]: MMCONFIG for domain 0000 [=
bus 00-3f] only partially covers this bridge
[    1.604697] PCI host bridge to bus 0000:00
[    1.620010] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
[    1.640009] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
[    1.660008] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df window]
[    1.680008] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    1.700008] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f window]
[    1.720009] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dfff=
f window]
[    1.744009] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfffffff=
f window]
[    1.768008] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.784023] pci 0000:00:00.0: [1022:1422] type 00 class 0x060000
[    1.785543] pci 0000:00:00.2: [1022:1423] type 00 class 0x080600
[    1.785543] pci 0000:00:02.0: [1022:1424] type 00 class 0x060000
[    1.786173] pci 0000:00:02.1: [1022:1425] type 01 class 0x060400
[    1.786204] pci 0000:00:02.1: enabling Extended Tags
[    1.804086] pci 0000:00:02.1: PME# supported from D0 D3hot D3cold
[    1.805686] pci 0000:00:03.0: [1022:1424] type 00 class 0x060000
[    1.805686] pci 0000:00:04.0: [1022:1424] type 00 class 0x060000
[    1.805686] pci 0000:00:10.0: [1022:7814] type 00 class 0x0c0330
[    1.805686] pci 0000:00:10.0: reg 0x10: [mem 0xfeb06000-0xfeb07fff 64bit]
[    1.805686] pci 0000:00:10.0: PME# supported from D0 D3hot D3cold
[    1.807249] pci 0000:00:10.1: [1022:7814] type 00 class 0x0c0330
[    1.807278] pci 0000:00:10.1: reg 0x10: [mem 0xfeb04000-0xfeb05fff 64bit]
[    1.807430] pci 0000:00:10.1: PME# supported from D0 D3hot D3cold
[    1.809012] pci 0000:00:11.0: [1022:7801] type 00 class 0x010601
[    1.809033] pci 0000:00:11.0: reg 0x10: [io  0xf040-0xf047]
[    1.809043] pci 0000:00:11.0: reg 0x14: [io  0xf030-0xf033]
[    1.809052] pci 0000:00:11.0: reg 0x18: [io  0xf020-0xf027]
[    1.809061] pci 0000:00:11.0: reg 0x1c: [io  0xf010-0xf013]
[    1.809070] pci 0000:00:11.0: reg 0x20: [io  0xf000-0xf00f]
[    1.809079] pci 0000:00:11.0: reg 0x24: [mem 0xfeb0c000-0xfeb0c7ff]
[    1.810613] pci 0000:00:12.0: [1022:7807] type 00 class 0x0c0310
[    1.810631] pci 0000:00:12.0: reg 0x10: [mem 0xfeb0b000-0xfeb0bfff]
[    1.812274] pci 0000:00:12.2: [1022:7808] type 00 class 0x0c0320
[    1.812294] pci 0000:00:12.2: reg 0x10: [mem 0xfeb0a000-0xfeb0a0ff]
[    1.812413] pci 0000:00:12.2: supports D1 D2
[    1.812414] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot D3cold
[    1.813961] pci 0000:00:13.0: [1022:7807] type 00 class 0x0c0310
[    1.813979] pci 0000:00:13.0: reg 0x10: [mem 0xfeb09000-0xfeb09fff]
[    1.815609] pci 0000:00:13.2: [1022:7808] type 00 class 0x0c0320
[    1.815630] pci 0000:00:13.2: reg 0x10: [mem 0xfeb08000-0xfeb080ff]
[    1.815747] pci 0000:00:13.2: supports D1 D2
[    1.815749] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot D3cold
[    1.817275] pci 0000:00:14.0: [1022:780b] type 00 class 0x0c0500
[    1.818676] pci 0000:00:14.2: [1022:780d] type 00 class 0x040300
[    1.818700] pci 0000:00:14.2: reg 0x10: [mem 0xfeb00000-0xfeb03fff 64bit]
[    1.818807] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    1.820332] pci 0000:00:14.3: [1022:780e] type 00 class 0x060100
[    1.824020] pci 0000:00:14.4: [1022:780f] type 01 class 0x060401
[    1.824020] pci 0000:00:15.0: [1022:43a0] type 01 class 0x060400
[    1.824020] pci 0000:00:15.0: enabling Extended Tags
[    1.840092] pci 0000:00:15.0: supports D1 D2
[    1.840094] pci 0000:00:15.0: PME# supported from D0 D3hot D3cold
[    1.840126] pci 0000:00:15.2: [1022:43a2] type 01 class 0x060400
[    1.840165] pci 0000:00:15.2: enabling Extended Tags
[    1.856091] pci 0000:00:15.2: supports D1 D2
[    1.856093] pci 0000:00:15.2: PME# supported from D0 D3hot D3cold
[    1.856688] pci 0000:00:18.0: [1022:141a] type 00 class 0x060000
[    1.858045] pci 0000:00:18.1: [1022:141b] type 00 class 0x060000
[    1.859385] pci 0000:00:18.2: [1022:141c] type 00 class 0x060000
[    1.860736] pci 0000:00:18.3: [1022:141d] type 00 class 0x060000
[    1.862093] pci 0000:00:18.4: [1022:141e] type 00 class 0x060000
[    1.863439] pci 0000:00:18.5: [1022:141f] type 00 class 0x060000
[    1.865499] pci 0000:01:00.0: [1002:67df] type 00 class 0x030000
[    1.865525] pci 0000:01:00.0: reg 0x10: [mem 0xe0000000-0xefffffff 64bit=
 pref]
[    1.865537] pci 0000:01:00.0: reg 0x18: [mem 0xf0000000-0xf01fffff 64bit=
 pref]
[    1.865545] pci 0000:01:00.0: reg 0x20: [io  0xe000-0xe0ff]
[    1.865552] pci 0000:01:00.0: reg 0x24: [mem 0xfea00000-0xfea3ffff]
[    1.865560] pci 0000:01:00.0: reg 0x30: [mem 0xfea40000-0xfea5ffff pref]
[    1.865567] pci 0000:01:00.0: enabling Extended Tags
[    1.880096] pci 0000:01:00.0: BAR 0: assigned to efifb
[    1.896056] pci 0000:01:00.0: supports D1 D2
[    1.896058] pci 0000:01:00.0: PME# supported from D1 D2 D3hot D3cold
[    1.896634] pci 0000:01:00.1: [1002:aaf0] type 00 class 0x040300
[    1.896655] pci 0000:01:00.1: reg 0x10: [mem 0xfea60000-0xfea63fff 64bit]
[    1.896682] pci 0000:01:00.1: enabling Extended Tags
[    1.912134] pci 0000:01:00.1: supports D1 D2
[    1.924061] pci 0000:00:02.1: PCI bridge to [bus 01]
[    1.940011] pci 0000:00:02.1:   bridge window [io  0xe000-0xefff]
[    1.940015] pci 0000:00:02.1:   bridge window [mem 0xfea00000-0xfeafffff]
[    1.940020] pci 0000:00:02.1:   bridge window [mem 0xe0000000-0xf01fffff=
 64bit pref]
[    1.940324] pci 0000:02:06.0: [109e:036e] type 00 class 0x040000
[    1.940354] pci 0000:02:06.0: reg 0x10: [mem 0xf0401000-0xf0401fff pref]
[    1.940929] pci 0000:02:06.1: [109e:0878] type 00 class 0x048000
[    1.940956] pci 0000:02:06.1: reg 0x10: [mem 0xf0400000-0xf0400fff pref]
[    1.940956] pci 0000:00:14.4: PCI bridge to [bus 02] (subtractive decode)
[    1.964014] pci 0000:00:14.4:   bridge window [mem 0xf0400000-0xf04fffff=
 pref]
[    1.964031] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af window]=
 (subtractive decode)
[    1.964039] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7 window]=
 (subtractive decode)
[    1.964047] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df window]=
 (subtractive decode)
[    1.964055] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff window]=
 (subtractive decode)
[    1.964063] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff=
 window] (subtractive decode)
[    1.964070] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff=
 window] (subtractive decode)
[    1.964078] pci 0000:00:14.4:   bridge window [mem 0xe0000000-0xffffffff=
 window] (subtractive decode)
[    1.964318] pci 0000:00:15.0: PCI bridge to [bus 03]
[    1.976487] pci 0000:04:00.0: [10ec:8168] type 00 class 0x020000
[    1.976524] pci 0000:04:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    1.976555] pci 0000:04:00.0: reg 0x18: [mem 0xfe900000-0xfe900fff 64bit]
[    1.976574] pci 0000:04:00.0: reg 0x20: [mem 0xf0300000-0xf0303fff 64bit=
 pref]
[    1.976791] pci 0000:04:00.0: supports D1 D2
[    1.976794] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.992059] pci 0000:00:15.2: PCI bridge to [bus 04]
[    2.008013] pci 0000:00:15.2:   bridge window [io  0xd000-0xdfff]
[    2.008017] pci 0000:00:15.2:   bridge window [mem 0xfe900000-0xfe9fffff]
[    2.008023] pci 0000:00:15.2:   bridge window [mem 0xf0300000-0xf03fffff=
 64bit pref]
[    2.017827] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 6 7 10 11 14 15) *0
[    2.041449] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 6 7 10 11 14 15) *0
[    2.061424] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 6 7 10 11 14 15) *0
[    2.085516] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 10 11 14 15) *0
[    2.105308] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 6 7 10 11 14 15) *0
[    2.124705] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 11 14 15) *0
[    2.149056] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 6 7 10 11 14 15) *0
[    2.169062] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *0
[    2.192041] pci 0000:01:00.0: vgaarb: VGA device added: decodes=3Dio+mem=
,owns=3Dnone,locks=3Dnone
[    2.216007] pci 0000:01:00.0: vgaarb: bridge control possible
[    2.236003] pci 0000:01:00.0: vgaarb: setting as boot device
[    2.252003] vgaarb: loaded
[    2.261120] SCSI subsystem initialized
[    2.272087] libata version 3.00 loaded.
[    2.272110] ACPI: bus type USB registered
[    2.284153] usbcore: registered new interface driver usbfs
[    2.300076] usbcore: registered new interface driver hub
[    2.316079] usbcore: registered new device driver usb
[    2.332174] EDAC MC: Ver: 3.0.0
[    2.340296] Registered efivars operations
[    2.360458] PCI: Using ACPI for IRQ routing
[    2.377977] PCI: pci_cache_line_size set to 64 bytes
[    2.378055] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    2.378070] e820: reserve RAM buffer [mem 0xdd234000-0xdfffffff]
[    2.378076] e820: reserve RAM buffer [mem 0xde3af000-0xdfffffff]
[    2.378083] e820: reserve RAM buffer [mem 0xde9f3000-0xdfffffff]
[    2.378089] e820: reserve RAM buffer [mem 0xdf000000-0xdfffffff]
[    2.378096] e820: reserve RAM buffer [mem 0x61f000000-0x61fffffff]
[    2.380010] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    2.384003] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    2.390130] clocksource: Switched to clocksource hpet
[    2.469591] VFS: Disk quotas dquot_6.6.0
[    2.481378] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)
[    2.502256] pnp: PnP ACPI init
[    2.512573] system 00:00: [mem 0xf8000000-0xfbffffff] has been reserved
[    2.532380] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.533330] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.534446] system 00:02: [mem 0xfeb80000-0xfebfffff] could not be reser=
ved
[    2.555297] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.558641] system 00:03: [io  0x0300-0x031f] has been reserved
[    2.576360] system 00:03: [io  0x0290-0x029f] has been reserved
[    2.594088] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.595899] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.598008] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    2.615732] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.616197] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.616752] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 PNP030b (a=
ctive)
[    2.620913] pnp 00:08: [dma 0 disabled]
[    2.621257] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.626053] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    2.643783] system 00:09: [io  0x040b] has been reserved
[    2.659676] system 00:09: [io  0x04d6] has been reserved
[    2.675574] system 00:09: [io  0x0c00-0x0c01] has been reserved
[    2.693293] system 00:09: [io  0x0c14] has been reserved
[    2.709194] system 00:09: [io  0x0c50-0x0c51] has been reserved
[    2.726910] system 00:09: [io  0x0c52] has been reserved
[    2.742811] system 00:09: [io  0x0c6c] has been reserved
[    2.758709] system 00:09: [io  0x0c6f] has been reserved
[    2.774609] system 00:09: [io  0x0cd0-0x0cd1] has been reserved
[    2.792327] system 00:09: [io  0x0cd2-0x0cd3] has been reserved
[    2.810047] system 00:09: [io  0x0cd4-0x0cd5] has been reserved
[    2.827765] system 00:09: [io  0x0cd6-0x0cd7] has been reserved
[    2.845504] system 00:09: [io  0x0cd8-0x0cdf] has been reserved
[    2.863217] system 00:09: [io  0x0800-0x089f] has been reserved
[    2.880936] system 00:09: [io  0x0b00-0x0b0f] has been reserved
[    2.898655] system 00:09: [io  0x0b20-0x0b3f] has been reserved
[    2.916375] system 00:09: [io  0x0900-0x090f] has been reserved
[    2.934094] system 00:09: [io  0x0910-0x091f] has been reserved
[    2.951812] system 00:09: [io  0xfe00-0xfefe] has been reserved
[    2.969538] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reser=
ved
[    2.990370] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    3.010171] system 00:09: [mem 0xfed80000-0xfed8ffff] has been reserved
[    3.029970] system 00:09: [mem 0xfed61000-0xfed70fff] has been reserved
[    3.049769] system 00:09: [mem 0xfec10000-0xfec10fff] has been reserved
[    3.069568] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[    3.089375] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.092323] pnp: PnP ACPI: found 10 devices
[    3.121099] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, m=
ax_idle_ns: 2085701024 ns
[    3.147690] pci 0000:00:02.1: PCI bridge to [bus 01]
[    3.162532] pci 0000:00:02.1:   bridge window [io  0xe000-0xefff]
[    3.180762] pci 0000:00:02.1:   bridge window [mem 0xfea00000-0xfeafffff]
[    3.201062] pci 0000:00:02.1:   bridge window [mem 0xe0000000-0xf01fffff=
 64bit pref]
[    3.224233] pci 0000:00:14.4: PCI bridge to [bus 02]
[    3.239079] pci 0000:00:14.4:   bridge window [mem 0xf0400000-0xf04fffff=
 pref]
[    3.260686] pci 0000:00:15.0: PCI bridge to [bus 03]
[    3.275532] pci 0000:00:15.2: PCI bridge to [bus 04]
[    3.290373] pci 0000:00:15.2:   bridge window [io  0xd000-0xdfff]
[    3.308601] pci 0000:00:15.2:   bridge window [mem 0xfe900000-0xfe9fffff]
[    3.328905] pci 0000:00:15.2:   bridge window [mem 0xf0300000-0xf03fffff=
 64bit pref]
[    3.352076] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
[    3.352078] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
[    3.352080] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
[    3.352082] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    3.352084] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff windo=
w]
[    3.352085] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff windo=
w]
[    3.352087] pci_bus 0000:00: resource 10 [mem 0xe0000000-0xffffffff wind=
ow]
[    3.352089] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    3.352091] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    3.352093] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xf01fffff 64bit=
 pref]
[    3.352095] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf04fffff pref]
[    3.352096] pci_bus 0000:02: resource 4 [io  0x0000-0x03af window]
[    3.352098] pci_bus 0000:02: resource 5 [io  0x03e0-0x0cf7 window]
[    3.352099] pci_bus 0000:02: resource 6 [io  0x03b0-0x03df window]
[    3.352101] pci_bus 0000:02: resource 7 [io  0x0d00-0xffff window]
[    3.352102] pci_bus 0000:02: resource 8 [mem 0x000a0000-0x000bffff windo=
w]
[    3.352104] pci_bus 0000:02: resource 9 [mem 0x000c0000-0x000dffff windo=
w]
[    3.352106] pci_bus 0000:02: resource 10 [mem 0xe0000000-0xffffffff wind=
ow]
[    3.352107] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    3.352109] pci_bus 0000:04: resource 1 [mem 0xfe900000-0xfe9fffff]
[    3.352110] pci_bus 0000:04: resource 2 [mem 0xf0300000-0xf03fffff 64bit=
 pref]
[    3.352816] NET: Registered protocol family 2
[    3.366706] TCP established hash table entries: 262144 (order: 9, 209715=
2 bytes)
[    3.389466] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    3.409760] TCP: Hash tables configured (established 262144 bind 65536)
[    3.429776] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    3.448450] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    3.468698] NET: Registered protocol family 1
[    3.482256] RPC: Registered named UNIX socket transport module.
[    3.499960] RPC: Registered udp transport module.
[    3.514022] RPC: Registered tcp transport module.
[    3.528088] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.781837] pci 0000:00:12.2: PME# does not work under D3, disabling it
[    3.913811] pci 0000:00:13.2: PME# does not work under D3, disabling it
[    3.933690] PCI: CLS 64 bytes, default 64
[    3.933972] Trying to unpack rootfs image as initramfs...
[    4.333645] Freeing initrd memory: 16728K
[    4.345661] AMD-Vi: IOMMU performance counters supported
[    4.361564] AMD-Vi: Applying ATS write check workaround for IOMMU at 000=
0:00:00.2
[    4.385840] pci 0000:00:00.2: can't derive routing for PCI INT A
[    4.403814] pci 0000:00:00.2: PCI INT A: not connected
[    4.420110] iommu: Adding device 0000:00:02.0 to group 0
[    4.436186] iommu: Using direct mapping for device 0000:00:02.0
[    4.453965] iommu: Adding device 0000:00:02.1 to group 0
[    4.470367] iommu: Adding device 0000:00:03.0 to group 1
[    4.486434] iommu: Using direct mapping for device 0000:00:03.0
[    4.504655] iommu: Adding device 0000:00:04.0 to group 2
[    4.520715] iommu: Using direct mapping for device 0000:00:04.0
[    4.538947] iommu: Adding device 0000:00:10.0 to group 3
[    4.555008] iommu: Using direct mapping for device 0000:00:10.0
[    4.572787] iommu: Adding device 0000:00:10.1 to group 3
[    4.589178] iommu: Adding device 0000:00:11.0 to group 4
[    4.605238] iommu: Using direct mapping for device 0000:00:11.0
[    4.623455] iommu: Adding device 0000:00:12.0 to group 5
[    4.639520] iommu: Using direct mapping for device 0000:00:12.0
[    4.657295] iommu: Adding device 0000:00:12.2 to group 5
[    4.673710] iommu: Adding device 0000:00:13.0 to group 6
[    4.689781] iommu: Using direct mapping for device 0000:00:13.0
[    4.707557] iommu: Adding device 0000:00:13.2 to group 6
[    4.723971] iommu: Adding device 0000:00:14.0 to group 7
[    4.740042] iommu: Using direct mapping for device 0000:00:14.0
[    4.757813] iommu: Adding device 0000:00:14.2 to group 7
[    4.773765] iommu: Adding device 0000:00:14.3 to group 7
[    4.790156] iommu: Adding device 0000:00:14.4 to group 8
[    4.806218] iommu: Using direct mapping for device 0000:00:14.4
[    4.824456] iommu: Adding device 0000:00:15.0 to group 9
[    4.840533] iommu: Using direct mapping for device 0000:00:15.0
[    4.858307] iommu: Adding device 0000:00:15.2 to group 9
[    4.874730] iommu: Adding device 0000:00:18.0 to group 10
[    4.891059] iommu: Using direct mapping for device 0000:00:18.0
[    4.908834] iommu: Adding device 0000:00:18.1 to group 10
[    4.925045] iommu: Adding device 0000:00:18.2 to group 10
[    4.941255] iommu: Adding device 0000:00:18.3 to group 10
[    4.957477] iommu: Adding device 0000:00:18.4 to group 10
[    4.973693] iommu: Adding device 0000:00:18.5 to group 10
[    4.989910] iommu: Adding device 0000:01:00.0 to group 0
[    5.005862] iommu: Adding device 0000:01:00.1 to group 0
[    5.021808] iommu: Adding device 0000:02:06.0 to group 8
[    5.037747] iommu: Adding device 0000:02:06.1 to group 8
[    5.053692] iommu: Adding device 0000:04:00.0 to group 9
[    5.069973] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
[    5.085863] AMD-Vi: Extended features (0x800090a52):
[    5.100716]  PPR GT IA PC
[    5.108539] AMD-Vi: Interrupt remapping enabled
[    5.122625] AMD-Vi: Lazy IO/TLB flushing enabled
[    5.136452] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.155717] software IO TLB [mem 0xd5483000-0xd9483000] (64MB) mapped at=
 [0000000070bdf88b-00000000293621a7]
[    5.185258] amd_uncore: AMD NB counters detected
[    5.199334] LVT offset 0 assigned for vector 0x400
[    5.213801] perf: AMD IBS detected (0x000001ff)
[    5.227358] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4 counters/b=
ank).
[    5.250715] Scanning for low memory corruption every 60 seconds
[    5.273338] Initialise system trusted keyrings
[    5.286862] workingset: timestamp_bits=3D40 max_order=3D23 bucket_order=
=3D0
[    5.307714] NFS: Registering the id_resolver key type
[    5.322835] Key type id_resolver registered
[    5.335336] Key type id_legacy registered
[    5.347359] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    5.367131] async_tx: api initialized (async)
[    5.380163] Key type asymmetric registered
[    5.392407] Asymmetric key parser 'x509' registered
[    5.407070] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 248)
[    5.429287] io scheduler noop registered
[    5.441013] io scheduler deadline registered
[    5.453839] io scheduler cfq registered (default)
[    5.467910] io scheduler mq-deadline registered
[    5.481457] io scheduler kyber registered
[    5.493508] io scheduler bfq registered
[    5.505126] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    5.532721] efifb: probing for efifb
[    5.543446] efifb: framebuffer at 0xe0000000, using 8128k, total 8128k
[    5.562969] efifb: mode is 1920x1080x32, linelength=3D7680, pages=3D1
[    5.581193] efifb: scrolling: redraw
[    5.591878] efifb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    5.616370] Console: switching to colour frame buffer device 240x67
[    5.641584] fb0: EFI VGA frame buffer device
[    5.666888] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.706422] 00:08: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    5.745900] brd: module loaded
[    5.756211] ahci 0000:00:11.0: version 3.0
[    5.759525] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 8 ports 6 Gbps 0x=
ff impl SATA mode
[    5.784056] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp=
 pio sxs=20
[    5.806492] ahci 0000:00:11.0: both AHCI_HFLAG_MULTI_MSI flag set and cu=
stom irq handler implemented
[    5.842344] scsi host0: ahci
[    5.851827] scsi host1: ahci
[    5.861354] scsi host2: ahci
[    5.870822] scsi host3: ahci
[    5.880315] scsi host4: ahci
[    5.889811] scsi host5: ahci
[    5.899259] scsi host6: ahci
[    5.908794] scsi host7: ahci
[    5.917924] ata1: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c10=
0 irq 25
[    5.940102] ata2: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c18=
0 irq 26
[    5.962270] ata3: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c20=
0 irq 27
[    5.984438] ata4: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c28=
0 irq 28
[    6.006599] ata5: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c30=
0 irq 29
[    6.028782] ata6: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c38=
0 irq 30
[    6.050946] ata7: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c40=
0 irq 31
[    6.073107] ata8: SATA max UDMA/133 abar m2048@0xfeb0c000 port 0xfeb0c48=
0 irq 32
[    6.097334] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    6.117701] i8042: PNP: PS/2 appears to have AUX port disabled, if this =
is incorrect please boot with i8042.nopnp
[    6.148769] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.164243] mousedev: PS/2 mouse device common for all mice
[    6.181147] rtc_cmos 00:04: RTC can wake from S4
[    6.195422] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    6.213744] rtc_cmos 00:04: alarms up to one month, y3k, 114 bytes nvram=
, hpet irqs
[    6.237194] device-mapper: uevent: version 1.0.3
[    6.250868] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    6.268033] tsc: Refined TSC clocksource calibration: 3999.997 MHz
[    6.268050] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x735=
0b459580, max_idle_ns: 881591204237 ns
[    6.325716] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initialised:=
 dm-devel@redhat.com
[    6.351230] device-mapper: multipath round-robin: version 1.2.0 loaded
[    6.370798] device-mapper: multipath queue-length: version 0.2.0 loaded
[    6.391939] device-mapper: multipath service-time: version 0.3.0 loaded
[    6.410540] ata7: SATA link down (SStatus 0 SControl 300)
[    6.411344] ata8: SATA link down (SStatus 0 SControl 300)
[    6.447961] device-mapper: raid: Loading target version 1.13.0
[    6.466796] EDAC amd64: Node 0: DRAM ECC disabled.
[    6.482432] EDAC amd64: ECC disabled in the BIOS or no ECC capability, m=
odule will not load.
                Either enable ECC checking or force module loading by setti=
ng 'ecc_enable_override'.
                (Note that use of the override may cause unknown side effec=
ts.)
[    6.559925] Initializing XFRM netlink socket
[    6.572059] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    6.572092] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.572120] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.572151] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.572176] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    6.572443] ata4.00: ATA-8: ST480HM000-1G5162, C675, max UDMA/133
[    6.572446] ata4.00: 988494192 sectors, multi 16: LBA48 NCQ (depth 31/32=
), AA
[    6.572758] ata4.00: configured for UDMA/133
[    6.573079] ata1.00: ATA-8: WDC WD6400AADS-00M2B0, 01.00A01, max UDMA/133
[    6.573081] ata1.00: 1250263728 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    6.573899] ata3.00: supports DRM functions and may not be fully accessi=
ble
[    6.574054] ata1.00: configured for UDMA/133
[    6.574267] ata3.00: NCQ Send/Recv Log not supported
[    6.574269] ata3.00: ATA-9: Samsung SSD 840 EVO 250GB, EXT0CB6Q, max UDM=
A/133
[    6.574270] ata3.00: 488397168 sectors, multi 1: LBA48 NCQ (depth 31/32)=
, AA
[    6.574850] ata3.00: supports DRM functions and may not be fully accessi=
ble
[    6.575208] ata3.00: NCQ Send/Recv Log not supported
[    6.575614] ata3.00: configured for UDMA/133
[    6.613818] ata2.00: ATA-7: WDC WD2500JS-75NCB3, 10.02E04, max UDMA/133
[    6.613820] ata2.00: 488281250 sectors, multi 16: LBA48 NCQ (depth 31/32=
), AA
[    6.613894] ata6.00: ATA-6: WDC WD800JB-00ETA0, 77.07W77, max UDMA/100
[    6.613897] ata6.00: 156301488 sectors, multi 16: LBA48=20
[    6.673358] ata6.00: configured for UDMA/100
[    6.692833] ata2.00: configured for UDMA/133
[    7.034189] NET: Registered protocol family 17
[    7.048848] Key type dns_resolver registered
[    7.064993] microcode: CPU0: patch_level=3D0x06003106
[    7.080940] microcode: CPU1: patch_level=3D0x06003106
[    7.096948] microcode: CPU2: patch_level=3D0x06003106
[    7.112905] microcode: CPU3: patch_level=3D0x06003106
[    7.129021] microcode: Microcode Update Driver: v2.2.
[    7.129060] AVX version of gcm_enc/dec engaged.
[    7.160342] AES CTR mode by8 optimization enabled
[    7.184251] sched_clock: Marking stable (7184234297, 0)->(7912481868, -7=
28247571)
[    7.209089] registered taskstats version 1
[    7.222724] Loading compiled-in X.509 certificates
[    7.243524] Loaded X.509 cert 'Build time autogenerated kernel key: 14f9=
58d78b6a34cd455a07781e3cfa8b3df8824e'
[    7.275110] zswap: loaded using pool lzo/z3fold
[    7.291506] Btrfs loaded, crc32c=3Dcrc32c-generic
[    7.306726] clocksource: Switched to clocksource tsc
[    7.309805] Key type encrypted registered
[    7.364188] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.393068] ata5.00: ATAPI: TSSTcorpCD/DVDW SH-S182M, SB03, max UDMA/33
[    7.414331] ata5.00: applying bridge limits
[    7.456839] ata5.00: configured for UDMA/33
[    8.924350] floppy0: no floppy controllers found
[    8.940816] scsi 0:0:0:0: Direct-Access     ATA      WDC WD6400AADS-0 0A=
01 PQ: 0 ANSI: 5
[    8.967907] sd 0:0:0:0: [sda] 1250263728 512-byte logical blocks: (640 G=
B/596 GiB)
[    8.968260] scsi 1:0:0:0: Direct-Access     ATA      WDC WD2500JS-75N 2E=
04 PQ: 0 ANSI: 5
[    8.969387] sd 1:0:0:0: [sdb] 488281250 512-byte logical blocks: (250 GB=
/233 GiB)
[    8.969433] sd 1:0:0:0: [sdb] Write Protect is off
[    8.969436] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    8.969520] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    8.970019] scsi 2:0:0:0: Direct-Access     ATA      Samsung SSD 840  CB=
6Q PQ: 0 ANSI: 5
[    8.971318] sd 2:0:0:0: [sdc] 488397168 512-byte logical blocks: (250 GB=
/233 GiB)
[    8.971365] sd 2:0:0:0: [sdc] Write Protect is off
[    8.971367] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    8.971453] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    8.971714] scsi 3:0:0:0: Direct-Access     ATA      ST480HM000-1G516 C6=
75 PQ: 0 ANSI: 5
[    8.973011] sd 3:0:0:0: [sdd] 988494192 512-byte logical blocks: (506 GB=
/471 GiB)
[    8.973013] sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    8.973066] sd 3:0:0:0: [sdd] Write Protect is off
[    8.973069] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    8.973179] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    8.976491] Alternate GPT is invalid, using primary GPT.
[    8.976506]  sdd: sdd1 sdd2 sdd3 sdd4
[    8.978592] sd 3:0:0:0: [sdd] Attached SCSI disk
[    9.006021] scsi 4:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182M SB=
03 PQ: 0 ANSI: 5
[    9.031895]  sdb: sdb1 sdb2 sdb3 < sdb5 > sdb4
[    9.034190] sd 1:0:0:0: [sdb] Attached SCSI disk
[    9.390756] sd 0:0:0:0: [sda] Write Protect is off
[    9.394344]  sdc: sdc1 sdc2 sdc3 sdc4
[    9.396777] sd 2:0:0:0: [sdc] Attached SCSI disk
[    9.434330] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    9.434429] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    9.539371] sr 4:0:0:0: [sr0] scsi3-mmc drive: 8x/48x writer dvd-ram cd/=
rw xa/form2 cdda tray
[    9.566421] cdrom: Uniform CD-ROM driver Revision: 3.20
[    9.584726] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    9.585658] scsi 5:0:0:0: Direct-Access     ATA      WDC WD800JB-00ET 7W=
77 PQ: 0 ANSI: 5
[    9.612852] sd 5:0:0:0: [sde] 156301488 512-byte logical blocks: (80.0 G=
B/74.5 GiB)
[    9.637401] sd 5:0:0:0: [sde] Write Protect is off
[    9.653256] sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    9.653378] sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    9.710423]  sde: sde1 sde2 sde3 sde4
[    9.725294] sd 5:0:0:0: [sde] Attached SCSI removable disk
[   10.014339]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
[   10.033430] sd 0:0:0:0: [sda] Attached SCSI disk
[   10.049196] PM: Image not found (code -22)
[   10.056411] Freeing unused kernel memory: 1948K
[   10.071509] Write protecting the kernel read-only data: 40960k
[   10.091381] Freeing unused kernel memory: 2008K
[   10.107454] Freeing unused kernel memory: 380K
[   10.122279] rodata_test: all tests were successful
[   10.183683] udevd[236]: starting eudev-3.2.5
[   10.759869] random: crng init done
[   11.044935] BTRFS: device label sync devid 1 transid 770 /dev/sda5
[   12.250047] md/raid1:mdX: active with 2 out of 2 mirrors
[   12.333986] md/raid1:mdX: active with 2 out of 2 mirrors
[   12.373986] BTRFS: device fsid c6cbf25f-f020-4247-822d-d9a85ec3c09f devi=
d 1 transid 11670 /dev/dm-4
[   12.472909] BTRFS: device fsid b1d27ab1-0cee-4b83-919d-a58635d1d67f devi=
d 1 transid 21448 /dev/dm-10
[   12.503594] BTRFS: device fsid 0839f4d0-9e0c-4330-bf0a-71bde2523788 devi=
d 1 transid 301052 /dev/dm-9
[   13.201067] PM: Starting manual resume from disk
[   13.217259] PM: Image not found (code -22)
[   13.228644] BTRFS info (device dm-4): disk space caching is enabled
[   13.249045] BTRFS info (device dm-4): has skinny extents
[   13.324912] BTRFS info (device dm-4): enabling ssd optimizations
[   13.667821] loop: module loaded
[   14.112277] udevd[701]: starting eudev-3.2.5
[   14.209053] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input1
[   14.241418] ACPI: Power Button [PWRB]
[   14.254626] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input2
[   14.255055] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   14.279323] acpi_cpufreq: overriding BIOS provided _PSD data
[   14.322383] ACPI: Power Button [PWRF]
[   14.336306] ACPI: Video Device [VGA1] (multi-head: yes  rom: no  post: n=
o)
[   14.370947] ACPI Error: [AFN7] Namespace lookup failure, AE_NOT_FOUND (2=
0170831/psargs-364)
[   14.407576] ACPI Error: Method parse/execution failed \_SB.PCI0.PB21.VGA=
.LCD._BCM, AE_NOT_FOUND (20170831/psparse-550)
[   14.441676] ACPI Error: Evaluating _BCM failed (20170831/video-364)
[   14.465451] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03=
:00/device:03/LNXVIDEO:01/input/input3
[   14.502238] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   14.542843] QUIRK: Enable AMD PLL fix
[   14.542894] xhci_hcd 0000:00:10.0: xHCI Host Controller
[   14.561377] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus =
number 1
[   14.585807] ehci-pci: EHCI PCI platform driver
[   14.585961] xhci_hcd 0000:00:10.0: hcc params 0x014040c3 hci version 0x1=
00 quirks 0x00000418
[   14.588672] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   14.588674] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   14.588676] usb usb1: Product: xHCI Host Controller
[   14.588677] usb usb1: Manufacturer: Linux 4.15.9-slack xhci-hcd
[   14.588679] usb usb1: SerialNumber: 0000:00:10.0
[   14.596662] hub 1-0:1.0: USB hub found
[   14.596754] hub 1-0:1.0: 2 ports detected
[   14.598005] xhci_hcd 0000:00:10.0: xHCI Host Controller
[   14.598402] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus =
number 2
[   14.598564] usb usb2: We don't know the algorithms for LPM for this host=
, disabling LPM.
[   14.598891] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[   14.598893] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   14.598895] usb usb2: Product: xHCI Host Controller
[   14.598897] usb usb2: Manufacturer: Linux 4.15.9-slack xhci-hcd
[   14.598898] usb usb2: SerialNumber: 0000:00:10.0
[   14.600077] hub 2-0:1.0: USB hub found
[   14.600168] hub 2-0:1.0: 2 ports detected
[   14.604846] xhci_hcd 0000:00:10.1: xHCI Host Controller
[   14.605308] xhci_hcd 0000:00:10.1: new USB bus registered, assigned bus =
number 3
[   14.605708] xhci_hcd 0000:00:10.1: hcc params 0x014040c3 hci version 0x1=
00 quirks 0x00000418
[   14.608160] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   14.608162] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   14.608163] usb usb3: Product: xHCI Host Controller
[   14.608165] usb usb3: Manufacturer: Linux 4.15.9-slack xhci-hcd
[   14.608166] usb usb3: SerialNumber: 0000:00:10.1
[   14.609332] hub 3-0:1.0: USB hub found
[   14.609428] hub 3-0:1.0: 2 ports detected
[   14.610654] xhci_hcd 0000:00:10.1: xHCI Host Controller
[   14.611021] xhci_hcd 0000:00:10.1: new USB bus registered, assigned bus =
number 4
[   14.611179] usb usb4: We don't know the algorithms for LPM for this host=
, disabling LPM.
[   14.611502] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[   14.611504] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   14.611506] usb usb4: Product: xHCI Host Controller
[   14.611507] usb usb4: Manufacturer: Linux 4.15.9-slack xhci-hcd
[   14.611509] usb usb4: SerialNumber: 0000:00:10.1
[   14.612593] hub 4-0:1.0: USB hub found
[   14.612683] hub 4-0:1.0: 2 ports detected
[   14.629696] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   14.676728] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, re=
vision 0
[   14.676730] piix4_smbus 0000:00:14.0: Using register 0x2e for SMBus port=
 selection
[   14.677715] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller at=
 0xb20
[   15.006723] EFI Variables Facility v0.08 2004-May-17
[   15.044377] Linux video capture interface: v2.00
[   15.109976] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   15.132485] r8169 0000:04:00.0 eth0: RTL8168g/8111g at 0x000000007b0b2a2=
0, e0:3f:49:6f:36:ef, XID 0c000880 IRQ 43
[   15.132489] r8169 0000:04:00.0 eth0: jumbo features [frames: 9200 bytes,=
 tx checksumming: ko]
[   15.326686] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
[   15.328933] snd_hda_intel 0000:01:00.1: Force to non-snoop mode
[   15.592465] input: HDA ATI HDMI HDMI/DP,pcm=3D3 as /devices/pci0000:00/0=
000:00:02.1/0000:01:00.1/sound/card1/input4
[   15.593085] input: HDA ATI HDMI HDMI/DP,pcm=3D7 as /devices/pci0000:00/0=
000:00:02.1/0000:01:00.1/sound/card1/input5
[   15.593638] input: HDA ATI HDMI HDMI/DP,pcm=3D8 as /devices/pci0000:00/0=
000:00:02.1/0000:01:00.1/sound/card1/input6
[   15.594183] input: HDA ATI HDMI HDMI/DP,pcm=3D9 as /devices/pci0000:00/0=
000:00:02.1/0000:01:00.1/sound/card1/input7
[   15.594745] input: HDA ATI HDMI HDMI/DP,pcm=3D10 as /devices/pci0000:00/=
0000:00:02.1/0000:01:00.1/sound/card1/input8
[   15.595301] input: HDA ATI HDMI HDMI/DP,pcm=3D11 as /devices/pci0000:00/=
0000:00:02.1/0000:01:00.1/sound/card1/input9
[   15.675448] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC887-VD:=
 line_outs=3D3 (0x14/0x15/0x16/0x0/0x0) type:line
[   15.675451] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=3D0 (0x0/=
0x0/0x0/0x0/0x0)
[   15.675454] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=3D1 (0x1b/0x0/=
0x0/0x0/0x0)
[   15.675455] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=3D0x0
[   15.675457] snd_hda_codec_realtek hdaudioC0D0:    dig-out=3D0x11/0x1e
[   15.675458] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[   15.675461] snd_hda_codec_realtek hdaudioC0D0:      Front Mic=3D0x19
[   15.675463] snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=3D0x18
[   15.675464] snd_hda_codec_realtek hdaudioC0D0:      Line=3D0x1a
[   15.700576] input: HD-Audio Generic Rear Mic as /devices/pci0000:00/0000=
:00:14.2/sound/card0/input10
[   15.701124] bttv: driver version 0.9.19 loaded
[   15.701126] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   15.701171] input: HD-Audio Generic Line as /devices/pci0000:00/0000:00:=
14.2/sound/card0/input11
[   15.701354] bttv: Bt8xx card found (0)
[   15.701387] bttv 0000:02:06.0: enabling device (0000 -> 0002)
[   15.701732] input: HD-Audio Generic Line Out Front as /devices/pci0000:0=
0/0000:00:14.2/sound/card0/input12
[   15.702291] input: HD-Audio Generic Line Out Surround as /devices/pci000=
0:00/0000:00:14.2/sound/card0/input13
[   15.702841] input: HD-Audio Generic Line Out CLFE as /devices/pci0000:00=
/0000:00:14.2/sound/card0/input14
[   15.702856] bttv: 0: Bt878 (rev 17) at 0000:02:06.0, irq: 21, latency: 3=
2, mmio: 0xf0401000
[   15.702898] bttv: 0: detected: Pinnacle PCTV [card=3D39], PCI subsystem =
ID is 11bd:0012
[   15.702899] bttv: 0: using: Pinnacle PCTV Studio/Rave [card=3D39,autodet=
ected]
[   15.703685] bttv: 0: i2c: checking for MSP34xx @ 0x80... not found
[   15.704429] bttv: 0: miro: id=3D25 tuner=3D1 radio=3Dno stereo=3Dno
[   15.704430] bttv: 0: tuner type=3D1
[   15.945182] i2c /dev entries driver
[   16.015575] bttv: 0: audio absent, no audio device found!
[   16.029846] r8169 0000:04:00.0 peth0: renamed from eth0
[   16.081940] asus_wmi: ASUS WMI generic driver loaded
[   16.156856] asus_wmi: Initialization: 0x0
[   16.158082] asus_wmi: BIOS WMI version: 0.9
[   16.160808] asus_wmi: SFUN value: 0x0
[   16.184990] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/inp=
ut/input15
[   16.188181] asus_wmi: Number of fans: 1
[   16.213675] tea5767: All bytes are equal. It is not a TEA5767
[   16.213681] tuner: 5-0060: Tuner -1 found with type(s) Radio TV.
[   16.301120] tuner-simple 5-0060: creating new instance
[   16.301123] tuner-simple 5-0060: type set to 1 (Philips PAL_I (FI1246 an=
d compatibles))
[   16.302752] bttv: 0: Setting PLL: 28636363 =3D> 35468950 (needs up to 10=
0ms)
[   16.340020] bttv: PLL set ok
[   16.341221] bttv: 0: registered device video0
[   16.341539] bttv: 0: registered device vbi0
[   16.690950] [drm] amdgpu kernel modesetting enabled.
[   16.799694] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[   16.925397] Found CRAT image with size=3D1320
[   16.926292] ehci-pci 0000:00:12.2: EHCI Host Controller
[   16.926734] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus =
number 5
[   16.926752] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 E=
HCI dummy qh workaround
[   16.926766] ehci-pci 0000:00:12.2: debug port 1
[   16.926951] ehci-pci 0000:00:12.2: irq 17, io mem 0xfeb0a000
[   16.940149] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   16.940583] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   16.940586] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   16.940587] usb usb5: Product: EHCI Host Controller
[   16.940589] usb usb5: Manufacturer: Linux 4.15.9-slack ehci_hcd
[   16.940590] usb usb5: SerialNumber: 0000:00:12.2
[   16.942349] hub 5-0:1.0: USB hub found
[   16.942524] hub 5-0:1.0: 5 ports detected
[   16.947226] ehci-pci 0000:00:13.2: EHCI Host Controller
[   16.947646] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus =
number 6
[   16.947665] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 E=
HCI dummy qh workaround
[   16.947678] ehci-pci 0000:00:13.2: debug port 1
[   16.947794] ehci-pci 0000:00:13.2: irq 17, io mem 0xfeb08000
[   16.960252] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   16.961216] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   16.961221] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   16.961224] usb usb6: Product: EHCI Host Controller
[   16.961228] usb usb6: Manufacturer: Linux 4.15.9-slack ehci_hcd
[   16.961231] usb usb6: SerialNumber: 0000:00:13.2
[   16.963672] hub 6-0:1.0: USB hub found
[   16.963874] hub 6-0:1.0: 5 ports detected
[   17.224068] ohci-pci: OHCI PCI platform driver
[   17.227243] ohci-pci 0000:00:12.0: OHCI PCI host controller
[   17.227804] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus =
number 7
[   17.228072] ohci-pci 0000:00:12.0: irq 18, io mem 0xfeb0b000
[   17.292400] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   17.292402] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   17.292404] usb usb7: Product: OHCI PCI host controller
[   17.292405] usb usb7: Manufacturer: Linux 4.15.9-slack ohci_hcd
[   17.292407] usb usb7: SerialNumber: 0000:00:12.0
[   17.293581] hub 7-0:1.0: USB hub found
[   17.293664] hub 7-0:1.0: 5 ports detected
[   17.297655] ohci-pci 0000:00:13.0: OHCI PCI host controller
[   17.298132] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus =
number 8
[   17.298274] ohci-pci 0000:00:13.0: irq 18, io mem 0xfeb09000
[   17.360412] usb usb8: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   17.360414] usb usb8: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   17.360415] usb usb8: Product: OHCI PCI host controller
[   17.360417] usb usb8: Manufacturer: Linux 4.15.9-slack ohci_hcd
[   17.360418] usb usb8: SerialNumber: 0000:00:13.0
[   17.361638] hub 8-0:1.0: USB hub found
[   17.361727] hub 8-0:1.0: 5 ports detected
[   17.660134] usb 7-2: new low-speed USB device number 2 using ohci-pci
[   17.821773] Parsing CRAT table with 1 nodes
[   17.835588] Found CU entry in CRAT table with proximity_domain=3D0 caps=
=3D0
[   17.856688] CU CPU: cores=3D4 id_base=3D16
[   17.869194] Found memory entry in CRAT table with proximity_domain=3D0
[   17.889522] Found memory entry in CRAT table with proximity_domain=3D0
[   17.909818] Found cache entry in CRAT table with processor_id=3D16
[   17.929087] Found cache entry in CRAT table with processor_id=3D16
[   17.948323] Found cache entry in CRAT table with processor_id=3D16
[   17.967538] Found cache entry in CRAT table with processor_id=3D17
[   17.986738] Found cache entry in CRAT table with processor_id=3D18
[   18.005937] Found cache entry in CRAT table with processor_id=3D18
[   18.025111] Found cache entry in CRAT table with processor_id=3D18
[   18.044262] Found cache entry in CRAT table with processor_id=3D19
[   18.063389] Found TLB entry in CRAT table (not processing)
[   18.080966] Found TLB entry in CRAT table (not processing)
[   18.098523] Found TLB entry in CRAT table (not processing)
[   18.116049] Found TLB entry in CRAT table (not processing)
[   18.133565] Found TLB entry in CRAT table (not processing)
[   18.151067] Found TLB entry in CRAT table (not processing)
[   18.168551] Found TLB entry in CRAT table (not processing)
[   18.186014] Found TLB entry in CRAT table (not processing)
[   18.203456] Found TLB entry in CRAT table (not processing)
[   18.220883] Found TLB entry in CRAT table (not processing)
[   18.238300] Creating topology SYSFS entries
[   18.252185] Finished initializing topology ret=3D0
[   18.267041] kfd kfd: Initialized module
[   18.280112] checking generic (e0000000 7f0000) vs hw (e0000000 10000000)
[   18.280117] fb: switching to amdgpudrmfb from EFI VGA
[   18.298030] Console: switching to colour dummy device 80x25
[   18.315563] amdgpu 0000:01:00.0: enabling device (0006 -> 0007)
[   18.335171] [drm] initializing kernel modesetting (POLARIS10 0x1002:0x67=
DF 0x1043:0x04FB 0xC7).
[   18.361290] [drm] register mmio base: 0xFEA00000
[   18.375107] [drm] register mmio size: 262144
[   18.387921] [drm] probing gen 2 caps for device 1022:1425 =3D 733d03/e
[   18.406970] [drm] probing mlw for device 1022:1425 =3D 733d03
[   18.423804] [drm] UVD is enabled in VM mode
[   18.436311] [drm] UVD ENC is enabled in VM mode
[   18.449858] [drm] VCE enabled in VM mode
[   18.461661] ATOM BIOS: 115-D000PIL-100
[   18.472903] [drm] GPU post is not needed
[   18.491615] [drm] vm size is 64 GB, block size is 13-bit, fragment size =
is 9-bit
[   18.522287] amdgpu 0000:01:00.0: VRAM: 8192M 0x000000F400000000 - 0x0000=
00F5FFFFFFFF (8192M used)
[   18.548885] amdgpu 0000:01:00.0: GTT: 256M 0x0000000000000000 - 0x000000=
000FFFFFFF
[   18.571584] [drm] Detected VRAM RAM=3D8192M, BAR=3D256M
[   18.586188] [drm] RAM width 256bits GDDR5
[   18.598846] [TTM] Zone  kernel: Available graphics memory: 10721474 kiB
[   18.618676] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   18.638202] [TTM] Initializing pool allocator
[   18.651345] [TTM] Initializing DMA pool allocator
[   18.665692] [drm] amdgpu: 8192M of VRAM memory ready
[   18.680584] [drm] amdgpu: 8192M of GTT memory ready.
[   18.695635] [drm] GART: num cpu pages 65536, num gpu pages 65536
[   18.713831] [drm] PCIE GART of 256M enabled (table at 0x000000F400040000=
).
[   18.735091] amdgpu 0000:01:00.0: amdgpu: using MSI.
[   18.749688] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   18.769490] [drm] Driver supports precise vblank timestamp query.
[   18.787849] [drm] amdgpu: irq initialized.
[   18.800339] amdgpu: [powerplay] amdgpu: powerplay sw initialized
[   18.823300] [drm] AMDGPU Display Connectors
[   18.835840] [drm] Connector 0:
[   18.844968] [drm]   DP-1
[   18.852532] [drm]   HPD1
[   18.860095] [drm]   DDC: 0x486c 0x486c 0x486d 0x486d 0x486e 0x486e 0x486=
f 0x486f
[   18.882226] [drm]   Encoders:
[   18.891091] [drm]     DFP1: INTERNAL_UNIPHY1
[   18.903855] [drm] Connector 1:
[   18.912981] [drm]   DP-2
[   18.920542] [drm]   HPD5
[   18.928112] [drm]   DDC: 0x4874 0x4874 0x4875 0x4875 0x4876 0x4876 0x487=
7 0x4877
[   18.950240] [drm]   Encoders:
[   18.959104] [drm]     DFP2: INTERNAL_UNIPHY1
[   18.971900] [drm] Connector 2:
[   18.981034] [drm]   HDMI-A-1
[   18.989649] [drm]   HPD6
[   18.997204] [drm]   DDC: 0x4868 0x4868 0x4869 0x4869 0x486a 0x486a 0x486=
b 0x486b
[   19.019349] [drm]   Encoders:
[   19.028212] [drm]     DFP3: INTERNAL_UNIPHY2
[   19.041146] [drm] Connector 3:
[   19.050273] [drm]   HDMI-A-2
[   19.058880] [drm]   HPD4
[   19.066442] [drm]   DDC: 0x4870 0x4870 0x4871 0x4871 0x4872 0x4872 0x487=
3 0x4873
[   19.088572] [drm]   Encoders:
[   19.097437] [drm]     DFP4: INTERNAL_UNIPHY2
[   19.110256] [drm] Connector 4:
[   19.119381] [drm]   DVI-D-1
[   19.127727] [drm]   HPD3
[   19.135291] [drm]   DDC: 0x487c 0x487c 0x487d 0x487d 0x487e 0x487e 0x487=
f 0x487f
[   19.157422] [drm]   Encoders:
[   19.166287] [drm]     DFP5: INTERNAL_UNIPHY
[   19.184076] [drm] Chained IB support enabled!
[   19.206148] amdgpu 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0=
000000000400040, cpu addr 0x00000000c2acfda4
[   19.238270] amdgpu 0000:01:00.0: fence driver on ring 1 use gpu addr 0x0=
0000000004000c0, cpu addr 0x000000009029b931
[   19.252168] usb 7-2: New USB device found, idVendor=3D0463, idProduct=3D=
ffff
[   19.252174] usb 7-2: New USB device strings: Mfr=3D4, Product=3D36, Seri=
alNumber=3D0
[   19.252177] usb 7-2: Product: ellipse
[   19.252181] usb 7-2: Manufacturer: MGE UPS SYSTEMS
[   19.337139] amdgpu 0000:01:00.0: fence driver on ring 2 use gpu addr 0x0=
000000000400140, cpu addr 0x0000000097dc1a0c
[   19.369109] amdgpu 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0=
0000000004001c0, cpu addr 0x00000000a158d958
[   19.401030] amdgpu 0000:01:00.0: fence driver on ring 4 use gpu addr 0x0=
000000000400240, cpu addr 0x000000007b1458f5
[   19.433001] amdgpu 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0=
0000000004002c0, cpu addr 0x000000009c7f0437
[   19.464940] amdgpu 0000:01:00.0: fence driver on ring 6 use gpu addr 0x0=
000000000400340, cpu addr 0x00000000f85a6c61
[   19.496909] amdgpu 0000:01:00.0: fence driver on ring 7 use gpu addr 0x0=
0000000004003c0, cpu addr 0x00000000390c41f4
[   19.528807] amdgpu 0000:01:00.0: fence driver on ring 8 use gpu addr 0x0=
000000000400440, cpu addr 0x0000000047973796
[   19.552120] usb 7-3: new full-speed USB device number 3 using ohci-pci
[   19.580205] amdgpu 0000:01:00.0: fence driver on ring 9 use gpu addr 0x0=
0000000004004e0, cpu addr 0x0000000074e1ab08
[   19.622513] amdgpu 0000:01:00.0: fence driver on ring 10 use gpu addr 0x=
0000000000400560, cpu addr 0x00000000bd49a140
[   19.654735] amdgpu 0000:01:00.0: fence driver on ring 11 use gpu addr 0x=
00000000004005e0, cpu addr 0x00000000072167c3
[   19.689683] [drm] Found UVD firmware Version: 1.130 Family ID: 16
[   19.708868] amdgpu 0000:01:00.0: fence driver on ring 12 use gpu addr 0x=
000000f4001e7a80, cpu addr 0x00000000bf916135
[   19.741017] amdgpu 0000:01:00.0: fence driver on ring 13 use gpu addr 0x=
00000000004006e0, cpu addr 0x00000000acdb077e
[   19.755113] usb 7-3: New USB device found, idVendor=3D09da, idProduct=3D=
9066
[   19.755118] usb 7-3: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[   19.755122] usb 7-3: Product: USB Device
[   19.755126] usb 7-3: Manufacturer: A4TECH
[   19.838306] amdgpu 0000:01:00.0: fence driver on ring 14 use gpu addr 0x=
0000000000400760, cpu addr 0x000000001fef0355
[   19.872418] [drm] Found VCE firmware Version: 52.4 Binary ID: 3
[   19.890914] amdgpu 0000:01:00.0: fence driver on ring 15 use gpu addr 0x=
00000000004007e0, cpu addr 0x00000000ab7cc637
[   19.923249] amdgpu 0000:01:00.0: fence driver on ring 16 use gpu addr 0x=
0000000000400860, cpu addr 0x000000006f7edfff
[   20.020011] [drm] ring test on 0 succeeded in 12 usecs
[   20.036226] [drm] ring test on 9 succeeded in 9 usecs
[   20.051372] [drm] ring test on 1 succeeded in 8 usecs
[   20.066482] [drm] ring test on 2 succeeded in 2 usecs
[   20.081598] [drm] ring test on 3 succeeded in 2 usecs
[   20.096815] [drm] ring test on 4 succeeded in 3 usecs
[   20.108013] usb 7-4: new full-speed USB device number 4 using ohci-pci
[   20.131489] [drm] ring test on 5 succeeded in 2 usecs
[   20.146626] [drm] ring test on 6 succeeded in 2 usecs
[   20.161744] [drm] ring test on 7 succeeded in 2 usecs
[   20.176862] [drm] ring test on 8 succeeded in 2 usecs
[   20.192066] [drm] ring test on 10 succeeded in 6 usecs
[   20.207442] [drm] ring test on 11 succeeded in 6 usecs
[   20.269709] [drm] ring test on 12 succeeded in 1 usecs
[   20.285724] [drm] ring test on 13 succeeded in 263 usecs
[   20.302702] [drm] ring test on 14 succeeded in 443 usecs
[   20.318595] [drm] UVD and UVD ENC initialized successfully.
[   20.352075] usb 7-4: New USB device found, idVendor=3D28de, idProduct=3D=
1142
[   20.372116] usb 7-4: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[   20.393460] usb 7-4: Product: Steam Controller
[   20.406744] usb 7-4: Manufacturer: Valve Software
[   20.445685] [drm] ring test on 15 succeeded in 6 usecs
[   20.461100] [drm] ring test on 16 succeeded in 2 usecs
[   20.476501] [drm] VCE initialized successfully.
[   20.500022] [drm] ib test on ring 0 succeeded
[   20.527068] hidraw: raw HID events driver (C) Jiri Kosina
[   20.564081] [drm] ib test on ring 1 succeeded
[   20.577234] [drm] ib test on ring 2 succeeded
[   20.590397] [drm] ib test on ring 3 succeeded
[   20.603492] [drm] ib test on ring 4 succeeded
[   20.616597] [drm] ib test on ring 5 succeeded
[   20.629685] [drm] ib test on ring 6 succeeded
[   20.642787] [drm] ib test on ring 7 succeeded
[   20.655888] [drm] ib test on ring 8 succeeded
[   21.180201] [drm] ib test on ring 9 succeeded
[   21.193430] [drm] ib test on ring 10 succeeded
[   21.206802] [drm] ib test on ring 11 succeeded
[   21.221342] [drm] ib test on ring 12 succeeded
[   21.237902] [drm] ib test on ring 13 succeeded
[   21.253895] [drm] ib test on ring 14 succeeded
[   21.267566] [drm] ib test on ring 15 succeeded
[   21.455814] [drm] fb mappable at 0xE0568000
[   21.468349] [drm] vram apper at 0xE0000000
[   21.480600] [drm] size 8294400
[   21.489725] [drm] fb depth is 24
[   21.499371] [drm]    pitch is 7680
[   21.510102] fbcon: amdgpudrmfb (fb0) is primary device
[   21.705967] Console: switching to colour frame buffer device 240x67
[   21.919409] amdgpu 0000:01:00.0: fb0: amdgpudrmfb frame buffer device
[   21.954748] amdgpu 0000:01:00.0: kfd not supported on this ASIC
[   21.973040] [drm] Initialized amdgpu 3.23.0 20150101 for 0000:01:00.0 on=
 minor 0
[   24.562965] usbcore: registered new interface driver usbhid
[   24.579720] usbhid: USB HID core driver
[   24.606157] hid-generic 0003:0463:FFFF.0001: hiddev96,hidraw0: USB HID v=
1.00 Device [MGE UPS SYSTEMS ellipse] on usb-0000:00:12.0-2/input0
[   24.644534] input: A4TECH USB Device as /devices/pci0000:00/0000:00:12.0=
/usb7/7-3/7-3:1.0/0003:09DA:9066.0002/input/input16
[   24.739845] hid-generic 0003:09DA:9066.0002: input,hiddev97,hidraw1: USB=
 HID v1.11 Keyboard [A4TECH USB Device] on usb-0000:00:12.0-3/input0
[   24.778481] input: A4TECH USB Device as /devices/pci0000:00/0000:00:12.0=
/usb7/7-3/7-3:1.1/0003:09DA:9066.0003/input/input17
[   24.813174] hid-generic 0003:09DA:9066.0003: input,hidraw2: USB HID v1.1=
1 Mouse [A4TECH USB Device] on usb-0000:00:12.0-3/input1
[   24.848808] input: Valve Software Steam Controller as /devices/pci0000:0=
0/0000:00:12.0/usb7/7-4/7-4:1.0/0003:28DE:1142.0004/input/input18
[   24.951066] hid-generic 0003:28DE:1142.0004: input,hidraw3: USB HID v1.1=
1 Keyboard [Valve Software Steam Controller] on usb-0000:00:12.0-4/input0
[   24.991649] hid-generic 0003:28DE:1142.0005: hiddev98,hidraw4: USB HID v=
1.11 Device [Valve Software Steam Controller] on usb-0000:00:12.0-4/input1
[   25.032242] hid-generic 0003:28DE:1142.0006: hiddev99,hidraw5: USB HID v=
1.11 Device [Valve Software Steam Controller] on usb-0000:00:12.0-4/input2
[   25.072733] hid-generic 0003:28DE:1142.0007: hiddev100,hidraw6: USB HID =
v1.11 Device [Valve Software Steam Controller] on usb-0000:00:12.0-4/input3
[   25.113416] hid-generic 0003:28DE:1142.0008: hiddev101,hidraw7: USB HID =
v1.11 Device [Valve Software Steam Controller] on usb-0000:00:12.0-4/input4
[   25.711334] Adding 16787452k swap on /dev/sda1.  Priority:10 extents:1 a=
cross:16787452k FS
[   25.738064] Adding 3865596k swap on /dev/sdb1.  Priority:5 extents:1 acr=
oss:3865596k FS
[   25.831605] fuse init (API version 7.26)
[   26.272186] BTRFS info (device dm-4): enabling auto defrag
[   26.292115] BTRFS info (device dm-4): use lzo compression, level 0
[   26.314802] BTRFS info (device dm-4): disk space caching is enabled
[   41.941478] input: PC Speaker as /devices/platform/pcspkr/input/input19
[   45.916896] BTRFS info (device sda5): enabling auto defrag
[   45.933377] BTRFS info (device sda5): use zlib compression, level 3
[   45.952184] BTRFS info (device sda5): disk space caching is enabled
[   45.971024] BTRFS info (device sda5): has skinny extents
[   46.520952] EXT4-fs (sda6): mounted filesystem with ordered data mode. O=
pts: errors=3Dremount-ro
[   46.657453] REISERFS (device sda7): found reiserfs format "3.6" with sta=
ndard journal
[   46.681122] REISERFS (device sda7): using ordered data mode
[   46.697900] reiserfs: using flush barriers
[   46.718834] REISERFS (device sda7): journal params: device sda7, size 81=
92, journal first block 18, max trans len 1024, max batch 900, max commit a=
ge 30, max trans age 30
[   46.765156] REISERFS (device sda7): checking transaction log (sda7)
[   46.836632] REISERFS (device sda7): Using r5 hash to sort names
[   46.998739] EXT4-fs (sda8): mounted filesystem with ordered data mode. O=
pts: errors=3Dremount-ro
[   47.114261] EXT4-fs (sdb2): mounted filesystem with ordered data mode. O=
pts: (null)
[   47.214005] EXT4-fs (sdb5): mounted filesystem with ordered data mode. O=
pts: errors=3Dremount-ro
[   47.258766] EXT4-fs (sdd3): mounted filesystem with ordered data mode. O=
pts: errors=3Dremount-ro
[   47.350309] BTRFS info (device dm-9): enabling ssd optimizations
[   47.368339] BTRFS info (device dm-9): enabling auto defrag
[   47.384804] BTRFS info (device dm-9): use lzo compression, level 0
[   47.404947] BTRFS info (device dm-9): disk space caching is enabled
[   47.425327] BTRFS info (device dm-9): has skinny extents
[   47.710195] BTRFS info (device dm-10): enabling ssd optimizations
[   47.732235] BTRFS info (device dm-10): enabling auto defrag
[   47.750506] BTRFS info (device dm-10): use zlib compression, level 3
[   47.771137] BTRFS info (device dm-10): disk space caching is enabled
[   47.791768] BTRFS info (device dm-10): has skinny extents
[   51.182891] NET: Registered protocol family 10
[   51.184778] Segment Routing with IPv6
[   51.326260] bridge: filtering via arp/ip/ip6tables is no longer availabl=
e by default. Update your scripts to load br_netfilter if you need this.
[   51.340473] eth0: port 1(peth0) entered blocking state
[   51.340476] eth0: port 1(peth0) entered disabled state
[   51.341138] device peth0 entered promiscuous mode
[   51.414815] r8169 0000:04:00.0 peth0: link down
[   51.414817] r8169 0000:04:00.0 peth0: link down
[   51.415105] IPv6: ADDRCONF(NETDEV_UP): peth0: link is not ready
[   51.418784] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   52.073260] ip_tables: (C) 2000-2006 Netfilter Core Team
[   52.849548] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[   53.044884] r8169 0000:04:00.0 peth0: link up
[   53.044896] IPv6: ADDRCONF(NETDEV_CHANGE): peth0: link becomes ready
[   53.045268] eth0: port 1(peth0) entered blocking state
[   53.045270] eth0: port 1(peth0) entered forwarding state
[   53.045451] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   53.140241] nf_nat_irc: kernel >=3D 2.6.10 only uses 'ports' for conntra=
ck modules
[   66.651644] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   73.414626] ata1.00: configured for UDMA/133
[   73.414634] ata1: EH complete
[   73.424249] ata3.00: supports DRM functions and may not be fully accessi=
ble
[   73.424618] ata3.00: NCQ Send/Recv Log not supported
[   73.425212] ata3.00: supports DRM functions and may not be fully accessi=
ble
[   73.425572] ata3.00: NCQ Send/Recv Log not supported
[   73.425979] ata3.00: configured for UDMA/133
[   73.425987] ata3: EH complete
[   73.433620] ata2.00: configured for UDMA/133
[   73.433627] ata2: EH complete
[   73.493074] ata4.00: configured for UDMA/133
[   73.493084] ata4: EH complete
[   74.358387] f71882fg: Found f81768d chip at 0x290, revision 32
[   74.361108] f71882fg f71882fg.656: Fan: 1 is in duty-cycle mode
[   74.361808] f71882fg f71882fg.656: Fan: 2 is in duty-cycle mode
[   74.362494] f71882fg f71882fg.656: Fan: 3 is in duty-cycle mode
[   74.362968] f71882fg f71882fg.656: hwmon_device_register() is deprecated=
. Please convert the driver to use hwmon_device_register_with_info().
[  782.907749] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[  782.907755] ata6.00: waking up from sleep
[  782.907766] ata6: hard resetting link
[  783.683713] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  783.688686] ata6.00: configured for UDMA/100
[  783.688732] ata6: EH complete
[ 7556.565475] Process accounting resumed
[10871.064638] BTRFS critical (device dm-4): corrupt leaf: root=3D1 block=
=3D999014400 slot=3D10, bad key order, prev (18446744073709551606 128 45691=
080704) current (18446744071562067958 128 45691621376)
[10871.184847] BTRFS critical (device dm-4): corrupt leaf: root=3D1 block=
=3D999014400 slot=3D10, bad key order, prev (18446744073709551606 128 45691=
080704) current (18446744071562067958 128 45691621376)

--MP_/ezjvi6UHFFEwn.PQHcjXCLG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=lvm-ssd.txt

# pvs
  PV         VG    Fmt  Attr PSize    PFree  =20
  /dev/sdc2  vdisk lvm2 a--  <232,00g 1012,00m
  /dev/sdd2  vdisk lvm2 a--  <444,91g   <3,90g

# vgs
  VG    #PV #LV #SN Attr   VSize   VFree=20
  vdisk   2   3   0 wz--n- 676,90g <4,89g

# lvs
  LV    VG    Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Syn=
c Convert
  home  vdisk rwi-aor--- 175,00g                                    100,00 =
        =20
  root  vdisk rwi-aor---  56,00g                                    100,00 =
        =20
  steam vdisk -wi-ao---- 210,00g                                           =
        =20

# hdparm -i /dev/sdc

/dev/sdc:

 Model=3DSamsung SSD 840 EVO 250GB, FwRev=3DEXT0CB6Q, SerialNo=3DS1DBNSBF72=
1669N
 Config=3D{ Fixed }
 RawCHS=3D16383/16/63, TrkSize=3D0, SectSize=3D0, ECCbytes=3D0
 BuffType=3Dunknown, BuffSize=3Dunknown, MaxMultSect=3D1, MultSect=3D1
 CurCHS=3D16383/16/63, CurSects=3D16514064, LBA=3Dyes, LBAsects=3D488397168
 IORDY=3Don/off, tPIO=3D{min:120,w/IORDY:120}, tDMA=3D{min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4=20
 DMA modes:  mdma0 mdma1 mdma2=20
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6=20
 AdvancedPM=3Dno WriteCache=3Denabled
 Drive conforms to: unknown:  ATA/ATAPI-2,3,4,5,6,7

 * signifies the current active mode

# hdparm -i /dev/sdd

/dev/sdd:

 Model=3DST480HM000-1G5162, FwRev=3DC675, SerialNo=3DZ4P005JD
 Config=3D{ Fixed }
 RawCHS=3D16383/16/63, TrkSize=3D0, SectSize=3D0, ECCbytes=3D0
 BuffType=3Dunknown, BuffSize=3Dunknown, MaxMultSect=3D16, MultSect=3Doff
 (maybe): CurCHS=3D16383/16/63, CurSects=3D16514064, LBA=3Dyes, LBAsects=3D=
988494192
 IORDY=3Don/off, tPIO=3D{min:120,w/IORDY:120}, tDMA=3D{min:120,rec:120}
 PIO modes:  pio0 pio3 pio4=20
 DMA modes:  mdma0 mdma1 mdma2=20
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6=20
 AdvancedPM=3Dno WriteCache=3Denabled
 Drive conforms to: unknown:  ATA/ATAPI-4,5,6,7

 * signifies the current active mode


mount | grep root
/dev/mapper/vdisk-root on / type btrfs (rw,relatime,ssd,autodefrag,compress=
=3Dlzo,space_cache)


--MP_/ezjvi6UHFFEwn.PQHcjXCLG--

--Sig_/nBpo7nQk45aG0flloK5OkM3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQzYESp8QLV9Wpl3Vuu/WNrOwxyswUCWqiDygAKCRCu/WNrOwxy
s75wAKCZqtP94wSyWiH5kP0jsl4NjQAVwQCg2WGPgNWG5gz50osYQpKRmW9Y3lg=
=voV5
-----END PGP SIGNATURE-----

--Sig_/nBpo7nQk45aG0flloK5OkM3--
