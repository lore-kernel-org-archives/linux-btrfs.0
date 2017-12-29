Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout1.hostsharing.net ([83.223.95.204]:51531 "EHLO
        mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdL2Qfb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 11:35:31 -0500
Received: from h06.hostsharing.net (h06.hostsharing.net [83.223.95.25])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 55E0E1033C3FA
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 17:35:29 +0100 (CET)
Received: from mail.home.lxtec.de (HSI-KBW-5-56-176-248.hsi16.kabel-badenwuerttemberg.de [5.56.176.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h06.hostsharing.net (Postfix) with ESMTPSA id EF254629DB07
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 17:35:28 +0100 (CET)
Received: from localhost ([127.0.0.1])
        by mail.home.lxtec.de with esmtp (Exim 4.90_RC4 4 (LXTEC))
        id 1eUxd2-00011O-5f
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 17:35:28 +0100
Received: from mail.home.lxtec.de ([127.0.0.1])
        by localhost (baumbart.home.lxtec.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3qQM13RcxNUm for <linux-btrfs@vger.kernel.org>;
        Fri, 29 Dec 2017 17:35:27 +0100 (CET)
Received: from galadriel.home.lxtec.de ([192.168.200.207])
        by mail.home.lxtec.de with smtp (Exim 4.90_RC4 4 (LXTEC))
        id 1eUxd1-00011J-Q7
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 17:35:27 +0100
Date: Fri, 29 Dec 2017 17:35:27 +0100
From: Elimar Riesebieter <riesebie@lxtec.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: WARNING: CPU: 1 PID: 3016 at fs/btrfs/ctree.h:1564
 btrfs_update_device+0x189/0x190 [btrfs]
Message-ID: <20171229163527.iuk7unh5ihrtn2h6@galadriel.home.lxtec.de>
References: <20171229163312.b3k7rfagcycz5mvf@galadriel.home.lxtec.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7aqv5h6oexvl25ma"
In-Reply-To: <20171229163312.b3k7rfagcycz5mvf@galadriel.home.lxtec.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7aqv5h6oexvl25ma
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

* Elimar Riesebieter <riesebie@lxtec.de> [2017-12-29 17:33 +0100]:

> Hi all,
> 
> I get warnings as seen in attached dmesg.log. This is on 4.14.9.
> 4.9.72 runs flawless so far.
> 
> ##########
> Linux toy 4.14.9-toy-lxtec-amd64 #7 SMP Fri Dec 29 10:43:28 CET 2017 x86_64 GNU/Linux
> --
> btrfs-progs v4.13.3
> --
> Label: 'TOY-RAID1'  uuid: 32fc4ea0-0b26-478c-9b2e-b299d6289270
> 	Total devices 2 FS bytes used 560.98GiB
> 	devid    1 size 3.62TiB used 566.03GiB path /dev/sda3
> 	devid    2 size 3.62TiB used 566.03GiB path /dev/sdb3
> --
> Data, RAID1: total=563.00GiB, used=559.43GiB
> System, RAID1: total=32.00MiB, used=96.00KiB
> Metadata, RAID1: total=3.00GiB, used=1.55GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> #########
> 
> I want to run this machine as a 24/7 server with the latest
> LT-KERNEL. So please investigate.

Ooops, dmesg attached now.

Many thanks
Elimar
-- 
  Alles, was viel bedacht wird, wird bedenklich!;-)
         Friedrich Nietzsche

--7aqv5h6oexvl25ma
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg.log"

[    0.000000] Linux version 4.14.9-toy-lxtec-amd64 (er@toy) (gcc version 7.2.0 (Debian 7.2.0-18)) #7 SMP Fri Dec 29 10:43:28 CET 2017
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.14.9-toy-lxtec-amd64 root=UUID=32fc4ea0-0b26-478c-9b2e-b299d6289270 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[    0.000000] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[    0.000000] x86/fpu: Enabled xstate features 0x1f, context size is 960 bytes, using 'compacted' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000077e90fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000077e91000-0x0000000077e91fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000077e92000-0x0000000077edbfff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000077edc000-0x000000007d09ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007d0a0000-0x000000007d42dfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007d42e000-0x000000007d5ecfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007d5ed000-0x000000007dd90fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007dd91000-0x000000007fe67fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007fe68000-0x000000007fffefff] type 20
[    0.000000] BIOS-e820: [mem 0x000000007ffff000-0x000000007fffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fe010fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000877bfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.40 by American Megatrends
[    0.000000] efi:  ESRT=0x7fc2e918  ACPI=0x7d7f5000  ACPI 2.0=0x7d7f5000  SMBIOS=0xf05e0  SMBIOS 3.0=0x7fb79000  MPS=0xfca00 
[    0.000000] random: fast init done
[    0.000000] SMBIOS 3.0.0 present.
[    0.000000] DMI: Supermicro Super Server/X11SSM-F, BIOS 2.0b 07/28/2017
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x877c00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00C0000000 mask 7FC0000000 uncachable
[    0.000000]   1 base 00A0000000 mask 7FE0000000 uncachable
[    0.000000]   2 base 0090000000 mask 7FF0000000 uncachable
[    0.000000]   3 base 008C000000 mask 7FFC000000 uncachable
[    0.000000]   4 base 008A000000 mask 7FFE000000 uncachable
[    0.000000]   5 base 0089000000 mask 7FFF000000 uncachable
[    0.000000]   6 base 0088800000 mask 7FFF800000 uncachable
[    0.000000]   7 base 0088400000 mask 7FFFC00000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.000000] e820: last_pfn = 0x80000 max_arch_pfn = 0x400000000
[    0.000000] esrt: Reserving ESRT space from 0x000000007fc2e918 to 0x000000007fc2e950.
[    0.000000] Base memory trampoline at [ffff880000092000] 92000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x02bb2000, 0x02bb2fff] PGTABLE
[    0.000000] BRK [0x02bb3000, 0x02bb3fff] PGTABLE
[    0.000000] BRK [0x02bb4000, 0x02bb4fff] PGTABLE
[    0.000000] BRK [0x02bb5000, 0x02bb5fff] PGTABLE
[    0.000000] BRK [0x02bb6000, 0x02bb6fff] PGTABLE
[    0.000000] BRK [0x02bb7000, 0x02bb7fff] PGTABLE
[    0.000000] Secure boot could not be determined
[    0.000000] RAMDISK: [mem 0x3740f000-0x379fefff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000000007D7F5000 000024 (v02 SUPERM)
[    0.000000] ACPI: XSDT 0x000000007D7F50B0 0000E4 (v01 SUPERM SUPERM   01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x000000007D817580 00010C (v05                 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x000000007D7F5230 022349 (v02 SUPERM SMCI--MB 01072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x000000007DD8FF80 000040
[    0.000000] ACPI: APIC 0x000000007D817690 0000BC (v03                 01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x000000007D817750 000044 (v01                 01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x000000007D817798 00009C (v01                 01072009 AMI  00010013)
[    0.000000] ACPI: SPMI 0x000000007D817838 000041 (v05 SUPERM SMCI--MB 00000000 AMI. 00000000)
[    0.000000] ACPI: MCFG 0x000000007D817880 00003C (v01 SUPERM SMCI--MB 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x000000007D8178C0 000038 (v01 SUPERM SMCI--MB 01072009 AMI. 0005000B)
[    0.000000] ACPI: LPIT 0x000000007D8178F8 000094 (v01 INTEL  GNLR     00000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x000000007D817990 000248 (v02 INTEL  sensrhub 00000000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x000000007D817BD8 002BAE (v02 INTEL  PtidDevc 00001000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x000000007D81A788 000BE3 (v02 INTEL  Ther_Rvp 00001000 INTL 20120913)
[    0.000000] ACPI: DBGP 0x000000007D81B370 000034 (v01 INTEL           00000000 MSFT 0000005F)
[    0.000000] ACPI: DBG2 0x000000007D81B3A8 000054 (v00 INTEL           00000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x000000007D81B400 000614 (v02 INTEL  xh_Zumba 00000000 INTL 20120913)
[    0.000000] ACPI: PRAD 0x000000007D81BA18 0000CA (v02 PRADID PRADTID  00000001 INTL 20120913)
[    0.000000] ACPI: SSDT 0x000000007D81BAE8 00547E (v02 SaSsdt SaSsdt   00003000 INTL 20120913)
[    0.000000] ACPI: UEFI 0x000000007D820F68 000042 (v01                 00000000      00000000)
[    0.000000] ACPI: SSDT 0x000000007D820FB0 000E73 (v02 CpuRef CpuSsdt  00003000 INTL 20120913)
[    0.000000] ACPI: BGRT 0x000000007D821E28 000038 (v01 SUPERM SMCI--MB 01072009 AMI  00010013)
[    0.000000] ACPI: DMAR 0x000000007D821E60 000070 (v01 INTEL  SKL      00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 0x000000007D821ED0 000130 (v01 AMI    AMI.EINJ 00000000 AMI. 00000000)
[    0.000000] ACPI: ERST 0x000000007D822000 000230 (v01 AMIER  AMI.ERST 00000000 AMI. 00000000)
[    0.000000] ACPI: BERT 0x000000007D822230 000030 (v01 AMI    AMI.BERT 00000000 AMI. 00000000)
[    0.000000] ACPI: HEST 0x000000007D822260 00027C (v01 AMI    AMI.HEST 00000000 AMI. 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000877bfffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x877bf9000-0x877bfcfff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x0000000877bfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
[    0.000000]   node   0: [mem 0x0000000000059000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x0000000077e90fff]
[    0.000000]   node   0: [mem 0x0000000077edc000-0x000000007d09ffff]
[    0.000000]   node   0: [mem 0x000000007d42e000-0x000000007d5ecfff]
[    0.000000]   node   0: [mem 0x000000007ffff000-0x000000007fffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x0000000877bfffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x0000000877bfffff]
[    0.000000] On node 0 totalpages: 8342962
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 30 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7945 pages used for memmap
[    0.000000]   DMA32 zone: 508437 pages, LIFO batch:31
[    0.000000]   Normal zone: 122352 pages used for memmap
[    0.000000]   Normal zone: 7830528 pages, LIFO batch:31
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
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x77e91000-0x77e91fff]
[    0.000000] PM: Registered nosave memory: [mem 0x77e92000-0x77edbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7d0a0000-0x7d42dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7d5ed000-0x7dd90fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7dd91000-0x7fe67fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7fe68000-0x7fffefff]
[    0.000000] PM: Registered nosave memory: [mem 0x80000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfdffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe000000-0xfe010fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe011000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0x80000000-0xdfffffff] available for PCI devices
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] percpu: Embedded 38 pages/cpu @ffff880877800000 s116888 r8192 d30568 u262144
[    0.000000] pcpu-alloc: s116888 r8192 d30568 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 8212571
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.14.9-toy-lxtec-amd64 root=UUID=32fc4ea0-0b26-478c-9b2e-b299d6289270 ro
[    0.000000] log_buf_len individual max cpu contribution: 32768 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 229376 bytes
[    0.000000] log_buf_len min size: 65536 bytes
[    0.000000] log_buf_len: 524288 bytes
[    0.000000] early log buf free: 52632(80%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 32712208K/33371848K available (4708K kernel code, 499K rwdata, 1500K rodata, 908K init, 304K bss, 659640K reserved, 0K cma-reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS: 4352, nr_irqs: 488, preallocated irqs: 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 120x40
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 79635855245 ns
[    0.000000] hpet clockevent registered
[    0.001000] tsc: Detected 3500.000 MHz processor
[    0.001000] Calibrating delay loop (skipped), value calculated using timer frequency.. 7008.00 BogoMIPS (lpj=3504000)
[    0.001000] pid_max: default: 32768 minimum: 301
[    0.001000] ACPI: Core revision 20170728
[    0.015561] ACPI Error: [\_SB_.PCI0.XHC_.RHUB.HS11] Namespace lookup failure, AE_NOT_FOUND (20170728/dswload-210)
[    0.015565] ACPI Exception: AE_NOT_FOUND, During name lookup/catalog (20170728/psobject-252)
[    0.015588] ACPI Exception: AE_NOT_FOUND, (SSDT:xh_Zumba) while loading table (20170728/tbxfload-228)
[    0.020377] ACPI Error: 1 table load failures, 6 successful (20170728/tbxfload-246)
[    0.021063] Security Framework initialized
[    0.023769] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.025110] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.025153] Mount-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.025193] Mountpoint-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.025301] CPU: Physical Processor ID: 0
[    0.025302] CPU: Processor Core ID: 0
[    0.025306] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.025307] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.025311] mce: CPU supports 10 MCE banks
[    0.025318] CPU0: Thermal monitoring enabled (TM1)
[    0.025332] process: using mwait in idle threads
[    0.025334] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.025335] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.025373] Freeing SMP alternatives memory: 24K
[    0.026825] smpboot: Max logical packages: 2
[    0.027820] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.037866] TSC deadline timer enabled
[    0.037871] smpboot: CPU0: Intel(R) Xeon(R) CPU E3-1230 v6 @ 3.50GHz (family: 0x6, model: 0x9e, stepping: 0x9)
[    0.037901] Performance Events: PEBS fmt3+, Skylake events, 32-deep LBR, full-width counters, Intel PMU driver.
[    0.037921] ... version:                4
[    0.037922] ... bit width:              48
[    0.037923] ... generic registers:      4
[    0.037923] ... value mask:             0000ffffffffffff
[    0.037924] ... max period:             00007fffffffffff
[    0.037925] ... fixed-purpose events:   3
[    0.037926] ... event mask:             000000070000000f
[    0.037949] Hierarchical SRCU implementation.
[    0.038000] smp: Bringing up secondary CPUs ...
[    0.038000] x86: Booting SMP configuration:
[    0.038000] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.040521] smp: Brought up 1 node, 8 CPUs
[    0.040521] smpboot: Total of 8 processors activated (56064.00 BogoMIPS)
[    0.041296] devtmpfs: initialized
[    0.041296] PM: Registering ACPI NVS region [mem 0x77e91000-0x77e91fff] (4096 bytes)
[    0.041296] PM: Registering ACPI NVS region [mem 0x7d5ed000-0x7dd90fff] (8011776 bytes)
[    0.041296] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.041296] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.041296] NET: Registered protocol family 16
[    0.041296] cpuidle: using governor ladder
[    0.041296] cpuidle: using governor menu
[    0.041296] ACPI: bus type PCI registered
[    0.041296] PCI: Using configuration type 1 for base access
[    0.042216] ACPI: Added _OSI(Module Device)
[    0.042216] ACPI: Added _OSI(Processor Device)
[    0.042216] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.042216] ACPI: Added _OSI(Processor Aggregator Device)
[    0.043076] ACPI: Executed 25 blocks of module-level executable AML code
[    0.048553] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.050833] ACPI: Dynamic OEM Table Load:
[    0.052118] ACPI: Dynamic OEM Table Load:
[    0.052123] ACPI: SSDT 0xFFFF88085390F000 000705 (v02 PmRef  Cpu0Ist  00003000 INTL 20120913)
[    0.052257] ACPI: \_PR_.CPU0: _OSC native thermal LVT Acked
[    0.053124] ACPI: Dynamic OEM Table Load:
[    0.053129] ACPI: SSDT 0xFFFF8808538DF800 00037F (v02 PmRef  Cpu0Cst  00003001 INTL 20120913)
[    0.053557] ACPI: Dynamic OEM Table Load:
[    0.053561] ACPI: SSDT 0xFFFF880853FF5000 0005AA (v02 PmRef  ApIst    00003000 INTL 20120913)
[    0.054106] ACPI: Dynamic OEM Table Load:
[    0.054110] ACPI: SSDT 0xFFFF880853963E00 000119 (v02 PmRef  ApCst    00003000 INTL 20120913)
[    0.058089] ACPI: Interpreter enabled
[    0.058113] ACPI: (supports S0 S4 S5)
[    0.058114] ACPI: Using IOAPIC for interrupt routing
[    0.058138] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.058652] ACPI: Enabled 8 GPEs in block 00 to 7F
[    0.060117] ACPI: Power Resource [PG00] (on)
[    0.060331] ACPI: Power Resource [PG01] (on)
[    0.060523] ACPI: Power Resource [PG02] (on)
[    0.062511] ACPI: Power Resource [WRST] (on)
[    0.062759] ACPI: Power Resource [WRST] (on)
[    0.062984] ACPI: Power Resource [WRST] (on)
[    0.063219] ACPI: Power Resource [WRST] (on)
[    0.063426] ACPI: Power Resource [WRST] (on)
[    0.063634] ACPI: Power Resource [WRST] (on)
[    0.063841] ACPI: Power Resource [WRST] (on)
[    0.064049] ACPI: Power Resource [WRST] (on)
[    0.064255] ACPI: Power Resource [WRST] (on)
[    0.064461] ACPI: Power Resource [WRST] (on)
[    0.064669] ACPI: Power Resource [WRST] (on)
[    0.064875] ACPI: Power Resource [WRST] (on)
[    0.065083] ACPI: Power Resource [WRST] (on)
[    0.065289] ACPI: Power Resource [WRST] (on)
[    0.065495] ACPI: Power Resource [WRST] (on)
[    0.065702] ACPI: Power Resource [WRST] (on)
[    0.065909] ACPI: Power Resource [WRST] (on)
[    0.066117] ACPI: Power Resource [WRST] (on)
[    0.066324] ACPI: Power Resource [WRST] (on)
[    0.066530] ACPI: Power Resource [WRST] (on)
[    0.073652] ACPI: Power Resource [FN00] (off)
[    0.073703] ACPI: Power Resource [FN01] (off)
[    0.073752] ACPI: Power Resource [FN02] (off)
[    0.073800] ACPI: Power Resource [FN03] (off)
[    0.073849] ACPI: Power Resource [FN04] (off)
[    0.074553] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.074556] acpi PNP0A08:00: _OSC: OS supports [Segments MSI]
[    0.074617] acpi PNP0A08:00: PCIe port services disabled; not requesting _OSC control
[    0.074828] PCI host bridge to bus 0000:00
[    0.074830] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.074831] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.074832] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.074834] pci_bus 0000:00: root bus resource [mem 0x88400000-0xdfffffff window]
[    0.074835] pci_bus 0000:00: root bus resource [mem 0xfd000000-0xfe7fffff window]
[    0.074836] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.074842] pci 0000:00:00.0: [8086:5918] type 00 class 0x060000
[    0.075115] pci 0000:00:13.0: [8086:a135] type 00 class 0x000000
[    0.075134] pci 0000:00:13.0: reg 0x10: [mem 0xdf322000-0xdf322fff 64bit]
[    0.075267] pci 0000:00:14.0: [8086:a12f] type 00 class 0x0c0330
[    0.075284] pci 0000:00:14.0: reg 0x10: [mem 0xdf300000-0xdf30ffff 64bit]
[    0.075336] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.075477] pci 0000:00:14.2: [8086:a131] type 00 class 0x118000
[    0.075494] pci 0000:00:14.2: reg 0x10: [mem 0xdf321000-0xdf321fff 64bit]
[    0.075627] pci 0000:00:16.0: [8086:a13a] type 00 class 0x078000
[    0.075651] pci 0000:00:16.0: reg 0x10: [mem 0xdf320000-0xdf320fff 64bit]
[    0.075723] pci 0000:00:16.0: PME# supported from D3hot
[    0.075808] pci 0000:00:16.1: [8086:a13b] type 00 class 0x078000
[    0.075832] pci 0000:00:16.1: reg 0x10: [mem 0xdf31f000-0xdf31ffff 64bit]
[    0.075903] pci 0000:00:16.1: PME# supported from D3hot
[    0.075994] pci 0000:00:17.0: [8086:a102] type 00 class 0x010601
[    0.076008] pci 0000:00:17.0: reg 0x10: [mem 0xdf310000-0xdf311fff]
[    0.076013] pci 0000:00:17.0: reg 0x14: [mem 0xdf31e000-0xdf31e0ff]
[    0.076019] pci 0000:00:17.0: reg 0x18: [io  0xf050-0xf057]
[    0.076024] pci 0000:00:17.0: reg 0x1c: [io  0xf040-0xf043]
[    0.076030] pci 0000:00:17.0: reg 0x20: [io  0xf020-0xf03f]
[    0.076035] pci 0000:00:17.0: reg 0x24: [mem 0xdf31d000-0xdf31d7ff]
[    0.076066] pci 0000:00:17.0: PME# supported from D3hot
[    0.076166] pci 0000:00:1c.0: [8086:a110] type 01 class 0x060400
[    0.076215] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.076343] pci 0000:00:1d.0: [8086:a118] type 01 class 0x060400
[    0.076386] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.076486] pci 0000:00:1d.1: [8086:a119] type 01 class 0x060400
[    0.076529] pci 0000:00:1d.1: PME# supported from D0 D3hot D3cold
[    0.076629] pci 0000:00:1d.2: [8086:a11a] type 01 class 0x060400
[    0.076672] pci 0000:00:1d.2: PME# supported from D0 D3hot D3cold
[    0.076790] pci 0000:00:1f.0: [8086:a149] type 00 class 0x060100
[    0.076972] pci 0000:00:1f.2: [8086:a121] type 00 class 0x058000
[    0.076982] pci 0000:00:1f.2: reg 0x10: [mem 0xdf318000-0xdf31bfff]
[    0.077111] pci 0000:00:1f.4: [8086:a123] type 00 class 0x0c0500
[    0.077170] pci 0000:00:1f.4: reg 0x10: [mem 0xdf31c000-0xdf31c0ff 64bit]
[    0.077239] pci 0000:00:1f.4: reg 0x20: [io  0xf000-0xf01f]
[    0.077421] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.077476] pci 0000:02:00.0: [8086:1533] type 00 class 0x020000
[    0.077498] pci 0000:02:00.0: reg 0x10: [mem 0xdf200000-0xdf27ffff]
[    0.077521] pci 0000:02:00.0: reg 0x18: [io  0xe000-0xe01f]
[    0.077533] pci 0000:02:00.0: reg 0x1c: [mem 0xdf280000-0xdf283fff]
[    0.077635] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.077679] pci 0000:00:1d.0: PCI bridge to [bus 02]
[    0.077692] pci 0000:00:1d.0:   bridge window [io  0xe000-0xefff]
[    0.077693] pci 0000:00:1d.0:   bridge window [mem 0xdf200000-0xdf2fffff]
[    0.077743] pci 0000:03:00.0: [8086:1533] type 00 class 0x020000
[    0.077764] pci 0000:03:00.0: reg 0x10: [mem 0xdf100000-0xdf17ffff]
[    0.077787] pci 0000:03:00.0: reg 0x18: [io  0xd000-0xd01f]
[    0.077799] pci 0000:03:00.0: reg 0x1c: [mem 0xdf180000-0xdf183fff]
[    0.077913] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.077953] pci 0000:00:1d.1: PCI bridge to [bus 03]
[    0.077966] pci 0000:00:1d.1:   bridge window [io  0xd000-0xdfff]
[    0.077967] pci 0000:00:1d.1:   bridge window [mem 0xdf100000-0xdf1fffff]
[    0.078007] pci 0000:04:00.0: [1a03:1150] type 01 class 0x060400
[    0.078056] pci 0000:04:00.0: enabling Extended Tags
[    0.078110] pci 0000:04:00.0: supports D1 D2
[    0.078111] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.078163] pci 0000:00:1d.2: PCI bridge to [bus 04-05]
[    0.078176] pci 0000:00:1d.2:   bridge window [io  0xc000-0xcfff]
[    0.078177] pci 0000:00:1d.2:   bridge window [mem 0xde000000-0xdf0fffff]
[    0.078230] pci 0000:05:00.0: [1a03:2000] type 00 class 0x030000
[    0.078256] pci 0000:05:00.0: reg 0x10: [mem 0xde000000-0xdeffffff]
[    0.078267] pci 0000:05:00.0: reg 0x14: [mem 0xdf000000-0xdf01ffff]
[    0.078278] pci 0000:05:00.0: reg 0x18: [io  0xc000-0xc07f]
[    0.078369] pci 0000:05:00.0: supports D1 D2
[    0.078369] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.078446] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.078452] pci 0000:04:00.0:   bridge window [io  0xc000-0xcfff]
[    0.078456] pci 0000:04:00.0:   bridge window [mem 0xde000000-0xdf0fffff]
[    0.079924] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.079979] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.080027] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.080075] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.080122] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.080169] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.080216] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.080263] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.080653] SCSI subsystem initialized
[    0.080661] libata version 3.00 loaded.
[    0.080661] ACPI: bus type USB registered
[    0.080661] usbcore: registered new interface driver usbfs
[    0.080661] usbcore: registered new interface driver hub
[    0.080661] usbcore: registered new device driver usb
[    0.080661] Registered efivars operations
[    0.086503] PCI: Using ACPI for IRQ routing
[    0.086504] PCI: pci_cache_line_size set to 64 bytes
[    0.086590] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    0.086591] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.086591] e820: reserve RAM buffer [mem 0x77e91000-0x77ffffff]
[    0.086592] e820: reserve RAM buffer [mem 0x7d0a0000-0x7fffffff]
[    0.086593] e820: reserve RAM buffer [mem 0x7d5ed000-0x7fffffff]
[    0.086593] e820: reserve RAM buffer [mem 0x877c00000-0x877ffffff]
[    0.086737] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.086741] hpet0: 8 comparators, 64-bit 24.000000 MHz counter
[    0.088018] clocksource: Switched to clocksource hpet
[    0.088048] pnp: PnP ACPI init
[    0.088266] system 00:00: [io  0x0a00-0x0a0f] has been reserved
[    0.088269] system 00:00: [io  0x0a10-0x0a1f] has been reserved
[    0.088270] system 00:00: [io  0x0a20-0x0a2f] has been reserved
[    0.088272] system 00:00: [io  0x0a30-0x0a3f] has been reserved
[    0.088273] system 00:00: [io  0x0a40-0x0a4f] has been reserved
[    0.088276] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.088508] pnp 00:01: [dma 0 disabled]
[    0.088529] pnp 00:01: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.088756] pnp 00:02: [dma 0 disabled]
[    0.088776] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.088855] system 00:03: [io  0x0680-0x069f] has been reserved
[    0.088857] system 00:03: [io  0xffff] has been reserved
[    0.088858] system 00:03: [io  0xffff] has been reserved
[    0.088859] system 00:03: [io  0xffff] has been reserved
[    0.088860] system 00:03: [io  0x1800-0x18fe] has been reserved
[    0.088862] system 00:03: [io  0x164e-0x164f] has been reserved
[    0.088864] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.088913] system 00:04: [io  0x0800-0x087f] has been reserved
[    0.088916] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.088924] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.088942] system 00:06: [io  0x1854-0x1857] has been reserved
[    0.088944] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.089123] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.089125] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.089126] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.089128] system 00:07: [mem 0xe0000000-0xefffffff] has been reserved
[    0.089129] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.089130] system 00:07: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.089132] system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.089133] system 00:07: [mem 0xff000000-0xffffffff] has been reserved
[    0.089135] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.089136] system 00:07: [mem 0xdffe0000-0xdfffffff] has been reserved
[    0.089138] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.089158] system 00:08: [mem 0xfd000000-0xfdabffff] has been reserved
[    0.089160] system 00:08: [mem 0xfdad0000-0xfdadffff] has been reserved
[    0.089161] system 00:08: [mem 0xfdb00000-0xfdffffff] has been reserved
[    0.089163] system 00:08: [mem 0xfe000000-0xfe01ffff] could not be reserved
[    0.089164] system 00:08: [mem 0xfe036000-0xfe03bfff] has been reserved
[    0.089165] system 00:08: [mem 0xfe03d000-0xfe3fffff] has been reserved
[    0.089167] system 00:08: [mem 0xfe410000-0xfe7fffff] has been reserved
[    0.089168] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.089336] system 00:09: [io  0xff00-0xfffe] has been reserved
[    0.089339] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.090032] system 00:0a: [mem 0xfdaf0000-0xfdafffff] has been reserved
[    0.090034] system 00:0a: [mem 0xfdae0000-0xfdaeffff] has been reserved
[    0.090035] system 00:0a: [mem 0xfdac0000-0xfdacffff] has been reserved
[    0.090038] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.090576] pnp: PnP ACPI: found 11 devices
[    0.097944] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.097971] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.097978] pci 0000:00:1d.0: PCI bridge to [bus 02]
[    0.097980] pci 0000:00:1d.0:   bridge window [io  0xe000-0xefff]
[    0.097983] pci 0000:00:1d.0:   bridge window [mem 0xdf200000-0xdf2fffff]
[    0.097987] pci 0000:00:1d.1: PCI bridge to [bus 03]
[    0.097989] pci 0000:00:1d.1:   bridge window [io  0xd000-0xdfff]
[    0.097992] pci 0000:00:1d.1:   bridge window [mem 0xdf100000-0xdf1fffff]
[    0.097996] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.097999] pci 0000:04:00.0:   bridge window [io  0xc000-0xcfff]
[    0.098030] pci 0000:04:00.0:   bridge window [mem 0xde000000-0xdf0fffff]
[    0.098040] pci 0000:00:1d.2: PCI bridge to [bus 04-05]
[    0.098042] pci 0000:00:1d.2:   bridge window [io  0xc000-0xcfff]
[    0.098045] pci 0000:00:1d.2:   bridge window [mem 0xde000000-0xdf0fffff]
[    0.098050] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.098051] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.098051] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.098052] pci_bus 0000:00: resource 7 [mem 0x88400000-0xdfffffff window]
[    0.098053] pci_bus 0000:00: resource 8 [mem 0xfd000000-0xfe7fffff window]
[    0.098053] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.098054] pci_bus 0000:02: resource 1 [mem 0xdf200000-0xdf2fffff]
[    0.098055] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.098055] pci_bus 0000:03: resource 1 [mem 0xdf100000-0xdf1fffff]
[    0.098056] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    0.098056] pci_bus 0000:04: resource 1 [mem 0xde000000-0xdf0fffff]
[    0.098057] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.098058] pci_bus 0000:05: resource 1 [mem 0xde000000-0xdf0fffff]
[    0.098142] NET: Registered protocol family 2
[    0.098232] TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.098427] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.098499] TCP: Hash tables configured (established 262144 bind 65536)
[    0.098521] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.098569] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    0.098630] NET: Registered protocol family 1
[    0.098844] pci 0000:05:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.098847] PCI: CLS 0 bytes, default 64
[    0.098884] Trying to unpack rootfs image as initramfs...
[    0.162701] Freeing initrd memory: 6080K
[    0.162707] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.162709] software IO TLB [mem 0x73afe000-0x77afe000] (64MB) mapped at [ffff880073afe000-ffff880077afdfff]
[    0.162868] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 655360 ms ovfl timer
[    0.162870] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    0.162871] RAPL PMU: hw unit of domain package 2^-14 Joules
[    0.162872] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    0.162873] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    0.162873] RAPL PMU: hw unit of domain psys 2^-14 Joules
[    0.163132] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x3282142a9b0, max_idle_ns: 440795384778 ns
[    0.164231] audit: initializing netlink subsys (disabled)
[    0.164294] audit: type=2000 audit(1514540821.164:1): state=initialized audit_enabled=0 res=1
[    0.164435] workingset: timestamp_bits=40 max_order=23 bucket_order=0
[    0.166232] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.166234] io scheduler noop registered
[    0.166235] io scheduler deadline registered
[    0.166240] io scheduler cfq registered (default)
[    0.166241] io scheduler mq-deadline registered
[    0.166242] io scheduler kyber registered
[    0.166351] intel_idle: MWAIT substates: 0x142120
[    0.166351] intel_idle: v0.4.1 model 0x9E
[    0.166632] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.166672] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    0.166691] ACPI: Sleep Button [SLPB]
[    0.166708] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.166725] ACPI: Power Button [PWRB]
[    0.166742] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.166786] ACPI: Power Button [PWRF]
[    0.168834] brd: module loaded
[    0.169873] loop: module loaded
[    0.169893] ahci 0000:00:17.0: version 3.0
[    0.180204] ahci 0000:00:17.0: AHCI 0001.0301 32 slots 8 ports 6 Gbps 0xff impl SATA mode
[    0.180207] ahci 0000:00:17.0: flags: 64bit ncq sntf led clo only pio slum part ems deso sadm sds apst 
[    0.202057] scsi host0: ahci
[    0.202378] scsi host1: ahci
[    0.202754] scsi host2: ahci
[    0.203057] scsi host3: ahci
[    0.203242] scsi host4: ahci
[    0.203438] scsi host5: ahci
[    0.203615] scsi host6: ahci
[    0.203810] scsi host7: ahci
[    0.203828] ata1: SATA max UDMA/133 abar m2048@0xdf31d000 port 0xdf31d100 irq 24
[    0.203832] ata2: SATA max UDMA/133 abar m2048@0xdf31d000 port 0xdf31d180 irq 24
[    0.203837] ata3: SATA max UDMA/133 abar m2048@0xdf31d000 port 0xdf31d200 irq 24
[    0.203838] ata4: SATA max UDMA/133 abar m2048@0xdf31d000 port 0xdf31d280 irq 24
[    0.203840] ata5: SATA max UDMA/133 abar m2048@0xdf31d000 port 0xdf31d300 irq 24
[    0.203842] ata6: SATA max UDMA/133 abar m2048@0xdf31d000 port 0xdf31d380 irq 24
[    0.203843] ata7: SATA max UDMA/133 abar m2048@0xdf31d000 port 0xdf31d400 irq 24
[    0.203845] ata8: SATA max UDMA/133 abar m2048@0xdf31d000 port 0xdf31d480 irq 24
[    0.203892] i8042: PNP: No PS/2 controller found.
[    0.203999] mousedev: PS/2 mouse device common for all mice
[    0.204063] rtc_cmos 00:05: RTC can wake from S4
[    0.204696] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.204832] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.204839] i2c /dev entries driver
[    0.204959] i801_smbus 0000:00:1f.4: SPD Write Disable is set
[    0.204999] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[    0.206435] intel_pstate: Intel P-state driver initializing
[    0.206566] intel_pstate: Disabling energy efficiency optimization
[    0.207534] intel_pstate: HWP enabled
[    0.207535] EFI Variables Facility v0.08 2004-May-17
[    0.213891] Initializing XFRM netlink socket
[    0.213893] NET: Registered protocol family 17
[    0.213900] Key type dns_resolver registered
[    0.214523] microcode: sig=0x906e9, pf=0x2, revision=0x5e
[    0.214909] microcode: Microcode Update Driver: v2.2.
[    0.214915] sched_clock: Marking stable (214900630, 0)->(270805431, -55904801)
[    0.215530] registered taskstats version 1
[    0.216385] rtc_cmos 00:05: setting system clock to 2017-12-29 09:47:02 UTC (1514540822)
[    0.508978] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.509725] ata5: SATA link down (SStatus 0 SControl 300)
[    0.509764] ata6: SATA link down (SStatus 0 SControl 300)
[    0.509805] ata4: SATA link down (SStatus 0 SControl 300)
[    0.509839] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.509880] ata3: SATA link down (SStatus 0 SControl 300)
[    0.512990] ata1.00: ATA-9: WDC WD4002FYYZ-01B7CB1, 01.01M03, max UDMA/133
[    0.513002] ata1.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.513815] ata2.00: ATA-9: WDC WD4002FYYZ-01B7CB1, 01.01M03, max UDMA/133
[    0.513827] ata2.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.517209] ata8: SATA link down (SStatus 0 SControl 300)
[    0.517929] ata7: SATA link down (SStatus 0 SControl 300)
[    0.519819] ata1.00: configured for UDMA/133
[    0.520292] ata2.00: configured for UDMA/133
[    0.520295] scsi 0:0:0:0: Direct-Access     ATA      WDC WD4002FYYZ-0 1M03 PQ: 0 ANSI: 5
[    0.520946] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.521532] scsi 1:0:0:0: Direct-Access     ATA      WDC WD4002FYYZ-0 1M03 PQ: 0 ANSI: 5
[    0.521535] sd 0:0:0:0: [sda] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
[    0.521657] sd 0:0:0:0: [sda] Write Protect is off
[    0.521669] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.521868] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.522182] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    0.522496] sd 1:0:0:0: [sdb] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
[    0.522581] sd 1:0:0:0: [sdb] Write Protect is off
[    0.522592] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.522761] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.565307]  sda: sda1 sda2 sda3
[    0.565337]  sdb: sdb1 sdb2 sdb3
[    0.567283] sd 1:0:0:0: [sdb] Attached SCSI disk
[    0.567284] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.588105] Freeing unused kernel memory: 908K
[    0.588114] Write protecting the kernel read-only data: 8192k
[    0.588950] Freeing unused kernel memory: 1416K
[    0.591347] Freeing unused kernel memory: 548K
[    0.635951] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    0.635984] thermal LNXTHERM:00: registered as thermal_zone0
[    0.635986] ACPI: Thermal Zone [TZ00] (28 C)
[    0.636098] thermal LNXTHERM:01: registered as thermal_zone1
[    0.636099] ACPI: Thermal Zone [TZ01] (30 C)
[    0.637647] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.637651] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    0.638834] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00109810
[    0.638839] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.638986] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.638988] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.638990] usb usb1: Product: xHCI Host Controller
[    0.638991] usb usb1: Manufacturer: Linux 4.14.9-toy-lxtec-amd64 xhci-hcd
[    0.638992] usb usb1: SerialNumber: 0000:00:14.0
[    0.639135] hub 1-0:1.0: USB hub found
[    0.639165] hub 1-0:1.0: 16 ports detected
[    0.639615] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.639620] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    0.639693] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    0.639696] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.639697] usb usb2: Product: xHCI Host Controller
[    0.639698] usb usb2: Manufacturer: Linux 4.14.9-toy-lxtec-amd64 xhci-hcd
[    0.639699] usb usb2: SerialNumber: 0000:00:14.0
[    0.639778] hub 2-0:1.0: USB hub found
[    0.639817] hub 2-0:1.0: 10 ports detected
[    0.642348] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4.0-k
[    0.642350] igb: Copyright (c) 2007-2014 Intel Corporation.
[    0.884140] igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
[    0.884150] igb 0000:02:00.0: eth0: (PCIe:2.5Gb/s:Width x1) ac:1f:6b:26:b9:76
[    0.884222] igb 0000:02:00.0: eth0: PBA No: 012700-000
[    0.884228] igb 0000:02:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    0.961126] usb 1-6: new low-speed USB device number 2 using xhci_hcd
[    1.092224] usb 1-6: New USB device found, idVendor=13ba, idProduct=0018
[    1.092235] usb 1-6: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    1.092240] usb 1-6: Product: Barcode Reader 
[    1.096000] hidraw: raw HID events driver (C) Jiri Kosina
[    1.102185] usbcore: registered new interface driver usbhid
[    1.102191] usbhid: USB HID core driver
[    1.104542] input: Barcode Reader  as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/0003:13BA:0018.0001/input/input3
[    1.139483] igb 0000:03:00.0: Intel(R) Gigabit Ethernet Network Connection
[    1.139494] igb 0000:03:00.0: eth1: (PCIe:2.5Gb/s:Width x1) ac:1f:6b:26:b9:77
[    1.139581] igb 0000:03:00.0: eth1: PBA No: 012700-000
[    1.139587] igb 0000:03:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    1.141779] igb 0000:03:00.0 eno2: renamed from eth1
[    1.150254] igb 0000:02:00.0 eno1: renamed from eth0
[    1.157176] hid-generic 0003:13BA:0018.0001: input,hidraw0: USB HID v1.10 Keyboard [Barcode Reader ] on usb-0000:00:14.0-6/input0
[    1.157769] input: Barcode Reader  as /devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.1/0003:13BA:0018.0002/input/input4
[    1.167383] clocksource: Switched to clocksource tsc
[    1.202422] usb 2-1: new SuperSpeed USB device number 2 using xhci_hcd
[    1.209443] hid-generic 0003:13BA:0018.0002: input,hidraw1: USB HID v1.10 Mouse [Barcode Reader ] on usb-0000:00:14.0-6/input1
[    1.214692] usb 2-1: New USB device found, idVendor=1f75, idProduct=0916
[    1.214696] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.214699] usb 2-1: Product: PenDrive
[    1.214701] usb 2-1: Manufacturer: Innostor
[    1.214702] usb 2-1: SerialNumber: 6214095400000023
[    1.216399] usb-storage 2-1:1.0: USB Mass Storage device detected
[    1.216465] scsi host8: usb-storage 2-1:1.0
[    1.216516] usbcore: registered new interface driver usb-storage
[    1.233046] raid6: sse2x1   gen() 11886 MB/s
[    1.250045] raid6: sse2x1   xor()  9923 MB/s
[    1.267043] raid6: sse2x2   gen() 16691 MB/s
[    1.284045] raid6: sse2x2   xor() 11435 MB/s
[    1.301042] raid6: sse2x4   gen() 19550 MB/s
[    1.318047] raid6: sse2x4   xor() 11845 MB/s
[    1.329044] usb 1-9: new high-speed USB device number 3 using xhci_hcd
[    1.335041] raid6: avx2x1   gen() 26953 MB/s
[    1.352040] raid6: avx2x1   xor() 18955 MB/s
[    1.369044] raid6: avx2x2   gen() 32832 MB/s
[    1.386040] raid6: avx2x2   xor() 21060 MB/s
[    1.403041] raid6: avx2x4   gen() 38261 MB/s
[    1.420039] raid6: avx2x4   xor() 23003 MB/s
[    1.420040] raid6: using algorithm avx2x4 gen() 38261 MB/s
[    1.420041] raid6: .... xor() 23003 MB/s, rmw enabled
[    1.420042] raid6: using avx2x2 recovery algorithm
[    1.420880] xor: automatically using best checksumming function   avx       
[    1.424730] Btrfs loaded, crc32c=crc32c-intel
[    1.456307] usb 1-9: New USB device found, idVendor=0557, idProduct=7000
[    1.456311] usb 1-9: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.456723] hub 1-9:1.0: USB hub found
[    1.456835] hub 1-9:1.0: 4 ports detected
[    1.471534] BTRFS: device label TOY-RAID1 devid 2 transid 6401 /dev/sdb3
[    1.471923] BTRFS: device label TOY-RAID1 devid 1 transid 6401 /dev/sda3
[    1.476364] random: crng init done
[    1.479138] PM: Starting manual resume from disk
[    1.494662] BTRFS info (device sda3): disk space caching is enabled
[    1.494670] BTRFS info (device sda3): has skinny extents
[    1.747083] usb 1-9.1: new low-speed USB device number 4 using xhci_hcd
[    1.852541] usb 1-9.1: New USB device found, idVendor=0557, idProduct=2419
[    1.852557] usb 1-9.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.854496] input: HID 0557:2419 as /devices/pci0000:00/0000:00:14.0/usb1/1-9/1-9.1/1-9.1:1.0/0003:0557:2419.0003/input/input5
[    1.906293] hid-generic 0003:0557:2419.0003: input,hidraw2: USB HID v1.00 Keyboard [HID 0557:2419] on usb-0000:00:14.0-9.1/input0
[    1.907543] input: HID 0557:2419 as /devices/pci0000:00/0000:00:14.0/usb1/1-9/1-9.1/1-9.1:1.1/0003:0557:2419.0004/input/input6
[    1.907870] hid-generic 0003:0557:2419.0004: input,hidraw3: USB HID v1.00 Mouse [HID 0557:2419] on usb-0000:00:14.0-9.1/input1
[    2.271531] scsi 8:0:0:0: Direct-Access     Innostor Innostor         1.00 PQ: 0 ANSI: 6
[    2.271933] sd 8:0:0:0: Attached scsi generic sg2 type 0
[    2.272134] sd 8:0:0:0: [sdc] 30720000 512-byte logical blocks: (15.7 GB/14.6 GiB)
[    2.272384] sd 8:0:0:0: [sdc] Write Protect is off
[    2.272395] sd 8:0:0:0: [sdc] Mode Sense: 03 00 00 00
[    2.272585] sd 8:0:0:0: [sdc] No Caching mode page found
[    2.272593] sd 8:0:0:0: [sdc] Assuming drive cache: write through
[    2.274161]  sdc: sdc1 sdc2
[    2.275264] sd 8:0:0:0: [sdc] Attached SCSI removable disk
[    4.038935] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    4.046983] Linux agpgart interface v0.103
[    4.110509] AVX2 version of gcm_enc/dec engaged.
[    4.110517] AES CTR mode by8 optimization enabled
[    4.410943] [drm] Using P2A bridge for configuration
[    4.410956] [drm] AST 2400 detected
[    4.410969] [drm] Analog VGA only
[    4.410988] [drm] dram MCLK=408 Mhz type=1 bus_width=16 size=01000000
[    4.411077] [TTM] Zone  kernel: Available graphics memory: 16386288 kiB
[    4.411082] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    4.411085] [TTM] Initializing pool allocator
[    4.411094] [TTM] Initializing DMA pool allocator
[    4.514293] fbcon: astdrmfb (fb0) is primary device
[    4.555315] Console: switching to colour frame buffer device 200x75
[    4.598188] ast 0000:05:00.0: fb0: astdrmfb frame buffer device
[    4.643012] [drm] Initialized ast 0.1.0 20120228 for 0000:05:00.0 on minor 0
[    4.645647] NET: Registered protocol family 10
[    4.646601] IPv6: ADDRCONF(NETDEV_UP): eno1: link is not ready
[    4.646648] Segment Routing with IPv6
[    4.999179] power_meter ACPI000D:00: Found ACPI power meter.
[    4.999280] power_meter ACPI000D:00: hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    5.084456] power_meter ACPI000D:00: Found ACPI power meter.
[    5.084565] power_meter ACPI000D:00: Ignoring unsafe software power cap!
[    5.366735] Adding 16777212k swap on /dev/sda2.  Priority:-2 extents:1 across:16777212k FS
[    5.371174] Adding 16777212k swap on /dev/sdb2.  Priority:-3 extents:1 across:16777212k FS
[    5.408672] BTRFS info (device sda3): use lzo compression
[    5.408716] BTRFS info (device sda3): disk space caching is enabled
[    6.944421] RPC: Registered named UNIX socket transport module.
[    6.944505] RPC: Registered udp transport module.
[    6.944559] RPC: Registered tcp transport module.
[    6.944607] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    7.023594] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    7.941707] igb 0000:02:00.0 eno1: igb: eno1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[    8.047299] IPv6: ADDRCONF(NETDEV_CHANGE): eno1: link becomes ready
[  233.642673] ------------[ cut here ]------------
[  233.642750] WARNING: CPU: 1 PID: 3016 at fs/btrfs/ctree.h:1564 btrfs_update_device+0x189/0x190 [btrfs]
[  233.642819] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace sunrpc vfat fat ipv6 ast drm_kms_helper cfbfillrect x86_pkg_temp_thermal coretemp aesni_intel aes_x86_64 crypto_simd glue_helper syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea ttm drm agpgart intel_pch_thermal acpi_pad evdev acpi_power_meter btrfs xor zstd_decompress zstd_compress xxhash raid6_pq usb_storage hid_generic usbhid hid igb i2c_algo_bit xhci_pci xhci_hcd fan thermal
[  233.643201] CPU: 1 PID: 3016 Comm: rred Not tainted 4.14.9-toy-lxtec-amd64 #7
[  233.643251] Hardware name: Supermicro Super Server/X11SSM-F, BIOS 2.0b 07/28/2017
[  233.643305] task: ffff880849709040 task.stack: ffffc900039b4000
[  233.643372] RIP: 0010:btrfs_update_device+0x189/0x190 [btrfs]
[  233.643412] RSP: 0018:ffffc900039b7a98 EFLAGS: 00010206
[  233.643450] RAX: 0000000000000fff RBX: ffff8808519d17e0 RCX: 0000039f7b2d1e00
[  233.643500] RDX: 0000000000001000 RSI: ffff880000000000 RDI: ffff880846fe3460
[  233.643550] RBP: ffff88085107d000 R08: ffffc900039b7a50 R09: ffffc900039b7a58
[  233.643600] R10: 0000000000000003 R11: 0000000000003000 R12: 0000000000000000
[  233.643651] R13: 0000000000003f3c R14: ffff880846fe3460 R15: 00000000fffffff4
[  233.643702] FS:  00007fae234b2440(0000) GS:ffff880877840000(0000) knlGS:0000000000000000
[  233.643760] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  233.643800] CR2: 00007ffec568c000 CR3: 0000000849702003 CR4: 00000000003606e0
[  233.643850] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  233.643901] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  233.643951] Call Trace:
[  233.643994]  btrfs_finish_chunk_alloc+0x105/0x450 [btrfs]
[  233.644049]  ? btrfs_insert_item+0x69/0xc0 [btrfs]
[  233.644100]  btrfs_create_pending_block_groups+0x118/0x1e0 [btrfs]
[  233.644168]  __btrfs_end_transaction+0x89/0x2c0 [btrfs]
[  233.644224]  btrfs_alloc_data_chunk_ondemand+0xeb/0x220 [btrfs]
[  233.644282]  btrfs_check_data_free_space+0x4e/0xa0 [btrfs]
[  233.644345]  __btrfs_buffered_write.isra.4+0x18e/0x6c0 [btrfs]
[  233.644407]  btrfs_file_write_iter+0x1dc/0x540 [btrfs]
[  233.644450]  __vfs_write+0xc5/0x130
[  233.644476]  vfs_write+0xac/0x190
[  233.644500]  SyS_write+0x3d/0xa0
[  233.644523]  do_syscall_64+0x52/0x290
[  233.644550]  entry_SYSCALL64_slow_path+0x25/0x25
[  233.644583] RIP: 0033:0x7fae2244c7a0
[  233.644606] RSP: 002b:00007ffd3554c528 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  233.644661] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fae2244c7a0
[  233.644712] RDX: 0000000000001cb6 RSI: 00007fae232cf010 RDI: 0000000000000004
[  233.644763] RBP: 0000000000001cb6 R08: 0000000000000015 R09: 00007fae20c65060
[  233.644813] R10: 00000000000004fb R11: 0000000000000246 R12: 00007fae232cf010
[  233.644863] R13: 00007fae234b2378 R14: 0000559f96a96740 R15: 00007ffd355ccd70
[  233.644913] Code: 4c 89 f7 45 31 c0 ba 10 00 00 00 4c 89 ee e8 7f 48 ff ff 4c 89 f7 e8 77 4b fd ff e9 f2 fe ff ff 41 bc f4 ff ff ff e9 ef fe ff ff <0f> ff eb b7 0f 1f 00 53 31 d2 be 02 00 00 00 e8 73 b3 fc e0 48 
[  233.645127] ---[ end trace b03cd62c0a7d3c9b ]---
[  233.645365] ------------[ cut here ]------------
[  233.645437] WARNING: CPU: 4 PID: 3161 at fs/btrfs/ctree.h:1564 btrfs_update_device+0x189/0x190 [btrfs]
[  233.645505] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace sunrpc vfat fat ipv6 ast drm_kms_helper cfbfillrect x86_pkg_temp_thermal coretemp aesni_intel aes_x86_64 crypto_simd glue_helper syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea ttm drm agpgart intel_pch_thermal acpi_pad evdev acpi_power_meter btrfs xor zstd_decompress zstd_compress xxhash raid6_pq usb_storage hid_generic usbhid hid igb i2c_algo_bit xhci_pci xhci_hcd fan thermal
[  233.645883] CPU: 4 PID: 3161 Comm: store Tainted: G        W       4.14.9-toy-lxtec-amd64 #7
[  233.649293] Hardware name: Supermicro Super Server/X11SSM-F, BIOS 2.0b 07/28/2017
[  233.652683] task: ffff88084a7c3180 task.stack: ffffc9000407c000
[  233.656075] RIP: 0010:btrfs_update_device+0x189/0x190 [btrfs]
[  233.659449] RSP: 0018:ffffc9000407fa98 EFLAGS: 00010206
[  233.662833] RAX: 0000000000000fff RBX: ffff880853976b60 RCX: 0000039f7b2d1e00
[  233.666252] RDX: 0000000000001000 RSI: ffff880000000000 RDI: ffff880846fe3460
[  233.669670] RBP: ffff88085107d000 R08: ffffc9000407fa50 R09: ffffc9000407fa58
[  233.673095] R10: 0000000000000003 R11: 0000000000003000 R12: 0000000000000000
[  233.676538] R13: 0000000000003f3c R14: ffff880846fe3460 R15: 00000000fffffff4
[  233.679988] FS:  00007f812d8112c0(0000) GS:ffff880877900000(0000) knlGS:0000000000000000
[  233.683470] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  233.686952] CR2: 00007f812bc48088 CR3: 000000082a060006 CR4: 00000000003606e0
[  233.690439] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  233.693928] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  233.697397] Call Trace:
[  233.700865]  btrfs_finish_chunk_alloc+0x105/0x450 [btrfs]
[  233.704324]  ? btrfs_insert_item+0x69/0xc0 [btrfs]
[  233.707761]  btrfs_create_pending_block_groups+0x118/0x1e0 [btrfs]
[  233.711218]  __btrfs_end_transaction+0x89/0x2c0 [btrfs]
[  233.714656]  btrfs_alloc_data_chunk_ondemand+0xeb/0x220 [btrfs]
[  233.718090]  btrfs_check_data_free_space+0x4e/0xa0 [btrfs]
[  233.721535]  __btrfs_buffered_write.isra.4+0x18e/0x6c0 [btrfs]
[  233.724992]  btrfs_file_write_iter+0x1dc/0x540 [btrfs]
[  233.728437]  __vfs_write+0xc5/0x130
[  233.731251]  vfs_write+0xac/0x190
[  233.733482]  SyS_write+0x3d/0xa0
[  233.735695]  do_syscall_64+0x52/0x290
[  233.737884]  entry_SYSCALL64_slow_path+0x25/0x25
[  233.739776] RIP: 0033:0x7f812c7ab7a0
[  233.741310] RSP: 002b:00007ffc64760838 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  233.742814] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f812c7ab7a0
[  233.744312] RDX: 0000000000002d86 RSI: 000056017f5eeb60 RDI: 0000000000000004
[  233.745804] RBP: 0000000000002d86 R08: 000056017f612bc0 R09: 7478656b74676269
[  233.747283] R10: 0000000000001000 R11: 0000000000000246 R12: 000056017f5eeb60
[  233.748625] R13: 00007f812d8111f8 R14: 000056017f5d53d0 R15: 00007ffc64762140
[  233.749806] Code: 4c 89 f7 45 31 c0 ba 10 00 00 00 4c 89 ee e8 7f 48 ff ff 4c 89 f7 e8 77 4b fd ff e9 f2 fe ff ff 41 bc f4 ff ff ff e9 ef fe ff ff <0f> ff eb b7 0f 1f 00 53 31 d2 be 02 00 00 00 e8 73 b3 fc e0 48 
[  233.751083] ---[ end trace b03cd62c0a7d3c9c ]---
[  233.752406] ------------[ cut here ]------------
[  233.753672] WARNING: CPU: 3 PID: 3017 at fs/btrfs/ctree.h:1564 btrfs_update_device+0x189/0x190 [btrfs]
[  233.754935] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace sunrpc vfat fat ipv6 ast drm_kms_helper cfbfillrect x86_pkg_temp_thermal coretemp aesni_intel aes_x86_64 crypto_simd glue_helper syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea ttm drm agpgart intel_pch_thermal acpi_pad evdev acpi_power_meter btrfs xor zstd_decompress zstd_compress xxhash raid6_pq usb_storage hid_generic usbhid hid igb i2c_algo_bit xhci_pci xhci_hcd fan thermal
[  233.758709] CPU: 3 PID: 3017 Comm: rred Tainted: G        W       4.14.9-toy-lxtec-amd64 #7
[  233.759858] Hardware name: Supermicro Super Server/X11SSM-F, BIOS 2.0b 07/28/2017
[  233.761014] task: ffff880847866100 task.stack: ffffc90004064000
[  233.762189] RIP: 0010:btrfs_update_device+0x189/0x190 [btrfs]
[  233.763350] RSP: 0018:ffffc90004067a98 EFLAGS: 00010206
[  233.764508] RAX: 0000000000000fff RBX: ffff88085281df50 RCX: 0000039f7b2d1e00
[  233.765676] RDX: 0000000000001000 RSI: ffff880000000000 RDI: ffff880846fe3460
[  233.766739] RBP: ffff88085107d000 R08: ffffc90004067a50 R09: ffffc90004067a58
[  233.767735] R10: 0000000000000003 R11: 0000000000003000 R12: 0000000000000000
[  233.768731] R13: 0000000000003f3c R14: ffff880846fe3460 R15: 00000000fffffff4
[  233.769725] FS:  00007f749b93c440(0000) GS:ffff8808778c0000(0000) knlGS:0000000000000000
[  233.770725] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  233.771725] CR2: 00005581b85a7ff0 CR3: 00000008497ba003 CR4: 00000000003606e0
[  233.772732] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  233.773741] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  233.774751] Call Trace:
[  233.775693]  btrfs_finish_chunk_alloc+0x105/0x450 [btrfs]
[  233.776587]  ? btrfs_insert_item+0x69/0xc0 [btrfs]
[  233.777481]  btrfs_create_pending_block_groups+0x118/0x1e0 [btrfs]
[  233.778378]  __btrfs_end_transaction+0x89/0x2c0 [btrfs]
[  233.779271]  btrfs_alloc_data_chunk_ondemand+0xeb/0x220 [btrfs]
[  233.780164]  btrfs_check_data_free_space+0x4e/0xa0 [btrfs]
[  233.781061]  __btrfs_buffered_write.isra.4+0x18e/0x6c0 [btrfs]
[  233.781961]  btrfs_file_write_iter+0x1dc/0x540 [btrfs]
[  233.782858]  __vfs_write+0xc5/0x130
[  233.783728]  vfs_write+0xac/0x190
[  233.784519]  SyS_write+0x3d/0xa0
[  233.785264]  do_syscall_64+0x52/0x290
[  233.786000]  entry_SYSCALL64_slow_path+0x25/0x25
[  233.786714] RIP: 0033:0x7f749a8d67a0
[  233.787402] RSP: 002b:00007ffc39fba3e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  233.788077] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f749a8d67a0
[  233.788748] RDX: 0000000000002aa9 RSI: 0000558058b54310 RDI: 0000000000000004
[  233.789415] RBP: 0000000000002aa9 R08: 000000000000000a R09: 0000558058b84340
[  233.790076] R10: 0000000000000356 R11: 0000000000000246 R12: 0000558058b54310
[  233.790733] R13: 00007f749b93c378 R14: 0000558058b3d580 R15: 00007ffc3a03ac30
[  233.791390] Code: 4c 89 f7 45 31 c0 ba 10 00 00 00 4c 89 ee e8 7f 48 ff ff 4c 89 f7 e8 77 4b fd ff e9 f2 fe ff ff 41 bc f4 ff ff ff e9 ef fe ff ff <0f> ff eb b7 0f 1f 00 53 31 d2 be 02 00 00 00 e8 73 b3 fc e0 48 
[  233.792101] ---[ end trace b03cd62c0a7d3c9d ]---

--7aqv5h6oexvl25ma--
