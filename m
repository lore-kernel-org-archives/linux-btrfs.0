Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bastet.luchs.at ([77.244.242.186]:41362 "EHLO bastet.luchs.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbbGMBdI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jul 2015 21:33:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by bastet.luchs.at (Postfix) with ESMTP id F29E63FFDD
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2015 03:24:51 +0200 (CEST)
Received: from bastet.luchs.at ([127.0.0.1])
	by localhost (bastet.luchs.at [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Xya65tILSHM for <linux-btrfs@vger.kernel.org>;
	Mon, 13 Jul 2015 03:24:47 +0200 (CEST)
Received: from nephtys.luchs.at (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "nephtys.luchs.at", Issuer "luchs.at CA" (verified OK))
	by bastet.luchs.at (Postfix) with ESMTPS id B06AD3FFDA
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2015 03:24:46 +0200 (CEST)
Received: from nephtys.luchs.at (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by nephtys.luchs.at (Postfix) with ESMTPS id 98ED9D37E4
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2015 03:23:52 +0200 (CEST)
Date: Mon, 13 Jul 2015 03:23:51 +0200
From: =?iso-8859-15?Q?Ren=E9?= Pfeiffer <lynx@luchs.at>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs read-only after btrfs-convert from Ext4 & workaround
Message-ID: <20150713012350.ZA6925@many.eyes.bnd.bund.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mxv5cy4qt+RJ9ypb
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

I also hit the Btrfs read-only after btrfs-convert bug when converting my
Ext4 root filesystem with btrfs-convert. I used the btrfs tools v4.0 and
Linux kernel 4.1.1.

As a workaround I mounted the converted Btrfs read-only and copied it to a
new Btrfs created by mkfs.btrfs (from the btrfs tools v4.0). Debian 8
system booted without problems, and the bug hasn't been seen (so far).

Output of uname, btrfs, and the dmesg log is attached. Let me know if you
need anything else. The old Btrfs is still on another disk, and I can
extract information from it.

Best regards,
Ren=E9.

--=20
  )\._.,--....,'``.  fL  Let GNU/Linux work for you while you take a nap.
 /,   _.. \   _\  (`._ ,. R. Pfeiffer <lynx at luchs.at> + http://web.luchs=
=2Eat/
`._.-(,_..'--(,_..'`-.;.'  - System administration + Consulting + Teaching -
Got mail delivery problems?  http://web.luchs.at/information/blockedmail.php

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="btrfs_bug_system.txt"
Content-Transfer-Encoding: quoted-printable

Linux nephtys 4.1.1 #1 SMP Thu Jul 2 03:28:56 CEST 2015 x86_64 GNU/Linux

btrfs-progs v4.0

btrfs-progs v4.0
Data, single: total=3D450.00GiB, used=3D237.20GiB
System, single: total=3D32.00MiB, used=3D48.00KiB
Metadata, single: total=3D188.00GiB, used=3D96.78GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.1.1 (lynx@nephtys) (gcc version 4.9.2 (Debia=
n 4.9.2-10) ) #1 SMP Thu Jul 2 03:28:56 CEST 2015
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-4.1.1 root=3DUUID=3D703f=
c8b4-b2b9-470b-af2f-9aae9536c2fb ro nordrand rd.auto rd.auto=3D1
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfcdcfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfcdd000-0x00000000dce3efff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000dce3f000-0x00000000dcf7efff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000dcf7f000-0x00000000dcffefff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x00000000dcfff000-0x00000000df9fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ff000fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000031e5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: LENOVO 20C6003AGE/20C6003AGE, BIOS J9ET91WW (2.11 ) 07/=
04/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x31e600 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   1 base 00DE000000 mask 7FFE000000 uncachable
[    0.000000]   2 base 00DD000000 mask 7FFF000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC =20
[    0.000000] e820: last_pfn =3D 0xcfcdd max_arch_pfn =3D 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x2d7cd000, 0x2d7cdfff] PGTABLE
[    0.000000] BRK [0x2d7ce000, 0x2d7cefff] PGTABLE
[    0.000000] BRK [0x2d7cf000, 0x2d7cffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x31e400000-0x31e5fffff]
[    0.000000]  [mem 0x31e400000-0x31e5fffff] page 2M
[    0.000000] BRK [0x2d7d0000, 0x2d7d0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x300000000-0x31e3fffff]
[    0.000000]  [mem 0x300000000-0x31e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x2e0000000-0x2ffffffff]
[    0.000000]  [mem 0x2e0000000-0x2ffffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xcfcdcfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xcfbfffff] page 2M
[    0.000000]  [mem 0xcfc00000-0xcfcdcfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x2dfffffff]
[    0.000000]  [mem 0x100000000-0x2dfffffff] page 1G
[    0.000000] RAMDISK: [mem 0x3633e000-0x37196fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0120 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000DCFFE170 0000D4 (v01 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: FACP 0x00000000DCFF8000 00010C (v05 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: DSDT 0x00000000DCFE1000 011E25 (v01 LENOVO TP-J9    00=
002110 INTL 20120711)
[    0.000000] ACPI: FACS 0x00000000DCF49000 000040
[    0.000000] ACPI: SLIC 0x00000000DCFFD000 000176 (v01 LENOVO TP-J9    00=
002110 PTEC 00000001)
[    0.000000] ACPI: DBGP 0x00000000DCFFB000 000034 (v01 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: ECDT 0x00000000DCFFA000 000052 (v01 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: HPET 0x00000000DCFF7000 000038 (v01 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: APIC 0x00000000DCFF6000 000098 (v01 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: MCFG 0x00000000DCFF5000 00003C (v01 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: SSDT 0x00000000DCFF4000 000033 (v01 LENOVO TP-SSDT1 00=
000100 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DCFF3000 00044F (v01 LENOVO TP-SSDT2 00=
000200 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DCFE0000 000920 (v01 LENOVO SataAhci 00=
001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DCFDF000 00078E (v01 LENOVO Cpu0Ist  00=
003000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DCFDE000 000AD8 (v01 LENOVO CpuPm    00=
003000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DCFDC000 0011FA (v01 LENOVO SaSsdt   00=
003000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DCFDB000 000379 (v01 LENOVO CppcTabl 00=
001000 INTL 20120711)
[    0.000000] ACPI: PCCT 0x00000000DCFDA000 00006E (v05 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: SSDT 0x00000000DCFD9000 000AC4 (v01 LENOVO Cpc_Tabl 00=
001000 INTL 20120711)
[    0.000000] ACPI: UEFI 0x00000000DCFD8000 000042 (v01 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: MSDM 0x00000000DCF42000 000055 (v03 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: ASF! 0x00000000DCFFC000 0000A5 (v32 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: BATB 0x00000000DCFD7000 000046 (v01 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: FPDT 0x00000000DCFD6000 000064 (v01 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: UEFI 0x00000000DCFD5000 0002E2 (v01 LENOVO TP-J9    00=
002110 PTEC 00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea000c7fffff] PMD -> [ffff88031200000=
0-ffff88031dbfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000031e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000cfcdcfff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000031e5fffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000031e5ff=
fff]
[    0.000000] On node 0 totalpages: 3072633
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13236 pages used for memmap
[    0.000000]   DMA32 zone: 847069 pages, LIFO batch:31
[    0.000000]   Normal zone: 34712 pages used for memmap
[    0.000000]   Normal zone: 2221568 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xdda00000-0xdf9ff=
fff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] clocksource refined-jiffies: mask: 0xffffffff max_cycles: 0x=
ffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff88031e200000 s88984 r8192=
 d29800 u262144
[    0.000000] pcpu-alloc: s88984 r8192 d29800 u262144 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 3024600
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-4.1.1 root=3DUUID=
=3D703fc8b4-b2b9-470b-af2f-9aae9536c2fb ro nordrand rd.auto rd.auto=3D1
[    0.000000] log_buf_len individual max cpu contribution: 16384 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 114688 bytes
[    0.000000] log_buf_len min size: 131072 bytes
[    0.000000] log_buf_len: 262144 bytes
[    0.000000] early log buf free: 121128(92%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 2097152 (order: 12, 1677721=
6 bytes)
[    0.000000] Inode-cache hash table entries: 1048576 (order: 11, 8388608 =
bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] Memory: 11983092K/12290532K available (3688K kernel code, 49=
6K rwdata, 1560K rodata, 808K init, 516K bss, 307440K reserved, 0K cma-rese=
rved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D8, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:488 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource hpet: mask: 0xffffffff max_cycles: 0xffffffff, m=
ax_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2194.966 MHz processor
[    0.000010] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4389.93 BogoMIPS (lpj=3D2194966)
[    0.000135] pid_max: default: 32768 minimum: 301
[    0.000199] ACPI: Core revision 20150410
[    0.015481] ACPI: All ACPI Tables successfully acquired
[    0.019161] Security Framework initialized
[    0.019231] Mount-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.019297] Mountpoint-cache hash table entries: 32768 (order: 6, 262144=
 bytes)
[    0.019582] Initializing cgroup subsys blkio
[    0.019644] Initializing cgroup subsys memory
[    0.019709] Initializing cgroup subsys devices
[    0.019778] Initializing cgroup subsys freezer
[    0.019839] Initializing cgroup subsys net_cls
[    0.019900] Initializing cgroup subsys net_prio
[    0.019980] CPU: Physical Processor ID: 0
[    0.020041] CPU: Processor Core ID: 0
[    0.020104] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.020167] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.020234] mce: CPU supports 9 MCE banks
[    0.020307] CPU0: Thermal monitoring enabled (TM1)
[    0.020377] process: using mwait in idle threads
[    0.020440] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.020503] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.020702] Freeing SMP alternatives memory: 12K (ffffffffad748000 - fff=
fffffad74b000)
[    0.021232] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.031311] TSC deadline timer enabled
[    0.031314] smpboot: CPU0: Intel(R) Core(TM) i7-4702MQ CPU @ 2.20GHz (fa=
m: 06, model: 3c, stepping: 03)
[    0.031523] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events,=
 full-width counters, Intel PMU driver.
[    0.031813] ... version:                3
[    0.031873] ... bit width:              48
[    0.031933] ... generic registers:      4
[    0.031992] ... value mask:             0000ffffffffffff
[    0.032054] ... max period:             0000ffffffffffff
[    0.032116] ... fixed-purpose events:   3
[    0.032176] ... event mask:             000000070000000f
[    0.032434] x86: Booting SMP configuration:
[    0.032495] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.125807] x86: Booted up 1 node, 8 CPUs
[    0.125921] smpboot: Total of 8 processors activated (35119.45 BogoMIPS)
[    0.133005] devtmpfs: initialized
[    0.137740] PM: Registering ACPI NVS region [mem 0xdce3f000-0xdcf7efff] =
(1310720 bytes)
[    0.137911] clocksource jiffies: mask: 0xffffffff max_cycles: 0xffffffff=
, max_idle_ns: 1911260446275000 ns
[    0.138064] prandom: seed boundary self test passed
[    0.138585] prandom: 100 self tests passed
[    0.138648] pinctrl core: initialized pinctrl subsystem
[    0.138888] NET: Registered protocol family 16
[    0.143902] cpuidle: using governor ladder
[    0.149924] cpuidle: using governor menu
[    0.150029] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.150975] ACPI: bus type PCI registered
[    0.152907] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    0.152992] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.153101] PCI: Using configuration type 1 for base access
[    0.153370] perf_event_intel: PMU erratum BJ122, BV98, HSD29 worked arou=
nd, HT is on
[    0.159204] ACPI: Added _OSI(Module Device)
[    0.159265] ACPI: Added _OSI(Processor Device)
[    0.159326] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.159387] ACPI: Added _OSI(Processor Aggregator Device)
[    0.161194] ACPI : EC: EC description table is found, configuring boot EC
[    0.161267] ACPI : EC: EC started
[    0.165978] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.175531] ACPI: Dynamic OEM Table Load:
[    0.175676] ACPI: SSDT 0xFFFF88031076C000 000436 (v01 PmRef  Cpu0Cst  00=
003001 INTL 20120711)
[    0.176475] ACPI: Dynamic OEM Table Load:
[    0.176618] ACPI: SSDT 0xFFFF88031076C800 0005AA (v01 PmRef  ApIst    00=
003000 INTL 20120711)
[    0.177460] ACPI: Dynamic OEM Table Load:
[    0.177601] ACPI: SSDT 0xFFFF88030FC14C00 000119 (v01 PmRef  ApCst    00=
003000 INTL 20120711)
[    0.179375] ACPI: Interpreter enabled
[    0.179442] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20150410/hwxface-580)
[    0.179606] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20150410/hwxface-580)
[    0.179776] ACPI: (supports S0 S3 S5)
[    0.179837] ACPI: Using IOAPIC for interrupt routing
[    0.179923] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.183680] ACPI: Power Resource [PUBS] (on)
[    0.195397] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.195890] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.196481] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11)
[    0.196983] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11)
[    0.197466] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.198044] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.198632] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11)
[    0.199117] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0,=
 disabled.
[    0.199700] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.199768] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cloc=
kPM Segments MSI]
[    0.199938] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapabi=
lity]
[    0.200044] acpi PNP0A08:00: _OSC: not requesting control; platform does=
 not support [PCIeCapability]
[    0.200129] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCI=
eCapability]
[    0.200210] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplu=
g PME AER]
[    0.200291] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.200395] PCI host bridge to bus 0000:00
[    0.200456] pci_bus 0000:00: root bus resource [bus 00-3f]
[    0.200520] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.200585] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.200651] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f window]
[    0.200732] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebffff=
f window]
[    0.200819] pci 0000:00:00.0: [8086:0c04] type 00 class 0x060000
[    0.200920] pci 0000:00:02.0: [8086:0416] type 00 class 0x030000
[    0.200930] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.200936] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit=
 pref]
[    0.200941] pci 0000:00:02.0: reg 0x20: [io  0x5000-0x503f]
[    0.201035] pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
[    0.201043] pci 0000:00:03.0: reg 0x10: [mem 0xf1610000-0xf1613fff 64bit]
[    0.201163] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.201181] pci 0000:00:14.0: reg 0x10: [mem 0xf1600000-0xf160ffff 64bit]
[    0.201237] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.201288] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.201389] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.201407] pci 0000:00:16.0: reg 0x10: [mem 0xf1619000-0xf161900f 64bit]
[    0.201465] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.201558] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    0.201573] pci 0000:00:1b.0: reg 0x10: [mem 0xf1614000-0xf1617fff 64bit]
[    0.201637] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.201691] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.201789] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.201849] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.201968] pci 0000:00:1c.2: [8086:8c14] type 01 class 0x060400
[    0.202029] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.202142] pci 0000:00:1c.3: [8086:8c16] type 01 class 0x060400
[    0.202200] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.205133] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.205238] pci 0000:00:1c.4: [8086:8c18] type 01 class 0x060400
[    0.205304] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.205386] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.205494] pci 0000:00:1f.0: [8086:8c4b] type 00 class 0x060100
[    0.205667] pci 0000:00:1f.2: [8086:8c03] type 00 class 0x010601
[    0.205681] pci 0000:00:1f.2: reg 0x10: [io  0x5088-0x508f]
[    0.205689] pci 0000:00:1f.2: reg 0x14: [io  0x5094-0x5097]
[    0.205697] pci 0000:00:1f.2: reg 0x18: [io  0x5080-0x5087]
[    0.205705] pci 0000:00:1f.2: reg 0x1c: [io  0x5090-0x5093]
[    0.205713] pci 0000:00:1f.2: reg 0x20: [io  0x5060-0x507f]
[    0.205721] pci 0000:00:1f.2: reg 0x24: [mem 0xf161c000-0xf161c7ff]
[    0.205753] pci 0000:00:1f.2: PME# supported from D3hot
[    0.205836] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.205851] pci 0000:00:1f.3: reg 0x10: [mem 0xf1618000-0xf16180ff 64bit]
[    0.205872] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    0.206004] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.206176] pci 0000:02:00.0: [10ec:5227] type 00 class 0xff0000
[    0.206253] pci 0000:02:00.0: reg 0x10: [mem 0xf0e00000-0xf0e00fff]
[    0.206483] pci 0000:02:00.0: supports D1 D2
[    0.206485] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.208141] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.208204] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.208208] pci 0000:00:1c.2:   bridge window [mem 0xf0e00000-0xf15fffff]
[    0.208214] pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf0bfffff=
 64bit pref]
[    0.208316] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.208378] pci 0000:03:00.0: reg 0x10: [io  0x3000-0x30ff]
[    0.208426] pci 0000:03:00.0: reg 0x18: [mem 0xf0d04000-0xf0d04fff 64bit]
[    0.208473] pci 0000:03:00.0: reg 0x20: [mem 0xf0d00000-0xf0d03fff 64bit]
[    0.208743] pci 0000:03:00.0: supports D1 D2
[    0.208745] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.210137] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.210201] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.210204] pci 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf0dfffff]
[    0.210293] pci 0000:04:00.0: [8086:08b2] type 00 class 0x028000
[    0.210348] pci 0000:04:00.0: reg 0x10: [mem 0xf0c00000-0xf0c01fff 64bit]
[    0.210569] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.212144] pci 0000:00:1c.4: PCI bridge to [bus 04]
[    0.212210] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf0cfffff]
[    0.212258] pci_bus 0000:00: on NUMA node 0
[    0.213813] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.214035] ACPI : EC: GPE =3D 0x17, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.214165] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.214229] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.214312] vgaarb: loaded
[    0.214369] vgaarb: bridge control possible 0000:00:02.0
[    0.214483] SCSI subsystem initialized
[    0.214574] libata version 3.00 loaded.
[    0.214642] PCI: Using ACPI for IRQ routing
[    0.216063] PCI: pci_cache_line_size set to 64 bytes
[    0.216144] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
[    0.216145] e820: reserve RAM buffer [mem 0xcfcdd000-0xcfffffff]
[    0.216147] e820: reserve RAM buffer [mem 0x31e600000-0x31fffffff]
[    0.216245] NetLabel: Initializing
[    0.216304] NetLabel:  domain hash size =3D 128
[    0.216364] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.216435] NetLabel:  unlabeled traffic allowed by default
[    0.216536] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.216941] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.220036] Switched to clocksource hpet
[    0.220199] pnp: PnP ACPI init
[    0.220548] system 00:00: [mem 0x00000000-0x0009ffff] could not be reser=
ved
[    0.220615] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reser=
ved
[    0.220681] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reser=
ved
[    0.220747] system 00:00: [mem 0x000c8000-0x000cbfff] could not be reser=
ved
[    0.220819] system 00:00: [mem 0x000cc000-0x000cffff] could not be reser=
ved
[    0.220904] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.220969] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.221044] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.221110] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.221175] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reser=
ved
[    0.221241] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reser=
ved
[    0.221307] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reser=
ved
[    0.221373] system 00:00: [mem 0x000ec000-0x000effff] could not be reser=
ved
[    0.221439] system 00:00: [mem 0x000f0000-0x000fffff] could not be reser=
ved
[    0.221506] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reser=
ved
[    0.221572] system 00:00: [mem 0xfec00000-0xffffffff] could not be reser=
ved
[    0.221639] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.221744] system 00:01: [io  0x1800-0x187f] could not be reserved
[    0.221810] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.221874] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.221938] system 00:01: [io  0x1640-0x165f] has been reserved
[    0.222002] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.222074] system 00:01: [mem 0x00000000-0x00000fff] could not be reser=
ved
[    0.222141] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.222206] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.222271] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.222337] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.222402] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.222467] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.222533] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.222583] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.222606] pnp 00:03: Plug and Play ACPI device, IDs LEN0071 PNP0303 (a=
ctive)
[    0.222627] pnp 00:04: Plug and Play ACPI device, IDs LEN2006 PNP0f13 (a=
ctive)
[    0.223214] pnp: PnP ACPI: found 5 devices
[    0.229432] clocksource acpi_pm: mask: 0xffffff max_cycles: 0xffffff, ma=
x_idle_ns: 2085701024 ns
[    0.229536] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus =
01] add_size 1000
[    0.229539] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 6=
4bit pref] to [bus 01] add_size 200000 add_align 100000
[    0.229542] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] =
to [bus 01] add_size 200000 add_align 100000
[    0.229566] pci 0000:00:1c.0: res[14]=3D[mem 0x00100000-0x000fffff] res_=
to_dev_res add_size 200000 min_align 100000
[    0.229568] pci 0000:00:1c.0: res[14]=3D[mem 0x00100000-0x002fffff] res_=
to_dev_res add_size 200000 min_align 100000
[    0.229570] pci 0000:00:1c.0: res[15]=3D[mem 0x00100000-0x000fffff 64bit=
 pref] res_to_dev_res add_size 200000 min_align 100000
[    0.229572] pci 0000:00:1c.0: res[15]=3D[mem 0x00100000-0x002fffff 64bit=
 pref] res_to_dev_res add_size 200000 min_align 100000
[    0.229574] pci 0000:00:1c.0: res[13]=3D[io  0x1000-0x0fff] res_to_dev_r=
es add_size 1000 min_align 1000
[    0.229576] pci 0000:00:1c.0: res[13]=3D[io  0x1000-0x1fff] res_to_dev_r=
es add_size 1000 min_align 1000
[    0.229580] pci 0000:00:1c.0: BAR 14: assigned [mem 0xdfa00000-0xdfbffff=
f]
[    0.229649] pci 0000:00:1c.0: BAR 15: assigned [mem 0xdfc00000-0xdfdffff=
f 64bit pref]
[    0.229731] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.229796] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.229859] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.229928] pci 0000:00:1c.0:   bridge window [mem 0xdfa00000-0xdfbfffff]
[    0.229996] pci 0000:00:1c.0:   bridge window [mem 0xdfc00000-0xdfdfffff=
 64bit pref]
[    0.230087] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.230150] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.230217] pci 0000:00:1c.2:   bridge window [mem 0xf0e00000-0xf15fffff]
[    0.230284] pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf0bfffff=
 64bit pref]
[    0.230368] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.230431] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.230497] pci 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf0dfffff]
[    0.230569] pci 0000:00:1c.4: PCI bridge to [bus 04]
[    0.230634] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf0cfffff]
[    0.230706] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.230708] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.230710] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff windo=
w]
[    0.230711] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff windo=
w]
[    0.230713] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.230714] pci_bus 0000:01: resource 1 [mem 0xdfa00000-0xdfbfffff]
[    0.230716] pci_bus 0000:01: resource 2 [mem 0xdfc00000-0xdfdfffff 64bit=
 pref]
[    0.230718] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
[    0.230719] pci_bus 0000:02: resource 1 [mem 0xf0e00000-0xf15fffff]
[    0.230721] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf0bfffff 64bit=
 pref]
[    0.230722] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    0.230724] pci_bus 0000:03: resource 1 [mem 0xf0d00000-0xf0dfffff]
[    0.230725] pci_bus 0000:04: resource 1 [mem 0xf0c00000-0xf0cfffff]
[    0.230759] NET: Registered protocol family 2
[    0.230958] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.231199] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.231371] TCP: Hash tables configured (established 131072 bind 65536)
[    0.231452] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.231548] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.231678] NET: Registered protocol family 1
[    0.231752] pci 0000:00:02.0: Video device with shadowed ROM
[    0.231933] PCI: CLS 64 bytes, default 64
[    0.231972] Unpacking initramfs...
[    0.512403] Freeing initrd memory: 14692K (ffff88003633e000 - ffff880037=
197000)
[    0.512512] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.512580] software IO TLB [mem 0xcbcdd000-0xcfcdd000] (64MB) mapped at=
 [ffff8800cbcdd000-ffff8800cfcdcfff]
[    0.512737] RAPL PMU detected, API unit is 2^-32 Joules, 4 fixed counter=
s 655360 ms ovfl timer
[    0.512820] hw unit of domain pp0-core 2^-14 Joules
[    0.512882] hw unit of domain package 2^-14 Joules
[    0.512943] hw unit of domain dram 2^-14 Joules
[    0.513003] hw unit of domain pp1-gpu 2^-14 Joules
[    0.513122] Machine check injector initialized
[    0.513247] microcode: CPU0 sig=3D0x306c3, pf=3D0x10, revision=3D0x17
[    0.513316] microcode: CPU1 sig=3D0x306c3, pf=3D0x10, revision=3D0x17
[    0.513400] microcode: CPU2 sig=3D0x306c3, pf=3D0x10, revision=3D0x17
[    0.513472] microcode: CPU3 sig=3D0x306c3, pf=3D0x10, revision=3D0x17
[    0.513542] microcode: CPU4 sig=3D0x306c3, pf=3D0x10, revision=3D0x17
[    0.513613] microcode: CPU5 sig=3D0x306c3, pf=3D0x10, revision=3D0x17
[    0.513683] microcode: CPU6 sig=3D0x306c3, pf=3D0x10, revision=3D0x17
[    0.513755] microcode: CPU7 sig=3D0x306c3, pf=3D0x10, revision=3D0x17
[    0.513861] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.513969] Scanning for low memory corruption every 60 seconds
[    0.514260] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.514356] Initialise system trusted keyring
[    0.514433] audit: initializing netlink subsys (disabled)
[    0.514511] audit: type=3D2000 audit(1436534395.492:1): initialized
[    0.516221] VFS: Disk quotas dquot_6.6.0
[    0.516314] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)
[    0.516688] Key type big_key registered
[    0.517009] alg: No test for stdrng (krng)
[    0.517959] Key type asymmetric registered
[    0.518021] Asymmetric key parser 'x509' registered
[    0.518096] bounce: pool size: 64 pages
[    0.518183] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.518303] io scheduler noop registered
[    0.518378] io scheduler deadline registered (default)
[    0.518798] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    0.518860] crc32: self tests passed, processed 225944 bytes in 174463 n=
sec
[    0.519102] crc32c: CRC_LE_BITS =3D 64
[    0.519161] crc32c: self tests passed, processed 225944 bytes in 87930 n=
sec
[    0.533105] crc32_combine: 8373 self tests passed
[    0.547013] crc32c_combine: 8373 self tests passed
[    0.547496] intel_idle: MWAIT substates: 0x42120
[    0.547498] intel_idle: v0.4 model 0x3C
[    0.547499] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.547806] GHES: HEST is not enabled!
[    0.547909] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
[    0.548757] ahci 0000:00:1f.2: version 3.0
[    0.548879] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
7 impl SATA mode
[    0.548962] ahci 0000:00:1f.2: flags: 64bit ncq ilck pm led clo pio slum=
 part ems apst=20
[    0.552893] scsi host0: ahci
[    0.553075] scsi host1: ahci
[    0.553248] scsi host2: ahci
[    0.553425] scsi host3: ahci
[    0.553597] scsi host4: ahci
[    0.553756] scsi host5: ahci
[    0.553853] ata1: SATA max UDMA/133 abar m2048@0xf161c000 port 0xf161c10=
0 irq 24
[    0.553934] ata2: SATA max UDMA/133 abar m2048@0xf161c000 port 0xf161c18=
0 irq 24
[    0.554014] ata3: SATA max UDMA/133 abar m2048@0xf161c000 port 0xf161c20=
0 irq 24
[    0.554094] ata4: DUMMY
[    0.554150] ata5: DUMMY
[    0.554207] ata6: DUMMY
[    0.554329] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    0.562948] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.563014] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.563196] mousedev: PS/2 mouse device common for all mice
[    0.563296] rtc_cmos 00:02: RTC can wake from S4
[    0.563488] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.563578] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram=
, hpet irqs
[    0.563690] Intel P-state driver initializing.
[    0.564261] NET: Registered protocol family 17
[    0.564369] Key type dns_resolver registered
[    0.565714] Loading compiled-in X.509 certificates
[    0.565817] registered taskstats version 1
[    0.567225] rtc_cmos 00:02: setting system clock to 2015-07-10 13:19:56 =
UTC (1436534396)
[    0.570403] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    0.858750] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.858835] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.858917] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.859154] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    0.859158] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    0.859572] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    0.859575] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    0.859669] ata2.00: ATA-9: SanDisk SSD U110 16GB, U21A001, max UDMA/133
[    0.859756] ata2.00: 31277232 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    0.860158] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    0.860162] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    0.860339] ata1.00: ATA-9: WDC WD10JPVX-08JC3T5, 05.01A05, max UDMA/133
[    0.860407] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32=
), AA
[    0.860569] ata2.00: configured for UDMA/133
[    0.861131] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    0.861135] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    0.861478] ata3.00: ATAPI: HL-DT-ST DVDRAM GU90N, LUE1, max UDMA/133
[    0.861817] ata1.00: configured for UDMA/133
[    0.862063] scsi 0:0:0:0: Direct-Access     ATA      WDC WD10JPVX-08J 1A=
05 PQ: 0 ANSI: 5
[    0.862491] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 =
TB/931 GiB)
[    0.862605] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    0.862668] scsi 1:0:0:0: Direct-Access     ATA      SanDisk SSD U110 00=
1  PQ: 0 ANSI: 5
[    0.862874] sd 1:0:0:0: [sdb] 31277232 512-byte logical blocks: (16.0 GB=
/14.9 GiB)
[    0.862946] sd 0:0:0:0: [sda] Write Protect is off
[    0.862948] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.863009] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    0.863175] sd 1:0:0:0: [sdb] Write Protect is off
[    0.863246] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.863256] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    0.863620] ata3.00: configured for UDMA/133
[    0.863693]  sdb: sdb1 sdb2 sdb3
[    0.863960] sd 1:0:0:0: [sdb] Attached SCSI disk
[    0.866202] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVDRAM GU90N     LU=
E1 PQ: 0 ANSI: 5
[    0.911239]  sda: sda1 sda2 sda3
[    0.911928] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.912173] Freeing unused kernel memory: 808K (ffffffffad67e000 - fffff=
fffad748000)
[    0.912255] Write protecting the kernel read-only data: 6144k
[    0.912575] Freeing unused kernel memory: 396K (ffff88002d39d000 - ffff8=
8002d400000)
[    0.912822] Freeing unused kernel memory: 488K (ffff88002d586000 - ffff8=
8002d600000)
[    0.914099] random: systemd urandom read with 18 bits of entropy availab=
le
[    0.914571] systemd[1]: systemd 215 running in system mode. (+PAM +AUDIT=
 +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ -SECCOMP -APPARMOR)
[    0.914849] systemd[1]: Detected architecture 'x86-64'.
[    0.914912] systemd[1]: Running in initial RAM disk.
[    0.915410] systemd[1]: Failed to insert module 'autofs4'
[    0.916527] NET: Registered protocol family 10
[    0.916815] systemd[1]: Inserted module 'ipv6'
[    0.916940] systemd[1]: No hostname configured.
[    0.917003] systemd[1]: Set hostname to <localhost>.
[    0.917086] systemd[1]: Initializing machine ID from random generator.
[    0.940381] systemd[1]: Expecting device dev-disk-by\x2duuid-703fc8b4\x2=
db2b9\x2d470b\x2daf2f\x2d9aae9536c2fb.device...
[    0.940690] systemd[1]: Starting Timers.
[    0.941019] systemd[1]: Reached target Timers.
[    0.941083] systemd[1]: Starting Encrypted Volumes.
[    0.941409] systemd[1]: Reached target Encrypted Volumes.
[    0.941475] systemd[1]: Starting -.slice.
[    0.941812] systemd[1]: Created slice -.slice.
[    0.941878] systemd[1]: Starting Journal Socket (/dev/log).
[    0.942227] systemd[1]: Listening on Journal Socket (/dev/log).
[    0.942296] systemd[1]: Starting udev Kernel Socket.
[    0.942619] systemd[1]: Listening on udev Kernel Socket.
[    0.942684] systemd[1]: Starting Journal Socket.
[    0.943023] systemd[1]: Listening on Journal Socket.
[    0.943089] systemd[1]: Starting System Slice.
[    0.943425] systemd[1]: Created slice System Slice.
[    0.943490] systemd[1]: Starting system-systemd\x2dfsck.slice.
[    0.943840] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[    0.943964] systemd[1]: Started Load Kernel Modules.
[    0.944033] systemd[1]: Starting Apply Kernel Variables...
[    0.944497] systemd[1]: Starting Create list of required static device n=
odes for the current kernel...
[    0.944967] systemd[1]: Starting Journal Service...
[    0.945686] systemd[1]: Started Journal Service.
[    1.019695] device-mapper: uevent: version 1.0.3
[    1.019848] device-mapper: ioctl: 4.31.0-ioctl (2015-3-12) initialised: =
dm-devel@redhat.com
[    1.038878] systemd-udevd[240]: starting version 215
[    1.108705] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0=
D:00/input/input2
[    1.116916] Linux agpgart interface v0.103
[    1.119285] [drm] Initialized drm 1.1.0 20060810
[    1.124657] AVX2 version of gcm_enc/dec engaged.
[    1.124721] AES CTR mode by8 optimization enabled
[    1.127023] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    1.129898] alg: No test for crc32 (crc32-pclmul)
[    1.133156] sr 2:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd=
/rw xa/form2 cdda tray
[    1.133261] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.133492] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.184022] raid6: sse2x1   gen()  7199 MB/s
[    1.201024] raid6: sse2x1   xor()  5878 MB/s
[    1.218070] raid6: sse2x2   gen() 10765 MB/s
[    1.235068] raid6: sse2x2   xor()  7384 MB/s
[    1.252073] raid6: sse2x4   gen() 13214 MB/s
[    1.269102] raid6: sse2x4   xor()  8648 MB/s
[    1.286121] raid6: avx2x1   gen() 16492 MB/s
[    1.303134] raid6: avx2x2   gen() 19621 MB/s
[    1.320154] raid6: avx2x4   gen() 22925 MB/s
[    1.320225] raid6: using algorithm avx2x4 gen() 22925 MB/s
[    1.320283] raid6: using avx2x2 recovery algorithm
[    1.320590] xor: automatically using best checksumming function:
[    1.330163]    avx       : 29444.000 MB/sec
[    1.332028] Btrfs loaded
[    1.332622] BTRFS: device label / devid 1 transid 725 /dev/sdb3
[    1.515403] tsc: Refined TSC clocksource calibration: 2194.918 MHz
[    1.515474] clocksource tsc: mask: 0xffffffffffffffff max_cycles: 0x1fa3=
7202099, max_idle_ns: 440795206796 ns
[    2.516622] Switched to clocksource tsc
[    2.728104] ACPI: Lid Switch [LID]
[    2.728281] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input3
[    2.728368] ACPI: Power Button [PWRF]
[    2.728659] wmi: Mapper loaded
[    2.730971] [drm] Memory usable by graphics device =3D 2048M
[    2.731033] [drm] Replacing VGA console driver
[    2.731644] Console: switching to colour dummy device 80x25
[    2.738136] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.738144] [drm] Driver supports precise vblank timestamp query.
[    2.738232] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[    2.762098] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    2.762397] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08=
:00/LNXVIDEO:00/input/input4
[    2.762447] [drm] Initialized i915 1.6.0 20150327 for 0000:00:02.0 on mi=
nor 0
[    2.774363] fbcon: inteldrmfb (fb0) is primary device
[    3.808649] Console: switching to colour frame buffer device 240x67
[    3.815671] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.815699] i915 0000:00:02.0: registered panic notifier
[    9.074637] random: nonblocking pool is initialized
[   16.771603] NET: Registered protocol family 38
[   17.381548] BTRFS: device fsid 703fc8b4-b2b9-470b-af2f-9aae9536c2fb devi=
d 1 transid 400 /dev/dm-0
[   17.482224] BTRFS info (device dm-0): disk space caching is enabled
[   18.921487] systemd-journald[116]: Received SIGTERM from PID 1 (systemd).
[   20.187464] systemd-default-display-manager-generator[631]: /lib/systemd=
/system/kdm.service is not a systemd unit, we disable the systemd enabled d=
isplay manager
[   22.420673] fuse init (API version 7.23)
[   22.922923] loop: module loaded
[   23.141791] systemd-udevd[663]: starting version 215
[   23.884313] SGI XFS with ACLs, security attributes, realtime, no debug e=
nabled
[   25.028473] ACPI: Deprecated procfs I/F for AC is loaded, please retry w=
ith CONFIG_ACPI_PROCFS_POWER cleared
[   25.030006] ACPI: AC Adapter [AC] (on-line)
[   25.058650] thermal LNXTHERM:00: registered as thermal_zone0
[   25.059596] ACPI: Thermal Zone [THM0] (50 C)
[   25.251601] ACPI: bus type USB registered
[   25.252751] usbcore: registered new interface driver usbfs
[   25.253794] usbcore: registered new interface driver hub
[   25.254885] usbcore: registered new device driver usb
[   25.259607] Non-volatile memory driver v1.3
[   25.267500] EDAC MC: Ver: 3.0.0
[   25.273812] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   25.286796] cfg80211: Calling CRDA to update world regulatory domain
[   25.308531] ACPI: Deprecated procfs I/F for battery is loaded, please re=
try with CONFIG_ACPI_PROCFS_POWER cleared
[   25.309693] ACPI: Battery Slot [BAT0] (battery present)
[   25.381218] xhci_hcd 0000:00:14.0: xHCI Host Controller
[   25.382389] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus =
number 1
[   25.383415] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x1=
00 quirks 0x00009810
[   25.384374] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[   25.384439] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   25.385396] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   25.386338] usb usb1: Product: xHCI Host Controller
[   25.387224] usb usb1: Manufacturer: Linux 4.1.1 xhci-hcd
[   25.388099] usb usb1: SerialNumber: 0000:00:14.0
[   25.389054] hub 1-0:1.0: USB hub found
[   25.389920] hub 1-0:1.0: 14 ports detected
[   25.391703] xhci_hcd 0000:00:14.0: xHCI Host Controller
[   25.392524] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus =
number 2
[   25.393398] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[   25.394221] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   25.394997] usb usb2: Product: xHCI Host Controller
[   25.395804] usb usb2: Manufacturer: Linux 4.1.1 xhci-hcd
[   25.396612] usb usb2: SerialNumber: 0000:00:14.0
[   25.397565] hub 2-0:1.0: USB hub found
[   25.398437] hub 2-0:1.0: 6 ports detected
[   25.399585] usb: failed to peer usb2-port4 and usb1-port3 by location (u=
sb2-port4:none) (usb1-port3:usb2-port3)
[   25.400408] usb usb2-port4: failed to peer to usb1-port3 (-16)
[   25.401258] usb: port power management may be unreliable
[   25.402220] usb: failed to peer usb2-port6 and usb1-port3 by location (u=
sb2-port6:none) (usb1-port3:usb2-port3)
[   25.403064] usb usb2-port6: failed to peer to usb1-port3 (-16)
[   25.438117] EDAC ie31200: No ECC support
[   25.690482] thinkpad_acpi: ThinkPad ACPI Extras v0.25
[   25.691659] thinkpad_acpi: http://ibm-acpi.sf.net/
[   25.692651] thinkpad_acpi: ThinkPad BIOS J9ET91WW (2.11 ), EC unknown
[   25.693646] thinkpad_acpi: Lenovo ThinkPad Edge E540, model 20C6003AGE
[   25.695118] thinkpad_acpi: Unsupported brightness interface, please cont=
act ibm-acpi-devel@lists.sourceforge.net
[   25.696237] thinkpad_acpi: This ThinkPad has standard ACPI backlight bri=
ghtness control, supported by the ACPI video driver
[   25.697281] thinkpad_acpi: Disabling thinkpad-acpi brightness events by =
default...
[   25.702115] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is u=
nblocked
[   25.707475] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   25.708661] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM=
 control
[   25.712329] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_=
acpi/input/input423
[   25.713186] r8169 0000:03:00.0 eth0: RTL8168g/8111g at 0xffffc9000005c00=
0, 28:d2:44:60:12:8f, XID 10900800 IRQ 27
[   25.713188] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 bytes,=
 tx checksumming: ko]
[   25.729715] Intel(R) Wireless WiFi driver for Linux
[   25.731797] Copyright(c) 2003- 2015 Intel Corporation
[   25.733776] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   25.735585] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   25.736645] sr 2:0:0:0: Attached scsi generic sg2 type 5
[   25.745628] usb 1-7: new full-speed USB device number 2 using xhci_hcd
[   25.911971] usb 1-7: New USB device found, idVendor=3D8087, idProduct=3D=
07dc
[   25.913282] usb 1-7: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[   26.193663] Bluetooth: Core ver 2.20
[   26.194813] NET: Registered protocol family 31
[   26.195802] Bluetooth: HCI device and connection manager initialized
[   26.196804] Bluetooth: HCI socket layer initialized
[   26.197808] Bluetooth: L2CAP socket layer initialized
[   26.198798] Bluetooth: SCO socket layer initialized
[   26.214789] iwlwifi 0000:04:00.0: loaded firmware version 25.30.13.0 op_=
mode iwlmvm
[   26.235334] input: PC Speaker as /devices/platform/pcspkr/input/input424
[   26.259446] intel_rapl: Found RAPL domain package
[   26.260680] intel_rapl: Found RAPL domain core
[   26.261763] intel_rapl: Found RAPL domain uncore
[   26.262914] intel_rapl: Found RAPL domain dram
[   26.612849] BTRFS info (device dm-0): disk space caching is enabled
[   26.633395] cfg80211: World regulatory domain updated:
[   26.634616] cfg80211:  DFS Master region: unset
[   26.634632] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenn=
a_gain, max_eirp), (dfs_cac_time)
[   26.636567] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2=
000 mBm), (N/A)
[   26.637518] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2=
000 mBm), (N/A)
[   26.638482] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2=
000 mBm), (N/A)
[   26.639456] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 K=
Hz AUTO), (N/A, 2000 mBm), (N/A)
[   26.640386] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 K=
Hz AUTO), (N/A, 2000 mBm), (0 s)
[   26.641338] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, =
2000 mBm), (0 s)
[   26.642281] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2=
000 mBm), (N/A)
[   26.643224] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/=
A, 0 mBm), (N/A)
[   26.716703] usbcore: registered new interface driver btusb
[   26.729572] Bluetooth: hci0: read Intel version: 370710018002030d00
[   26.755904] snd_hda_intel 0000:00:03.0: bound 0000:00:02.0 (ops i915_exi=
t [i915])
[   26.764520] iwlwifi 0000:04:00.0: Detected Intel(R) Wireless N 7260, REV=
=3D0x144
[   26.765797] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[   26.767237] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[   27.098708] Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw=
-37.7.10-fw-1.80.2.3.d.bseq
[   27.128955] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[   27.234108] Bluetooth: hci0: Intel Bluetooth firmware patch completed an=
d activated
[   27.241008] input: HDA Intel HDMI HDMI/DP,pcm=3D3 as /devices/pci0000:00=
/0000:00:03.0/sound/card0/input425
[   27.242485] input: HDA Intel HDMI HDMI/DP,pcm=3D7 as /devices/pci0000:00=
/0000:00:03.0/sound/card0/input426
[   27.243649] input: HDA Intel HDMI HDMI/DP,pcm=3D8 as /devices/pci0000:00=
/0000:00:03.0/sound/card0/input427
[   27.535676] snd_hda_codec_conexant hdaudioC2D0: CX20751/2: BIOS auto-pro=
bing.
[   27.537158] snd_hda_codec_conexant hdaudioC2D0: autoconfig for CX20751/2=
: line_outs=3D1 (0x17/0x0/0x0/0x0/0x0) type:speaker
[   27.538091] snd_hda_codec_conexant hdaudioC2D0:    speaker_outs=3D0 (0x0=
/0x0/0x0/0x0/0x0)
[   27.539055] snd_hda_codec_conexant hdaudioC2D0:    hp_outs=3D1 (0x16/0x0=
/0x0/0x0/0x0)
[   27.539970] snd_hda_codec_conexant hdaudioC2D0:    mono: mono_out=3D0x0
[   27.540856] snd_hda_codec_conexant hdaudioC2D0:    inputs:
[   27.542133] snd_hda_codec_conexant hdaudioC2D0: Enable sync_write for st=
able communication
[   27.546932] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.=
0/sound/card2/input428
[   27.548130] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:0=
0:1b.0/sound/card2/input429
[   28.491705] r8169 0000:03:00.0 eth0: rtl_ocp_gphy_cond =3D=3D 1 (loop: 1=
0, delay: 25).
[   28.492135] r8169 0000:03:00.0 eth0: rtl_ocp_gphy_cond =3D=3D 1 (loop: 1=
0, delay: 25).
[   28.492565] r8169 0000:03:00.0 eth0: rtl_ocp_gphy_cond =3D=3D 1 (loop: 1=
0, delay: 25).
[   28.752775] r8169 0000:03:00.0 eth0: link down
[   28.909009] sha256_ssse3: Using AVX2 optimized SHA-256 implementation
[   30.246696] Adding 8000364k swap on /dev/mapper/sda2_crypt.  Priority:-1=
 extents:1 across:8000364k FS
[   38.542509] systemd-journald[658]: Received request to flush runtime jou=
rnal from PID 1
[   41.261732] NET: Registered protocol family 15
[   41.408798] sha512_ssse3: Using AVX2 optimized SHA-512 implementation
[   41.927585] RPC: Registered named UNIX socket transport module.
[   41.928647] RPC: Registered udp transport module.
[   41.929621] RPC: Registered tcp transport module.
[   41.930604] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   42.009885] FS-Cache: Loaded
[   42.025553] FS-Cache: Netfs 'nfs' registered for caching
[   42.095178] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   45.519634] CacheFiles: Loaded
[   48.344301] FS-Cache: Cache "mycache" added (type cachefiles)
[   48.345266] CacheFiles: File cache on dm-0 registered
[  156.045127] cfg80211: Calling CRDA for country: AT
[  156.050142] cfg80211: Regulatory domain changed to country: AT
[  156.050147] cfg80211:  DFS Master region: ETSI
[  156.050150] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenn=
a_gain, max_eirp), (dfs_cac_time)
[  156.050154] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2=
000 mBm), (N/A)
[  156.050158] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 K=
Hz AUTO), (N/A, 2000 mBm), (N/A)
[  156.050162] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 K=
Hz AUTO), (N/A, 2000 mBm), (0 s)
[  156.050165] cfg80211:   (5490000 KHz - 5710000 KHz @ 160000 KHz), (N/A, =
2700 mBm), (0 s)
[  156.050167] cfg80211:   (57000000 KHz - 66000000 KHz @ 2160000 KHz), (N/=
A, 4000 mBm), (N/A)
[  467.937892] FS-Cache: Netfs 'cifs' registered for caching
[  467.937964] Key type cifs.spnego registered
[  467.937971] Key type cifs.idmap registered

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="btrfs_transaction_aborted.txt"
Content-Transfer-Encoding: quoted-printable

Jul 10 14:47:29 nephtys kernel: [ 4753.244129] ------------[ cut here ]----=
--------
Jul 10 14:47:29 nephtys kernel: [ 4753.244161] WARNING: CPU: 5 PID: 6349 at=
 fs/btrfs/super.c:260 __btrfs_abort_transaction+0x46/0x104 [btrfs]()
Jul 10 14:47:29 nephtys kernel: [ 4753.244163] BTRFS: Transaction aborted (=
error -95)
Jul 10 14:47:29 nephtys kernel: [ 4753.244164] Modules linked in: md4 nls_u=
tf8 cifs tun ccm hid_generic usbhid hid cachefiles binfmt_misc nfsd auth_rp=
cgss nfs_acl nfs lockd grace fscache sunrpc deflate ctr twofish_generic two=
fish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_common blowfish_=
generic blowfish_x86_64 blowfish_common cast5_avx_x86_64 cast5_generic cast=
_common des_generic cbc cmac xcbc rmd160 sha512_ssse3 sha512_generic md5 hm=
ac crypto_null af_key xfrm_algo sha256_ssse3 sha256_generic arc4 snd_hda_co=
dec_conexant iwlmvm mac80211 btusb snd_hda_codec_hdmi snd_hda_codec_generic=
 x86_pkg_temp_thermal btbcm btintel bluetooth snd_hda_intel intel_powerclam=
p snd_hda_controller intel_rapl snd_hda_codec iwlwifi snd_pcsp thinkpad_acp=
i xhci_pci iosf_mbi ie31200_edac r8169 snd_hda_core tpm_tis sg cfg80211 i2c=
_i801 snd_hwdep kvm_intel snd_pcm_oss xhci_hcd tpm nvram rfkill usbcore kvm=
 edac_core mii usb_common snd_mixer_oss thermal snd_pcm evdev battery snd_t=
imer snd processor ac soundcore tcp_lp md_mod coretemp xfs serpent_avx2 ser=
pent_avx_x86_64 serpent_sse2_x86_64 serpent_generic loop fuse dm_crypt came=
llia_generic camellia_aesni_avx2 camellia_aesni_avx_x86_64 camellia_x86_64 =
xts algif_skcipher af_alg i915 btrfs xor raid6_pq crct10dif_pclmul crc32_pc=
lmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul g=
lue_helper ablk_helper cryptd intel_gtt sr_mod i2c_algo_bit cdrom drm_kms_h=
elper drm agpgart i2c_core wmi video thermal_sys button dm_mirror dm_region=
_hash dm_log dm_mod ipv6
Jul 10 14:47:29 nephtys kernel: [ 4753.244229] CPU: 5 PID: 6349 Comm: kwork=
er/u16:4 Tainted: G     U          4.1.1 #1
Jul 10 14:47:29 nephtys kernel: [ 4753.244230] Hardware name: LENOVO 20C600=
3AGE/20C6003AGE, BIOS J9ET91WW (2.11 ) 07/04/2014
Jul 10 14:47:29 nephtys kernel: [ 4753.244249] Workqueue: btrfs-endio-write=
 btrfs_endio_write_helper [btrfs]
Jul 10 14:47:29 nephtys kernel: [ 4753.244251]  0000000000000000 0000000000=
000009 ffffffff83392df0 ffff8802b9147cf8
Jul 10 14:47:29 nephtys kernel: [ 4753.244254]  ffffffff8303b0e9 ffff880307=
812a50 ffffffffc03c0326 ffff8802bc9f22d0
Jul 10 14:47:29 nephtys kernel: [ 4753.244256]  00000000ffffffa1 ffff880307=
812a50 ffffffffc043fbc0 0000000000000b50
Jul 10 14:47:29 nephtys kernel: [ 4753.244258] Call Trace:
Jul 10 14:47:29 nephtys kernel: [ 4753.244264]  [<ffffffff83392df0>] ? dump=
_stack+0x40/0x50
Jul 10 14:47:29 nephtys kernel: [ 4753.244283]  [<ffffffff8303b0e9>] ? warn=
_slowpath_common+0x93/0xab
Jul 10 14:47:29 nephtys kernel: [ 4753.244300]  [<ffffffffc03c0326>] ? __bt=
rfs_abort_transaction+0x46/0x104 [btrfs]
Jul 10 14:47:29 nephtys kernel: [ 4753.244312]  [<ffffffff8303b146>] ? warn=
_slowpath_fmt+0x45/0x4a
Jul 10 14:47:29 nephtys kernel: [ 4753.244340]  [<ffffffffc03f4610>] ? try_=
merge_map+0xb7/0x10c [btrfs]
Jul 10 14:47:29 nephtys kernel: [ 4753.244355]  [<ffffffffc03c0326>] ? __bt=
rfs_abort_transaction+0x46/0x104 [btrfs]
Jul 10 14:47:29 nephtys kernel: [ 4753.244376]  [<ffffffffc03ea398>] ? btrf=
s_finish_ordered_io+0x302/0x415 [btrfs]
Jul 10 14:47:29 nephtys kernel: [ 4753.244384]  [<ffffffff830012a6>] ? __sw=
itch_to+0x1d2/0x455
Jul 10 14:47:29 nephtys kernel: [ 4753.244408]  [<ffffffffc0407ad8>] ? norm=
al_work_helper+0xaf/0x15c [btrfs]
Jul 10 14:47:29 nephtys kernel: [ 4753.244413]  [<ffffffff8304be86>] ? proc=
ess_one_work+0x142/0x214
Jul 10 14:47:29 nephtys kernel: [ 4753.244418]  [<ffffffff8304c3dc>] ? work=
er_thread+0x1db/0x285
Jul 10 14:47:29 nephtys kernel: [ 4753.244422]  [<ffffffff8304c201>] ? resc=
uer_thread+0x284/0x284
Jul 10 14:47:29 nephtys kernel: [ 4753.244425]  [<ffffffff8304fbca>] ? kthr=
ead+0xab/0xb3
Jul 10 14:47:29 nephtys kernel: [ 4753.244429]  [<ffffffff83050000>] ? kthr=
eadd+0x11b/0x186
Jul 10 14:47:29 nephtys kernel: [ 4753.244432]  [<ffffffff8304fb1f>] ? __kt=
hread_parkme+0x5d/0x5d
Jul 10 14:47:29 nephtys kernel: [ 4753.244436]  [<ffffffff83396992>] ? ret_=
=66rom_fork+0x42/0x70
Jul 10 14:47:29 nephtys kernel: [ 4753.244439]  [<ffffffff8304fb1f>] ? __kt=
hread_parkme+0x5d/0x5d
Jul 10 14:47:29 nephtys kernel: [ 4753.244442] ---[ end trace d6f89ee450ae0=
021 ]---
Jul 10 14:47:29 nephtys kernel: [ 4753.244446] BTRFS warning (device dm-0):=
 btrfs_finish_ordered_io:2896: Aborting unused transaction(unknown).
Jul 10 14:47:29 nephtys kernel: [ 4753.477598] BTRFS warning (device dm-0):=
 btrfs_finish_ordered_io:2896: Aborting unused transaction(unknown).

--wRRV7LY7NUeQGEoC--

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREKAAYFAlWjEyYACgkQSPQ8C8rI6DvEzQD+KNwmsRLsAYE78PiCMuSyrGD/
6ilZ4w7Kghi2sWPPcO8BAJYYP1ifxNGCn/tVRwUffsU4L0APdDVbid5ryXqLmey1
=BdKq
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
