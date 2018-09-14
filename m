Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.idedalo.net ([178.33.75.195]:46344 "EHLO mx1.idedalo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbeINWtP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 18:49:15 -0400
Received: from localhost (ip6-localhost [127.0.0.1])
        by mx1.idedalo.net (Postfix) with ESMTP id 956E6BD8EB3
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 19:33:35 +0200 (CEST)
Received: from mx1.idedalo.net ([127.0.0.1])
        by localhost (mx1.idedalo.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GLLdA2s-FaIZ for <linux-btrfs@vger.kernel.org>;
        Fri, 14 Sep 2018 19:33:33 +0200 (CEST)
Received: from [10.0.1.2] (s000002.idedalo.net [5.23.15.213])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: ralcantara@idedalo.com)
        by mx1.idedalo.net (Postfix) with ESMTPSA id 4FE99BD8EB2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 19:33:33 +0200 (CEST)
Subject: Re: Problem with BTRFS
From: =?UTF-8?Q?Rafael_Jes=c3=bas_Alc=c3=a1ntara_P=c3=a9rez?=
        <ralcantara@idedalo.com>
To: linux-btrfs@vger.kernel.org
References: <c7040285-599d-4f6c-cf16-50dc77c9b5f1@idedalo.com>
Message-ID: <1c9d37c6-929e-cd00-f483-a53a0cca5080@idedalo.com>
Date: Fri, 14 Sep 2018 19:33:33 +0200
MIME-Version: 1.0
In-Reply-To: <c7040285-599d-4f6c-cf16-50dc77c9b5f1@idedalo.com>
Content-Type: multipart/mixed;
 boundary="------------F9DE229353EE27DECF820E87"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------F9DE229353EE27DECF820E87
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi again:

Sorry, I missed some details :)

$ uname -a
Linux gemini 4.17.0-0.bpo.3-amd64 #1 SMP Debian 4.17.17-1~bpo9+1
(2018-08-27) x86_64 GNU/Linux

$ btrfs --version
btrfs-progs v4.13.3

$ sudo btrfs fi show
Label: '/srv/dedalo'  uuid: d1071744-ac3b-4926-bb43-27091ea73c05
        Total devices 4 FS bytes used 2.57TiB
        devid    3 size 1.82TiB used 1.80TiB path /dev/sdd1
        devid    4 size 1.82TiB used 1.81TiB path /dev/sdc1
        devid    5 size 1.82TiB used 1.81TiB path /dev/sdb1
        devid    6 size 10.00GiB used 573.94MiB path /dev/loop0

I can't include "btrfs fi df" because I can't mount the file system.

I've attached the dmesg output to the message.

Greets and thanks again.
Rafael J. Alcántara Pérez.

El 14/09/18 a las 19:27, Rafael Jesús Alcántara Pérez escribió:
> Hi:
> 
> After a power outage, my server refuses to mount a BTRFS file system.
> 
> This is the result of trying to mount with options recovery,ro:
> 
> BTRFS info (device sdc1): use lzo compression, level 0
> BTRFS warning (device sdc1): 'recovery' is deprecated, use
> 'usebackuproot' instead
> BTRFS info (device sdc1): trying to use backup root at mount time
> BTRFS info (device sdc1): disk space caching is enabled
> BTRFS info (device sdc1): has skinny extents
> BTRFS error (device sdc1): super_total_bytes 6010266660864 mismatch with
> fs_devices total_rw_bytes 6010266663424
> BTRFS error (device sdc1): failed to read chunk tree: -22
> BTRFS error (device sdc1): open_ctree failed
> 
> And this is the initial output of a "btrfs check --readonly":
> 
>   https://pastebin.com/6gs7hJTG
> 
> I'm planning to do a "btrfs recover fix-device-size" but I don't know if
> it can be dangerous or if it's better to do a "btrfs check --repair" before.
> 
> Any recommendation?
> 
> Greets and thanks in advance.
> Rafael J. Alcántara Pérez.
> 


-- 

--------------F9DE229353EE27DECF820E87
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Linux version 4.17.0-0.bpo.3-amd64 (debian-kernel@lists.de=
bian.org) (gcc version 6.3.0 20170516 (Debian 6.3.0-18+deb9u1)) #1 SMP De=
bian 4.17.17-1~bpo9+1 (2018-08-27)
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-4.17.0-0.bpo.3-amd64 r=
oot=3DUUID=3De51e49de-ad23-436d-bb84-a50bb8ec8c94 ro quiet vsyscall=3Demu=
late consoleblank=3D0
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating poi=
nt registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Enabled xstate features 0x3, context size is 576 =
bytes, using 'standard' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bfb4ffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000bfb50000-0x00000000bfb65fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000bfb66000-0x00000000bfb85bff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000bfb85c00-0x00000000bfffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000073fffffff] usa=
ble
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: Dell Inc. PowerEdge 2900/0NX642, BIOS 2.7.0 10/30/201=
0
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x740000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EBFFF uncachable
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 3F80000000 write-back
[    0.000000]   1 base 0080000000 mask 3FC0000000 write-back
[    0.000000]   2 base 0100000000 mask 3F00000000 write-back
[    0.000000]   3 base 0200000000 mask 3E00000000 write-back
[    0.000000]   4 base 0400000000 mask 3C00000000 write-back
[    0.000000]   5 base 00BFC00000 mask 3FFFC00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- =
WT =20
[    0.000000] e820: update [mem 0xbfc00000-0xffffffff] usable =3D=3D> re=
served
[    0.000000] e820: last_pfn =3D 0xbfb50 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fe710-0x000fe71f] mapped a=
t [        (ptrval)]
[    0.000000] Base memory trampoline at [        (ptrval)] 99000 size 24=
576
[    0.000000] BRK [0x405e3f000, 0x405e3ffff] PGTABLE
[    0.000000] BRK [0x405e40000, 0x405e40fff] PGTABLE
[    0.000000] BRK [0x405e41000, 0x405e41fff] PGTABLE
[    0.000000] BRK [0x405e42000, 0x405e42fff] PGTABLE
[    0.000000] BRK [0x405e43000, 0x405e43fff] PGTABLE
[    0.000000] BRK [0x405e44000, 0x405e44fff] PGTABLE
[    0.000000] BRK [0x405e45000, 0x405e45fff] PGTABLE
[    0.000000] BRK [0x405e46000, 0x405e46fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x35123000-0x36888fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F2160 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x00000000000F21FC 000084 (v01 DELL   PE_SC3   =
00000001 DELL 00000001)
[    0.000000] ACPI: FACP 0x00000000BFB83524 0000F4 (v03 DELL   PE_SC3   =
00000001 DELL 00000001)
[    0.000000] ACPI: DSDT 0x00000000BFB66000 004996 (v01 DELL   PE_SC3   =
00000001 INTL 20050624)
[    0.000000] ACPI: FACS 0x00000000BFB85C00 000040
[    0.000000] ACPI: FACS 0x00000000BFB85C00 000040
[    0.000000] ACPI: APIC 0x00000000BFB83078 00009E (v01 DELL   PE_SC3   =
00000001 DELL 00000001)
[    0.000000] ACPI: SPCR 0x00000000BFB83130 000050 (v01 DELL   PE_SC3   =
00000001 DELL 00000001)
[    0.000000] ACPI: HPET 0x00000000BFB83184 000038 (v01 DELL   PE_SC3   =
00000001 DELL 00000001)
[    0.000000] ACPI: MCFG 0x00000000BFB831C0 00003C (v01 DELL   PE_SC3   =
00000001 DELL 00000001)
[    0.000000] ACPI: WD__ 0x00000000BFB83200 000134 (v01 DELL   PE_SC3   =
00000001 DELL 00000001)
[    0.000000] ACPI: SLIC 0x00000000BFB83338 000024 (v01 DELL   PE_SC3   =
00000001 DELL 00000001)
[    0.000000] ACPI: ERST 0x00000000BFB6AB18 000210 (v01 DELL   PE_SC3   =
00000001 DELL 00000001)
[    0.000000] ACPI: HEST 0x00000000BFB6AD28 00027C (v01 DELL   PE_SC3   =
00000001 DELL 00000001)
[    0.000000] ACPI: BERT 0x00000000BFB6A998 000030 (v01 DELL   PE_SC3   =
00000001 DELL 00000001)
[    0.000000] ACPI: EINJ 0x00000000BFB6A9C8 000150 (v01 DELL   PE_SC3   =
00000001 DELL 00000001)
[    0.000000] ACPI: TCPA 0x00000000BFB834BC 000064 (v02 DELL   PE_SC3   =
00000001 DELL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000073ffffff=
f]
[    0.000000] NODE_DATA(0) allocated [mem 0x73ffe3000-0x73ffe7fff]
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000073fffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000bfb4ffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000073fffffff]
[    0.000000] Reserved but unavailable: 1297 pages
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000073ff=
fffff]
[    0.000000] On node 0 totalpages: 7338735
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3999 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12206 pages used for memmap
[    0.000000]   DMA32 zone: 781136 pages, LIFO batch:31
[    0.000000]   Normal zone: 102400 pages used for memmap
[    0.000000]   Normal zone: 6553600 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI =
0-23
[    0.000000] IOAPIC[1]: apic_id 5, version 32, address 0xfec80000, GSI =
32-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] ACPI: SPCR: SPCR table version 1
[    0.000000] ACPI: SPCR: Unexpected SPCR Access Width.  Defaulting to b=
yte size
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfb50000-0xbfb65fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfb66000-0xbfb84fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfb85000-0xbfb85fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfb86000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfdffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe000000-0xffffffff]
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles:=
 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] random: get_random_bytes called from start_kernel+0x94/0x5=
40 with crng_init=3D0
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8=
 nr_node_ids:1
[    0.000000] percpu: Embedded 44 pages/cpu @        (ptrval) s142360 r8=
192 d29672 u262144
[    0.000000] pcpu-alloc: s142360 r8192 d29672 u262144 alloc=3D1*2097152=

[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7=20
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 722=
4043
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-4.17.0-0.bpo.3-=
amd64 root=3DUUID=3De51e49de-ad23-436d-bb84-a50bb8ec8c94 ro quiet vsyscal=
l=3Demulate consoleblank=3D0
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - baili=
ng!
[    0.000000] Memory: 28781756K/29354940K available (10252K kernel code,=
 1210K rwdata, 3220K rodata, 1548K init, 656K bss, 573184K reserved, 0K c=
ma-reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D8,=
 Nodes=3D1
[    0.000000] Kernel/User page tables isolation: enabled
[    0.000000] ftrace: allocating 30853 entries in 121 pages
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D512 to nr_cpu_ids=3D8=
=2E
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D8
[    0.000000] NR_IRQS: 33024, nr_irqs: 1032, preallocated irqs: 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] ACPI: Core revision 20180313
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff=
, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] APIC: Switch to symmetric I/O mode setup
[    0.000000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.020000] tsc: Fast TSC calibration using PIT
[    0.024000] tsc: Detected 2493.828 MHz processor
[    0.024000] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycle=
s: 0x23f2736c5f2, max_idle_ns: 440795261817 ns
[    0.024000] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 4987.65 BogoMIPS (lpj=3D9975312)
[    0.024000] pid_max: default: 32768 minimum: 301
[    0.028025] Security Framework initialized
[    0.028027] Yama: disabled by default; enable with sysctl kernel.yama.=
*
[    0.028050] AppArmor: AppArmor initialized
[    0.048145] Dentry cache hash table entries: 4194304 (order: 13, 33554=
432 bytes)
[    0.058210] Inode-cache hash table entries: 2097152 (order: 12, 167772=
16 bytes)
[    0.058567] Mount-cache hash table entries: 65536 (order: 7, 524288 by=
tes)
[    0.058880] Mountpoint-cache hash table entries: 65536 (order: 7, 5242=
88 bytes)
[    0.059245] mce: CPU supports 6 MCE banks
[    0.059254] CPU0: Thermal monitoring enabled (TM1)
[    0.059257] process: using mwait in idle threads
[    0.059263] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.059264] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
[    0.059266] Spectre V2 : Mitigation: Full generic retpoline
[    0.059267] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling R=
SB on context switch
[    0.059268] Speculative Store Bypass: Vulnerable
[    0.059405] Freeing SMP alternatives memory: 24K
[    0.064000] smpboot: CPU0: Intel(R) Xeon(R) CPU           E5420  @ 2.5=
0GHz (family: 0x6, model: 0x17, stepping: 0xa)
[    0.064000] Performance Events: PEBS fmt0+, Core2 events, Intel PMU dr=
iver.
[    0.064000] ... version:                2
[    0.064000] ... bit width:              40
[    0.064000] ... generic registers:      2
[    0.064000] ... value mask:             000000ffffffffff
[    0.064000] ... max period:             000000007fffffff
[    0.064000] ... fixed-purpose events:   3
[    0.064000] ... event mask:             0000000700000003
[    0.064000] Hierarchical SRCU implementation.
[    0.064000] smp: Bringing up secondary CPUs ...
[    0.064000] x86: Booting SMP configuration:
[    0.064000] .... node  #0, CPUs:      #1
[    0.064279] NMI watchdog: Enabled. Permanently consumes one hw-PMU cou=
nter.
[    0.064421]  #2 #3
[    0.070938] smp: Brought up 1 node, 4 CPUs
[    0.070938] smpboot: Max logical packages: 2
[    0.070938] smpboot: Total of 4 processors activated (19950.62 BogoMIP=
S)
[    0.073379] devtmpfs: initialized
[    0.073379] x86/mm: Memory block size: 128MB
[    0.078265] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffff=
fff, max_idle_ns: 7645041785100000 ns
[    0.078265] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.078265] pinctrl core: initialized pinctrl subsystem
[    0.078265] NET: Registered protocol family 16
[    0.078265] audit: initializing netlink subsys (disabled)
[    0.078265] audit: type=3D2000 audit(1536906565.076:1): state=3Dinitia=
lized audit_enabled=3D0 res=3D1
[    0.078265] cpuidle: using governor ladder
[    0.078265] cpuidle: using governor menu
[    0.078265] ACPI FADT declares the system doesn't support PCIe ASPM, s=
o disable it
[    0.078265] ACPI: bus type PCI registered
[    0.078265] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.078265] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe00000=
00-0xefffffff] (base 0xe0000000)
[    0.078265] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E=
820
[    0.078265] PCI: Using configuration type 1 for base access
[    0.078265] PCI: Dell PowerEdge 2900 detected, enabling pci=3Dbfsort.
[    0.080049] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.080050] mtrr: probably your BIOS does not setup all CPUs.
[    0.080050] mtrr: corrected configuration.
[    0.080863] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pag=
es
[    0.080863] ACPI: Added _OSI(Module Device)
[    0.080863] ACPI: Added _OSI(Processor Device)
[    0.080863] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.080863] ACPI: Added _OSI(Processor Aggregator Device)
[    0.080863] ACPI: Added _OSI(Linux-Dell-Video)
[    0.081116] ACPI: 1 ACPI AML tables successfully acquired and loaded
[    0.081426] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.081845] ACPI BIOS Error (bug): Could not resolve [\_SB._OSC.CDW1],=
 AE_NOT_FOUND (20180313/psargs-330)
[    0.081914] ACPI Error: Method parse/execution failed \_SB._OSC, AE_NO=
T_FOUND (20180313/psparse-516)
[    0.082207] ACPI: Interpreter enabled
[    0.082222] ACPI: (supports S0 S4 S5)
[    0.082223] ACPI: Using IOAPIC for interrupt routing
[    0.084142] HEST: Table parsing has been initialized.
[    0.084146] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.084260] ACPI: Enabled 2 GPEs in block 00 to 1F
[    0.088008] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.088008] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cl=
ockPM Segments MSI]
[    0.088008] acpi PNP0A08:00: PCIe AER handled by firmware
[    0.092001] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME PC=
IeCapability]
[    0.092001] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using=
 BIOS configuration
[    0.092169] PCI host bridge to bus 0000:00
[    0.092172] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 wind=
ow]
[    0.092173] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff wind=
ow]
[    0.092175] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff window]
[    0.092177] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfdfff=
fff window]
[    0.092178] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44=
fff window]
[    0.092181] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.092194] pci 0000:00:00.0: [8086:25c0] type 00 class 0x060000
[    0.092245] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.092321] pci 0000:00:02.0: [8086:25e2] type 01 class 0x060400
[    0.092362] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.092444] pci 0000:00:03.0: [8086:25e3] type 01 class 0x060400
[    0.092484] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.092561] pci 0000:00:04.0: [8086:25e4] type 01 class 0x060400
[    0.092602] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.092676] pci 0000:00:05.0: [8086:25e5] type 01 class 0x060400
[    0.092716] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.092789] pci 0000:00:06.0: [8086:25f9] type 01 class 0x060400
[    0.092829] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.092903] pci 0000:00:07.0: [8086:25e7] type 01 class 0x060400
[    0.092943] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.093017] pci 0000:00:10.0: [8086:25f0] type 00 class 0x060000
[    0.093100] pci 0000:00:10.1: [8086:25f0] type 00 class 0x060000
[    0.093636] pci 0000:00:10.2: [8086:25f0] type 00 class 0x060000
[    0.093715] pci 0000:00:11.0: [8086:25f1] type 00 class 0x060000
[    0.093788] pci 0000:00:13.0: [8086:25f3] type 00 class 0x060000
[    0.093861] pci 0000:00:15.0: [8086:25f5] type 00 class 0x060000
[    0.093933] pci 0000:00:16.0: [8086:25f6] type 00 class 0x060000
[    0.094014] pci 0000:00:1c.0: [8086:2690] type 01 class 0x060400
[    0.094047] pci 0000:00:1c.0: enabling Extended Tags
[    0.094087] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.094174] pci 0000:00:1d.0: [8086:2688] type 00 class 0x0c0300
[    0.094214] pci 0000:00:1d.0: reg 0x20: [io  0xcce0-0xccff]
[    0.094290] pci 0000:00:1d.1: [8086:2689] type 00 class 0x0c0300
[    0.094329] pci 0000:00:1d.1: reg 0x20: [io  0xccc0-0xccdf]
[    0.094407] pci 0000:00:1d.2: [8086:268a] type 00 class 0x0c0300
[    0.094446] pci 0000:00:1d.2: reg 0x20: [io  0xcca0-0xccbf]
[    0.094520] pci 0000:00:1d.3: [8086:268b] type 00 class 0x0c0300
[    0.094559] pci 0000:00:1d.3: reg 0x20: [io  0xcc80-0xcc9f]
[    0.094640] pci 0000:00:1d.7: [8086:268c] type 00 class 0x0c0320
[    0.094660] pci 0000:00:1d.7: reg 0x10: [mem 0xfc500400-0xfc5007ff]
[    0.094732] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.094799] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.094909] pci 0000:00:1f.0: [8086:2670] type 00 class 0x060100
[    0.095050] pci 0000:00:1f.2: [8086:2680] type 00 class 0x01018f
[    0.095070] pci 0000:00:1f.2: reg 0x10: [io  0xcc78-0xcc7f]
[    0.095077] pci 0000:00:1f.2: reg 0x14: [io  0xcc70-0xcc73]
[    0.095084] pci 0000:00:1f.2: reg 0x18: [io  0xcc60-0xcc67]
[    0.095090] pci 0000:00:1f.2: reg 0x1c: [io  0xcc58-0xcc5b]
[    0.095097] pci 0000:00:1f.2: reg 0x20: [io  0xcc40-0xcc4f]
[    0.095104] pci 0000:00:1f.2: reg 0x24: [mem 0xfc500000-0xfc5003ff]
[    0.095132] pci 0000:00:1f.2: PME# supported from D3hot
[    0.095510] pci 0000:04:00.0: [8086:3500] type 01 class 0x060400
[    0.097281] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.098199] pci 0000:04:00.3: [8086:350c] type 01 class 0x060400
[    0.100047] pci 0000:04:00.3: PME# supported from D0 D3hot D3cold
[    0.112114] pci 0000:00:02.0: PCI bridge to [bus 04-09]
[    0.112123] pci 0000:00:02.0:   bridge window [mem 0xf2000000-0xf7ffff=
ff]
[    0.113021] pci 0000:05:00.0: [8086:3510] type 01 class 0x060400
[    0.115041] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.116004] pci 0000:05:01.0: [8086:3514] type 01 class 0x060400
[    0.118067] pci 0000:05:01.0: PME# supported from D0 D3hot D3cold
[    0.119444] pci 0000:04:00.0: PCI bridge to [bus 05-08]
[    0.119536] pci 0000:04:00.0:   bridge window [mem 0xf4000000-0xf7ffff=
ff]
[    0.120643] pci 0000:06:00.0: [1166:0103] type 01 class 0x060400
[    0.122433] pci 0000:06:00.0: enabling Extended Tags
[    0.124092] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.126021] pci 0000:05:00.0: PCI bridge to [bus 06-07]
[    0.126112] pci 0000:05:00.0:   bridge window [mem 0xf4000000-0xf7ffff=
ff]
[    0.127444] pci 0000:07:00.0: [14e4:164c] type 00 class 0x020000
[    0.128414] pci 0000:07:00.0: reg 0x10: [mem 0xf4000000-0xf5ffffff 64b=
it]
[    0.131673] pci 0000:07:00.0: PME# supported from D3hot D3cold
[    0.133740] pci 0000:06:00.0: PCI bridge to [bus 07]
[    0.134015] pci 0000:06:00.0:   bridge window [mem 0xf4000000-0xf7ffff=
ff]
[    0.135163] pci 0000:05:01.0: PCI bridge to [bus 08]
[    0.137698] pci 0000:04:00.3: PCI bridge to [bus 09]
[    0.138195] pci 0000:00:03.0: PCI bridge to [bus 0a]
[    0.138240] pci 0000:00:04.0: PCI bridge to [bus 0b]
[    0.138294] pci 0000:01:00.0: [1000:0060] type 00 class 0x010400
[    0.138314] pci 0000:01:00.0: reg 0x10: [mem 0xfc480000-0xfc4bffff 64b=
it]
[    0.138322] pci 0000:01:00.0: reg 0x18: [io  0xec00-0xecff]
[    0.138334] pci 0000:01:00.0: reg 0x1c: [mem 0xfc440000-0xfc47ffff 64b=
it]
[    0.138348] pci 0000:01:00.0: reg 0x30: [mem 0xfc300000-0xfc307fff pre=
f]
[    0.138394] pci 0000:01:00.0: supports D1
[    0.148015] pci 0000:00:05.0: PCI bridge to [bus 01]
[    0.148018] pci 0000:00:05.0:   bridge window [io  0xe000-0xefff]
[    0.148021] pci 0000:00:05.0:   bridge window [mem 0xfc300000-0xfc4fff=
ff]
[    0.148094] pci 0000:00:06.0: PCI bridge to [bus 0c]
[    0.148128] pci 0000:00:07.0: PCI bridge to [bus 0d]
[    0.148183] pci 0000:02:00.0: [1166:0103] type 01 class 0x060400
[    0.148232] pci 0000:02:00.0: enabling Extended Tags
[    0.148282] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.148363] pci 0000:00:1c.0: ASPM: current common clock configuration=
 is broken, reconfiguring
[    0.160018] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    0.160023] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xfbffff=
ff]
[    0.160099] pci 0000:03:00.0: [14e4:164c] type 00 class 0x020000
[    0.160127] pci 0000:03:00.0: reg 0x10: [mem 0xf8000000-0xf9ffffff 64b=
it]
[    0.160222] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.160318] pci 0000:02:00.0: PCI bridge to [bus 03]
[    0.160327] pci 0000:02:00.0:   bridge window [mem 0xf8000000-0xfbffff=
ff]
[    0.160391] pci 0000:0e:0d.0: [1002:515e] type 00 class 0x030000
[    0.160411] pci 0000:0e:0d.0: reg 0x10: [mem 0xd8000000-0xdfffffff pre=
f]
[    0.160420] pci 0000:0e:0d.0: reg 0x14: [io  0xdc00-0xdcff]
[    0.160429] pci 0000:0e:0d.0: reg 0x18: [mem 0xfc2d0000-0xfc2dffff]
[    0.160461] pci 0000:0e:0d.0: reg 0x30: [mem 0x00000000-0x0001ffff pre=
f]
[    0.160493] pci 0000:0e:0d.0: supports D1 D2
[    0.160553] pci 0000:00:1e.0: PCI bridge to [bus 0e] (subtractive deco=
de)
[    0.160556] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.160560] pci 0000:00:1e.0:   bridge window [mem 0xfc100000-0xfc2fff=
ff]
[    0.160564] pci 0000:00:1e.0:   bridge window [mem 0xd8000000-0xdfffff=
ff 64bit pref]
[    0.160566] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7 windo=
w] (subtractive decode)
[    0.160568] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff windo=
w] (subtractive decode)
[    0.160570] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bff=
ff window] (subtractive decode)
[    0.160571] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfdffff=
ff window] (subtractive decode)
[    0.160573] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44f=
ff window] (subtractive decode)
[    0.162605] ACPI: PCI Interrupt Link [LK00] (IRQs 3 4 5 6 7 *10 11 12)=

[    0.162679] ACPI: PCI Interrupt Link [LK01] (IRQs 3 4 5 6 7 10 11 12) =
*0, disabled.
[    0.162753] ACPI: PCI Interrupt Link [LK02] (IRQs 3 4 5 6 7 10 11 12) =
*0, disabled.
[    0.162826] ACPI: PCI Interrupt Link [LK03] (IRQs 3 4 5 *6 7 10 11 12)=

[    0.162898] ACPI: PCI Interrupt Link [LK04] (IRQs 3 4 5 6 7 10 11 12) =
*14
[    0.162970] ACPI: PCI Interrupt Link [LK05] (IRQs 3 4 5 6 7 10 11 12) =
*15
[    0.163043] ACPI: PCI Interrupt Link [LK06] (IRQs 3 4 5 6 7 10 11 12) =
*0, disabled.
[    0.163116] ACPI: PCI Interrupt Link [LK07] (IRQs 3 4 5 6 7 10 *11 12)=

[    0.163251] pci 0000:0e:0d.0: vgaarb: setting as boot VGA device
[    0.163251] pci 0000:0e:0d.0: vgaarb: VGA device added: decodes=3Dio+m=
em,owns=3Dio+mem,locks=3Dnone
[    0.163251] pci 0000:0e:0d.0: vgaarb: bridge control possible
[    0.163251] vgaarb: loaded
[    0.163251] pps_core: LinuxPPS API ver. 1 registered
[    0.163251] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    0.163251] PTP clock support registered
[    0.163251] EDAC MC: Ver: 3.0.0
[    0.164047] PCI: Using ACPI for IRQ routing
[    0.169708] PCI: pci_cache_line_size set to 64 bytes
[    0.170193] e820: reserve RAM buffer [mem 0xbfb50000-0xbfffffff]
[    0.170334] HPET: 3 timers in total, 0 timers will be used for per-cpu=
 timer
[    0.170334] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.170334] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.172035] clocksource: Switched to clocksource tsc-early
[    0.187272] VFS: Disk quotas dquot_6.6.0
[    0.187301] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 by=
tes)
[    0.187488] AppArmor: AppArmor Filesystem Enabled
[    0.187517] pnp: PnP ACPI init
[    0.187736] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    0.187783] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.187909] pnp 00:02: Plug and Play ACPI device, IDs PNP0700 (disable=
d)
[    0.188146] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.188379] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.190545] system 00:05: [io  0x0800-0x087f] has been reserved
[    0.190547] system 00:05: [io  0x0880-0x08bf] has been reserved
[    0.190549] system 00:05: [io  0x08c0-0x08df] has been reserved
[    0.190551] system 00:05: [io  0x08e0-0x08e3] has been reserved
[    0.190552] system 00:05: [io  0x0900] has been reserved
[    0.190554] system 00:05: [io  0x0c00-0x0c7f] has been reserved
[    0.190556] system 00:05: [io  0x0ca0-0x0ca7] has been reserved
[    0.190558] system 00:05: [io  0x0ca9-0x0cab] has been reserved
[    0.190560] system 00:05: [io  0x0cad-0x0caf] has been reserved
[    0.190565] system 00:05: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    0.190641] system 00:06: [io  0x0ca8] has been reserved
[    0.190643] system 00:06: [io  0x0cac] has been reserved
[    0.190649] system 00:06: Plug and Play ACPI device, IDs IPI0001 PNP0c=
01 (active)
[    0.191284] system 00:07: [mem 0xe0000000-0xefffffff] has been reserve=
d
[    0.191289] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.191459] pnp: PnP ACPI: found 8 devices
[    0.199628] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff,=
 max_idle_ns: 2085701024 ns
[    0.200463] pci 0000:06:00.0: PCI bridge to [bus 07]
[    0.200559] pci 0000:06:00.0:   bridge window [mem 0xf4000000-0xf7ffff=
ff]
[    0.200834] pci 0000:05:00.0: PCI bridge to [bus 06-07]
[    0.200925] pci 0000:05:00.0:   bridge window [mem 0xf4000000-0xf7ffff=
ff]
[    0.201064] pci 0000:05:01.0: PCI bridge to [bus 08]
[    0.201294] pci 0000:04:00.0: PCI bridge to [bus 05-08]
[    0.201385] pci 0000:04:00.0:   bridge window [mem 0xf4000000-0xf7ffff=
ff]
[    0.201523] pci 0000:04:00.3: PCI bridge to [bus 09]
[    0.201752] pci 0000:00:02.0: PCI bridge to [bus 04-09]
[    0.201755] pci 0000:00:02.0:   bridge window [mem 0xf2000000-0xf7ffff=
ff]
[    0.201760] pci 0000:00:03.0: PCI bridge to [bus 0a]
[    0.201766] pci 0000:00:04.0: PCI bridge to [bus 0b]
[    0.201772] pci 0000:00:05.0: PCI bridge to [bus 01]
[    0.201774] pci 0000:00:05.0:   bridge window [io  0xe000-0xefff]
[    0.201778] pci 0000:00:05.0:   bridge window [mem 0xfc300000-0xfc4fff=
ff]
[    0.201782] pci 0000:00:06.0: PCI bridge to [bus 0c]
[    0.201789] pci 0000:00:07.0: PCI bridge to [bus 0d]
[    0.201795] pci 0000:02:00.0: PCI bridge to [bus 03]
[    0.201800] pci 0000:02:00.0:   bridge window [mem 0xf8000000-0xfbffff=
ff]
[    0.201809] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    0.201813] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xfbffff=
ff]
[    0.201824] pci 0000:0e:0d.0: BAR 6: assigned [mem 0xfc100000-0xfc11ff=
ff pref]
[    0.201827] pci 0000:00:1e.0: PCI bridge to [bus 0e]
[    0.201829] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.201833] pci 0000:00:1e.0:   bridge window [mem 0xfc100000-0xfc2fff=
ff]
[    0.201836] pci 0000:00:1e.0:   bridge window [mem 0xd8000000-0xdfffff=
ff 64bit pref]
[    0.201842] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.201843] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.201845] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff win=
dow]
[    0.201847] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfdffffff win=
dow]
[    0.201849] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff win=
dow]
[    0.201851] pci_bus 0000:04: resource 1 [mem 0xf2000000-0xf7ffffff]
[    0.201852] pci_bus 0000:05: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.201854] pci_bus 0000:06: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.201856] pci_bus 0000:07: resource 1 [mem 0xf4000000-0xf7ffffff]
[    0.201858] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.201860] pci_bus 0000:01: resource 1 [mem 0xfc300000-0xfc4fffff]
[    0.201862] pci_bus 0000:02: resource 1 [mem 0xf8000000-0xfbffffff]
[    0.201863] pci_bus 0000:03: resource 1 [mem 0xf8000000-0xfbffffff]
[    0.201865] pci_bus 0000:0e: resource 0 [io  0xd000-0xdfff]
[    0.201867] pci_bus 0000:0e: resource 1 [mem 0xfc100000-0xfc2fffff]
[    0.201868] pci_bus 0000:0e: resource 2 [mem 0xd8000000-0xdfffffff 64b=
it pref]
[    0.201870] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7 window]
[    0.201872] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff window]
[    0.201873] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff win=
dow]
[    0.201875] pci_bus 0000:0e: resource 7 [mem 0xc0000000-0xfdffffff win=
dow]
[    0.201876] pci_bus 0000:0e: resource 8 [mem 0xfed40000-0xfed44fff win=
dow]
[    0.201935] NET: Registered protocol family 2
[    0.202150] tcp_listen_portaddr_hash hash table entries: 16384 (order:=
 6, 262144 bytes)
[    0.202358] TCP established hash table entries: 262144 (order: 9, 2097=
152 bytes)
[    0.203413] TCP bind hash table entries: 65536 (order: 8, 1048576 byte=
s)
[    0.203911] TCP: Hash tables configured (established 262144 bind 65536=
)
[    0.204003] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.204265] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes=
)
[    0.204581] NET: Registered protocol family 1
[    0.206373] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
[    0.206380] pci 0000:01:00.0: [Firmware Bug]: disabling VPD access (ca=
n't determine size of non-standard VPD format)
[    0.206628] pci 0000:0e:0d.0: Video device with shadowed ROM at [mem 0=
x000c0000-0x000dffff]
[    0.206631] PCI: CLS 64 bytes, default 64
[    0.206701] Unpacking initramfs...
[    0.669250] Freeing initrd memory: 23960K
[    0.669294] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.669298] software IO TLB [mem 0xbbb50000-0xbfb50000] (64MB) mapped =
at [        (ptrval)-        (ptrval)]
[    0.670328] Initialise system trusted keyrings
[    0.670453] workingset: timestamp_bits=3D40 max_order=3D23 bucket_orde=
r=3D0
[    0.672457] zbud: loaded
[    0.672776] pstore: using deflate compression
[    1.109623] Key type asymmetric registered
[    1.109625] Asymmetric key parser 'x509' registered
[    1.109665] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 248)
[    1.109753] io scheduler noop registered
[    1.109754] io scheduler deadline registered
[    1.109815] io scheduler cfq registered (default)
[    1.109817] io scheduler mq-deadline registered
[    1.114210] pcieport 0000:00:02.0: Signaling PME with IRQ 24
[    1.114231] pcieport 0000:00:03.0: Signaling PME with IRQ 25
[    1.114249] pcieport 0000:00:04.0: Signaling PME with IRQ 26
[    1.114267] pcieport 0000:00:05.0: Signaling PME with IRQ 27
[    1.114293] pcieport 0000:00:06.0: Signaling PME with IRQ 28
[    1.114312] pcieport 0000:00:07.0: Signaling PME with IRQ 29
[    1.114333] pcieport 0000:00:1c.0: Signaling PME with IRQ 30
[    1.114368] intel_idle: does not run on family 6 model 23
[    1.114864] ERST: Failed to get Error Log Address Range.
[    1.115104] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[    1.115197] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.135635] 00:03: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200=
) is a 16550A
[    1.156163] 00:04: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D 115200=
) is a 16550A
[    1.156658] Linux agpgart interface v0.103
[    1.156743] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[    1.156744] AMD IOMMUv2 functionality not available on this system
[    1.157141] i8042: PNP: No PS/2 controller found.
[    1.157142] i8042: Probing ports directly.
[    1.159986] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.159990] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.160179] mousedev: PS/2 mouse device common for all mice
[    1.160228] rtc_cmos 00:01: RTC can wake from S4
[    1.160380] rtc_cmos 00:01: registered as rtc0
[    1.160398] rtc_cmos 00:01: alarms up to one day, y3k, 242 bytes nvram=
, hpet irqs
[    1.160478] ledtrig-cpu: registered to indicate activity on CPUs
[    1.161102] NET: Registered protocol family 10
[    1.164824] Segment Routing with IPv6
[    1.164841] mip6: Mobile IPv6
[    1.164843] NET: Registered protocol family 17
[    1.164847] mpls_gso: MPLS GSO support
[    1.165121] microcode: sig=3D0x1067a, pf=3D0x40, revision=3D0xa0b
[    1.165220] microcode: Microcode Update Driver: v2.2.
[    1.165231] sched_clock: Marking stable (1165208949, 0)->(1249913775, =
-84704826)
[    1.165558] registered taskstats version 1
[    1.165559] Loading compiled-in X.509 certificates
[    1.220521] Loaded X.509 cert 'secure-boot-test-key-lfaraone: 97c1b25c=
ddf9873ca78a58f3d73bf727d2cf78ff'
[    1.220837] Loaded X.509 cert 'Debian Project: Ben Hutchings: 008a018d=
ca80932630'
[    1.220854] zswap: loaded using pool lzo/zbud
[    1.220967] AppArmor: AppArmor sha1 policy hashing enabled
[    1.221383] rtc_cmos 00:01: setting system clock to 2018-09-14 06:29:2=
6 UTC (1536906566)
[    1.224162] Freeing unused kernel memory: 1548K
[    1.248022] Write protecting the kernel read-only data: 16384k
[    1.248886] Freeing unused kernel memory: 2024K
[    1.251263] Freeing unused kernel memory: 876K
[    1.261678] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    1.261678] x86/mm: Checking user space page tables
[    1.271779] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    1.286646] random: systemd-udevd: uninitialized urandom read (16 byte=
s read)
[    1.286760] random: systemd-udevd: uninitialized urandom read (16 byte=
s read)
[    1.286773] random: systemd-udevd: uninitialized urandom read (16 byte=
s read)
[    1.338330] bnx2: QLogic bnx2 Gigabit Ethernet Driver v2.2.6 (January =
29, 2014)
[    1.339158] bnx2 0000:03:00.0 eth0: Broadcom NetXtreme II BCM5708 1000=
Base-T (B2) PCI-X 64-bit 133MHz found at mem f8000000, IRQ 16, node addr =
00:22:19:c9:a8:15
[    1.341740] bnx2 0000:07:00.0 eth1: Broadcom NetXtreme II BCM5708 1000=
Base-T (B2) PCI-X 64-bit 133MHz found at mem f4000000, IRQ 16, node addr =
00:22:19:c9:a8:17
[    1.342404] SCSI subsystem initialized
[    1.344826] megasas: 07.704.04.00-rc1
[    1.348277] ACPI: bus type USB registered
[    1.348313] usbcore: registered new interface driver usbfs
[    1.348323] usbcore: registered new interface driver hub
[    1.348368] usbcore: registered new device driver usb
[    1.349900] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    1.351162] ehci-pci: EHCI PCI platform driver
[    1.351460] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    1.351469] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bu=
s number 1
[    1.351487] ehci-pci 0000:00:1d.7: debug port 1
[    1.351555] uhci_hcd: USB Universal Host Controller Interface driver
[    1.355389] ehci-pci 0000:00:1d.7: cache line size of 64 is not suppor=
ted
[    1.355768] megaraid_sas 0000:01:00.0: FW now in Ready state
[    1.355773] megaraid_sas 0000:01:00.0: 64 bit DMA mask and 32 bit cons=
istent mask
[    1.356040] megaraid_sas 0000:01:00.0: firmware supports msix	: (0)
[    1.356042] megaraid_sas 0000:01:00.0: current msix/online cpus	: (0/4=
)
[    1.356044] megaraid_sas 0000:01:00.0: RDPQ mode	: (disabled)
[    1.356157] ehci-pci 0000:00:1d.7: irq 21, io mem 0xfc500400
[    1.358057] libata version 3.00 loaded.
[    1.372020] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.372102] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002, bcdDevice=3D 4.17
[    1.372104] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.372105] usb usb1: Product: EHCI Host Controller
[    1.372107] usb usb1: Manufacturer: Linux 4.17.0-0.bpo.3-amd64 ehci_hc=
d
[    1.372108] usb usb1: SerialNumber: 0000:00:1d.7
[    1.372260] hub 1-0:1.0: USB hub found
[    1.372274] hub 1-0:1.0: 8 ports detected
[    1.372766] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.372775] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bu=
s number 2
[    1.372784] uhci_hcd 0000:00:1d.0: detected 2 ports
[    1.372815] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000cce0
[    1.372893] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001, bcdDevice=3D 4.17
[    1.372895] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.372897] usb usb2: Product: UHCI Host Controller
[    1.372899] usb usb2: Manufacturer: Linux 4.17.0-0.bpo.3-amd64 uhci_hc=
d
[    1.372900] usb usb2: SerialNumber: 0000:00:1d.0
[    1.373046] hub 2-0:1.0: USB hub found
[    1.373055] hub 2-0:1.0: 2 ports detected
[    1.373404] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.373409] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bu=
s number 3
[    1.373415] uhci_hcd 0000:00:1d.1: detected 2 ports
[    1.373455] uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000ccc0
[    1.373512] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001, bcdDevice=3D 4.17
[    1.373514] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.373516] usb usb3: Product: UHCI Host Controller
[    1.373517] usb usb3: Manufacturer: Linux 4.17.0-0.bpo.3-amd64 uhci_hc=
d
[    1.373519] usb usb3: SerialNumber: 0000:00:1d.1
[    1.373631] hub 3-0:1.0: USB hub found
[    1.373639] hub 3-0:1.0: 2 ports detected
[    1.373795] ata_piix 0000:00:1f.2: version 2.13
[    1.374000] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.440010] megaraid_sas 0000:01:00.0: controller type	: MR(256MB)
[    1.440013] megaraid_sas 0000:01:00.0: Online Controller Reset(OCR)	: =
Enabled
[    1.440015] megaraid_sas 0000:01:00.0: Secure JBOD support	: No
[    1.440017] megaraid_sas 0000:01:00.0: NVMe passthru support	: No
[    1.440019] megaraid_sas 0000:01:00.0: megasas_init_mfi: fw_support_ie=
ee=3D0
[    1.440036] megaraid_sas 0000:01:00.0: INIT adapter done
[    1.440038] megaraid_sas 0000:01:00.0: Jbod map is not supported megas=
as_setup_jbod_map 5132
[    1.468008] megaraid_sas 0000:01:00.0: MR_DCMD_PD_LIST_QUERY failed/no=
t supported by firmware
[    1.496010] megaraid_sas 0000:01:00.0: DCMD not supported by firmware =
- megasas_ld_list_query 4544
[    1.524015] megaraid_sas 0000:01:00.0: pci id		: (0x1000)/(0x0060)/(0x=
1028)/(0x1f0c)
[    1.524017] megaraid_sas 0000:01:00.0: unevenspan support	: no
[    1.524019] megaraid_sas 0000:01:00.0: firmware crash dump	: no
[    1.524021] megaraid_sas 0000:01:00.0: jbod sync map		: no
[    1.524024] scsi host0: Avago SAS based MegaRAID driver
[    1.526285] scsi 0:0:0:0: Direct-Access     SEAGATE  ST3500620SS      =
MS0C PQ: 0 ANSI: 5
[    1.532406] scsi host1: ata_piix
[    1.532531] scsi host2: ata_piix
[    1.532583] ata1: SATA max UDMA/133 cmd 0xcc78 ctl 0xcc70 bmdma 0xcc40=
 irq 23
[    1.532584] ata2: SATA max UDMA/133 cmd 0xcc60 ctl 0xcc58 bmdma 0xcc48=
 irq 23
[    1.532851] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.532859] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bu=
s number 4
[    1.532867] uhci_hcd 0000:00:1d.2: detected 2 ports
[    1.532895] uhci_hcd 0000:00:1d.2: irq 21, io base 0x0000cca0
[    1.533007] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001, bcdDevice=3D 4.17
[    1.533009] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.533010] usb usb4: Product: UHCI Host Controller
[    1.533012] usb usb4: Manufacturer: Linux 4.17.0-0.bpo.3-amd64 uhci_hc=
d
[    1.533013] usb usb4: SerialNumber: 0000:00:1d.2
[    1.533158] hub 4-0:1.0: USB hub found
[    1.533167] hub 4-0:1.0: 2 ports detected
[    1.533480] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.533486] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bu=
s number 5
[    1.533492] uhci_hcd 0000:00:1d.3: detected 2 ports
[    1.533516] uhci_hcd 0000:00:1d.3: irq 20, io base 0x0000cc80
[    1.533603] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001, bcdDevice=3D 4.17
[    1.533605] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.533606] usb usb5: Product: UHCI Host Controller
[    1.533608] usb usb5: Manufacturer: Linux 4.17.0-0.bpo.3-amd64 uhci_hc=
d
[    1.533609] usb usb5: SerialNumber: 0000:00:1d.3
[    1.533748] hub 5-0:1.0: USB hub found
[    1.533756] hub 5-0:1.0: 2 ports detected
[    1.556874] scsi 0:0:1:0: Direct-Access     SEAGATE  ST500NM0001      =
PS07 PQ: 0 ANSI: 6
[    1.592511] scsi 0:0:2:0: Direct-Access     ATA      WDC WD20EZRZ-00Z =
0A80 PQ: 0 ANSI: 5
[    1.642267] scsi 0:0:3:0: Direct-Access     ATA      WDC WD20EZRZ-00Z =
0A80 PQ: 0 ANSI: 5
[    1.672954] scsi 0:0:4:0: Direct-Access     ATA      WDC WD20EZRZ-00Z =
0A80 PQ: 0 ANSI: 5
[    1.692010] tsc: Refined TSC clocksource calibration: 2493.749 MHz
[    1.692018] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2=
3f228f923f, max_idle_ns: 440795318852 ns
[    1.702683] clocksource: Switched to clocksource tsc
[    1.702810] ata2.01: NODEV after polling detection
[    1.705111] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-H653F, D300, max UDMA=
/100
[    1.705114] ata2.00: applying bridge limits
[    1.709598] ata2.00: configured for UDMA/100
[    1.844013] usb 3-2: new low-speed USB device number 2 using uhci_hcd
[    2.041025] usb 3-2: New USB device found, idVendor=3D0e8f, idProduct=3D=
0020, bcdDevice=3D 2.01
[    2.041027] usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    2.041029] usb 3-2: Product: PS2toUSB Adapter
[    2.041031] usb 3-2: Manufacturer: GASIA
[    2.046194] hidraw: raw HID events driver (C) Jiri Kosina
[    2.084398] usbcore: registered new interface driver usbhid
[    2.084399] usbhid: USB HID core driver
[    2.085169] input: GASIA PS2toUSB Adapter as /devices/pci0000:00/0000:=
00:1d.1/usb3/3-2/3-2:1.0/0003:0E8F:0020.0001/input/input3
[    2.144151] hid-generic 0003:0E8F:0020.0001: input,hidraw0: USB HID v1=
=2E10 Keyboard [GASIA PS2toUSB Adapter] on usb-0000:00:1d.1-2/input0
[    2.144606] input: GASIA PS2toUSB Adapter as /devices/pci0000:00/0000:=
00:1d.1/usb3/3-2/3-2:1.1/0003:0E8F:0020.0002/input/input4
[    2.204092] hid-generic 0003:0E8F:0020.0002: input,hidraw1: USB HID v1=
=2E10 Mouse [GASIA PS2toUSB Adapter] on usb-0000:00:1d.1-2/input1
[    2.472013] usb 1-7: new high-speed USB device number 3 using ehci-pci=

[    2.628318] usb 1-7: New USB device found, idVendor=3D04b4, idProduct=3D=
6560, bcdDevice=3D 0.0b
[    2.628320] usb 1-7: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    2.628478] hub 1-7:1.0: USB hub found
[    2.628573] hub 1-7:1.0: 4 ports detected
[    2.790009] scsi 0:0:32:0: Enclosure         DP       BACKPLANE       =
 1.05 PQ: 0 ANSI: 5
[    4.572073] floppy0: no floppy controllers found
[    9.716191] random: fast init done
[   10.132243] scsi 0:2:0:0: Direct-Access     DELL     PERC 6/i         =
1.22 PQ: 0 ANSI: 5
[   10.132764] scsi 0:2:1:0: Direct-Access     DELL     PERC 6/i         =
1.22 PQ: 0 ANSI: 5
[   10.133243] scsi 0:2:2:0: Direct-Access     DELL     PERC 6/i         =
1.22 PQ: 0 ANSI: 5
[   10.133726] scsi 0:2:3:0: Direct-Access     DELL     PERC 6/i         =
1.22 PQ: 0 ANSI: 5
[   18.273362] scsi 2:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-H653F =
D300 PQ: 0 ANSI: 5
[   18.319548] sd 0:2:1:0: [sdb] 3905945600 512-byte logical blocks: (2.0=
0 TB/1.82 TiB)
[   18.319637] sd 0:2:1:0: [sdb] Write Protect is off
[   18.319640] sd 0:2:1:0: [sdb] Mode Sense: 1f 00 10 08
[   18.319737] sd 0:2:1:0: [sdb] Write cache: disabled, read cache: enabl=
ed, supports DPO and FUA
[   18.319787] sd 0:2:0:0: [sda] 975699968 512-byte logical blocks: (500 =
GB/465 GiB)
[   18.319829] sd 0:2:0:0: [sda] Write Protect is off
[   18.319831] sd 0:2:0:0: [sda] Mode Sense: 1f 00 10 08
[   18.319840] sd 0:2:3:0: [sdd] 3905945600 512-byte logical blocks: (2.0=
0 TB/1.82 TiB)
[   18.319868] sd 0:2:3:0: [sdd] Write Protect is off
[   18.319869] sd 0:2:3:0: [sdd] Mode Sense: 1f 00 10 08
[   18.319891] sd 0:2:0:0: [sda] Write cache: disabled, read cache: enabl=
ed, supports DPO and FUA
[   18.320076] sd 0:2:3:0: [sdd] Write cache: disabled, read cache: enabl=
ed, supports DPO and FUA
[   18.321106] sd 0:2:2:0: [sdc] 3905945600 512-byte logical blocks: (2.0=
0 TB/1.82 TiB)
[   18.321156] sd 0:2:2:0: [sdc] Write Protect is off
[   18.321157] sd 0:2:2:0: [sdc] Mode Sense: 1f 00 10 08
[   18.321223] sd 0:2:2:0: [sdc] Write cache: disabled, read cache: enabl=
ed, supports DPO and FUA
[   18.336611]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   18.337300] sd 0:2:0:0: [sda] Attached SCSI disk
[   18.371755] scsi 0:0:32:0: Wrong diagnostic page; asked for 10 got 0
[   18.385925] sr 2:0:0:0: [sr0] scsi3-mmc drive: 48x/48x writer dvd-ram =
cd/rw xa/form2 cdda tray
[   18.385926] cdrom: Uniform CD-ROM driver Revision: 3.20
[   18.386169] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   18.488247]  sdb: sdb1
[   18.488715] sd 0:2:1:0: [sdb] Attached SCSI disk
[   18.498973]  sdc: sdc1
[   18.499537] sd 0:2:2:0: [sdc] Attached SCSI disk
[   18.662427] ses 0:0:32:0: Attached Enclosure device
[   18.893327]  sdd: sdd1
[   18.893919] sd 0:2:3:0: [sdd] Attached SCSI disk
[   19.932019] raid6: sse2x1   gen()  3598 MB/s
[   20.000010] raid6: sse2x1   xor()  4203 MB/s
[   20.068020] raid6: sse2x2   gen()  6657 MB/s
[   20.136013] raid6: sse2x2   xor()  5119 MB/s
[   20.204021] raid6: sse2x4   gen()  7522 MB/s
[   20.272021] raid6: sse2x4   xor()  5554 MB/s
[   20.272022] raid6: using algorithm sse2x4 gen() 7522 MB/s
[   20.272022] raid6: .... xor() 5554 MB/s, rmw enabled
[   20.272023] raid6: using ssse3x2 recovery algorithm
[   20.274959] xor: measuring software checksum speed
[   20.312012]    prefetch64-sse: 10139.000 MB/sec
[   20.352009]    generic_sse:  8921.000 MB/sec
[   20.352010] xor: using function: prefetch64-sse (10139.000 MB/sec)
[   20.413557] Btrfs loaded, crc32c=3Dcrc32c-generic
[   20.950255] BTRFS: device label /srv/dedalo devid 4 transid 1231485 /d=
ev/sdc1
[   20.950524] BTRFS: device label /srv/dedalo devid 3 transid 1231484 /d=
ev/sdd1
[   20.950779] BTRFS: device label /srv/dedalo devid 5 transid 1231485 /d=
ev/sdb1
[   20.966954] PM: Image not found (code -22)
[   21.058658] SGI XFS with ACLs, security attributes, realtime, no debug=
 enabled
[   21.184042] XFS (sda6): Mounting V4 Filesystem
[   21.309473] XFS (sda6): Starting recovery (logdev: internal)
[   21.408217] XFS (sda6): Ending recovery (logdev: internal)
[   22.453240] systemd[1]: systemd 232 running in system mode. (+PAM +AUD=
IT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT =
+GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[   22.472141] systemd[1]: Detected architecture x86-64.
[   22.481162] systemd[1]: Set hostname to <gemini>.
[   25.100954] systemd[1]: Started Forward Password Requests to Wall Dire=
ctory Watch.
[   25.101037] systemd[1]: Listening on LVM2 poll daemon socket.
[   25.101094] systemd[1]: Listening on Journal Socket (/dev/log).
[   25.102194] systemd[1]: Created slice User and Session Slice.
[   25.102235] systemd[1]: Listening on fsck to fsckd communication Socke=
t.
[   25.102289] systemd[1]: Listening on Device-mapper event daemon FIFOs.=

[   25.102338] systemd[1]: Listening on udev Kernel Socket.
[   25.421164] RPC: Registered named UNIX socket transport module.
[   25.421166] RPC: Registered udp transport module.
[   25.421167] RPC: Registered tcp transport module.
[   25.421167] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   25.618783] systemd-journald[233]: Received request to flush runtime j=
ournal from PID 1
[   26.057840] loop: module loaded
[   26.115785] ipmi message handler version 39.2
[   26.138474] ipmi device interface
[   26.154762] IPMI System Interface driver.
[   26.154783] ipmi_si dmi-ipmi-si.0: ipmi_platform: probing via SMBIOS
[   26.154785] ipmi_si: SMBIOS: io 0xca8 regsize 1 spacing 4 irq 0
[   26.154786] ipmi_si: Adding SMBIOS-specified kcs state machine
[   26.154843] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o =
address 0xca8, slave address 0x20, irq 0
[   26.472314] ipmi_si dmi-ipmi-si.0: Found new BMC (man_id: 0x0002a2, pr=
od_id: 0x0100, dev_id: 0x20)
[   26.491370] ipmi_si dmi-ipmi-si.0: IPMI kcs interface initialized
[   26.502367] IPMI Watchdog: driver initialized
[   26.508254] Copyright (C) 2004 MontaVista Software - IPMI Powerdown vi=
a sys_reboot.
[   26.510606] IPMI poweroff: ATCA Detect mfg 0x2A2 prod 0x100
[   26.510607] IPMI poweroff: Found a chassis style poweroff function
[   26.656233] i5k_amb i5k_amb.0: hwmon_device_register() is deprecated. =
Please convert the driver to use hwmon_device_register_with_info().
[   26.898820] EDAC MC0: Giving out device to module i5000_edac.c control=
ler I5000: DEV 0000:00:10.0 (POLLED)
[   26.898837] EDAC PCI0: Giving out device to module i5000_edac controll=
er EDAC PCI controller: DEV 0000:00:10.0 (POLLED)
[   26.944447] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input5
[   26.945587] shpchp: Standard Hot Plug PCI Controller Driver version: 0=
=2E4
[   26.945812] ACPI: Power Button [PWRF]
[   27.060947] intel_rng: FWH not detected
[   27.106726] ses 0:0:32:0: Attached scsi generic sg0 type 13
[   27.106777] sd 0:2:0:0: Attached scsi generic sg1 type 0
[   27.106828] sd 0:2:1:0: Attached scsi generic sg2 type 0
[   27.106877] sd 0:2:2:0: Attached scsi generic sg3 type 0
[   27.106925] sd 0:2:3:0: Attached scsi generic sg4 type 0
[   27.106971] sr 2:0:0:0: Attached scsi generic sg5 type 5
[   27.288326] input: PC Speaker as /devices/platform/pcspkr/input/input6=

[   27.304403] intel_powerclamp: No package C-state available
[   27.356477] intel_powerclamp: No package C-state available
[   27.428795] intel_powerclamp: No package C-state available
[   27.429255] dcdbas dcdbas: Dell Systems Management Base Driver (versio=
n 5.6.0-3.2)
[   27.509394] iTCO_vendor_support: vendor-support=3D0
[   27.544339] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   27.544397] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=3D2,=
 TCOBASE=3D0x0860)
[   27.544411] watchdog: iTCO_wdt: cannot register miscdev on minor=3D130=
 (err=3D-16).
[   27.544476] watchdog: iTCO_wdt: a legacy watchdog module is probably p=
resent.
[   27.544597] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[   27.973253] Adding 3903756k swap on /dev/sda5.  Priority:-2 extents:1 =
across:3903756k FS
[   28.048486] [drm] radeon kernel modesetting enabled.
[   28.048941] [drm] initializing kernel modesetting (RV100 0x1002:0x515E=
 0x1028:0x01B1 0x02).
[   28.049039] radeon 0000:0e:0d.0: VRAM: 128M 0x00000000D8000000 - 0x000=
00000DFFFFFFF (16M used)
[   28.049041] radeon 0000:0e:0d.0: GTT: 512M 0x00000000B8000000 - 0x0000=
0000D7FFFFFF
[   28.049048] [drm] Detected VRAM RAM=3D128M, BAR=3D128M
[   28.049049] [drm] RAM width 16bits DDR
[   28.049159] [TTM] Zone  kernel: Available graphics memory: 14405094 ki=
B
[   28.049160] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB=

[   28.049161] [TTM] Initializing pool allocator
[   28.049166] [TTM] Initializing DMA pool allocator
[   28.049190] [drm] radeon: 16M of VRAM memory ready
[   28.049191] [drm] radeon: 512M of GTT memory ready.
[   28.049204] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   28.069732] [drm] PCI GART of 512M enabled (table at 0x000000003610000=
0).
[   28.069772] radeon 0000:0e:0d.0: WB disabled
[   28.069775] radeon 0000:0e:0d.0: fence driver on ring 0 use gpu addr 0=
x00000000b8000000 and cpu addr 0x        (ptrval)
[   28.069777] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013)=
=2E
[   28.069778] [drm] Driver supports precise vblank timestamp query.
[   28.069803] [drm] radeon: irq initialized.
[   28.069812] [drm] Loading R100 Microcode
[   28.203162] radeon 0000:0e:0d.0: firmware: direct-loading firmware rad=
eon/R100_cp.bin
[   28.203648] [drm] radeon: ring at 0x00000000B8001000
[   28.203673] [drm] ring test succeeded in 1 usecs
[   28.204154] [drm] ib test succeeded in 0 usecs
[   28.204426] [drm] Radeon Display Connectors
[   28.204427] [drm] Connector 0:
[   28.204428] [drm]   VGA-1
[   28.204429] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[   28.204430] [drm]   Encoders:
[   28.204431] [drm]     CRT1: INTERNAL_DAC1
[   28.274397] [drm] fb mappable at 0xD8040000
[   28.274398] [drm] vram apper at 0xD8000000
[   28.274399] [drm] size 3842048
[   28.274399] [drm] fb depth is 16
[   28.274400] [drm]    pitch is 3200
[   28.274494] fbcon: radeondrmfb (fb0) is primary device
[   28.457728] cryptd: max_cpu_qlen set to 1000
[   28.461341] Console: switching to colour frame buffer device 200x75
[   28.497509] radeon 0000:0e:0d.0: fb0: radeondrmfb frame buffer device
[   28.575435] [drm] Initialized radeon 2.50.0 20080528 for 0000:0e:0d.0 =
on minor 0
[   28.790644] EXT4-fs (sda3): mounting ext3 file system using the ext4 s=
ubsystem
[   28.793483] EXT4-fs (sda3): mounted filesystem with ordered data mode.=
 Opts: (null)
[   30.172041] floppy0: no floppy controllers found
[   30.310837] audit: type=3D1400 audit(1536906595.585:2): apparmor=3D"ST=
ATUS" operation=3D"profile_load" profile=3D"unconfined" name=3D"/usr/bin/=
lxc-start" pid=3D486 comm=3D"apparmor_parser"
[   30.491792] audit: type=3D1400 audit(1536906595.765:3): apparmor=3D"ST=
ATUS" operation=3D"profile_load" profile=3D"unconfined" name=3D"/usr/sbin=
/named" pid=3D487 comm=3D"apparmor_parser"
[   30.606830] audit: type=3D1400 audit(1536906595.881:4): apparmor=3D"ST=
ATUS" operation=3D"profile_load" profile=3D"unconfined" name=3D"lxc-conta=
iner-default" pid=3D488 comm=3D"apparmor_parser"
[   30.606963] audit: type=3D1400 audit(1536906595.881:5): apparmor=3D"ST=
ATUS" operation=3D"profile_load" profile=3D"unconfined" name=3D"lxc-conta=
iner-default-cgns" pid=3D488 comm=3D"apparmor_parser"
[   30.607064] audit: type=3D1400 audit(1536906595.881:6): apparmor=3D"ST=
ATUS" operation=3D"profile_load" profile=3D"unconfined" name=3D"lxc-conta=
iner-default-with-mounting" pid=3D488 comm=3D"apparmor_parser"
[   30.607161] audit: type=3D1400 audit(1536906595.881:7): apparmor=3D"ST=
ATUS" operation=3D"profile_load" profile=3D"unconfined" name=3D"lxc-conta=
iner-default-with-nesting" pid=3D488 comm=3D"apparmor_parser"
[   31.520428] new mount options do not match the existing superblock, wi=
ll be ignored
[   31.777690] fuse init (API version 7.26)
[   32.161760] bridge: filtering via arp/ip/ip6tables is no longer availa=
ble by default. Update your scripts to load br_netfilter if you need this=
=2E
[   32.165703] lxcbr0: port 1(eth0) entered blocking state
[   32.165705] lxcbr0: port 1(eth0) entered disabled state
[   32.165786] device eth0 entered promiscuous mode
[   32.293907] bnx2 0000:03:00.0: firmware: direct-loading firmware bnx2/=
bnx2-mips-06-6.2.3.fw
[   32.314997] bnx2 0000:03:00.0: firmware: direct-loading firmware bnx2/=
bnx2-rv2p-06-6.0.15.fw
[   32.440022] bnx2 0000:03:00.0 eth0: using MSI
[   32.442339] lxcbr0: port 1(eth0) entered blocking state
[   32.442341] lxcbr0: port 1(eth0) entered forwarding state
[   32.442378] IPv6: ADDRCONF(NETDEV_UP): lxcbr0: link is not ready
[   33.180055] lxcbr0: port 1(eth0) entered disabled state
[   35.591333] bnx2 0000:03:00.0 eth0: NIC Copper Link is Up, 1000 Mbps f=
ull duplex
[   35.591436] lxcbr0: port 1(eth0) entered blocking state
[   35.591438] lxcbr0: port 1(eth0) entered forwarding state
[   35.591491] IPv6: ADDRCONF(NETDEV_CHANGE): lxcbr0: link becomes ready
[   44.495441] audit: type=3D1400 audit(1536906609.770:8): apparmor=3D"ST=
ATUS" operation=3D"profile_replace" info=3D"same as current profile, skip=
ping" profile=3D"unconfined" name=3D"/usr/bin/lxc-start" pid=3D781 comm=3D=
"apparmor_parser"
[   44.504427] audit: type=3D1400 audit(1536906609.782:9): apparmor=3D"ST=
ATUS" operation=3D"profile_replace" profile=3D"unconfined" name=3D"lxc-co=
ntainer-default" pid=3D785 comm=3D"apparmor_parser"
[   44.504431] audit: type=3D1400 audit(1536906609.782:10): apparmor=3D"S=
TATUS" operation=3D"profile_replace" profile=3D"unconfined" name=3D"lxc-c=
ontainer-default-cgns" pid=3D785 comm=3D"apparmor_parser"
[   44.504434] audit: type=3D1400 audit(1536906609.782:11): apparmor=3D"S=
TATUS" operation=3D"profile_replace" profile=3D"unconfined" name=3D"lxc-c=
ontainer-default-with-mounting" pid=3D785 comm=3D"apparmor_parser"
[   44.504437] audit: type=3D1400 audit(1536906609.782:12): apparmor=3D"S=
TATUS" operation=3D"profile_replace" profile=3D"unconfined" name=3D"lxc-c=
ontainer-default-with-nesting" pid=3D785 comm=3D"apparmor_parser"
[   45.387865] lxcbr0: port 2(vethPIM6Y0) entered blocking state
[   45.387868] lxcbr0: port 2(vethPIM6Y0) entered disabled state
[   45.387924] device vethPIM6Y0 entered promiscuous mode
[   45.388423] IPv6: ADDRCONF(NETDEV_UP): vethPIM6Y0: link is not ready
[   45.465807] eth0: renamed from vethAMB6QG
[   45.484225] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   45.484721] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   45.484749] IPv6: ADDRCONF(NETDEV_CHANGE): vethPIM6Y0: link becomes re=
ady
[   45.484767] lxcbr0: port 2(vethPIM6Y0) entered blocking state
[   45.484769] lxcbr0: port 2(vethPIM6Y0) entered forwarding state
[   46.087949] lxcbr0: port 3(veth62T5FH) entered blocking state
[   46.087951] lxcbr0: port 3(veth62T5FH) entered disabled state
[   46.088036] device veth62T5FH entered promiscuous mode
[   46.088122] IPv6: ADDRCONF(NETDEV_UP): veth62T5FH: link is not ready
[   46.088124] lxcbr0: port 3(veth62T5FH) entered blocking state
[   46.088126] lxcbr0: port 3(veth62T5FH) entered forwarding state
[   46.137928] eth0: renamed from vethI42397
[   46.157309] IPv6: ADDRCONF(NETDEV_CHANGE): veth62T5FH: link becomes re=
ady
[   46.568794] lxcbr0: port 4(vethPPKV6Q) entered blocking state
[   46.568798] lxcbr0: port 4(vethPPKV6Q) entered disabled state
[   46.568869] device vethPPKV6Q entered promiscuous mode
[   46.568964] IPv6: ADDRCONF(NETDEV_UP): vethPPKV6Q: link is not ready
[   46.621854] eth0: renamed from vethN2NN8N
[   46.648234] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   46.648541] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   46.648568] IPv6: ADDRCONF(NETDEV_CHANGE): vethPPKV6Q: link becomes re=
ady
[   46.648586] lxcbr0: port 4(vethPPKV6Q) entered blocking state
[   46.648588] lxcbr0: port 4(vethPPKV6Q) entered forwarding state
[   47.479619] lxcbr0: port 5(vethWMFGRR) entered blocking state
[   47.479623] lxcbr0: port 5(vethWMFGRR) entered disabled state
[   47.479683] device vethWMFGRR entered promiscuous mode
[   47.479763] IPv6: ADDRCONF(NETDEV_UP): vethWMFGRR: link is not ready
[   47.479765] lxcbr0: port 5(vethWMFGRR) entered blocking state
[   47.479767] lxcbr0: port 5(vethWMFGRR) entered forwarding state
[   47.533743] eth0: renamed from vethHIGGXF
[   47.548703] IPv6: ADDRCONF(NETDEV_CHANGE): vethWMFGRR: link becomes re=
ady
[   48.167945] lxcbr0: port 6(vethFI8WFT) entered blocking state
[   48.167948] lxcbr0: port 6(vethFI8WFT) entered disabled state
[   48.168148] device vethFI8WFT entered promiscuous mode
[   48.168236] IPv6: ADDRCONF(NETDEV_UP): vethFI8WFT: link is not ready
[   48.238311] eth0: renamed from vethBNDRMO
[   48.260201] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   48.261270] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   48.261300] IPv6: ADDRCONF(NETDEV_CHANGE): vethFI8WFT: link becomes re=
ady
[   48.261321] lxcbr0: port 6(vethFI8WFT) entered blocking state
[   48.261323] lxcbr0: port 6(vethFI8WFT) entered forwarding state
[   58.485457] random: crng init done
[   58.485459] random: 7 urandom warning(s) missed due to ratelimiting
[  106.784692] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready
[  351.171801] BTRFS: device label /srv/dedalo devid 6 transid 1231485 /d=
ev/loop0
[  552.672991] BTRFS info (device sdc1): use lzo compression, level 0
[  552.672995] BTRFS info (device sdc1): disk space caching is enabled
[  552.672996] BTRFS info (device sdc1): has skinny extents
[  552.750087] BTRFS error (device sdc1): super_total_bytes 6010266660864=
 mismatch with fs_devices total_rw_bytes 6010266663424
[  552.750428] BTRFS error (device sdc1): failed to read chunk tree: -22
[  552.785302] BTRFS error (device sdc1): open_ctree failed
[  887.721654] perf: interrupt took too long (2520 > 2500), lowering kern=
el.perf_event_max_sample_rate to 79250
[  946.280585] perf: interrupt took too long (3163 > 3150), lowering kern=
el.perf_event_max_sample_rate to 63000
[ 1167.814852] perf: interrupt took too long (3974 > 3953), lowering kern=
el.perf_event_max_sample_rate to 50250
[ 1809.430639] perf: interrupt took too long (4974 > 4967), lowering kern=
el.perf_event_max_sample_rate to 40000
[26088.757016] BTRFS info (device sdc1): use lzo compression, level 0
[26088.757021] BTRFS warning (device sdc1): 'recovery' is deprecated, use=
 'usebackuproot' instead
[26088.757022] BTRFS info (device sdc1): trying to use backup root at mou=
nt time
[26088.757023] BTRFS info (device sdc1): disk space caching is enabled
[26088.757025] BTRFS info (device sdc1): has skinny extents
[26089.295229] BTRFS error (device sdc1): super_total_bytes 6010266660864=
 mismatch with fs_devices total_rw_bytes 6010266663424
[26089.295565] BTRFS error (device sdc1): failed to read chunk tree: -22
[26089.337423] BTRFS error (device sdc1): open_ctree failed
[26136.285005] BTRFS info (device sdc1): use lzo compression, level 0
[26136.285010] BTRFS warning (device sdc1): 'recovery' is deprecated, use=
 'usebackuproot' instead
[26136.285012] BTRFS info (device sdc1): trying to use backup root at mou=
nt time
[26136.285013] BTRFS info (device sdc1): disk space caching is enabled
[26136.285014] BTRFS info (device sdc1): has skinny extents
[26136.296227] BTRFS error (device sdc1): super_total_bytes 6010266660864=
 mismatch with fs_devices total_rw_bytes 6010266663424
[26136.296570] BTRFS error (device sdc1): failed to read chunk tree: -22
[26136.328828] BTRFS error (device sdc1): open_ctree failed
[26243.323334] BTRFS info (device sdc1): use lzo compression, level 0
[26243.323339] BTRFS warning (device sdc1): 'recovery' is deprecated, use=
 'usebackuproot' instead
[26243.323340] BTRFS info (device sdc1): trying to use backup root at mou=
nt time
[26243.323342] BTRFS info (device sdc1): disk space caching is enabled
[26243.323343] BTRFS info (device sdc1): has skinny extents
[26243.334722] BTRFS error (device sdc1): super_total_bytes 6010266660864=
 mismatch with fs_devices total_rw_bytes 6010266663424
[26243.335079] BTRFS error (device sdc1): failed to read chunk tree: -22
[26243.383437] BTRFS error (device sdc1): open_ctree failed
[26517.703119] BTRFS info (device sdc1): use lzo compression, level 0
[26517.703121] BTRFS info (device sdc1): disk space caching is enabled
[26517.703123] BTRFS info (device sdc1): has skinny extents
[26517.714724] BTRFS error (device sdc1): super_total_bytes 6010266660864=
 mismatch with fs_devices total_rw_bytes 6010266663424
[26517.715080] BTRFS error (device sdc1): failed to read chunk tree: -22
[26517.763915] BTRFS error (device sdc1): open_ctree failed
[26592.539048] BTRFS info (device sdc1): use lzo compression, level 0
[26592.539053] BTRFS warning (device sdc1): 'recovery' is deprecated, use=
 'usebackuproot' instead
[26592.539054] BTRFS info (device sdc1): trying to use backup root at mou=
nt time
[26592.539055] BTRFS info (device sdc1): disk space caching is enabled
[26592.539056] BTRFS info (device sdc1): has skinny extents
[26592.550703] BTRFS error (device sdc1): super_total_bytes 6010266660864=
 mismatch with fs_devices total_rw_bytes 6010266663424
[26592.551056] BTRFS error (device sdc1): failed to read chunk tree: -22
[26592.598954] BTRFS error (device sdc1): open_ctree failed
[26630.993520] BTRFS info (device sdc1): use lzo compression, level 0
[26630.993525] BTRFS info (device sdc1): trying to use backup root at mou=
nt time
[26630.993526] BTRFS info (device sdc1): disk space caching is enabled
[26630.993527] BTRFS info (device sdc1): has skinny extents
[26631.070090] BTRFS error (device sdc1): super_total_bytes 6010266660864=
 mismatch with fs_devices total_rw_bytes 6010266663424
[26631.070434] BTRFS error (device sdc1): failed to read chunk tree: -22
[26631.118462] BTRFS error (device sdc1): open_ctree failed

--------------F9DE229353EE27DECF820E87--
