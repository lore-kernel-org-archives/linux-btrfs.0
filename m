Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxc2.seznam.cz ([77.75.77.23]:33676 "EHLO mxc2.seznam.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752460AbdF0IBB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 04:01:01 -0400
Date: Tue, 27 Jun 2017 09:45:02 +0200
From: Karel =?utf-8?B?S2/EjcOt?= <cynerd@email.cz>
To: linux-btrfs@vger.kernel.org
Subject: invalid location in dir intem
Message-ID: <20170627074502.fvusad7x2mefsgkz@cynerd-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="embmhhw7cail5vnj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--embmhhw7cail5vnj
Content-Type: multipart/mixed; boundary="to23qdmubyw74dqp"
Content-Disposition: inline


--to23qdmubyw74dqp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello

I have encountered problem with my btrfs partition. I have file that is rep=
orted
as missing, but I can't get rid of it. btrfs-check reports:

	checking extents
	checking free space cache
	checking fs roots
	invalid location in dir item 99
	invalid location in dir item 114
		unresolved ref dir 28321 index 0 namelen 0 name  filetype 0 errors 6, no =
dir index, no inode ref
		unresolved ref dir 28321 index 29 namelen 25 name validators.cpython-34.p=
yo filetype 1 errors 1, no dir item
	root 484 inode 18446744073709551361 errors 2002, no orphan item, link coun=
t wrong
		unresolved ref dir 28321 index 0 namelen 0 name  filetype 0 errors 6, no =
dir index, no inode ref
		unresolved ref dir 28321 index 0 namelen 255 name  filetype 0 errors 106,=
 no dir index, no inode ref, name too long
	ERROR: errors found in fs roots
	Checking filesystem on /dev/mapper/encroot
	UUID: 1c9bafac-fcf8-41c4-b394-bca5917ca82d
	cache and super generation don't match, space cache will be invalidated
	found 169171566592 bytes used, error(s) found
	total csum bytes: 163303624
	total tree bytes: 1875197952
	total fs tree bytes: 1523220480
	total extent tree bytes: 113016832
	btree space waste bytes: 409319304
	file data blocks allocated: 517520035840
	 referenced 158072827904
		invalid location in dir item ..

Do you know how to fix it?

It's an ssd drive.

$ uname -a
Linux cynerd-laptop 4.11.6 #1 SMP PREEMPT Fri Jun 23 22:01:45 CEST 2017 x86=
_64 Intel(R) Core(TM) i3-7100U CPU @ 2.40GHz GenuineIntel GNU/Linux

$ btrfs --version
btrfs-progs v4.11

# btrfs fi show
Label: none  uuid: 1c9bafac-fcf8-41c4-b394-bca5917ca82d
	Total devices 1 FS bytes used 157.55GiB
	devid    1 size 219.48GiB used 219.48GiB path /dev/mapper/encroot

$ btrfs fi df /
Data, single: total=3D215.47GiB, used=3D155.80GiB
System, single: total=3D4.00MiB, used=3D48.00KiB
Metadata, single: total=3D4.01GiB, used=3D1.75GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

dmesg is attached.

Thank you up front for any response.

Karel Ko=C4=8D=C3=AD

--to23qdmubyw74dqp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.log"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 4.11.6 (portage@cynerd-laptop) (gcc version 5.=
4.0 (Gentoo 5.4.0-r3 p1.3, pie-0.6.5) ) #1 SMP PREEMPT Fri Jun 23 22:01:45 =
CEST 2017
[    0.000000] Command line: BOOT_IMAGE=3D../bzlinux-4.11.6 root=3D/dev/sda=
2 rootflags=3Dsubvol=3D@gentoo initrd=3D../initramfs-gentoo
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
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b8169fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b816a000-0x00000000b816afff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000b816b000-0x00000000b816bfff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000b816c000-0x00000000c9024fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c9025000-0x00000000c9d7efff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000c9d7f000-0x00000000c9f7efff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000c9f7f000-0x00000000c9ffefff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x00000000c9fff000-0x00000000c9ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ca000000-0x00000000ce7fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fe010000-0x00000000fe010fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000001307fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.50 by HP
[    0.000000] efi:  ACPI=3D0xc9ffe000  ACPI 2.0=3D0xc9ffe014  SMBIOS=3D0xc=
97ef000  SMBIOS 3.0=3D0xc97ed000  ESRT=3D0xc6d025d8=20
[    0.000000] SMBIOS 3.0.0 present.
[    0.000000] DMI: HP HP ProBook 440 G4/822E, BIOS P85 Ver. 01.02 08/30/20=
16
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x130800 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   1 base 00D0000000 mask 7FF0000000 uncachable
[    0.000000]   2 base 00CC000000 mask 7FFC000000 uncachable
[    0.000000]   3 base 1C00000000 mask 7C00000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT=
 =20
[    0.000000] e820: last_pfn =3D 0xca000 max_arch_pfn =3D 0x400000000
[    0.000000] esrt: Reserving ESRT space from 0x00000000c6d025d8 to 0x0000=
0000c6d02610.
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x01f96000, 0x01f96fff] PGTABLE
[    0.000000] BRK [0x01f97000, 0x01f97fff] PGTABLE
[    0.000000] BRK [0x01f98000, 0x01f98fff] PGTABLE
[    0.000000] BRK [0x01f99000, 0x01f99fff] PGTABLE
[    0.000000] BRK [0x01f9a000, 0x01f9afff] PGTABLE
[    0.000000] BRK [0x01f9b000, 0x01f9bfff] PGTABLE
[    0.000000] Secure boot could not be determined
[    0.000000] RAMDISK: [mem 0x7f77f000-0x7fffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000C9FFE014 000024 (v02 HPQOEM)
[    0.000000] ACPI: XSDT 0x00000000C9FBE188 0000FC (v01 HPQOEM SLIC-BPC 00=
000000      01000013)
[    0.000000] ACPI: FACP 0x00000000C9FE7000 0000F4 (v05 HPQOEM SLIC-BPC 00=
000000 HP   00000001)
[    0.000000] ACPI: DSDT 0x00000000C9FC6000 01D1E6 (v02 HPQOEM 822E     00=
000000 INTL 20150818)
[    0.000000] ACPI: FACS 0x00000000C9F62000 000040
[    0.000000] ACPI: SSDT 0x00000000C9FFC000 000108 (v02 HP     ShmTable 00=
000001 INTL 20150818)
[    0.000000] ACPI: SSDT 0x00000000C9FF1000 00A7FA (v02 AcpiRe PLT_RTD3 00=
001000 INTL 20150818)
[    0.000000] ACPI: SSDT 0x00000000C9FEF000 0003A8 (v02 HPQOEM Tpm2Tabl 00=
001000 INTL 20150818)
[    0.000000] ACPI: TPM2 0x00000000C9FEE000 000034 (v03 HPQOEM EDK2     00=
000002      01000013)
[    0.000000] ACPI: UEFI 0x00000000C9F71000 000042 (v01 HPQOEM EDK2     00=
000002      01000013)
[    0.000000] ACPI: SSDT 0x00000000C9FEB000 002F93 (v02 SaSsdt SaSsdt   00=
003000 INTL 20150818)
[    0.000000] ACPI: SSDT 0x00000000C9FEA000 0004FD (v02 Intel  PerfTune 00=
001000 INTL 20150818)
[    0.000000] ACPI: MSDM 0x00000000C9FE9000 000055 (v03 HPQOEM SLIC-BPC 00=
000000 HP   00000001)
[    0.000000] ACPI: SLIC 0x00000000C9FE8000 000176 (v01 HPQOEM SLIC-BPC 00=
000001 HP   00000001)
[    0.000000] ACPI: HPET 0x00000000C9FE6000 000038 (v01 HPQOEM 822E     00=
000001 HP   00000001)
[    0.000000] ACPI: APIC 0x00000000C9FE5000 0000BC (v03 HPQOEM 822E     00=
000001 HP   00000001)
[    0.000000] ACPI: MCFG 0x00000000C9FE4000 00003C (v01 HPQOEM 822E     00=
000001 HP   00000001)
[    0.000000] ACPI: SSDT 0x00000000C9FC5000 00019A (v02 HPQOEM Sata0Ide 00=
001000 INTL 20150818)
[    0.000000] ACPI: SSDT 0x00000000C9FC4000 000729 (v01 HPQOEM PtidDevc 00=
001000 INTL 20150818)
[    0.000000] ACPI: SSDT 0x00000000C9FC3000 000E5E (v02 CpuRef CpuSsdt  00=
003000 INTL 20150818)
[    0.000000] ACPI: SSDT 0x00000000C9FC2000 000472 (v02 CtdpB  CtdpB    00=
001000 INTL 20150818)
[    0.000000] ACPI: WSMT 0x00000000C9FC1000 000028 (v01 INTEL  KBL-ULT  00=
000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x00000000C9FC0000 00024B (v02 INTEL  sensrhub 00=
000000 INTL 20150818)
[    0.000000] ACPI: SSDT 0x00000000C9FBF000 0002D2 (v01 INTEL  EInkApp  00=
000000 INTL 20150818)
[    0.000000] ACPI: DBGP 0x00000000C9FFD000 000034 (v01 INTEL           00=
000002 MSFT 0000005F)
[    0.000000] ACPI: DBG2 0x00000000C9FBD000 000054 (v00 INTEL           00=
000002 MSFT 0000005F)
[    0.000000] ACPI: DMAR 0x00000000C9FBC000 0000A8 (v01 INTEL  KBL      00=
000001 INTL 00000001)
[    0.000000] ACPI: NHLT 0x00000000C9FBB000 00002D (v00 INTEL  EDK2     00=
000002      01000013)
[    0.000000] ACPI: FPDT 0x00000000C9FBA000 000044 (v01 HPQOEM EDK2     00=
000002      01000013)
[    0.000000] ACPI: BGRT 0x00000000C9FB9000 000038 (v01 HPQOEM EDK2     00=
000002      01000013)
[    0.000000] ACPI: SSDT 0x00000000C9FF0000 000260 (v02 HP     PwrCtlEv 00=
000001 INTL 20150818)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000001307fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x1307f8000-0x1307fcfff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x00000001307fffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
[    0.000000]   node   0: [mem 0x0000000000059000-0x000000000009dfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000b8169fff]
[    0.000000]   node   0: [mem 0x00000000b816c000-0x00000000c9024fff]
[    0.000000]   node   0: [mem 0x00000000c9fff000-0x00000000c9ffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x00000001307fffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x00000001307ff=
fff]
[    0.000000] On node 0 totalpages: 1021888
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12801 pages used for memmap
[    0.000000]   DMA32 zone: 819236 pages, LIFO batch:31
[    0.000000]   Normal zone: 3104 pages used for memmap
[    0.000000]   Normal zone: 198656 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics memory at 0x00000000cc800000-0x0000=
0000ce7fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xb816a000-0xb816afff]
[    0.000000] PM: Registered nosave memory: [mem 0xb816b000-0xb816bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xc9025000-0xc9d7efff]
[    0.000000] PM: Registered nosave memory: [mem 0xc9d7f000-0xc9f7efff]
[    0.000000] PM: Registered nosave memory: [mem 0xc9f7f000-0xc9ffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xca000000-0xce7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xce800000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfe00ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe010000-0xfe010fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe011000-0xffffffff]
[    0.000000] e820: [mem 0xce800000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 6370452778343963 ns
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] percpu: Embedded 38 pages/cpu @ffff880130400000 s115544 r819=
2 d31912 u524288
[    0.000000] pcpu-alloc: s115544 r8192 d31912 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1005897
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D../bzlinux-4.11.6 root=3D/=
dev/sda2 rootflags=3Dsubvol=3D@gentoo initrd=3D../initramfs-gentoo
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3850064K/4087552K available (8019K kernel code, 1270=
K rwdata, 2428K rodata, 1428K init, 932K bss, 237488K reserved, 0K cma-rese=
rved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D128 to nr_cpu_ids=3D4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D64, nr_cpu_ids=
=3D4
[    0.000000] NR_IRQS:8448 nr_irqs:1024 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, =
max_idle_ns: 79635855245 ns
[    0.000000] hpet clockevent registered
[    0.003333] tsc: Detected 2400.000 MHz processor
[    0.003333] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4801.00 BogoMIPS (lpj=3D8000000)
[    0.003333] pid_max: default: 32768 minimum: 301
[    0.003333] ACPI: Core revision 20170119
[    0.013395] ACPI Warning: Unsupported module-level executable opcode 0x7=
0 at table offset 0xBBDA (20170119/psloop-226)
[    0.038016] ACPI: 13 ACPI AML tables successfully acquired and loaded
[    0.038364] Security Framework initialized
[    0.038366] Yama: becoming mindful.
[    0.038570] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.039600] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.040119] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.040123] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 b=
ytes)
[    0.040339] CPU: Physical Processor ID: 0
[    0.040340] CPU: Processor Core ID: 0
[    0.040344] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.040345] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.040352] mce: CPU supports 8 MCE banks
[    0.040380] CPU0: Thermal monitoring enabled (TM1)
[    0.040396] process: using mwait in idle threads
[    0.040399] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.040399] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.040499] Freeing SMP alternatives memory: 28K
[    0.044486] ftrace: allocating 29665 entries in 116 pages
[    0.053400] smpboot: Max logical packages: 2
[    0.053409] DMAR: Host address width 39
[    0.053411] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.053416] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660=
462 ecap 19e2ff0505e
[    0.053417] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.053422] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008c406604=
62 ecap f050da
[    0.053423] DMAR: RMRR base: 0x000000c9cd6000 end: 0x000000c9cf5fff
[    0.053424] DMAR: RMRR base: 0x000000cc000000 end: 0x000000ce7fffff
[    0.053426] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.053427] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.053428] DMAR-IR: Queued invalidation will be enabled to support x2ap=
ic and Intr-remapping.
[    0.057261] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.057262] x2apic enabled
[    0.057273] Switched APIC routing to cluster x2apic.
[    0.061310] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.094347] TSC deadline timer enabled
[    0.094351] smpboot: CPU0: Intel(R) Core(TM) i3-7100U CPU @ 2.40GHz (fam=
ily: 0x6, model: 0x8e, stepping: 0x9)
[    0.106696] Performance Events: PEBS fmt3+, Skylake events, 32-deep LBR,=
 full-width counters, Intel PMU driver.
[    0.106764] ... version:                4
[    0.106764] ... bit width:              48
[    0.106765] ... generic registers:      4
[    0.106766] ... value mask:             0000ffffffffffff
[    0.106766] ... max period:             00007fffffffffff
[    0.106766] ... fixed-purpose events:   3
[    0.106767] ... event mask:             000000070000000f
[    0.126789] NMI watchdog: enabled on all CPUs, permanently consumes one =
hw-PMU counter.
[    0.133342] smp: Bringing up secondary CPUs ...
[    0.160052] x86: Booting SMP configuration:
[    0.160053] .... node  #0, CPUs:      #1 #2 #3
[    0.463376] smp: Brought up 1 node, 4 CPUs
[    0.463376] smpboot: Total of 4 processors activated (19212.92 BogoMIPS)
[    0.466774] sched_clock: Marking stable (466666620, 0)->(468720745, -205=
4125)
[    0.467014] devtmpfs: initialized
[    0.467056] x86/mm: Memory block size: 128MB
[    0.468779] PM: Registering ACPI NVS region [mem 0xb816a000-0xb816afff] =
(4096 bytes)
[    0.468780] PM: Registering ACPI NVS region [mem 0xc9d7f000-0xc9f7efff] =
(2097152 bytes)
[    0.468852] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 6370867519511994 ns
[    0.468859] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.468914] xor: automatically using best checksumming function   avx   =
   =20
[    0.468920] pinctrl core: initialized pinctrl subsystem
[    0.469024] RTC time:  7:13:17, date: 06/27/17
[    0.469120] NET: Registered protocol family 16
[    0.469269] cpuidle: using governor ladder
[    0.469302] cpuidle: using governor menu
[    0.469304] PCCT header not found.
[    0.469343] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.469344] ACPI: bus type PCI registered
[    0.469345] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.469409] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    0.469434] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.469439] PCI: Using configuration type 1 for base access
[    0.473488] HugeTLB registered 1 GB page size, pre-allocated 0 pages
[    0.473489] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.530044] raid6: sse2x1   gen()  8286 MB/s
[    0.586734] raid6: sse2x1   xor()  6257 MB/s
[    0.643415] raid6: sse2x2   gen() 10148 MB/s
[    0.700102] raid6: sse2x2   xor()  7174 MB/s
[    0.756784] raid6: sse2x4   gen() 10729 MB/s
[    0.813468] raid6: sse2x4   xor()  7853 MB/s
[    0.870153] raid6: avx2x1   gen() 16271 MB/s
[    0.926834] raid6: avx2x1   xor() 12209 MB/s
[    0.983517] raid6: avx2x2   gen() 18233 MB/s
[    1.040200] raid6: avx2x2   xor() 13181 MB/s
[    1.096882] raid6: avx2x4   gen() 19352 MB/s
[    1.153567] raid6: avx2x4   xor() 15202 MB/s
[    1.153568] raid6: using algorithm avx2x4 gen() 19352 MB/s
[    1.153568] raid6: .... xor() 15202 MB/s, rmw enabled
[    1.153569] raid6: using avx2x2 recovery algorithm
[    1.153607] ACPI: Added _OSI(Module Device)
[    1.153608] ACPI: Added _OSI(Processor Device)
[    1.153609] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.153609] ACPI: Added _OSI(Processor Aggregator Device)
[    1.156206] ACPI: Executed 37 blocks of module-level executable AML code
[    1.162755] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    1.167992] ACPI: Dynamic OEM Table Load:
[    1.168040] ACPI: SSDT 0xFFFF88012AA76000 000609 (v02 PmRef  Cpu0Ist  00=
003000 INTL 20150818)
[    1.168257] ACPI: \_PR_.CPU0: _OSC native thermal LVT Acked
[    1.168804] ACPI Error: Field [CAP1] at 96 exceeds Buffer [NULL] size 64=
 (bits) (20170119/dsopcode-236)
[    1.168812] ACPI Error: Method parse/execution failed [\_SB._OSC] (Node =
ffff88012b8e10c8), AE_AML_BUFFER_LIMIT (20170119/psparse-543)
[    1.169167] ACPI: Dynamic OEM Table Load:
[    1.169175] ACPI: SSDT 0xFFFF88012AA2A000 000385 (v02 PmRef  Cpu0Cst  00=
003001 INTL 20150818)
[    1.169695] ACPI: Dynamic OEM Table Load:
[    1.169704] ACPI: SSDT 0xFFFF88012AA70800 0005AA (v02 PmRef  ApIst    00=
003000 INTL 20150818)
[    1.170194] ACPI: Dynamic OEM Table Load:
[    1.170201] ACPI: SSDT 0xFFFF88012AA6DA00 000119 (v02 PmRef  ApCst    00=
003000 INTL 20150818)
[    1.171524] ACPI : EC: EC started
[    1.171524] ACPI : EC: interrupt blocked
[    3.290661] ACPI: \_SB_.PCI0.LPCB.EC0_: Used as first EC
[    3.290663] ACPI: \_SB_.PCI0.LPCB.EC0_: GPE=3D0x6e, EC_CMD/EC_SC=3D0x66,=
 EC_DATA=3D0x62
[    3.290664] ACPI: \_SB_.PCI0.LPCB.EC0_: Used as boot DSDT EC to handle t=
ransactions
[    3.290665] ACPI: Interpreter enabled
[    3.290720] ACPI: (supports S0 S3 S4 S5)
[    3.290720] ACPI: Using IOAPIC for interrupt routing
[    3.290761] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    3.297816] ACPI: Power Resource [WRST] (off)
[    3.298793] ACPI: Power Resource [PXP] (on)
[    3.455581] ACPI: Power Resource [PXPR] (on)
[    3.460545] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    3.460550] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cloc=
kPM Segments MSI]
[    3.462383] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER =
PCIeCapability]
[    3.462384] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using B=
IOS configuration
[    3.464419] PCI host bridge to bus 0000:00
[    3.464421] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    3.464422] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    3.464423] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f window]
[    3.464424] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3ff=
f window]
[    3.464425] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7ff=
f window]
[    3.464426] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbff=
f window]
[    3.464426] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cfff=
f window]
[    3.464427] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3ff=
f window]
[    3.464428] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7ff=
f window]
[    3.464429] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbff=
f window]
[    3.464430] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dfff=
f window]
[    3.464431] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3ff=
f window]
[    3.464432] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7ff=
f window]
[    3.464432] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebff=
f window]
[    3.464433] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000efff=
f window]
[    3.464434] pci_bus 0000:00: root bus resource [mem 0xce800000-0xf7fffff=
f window]
[    3.464435] pci_bus 0000:00: root bus resource [mem 0x1c00000000-0x1ffff=
fffff window]
[    3.464436] pci_bus 0000:00: root bus resource [mem 0xfd000000-0xfe7ffff=
f window]
[    3.464438] pci_bus 0000:00: root bus resource [bus 00-3e]
[    3.464446] pci 0000:00:00.0: [8086:5904] type 00 class 0x060000
[    3.465281] pci 0000:00:02.0: [8086:5916] type 00 class 0x030000
[    3.465291] pci 0000:00:02.0: reg 0x10: [mem 0x1ff0000000-0x1ff0ffffff 6=
4bit]
[    3.465298] pci 0000:00:02.0: reg 0x18: [mem 0x1fe0000000-0x1fefffffff 6=
4bit pref]
[    3.465303] pci 0000:00:02.0: reg 0x20: [io  0x4000-0x403f]
[    3.466203] pci 0000:00:14.0: [8086:9d2f] type 00 class 0x0c0330
[    3.466221] pci 0000:00:14.0: reg 0x10: [mem 0xcec00000-0xcec0ffff 64bit]
[    3.466285] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    3.467162] pci 0000:00:14.0: System wakeup disabled by ACPI
[    3.467196] pci 0000:00:14.2: [8086:9d31] type 00 class 0x118000
[    3.467212] pci 0000:00:14.2: reg 0x10: [mem 0x1ff1016000-0x1ff1016fff 6=
4bit]
[    3.468093] pci 0000:00:16.0: [8086:9d3a] type 00 class 0x078000
[    3.468115] pci 0000:00:16.0: reg 0x10: [mem 0x1ff1015000-0x1ff1015fff 6=
4bit]
[    3.468183] pci 0000:00:16.0: PME# supported from D3hot
[    3.469037] pci 0000:00:17.0: [8086:9d03] type 00 class 0x010601
[    3.469052] pci 0000:00:17.0: reg 0x10: [mem 0xcec14000-0xcec15fff]
[    3.469060] pci 0000:00:17.0: reg 0x14: [mem 0xcec17000-0xcec170ff]
[    3.469068] pci 0000:00:17.0: reg 0x18: [io  0x4080-0x4087]
[    3.469075] pci 0000:00:17.0: reg 0x1c: [io  0x4088-0x408b]
[    3.469083] pci 0000:00:17.0: reg 0x20: [io  0x4060-0x407f]
[    3.469090] pci 0000:00:17.0: reg 0x24: [mem 0xcec16000-0xcec167ff]
[    3.469130] pci 0000:00:17.0: PME# supported from D3hot
[    3.469977] pci 0000:00:1c.0: [8086:9d14] type 01 class 0x060400
[    3.470039] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    3.470881] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    3.470923] pci 0000:00:1c.5: [8086:9d15] type 01 class 0x060400
[    3.470985] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    3.471823] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    3.471856] pci 0000:00:1d.0: [8086:9d18] type 01 class 0x060400
[    3.471917] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    3.472759] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    3.472813] pci 0000:00:1f.0: [8086:9d58] type 00 class 0x060100
[    3.473712] pci 0000:00:1f.2: [8086:9d21] type 00 class 0x058000
[    3.473722] pci 0000:00:1f.2: reg 0x10: [mem 0xcec10000-0xcec13fff]
[    3.474600] pci 0000:00:1f.3: [8086:9d71] type 00 class 0x040380
[    3.474622] pci 0000:00:1f.3: reg 0x10: [mem 0x1ff1010000-0x1ff1013fff 6=
4bit]
[    3.474648] pci 0000:00:1f.3: reg 0x20: [mem 0x1ff1000000-0x1ff100ffff 6=
4bit]
[    3.474696] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    3.475578] pci 0000:00:1f.3: System wakeup disabled by ACPI
[    3.475612] pci 0000:00:1f.4: [8086:9d23] type 00 class 0x0c0500
[    3.475652] pci 0000:00:1f.4: reg 0x10: [mem 0x1ff1014000-0x1ff10140ff 6=
4bit]
[    3.475702] pci 0000:00:1f.4: reg 0x20: [io  0xefa0-0xefbf]
[    3.476640] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    3.476656] pci 0000:01:00.0: reg 0x10: [io  0x3000-0x30ff]
[    3.476678] pci 0000:01:00.0: reg 0x18: [mem 0xceb04000-0xceb04fff 64bit]
[    3.476692] pci 0000:01:00.0: reg 0x20: [mem 0xceb00000-0xceb03fff 64bit]
[    3.476781] pci 0000:01:00.0: supports D1 D2
[    3.476782] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.476832] pci 0000:01:00.0: System wakeup disabled by ACPI
[    3.483980] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    3.483982] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    3.483985] pci 0000:00:1c.0:   bridge window [mem 0xceb00000-0xcebfffff]
[    3.484195] pci 0000:02:00.0: [8086:095a] type 00 class 0x028000
[    3.484273] pci 0000:02:00.0: reg 0x10: [mem 0xcea00000-0xcea01fff 64bit]
[    3.484531] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    3.484738] pci 0000:02:00.0: System wakeup disabled by ACPI
[    3.494143] pci 0000:00:1c.5: PCI bridge to [bus 02]
[    3.494147] pci 0000:00:1c.5:   bridge window [mem 0xcea00000-0xceafffff]
[    3.494205] pci 0000:03:00.0: [10ec:522a] type 00 class 0xff0000
[    3.494221] pci 0000:03:00.0: reg 0x10: [mem 0xce900000-0xce900fff]
[    3.494337] pci 0000:03:00.0: supports D1 D2
[    3.494338] pci 0000:03:00.0: PME# supported from D1 D2 D3hot D3cold
[    3.494383] pci 0000:03:00.0: System wakeup disabled by ACPI
[    3.504012] pci 0000:00:1d.0: PCI bridge to [bus 03]
[    3.504016] pci 0000:00:1d.0:   bridge window [mem 0xce900000-0xce9fffff]
[    3.505587] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    3.505634] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 1=
5)
[    3.505679] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    3.505724] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    3.505769] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    3.505813] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    3.505857] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    3.505902] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    3.506187] ACPI: Enabled 5 GPEs in block 00 to 7F
[    3.506237] ACPI : EC: interrupt unblocked
[    3.506242] ACPI : EC: event unblocked
[    3.506250] ACPI: \_SB_.PCI0.LPCB.EC0_: GPE=3D0x6e, EC_CMD/EC_SC=3D0x66,=
 EC_DATA=3D0x62
[    3.506252] ACPI: \_SB_.PCI0.LPCB.EC0_: Used as boot DSDT EC to handle t=
ransactions and events
[    3.506331] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    3.506332] pci 0000:00:02.0: vgaarb: VGA device added: decodes=3Dio+mem=
,owns=3Dio+mem,locks=3Dnone
[    3.506336] pci 0000:00:02.0: vgaarb: bridge control possible
[    3.506336] vgaarb: loaded
[    3.506401] SCSI subsystem initialized
[    3.506440] libata version 3.00 loaded.
[    3.506443] ACPI: bus type USB registered
[    3.506453] usbcore: registered new interface driver usbfs
[    3.506460] usbcore: registered new interface driver hub
[    3.506478] usbcore: registered new device driver usb
[    3.506502] Registered efivars operations
[    3.532667] PCI: Using ACPI for IRQ routing
[    3.539326] PCI: pci_cache_line_size set to 64 bytes
[    3.539664] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    3.539665] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    3.539666] e820: reserve RAM buffer [mem 0xb816a000-0xbbffffff]
[    3.539667] e820: reserve RAM buffer [mem 0xc9025000-0xcbffffff]
[    3.539668] e820: reserve RAM buffer [mem 0xca000000-0xcbffffff]
[    3.539668] e820: reserve RAM buffer [mem 0x130800000-0x133ffffff]
[    3.539741] NetLabel: Initializing
[    3.539741] NetLabel:  domain hash size =3D 128
[    3.539742] NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
[    3.539754] NetLabel:  unlabeled traffic allowed by default
[    3.539854] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    3.539859] hpet0: 8 comparators, 64-bit 24.000000 MHz counter
[    3.541902] clocksource: Switched to clocksource hpet
[    3.551402] VFS: Disk quotas dquot_6.6.0
[    3.551421] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)
[    3.551481] pnp: PnP ACPI init
[    3.551663] system 00:00: [mem 0xfd000000-0xfdabffff] has been reserved
[    3.551665] system 00:00: [mem 0xfdad0000-0xfdadffff] has been reserved
[    3.551666] system 00:00: [mem 0xfdb00000-0xfdffffff] has been reserved
[    3.551667] system 00:00: [mem 0xfe000000-0xfe01ffff] could not be reser=
ved
[    3.551668] system 00:00: [mem 0xfe03d000-0xfe3fffff] has been reserved
[    3.551671] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.552012] system 00:01: [io  0x2000-0x20fe] has been reserved
[    3.552014] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.552166] system 00:02: [io  0x0680-0x069f] has been reserved
[    3.552167] system 00:02: [io  0xffff] has been reserved
[    3.552169] system 00:02: [io  0xffff] has been reserved
[    3.552170] system 00:02: [io  0xffff] has been reserved
[    3.552171] system 00:02: [io  0x1800-0x18fe] has been reserved
[    3.552172] system 00:02: [io  0x164e-0x164f] has been reserved
[    3.552174] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.552275] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.552307] system 00:04: [io  0x1854-0x1857] has been reserved
[    3.552309] system 00:04: Plug and Play ACPI device, IDs INT3f0d PNP0c02=
 (active)
[    3.552326] pnp 00:05: Plug and Play ACPI device, IDs HPQ8002 PNP0303 (a=
ctive)
[    3.552341] pnp 00:06: Plug and Play ACPI device, IDs SYN3047 SYN0100 SY=
N0002 PNP0f13 (active)
[    3.552392] system 00:07: [io  0x0200-0x023f] has been reserved
[    3.552394] system 00:07: [mem 0xfedf0000-0xfedfffff] has been reserved
[    3.552396] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.553646] system 00:08: [mem 0xfe029000-0xfe029fff] has been reserved
[    3.553647] system 00:08: [mem 0xfe028000-0xfe028fff] has been reserved
[    3.553648] system 00:08: [mem 0xfdaf0000-0xfdafffff] has been reserved
[    3.553649] system 00:08: [mem 0xfdae0000-0xfdaeffff] has been reserved
[    3.553651] system 00:08: [mem 0xfdac0000-0xfdacffff] has been reserved
[    3.553652] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.554183] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
[    3.554184] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    3.554185] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    3.554186] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
[    3.554187] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    3.554188] system 00:09: [mem 0xfed90000-0xfed93fff] could not be reser=
ved
[    3.554190] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    3.554192] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[    3.554193] system 00:09: [mem 0xfee00000-0xfeefffff] has been reserved
[    3.554194] system 00:09: [mem 0xce800000-0xce81ffff] has been reserved
[    3.554196] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.554533] pnp: PnP ACPI: found 10 devices
[    3.562013] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, m=
ax_idle_ns: 2085701024 ns
[    3.562034] pci 0000:00:1d.0: bridge window [io  0x1000-0x0fff] to [bus =
03] add_size 1000
[    3.562036] pci 0000:00:1d.0: bridge window [mem 0x00100000-0x000fffff 6=
4bit pref] to [bus 03] add_size 200000 add_align 100000
[    3.562046] pci 0000:00:1d.0: BAR 15: assigned [mem 0x1c00000000-0x1c001=
fffff 64bit pref]
[    3.562048] pci 0000:00:1d.0: BAR 13: assigned [io  0x5000-0x5fff]
[    3.562050] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    3.562052] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    3.562055] pci 0000:00:1c.0:   bridge window [mem 0xceb00000-0xcebfffff]
[    3.562061] pci 0000:00:1c.5: PCI bridge to [bus 02]
[    3.562064] pci 0000:00:1c.5:   bridge window [mem 0xcea00000-0xceafffff]
[    3.562070] pci 0000:00:1d.0: PCI bridge to [bus 03]
[    3.562072] pci 0000:00:1d.0:   bridge window [io  0x5000-0x5fff]
[    3.562075] pci 0000:00:1d.0:   bridge window [mem 0xce900000-0xce9fffff]
[    3.562077] pci 0000:00:1d.0:   bridge window [mem 0x1c00000000-0x1c001f=
ffff 64bit pref]
[    3.562082] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    3.562083] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    3.562084] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff windo=
w]
[    3.562085] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff windo=
w]
[    3.562086] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff windo=
w]
[    3.562087] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff windo=
w]
[    3.562088] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff wind=
ow]
[    3.562089] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff wind=
ow]
[    3.562090] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff wind=
ow]
[    3.562091] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff wind=
ow]
[    3.562092] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff wind=
ow]
[    3.562093] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff wind=
ow]
[    3.562094] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff wind=
ow]
[    3.562094] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff wind=
ow]
[    3.562095] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff wind=
ow]
[    3.562096] pci_bus 0000:00: resource 19 [mem 0xce800000-0xf7ffffff wind=
ow]
[    3.562097] pci_bus 0000:00: resource 20 [mem 0x1c00000000-0x1fffffffff =
window]
[    3.562098] pci_bus 0000:00: resource 21 [mem 0xfd000000-0xfe7fffff wind=
ow]
[    3.562099] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    3.562100] pci_bus 0000:01: resource 1 [mem 0xceb00000-0xcebfffff]
[    3.562101] pci_bus 0000:02: resource 1 [mem 0xcea00000-0xceafffff]
[    3.562102] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    3.562103] pci_bus 0000:03: resource 1 [mem 0xce900000-0xce9fffff]
[    3.562104] pci_bus 0000:03: resource 2 [mem 0x1c00000000-0x1c001fffff 6=
4bit pref]
[    3.562228] NET: Registered protocol family 2
[    3.562370] TCP established hash table entries: 32768 (order: 6, 262144 =
bytes)
[    3.562434] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    3.562533] TCP: Hash tables configured (established 32768 bind 32768)
[    3.562558] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    3.562575] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    3.562618] NET: Registered protocol family 1
[    3.562630] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x0=
00c0000-0x000dffff]
[    3.563062] PCI: CLS 0 bytes, default 64
[    3.563099] Unpacking initramfs...
[    3.706849] Freeing initrd memory: 8708K
[    3.706888] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.706891] software IO TLB [mem 0xc21e9000-0xc61e9000] (64MB) mapped at=
 [ffff8800c21e9000-ffff8800c61e8fff]
[    3.707058] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x229=
83777dd9, max_idle_ns: 440795300422 ns
[    3.707187] Scanning for low memory corruption every 60 seconds
[    3.708499] Initialise system trusted keyrings
[    3.708546] workingset: timestamp_bits=3D40 max_order=3D20 bucket_order=
=3D0
[    3.709497] zbud: loaded
[    3.710713] NET: Registered protocol family 38
[    3.710715] Key type asymmetric registered
[    3.710724] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    3.710767] io scheduler noop registered
[    3.710768] io scheduler deadline registered
[    3.710788] io scheduler cfq registered (default)
[    3.710789] io scheduler mq-deadline registered
[    3.711581] pcieport 0000:00:1c.0: AER enabled with IRQ 122
[    3.711606] pcieport 0000:00:1c.5: AER enabled with IRQ 123
[    3.711630] pcieport 0000:00:1d.0: AER enabled with IRQ 124
[    3.711640] pcieport 0000:00:1c.0: Signaling PME with IRQ 122
[    3.711648] pcieport 0000:00:1c.5: Signaling PME with IRQ 123
[    3.711657] pcieport 0000:00:1d.0: Signaling PME with IRQ 124
[    3.711670] pciehp 0000:00:1d.0:pcie004: Slot #8 AttnBtn- PwrCtrl- MRL- =
AttnInd- PwrInd- HotPlug+ Surprise+ Interlock- NoCompl+ LLActRep+
[    3.711704] efifb: probing for efifb
[    3.711716] efifb: framebuffer at 0x1fe0000000, using 8100k, total 8100k
[    3.711717] efifb: mode is 1920x1080x32, linelength=3D7680, pages=3D1
[    3.711717] efifb: scrolling: redraw
[    3.711718] efifb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    3.715870] Console: switching to colour frame buffer device 240x67
[    3.719866] fb0: EFI VGA frame buffer device
[    3.719872] intel_idle: MWAIT substates: 0x11142120
[    3.719873] intel_idle: v0.4.1 model 0x8E
[    3.720077] intel_idle: lapic_timer_reliable_states 0xffffffff
[    3.720270] GHES: HEST is not enabled!
[    3.720338] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.720801] Linux agpgart interface v0.103
[    3.721077] ahci 0000:00:17.0: version 3.0
[    3.721251] ahci 0000:00:17.0: AHCI 0001.0301 32 slots 3 ports 6 Gbps 0x=
7 impl SATA mode
[    3.721253] ahci 0000:00:17.0: flags: 64bit ncq pm led clo only pio slum=
 part deso sadm sds apst=20
[    3.721799] scsi host0: ahci
[    3.722015] scsi host1: ahci
[    3.722221] scsi host2: ahci
[    3.722260] ata1: SATA max UDMA/133 abar m2048@0xcec16000 port 0xcec1610=
0 irq 125
[    3.722262] ata2: SATA max UDMA/133 abar m2048@0xcec16000 port 0xcec1618=
0 irq 125
[    3.722263] ata3: SATA max UDMA/133 abar m2048@0xcec16000 port 0xcec1620=
0 irq 125
[    3.722289] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.722293] ehci-pci: EHCI PCI platform driver
[    3.722448] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.722453] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus =
number 1
[    3.723552] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x1=
00 quirks 0x00109810
[    3.723557] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    3.723780] hub 1-0:1.0: USB hub found
[    3.723794] hub 1-0:1.0: 12 ports detected
[    3.730693] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.730696] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus =
number 2
[    3.730877] hub 2-0:1.0: USB hub found
[    3.730886] hub 2-0:1.0: 6 ports detected
[    3.732725] usb: port power management may be unreliable
[    3.734645] usbcore: registered new interface driver usb-storage
[    3.734679] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0=
x60,0x64 irq 1,12
[    3.736210] i8042: Detected active multiplexing controller, rev 1.1
[    3.736455] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.736478] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    3.736494] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    3.736510] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    3.736526] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    3.736585] rtc_cmos 00:03: RTC can wake from S4
[    3.737013] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.737095] rtc_cmos 00:03: alarms up to one month, y3k, 242 bytes nvram=
, hpet irqs
[    3.737129] device-mapper: uevent: version 1.0.3
[    3.737231] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised:=
 dm-devel@redhat.com
[    3.737232] intel_pstate: Intel P-state driver initializing
[    3.737653] intel_pstate: HWP enabled
[    3.737771] ledtrig-cpu: registered to indicate activity on CPUs
[    3.737791] hidraw: raw HID events driver (C) Jiri Kosina
[    3.737807] usbcore: registered new interface driver usbhid
[    3.737808] usbhid: USB HID core driver
[    3.737822] intel_pmc_core 0000:00:1f.2: enabling device (0000 -> 0002)
[    3.737998] NET: Registered protocol family 10
[    3.739121] Segment Routing with IPv6
[    3.739135] NET: Registered protocol family 17
[    3.739400] microcode: sig=3D0x806e9, pf=3D0x80, revision=3D0x34
[    3.739467] microcode: Microcode Update Driver: v2.2.
[    3.739595] registered taskstats version 1
[    3.739601] Loading compiled-in X.509 certificates
[    3.739612] zswap: loaded using pool lzo/zbud
[    3.740089] Btrfs loaded, crc32c=3Dcrc32c-generic
[    3.741068]   Magic number: 5:936:218
[    3.741110] acpi device:69: hash matches
[    3.741116] acpi device:3c: hash matches
[    3.741263] rtc_cmos 00:03: setting system clock to 2017-06-27 07:13:20 =
UTC (1498547600)
[    3.741294] PM: Hibernation image not present or could not be loaded.
[    3.762921] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    4.034174] ata2: SATA link down (SStatus 4 SControl 300)
[    4.034247] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    4.034291] ata1: SATA link down (SStatus 4 SControl 300)
[    4.034749] ata3.00: ACPI cmd f5/00:00:00:00:00:e0 (SECURITY FREEZE LOCK=
) filtered out
[    4.034756] ata3.00: ACPI cmd b1/c1:00:00:00:00:e0 (DEVICE CONFIGURATION=
 OVERLAY) filtered out
[    4.034834] ata3.00: ATA-9: SanDisk SD8SNAT-256G-1006, Z2311006, max UDM=
A/100
[    4.034839] ata3.00: 500118192 sectors, multi 1: LBA48 NCQ (depth 31/32)=
, AA
[    4.037003] ata3.00: ACPI cmd f5/00:00:00:00:00:e0 (SECURITY FREEZE LOCK=
) filtered out
[    4.037011] ata3.00: ACPI cmd b1/c1:00:00:00:00:e0 (DEVICE CONFIGURATION=
 OVERLAY) filtered out
[    4.038087] ata3.00: configured for UDMA/100
[    4.039081] scsi 2:0:0:0: Direct-Access     ATA      SanDisk SD8SNAT- 10=
06 PQ: 0 ANSI: 5
[    4.041005] sd 2:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB=
/238 GiB)
[    4.041011] sd 2:0:0:0: [sda] 4096-byte physical blocks
[    4.041149] sd 2:0:0:0: [sda] Write Protect is off
[    4.041156] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.041414] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.045578]  sda: sda1 sda2 sda5 sda6
[    4.047158] sd 2:0:0:0: [sda] Attached SCSI disk
[    4.050865] Freeing unused kernel memory: 1428K
[    4.050874] Write protecting the kernel read-only data: 12288k
[    4.051442] Freeing unused kernel memory: 156K
[    4.062299] Freeing unused kernel memory: 1668K
[    4.105453] usb 1-6: new high-speed USB device number 2 using xhci_hcd
[    4.512176] usb 1-7: new full-speed USB device number 3 using xhci_hcd
[    4.722588] clocksource: Switched to clocksource tsc
[    9.681294] BTRFS: device fsid 1c9bafac-fcf8-41c4-b394-bca5917ca82d devi=
d 1 transid 142168 /dev/mapper/encroot
[    9.681696] BTRFS info (device dm-0): disk space caching is enabled
[    9.681697] BTRFS info (device dm-0): has skinny extents
[    9.774212] random: fast init done
[    9.784641] BTRFS info (device dm-0): detected SSD devices, enabling SSD=
 mode
[    9.958720] BTRFS warning (device dm-0): block group 20971520 has wrong =
amount of free space
[    9.958721] BTRFS warning (device dm-0): failed to load free space cache=
 for block group 20971520, rebuilding it now
[   11.033557] udevd[651]: starting version 3.1.5
[   11.166466] (NULL device *): hwmon_device_register() is deprecated. Plea=
se convert the driver to use hwmon_device_register_with_info().
[   11.170554] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   11.176415] mei_me 0000:00:16.0: enabling device (0000 -> 0002)
[   11.189357] hp_accel: laptop model unknown, using default axes configura=
tion
[   11.191120] i801_smbus 0000:00:1f.4: enabling device (0000 -> 0003)
[   11.191290] i801_smbus 0000:00:1f.4: SPD Write Disable is set
[   11.191327] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[   11.208721] tpm_tis MSFT0101:00: 2.0 TPM (device-id 0x1B, rev-id 16)
[   11.208963] Initializing HPQ6001 module
[   11.221594] snd_hda_intel 0000:00:1f.3: enabling device (0000 -> 0002)
[   11.310799] lis3lv02d: 8 bits 3DC sensor found
[   11.565800] ACPI: AC Adapter [AC] (on-line)
[   11.565869] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0E:00/input/input5
[   11.566859] ACPI: Sleep Button [SLPB]
[   11.566961] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0=
D:00/input/input6
[   11.567700] ACPI: Lid Switch [LID]
[   11.567799] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input7
[   11.567970] ACPI: Power Button [PWRF]
[   11.568433] input: HP Wireless hotkeys as /devices/virtual/input/input8
[   11.623741] [drm] Memory usable by graphics device =3D 4096M
[   11.623745] checking generic (1fe0000000 7e9000) vs hw (1fe0000000 10000=
000)
[   11.623747] fb: switching to inteldrmfb from EFI VGA
[   11.623812] Console: switching to colour dummy device 80x25
[   11.624057] [drm] Replacing VGA console driver
[   11.628675] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   11.628677] [drm] Driver supports precise vblank timestamp query.
[   11.633764] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[   11.635224] [drm] Finished loading DMC firmware i915/kbl_dmc_ver1_01.bin=
 (v1.1)
[   11.642760] [drm] GuC firmware load skipped
[   11.643293] [drm] Initialized i915 1.6.0 20170123 for 0000:00:02.0 on mi=
nor 0
[   11.659468] Bluetooth: Core ver 2.22
[   11.659483] NET: Registered protocol family 31
[   11.659483] Bluetooth: HCI device and connection manager initialized
[   11.659488] Bluetooth: HCI socket layer initialized
[   11.659490] Bluetooth: L2CAP socket layer initialized
[   11.659495] Bluetooth: SCO socket layer initialized
[   11.665772] Bluetooth: HCI UART driver ver 2.3
[   11.665774] Bluetooth: HCI UART protocol H4 registered
[   11.665775] Bluetooth: HCI UART protocol BCSP registered
[   11.665775] Bluetooth: HCI UART protocol LL registered
[   11.665776] Bluetooth: HCI UART protocol ATH3K registered
[   11.665776] Bluetooth: HCI UART protocol Three-wire (H5) registered
[   11.665801] Bluetooth: HCI UART protocol Intel registered
[   11.665809] Bluetooth: HCI UART protocol Broadcom registered
[   11.665809] Bluetooth: HCI UART protocol QCA registered
[   11.665810] Bluetooth: HCI UART protocol AG6XX registered
[   11.665810] Bluetooth: HCI UART protocol Marvell registered
[   11.671368] media: Linux media interface: v0.10
[   11.692049] Linux video capture interface: v2.00
[   11.698581] usbcore: registered new interface driver btusb
[   11.700041] uvcvideo: Found UVC 1.00 device HP HD Camera (05c8:03a0)
[   11.705197] uvcvideo 1-6:1.0: Entity type for entity Extension 4 was not=
 initialized!
[   11.705200] uvcvideo 1-6:1.0: Entity type for entity Processing 2 was no=
t initialized!
[   11.705202] uvcvideo 1-6:1.0: Entity type for entity Camera 1 was not in=
itialized!
[   11.705285] input: HP HD Camera as /devices/pci0000:00/0000:00:14.0/usb1=
/1-6/1-6:1.0/input/input9
[   11.705332] usbcore: registered new interface driver uvcvideo
[   11.705332] USB Video Class driver (1.1.1)
[   11.711158] Bluetooth: hci0: read Intel version: 370810225019140f00
[   11.712777] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw=
-37.8.10-fw-22.50.19.14.f.bseq
[   11.724634] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   11.724644] r8169 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM=
 control
[   11.724650] r8169 0000:01:00.0: enabling device (0000 -> 0003)
[   11.732983] r8169 0000:01:00.0 eth0: RTL8168h/8111h at 0xffffc900006dd00=
0, 98:e7:f4:5d:7b:09, XID 14100800 IRQ 129
[   11.732984] r8169 0000:01:00.0 eth0: jumbo features [frames: 9200 bytes,=
 tx checksumming: ko]
[   11.763409] Intel(R) Wireless WiFi driver for Linux
[   11.763411] Copyright(c) 2003- 2015 Intel Corporation
[   11.763642] iwlwifi 0000:02:00.0: enabling device (0000 -> 0002)
[   11.765177] iwlwifi 0000:02:00.0: Direct firmware load for iwlwifi-7265D=
-28.ucode failed with error -2
[   11.776998] iwlwifi 0000:02:00.0: capa flags index 3 larger than support=
ed by driver
[   11.777478] iwlwifi 0000:02:00.0: loaded firmware version 27.455470.0 op=
_mode iwlmvm
[   11.785249] rtsx_pci 0000:03:00.0: enabling device (0000 -> 0002)
[   11.785433] rtsx_pci 0000:03:00.0: rtsx_pci_acquire_irq: pcr->msi_en =3D=
 1, pci->irq =3D 131
[   11.803366] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band Wireless A=
C 7265, REV=3D0x210
[   11.805427] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
[   11.805884] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
[   11.837865] ACPI: Battery Slot [BAT0] (battery present)
[   11.839636] wmi: Mapper loaded
[   11.843451] input: PC Speaker as /devices/platform/pcspkr/input/input10
[   11.864328] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 655360=
 ms ovfl timer
[   11.864329] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[   11.864330] RAPL PMU: hw unit of domain package 2^-14 Joules
[   11.864331] RAPL PMU: hw unit of domain dram 2^-14 Joules
[   11.864332] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[   11.864332] RAPL PMU: hw unit of domain psys 2^-14 Joules
[   11.874615] AVX2 version of gcm_enc/dec engaged.
[   11.874616] AES CTR mode by8 optimization enabled
[   11.880653] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[   11.880938] (NULL device *): hwmon_device_register() is deprecated. Plea=
se convert the driver to use hwmon_device_register_with_info().
[   11.880957] thermal thermal_zone1: failed to read out thermal zone (-5)
[   11.924146] intel_rapl: Found RAPL domain package
[   11.924148] intel_rapl: Found RAPL domain core
[   11.924149] intel_rapl: Found RAPL domain uncore
[   11.924150] intel_rapl: Found RAPL domain dram
[   11.944156] Bluetooth: hci0: Intel Bluetooth firmware patch completed an=
d activated
[   11.965582] (NULL device *): hwmon_device_register() is deprecated. Plea=
se convert the driver to use hwmon_device_register_with_info().
[   11.992997] iTCO_vendor_support: vendor-support=3D0
[   11.994328] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   11.994458] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by=
 hardware/BIOS
[   12.027710] r8169 0000:01:00.0 enp1s0: renamed from eth0
[   12.050631] iwlwifi 0000:02:00.0 wlp2s0: renamed from wlan0
[   12.054755] ACPI Error: Needed [Buffer/String/Package], found [Integer] =
ffff880120f93708 (20170119/exresop-593)
[   12.054759] ACPI Exception: AE_AML_OPERAND_TYPE, While resolving operand=
s for [OpcodeName unavailable] (20170119/dswexec-461)
[   12.054762] ACPI Error: Method parse/execution failed [\_SB.WMIV.WVPO] (=
Node ffff88012b8a0370), AE_AML_OPERAND_TYPE (20170119/psparse-543)
[   12.054768] ACPI Error: Method parse/execution failed [\_SB.WMIV.WMPV] (=
Node ffff88012b8a0410), AE_AML_OPERAND_TYPE (20170119/psparse-543)
[   12.054785] random: crng init done
[   12.055741] ACPI Error: Needed [Buffer/String/Package], found [Integer] =
ffff88011d18a3f0 (20170119/exresop-593)
[   12.055752] ACPI Exception: AE_AML_OPERAND_TYPE, While resolving operand=
s for [OpcodeName unavailable] (20170119/dswexec-461)
[   12.055757] ACPI Error: Method parse/execution failed [\_SB.WMIV.WVPO] (=
Node ffff88012b8a0370), AE_AML_OPERAND_TYPE (20170119/psparse-543)
[   12.055764] ACPI Error: Method parse/execution failed [\_SB.WMIV.WMPV] (=
Node ffff88012b8a0410), AE_AML_OPERAND_TYPE (20170119/psparse-543)
[   12.056530] ACPI Error: Needed [Buffer/String/Package], found [Integer] =
ffff88011d18ab88 (20170119/exresop-593)
[   12.056533] ACPI Exception: AE_AML_OPERAND_TYPE, While resolving operand=
s for [OpcodeName unavailable] (20170119/dswexec-461)
[   12.056536] ACPI Error: Method parse/execution failed [\_SB.WMIV.WVPO] (=
Node ffff88012b8a0370), AE_AML_OPERAND_TYPE (20170119/psparse-543)
[   12.056542] ACPI Error: Method parse/execution failed [\_SB.WMIV.WMPV] (=
Node ffff88012b8a0410), AE_AML_OPERAND_TYPE (20170119/psparse-543)
[   12.056604] input: HP WMI hotkeys as /devices/virtual/input/input14
[   12.059513] ACPI Error: Attempt to CreateField of length zero (20170119/=
dsopcode-168)
[   12.059519] ACPI Error: Method parse/execution failed [\_SB.WMIV.WVPI] (=
Node ffff88012b8a0988), AE_AML_OPERAND_VALUE (20170119/psparse-543)
[   12.059530] ACPI Error: Method parse/execution failed [\_SB.WMIV.WMPV] (=
Node ffff88012b8a0410), AE_AML_OPERAND_VALUE (20170119/psparse-543)
[   12.095469] thermal LNXTHERM:00: registered as thermal_zone3
[   12.095471] ACPI: Thermal Zone [CPUZ] (38 C)
[   12.392018] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   12.392020] Bluetooth: BNEP filters: protocol multicast
[   12.392024] Bluetooth: BNEP socket layer initialized
[   12.415491] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
[   12.415940] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
[   12.482283] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
[   12.482857] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
[   12.509491] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[   12.574791] psmouse serio3: synaptics: queried max coordinates: x [..565=
4], y [..4702]
[   12.603991] psmouse serio3: synaptics: queried min coordinates: x [1288.=
=2E], y [1150..]
[   12.645056] thermal LNXTHERM:01: registered as thermal_zone4
[   12.645060] ACPI: Thermal Zone [GFXZ] (0 C)
[   12.657291] psmouse serio3: synaptics: Touchpad model: 1, fw: 8.2, id: 0=
x1e2b1, caps: 0xf00123/0x840300/0x12e800/0x0, board id: 3245, fw id: 2368862
[   12.672048] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3=
lv02d/input/input15
[   12.676784] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: n=
o)
[   12.677562] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08=
:00/LNXVIDEO:00/input/input16
[   12.681414] thermal LNXTHERM:02: registered as thermal_zone5
[   12.681416] ACPI: Thermal Zone [EXTZ] (25 C)
[   12.690668] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio3/input/input13
[   12.728060] r8169 0000:01:00.0 enp1s0: link down
[   12.728145] IPv6: ADDRCONF(NETDEV_UP): enp1s0: link is not ready
[   13.044378] thermal LNXTHERM:03: registered as thermal_zone6
[   13.044385] ACPI: Thermal Zone [LOCZ] (24 C)
[   13.397376] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops i915_aud=
io_component_bind_ops [i915])
[   13.397445] mousedev: PS/2 mouse device common for all mice
[   13.403430] thermal LNXTHERM:04: registered as thermal_zone7
[   13.403437] ACPI: Thermal Zone [BATZ] (22 C)
[   13.404677] thermal LNXTHERM:05: registered as thermal_zone8
[   13.404681] ACPI: Thermal Zone [PCHZ] (0 C)
[   13.416877] fbcon: inteldrmfb (fb0) is primary device
[   13.495858] [drm] RC6 on
[   14.754666] Console: switching to colour frame buffer device 240x67
[   14.784728] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   14.833791] snd_hda_codec_conexant hdaudioC0D0: CX8200: BIOS auto-probin=
g.
[   14.834309] snd_hda_codec_conexant hdaudioC0D0: autoconfig for CX8200: l=
ine_outs=3D1 (0x17/0x0/0x0/0x0/0x0) type:speaker
[   14.834310] snd_hda_codec_conexant hdaudioC0D0:    speaker_outs=3D0 (0x0=
/0x0/0x0/0x0/0x0)
[   14.834311] snd_hda_codec_conexant hdaudioC0D0:    hp_outs=3D1 (0x16/0x0=
/0x0/0x0/0x0)
[   14.834312] snd_hda_codec_conexant hdaudioC0D0:    mono: mono_out=3D0x0
[   14.834313] snd_hda_codec_conexant hdaudioC0D0:    inputs:
[   14.834314] snd_hda_codec_conexant hdaudioC0D0:      Internal Mic=3D0x1a
[   14.834315] snd_hda_codec_conexant hdaudioC0D0:      Mic=3D0x19
[   14.835276] snd_hda_codec_conexant hdaudioC0D0: Enable sync_write for st=
able communication
[   14.848448] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1f.=
3/sound/card0/input18
[   14.849288] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1f.3=
/sound/card0/input19
[   14.849349] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:0=
0:1f.3/sound/card0/input20
[   14.849410] input: HDA Intel PCH HDMI/DP,pcm=3D3 as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input21
[   14.849468] input: HDA Intel PCH HDMI/DP,pcm=3D7 as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input22
[   14.849510] input: HDA Intel PCH HDMI/DP,pcm=3D8 as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input23
[   14.849558] input: HDA Intel PCH HDMI/DP,pcm=3D9 as /devices/pci0000:00/=
0000:00:1f.3/sound/card0/input24
[   14.849594] input: HDA Intel PCH HDMI/DP,pcm=3D10 as /devices/pci0000:00=
/0000:00:1f.3/sound/card0/input25
[   16.075624] wlp2s0: authenticate with ac:a3:1e:13:3c:c0
[   16.084050] wlp2s0: send auth to ac:a3:1e:13:3c:c0 (try 1/3)
[   16.087572] wlp2s0: authenticated
[   16.088683] wlp2s0: associate with ac:a3:1e:13:3c:c0 (try 1/3)
[   16.092274] wlp2s0: RX AssocResp from ac:a3:1e:13:3c:c0 (capab=3D0x431 s=
tatus=3D0 aid=3D4)
[   16.094615] wlp2s0: associated
[   16.094642] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
[   24.674934] wlp2s0: deauthenticated from ac:a3:1e:13:3c:c0 (Reason: 3=3D=
DEAUTH_LEAVING)
[   24.731931] iwlwifi 0000:02:00.0: Failed to find station
[   24.731934] wlp2s0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from har=
dware (-22)
[   25.202920] wlp2s0: authenticate with ac:a3:1e:13:49:80
[   25.209952] wlp2s0: send auth to ac:a3:1e:13:49:80 (try 1/3)
[   25.315518] wlp2s0: send auth to ac:a3:1e:13:49:80 (try 2/3)
[   25.420755] wlp2s0: send auth to ac:a3:1e:13:49:80 (try 3/3)
[   25.525494] wlp2s0: authentication with ac:a3:1e:13:49:80 timed out
[   25.914233] wlp2s0: authenticate with ac:a3:1e:13:3c:d0
[   25.921553] wlp2s0: send auth to ac:a3:1e:13:3c:d0 (try 1/3)
[   25.923556] wlp2s0: authenticated
[   25.925363] wlp2s0: associate with ac:a3:1e:13:3c:d0 (try 1/3)
[   25.926435] wlp2s0: RX AssocResp from ac:a3:1e:13:3c:d0 (capab=3D0x11 st=
atus=3D0 aid=3D2)
[   25.929500] wlp2s0: associated
[   25.956181] wlp2s0: Limiting TX power to 23 (23 - 0) dBm as advertised b=
y ac:a3:1e:13:3c:d0
[   39.013914] tun: Universal TUN/TAP device driver, 1.6

--to23qdmubyw74dqp--

--embmhhw7cail5vnj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEERtcVoO0ODEM8v1lj2DvXMqwr2CgFAllSDP4ACgkQ2DvXMqwr
2CgMpQ/+PR6AhZANV8/xlTPzn6Y+XcBNEn+ljJu9Pn379PfXPAJ464rV6JoLwkWc
/9KRWPoi95bkZYhLPz+N3O8cH+H9GD1tOWk6pvh5yGo0jlqGf9/CXzEg1E7yuSvV
2o9Eql31ZoLq3aLRo1zD2JTpz/VbTM1XxMvkpnQEIpobmTwzSgx7IZsto3sgXnpS
grl9rrPyA2mdjZWm3X3s3uaq/49bi5+3Ian8lxWl/oimvmd99LACjhzq3QtD53jr
7jkPuGsGNbwOjaCNuvwMDwEXfBvhQrGbCtGls8zp7qQBJJWmjN/kjMN2dU+Z2+JI
p9WHJ+F9RIBX0kE0+lM+w5+CRyt6mGJ9mxvQiysiqB3BxF8TwiH7d3TdWtf+juW8
/1dxEf5srQpK1yqYaKP41LLAu6DfmXnARgge6MR/wdOqW3RZ8pTKSjy0TiyrwUoe
Zb6+Z9nvJ+rch2Em4WvmzUwh8X/r2RFnaPZhRiZ/HKwq1Lu+5p/EnmSFPDZD+RP4
ORsBtQyh4y6HcP8wqEDmHkM45158crFQyMn+qTONdg/CI/wTmsuGGFB/nAeyNwY4
qLHlDklkkW6fs09VPLwrcnsVeHup7DW4rAvLi1DUgLbNwGL1Bm1K/eUJmAN50JOH
qkYKal9C/mJ38E6T8m1MbekCWINmwZD5ALEc4B03Xauo79LV1Co=
=r96F
-----END PGP SIGNATURE-----

--embmhhw7cail5vnj--
