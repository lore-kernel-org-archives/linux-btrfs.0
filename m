Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:38805 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaHAJ6z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Aug 2014 05:58:55 -0400
Received: from homiemail-a11.g.dreamhost.com (sub3.mail.dreamhost.com [69.163.253.7])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 5ED8C9041C
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Aug 2014 02:58:55 -0700 (PDT)
Message-ID: <53DB64CF.7060601@terrorise.me.uk>
Date: Fri, 01 Aug 2014 10:58:39 +0100
From: Frankie Fisher <frankie@terrorise.me.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: open_ctree failed on 3.16.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020106060608080208070008"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020106060608080208070008
Content-Type: multipart/mixed;
 boundary="------------050703040409050304090807"

This is a multi-part message in MIME format.
--------------050703040409050304090807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hello.

A circuit breaker failed a few times and now I can't mount my btrfs=20
volume - it fails with open_ctree failed:

[  337.004372]  [<ffffffff817865a5>] dump_stack+0x46/0x58
[  337.004375]  [<ffffffff810720ac>] warn_slowpath_common+0x8c/0xc0
[  337.004378]  [<ffffffff810720fa>] warn_slowpath_null+0x1a/0x20
[  337.004387]  [<ffffffffc04583b5>] btrfs_put_block_group+0x75/0x80 [btr=
fs]
[  337.004398]  [<ffffffffc046227d>] btrfs_free_block_groups+0xbd/0x2e0=20
[btrfs]
[  337.004410]  [<ffffffffc0470abd>] open_ctree+0x188d/0x1f70 [btrfs]
[  337.004418]  [<ffffffffc0442af1>] btrfs_fill_super.isra.84+0x81/0x130 =

[btrfs]
[  337.004422]  [<ffffffff8136d7f1>] ? disk_name+0x61/0xc0
[  337.004425]  [<ffffffff81392ab7>] ? strlcpy+0x47/0x60
[  337.004434]  [<ffffffffc04474be>] btrfs_mount+0x3ae/0x3d0 [btrfs]
[  337.004439]  [<ffffffff811e52e3>] mount_fs+0x43/0x1b0
[  337.004443]  [<ffffffff812004c6>] vfs_kern_mount+0x76/0x140
[  337.004446]  [<ffffffff81201c44>] do_new_mount+0xa4/0x1f0
[  337.004448]  [<ffffffff81202fe6>] do_mount+0x1e6/0x230
[  337.004451]  [<ffffffff812033b0>] SyS_mount+0x90/0xe0
[  337.004454]  [<ffffffff8179402d>] system_call_fastpath+0x1a/0x1f

mount -o recovery doesn't succeed, nor does mount -o recovery,ro.

I have tried the above with kernel 3.13.0 first and 3.16.0 later and the =

behaviour seems identical. This may or may not be relevant, but after I=20
initialised the filesystem by copying some files to it (with kernel=20
3.13.0), one of the files failed a checksum error. I hadn't yet compared =

the file that was written with the original to determine whether the=20
error was with the checksum or otherwise.

What are the next steps I should try? Should I try btrfs-zero-log? Or=20
should I try btrfsck? Or something else?

Regards,
Frankie Fisher

# uname -a
Linux mythtv 3.16.0-999-generic #201408010205 SMP Fri Aug 1 06:06:01 UTC =

2014 x86_64 x86_64 x86_64 GNU/Linux
# btrfs --version
Btrfs v3.12
# btrfs fi show
Label: none  uuid: beaff1b6-fb0e-4b80-8b59-74968fd51066
     Total devices 1 FS bytes used 342.01GiB
     devid    1 size 1.36TiB used 349.04GiB path /dev/sdc2

Label: none  uuid: 34d2986d-6954-4c5c-922c-799cc66cd28e
     Total devices 1 FS bytes used 112.00KiB
     devid    1 size 231.90GiB used 2.04GiB path /dev/sda2

Btrfs v3.12


--------------050703040409050304090807
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-999-generic (apw@gomeisa) (gcc versio=
n 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201408010205 SMP Fri Aug 1 06:0=
6:01 UTC 2014
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-3.16.0-999-generic roo=
t=3DUUID=3D86c5a6cb-9130-4193-8536-76051f2a1e7e ro quiet splash
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000e4000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cff7ffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000cff80000-0x00000000cff8dfff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000cff8e000-0x00000000cffcffff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000cffd0000-0x00000000cfffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000022fffffff] usa=
ble
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: System manufacturer P5QL PRO/P5QL PRO, BIOS 0803    1=
0/08/2008
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x230000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FE0000000 write-back
[    0.000000]   2 base 220000000 mask FF0000000 write-back
[    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   4 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600=
070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 8GB, type WB
[    0.000000] reg 1, base: 8GB, range: 512MB, type WB
[    0.000000] reg 2, base: 8704MB, range: 256MB, type WB
[    0.000000] reg 3, base: 3328MB, range: 256MB, type UC
[    0.000000] reg 4, base: 3584MB, range: 512MB, type UC
[    0.000000] total RAM covered: 8192M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 6  	lose cover =
RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 256MB, type WB
[    0.000000] reg 3, base: 4GB, range: 4GB, type WB
[    0.000000] reg 4, base: 8GB, range: 512MB, type WB
[    0.000000] reg 5, base: 8704MB, range: 256MB, type WB
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable =3D=3D> re=
served
[    0.000000] e820: last_pfn =3D 0xcff80 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped a=
t [ffff8800000ff780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fbe000, 0x01fbefff] PGTABLE
[    0.000000] BRK [0x01fbf000, 0x01fbffff] PGTABLE
[    0.000000] BRK [0x01fc0000, 0x01fc0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x22fe00000-0x22fffffff]
[    0.000000]  [mem 0x22fe00000-0x22fffffff] page 2M
[    0.000000] BRK [0x01fc1000, 0x01fc1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x22c000000-0x22fdfffff]
[    0.000000]  [mem 0x22c000000-0x22fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x22bffffff]
[    0.000000]  [mem 0x200000000-0x22bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xcff7ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcff7ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] BRK [0x01fc2000, 0x01fc2fff] PGTABLE
[    0.000000] BRK [0x01fc3000, 0x01fc3fff] PGTABLE
[    0.000000] cma: CMA: reserved 64 MiB at 22bc00000
[    0.000000] RAMDISK: [mem 0x35b80000-0x36db7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FBBE0 000024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 0x00000000CFF80100 00005C (v01 A_M_I_ OEMXSDT  =
10000808 MSFT 00000097)
[    0.000000] ACPI: FACP 0x00000000CFF80290 0000F4 (v03 A_M_I_ OEMFACP  =
10000808 MSFT 00000097)
[    0.000000] ACPI: DSDT 0x00000000CFF80440 008846 (v01 A1014  A1014001 =
00000001 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000CFF8E000 000040
[    0.000000] ACPI: APIC 0x00000000CFF80390 00006C (v01 A_M_I_ OEMAPIC  =
10000808 MSFT 00000097)
[    0.000000] ACPI: MCFG 0x00000000CFF80400 00003C (v01 A_M_I_ OEMMCFG  =
10000808 MSFT 00000097)
[    0.000000] ACPI: OEMB 0x00000000CFF8E040 000081 (v01 A_M_I_ AMI_OEM  =
10000808 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000CFF88C90 000038 (v01 A_M_I_ OEMHPET  =
10000808 MSFT 00000097)
[    0.000000] ACPI: OSFR 0x00000000CFF88CD0 0000B0 (v01 A_M_I_ OEMOSFR  =
10000808 MSFT 00000097)
[    0.000000] ACPI: SSDT 0x00000000CFF8EB20 000A7C (v01 DpgPmm CpuPm    =
00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000022ffffff=
f]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x22fffffff]
[    0.000000]   NODE_DATA [mem 0x22fff5000-0x22fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0008bfffff] PMD -> [ffff880223400=
000-ffff88022b3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x22fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xcff7ffff]
[    0.000000]   node   0: [mem 0x100000000-0x22fffffff]
[    0.000000] On node 0 totalpages: 2096926
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13246 pages used for memmap
[    0.000000]   DMA32 zone: 847744 pages, LIFO batch:31
[    0.000000]   Normal zone: 19456 pages used for memmap
[    0.000000]   Normal zone: 1245184 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e4000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcff80000-0xcff8dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcff8e000-0xcffcffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcffd0000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfff00000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfedfffff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4=
 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88022fc00000 s86336 r81=
92 d24256 u524288
[    0.000000] pcpu-alloc: s86336 r8192 d24256 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 2064139
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.16.0-999-gene=
ric root=3DUUID=3D86c5a6cb-9130-4193-8536-76051f2a1e7e ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - baili=
ng!
[    0.000000] Memory: 8089404K/8387704K available (7780K kernel code, 11=
18K rwdata, 3704K rodata, 1368K init, 1304K bss, 298300K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4,=
 Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D256 to nr_cpu_ids=3D4=
=2E
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D4
[    0.000000] NR_IRQS:16640 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2996.893 MHz processor
[    0.004015] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 5993.78 BogoMIPS (lpj=3D11987572)
[    0.004018] pid_max: default: 32768 minimum: 301
[    0.004027] ACPI: Core revision 20140424
[    0.011471] ACPI: All ACPI Tables successfully acquired
[    0.011773] Security Framework initialized
[    0.011790] AppArmor: AppArmor initialized
[    0.011791] Yama: becoming mindful.
[    0.012413] Dentry cache hash table entries: 1048576 (order: 11, 83886=
08 bytes)
[    0.015522] Inode-cache hash table entries: 524288 (order: 10, 4194304=
 bytes)
[    0.017044] Mount-cache hash table entries: 16384 (order: 5, 131072 by=
tes)
[    0.017056] Mountpoint-cache hash table entries: 16384 (order: 5, 1310=
72 bytes)
[    0.017397] Initializing cgroup subsys memory
[    0.017426] Initializing cgroup subsys devices
[    0.017433] Initializing cgroup subsys freezer
[    0.017436] Initializing cgroup subsys net_cls
[    0.017442] Initializing cgroup subsys blkio
[    0.017446] Initializing cgroup subsys perf_event
[    0.017449] Initializing cgroup subsys net_prio
[    0.017457] Initializing cgroup subsys hugetlb
[    0.017481] CPU: Physical Processor ID: 0
[    0.017482] CPU: Processor Core ID: 0
[    0.017484] mce: CPU supports 6 MCE banks
[    0.017491] CPU0: Thermal monitoring enabled (TM2)
[    0.017498] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.017498] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
[    0.017498] tlb_flushall_shift: -1
[    0.017587] Freeing SMP alternatives memory: 28K (ffffffff81e6f000 - f=
fffffff81e76000)
[    0.018789] ftrace: allocating 31956 entries in 125 pages
[    0.028435] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.071167] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.0=
0GHz (fam: 06, model: 0f, stepping: 0b)
[    0.072000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, =
Intel PMU driver.
[    0.072000] perf_event_intel: PEBS disabled due to CPU errata
[    0.072000] ... version:                2
[    0.072000] ... bit width:              40
[    0.072000] ... generic registers:      2
[    0.072000] ... value mask:             000000ffffffffff
[    0.072000] ... max period:             000000007fffffff
[    0.072000] ... fixed-purpose events:   3
[    0.072000] ... event mask:             0000000700000003
[    0.072000] x86: Booting SMP configuration:
[    0.072000] .... node  #0, CPUs:      #1
[    0.082685] x86: Booted up 1 node, 2 CPUs
[    0.082690] smpboot: Total of 2 processors activated (11987.57 BogoMIP=
S)
[    0.082776] NMI watchdog: enabled on all CPUs, permanently consumes on=
e hw-PMU counter.
[    0.084091] devtmpfs: initialized
[    0.088727] evm: security.selinux
[    0.088728] evm: security.SMACK64
[    0.088729] evm: security.SMACK64EXEC
[    0.088730] evm: security.SMACK64TRANSMUTE
[    0.088731] evm: security.SMACK64MMAP
[    0.088732] evm: security.ima
[    0.088733] evm: security.capability
[    0.088756] PM: Registering ACPI NVS region [mem 0xcff8e000-0xcffcffff=
] (270336 bytes)
[    0.089019] pinctrl core: initialized pinctrl subsystem
[    0.089096] regulator-dummy: no parameters
[    0.089391] RTC time:  8:48:22, date: 08/01/14
[    0.089444] NET: Registered protocol family 16
[    0.089605] cpuidle: using governor ladder
[    0.089608] cpuidle: using governor menu
[    0.089651] ACPI: bus type PCI registered
[    0.089653] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.089725] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe00000=
00-0xefffffff] (base 0xe0000000)
[    0.089727] PCI: not using MMCONFIG
[    0.089728] PCI: Using configuration type 1 for base access
[    0.092097] ACPI: Added _OSI(Module Device)
[    0.092097] ACPI: Added _OSI(Processor Device)
[    0.092097] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.092097] ACPI: Added _OSI(Processor Aggregator Device)
[    0.093777] ACPI: Executed 1 blocks of module-level executable AML cod=
e
[    0.097906] ACPI: Dynamic OEM Table Load:
[    0.097912] ACPI: SSDT 0xFFFF880220B83000 000277 (v01 DpgPmm P001Ist  =
00000011 INTL 20051117)
[    0.098190] ACPI: Dynamic OEM Table Load:
[    0.098195] ACPI: SSDT 0xFFFF880220BD9800 0004B2 (v01 PmRef  P001Cst  =
00003001 INTL 20051117)
[    0.098607] ACPI: Dynamic OEM Table Load:
[    0.098611] ACPI: SSDT 0xFFFF880220B83400 000277 (v01 DpgPmm P002Ist  =
00000012 INTL 20051117)
[    0.098868] ACPI: Dynamic OEM Table Load:
[    0.098872] ACPI: SSDT 0xFFFF880220B98900 000085 (v01 PmRef  P002Cst  =
00003000 INTL 20051117)
[    0.099179] ACPI: Interpreter enabled
[    0.099186] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S2_] (20140424/hwxface-580)
[    0.099198] ACPI: (supports S0 S1 S3 S4 S5)
[    0.099200] ACPI: Using IOAPIC for interrupt routing
[    0.099217] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe00000=
00-0xefffffff] (base 0xe0000000)
[    0.100139] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in A=
CPI motherboard resources
[    0.100497] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.105585] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.105591] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cl=
ockPM Segments MSI]
[    0.105595] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASP=
M
[    0.105802] PCI host bridge to bus 0000:00
[    0.105805] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.105807] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.105809] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.105811] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.105813] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000df=
fff]
[    0.105814] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfffff=
fff]
[    0.105822] pci 0000:00:00.0: [8086:2e20] type 00 class 0x060000
[    0.105839] DMAR: Forcing write-buffer flush capability
[    0.105840] DMAR: Disabling IOMMU for graphics on this chipset
[    0.105908] pci 0000:00:01.0: [8086:2e21] type 01 class 0x060400
[    0.105941] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.105974] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.106035] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    0.106072] pci 0000:00:1a.0: reg 0x20: [io  0xb800-0xb81f]
[    0.106143] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.106185] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    0.106221] pci 0000:00:1a.1: reg 0x20: [io  0xb880-0xb89f]
[    0.106291] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    0.106333] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    0.106369] pci 0000:00:1a.2: reg 0x20: [io  0xbc00-0xbc1f]
[    0.106439] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    0.106489] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    0.106508] pci 0000:00:1a.7: reg 0x10: [mem 0xf9fffc00-0xf9ffffff]
[    0.106586] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.106621] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    0.106666] pci 0000:00:1b.0: [8086:3a3e] type 00 class 0x040300
[    0.106681] pci 0000:00:1b.0: reg 0x10: [mem 0xf9ff8000-0xf9ffbfff 64b=
it]
[    0.106742] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.106813] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    0.106875] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.106911] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.106956] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    0.107018] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.107054] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.107095] pci 0000:00:1c.5: [8086:3a4a] type 01 class 0x060400
[    0.107157] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.107193] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.107235] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    0.107271] pci 0000:00:1d.0: reg 0x20: [io  0xb080-0xb09f]
[    0.107341] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.107385] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    0.107421] pci 0000:00:1d.1: reg 0x20: [io  0xb400-0xb41f]
[    0.107490] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.107532] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    0.107568] pci 0000:00:1d.2: reg 0x20: [io  0xb480-0xb49f]
[    0.107638] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.107687] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    0.107706] pci 0000:00:1d.7: reg 0x10: [mem 0xf9fff800-0xf9fffbff]
[    0.107783] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.107819] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.107864] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.107927] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.107971] pci 0000:00:1f.0: [8086:3a18] type 00 class 0x060100
[    0.108120] pci 0000:00:1f.2: [8086:3a20] type 00 class 0x01018f
[    0.108133] pci 0000:00:1f.2: reg 0x10: [io  0xa000-0xa007]
[    0.108140] pci 0000:00:1f.2: reg 0x14: [io  0x9c00-0x9c03]
[    0.108147] pci 0000:00:1f.2: reg 0x18: [io  0x9880-0x9887]
[    0.108153] pci 0000:00:1f.2: reg 0x1c: [io  0x9800-0x9803]
[    0.108160] pci 0000:00:1f.2: reg 0x20: [io  0x9480-0x948f]
[    0.108166] pci 0000:00:1f.2: reg 0x24: [io  0x9400-0x940f]
[    0.108254] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    0.108267] pci 0000:00:1f.3: reg 0x10: [mem 0xf9fff400-0xf9fff4ff 64b=
it]
[    0.108284] pci 0000:00:1f.3: reg 0x20: [io  0x0400-0x041f]
[    0.108361] pci 0000:00:1f.5: [8086:3a26] type 00 class 0x010185
[    0.108373] pci 0000:00:1f.5: reg 0x10: [io  0xb000-0xb007]
[    0.108380] pci 0000:00:1f.5: reg 0x14: [io  0xac00-0xac03]
[    0.108387] pci 0000:00:1f.5: reg 0x18: [io  0xa880-0xa887]
[    0.108393] pci 0000:00:1f.5: reg 0x1c: [io  0xa800-0xa803]
[    0.108400] pci 0000:00:1f.5: reg 0x20: [io  0xa480-0xa48f]
[    0.108407] pci 0000:00:1f.5: reg 0x24: [io  0xa400-0xa40f]
[    0.108532] pci 0000:01:00.0: [10de:0614] type 00 class 0x030000
[    0.108542] pci 0000:01:00.0: reg 0x10: [mem 0xfd000000-0xfdffffff]
[    0.108552] pci 0000:01:00.0: reg 0x14: [mem 0xd0000000-0xdfffffff 64b=
it pref]
[    0.108561] pci 0000:01:00.0: reg 0x1c: [mem 0xfa000000-0xfbffffff 64b=
it]
[    0.108567] pci 0000:01:00.0: reg 0x24: [io  0xcc00-0xcc7f]
[    0.108574] pci 0000:01:00.0: reg 0x30: [mem 0xfe9e0000-0xfe9fffff pre=
f]
[    0.108652] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.108655] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    0.108658] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfe9fff=
ff]
[    0.108661] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffff=
ff 64bit pref]
[    0.108708] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    0.108716] pci 0000:00:1c.0:   bridge window [mem 0xf8f00000-0xf8ffff=
ff 64bit pref]
[    0.108779] pci 0000:03:00.0: [11ab:6101] type 00 class 0x01018f
[    0.108796] pci 0000:03:00.0: reg 0x10: [io  0xec00-0xec07]
[    0.108807] pci 0000:03:00.0: reg 0x14: [io  0xe880-0xe883]
[    0.108818] pci 0000:03:00.0: reg 0x18: [io  0xe800-0xe807]
[    0.108828] pci 0000:03:00.0: reg 0x1c: [io  0xe480-0xe483]
[    0.108839] pci 0000:03:00.0: reg 0x20: [io  0xe400-0xe40f]
[    0.108850] pci 0000:03:00.0: reg 0x24: [mem 0xfebffc00-0xfebffdff]
[    0.108912] pci 0000:03:00.0: supports D1
[    0.108913] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.108964] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.108972] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    0.108975] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.108979] pci 0000:00:1c.4:   bridge window [mem 0xfeb00000-0xfebfff=
ff]
[    0.109046] pci 0000:02:00.0: [1969:1026] type 00 class 0x020000
[    0.109069] pci 0000:02:00.0: reg 0x10: [mem 0xfeac0000-0xfeafffff 64b=
it]
[    0.109081] pci 0000:02:00.0: reg 0x18: [io  0xdc00-0xdc7f]
[    0.109175] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.109227] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.109235] pci 0000:00:1c.5: PCI bridge to [bus 02]
[    0.109239] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.109242] pci 0000:00:1c.5:   bridge window [mem 0xfea00000-0xfeafff=
ff]
[    0.109310] pci 0000:00:1e.0: PCI bridge to [bus 05] (subtractive deco=
de)
[    0.109318] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (sub=
tractive decode)
[    0.109320] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (sub=
tractive decode)
[    0.109321] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bff=
ff] (subtractive decode)
[    0.109323] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dff=
ff] (subtractive decode)
[    0.109325] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xffffff=
ff] (subtractive decode)
[    0.109880] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 =
14 15)
[    0.109925] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 =
14 15)
[    0.109967] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 1=
4 *15)
[    0.110010] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 =
14 15)
[    0.110052] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 1=
4 15) *0, disabled.
[    0.110095] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 *=
14 15)
[    0.110138] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 =
14 15)
[    0.110180] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 =
14 15)
[    0.110233] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.110311] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.110311] vgaarb: loaded
[    0.110311] vgaarb: bridge control possible 0000:01:00.0
[    0.110311] SCSI subsystem initialized
[    0.110311] libata version 3.00 loaded.
[    0.110311] ACPI: bus type USB registered
[    0.110311] usbcore: registered new interface driver usbfs
[    0.110311] usbcore: registered new interface driver hub
[    0.110311] usbcore: registered new device driver usb
[    0.110311] PCI: Using ACPI for IRQ routing
[    0.115768] PCI: pci_cache_line_size set to 64 bytes
[    0.115815] e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
[    0.115817] e820: reserve RAM buffer [mem 0xcff80000-0xcfffffff]
[    0.115933] NetLabel: Initializing
[    0.115934] NetLabel:  domain hash size =3D 128
[    0.115935] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.115948] NetLabel:  unlabeled traffic allowed by default
[    0.116009] HPET: 4 timers in total, 0 timers will be used for per-cpu=
 timer
[    0.116013] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.116016] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.118031] Switched to clocksource hpet
[    0.122392] AppArmor: AppArmor Filesystem Enabled
[    0.122435] pnp: PnP ACPI init
[    0.122453] ACPI: bus type PNP registered
[    0.122545] system 00:00: [mem 0xfed14000-0xfed19fff] has been reserve=
d
[    0.122549] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    0.122620] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.122780] system 00:02: [io  0x0290-0x029f] has been reserved
[    0.122783] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.122905] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    0.122908] system 00:03: [io  0x0800-0x087f] could not be reserved
[    0.122910] system 00:03: [io  0x0500-0x057f] has been reserved
[    0.122912] system 00:03: [mem 0xfed08000-0xfed08fff] has been reserve=
d
[    0.122914] system 00:03: [mem 0xfed1c000-0xfed1ffff] has been reserve=
d
[    0.122917] system 00:03: [mem 0xfed20000-0xfed3ffff] has been reserve=
d
[    0.122919] system 00:03: [mem 0xfed50000-0xfed8ffff] has been reserve=
d
[    0.122921] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.123013] system 00:04: [mem 0xffc00000-0xffefffff] has been reserve=
d
[    0.123016] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.123122] system 00:05: [mem 0xfec00000-0xfec00fff] could not be res=
erved
[    0.123124] system 00:05: [mem 0xfee00000-0xfee00fff] has been reserve=
d
[    0.123127] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.123270] system 00:06: [mem 0xe0000000-0xefffffff] has been reserve=
d
[    0.123273] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.123412] system 00:07: [mem 0x00000000-0x0009ffff] could not be res=
erved
[    0.123414] system 00:07: [mem 0x000c0000-0x000cffff] could not be res=
erved
[    0.123416] system 00:07: [mem 0x000e0000-0x000fffff] could not be res=
erved
[    0.123419] system 00:07: [mem 0x00100000-0xcfffffff] could not be res=
erved
[    0.123421] system 00:07: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    0.123516] pnp: PnP ACPI: found 8 devices
[    0.123517] ACPI: bus type PNP unregistered
[    0.130112] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bu=
s 04] add_size 1000
[    0.130116] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff=
] to [bus 04] add_size 400000
[    0.130123] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff=
 64bit pref] to [bus 03] add_size 200000
[    0.130130] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff=
 64bit pref] to [bus 02] add_size 200000
[    0.130140] pci 0000:00:1c.0: res[14]=3D[mem 0x00100000-0x000fffff] ge=
t_res_add_size add_size 400000
[    0.130142] pci 0000:00:1c.4: res[15]=3D[mem 0x00100000-0x000fffff 64b=
it pref] get_res_add_size add_size 200000
[    0.130144] pci 0000:00:1c.5: res[15]=3D[mem 0x00100000-0x000fffff 64b=
it pref] get_res_add_size add_size 200000
[    0.130146] pci 0000:00:1c.0: res[13]=3D[io  0x1000-0x0fff] get_res_ad=
d_size add_size 1000
[    0.130151] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf0000000-0xf03ff=
fff]
[    0.130156] pci 0000:00:1c.4: BAR 15: assigned [mem 0xf0400000-0xf05ff=
fff 64bit pref]
[    0.130160] pci 0000:00:1c.5: BAR 15: assigned [mem 0xf0600000-0xf07ff=
fff 64bit pref]
[    0.130162] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.130165] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.130167] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    0.130170] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfe9fff=
ff]
[    0.130173] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffff=
ff 64bit pref]
[    0.130176] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    0.130178] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.130182] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf03fff=
ff]
[    0.130185] pci 0000:00:1c.0:   bridge window [mem 0xf8f00000-0xf8ffff=
ff 64bit pref]
[    0.130190] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    0.130192] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.130196] pci 0000:00:1c.4:   bridge window [mem 0xfeb00000-0xfebfff=
ff]
[    0.130199] pci 0000:00:1c.4:   bridge window [mem 0xf0400000-0xf05fff=
ff 64bit pref]
[    0.130204] pci 0000:00:1c.5: PCI bridge to [bus 02]
[    0.130206] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.130210] pci 0000:00:1c.5:   bridge window [mem 0xfea00000-0xfeafff=
ff]
[    0.130214] pci 0000:00:1c.5:   bridge window [mem 0xf0600000-0xf07fff=
ff 64bit pref]
[    0.130218] pci 0000:00:1e.0: PCI bridge to [bus 05]
[    0.130227] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.130229] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.130231] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.130233] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.130235] pci_bus 0000:00: resource 8 [mem 0xd0000000-0xffffffff]
[    0.130237] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    0.130238] pci_bus 0000:01: resource 1 [mem 0xfa000000-0xfe9fffff]
[    0.130240] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64b=
it pref]
[    0.130242] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.130244] pci_bus 0000:04: resource 1 [mem 0xf0000000-0xf03fffff]
[    0.130246] pci_bus 0000:04: resource 2 [mem 0xf8f00000-0xf8ffffff 64b=
it pref]
[    0.130247] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.130249] pci_bus 0000:03: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.130251] pci_bus 0000:03: resource 2 [mem 0xf0400000-0xf05fffff 64b=
it pref]
[    0.130253] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.130254] pci_bus 0000:02: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.130256] pci_bus 0000:02: resource 2 [mem 0xf0600000-0xf07fffff 64b=
it pref]
[    0.130258] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.130260] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.130262] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.130263] pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000dffff]
[    0.130265] pci_bus 0000:05: resource 8 [mem 0xd0000000-0xffffffff]
[    0.130295] NET: Registered protocol family 2
[    0.130498] TCP established hash table entries: 65536 (order: 7, 52428=
8 bytes)
[    0.130713] TCP bind hash table entries: 65536 (order: 8, 1048576 byte=
s)
[    0.130983] TCP: Hash tables configured (established 65536 bind 65536)=

[    0.131018] TCP: reno registered
[    0.131030] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.131074] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)=

[    0.131174] NET: Registered protocol family 1
[    1.756024] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01=
010001
[    1.756221] pci 0000:01:00.0: Boot video device
[    1.756236] PCI: CLS 32 bytes, default 64
[    1.756311] Trying to unpack rootfs image as initramfs...
[    2.035894] Freeing initrd memory: 18656K (ffff880035b80000 - ffff8800=
36db8000)
[    2.035960] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.035965] software IO TLB [mem 0xcbf80000-0xcff80000] (64MB) mapped =
at [ffff8800cbf80000-ffff8800cff7ffff]
[    2.036197] microcode: CPU0 sig=3D0x6fb, pf=3D0x1, revision=3D0xb6
[    2.036202] microcode: CPU1 sig=3D0x6fb, pf=3D0x1, revision=3D0xb6
[    2.036276] microcode: Microcode Update Driver: v2.00 <tigran@aivazian=
=2Efsnet.co.uk>, Peter Oruba
[    2.036304] Scanning for low memory corruption every 60 seconds
[    2.036600] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    2.036632] Initialise system trusted keyring
[    2.036654] audit: initializing netlink subsys (disabled)
[    2.036681] audit: type=3D2000 audit(1406882904.036:1): initialized
[    2.036987] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.038732] zbud: loaded
[    2.038864] VFS: Disk quotas dquot_6.5.2
[    2.038906] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.039436] fuse init (API version 7.23)
[    2.039528] msgmni has been set to 15964
[    2.039588] Key type big_key registered
[    2.039900] Key type asymmetric registered
[    2.039904] Asymmetric key parser 'x509' registered
[    2.039943] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 252)
[    2.039981] io scheduler noop registered
[    2.039984] io scheduler deadline registered (default)
[    2.040051] io scheduler cfq registered
[    2.040252] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    2.040296] pcieport 0000:00:1c.0: enabling device (0106 -> 0107)
[    2.040356] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    2.040470] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    2.040583] pcieport 0000:00:1c.5: irq 43 for MSI/MSI-X
[    2.040662] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.040679] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    2.040741] intel_idle: does not run on family 6 model 15
[    2.040829] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PN=
P0C0C:00/input/input0
[    2.040834] ACPI: Power Button [PWRB]
[    2.040876] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input1
[    2.040878] ACPI: Power Button [PWRF]
[    2.041160] Monitor-Mwait will be used to enter C-1 state
[    2.041164] Monitor-Mwait will be used to enter C-2 state
[    2.041167] tsc: Marking TSC unstable due to TSC halts in idle
[    2.041172] ACPI: acpi_idle registered with cpuidle
[    2.041598] GHES: HEST is not enabled!
[    2.041691] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    2.043407] Linux agpgart interface v0.103
[    2.044900] brd: module loaded
[    2.045608] loop: module loaded
[    2.045746] ata_piix 0000:00:1f.2: version 2.13
[    2.045810] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    2.047061] scsi0 : ata_piix
[    2.047190] scsi1 : ata_piix
[    2.047240] ata1: SATA max UDMA/133 cmd 0xa000 ctl 0x9c00 bmdma 0x9480=
 irq 19
[    2.047244] ata2: SATA max UDMA/133 cmd 0x9880 ctl 0x9800 bmdma 0x9488=
 irq 19
[    2.047325] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    2.048307] scsi2 : ata_piix
[    2.048406] scsi3 : ata_piix
[    2.048449] ata3: SATA max UDMA/133 cmd 0xb000 ctl 0xac00 bmdma 0xa480=
 irq 19
[    2.048451] ata4: SATA max UDMA/133 cmd 0xa880 ctl 0xa800 bmdma 0xa488=
 irq 19
[    2.048578] libphy: Fixed MDIO Bus: probed
[    2.048581] tun: Universal TUN/TAP device driver, 1.6
[    2.048583] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.048637] PPP generic driver version 2.4.2
[    2.048684] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    2.048689] ehci-pci: EHCI PCI platform driver
[    2.048770] ehci-pci 0000:00:1a.7: EHCI Host Controller
[    2.048777] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bu=
s number 1
[    2.048790] ehci-pci 0000:00:1a.7: debug port 1
[    2.052906] ehci-pci 0000:00:1a.7: cache line size of 32 is not suppor=
ted
[    2.052939] ehci-pci 0000:00:1a.7: irq 18, io mem 0xf9fffc00
[    2.068023] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.068091] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.068095] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.068097] usb usb1: Product: EHCI Host Controller
[    2.068100] usb usb1: Manufacturer: Linux 3.16.0-999-generic ehci_hcd
[    2.068102] usb usb1: SerialNumber: 0000:00:1a.7
[    2.068252] hub 1-0:1.0: USB hub found
[    2.068259] hub 1-0:1.0: 6 ports detected
[    2.068470] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    2.068477] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bu=
s number 2
[    2.068488] ehci-pci 0000:00:1d.7: debug port 1
[    2.072620] ehci-pci 0000:00:1d.7: cache line size of 32 is not suppor=
ted
[    2.072632] ehci-pci 0000:00:1d.7: irq 23, io mem 0xf9fff800
[    2.084022] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.084064] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.084068] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.084070] usb usb2: Product: EHCI Host Controller
[    2.084073] usb usb2: Manufacturer: Linux 3.16.0-999-generic ehci_hcd
[    2.084075] usb usb2: SerialNumber: 0000:00:1d.7
[    2.084220] hub 2-0:1.0: USB hub found
[    2.084232] hub 2-0:1.0: 6 ports detected
[    2.084373] ehci-platform: EHCI generic platform driver
[    2.084384] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.084389] ohci-platform: OHCI generic platform driver
[    2.084400] uhci_hcd: USB Universal Host Controller Interface driver
[    2.084468] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.084474] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bu=
s number 3
[    2.084480] uhci_hcd 0000:00:1a.0: detected 2 ports
[    2.084503] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b800
[    2.084541] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.084543] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.084545] usb usb3: Product: UHCI Host Controller
[    2.084547] usb usb3: Manufacturer: Linux 3.16.0-999-generic uhci_hcd
[    2.084549] usb usb3: SerialNumber: 0000:00:1a.0
[    2.084647] hub 3-0:1.0: USB hub found
[    2.084653] hub 3-0:1.0: 2 ports detected
[    2.084792] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.084798] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bu=
s number 4
[    2.084805] uhci_hcd 0000:00:1a.1: detected 2 ports
[    2.084829] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b880
[    2.084866] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.084868] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.084870] usb usb4: Product: UHCI Host Controller
[    2.084872] usb usb4: Manufacturer: Linux 3.16.0-999-generic uhci_hcd
[    2.084873] usb usb4: SerialNumber: 0000:00:1a.1
[    2.084971] hub 4-0:1.0: USB hub found
[    2.084977] hub 4-0:1.0: 2 ports detected
[    2.085113] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    2.085119] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bu=
s number 5
[    2.085124] uhci_hcd 0000:00:1a.2: detected 2 ports
[    2.085140] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000bc00
[    2.085178] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.085180] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.085182] usb usb5: Product: UHCI Host Controller
[    2.085183] usb usb5: Manufacturer: Linux 3.16.0-999-generic uhci_hcd
[    2.085185] usb usb5: SerialNumber: 0000:00:1a.2
[    2.085280] hub 5-0:1.0: USB hub found
[    2.085288] hub 5-0:1.0: 2 ports detected
[    2.085427] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.085432] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bu=
s number 6
[    2.085437] uhci_hcd 0000:00:1d.0: detected 2 ports
[    2.085453] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b080
[    2.085493] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.085495] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.085497] usb usb6: Product: UHCI Host Controller
[    2.085499] usb usb6: Manufacturer: Linux 3.16.0-999-generic uhci_hcd
[    2.085500] usb usb6: SerialNumber: 0000:00:1d.0
[    2.085595] hub 6-0:1.0: USB hub found
[    2.085601] hub 6-0:1.0: 2 ports detected
[    2.085739] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.085744] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bu=
s number 7
[    2.085750] uhci_hcd 0000:00:1d.1: detected 2 ports
[    2.085765] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b400
[    2.085803] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.085805] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.085807] usb usb7: Product: UHCI Host Controller
[    2.085808] usb usb7: Manufacturer: Linux 3.16.0-999-generic uhci_hcd
[    2.085810] usb usb7: SerialNumber: 0000:00:1d.1
[    2.085908] hub 7-0:1.0: USB hub found
[    2.085913] hub 7-0:1.0: 2 ports detected
[    2.086052] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.086058] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bu=
s number 8
[    2.086063] uhci_hcd 0000:00:1d.2: detected 2 ports
[    2.086080] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b480
[    2.086117] usb usb8: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.086119] usb usb8: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.086121] usb usb8: Product: UHCI Host Controller
[    2.086123] usb usb8: Manufacturer: Linux 3.16.0-999-generic uhci_hcd
[    2.086124] usb usb8: SerialNumber: 0000:00:1d.2
[    2.086220] hub 8-0:1.0: USB hub found
[    2.086226] hub 8-0:1.0: 2 ports detected
[    2.086365] i8042: PNP: No PS/2 controller found. Probing ports direct=
ly.
[    2.088860] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.088865] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.089003] mousedev: PS/2 mouse device common for all mice
[    2.089148] rtc_cmos 00:01: RTC can wake from S4
[    2.089264] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    2.089286] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvr=
am, hpet irqs
[    2.089364] device-mapper: uevent: version 1.0.3
[    2.089438] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialise=
d: dm-devel@redhat.com
[    2.089453] ledtrig-cpu: registered to indicate activity on CPUs
[    2.089541] TCP: cubic registered
[    2.089666] NET: Registered protocol family 10
[    2.089856] NET: Registered protocol family 17
[    2.089866] Key type dns_resolver registered
[    2.090133] Loading compiled-in X.509 certificates
[    2.090980] Loaded X.509 cert 'Magrathea: Glacier signing key: f4aa321=
4c71e169f5b9e56590d025bb5152dd9a3'
[    2.090996] registered taskstats version 1
[    2.092862] Key type trusted registered
[    2.094308] Key type encrypted registered
[    2.095816] AppArmor: AppArmor sha1 policy hashing enabled
[    2.095820] ima: No TPM chip found, activating TPM-bypass!
[    2.095838] evm: HMAC attrs: 0x1
[    2.096148]   Magic number: 10:719:825
[    2.096261] rtc_cmos 00:01: setting system clock to 2014-08-01 08:48:2=
4 UTC (1406882904)
[    2.096795] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.096796] EDD information not available.
[    2.096856] PM: Hibernation image not present or could not be loaded.
[    2.382596] ata3: SATA link down (SStatus 0 SControl 300)
[    2.382602] usb 1-6: new high-speed USB device number 2 using ehci-pci=

[    2.516107] usb 1-6: New USB device found, idVendor=3D1b80, idProduct=3D=
e409
[    2.516110] usb 1-6: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    2.516112] usb 1-6: Product: DVB-T TV Stick
[    2.516113] usb 1-6: Manufacturer: ITE Technologies, Inc.
[    2.524048] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.532299] ata4.00: ATA-8: WDC WD20EARX-00PASB0, 51.0AB51, max UDMA/1=
33
[    2.532302] ata4.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 0/=
32)
[    2.540321] ata4.00: configured for UDMA/133
[    2.840067] ata1.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.840079] ata1.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.848169] ata2.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.848181] ata2.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.857166] ata1.00: ATA-7: Maxtor 7L250S0, BACE1G10, max UDMA/133
[    2.857170] ata1.00: 488281250 sectors, multi 16: LBA48 NCQ (depth 0/3=
2)
[    2.857176] ata1.01: ATAPI: ATAPI   iHAS124   E, 4L04, max UDMA/100
[    2.868032] usb 6-1: new low-speed USB device number 2 using uhci_hcd
[    2.873092] ata1.00: configured for UDMA/133
[    2.873550] ata2.00: ATA-7: WDC WD5000AAKS-00TMA0, 12.01C01, max UDMA/=
133
[    2.873553] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/3=
2)
[    2.873693] ata2.01: ATA-8: WDC WD1501FASS-00U0B0, 01.00101, max UDMA/=
133
[    2.873696] ata2.01: 2930277168 sectors, multi 16: LBA48 NCQ (depth 0/=
32)
[    2.888195] ata1.01: configured for UDMA/100
[    2.888861] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 7L250S0   =
1G10 PQ: 0 ANSI: 5
[    2.889046] sd 0:0:0:0: [sda] 488281250 512-byte logical blocks: (250 =
GB/232 GiB)
[    2.889067] ata2.00: configured for UDMA/133
[    2.889089] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.889886] scsi 0:0:1:0: CD-ROM            ATAPI    iHAS124   E      =
4L04 PQ: 0 ANSI: 5
[    2.896267] ata2.01: configured for UDMA/133
[    2.899419] sd 0:0:0:0: [sda] Write Protect is off
[    2.899423] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.899452] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    2.906410] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form=
2 cdda tray
[    2.906413] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.906546] sr 0:0:1:0: Attached scsi CD-ROM sr0
[    2.906618] sr 0:0:1:0: Attached scsi generic sg1 type 5
[    2.906712] scsi 1:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 =
1C01 PQ: 0 ANSI: 5
[    2.906843] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 =
GB/465 GiB)
[    2.906868] sd 1:0:0:0: Attached scsi generic sg2 type 0
[    2.906885] sd 1:0:0:0: [sdb] Write Protect is off
[    2.906887] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.906906] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    2.906933] scsi 1:0:1:0: Direct-Access     ATA      WDC WD1501FASS-0 =
0101 PQ: 0 ANSI: 5
[    2.907087] sd 1:0:1:0: Attached scsi generic sg3 type 0
[    2.907166] scsi 3:0:0:0: Direct-Access     ATA      WDC WD20EARX-00P =
AB51 PQ: 0 ANSI: 5
[    2.907295] sd 3:0:0:0: [sdd] 3907029168 512-byte logical blocks: (2.0=
0 TB/1.81 TiB)
[    2.907297] sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    2.907323] sd 3:0:0:0: Attached scsi generic sg4 type 0
[    2.907329] sd 3:0:0:0: [sdd] Write Protect is off
[    2.907332] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.907346] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    2.912214] sd 1:0:1:0: [sdc] 2930277168 512-byte logical blocks: (1.5=
0 TB/1.36 TiB)
[    2.933575]  sdb: sdb1 sdb2 < sdb5 >
[    2.933610] sd 1:0:1:0: [sdc] Write Protect is off
[    2.933614] sd 1:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[    2.933641] sd 1:0:1:0: [sdc] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    2.933917] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.938347]  sda: sda1 sda2
[    2.938600] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.946638]  sdc: sdc1 sdc2 sdc3
[    2.946983] sd 1:0:1:0: [sdc] Attached SCSI disk
[    3.036491] usb 6-1: New USB device found, idVendor=3D192f, idProduct=3D=
0916
[    3.036494] usb 6-1: New USB device strings: Mfr=3D0, Product=3D2, Ser=
ialNumber=3D0
[    3.036497] usb 6-1: Product: USB Optical Mouse
[    3.276034] usb 7-2: new low-speed USB device number 2 using uhci_hcd
[    3.346599]  sdd: sdd1 sdd2
[    3.346860] sd 3:0:0:0: [sdd] Attached SCSI disk
[    3.348115] Freeing unused kernel memory: 1368K (ffffffff81d19000 - ff=
ffffff81e6f000)
[    3.348117] Write protecting the kernel read-only data: 12288k
[    3.349160] Freeing unused kernel memory: 400K (ffff88000179c000 - fff=
f880001800000)
[    3.350078] Freeing unused kernel memory: 392K (ffff880001b9e000 - fff=
f880001c00000)
[    3.359435] systemd-udevd[118]: starting version 204
[    3.391698] scsi4 : pata_marvell
[    3.391786] scsi5 : pata_marvell
[    3.391830] ata5: PATA max UDMA/100 cmd 0xec00 ctl 0xe880 bmdma 0xe400=
 irq 16
[    3.391831] ata6: DUMMY
[    3.398026] hidraw: raw HID events driver (C) Jiri Kosina
[    3.413690] usbcore: registered new interface driver usbhid
[    3.413693] usbhid: USB HID core driver
[    3.443149] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d=
=2E0/usb6/6-1/6-1:1.0/0003:192F:0916.0001/input/input5
[    3.443259] hid-generic 0003:192F:0916.0001: input,hidraw0: USB HID v1=
=2E11 Mouse [USB Optical Mouse] on usb-0000:00:1d.0-1/input0
[    3.450810] usb 7-2: New USB device found, idVendor=3D04f2, idProduct=3D=
0116
[    3.450813] usb 7-2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    3.450815] usb 7-2: Product: USB Keyboard
[    3.450817] usb 7-2: Manufacturer: CHICONY
[    3.469391] input: CHICONY USB Keyboard as /devices/pci0000:00/0000:00=
:1d.1/usb7/7-2/7-2:1.0/0003:04F2:0116.0002/input/input6
[    3.469477] hid-generic 0003:04F2:0116.0002: input,hidraw1: USB HID v1=
=2E10 Keyboard [CHICONY USB Keyboard] on usb-0000:00:1d.1-2/input0
[    3.645419] random: nonblocking pool is initialized
[    3.912017] raid6: sse2x1    5080 MB/s
[    3.980007] raid6: sse2x2    6980 MB/s
[    4.048013] raid6: sse2x4    9026 MB/s
[    4.048014] raid6: using algorithm sse2x4 (9026 MB/s)
[    4.048016] raid6: using ssse3x2 recovery algorithm
[    4.049140] xor: measuring software checksum speed
[    4.088008]    prefetch64-sse: 12341.000 MB/sec
[    4.128007]    generic_sse: 10900.000 MB/sec
[    4.128009] xor: using function: prefetch64-sse (12341.000 MB/sec)
[    4.140270] Btrfs loaded
[    4.297723] BTRFS: device fsid 34d2986d-6954-4c5c-922c-799cc66cd28e de=
vid 1 transid 4 /dev/sda2
[    4.326377] BTRFS: device fsid beaff1b6-fb0e-4b80-8b59-74968fd51066 de=
vid 1 transid 2105 /dev/sdc2
[    4.385246] EXT4-fs (sdb1): mounted filesystem with ordered data mode.=
 Opts: (null)
[    6.412033] floppy0: no floppy controllers found
[    8.821181] init: ureadahead main process (183) terminated with status=
 5
[    9.957790] Adding 2996084k swap on /dev/sdb5.  Priority:-1 extents:1 =
across:2996084k FS
[    9.974091] Adding 1535996k swap on /dev/sdc1.  Priority:-2 extents:1 =
across:1535996k FS
[    9.976359] Adding 1023996k swap on /dev/sdd2.  Priority:-3 extents:1 =
across:1023996k FS
[   12.965158] systemd-udevd[327]: starting version 204
[   13.305893] EXT4-fs (sdb1): re-mounted. Opts: errors=3Dremount-ro
[   13.716310] EXT4-fs (sdd1): mounted filesystem with ordered data mode.=
 Opts: errors=3Dremount-ro
[   13.731968] EXT4-fs (sdc3): mounting ext2 file system using the ext4 s=
ubsystem
[   13.798333] EXT4-fs (sdc3): mounted filesystem without journal. Opts: =
errors=3Dremount-ro
[   14.396893] lp: driver loaded but no devices found
[   14.568100] coretemp coretemp.0: Using relative temperature scale!
[   14.568113] coretemp coretemp.0: Using relative temperature scale!
[   14.723841] w83627ehf: Found W83667HG chip at 0x290
[   14.723888] ACPI Warning: SystemIO range 0x0000000000000295-0x00000000=
00000296 conflicts with OpRegion 0x0000000000000290-0x0000000000000299 (\=
_SB_.PCI0.SBRG.SIOR.HWRE) (20140424/utaddress-258)
[   14.723893] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   14.737421] w83627ehf: Found W83667HG chip at 0x290
[   14.737469] ACPI Warning: SystemIO range 0x0000000000000295-0x00000000=
00000296 conflicts with OpRegion 0x0000000000000290-0x0000000000000299 (\=
_SB_.PCI0.SBRG.SIOR.HWRE) (20140424/utaddress-258)
[   14.737474] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   14.767763] w83627ehf: Found W83667HG chip at 0x290
[   14.767804] ACPI Warning: SystemIO range 0x0000000000000295-0x00000000=
00000296 conflicts with OpRegion 0x0000000000000290-0x0000000000000299 (\=
_SB_.PCI0.SBRG.SIOR.HWRE) (20140424/utaddress-258)
[   14.767809] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   15.100128] FS-Cache: Loaded
[   15.170786] RPC: Registered named UNIX socket transport module.
[   15.170790] RPC: Registered udp transport module.
[   15.170791] RPC: Registered tcp transport module.
[   15.170792] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   15.386768] FS-Cache: Netfs 'nfs' registered for caching
[   15.745919] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   17.581388] ACPI Warning: SystemIO range 0x0000000000000828-0x00000000=
0000082f conflicts with OpRegion 0x0000000000000800-0x000000000000084f (\=
PMRG) (20140424/utaddress-258)
[   17.581395] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   17.581398] ACPI Warning: SystemIO range 0x0000000000000530-0x00000000=
0000053f conflicts with OpRegion 0x0000000000000500-0x000000000000053f (\=
GPS0) (20140424/utaddress-258)
[   17.581401] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   17.581403] ACPI Warning: SystemIO range 0x0000000000000500-0x00000000=
0000052f conflicts with OpRegion 0x0000000000000500-0x000000000000053f (\=
GPS0) (20140424/utaddress-258)
[   17.581406] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   17.581407] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   17.798269] [drm] Initialized drm 1.1.0 20060810
[   18.786624] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[   18.936544] sound hdaudioC0D0: autoconfig: line_outs=3D4 (0x14/0x15/0x=
16/0x17/0x0) type:line
[   18.936548] sound hdaudioC0D0:    speaker_outs=3D0 (0x0/0x0/0x0/0x0/0x=
0)
[   18.936550] sound hdaudioC0D0:    hp_outs=3D1 (0x1b/0x0/0x0/0x0/0x0)
[   18.936552] sound hdaudioC0D0:    mono: mono_out=3D0x0
[   18.936554] sound hdaudioC0D0:    dig-out=3D0x11/0x1e
[   18.936555] sound hdaudioC0D0:    inputs:
[   18.936558] sound hdaudioC0D0:      Front Mic=3D0x19
[   18.936560] sound hdaudioC0D0:      Rear Mic=3D0x18
[   18.936561] sound hdaudioC0D0:      Line=3D0x1a
[   18.948679] input: HDA Intel Front Mic as /devices/pci0000:00/0000:00:=
1b.0/sound/card0/input7
[   18.948753] input: HDA Intel Rear Mic as /devices/pci0000:00/0000:00:1=
b.0/sound/card0/input8
[   18.948822] input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/=
sound/card0/input9
[   18.948901] input: HDA Intel Line Out Front as /devices/pci0000:00/000=
0:00:1b.0/sound/card0/input10
[   18.948971] input: HDA Intel Line Out Surround as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input11
[   18.949040] input: HDA Intel Line Out CLFE as /devices/pci0000:00/0000=
:00:1b.0/sound/card0/input12
[   18.949110] input: HDA Intel Line Out Side as /devices/pci0000:00/0000=
:00:1b.0/sound/card0/input13
[   18.949179] input: HDA Intel Front Headphone as /devices/pci0000:00/00=
00:00:1b.0/sound/card0/input14
[   19.568493] usb 1-6: dvb_usb_af9035: prechip_version=3D83 chip_version=
=3D01 chip_type=3D9135
[   19.568864] usb 1-6: dvb_usb_v2: found a 'Kworld UB499-2T T09' in cold=
 state
[   19.848192] usb 1-6: Direct firmware load failed with error -2
[   19.848196] usb 1-6: Falling back to user helper
[   19.916526] usb 1-6: dvb_usb_v2: Did not find the firmware file 'dvb-u=
sb-it9135-01.fw'. Please see linux/Documentation/dvb/ for more details on=
 firmware-problems. Status -12
[   19.916583] dvb_usb_af9035: probe of 1-6:1.0 failed with error -12
[   19.916605] usbcore: registered new interface driver dvb_usb_af9035
[   20.468050] floppy0: no floppy controllers found
[   20.776622] init: avahi-cups-reload main process (686) terminated with=
 status 1
[   20.821197] audit: type=3D1400 audit(1406882923.219:2): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/sbin/dhclient" pid=3D603 comm=3D=
"apparmor_parser"
[   20.821337] audit: type=3D1400 audit(1406882923.219:3): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/usr/lib/NetworkManager/nm-dhcp-=
client.action" pid=3D603 comm=3D"apparmor_parser"
[   20.821441] audit: type=3D1400 audit(1406882923.219:4): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/usr/lib/connman/scripts/dhclien=
t-script" pid=3D603 comm=3D"apparmor_parser"
[   20.856263] audit: type=3D1400 audit(1406882923.255:5): apparmor=3D"ST=
ATUS" operation=3D"profile_replace" name=3D"/sbin/dhclient" pid=3D576 com=
m=3D"apparmor_parser"
[   20.856397] audit: type=3D1400 audit(1406882923.255:6): apparmor=3D"ST=
ATUS" operation=3D"profile_replace" name=3D"/usr/lib/NetworkManager/nm-dh=
cp-client.action" pid=3D576 comm=3D"apparmor_parser"
[   20.856495] audit: type=3D1400 audit(1406882923.255:7): apparmor=3D"ST=
ATUS" operation=3D"profile_replace" name=3D"/usr/lib/connman/scripts/dhcl=
ient-script" pid=3D576 comm=3D"apparmor_parser"
[   21.289988] audit: type=3D1400 audit(1406882923.687:8): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/usr/sbin/ntpd" pid=3D691 comm=3D=
"apparmor_parser"
[   21.290568] audit: type=3D1400 audit(1406882923.687:9): apparmor=3D"ST=
ATUS" operation=3D"profile_replace" name=3D"/usr/sbin/ntpd" pid=3D692 com=
m=3D"apparmor_parser"
[   21.875551] nvidia: module license 'NVIDIA' taints kernel.
[   21.875556] Disabling lock debugging due to kernel taint
[   21.885283] nvidia: module verification failed: signature and/or  requ=
ired key missing - tainting kernel
[   21.891366] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecode=
s=3Dio+mem,decodes=3Dnone:owns=3Dnone
[   21.891688] [drm] Initialized nvidia-drm 0.0.0 20130102 for 0000:01:00=
=2E0 on minor 0
[   21.891695] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  331.38  We=
d Jan  8 19:32:30 PST 2014
[   22.347499] init: Failed to obtain startpar-bridge instance: Unknown p=
arameter: INSTANCE
[   23.732189] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   23.732247] ATL1E 0000:02:00.0 eth0: NIC Link is Up <1000 Mbps Full Du=
plex>
[   23.732258] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   24.146279] init: udev-fallback-graphics main process (848) terminated=
 with status 1
[   24.923424] init: Failed to spawn mythbuntu-bare-console main process:=
 unable to execute: No such file or directory
[   25.109767] init: smbd main process (743) killed by HUP signal
[   25.109779] init: smbd main process ended, respawning
[   28.322676] init: failsafe main process (709) killed by TERM signal
[   29.840555] NET: Registered protocol family 15
[   30.361405] AVX instructions are not detected.
[   30.684996] AVX instructions are not detected.
[   30.701811] AVX instructions are not detected.
[   30.792493] AVX or AES-NI instructions are not detected.
[   30.801660] AVX or AES-NI instructions are not detected.
[   30.973251] AVX instructions are not detected.
[   31.296781] init: samba-ad-dc main process (1049) terminated with stat=
us 1
[   31.432484] audit: type=3D1400 audit(1406882933.831:10): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/sbin/dhclient" pid=3D1460 c=
omm=3D"apparmor_parser"
[   31.432492] audit: type=3D1400 audit(1406882933.831:11): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/usr/lib/NetworkManager/nm-d=
hcp-client.action" pid=3D1460 comm=3D"apparmor_parser"
[   31.432496] audit: type=3D1400 audit(1406882933.831:12): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/usr/lib/connman/scripts/dhc=
lient-script" pid=3D1460 comm=3D"apparmor_parser"
[   31.432813] audit: type=3D1400 audit(1406882933.831:13): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/usr/lib/NetworkManager/nm-d=
hcp-client.action" pid=3D1460 comm=3D"apparmor_parser"
[   31.432817] audit: type=3D1400 audit(1406882933.831:14): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/usr/lib/connman/scripts/dhc=
lient-script" pid=3D1460 comm=3D"apparmor_parser"
[   31.432971] audit: type=3D1400 audit(1406882933.831:15): apparmor=3D"S=
TATUS" operation=3D"profile_replace" name=3D"/usr/lib/connman/scripts/dhc=
lient-script" pid=3D1460 comm=3D"apparmor_parser"
[   31.878288] audit: type=3D1400 audit(1406882934.276:16): apparmor=3D"S=
TATUS" operation=3D"profile_load" name=3D"/usr/lib/lightdm/lightdm-guest-=
session" pid=3D1459 comm=3D"apparmor_parser"
[   31.878438] audit: type=3D1400 audit(1406882934.276:17): apparmor=3D"S=
TATUS" operation=3D"profile_load" name=3D"chromium" pid=3D1459 comm=3D"ap=
parmor_parser"
[   32.098478] audit: type=3D1400 audit(1406882934.496:18): apparmor=3D"S=
TATUS" operation=3D"profile_load" name=3D"/usr/bin/freshclam" pid=3D1466 =
comm=3D"apparmor_parser"
[   32.234466] audit: type=3D1400 audit(1406882934.632:19): apparmor=3D"S=
TATUS" operation=3D"profile_load" name=3D"/usr/sbin/mysqld" pid=3D1468 co=
mm=3D"apparmor_parser"
[   35.941751] init: Failed to spawn hybrid-gfx main process: unable to e=
xecute: No such file or directory
[   36.001165] init: mythzoneminder main process (1562) terminated with s=
tatus 136
[   36.001176] init: mythzoneminder main process ended, respawning
[   36.220613] init: mythzoneminder main process (1633) terminated with s=
tatus 136
[   36.220625] init: mythzoneminder main process ended, respawning
[   36.258397] init: mythzoneminder main process (1699) terminated with s=
tatus 136
[   36.258409] init: mythzoneminder main process ended, respawning
[   36.277500] init: mythzoneminder main process (1701) terminated with s=
tatus 136
[   36.277512] init: mythzoneminder main process ended, respawning
[   36.287731] init: mythzoneminder main process (1709) terminated with s=
tatus 136
[   36.287743] init: mythzoneminder main process ended, respawning
[   36.298277] init: mythzoneminder main process (1711) terminated with s=
tatus 136
[   36.298288] init: mythzoneminder main process ended, respawning
[   36.322984] init: mythzoneminder main process (1713) terminated with s=
tatus 136
[   36.322996] init: mythzoneminder main process ended, respawning
[   36.348879] init: mythzoneminder main process (1739) terminated with s=
tatus 136
[   36.348893] init: mythzoneminder main process ended, respawning
[   36.363354] init: mythzoneminder main process (1759) terminated with s=
tatus 136
[   36.363366] init: mythzoneminder main process ended, respawning
[   36.371134] init: mythzoneminder main process (1761) terminated with s=
tatus 136
[   36.371148] init: mythzoneminder main process ended, respawning
[   36.382633] init: mythzoneminder main process (1763) terminated with s=
tatus 136
[   36.382646] init: mythzoneminder respawning too fast, stopped
[   46.739438] init: nvidia-persistenced main process (2689) terminated w=
ith status 1
[   64.141179] nvidia 0000:01:00.0: irq 45 for MSI/MSI-X
[   65.626364] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state rec=
overy directory
[   65.765937] NFSD: starting 90-second grace period (net ffffffff81cd08c=
0)
[   68.171827] init: plymouth-upstart-bridge main process ended, respawni=
ng
[   97.285823] Bluetooth: Core ver 2.19
[   97.285843] NET: Registered protocol family 31
[   97.285845] Bluetooth: HCI device and connection manager initialized
[   97.285854] Bluetooth: HCI socket layer initialized
[   97.285856] Bluetooth: L2CAP socket layer initialized
[   97.285866] Bluetooth: SCO socket layer initialized
[   97.382867] Netfilter messages via NETLINK v0.30.
[  109.536044] device eth0 entered promiscuous mode
[  177.525472] ip_tables: (C) 2000-2006 Netfilter Core Team
[  177.588875] init: plymouth-stop pre-start process (5437) terminated wi=
th status 1
[  218.785285] show_signal_msg: 27 callbacks suppressed
[  218.785291] PT1[5173]: segfault at 8 ip 00007f2a81e54d81 sp 00007f29a7=
bd42a0 error 4 in libQtCore.so.4.8.6[7f2a81cf2000+2d8000]
[  228.623832] BTRFS info (device sdc2): disk space caching is enabled
[  228.839569] BTRFS: bdev /dev/sdc2 errs: wr 0, rd 0, flush 0, corrupt 3=
30, gen 0
[  234.073906] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  234.093890] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  234.110834] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  234.125023] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  234.153476] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  234.153794] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  237.745806] BTRFS: error (device sdc2) in open_ctree:2886: errno=3D-5 =
IO failure (Failed to recover log tree)
[  237.748366] ------------[ cut here ]------------
[  237.748397] WARNING: CPU: 1 PID: 7348 at /home/apw/COD/linux/fs/btrfs/=
extent-tree.c:137 btrfs_put_block_group+0x75/0x80 [btrfs]()
[  237.748399] Modules linked in: xt_multiport iptable_filter ip_tables x=
_tables nfnetlink_queue nfnetlink_log nfnetlink bluetooth 6lowpan_iphc de=
flate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_comm=
on camellia_generic camellia_x86_64 serpent_sse2_x86_64 xts serpent_gener=
ic lrw gf128mul glue_helper blowfish_generic blowfish_x86_64 blowfish_com=
mon cast5_generic cast_common ablk_helper cryptd des_generic cmac xcbc rm=
d160 crypto_null af_key xfrm_algo nvidia(POE) dvb_usb_af9035 dvb_usb_v2 d=
vb_core rc_core snd_hda_codec_realtek kvm_intel snd_hda_codec_generic kvm=
 snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_seq=
_midi serio_raw snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd=
_timer snd drm soundcore lpc_ich asus_atk0110 mac_hid nfsd auth_rpcgss nf=
s_acl nfs lockd binfmt_misc sunrpc fscache hwmon_vid coretemp lp parport =
btrfs xor raid6_pq pata_acpi hid_generic psmouse usbhid hid atl1e pata_ma=
rvell
[  237.748442] CPU: 1 PID: 7348 Comm: mount Tainted: P           OE 3.16.=
0-999-generic #201408010205
[  237.748443] Hardware name: System manufacturer P5QL PRO/P5QL PRO, BIOS=
 0803    10/08/2008
[  237.748445]  0000000000000089 ffff8801fb6dfb18 ffffffff817865a5 000000=
0000000007
[  237.748447]  0000000000000000 ffff8801fb6dfb58 ffffffff810720ac ffff88=
01fb6dfb68
[  237.748449]  ffff8801c502ae00 ffff8801c502ae00 ffff8800ad6bd080 ffff88=
00ad6bd090
[  237.748452] Call Trace:
[  237.748457]  [<ffffffff817865a5>] dump_stack+0x46/0x58
[  237.748461]  [<ffffffff810720ac>] warn_slowpath_common+0x8c/0xc0
[  237.748463]  [<ffffffff810720fa>] warn_slowpath_null+0x1a/0x20
[  237.748473]  [<ffffffffc04583b5>] btrfs_put_block_group+0x75/0x80 [btr=
fs]
[  237.748483]  [<ffffffffc046227d>] btrfs_free_block_groups+0xbd/0x2e0 [=
btrfs]
[  237.748495]  [<ffffffffc0470abd>] open_ctree+0x188d/0x1f70 [btrfs]
[  237.748504]  [<ffffffffc0442af1>] btrfs_fill_super.isra.84+0x81/0x130 =
[btrfs]
[  237.748507]  [<ffffffff8136d7f1>] ? disk_name+0x61/0xc0
[  237.748510]  [<ffffffff81392ab7>] ? strlcpy+0x47/0x60
[  237.748519]  [<ffffffffc04474be>] btrfs_mount+0x3ae/0x3d0 [btrfs]
[  237.748523]  [<ffffffff8118dc72>] ? pcpu_alloc+0x322/0x3f0
[  237.748527]  [<ffffffff811e52e3>] mount_fs+0x43/0x1b0
[  237.748529]  [<ffffffff8118dd50>] ? __alloc_percpu+0x10/0x20
[  237.748533]  [<ffffffff812004c6>] vfs_kern_mount+0x76/0x140
[  237.748536]  [<ffffffff81201c44>] do_new_mount+0xa4/0x1f0
[  237.748539]  [<ffffffff81202fe6>] do_mount+0x1e6/0x230
[  237.748541]  [<ffffffff812033b0>] SyS_mount+0x90/0xe0
[  237.748544]  [<ffffffff8179402d>] system_call_fastpath+0x1a/0x1f
[  237.748546] ---[ end trace 9d0d02f52060b3dc ]---
[  237.784272] BTRFS: open_ctree failed
[  312.719525] BTRFS info (device sdc2): enabling auto recovery
[  312.719530] BTRFS info (device sdc2): disk space caching is enabled
[  312.758417] BTRFS: bdev /dev/sdc2 errs: wr 0, rd 0, flush 0, corrupt 3=
30, gen 0
[  314.319570] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  314.324169] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  314.324391] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  314.324610] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  314.333768] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  314.333973] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  315.047111] BTRFS: error (device sdc2) in open_ctree:2886: errno=3D-5 =
IO failure (Failed to recover log tree)
[  315.049720] ------------[ cut here ]------------
[  315.049754] WARNING: CPU: 1 PID: 8708 at /home/apw/COD/linux/fs/btrfs/=
extent-tree.c:137 btrfs_put_block_group+0x75/0x80 [btrfs]()
[  315.049755] Modules linked in: xt_multiport iptable_filter ip_tables x=
_tables nfnetlink_queue nfnetlink_log nfnetlink bluetooth 6lowpan_iphc de=
flate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_comm=
on camellia_generic camellia_x86_64 serpent_sse2_x86_64 xts serpent_gener=
ic lrw gf128mul glue_helper blowfish_generic blowfish_x86_64 blowfish_com=
mon cast5_generic cast_common ablk_helper cryptd des_generic cmac xcbc rm=
d160 crypto_null af_key xfrm_algo nvidia(POE) dvb_usb_af9035 dvb_usb_v2 d=
vb_core rc_core snd_hda_codec_realtek kvm_intel snd_hda_codec_generic kvm=
 snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_seq=
_midi serio_raw snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd=
_timer snd drm soundcore lpc_ich asus_atk0110 mac_hid nfsd auth_rpcgss nf=
s_acl nfs lockd binfmt_misc sunrpc fscache hwmon_vid coretemp lp parport =
btrfs xor raid6_pq pata_acpi hid_generic psmouse usbhid hid atl1e pata_ma=
rvell
[  315.049799] CPU: 1 PID: 8708 Comm: mount Tainted: P        W  OE 3.16.=
0-999-generic #201408010205
[  315.049800] Hardware name: System manufacturer P5QL PRO/P5QL PRO, BIOS=
 0803    10/08/2008
[  315.049802]  0000000000000089 ffff8800ca373b18 ffffffff817865a5 000000=
0000000007
[  315.049804]  0000000000000000 ffff8800ca373b58 ffffffff810720ac ffff88=
00ca373b68
[  315.049806]  ffff8801cee62c00 ffff8801cee62c00 ffff8801c51a8080 ffff88=
01c51a8090
[  315.049809] Call Trace:
[  315.049814]  [<ffffffff817865a5>] dump_stack+0x46/0x58
[  315.049818]  [<ffffffff810720ac>] warn_slowpath_common+0x8c/0xc0
[  315.049820]  [<ffffffff810720fa>] warn_slowpath_null+0x1a/0x20
[  315.049830]  [<ffffffffc04583b5>] btrfs_put_block_group+0x75/0x80 [btr=
fs]
[  315.049840]  [<ffffffffc046227d>] btrfs_free_block_groups+0xbd/0x2e0 [=
btrfs]
[  315.049852]  [<ffffffffc0470abd>] open_ctree+0x188d/0x1f70 [btrfs]
[  315.049861]  [<ffffffffc0442af1>] btrfs_fill_super.isra.84+0x81/0x130 =
[btrfs]
[  315.049864]  [<ffffffff8136d7f1>] ? disk_name+0x61/0xc0
[  315.049867]  [<ffffffff81392ab7>] ? strlcpy+0x47/0x60
[  315.049876]  [<ffffffffc04474be>] btrfs_mount+0x3ae/0x3d0 [btrfs]
[  315.049882]  [<ffffffff811e52e3>] mount_fs+0x43/0x1b0
[  315.049885]  [<ffffffff812004c6>] vfs_kern_mount+0x76/0x140
[  315.049888]  [<ffffffff81201c44>] do_new_mount+0xa4/0x1f0
[  315.049891]  [<ffffffff81202fe6>] do_mount+0x1e6/0x230
[  315.049893]  [<ffffffff812033b0>] SyS_mount+0x90/0xe0
[  315.049897]  [<ffffffff8179402d>] system_call_fastpath+0x1a/0x1f
[  315.049899] ---[ end trace 9d0d02f52060b3dd ]---
[  315.080243] BTRFS: open_ctree failed
[  334.714453] BTRFS info (device sdc2): enabling auto recovery
[  334.714458] BTRFS info (device sdc2): disk space caching is enabled
[  334.746356] BTRFS: bdev /dev/sdc2 errs: wr 0, rd 0, flush 0, corrupt 3=
30, gen 0
[  336.299119] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  336.303746] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  336.303973] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  336.304193] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  336.313241] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  336.313442] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[  337.001704] BTRFS: error (device sdc2) in open_ctree:2886: errno=3D-5 =
IO failure (Failed to recover log tree)
[  337.004267] ------------[ cut here ]------------
[  337.004309] WARNING: CPU: 1 PID: 8734 at /home/apw/COD/linux/fs/btrfs/=
extent-tree.c:137 btrfs_put_block_group+0x75/0x80 [btrfs]()
[  337.004310] Modules linked in: xt_multiport iptable_filter ip_tables x=
_tables nfnetlink_queue nfnetlink_log nfnetlink bluetooth 6lowpan_iphc de=
flate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_comm=
on camellia_generic camellia_x86_64 serpent_sse2_x86_64 xts serpent_gener=
ic lrw gf128mul glue_helper blowfish_generic blowfish_x86_64 blowfish_com=
mon cast5_generic cast_common ablk_helper cryptd des_generic cmac xcbc rm=
d160 crypto_null af_key xfrm_algo nvidia(POE) dvb_usb_af9035 dvb_usb_v2 d=
vb_core rc_core snd_hda_codec_realtek kvm_intel snd_hda_codec_generic kvm=
 snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_seq=
_midi serio_raw snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd=
_timer snd drm soundcore lpc_ich asus_atk0110 mac_hid nfsd auth_rpcgss nf=
s_acl nfs lockd binfmt_misc sunrpc fscache hwmon_vid coretemp lp parport =
btrfs xor raid6_pq pata_acpi hid_generic psmouse usbhid hid atl1e pata_ma=
rvell
[  337.004355] CPU: 1 PID: 8734 Comm: mount Tainted: P        W  OE 3.16.=
0-999-generic #201408010205
[  337.004357] Hardware name: System manufacturer P5QL PRO/P5QL PRO, BIOS=
 0803    10/08/2008
[  337.004358]  0000000000000089 ffff8801c531fb18 ffffffff817865a5 000000=
0000000007
[  337.004361]  0000000000000000 ffff8801c531fb58 ffffffff810720ac ffff88=
01c531fb68
[  337.004363]  ffff8801c4c6f400 ffff8801c4c6f400 ffff8800cb3c8080 ffff88=
00cb3c8090
[  337.004365] Call Trace:
[  337.004372]  [<ffffffff817865a5>] dump_stack+0x46/0x58
[  337.004375]  [<ffffffff810720ac>] warn_slowpath_common+0x8c/0xc0
[  337.004378]  [<ffffffff810720fa>] warn_slowpath_null+0x1a/0x20
[  337.004387]  [<ffffffffc04583b5>] btrfs_put_block_group+0x75/0x80 [btr=
fs]
[  337.004398]  [<ffffffffc046227d>] btrfs_free_block_groups+0xbd/0x2e0 [=
btrfs]
[  337.004410]  [<ffffffffc0470abd>] open_ctree+0x188d/0x1f70 [btrfs]
[  337.004418]  [<ffffffffc0442af1>] btrfs_fill_super.isra.84+0x81/0x130 =
[btrfs]
[  337.004422]  [<ffffffff8136d7f1>] ? disk_name+0x61/0xc0
[  337.004425]  [<ffffffff81392ab7>] ? strlcpy+0x47/0x60
[  337.004434]  [<ffffffffc04474be>] btrfs_mount+0x3ae/0x3d0 [btrfs]
[  337.004439]  [<ffffffff811e52e3>] mount_fs+0x43/0x1b0
[  337.004443]  [<ffffffff812004c6>] vfs_kern_mount+0x76/0x140
[  337.004446]  [<ffffffff81201c44>] do_new_mount+0xa4/0x1f0
[  337.004448]  [<ffffffff81202fe6>] do_mount+0x1e6/0x230
[  337.004451]  [<ffffffff812033b0>] SyS_mount+0x90/0xe0
[  337.004454]  [<ffffffff8179402d>] system_call_fastpath+0x1a/0x1f
[  337.004456] ---[ end trace 9d0d02f52060b3de ]---
[  337.036078] BTRFS: open_ctree failed
[  509.196653] perf interrupt took too long (2504 > 2500), lowering kerne=
l.perf_event_max_sample_rate to 50000
[  932.554987] usb 1-6: USB disconnect, device number 2
[  937.044043] usb 1-6: new high-speed USB device number 3 using ehci-pci=

[  937.180124] usb 1-6: New USB device found, idVendor=3D1b80, idProduct=3D=
e409
[  937.180129] usb 1-6: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[  937.180133] usb 1-6: Product: DVB-T TV Stick
[  937.180135] usb 1-6: Manufacturer: ITE Technologies, Inc.
[  937.182495] usb 1-6: dvb_usb_af9035: prechip_version=3D83 chip_version=
=3D01 chip_type=3D9135
[  937.182868] usb 1-6: dvb_usb_v2: found a 'Kworld UB499-2T T09' in cold=
 state
[  937.182916] usb 1-6: dvb_usb_v2: downloading firmware from file 'dvb-u=
sb-it9135-01.fw'
[  938.804912] usb 1-6: dvb_usb_af9035: command=3D29 checksum mismatch (7=
303 !=3D ffd6)
[  938.804933] dvb_usb_af9035: probe of 1-6:1.0 failed with error -5
[ 2563.464717] UDP: bad checksum. From 212.56.214.12:22833 to 172.16.1.11=
1:51413 ulen 28
[ 3510.385007] BTRFS info (device sdc2): enabling auto recovery
[ 3510.385011] BTRFS info (device sdc2): disk space caching is enabled
[ 3510.427538] BTRFS: bdev /dev/sdc2 errs: wr 0, rd 0, flush 0, corrupt 3=
30, gen 0
[ 3512.056711] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[ 3512.061430] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[ 3512.061637] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[ 3512.061847] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[ 3512.071040] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[ 3512.071246] BTRFS: sdc2 checksum verify failed on 281614303232 wanted =
919CDD7F found 128A506F level 0
[ 3512.810037] BTRFS: error (device sdc2) in open_ctree:2886: errno=3D-5 =
IO failure (Failed to recover log tree)
[ 3512.812624] ------------[ cut here ]------------
[ 3512.812657] WARNING: CPU: 0 PID: 13993 at /home/apw/COD/linux/fs/btrfs=
/extent-tree.c:137 btrfs_put_block_group+0x75/0x80 [btrfs]()
[ 3512.812658] Modules linked in: ipt_REJECT xt_multiport iptable_filter =
ip_tables x_tables nfnetlink_queue nfnetlink_log nfnetlink bluetooth 6low=
pan_iphc deflate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 t=
wofish_common camellia_generic camellia_x86_64 serpent_sse2_x86_64 xts se=
rpent_generic lrw gf128mul glue_helper blowfish_generic blowfish_x86_64 b=
lowfish_common cast5_generic cast_common ablk_helper cryptd des_generic c=
mac xcbc rmd160 crypto_null af_key xfrm_algo nvidia(POE) dvb_usb_af9035 d=
vb_usb_v2 dvb_core rc_core snd_hda_codec_realtek kvm_intel snd_hda_codec_=
generic kvm snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_=
pcm snd_seq_midi serio_raw snd_seq_midi_event snd_rawmidi snd_seq snd_seq=
_device snd_timer snd drm soundcore lpc_ich asus_atk0110 mac_hid nfsd aut=
h_rpcgss nfs_acl nfs lockd binfmt_misc sunrpc fscache hwmon_vid coretemp =
lp parport btrfs xor raid6_pq pata_acpi hid_generic psmouse usbhid hid at=
l1e pata_marvell
[ 3512.812702] CPU: 0 PID: 13993 Comm: mount Tainted: P        W  OE 3.16=
=2E0-999-generic #201408010205
[ 3512.812703] Hardware name: System manufacturer P5QL PRO/P5QL PRO, BIOS=
 0803    10/08/2008
[ 3512.812705]  0000000000000089 ffff88020155fb18 ffffffff817865a5 000000=
0000000007
[ 3512.812707]  0000000000000000 ffff88020155fb58 ffffffff810720ac ffff88=
020155fb68
[ 3512.812709]  ffff88008e8e8200 ffff88008e8e8200 ffff8800ad6b8080 ffff88=
00ad6b8090
[ 3512.812712] Call Trace:
[ 3512.812718]  [<ffffffff817865a5>] dump_stack+0x46/0x58
[ 3512.812721]  [<ffffffff810720ac>] warn_slowpath_common+0x8c/0xc0
[ 3512.812723]  [<ffffffff810720fa>] warn_slowpath_null+0x1a/0x20
[ 3512.812733]  [<ffffffffc04583b5>] btrfs_put_block_group+0x75/0x80 [btr=
fs]
[ 3512.812744]  [<ffffffffc046227d>] btrfs_free_block_groups+0xbd/0x2e0 [=
btrfs]
[ 3512.812755]  [<ffffffffc0470abd>] open_ctree+0x188d/0x1f70 [btrfs]
[ 3512.812764]  [<ffffffffc0442af1>] btrfs_fill_super.isra.84+0x81/0x130 =
[btrfs]
[ 3512.812770]  [<ffffffff8136d7f1>] ? disk_name+0x61/0xc0
[ 3512.812773]  [<ffffffff81392ab7>] ? strlcpy+0x47/0x60
[ 3512.812782]  [<ffffffffc04474be>] btrfs_mount+0x3ae/0x3d0 [btrfs]
[ 3512.812787]  [<ffffffff811e52e3>] mount_fs+0x43/0x1b0
[ 3512.812792]  [<ffffffff812004c6>] vfs_kern_mount+0x76/0x140
[ 3512.812795]  [<ffffffff81201c44>] do_new_mount+0xa4/0x1f0
[ 3512.812797]  [<ffffffff81202fe6>] do_mount+0x1e6/0x230
[ 3512.812800]  [<ffffffff812033b0>] SyS_mount+0x90/0xe0
[ 3512.812803]  [<ffffffff8179402d>] system_call_fastpath+0x1a/0x1f
[ 3512.812805] ---[ end trace 9d0d02f52060b3df ]---
[ 3512.844245] BTRFS: open_ctree failed

--------------050703040409050304090807--

--------------ms020106060608080208070008
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIMijCC
BjQwggQcoAMCAQICAR4wDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDE1NVoXDTE3MTAyNDIxMDE1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMcJg8zOLdgasSmkLhOr
lr6KMoOMpohBllVHrdRvEg/q6r8jR+EK75xCGhR8ToREoqe7zM9/UnC6TS2y9UKTpT1v7RSM
zR0t6ndl0TWBuUr/UXBhPk+Kmy7bI4yW4urC+y7P3/1/X7U8ocb8VpH/Clt+4iq7nirMcNh6
qJR+xjOhV+VHzQMALuGYn5KZmc1NbJQYclsGkDxDz2UbFqE2+6vIZoL+jb9x4Pa5gNf1TwSD
kOkikZB1xtB4ZqtXThaABSONdfmv/Z1pua3FYxnCFmdr/+N2JLKutIxMYqQOJebr/f/h5t95
m4JgrM3Y/w7YX9d7YAL9jvN4SydHsU6n65cCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRTcu2SnODaywFcfH6WNU7y1LhRgjAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBAAqD
CH14qywGXLhjjF6uHLkjd02hcdh9hrw+VUsv+q1eeQWB21jWj3kJ96AUlPCoEGZ/ynJNScWy
6QMVQjbbMXltUfO4n4bGGdKo3awPWp61tjAFgraLJgDk+DsSvUD6EowjMTNx25GQgyYJ5RPI
zKKR9tQW8gGK+2+RHxkUCTbYFnL6kl8Ch507rUdPPipJ9CgJFws3kDS3gOS5WFMxcjO5DwKf
KSETEPrHh7p5shuuNktvsv6hxHTLhiMKX893gxdT3XLS9OKmCv87vkINQcNEcIIoFWbP9HOR
z9v3vQwR4e3ksLc2JZOAFK+ssS5XMEoznzpihEP0PLc4dCBYjbvSD7kxgDwZ+Aj8Q9PkbvE9
sIPP7ON0fz095HdThKjiVJe6vofq+n6b1NBc8XdrQvBmunwxD5nvtTW4vtN6VY7mUCmxsCie
uoBJ9OlqmsVWQvifIYf40dJPZkk9YgGTzWLpXDSfLSplbY2LL9C9U0ptvjcDjefLTvqSFc7t
w1sEhF0n/qpA2r0GpvkLRDmcSwVyPvmjFBGqUp/pNy8ZuPGQmHwFi2/14+xeSUDG2bwnsYJQ
G2EdJCB6luQ57GEnTA/yKZSTKI8dDQa8Sd3zfXb19mOgSF0bBdXbuKhEpuP9wirslFe6fQ1t
5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIGTjCCBTagAwIBAgIDCls5MA0GCSqGSIb3DQEB
BQUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMi
U2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20g
Q2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcNMTQwNjI2MTIyMDE4
WhcNMTUwNjI3MDcxNTEyWjBlMRkwFwYDVQQNExAzU3VzdEVEbVdWb2pDQ3IzMSAwHgYDVQQD
DBdmcmFua2llQHRlcnJvcmlzZS5tZS51azEmMCQGCSqGSIb3DQEJARYXZnJhbmtpZUB0ZXJy
b3Jpc2UubWUudWswggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCwfY6rRpAyxFVA
17oVBISNhqyms1PoGt2ADCM1svmgwi9i76QY1OCmLfHiOGRzkXURvZkm2OlxMmIK0lVnmI7B
o6/xJavi/Fiyl4IbBVCrRMqaP3gdyatwd1Y7323SKb43DlxPDsU/AfiPvDsmu0V/0JCOMBAE
hfECe9n3aONNPHnGDMresseNONMb/R21EldU791dhuVaIYUmwXA50BiDLI0u4ZOtTWVGDG9R
0MyjfBaXCmMh/YBL+FWBAvjy5+vUxusWbOrG3hS6aSEwvjJz2yAin5MjI5hb4wsC8jmWgr6w
xokAdRZwjDZZNGo0XS/lGqi8hdYiBdL+jRpVp34pAgMBAAGjggLdMIIC2TAJBgNVHRMEAjAA
MAsGA1UdDwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwHQYDVR0OBBYE
FKGQiXHn4U8U/LSclk+GwpwhYT18MB8GA1UdIwQYMBaAFFNy7ZKc4NrLAVx8fpY1TvLUuFGC
MCIGA1UdEQQbMBmBF2ZyYW5raWVAdGVycm9yaXNlLm1lLnVrMIIBTAYDVR0gBIIBQzCCAT8w
ggE7BgsrBgEEAYG1NwECAzCCASowLgYIKwYBBQUHAgEWImh0dHA6Ly93d3cuc3RhcnRzc2wu
Y29tL3BvbGljeS5wZGYwgfcGCCsGAQUFBwICMIHqMCcWIFN0YXJ0Q29tIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MAMCAQEagb5UaGlzIGNlcnRpZmljYXRlIHdhcyBpc3N1ZWQgYWNjb3Jk
aW5nIHRvIHRoZSBDbGFzcyAxIFZhbGlkYXRpb24gcmVxdWlyZW1lbnRzIG9mIHRoZSBTdGFy
dENvbSBDQSBwb2xpY3ksIHJlbGlhbmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRlZCBwdXJwb3Nl
IGluIGNvbXBsaWFuY2Ugb2YgdGhlIHJlbHlpbmcgcGFydHkgb2JsaWdhdGlvbnMuMDYGA1Ud
HwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL2NydHUxLWNybC5jcmwwgY4G
CCsGAQUFBwEBBIGBMH8wOQYIKwYBBQUHMAGGLWh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9z
dWIvY2xhc3MxL2NsaWVudC9jYTBCBggrBgEFBQcwAoY2aHR0cDovL2FpYS5zdGFydHNzbC5j
b20vY2VydHMvc3ViLmNsYXNzMS5jbGllbnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tLzANBgkqhkiG9w0BAQUFAAOCAQEAeOm6OtvIkNrl7HQ+2WfWuXol
k0v/3cTqKaMWez4HhrniFYvGhVeum9hWtUJsfyNW37nnkJVKFvPFuR76fEWiouKIt8X2ddya
22aCHqawnF9BV3WZ7tnb6YQ+r8t4kNrEVa6Vdg0P/qw3ZJeDuSAW8O4w/aXKOBLbjJsbEo/r
8F3LITi3AXOyYQC8x6PacwZ6d4NvjMGvyyZUYFWyDDoie8DDkBjcOGZaW4CDIQvzwgODC6vZ
Ns2ixrpLQ5q/1Nl+qdAK2CLYO8JLGgm1VcD2kBphxz4cc6fJPwfC9tTZfk9B+u8+S/BPYSxt
H5yLsLzgxx8bcysh3ZfHCGYTvP+cUDGCA90wggPZAgEBMIGUMIGMMQswCQYDVQQGEwJJTDEW
MBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlm
aWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVy
bWVkaWF0ZSBDbGllbnQgQ0ECAwpbOTAJBgUrDgMCGgUAoIICHTAYBgkqhkiG9w0BCQMxCwYJ
KoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNDA4MDEwOTU4MzlaMCMGCSqGSIb3DQEJBDEW
BBQdFCUjj4ocnnM/66ppWljwAnlsHTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGlBgkrBgEEAYI3EAQxgZcwgZQwgYwxCzAJBgNV
BAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRh
bCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1h
cnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQQIDCls5MIGnBgsqhkiG9w0BCRACCzGBl6CBlDCB
jDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3Vy
ZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNz
IDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgMKWzkwDQYJKoZIhvcNAQEBBQAE
ggEAC+IU6DBaIBB2i0YdbTlyGwmmnsuN789SEEu0Iakry6dHsoIxLLkw1O9lLsN23euKt2rF
9qiweVp54YHp++ALQ0Wa9KPIuevTZ9zPMWObY3YqQRWpa+eykSa/iWp9jwF0wvtyyW0OPKky
dSLGRp5ciwN45DXFg/fkN9V/YS3WgoRUBJpyTuJBAXEGus0eZV9r/Md0HNCM7qkknycemNc0
O4yhIgEuSgI4kePwmFkYQDkHrji0uDqBGMnnPxjT8A/cO0fFVKmKCApSse9F0jEEgzju3g9Q
1qKeycsADHuF4aF+TbzRPTMLvMQZGpbacLKfLVPYVYLO959QPcDleMGvfAAAAAAAAA==
--------------ms020106060608080208070008--
