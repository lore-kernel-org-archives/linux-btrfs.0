Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vsmx011.vodafonemail.xion.oxcs.net ([153.92.174.89]:50338 "EHLO
        vsmx011.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756572AbdEKXYT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 19:24:19 -0400
To: lists@colorremedies.com
References: <CAJCQCtRNzJPNhMwRtha3Wf1WReDQvaXY=7CpZGW4M=mONLrLSQ@mail.gmail.com>
Subject: Re: Creating btrfs RAID on LUKS devs makes devices disappear
Cc: linux-btrfs@vger.kernel.org
From: Ochi <ochi@arcor.de>
Message-ID: <4b7809e0-7329-62b0-c488-51bd4f0318a6@arcor.de>
Date: Fri, 12 May 2017 01:24:08 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRNzJPNhMwRtha3Wf1WReDQvaXY=7CpZGW4M=mONLrLSQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------C88D14D0FB12660CCFE09440"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------C88D14D0FB12660CCFE09440
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

here is the journal.log (I hope). It's quite interesting. I rebooted the 
machine, performed a mkfs.btrfs on dm-{2,3,4} and dm-3 was missing 
afterwards (around timestamp 66.*). However, I then logged into the 
machine from another terminal (around timestamp 118.*) which triggered 
something to make the device appear again :O Indeed, dm-3 was once again 
there after logging in. Does systemd mix something up?

Hmm, I just did another mkfs once the devices where back, devices were 
missing, but they re-appeared a few seconds later, without logging into 
a terminal. After another mkfs, they were gone again and are now still 
gone after waiting a few minutes. It's really weird, I can't really tell 
what triggers this yet. Will test more tomorrow, let me know if you have 
any more ideas what to try.

Best regards
Sebastian

--------------C88D14D0FB12660CCFE09440
Content-Type: text/x-log;
 name="journal.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="journal.log"

-- Logs begin at Sun 2017-03-26 20:36:24 CEST, end at Fri 2017-05-12 01:00:45 CEST. --
[    0.000000] nas kernel: Linux version 4.9.27-1-lts (builduser@andyrtr) (gcc version 6.3.1 20170306 (GCC) ) #1 SMP Mon May 8 13:37:42 CEST 2017
[    0.000000] nas kernel: Command line: BOOT_IMAGE=/default/vmlinuz-linux-lts root=UUID=4ac09b56-3e02-40c0-bf64-02a4cf9344fc rw rootflags=subvol=default ip=192.168.0.3:::::eth0:none cryptdevice=/dev/sda2:root:allow-discards
[    0.000000] nas kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] nas kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] nas kernel: x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registers'
[    0.000000] nas kernel: x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] nas kernel: x86/fpu: xstate_offset[3]:  576, xstate_sizes[3]:   64
[    0.000000] nas kernel: x86/fpu: xstate_offset[4]:  640, xstate_sizes[4]:   64
[    0.000000] nas kernel: x86/fpu: Enabled xstate features 0x1b, context size is 704 bytes, using 'compacted' format.
[    0.000000] nas kernel: x86/fpu: Using 'eager' FPU context switches.
[    0.000000] nas kernel: e820: BIOS-provided physical RAM map:
[    0.000000] nas kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009c3ff] usable
[    0.000000] nas kernel: BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] nas kernel: BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] nas kernel: BIOS-e820: [mem 0x0000000000100000-0x0000000078770fff] usable
[    0.000000] nas kernel: BIOS-e820: [mem 0x0000000078771000-0x0000000078771fff] ACPI NVS
[    0.000000] nas kernel: BIOS-e820: [mem 0x0000000078772000-0x0000000078772fff] reserved
[    0.000000] nas kernel: BIOS-e820: [mem 0x0000000078773000-0x000000007e137fff] usable
[    0.000000] nas kernel: BIOS-e820: [mem 0x000000007e138000-0x000000007e5bafff] reserved
[    0.000000] nas kernel: BIOS-e820: [mem 0x000000007e5bb000-0x000000007e667fff] usable
[    0.000000] nas kernel: BIOS-e820: [mem 0x000000007e668000-0x000000007ea06fff] ACPI NVS
[    0.000000] nas kernel: BIOS-e820: [mem 0x000000007ea07000-0x000000007effefff] reserved
[    0.000000] nas kernel: BIOS-e820: [mem 0x000000007efff000-0x000000007effffff] usable
[    0.000000] nas kernel: BIOS-e820: [mem 0x000000007f000000-0x000000008fffffff] reserved
[    0.000000] nas kernel: BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] nas kernel: BIOS-e820: [mem 0x00000000fe000000-0x00000000fe010fff] reserved
[    0.000000] nas kernel: BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] nas kernel: BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] nas kernel: BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] nas kernel: BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] nas kernel: BIOS-e820: [mem 0x0000000100000000-0x000000046dffffff] usable
[    0.000000] nas kernel: NX (Execute Disable) protection: active
[    0.000000] nas kernel: SMBIOS 3.0 present.
[    0.000000] nas kernel: DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./C236 WSI, BIOS P2.10 04/18/2017
[    0.000000] nas kernel: e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] nas kernel: e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] nas kernel: e820: last_pfn = 0x46e000 max_arch_pfn = 0x400000000
[    0.000000] nas kernel: MTRR default type: write-back
[    0.000000] nas kernel: MTRR fixed ranges enabled:
[    0.000000] nas kernel:   00000-9FFFF write-back
[    0.000000] nas kernel:   A0000-BFFFF uncachable
[    0.000000] nas kernel:   C0000-FFFFF write-protect
[    0.000000] nas kernel: MTRR variable ranges enabled:
[    0.000000] nas kernel:   0 base 0080000000 mask 7F80000000 uncachable
[    0.000000] nas kernel:   1 base 007F800000 mask 7FFF800000 uncachable
[    0.000000] nas kernel:   2 disabled
[    0.000000] nas kernel:   3 disabled
[    0.000000] nas kernel:   4 disabled
[    0.000000] nas kernel:   5 disabled
[    0.000000] nas kernel:   6 disabled
[    0.000000] nas kernel:   7 disabled
[    0.000000] nas kernel:   8 disabled
[    0.000000] nas kernel:   9 disabled
[    0.000000] nas kernel: x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] nas kernel: e820: last_pfn = 0x7f000 max_arch_pfn = 0x400000000
[    0.000000] nas kernel: found SMP MP-table at [mem 0x000fda00-0x000fda0f] mapped at [ffff8800000fda00]
[    0.000000] nas kernel: Scanning 1 areas for low memory corruption
[    0.000000] nas kernel: Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] nas kernel: Using GB pages for direct mapping
[    0.000000] nas kernel: BRK [0x01d58000, 0x01d58fff] PGTABLE
[    0.000000] nas kernel: BRK [0x01d59000, 0x01d59fff] PGTABLE
[    0.000000] nas kernel: BRK [0x01d5a000, 0x01d5afff] PGTABLE
[    0.000000] nas kernel: BRK [0x01d5b000, 0x01d5bfff] PGTABLE
[    0.000000] nas kernel: BRK [0x01d5c000, 0x01d5cfff] PGTABLE
[    0.000000] nas kernel: BRK [0x01d5d000, 0x01d5dfff] PGTABLE
[    0.000000] nas kernel: RAMDISK: [mem 0x36c99000-0x37643fff]
[    0.000000] nas kernel: ACPI: Early table checksum verification disabled
[    0.000000] nas kernel: ACPI: RSDP 0x00000000000F05B0 000024 (v02 ALASKA)
[    0.000000] nas kernel: ACPI: XSDT 0x000000007E6680B8 0000F4 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] nas kernel: ACPI: FACP 0x000000007E68EC10 000114 (v06 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] nas kernel: ACPI: DSDT 0x000000007E668248 0269C2 (v02 ALASKA A M I    01072009 INTL 20160422)
[    0.000000] nas kernel: ACPI: FACS 0x000000007EA06F80 000040
[    0.000000] nas kernel: ACPI: APIC 0x000000007E68ED28 000084 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] nas kernel: ACPI: FPDT 0x000000007E68EDB0 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] nas kernel: ACPI: FIDT 0x000000007E68EDF8 00009C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] nas kernel: ACPI: MCFG 0x000000007E68EE98 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
[    0.000000] nas kernel: ACPI: SSDT 0x000000007E68EED8 0003A3 (v01 SataRe SataTabl 00001000 INTL 20160422)
[    0.000000] nas kernel: ACPI: AAFT 0x000000007E68F280 00007B (v01 ALASKA OEMAAFT  01072009 MSFT 00000097)
[    0.000000] nas kernel: ACPI: SSDT 0x000000007E68F300 003176 (v02 SaSsdt SaSsdt   00003000 INTL 20160422)
[    0.000000] nas kernel: ACPI: HPET 0x000000007E692478 000038 (v01 INTEL  KBL      00000001 MSFT 0000005F)
[    0.000000] nas kernel: ACPI: SSDT 0x000000007E6924B0 000A2E (v02 INTEL  xh_rvp08 00000000 INTL 20160422)
[    0.000000] nas kernel: ACPI: UEFI 0x000000007E692EE0 000042 (v01 ALASKA A M I    00000002      01000013)
[    0.000000] nas kernel: ACPI: SSDT 0x000000007E692F28 000EDE (v02 CpuRef CpuSsdt  00003000 INTL 20160422)
[    0.000000] nas kernel: ACPI: LPIT 0x000000007E693E08 000094 (v01 INTEL  KBL      00000000 MSFT 0000005F)
[    0.000000] nas kernel: ACPI: SSDT 0x000000007E693EA0 000141 (v02 INTEL  HdaDsp   00000000 INTL 20160422)
[    0.000000] nas kernel: ACPI: SSDT 0x000000007E693FE8 00029F (v02 INTEL  sensrhub 00000000 INTL 20160422)
[    0.000000] nas kernel: ACPI: SSDT 0x000000007E694288 003002 (v02 INTEL  PtidDevc 00001000 INTL 20160422)
[    0.000000] nas kernel: ACPI: SSDT 0x000000007E697290 00050D (v02 INTEL  TbtTypeC 00000000 INTL 20160422)
[    0.000000] nas kernel: ACPI: DBGP 0x000000007E6977A0 000034 (v01 INTEL           00000002 MSFT 0000005F)
[    0.000000] nas kernel: ACPI: DBG2 0x000000007E6977D8 000054 (v00 INTEL           00000002 MSFT 0000005F)
[    0.000000] nas kernel: ACPI: DMAR 0x000000007E697830 0000A8 (v01 INTEL  KBL      00000001 INTL 00000001)
[    0.000000] nas kernel: ACPI: ASF! 0x000000007E6978D8 0000A0 (v32 INTEL   HCG     00000001 TFSM 000F4240)
[    0.000000] nas kernel: ACPI: WSMT 0x000000007E697978 000028 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] nas kernel: ACPI: EINJ 0x000000007E6979A0 000130 (v01 AMI    AMI.EINJ 00000000 AMI. 00000000)
[    0.000000] nas kernel: ACPI: ERST 0x000000007E697AD0 000230 (v01 AMIER  AMI.ERST 00000000 AMI. 00000000)
[    0.000000] nas kernel: ACPI: BERT 0x000000007E697D00 000030 (v01 AMI    AMI.BERT 00000000 AMI. 00000000)
[    0.000000] nas kernel: ACPI: HEST 0x000000007E697D30 0000A8 (v01 AMI    AMI.HEST 00000000 AMI. 00000000)
[    0.000000] nas kernel: ACPI: Local APIC address 0xfee00000
[    0.000000] nas kernel: No NUMA configuration found
[    0.000000] nas kernel: Faking a node at [mem 0x0000000000000000-0x000000046dffffff]
[    0.000000] nas kernel: NODE_DATA(0) allocated [mem 0x46dff7000-0x46dffbfff]
[    0.000000] nas kernel: Zone ranges:
[    0.000000] nas kernel:   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000] nas kernel:   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000] nas kernel:   Normal   [mem 0x0000000100000000-0x000000046dffffff]
[    0.000000] nas kernel:   Device   empty
[    0.000000] nas kernel: Movable zone start for each node
[    0.000000] nas kernel: Early memory node ranges
[    0.000000] nas kernel:   node   0: [mem 0x0000000000001000-0x000000000009bfff]
[    0.000000] nas kernel:   node   0: [mem 0x0000000000100000-0x0000000078770fff]
[    0.000000] nas kernel:   node   0: [mem 0x0000000078773000-0x000000007e137fff]
[    0.000000] nas kernel:   node   0: [mem 0x000000007e5bb000-0x000000007e667fff]
[    0.000000] nas kernel:   node   0: [mem 0x000000007efff000-0x000000007effffff]
[    0.000000] nas kernel:   node   0: [mem 0x0000000100000000-0x000000046dffffff]
[    0.000000] nas kernel: Initmem setup node 0 [mem 0x0000000000001000-0x000000046dffffff]
[    0.000000] nas kernel: On node 0 totalpages: 4112767
[    0.000000] nas kernel:   DMA zone: 64 pages used for memmap
[    0.000000] nas kernel:   DMA zone: 21 pages reserved
[    0.000000] nas kernel:   DMA zone: 3995 pages, LIFO batch:0
[    0.000000] nas kernel:   DMA32 zone: 8008 pages used for memmap
[    0.000000] nas kernel:   DMA32 zone: 512484 pages, LIFO batch:31
[    0.000000] nas kernel:   Normal zone: 56192 pages used for memmap
[    0.000000] nas kernel:   Normal zone: 3596288 pages, LIFO batch:31
[    0.000000] nas kernel: Reserving Intel graphics memory at 0x0000000080000000-0x000000008fffffff
[    0.000000] nas kernel: ACPI: PM-Timer IO Port: 0x1808
[    0.000000] nas kernel: ACPI: Local APIC address 0xfee00000
[    0.000000] nas kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] nas kernel: ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] nas kernel: ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] nas kernel: ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] nas kernel: IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-119
[    0.000000] nas kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] nas kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] nas kernel: ACPI: IRQ0 used by override.
[    0.000000] nas kernel: ACPI: IRQ9 used by override.
[    0.000000] nas kernel: Using ACPI (MADT) for SMP configuration information
[    0.000000] nas kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] nas kernel: smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0x78771000-0x78771fff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0x78772000-0x78772fff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0x7e138000-0x7e5bafff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0x7e668000-0x7ea06fff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0x7ea07000-0x7effefff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0x7f000000-0x8fffffff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0x90000000-0xdfffffff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0xf0000000-0xfdffffff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0xfe000000-0xfe010fff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0xfe011000-0xfebfffff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0xfed01000-0xfedfffff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] nas kernel: PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] nas kernel: e820: [mem 0x90000000-0xdfffffff] available for PCI devices
[    0.000000] nas kernel: Booting paravirtualized kernel on bare hardware
[    0.000000] nas kernel: clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.000000] nas kernel: setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] nas kernel: percpu: Embedded 34 pages/cpu @ffff88046dc00000 s102232 r8192 d28840 u524288
[    0.000000] nas kernel: pcpu-alloc: s102232 r8192 d28840 u524288 alloc=1*2097152
[    0.000000] nas kernel: pcpu-alloc: [0] 0 1 2 3 
[    0.000000] nas kernel: Built 1 zonelists in Node order, mobility grouping on.  Total pages: 4048482
[    0.000000] nas kernel: Policy zone: Normal
[    0.000000] nas kernel: Kernel command line: BOOT_IMAGE=/default/vmlinuz-linux-lts root=UUID=4ac09b56-3e02-40c0-bf64-02a4cf9344fc rw rootflags=subvol=default ip=192.168.0.3:::::eth0:none cryptdevice=/dev/sda2:root:allow-discards
[    0.000000] nas kernel: PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] nas kernel: Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] nas kernel: Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] nas kernel: Memory: 16102752K/16451068K available (6153K kernel code, 1075K rwdata, 1944K rodata, 1280K init, 1032K bss, 348316K reserved, 0K cma-reserved)
[    0.000000] nas kernel: SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] nas kernel: Hierarchical RCU implementation.
[    0.000000] nas kernel:         RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=4.
[    0.000000] nas kernel: RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] nas kernel: NR_IRQS:8448 nr_irqs:1024 16
[    0.000000] nas kernel: Console: colour dummy device 80x25
[    0.000000] nas kernel: console [tty0] enabled
[    0.000000] nas kernel: clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 79635855245 ns
[    0.000000] nas kernel: hpet clockevent registered
[    0.000000] nas kernel: tsc: Detected 3500.000 MHz processor
[    0.000016] nas kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 7008.00 BogoMIPS (lpj=35040000)
[    0.000017] nas kernel: pid_max: default: 32768 minimum: 301
[    0.000021] nas kernel: ACPI: Core revision 20160831
[    0.020841] nas kernel: ACPI: 9 ACPI AML tables successfully acquired and loaded
[    0.020854] nas kernel: Security Framework initialized
[    0.020854] nas kernel: Yama: becoming mindful.
[    0.021341] nas kernel: Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.023366] nas kernel: Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.024213] nas kernel: Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.024221] nas kernel: Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.024379] nas kernel: CPU: Physical Processor ID: 0
[    0.024379] nas kernel: CPU: Processor Core ID: 0
[    0.024382] nas kernel: ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.024382] nas kernel: ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.024385] nas kernel: mce: CPU supports 8 MCE banks
[    0.024391] nas kernel: CPU0: Thermal monitoring enabled (TM1)
[    0.024403] nas kernel: process: using mwait in idle threads
[    0.024404] nas kernel: Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.024405] nas kernel: Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.024636] nas kernel: Freeing SMP alternatives memory: 24K (ffffffff81c4e000 - ffffffff81c54000)
[    0.025549] nas kernel: ftrace: allocating 24614 entries in 97 pages
[    0.032831] nas kernel: smpboot: Max logical packages: 2
[    0.032834] nas kernel: DMAR: Host address width 39
[    0.032835] nas kernel: DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.032839] nas kernel: DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660462 ecap 19e2ff0505e
[    0.032840] nas kernel: DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.032842] nas kernel: DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008c40660462 ecap f050da
[    0.032842] nas kernel: DMAR: RMRR base: 0x0000007e545000 end: 0x0000007e564fff
[    0.032844] nas kernel: DMAR: RMRR base: 0x0000007f800000 end: 0x0000008fffffff
[    0.032850] nas kernel: DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.032851] nas kernel: DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.032852] nas kernel: DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.034195] nas kernel: DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.034196] nas kernel: x2apic enabled
[    0.034206] nas kernel: Switched APIC routing to cluster x2apic.
[    0.038092] nas kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.138104] nas kernel: TSC deadline timer enabled
[    0.138109] nas kernel: smpboot: CPU0: Intel(R) Pentium(R) CPU G4560 @ 3.50GHz (family: 0x6, model: 0x9e, stepping: 0x9)
[    0.138112] nas kernel: Performance Events: PEBS fmt3+, Skylake events, 32-deep LBR, full-width counters, Intel PMU driver.
[    0.138132] nas kernel: ... version:                4
[    0.138132] nas kernel: ... bit width:              48
[    0.138132] nas kernel: ... generic registers:      4
[    0.138133] nas kernel: ... value mask:             0000ffffffffffff
[    0.138133] nas kernel: ... max period:             00007fffffffffff
[    0.138133] nas kernel: ... fixed-purpose events:   3
[    0.138133] nas kernel: ... event mask:             000000070000000f
[    0.138487] nas kernel: NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.138532] nas kernel: x86: Booting SMP configuration:
[    0.138533] nas kernel: .... node  #0, CPUs:      #1 #2 #3
[    0.590194] nas kernel: x86: Booted up 1 node, 4 CPUs
[    0.590196] nas kernel: smpboot: Total of 4 processors activated (28033.41 BogoMIPS)
[    0.592938] nas kernel: devtmpfs: initialized
[    0.592972] nas kernel: x86/mm: Memory block size: 128MB
[    0.594808] nas kernel: PM: Registering ACPI NVS region [mem 0x78771000-0x78771fff] (4096 bytes)
[    0.594809] nas kernel: PM: Registering ACPI NVS region [mem 0x7e668000-0x7ea06fff] (3796992 bytes)
[    0.594868] nas kernel: clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.594873] nas kernel: futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.594898] nas kernel: pinctrl core: initialized pinctrl subsystem
[    0.595001] nas kernel: RTC time: 22:56:20, date: 05/11/17
[    0.595051] nas kernel: NET: Registered protocol family 16
[    0.618170] nas kernel: cpuidle: using governor ladder
[    0.658182] nas kernel: cpuidle: using governor menu
[    0.658248] nas kernel: ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.658249] nas kernel: ACPI: bus type PCI registered
[    0.658250] nas kernel: acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.658287] nas kernel: PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.658288] nas kernel: PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.658294] nas kernel: PCI: Using configuration type 1 for base access
[    0.698302] nas kernel: HugeTLB registered 1 GB page size, pre-allocated 0 pages
[    0.698302] nas kernel: HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.698409] nas kernel: ACPI: Added _OSI(Module Device)
[    0.698409] nas kernel: ACPI: Added _OSI(Processor Device)
[    0.698410] nas kernel: ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.698410] nas kernel: ACPI: Added _OSI(Processor Aggregator Device)
[    0.699385] nas kernel: ACPI: Executed 33 blocks of module-level executable AML code
[    0.707489] nas kernel: ACPI: Dynamic OEM Table Load:
[    0.707493] nas kernel: ACPI: SSDT 0xFFFF88045B788800 000717 (v02 PmRef  Cpu0Ist  00003000 INTL 20160422)
[    0.707587] nas kernel: ACPI: Executed 1 blocks of module-level executable AML code
[    0.707637] nas kernel: ACPI: \_PR_.CPU0: _OSC native thermal LVT Acked
[    0.708376] nas kernel: ACPI: Dynamic OEM Table Load:
[    0.708380] nas kernel: ACPI: SSDT 0xFFFF88045B0EE400 0003FF (v02 PmRef  Cpu0Cst  00003001 INTL 20160422)
[    0.708464] nas kernel: ACPI: Executed 1 blocks of module-level executable AML code
[    0.708705] nas kernel: ACPI: Dynamic OEM Table Load:
[    0.708709] nas kernel: ACPI: SSDT 0xFFFF88045B6A9000 00065C (v02 PmRef  ApIst    00003000 INTL 20160422)
[    0.708917] nas kernel: ACPI: Executed 1 blocks of module-level executable AML code
[    0.709013] nas kernel: ACPI: Dynamic OEM Table Load:
[    0.709016] nas kernel: ACPI: SSDT 0xFFFF88045B1C6000 00018A (v02 PmRef  ApCst    00003000 INTL 20160422)
[    0.709101] nas kernel: ACPI: Executed 1 blocks of module-level executable AML code
[    0.710463] nas kernel: ACPI: Interpreter enabled
[    0.710488] nas kernel: ACPI: (supports S0 S3 S4 S5)
[    0.710488] nas kernel: ACPI: Using IOAPIC for interrupt routing
[    0.710559] nas kernel: HEST: Table parsing has been initialized.
[    0.710561] nas kernel: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.713036] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.713244] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.713451] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.713657] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.713864] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.714070] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.714275] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.714481] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.714687] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.714893] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.715099] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.715303] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.715513] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.715718] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.715925] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.716131] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.716336] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.717126] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.717333] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.717538] nas kernel: ACPI: Power Resource [WRST] (on)
[    0.723059] nas kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.723062] nas kernel: acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.723161] nas kernel: acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.723252] nas kernel: acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.723253] nas kernel: acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.723704] nas kernel: PCI host bridge to bus 0000:00
[    0.723705] nas kernel: pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.723706] nas kernel: pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.723706] nas kernel: pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.723707] nas kernel: pci_bus 0000:00: root bus resource [mem 0x90000000-0xdfffffff window]
[    0.723707] nas kernel: pci_bus 0000:00: root bus resource [mem 0xfd000000-0xfe7fffff window]
[    0.723708] nas kernel: pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.723713] nas kernel: pci 0000:00:00.0: [8086:590f] type 00 class 0x060000
[    0.723917] nas kernel: pci 0000:00:02.0: [8086:5902] type 00 class 0x030000
[    0.723923] nas kernel: pci 0000:00:02.0: reg 0x10: [mem 0xde000000-0xdeffffff 64bit]
[    0.723927] nas kernel: pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.723930] nas kernel: pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.724074] nas kernel: pci 0000:00:14.0: [8086:a12f] type 00 class 0x0c0330
[    0.724089] nas kernel: pci 0000:00:14.0: reg 0x10: [mem 0xdf130000-0xdf13ffff 64bit]
[    0.724143] nas kernel: pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.724251] nas kernel: pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.724277] nas kernel: pci 0000:00:14.2: [8086:a131] type 00 class 0x118000
[    0.724291] nas kernel: pci 0000:00:14.2: reg 0x10: [mem 0xdf14e000-0xdf14efff 64bit]
[    0.724421] nas kernel: pci 0000:00:16.0: [8086:a13a] type 00 class 0x078000
[    0.724438] nas kernel: pci 0000:00:16.0: reg 0x10: [mem 0xdf14d000-0xdf14dfff 64bit]
[    0.724496] nas kernel: pci 0000:00:16.0: PME# supported from D3hot
[    0.724623] nas kernel: pci 0000:00:17.0: [8086:a102] type 00 class 0x010601
[    0.724634] nas kernel: pci 0000:00:17.0: reg 0x10: [mem 0xdf148000-0xdf149fff]
[    0.724640] nas kernel: pci 0000:00:17.0: reg 0x14: [mem 0xdf14c000-0xdf14c0ff]
[    0.724645] nas kernel: pci 0000:00:17.0: reg 0x18: [io  0xf090-0xf097]
[    0.724651] nas kernel: pci 0000:00:17.0: reg 0x1c: [io  0xf080-0xf083]
[    0.724656] nas kernel: pci 0000:00:17.0: reg 0x20: [io  0xf060-0xf07f]
[    0.724662] nas kernel: pci 0000:00:17.0: reg 0x24: [mem 0xdf14b000-0xdf14b7ff]
[    0.724692] nas kernel: pci 0000:00:17.0: PME# supported from D3hot
[    0.724789] nas kernel: pci 0000:00:1c.0: [8086:a110] type 01 class 0x060400
[    0.724839] nas kernel: pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.724923] nas kernel: pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.724964] nas kernel: pci 0000:00:1c.7: [8086:a117] type 01 class 0x060400
[    0.725009] nas kernel: pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.725089] nas kernel: pci 0000:00:1c.7: System wakeup disabled by ACPI
[    0.725115] nas kernel: pci 0000:00:1f.0: [8086:a149] type 00 class 0x060100
[    0.725286] nas kernel: pci 0000:00:1f.2: [8086:a121] type 00 class 0x058000
[    0.725295] nas kernel: pci 0000:00:1f.2: reg 0x10: [mem 0xdf144000-0xdf147fff]
[    0.725422] nas kernel: pci 0000:00:1f.3: [8086:a170] type 00 class 0x040300
[    0.725441] nas kernel: pci 0000:00:1f.3: reg 0x10: [mem 0xdf140000-0xdf143fff 64bit]
[    0.725469] nas kernel: pci 0000:00:1f.3: reg 0x20: [mem 0xdf120000-0xdf12ffff 64bit]
[    0.725510] nas kernel: pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.725635] nas kernel: pci 0000:00:1f.3: System wakeup disabled by ACPI
[    0.725665] nas kernel: pci 0000:00:1f.4: [8086:a123] type 00 class 0x0c0500
[    0.725711] nas kernel: pci 0000:00:1f.4: reg 0x10: [mem 0xdf14a000-0xdf14a0ff 64bit]
[    0.725780] nas kernel: pci 0000:00:1f.4: reg 0x20: [io  0xf040-0xf05f]
[    0.725939] nas kernel: pci 0000:00:1f.6: [8086:15b7] type 00 class 0x020000
[    0.725958] nas kernel: pci 0000:00:1f.6: reg 0x10: [mem 0xdf100000-0xdf11ffff]
[    0.726056] nas kernel: pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
[    0.726129] nas kernel: pci 0000:00:1f.6: System wakeup disabled by ACPI
[    0.726192] nas kernel: pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.726256] nas kernel: pci 0000:02:00.0: [8086:1533] type 00 class 0x020000
[    0.726276] nas kernel: pci 0000:02:00.0: reg 0x10: [mem 0xdf000000-0xdf07ffff]
[    0.726299] nas kernel: pci 0000:02:00.0: reg 0x18: [io  0xe000-0xe01f]
[    0.726311] nas kernel: pci 0000:02:00.0: reg 0x1c: [mem 0xdf080000-0xdf083fff]
[    0.726423] nas kernel: pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.726489] nas kernel: pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.750265] nas kernel: pci 0000:00:1c.7: PCI bridge to [bus 02]
[    0.750270] nas kernel: pci 0000:00:1c.7:   bridge window [io  0xe000-0xefff]
[    0.750276] nas kernel: pci 0000:00:1c.7:   bridge window [mem 0xdf000000-0xdf0fffff]
[    0.751436] nas kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.751469] nas kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.751502] nas kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.751534] nas kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.751566] nas kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.751598] nas kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.751629] nas kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.751661] nas kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.751831] nas kernel: ACPI: Enabled 4 GPEs in block 00 to 7F
[    0.751923] nas kernel: vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.751924] nas kernel: vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.751925] nas kernel: vgaarb: loaded
[    0.751925] nas kernel: vgaarb: bridge control possible 0000:00:02.0
[    0.751975] nas kernel: PCI: Using ACPI for IRQ routing
[    0.780103] nas kernel: PCI: pci_cache_line_size set to 64 bytes
[    0.780140] nas kernel: e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    0.780140] nas kernel: e820: reserve RAM buffer [mem 0x78771000-0x7bffffff]
[    0.780141] nas kernel: e820: reserve RAM buffer [mem 0x7e138000-0x7fffffff]
[    0.780141] nas kernel: e820: reserve RAM buffer [mem 0x7e668000-0x7fffffff]
[    0.780142] nas kernel: e820: reserve RAM buffer [mem 0x7f000000-0x7fffffff]
[    0.780142] nas kernel: e820: reserve RAM buffer [mem 0x46e000000-0x46fffffff]
[    0.780195] nas kernel: NetLabel: Initializing
[    0.780195] nas kernel: NetLabel:  domain hash size = 128
[    0.780195] nas kernel: NetLabel:  protocols = UNLABELED CIPSOv4
[    0.780204] nas kernel: NetLabel:  unlabeled traffic allowed by default
[    0.780267] nas kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.780270] nas kernel: hpet0: 8 comparators, 64-bit 24.000000 MHz counter
[    0.782309] nas kernel: clocksource: Switched to clocksource hpet
[    0.785495] nas kernel: VFS: Disk quotas dquot_6.6.0
[    0.785504] nas kernel: VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.785550] nas kernel: pnp: PnP ACPI init
[    0.785708] nas kernel: system 00:00: [io  0x0280-0x028f] has been reserved
[    0.785709] nas kernel: system 00:00: [io  0x0290-0x029f] has been reserved
[    0.785710] nas kernel: system 00:00: [io  0x02a0-0x02af] has been reserved
[    0.785711] nas kernel: system 00:00: [io  0x02b0-0x02bf] has been reserved
[    0.785713] nas kernel: system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.785811] nas kernel: system 00:01: [io  0x0680-0x069f] has been reserved
[    0.785812] nas kernel: system 00:01: [io  0xffff] has been reserved
[    0.785813] nas kernel: system 00:01: [io  0xffff] has been reserved
[    0.785814] nas kernel: system 00:01: [io  0xffff] has been reserved
[    0.785814] nas kernel: system 00:01: [io  0x1800-0x18fe] has been reserved
[    0.785815] nas kernel: system 00:01: [io  0x164e-0x164f] has been reserved
[    0.785816] nas kernel: system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.785869] nas kernel: system 00:02: [io  0x0800-0x087f] has been reserved
[    0.785870] nas kernel: system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.785882] nas kernel: pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.785902] nas kernel: system 00:04: [io  0x1854-0x1857] has been reserved
[    0.785903] nas kernel: system 00:04: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.786036] nas kernel: system 00:05: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.786037] nas kernel: system 00:05: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.786037] nas kernel: system 00:05: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.786038] nas kernel: system 00:05: [mem 0xe0000000-0xefffffff] has been reserved
[    0.786039] nas kernel: system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.786039] nas kernel: system 00:05: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.786040] nas kernel: system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.786041] nas kernel: system 00:05: [mem 0xff000000-0xffffffff] has been reserved
[    0.786042] nas kernel: system 00:05: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.786042] nas kernel: system 00:05: [mem 0xdffe0000-0xdfffffff] has been reserved
[    0.786043] nas kernel: system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.786065] nas kernel: system 00:06: [mem 0xfd000000-0xfdabffff] has been reserved
[    0.786066] nas kernel: system 00:06: [mem 0xfdad0000-0xfdadffff] has been reserved
[    0.786067] nas kernel: system 00:06: [mem 0xfdb00000-0xfdffffff] has been reserved
[    0.786067] nas kernel: system 00:06: [mem 0xfe000000-0xfe01ffff] could not be reserved
[    0.786068] nas kernel: system 00:06: [mem 0xfe036000-0xfe03bfff] has been reserved
[    0.786069] nas kernel: system 00:06: [mem 0xfe03d000-0xfe3fffff] has been reserved
[    0.786069] nas kernel: system 00:06: [mem 0xfe410000-0xfe7fffff] has been reserved
[    0.786070] nas kernel: system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.786240] nas kernel: system 00:07: [io  0xff00-0xfffe] has been reserved
[    0.786241] nas kernel: system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.786885] nas kernel: system 00:08: [mem 0xfdaf0000-0xfdafffff] has been reserved
[    0.786886] nas kernel: system 00:08: [mem 0xfdae0000-0xfdaeffff] has been reserved
[    0.786887] nas kernel: system 00:08: [mem 0xfdac0000-0xfdacffff] has been reserved
[    0.786888] nas kernel: system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.787378] nas kernel: pnp: PnP ACPI: found 9 devices
[    0.793333] nas kernel: clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.793345] nas kernel: pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.793352] nas kernel: pci 0000:00:1c.7: PCI bridge to [bus 02]
[    0.793353] nas kernel: pci 0000:00:1c.7:   bridge window [io  0xe000-0xefff]
[    0.793356] nas kernel: pci 0000:00:1c.7:   bridge window [mem 0xdf000000-0xdf0fffff]
[    0.793360] nas kernel: pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.793361] nas kernel: pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.793362] nas kernel: pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.793362] nas kernel: pci_bus 0000:00: resource 7 [mem 0x90000000-0xdfffffff window]
[    0.793363] nas kernel: pci_bus 0000:00: resource 8 [mem 0xfd000000-0xfe7fffff window]
[    0.793364] nas kernel: pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.793364] nas kernel: pci_bus 0000:02: resource 1 [mem 0xdf000000-0xdf0fffff]
[    0.793448] nas kernel: NET: Registered protocol family 2
[    0.793553] nas kernel: TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.793665] nas kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.793734] nas kernel: TCP: Hash tables configured (established 131072 bind 65536)
[    0.793749] nas kernel: UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.793774] nas kernel: UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.793811] nas kernel: NET: Registered protocol family 1
[    0.793819] nas kernel: pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.794140] nas kernel: PCI: CLS 64 bytes, default 64
[    0.794166] nas kernel: Unpacking initramfs...
[    0.886879] nas kernel: Freeing initrd memory: 9900K (ffff880036c99000 - ffff880037644000)
[    0.886897] nas kernel: PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.886898] nas kernel: software IO TLB [mem 0x7a138000-0x7e138000] (64MB) mapped at [ffff88007a138000-ffff88007e137fff]
[    0.886946] nas kernel: Scanning for low memory corruption every 60 seconds
[    0.887277] nas kernel: Initialise system trusted keyrings
[    0.887371] nas kernel: workingset: timestamp_bits=40 max_order=22 bucket_order=0
[    0.888189] nas kernel: zbud: loaded
[    0.888832] nas kernel: Key type asymmetric registered
[    0.888855] nas kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
[    0.888899] nas kernel: io scheduler noop registered
[    0.888899] nas kernel: io scheduler deadline registered (default)
[    0.888904] nas kernel: io scheduler cfq registered
[    0.889144] nas kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.889146] nas kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.889151] nas kernel: vesafb: mode is 1920x1080x32, linelength=7680, pages=0
[    0.889152] nas kernel: vesafb: scrolling: redraw
[    0.889153] nas kernel: vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.889160] nas kernel: vesafb: framebuffer at 0xc0000000, mapped to 0xffffc90002000000, using 8128k, total 8128k
[    1.033186] nas kernel: Console: switching to colour frame buffer device 240x67
[    1.176594] nas kernel: fb0: VESA VGA frame buffer device
[    1.176601] nas kernel: intel_idle: MWAIT substates: 0x142120
[    1.176601] nas kernel: intel_idle: v0.4.1 model 0x9E
[    1.176696] nas kernel: intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.176776] nas kernel: ERST: Error Record Serialization Table (ERST) support is initialized.
[    1.176776] nas kernel: pstore: using zlib compression
[    1.176778] nas kernel: pstore: Registered erst as persistent store backend
[    1.176814] nas kernel: GHES: APEI firmware first mode is enabled by APEI bit.
[    1.176870] nas kernel: Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.177217] nas kernel: Linux agpgart interface v0.103
[    1.177420] nas kernel: rtc_cmos 00:03: RTC can wake from S4
[    1.177787] nas kernel: rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.177867] nas kernel: rtc_cmos 00:03: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.177871] nas kernel: intel_pstate: Intel P-state driver initializing
[    1.177883] nas kernel: intel_pstate: Disabling energy efficiency optimization
[    1.178089] nas kernel: intel_pstate: HWP enabled
[    1.178205] nas kernel: ledtrig-cpu: registered to indicate activity on CPUs
[    1.178319] nas kernel: NET: Registered protocol family 10
[    1.178466] nas kernel: NET: Registered protocol family 17
[    1.178637] nas kernel: microcode: sig=0x906e9, pf=0x2, revision=0x48
[    1.178749] nas kernel: microcode: Microcode Update Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.178960] nas kernel: registered taskstats version 1
[    1.178964] nas kernel: Loading compiled-in X.509 certificates
[    1.178972] nas kernel: zswap: loaded using pool lzo/zbud
[    1.179554] nas kernel: BERT: Can't request iomem region <000000007ea06018-000000007ea0602b>.
[    1.180332] nas kernel:   Magic number: 1:47:957
[    1.180517] nas kernel: rtc_cmos 00:03: setting system clock to 2017-05-11 22:56:21 UTC (1494543381)
[    1.180549] nas kernel: PM: Hibernation image not present or could not be loaded.
[    1.181152] nas kernel: Freeing unused kernel memory: 1280K (ffffffff81b0e000 - ffffffff81c4e000)
[    1.181153] nas kernel: Write protecting the kernel read-only data: 10240k
[    1.181417] nas kernel: Freeing unused kernel memory: 2024K (ffff880001606000 - ffff880001800000)
[    1.181563] nas kernel: Freeing unused kernel memory: 104K (ffff8800019e6000 - ffff880001a00000)
[    1.186742] nas kernel: random: systemd-tmpfile: uninitialized urandom read (16 bytes read)
[    1.186796] nas kernel: random: systemd-tmpfile: uninitialized urandom read (16 bytes read)
[    1.188013] nas kernel: random: systemd-udevd: uninitialized urandom read (16 bytes read)
[    1.188042] nas kernel: random: systemd-udevd: uninitialized urandom read (16 bytes read)
[    1.188047] nas kernel: random: systemd-udevd: uninitialized urandom read (16 bytes read)
[    1.189107] nas kernel: random: udevadm: uninitialized urandom read (16 bytes read)
[    1.189116] nas kernel: random: udevadm: uninitialized urandom read (16 bytes read)
[    1.190651] nas kernel: random: systemd-udevd: uninitialized urandom read (16 bytes read)
[    1.190660] nas kernel: random: systemd-udevd: uninitialized urandom read (16 bytes read)
[    1.190662] nas kernel: random: systemd-udevd: uninitialized urandom read (16 bytes read)
[    1.210082] nas kernel: FUJITSU Extended Socket Network Device Driver - version 1.1 - Copyright (c) 2015 FUJITSU LIMITED
[    1.216263] nas kernel: i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.219404] nas kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.219407] nas kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.226325] nas kernel: pps_core: LinuxPPS API ver. 1 registered
[    1.226326] nas kernel: pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.226647] nas kernel: PTP clock support registered
[    1.226667] nas kernel: ACPI: bus type USB registered
[    1.226686] nas kernel: usbcore: registered new interface driver usbfs
[    1.226695] nas kernel: usbcore: registered new interface driver hub
[    1.226708] nas kernel: usbcore: registered new device driver usb
[    1.226752] nas kernel: SCSI subsystem initialized
[    1.226899] nas kernel: dca service started, version 1.12.1
[    1.227690] nas kernel: xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.227695] nas kernel: xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    1.228034] nas kernel: igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4.0-k
[    1.228034] nas kernel: igb: Copyright (c) 2007-2014 Intel Corporation.
[    1.228833] nas kernel: xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00109810
[    1.228837] nas kernel: xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.228947] nas kernel: libata version 3.00 loaded.
[    1.229052] nas kernel: hub 1-0:1.0: USB hub found
[    1.229068] nas kernel: hub 1-0:1.0: 16 ports detected
[    1.232236] nas kernel: SSE version of gcm_enc/dec engaged.
[    1.235244] nas kernel: e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    1.235245] nas kernel: e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    1.239013] nas kernel: xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.239016] nas kernel: xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    1.239198] nas kernel: hub 2-0:1.0: USB hub found
[    1.239216] nas kernel: hub 2-0:1.0: 10 ports detected
[    1.245301] nas kernel: ahci 0000:00:17.0: version 3.0
[    1.255580] nas kernel: ahci 0000:00:17.0: AHCI 0001.0301 32 slots 8 ports 6 Gbps 0xff impl SATA mode
[    1.255581] nas kernel: ahci 0000:00:17.0: flags: 64bit ncq sntf led clo only pio slum part ems deso sadm sds apst 
[    1.257029] nas kernel: pps pps0: new PPS source ptp0
[    1.257030] nas kernel: igb 0000:02:00.0: added PHC on eth0
[    1.257031] nas kernel: igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
[    1.257032] nas kernel: igb 0000:02:00.0: eth0: (PCIe:2.5Gb/s:Width x1) d0:50:99:c1:f6:cb
[    1.257098] nas kernel: igb 0000:02:00.0: eth0: PBA No: 001300-000
[    1.257098] nas kernel: igb 0000:02:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    1.473447] nas kernel: scsi host0: ahci
[    1.473626] nas kernel: scsi host1: ahci
[    1.473872] nas kernel: scsi host2: ahci
[    1.474074] nas kernel: scsi host3: ahci
[    1.474260] nas kernel: scsi host4: ahci
[    1.474447] nas kernel: scsi host5: ahci
[    1.474640] nas kernel: scsi host6: ahci
[    1.474828] nas kernel: scsi host7: ahci
[    1.474900] nas kernel: ata1: SATA max UDMA/133 abar m2048@0xdf14b000 port 0xdf14b100 irq 128
[    1.474904] nas kernel: ata2: SATA max UDMA/133 abar m2048@0xdf14b000 port 0xdf14b180 irq 128
[    1.474908] nas kernel: ata3: SATA max UDMA/133 abar m2048@0xdf14b000 port 0xdf14b200 irq 128
[    1.474913] nas kernel: ata4: SATA max UDMA/133 abar m2048@0xdf14b000 port 0xdf14b280 irq 128
[    1.474917] nas kernel: ata5: SATA max UDMA/133 abar m2048@0xdf14b000 port 0xdf14b300 irq 128
[    1.474919] nas kernel: ata6: SATA max UDMA/133 abar m2048@0xdf14b000 port 0xdf14b380 irq 128
[    1.474921] nas kernel: ata7: SATA max UDMA/133 abar m2048@0xdf14b000 port 0xdf14b400 irq 128
[    1.474924] nas kernel: ata8: SATA max UDMA/133 abar m2048@0xdf14b000 port 0xdf14b480 irq 128
[    1.475176] nas kernel: e1000e 0000:00:1f.6: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.680362] nas kernel: e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): registered PHC clock
[    1.763231] nas kernel: e1000e 0000:00:1f.6 eth1: (PCI Express:2.5GT/s:Width x1) d0:50:99:c1:f6:cc
[    1.763233] nas kernel: e1000e 0000:00:1f.6 eth1: Intel(R) PRO/1000 Network Connection
[    1.763329] nas kernel: e1000e 0000:00:1f.6 eth1: MAC: 12, PHY: 12, PBA No: FFFFFF-0FF
[    1.802593] nas kernel: ata6: SATA link down (SStatus 0 SControl 300)
[    1.802614] nas kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.802634] nas kernel: ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.802655] nas kernel: ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.802669] nas kernel: ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.802683] nas kernel: ata8: SATA link down (SStatus 0 SControl 300)
[    1.802707] nas kernel: ata7: SATA link down (SStatus 0 SControl 300)
[    1.802727] nas kernel: ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.802938] nas kernel: ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160831/psargs-359)
[    1.804929] nas kernel: ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.PRT0._GTF] (Node ffff88045d4e9e38), AE_NOT_FOUND (20160831/psparse-543)
[    1.807985] nas kernel: ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160831/psargs-359)
[    1.809969] nas kernel: ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.PRT1._GTF] (Node ffff88045d4e9e60), AE_NOT_FOUND (20160831/psparse-543)
[    1.813043] nas kernel: ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160831/psargs-359)
[    1.815039] nas kernel: ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.PRT2._GTF] (Node ffff88045d4e9e88), AE_NOT_FOUND (20160831/psparse-543)
[    1.818091] nas kernel: ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160831/psargs-359)
[    1.820075] nas kernel: ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.PRT4._GTF] (Node ffff88045d4e9ed8), AE_NOT_FOUND (20160831/psparse-543)
[    1.823109] nas kernel: ata1.00: ATA-7: INTEL SSDSA2M040G2GC, 2CV102M3, max UDMA/133
[    1.823112] nas kernel: ata1.00: 78165360 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.823188] nas kernel: ata2.00: ATA-10: WDC WD40EFRX-68N32N0, 82.00A82, max UDMA/133
[    1.823189] nas kernel: ata2.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.823210] nas kernel: ata3.00: ATA-10: WDC WD40EFRX-68N32N0, 82.00A82, max UDMA/133
[    1.823212] nas kernel: ata3.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.823323] nas kernel: ata5.00: ATA-10: WDC WD40EFRX-68N32N0, 82.00A82, max UDMA/133
[    1.823325] nas kernel: ata5.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.823471] nas kernel: ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160831/psargs-359)
[    1.825459] nas kernel: ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.PRT0._GTF] (Node ffff88045d4e9e38), AE_NOT_FOUND (20160831/psparse-543)
[    1.828517] nas kernel: ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160831/psargs-359)
[    1.830505] nas kernel: ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.PRT2._GTF] (Node ffff88045d4e9e88), AE_NOT_FOUND (20160831/psparse-543)
[    1.833570] nas kernel: ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160831/psargs-359)
[    1.835226] nas kernel: ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.PRT1._GTF] (Node ffff88045d4e9e60), AE_NOT_FOUND (20160831/psparse-543)
[    1.837621] nas kernel: ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160831/psargs-359)
[    1.839160] nas kernel: ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.PRT4._GTF] (Node ffff88045d4e9ed8), AE_NOT_FOUND (20160831/psparse-543)
[    1.841119] nas kernel: ata1.00: configured for UDMA/133
[    1.841203] nas kernel: ata3.00: configured for UDMA/133
[    1.841222] nas kernel: ata2.00: configured for UDMA/133
[    1.841297] nas kernel: ata5.00: configured for UDMA/133
[    1.841354] nas kernel: scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M040 02M3 PQ: 0 ANSI: 5
[    1.912647] nas kernel: scsi 1:0:0:0: Direct-Access     ATA      WDC WD40EFRX-68N 0A82 PQ: 0 ANSI: 5
[    1.922339] nas kernel: tsc: Refined TSC clocksource calibration: 3504.014 MHz
[    1.922351] nas kernel: clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x3282213ee60, max_idle_ns: 440795368004 ns
[    2.012747] nas kernel: scsi 2:0:0:0: Direct-Access     ATA      WDC WD40EFRX-68N 0A82 PQ: 0 ANSI: 5
[    2.023090] nas kernel: ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160831/psargs-359)
[    2.025079] nas kernel: ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.PRT3._GTF] (Node ffff88045d4e9eb0), AE_NOT_FOUND (20160831/psparse-543)
[    2.143565] nas kernel: ata4.00: ATA-9: ST8000AS0002-1NA17Z, AR15, max UDMA/133
[    2.143568] nas kernel: ata4.00: 15628053168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.145055] nas kernel: ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160831/psargs-359)
[    2.147189] nas kernel: ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.PRT3._GTF] (Node ffff88045d4e9eb0), AE_NOT_FOUND (20160831/psparse-543)
[    2.150736] nas kernel: ata4.00: configured for UDMA/133
[    2.150978] nas kernel: scsi 3:0:0:0: Direct-Access     ATA      ST8000AS0002-1NA AR15 PQ: 0 ANSI: 5
[    2.223094] nas kernel: scsi 4:0:0:0: Direct-Access     ATA      WDC WD40EFRX-68N 0A82 PQ: 0 ANSI: 5
[    2.305896] nas kernel: ata1.00: Enabling discard_zeroes_data
[    2.305920] nas kernel: sd 0:0:0:0: [sda] 78165360 512-byte logical blocks: (40.0 GB/37.3 GiB)
[    2.306055] nas kernel: sd 0:0:0:0: [sda] Write Protect is off
[    2.306059] nas kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.306085] nas kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.306094] nas kernel: sd 1:0:0:0: [sdb] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
[    2.306097] nas kernel: sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    2.306113] nas kernel: sd 2:0:0:0: [sdc] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
[    2.306116] nas kernel: sd 2:0:0:0: [sdc] 4096-byte physical blocks
[    2.306164] nas kernel: sd 1:0:0:0: [sdb] Write Protect is off
[    2.306167] nas kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.306194] nas kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.306204] nas kernel: sd 2:0:0:0: [sdc] Write Protect is off
[    2.306208] nas kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.306239] nas kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.306251] nas kernel: ata1.00: Enabling discard_zeroes_data
[    2.306495] nas kernel: sd 3:0:0:0: [sdd] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
[    2.306497] nas kernel: sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    2.306555] nas kernel: sd 4:0:0:0: [sde] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
[    2.306557] nas kernel: sd 4:0:0:0: [sde] 4096-byte physical blocks
[    2.306581] nas kernel: sd 3:0:0:0: [sdd] Write Protect is off
[    2.306584] nas kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.306621] nas kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.306656] nas kernel:  sda: sda1 sda2
[    2.306726] nas kernel: sd 4:0:0:0: [sde] Write Protect is off
[    2.306729] nas kernel: sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    2.306765] nas kernel: sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.306925] nas kernel: ata1.00: Enabling discard_zeroes_data
[    2.307105] nas kernel: sd 0:0:0:0: [sda] Attached SCSI disk
[    2.349350] nas kernel:  sdc: sdc1
[    2.349899] nas kernel: sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.352193] nas kernel:  sde: sde1
[    2.352675] nas kernel: sd 4:0:0:0: [sde] Attached SCSI disk
[    2.357445] nas kernel:  sdb: sdb1
[    2.357827] nas kernel: sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.509573] nas kernel:  sdd: sdd1
[    2.510156] nas kernel: sd 3:0:0:0: [sdd] Attached SCSI disk
[    2.605554] nas kernel: random: fast init done
[    2.702329] nas kernel: raid6: sse2x1   gen() 12362 MB/s
[    2.872326] nas kernel: raid6: sse2x1   xor()  9315 MB/s
[    3.042324] nas kernel: raid6: sse2x2   gen() 15330 MB/s
[    3.212324] nas kernel: raid6: sse2x2   xor() 10682 MB/s
[    3.382325] nas kernel: raid6: sse2x4   gen() 16257 MB/s
[    3.552324] nas kernel: raid6: sse2x4   xor() 11933 MB/s
[    3.552324] nas kernel: raid6: using algorithm sse2x4 gen() 16257 MB/s
[    3.552325] nas kernel: raid6: .... xor() 11933 MB/s, rmw enabled
[    3.552325] nas kernel: raid6: using ssse3x2 recovery algorithm
[    3.552498] nas kernel: xor: measuring software checksum speed
[    3.652324] nas kernel:    prefetch64-sse: 18731.200 MB/sec
[    3.752323] nas kernel:    generic_sse: 17350.400 MB/sec
[    3.752324] nas kernel: xor: using function: prefetch64-sse (18731.200 MB/sec)
[    3.752347] nas kernel: clocksource: Switched to clocksource tsc
[    3.754453] nas kernel: Btrfs loaded, crc32c=crc32c-intel
[    3.754797] nas kernel: BTRFS: device fsid adeef581-5e84-46cd-8515-2981e920b180 devid 1 transid 183 /dev/sda1
[    3.801181] nas kernel: IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    3.810384] nas kernel: device-mapper: uevent: version 1.0.3
[    3.810427] nas kernel: device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel@redhat.com
[    6.813065] nas kernel: igb 0000:02:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[    6.932543] nas kernel: IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   21.872273] nas kernel: NET: Registered protocol family 38
[   22.112261] nas kernel: BTRFS: device fsid 4ac09b56-3e02-40c0-bf64-02a4cf9344fc devid 1 transid 34039 /dev/dm-0
[   22.127188] nas kernel: BTRFS info (device dm-0): disk space caching is enabled
[   22.127189] nas kernel: BTRFS info (device dm-0): has skinny extents
[   22.131571] nas kernel: BTRFS info (device dm-0): detected SSD devices, enabling SSD mode
[   22.431927] nas kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
[   22.436314] nas systemd[1]: systemd 233 running in system mode. (+PAM -AUDIT -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN default-hierarchy=hybrid)
[   22.436472] nas systemd[1]: Detected architecture x86-64.
[   22.437874] nas systemd[1]: Set hostname to <nas>.
[   22.493826] nas systemd[1]: Unnecessary job for dev-mapper-storage2.device was removed.
[   22.495563] nas systemd[1]: Unnecessary job for dev-mapper-storage0.device was removed.
[   22.497246] nas systemd[1]: Unnecessary job for dev-mapper-storage1.device was removed.
[   22.498925] nas systemd[1]: Unnecessary job for dev-mapper-backup.device was removed.
[   22.501096] nas systemd[1]: Created slice User and Session Slice.
[   22.502203] nas systemd[1]: Created slice System Slice.
[   22.503110] nas systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[   22.804886] nas kernel: BTRFS info (device dm-0): disk space caching is enabled
[   22.897177] nas systemd-journald[293]: Journal started
[   22.897248] nas systemd-journald[293]: Runtime journal (/run/log/journal/3b393d5a76e247d99b60857efd51b1d7) is 8.0M, max 786.9M, 778.9M free.
[   23.297851] nas systemd[1]: Started Apply Kernel Variables.
[   23.327869] nas systemd[1]: Started Remount Root and Kernel File Systems.
[   23.357345] nas systemd[1]: Started Create list of required static device nodes for the current kernel.
[   23.387270] nas systemd[1]: Starting udev Coldplug all Devices...
[   23.416062] nas systemd[1]: Starting Create Static Device Nodes in /dev...
[   23.443999] nas systemd[1]: Starting Load/Save Random Seed...
[   23.471693] nas systemd[1]: Starting Flush Journal to Persistent Storage...
[   23.499914] nas systemd[1]: Started Create Static Device Nodes in /dev.
[   23.527537] nas systemd[1]: Started Load/Save Random Seed.
[   23.555104] nas systemd[1]: Started udev Coldplug all Devices.
[   23.583509] nas systemd[1]: Starting udev Kernel Device Manager...
[   23.610948] nas systemd[1]: Reached target Local File Systems (Pre).
[   23.639362] nas systemd[1]: Started udev Kernel Device Manager.
[   23.653809] nas kernel: shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   23.655188] nas kernel: input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[   23.655190] nas kernel: ACPI: Sleep Button [SLPB]
[   23.655219] nas kernel: input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[   23.655220] nas kernel: ACPI: Power Button [PWRB]
[   23.655326] nas kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[   23.655327] nas kernel: ACPI: Power Button [PWRF]
[   23.665057] nas kernel: mei_me 0000:00:16.0: enabling device (0000 -> 0002)
[   23.669262] nas kernel: hidraw: raw HID events driver (C) Jiri Kosina
[   23.671959] nas kernel: [drm] Initialized
[   23.669986] nas systemd-journald[293]: Time spent on flushing to /var is 104.492ms for 730 entries.
[   23.669986] nas systemd-journald[293]: System journal (/var/log/journal/3b393d5a76e247d99b60857efd51b1d7) is 89.4M, max 3.6G, 3.5G free.
[   23.680072] nas kernel: i801_smbus 0000:00:1f.4: SPD Write Disable is set
[   23.680101] nas kernel: i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[   23.703436] nas kernel: wmi: Mapper loaded
[   23.707058] nas kernel: igb 0000:02:00.0 enp2s0: renamed from eth0
[   23.708727] nas kernel: Bluetooth: Core ver 2.22
[   23.708735] nas kernel: NET: Registered protocol family 31
[   23.708736] nas kernel: Bluetooth: HCI device and connection manager initialized
[   23.708738] nas kernel: Bluetooth: HCI socket layer initialized
[   23.708739] nas kernel: Bluetooth: L2CAP socket layer initialized
[   23.708741] nas kernel: Bluetooth: SCO socket layer initialized
[   23.752986] nas kernel: e1000e 0000:00:1f.6 enp0s31f6: renamed from eth1
[   23.826794] nas kernel: random: crng init done
[   23.887476] nas kernel: input: PC Speaker as /devices/platform/pcspkr/input/input5
[   23.889861] nas kernel: [drm] Memory usable by graphics device = 4096M
[   23.889863] nas kernel: checking generic (c0000000 7f0000) vs hw (c0000000 10000000)
[   23.889863] nas kernel: fb: switching to inteldrmfb from VESA VGA
[   23.889876] nas kernel: Console: switching to colour dummy device 80x25
[   23.889946] nas kernel: [drm] Replacing VGA console driver
[   23.895538] nas kernel: [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   23.895539] nas kernel: [drm] Driver supports precise vblank timestamp query.
[   23.902620] nas systemd-udevd[318]: link_config: autonegotiation is unset or enabled, the speed and duplex are not writable.
[   23.902831] nas systemd[1]: Found device WDC_WD40EFRX-68N32N0 1.
[   23.903048] nas systemd[1]: Found device WDC_WD40EFRX-68N32N0 1.
[   23.903164] nas systemd-udevd[310]: link_config: autonegotiation is unset or enabled, the speed and duplex are not writable.
[   23.903292] nas systemd[1]: Found device WDC_WD40EFRX-68N32N0 1.
[   23.903421] nas systemd[1]: Found device INTEL_SSDSA2M040G2GC 1.
[   23.903536] nas systemd-udevd[318]: link_config: autonegotiation is unset or enabled, the speed and duplex are not writable.
[   23.903652] nas systemd[1]: Started Flush Journal to Persistent Storage.
[   23.903762] nas systemd[1]: Found device /dev/disk/by-uuid/4ac09b56-3e02-40c0-bf64-02a4cf9344fc.
[   23.903864] nas systemd[1]: Mounting /mnt/btrfs/root...
[   23.903982] nas systemd[1]: Mounting /var/lib/machines...
[   23.904081] nas systemd[1]: Mounting /boot...
[   23.904182] nas systemd[1]: Mounting /mnt/btrfs/boot...
[   23.904288] nas systemd[1]: Starting Cryptography Setup for storage2...
[   23.904392] nas systemd[1]: Starting Cryptography Setup for storage1...
[   23.904495] nas systemd[1]: Starting Cryptography Setup for storage0...
[   23.904606] nas systemd[1]: Listening on Load/Save RF Kill Switch Status /dev/rfkill Watch.
[   23.905612] nas kernel: vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   23.910295] nas kernel: [drm] GuC firmware load skipped
[   23.910144] nas systemd-cryptsetup[335]: Set cipher aes, mode xts-plain64, key size 256 bits for device /dev/disk/by-uuid/94dafd2c-34e3-442e-9103-0c42f4b626cd.
[   23.910573] nas systemd-cryptsetup[334]: Set cipher aes, mode xts-plain64, key size 256 bits for device /dev/disk/by-uuid/f7b8c661-57f9-4310-8e70-aaf402d81399.
[   23.914937] nas kernel: ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   23.915409] nas kernel: acpi device:0f: registered as cooling_device4
[   23.915475] nas kernel: input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input7
[   23.916119] nas kernel: [drm] Initialized i915 1.6.0 20160919 for 0000:00:02.0 on minor 0
[   23.925637] nas systemd-cryptsetup[336]: Set cipher aes, mode xts-plain64, key size 256 bits for device /dev/disk/by-uuid/e7752d4e-6da4-4dda-ae81-49595981c3a5.
[   23.922712] nas kernel: BTRFS info (device sda1): use ssd allocation scheme
[   23.922715] nas kernel: BTRFS info (device sda1): disk space caching is enabled
[   23.922715] nas kernel: BTRFS info (device sda1): has skinny extents
[   23.928670] nas kernel: [drm] Finished loading i915/kbl_dmc_ver1_01.bin (v1.1)
[   23.946757] nas kernel: snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
[   23.951957] nas systemd-vconsole-setup[326]: Invalid font metadata - width: 1476450304 (max 32), height: 4294936580 (max 32), count: 0 (max 512)
[   23.952207] nas systemd-vconsole-setup[326]: Fonts will not be copied to remaining consoles
[   23.962907] nas kernel: Bluetooth: HCI UART driver ver 2.3
[   23.962909] nas kernel: Bluetooth: HCI UART protocol H4 registered
[   23.962909] nas kernel: Bluetooth: HCI UART protocol BCSP registered
[   23.962910] nas kernel: Bluetooth: HCI UART protocol LL registered
[   23.962910] nas kernel: Bluetooth: HCI UART protocol ATH3K registered
[   23.962911] nas kernel: Bluetooth: HCI UART protocol Three-wire (H5) registered
[   23.962928] nas kernel: Bluetooth: HCI UART protocol Intel registered
[   23.962937] nas kernel: Bluetooth: HCI UART protocol Broadcom registered
[   23.962937] nas kernel: Bluetooth: HCI UART protocol QCA registered
[   23.962938] nas kernel: Bluetooth: HCI UART protocol AG6XX registered
[   23.962938] nas kernel: Bluetooth: HCI UART protocol Marvell registered
[   23.965237] nas kernel: iTCO_vendor_support: vendor-support=0
[   23.965928] nas kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   23.966044] nas kernel: iTCO_wdt: Found a Intel PCH TCO device (Version=4, TCOBASE=0x0400)
[   23.966573] nas kernel: iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   23.973247] nas kernel: intel_rapl: Found RAPL domain package
[   23.973249] nas kernel: intel_rapl: Found RAPL domain core
[   23.973251] nas kernel: intel_rapl: Found RAPL domain uncore
[   23.973252] nas kernel: intel_rapl: Found RAPL domain dram
[   23.973648] nas kernel: fbcon: inteldrmfb (fb0) is primary device
[   24.007973] nas systemd[1]: Reached target Sound Card.
[   24.073530] nas systemd[1]: Mounted /mnt/btrfs/root.
[   24.073710] nas systemd[1]: Mounted /var/lib/machines.
[   24.073815] nas systemd[1]: Found device ST8000AS0002-1NA17Z 1.
[   24.073912] nas systemd[1]: Starting Cryptography Setup for backup...
[   23.988328] nas kernel: snd_hda_codec_realtek hdaudioC0D0: ALC1150: SKU not ready 0x00000000
[   23.988705] nas kernel: snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC1150: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[   23.988706] nas kernel: snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   23.988707] nas kernel: snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[   23.988708] nas kernel: snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[   23.988708] nas kernel: snd_hda_codec_realtek hdaudioC0D0:    dig-out=0x1e/0x0
[   23.988709] nas kernel: snd_hda_codec_realtek hdaudioC0D0:    inputs:
[   23.988710] nas kernel: snd_hda_codec_realtek hdaudioC0D0:      Front Mic=0x19
[   23.988711] nas kernel: snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=0x18
[   23.988712] nas kernel: snd_hda_codec_realtek hdaudioC0D0:      Line=0x1a
[   24.007567] nas kernel: input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1f.3/sound/card0/input8
[   24.008401] nas kernel: input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1f.3/sound/card0/input9
[   24.008441] nas kernel: input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1f.3/sound/card0/input10
[   24.008480] nas kernel: input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1f.3/sound/card0/input11
[   24.008518] nas kernel: input: HDA Intel PCH Line Out as /devices/pci0000:00/0000:00:1f.3/sound/card0/input12
[   24.008557] nas kernel: input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1f.3/sound/card0/input13
[   24.008596] nas kernel: input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input14
[   24.008635] nas kernel: input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input15
[   24.008673] nas kernel: input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input16
[   24.051197] nas kernel: Console: switching to colour frame buffer device 240x67
[   24.072723] nas kernel: i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   24.081421] nas systemd-cryptsetup[372]: Set cipher aes, mode xts-plain64, key size 256 bits for device /dev/disk/by-uuid/44c7fa8c-a1e3-4a4a-84ce-faac4c7c3c3b.
[   24.082349] nas systemd[1]: Mounted /boot.
[   24.132708] nas systemd[1]: Created slice system-systemd\x2dbacklight.slice.
[   24.132883] nas systemd[1]: Starting Load/Save Screen Backlight Brightness of backlight:acpi_video0...
[   24.136198] nas systemd[1]: Started Load/Save Screen Backlight Brightness of backlight:acpi_video0.
[   24.151142] nas systemd[1]: Mounted /mnt/btrfs/boot.
[   25.042780] nas kernel: [drm] RC6 on
[   29.390820] nas kernel: BTRFS: device fsid 3a01e217-09d9-4006-b51b-28773f4eb3e5 devid 1 transid 9556 /dev/dm-1
[   29.390325] nas systemd[1]: Started Cryptography Setup for backup.
[   29.390497] nas systemd[1]: systemd-cryptsetup@backup.service: Unit is bound to inactive unit dev-mapper-backup.device. Stopping, too.
[   29.390624] nas systemd[1]: Requested transaction contradicts existing jobs: Transaction is destructive.
[   29.390719] nas systemd[1]: systemd-cryptsetup@backup.service: Failed to enqueue stop job, ignoring: Transaction is destructive.
[   29.391268] nas systemd[1]: Found device /dev/disk/by-uuid/3a01e217-09d9-4006-b51b-28773f4eb3e5.
[   29.393800] nas systemd[1]: Mounting /mnt/btrfs/backup...
[   29.393970] nas systemd[1]: Mounting /srv/backup...
[   29.396876] nas kernel: BTRFS info (device dm-1): disk space caching is enabled
[   29.396877] nas kernel: BTRFS info (device dm-1): has skinny extents
[   31.197182] nas systemd[1]: Started Cryptography Setup for storage0.
[   31.197360] nas systemd[1]: systemd-cryptsetup@storage0.service: Unit is bound to inactive unit dev-mapper-storage0.device. Stopping, too.
[   31.197465] nas systemd[1]: Requested transaction contradicts existing jobs: Transaction is destructive.
[   31.197559] nas systemd[1]: systemd-cryptsetup@storage0.service: Failed to enqueue stop job, ignoring: Transaction is destructive.
[   31.197691] nas kernel: BTRFS: device fsid 2ba6cbfb-4c68-4559-9ae8-b4aa4fda10f5 devid 1 transid 5 /dev/dm-2
[   31.302316] nas systemd[1]: Started Cryptography Setup for storage1.
[   31.302502] nas systemd[1]: systemd-cryptsetup@storage1.service: Unit is bound to inactive unit dev-mapper-storage1.device. Stopping, too.
[   31.302611] nas systemd[1]: Requested transaction contradicts existing jobs: Transaction is destructive.
[   31.302703] nas systemd[1]: systemd-cryptsetup@storage1.service: Failed to enqueue stop job, ignoring: Transaction is destructive.
[   31.303008] nas kernel: BTRFS: device fsid 2ba6cbfb-4c68-4559-9ae8-b4aa4fda10f5 devid 2 transid 5 /dev/dm-3
[   31.707759] nas systemd[1]: Started Cryptography Setup for storage2.
[   31.707905] nas systemd[1]: Reached target Encrypted Volumes.
[   31.707859] nas kernel: BTRFS: device fsid 2ba6cbfb-4c68-4559-9ae8-b4aa4fda10f5 devid 3 transid 5 /dev/dm-4
[   41.101831] nas systemd[1]: Mounted /mnt/btrfs/backup.
[   41.181892] nas systemd[1]: Mounted /srv/backup.
[   41.182195] nas systemd[1]: Reached target Local File Systems.
[   41.182931] nas systemd[1]: Starting Create Volatile Files and Directories...
[   41.190529] nas systemd[1]: Started Create Volatile Files and Directories.
[   41.191528] nas systemd[1]: Starting Update UTMP about System Boot/Shutdown...
[   41.197478] nas systemd[1]: Started Update UTMP about System Boot/Shutdown.
[   41.197801] nas systemd[1]: Reached target System Initialization.
[   41.198154] nas systemd[1]: Started Discard unused blocks once a week.
[   41.199028] nas systemd[1]: Starting Network Service...
[   41.199311] nas systemd[1]: Started Daily Cleanup of Temporary Directories.
[   41.199590] nas systemd[1]: Started Daily verification of password and group files.
[   41.199951] nas systemd[1]: Started Daily man-db cache update.
[   41.200216] nas systemd[1]: Listening on D-Bus System Message Bus Socket.
[   41.200452] nas systemd[1]: Reached target Sockets.
[   41.200689] nas systemd[1]: Reached target Basic System.
[   41.200854] nas systemd[1]: Reached target Containers.
[   41.201741] nas systemd[1]: Started D-Bus System Message Bus.
[   41.234121] nas systemd[1]: Starting Login Service...
[   41.234488] nas systemd-networkd[451]: Enumeration completed
[   41.234824] nas systemd[1]: Started Daily rotation of log files.
[   41.235069] nas systemd[1]: Reached target Timers.
[   41.235301] nas systemd-networkd[451]: enp2s0: IPv6 successfully enabled
[   41.235576] nas systemd[1]: Started Network Service.
[   41.235819] nas systemd[1]: Reached target Network.
[   41.236892] nas systemd[1]: Starting Network Name Resolution...
[   41.237798] nas systemd[1]: Started OpenSSH Daemon.
[   41.241009] nas systemd[1]: Starting Permit User Sessions...
[   41.246981] nas systemd[1]: Started Login Service.
[   41.247253] nas systemd-logind[453]: New seat seat0.
[   41.254174] nas systemd-logind[453]: Watching system buttons on /dev/input/event2 (Power Button)
[   41.254438] nas systemd-logind[453]: Watching system buttons on /dev/input/event4 (Video Bus)
[   41.254636] nas systemd-logind[453]: Watching system buttons on /dev/input/event1 (Power Button)
[   41.254863] nas systemd-logind[453]: Watching system buttons on /dev/input/event0 (Sleep Button)
[   41.281985] nas systemd[1]: Started Permit User Sessions.
[   41.283159] nas systemd[1]: Started Getty on tty1.
[   41.283926] nas systemd[1]: Reached target Login Prompts.
[   41.282895] nas kernel: IPv6: ADDRCONF(NETDEV_UP): enp2s0: link is not ready
[   41.315692] nas sshd[455]: Server listening on 0.0.0.0 port 22.
[   41.315985] nas sshd[455]: Server listening on :: port 22.
[   41.527700] nas systemd-resolved[454]: Positive Trust Anchors:
[   41.528016] nas systemd-resolved[454]: . IN DS 19036 8 2 49aac11d7b6f6446702e54a1607371607a1a41855200fd2ce1cdde32f24e8fb5
[   41.528184] nas systemd-resolved[454]: . IN DS 20326 8 2 e06d44b80b8f1d39a95c0b0d7c65d08458e880409bbc683457104237c7f8ec8d
[   41.528328] nas systemd-resolved[454]: Negative trust anchors: 10.in-addr.arpa 16.172.in-addr.arpa 17.172.in-addr.arpa 18.172.in-addr.arpa 19.172.in-addr.arpa 20.172.in-addr.arpa 21.172.in-addr.arpa 22.172.in-addr.arpa 23.172.in-addr.arpa 24.172.in-addr.arpa 25.172.in-addr.arpa 26.172.in-addr.arpa 27.172.in-addr.arpa 28.172.in-addr.arpa 29.172.in-addr.arpa 30.172.in-addr.arpa 31.172.in-addr.arpa 168.192.in-addr.arpa d.f.ip6.arpa corp home internal intranet lan local private test
[   41.528473] nas systemd-resolved[454]: Using system hostname 'nas'.
[   41.529566] nas systemd[1]: Started Network Name Resolution.
[   41.531306] nas systemd[1]: Reached target Multi-User System.
[   41.532933] nas systemd[1]: Reached target Graphical Interface.
[   41.534499] nas systemd[1]: Startup finished in 22.406s (kernel) + 19.128s (userspace) = 41.534s.
[   44.223221] nas kernel: igb 0000:02:00.0 enp2s0: igb: enp2s0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   44.340935] nas systemd-networkd[451]: enp2s0: Gained carrier
[   44.342930] nas kernel: IPv6: ADDRCONF(NETDEV_CHANGE): enp2s0: link becomes ready
[   45.760421] nas systemd-networkd[451]: enp2s0: Gained IPv6LL
[   46.974507] nas sshd[463]: Accepted publickey for root from 192.168.0.21 port 55654 ssh2: RSA SHA256:Dvets/zE6m0i0+7iKHE4ppWWSP7urXA0RwlHarWJG0s
[   46.976095] nas sshd[463]: pam_unix(sshd:session): session opened for user root by (uid=0)
[   46.981413] nas systemd[1]: Created slice User Slice of root.
[   46.985089] nas systemd[1]: Starting User Manager for UID 0...
[   46.989254] nas systemd[1]: Started Session c1 of user root.
[   46.989504] nas systemd-logind[453]: New session c1 of user root.
[   46.990400] nas systemd[465]: pam_unix(systemd-user:session): session opened for user root by (uid=0)
[   47.000397] nas systemd[465]: Reached target Paths.
[   47.000856] nas systemd[465]: Starting D-Bus User Message Bus Socket.
[   47.001025] nas systemd[465]: Reached target Timers.
[   47.004832] nas systemd[465]: Listening on D-Bus User Message Bus Socket.
[   47.005004] nas systemd[465]: Reached target Sockets.
[   47.005132] nas systemd[465]: Reached target Basic System.
[   47.005222] nas systemd[465]: Reached target Default.
[   47.005320] nas systemd[465]: Startup finished in 12ms.
[   47.005456] nas systemd[1]: Started User Manager for UID 0.
[   47.760445] nas systemd-networkd[451]: enp2s0: Configured
[   66.113989] nas kernel: BTRFS: device fsid 2ad77473-ae68-4f11-8e64-03aa22e437ad devid 1 transid 5 /dev/dm-2
[   66.407643] nas systemd[1]: Stopped /dev/disk/by-id/dm-uuid-CRYPT-LUKS1-94dafd2c34e3442e91030c42f4b626cd-storage1.
[   66.408093] nas systemd[1]: Stopped /dev/disk/by-id/dm-name-storage1.
[   66.408300] nas systemd[1]: Stopped /dev/dm-3.
[   66.408520] nas systemd[1]: Stopped /sys/devices/virtual/block/dm-3.
[   66.408684] nas systemd[1]: Stopped target Encrypted Volumes.
[   66.409308] nas systemd[1]: Stopping Cryptography Setup for storage1...
[   66.408438] nas kernel: BTRFS: device fsid 2ad77473-ae68-4f11-8e64-03aa22e437ad devid 2 transid 5 /dev/dm-3
[   66.501206] nas systemd[1]: Stopped Cryptography Setup for storage1.
[   66.552614] nas kernel: BTRFS: device fsid 2ad77473-ae68-4f11-8e64-03aa22e437ad devid 3 transid 5 /dev/dm-4
[  118.449318] nas sshd[520]: Accepted publickey for ochi from 192.168.0.21 port 55656 ssh2: RSA SHA256:Dvets/zE6m0i0+7iKHE4ppWWSP7urXA0RwlHarWJG0s
[  118.450228] nas sshd[520]: pam_unix(sshd:session): session opened for user ochi by (uid=0)
[  118.456249] nas systemd[1]: Created slice User Slice of ochi.
[  118.458049] nas systemd[1]: Unnecessary job for /dev/mapper/storage1 was removed.
[  118.458872] nas systemd[1]: Starting Cryptography Setup for storage1...
[  118.459543] nas systemd[1]: Starting User Manager for UID 1000...
[  118.461904] nas systemd[1]: Started Session c2 of user ochi.
[  118.462919] nas systemd-logind[453]: New session c2 of user ochi.
[  118.463519] nas systemd-cryptsetup[522]: Set cipher aes, mode xts-plain64, key size 256 bits for device /dev/disk/by-uuid/94dafd2c-34e3-442e-9103-0c42f4b626cd.
[  118.465899] nas systemd[523]: pam_unix(systemd-user:session): session opened for user ochi by (uid=0)
[  118.478971] nas systemd[523]: Starting D-Bus User Message Bus Socket.
[  118.486257] nas systemd[523]: Reached target Timers.
[  118.486404] nas systemd[523]: Reached target Paths.
[  118.486530] nas systemd[523]: Listening on D-Bus User Message Bus Socket.
[  118.486636] nas systemd[523]: Reached target Sockets.
[  118.486712] nas systemd[523]: Reached target Basic System.
[  118.486784] nas systemd[523]: Reached target Default.
[  118.486852] nas systemd[523]: Startup finished in 14ms.
[  118.486926] nas systemd[1]: Started User Manager for UID 1000.
[  122.905359] nas systemd[1]: Started Cryptography Setup for storage1.
[  141.911199] nas sshd[538]: Received disconnect from 192.168.0.21 port 55656:11: disconnected by user
[  141.911675] nas sshd[538]: Disconnected from user ochi 192.168.0.21 port 55656
[  141.911954] nas sshd[520]: pam_unix(sshd:session): session closed for user ochi
[  141.915562] nas systemd-logind[453]: Removed session c2.
[  141.916253] nas systemd[1]: Stopping User Manager for UID 1000...
[  141.917027] nas systemd[523]: Stopped target Default.
[  141.917421] nas systemd[523]: Stopped target Basic System.
[  141.917678] nas systemd[523]: Stopped target Timers.
[  141.917930] nas systemd[523]: Stopped target Sockets.
[  141.918179] nas systemd[523]: Closed D-Bus User Message Bus Socket.
[  141.918402] nas systemd[523]: Stopped target Paths.
[  141.918560] nas systemd[523]: Reached target Shutdown.
[  141.918709] nas systemd[523]: Starting Exit the Session...
[  141.920945] nas systemd[523]: Received SIGRTMIN+24 from PID 555 (kill).
[  141.923928] nas systemd[1]: Stopped User Manager for UID 1000.
[  141.924933] nas systemd[1]: Removed slice User Slice of ochi.
[  243.822364] nas sshd[556]: Accepted publickey for root from 192.168.0.21 port 55668 ssh2: RSA SHA256:Dvets/zE6m0i0+7iKHE4ppWWSP7urXA0RwlHarWJG0s
[  243.823224] nas sshd[556]: pam_unix(sshd:session): session opened for user root by (uid=0)
[  243.825290] nas systemd-logind[453]: New session c3 of user root.
[  243.825893] nas systemd[1]: Started Session c3 of user root.
[  265.195087] nas sshd[556]: Received disconnect from 192.168.0.21 port 55668:11: disconnected by user
[  265.195937] nas sshd[556]: Disconnected from user root 192.168.0.21 port 55668
[  265.196311] nas sshd[556]: pam_unix(sshd:session): session closed for user root
[  265.200852] nas systemd-logind[453]: Removed session c3.

--------------C88D14D0FB12660CCFE09440--
