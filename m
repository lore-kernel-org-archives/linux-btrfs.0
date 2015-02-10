Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scc-mailout-kit-01-web.scc.kit.edu ([129.13.231.93]:53600 "EHLO
	scc-mailout-kit-01-web.scc.kit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754029AbbBJJZj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 04:25:39 -0500
Received: from kit-msx-03.kit.edu ([172.21.117.13])
	by scc-mailout-kit-01.scc.kit.edu with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:128)
	(envelope-from <philipp.leufke@kit.edu>)
	id 1YL6li-00049F-Um
	for linux-btrfs@vger.kernel.org; Tue, 10 Feb 2015 10:06:12 +0100
Message-ID: <54D9C9FC.4080405@kit.edu>
Date: Tue, 10 Feb 2015 10:06:04 +0100
From: "Leufke, Philipp M. (INT)" <leufke@kit.edu>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: undeletable, lost and empty files
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha1; boundary="------------ms010200060709050205040603"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------ms010200060709050205040603
Content-Type: multipart/mixed;
 boundary="------------070606070200080809030106"

This is a multi-part message in MIME format.
--------------070606070200080809030106
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Good morning,

these days I am encountering severe problems with at least two btrfs=20
subvolumes of a raid1 volume.
The problems started after a regular dist-upgrade on a machine running=20
Ubuntu 14.04 with kernel 3.16.7-031607-generic.

As maybe the following issue with Virtualbox (VB) is related, either as=20
cause or result of the underlying problems, I would like to mention,=20
that the issues first appeared when after the reboot (right after the=20
upgrade) I tried to start a VB virtual machine, which led to a complete=20
system freeze (no ssh, no text terminal, only magic sysrequest helped).
After rebooting the xml configuration file (and its backup) of the VM=20
that I tried to start before were empty (0 bytes).

During further attempts to fix the VB issues (i.e. recompiling its=20
kernel modules=E2=80=A6), the system freeze was reproducible and either l=
ed to 0=20
bytes or vanished xml config files of the VMs that were tested.

Now the file system is in a rather unstable state, where for at least=20
two subvolumes I am encountering btrfs_unlink_inode and btrfs_rename=20
errors stating "no such entry" when trying to delete some files, causing =

the subvolumes to be remounted read-only. I did not yet investigate, if=20
this is only true for a few or for all of the files in these subvols.

This situation is of course very undesirable and I hope you could help me=

* trying to fix the issues
* figuring out what went wrong
* and reveal the underlying bugs that I will then file in bugzilla.


In order to solve the problem, I ran btrfs scrub twice on the whole=20
btrfs volume, yielding 0 errors each time. The last btrfs balance on the =

whole fs was maybe 1 month ago.
Currently, as the defect volume is not the root partition, my=20
desperation led me to upgrading to Ubuntu 14.10, hoping that the more=20
recent kernel and btrfs utils may help in any way. We'll see=E2=80=A6


Below, you can find all sorts of hopefully valuable information about my =

setup:


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

uname -a:
Linux myhost 3.16.7-031607-generic #201410301735 SMP Thu Oct 30 17:37:43 =

UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

btrfs --version:
Btrfs v3.14.1

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

btrfs fi show:
Label: none  uuid: bc2aa9ef-d70b-4cab-8099-422f617ddaa4
     Total devices 2 FS bytes used 2.01TiB
     devid    1 size 3.63TiB used 2.02TiB path /dev/sdc1
     devid    2 size 3.63TiB used 2.02TiB path /dev/sdd1

Btrfs v3.14.1

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

btrfs fi df /data/btrfs_root/:
Data, RAID1: total=3D2.02TiB, used=3D2.00TiB
System, RAID1: total=3D32.00MiB, used=3D320.00KiB
Metadata, RAID1: total=3D6.00GiB, used=3D4.14GiB
unknown, single: total=3D512.00MiB, used=3D0.00

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Please find the dmesg.log attached.

Best regards,
-- pml

--=20
Karlsruher Institut f=C3=BCr Technologie (KIT)
Institut f=C3=BCr Nanotechnologie

Dr. Philipp M. Leufke
Dipl. Phys.

Hermann-von-Helmholtz-Platz 1
76344 Eggenstein-Leopoldshafen
www.kit.edu

KIT - Universit=C3=A4t des Landes Baden-W=C3=BCrttemberg und
nationales Forschungszentrum in der Helmholtz-Gemeinschaft


--------------070606070200080809030106
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.7-031607-generic (apw@tangerine) (gcc v=
ersion 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201410301735 SMP Thu Oct 3=
0 17:37:43 UTC 2014
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-3.16.7-031607-gen=
eric root=3DUUID=3D55971d02-38a2-4065-babd-b79c60741ef8 ro cgroup_enable=3D=
memory swapaccount=3D1 quiet splash pcie_aspm=3Dforce
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e3ff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009e400-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000e4000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bff9ffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000bffa0000-0x00000000bffaffff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000bffb0000-0x00000000bffdffff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bffe0000-0x00000000bfffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000043fffffff] usa=
ble
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./890GM P=
ro3, BIOS P1.60 06/23/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x440000 max_arch_pfn =3D 0x400000000
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
[    0.000000] TOM2: 0000000440000000 aka 17408M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600=
070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable =3D=3D> re=
served
[    0.000000] e820: last_pfn =3D 0xbffa0 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped a=
t [ffff8800000ff780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24=
576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fbe000, 0x01fbefff] PGTABLE
[    0.000000] BRK [0x01fbf000, 0x01fbffff] PGTABLE
[    0.000000] BRK [0x01fc0000, 0x01fc0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x43fe00000-0x43fffffff]
[    0.000000]  [mem 0x43fe00000-0x43fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x43c000000-0x43fdfffff]
[    0.000000]  [mem 0x43c000000-0x43fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x400000000-0x43bffffff]
[    0.000000]  [mem 0x400000000-0x43bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbff9ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbfdfffff] page 2M
[    0.000000]  [mem 0xbfe00000-0xbff9ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x34c42000-0x36618fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FAA70 000014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 0x00000000BFFA0000 000044 (v01 062310 RSDT2101 =
20100623 MSFT 00000097)
[    0.000000] ACPI: FACP 0x00000000BFFA0200 000084 (v01 A_M_I  OEMFACP  =
12000601 MSFT 00000097)
[    0.000000] ACPI: DSDT 0x00000000BFFA0450 00744B (v01 AS370  AS370154 =
00000154 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000BFFB0000 000040
[    0.000000] ACPI: APIC 0x00000000BFFA0390 00007C (v01 062310 APIC2101 =
20100623 MSFT 00000097)
[    0.000000] ACPI: MCFG 0x00000000BFFA0410 00003C (v01 062310 OEMMCFG  =
20100623 MSFT 00000097)
[    0.000000] ACPI: OEMB 0x00000000BFFB0040 000072 (v01 062310 OEMB2101 =
20100623 MSFT 00000097)
[    0.000000] ACPI: SRAT 0x00000000BFFAA450 000108 (v03 AMD    FAM_F_10 =
00000002 AMD  00000001)
[    0.000000] ACPI: AAFT 0x00000000BFFAA560 000027 (v01 062310 OEMAAFT  =
20100623 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000BFFAA590 000038 (v01 062310 OEMHPET  =
20100623 MSFT 00000097)
[    0.000000] ACPI: SSDT 0x00000000BFFAA5D0 000DA4 (v01 A M I  POWERNOW =
00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x43fffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000=
-0xbfffffff] -> [mem 0x00000000-0xbfffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x10000000=
0-0x43fffffff] -> [mem 0x00000000-0x43fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x43fffffff]
[    0.000000]   NODE_DATA [mem 0x43fff9000-0x43fffdfff]
[    0.000000]  [ffffea0000000000-ffffea0010ffffff] PMD -> [ffff88042f600=
000-ffff88043f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x43fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0xbff9ffff]
[    0.000000]   node   0: [mem 0x100000000-0x43fffffff]
[    0.000000] On node 0 totalpages: 4194109
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12223 pages used for memmap
[    0.000000]   DMA32 zone: 782240 pages, LIFO batch:31
[    0.000000]   Normal zone: 53248 pages used for memmap
[    0.000000]   Normal zone: 3407872 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 6, version 33, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)=

[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] smpboot: Allowing 6 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e4000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbffa0000-0xbffaffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbffb0000-0xbffdffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbffe0000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xffefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfff00000-0xffffffff]
[    0.000000] e820: [mem 0xc0000000-0xffefffff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:6=
 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88043fc00000 s86272 r81=
92 d24320 u262144
[    0.000000] pcpu-alloc: s86272 r8192 d24320 u262144 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - -=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 4128553
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-3.16.7-031=
607-generic root=3DUUID=3D55971d02-38a2-4065-babd-b79c60741ef8 ro cgroup_=
enable=3Dmemory swapaccount=3D1 quiet splash pcie_aspm=3Dforce
[    0.000000] PCIe ASPM is forcibly enabled
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] AGP: Node 0: aperture [bus addr 0xc816000000-0xc817ffffff]=
 (32MB)
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] AGP: Your BIOS doesn't leave a aperture memory hole
[    0.000000] AGP: Please enable the IOMMU option in the BIOS setup
[    0.000000] AGP: This costs you 64MB of RAM
[    0.000000] AGP: Mapping aperture over RAM [mem 0xb4000000-0xb7ffffff]=
 (65536KB)
[    0.000000] PM: Registered nosave memory: [mem 0xb4000000-0xb7ffffff]
[    0.000000] Memory: 16339040K/16776436K available (7790K kernel code, =
1120K rwdata, 3712K rodata, 1368K init, 1300K bss, 437396K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D6,=
 Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D256 to nr_cpu_ids=3D6=
=2E
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-5.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D6
[    0.000000] NR_IRQS:16640 nr_irqs:728 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2805.588 MHz processor
[    0.000024] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 5611.17 BogoMIPS (lpj=3D11222352)
[    0.000027] pid_max: default: 32768 minimum: 301
[    0.000033] ACPI: Core revision 20140424
[    0.002773] ACPI: All ACPI Tables successfully acquired
[    0.004682] Security Framework initialized
[    0.004694] AppArmor: AppArmor initialized
[    0.004695] Yama: becoming mindful.
[    0.005634] Dentry cache hash table entries: 2097152 (order: 12, 16777=
216 bytes)
[    0.009565] Inode-cache hash table entries: 1048576 (order: 11, 838860=
8 bytes)
[    0.011338] Mount-cache hash table entries: 32768 (order: 6, 262144 by=
tes)
[    0.011353] Mountpoint-cache hash table entries: 32768 (order: 6, 2621=
44 bytes)
[    0.011644] Initializing cgroup subsys memory
[    0.011663] Initializing cgroup subsys devices
[    0.011668] Initializing cgroup subsys freezer
[    0.011671] Initializing cgroup subsys net_cls
[    0.011676] Initializing cgroup subsys blkio
[    0.011679] Initializing cgroup subsys perf_event
[    0.011681] Initializing cgroup subsys net_prio
[    0.011687] Initializing cgroup subsys hugetlb
[    0.011705] tseg: 0000000000
[    0.011711] CPU: Physical Processor ID: 0
[    0.011712] CPU: Processor Core ID: 0
[    0.011714] mce: CPU supports 6 MCE banks
[    0.011719] LVT offset 0 assigned for vector 0xf9
[    0.011723] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
tlb_flushall_shift: 6
[    0.011800] Freeing SMP alternatives memory: 28K (ffffffff81e70000 - f=
fffffff81e77000)
[    0.012442] ftrace: allocating 32024 entries in 126 pages
[    0.044068] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.083756] smpboot: CPU0: AMD Phenom(tm) II X6 1055T Processor (fam: =
10, model: 0a, stepping: 00)
[    0.191263] Performance Events: AMD PMU driver.
[    0.191266] ... version:                0
[    0.191267] ... bit width:              48
[    0.191268] ... generic registers:      4
[    0.191269] ... value mask:             0000ffffffffffff
[    0.191270] ... max period:             00007fffffffffff
[    0.191270] ... fixed-purpose events:   0
[    0.191271] ... event mask:             000000000000000f
[    0.192575] NMI watchdog: enabled on all CPUs, permanently consumes on=
e hw-PMU counter.
[    0.192646] x86: Booting SMP configuration:
[    0.192648] .... node  #0, CPUs:      #1 #2 #3 #4 #5
[    0.258054] x86: Booted up 1 node, 6 CPUs
[    0.258056] smpboot: Total of 6 processors activated (33667.05 BogoMIP=
S)
[    0.265113] devtmpfs: initialized
[    0.269985] evm: security.selinux
[    0.269987] evm: security.SMACK64
[    0.269988] evm: security.SMACK64EXEC
[    0.269988] evm: security.SMACK64TRANSMUTE
[    0.269989] evm: security.SMACK64MMAP
[    0.269990] evm: security.ima
[    0.269991] evm: security.capability
[    0.270114] PM: Registering ACPI NVS region [mem 0xbffb0000-0xbffdffff=
] (196608 bytes)
[    0.271058] pinctrl core: initialized pinctrl subsystem
[    0.271122] regulator-dummy: no parameters
[    0.271148] RTC time:  7:00:10, date: 02/10/15
[    0.271193] NET: Registered protocol family 16
[    0.271338] cpuidle: using governor ladder
[    0.271340] cpuidle: using governor menu
[    0.271345] node 0 link 0: io port [1000, ffffff]
[    0.271346] TOM: 00000000c0000000 aka 3072M
[    0.271348] Fam 10h mmconf [mem 0xe0000000-0xefffffff]
[    0.271350] node 0 link 0: mmio [a0000, bffff]
[    0.271352] node 0 link 0: mmio [c0000000, dfffffff]
[    0.271353] node 0 link 0: mmio [e0000000, efffffff] =3D=3D> none
[    0.271355] node 0 link 0: mmio [f0000000, fccfffff]
[    0.271356] node 0 link 0: mmio [fcd00000, fcefffff]
[    0.271357] node 0 link 0: mmio [fcf00000, ffefffff]
[    0.271358] TOM2: 0000000440000000 aka 17408M
[    0.271360] bus: [bus 00-07] on node 0 link 0
[    0.271361] bus: 00 [io  0x0000-0xffff]
[    0.271362] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.271363] bus: 00 [mem 0xc0000000-0xdfffffff]
[    0.271364] bus: 00 [mem 0xf0000000-0xffffffff]
[    0.271365] bus: 00 [mem 0x440000000-0xfcffffffff]
[    0.271476] ACPI: bus type PCI registered
[    0.271478] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.271548] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe00000=
00-0xefffffff] (base 0xe0000000)
[    0.271550] PCI: not using MMCONFIG
[    0.271552] PCI: Using configuration type 1 for base access
[    0.271552] PCI: Using configuration type 1 for extended access
[    0.271939] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.271940] mtrr: probably your BIOS does not setup all CPUs.
[    0.271941] mtrr: corrected configuration.
[    0.275797] ACPI: Added _OSI(Module Device)
[    0.275799] ACPI: Added _OSI(Processor Device)
[    0.275800] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.275802] ACPI: Added _OSI(Processor Aggregator Device)
[    0.276995] ACPI: Executed 4 blocks of module-level executable AML cod=
e
[    0.279500] ACPI: Interpreter enabled
[    0.279509] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S2_] (20140424/hwxface-580)
[    0.279519] ACPI: (supports S0 S1 S3 S4 S5)
[    0.279520] ACPI: Using IOAPIC for interrupt routing
[    0.279622] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe00000=
00-0xefffffff] (base 0xe0000000)
[    0.280239] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in A=
CPI motherboard resources
[    0.280583] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.283625] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.283630] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM Cl=
ockPM Segments MSI]
[    0.283634] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASP=
M
[    0.283834] PCI host bridge to bus 0000:00
[    0.283836] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.283838] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.283839] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.283841] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.283842] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000df=
fff]
[    0.283844] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xdffff=
fff]
[    0.283845] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebff=
fff]
[    0.283854] pci 0000:00:00.0: [1022:9601] type 00 class 0x060000
[    0.283935] pci 0000:00:01.0: [1849:9602] type 01 class 0x060400
[    0.283999] pci 0000:00:02.0: [1022:9603] type 01 class 0x060400
[    0.284030] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.284061] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.284095] pci 0000:00:07.0: [1022:9607] type 01 class 0x060400
[    0.284124] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.284149] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.284181] pci 0000:00:0a.0: [1022:9609] type 01 class 0x060400
[    0.284211] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.284239] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    0.284277] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    0.284293] pci 0000:00:11.0: reg 0x10: [io  0xb000-0xb007]
[    0.284300] pci 0000:00:11.0: reg 0x14: [io  0xa000-0xa003]
[    0.284307] pci 0000:00:11.0: reg 0x18: [io  0x9000-0x9007]
[    0.284314] pci 0000:00:11.0: reg 0x1c: [io  0x8000-0x8003]
[    0.284321] pci 0000:00:11.0: reg 0x20: [io  0x7000-0x700f]
[    0.284328] pci 0000:00:11.0: reg 0x24: [mem 0xfccffc00-0xfccfffff]
[    0.284414] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.284424] pci 0000:00:12.0: reg 0x10: [mem 0xfccfe000-0xfccfefff]
[    0.284485] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.284520] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.284534] pci 0000:00:12.2: reg 0x10: [mem 0xfccff800-0xfccff8ff]
[    0.284594] pci 0000:00:12.2: supports D1 D2
[    0.284595] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.284621] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.284656] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.284666] pci 0000:00:13.0: reg 0x10: [mem 0xfccfd000-0xfccfdfff]
[    0.284726] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.284759] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.284773] pci 0000:00:13.2: reg 0x10: [mem 0xfccff400-0xfccff4ff]
[    0.284832] pci 0000:00:13.2: supports D1 D2
[    0.284834] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.284860] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.284893] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.284989] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.285004] pci 0000:00:14.2: reg 0x10: [mem 0xfccf8000-0xfccfbfff 64b=
it]
[    0.285052] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.285076] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.285105] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.285195] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.285239] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.285269] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.285279] pci 0000:00:14.5: reg 0x10: [mem 0xfccfc000-0xfccfcfff]
[    0.285340] pci 0000:00:14.5: System wakeup disabled by ACPI
[    0.285371] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    0.285381] pci 0000:00:16.0: reg 0x10: [mem 0xfccf7000-0xfccf7fff]
[    0.285441] pci 0000:00:16.0: System wakeup disabled by ACPI
[    0.285474] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    0.285488] pci 0000:00:16.2: reg 0x10: [mem 0xfccff000-0xfccff0ff]
[    0.285547] pci 0000:00:16.2: supports D1 D2
[    0.285548] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.285574] pci 0000:00:16.2: System wakeup disabled by ACPI
[    0.285608] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    0.285655] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    0.285706] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    0.285751] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    0.285797] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    0.285887] pci 0000:01:05.0: [1002:9714] type 00 class 0x030000
[    0.285895] pci 0000:01:05.0: reg 0x10: [mem 0xc0000000-0xc7ffffff pre=
f]
[    0.285898] pci 0000:01:05.0: reg 0x14: [io  0xc000-0xc0ff]
[    0.285902] pci 0000:01:05.0: reg 0x18: [mem 0xfcef0000-0xfcefffff]
[    0.285910] pci 0000:01:05.0: reg 0x24: [mem 0xfcd00000-0xfcdfffff]
[    0.285929] pci 0000:01:05.0: supports D1 D2
[    0.285982] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.285985] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    0.285987] pci 0000:00:01.0:   bridge window [mem 0xfcd00000-0xfcefff=
ff]
[    0.285990] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc7ffff=
ff 64bit pref]
[    0.286028] pci 0000:04:00.0: [10de:0fc1] type 00 class 0x030000
[    0.286039] pci 0000:04:00.0: reg 0x10: [mem 0xfd000000-0xfdffffff]
[    0.286048] pci 0000:04:00.0: reg 0x14: [mem 0xd0000000-0xdfffffff 64b=
it pref]
[    0.286058] pci 0000:04:00.0: reg 0x1c: [mem 0xce000000-0xcfffffff 64b=
it pref]
[    0.286064] pci 0000:04:00.0: reg 0x24: [io  0xe800-0xe87f]
[    0.286071] pci 0000:04:00.0: reg 0x30: [mem 0xfe980000-0xfe9fffff pre=
f]
[    0.286150] pci 0000:04:00.1: [10de:0e1b] type 00 class 0x040300
[    0.286161] pci 0000:04:00.1: reg 0x10: [mem 0xfe97c000-0xfe97ffff]
[    0.291274] pci 0000:00:02.0: PCI bridge to [bus 04]
[    0.291280] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.291283] pci 0000:00:02.0:   bridge window [mem 0xfd000000-0xfe9fff=
ff]
[    0.291286] pci 0000:00:02.0:   bridge window [mem 0xce000000-0xdfffff=
ff 64bit pref]
[    0.291350] pci 0000:03:00.0: [1b73:1000] type 00 class 0x0c0330
[    0.291376] pci 0000:03:00.0: reg 0x10: [mem 0xfcff0000-0xfcffffff]
[    0.291532] pci 0000:03:00.0: PME# supported from D0 D3hot
[    0.299279] pci 0000:00:07.0: PCI bridge to [bus 03]
[    0.299284] pci 0000:00:07.0:   bridge window [mem 0xfcf00000-0xfcffff=
ff]
[    0.299339] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.299354] pci 0000:02:00.0: reg 0x10: [io  0xd800-0xd8ff]
[    0.299373] pci 0000:02:00.0: reg 0x18: [mem 0xcdfff000-0xcdffffff 64b=
it pref]
[    0.299386] pci 0000:02:00.0: reg 0x20: [mem 0xcdff8000-0xcdffbfff 64b=
it pref]
[    0.299454] pci 0000:02:00.0: supports D1 D2
[    0.299455] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.307274] pci 0000:00:0a.0: PCI bridge to [bus 02]
[    0.307279] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    0.307283] pci 0000:00:0a.0:   bridge window [mem 0xcdf00000-0xcdffff=
ff 64bit pref]
[    0.307355] pci 0000:00:14.4: PCI bridge to [bus 05] (subtractive deco=
de)
[    0.307363] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (sub=
tractive decode)
[    0.307364] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (sub=
tractive decode)
[    0.307366] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bff=
ff] (subtractive decode)
[    0.307368] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dff=
ff] (subtractive decode)
[    0.307369] pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xdfffff=
ff] (subtractive decode)
[    0.307371] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfff=
ff] (subtractive decode)
[    0.307393] pci_bus 0000:00: on NUMA node 0
[    0.307734] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11 14 15) *0
[    0.307777] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11 14 15) *0
[    0.307820] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11 14 15) *0
[    0.307863] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11 14 15) *0
[    0.307898] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11 14 15) *0
[    0.307924] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11 14 15) *0
[    0.307951] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11 14 15) *0
[    0.307978] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11 14 15) *0
[    0.308121] vgaarb: device added: PCI:0000:01:05.0,decodes=3Dio+mem,ow=
ns=3Dnone,locks=3Dnone
[    0.308124] vgaarb: setting as boot device: PCI:0000:04:00.0
[    0.308125] vgaarb: device added: PCI:0000:04:00.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.308126] vgaarb: loaded
[    0.308127] vgaarb: bridge control possible 0000:04:00.0
[    0.308128] vgaarb: bridge control possible 0000:01:05.0
[    0.308311] SCSI subsystem initialized
[    0.308410] libata version 3.00 loaded.
[    0.308433] ACPI: bus type USB registered
[    0.308451] usbcore: registered new interface driver usbfs
[    0.308460] usbcore: registered new interface driver hub
[    0.308483] usbcore: registered new device driver usb
[    0.308619] PCI: Using ACPI for IRQ routing
[    0.314732] PCI: pci_cache_line_size set to 64 bytes
[    0.314792] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
[    0.314794] e820: reserve RAM buffer [mem 0xbffa0000-0xbfffffff]
[    0.314885] NetLabel: Initializing
[    0.314886] NetLabel:  domain hash size =3D 128
[    0.314887] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.314896] NetLabel:  unlabeled traffic allowed by default
[    0.314973] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.314976] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.317063] Switched to clocksource hpet
[    0.322106] AppArmor: AppArmor Filesystem Enabled
[    0.322135] pnp: PnP ACPI init
[    0.322149] ACPI: bus type PNP registered
[    0.322272] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.322321] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.322467] system 00:02: [mem 0xfec00000-0xfec00fff] could not be res=
erved
[    0.322469] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserve=
d
[    0.322471] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.322610] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    0.322612] system 00:03: [io  0x040b] has been reserved
[    0.322614] system 00:03: [io  0x04d6] has been reserved
[    0.322615] system 00:03: [io  0x0c00-0x0c01] has been reserved
[    0.322617] system 00:03: [io  0x0c14] has been reserved
[    0.322618] system 00:03: [io  0x0c50-0x0c51] has been reserved
[    0.322620] system 00:03: [io  0x0c52] has been reserved
[    0.322621] system 00:03: [io  0x0c6c] has been reserved
[    0.322623] system 00:03: [io  0x0c6f] has been reserved
[    0.322624] system 00:03: [io  0x0cd0-0x0cd1] has been reserved
[    0.322626] system 00:03: [io  0x0cd2-0x0cd3] has been reserved
[    0.322627] system 00:03: [io  0x0cd4-0x0cd5] has been reserved
[    0.322629] system 00:03: [io  0x0cd6-0x0cd7] has been reserved
[    0.322630] system 00:03: [io  0x0cd8-0x0cdf] has been reserved
[    0.322632] system 00:03: [io  0x0800-0x089f] could not be reserved
[    0.322634] system 00:03: [io  0x0b00-0x0b1f] has been reserved
[    0.322635] system 00:03: [io  0x0b20-0x0b3f] has been reserved
[    0.322637] system 00:03: [io  0x0900-0x090f] has been reserved
[    0.322638] system 00:03: [io  0x0910-0x091f] has been reserved
[    0.322640] system 00:03: [io  0xfe00-0xfefe] has been reserved
[    0.322642] system 00:03: [mem 0xffb80000-0xffbfffff] has been reserve=
d
[    0.322643] system 00:03: [mem 0xfec10000-0xfec1001f] has been reserve=
d
[    0.322645] system 00:03: [mem 0xfed80000-0xfed80fff] has been reserve=
d
[    0.322647] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.322690] pnp 00:04: Plug and Play ACPI device, IDs PNP0303 PNP030b =
(active)
[    0.322833] system 00:05: [io  0x0280-0x028f] has been reserved
[    0.322835] system 00:05: [io  0x0290-0x029f] has been reserved
[    0.322837] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.322881] system 00:06: [mem 0xe0000000-0xefffffff] has been reserve=
d
[    0.322883] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.322989] system 00:07: [mem 0x00000000-0x0009ffff] could not be res=
erved
[    0.322991] system 00:07: [mem 0x000c0000-0x000cffff] could not be res=
erved
[    0.322992] system 00:07: [mem 0x000e0000-0x000fffff] could not be res=
erved
[    0.322994] system 00:07: [mem 0x00100000-0xbfffffff] could not be res=
erved
[    0.322996] system 00:07: [mem 0xfec00000-0xffffffff] could not be res=
erved
[    0.322998] system 00:07: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    0.323059] pnp: PnP ACPI: found 8 devices
[    0.323060] ACPI: bus type PNP unregistered
[    0.329385] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.329388] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    0.329390] pci 0000:00:01.0:   bridge window [mem 0xfcd00000-0xfcefff=
ff]
[    0.329393] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc7ffff=
ff 64bit pref]
[    0.329395] pci 0000:00:02.0: PCI bridge to [bus 04]
[    0.329397] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.329399] pci 0000:00:02.0:   bridge window [mem 0xfd000000-0xfe9fff=
ff]
[    0.329401] pci 0000:00:02.0:   bridge window [mem 0xce000000-0xdfffff=
ff 64bit pref]
[    0.329404] pci 0000:00:07.0: PCI bridge to [bus 03]
[    0.329406] pci 0000:00:07.0:   bridge window [mem 0xfcf00000-0xfcffff=
ff]
[    0.329410] pci 0000:00:0a.0: PCI bridge to [bus 02]
[    0.329411] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    0.329414] pci 0000:00:0a.0:   bridge window [mem 0xcdf00000-0xcdffff=
ff 64bit pref]
[    0.329417] pci 0000:00:14.4: PCI bridge to [bus 05]
[    0.329426] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.329427] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.329429] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.329430] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.329432] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
[    0.329433] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.329435] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    0.329436] pci_bus 0000:01: resource 1 [mem 0xfcd00000-0xfcefffff]
[    0.329438] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xc7ffffff 64b=
it pref]
[    0.329439] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    0.329441] pci_bus 0000:04: resource 1 [mem 0xfd000000-0xfe9fffff]
[    0.329442] pci_bus 0000:04: resource 2 [mem 0xce000000-0xdfffffff 64b=
it pref]
[    0.329444] pci_bus 0000:03: resource 1 [mem 0xfcf00000-0xfcffffff]
[    0.329445] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.329447] pci_bus 0000:02: resource 2 [mem 0xcdf00000-0xcdffffff 64b=
it pref]
[    0.329448] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.329450] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.329451] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.329453] pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000dffff]
[    0.329454] pci_bus 0000:05: resource 8 [mem 0xc0000000-0xdfffffff]
[    0.329455] pci_bus 0000:05: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.329481] NET: Registered protocol family 2
[    0.329717] TCP established hash table entries: 131072 (order: 8, 1048=
576 bytes)
[    0.330043] TCP bind hash table entries: 65536 (order: 8, 1048576 byte=
s)
[    0.330283] TCP: Hash tables configured (established 131072 bind 65536=
)
[    0.330318] TCP: reno registered
[    0.330333] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.330415] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)=

[    0.330528] NET: Registered protocol family 1
[    0.330539] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disa=
bled
[    0.685286] pci 0000:04:00.0: Video device with shadowed ROM
[    0.685412] PCI: CLS 64 bytes, default 64
[    0.685472] Trying to unpack rootfs image as initramfs...
[    1.035426] Freeing initrd memory: 26460K (ffff880034c42000 - ffff8800=
36619000)
[    1.035703] PCI-DMA: Disabling AGP.
[    1.036944] PCI-DMA: aperture base @ b4000000 size 65536 KB
[    1.036945] PCI-DMA: using GART IOMMU.
[    1.036947] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.040235] microcode: CPU0: patch_level=3D0x010000bf
[    1.040249] microcode: CPU1: patch_level=3D0x010000bf
[    1.040261] microcode: CPU2: patch_level=3D0x010000bf
[    1.040272] microcode: CPU3: patch_level=3D0x010000bf
[    1.040286] microcode: CPU4: patch_level=3D0x010000bf
[    1.040302] microcode: CPU5: patch_level=3D0x010000bf
[    1.040370] microcode: Microcode Update Driver: v2.00 <tigran@aivazian=
=2Efsnet.co.uk>, Peter Oruba
[    1.040375] LVT offset 1 assigned for vector 0x400
[    1.040381] IBS: LVT offset 1 assigned
[    1.040398] perf: AMD IBS detected (0x0000001f)
[    1.040418] Scanning for low memory corruption every 60 seconds
[    1.040710] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    1.040737] Initialise system trusted keyring
[    1.040755] audit: initializing netlink subsys (disabled)
[    1.040771] audit: type=3D2000 audit(1423551609.912:1): initialized
[    1.041122] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.042449] zbud: loaded
[    1.042625] VFS: Disk quotas dquot_6.5.2
[    1.042654] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.043165] fuse init (API version 7.23)
[    1.043247] msgmni has been set to 32092
[    1.043303] Key type big_key registered
[    1.043788] Key type asymmetric registered
[    1.043792] Asymmetric key parser 'x509' registered
[    1.043854] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 252)
[    1.043933] io scheduler noop registered
[    1.043936] io scheduler deadline registered (default)
[    1.043983] io scheduler cfq registered
[    1.044176] pcieport 0000:00:02.0: irq 40 for MSI/MSI-X
[    1.044224] pcieport 0000:00:07.0: irq 41 for MSI/MSI-X
[    1.044317] pcieport 0000:00:0a.0: irq 42 for MSI/MSI-X
[    1.044381] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.044393] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    1.044513] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PN=
P0C0C:00/input/input0
[    1.044517] ACPI: Power Button [PWRB]
[    1.044548] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input1
[    1.044549] ACPI: Power Button [PWRF]
[    1.044617] ACPI: acpi_idle registered with cpuidle
[    1.045011] GHES: HEST is not enabled!
[    1.045129] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.046654] Linux agpgart interface v0.103
[    1.047842] brd: module loaded
[    1.048421] loop: module loaded
[    1.048651] libphy: Fixed MDIO Bus: probed
[    1.048654] tun: Universal TUN/TAP device driver, 1.6
[    1.048655] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.048723] PPP generic driver version 2.4.2
[    1.048772] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    1.048781] ehci-pci: EHCI PCI platform driver
[    1.048858] QUIRK: Enable AMD PLL fix
[    1.048874] ehci-pci 0000:00:12.2: EHCI Host Controller
[    1.048880] ehci-pci 0000:00:12.2: new USB bus registered, assigned bu=
s number 1
[    1.048884] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3=
 EHCI dummy qh workaround
[    1.048893] ehci-pci 0000:00:12.2: debug port 1
[    1.048935] ehci-pci 0000:00:12.2: irq 17, io mem 0xfccff800
[    1.057125] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.057167] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.057169] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.057170] usb usb1: Product: EHCI Host Controller
[    1.057172] usb usb1: Manufacturer: Linux 3.16.7-031607-generic ehci_h=
cd
[    1.057173] usb usb1: SerialNumber: 0000:00:12.2
[    1.057309] hub 1-0:1.0: USB hub found
[    1.057314] hub 1-0:1.0: 5 ports detected
[    1.057488] ehci-pci 0000:00:13.2: EHCI Host Controller
[    1.057493] ehci-pci 0000:00:13.2: new USB bus registered, assigned bu=
s number 2
[    1.057496] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3=
 EHCI dummy qh workaround
[    1.057504] ehci-pci 0000:00:13.2: debug port 1
[    1.057528] ehci-pci 0000:00:13.2: irq 17, io mem 0xfccff400
[    1.069140] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.069175] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.069176] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.069178] usb usb2: Product: EHCI Host Controller
[    1.069180] usb usb2: Manufacturer: Linux 3.16.7-031607-generic ehci_h=
cd
[    1.069181] usb usb2: SerialNumber: 0000:00:13.2
[    1.069302] hub 2-0:1.0: USB hub found
[    1.069307] hub 2-0:1.0: 5 ports detected
[    1.069485] ehci-pci 0000:00:16.2: EHCI Host Controller
[    1.069489] ehci-pci 0000:00:16.2: new USB bus registered, assigned bu=
s number 3
[    1.069492] ehci-pci 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3=
 EHCI dummy qh workaround
[    1.069501] ehci-pci 0000:00:16.2: debug port 1
[    1.069523] ehci-pci 0000:00:16.2: irq 17, io mem 0xfccff000
[    1.081133] ehci-pci 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    1.081168] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.081170] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.081171] usb usb3: Product: EHCI Host Controller
[    1.081173] usb usb3: Manufacturer: Linux 3.16.7-031607-generic ehci_h=
cd
[    1.081174] usb usb3: SerialNumber: 0000:00:16.2
[    1.081333] hub 3-0:1.0: USB hub found
[    1.081340] hub 3-0:1.0: 4 ports detected
[    1.081461] ehci-platform: EHCI generic platform driver
[    1.081470] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.081481] ohci-pci: OHCI PCI platform driver
[    1.081563] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    1.081567] ohci-pci 0000:00:12.0: new USB bus registered, assigned bu=
s number 4
[    1.081594] ohci-pci 0000:00:12.0: irq 18, io mem 0xfccfe000
[    1.141148] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.141151] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.141152] usb usb4: Product: OHCI PCI host controller
[    1.141154] usb usb4: Manufacturer: Linux 3.16.7-031607-generic ohci_h=
cd
[    1.141155] usb usb4: SerialNumber: 0000:00:12.0
[    1.141308] hub 4-0:1.0: USB hub found
[    1.141317] hub 4-0:1.0: 5 ports detected
[    1.141488] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    1.141493] ohci-pci 0000:00:13.0: new USB bus registered, assigned bu=
s number 5
[    1.141513] ohci-pci 0000:00:13.0: irq 18, io mem 0xfccfd000
[    1.201155] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.201158] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.201159] usb usb5: Product: OHCI PCI host controller
[    1.201160] usb usb5: Manufacturer: Linux 3.16.7-031607-generic ohci_h=
cd
[    1.201161] usb usb5: SerialNumber: 0000:00:13.0
[    1.201313] hub 5-0:1.0: USB hub found
[    1.201322] hub 5-0:1.0: 5 ports detected
[    1.201499] ohci-pci 0000:00:14.5: OHCI PCI host controller
[    1.201504] ohci-pci 0000:00:14.5: new USB bus registered, assigned bu=
s number 6
[    1.201521] ohci-pci 0000:00:14.5: irq 18, io mem 0xfccfc000
[    1.261153] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.261155] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.261157] usb usb6: Product: OHCI PCI host controller
[    1.261158] usb usb6: Manufacturer: Linux 3.16.7-031607-generic ohci_h=
cd
[    1.261159] usb usb6: SerialNumber: 0000:00:14.5
[    1.261310] hub 6-0:1.0: USB hub found
[    1.261319] hub 6-0:1.0: 2 ports detected
[    1.261457] ohci-pci 0000:00:16.0: OHCI PCI host controller
[    1.261461] ohci-pci 0000:00:16.0: new USB bus registered, assigned bu=
s number 7
[    1.261478] ohci-pci 0000:00:16.0: irq 18, io mem 0xfccf7000
[    1.321157] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.321159] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.321161] usb usb7: Product: OHCI PCI host controller
[    1.321162] usb usb7: Manufacturer: Linux 3.16.7-031607-generic ohci_h=
cd
[    1.321163] usb usb7: SerialNumber: 0000:00:16.0
[    1.321314] hub 7-0:1.0: USB hub found
[    1.321323] hub 7-0:1.0: 4 ports detected
[    1.321424] ohci-platform: OHCI generic platform driver
[    1.321436] uhci_hcd: USB Universal Host Controller Interface driver
[    1.321513] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    1.321518] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bu=
s number 8
[    1.446397] usb usb8: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.446398] usb usb8: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.446400] usb usb8: Product: xHCI Host Controller
[    1.446401] usb usb8: Manufacturer: Linux 3.16.7-031607-generic xhci_h=
cd
[    1.446402] usb usb8: SerialNumber: 0000:03:00.0
[    1.446512] hub 8-0:1.0: USB hub found
[    1.446518] hub 8-0:1.0: 1 port detected
[    1.446574] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    1.446577] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bu=
s number 9
[    1.446604] usb usb9: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[    1.446605] usb usb9: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.446609] usb usb9: Product: xHCI Host Controller
[    1.446610] usb usb9: Manufacturer: Linux 3.16.7-031607-generic xhci_h=
cd
[    1.446612] usb usb9: SerialNumber: 0000:03:00.0
[    1.446712] hub 9-0:1.0: USB hub found
[    1.446718] hub 9-0:1.0: 1 port detected
[    1.446805] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 ir=
q 1
[    1.446806] i8042: PNP: PS/2 appears to have AUX port disabled, if thi=
s is incorrect please boot with i8042.nopnp
[    1.447309] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.447432] mousedev: PS/2 mouse device common for all mice
[    1.447571] rtc_cmos 00:01: RTC can wake from S4
[    1.447667] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    1.447686] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvr=
am, hpet irqs
[    1.447738] device-mapper: uevent: version 1.0.3
[    1.447824] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialise=
d: dm-devel@redhat.com
[    1.447839] ledtrig-cpu: registered to indicate activity on CPUs
[    1.447922] TCP: cubic registered
[    1.448018] NET: Registered protocol family 10
[    1.448267] NET: Registered protocol family 17
[    1.448283] Key type dns_resolver registered
[    1.448716] Loading compiled-in X.509 certificates
[    1.449509] Loaded X.509 cert 'Magrathea: Glacier signing key: f4e6396=
ee79bbcbbfe2f3dea9e71c8797687680e'
[    1.449525] registered taskstats version 1
[    1.451529] Key type trusted registered
[    1.453204] Key type encrypted registered
[    1.454844] AppArmor: AppArmor sha1 policy hashing enabled
[    1.454848] ima: No TPM chip found, activating TPM-bypass!
[    1.454863] evm: HMAC attrs: 0x1
[    1.455202]   Magic number: 3:427:15
[    1.455255] memory memory59: hash matches
[    1.455320] rtc_cmos 00:01: setting system clock to 2015-02-10 07:00:1=
1 UTC (1423551611)
[    1.455477] acpi-cpufreq: overriding BIOS provided _PSD data
[    1.455679] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.455680] EDD information not available.
[    1.455724] PM: Hibernation image not present or could not be loaded.
[    1.456991] Freeing unused kernel memory: 1368K (ffffffff81d1a000 - ff=
ffffff81e70000)
[    1.456993] Write protecting the kernel read-only data: 12288k
[    1.458163] Freeing unused kernel memory: 392K (ffff88000179e000 - fff=
f880001800000)
[    1.459128] Freeing unused kernel memory: 384K (ffff880001ba0000 - fff=
f880001c00000)
[    1.470930] systemd-udevd[132]: starting version 204
[    1.486879] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.486903] ahci 0000:00:11.0: version 3.0
[    1.487079] ahci 0000:00:11.0: irq 43 for MSI/MSI-X
[    1.487106] r8169 0000:02:00.0: irq 44 for MSI/MSI-X
[    1.487166] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 6 ports 6 Gbps =
0x3f impl SATA mode
[    1.487169] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo p=
mp pio slum part=20
[    1.487287] r8169 0000:02:00.0 eth0: RTL8168e/8111e at 0xffffc9000000e=
000, 00:25:22:60:8b:4a, XID 0c100000 IRQ 44
[    1.487290] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 byte=
s, tx checksumming: ko]
[    1.488312] scsi0 : ahci
[    1.488467] scsi1 : ahci
[    1.488592] scsi2 : ahci
[    1.488759] scsi3 : ahci
[    1.488937] scsi4 : ahci
[    1.489060] scsi5 : ahci
[    1.489125] ata1: SATA max UDMA/133 abar m1024@0xfccffc00 port 0xfccff=
d00 irq 43
[    1.489129] ata2: SATA max UDMA/133 abar m1024@0xfccffc00 port 0xfccff=
d80 irq 43
[    1.489131] ata3: SATA max UDMA/133 abar m1024@0xfccffc00 port 0xfccff=
e00 irq 43
[    1.489133] ata4: SATA max UDMA/133 abar m1024@0xfccffc00 port 0xfccff=
e80 irq 43
[    1.489136] ata5: SATA max UDMA/133 abar m1024@0xfccffc00 port 0xfccff=
f00 irq 43
[    1.489138] ata6: SATA max UDMA/133 abar m1024@0xfccffc00 port 0xfccff=
f80 irq 43
[    1.809192] ata6: SATA link down (SStatus 0 SControl 300)
[    1.809259] ata1: SATA link down (SStatus 0 SControl 300)
[    1.981209] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.981232] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.981255] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.981279] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.981823] ata5.00: ATA-9: WDC WD40PURX-64GVNY0, 80.00A80, max UDMA/1=
33
[    1.981826] ata5.00: 7814037168 sectors, multi 0: LBA48 NCQ (depth 31/=
32), AA
[    1.981861] ata4.00: ATA-9: WDC WD40EFRX-68WT0N0, 80.00A80, max UDMA/1=
33
[    1.981865] ata4.00: 7814037168 sectors, multi 0: LBA48 NCQ (depth 31/=
32), AA
[    1.982400] ata5.00: configured for UDMA/133
[    1.982455] ata4.00: configured for UDMA/133
[    1.987364] ata2.00: ATA-8: SAMSUNG HD204UI, 1AQ10001, max UDMA/133
[    1.987367] ata2.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/=
32), AA
[    1.993528] ata2.00: configured for UDMA/133
[    1.993692] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD204UI  =
0001 PQ: 0 ANSI: 5
[    1.994035] sd 1:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.0=
0 TB/1.81 TiB)
[    1.994041] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    1.994193] sd 1:0:0:0: [sda] Write Protect is off
[    1.994197] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.994241] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    2.023298] ata3.00: ATA-8: OCZ-VERTEX2, 1.28, max UDMA/133
[    2.023301] ata3.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 31/3=
2), AA
[    2.025556]  sda: sda1 sda2
[    2.025994] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.037155] tsc: Refined TSC clocksource calibration: 2805.558 MHz
[    2.053302] ata3.00: configured for UDMA/133
[    2.053439] scsi 2:0:0:0: Direct-Access     ATA      OCZ-VERTEX2      =
1.28 PQ: 0 ANSI: 5
[    2.053731] sd 2:0:0:0: [sdb] 234441648 512-byte logical blocks: (120 =
GB/111 GiB)
[    2.053743] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    2.053905] sd 2:0:0:0: [sdb] Write Protect is off
[    2.053909] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.053919] scsi 3:0:0:0: Direct-Access     ATA      WDC WD40EFRX-68W =
0A80 PQ: 0 ANSI: 5
[    2.053953] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    2.054158] sd 3:0:0:0: [sdc] 7814037168 512-byte logical blocks: (4.0=
0 TB/3.63 TiB)
[    2.054161] sd 3:0:0:0: [sdc] 4096-byte physical blocks
[    2.054189] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    2.054297] sd 3:0:0:0: [sdc] Write Protect is off
[    2.054299] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.054331] scsi 4:0:0:0: Direct-Access     ATA      WDC WD40PURX-64G =
0A80 PQ: 0 ANSI: 5
[    2.054344] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    2.054535]  sdb: sdb1
[    2.054573] sd 4:0:0:0: [sdd] 7814037168 512-byte logical blocks: (4.0=
0 TB/3.63 TiB)
[    2.054577] sd 4:0:0:0: [sdd] 4096-byte physical blocks
[    2.054605] sd 4:0:0:0: Attached scsi generic sg3 type 0
[    2.054691] sd 4:0:0:0: [sdd] Write Protect is off
[    2.054694] sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.054746] sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    2.054885] sd 2:0:0:0: [sdb] Attached SCSI disk
[    2.092230]  sdc: sdc1 sdc2
[    2.092662] sd 3:0:0:0: [sdc] Attached SCSI disk
[    2.103002]  sdd: sdd1 sdd2
[    2.103423] sd 4:0:0:0: [sdd] Attached SCSI disk
[    3.037306] Switched to clocksource tsc
[    3.807272] random: nonblocking pool is initialized
[    3.973195] raid6: sse2x1    4422 MB/s
[    4.041211] raid6: sse2x2    7589 MB/s
[    4.109196] raid6: sse2x4    7993 MB/s
[    4.109198] raid6: using algorithm sse2x4 (7993 MB/s)
[    4.109199] raid6: using intx1 recovery algorithm
[    4.110335] xor: measuring software checksum speed
[    4.149184]    prefetch64-sse: 12851.000 MB/sec
[    4.189186]    generic_sse: 12439.000 MB/sec
[    4.189187] xor: using function: prefetch64-sse (12851.000 MB/sec)
[    4.201071] Btrfs loaded
[    4.293730] BTRFS: device fsid bc2aa9ef-d70b-4cab-8099-422f617ddaa4 de=
vid 1 transid 519371 /dev/sdc1
[    4.391338] BTRFS: device fsid bc2aa9ef-d70b-4cab-8099-422f617ddaa4 de=
vid 2 transid 519369 /dev/sdd1
[    9.397497] EXT4-fs (sdb1): INFO: recovery required on readonly filesy=
stem
[    9.397503] EXT4-fs (sdb1): write access will be enabled during recove=
ry
[    9.407767] EXT4-fs (sdb1): recovery complete
[    9.407882] EXT4-fs (sdb1): mounted filesystem with ordered data mode.=
 Opts: (null)
[    9.573652] init: ureadahead main process (255) terminated with status=
 5
[    9.637317] Adding 8388604k swap on /dev/sdc2.  Priority:-1 extents:1 =
across:8388604k FS
[    9.668694] Adding 8388604k swap on /dev/sdd2.  Priority:-2 extents:1 =
across:8388604k FS
[    9.724746] EXT4-fs (sdb1): re-mounted. Opts: errors=3Dremount-ro,user=
_xattr
[    9.771616] BTRFS info (device sdc1): disk space caching is enabled
[   22.300468] systemd-udevd[543]: starting version 204
[   22.330598] lp: driver loaded but no devices found
[   22.339062] w83627ehf: Found W83627DHG-P chip at 0x290
[   22.344899] ppdev: user-space parallel port driver
[   22.386979] shpchp: Standard Hot Plug PCI Controller Driver version: 0=
=2E4
[   22.387388] ACPI Warning: SystemIO range 0x0000000000000b00-0x00000000=
00000b07 conflicts with OpRegion 0x0000000000000b00-0x0000000000000b0f (\=
SOR1) (20140424/utaddress-258)
[   22.387396] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   22.390921] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[   22.391015] sp5100_tco: PCI Revision ID: 0x41
[   22.391050] sp5100_tco: Using 0xfed80b00 for watchdog MMIO address
[   22.391061] sp5100_tco: Last reboot was not triggered by watchdog.
[   22.391326] sp5100_tco: initialized (0xffffc90011ba8b00). heartbeat=3D=
60 sec (nowayout=3D0)
[   22.398872] wmi: Mapper loaded
[   22.414930] MCE: In-kernel MCE decoding enabled.
[   22.417535] EDAC MC: Ver: 3.0.0
[   22.420063] AMD64 EDAC driver v3.4.0
[   22.420099] EDAC amd64: DRAM ECC disabled.
[   22.420107] EDAC amd64: ECC disabled in the BIOS or no ECC capability,=
 module will not load.
 Either enable ECC checking or force module loading by setting 'ecc_enabl=
e_override'.
 (Note that use of the override may cause unknown side effects.)
[   22.424244] [drm] Initialized drm 1.1.0 20060810
[   22.471885] kvm: Nested Virtualization enabled
[   22.471891] kvm: Nested Paging enabled
[   22.519705] Bluetooth: Core ver 2.19
[   22.519731] NET: Registered protocol family 31
[   22.519732] Bluetooth: HCI device and connection manager initialized
[   22.519739] Bluetooth: HCI socket layer initialized
[   22.519741] Bluetooth: L2CAP socket layer initialized
[   22.519751] Bluetooth: SCO socket layer initialized
[   22.530547] Bluetooth: RFCOMM TTY layer initialized
[   22.530560] Bluetooth: RFCOMM socket layer initialized
[   22.530568] Bluetooth: RFCOMM ver 1.11
[   22.532207] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   22.532210] Bluetooth: BNEP filters: protocol multicast
[   22.532217] Bluetooth: BNEP socket layer initialized
[   22.539398] snd_hda_intel 0000:04:00.1: Disabling MSI
[   22.539405] snd_hda_intel 0000:04:00.1: Handle VGA-switcheroo audio cl=
ient
[   22.542306] audit: type=3D1400 audit(1423551632.585:2): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/sbin/dhclient" pid=3D739 comm=3D=
"apparmor_parser"
[   22.542312] audit: type=3D1400 audit(1423551632.585:3): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/usr/lib/NetworkManager/nm-dhcp-=
client.action" pid=3D739 comm=3D"apparmor_parser"
[   22.542316] audit: type=3D1400 audit(1423551632.585:4): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/usr/lib/connman/scripts/dhclien=
t-script" pid=3D739 comm=3D"apparmor_parser"
[   22.542743] audit: type=3D1400 audit(1423551632.585:5): apparmor=3D"ST=
ATUS" operation=3D"profile_replace" name=3D"/usr/lib/NetworkManager/nm-dh=
cp-client.action" pid=3D739 comm=3D"apparmor_parser"
[   22.542748] audit: type=3D1400 audit(1423551632.585:6): apparmor=3D"ST=
ATUS" operation=3D"profile_replace" name=3D"/usr/lib/connman/scripts/dhcl=
ient-script" pid=3D739 comm=3D"apparmor_parser"
[   22.542956] audit: type=3D1400 audit(1423551632.585:7): apparmor=3D"ST=
ATUS" operation=3D"profile_replace" name=3D"/usr/lib/connman/scripts/dhcl=
ient-script" pid=3D739 comm=3D"apparmor_parser"
[   22.572516] audit: type=3D1400 audit(1423551632.613:8): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/usr/lib/cups/backend/cups-pdf" =
pid=3D761 comm=3D"apparmor_parser"
[   22.572522] audit: type=3D1400 audit(1423551632.613:9): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/usr/sbin/cupsd" pid=3D761 comm=3D=
"apparmor_parser"
[   22.572829] init: avahi-cups-reload main process (799) terminated with=
 status 1
[   22.573046] audit: type=3D1400 audit(1423551632.613:10): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/usr/sbin/cupsd" pid=3D761 c=
omm=3D"apparmor_parser"
[   22.582168] sound hdaudioC0D0: autoconfig: line_outs=3D3 (0x24/0x25/0x=
26/0x0/0x0) type:line
[   22.582173] sound hdaudioC0D0:    speaker_outs=3D0 (0x0/0x0/0x0/0x0/0x=
0)
[   22.582175] sound hdaudioC0D0:    hp_outs=3D1 (0x28/0x0/0x0/0x0/0x0)
[   22.582180] sound hdaudioC0D0:    mono: mono_out=3D0x0
[   22.582181] sound hdaudioC0D0:    dig-out=3D0x2d/0x0
[   22.582182] sound hdaudioC0D0:    inputs:
[   22.582185] sound hdaudioC0D0:      Front Mic=3D0x29
[   22.582186] sound hdaudioC0D0:      Rear Mic=3D0x2b
[   22.582188] sound hdaudioC0D0:      Line=3D0x2a
[   22.590970] input: HDA ATI SB Front Mic as /devices/pci0000:00/0000:00=
:14.2/sound/card0/input3
[   22.591091] input: HDA ATI SB Rear Mic as /devices/pci0000:00/0000:00:=
14.2/sound/card0/input4
[   22.591192] input: HDA ATI SB Line as /devices/pci0000:00/0000:00:14.2=
/sound/card0/input5
[   22.591322] input: HDA ATI SB Line Out Front as /devices/pci0000:00/00=
00:00:14.2/sound/card0/input6
[   22.591473] input: HDA ATI SB Line Out Surround as /devices/pci0000:00=
/0000:00:14.2/sound/card0/input7
[   22.591598] input: HDA ATI SB Line Out CLFE as /devices/pci0000:00/000=
0:00:14.2/sound/card0/input8
[   22.591727] input: HDA ATI SB Front Headphone as /devices/pci0000:00/0=
000:00:14.2/sound/card0/input9
[   22.643840] nvidia: module license 'NVIDIA' taints kernel.
[   22.643845] Disabling lock debugging due to kernel taint
[   22.654459] nvidia: module verification failed: signature and/or  requ=
ired key missing - tainting kernel
[   22.660834] vgaarb: device changed decodes: PCI:0000:04:00.0,olddecode=
s=3Dio+mem,decodes=3Dnone:owns=3Dnone
[   22.661180] [drm] Initialized nvidia-drm 0.0.0 20130102 for 0000:04:00=
=2E0 on minor 0
[   22.661188] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  331.113  M=
on Dec  1 21:08:13 PST 2014
[   22.688675] init: failsafe main process (894) killed by TERM signal
[   22.762011] audit: type=3D1400 audit(1423551632.805:11): apparmor=3D"S=
TATUS" operation=3D"profile_load" name=3D"docker-default" pid=3D1041 comm=
=3D"apparmor_parser"
[   22.911187] init: samba-ad-dc main process (1101) terminated with stat=
us 1
[   23.077581] r8169 0000:02:00.0 eth0: link down
[   23.077591] r8169 0000:02:00.0 eth0: link down
[   23.077627] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   23.214128] input: HDA NVidia HDMI/DP,pcm=3D3 as /devices/pci0000:00/0=
000:00:02.0/0000:04:00.1/sound/card1/input10
[   23.214225] input: HDA NVidia HDMI/DP,pcm=3D7 as /devices/pci0000:00/0=
000:00:02.0/0000:04:00.1/sound/card1/input11
[   23.214292] input: HDA NVidia HDMI/DP,pcm=3D8 as /devices/pci0000:00/0=
000:00:02.0/0000:04:00.1/sound/card1/input12
[   23.214370] input: HDA NVidia HDMI/DP,pcm=3D9 as /devices/pci0000:00/0=
000:00:02.0/0000:04:00.1/sound/card1/input13
[   23.696608] nvidia 0000:04:00.0: irq 45 for MSI/MSI-X
[   23.733520] Ebtables v2.0 registered
[   23.747287] ip_tables: (C) 2000-2006 Netfilter Core Team
[   23.756419] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   24.402693] Bridge firewalling registered
[   24.502810] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   24.533170] IPv6: ADDRCONF(NETDEV_UP): virbr0: link is not ready
[   24.572149] init: plymouth-upstart-bridge main process ended, respawni=
ng
[   24.576854] init: plymouth-upstart-bridge main process (1802) terminat=
ed with status 1
[   24.576864] init: plymouth-upstart-bridge main process ended, respawni=
ng
[   24.724607] cgroup: systemd-logind (771) created nested cgroup for con=
troller "memory" which has incomplete hierarchy support. Nested cgroups m=
ay change behavior in the future.
[   24.724612] cgroup: "memory" requires setting use_hierarchy to 1 on th=
e root
[   28.820944] vboxdrv: Found 6 processor cores.
[   28.821157] vboxdrv: fAsync=3D0 offMin=3D0x3b5 offMax=3D0x136e
[   28.821237] vboxdrv: TSC mode is 'synchronous', kernel timer mode is '=
normal'.
[   28.821239] vboxdrv: Successfully loaded version 4.3.10_Ubuntu (interf=
ace 0x001a0007).
[   29.001013] audit_printk_skb: 204 callbacks suppressed
[   29.001018] audit: type=3D1400 audit(1423551639.041:80): apparmor=3D"D=
ENIED" operation=3D"mkdir" profile=3D"/usr/lib/telepathy/mission-control-=
5" name=3D"/var/lib/gdm/.config/libaccounts-glib/" pid=3D2211 comm=3D"mis=
sion-control" requested_mask=3D"c" denied_mask=3D"c" fsuid=3D113 ouid=3D1=
13
[   29.002152] audit: type=3D1400 audit(1423551639.045:81): apparmor=3D"D=
ENIED" operation=3D"open" profile=3D"/usr/lib/telepathy/mission-control-5=
" name=3D"/etc/dconf/profile/gdm" pid=3D2211 comm=3D"mission-control" req=
uested_mask=3D"r" denied_mask=3D"r" fsuid=3D113 ouid=3D0
[   29.034765] vboxpci: IOMMU not found (not registered)
[   29.370733] parent transid verify failed on 2430109499392 wanted 51937=
1 found 519332
[   29.390943] BTRFS: read error corrected: ino 1 off 2430109499392 (dev =
/dev/sdd1 sector 4087631904)
[   29.391046] BTRFS: read error corrected: ino 1 off 2430109503488 (dev =
/dev/sdd1 sector 4087631912)
[   29.391154] BTRFS: read error corrected: ino 1 off 2430109507584 (dev =
/dev/sdd1 sector 4087631920)
[   29.391246] BTRFS: read error corrected: ino 1 off 2430109511680 (dev =
/dev/sdd1 sector 4087631928)
[   29.700743] parent transid verify failed on 2430109581312 wanted 51937=
1 found 519334
[   29.700985] BTRFS: read error corrected: ino 1 off 2430109581312 (dev =
/dev/sdd1 sector 4087632064)
[   29.701087] BTRFS: read error corrected: ino 1 off 2430109585408 (dev =
/dev/sdd1 sector 4087632072)
[   29.701172] BTRFS: read error corrected: ino 1 off 2430109589504 (dev =
/dev/sdd1 sector 4087632080)
[   29.701257] BTRFS: read error corrected: ino 1 off 2430109593600 (dev =
/dev/sdd1 sector 4087632088)
[   31.152080] init: plymouth-stop pre-start process (2948) terminated wi=
th status 1
[   34.477212] parent transid verify failed on 2430110171136 wanted 51937=
1 found 519252
[   34.477457] BTRFS: read error corrected: ino 1 off 2430110171136 (dev =
/dev/sdd1 sector 4087633216)
[   34.477548] BTRFS: read error corrected: ino 1 off 2430110175232 (dev =
/dev/sdd1 sector 4087633224)
[   34.477621] BTRFS: read error corrected: ino 1 off 2430110179328 (dev =
/dev/sdd1 sector 4087633232)
[   34.477735] BTRFS: read error corrected: ino 1 off 2430110183424 (dev =
/dev/sdd1 sector 4087633240)
[   34.495820] parent transid verify failed on 2430111285248 wanted 51937=
1 found 519332
[   34.496409] BTRFS: read error corrected: ino 1 off 2430111285248 (dev =
/dev/sdd1 sector 4087635392)
[   34.496514] BTRFS: read error corrected: ino 1 off 2430111289344 (dev =
/dev/sdd1 sector 4087635400)
[   34.496604] BTRFS: read error corrected: ino 1 off 2430111293440 (dev =
/dev/sdd1 sector 4087635408)
[   34.496692] BTRFS: read error corrected: ino 1 off 2430111297536 (dev =
/dev/sdd1 sector 4087635416)
[   34.528697] parent transid verify failed on 2430025318400 wanted 51937=
0 found 519368
[   34.544396] BTRFS: read error corrected: ino 1 off 2430025318400 (dev =
/dev/sdd1 sector 4087467488)
[   34.544503] BTRFS: read error corrected: ino 1 off 2430025322496 (dev =
/dev/sdd1 sector 4087467496)
[   34.564793] parent transid verify failed on 2430108827648 wanted 51937=
1 found 519334
[   34.595264] parent transid verify failed on 2430108844032 wanted 51937=
1 found 519334
[   34.646346] parent transid verify failed on 2430027628544 wanted 51937=
0 found 519368
[   34.661419] parent transid verify failed on 2430109745152 wanted 51937=
1 found 519334
[   34.664927] parent transid verify failed on 2430109892608 wanted 51937=
1 found 519334
[   36.706126] usb 5-3: new low-speed USB device number 2 using ohci-pci
[   36.874160] usb 5-3: New USB device found, idVendor=3D046d, idProduct=3D=
c517
[   36.874164] usb 5-3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[   36.874166] usb 5-3: Product: USB Receiver
[   36.874168] usb 5-3: Manufacturer: Logitech
[   36.894975] hidraw: raw HID events driver (C) Jiri Kosina
[   36.909225] usbcore: registered new interface driver usbhid
[   36.909228] usbhid: USB HID core driver
[   36.914186] input: Logitech USB Receiver as /devices/pci0000:00/0000:0=
0:13.0/usb5/5-3/5-3:1.0/0003:046D:C517.0001/input/input14
[   36.914567] logitech 0003:046D:C517.0001: input,hidraw0: USB HID v1.10=
 Keyboard [Logitech USB Receiver] on usb-0000:00:13.0-3/input0
[   36.914581] logitech 0003:046D:C517.0002: fixing up Logitech keyboard =
report descriptor
[   36.915025] input: Logitech USB Receiver as /devices/pci0000:00/0000:0=
0:13.0/usb5/5-3/5-3:1.1/0003:046D:C517.0002/input/input15
[   36.915218] logitech 0003:046D:C517.0002: input,hiddev0,hidraw1: USB H=
ID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:13.0-3/input1
[   37.665358] r8169 0000:02:00.0 eth0: link up
[   37.665367] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   38.843333] init: mediatomb main process (3243) terminated with status=
 127
[   38.843344] init: mediatomb main process ended, respawning
[   38.858670] init: mediatomb main process (3289) terminated with status=
 127
[   38.858681] init: mediatomb main process ended, respawning
[   38.866696] init: mediatomb main process (3314) terminated with status=
 127
[   38.866709] init: mediatomb main process ended, respawning
[   38.883350] init: mediatomb main process (3325) terminated with status=
 127
[   38.883366] init: mediatomb main process ended, respawning
[   38.890459] init: mediatomb main process (3336) terminated with status=
 127
[   38.890468] init: mediatomb main process ended, respawning
[   38.895849] init: mediatomb main process (3339) terminated with status=
 127
[   38.895859] init: mediatomb main process ended, respawning
[   38.901241] init: mediatomb main process (3343) terminated with status=
 127
[   38.901250] init: mediatomb main process ended, respawning
[   38.906503] init: mediatomb main process (3346) terminated with status=
 127
[   38.906513] init: mediatomb main process ended, respawning
[   38.911964] init: mediatomb main process (3349) terminated with status=
 127
[   38.911975] init: mediatomb main process ended, respawning
[   38.917361] init: mediatomb main process (3354) terminated with status=
 127
[   38.917370] init: mediatomb main process ended, respawning
[   38.922642] init: mediatomb main process (3357) terminated with status=
 127
[   38.922651] init: mediatomb respawning too fast, stopped
[   39.514850] parent transid verify failed on 2430109974528 wanted 51937=
1 found 519332
[   39.515116] repair_io_failure: 22 callbacks suppressed
[   39.515119] BTRFS: read error corrected: ino 1 off 2430109974528 (dev =
/dev/sdd1 sector 4087632832)
[   39.515220] BTRFS: read error corrected: ino 1 off 2430109978624 (dev =
/dev/sdd1 sector 4087632840)
[   39.515322] BTRFS: read error corrected: ino 1 off 2430109982720 (dev =
/dev/sdd1 sector 4087632848)
[   39.515419] BTRFS: read error corrected: ino 1 off 2430109986816 (dev =
/dev/sdd1 sector 4087632856)
[   39.515509] parent transid verify failed on 2430109990912 wanted 51937=
1 found 519332
[   39.515774] BTRFS: read error corrected: ino 1 off 2430109990912 (dev =
/dev/sdd1 sector 4087632864)
[   39.515875] BTRFS: read error corrected: ino 1 off 2430109995008 (dev =
/dev/sdd1 sector 4087632872)
[   39.515974] BTRFS: read error corrected: ino 1 off 2430109999104 (dev =
/dev/sdd1 sector 4087632880)
[   39.516073] BTRFS: read error corrected: ino 1 off 2430110003200 (dev =
/dev/sdd1 sector 4087632888)
[   39.540559] parent transid verify failed on 2430108532736 wanted 51937=
1 found 519334
[   39.553708] BTRFS: read error corrected: ino 1 off 2430108532736 (dev =
/dev/sdd1 sector 4087630016)
[   39.554280] BTRFS: read error corrected: ino 1 off 2430108536832 (dev =
/dev/sdd1 sector 4087630024)
[   39.554541] parent transid verify failed on 2430108663808 wanted 51937=
1 found 519331
[   39.606057] parent transid verify failed on 2430111154176 wanted 51937=
1 found 519332
[   41.214537] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready
[   41.383939] parent transid verify failed on 2430042128384 wanted 51937=
0 found 519368
[   41.831419] audit: type=3D1400 audit(1423551651.873:82): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"docker-default" pid=3D3446 c=
omm=3D"apparmor_parser"
[   57.013579] parent transid verify failed on 2430106435584 wanted 51937=
0 found 519367
[   57.032110] repair_io_failure: 14 callbacks suppressed
[   57.032116] BTRFS: read error corrected: ino 1 off 2430106435584 (dev =
/dev/sdd1 sector 4087625920)
[   57.032236] BTRFS: read error corrected: ino 1 off 2430106439680 (dev =
/dev/sdd1 sector 4087625928)
[   57.032343] BTRFS: read error corrected: ino 1 off 2430106443776 (dev =
/dev/sdd1 sector 4087625936)
[   57.032431] BTRFS: read error corrected: ino 1 off 2430106447872 (dev =
/dev/sdd1 sector 4087625944)
[   61.182116] capability: warning: `VirtualBox' uses 32-bit capabilities=
 (legacy support in use)
[   62.122609] parent transid verify failed on 2430071013376 wanted 51937=
0 found 519368
[   62.162006] BTRFS: read error corrected: ino 1 off 2430071013376 (dev =
/dev/sdd1 sector 4087556736)
[   62.162091] BTRFS: read error corrected: ino 1 off 2430071017472 (dev =
/dev/sdd1 sector 4087556744)
[   62.162173] BTRFS: read error corrected: ino 1 off 2430071021568 (dev =
/dev/sdd1 sector 4087556752)
[   62.162249] BTRFS: read error corrected: ino 1 off 2430071025664 (dev =
/dev/sdd1 sector 4087556760)
[   62.579567] parent transid verify failed on 2430104944640 wanted 51937=
0 found 519367
[   62.580238] BTRFS: read error corrected: ino 1 off 2430104944640 (dev =
/dev/sdd1 sector 4087623008)
[   62.580341] BTRFS: read error corrected: ino 1 off 2430104948736 (dev =
/dev/sdd1 sector 4087623016)
[   62.580434] BTRFS: read error corrected: ino 1 off 2430104952832 (dev =
/dev/sdd1 sector 4087623024)
[   62.580579] BTRFS: read error corrected: ino 1 off 2430104956928 (dev =
/dev/sdd1 sector 4087623032)
[   62.626728] parent transid verify failed on 2430108106752 wanted 51937=
0 found 519367
[   62.723044] BTRFS: read error corrected: ino 1 off 2430108106752 (dev =
/dev/sdd1 sector 4087629184)
[   62.723131] BTRFS: read error corrected: ino 1 off 2430108110848 (dev =
/dev/sdd1 sector 4087629192)
[   62.723520] parent transid verify failed on 2430108352512 wanted 51937=
0 found 519334
[   62.768804] parent transid verify failed on 2430109171712 wanted 51937=
1 found 519334
[   62.789251] parent transid verify failed on 2430109663232 wanted 51937=
1 found 519334
[   62.884120] parent transid verify failed on 2430105583616 wanted 51937=
0 found 519367
[   63.042831] parent transid verify failed on 2430110203904 wanted 51937=
1 found 519334
[   93.213544] BTRFS info (device sdc1): failed to delete reference to Ub=
untu 64 Bit.xml-prev, inode 1086 parent 260
[   93.213554] ------------[ cut here ]------------
[   93.213616] WARNING: CPU: 0 PID: 4562 at /home/apw/COD/linux/fs/btrfs/=
super.c:259 __btrfs_abort_transaction+0x5f/0x130 [btrfs]()
[   93.213621] BTRFS: Transaction aborted (error -2)
[   93.213625] Modules linked in: xt_addrtype joydev hid_logitech ff_meml=
ess usbhid hid pci_stub vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv=
(OE) ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_d=
efrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangl=
e xt_tcpudp bridge stp llc ip6table_filter ip6_tables iptable_filter ip_t=
ables ebtable_nat ebtables x_tables dm_crypt snd_hda_codec_hdmi nvidia(PO=
E) snd_hda_codec_via snd_hda_codec_generic snd_hda_intel snd_hda_controll=
er bnep snd_hda_codec rfcomm snd_hwdep bluetooth snd_pcm 6lowpan_iphc snd=
_seq_midi snd_seq_midi_event kvm_amd kvm snd_rawmidi snd_seq serio_raw dr=
m snd_seq_device edac_core snd_timer edac_mce_amd k10temp snd wmi soundco=
re sp5100_tco i2c_piix4 shpchp mac_hid binfmt_misc parport_pc ppdev w8362=
7ehf hwmon_vid
[   93.213715]  lp parport btrfs xor raid6_pq ahci r8169 libahci mii
[   93.213733] CPU: 0 PID: 4562 Comm: pool Tainted: P           OE 3.16.7=
-031607-generic #201410301735
[   93.213738] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.=
M./890GM Pro3, BIOS P1.60 06/23/2010
[   93.213743]  0000000000000103 ffff8803a3b7bac8 ffffffff81788d08 000000=
0000000007
[   93.213751]  ffff8803a3b7bb18 ffff8803a3b7bb08 ffffffff8107207c 000000=
0020743c43
[   93.213758]  ffff880424e9a000 ffff880411858be0 00000000fffffffe 000000=
0000000ea7
[   93.213764] Call Trace:
[   93.213782]  [<ffffffff81788d08>] dump_stack+0x46/0x58
[   93.213791]  [<ffffffff8107207c>] warn_slowpath_common+0x8c/0xc0
[   93.213802]  [<ffffffff81072166>] warn_slowpath_fmt+0x46/0x50
[   93.213839]  [<ffffffffc0142c0f>] __btrfs_abort_transaction+0x5f/0x130=
 [btrfs]
[   93.213886]  [<ffffffffc017a073>] __btrfs_unlink_inode+0x353/0x3b0 [bt=
rfs]
[   93.213931]  [<ffffffffc0175422>] ? btrfs_set_inode_index_count+0x82/0=
x140 [btrfs]
[   93.213940]  [<ffffffff81794b56>] ? mutex_lock+0x16/0x37
[   93.213985]  [<ffffffffc017e352>] btrfs_rename+0x412/0x710 [btrfs]
[   93.213994]  [<ffffffff811ef52c>] vfs_rename+0x53c/0x730
[   93.214001]  [<ffffffff811efb92>] SYSC_renameat2+0x472/0x4c0
[   93.214009]  [<ffffffff811f1c01>] ? user_path_at+0x11/0x20
[   93.214016]  [<ffffffff811e69b1>] ? vfs_fstatat+0x51/0xb0
[   93.214024]  [<ffffffff811e6a75>] ? SYSC_newlstat+0x15/0x30
[   93.214032]  [<ffffffff810edf72>] ? SyS_futex+0x142/0x1a0
[   93.214038]  [<ffffffff811e1dfe>] ? vfs_write+0x17e/0x1f0
[   93.214045]  [<ffffffff811f254e>] SyS_renameat2+0xe/0x10
[   93.214052]  [<ffffffff811f258e>] SyS_rename+0x1e/0x20
[   93.214058]  [<ffffffff817967ad>] system_call_fastpath+0x1a/0x1f
[   93.214063] ---[ end trace 6cafc64a33c05744 ]---
[   93.214069] BTRFS: error (device sdc1) in __btrfs_unlink_inode:3751: e=
rrno=3D-2 No such entry
[   93.214075] BTRFS info (device sdc1): forced readonly
[   93.214080] BTRFS: error (device sdc1) in btrfs_rename:8406: errno=3D-=
2 No such entry
[  988.161783] init: upstart-udev-bridge main process (536) terminated wi=
th status 1
[  988.161816] init: upstart-udev-bridge main process ended, respawning
[  988.162168] init: upstart-file-bridge main process (999) terminated wi=
th status 1
[  988.162192] init: upstart-file-bridge main process ended, respawning
[  988.162465] init: upstart-socket-bridge main process (1012) terminated=
 with status 1
[  988.162487] init: upstart-socket-bridge main process ended, respawning=

[  989.681289] init: upstart-udev-bridge main process (9145) terminated w=
ith status 1
[  989.681322] init: upstart-udev-bridge main process ended, respawning
[  989.681612] init: upstart-socket-bridge main process (9149) terminated=
 with status 1
[  989.681648] init: upstart-socket-bridge main process ended, respawning=

[  989.681864] init: upstart-file-bridge main process (9151) terminated w=
ith status 1
[  989.681886] init: upstart-file-bridge main process ended, respawning
[ 1067.248119] init: upstart-udev-bridge main process (9203) terminated w=
ith status 1
[ 1067.248153] init: upstart-udev-bridge main process ended, respawning
[ 1067.248438] init: upstart-socket-bridge main process (9209) terminated=
 with status 1
[ 1067.248464] init: upstart-socket-bridge main process ended, respawning=

[ 1067.248693] init: upstart-file-bridge main process (9214) terminated w=
ith status 1
[ 1067.248716] init: upstart-file-bridge main process ended, respawning
[ 1068.275547] init: upstart-udev-bridge main process (28279) terminated =
with status 1
[ 1068.275580] init: upstart-udev-bridge main process ended, respawning
[ 1068.275866] init: upstart-socket-bridge main process (28283) terminate=
d with status 1
[ 1068.275891] init: upstart-socket-bridge main process ended, respawning=

[ 1068.276118] init: upstart-file-bridge main process (28286) terminated =
with status 1
[ 1068.276141] init: upstart-file-bridge main process ended, respawning
[ 1177.177728] init: systemd-logind main process (771) killed by TERM sig=
nal
[ 1248.603852] init: cron main process (1330) killed by TERM signal
[ 1403.973701] init: smbd main process (914) killed by TERM signal
[ 1659.341337] init: irqbalance main process (1332) killed by TERM signal=

[ 1678.758450] init: apport post-stop process (2467) terminated with stat=
us 1
[ 2067.001661] init: upstart-udev-bridge main process (28312) terminated =
with status 1
[ 2067.001693] init: upstart-udev-bridge main process ended, respawning
[ 2067.001993] init: upstart-file-bridge main process (28319) terminated =
with status 1
[ 2067.002016] init: upstart-file-bridge main process ended, respawning
[ 2067.002317] init: upstart-socket-bridge main process (28321) terminate=
d with status 1
[ 2067.002340] init: upstart-socket-bridge main process ended, respawning=

[ 2079.182635] init: upstart-udev-bridge main process (22034) terminated =
with status 1
[ 2079.182647] init: upstart-udev-bridge main process ended, respawning
[ 2079.182739] init: upstart-socket-bridge main process (22053) terminate=
d with status 1
[ 2079.182746] init: upstart-socket-bridge main process ended, respawning=

[ 2079.182812] init: upstart-file-bridge main process (22057) terminated =
with status 1
[ 2079.182818] init: upstart-file-bridge main process ended, respawning
[ 5358.371859] systemd-logind[26798]: [/etc/systemd/logind.conf:16] Unkno=
wn lvalue 'Controllers' in section 'Login'
[ 5358.371882] systemd-logind[26798]: [/etc/systemd/logind.conf:17] Unkno=
wn lvalue 'ResetControllers' in section 'Login'
[ 5359.159066] systemd-logind[26798]: Watching system buttons on /dev/inp=
ut/event1 (Power Button)
[ 5359.159250] systemd-logind[26798]: Watching system buttons on /dev/inp=
ut/event0 (Power Button)
[ 5359.159303] systemd-logind[26798]: New seat seat0.
[ 5359.170491] systemd-logind[26798]: Failed to start unit user@1000.serv=
ice: Unknown unit: user@1000.service
[ 5359.170511] systemd-logind[26798]: Failed to start user service: Unkno=
wn unit: user@1000.service
[ 5359.174694] systemd-logind[26798]: New session c3 of user biephi.
[ 5359.174727] systemd-logind[26798]: Linked /tmp/.X11-unix/X0 to /run/us=
er/1000/X11-display.
[ 5359.178383] systemd-logind[26798]: New session 1 of user biephi.
[ 6619.828656] init: upstart-udev-bridge main process (22602) terminated =
with status 1
[ 6619.828670] init: upstart-udev-bridge main process ended, respawning
[ 6619.828796] init: upstart-socket-bridge main process (22618) terminate=
d with status 1
[ 6619.828805] init: upstart-socket-bridge main process ended, respawning=

[ 6619.828895] init: upstart-file-bridge main process (22619) terminated =
with status 1
[ 6619.828903] init: upstart-file-bridge main process ended, respawning
[ 6621.954052] audit: type=3D1400 audit(1423558231.697:83): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/sbin/dhclient" pid=3D29242 =
comm=3D"apparmor_parser"
[ 6621.954226] audit: type=3D1400 audit(1423558231.697:84): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/usr/lib/NetworkManager/nm-d=
hcp-client.action" pid=3D29242 comm=3D"apparmor_parser"
[ 6621.954321] audit: type=3D1400 audit(1423558231.697:85): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/usr/lib/connman/scripts/dhc=
lient-script" pid=3D29242 comm=3D"apparmor_parser"
[ 6623.888738] init: upstart-udev-bridge main process (28946) terminated =
with status 1
[ 6623.888751] init: upstart-udev-bridge main process ended, respawning
[ 6623.888866] init: upstart-socket-bridge main process (28962) terminate=
d with status 1
[ 6623.888874] init: upstart-socket-bridge main process ended, respawning=

[ 6623.888957] init: upstart-file-bridge main process (28966) terminated =
with status 1
[ 6623.888965] init: upstart-file-bridge main process ended, respawning
[ 6678.374354] SGI XFS with ACLs, security attributes, realtime, large bl=
ock/inode numbers, no debug enabled
[ 6678.384246] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[ 6678.407888] ntfs: driver 2.1.30 [Flags: R/O MODULE].
[ 6678.424661] QNX4 filesystem 0.2.3 registered.
[ 6757.836200] audit: type=3D1400 audit(1423558367.573:86): apparmor=3D"S=
TATUS" operation=3D"profile_load" name=3D"/usr/sbin/ntpd" pid=3D17944 com=
m=3D"apparmor_parser"
[ 6768.271858] audit: type=3D1400 audit(1423558378.009:87): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/usr/sbin/tcpdump" pid=3D192=
32 comm=3D"apparmor_parser"
[ 6785.067946] audit: type=3D1400 audit(1423558394.805:88): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/usr/bin/evince" pid=3D20635=
 comm=3D"apparmor_parser"
[ 6785.074308] audit: type=3D1400 audit(1423558394.813:89): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"sanitized_helper" pid=3D2063=
5 comm=3D"apparmor_parser"
[ 6785.074841] audit: type=3D1400 audit(1423558394.813:90): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/usr/bin/evince-previewer" p=
id=3D20635 comm=3D"apparmor_parser"
[ 6785.086722] audit: type=3D1400 audit(1423558394.825:91): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"sanitized_helper" pid=3D2063=
5 comm=3D"apparmor_parser"
[ 6785.088572] audit: type=3D1400 audit(1423558394.825:92): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/usr/bin/evince-thumbnailer"=
 pid=3D20635 comm=3D"apparmor_parser"
[ 6785.102634] audit: type=3D1400 audit(1423558394.841:93): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"sanitized_helper" pid=3D2063=
5 comm=3D"apparmor_parser"
[ 7186.375473] systemd-logind[26798]: Existing logind session ID 1 used b=
y new audit session, ignoring
[ 7186.393118] systemd-logind[26798]: Failed to start unit user@0.service=
: Unknown unit: user@0.service
[ 7186.393129] systemd-logind[26798]: Failed to start user service: Unkno=
wn unit: user@0.service
[ 7186.396099] systemd-logind[26798]: New session c1 of user root.

--------------070606070200080809030106--

--------------ms010200060709050205040603
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIQCjCC
BNUwggO9oAMCAQICCFBOxvU9EbRkMA0GCSqGSIb3DQEBCwUAMHExCzAJBgNVBAYTAkRFMRww
GgYDVQQKExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3Qg
Q2VudGVyMSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0xNDA3MjIx
MjA4MjZaFw0xOTA3MDkyMzU5MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVy
ZWluMRAwDgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwg
LSBHMDEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9
YuluTO2U1wBblSJ01CDrNI/W7MAxBAuZgeKmFNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2Q
RdDtoAB6fL9KDhsAw4bpXCsxEXsM84IkQ4wcOItqaACa7txPeKvSxhObdq3u3ibo7wGvdA/B
CaL2a869080UME/15eOkyGKbghoDJzANAmVgTe3RCSMqljVYJ9N2xnG2kB3E7f81hn1vM7Pb
D8URwoqDoZRdQWvY0hD1TP3KUazZve+Sg7va64sWVlZDz+HVEz2mHycwzUlU28kTNJpxdcVs
6qcLmPkhnSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjggGGMIIBgjAOBgNVHQ8BAf8EBAMCAQYw
HQYDVR0OBBYEFEm3xs/oPR9/6kR7Eyn38QpwPt5kMB8GA1UdIwQYMBaAFDHDeRu69VPXF+CJ
ei0XbAqzK50zMBIGA1UdEwEB/wQIMAYBAf8CAQIwYgYDVR0gBFswWTARBg8rBgEEAYGtIYIs
AQEEAgIwEQYPKwYBBAGBrSGCLAEBBAMAMBEGDysGAQQBga0hgiwBAQQDATAPBg0rBgEEAYGt
IYIsAQEEMA0GCysGAQQBga0hgiweMD4GA1UdHwQ3MDUwM6AxoC+GLWh0dHA6Ly9wa2kwMzM2
LnRlbGVzZWMuZGUvcmwvRFRfUk9PVF9DQV8yLmNybDB4BggrBgEFBQcBAQRsMGowLAYIKwYB
BQUHMAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMDoGCCsGAQUFBzAChi5o
dHRwOi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9EVF9ST09UX0NBXzIuY2VyMA0GCSqGSIb3
DQEBCwUAA4IBAQBjICj9nCGGcr45Rlk5MiW8qQGbDczKfUGchm0KbiyzE1l1sTOSG2EnFv/D
stU1gvuEKgFJvWa7Zi+ywgZdbj9u4wFaW8pDY1yVtuExpx/VB19N5mWCTjL5w3x6S81NXHTu
IfJ1AuxSPtLJatOQI25JZzW+f01WpOzML8+3oZeocj7JvEDWWqQIPda8gsO3tzKOsSyOam23
NQIZz/U5RFhjpyQAELC7/E6vbi84u6VXST/YblBvLJeW3B1GmmWJz67M8uXZn1OzPqEvkqnY
C8aEHwTG6x7on321e6UC8STFJGMRNMxakyAqeYg6JUKQqWU7fIbTEhUjKfws2sw5W1QXMIIF
lDCCBHygAwIBAgIHF6/3byMi6TANBgkqhkiG9w0BAQsFADBaMQswCQYDVQQGEwJERTETMBEG
A1UEChMKREZOLVZlcmVpbjEQMA4GA1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVp
biBQQ0EgR2xvYmFsIC0gRzAxMB4XDTE0MDYwNTE0MDgzMVoXDTE5MDcwOTIzNTkwMFowgb8x
CzAJBgNVBAYTAkRFMRswGQYDVQQIExJCYWRlbi1XdWVydHRlbWJlcmcxEjAQBgNVBAcTCUth
cmxzcnVoZTEqMCgGA1UEChMhS2FybHNydWhlIEluc3RpdHV0ZSBvZiBUZWNobm9sb2d5MScw
JQYDVQQLEx5TdGVpbmJ1Y2ggQ2VudHJlIGZvciBDb21wdXRpbmcxDzANBgNVBAMTBktJVC1D
QTEZMBcGCSqGSIb3DQEJARYKY2FAa2l0LmVkdTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAMyyqIqJooBBUSkvbR08HQh6NNE+tqNErubDBemoGj8A803wg+1xvXqkhO1vnBAB
p5U++7xgD5uLlTcOb/F4UFrJBBy9QCnThzCb+eqG+94Iw6m8LjWqCKor9lKwNCUit7vzNAOC
d0r0iNCYV2/xcK8tHSHw3mGXgvwfY0F9j14nUEg9nd5kPq0Aw9iQHDuYnOz3A8NVTpXpTCzi
QTCZJQYETDsC+nynQN2svAmAV3V1HJRe/AD6idy/6HN0EtAIOPlE1px14NFS4SZqUk/F4vD8
pxSz/YUwbCGK4IH37V9bcbQmA8NNNKBtFLqX19ovuQn32lRwSW/Cz3Hj+zSRP3MCAwEAAaOC
AfcwggHzMBIGA1UdEwEB/wQIMAYBAf8CAQEwDgYDVR0PAQH/BAQDAgEGMBEGA1UdIAQKMAgw
BgYEVR0gADAdBgNVHQ4EFgQUH3Rl9JodevYx6d9hG3MrDW3QM0kwHwYDVR0jBBgwFoAUSbfG
z+g9H3/qRHsTKffxCnA+3mQwFQYDVR0RBA4wDIEKY2FAa2l0LmVkdTCBiAYDVR0fBIGAMH4w
PaA7oDmGN2h0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NybC9j
YWNybC5jcmwwPaA7oDmGN2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2Ev
cHViL2NybC9jYWNybC5jcmwwgdcGCCsGAQUFBwEBBIHKMIHHMDMGCCsGAQUFBzABhidodHRw
Oi8vb2NzcC5wY2EuZGZuLmRlL09DU1AtU2VydmVyL09DU1AwRwYIKwYBBQUHMAKGO2h0dHA6
Ly9jZHAxLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0
MEcGCCsGAQUFBzAChjtodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1
Yi9jYWNlcnQvY2FjZXJ0LmNydDANBgkqhkiG9w0BAQsFAAOCAQEAOhYm/9RXIH2d+yjKb3Eq
nxruw4trhdI9T/GsoXgOndR2Up3MMrYm/MLOIXnRKIfnhm4puwpRrphfAeJYc7u2xRbb6vpy
dt/oUZy/KXJ46161Cygq8HZsyEQbR+fUHj72Tki5cmlxBIeIpmFFr+Wo1Y73mEoe+G1Q7x2V
Ni2VNpISa/pEBx/DYlxgqIHYYL3uHdinCKYMLXmx/PBh2eFN1JcXngJU+DAc8vzlxH9gjsqV
C2O8jrLPXiaZrt99g3pbtQEM89z/l6aJgiDFvAQEVnmit+S8+194lS5PcUjtEGYTyY+X9t61
591nOoXUXfnt6aum4Yf2Blsmn3xKCu5CqDCCBZUwggR9oAMCAQICBxfnAFYW8jQwDQYJKoZI
hvcNAQELBQAwgb8xCzAJBgNVBAYTAkRFMRswGQYDVQQIExJCYWRlbi1XdWVydHRlbWJlcmcx
EjAQBgNVBAcTCUthcmxzcnVoZTEqMCgGA1UEChMhS2FybHNydWhlIEluc3RpdHV0ZSBvZiBU
ZWNobm9sb2d5MScwJQYDVQQLEx5TdGVpbmJ1Y2ggQ2VudHJlIGZvciBDb21wdXRpbmcxDzAN
BgNVBAMTBktJVC1DQTEZMBcGCSqGSIb3DQEJARYKY2FAa2l0LmVkdTAeFw0xNDA3MTcwODAx
MTBaFw0xNzA3MTYwODAxMTBaMH0xCzAJBgNVBAYTAkRFMSowKAYDVQQKEyFLYXJsc3J1aGUg
SW5zdGl0dXRlIG9mIFRlY2hub2xvZ3kxJjAkBgNVBAsTHUluc3RpdHV0IGZ1ZXIgTmFub3Rl
Y2hub2xvZ2llMRowGAYDVQQDExFQaGlsaXBwIE0uIExldWZrZTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAMON2EJp5gvHmUPw65ftpmRIAQ8WUa2BGd16VqZxCitGYcJQWQ31
zXbyO6g5rBtz8qpBtJPhbW3K9MHil/peT7fUMlVmO2un0Tm7sTguxfEbiToKJMRI6xZDy84I
UVfsQKjJ6S4XPEir4TkQZ2sEGeko+S9QU+Fsf28MoLn3UPNsH5vmSmO4cDOTGsyvKsFbK6lP
C5/RqUpDVpZ0FtqCwUrmL+y0Cikq4kj/tVapLj95PB766kk+ClmRXej4+NfIHnw+t88ZbcMW
5ZKzLKyf1M8fs1awHtywmXE/Hdb/+RQyJLb+VgQDIesLCC9ydk+YgrDvB2BJ9MBbLgFYqvlu
1zECAwEAAaOCAdUwggHRMC8GA1UdIAQoMCYwEQYPKwYBBAGBrSGCLAEBBAMBMBEGDysGAQQB
ga0hgiwCAQQDATAJBgNVHRMEAjAAMAsGA1UdDwQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcD
AgYIKwYBBQUHAwQwHQYDVR0OBBYEFAPVzuDT8sEOlp3D0sZ3s+F9/kAcMB8GA1UdIwQYMBaA
FB90ZfSaHXr2MenfYRtzKw1t0DNJMBkGA1UdEQQSMBCBDmxldWZrZUBraXQuZWR1MHcGA1Ud
HwRwMG4wNaAzoDGGL2h0dHA6Ly9jZHAxLnBjYS5kZm4uZGUva2l0LWNhL3B1Yi9jcmwvY2Fj
cmwuY3JsMDWgM6Axhi9odHRwOi8vY2RwMi5wY2EuZGZuLmRlL2tpdC1jYS9wdWIvY3JsL2Nh
Y3JsLmNybDCBkgYIKwYBBQUHAQEEgYUwgYIwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jZHAxLnBj
YS5kZm4uZGUva2l0LWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDA/BggrBgEFBQcwAoYzaHR0
cDovL2NkcDIucGNhLmRmbi5kZS9raXQtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqG
SIb3DQEBCwUAA4IBAQBYGZXB1aIpEd34M6VZFmVQ2de0o/Pv1142tNW1XfQGTMcATz0HTLyS
YcL3FzdtsvTSTx0rQ2QbkyJt31j3sUW++WnDCQqa8MxPz0gW4FxwLcaqv8m3D8ALOwpVwzoP
mz8eBtDdGuU5KNAufsak3VfMnZNzRQviQCg/iOIY2oOg0AWKNHgfKhe10hg4c7o9MfMCB5FN
Vjk6+2RYqSo3l1A/1hxhjLfNPqsJD5NqwNYmikSUitKljgl7V3MLhd0qFrl9HbMQs+BGaPo2
eMA3RYX+O/WffG07k7yUZDqCC8LgSzQbxqWgkjLxo0n4vGZQy41rtXc5Dd4k8lLSQguhVhrd
MYIEgjCCBH4CAQEwgcswgb8xCzAJBgNVBAYTAkRFMRswGQYDVQQIExJCYWRlbi1XdWVydHRl
bWJlcmcxEjAQBgNVBAcTCUthcmxzcnVoZTEqMCgGA1UEChMhS2FybHNydWhlIEluc3RpdHV0
ZSBvZiBUZWNobm9sb2d5MScwJQYDVQQLEx5TdGVpbmJ1Y2ggQ2VudHJlIGZvciBDb21wdXRp
bmcxDzANBgNVBAMTBktJVC1DQTEZMBcGCSqGSIb3DQEJARYKY2FAa2l0LmVkdQIHF+cAVhby
NDAJBgUrDgMCGgUAoIICizAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0xNTAyMTAwOTA2MDRaMCMGCSqGSIb3DQEJBDEWBBTtumWPjsDTTYru8aSijW0VBVpS
3zBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcN
AwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMC
AgEoMIHcBgkrBgEEAYI3EAQxgc4wgcswgb8xCzAJBgNVBAYTAkRFMRswGQYDVQQIExJCYWRl
bi1XdWVydHRlbWJlcmcxEjAQBgNVBAcTCUthcmxzcnVoZTEqMCgGA1UEChMhS2FybHNydWhl
IEluc3RpdHV0ZSBvZiBUZWNobm9sb2d5MScwJQYDVQQLEx5TdGVpbmJ1Y2ggQ2VudHJlIGZv
ciBDb21wdXRpbmcxDzANBgNVBAMTBktJVC1DQTEZMBcGCSqGSIb3DQEJARYKY2FAa2l0LmVk
dQIHF+cAVhbyNDCB3gYLKoZIhvcNAQkQAgsxgc6ggcswgb8xCzAJBgNVBAYTAkRFMRswGQYD
VQQIExJCYWRlbi1XdWVydHRlbWJlcmcxEjAQBgNVBAcTCUthcmxzcnVoZTEqMCgGA1UEChMh
S2FybHNydWhlIEluc3RpdHV0ZSBvZiBUZWNobm9sb2d5MScwJQYDVQQLEx5TdGVpbmJ1Y2gg
Q2VudHJlIGZvciBDb21wdXRpbmcxDzANBgNVBAMTBktJVC1DQTEZMBcGCSqGSIb3DQEJARYK
Y2FAa2l0LmVkdQIHF+cAVhbyNDANBgkqhkiG9w0BAQEFAASCAQAyf2tZDa62y0acf8oUxCQO
0EVAsR1JzeCJgp/Ek8EQkfW2jeZKOqgb+RJe9+QMfC6g/JovrZ2V1HHqld2BI1hJsghDllPY
TscSF14Enhry+1ibvwloKrf8yojzRCqTbunz8OWOsfArPeE+kD6e9WvJxSArCe3W++36ATIJ
nv41epBPe/eJwgvvASfTniV2+lTIiu//07kle5gQurP3Mai49EsdRb1tL/OIy2pd2hKcOCqe
TPSMqf9grTay92kDACLUo2lIWva7YbS4lU094TfBoJ1Wq7UkDQDGan7td0uP24wc2SGe+u85
HY8jgCcQ70DFXoUZXwH1hQWFWZFUFLzwAAAAAAAA
--------------ms010200060709050205040603--
