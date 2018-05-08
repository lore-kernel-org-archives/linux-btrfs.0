Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:34232 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755122AbeEHRoR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 13:44:17 -0400
Received: by mail-wm0-f47.google.com with SMTP id a137-v6so20039056wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 May 2018 10:44:16 -0700 (PDT)
Received: from localhost (htr06-1-82-227-229-91.fbx.proxad.net. [82.227.229.91])
        by smtp.gmail.com with ESMTPSA id d8-v6sm24464860wrb.52.2018.05.08.10.44.13
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 May 2018 10:44:14 -0700 (PDT)
Date: Tue, 8 May 2018 19:44:12 +0200
From: Nicolas Porcel <nicolasporcel06@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: send ioctl failed with -2
Message-ID: <20180508174412.GA3058@nicolas-desktop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello,

When I do a btrfs send, I get the following error code:

    # btrfs send mysnapshot > /dev/null
    ERROR: send ioctl failed with -2: No such file or directory

I get it after 70-100% of the bytes are sent.

    $ uname -a
    Linux nicolas-desktop 4.17.0-rc2_3+ #1 SMP PREEMPT Tue May 8 01:14:47 CEST 2018 x86_64 GNU/Linux 

    $ btrfs --version
    btrfs-progs v4.16.1

    # btrfs fi show
    Label: 'ssd'  uuid: 135e8b6e-c5e5-4d2c-8c1a-62093b41ed1c
          Total devices 1 FS bytes used 178.72GiB
          devid    1 size 238.47GiB used 238.47GiB path /dev/sdb1

    # btrfs fi df /home
    Data, single: total=226.44GiB, used=173.10GiB
    System, single: total=32.00MiB, used=48.00KiB
    Metadata, single: total=12.00GiB, used=5.62GiB
    GlobalReserve, single: total=512.00MiB, used=0.00B

    # sudo btrfs scrub status /home                                                                                                               
    scrub status for 135e8b6e-c5e5-4d2c-8c1a-62093b41ed1c
    scrub started at Mon May  7 02:07:52 2018 and finished after 00:07:23
    total bytes scrubbed: 162.16GiB with 0 errors

For the kernel version, I had the same problem with v4.16.1 so this is
not a regression of the rc.

I use btrbk to automate my snapshots and backups. I only have the
problem with one of my subvolumes while I do the automatic snapshots
with many subvolumes on this drive. Also, all the snapshots of this
subvolume seem affected.

Did anyone encounter a similar issue or can help me investigate it?

I started looking at the kernel code for the send ioctl but was too lazy
to go through the call hierarchy after 3 function calls. I also found a
page on the btrfs wiki how to debug btrfs using user mode linux but I do
not know if it still works considering it is using 2.6.

Thank you.

-- 
Nicolas Porcel

--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg.log"

[    0.000000] Linux version 4.17.0-rc2_3+ (nicolas@nicolas-desktop) (gcc version 7.3.0 (GCC)) #1 SMP PREEMPT Tue May 8 01:14:47 CEST 2018
[    0.000000] Command line: BOOT_IMAGE=/void/boot/vmlinuz-4.17.0-rc2_3+ root=UUID=135e8b6e-c5e5-4d2c-8c1a-62093b41ed1c ro rootflags=subvol=void loglevel=4 slub_debug=P page_poison=1 crashkernel=168M
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'compacted' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000009d7ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000009d80000-0x0000000009ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000000a000000-0x00000000dd27ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dd280000-0x00000000dd3c0fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dd3c1000-0x00000000dd4bbfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dd4bc000-0x00000000dd88efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dd88f000-0x00000000de3e8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000de3e9000-0x00000000deffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000df000000-0x00000000dfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fdf00000-0x00000000fdffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fea00000-0x00000000fea0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feb80000-0x00000000fec01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec30000-0x00000000fec30fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed40000-0x00000000fed44fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fedc2000-0x00000000fedcffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fedd4000-0x00000000fedd5fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000feefffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041f37ffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 3.0 present.
[    0.000000] DMI: Micro-Star International Co., Ltd. MS-7A34/B350 TOMAHAWK (MS-7A34), BIOS 1.90 09/19/2017
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x41f380 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFE0000000 write-back
[    0.000000]   3 base 0000DF000000 mask FFFFFF000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000420000000 aka 16896M
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.000000] e820: update [mem 0xdf000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdf000 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [        (ptrval)] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x1a96b2000, 0x1a96b2fff] PGTABLE
[    0.000000] BRK [0x1a96b3000, 0x1a96b3fff] PGTABLE
[    0.000000] BRK [0x1a96b4000, 0x1a96b4fff] PGTABLE
[    0.000000] BRK [0x1a96b5000, 0x1a96b5fff] PGTABLE
[    0.000000] BRK [0x1a96b6000, 0x1a96b6fff] PGTABLE
[    0.000000] BRK [0x1a96b7000, 0x1a96b7fff] PGTABLE
[    0.000000] BRK [0x1a96b8000, 0x1a96b8fff] PGTABLE
[    0.000000] BRK [0x1a96b9000, 0x1a96b9fff] PGTABLE
[    0.000000] BRK [0x1a96ba000, 0x1a96bafff] PGTABLE
[    0.000000] BRK [0x1a96bb000, 0x1a96bbfff] PGTABLE
[    0.000000] BRK [0x1a96bc000, 0x1a96bcfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x35ce7000-0x36e6afff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F05B0 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000DD4BC090 00009C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DD4C1FA0 000114 (v06 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has valid Length but zero Address: 0x0000000000000000/0x1 (20180313/tbfadt-624)
[    0.000000] ACPI: DSDT 0x00000000DD4BC1C0 005DDA (v02 ALASKA A M I    01072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x00000000DD878E00 000040
[    0.000000] ACPI: APIC 0x00000000DD4C20B8 0000DE (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000DD4C2198 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x00000000DD4C21E0 00009C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x00000000DD4C2280 008C4C (v02 AMD    AMD ALIB 00000002 MSFT 04000000)
[    0.000000] ACPI: CRAT 0x00000000DD4CAED0 000F50 (v01 AMD    AMD CRAT 00000001 AMD  00000001)
[    0.000000] ACPI: CDIT 0x00000000DD4CBE20 000029 (v01 AMD    AMD CDIT 00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 0x00000000DD4CBE50 0017B7 (v01 AMD    AMD AOD  00000001 INTL 20120913)
[    0.000000] ACPI: MCFG 0x00000000DD4CD608 00003C (v01 ALASKA A M I    01072009 MSFT 00010013)
[    0.000000] ACPI: HPET 0x00000000DD4CD648 000038 (v01 ALASKA A M I    01072009 AMI  00000005)
[    0.000000] ACPI: SSDT 0x00000000DD4CD680 000024 (v01 AMDFCH FCHZP    00001000 INTL 20120913)
[    0.000000] ACPI: UEFI 0x00000000DD4CD6A8 000042 (v01                 00000000      00000000)
[    0.000000] ACPI: IVRS 0x00000000DD4CD6F0 0000D0 (v02 AMD    AMD IVRS 00000001 AMD  00000000)
[    0.000000] ACPI: SSDT 0x00000000DD4CD7C0 0000F8 (v01 AMD    AMD PT   00001000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x00000000DD4CD8B8 001664 (v01 AMD    CPMCMN   00000001 INTL 20120913)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] system APIC only can use physical flat
[    0.000000] Setting APIC routing to physical flat.
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041f37ffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x41f37b000-0x41f37ffff]
[    0.000000] Reserving 168MB of memory at 688MB for crashkernel (System RAM: 16336MB)
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Using PIT calibration value
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000041f37ffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x0000000009d7ffff]
[    0.000000]   node   0: [mem 0x000000000a000000-0x00000000dd27ffff]
[    0.000000]   node   0: [mem 0x00000000dd3c1000-0x00000000dd4bbfff]
[    0.000000]   node   0: [mem 0x00000000de3e9000-0x00000000deffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000041f37ffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000041f37ffff]
[    0.000000] On node 0 totalpages: 4182062
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14133 pages used for memmap
[    0.000000]   DMA32 zone: 904466 pages, LIFO batch:31
[    0.000000]   Normal zone: 51150 pages used for memmap
[    0.000000]   Normal zone: 3273600 pages, LIFO batch:31
[    0.000000] Reserved but unavailable: 100 pages
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] system APIC only can use physical flat
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 17, version 33, address 0xfec00000, GSI 0-23
[    0.000000] IOAPIC[1]: apic_id 18, version 33, address 0xfec01000, GSI 24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10228201 base: 0xfed00000
[    0.000000] smpboot: Allowing 16 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x09d80000-0x09ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd280000-0xdd3c0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd4bc000-0xdd88efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd88f000-0xde3e8fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfdefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdf00000-0xfdffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe000000-0xfe9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfea00000-0xfea0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfea10000-0xfeb7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeb80000-0xfec01fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec02000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec11000-0xfec2ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec30000-0xfec30fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec31000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed3ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed40000-0xfed44fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed45000-0xfed7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed80000-0xfed8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfedc1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfedc2000-0xfedcffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfedd0000-0xfedd3fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfedd4000-0xfedd5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfedd6000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfeefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] random: get_random_bytes called from start_kernel+0xc5/0x750 with crng_init=0
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] percpu: Embedded 44 pages/cpu @        (ptrval) s141848 r8192 d30184 u262144
[    0.000000] pcpu-alloc: s141848 r8192 d30184 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 4116694
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/void/boot/vmlinuz-4.17.0-rc2_3+ root=UUID=135e8b6e-c5e5-4d2c-8c1a-62093b41ed1c ro rootflags=subvol=void loglevel=4 slub_debug=P page_poison=1 crashkernel=168M
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 16183896K/16728248K available (10252K kernel code, 1121K rwdata, 2340K rodata, 1856K init, 916K bss, 544352K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] ftrace: allocating 31432 entries in 123 pages
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=16.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=16
[    0.000000] NR_IRQS: 4352, nr_irqs: 1096, preallocated irqs: 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] ACPI: Core revision 20180313
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484873504 ns
[    0.000000] hpet clockevent registered
[    0.000000] APIC: Switch to symmetric I/O mode setup
[    0.002000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.007000] tsc: Fast TSC calibration failed
[    0.009000] tsc: PIT calibration matches HPET. 1 loops
[    0.009000] tsc: Detected 3399.618 MHz processor
[    0.009000] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x3100e592838, max_idle_ns: 440795256374 ns
[    0.009000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6799.23 BogoMIPS (lpj=3399618)
[    0.009000] pid_max: default: 32768 minimum: 301
[    0.009000] Security Framework initialized
[    0.009000] Yama: becoming mindful.
[    0.010054] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.010216] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.010229] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.010235] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.010444] CPU: Physical Processor ID: 0
[    0.010444] CPU: Processor Core ID: 0
[    0.010450] mce: CPU supports 23 MCE banks
[    0.010466] LVT offset 1 assigned for vector 0xf9
[    0.010578] LVT offset 2 assigned for vector 0xf4
[    0.010588] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 512
[    0.010589] Last level dTLB entries: 4KB 1536, 2MB 1536, 4MB 768, 1GB 0
[    0.010590] Spectre V2 : Mitigation: Full AMD retpoline
[    0.015087] Freeing SMP alternatives memory: 24K
[    0.017000] smpboot: CPU0: AMD Ryzen 7 1700X Eight-Core Processor (family: 0x17, model: 0x1, stepping: 0x1)
[    0.021010] Performance Events: Fam17h core perfctr, AMD PMU driver.
[    0.021013] ... version:                0
[    0.021014] ... bit width:              48
[    0.021014] ... generic registers:      6
[    0.021015] ... value mask:             0000ffffffffffff
[    0.021015] ... max period:             00007fffffffffff
[    0.021016] ... fixed-purpose events:   0
[    0.021016] ... event mask:             000000000000003f
[    0.023005] Hierarchical SRCU implementation.
[    0.027217] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
[    0.029004] smp: Bringing up secondary CPUs ...
[    0.037014] x86: Booting SMP configuration:
[    0.037016] .... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7  #8  #9 #10 #11 #12 #13 #14 #15
[    0.164025] smp: Brought up 1 node, 16 CPUs
[    0.164025] smpboot: Max logical packages: 1
[    0.164025] smpboot: Total of 16 processors activated (108787.77 BogoMIPS)
[    0.166001] devtmpfs: initialized
[    0.166073] x86/mm: Memory block size: 128MB
[    0.168028] PM: Registering ACPI NVS region [mem 0xdd4bc000-0xdd88efff] (4009984 bytes)
[    0.168519] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.168519] futex hash table entries: 4096 (order: 6, 262144 bytes)
[    0.168519] pinctrl core: initialized pinctrl subsystem
[    0.168519] NET: Registered protocol family 16
[    0.169080] audit: initializing netlink subsys (disabled)
[    0.169090] audit: type=2000 audit(1525777007.169:1): state=initialized audit_enabled=0 res=1
[    0.170006] cpuidle: using governor ladder
[    0.170021] cpuidle: using governor menu
[    0.170049] ACPI: bus type PCI registered
[    0.170050] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.170179] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.170182] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.170191] PCI: Using configuration type 1 for base access
[    0.171553] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.171553] mtrr: probably your BIOS does not setup all CPUs.
[    0.171553] mtrr: corrected configuration.
[    0.172546] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.172546] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.173103] ACPI: Added _OSI(Module Device)
[    0.173104] ACPI: Added _OSI(Processor Device)
[    0.173104] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.173105] ACPI: Added _OSI(Processor Aggregator Device)
[    0.173107] ACPI: Added _OSI(Linux-Dell-Video)
[    0.179631] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.206369] ACPI: 6 ACPI AML tables successfully acquired and loaded
[    0.217853] ACPI: Interpreter enabled
[    0.217872] ACPI: (supports S0 S3 S4 S5)
[    0.217873] ACPI: Using IOAPIC for interrupt routing
[    0.218143] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.218831] ACPI: Enabled 2 GPEs in block 00 to 1F
[    0.238890] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.238896] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.239645] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.239669] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.240864] PCI host bridge to bus 0000:00
[    0.240867] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
[    0.240869] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
[    0.240871] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df window]
[    0.240873] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.240875] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.240877] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
[    0.240879] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfec2ffff window]
[    0.240881] pci_bus 0000:00: root bus resource [mem 0xfee00000-0xffffffff window]
[    0.240883] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.240890] pci 0000:00:00.0: [1022:1450] type 00 class 0x060000
[    0.241085] pci 0000:00:00.2: [1022:1451] type 00 class 0x080600
[    0.241294] pci 0000:00:01.0: [1022:1452] type 00 class 0x060000
[    0.241472] pci 0000:00:01.3: [1022:1453] type 01 class 0x060400
[    0.241523] pci 0000:00:01.3: PME# supported from D0 D3hot D3cold
[    0.241711] pci 0000:00:02.0: [1022:1452] type 00 class 0x060000
[    0.241891] pci 0000:00:03.0: [1022:1452] type 00 class 0x060000
[    0.242059] pci 0000:00:03.1: [1022:1453] type 01 class 0x060400
[    0.242108] pci 0000:00:03.1: PME# supported from D0 D3hot D3cold
[    0.242301] pci 0000:00:04.0: [1022:1452] type 00 class 0x060000
[    0.242487] pci 0000:00:07.0: [1022:1452] type 00 class 0x060000
[    0.242653] pci 0000:00:07.1: [1022:1454] type 01 class 0x060400
[    0.242671] pci 0000:00:07.1: enabling Extended Tags
[    0.242697] pci 0000:00:07.1: PME# supported from D0 D3hot D3cold
[    0.242882] pci 0000:00:08.0: [1022:1452] type 00 class 0x060000
[    0.243050] pci 0000:00:08.1: [1022:1454] type 01 class 0x060400
[    0.243069] pci 0000:00:08.1: enabling Extended Tags
[    0.243101] pci 0000:00:08.1: PME# supported from D0 D3hot D3cold
[    0.243315] pci 0000:00:14.0: [1022:790b] type 00 class 0x0c0500
[    0.243647] pci 0000:00:14.3: [1022:790e] type 00 class 0x060100
[    0.243980] pci 0000:00:18.0: [1022:1460] type 00 class 0x060000
[    0.244137] pci 0000:00:18.1: [1022:1461] type 00 class 0x060000
[    0.244292] pci 0000:00:18.2: [1022:1462] type 00 class 0x060000
[    0.244451] pci 0000:00:18.3: [1022:1463] type 00 class 0x060000
[    0.244605] pci 0000:00:18.4: [1022:1464] type 00 class 0x060000
[    0.244759] pci 0000:00:18.5: [1022:1465] type 00 class 0x060000
[    0.244912] pci 0000:00:18.6: [1022:1466] type 00 class 0x060000
[    0.245068] pci 0000:00:18.7: [1022:1467] type 00 class 0x060000
[    0.245325] pci 0000:03:00.0: [1022:43bb] type 00 class 0x0c0330
[    0.245346] pci 0000:03:00.0: reg 0x10: [mem 0xfe8a0000-0xfe8a7fff 64bit]
[    0.245428] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.245512] pci 0000:03:00.1: [1022:43b7] type 00 class 0x010601
[    0.245555] pci 0000:03:00.1: reg 0x24: [mem 0xfe880000-0xfe89ffff]
[    0.245562] pci 0000:03:00.1: reg 0x30: [mem 0xfe800000-0xfe87ffff pref]
[    0.245608] pci 0000:03:00.1: PME# supported from D3hot D3cold
[    0.245673] pci 0000:03:00.2: [1022:43b2] type 01 class 0x060400
[    0.245751] pci 0000:03:00.2: PME# supported from D3hot D3cold
[    0.245851] pci 0000:00:01.3: PCI bridge to [bus 03-22]
[    0.245853] pci 0000:00:01.3:   bridge window [io  0xf000-0xffff]
[    0.245855] pci 0000:00:01.3:   bridge window [mem 0xfe700000-0xfe8fffff]
[    0.245962] pci 0000:04:00.0: [1022:43b4] type 01 class 0x060400
[    0.246059] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    0.246141] pci 0000:04:01.0: [1022:43b4] type 01 class 0x060400
[    0.246239] pci 0000:04:01.0: PME# supported from D3hot D3cold
[    0.246321] pci 0000:04:04.0: [1022:43b4] type 01 class 0x060400
[    0.246417] pci 0000:04:04.0: PME# supported from D3hot D3cold
[    0.246506] pci 0000:03:00.2: PCI bridge to [bus 04-22]
[    0.246510] pci 0000:03:00.2:   bridge window [io  0xf000-0xffff]
[    0.246512] pci 0000:03:00.2:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.246578] pci 0000:1f:00.0: [1b21:1080] type 01 class 0x060400
[    0.246775] pci 0000:1f:00.0: supports D1 D2
[    0.246776] pci 0000:1f:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.249019] pci 0000:04:00.0: PCI bridge to [bus 1f-20]
[    0.249171] pci 0000:1f:00.0: PCI bridge to [bus 20]
[    0.249264] pci 0000:21:00.0: [10ec:8168] type 00 class 0x020000
[    0.249305] pci 0000:21:00.0: reg 0x10: [io  0xf000-0xf0ff]
[    0.249339] pci 0000:21:00.0: reg 0x18: [mem 0xfe704000-0xfe704fff 64bit]
[    0.249361] pci 0000:21:00.0: reg 0x20: [mem 0xfe700000-0xfe703fff 64bit]
[    0.249505] pci 0000:21:00.0: supports D1 D2
[    0.249506] pci 0000:21:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.249661] pci 0000:04:01.0: PCI bridge to [bus 21]
[    0.249665] pci 0000:04:01.0:   bridge window [io  0xf000-0xffff]
[    0.249668] pci 0000:04:01.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.249712] pci 0000:04:04.0: PCI bridge to [bus 22]
[    0.249805] pci 0000:23:00.0: [1022:1470] type 01 class 0x060400
[    0.249823] pci 0000:23:00.0: reg 0x10: [mem 0xfe600000-0xfe603fff]
[    0.249894] pci 0000:23:00.0: PME# supported from D0 D3hot D3cold
[    0.249987] pci 0000:00:03.1: PCI bridge to [bus 23-25]
[    0.249990] pci 0000:00:03.1:   bridge window [io  0xe000-0xefff]
[    0.249991] pci 0000:00:03.1:   bridge window [mem 0xfe500000-0xfe6fffff]
[    0.249994] pci 0000:00:03.1:   bridge window [mem 0xe0000000-0xf01fffff 64bit pref]
[    0.250043] pci 0000:24:00.0: [1022:1471] type 01 class 0x060400
[    0.250124] pci 0000:24:00.0: PME# supported from D0 D3hot D3cold
[    0.250200] pci 0000:23:00.0: PCI bridge to [bus 24-25]
[    0.250204] pci 0000:23:00.0:   bridge window [io  0xe000-0xefff]
[    0.250206] pci 0000:23:00.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.250210] pci 0000:23:00.0:   bridge window [mem 0xe0000000-0xf01fffff 64bit pref]
[    0.250253] pci 0000:25:00.0: [1002:687f] type 00 class 0x030000
[    0.250276] pci 0000:25:00.0: reg 0x10: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.250285] pci 0000:25:00.0: reg 0x18: [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.250291] pci 0000:25:00.0: reg 0x20: [io  0xe000-0xe0ff]
[    0.250298] pci 0000:25:00.0: reg 0x24: [mem 0xfe500000-0xfe57ffff]
[    0.250304] pci 0000:25:00.0: reg 0x30: [mem 0xfe580000-0xfe59ffff pref]
[    0.250368] pci 0000:25:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.250439] pci 0000:25:00.1: [1002:aaf8] type 00 class 0x040300
[    0.250455] pci 0000:25:00.1: reg 0x10: [mem 0xfe5a0000-0xfe5a3fff]
[    0.250536] pci 0000:25:00.1: PME# supported from D1 D2 D3hot D3cold
[    0.250622] pci 0000:24:00.0: PCI bridge to [bus 25]
[    0.250626] pci 0000:24:00.0:   bridge window [io  0xe000-0xefff]
[    0.250628] pci 0000:24:00.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.250632] pci 0000:24:00.0:   bridge window [mem 0xe0000000-0xf01fffff 64bit pref]
[    0.250725] pci 0000:26:00.0: [1022:145a] type 00 class 0x130000
[    0.250754] pci 0000:26:00.0: enabling Extended Tags
[    0.250833] pci 0000:26:00.2: [1022:1456] type 00 class 0x108000
[    0.250848] pci 0000:26:00.2: reg 0x18: [mem 0xfe300000-0xfe3fffff]
[    0.250858] pci 0000:26:00.2: reg 0x24: [mem 0xfe400000-0xfe401fff]
[    0.250864] pci 0000:26:00.2: enabling Extended Tags
[    0.250963] pci 0000:26:00.3: [1022:145c] type 00 class 0x0c0330
[    0.250974] pci 0000:26:00.3: reg 0x10: [mem 0xfe200000-0xfe2fffff 64bit]
[    0.250992] pci 0000:26:00.3: enabling Extended Tags
[    0.251025] pci 0000:26:00.3: PME# supported from D0 D3hot D3cold
[    0.251101] pci 0000:00:07.1: PCI bridge to [bus 26]
[    0.251104] pci 0000:00:07.1:   bridge window [mem 0xfe200000-0xfe4fffff]
[    0.251206] pci 0000:27:00.0: [1022:1455] type 00 class 0x130000
[    0.251238] pci 0000:27:00.0: enabling Extended Tags
[    0.251328] pci 0000:27:00.2: [1022:7901] type 00 class 0x010601
[    0.251354] pci 0000:27:00.2: reg 0x24: [mem 0xfe908000-0xfe908fff]
[    0.251361] pci 0000:27:00.2: enabling Extended Tags
[    0.251396] pci 0000:27:00.2: PME# supported from D3hot D3cold
[    0.251475] pci 0000:27:00.3: [1022:1457] type 00 class 0x040300
[    0.251485] pci 0000:27:00.3: reg 0x10: [mem 0xfe900000-0xfe907fff]
[    0.251507] pci 0000:27:00.3: enabling Extended Tags
[    0.251541] pci 0000:27:00.3: PME# supported from D0 D3hot D3cold
[    0.251621] pci 0000:00:08.1: PCI bridge to [bus 27]
[    0.251624] pci 0000:00:08.1:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.252789] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 10 11 14 15) *0
[    0.252931] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 10 11 14 15) *0
[    0.253065] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 10 11 14 15) *0
[    0.253216] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 10 11 14 15) *0
[    0.253356] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 10 11 14 15) *0
[    0.253479] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 10 11 14 15) *0
[    0.253598] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 7 10 11 14 15) *0
[    0.253717] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 7 10 11 14 15) *0
[    0.254865] pci 0000:25:00.0: vgaarb: setting as boot VGA device
[    0.254865] pci 0000:25:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.254865] pci 0000:25:00.0: vgaarb: bridge control possible
[    0.254865] vgaarb: loaded
[    0.254865] pps_core: LinuxPPS API ver. 1 registered
[    0.254865] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.254865] PTP clock support registered
[    0.254865] EDAC MC: Ver: 3.0.0
[    0.255031] PCI: Using ACPI for IRQ routing
[    0.257643] PCI: pci_cache_line_size set to 64 bytes
[    0.257701] e820: reserve RAM buffer [mem 0x0009d400-0x0009ffff]
[    0.257703] e820: reserve RAM buffer [mem 0x09d80000-0x0bffffff]
[    0.257704] e820: reserve RAM buffer [mem 0xdd280000-0xdfffffff]
[    0.257705] e820: reserve RAM buffer [mem 0xdd4bc000-0xdfffffff]
[    0.257706] e820: reserve RAM buffer [mem 0xdf000000-0xdfffffff]
[    0.257707] e820: reserve RAM buffer [mem 0x41f380000-0x41fffffff]
[    0.258037] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.258039] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.260031] clocksource: Switched to clocksource tsc-early
[    0.267281] VFS: Disk quotas dquot_6.6.0
[    0.267296] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.267367] pnp: PnP ACPI init
[    0.267522] system 00:00: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.267526] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.267655] system 00:01: [mem 0xfeb80000-0xfebfffff] could not be reserved
[    0.267659] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.267931] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.268360] system 00:03: [io  0x0a00-0x0a0f] has been reserved
[    0.268364] system 00:03: [io  0x0a10-0x0a1f] has been reserved
[    0.268367] system 00:03: [io  0x0a20-0x0a2f] has been reserved
[    0.268371] system 00:03: [io  0x0a40-0x0a4f] has been reserved
[    0.268375] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.269014] pnp 00:04: [dma 0 disabled]
[    0.269206] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.269741] pnp 00:05: [dma 0 disabled]
[    0.269789] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.270288] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.270292] system 00:06: [io  0x040b] has been reserved
[    0.270295] system 00:06: [io  0x04d6] has been reserved
[    0.270298] system 00:06: [io  0x0c00-0x0c01] has been reserved
[    0.270302] system 00:06: [io  0x0c14] has been reserved
[    0.270305] system 00:06: [io  0x0c50-0x0c51] has been reserved
[    0.270308] system 00:06: [io  0x0c52] has been reserved
[    0.270311] system 00:06: [io  0x0c6c] has been reserved
[    0.270314] system 00:06: [io  0x0c6f] has been reserved
[    0.270317] system 00:06: [io  0x0cd0-0x0cd1] has been reserved
[    0.270320] system 00:06: [io  0x0cd2-0x0cd3] has been reserved
[    0.270324] system 00:06: [io  0x0cd4-0x0cd5] has been reserved
[    0.270327] system 00:06: [io  0x0cd6-0x0cd7] has been reserved
[    0.270330] system 00:06: [io  0x0cd8-0x0cdf] has been reserved
[    0.270333] system 00:06: [io  0x0800-0x089f] has been reserved
[    0.270336] system 00:06: [io  0x0b00-0x0b0f] has been reserved
[    0.270339] system 00:06: [io  0x0b20-0x0b3f] has been reserved
[    0.270342] system 00:06: [io  0x0900-0x090f] has been reserved
[    0.270345] system 00:06: [io  0x0910-0x091f] has been reserved
[    0.270348] system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.270351] system 00:06: [mem 0xfec01000-0xfec01fff] could not be reserved
[    0.270354] system 00:06: [mem 0xfedc0000-0xfedc0fff] has been reserved
[    0.270357] system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.270360] system 00:06: [mem 0xfed80000-0xfed8ffff] could not be reserved
[    0.270363] system 00:06: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.270366] system 00:06: [mem 0xff000000-0xffffffff] has been reserved
[    0.270370] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.271374] pnp: PnP ACPI: found 7 devices
[    0.277701] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.277765] pci 0000:1f:00.0: PCI bridge to [bus 20]
[    0.277785] pci 0000:04:00.0: PCI bridge to [bus 1f-20]
[    0.277794] pci 0000:04:01.0: PCI bridge to [bus 21]
[    0.277796] pci 0000:04:01.0:   bridge window [io  0xf000-0xffff]
[    0.277800] pci 0000:04:01.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.277806] pci 0000:04:04.0: PCI bridge to [bus 22]
[    0.277814] pci 0000:03:00.2: PCI bridge to [bus 04-22]
[    0.277816] pci 0000:03:00.2:   bridge window [io  0xf000-0xffff]
[    0.277819] pci 0000:03:00.2:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.277825] pci 0000:00:01.3: PCI bridge to [bus 03-22]
[    0.277826] pci 0000:00:01.3:   bridge window [io  0xf000-0xffff]
[    0.277828] pci 0000:00:01.3:   bridge window [mem 0xfe700000-0xfe8fffff]
[    0.277832] pci 0000:24:00.0: PCI bridge to [bus 25]
[    0.277834] pci 0000:24:00.0:   bridge window [io  0xe000-0xefff]
[    0.277837] pci 0000:24:00.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.277839] pci 0000:24:00.0:   bridge window [mem 0xe0000000-0xf01fffff 64bit pref]
[    0.277843] pci 0000:23:00.0: PCI bridge to [bus 24-25]
[    0.277844] pci 0000:23:00.0:   bridge window [io  0xe000-0xefff]
[    0.277848] pci 0000:23:00.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.277850] pci 0000:23:00.0:   bridge window [mem 0xe0000000-0xf01fffff 64bit pref]
[    0.277854] pci 0000:00:03.1: PCI bridge to [bus 23-25]
[    0.277855] pci 0000:00:03.1:   bridge window [io  0xe000-0xefff]
[    0.277857] pci 0000:00:03.1:   bridge window [mem 0xfe500000-0xfe6fffff]
[    0.277858] pci 0000:00:03.1:   bridge window [mem 0xe0000000-0xf01fffff 64bit pref]
[    0.277861] pci 0000:00:07.1: PCI bridge to [bus 26]
[    0.277863] pci 0000:00:07.1:   bridge window [mem 0xfe200000-0xfe4fffff]
[    0.277867] pci 0000:00:08.1: PCI bridge to [bus 27]
[    0.277869] pci 0000:00:08.1:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.277873] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
[    0.277874] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
[    0.277875] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
[    0.277876] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.277877] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff window]
[    0.277878] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff window]
[    0.277879] pci_bus 0000:00: resource 10 [mem 0xe0000000-0xfec2ffff window]
[    0.277879] pci_bus 0000:00: resource 11 [mem 0xfee00000-0xffffffff window]
[    0.277880] pci_bus 0000:03: resource 0 [io  0xf000-0xffff]
[    0.277881] pci_bus 0000:03: resource 1 [mem 0xfe700000-0xfe8fffff]
[    0.277882] pci_bus 0000:04: resource 0 [io  0xf000-0xffff]
[    0.277883] pci_bus 0000:04: resource 1 [mem 0xfe700000-0xfe7fffff]
[    0.277884] pci_bus 0000:21: resource 0 [io  0xf000-0xffff]
[    0.277885] pci_bus 0000:21: resource 1 [mem 0xfe700000-0xfe7fffff]
[    0.277886] pci_bus 0000:23: resource 0 [io  0xe000-0xefff]
[    0.277887] pci_bus 0000:23: resource 1 [mem 0xfe500000-0xfe6fffff]
[    0.277888] pci_bus 0000:23: resource 2 [mem 0xe0000000-0xf01fffff 64bit pref]
[    0.277889] pci_bus 0000:24: resource 0 [io  0xe000-0xefff]
[    0.277889] pci_bus 0000:24: resource 1 [mem 0xfe500000-0xfe5fffff]
[    0.277890] pci_bus 0000:24: resource 2 [mem 0xe0000000-0xf01fffff 64bit pref]
[    0.277891] pci_bus 0000:25: resource 0 [io  0xe000-0xefff]
[    0.277892] pci_bus 0000:25: resource 1 [mem 0xfe500000-0xfe5fffff]
[    0.277893] pci_bus 0000:25: resource 2 [mem 0xe0000000-0xf01fffff 64bit pref]
[    0.277894] pci_bus 0000:26: resource 1 [mem 0xfe200000-0xfe4fffff]
[    0.277895] pci_bus 0000:27: resource 1 [mem 0xfe900000-0xfe9fffff]
[    0.278082] NET: Registered protocol family 2
[    0.278243] tcp_listen_portaddr_hash hash table entries: 8192 (order: 5, 131072 bytes)
[    0.278282] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.278426] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.278535] TCP: Hash tables configured (established 131072 bind 65536)
[    0.278582] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.278618] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.278721] NET: Registered protocol family 1
[    0.278921] pci 0000:25:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.278927] pci 0000:25:00.1: Linked as a consumer to 0000:25:00.0
[    0.279184] PCI: CLS 64 bytes, default 64
[    0.279225] Unpacking initramfs...
[    0.513388] Freeing initrd memory: 17936K
[    0.513403] AMD-Vi: IOMMU performance counters supported
[    0.513560] pci 0000:00:00.2: can't derive routing for PCI INT A
[    0.513561] pci 0000:00:00.2: PCI INT A: not connected
[    0.513961] iommu: Adding device 0000:00:01.0 to group 0
[    0.514185] iommu: Adding device 0000:00:01.3 to group 1
[    0.514344] iommu: Adding device 0000:00:02.0 to group 2
[    0.514515] iommu: Adding device 0000:00:03.0 to group 3
[    0.514676] iommu: Adding device 0000:00:03.1 to group 4
[    0.514846] iommu: Adding device 0000:00:04.0 to group 5
[    0.515010] iommu: Adding device 0000:00:07.0 to group 6
[    0.515031] iommu: Adding device 0000:00:07.1 to group 6
[    0.515203] iommu: Adding device 0000:00:08.0 to group 7
[    0.515226] iommu: Adding device 0000:00:08.1 to group 7
[    0.515391] iommu: Adding device 0000:00:14.0 to group 8
[    0.515412] iommu: Adding device 0000:00:14.3 to group 8
[    0.515605] iommu: Adding device 0000:00:18.0 to group 9
[    0.515623] iommu: Adding device 0000:00:18.1 to group 9
[    0.515641] iommu: Adding device 0000:00:18.2 to group 9
[    0.515662] iommu: Adding device 0000:00:18.3 to group 9
[    0.515680] iommu: Adding device 0000:00:18.4 to group 9
[    0.515698] iommu: Adding device 0000:00:18.5 to group 9
[    0.515719] iommu: Adding device 0000:00:18.6 to group 9
[    0.515737] iommu: Adding device 0000:00:18.7 to group 9
[    0.515910] iommu: Adding device 0000:03:00.0 to group 10
[    0.515936] iommu: Adding device 0000:03:00.1 to group 10
[    0.515962] iommu: Adding device 0000:03:00.2 to group 10
[    0.515981] iommu: Adding device 0000:04:00.0 to group 10
[    0.515998] iommu: Adding device 0000:04:01.0 to group 10
[    0.516014] iommu: Adding device 0000:04:04.0 to group 10
[    0.516032] iommu: Adding device 0000:1f:00.0 to group 10
[    0.516057] iommu: Adding device 0000:21:00.0 to group 10
[    0.516300] iommu: Adding device 0000:23:00.0 to group 11
[    0.516452] iommu: Adding device 0000:24:00.0 to group 12
[    0.516668] iommu: Adding device 0000:25:00.0 to group 13
[    0.516751] iommu: Using direct mapping for device 0000:25:00.0
[    0.516879] iommu: Adding device 0000:25:00.1 to group 14
[    0.516893] iommu: Adding device 0000:26:00.0 to group 6
[    0.516906] iommu: Adding device 0000:26:00.2 to group 6
[    0.516922] iommu: Adding device 0000:26:00.3 to group 6
[    0.516937] iommu: Adding device 0000:27:00.0 to group 7
[    0.516949] iommu: Adding device 0000:27:00.2 to group 7
[    0.516962] iommu: Adding device 0000:27:00.3 to group 7
[    0.517187] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
[    0.517187] AMD-Vi: Extended features (0xf77ef22294ada):
[    0.517188]  PPR NX GT IA GA PC GA_vAPIC
[    0.517191] AMD-Vi: Interrupt remapping enabled
[    0.517191] AMD-Vi: virtual APIC enabled
[    0.517302] AMD-Vi: Lazy IO/TLB flushing enabled
[    0.524348] amd_uncore: AMD NB counters detected
[    0.524352] amd_uncore: AMD LLC counters detected
[    0.524585] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4 counters/bank).
[    0.524648] Scanning for low memory corruption every 60 seconds
[    0.525471] Initialise system trusted keyrings
[    0.525539] workingset: timestamp_bits=40 max_order=22 bucket_order=0
[    0.527548] zbud: loaded
[    0.527964] pstore: using deflate compression
[    0.528439] Key type asymmetric registered
[    0.528440] Asymmetric key parser 'x509' registered
[    0.528471] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 246)
[    0.528510] io scheduler noop registered
[    0.528511] io scheduler deadline registered
[    0.528560] io scheduler cfq registered (default)
[    0.528561] io scheduler mq-deadline registered
[    0.528562] io scheduler kyber registered
[    0.530479] pcieport 0000:00:01.3: AER enabled with IRQ 26
[    0.530503] pcieport 0000:00:03.1: AER enabled with IRQ 27
[    0.530518] pcieport 0000:00:01.3: Signaling PME with IRQ 26
[    0.530528] pcieport 0000:00:03.1: Signaling PME with IRQ 27
[    0.530538] iommu ivhd0: AMD-Vi: Event logged [
[    0.530544] iommu ivhd0: INVALID_DEVICE_REQUEST device=00:00.0 address=0xfffffffdf8000000 flags=0x0a00]
[    0.530545] pcieport 0000:00:07.1: Signaling PME with IRQ 28
[    0.530577] pcieport 0000:00:08.1: Signaling PME with IRQ 30
[    0.530608] vesafb: mode is 3840x2160x16, linelength=7680, pages=0
[    0.530608] vesafb: scrolling: redraw
[    0.530609] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.530618] vesafb: framebuffer at 0xe0000000, mapped to 0x        (ptrval), using 16256k, total 16256k
[    0.568702] Console: switching to colour frame buffer device 480x135
[    0.606656] fb0: VESA VGA frame buffer device
[    0.615069] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.636150] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.638141] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    0.638158] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.638159] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.638173] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    0.638174] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    0.638189] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    0.638189] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    0.638225] i8042: PNP: No PS/2 controller found.
[    0.638279] mousedev: PS/2 mouse device common for all mice
[    0.638332] rtc_cmos 00:02: RTC can wake from S4
[    0.638577] rtc_cmos 00:02: registered as rtc0
[    0.638593] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.638719] ledtrig-cpu: registered to indicate activity on CPUs
[    0.639031] NET: Registered protocol family 10
[    0.641526] Segment Routing with IPv6
[    0.641541] NET: Registered protocol family 17
[    0.641578] Key type dns_resolver registered
[    0.643930] microcode: CPU0: patch_level=0x08001129
[    0.643933] microcode: CPU1: patch_level=0x08001129
[    0.643936] microcode: CPU2: patch_level=0x08001129
[    0.643939] microcode: CPU3: patch_level=0x08001129
[    0.643943] microcode: CPU4: patch_level=0x08001129
[    0.643947] microcode: CPU5: patch_level=0x08001129
[    0.643951] microcode: CPU6: patch_level=0x08001129
[    0.643955] microcode: CPU7: patch_level=0x08001129
[    0.643960] microcode: CPU8: patch_level=0x08001129
[    0.643965] microcode: CPU9: patch_level=0x08001129
[    0.643970] microcode: CPU10: patch_level=0x08001129
[    0.643975] microcode: CPU11: patch_level=0x08001129
[    0.643979] microcode: CPU12: patch_level=0x08001129
[    0.643984] microcode: CPU13: patch_level=0x08001129
[    0.643988] microcode: CPU14: patch_level=0x08001129
[    0.643993] microcode: CPU15: patch_level=0x08001129
[    0.644026] microcode: Microcode Update Driver: v2.2.
[    0.644036] sched_clock: Marking stable (644021604, 0)->(828686166, -184664562)
[    0.644133] registered taskstats version 1
[    0.644134] Loading compiled-in X.509 certificates
[    0.644193] zswap: loaded using pool lzo/zbud
[    0.644971] rtc_cmos 00:02: setting system clock to 2018-05-08 10:56:48 UTC (1525777008)
[    1.029153] Freeing unused kernel memory: 1856K
[    1.029154] Write protecting the kernel read-only data: 16384k
[    1.030486] Freeing unused kernel memory: 2024K
[    1.033355] Freeing unused kernel memory: 1756K
[    1.033486] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    1.070959] dracut: dracut-047
[    1.122779] systemd-udevd[306]: starting version 3.2.5
[    1.122880] random: systemd-udevd: uninitialized urandom read (16 bytes read)
[    1.122899] random: systemd-udevd: uninitialized urandom read (16 bytes read)
[    1.122913] random: systemd-udevd: uninitialized urandom read (16 bytes read)
[    1.123492] udevd[307]: starting eudev-3.2.5
[    1.128225] random: systemd-udevd: uninitialized urandom read (16 bytes read)
[    1.136935] random: systemd-udevd: uninitialized urandom read (16 bytes read)
[    1.139369] random: systemd-udevd: uninitialized urandom read (16 bytes read)
[    1.147112] ACPI: bus type USB registered
[    1.147160] usbcore: registered new interface driver usbfs
[    1.147177] usbcore: registered new interface driver hub
[    1.147247] usbcore: registered new device driver usb
[    1.148132] Linux agpgart interface v0.103
[    1.148430] SCSI subsystem initialized
[    1.154020] QUIRK: Enable AMD PLL fix
[    1.154042] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    1.154048] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 1
[    1.154061] libata version 3.00 loaded.
[    1.186903] [drm] amdgpu kernel modesetting enabled.
[    1.187550] checking generic (e0000000 fe0000) vs hw (e0000000 10000000)
[    1.187551] fb: switching to amdgpudrmfb from VESA VGA
[    1.187582] Console: switching to colour dummy device 80x25
[    1.187895] [drm] initializing kernel modesetting (VEGA10 0x1002:0x687F 0x1002:0x0B36 0xC3).
[    1.187903] [drm] register mmio base: 0xFE500000
[    1.187904] [drm] register mmio size: 524288
[    1.187911] [drm] probing gen 2 caps for device 1022:1471 = 700d03/e
[    1.187913] [drm] probing mlw for device 1022:1471 = 700d03
[    1.187915] [drm] add ip block number 0 <soc15_common>
[    1.187915] [drm] add ip block number 1 <gmc_v9_0>
[    1.187916] [drm] add ip block number 2 <vega10_ih>
[    1.187917] [drm] add ip block number 3 <psp>
[    1.187917] [drm] add ip block number 4 <powerplay>
[    1.187918] [drm] add ip block number 5 <dm>
[    1.187919] [drm] add ip block number 6 <gfx_v9_0>
[    1.187919] [drm] add ip block number 7 <sdma_v4_0>
[    1.187920] [drm] add ip block number 8 <uvd_v7_0>
[    1.187921] [drm] add ip block number 9 <vce_v4_0>
[    1.187955] [drm] UVD is enabled in VM mode
[    1.187955] [drm] UVD ENC is enabled in VM mode
[    1.187955] [drm] VCE enabled in VM mode
[    1.187967] amdgpu 0000:25:00.0: Invalid PCI ROM header signature: expecting 0xaa55, got 0xffff
[    1.187981] ATOM BIOS: 113-D0500300-102
[    1.188025] [drm] vm size is 262144 GB, 4 levels, block size is 9-bit, fragment size is 9-bit
[    1.188036] amdgpu 0000:25:00.0: VRAM: 8176M 0x000000F400000000 - 0x000000F5FEFFFFFF (8176M used)
[    1.188037] amdgpu 0000:25:00.0: GTT: 512M 0x000000F600000000 - 0x000000F61FFFFFFF
[    1.188040] [drm] Detected VRAM RAM=8176M, BAR=256M
[    1.188041] [drm] RAM width 2048bits HBM
[    1.188119] [TTM] Zone  kernel: Available graphics memory: 8136722 kiB
[    1.188119] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    1.188120] [TTM] Initializing pool allocator
[    1.188134] [TTM] Initializing DMA pool allocator
[    1.188172] [drm] amdgpu: 8176M of VRAM memory ready
[    1.188173] [drm] amdgpu: 8176M of GTT memory ready.
[    1.188187] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.188292] [drm] PCIE GART of 512M enabled (table at 0x000000F400800000).
[    1.189394] [drm] use_doorbell being set to: [true]
[    1.189435] [drm] use_doorbell being set to: [true]
[    1.189531] [drm] Found UVD firmware Version: 1.87 Family ID: 17
[    1.189534] [drm] PSP loading UVD firmware
[    1.189996] [drm] Found VCE firmware Version: 53.45 Binary ID: 4
[    1.190005] [drm] PSP loading VCE firmware
[    1.209421] xhci_hcd 0000:03:00.0: hcc params 0x0200ef81 hci version 0x110 quirks 0x48000418
[    1.209811] hub 1-0:1.0: USB hub found
[    1.209831] hub 1-0:1.0: 10 ports detected
[    1.210314] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    1.210319] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 2
[    1.210324] xhci_hcd 0000:03:00.0: Host supports USB 3.1 Enhanced SuperSpeed
[    1.210360] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
[    1.210536] hub 2-0:1.0: USB hub found
[    1.210548] hub 2-0:1.0: 4 ports detected
[    1.210797] ahci 0000:03:00.1: version 3.0
[    1.210945] xhci_hcd 0000:26:00.3: xHCI Host Controller
[    1.210951] xhci_hcd 0000:26:00.3: new USB bus registered, assigned bus number 3
[    1.210990] ahci 0000:03:00.1: SSS flag set, parallel bus scan disabled
[    1.211030] ahci 0000:03:00.1: AHCI 0001.0301 32 slots 8 ports 6 Gbps 0x33 impl SATA mode
[    1.211033] ahci 0000:03:00.1: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part sxs deso sadm sds apst 
[    1.211076] xhci_hcd 0000:26:00.3: hcc params 0x0270f665 hci version 0x100 quirks 0x00000418
[    1.211433] hub 3-0:1.0: USB hub found
[    1.211456] hub 3-0:1.0: 4 ports detected
[    1.211800] xhci_hcd 0000:26:00.3: xHCI Host Controller
[    1.211804] xhci_hcd 0000:26:00.3: new USB bus registered, assigned bus number 4
[    1.211809] xhci_hcd 0000:26:00.3: Host supports USB 3.0  SuperSpeed
[    1.211846] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
[    1.212131] hub 4-0:1.0: USB hub found
[    1.212150] hub 4-0:1.0: 4 ports detected
[    1.212426] scsi host0: ahci
[    1.212626] scsi host1: ahci
[    1.212790] scsi host2: ahci
[    1.213032] scsi host3: ahci
[    1.213176] scsi host4: ahci
[    1.213329] scsi host5: ahci
[    1.213497] scsi host6: ahci
[    1.213676] scsi host7: ahci
[    1.213763] ata1: SATA max UDMA/133 abar m131072@0xfe880000 port 0xfe880100 irq 44
[    1.213765] ata2: SATA max UDMA/133 abar m131072@0xfe880000 port 0xfe880180 irq 44
[    1.213765] ata3: DUMMY
[    1.213766] ata4: DUMMY
[    1.213767] ata5: SATA max UDMA/133 abar m131072@0xfe880000 port 0xfe880300 irq 44
[    1.213768] ata6: SATA max UDMA/133 abar m131072@0xfe880000 port 0xfe880380 irq 44
[    1.213769] ata7: DUMMY
[    1.213769] ata8: DUMMY
[    1.213962] ahci 0000:27:00.2: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl SATA mode
[    1.213964] ahci 0000:27:00.2: flags: 64bit ncq sntf ilck led clo only pmp fbs pio 
[    1.214169] scsi host8: ahci
[    1.214243] ata9: SATA max UDMA/133 abar m4096@0xfe908000 port 0xfe908100 irq 47
[    1.525462] ata9: SATA link down (SStatus 0 SControl 300)
[    1.530025] usb 3-1: new high-speed USB device number 2 using xhci_hcd
[    1.565433] [drm] Display Core initialized with v3.1.38!
[    1.568160] tsc: Refined TSC clocksource calibration: 3400.001 MHz
[    1.568170] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x31024f56bf0, max_idle_ns: 440795227444 ns
[    1.568198] clocksource: Switched to clocksource tsc
[    1.590865] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.590866] [drm] Driver supports precise vblank timestamp query.
[    1.592021] usb 1-9: new low-speed USB device number 2 using xhci_hcd
[    1.614030] [drm] UVD and UVD ENC initialized successfully.
[    1.672024] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.672590] ata1.00: ATA-9: WDC WD20EZRZ-00Z5HB0, 80.00A80, max UDMA/133
[    1.672592] ata1.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.673034] ata1.00: configured for UDMA/133
[    1.673191] scsi 0:0:0:0: Direct-Access     ATA      WDC WD20EZRZ-00Z 0A80 PQ: 0 ANSI: 5
[    1.714438] [drm] VCE initialized successfully.
[    1.717635] [drm] fb mappable at 0xE0F00000
[    1.717636] [drm] vram apper at 0xE0000000
[    1.717636] [drm] size 33177600
[    1.717636] [drm] fb depth is 24
[    1.717637] [drm]    pitch is 15360
[    1.717793] fbcon: amdgpudrmfb (fb0) is primary device
[    1.769422] Console: switching to colour frame buffer device 480x135
[    1.795816] amdgpu 0000:25:00.0: fb0: amdgpudrmfb frame buffer device
[    1.801157] amdgpu 0000:25:00.0: ring 0(gfx) uses VM inv eng 4 on hub 0
[    1.801159] amdgpu 0000:25:00.0: ring 1(comp_1.0.0) uses VM inv eng 5 on hub 0
[    1.801160] amdgpu 0000:25:00.0: ring 2(comp_1.1.0) uses VM inv eng 6 on hub 0
[    1.801161] amdgpu 0000:25:00.0: ring 3(comp_1.2.0) uses VM inv eng 7 on hub 0
[    1.801162] amdgpu 0000:25:00.0: ring 4(comp_1.3.0) uses VM inv eng 8 on hub 0
[    1.801164] amdgpu 0000:25:00.0: ring 5(comp_1.0.1) uses VM inv eng 9 on hub 0
[    1.801165] amdgpu 0000:25:00.0: ring 6(comp_1.1.1) uses VM inv eng 10 on hub 0
[    1.801166] amdgpu 0000:25:00.0: ring 7(comp_1.2.1) uses VM inv eng 11 on hub 0
[    1.801167] amdgpu 0000:25:00.0: ring 8(comp_1.3.1) uses VM inv eng 12 on hub 0
[    1.801168] amdgpu 0000:25:00.0: ring 9(kiq_2.1.0) uses VM inv eng 13 on hub 0
[    1.801170] amdgpu 0000:25:00.0: ring 10(sdma0) uses VM inv eng 4 on hub 1
[    1.801171] amdgpu 0000:25:00.0: ring 11(sdma1) uses VM inv eng 5 on hub 1
[    1.801172] amdgpu 0000:25:00.0: ring 12(uvd) uses VM inv eng 6 on hub 1
[    1.801173] amdgpu 0000:25:00.0: ring 13(uvd_enc0) uses VM inv eng 7 on hub 1
[    1.801174] amdgpu 0000:25:00.0: ring 14(uvd_enc1) uses VM inv eng 8 on hub 1
[    1.801176] amdgpu 0000:25:00.0: ring 15(vce0) uses VM inv eng 9 on hub 1
[    1.801177] amdgpu 0000:25:00.0: ring 16(vce1) uses VM inv eng 10 on hub 1
[    1.801178] amdgpu 0000:25:00.0: ring 17(vce2) uses VM inv eng 11 on hub 1
[    1.801220] [drm] ECC is not present.
[    1.801918] [drm] Initialized amdgpu 3.25.0 20150101 for 0000:25:00.0 on minor 0
[    1.803889] random: systemd-udevd: uninitialized urandom read (16 bytes read)
[    1.808410] sd 0:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 TB/1.82 TiB)
[    1.808413] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.808429] sd 0:0:0:0: [sda] Write Protect is off
[    1.808431] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.808453] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.898793] hidraw: raw HID events driver (C) Jiri Kosina
[    1.909531] usbcore: registered new interface driver usbhid
[    1.909532] usbhid: USB HID core driver
[    1.909933] usbcore: registered new interface driver usbmouse
[    1.910622] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:01.3/0000:03:00.0/usb1/1-9/1-9:1.0/0003:046D:C05A.0001/input/input0
[    1.910710] hid-generic 0003:046D:C05A.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:03:00.0-9/input0
[    1.966038] usb 3-4: new full-speed USB device number 3 using xhci_hcd
[    1.984131] ata2: SATA link down (SStatus 0 SControl 300)
[    2.172965] hub 3-4:1.0: USB hub found
[    2.176898] hub 3-4:1.0: 3 ports detected
[    2.369574]  sda: sda1 sda2 sda3
[    2.370111] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.456053] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.456459] ata5.00: supports DRM functions and may not be fully accessible
[    2.464602] ata5.00: disabling queued TRIM support
[    2.464605] ata5.00: ATA-9: Crucial_CT256MX100SSD1, MU01, max UDMA/133
[    2.464606] ata5.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.478019] usb 3-4.1: new full-speed USB device number 4 using xhci_hcd
[    2.481997] ata5.00: supports DRM functions and may not be fully accessible
[    2.490183] ata5.00: disabling queued TRIM support
[    2.507142] ata5.00: configured for UDMA/133
[    2.507517] scsi 4:0:0:0: Direct-Access     ATA      Crucial_CT256MX1 MU01 PQ: 0 ANSI: 5
[    2.507732] ata5.00: Enabling discard_zeroes_data
[    2.507819] sd 4:0:0:0: [sdb] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    2.507820] sd 4:0:0:0: [sdb] 4096-byte physical blocks
[    2.507834] sd 4:0:0:0: [sdb] Write Protect is off
[    2.507836] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.507859] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.508024] ata5.00: Enabling discard_zeroes_data
[    2.508330]  sdb: sdb1
[    2.508461] ata5.00: Enabling discard_zeroes_data
[    2.508584] sd 4:0:0:0: [sdb] Attached SCSI disk
[    2.512941] random: fast init done
[    2.536002] raid6: sse2x1   gen()  7687 MB/s
[    2.553004] raid6: sse2x1   xor()  8083 MB/s
[    2.570002] raid6: sse2x2   gen() 16972 MB/s
[    2.587005] raid6: sse2x2   xor() 10910 MB/s
[    2.604003] raid6: sse2x4   gen() 16875 MB/s
[    2.621001] raid6: sse2x4   xor() 10052 MB/s
[    2.638002] raid6: avx2x1   gen() 19050 MB/s
[    2.655002] raid6: avx2x1   xor() 14527 MB/s
[    2.672003] raid6: avx2x2   gen() 24136 MB/s
[    2.689002] raid6: avx2x2   xor() 15613 MB/s
[    2.706001] raid6: avx2x4   gen() 25160 MB/s
[    2.723006] raid6: avx2x4   xor() 14253 MB/s
[    2.723006] raid6: using algorithm avx2x4 gen() 25160 MB/s
[    2.723007] raid6: .... xor() 14253 MB/s, rmw enabled
[    2.723007] raid6: using avx2x2 recovery algorithm
[    2.725293] xor: automatically using best checksumming function   avx       
[    2.741807] Btrfs loaded, crc32c=crc32c-intel
[    2.742163] BTRFS: device label ssd devid 1 transid 986115 /dev/sdb1
[    2.816114] ata6: SATA link down (SStatus 0 SControl 300)
[    2.904633] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:07.1/0000:26:00.3/usb3/3-4/3-4.1/3-4.1:1.0/0003:413C:2010.0002/input/input1
[    2.956570] hid-generic 0003:413C:2010.0002: input,hidraw1: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:26:00.3-4.1/input0
[    2.984737] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:07.1/0000:26:00.3/usb3/3-4/3-4.1/3-4.1:1.1/0003:413C:2010.0003/input/input2
[    3.036110] hid-generic 0003:413C:2010.0003: input,hidraw2: USB HID v1.10 Device [Dell Dell USB Keyboard] on usb-0000:26:00.3-4.1/input1
[    3.036831] usbcore: registered new interface driver usbkbd
[    3.037996] BTRFS: device label backup devid 1 transid 24289 /dev/sda2
[    3.051192] BTRFS info (device sdb1): disk space caching is enabled
[    3.051193] BTRFS info (device sdb1): has skinny extents
[    3.120094] BTRFS info (device sdb1): enabling ssd optimizations
[    3.158413] dracut: Mounted root filesystem /dev/sdb1
[    3.186012] dracut: Switching root
[    3.297219] fuse init (API version 7.26)
[    3.307324] loop: module loaded
[    3.311568] tun: Universal TUN/TAP device driver, 1.6
[    3.316619] PPP generic driver version 2.4.2
[    3.331462] device-mapper: uevent: version 1.0.3
[    3.331559] device-mapper: ioctl: 4.39.0-ioctl (2018-04-03) initialised: dm-devel@redhat.com
[    3.334977] VFIO - User Level meta-driver version: 0.3
[    3.364624] Bluetooth: Core ver 2.22
[    3.364662] NET: Registered protocol family 31
[    3.364662] Bluetooth: HCI device and connection manager initialized
[    3.364667] Bluetooth: HCI socket layer initialized
[    3.364672] Bluetooth: L2CAP socket layer initialized
[    3.364678] Bluetooth: SCO socket layer initialized
[    3.385882] NET: Registered protocol family 40
[    3.421098] nct6775: Found NCT6795D or compatible chip at 0x4e:0xa20
[    3.427434] udevd[648]: starting version 3.2.5
[    3.431499] random: udevd: uninitialized urandom read (16 bytes read)
[    3.431545] random: udevd: uninitialized urandom read (16 bytes read)
[    3.431552] random: udevd: uninitialized urandom read (16 bytes read)
[    3.446974] udevd[649]: starting eudev-3.2.5
[    3.469517] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.470960] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[    3.470975] ACPI: Power Button [PWRB]
[    3.471071] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    3.471091] ACPI: Power Button [PWRF]
[    3.500381] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.505533] r8169 0000:21:00.0 eth0: RTL8168h/8111h at 0x        (ptrval), 30:9c:23:1e:4c:31, XID 14100800 IRQ 48
[    3.505536] r8169 0000:21:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    3.512489] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    3.513202] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    3.513205] piix4_smbus 0000:00:14.0: Using register 0x02 for SMBus port selection
[    3.514473] parport_pc 00:04: reported by Plug and Play ACPI
[    3.514602] parport0: PC-style at 0x378, irq 5 [PCSPP]
[    3.518070] ccp 0000:26:00.2: ccp enabled
[    3.518098] ccp 0000:26:00.2: psp initialization failed
[    3.518099] ccp 0000:26:00.2: enabled
[    3.521936] cryptd: max_cpu_qlen set to 1000
[    3.523147] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver
[    3.523328] sp5100-tco sp5100-tco: Using 0xfed80b00 for watchdog MMIO address
[    3.523339] sp5100-tco sp5100-tco: Watchdog hardware is disabled
[    3.524487] r8169 0000:21:00.0 enp33s0: renamed from eth0
[    3.524789] media: Linux media interface: v0.10
[    3.535785] ppdev: user-space parallel port driver
[    3.541550] AVX2 version of gcm_enc/dec engaged.
[    3.541551] AES CTR mode by8 optimization enabled
[    3.543077] Linux video capture interface: v2.00
[    3.553760] snd_hda_intel 0000:25:00.1: Handle vga_switcheroo audio client
[    3.566646] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.1/0000:23:00.0/0000:24:00.0/0000:25:00.1/sound/card1/input6
[    3.566958] input: HD-Audio Generic HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.1/0000:23:00.0/0000:24:00.0/0000:25:00.1/sound/card1/input7
[    3.567348] input: HD-Audio Generic HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.1/0000:23:00.0/0000:24:00.0/0000:25:00.1/sound/card1/input8
[    3.567738] input: HD-Audio Generic HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:03.1/0000:23:00.0/0000:24:00.0/0000:25:00.1/sound/card1/input9
[    3.568077] input: HD-Audio Generic HDMI/DP,pcm=10 as /devices/pci0000:00/0000:00:03.1/0000:23:00.0/0000:24:00.0/0000:25:00.1/sound/card1/input10
[    3.568291] input: HD-Audio Generic HDMI/DP,pcm=11 as /devices/pci0000:00/0000:00:03.1/0000:23:00.0/0000:24:00.0/0000:25:00.1/sound/card1/input11
[    3.586977] random: crng init done
[    3.589005] snd_hda_codec_realtek hdaudioC2D0: autoconfig for ALC892: line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
[    3.589022] snd_hda_codec_realtek hdaudioC2D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.589023] snd_hda_codec_realtek hdaudioC2D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    3.589026] snd_hda_codec_realtek hdaudioC2D0:    mono: mono_out=0x0
[    3.589027] snd_hda_codec_realtek hdaudioC2D0:    inputs:
[    3.589030] snd_hda_codec_realtek hdaudioC2D0:      Front Mic=0x19
[    3.589031] snd_hda_codec_realtek hdaudioC2D0:      Rear Mic=0x18
[    3.589032] snd_hda_codec_realtek hdaudioC2D0:      Line=0x1a
[    3.606796] input: HD-Audio Generic Front Mic as /devices/pci0000:00/0000:00:08.1/0000:27:00.3/sound/card2/input12
[    3.606985] input: HD-Audio Generic Rear Mic as /devices/pci0000:00/0000:00:08.1/0000:27:00.3/sound/card2/input13
[    3.607178] input: HD-Audio Generic Line as /devices/pci0000:00/0000:00:08.1/0000:27:00.3/sound/card2/input14
[    3.607331] input: HD-Audio Generic Line Out Front as /devices/pci0000:00/0000:00:08.1/0000:27:00.3/sound/card2/input15
[    3.607508] input: HD-Audio Generic Line Out Surround as /devices/pci0000:00/0000:00:08.1/0000:27:00.3/sound/card2/input16
[    3.607673] input: HD-Audio Generic Line Out CLFE as /devices/pci0000:00/0000:00:08.1/0000:27:00.3/sound/card2/input17
[    3.607806] input: HD-Audio Generic Line Out Side as /devices/pci0000:00/0000:00:08.1/0000:27:00.3/sound/card2/input18
[    3.608037] input: HD-Audio Generic Front Headphone as /devices/pci0000:00/0000:00:08.1/0000:27:00.3/sound/card2/input19
[    3.623167] kvm: Nested Virtualization enabled
[    3.623182] kvm: Nested Paging enabled
[    3.623182] SVM: Virtual VMLOAD VMSAVE supported
[    3.623182] SVM: Virtual GIF supported
[    3.627097] MCE: In-kernel MCE decoding enabled.
[    3.631193] EDAC amd64: Node 0: DRAM ECC disabled.
[    3.631195] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
                Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
                (Note that use of the override may cause unknown side effects.)
[    3.649958] EDAC amd64: Node 0: DRAM ECC disabled.
[    3.649960] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
                Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
                (Note that use of the override may cause unknown side effects.)
[    3.676814] EDAC amd64: Node 0: DRAM ECC disabled.
[    3.676815] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
                Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
                (Note that use of the override may cause unknown side effects.)
[    3.704819] EDAC amd64: Node 0: DRAM ECC disabled.
[    3.704820] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
                Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
                (Note that use of the override may cause unknown side effects.)
[    3.729752] EDAC amd64: Node 0: DRAM ECC disabled.
[    3.729753] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
                Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
                (Note that use of the override may cause unknown side effects.)
[    3.758598] EDAC amd64: Node 0: DRAM ECC disabled.
[    3.758599] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
                Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
                (Note that use of the override may cause unknown side effects.)
[    3.765256] usb 3-1: Warning! Unlikely big volume range (=3072), cval->res is probably wrong.
[    3.765258] usb 3-1: [5] FU [Mic Capture Volume] ch = 1, val = 4608/7680/1
[    3.765466] usbcore: registered new interface driver snd-usb-audio
[    3.765488] uvcvideo: Found UVC 1.00 device <unnamed> (046d:08c5)
[    3.864998] uvcvideo 3-1:1.0: Entity type for entity Extension 4 was not initialized!
[    3.865007] uvcvideo 3-1:1.0: Entity type for entity Extension 8 was not initialized!
[    3.865008] uvcvideo 3-1:1.0: Entity type for entity Extension 10 was not initialized!
[    3.865010] uvcvideo 3-1:1.0: Entity type for entity Extension 3 was not initialized!
[    3.865011] uvcvideo 3-1:1.0: Entity type for entity Processing 2 was not initialized!
[    3.865012] uvcvideo 3-1:1.0: Entity type for entity Camera 1 was not initialized!
[    3.865089] input: UVC Camera (046d:08c5) as /devices/pci0000:00/0000:00:07.1/0000:26:00.3/usb3/3-1/3-1:1.0/input/input20
[    3.865174] usbcore: registered new interface driver uvcvideo
[    3.865175] USB Video Class driver (1.1.1)
[    4.113877] BTRFS info (device sdb1): use lzo compression, level 0
[    4.113879] BTRFS info (device sdb1): disk space caching is enabled
[    4.317360] BTRFS info (device sdb1): disk space caching is enabled
[    4.338887] BTRFS info (device sda2): use lzo compression, level 0
[    4.338888] BTRFS info (device sda2): disk space caching is enabled
[    4.338889] BTRFS info (device sda2): has skinny extents
[    8.767957] FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[    8.859385] udevd[898]: starting version 3.2.5
[    8.884671] 8021q: 802.1Q VLAN Support v1.8
[    8.912523] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    8.914161] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    8.914836] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[    8.914838] cfg80211: failed to load regulatory.db
[    9.024845] r8169 0000:21:00.0 enp33s0: link down
[    9.024847] r8169 0000:21:00.0 enp33s0: link down
[    9.024938] IPv6: ADDRCONF(NETDEV_UP): enp33s0: link is not ready
[    9.109614] udevd[898]: starting eudev-3.2.5
[   12.196430] r8169 0000:21:00.0 enp33s0: link up
[   12.196436] IPv6: ADDRCONF(NETDEV_CHANGE): enp33s0: link becomes ready
[11299.445768] usb 3-4: USB disconnect, device number 3
[11299.445770] usb 3-4.1: USB disconnect, device number 4
[11329.030660] usb 1-8: new full-speed USB device number 3 using xhci_hcd
[11329.348400] hub 1-8:1.0: USB hub found
[11329.352367] hub 1-8:1.0: 3 ports detected
[11329.650598] usb 1-8.1: new full-speed USB device number 4 using xhci_hcd
[11329.877854] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:01.3/0000:03:00.0/usb1/1-8/1-8.1/1-8.1:1.0/0003:413C:2010.0004/input/input21
[11329.929831] hid-generic 0003:413C:2010.0004: input,hidraw1: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:03:00.0-8.1/input0
[11329.957825] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:01.3/0000:03:00.0/usb1/1-8/1-8.1/1-8.1:1.1/0003:413C:2010.0005/input/input22
[11330.009756] hid-generic 0003:413C:2010.0005: input,hidraw2: USB HID v1.10 Device [Dell Dell USB Keyboard] on usb-0000:03:00.0-8.1/input1
[11568.252698] usb 1-8: USB disconnect, device number 3
[11568.252701] usb 1-8.1: USB disconnect, device number 4
[11599.278400] usb 1-8: new full-speed USB device number 5 using xhci_hcd
[11599.595772] hub 1-8:1.0: USB hub found
[11599.599734] hub 1-8:1.0: 3 ports detected
[11599.899757] usb 1-8.1: new full-speed USB device number 6 using xhci_hcd
[11600.127575] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:01.3/0000:03:00.0/usb1/1-8/1-8.1/1-8.1:1.0/0003:413C:2010.0006/input/input23
[11600.179637] hid-generic 0003:413C:2010.0006: input,hidraw1: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:03:00.0-8.1/input0
[11600.208457] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:01.3/0000:03:00.0/usb1/1-8/1-8.1/1-8.1:1.1/0003:413C:2010.0007/input/input24
[11600.260545] hid-generic 0003:413C:2010.0007: input,hidraw2: USB HID v1.10 Device [Dell Dell USB Keyboard] on usb-0000:03:00.0-8.1/input1
[12208.920342] usb 3-1: reset high-speed USB device number 2 using xhci_hcd
[18473.718449] usb 3-1: reset high-speed USB device number 2 using xhci_hcd

--9jxsPFA5p3P2qPhR--
