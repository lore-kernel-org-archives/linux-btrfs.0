Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:54182 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXcX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 19:32:23 -0400
Received: by mail-qk0-f179.google.com with SMTP id w63so9913967qkd.10
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Oct 2017 16:32:23 -0700 (PDT)
Received: from [192.168.69.101] (cpe-68-174-152-193.nyc.res.rr.com. [68.174.152.193])
        by smtp.gmail.com with ESMTPSA id p24sm2938993qtj.22.2017.10.03.16.32.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Oct 2017 16:32:21 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Asif Youssuff <yoasif@gmail.com>
Subject: Can't mount array with super_total_bytes mismatch with fs_devices
 total_rw_bytes
Message-ID: <f561678d-17f0-f06e-b781-3445a59e0349@gmail.com>
Date: Tue, 3 Oct 2017 19:32:21 -0400
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------F31163CEB9808FAC3827A878"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------F31163CEB9808FAC3827A878
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

My power went out at my home, and I'm now having trouble mounting my array.

I'm mounting with the 'recovery' option in fstab.

When mounting, dmesg output shows:

[210017.281912] BTRFS info (device sdb): disk space caching is enabled
[210017.281915] BTRFS info (device sdb): has skinny extents
[210017.402084] BTRFS error (device sdb): super_total_bytes 92017859088384
mismatch with fs_devices total_rw_bytes 92017859094528
[210017.402126] BTRFS error (device sdb): failed to read chunk tree: -22
[210017.461473] BTRFS error (device sdb): open_ctree failed

I've tried a few steps --

btrfs-chunk-recover, super-recover and I have run a btrfs check --repair 
on two of the disks in the array (this takes a very long time, so I'm 
hoping I don't have to run this on all of the disks).

I had run into this problem once before in the past, and I'm not sure 
how I recovered from it; I may have simply rolled back the booted kernel 
to escape the extra checks around this mismatch.

I'm at a loss for ideas and am running a btrfs-image so I can also 
report an issue -- I'm not sure whether 'btrfs-image -c9 -t4 /dev/sdo 
btrfs.image' is  the right command to run if it is a multi-device array.

Any ideas would be helpful, and I am happy to provide further information.

root@ubuntu-server:~#   uname -a
Linux ubuntu-server 4.14.0-041400rc2-generic #201709242031 SMP Mon Sep 
25 00:33:13 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

root@ubuntu-server:~#   btrfs --version
btrfs-progs v4.13.1

root@ubuntu-server:~#   btrfs fi show
Label: none  uuid: 48ed8a66-731d-499b-829e-dd07dd7260cc
Total devices 13 FS bytes used 40.73TiB
devid    4 size 5.46TiB used 5.42TiB path /dev/sdo
devid    5 size 5.46TiB used 5.42TiB path /dev/sdn
devid    7 size 5.46TiB used 5.42TiB path /dev/sdc
devid    9 size 5.46TiB used 5.42TiB path /dev/sdk
devid   10 size 5.46TiB used 5.42TiB path /dev/sdj
devid   11 size 7.28TiB used 7.24TiB path /dev/sdd
devid   12 size 5.46TiB used 5.42TiB path /dev/sdm
devid   14 size 7.28TiB used 7.24TiB path /dev/sdh
devid   15 size 7.28TiB used 7.24TiB path /dev/sdb
devid   17 size 7.28TiB used 5.77TiB path /dev/sdl
devid   18 size 7.28TiB used 7.24TiB path /dev/sdf
devid   20 size 7.28TiB used 7.24TiB path /dev/sdi
devid   21 size 7.28TiB used 7.24TiB path /dev/sdg

Thanks,
Asif

--------------F31163CEB9808FAC3827A878
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Linux version 4.14.0-041400rc2-generic (kernel@tangerine) (gcc version 7.2.0 (Ubuntu 7.2.0-6ubuntu1)) #201709242031 SMP Mon Sep 25 00:33:13 UTC 2017
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.14.0-041400rc2-generic root=/dev/mapper/ubuntu--server--vg-root ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
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
[    0.000000] random: fast init done
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Supermicro X10SLM-F/X10SLM-F, BIOS 3.0 04/24/2015
[    0.000000] tsc: Fast TSC calibration using PIT
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
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.000000] total RAM covered: 32768M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 7  	lose cover RAM: 0G
[    0.000000] e820: update [mem 0xe0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdf800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd720-0x000fd72f] mapped at [fffffffffd200720]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff953cc0093000] 93000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x13924000, 0x13924fff] PGTABLE
[    0.000000] BRK [0x13925000, 0x13925fff] PGTABLE
[    0.000000] BRK [0x13926000, 0x13926fff] PGTABLE
[    0.000000] BRK [0x13927000, 0x13927fff] PGTABLE
[    0.000000] BRK [0x13928000, 0x13928fff] PGTABLE
[    0.000000] BRK [0x13929000, 0x13929fff] PGTABLE
[    0.000000] BRK [0x1392a000, 0x1392afff] PGTABLE
[    0.000000] BRK [0x1392b000, 0x1392bfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x33130000-0x3588ffff]
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
[    0.000000] NODE_DATA(0) allocated [mem 0x81ffd3000-0x81fffdfff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000081fffffff]
[    0.000000]   Device   empty
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
[    0.000000] [Firmware Bug]: TSC_DEADLINE disabled due to Errata; please update microcode to version: 0x22 (or later)
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
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] percpu: Embedded 39 pages/cpu @ffff9544dfc00000 s119768 r8192 d31784 u262144
[    0.000000] pcpu-alloc: s119768 r8192 d31784 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 8247386
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.14.0-041400rc2-generic root=/dev/mapper/ubuntu--server--vg-root ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 32859436K/33513280K available (9469K kernel code, 2477K rwdata, 4052K rodata, 2324K init, 2388K bss, 653844K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] ftrace: allocating 38127 entries in 149 pages
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS: 524544, nr_irqs: 488, preallocated irqs: 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3399.709 MHz processor
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6799.41 BogoMIPS (lpj=13598836)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004000] ACPI: Core revision 20170728
[    0.015779] ACPI: 8 ACPI AML tables successfully acquired and loaded
[    0.015802] Security Framework initialized
[    0.015803] Yama: becoming mindful.
[    0.015814] AppArmor: AppArmor initialized
[    0.019773] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.021721] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.021794] Mount-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.021855] Mountpoint-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.022009] CPU: Physical Processor ID: 0
[    0.022011] CPU: Processor Core ID: 0
[    0.022015] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.022017] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.022021] mce: CPU supports 9 MCE banks
[    0.022028] CPU0: Thermal monitoring enabled (TM1)
[    0.022039] process: using mwait in idle threads
[    0.022042] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.022044] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.022124] Freeing SMP alternatives memory: 36K
[    0.023367] smpboot: Max logical packages: 2
[    0.023373] DMAR: Host address width 39
[    0.023375] DMAR: DRHD base: 0x000000fed90000 flags: 0x1
[    0.023381] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap d2008c20660462 ecap f010da
[    0.023383] DMAR: RMRR base: 0x000000df695000 end: 0x000000df6a3fff
[    0.023386] DMAR-IR: IOAPIC id 8 under DRHD base  0xfed90000 IOMMU 0
[    0.023387] DMAR-IR: HPET id 0 under DRHD base 0xfed90000
[    0.023388] DMAR-IR: x2apic is disabled because BIOS sets x2apic opt out bit.
[    0.023389] DMAR-IR: Use 'intremap=no_x2apic_optout' to override the BIOS setting.
[    0.023540] DMAR-IR: Enabled IRQ remapping in xapic mode
[    0.023542] x2apic: IRQ remapping doesn't support X2APIC mode
[    0.023968] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.064000] smpboot: CPU0: Intel(R) Xeon(R) CPU E3-1231 v3 @ 3.40GHz (family: 0x6, model: 0x3c, stepping: 0x3)
[    0.064000] Performance Events: PEBS fmt2+, Haswell events, 16-deep LBR, full-width counters, Intel PMU driver.
[    0.064000] ... version:                3
[    0.064000] ... bit width:              48
[    0.064000] ... generic registers:      4
[    0.064000] ... value mask:             0000ffffffffffff
[    0.064000] ... max period:             00007fffffffffff
[    0.064000] ... fixed-purpose events:   3
[    0.064000] ... event mask:             000000070000000f
[    0.064000] Hierarchical SRCU implementation.
[    0.064000] smp: Bringing up secondary CPUs ...
[    0.064000] x86: Booting SMP configuration:
[    0.064000] .... node  #0, CPUs:      #1
[    0.140063] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.140134]  #2 #3 #4 #5 #6 #7
[    0.620018] smp: Brought up 1 node, 8 CPUs
[    0.620018] smpboot: Total of 8 processors activated (54397.80 BogoMIPS)
[    0.624651] devtmpfs: initialized
[    0.624651] x86/mm: Memory block size: 128MB
[    0.629111] evm: security.selinux
[    0.629112] evm: security.SMACK64
[    0.629113] evm: security.SMACK64EXEC
[    0.629114] evm: security.SMACK64TRANSMUTE
[    0.629115] evm: security.SMACK64MMAP
[    0.629116] evm: security.ima
[    0.629117] evm: security.capability
[    0.629128] PM: Registering ACPI NVS region [mem 0xcd4fc000-0xcd502fff] (28672 bytes)
[    0.629128] PM: Registering ACPI NVS region [mem 0xdd925000-0xdda5bfff] (1273856 bytes)
[    0.629128] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.629128] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.629128] pinctrl core: initialized pinctrl subsystem
[    0.629128] RTC time: 12:26:07, date: 10/01/17
[    0.629128] NET: Registered protocol family 16
[    0.629137] cpuidle: using governor ladder
[    0.629137] cpuidle: using governor menu
[    0.629137] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.629137] ACPI: bus type PCI registered
[    0.629137] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.629137] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.629137] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.629137] PCI: Using configuration type 1 for base access
[    0.629137] core: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
[    0.629137] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.629137] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.629137] ACPI: Added _OSI(Module Device)
[    0.629137] ACPI: Added _OSI(Processor Device)
[    0.629137] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.629137] ACPI: Added _OSI(Processor Aggregator Device)
[    0.629137] ACPI: Executed 6 blocks of module-level executable AML code
[    0.640565] ACPI: Dynamic OEM Table Load:
[    0.640662] ACPI: Dynamic OEM Table Load:
[    0.640662] ACPI: SSDT 0xFFFF9544BB657C00 0003D3 (v02 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.640662] ACPI: Dynamic OEM Table Load:
[    0.640662] ACPI: SSDT 0xFFFF9544BB956000 0005AA (v02 PmRef  ApIst    00003000 INTL 20051117)
[    0.640662] ACPI: Dynamic OEM Table Load:
[    0.640662] ACPI: SSDT 0xFFFF9544BB67E600 000119 (v02 PmRef  ApCst    00003000 INTL 20051117)
[    0.641273] ACPI: Interpreter enabled
[    0.641300] ACPI: (supports S0 S4 S5)
[    0.641301] ACPI: Using IOAPIC for interrupt routing
[    0.641338] HEST: Table parsing has been initialized.
[    0.641342] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.641512] ACPI: GPE 0x1E active on init
[    0.641522] ACPI: Enabled 8 GPEs in block 00 to 3F
[    0.641525] ACPI: Power Resource [PG00] (on)
[    0.641525] ACPI: Power Resource [PG01] (on)
[    0.641525] ACPI: Power Resource [PG02] (on)
[    0.650266] ACPI: Power Resource [FN00] (off)
[    0.650313] ACPI: Power Resource [FN01] (off)
[    0.650357] ACPI: Power Resource [FN02] (off)
[    0.650401] ACPI: Power Resource [FN03] (off)
[    0.650446] ACPI: Power Resource [FN04] (off)
[    0.650989] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.650994] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.651157] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.651247] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.651249] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.651534] PCI host bridge to bus 0000:00
[    0.651537] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.651539] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.651540] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.651542] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
[    0.651544] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
[    0.651545] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
[    0.651547] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
[    0.651549] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
[    0.651550] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff window]
[    0.651552] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff window]
[    0.651554] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfeafffff window]
[    0.651556] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.651562] pci 0000:00:00.0: [8086:0c08] type 00 class 0x060000
[    0.651623] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.651649] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.651711] pci 0000:00:01.1: [8086:0c05] type 01 class 0x060400
[    0.651736] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
[    0.651822] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.651840] pci 0000:00:14.0: reg 0x10: [mem 0xf7320000-0xf732ffff 64bit]
[    0.651891] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.651940] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.651958] pci 0000:00:16.0: reg 0x10: [mem 0xf7338000-0xf733800f 64bit]
[    0.652012] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.652077] pci 0000:00:16.1: [8086:8c3b] type 00 class 0x078000
[    0.652095] pci 0000:00:16.1: reg 0x10: [mem 0xf7337000-0xf733700f 64bit]
[    0.652147] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
[    0.652198] pci 0000:00:19.0: [8086:153a] type 00 class 0x020000
[    0.652214] pci 0000:00:19.0: reg 0x10: [mem 0xf7300000-0xf731ffff]
[    0.652220] pci 0000:00:19.0: reg 0x14: [mem 0xf7335000-0xf7335fff]
[    0.652227] pci 0000:00:19.0: reg 0x18: [io  0xf020-0xf03f]
[    0.652275] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.652327] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    0.652346] pci 0000:00:1a.0: reg 0x10: [mem 0xf7334000-0xf73343ff]
[    0.652418] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.652471] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.652529] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.652601] pci 0000:00:1c.1: [8086:8c12] type 01 class 0x060400
[    0.652660] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.652735] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    0.652754] pci 0000:00:1d.0: reg 0x10: [mem 0xf7333000-0xf73333ff]
[    0.652824] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.652878] pci 0000:00:1f.0: [8086:8c54] type 00 class 0x060100
[    0.653017] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
[    0.653030] pci 0000:00:1f.2: reg 0x10: [io  0xf070-0xf077]
[    0.653036] pci 0000:00:1f.2: reg 0x14: [io  0xf060-0xf063]
[    0.653042] pci 0000:00:1f.2: reg 0x18: [io  0xf050-0xf057]
[    0.653048] pci 0000:00:1f.2: reg 0x1c: [io  0xf040-0xf043]
[    0.653054] pci 0000:00:1f.2: reg 0x20: [io  0xf000-0xf01f]
[    0.653060] pci 0000:00:1f.2: reg 0x24: [mem 0xf7332000-0xf73327ff]
[    0.653089] pci 0000:00:1f.2: PME# supported from D3hot
[    0.653137] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.653152] pci 0000:00:1f.3: reg 0x10: [mem 0xf7331000-0xf73310ff 64bit]
[    0.653169] pci 0000:00:1f.3: reg 0x20: [io  0x0580-0x059f]
[    0.653235] pci 0000:00:1f.6: [8086:8c24] type 00 class 0x118000
[    0.653253] pci 0000:00:1f.6: reg 0x10: [mem 0xf7330000-0xf7330fff 64bit]
[    0.653529] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.653557] pci 0000:02:00.0: [1000:0072] type 00 class 0x010700
[    0.653567] pci 0000:02:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    0.653573] pci 0000:02:00.0: reg 0x14: [mem 0xf72c0000-0xf72c3fff 64bit]
[    0.653580] pci 0000:02:00.0: reg 0x1c: [mem 0xf7280000-0xf72bffff 64bit]
[    0.653588] pci 0000:02:00.0: reg 0x30: [mem 0xf7200000-0xf727ffff pref]
[    0.653619] pci 0000:02:00.0: supports D1 D2
[    0.653630] pci 0000:02:00.0: reg 0x174: [mem 0x00000000-0x00003fff 64bit]
[    0.653631] pci 0000:02:00.0: VF(n) BAR0 space: [mem 0x00000000-0x0003ffff 64bit] (contains BAR0 for 16 VFs)
[    0.653638] pci 0000:02:00.0: reg 0x17c: [mem 0x00000000-0x0003ffff 64bit]
[    0.653639] pci 0000:02:00.0: VF(n) BAR2 space: [mem 0x00000000-0x003fffff 64bit] (contains BAR2 for 16 VFs)
[    0.664016] pci 0000:00:01.1: PCI bridge to [bus 02]
[    0.664016] pci 0000:00:01.1:   bridge window [io  0xe000-0xefff]
[    0.664016] pci 0000:00:01.1:   bridge window [mem 0xf7200000-0xf72fffff]
[    0.664093] pci 0000:03:00.0: [1a03:1150] type 01 class 0x060400
[    0.664154] pci 0000:03:00.0: enabling Extended Tags
[    0.664219] pci 0000:03:00.0: supports D1 D2
[    0.664220] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.676017] pci 0000:00:1c.0: PCI bridge to [bus 03-04]
[    0.676021] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.676024] pci 0000:00:1c.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.676089] pci 0000:04:00.0: [1a03:2000] type 00 class 0x030000
[    0.676119] pci 0000:04:00.0: reg 0x10: [mem 0xf6000000-0xf6ffffff]
[    0.676132] pci 0000:04:00.0: reg 0x14: [mem 0xf7000000-0xf701ffff]
[    0.676144] pci 0000:04:00.0: reg 0x18: [io  0xd000-0xd07f]
[    0.676241] pci 0000:04:00.0: supports D1 D2
[    0.676242] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.676322] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.676329] pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
[    0.676333] pci 0000:03:00.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.676435] pci 0000:05:00.0: [8086:1533] type 00 class 0x020000
[    0.676478] pci 0000:05:00.0: reg 0x10: [mem 0xf7100000-0xf717ffff]
[    0.676509] pci 0000:05:00.0: reg 0x18: [io  0xc000-0xc01f]
[    0.676525] pci 0000:05:00.0: reg 0x1c: [mem 0xf7180000-0xf7183fff]
[    0.676682] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.688035] pci 0000:00:1c.1: PCI bridge to [bus 05]
[    0.688039] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.688042] pci 0000:00:1c.1:   bridge window [mem 0xf7100000-0xf71fffff]
[    0.688705] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.688756] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.688803] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.688841] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.688884] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.688922] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.688965] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.689009] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.689266] pci 0000:04:00.0: vgaarb: setting as boot VGA device
[    0.689266] pci 0000:04:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.689266] pci 0000:04:00.0: vgaarb: bridge control possible
[    0.689266] vgaarb: loaded
[    0.689266] SCSI subsystem initialized
[    0.689266] libata version 3.00 loaded.
[    0.689266] ACPI: bus type USB registered
[    0.689266] usbcore: registered new interface driver usbfs
[    0.689266] usbcore: registered new interface driver hub
[    0.689266] usbcore: registered new device driver usb
[    0.689266] EDAC MC: Ver: 3.0.0
[    0.689266] PCI: Using ACPI for IRQ routing
[    0.689344] PCI: pci_cache_line_size set to 64 bytes
[    0.689408] e820: reserve RAM buffer [mem 0x00099c00-0x0009ffff]
[    0.689409] e820: reserve RAM buffer [mem 0xcd4fc000-0xcfffffff]
[    0.689410] e820: reserve RAM buffer [mem 0xdd7f2000-0xdfffffff]
[    0.689410] e820: reserve RAM buffer [mem 0xdd925000-0xdfffffff]
[    0.689411] e820: reserve RAM buffer [mem 0xdf800000-0xdfffffff]
[    0.689468] NetLabel: Initializing
[    0.689470] NetLabel:  domain hash size = 128
[    0.689471] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.689481] NetLabel:  unlabeled traffic allowed by default
[    0.689491] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.689491] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.694022] clocksource: Switched to clocksource hpet
[    0.699622] VFS: Disk quotas dquot_6.6.0
[    0.699637] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.699707] AppArmor: AppArmor Filesystem Enabled
[    0.699722] pnp: PnP ACPI init
[    0.699816] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.699821] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.699892] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.699895] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.699909] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.699933] system 00:03: [io  0x1854-0x1857] has been reserved
[    0.699936] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.699991] system 00:04: [io  0x0a00-0x0a1f] has been reserved
[    0.699994] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.700154] pnp 00:05: [dma 0 disabled]
[    0.700337] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.700472] pnp 00:06: [dma 0 disabled]
[    0.700495] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.700527] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.700530] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.700795] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.700797] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.700799] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.700800] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.700802] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.700804] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.700806] system 00:08: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.700807] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.700809] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.700811] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.700813] system 00:08: [mem 0xf7fe0000-0xf7feffff] has been reserved
[    0.700814] system 00:08: [mem 0xf7ff0000-0xf7ffffff] has been reserved
[    0.700817] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.700971] pnp: PnP ACPI: found 9 devices
[    0.706969] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.706975] pci_bus 0000:00: max bus depth: 2 pci_try_num: 3
[    0.707001] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.707008] pci 0000:02:00.0: BAR 9: no space for [mem size 0x00400000 64bit]
[    0.707010] pci 0000:02:00.0: BAR 9: failed to assign [mem size 0x00400000 64bit]
[    0.707012] pci 0000:02:00.0: BAR 7: no space for [mem size 0x00040000 64bit]
[    0.707014] pci 0000:02:00.0: BAR 7: failed to assign [mem size 0x00040000 64bit]
[    0.707016] pci 0000:00:01.1: PCI bridge to [bus 02]
[    0.707018] pci 0000:00:01.1:   bridge window [io  0xe000-0xefff]
[    0.707020] pci 0000:00:01.1:   bridge window [mem 0xf7200000-0xf72fffff]
[    0.707024] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.707028] pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
[    0.707034] pci 0000:03:00.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.707045] pci 0000:00:1c.0: PCI bridge to [bus 03-04]
[    0.707048] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.707053] pci 0000:00:1c.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.707060] pci 0000:00:1c.1: PCI bridge to [bus 05]
[    0.707062] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.707067] pci 0000:00:1c.1:   bridge window [mem 0xf7100000-0xf71fffff]
[    0.707074] pci_bus 0000:00: No. 2 try to assign unassigned res
[    0.707075] release child resource [mem 0xf7200000-0xf727ffff pref]
[    0.707075] release child resource [mem 0xf7280000-0xf72bffff 64bit]
[    0.707075] release child resource [mem 0xf72c0000-0xf72c3fff 64bit]
[    0.707076] pci 0000:00:01.1: resource 14 [mem 0xf7200000-0xf72fffff] released
[    0.707077] pci 0000:00:01.1: PCI bridge to [bus 02]
[    0.707109] pci 0000:00:01.1: BAR 14: assigned [mem 0xe0000000-0xe05fffff]
[    0.707111] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.707116] pci 0000:02:00.0: BAR 6: assigned [mem 0xe0000000-0xe007ffff pref]
[    0.707118] pci 0000:02:00.0: BAR 3: assigned [mem 0xe0080000-0xe00bffff 64bit]
[    0.707124] pci 0000:02:00.0: BAR 9: assigned [mem 0xe00c0000-0xe04bffff 64bit]
[    0.707128] pci 0000:02:00.0: BAR 1: assigned [mem 0xe04c0000-0xe04c3fff 64bit]
[    0.707133] pci 0000:02:00.0: BAR 7: assigned [mem 0xe04c4000-0xe0503fff 64bit]
[    0.707136] pci 0000:00:01.1: PCI bridge to [bus 02]
[    0.707138] pci 0000:00:01.1:   bridge window [io  0xe000-0xefff]
[    0.707140] pci 0000:00:01.1:   bridge window [mem 0xe0000000-0xe05fffff]
[    0.707144] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.707152] pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
[    0.707310] pci 0000:03:00.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.707320] pci 0000:00:1c.0: PCI bridge to [bus 03-04]
[    0.707323] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.707327] pci 0000:00:1c.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.707334] pci 0000:00:1c.1: PCI bridge to [bus 05]
[    0.707337] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.707341] pci 0000:00:1c.1:   bridge window [mem 0xf7100000-0xf71fffff]
[    0.707348] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.707349] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.707350] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.707351] pci_bus 0000:00: resource 7 [mem 0x000cc000-0x000cffff window]
[    0.707351] pci_bus 0000:00: resource 8 [mem 0x000d0000-0x000d3fff window]
[    0.707352] pci_bus 0000:00: resource 9 [mem 0x000d4000-0x000d7fff window]
[    0.707353] pci_bus 0000:00: resource 10 [mem 0x000d8000-0x000dbfff window]
[    0.707353] pci_bus 0000:00: resource 11 [mem 0x000dc000-0x000dffff window]
[    0.707354] pci_bus 0000:00: resource 12 [mem 0x000e0000-0x000e3fff window]
[    0.707354] pci_bus 0000:00: resource 13 [mem 0x000e4000-0x000e7fff window]
[    0.707355] pci_bus 0000:00: resource 14 [mem 0xe0000000-0xfeafffff window]
[    0.707356] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.707357] pci_bus 0000:02: resource 1 [mem 0xe0000000-0xe05fffff]
[    0.707358] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.707358] pci_bus 0000:03: resource 1 [mem 0xf6000000-0xf70fffff]
[    0.707359] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.707360] pci_bus 0000:04: resource 1 [mem 0xf6000000-0xf70fffff]
[    0.707360] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.707361] pci_bus 0000:05: resource 1 [mem 0xf7100000-0xf71fffff]
[    0.707433] NET: Registered protocol family 2
[    0.707594] TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.707816] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.707913] TCP: Hash tables configured (established 262144 bind 65536)
[    0.707947] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.708023] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    0.708105] NET: Registered protocol family 1
[    0.756101] pci 0000:04:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.756118] PCI: CLS 64 bytes, default 64
[    0.756144] Unpacking initramfs...
[    1.196060] Freeing initrd memory: 40320K
[    1.196109] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.196112] software IO TLB [mem 0xd97f2000-0xdd7f2000] (64MB) mapped at [ffff953d997f2000-ffff953d9d7f1fff]
[    1.196373] Scanning for low memory corruption every 60 seconds
[    1.196623] audit: initializing netlink subsys (disabled)
[    1.196660] audit: type=2000 audit(1506860767.196:1): state=initialized audit_enabled=0 res=1
[    1.196909] Initialise system trusted keyrings
[    1.196917] Key type blacklist registered
[    1.196949] workingset: timestamp_bits=36 max_order=23 bucket_order=0
[    1.197634] zbud: loaded
[    1.197881] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.197982] fuse init (API version 7.26)
[    1.198988] Key type asymmetric registered
[    1.198990] Asymmetric key parser 'x509' registered
[    1.199008] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 246)
[    1.199037] io scheduler noop registered
[    1.199038] io scheduler deadline registered
[    1.199064] io scheduler cfq registered (default)
[    1.199633] vesafb: mode is 640x480x32, linelength=2560, pages=0
[    1.199635] vesafb: scrolling: redraw
[    1.199637] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.199646] vesafb: framebuffer at 0xf6000000, mapped to 0xffffaf86c3a00000, using 1216k, total 1216k
[    1.256673] Console: switching to colour frame buffer device 80x30
[    1.315360] fb0: VESA VGA frame buffer device
[    1.316566] intel_idle: MWAIT substates: 0x42120
[    1.316566] intel_idle: v0.4.1 model 0x3C
[    1.316794] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.316867] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    1.319153] ACPI: Sleep Button [SLPB]
[    1.320174] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    1.396565] ACPI: Power Button [PWRB]
[    1.434051] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.510270] ACPI: Power Button [PWRF]
[    1.549391] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    1.627196] thermal LNXTHERM:00: registered as thermal_zone0
[    1.666635] ACPI: Thermal Zone [TZ00] (28 C)
[    1.705668] thermal LNXTHERM:01: registered as thermal_zone1
[    1.745040] ACPI: Thermal Zone [TZ01] (30 C)
[    1.784111] ERST: Error Record Serialization Table (ERST) support is initialized.
[    1.864000] pstore: using zlib compression
[    1.903867] pstore: Registered erst as persistent store backend
[    1.943793] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
[    2.024593] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    2.087764] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    2.193164] 00:06: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    2.208064] tsc: Refined TSC clocksource calibration: 3399.985 MHz
[    2.208100] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x310240add1b, max_idle_ns: 440795323293 ns
[    2.411741] Linux agpgart interface v0.103
[    2.456433] loop: module loaded
[    2.498322] libphy: Fixed MDIO Bus: probed
[    2.540250] tun: Universal TUN/TAP device driver, 1.6
[    2.581933] PPP generic driver version 2.4.2
[    2.622669] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.664572] ehci-pci: EHCI PCI platform driver
[    2.705609] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    2.745999] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.826301] ehci-pci 0000:00:1a.0: debug port 2
[    2.869827] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    2.869836] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7334000
[    2.924018] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.962623] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.001806] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.078372] usb usb1: Product: EHCI Host Controller
[    3.116457] usb usb1: Manufacturer: Linux 4.14.0-041400rc2-generic ehci_hcd
[    3.155515] usb usb1: SerialNumber: 0000:00:1a.0
[    3.194138] hub 1-0:1.0: USB hub found
[    3.231873] hub 1-0:1.0: 2 ports detected
[    3.268644] clocksource: Switched to clocksource tsc
[    3.268828] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    3.268831] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.268863] ehci-pci 0000:00:1d.0: debug port 2
[    3.272798] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    3.272808] ehci-pci 0000:00:1d.0: irq 22, io mem 0xf7333000
[    3.288011] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.288027] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.288028] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.288028] usb usb2: Product: EHCI Host Controller
[    3.288029] usb usb2: Manufacturer: Linux 4.14.0-041400rc2-generic ehci_hcd
[    3.288029] usb usb2: SerialNumber: 0000:00:1d.0
[    3.288101] hub 2-0:1.0: USB hub found
[    3.288103] hub 2-0:1.0: 2 ports detected
[    3.288183] ehci-platform: EHCI generic platform driver
[    3.288188] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.288190] ohci-pci: OHCI PCI platform driver
[    3.288195] ohci-platform: OHCI generic platform driver
[    3.288199] uhci_hcd: USB Universal Host Controller Interface driver
[    3.288291] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.288293] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    3.289590] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
[    3.289603] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    3.289748] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    3.289749] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.289749] usb usb3: Product: xHCI Host Controller
[    3.289750] usb usb3: Manufacturer: Linux 4.14.0-041400rc2-generic xhci-hcd
[    3.289750] usb usb3: SerialNumber: 0000:00:14.0
[    3.289818] hub 3-0:1.0: USB hub found
[    3.289867] hub 3-0:1.0: 12 ports detected
[    3.292423] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.292425] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    3.292454] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    3.292455] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.292456] usb usb4: Product: xHCI Host Controller
[    3.292456] usb usb4: Manufacturer: Linux 4.14.0-041400rc2-generic xhci-hcd
[    3.292457] usb usb4: SerialNumber: 0000:00:14.0
[    3.292518] hub 4-0:1.0: USB hub found
[    3.292545] hub 4-0:1.0: 6 ports detected
[    3.293992] i8042: PNP: No PS/2 controller found.
[    3.294055] mousedev: PS/2 mouse device common for all mice
[    3.294191] rtc_cmos 00:02: RTC can wake from S4
[    3.294499] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    3.294575] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    3.294578] i2c /dev entries driver
[    3.294605] device-mapper: uevent: version 1.0.3
[    3.294636] device-mapper: ioctl: 4.36.0-ioctl (2017-06-09) initialised: dm-devel@redhat.com
[    3.294639] intel_pstate: Intel P-state driver initializing
[    3.616035] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    3.628026] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    3.784382] usb 1-1: New USB device found, idVendor=8087, idProduct=8008
[    3.784383] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.784646] hub 1-1:1.0: USB hub found
[    3.784756] hub 1-1:1.0: 6 ports detected
[    3.796380] usb 2-1: New USB device found, idVendor=8087, idProduct=8000
[    3.796381] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.796646] hub 2-1:1.0: USB hub found
[    3.796755] hub 2-1:1.0: 6 ports detected
[    4.440095] usb 4-1: new SuperSpeed USB device number 2 using xhci_hcd
[    4.460746] usb 4-1: New USB device found, idVendor=174c, idProduct=55aa
[    4.460747] usb 4-1: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[    4.460748] usb 4-1: Product: ASMT1051
[    4.460749] usb 4-1: Manufacturer: asmedia
[    4.460749] usb 4-1: SerialNumber: 12345678C6CA
[    4.596033] usb 3-3: new high-speed USB device number 3 using xhci_hcd
[    4.756298] usb 3-3: New USB device found, idVendor=0000, idProduct=0001
[    4.756299] usb 3-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.756833] hub 3-3:1.0: USB hub found
[    4.756934] hub 3-3:1.0: 4 ports detected
[    5.072034] usb 3-3.1: new low-speed USB device number 4 using xhci_hcd
[    5.204291] usb 3-3.1: New USB device found, idVendor=0557, idProduct=2419
[    5.204292] usb 3-3.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.008962] ledtrig-cpu: registered to indicate activity on CPUs
[    6.043264] NET: Registered protocol family 10
[    6.079568] Segment Routing with IPv6
[    6.111768] NET: Registered protocol family 17
[    6.143669] Key type dns_resolver registered
[    6.175377] RAS: Correctable Errors collector initialized.
[    6.208126] microcode: sig=0x306c3, pf=0x2, revision=0x1d
[    6.240914] microcode: Microcode Update Driver: v2.2.
[    6.240919] sched_clock: Marking stable (6240911678, 0)->(6385781561, -144869883)
[    6.339285] registered taskstats version 1
[    6.372538] Loading compiled-in X.509 certificates
[    6.407571] Loaded X.509 cert 'Build time autogenerated kernel key: 9b7a80b33f7d910de9992a47915dfdc7fb37fc24'
[    6.476499] zswap: loaded using pool lzo/zbud
[    6.512302] Key type big_key registered
[    6.546667] Key type trusted registered
[    6.581394] Key type encrypted registered
[    6.614458] AppArmor: AppArmor sha1 policy hashing enabled
[    6.648616] ima: No TPM chip found, activating TPM-bypass! (rc=-19)
[    6.683756] evm: HMAC attrs: 0x1
[    6.718395]   Magic number: 5:744:429
[    6.752559] rtc_cmos 00:02: setting system clock to 2017-10-01 12:26:13 UTC (1506860773)
[    6.822196] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.858639] EDD information not available.
[    6.895885] Freeing unused kernel memory: 2324K
[    6.931515] Write protecting the kernel read-only data: 14336k
[    6.967841] Freeing unused kernel memory: 760K
[    7.003286] Freeing unused kernel memory: 44K
[    7.041598] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    7.177275] pps_core: LinuxPPS API ver. 1 registered
[    7.212326] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    7.283845] usbcore: registered new interface driver usb-storage
[    7.320525] hidraw: raw HID events driver (C) Jiri Kosina
[    7.356896] PTP clock support registered
[    7.392302] ahci 0000:00:1f.2: version 3.0
[    7.392497] mpt3sas version 15.100.00.00 loaded
[    7.392775] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    7.392777] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    7.393498] usbcore: registered new interface driver usbhid
[    7.393499] usbhid: USB HID core driver
[    7.393607] scsi host0: uas
[    7.393661] usbcore: registered new interface driver uas
[    7.393952] scsi 0:0:0:0: Direct-Access     ASMT     2115             0    PQ: 0 ANSI: 6
[    7.394400] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.394786] sd 0:0:0:0: [sda] 937703088 512-byte logical blocks: (480 GB/447 GiB)
[    7.394868] sd 0:0:0:0: [sda] Write Protect is off
[    7.394869] sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
[    7.395037] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.397222]  sda: sda1 sda2 < sda5 >
[    7.398175] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.452609] scsi host1: ahci
[    7.452764] scsi host2: ahci
[    7.452877] scsi host3: ahci
[    7.452980] scsi host4: ahci
[    7.453049] scsi host5: ahci
[    7.453117] scsi host6: ahci
[    7.453145] ata1: SATA max UDMA/133 abar m2048@0xf7332000 port 0xf7332100 irq 26
[    7.453150] ata2: SATA max UDMA/133 abar m2048@0xf7332000 port 0xf7332180 irq 26
[    7.453154] ata3: SATA max UDMA/133 abar m2048@0xf7332000 port 0xf7332200 irq 26
[    7.453158] ata4: SATA max UDMA/133 abar m2048@0xf7332000 port 0xf7332280 irq 26
[    7.453163] ata5: SATA max UDMA/133 abar m2048@0xf7332000 port 0xf7332300 irq 26
[    7.453167] ata6: SATA max UDMA/133 abar m2048@0xf7332000 port 0xf7332380 irq 26
[    7.766321] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.766406] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.766475] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.766579] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.766878] ata4.00: ATA-9: WDC WD60EZRX-11MVLB1, 80.00A80, max UDMA/133
[    7.766879] ata4.00: 11720979633 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.767413] ata4.00: configured for UDMA/133
[    7.768088] ata3.00: ATA-9: ST8000AS0002-1NA17Z, RT17, max UDMA/133
[    7.768089] ata3.00: 15628053168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.769482] ata3.00: configured for UDMA/133
[    7.769789] ata1.00: ATA-9: WDC WD80EZZX-11CSGA0, 83.H0A03, max UDMA/133
[    7.769790] ata1.00: 15628053168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.769946] ata5.00: ATA-9: WDC WD80EZZX-11CSGA0, 83.H0A03, max UDMA/133
[    7.769947] ata5.00: 15628053168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.770370] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.770451] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.771004] ata2.00: ATA-9: WDC WD60EZRX-11MVLB1, 80.00A80, max UDMA/133
[    7.771005] ata2.00: 11720979633 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.771656] ata2.00: configured for UDMA/133
[    7.771942] ata6.00: ATA-9: ST8000AS0002-1NA17Z, RT17, max UDMA/133
[    7.771942] ata6.00: 15628053168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.773325] ata6.00: configured for UDMA/133
[    7.775402] ata1.00: configured for UDMA/133
[    7.775508] ata5.00: configured for UDMA/133
[    7.775561] scsi 1:0:0:0: Direct-Access     ATA      WDC WD80EZZX-11C 0A03 PQ: 0 ANSI: 5
[    7.775710] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    7.775727] sd 1:0:0:0: [sdb] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
[    7.775728] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    7.775737] sd 1:0:0:0: [sdb] Write Protect is off
[    7.775738] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    7.775753] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.775802] scsi 2:0:0:0: Direct-Access     ATA      WDC WD60EZRX-11M 0A80 PQ: 0 ANSI: 5
[    7.775903] sd 2:0:0:0: [sdc] 11720979633 512-byte logical blocks: (6.00 TB/5.46 TiB)
[    7.775904] sd 2:0:0:0: [sdc] 4096-byte physical blocks
[    7.775911] sd 2:0:0:0: [sdc] Write Protect is off
[    7.775912] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    7.775917] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    7.775929] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.776013] scsi 3:0:0:0: Direct-Access     ATA      ST8000AS0002-1NA RT17 PQ: 0 ANSI: 5
[    7.776127] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    7.776129] sd 3:0:0:0: [sdd] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
[    7.776130] sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    7.776137] sd 3:0:0:0: [sdd] Write Protect is off
[    7.776138] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    7.776155] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.776219] scsi 4:0:0:0: Direct-Access     ATA      WDC WD60EZRX-11M 0A80 PQ: 0 ANSI: 5
[    7.776329] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    7.776349] sd 4:0:0:0: [sde] 11720979633 512-byte logical blocks: (6.00 TB/5.46 TiB)
[    7.776350] sd 4:0:0:0: [sde] 4096-byte physical blocks
[    7.776358] sd 4:0:0:0: [sde] Write Protect is off
[    7.776359] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    7.776372] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.776415] scsi 5:0:0:0: Direct-Access     ATA      WDC WD80EZZX-11C 0A03 PQ: 0 ANSI: 5
[    7.776520] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    7.776551] sd 5:0:0:0: [sdf] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
[    7.776552] sd 5:0:0:0: [sdf] 4096-byte physical blocks
[    7.776557] sd 5:0:0:0: [sdf] Write Protect is off
[    7.776558] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    7.776565] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.776603] scsi 6:0:0:0: Direct-Access     ATA      ST8000AS0002-1NA RT17 PQ: 0 ANSI: 5
[    7.776707] sd 6:0:0:0: Attached scsi generic sg6 type 0
[    7.776751] sd 6:0:0:0: [sdg] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
[    7.776752] sd 6:0:0:0: [sdg] 4096-byte physical blocks
[    7.776759] sd 6:0:0:0: [sdg] Write Protect is off
[    7.776760] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    7.776773] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.787649] sd 6:0:0:0: [sdg] Attached SCSI disk
[    7.788451] sd 3:0:0:0: [sdd] Attached SCSI disk
[    7.793680] sd 1:0:0:0: [sdb] Attached SCSI disk
[    7.795716] sd 5:0:0:0: [sdf] Attached SCSI disk
[    7.799244] sd 2:0:0:0: [sdc] Attached SCSI disk
[    7.827111]  sde: sde1
[    7.827362] sd 4:0:0:0: [sde] Attached SCSI disk
[   12.087352] mpt3sas 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[   12.155077] mpt2sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (32902920 kB)
[   12.244398] dca service started, version 1.12.1
[   12.244401] input: HID 0557:2419 as /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3.1/3-3.1:1.0/0003:0557:2419.0001/input/input3
[   12.246349] random: crng init done
[   12.308101] hid-generic 0003:0557:2419.0001: input,hidraw0: USB HID v1.00 Keyboard [HID 0557:2419] on usb-0000:00:14.0-3.1/input0
[   12.308185] input: HID 0557:2419 as /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3.1/3-3.1:1.1/0003:0557:2419.0002/input/input4
[   12.308257] hid-generic 0003:0557:2419.0002: input,hidraw1: USB HID v1.00 Mouse [HID 0557:2419] on usb-0000:00:14.0-3.1/input1
[   12.314014] mpt2sas_cm0: MSI-X vectors supported: 1, no of cores: 8, max_msix_vectors: -1
[   12.314064] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 27
[   12.314065] mpt2sas_cm0: iomem(0x00000000e04c0000), mapped(0xffffaf86c3c78000), size(16384)
[   12.314065] mpt2sas_cm0: ioport(0x000000000000e000), size(256)
[   12.406281] mpt2sas_cm0: Allocated physical memory: size(7579 kB)
[   12.406281] mpt2sas_cm0: Current Controller Queue Depth(3364),Max Controller Queue Depth(3432)
[   12.406282] mpt2sas_cm0: Scatter Gather Elements per IO(128)
[   12.451898] mpt2sas_cm0: LSISAS2008: FWVersion(15.00.00.00), ChipRevision(0x03), BiosVersion(00.00.00.00)
[   12.451899] mpt2sas_cm0: Protocol=(
[   12.451899] Initiator
[   12.451899] ,Target
[   12.451900] ), 
[   12.451900] Capabilities=(
[   12.451900] TLR
[   12.451901] ,EEDP
[   12.451901] ,Snapshot Buffer
[   12.451901] ,Diag Trace Buffer
[   12.451901] ,Task Set Full
[   12.451901] ,NCQ
[   12.451902] )
[   12.451946] scsi host7: Fusion MPT SAS Host
[   12.452080] mpt2sas_cm0: sending port enable !!
[   13.227193] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[   13.227193] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[   13.227499] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   13.314345] e1000e 0000:00:19.0 0000:00:19.0 (uninitialized): registered PHC clock
[   13.395720] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 0c:c4:7a:79:68:63
[   13.395721] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[   13.395897] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: 0100FF-0FF
[   13.529914] e1000e 0000:00:19.0 eno2: renamed from eth0
[   13.955631] [drm] Using P2A bridge for configuration
[   13.985147] [drm] AST 2400 detected
[   13.999244] mpt2sas_cm0: host_add: handle(0x0001), sas_addr(0x5000000080000000), phys(8)
[   14.072090] [drm] Analog VGA only
[   14.072165] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4.0-k
[   14.072166] igb: Copyright (c) 2007-2014 Intel Corporation.
[   14.163258] [drm] dram MCLK=408 Mhz type=1 bus_width=16 size=01000000
[   14.196414] [TTM] Zone  kernel: Available graphics memory: 16451460 kiB
[   14.230533] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   14.264865] [TTM] Initializing pool allocator
[   14.299675] [TTM] Initializing DMA pool allocator
[   14.304655] pps pps0: new PPS source ptp1
[   14.304656] igb 0000:05:00.0: added PHC on eth0
[   14.304657] igb 0000:05:00.0: Intel(R) Gigabit Ethernet Network Connection
[   14.304658] igb 0000:05:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 0c:c4:7a:79:68:62
[   14.304811] igb 0000:05:00.0: eth0: PBA No: 011000-000
[   14.304812] igb 0000:05:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[   14.406555] igb 0000:05:00.0 eno1: renamed from eth0
[   14.499248] scsi 7:0:0:0: Direct-Access     ATA      ST8000AS0002-1NA RT17 PQ: 0 ANSI: 6
[   14.499251] scsi 7:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221100000000), phy(0), device_name(0x0000000000000000)
[   14.499252] scsi 7:0:0:0: SATA: enclosure_logical_id(0x5000000080000000), slot(3)
[   14.499356] scsi 7:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   14.749234] scsi 7:0:1:0: Direct-Access     ATA      ST8000AS0002-1NA RT17 PQ: 0 ANSI: 6
[   14.749236] scsi 7:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221101000000), phy(1), device_name(0x0000000000000000)
[   14.749237] scsi 7:0:1:0: SATA: enclosure_logical_id(0x5000000080000000), slot(2)
[   14.749336] scsi 7:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   14.998190] scsi 7:0:2:0: Direct-Access     ATA      WDC WD60EZRX-00M 0A80 PQ: 0 ANSI: 6
[   14.998192] scsi 7:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221102000000), phy(2), device_name(0x0000000000000000)
[   14.998193] scsi 7:0:2:0: SATA: enclosure_logical_id(0x5000000080000000), slot(1)
[   14.998292] scsi 7:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   15.647058] scsi 7:0:3:0: Direct-Access     ATA      WDC WD60EFRX-68M 0A82 PQ: 0 ANSI: 6
[   15.660839] checking generic (f6000000 130000) vs hw (f6000000 1000000)
[   15.660840] fb: switching to astdrmfb from VESA VGA
[   15.801120] scsi 7:0:3:0: SATA: handle(0x000c), sas_addr(0x4433221104000000), phy(4), device_name(0x0000000000000000)
[   15.801121] scsi 7:0:3:0: SATA: enclosure_logical_id(0x5000000080000000), slot(7)
[   15.801165] Console: switching to colour dummy device 80x25
[   15.801278] scsi 7:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   15.801345] fbcon: astdrmfb (fb0) is primary device
[   15.999306] scsi 7:0:4:0: Direct-Access     ATA      ST8000AS0002-1NA RT17 PQ: 0 ANSI: 6
[   15.999308] scsi 7:0:4:0: SATA: handle(0x000d), sas_addr(0x4433221103000000), phy(3), device_name(0x0000000000000000)
[   15.999309] scsi 7:0:4:0: SATA: enclosure_logical_id(0x5000000080000000), slot(0)
[   15.999421] scsi 7:0:4:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   16.248878] scsi 7:0:5:0: Direct-Access     ATA      WDC WD60EFRX-68M 0A82 PQ: 0 ANSI: 6
[   16.248880] scsi 7:0:5:0: SATA: handle(0x000e), sas_addr(0x4433221105000000), phy(5), device_name(0x0000000000000000)
[   16.248881] scsi 7:0:5:0: SATA: enclosure_logical_id(0x5000000080000000), slot(6)
[   16.248994] scsi 7:0:5:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   16.386443] Console: switching to colour frame buffer device 128x48
[   16.498250] scsi 7:0:6:0: Direct-Access     ATA      WDC WD60EZRX-11M 0A80 PQ: 0 ANSI: 6
[   16.498252] scsi 7:0:6:0: SATA: handle(0x000f), sas_addr(0x4433221106000000), phy(6), device_name(0x0000000000000000)
[   16.498253] scsi 7:0:6:0: SATA: enclosure_logical_id(0x5000000080000000), slot(5)
[   16.498334] scsi 7:0:6:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   16.748264] scsi 7:0:7:0: Direct-Access     ATA      WDC WD60EZRX-11M 0A80 PQ: 0 ANSI: 6
[   16.748267] scsi 7:0:7:0: SATA: handle(0x0010), sas_addr(0x4433221107000000), phy(7), device_name(0x0000000000000000)
[   16.748268] scsi 7:0:7:0: SATA: enclosure_logical_id(0x5000000080000000), slot(4)
[   16.748348] scsi 7:0:7:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   16.974841] ast 0000:04:00.0: fb0: astdrmfb frame buffer device
[   17.016085] [drm] Initialized ast 0.1.0 20120228 for 0000:04:00.0 on minor 0
[   19.132079] mpt2sas_cm0: port enable: SUCCESS
[   19.132410] sd 7:0:0:0: Attached scsi generic sg7 type 0
[   19.132626] sd 7:0:1:0: Attached scsi generic sg8 type 0
[   19.132851] sd 7:0:2:0: Attached scsi generic sg9 type 0
[   19.133609] sd 7:0:3:0: Attached scsi generic sg10 type 0
[   19.134305] sd 7:0:4:0: Attached scsi generic sg11 type 0
[   19.134868] sd 7:0:2:0: [sdj] 11720979633 512-byte logical blocks: (6.00 TB/5.46 TiB)
[   19.134869] sd 7:0:2:0: [sdj] 4096-byte physical blocks
[   19.135056] sd 7:0:3:0: [sdk] 11721045168 512-byte logical blocks: (6.00 TB/5.46 TiB)
[   19.135057] sd 7:0:3:0: [sdk] 4096-byte physical blocks
[   19.137205] sd 7:0:5:0: Attached scsi generic sg12 type 0
[   19.137266] sd 7:0:0:0: [sdh] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
[   19.137277] sd 7:0:0:0: [sdh] 4096-byte physical blocks
[   19.137329] sd 7:0:1:0: [sdi] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
[   19.137330] sd 7:0:1:0: [sdi] 4096-byte physical blocks
[   19.137973] sd 7:0:2:0: [sdj] Write Protect is off
[   19.137974] sd 7:0:2:0: [sdj] Mode Sense: 7f 00 10 08
[   19.138027] sd 7:0:3:0: [sdk] Write Protect is off
[   19.138028] sd 7:0:3:0: [sdk] Mode Sense: 7f 00 10 08
[   19.138632] sd 7:0:3:0: [sdk] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   19.138767] sd 7:0:2:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   19.139112] sd 7:0:4:0: [sdl] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
[   19.139113] sd 7:0:4:0: [sdl] 4096-byte physical blocks
[   19.139488] sd 7:0:5:0: [sdm] 11721045168 512-byte logical blocks: (6.00 TB/5.46 TiB)
[   19.139489] sd 7:0:5:0: [sdm] 4096-byte physical blocks
[   19.142626] sd 7:0:5:0: [sdm] Write Protect is off
[   19.142626] sd 7:0:5:0: [sdm] Mode Sense: 7f 00 10 08
[   19.143529] sd 7:0:5:0: [sdm] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   19.145227] sd 7:0:6:0: Attached scsi generic sg13 type 0
[   19.145815] sd 7:0:7:0: Attached scsi generic sg14 type 0
[   19.147132] sd 7:0:6:0: [sdn] 11720979633 512-byte logical blocks: (6.00 TB/5.46 TiB)
[   19.147632] sd 7:0:6:0: [sdn] 4096-byte physical blocks
[   19.147797] sd 7:0:7:0: [sdo] 11720979633 512-byte logical blocks: (6.00 TB/5.46 TiB)
[   19.147797] sd 7:0:7:0: [sdo] 4096-byte physical blocks
[   19.150957] sd 7:0:7:0: [sdo] Write Protect is off
[   19.151448] sd 7:0:7:0: [sdo] Mode Sense: 7f 00 10 08
[   19.152226] sd 7:0:6:0: [sdn] Write Protect is off
[   19.152239] sd 7:0:7:0: [sdo] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   19.153221] sd 7:0:6:0: [sdn] Mode Sense: 7f 00 10 08
[   19.154012] sd 7:0:6:0: [sdn] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   19.271520] sd 7:0:1:0: [sdi] Write Protect is off
[   19.271521] sd 7:0:1:0: [sdi] Mode Sense: 7f 00 10 08
[   19.273533] sd 7:0:1:0: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   19.277078] sd 7:0:0:0: [sdh] Write Protect is off
[   19.277079] sd 7:0:0:0: [sdh] Mode Sense: 7f 00 10 08
[   19.279095] sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   19.281196] sd 7:0:4:0: [sdl] Write Protect is off
[   19.281197] sd 7:0:4:0: [sdl] Mode Sense: 7f 00 10 08
[   19.283233] sd 7:0:4:0: [sdl] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   19.576351] sd 7:0:1:0: [sdi] Attached SCSI disk
[   19.581912] sd 7:0:0:0: [sdh] Attached SCSI disk
[   19.596065] sd 7:0:4:0: [sdl] Attached SCSI disk
[   19.794715] sd 7:0:7:0: [sdo] Attached SCSI disk
[   19.797463] sd 7:0:6:0: [sdn] Attached SCSI disk
[   19.797835] sd 7:0:5:0: [sdm] Attached SCSI disk
[   19.800470] sd 7:0:2:0: [sdj] Attached SCSI disk
[   19.854653] sd 7:0:3:0: [sdk] Attached SCSI disk
[   22.412004] raid6: sse2x1   gen() 13357 MB/s
[   22.480003] raid6: sse2x1   xor()  9340 MB/s
[   22.548005] raid6: sse2x2   gen() 15557 MB/s
[   22.616020] raid6: sse2x2   xor()  8119 MB/s
[   22.684020] raid6: sse2x4   gen() 14142 MB/s
[   22.752016] raid6: sse2x4   xor()  9604 MB/s
[   22.820017] raid6: avx2x1   gen() 19794 MB/s
[   22.888004] raid6: avx2x1   xor() 13086 MB/s
[   22.956004] raid6: avx2x2   gen() 23332 MB/s
[   23.024018] raid6: avx2x2   xor() 14224 MB/s
[   23.092016] raid6: avx2x4   gen() 27062 MB/s
[   23.160003] raid6: avx2x4   xor() 18507 MB/s
[   23.160003] raid6: using algorithm avx2x4 gen() 27062 MB/s
[   23.160003] raid6: .... xor() 18507 MB/s, rmw enabled
[   23.160004] raid6: using avx2x2 recovery algorithm
[   23.162111] xor: automatically using best checksumming function   avx       
[   23.171633] Btrfs loaded, crc32c=crc32c-intel
[   24.588495] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 17 transid 2948705 /dev/sdl
[   24.588981] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 14 transid 2948705 /dev/sdh
[   24.589456] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 20 transid 2948705 /dev/sdi
[   24.590193] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 5 transid 2948705 /dev/sdn
[   24.590924] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 4 transid 2948705 /dev/sdo
[   24.591361] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 12 transid 2948705 /dev/sdm
[   24.592091] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 10 transid 2948705 /dev/sdj
[   24.592533] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 9 transid 2948705 /dev/sdk
[   24.592974] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 21 transid 2948705 /dev/sdg
[   24.593508] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 18 transid 2948705 /dev/sdf
[   24.593936] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 11 transid 2948705 /dev/sdd
[   24.594632] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 7 transid 2948705 /dev/sdc
[   24.595138] BTRFS: device fsid 48ed8a66-731d-499b-829e-dd07dd7260cc devid 15 transid 2948705 /dev/sdb
[   26.066289] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[   27.467496] systemd[1]: systemd 229 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN)
[   27.468434] systemd[1]: Detected architecture x86-64.
[   28.683151] systemd[1]: Set hostname to <ubuntu-server>.
[   28.865066] systemd[1]: Listening on Journal Socket.
[   30.096787] systemd[1]: Reached target Remote File Systems (Pre).
[   30.893518] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[   31.708572] systemd[1]: Listening on fsck to fsckd communication Socket.
[   32.533402] systemd[1]: Listening on LVM2 poll daemon socket.
[   33.365626] systemd[1]: Reached target User and Group Name Lookups.
[   34.208469] systemd[1]: Listening on Syslog Socket.
[   35.052551] systemd[1]: Listening on udev Kernel Socket.
[   35.899151] systemd[1]: Created slice System Slice.
[   36.746690] systemd[1]: Starting Uncomplicated firewall...
[   37.594881] systemd[1]: Mounting POSIX Message Queue File System...
[   38.452368] systemd[1]: Created slice system-systemd\x2dcryptsetup.slice.
[   39.321506] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[   40.198260] systemd[1]: Mounting Debug File System...
[   41.082201] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[   41.987043] systemd[1]: Listening on Journal Audit Socket.
[   42.883284] systemd[1]: Listening on Journal Socket (/dev/log).
[   43.776312] systemd[1]: Mounting Huge Pages File System...
[   44.665341] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[   45.549712] systemd[1]: Starting Journal Service...
[   46.437998] systemd[1]: Starting Set console keymap...
[   47.318921] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[   48.204830] systemd[1]: Created slice User and Session Slice.
[   49.094917] systemd[1]: Reached target Slices.
[   49.978292] systemd[1]: Started Trigger resolvconf update for networkd DNS.
[   50.868788] systemd[1]: Starting Load Kernel Modules...
[   51.757464] systemd[1]: Listening on LVM2 metadata daemon socket.
[   52.641283] systemd[1]: Starting Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling...
[   53.537854] systemd[1]: Reached target Remote File Systems.
[   54.429344] systemd[1]: Started Read required files in advance.
[   55.324866] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[   56.218432] systemd[1]: Listening on udev Control Socket.
[   57.112886] systemd[1]: Mounted POSIX Message Queue File System.
[   58.008613] systemd[1]: Mounted Huge Pages File System.
[   58.901144] systemd[1]: Mounted Debug File System.
[   59.789508] systemd[1]: Started Journal Service.
[   65.177495] EXT4-fs (dm-0): re-mounted. Opts: errors=remount-ro
[   67.991598] systemd-journald[404]: Received request to flush runtime journal from PID 1
[   68.056182] EXT4-fs (dm-0): Delayed block allocation failed for inode 130378 at logical offset 1061 with max blocks 2 with error 121
[   68.056183] EXT4-fs (dm-0): This should not happen!! Data will be lost

[   68.157040] ipmi message handler version 39.2
[   68.167707] ipmi device interface
[   68.169356] ipmi_si: probing via SMBIOS
[   68.169357] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   68.169357] ipmi_si: Adding SMBIOS-specified kcs state machine
[   68.169372] ipmi_si IPI0001:00: ipmi_si: probing via ACPI
[   68.169388] ipmi_si IPI0001:00: [io  0x0ca2] regsize 1 spacing 1 irq 0
[   68.169389] ipmi_si: ACPI-specified kcs state machine: duplicate
[   68.169415] IPMI System Interface driver.
[   68.169426] ipmi_si: probing via SPMI
[   68.169427] ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
[   68.169427] ipmi_si: SPMI-specified kcs state machine: duplicate
[   68.169428] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[   68.196271] mei_me 0000:00:16.0: Device doesn't have valid ME Interface
[   68.196542] EDAC MC0: Giving out device to module ie31200_edac controller IE31200: DEV 0000:00:00.0 (POLLED)
[   68.196621] ACPI Warning: SystemIO range 0x0000000000001828-0x000000000000182F conflicts with OpRegion 0x0000000000001800-0x000000000000187F (\PMIO) (20170728/utaddress-247)
[   68.196626] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   68.196631] ACPI Warning: SystemIO range 0x0000000000001C40-0x0000000000001C4F conflicts with OpRegion 0x0000000000001C00-0x0000000000001FFF (\GPR) (20170728/utaddress-247)
[   68.196633] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   68.196633] ACPI Warning: SystemIO range 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x0000000000001C00-0x0000000000001C3F (\GPRL) (20170728/utaddress-247)
[   68.196634] ACPI Warning: SystemIO range 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x0000000000001C00-0x0000000000001FFF (\GPR) (20170728/utaddress-247)
[   68.196636] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   68.196636] ACPI Warning: SystemIO range 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x0000000000001C00-0x0000000000001C3F (\GPRL) (20170728/utaddress-247)
[   68.196637] ACPI Warning: SystemIO range 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x0000000000001C00-0x0000000000001FFF (\GPR) (20170728/utaddress-247)
[   68.196638] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   68.196639] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   68.207363] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[   68.208088] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   68.440028] ipmi_si dmi-ipmi-si.0: The BMC does not support clearing the recv irq bit, compensating, but the BMC needs to be fixed.
[   68.508879] ipmi_si dmi-ipmi-si.0: Found new BMC (man_id: 0x002a7c, prod_id: 0x0811, dev_id: 0x20)
[   68.508926] ipmi_si dmi-ipmi-si.0: IPMI kcs interface initialized
[   68.528642] IPMI SSIF Interface driver
[   68.853027] RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters, 655360 ms ovfl timer
[   68.853028] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[   68.853028] RAPL PMU: hw unit of domain package 2^-14 Joules
[   68.853028] RAPL PMU: hw unit of domain dram 2^-14 Joules
[   68.853029] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[   68.967223] AVX2 version of gcm_enc/dec engaged.
[   68.967224] AES CTR mode by8 optimization enabled
[   68.983192] intel-spi intel-spi: w25q128 (16384 Kbytes)
[   68.985938] Creating 1 MTD partitions on "intel-spi":
[   68.985940] 0x000000000000-0x000001000000 : "BIOS"
[   69.044605] intel_rapl: Found RAPL domain package
[   69.044606] intel_rapl: Found RAPL domain core
[   69.044607] intel_rapl: Found RAPL domain dram
[   71.752039] EXT4-fs (sde1): mounted filesystem with ordered data mode. Opts: (null)
[   73.123126] Adding 785916k swap on /dev/mapper/cryptswap1.  Priority:-2 extents:1 across:785916k FS
[   73.852778] EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem
[   73.858765] EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
[   78.269662] audit: type=1400 audit(1506860845.011:2): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/lxc-start" pid=1179 comm="apparmor_parser"
[   78.330399] audit: type=1400 audit(1506860845.071:3): apparmor="STATUS" operation="profile_load" profile="unconfined" name="docker-default" pid=1176 comm="apparmor_parser"
[   78.336467] audit: type=1400 audit(1506860845.079:4): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/sbin/libvirtd" pid=1175 comm="apparmor_parser"
[   78.378232] audit: type=1400 audit(1506860845.119:5): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/libvirt/virt-aa-helper" pid=1177 comm="apparmor_parser"
[   78.383385] audit: type=1400 audit(1506860845.123:6): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/lxd/lxd-bridge-proxy" pid=1180 comm="apparmor_parser"
[   78.398275] audit: type=1400 audit(1506860845.139:7): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/sbin/ntpd" pid=1184 comm="apparmor_parser"
[   78.414571] audit: type=1400 audit(1506860845.155:8): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/sbin/tcpdump" pid=1188 comm="apparmor_parser"
[   78.451944] audit: type=1400 audit(1506860845.191:9): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/sbin/dhclient" pid=1181 comm="apparmor_parser"
[   78.452132] audit: type=1400 audit(1506860845.195:10): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1181 comm="apparmor_parser"
[   78.452317] audit: type=1400 audit(1506860845.195:11): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=1181 comm="apparmor_parser"
[   82.360272] IPv6: ADDRCONF(NETDEV_UP): eno2: link is not ready
[   85.107707] new mount options do not match the existing superblock, will be ignored
[   85.200343] e1000e: eno2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   85.200481] IPv6: ADDRCONF(NETDEV_CHANGE): eno2: link becomes ready
[   85.491601] zram: Added device: zram0
[   85.491656] zram: Added device: zram1
[   85.491704] zram: Added device: zram2
[   85.491755] zram: Added device: zram3
[   85.491810] zram: Added device: zram4
[   85.491863] zram: Added device: zram5
[   85.491911] zram: Added device: zram6
[   85.491963] zram: Added device: zram7
[   85.500929] zram0: detected capacity change from 0 to 2105786368
[   85.503426] Adding 2056428k swap on /dev/zram0.  Priority:5 extents:1 across:2056428k SSFS
[   85.504169] zram1: detected capacity change from 0 to 2105786368
[   85.506493] Adding 2056428k swap on /dev/zram1.  Priority:5 extents:1 across:2056428k SSFS
[   85.507192] zram2: detected capacity change from 0 to 2105786368
[   85.509515] Adding 2056428k swap on /dev/zram2.  Priority:5 extents:1 across:2056428k SSFS
[   85.510182] zram3: detected capacity change from 0 to 2105786368
[   85.512191] Adding 2056428k swap on /dev/zram3.  Priority:5 extents:1 across:2056428k SSFS
[   85.512844] zram4: detected capacity change from 0 to 2105786368
[   85.514907] Adding 2056428k swap on /dev/zram4.  Priority:5 extents:1 across:2056428k SSFS
[   85.515573] zram5: detected capacity change from 0 to 2105786368
[   85.517596] Adding 2056428k swap on /dev/zram5.  Priority:5 extents:1 across:2056428k SSFS
[   85.518264] zram6: detected capacity change from 0 to 2105786368
[   85.520483] Adding 2056428k swap on /dev/zram6.  Priority:5 extents:1 across:2056428k SSFS
[   85.521119] zram7: detected capacity change from 0 to 2105786368
[   85.523463] Adding 2056428k swap on /dev/zram7.  Priority:5 extents:1 across:2056428k SSFS
[   85.531066] kauditd_printk_skb: 35 callbacks suppressed
[   85.531066] audit: type=1400 audit(1506860852.271:47): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1337 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[   85.531068] audit: type=1400 audit(1506860852.271:48): apparmor="DENIED" operation="sendmsg" profile="/sbin/dhclient" pid=1337 comm="dhclient" family="unix" sock_type="stream" protocol=0 requested_mask="send" denied_mask="send"
[   85.531069] audit: type=1400 audit(1506860852.271:49): apparmor="DENIED" operation="sendmsg" profile="/sbin/dhclient" pid=1337 comm="dhclient" family="unix" sock_type="stream" protocol=0 requested_mask="send" denied_mask="send"
[   85.531951] audit: type=1400 audit(1506860852.271:50): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1337 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[   85.531952] audit: type=1400 audit(1506860852.271:51): apparmor="DENIED" operation="sendmsg" profile="/sbin/dhclient" pid=1337 comm="dhclient" family="unix" sock_type="stream" protocol=0 requested_mask="send" denied_mask="send"
[   85.531953] audit: type=1400 audit(1506860852.271:52): apparmor="DENIED" operation="sendmsg" profile="/sbin/dhclient" pid=1337 comm="dhclient" family="unix" sock_type="stream" protocol=0 requested_mask="send" denied_mask="send"
[   85.531973] audit: type=1400 audit(1506860852.271:53): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1337 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[   85.531976] audit: type=1400 audit(1506860852.271:54): apparmor="DENIED" operation="sendmsg" profile="/sbin/dhclient" pid=1337 comm="dhclient" family="unix" sock_type="stream" protocol=0 requested_mask="send" denied_mask="send"
[   85.531977] audit: type=1400 audit(1506860852.271:55): apparmor="DENIED" operation="sendmsg" profile="/sbin/dhclient" pid=1337 comm="dhclient" family="unix" sock_type="stream" protocol=0 requested_mask="send" denied_mask="send"
[   85.533912] audit: type=1400 audit(1506860852.275:56): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1337 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[   88.484744] new mount options do not match the existing superblock, will be ignored
[   94.149317] kauditd_printk_skb: 2 callbacks suppressed
[   94.149319] audit: type=1400 audit(1506860860.891:59): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1337 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[   94.149321] audit: type=1400 audit(1506860860.891:60): apparmor="DENIED" operation="sendmsg" profile="/sbin/dhclient" pid=1337 comm="dhclient" family="unix" sock_type="stream" protocol=0 requested_mask="send" denied_mask="send"
[   94.149322] audit: type=1400 audit(1506860860.891:61): apparmor="DENIED" operation="sendmsg" profile="/sbin/dhclient" pid=1337 comm="dhclient" family="unix" sock_type="stream" protocol=0 requested_mask="send" denied_mask="send"
[  484.491713] BTRFS info (device sdb): disk space caching is enabled
[  484.491714] BTRFS info (device sdb): has skinny extents
[  484.807064] BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528
[  484.807099] BTRFS error (device sdb): failed to read chunk tree: -22
[  484.849921] BTRFS error (device sdb): open_ctree failed
[  522.459468] BTRFS info (device sdb): trying to use backup root at mount time
[  522.459472] BTRFS info (device sdb): disk space caching is enabled
[  522.459474] BTRFS info (device sdb): has skinny extents
[  522.540915] BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528
[  522.540953] BTRFS error (device sdb): failed to read chunk tree: -22
[  522.622128] BTRFS error (device sdb): open_ctree failed
[ 1318.848699] BTRFS info (device sdb): trying to use backup root at mount time
[ 1318.848702] BTRFS info (device sdb): disk space caching is enabled
[ 1318.848703] BTRFS info (device sdb): has skinny extents
[ 1319.144633] BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528
[ 1319.144670] BTRFS error (device sdb): failed to read chunk tree: -22
[ 1319.229851] BTRFS error (device sdb): open_ctree failed
[ 8629.409291] BTRFS info (device sdb): trying to use backup root at mount time
[ 8629.409296] BTRFS info (device sdb): force clearing of disk cache
[ 8629.409299] BTRFS info (device sdb): disk space caching is enabled
[ 8629.409301] BTRFS info (device sdb): has skinny extents
[ 8629.566279] BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528
[ 8629.566316] BTRFS error (device sdb): failed to read chunk tree: -22
[ 8629.633092] BTRFS error (device sdb): open_ctree failed
[ 8640.782589] BTRFS info (device sdb): trying to use backup root at mount time
[ 8640.782593] BTRFS info (device sdb): force clearing of disk cache
[ 8640.782595] BTRFS info (device sdb): disk space caching is enabled
[ 8640.782597] BTRFS info (device sdb): has skinny extents
[ 8640.874001] BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528
[ 8640.874035] BTRFS error (device sdb): failed to read chunk tree: -22
[ 8640.925235] BTRFS error (device sdb): open_ctree failed
[42915.101841] audit: type=1400 audit(1506903681.232:62): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[42915.103428] audit: type=1400 audit(1506903681.232:63): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[42915.180693] audit: type=1400 audit(1506903681.308:64): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[80010.138535] audit: type=1400 audit(1506940775.778:65): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[80010.140035] audit: type=1400 audit(1506940775.778:66): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[80010.161098] audit: type=1400 audit(1506940775.798:67): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[82512.748306] BTRFS info (device sdb): trying to use backup root at mount time
[82512.748309] BTRFS info (device sdb): force clearing of disk cache
[82512.748311] BTRFS info (device sdb): disk space caching is enabled
[82512.748312] BTRFS info (device sdb): has skinny extents
[82513.067033] BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528
[82513.067068] BTRFS error (device sdb): failed to read chunk tree: -22
[82513.133708] BTRFS error (device sdb): open_ctree failed
[83332.777470] perf: interrupt took too long (2505 > 2500), lowering kernel.perf_event_max_sample_rate to 79750
[111305.739447] audit: type=1400 audit(1506972070.968:68): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[111305.740948] audit: type=1400 audit(1506972070.968:69): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[111305.757305] audit: type=1400 audit(1506972070.984:70): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[137535.944588] BTRFS info (device sdb): trying to use backup root at mount time
[137535.944590] BTRFS info (device sdb): force clearing of disk cache
[137535.944591] BTRFS info (device sdb): disk space caching is enabled
[137535.944591] BTRFS info (device sdb): has skinny extents
[137536.247164] BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528
[137536.247194] BTRFS error (device sdb): failed to read chunk tree: -22
[137536.303779] BTRFS error (device sdb): open_ctree failed
[138233.331771] BTRFS info (device sdb): trying to use backup root at mount time
[138233.331775] BTRFS info (device sdb): disabling disk space caching
[138233.331778] BTRFS info (device sdb): force clearing of disk cache
[138233.331779] BTRFS info (device sdb): has skinny extents
[138233.638570] BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528
[138233.638606] BTRFS error (device sdb): failed to read chunk tree: -22
[138233.693661] BTRFS error (device sdb): open_ctree failed
[138848.478164] BTRFS info (device sdb): trying to use backup root at mount time
[138848.478167] BTRFS info (device sdb): unrecognized mount option 'errors=continue'
[138848.503511] BTRFS error (device sdb): open_ctree failed
[139055.927061] BTRFS info (device sdb): trying to use backup root at mount time
[139055.927063] BTRFS info (device sdb): allowing degraded mounts
[139055.927064] BTRFS info (device sdb): disk space caching is enabled
[139055.927064] BTRFS info (device sdb): has skinny extents
[139056.002424] BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528
[139056.002459] BTRFS error (device sdb): failed to read chunk tree: -22
[139056.117758] BTRFS error (device sdb): open_ctree failed
[139922.147349] perf: interrupt took too long (3133 > 3131), lowering kernel.perf_event_max_sample_rate to 63750
[141279.800296] audit: type=1400 audit(1507002044.648:71): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[141279.801756] audit: type=1400 audit(1507002044.648:72): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[141280.097268] audit: type=1400 audit(1507002044.944:73): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[178657.216624] audit: type=1400 audit(1507039421.583:74): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[178657.217894] audit: type=1400 audit(1507039421.583:75): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[178657.352952] audit: type=1400 audit(1507039421.719:76): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[189588.594786] perf: interrupt took too long (3930 > 3916), lowering kernel.perf_event_max_sample_rate to 50750
[207982.081959] audit: type=1400 audit(1507068746.083:77): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[207982.083394] audit: type=1400 audit(1507068746.083:78): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[207982.161411] audit: type=1400 audit(1507068746.163:79): apparmor="DENIED" operation="create" profile="/sbin/dhclient" pid=1925 comm="dhclient" family="unix" sock_type="dgram" protocol=0 requested_mask="create" denied_mask="create"
[209988.369637] BTRFS info (device sdb): trying to use backup root at mount time
[209988.369640] BTRFS info (device sdb): disk space caching is enabled
[209988.369641] BTRFS info (device sdb): has skinny extents
[209988.867190] BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528
[209988.867222] BTRFS error (device sdb): failed to read chunk tree: -22
[209988.981030] BTRFS error (device sdb): open_ctree failed
[210003.162180] BTRFS info (device sdb): trying to use backup root at mount time
[210003.162181] BTRFS info (device sdb): disk space caching is enabled
[210003.162182] BTRFS info (device sdb): has skinny extents
[210003.242724] BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528
[210003.242759] BTRFS error (device sdb): failed to read chunk tree: -22
[210003.325267] BTRFS error (device sdb): open_ctree failed
[210017.281912] BTRFS info (device sdb): disk space caching is enabled
[210017.281915] BTRFS info (device sdb): has skinny extents
[210017.402084] BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528
[210017.402126] BTRFS error (device sdb): failed to read chunk tree: -22
[210017.461473] BTRFS error (device sdb): open_ctree failed

--------------F31163CEB9808FAC3827A878--
