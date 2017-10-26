Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21607 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932334AbdJZSq5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 14:46:57 -0400
Date: Thu, 26 Oct 2017 11:46:50 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: andreas.btrfs@diezwickers.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Kernel Oops / btrfs problems
Message-ID: <20171026184650.GA16082@dhcp-10-11-179-182.us.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <081ef871-f4fe-01e5-b8f8-285b2af6f6d0@diezwickers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <081ef871-f4fe-01e5-b8f8-285b2af6f6d0@diezwickers.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 25, 2017 at 02:05:48PM +0200, andreas.btrfs@diezwickers.de wrote:
> Hi,
> 
> I've had problems with a btrfs filesystem on a usb disk. I made a
> successfull backup of all data and created the filesystem from scratch.
> I'm not able to restore all backuped data because of a kernel oops.
> The problem is reproducible.
> 
> I've checked my RAM alreayd with memtest86 for 8h without any problems
> found.
> 
> Could you be so kind to provide any information to solve the problem?
> 
> Thanks for you help.
> 
> Andreas
> 
> uname -a
> ========
> Linux fatblock 4.12.0-0.bpo.2-amd64 #1 SMP Debian 4.12.13-1~bpo9+1
> (2017-09-28) x86_64 GNU/Linux
> 
> btrfs --version
> ===============
> btrfs-progs v4.9.1
> 
> btrfs fi df /mnt/archive/
> =========================
> Data, single: total=1.20TiB, used=1.20TiB
> System, DUP: total=40.00MiB, used=160.00KiB
> Metadata, DUP: total=3.50GiB, used=2.79GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> smartctl -a /dev/sdf
> ====================
> andi@fatblock:/etc/initramfs-tools$ sudo smartctl -a /dev/sdf
> smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.12.0-0.bpo.2-amd64] (local
> build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Model Family:     Seagate NAS HDD
> Device Model:     ST4000VN000-1H4168
> Serial Number:    Z300MKYZ
> LU WWN Device Id: 5 000c50 063dd0357
> Firmware Version: SC43
> User Capacity:    4.000.787.030.016 bytes [4,00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5900 rpm
> Form Factor:      3.5 inches
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Wed Oct 25 14:03:51 2017 CEST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> 
> General SMART Values:
> Offline data collection status:  (0x00)	Offline data collection activity
> 					was never started.
> 					Auto Offline Data Collection: Disabled.
> Self-test execution status:      (   0)	The previous self-test routine
> completed
> 					without error or no self-test has ever
> 					been run.
> Total time to complete Offline
> data collection: 		(  117) seconds.
> Offline data collection
> capabilities: 			 (0x73) SMART execute Offline immediate.
> 					Auto Offline data collection on/off support.
> 					Suspend Offline collection upon new
> 					command.
> 					No Offline surface scan supported.
> 					Self-test supported.
> 					Conveyance Self-test supported.
> 					Selective Self-test supported.
> SMART capabilities:            (0x0003)	Saves SMART data before entering
> 					power-saving mode.
> 					Supports SMART auto save timer.
> Error logging capability:        (0x01)	Error logging supported.
> 					General Purpose Logging supported.
> Short self-test routine
> recommended polling time: 	 (   1) minutes.
> Extended self-test routine
> recommended polling time: 	 ( 517) minutes.
> Conveyance self-test routine
> recommended polling time: 	 (   2) minutes.
> SCT capabilities: 	       (0x10bd)	SCT Status supported.
> 					SCT Error Recovery Control supported.
> 					SCT Feature Control supported.
> 					SCT Data Table supported.
> 
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED
> WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   109   099   006    Pre-fail Always
> -       23673928
>   3 Spin_Up_Time            0x0003   094   093   000    Pre-fail Always
> -       0
>   4 Start_Stop_Count        0x0032   078   078   020    Old_age Always
> -       23040
>   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail Always
> -       0
>   7 Seek_Error_Rate         0x000f   083   060   030    Pre-fail Always
> -       218165830
>   9 Power_On_Hours          0x0032   059   059   000    Old_age Always
> -       36667
>  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail Always
> -       0
>  12 Power_Cycle_Count       0x0032   100   100   020    Old_age Always
> -       31
> 184 End-to-End_Error        0x0032   100   100   099    Old_age   Always
> -       0
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always
> -       0
> 188 Command_Timeout         0x0032   100   099   000    Old_age   Always
> -       21475164165
> 189 High_Fly_Writes         0x003a   001   001   000    Old_age   Always
> -       1479
> 190 Airflow_Temperature_Cel 0x0022   074   056   045    Old_age   Always
> -       26 (Min/Max 21/40)
> 191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always
> -       0
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always
> -       30
> 193 Load_Cycle_Count        0x0032   058   058   000    Old_age   Always
> -       85601
> 194 Temperature_Celsius     0x0022   026   044   000    Old_age   Always
> -       26 (0 20 0 0 0)
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always
> -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age Offline
> -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always
> -       0
> 
> SMART Error Log Version: 1
> No Errors Logged
> 
> SMART Self-test log structure revision number 1
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
> 
> SMART Selective self-test log data structure revision number 1
>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>     1        0        0  Not_testing
>     2        0        0  Not_testing
>     3        0        0  Not_testing
>     4        0        0  Not_testing
>     5        0        0  Not_testing
> Selective self-test flags (0x0):
>   After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute delay.
> 
> 
> dmesg
> =====
> [    0.000000] microcode: microcode updated early to revision 0x22, date =
> 2017-01-27
> [    0.000000] Linux version 4.12.0-0.bpo.2-amd64
> (debian-kernel@lists.debian.org) (gcc version 6.3.0 20170516 (Debian
> 6.3.0-18) ) #1 SMP Debian 4.12.13-1~bpo9+1 (2017-09-28)
> [    0.000000] Command line: BOOT_IMAGE=/@/boot/vmlinuz-4.12.0-0.bpo.2-amd64
> root=UUID=9208425d-8927-4ca1-83f6-a946adb13588 ro rootflags=subvol=@
> cgroup_enable=memory swappaccount=1 pcie_aspm.policy=powersave
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point
> registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
> [    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
> [    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832
> bytes, using 'standard' format.
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000c6c80fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000c6c81000-0x00000000c6c87fff] ACPI
> NVS
> [    0.000000] BIOS-e820: [mem 0x00000000c6c88000-0x00000000c70cafff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000c70cb000-0x00000000c765bfff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000c765c000-0x00000000d8da7fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000d8da8000-0x00000000d8e3efff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000d8e3f000-0x00000000d8e90fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000d8e91000-0x00000000d8fc7fff] ACPI
> NVS
> [    0.000000] BIOS-e820: [mem 0x00000000d8fc8000-0x00000000d9ffefff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000d9fff000-0x00000000d9ffffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df1fffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011edfffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.8 present.
> [    0.000000] DMI: MSI MS-7823/H87M-G43 (MS-7823), BIOS V1.9 05/30/2015
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x11ee00 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CFFFF write-protect
> [    0.000000]   D0000-E7FFF uncachable
> [    0.000000]   E8000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0000000000 mask 7F00000000 write-back
> [    0.000000]   1 base 0100000000 mask 7FE0000000 write-back
> [    0.000000]   2 base 00E0000000 mask 7FE0000000 uncachable
> [    0.000000]   3 base 00DC000000 mask 7FFC000000 uncachable
> [    0.000000]   4 base 00DB000000 mask 7FFF000000 uncachable
> [    0.000000]   5 base 011F000000 mask 7FFF000000 uncachable
> [    0.000000]   6 base 011EE00000 mask 7FFFE00000 uncachable
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT
> [    0.000000] e820: update [mem 0xdb000000-0xffffffff] usable ==> reserved
> [    0.000000] e820: last_pfn = 0xda000 max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000fd7d0-0x000fd7df] mapped at
> [ffff9dad800fd7d0]
> [    0.000000] Base memory trampoline at [ffff9dad80097000] 97000 size 24576
> [    0.000000] Using GB pages for direct mapping
> [    0.000000] BRK [0x20754000, 0x20754fff] PGTABLE
> [    0.000000] BRK [0x20755000, 0x20755fff] PGTABLE
> [    0.000000] BRK [0x20756000, 0x20756fff] PGTABLE
> [    0.000000] BRK [0x20757000, 0x20757fff] PGTABLE
> [    0.000000] BRK [0x20758000, 0x20758fff] PGTABLE
> [    0.000000] BRK [0x20759000, 0x20759fff] PGTABLE
> [    0.000000] BRK [0x2075a000, 0x2075afff] PGTABLE
> [    0.000000] BRK [0x2075b000, 0x2075bfff] PGTABLE
> [    0.000000] BRK [0x2075c000, 0x2075cfff] PGTABLE
> [    0.000000] BRK [0x2075d000, 0x2075dfff] PGTABLE
> [    0.000000] BRK [0x2075e000, 0x2075efff] PGTABLE
> [    0.000000] BRK [0x2075f000, 0x2075ffff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x345bb000-0x362d4fff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x00000000000F04A0 000024 (v02 ALASKA)
> [    0.000000] ACPI: XSDT 0x00000000D8F99080 000084 (v01 ALASKA A M I
> 01072009 AMI  00010013)
> [    0.000000] ACPI: FACP 0x00000000D8FA69E0 00010C (v05 ALASKA A M I
> 01072009 AMI  00010013)
> [    0.000000] ACPI: DSDT 0x00000000D8F991A0 00D839 (v02 ALASKA A M I
> 00000036 INTL 20120711)
> [    0.000000] ACPI: FACS 0x00000000D8FC7F80 000040
> [    0.000000] ACPI: APIC 0x00000000D8FA6AF0 000092 (v03 ALASKA A M I
> 01072009 AMI  00010013)
> [    0.000000] ACPI: FPDT 0x00000000D8FA6B88 000044 (v01 ALASKA A M I
> 01072009 AMI  00010013)
> [    0.000000] ACPI: SSDT 0x00000000D8FA6BD0 000539 (v01 PmRef  Cpu0Ist
> 00003000 INTL 20120711)
> [    0.000000] ACPI: SSDT 0x00000000D8FA7110 000AD8 (v01 PmRef  CpuPm
> 00003000 INTL 20120711)
> [    0.000000] ACPI: MCFG 0x00000000D8FA7BE8 00003C (v01 ALASKA A M I
> 01072009 MSFT 00000097)
> [    0.000000] ACPI: HPET 0x00000000D8FA7C28 000038 (v01 ALASKA A M I
> 01072009 AMI. 00000005)
> [    0.000000] ACPI: SSDT 0x00000000D8FA7C60 00036D (v01 SataRe SataTabl
> 00001000 INTL 20120711)
> [    0.000000] ACPI: SSDT 0x00000000D8FA7FD0 003528 (v01 SaSsdt SaSsdt
> 00003000 INTL 20091112)
> [    0.000000] ACPI: ASF! 0x00000000D8FAB4F8 0000A5 (v32 INTEL   HCG
> 00000001 TFSM 000F4240)
> [    0.000000] ACPI: DMAR 0x00000000D8FAB5A0 0000B8 (v01 INTEL  HSW 00000001
> INTL 00000001)
> [    0.000000] ACPI: SSDT 0x00000000D8FAB658 000A26 (v01 Intel_ IsctTabl
> 00001000 INTL 20120711)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011edfffff]
> [    0.000000] NODE_DATA(0) allocated [mem 0x11edfb000-0x11edfffff]
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> [    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
> [    0.000000]   Normal   [mem 0x0000000100000000-0x000000011edfffff]
> [    0.000000]   Device   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
> [    0.000000]   node   0: [mem 0x0000000000100000-0x00000000c6c80fff]
> [    0.000000]   node   0: [mem 0x00000000c6c88000-0x00000000c70cafff]
> [    0.000000]   node   0: [mem 0x00000000c765c000-0x00000000d8da7fff]
> [    0.000000]   node   0: [mem 0x00000000d8e3f000-0x00000000d8e90fff]
> [    0.000000]   node   0: [mem 0x00000000d9fff000-0x00000000d9ffffff]
> [    0.000000]   node   0: [mem 0x0000000100000000-0x000000011edfffff]
> [    0.000000] Initmem setup node 0 [mem
> 0x0000000000001000-0x000000011edfffff]
> [    0.000000] On node 0 totalpages: 1013247
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3996 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 13794 pages used for memmap
> [    0.000000]   DMA32 zone: 882787 pages, LIFO batch:31
> [    0.000000]   Normal zone: 1976 pages used for memmap
> [    0.000000]   Normal zone: 126464 pages, LIFO batch:31
> [    0.000000] Reserving Intel graphics memory at
> 0x00000000db200000-0x00000000df1fffff
> [    0.000000] ACPI: PM-Timer IO Port: 0x1808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
> [    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI
> 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
> [    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
> [    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
> [    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xc6c81000-0xc6c87fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xc70cb000-0xc765bfff]
> [    0.000000] PM: Registered nosave memory: [mem 0xd8da8000-0xd8e3efff]
> [    0.000000] PM: Registered nosave memory: [mem 0xd8e91000-0xd8fc7fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xd8fc8000-0xd9ffefff]
> [    0.000000] PM: Registered nosave memory: [mem 0xda000000-0xdaffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdb000000-0xdf1fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdf200000-0xf7ffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
> [    0.000000] e820: [mem 0xdf200000-0xf7ffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles:
> 0xffffffff, max_idle_ns: 7645519600211568 ns
> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8
> nr_node_ids:1
> [    0.000000] percpu: Embedded 38 pages/cpu @ffff9dae9ea00000 s114840 r8192
> d32616 u262144
> [    0.000000] pcpu-alloc: s114840 r8192 d32616 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on. Total
> pages: 997392
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line:
> BOOT_IMAGE=/@/boot/vmlinuz-4.12.0-0.bpo.2-amd64
> root=UUID=9208425d-8927-4ca1-83f6-a946adb13588 ro rootflags=subvol=@
> cgroup_enable=memory swappaccount=1 pcie_aspm.policy=powersave
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] Memory: 3874576K/4052988K available (6485K kernel code, 1145K
> rwdata, 2908K rodata, 1468K init, 704K bss, 178412K reserved, 0K
> cma-reserved)
> [    0.000000] ftrace: allocating 28157 entries in 110 pages
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=8.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
> [    0.000000] NR_IRQS:33024 nr_irqs:488 16
> [    0.000000] spurious 8259A interrupt: IRQ7.
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff,
> max_idle_ns: 133484882848 ns
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.004000] tsc: Detected 3399.816 MHz processor
> [    0.004000] Calibrating delay loop (skipped), value calculated using
> timer frequency.. 6799.63 BogoMIPS (lpj=13599264)
> [    0.004000] pid_max: default: 32768 minimum: 301
> [    0.004000] ACPI: Core revision 20170303
> [    0.012103] ACPI: 6 ACPI AML tables successfully acquired and loaded
> [    0.012192] Security Framework initialized
> [    0.012247] Yama: disabled by default; enable with sysctl kernel.yama.*
> [    0.012309] AppArmor: AppArmor disabled by boot time parameter
> [    0.012495] Dentry cache hash table entries: 524288 (order: 10, 4194304
> bytes)
> [    0.013124] Inode-cache hash table entries: 262144 (order: 9, 2097152
> bytes)
> [    0.013462] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
> [    0.013523] Mountpoint-cache hash table entries: 8192 (order: 4, 65536
> bytes)
> [    0.013734] CPU: Physical Processor ID: 0
> [    0.013789] CPU: Processor Core ID: 0
> [    0.013845] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.013903] ENERGY_PERF_BIAS: View and update with
> x86_energy_perf_policy(8)
> [    0.013964] mce: CPU supports 9 MCE banks
> [    0.014025] CPU0: Thermal monitoring enabled (TM1)
> [    0.014089] process: using mwait in idle threads
> [    0.014146] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
> [    0.014204] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
> [    0.014347] Freeing SMP alternatives memory: 24K
> [    0.016053] smpboot: Max logical packages: 2
> [    0.016110] DMAR: Host address width 39
> [    0.016164] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
> [    0.020017] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap
> c0000020660462 ecap f0101a
> [    0.020088] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
> [    0.020146] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap
> d2008020660462 ecap f010da
> [    0.020218] DMAR: RMRR base: 0x000000d9ea4000 end: 0x000000d9eb2fff
> [    0.020277] DMAR: RMRR base: 0x000000db000000 end: 0x000000df1fffff
> [    0.020336] DMAR-IR: IOAPIC id 8 under DRHD base  0xfed91000 IOMMU 1
> [    0.020393] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
> [    0.020450] DMAR-IR: Queued invalidation will be enabled to support
> x2apic and Intr-remapping.
> [    0.020788] DMAR-IR: Enabled IRQ remapping in x2apic mode
> [    0.020845] x2apic enabled
> [    0.020899] Switched APIC routing to cluster x2apic.
> [    0.021368] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.061167] TSC deadline timer enabled
> [    0.061170] smpboot: CPU0: Intel(R) Xeon(R) CPU E3-1245 v3 @ 3.40GHz
> (family: 0x6, model: 0x3c, stepping: 0x3)
> [    0.061286] Performance Events: PEBS fmt2+, Haswell events, 16-deep LBR,
> full-width counters, Intel PMU driver.
> [    0.062124] ... version:                3
> [    0.062178] ... bit width:              48
> [    0.062232] ... generic registers:      4
> [    0.062287] ... value mask:             0000ffffffffffff
> [    0.062343] ... max period:             00007fffffffffff
> [    0.062399] ... fixed-purpose events:   3
> [    0.062453] ... event mask:             000000070000000f
> [    0.062913] NMI watchdog: enabled on all CPUs, permanently consumes one
> hw-PMU counter.
> [    0.062995] smp: Bringing up secondary CPUs ...
> [    0.063104] x86: Booting SMP configuration:
> [    0.063158] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
> [    0.620014] smp: Brought up 1 node, 8 CPUs
> [    0.620114] smpboot: Total of 8 processors activated (54404.80 BogoMIPS)
> [    0.624109] sched_clock: Marking stable (624000000, 0)->(626588257,
> -2588257)
> [    0.624339] devtmpfs: initialized
> [    0.624429] x86/mm: Memory block size: 128MB
> [    0.625695] PM: Registering ACPI NVS region [mem 0xc6c81000-0xc6c87fff]
> (28672 bytes)
> [    0.625769] PM: Registering ACPI NVS region [mem 0xd8e91000-0xd8fc7fff]
> (1273856 bytes)
> [    0.625897] clocksource: jiffies: mask: 0xffffffff max_cycles:
> 0xffffffff, max_idle_ns: 7645041785100000 ns
> [    0.625981] futex hash table entries: 2048 (order: 5, 131072 bytes)
> [    0.626085] pinctrl core: initialized pinctrl subsystem
> [    0.626215] NET: Registered protocol family 16
> [    0.626390] cpuidle: using governor ladder
> [    0.626460] cpuidle: using governor menu
> [    0.626517] PCCT header not found.
> [    0.626597] ACPI FADT declares the system doesn't support PCIe ASPM, so
> disable it
> [    0.626669] ACPI: bus type PCI registered
> [    0.626723] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.626825] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
> 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.626900] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> [    0.626962] pmd_set_huge: Cannot satisfy [mem 0xf8000000-0xf8200000] with
> a huge-page mapping due to MTRR override.
> [    0.627082] PCI: Using configuration type 1 for base access
> [    0.627179] core: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
> [    0.627858] HugeTLB registered 1 GB page size, pre-allocated 0 pages
> [    0.627917] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.628130] ACPI: Added _OSI(Module Device)
> [    0.628186] ACPI: Added _OSI(Processor Device)
> [    0.628241] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.628297] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.628488] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.631523] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
> [    0.632192] ACPI: Dynamic OEM Table Load:
> [    0.632251] ACPI: SSDT 0xFFFF9DAE9907C000 0003D3 (v01 PmRef  Cpu0Cst
> 00003001 INTL 20120711)
> [    0.632587] ACPI: Dynamic OEM Table Load:
> [    0.632645] ACPI: SSDT 0xFFFF9DAE9921B000 0005AA (v01 PmRef  ApIst
> 00003000 INTL 20120711)
> [    0.633009] ACPI: Dynamic OEM Table Load:
> [    0.633067] ACPI: SSDT 0xFFFF9DAE9928E000 000119 (v01 PmRef  ApCst
> 00003000 INTL 20120711)
> [    0.634425] ACPI: Interpreter enabled
> [    0.634500] ACPI: (supports S0 S3 S4 S5)
> [    0.634554] ACPI: Using IOAPIC for interrupt routing
> [    0.634627] PCI: Using host bridge windows from ACPI; if necessary, use
> "pci=nocrs" and report a bug
> [    0.641764] ACPI: Power Resource [FN00] (off)
> [    0.641871] ACPI: Power Resource [FN01] (off)
> [    0.641975] ACPI: Power Resource [FN02] (off)
> [    0.642076] ACPI: Power Resource [FN03] (off)
> [    0.642177] ACPI: Power Resource [FN04] (off)
> [    0.642728] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
> [    0.642789] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
> ClockPM Segments MSI]
> [    0.643017] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug
> PME]
> [    0.643175] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
> [    0.643234] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using
> BIOS configuration
> [    0.643577] PCI host bridge to bus 0000:00
> [    0.643632] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
> [    0.643691] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
> [    0.643750] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff
> window]
> [    0.643822] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff
> window]
> [    0.643894] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff
> window]
> [    0.643965] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff
> window]
> [    0.644038] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff
> window]
> [    0.644110] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff
> window]
> [    0.644182] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff
> window]
> [    0.644253] pci_bus 0000:00: root bus resource [mem 0xdf200000-0xfeafffff
> window]
> [    0.644325] pci_bus 0000:00: root bus resource [bus 00-3e]
> [    0.644386] pci 0000:00:00.0: [8086:0c08] type 00 class 0x060000
> [    0.644447] pci 0000:00:02.0: [8086:041a] type 00 class 0x030000
> [    0.644454] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
> [    0.644458] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit
> pref]
> [    0.644460] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
> [    0.644514] pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
> [    0.644519] pci 0000:00:03.0: reg 0x10: [mem 0xf7e14000-0xf7e17fff 64bit]
> [    0.644592] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
> [    0.644606] pci 0000:00:14.0: reg 0x10: [mem 0xf7e00000-0xf7e0ffff 64bit]
> [    0.644655] pci 0000:00:14.0: PME# supported from D3hot D3cold
> [    0.644683] pci 0000:00:14.0: System wakeup disabled by ACPI
> [    0.644764] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
> [    0.644778] pci 0000:00:16.0: reg 0x10: [mem 0xf7e1e000-0xf7e1e00f 64bit]
> [    0.644830] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    0.644884] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
> [    0.644898] pci 0000:00:1a.0: reg 0x10: [mem 0xf7e1c000-0xf7e1c3ff]
> [    0.644967] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    0.645007] pci 0000:00:1a.0: System wakeup disabled by ACPI
> [    0.645087] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
> [    0.645100] pci 0000:00:1b.0: reg 0x10: [mem 0xf7e10000-0xf7e13fff 64bit]
> [    0.645157] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.645189] pci 0000:00:1b.0: System wakeup disabled by ACPI
> [    0.645267] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
> [    0.645327] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.645384] pci 0000:00:1c.0: System wakeup disabled by ACPI
> [    0.645465] pci 0000:00:1c.4: [8086:8c18] type 01 class 0x060400
> [    0.645519] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.645570] pci 0000:00:1c.4: System wakeup disabled by ACPI
> [    0.645649] pci 0000:00:1c.5: [8086:8c1a] type 01 class 0x060400
> [    0.645702] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
> [    0.645752] pci 0000:00:1c.5: System wakeup disabled by ACPI
> [    0.645833] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
> [    0.645848] pci 0000:00:1d.0: reg 0x10: [mem 0xf7e1b000-0xf7e1b3ff]
> [    0.645917] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    0.645955] pci 0000:00:1d.0: System wakeup disabled by ACPI
> [    0.646034] pci 0000:00:1f.0: [8086:8c4a] type 00 class 0x060100
> [    0.646164] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
> [    0.646174] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
> [    0.646180] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
> [    0.646186] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
> [    0.646192] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
> [    0.646197] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
> [    0.646203] pci 0000:00:1f.2: reg 0x24: [mem 0xf7e1a000-0xf7e1a7ff]
> [    0.646232] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.646275] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
> [    0.646287] pci 0000:00:1f.3: reg 0x10: [mem 0xf7e19000-0xf7e190ff 64bit]
> [    0.646303] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
> [    0.646404] acpiphp: Slot [1] registered
> [    0.646462] pci 0000:00:1c.0: PCI bridge to [bus 01]
> [    0.646577] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
> [    0.646599] pci 0000:02:00.0: reg 0x10: [io  0xe000-0xe0ff]
> [    0.646625] pci 0000:02:00.0: reg 0x18: [mem 0xf7d00000-0xf7d00fff 64bit]
> [    0.646640] pci 0000:02:00.0: reg 0x20: [mem 0xf0000000-0xf0003fff 64bit
> pref]
> [    0.646726] pci 0000:02:00.0: supports D1 D2
> [    0.646726] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.646765] pci 0000:02:00.0: System wakeup disabled by ACPI
> [    0.656059] pci 0000:00:1c.4: PCI bridge to [bus 02]
> [    0.656117] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
> [    0.656119] pci 0000:00:1c.4:   bridge window [mem 0xf7d00000-0xf7dfffff]
> [    0.656123] pci 0000:00:1c.4:   bridge window [mem 0xf0000000-0xf00fffff
> 64bit pref]
> [    0.656183] pci 0000:03:00.0: [dd01:0003] type 00 class 0x048000
> [    0.656214] pci 0000:03:00.0: reg 0x10: [mem 0xf7c00000-0xf7c0ffff 64bit]
> [    0.656354] pci 0000:03:00.0: System wakeup disabled by ACPI
> [    0.668057] pci 0000:00:1c.5: PCI bridge to [bus 03]
> [    0.668115] pci 0000:00:1c.5:   bridge window [mem 0xf7c00000-0xf7cfffff]
> [    0.668660] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14
> 15)
> [    0.668753] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 *11 12 14
> 15)
> [    0.668843] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14
> 15)
> [    0.668934] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14
> 15)
> [    0.669023] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15)
> *0, disabled.
> [    0.669128] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15)
> *0, disabled.
> [    0.669232] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14
> 15)
> [    0.669322] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14
> 15)
> [    0.669619] ACPI: Enabled 4 GPEs in block 00 to 3F
> [    0.669736] pci 0000:00:02.0: vgaarb: setting as boot VGA device
> [    0.669795] pci 0000:00:02.0: vgaarb: VGA device added:
> decodes=io+mem,owns=io+mem,locks=none
> [    0.669869] pci 0000:00:02.0: vgaarb: bridge control possible
> [    0.669925] vgaarb: loaded
> [    0.670000] EDAC MC: Ver: 3.0.0
> [    0.670127] PCI: Using ACPI for IRQ routing
> [    0.671326] PCI: pci_cache_line_size set to 64 bytes
> [    0.671358] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
> [    0.671359] e820: reserve RAM buffer [mem 0xc6c81000-0xc7ffffff]
> [    0.671360] e820: reserve RAM buffer [mem 0xc70cb000-0xc7ffffff]
> [    0.671360] e820: reserve RAM buffer [mem 0xd8da8000-0xdbffffff]
> [    0.671361] e820: reserve RAM buffer [mem 0xd8e91000-0xdbffffff]
> [    0.671362] e820: reserve RAM buffer [mem 0xda000000-0xdbffffff]
> [    0.671362] e820: reserve RAM buffer [mem 0x11ee00000-0x11fffffff]
> [    0.671463] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    0.671524] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    0.673597] clocksource: Switched to clocksource hpet
> [    0.679243] VFS: Disk quotas dquot_6.6.0
> [    0.679309] VFS: Dquot-cache hash table entries: 512 (order 0, 4096
> bytes)
> [    0.679412] pnp: PnP ACPI init
> [    0.679511] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
> [    0.679572] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.679691] system 00:01: [io  0x0680-0x069f] has been reserved
> [    0.679749] system 00:01: [io  0xffff] has been reserved
> [    0.679806] system 00:01: [io  0xffff] has been reserved
> [    0.679863] system 00:01: [io  0xffff] has been reserved
> [    0.679919] system 00:01: [io  0x1c00-0x1cfe] has been reserved
> [    0.679976] system 00:01: [io  0x1d00-0x1dfe] has been reserved
> [    0.680034] system 00:01: [io  0x1e00-0x1efe] has been reserved
> [    0.680091] system 00:01: [io  0x1f00-0x1ffe] has been reserved
> [    0.680149] system 00:01: [io  0x1800-0x18fe] has been reserved
> [    0.680207] system 00:01: [io  0x164e-0x164f] has been reserved
> [    0.680265] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.680278] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.680308] system 00:03: [io  0x1854-0x1857] has been reserved
> [    0.680366] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02
> (active)
> [    0.680437] system 00:04: [io  0x0a00-0x0a0f] has been reserved
> [    0.680494] system 00:04: [io  0x0a10-0x0a1f] has been reserved
> [    0.680552] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.680653] pnp 00:05: [dma 0 disabled]
> [    0.680679] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.680835] pnp 00:06: [dma 0 disabled]
> [    0.680890] pnp 00:06: Plug and Play ACPI device, IDs PNP0400 (active)
> [    0.680919] system 00:07: [io  0x04d0-0x04d1] has been reserved
> [    0.680979] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.681253] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.681312] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
> [    0.681371] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.681430] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.681489] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.681549] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    0.681617] system 00:08: [mem 0xfed90000-0xfed93fff] could not be
> reserved
> [    0.681676] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    0.681734] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
> [    0.681793] system 00:08: [mem 0xfee00000-0xfeefffff] could not be
> reserved
> [    0.681852] system 00:08: [mem 0xf7fdf000-0xf7fdffff] has been reserved
> [    0.681910] system 00:08: [mem 0xf7fe0000-0xf7feffff] has been reserved
> [    0.681970] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.682115] pnp: PnP ACPI: found 9 devices
> [    0.687863] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff,
> max_idle_ns: 2085701024 ns
> [    0.687947] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus
> 01] add_size 1000
> [    0.687949] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff
> 64bit pref] to [bus 01] add_size 200000 add_align 100000
> [    0.687950] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff]
> to [bus 01] add_size 200000 add_align 100000
> [    0.687965] pci 0000:00:1c.0: BAR 14: assigned [mem
> 0xdf200000-0xdf3fffff]
> [    0.688028] pci 0000:00:1c.0: BAR 15: assigned [mem 0xdf400000-0xdf5fffff
> 64bit pref]
> [    0.688101] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
> [    0.688159] pci 0000:00:1c.0: PCI bridge to [bus 01]
> [    0.688215] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
> [    0.688275] pci 0000:00:1c.0:   bridge window [mem 0xdf200000-0xdf3fffff]
> [    0.688335] pci 0000:00:1c.0:   bridge window [mem 0xdf400000-0xdf5fffff
> 64bit pref]
> [    0.688411] pci 0000:00:1c.4: PCI bridge to [bus 02]
> [    0.688467] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
> [    0.688526] pci 0000:00:1c.4:   bridge window [mem 0xf7d00000-0xf7dfffff]
> [    0.688587] pci 0000:00:1c.4:   bridge window [mem 0xf0000000-0xf00fffff
> 64bit pref]
> [    0.688662] pci 0000:00:1c.5: PCI bridge to [bus 03]
> [    0.688721] pci 0000:00:1c.5:   bridge window [mem 0xf7c00000-0xf7cfffff]
> [    0.688784] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
> [    0.688785] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
> [    0.688785] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff
> window]
> [    0.688786] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff
> window]
> [    0.688787] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff
> window]
> [    0.688787] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff
> window]
> [    0.688788] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff
> window]
> [    0.688788] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff
> window]
> [    0.688789] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff
> window]
> [    0.688790] pci_bus 0000:00: resource 13 [mem 0xdf200000-0xfeafffff
> window]
> [    0.688790] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
> [    0.688791] pci_bus 0000:01: resource 1 [mem 0xdf200000-0xdf3fffff]
> [    0.688792] pci_bus 0000:01: resource 2 [mem 0xdf400000-0xdf5fffff 64bit
> pref]
> [    0.688792] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
> [    0.688793] pci_bus 0000:02: resource 1 [mem 0xf7d00000-0xf7dfffff]
> [    0.688794] pci_bus 0000:02: resource 2 [mem 0xf0000000-0xf00fffff 64bit
> pref]
> [    0.688794] pci_bus 0000:03: resource 1 [mem 0xf7c00000-0xf7cfffff]
> [    0.688867] NET: Registered protocol family 2
> [    0.689018] TCP established hash table entries: 32768 (order: 6, 262144
> bytes)
> [    0.689880] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
> [    0.690009] TCP: Hash tables configured (established 32768 bind 32768)
> [    0.690091] UDP hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.690159] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.690258] NET: Registered protocol family 1
> [    0.690320] pci 0000:00:02.0: Video device with shadowed ROM at [mem
> 0x000c0000-0x000dffff]
> [    0.690720] PCI: CLS 64 bytes, default 64
> [    0.690743] Unpacking initramfs...
> [    1.028870] Freeing initrd memory: 29800K
> [    1.028965] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    1.029025] software IO TLB [mem 0xd4da8000-0xd8da8000] (64MB) mapped at
> [ffff9dae54da8000-ffff9dae58da7fff]
> [    1.029421] audit: initializing netlink subsys (disabled)
> [    1.029527] audit: type=2000 audit(1508909884.027:1): state=initialized
> audit_enabled=0 res=1
> [    1.029769] workingset: timestamp_bits=40 max_order=20 bucket_order=0
> [    1.029887] zbud: loaded
> [    1.245581] Key type asymmetric registered
> [    1.245643] Asymmetric key parser 'x509' registered
> [    1.245708] Block layer SCSI generic (bsg) driver version 0.4 loaded
> (major 249)
> [    1.245804] io scheduler noop registered
> [    1.245859] io scheduler deadline registered
> [    1.245919] io scheduler cfq registered (default)
> [    1.245975] io scheduler mq-deadline registered
> [    1.246400] intel_idle: MWAIT substates: 0x42120
> [    1.246401] intel_idle: v0.4.1 model 0x3C
> [    1.246604] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    1.246732] GHES: HEST is not enabled!
> [    1.246826] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    1.267290] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a
> 16550A
> [    1.267621] Linux agpgart interface v0.103
> [    1.267722] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
> [    1.267780] AMD IOMMUv2 functionality not available on this system
> [    1.268258] i8042: PNP: No PS/2 controller found.
> [    1.268353] mousedev: PS/2 mouse device common for all mice
> [    1.268432] rtc_cmos 00:02: RTC can wake from S4
> [    1.268582] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> [    1.268664] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram,
> hpet irqs
> [    1.268743] intel_pstate: Intel P-state driver initializing
> [    1.269211] ledtrig-cpu: registered to indicate activity on CPUs
> [    1.270308] NET: Registered protocol family 10
> [    1.270860] Segment Routing with IPv6
> [    1.270977] mip6: Mobile IPv6
> [    1.271061] NET: Registered protocol family 17
> [    1.271151] mpls_gso: MPLS GSO support
> [    1.272384] microcode: sig=0x306c3, pf=0x2, revision=0x22
> [    1.272779] microcode: Microcode Update Driver: v2.2.
> [    1.273222] registered taskstats version 1
> [    1.273439] zswap: loaded using pool lzo/zbud
> [    1.273807] ima: No TPM chip found, activating TPM-bypass! (rc=-19)
> [    1.274765] rtc_cmos 00:02: setting system clock to 2017-10-25 05:38:05
> UTC (1508909885)
> [    1.275005] PM: Hibernation image not present or could not be loaded.
> [    1.278313] Freeing unused kernel memory: 1468K
> [    1.278402] Write protecting the kernel read-only data: 12288k
> [    1.279576] Freeing unused kernel memory: 1692K
> [    1.282963] Freeing unused kernel memory: 1188K
> [    1.283817] x86/mm: Checked W+X mappings: passed, no W+X pages found.
> [    1.292098] random: systemd-udevd: uninitialized urandom read (16 bytes
> read)
> [    1.292226] random: systemd-udevd: uninitialized urandom read (16 bytes
> read)
> [    1.292296] random: systemd-udevd: uninitialized urandom read (16 bytes
> read)
> [    1.292368] random: systemd-udevd: uninitialized urandom read (16 bytes
> read)
> [    1.292767] random: udevadm: uninitialized urandom read (16 bytes read)
> [    1.292855] random: udevadm: uninitialized urandom read (16 bytes read)
> [    1.293776] random: udevadm: uninitialized urandom read (16 bytes read)
> [    1.293880] random: udevadm: uninitialized urandom read (16 bytes read)
> [    1.293980] random: udevadm: uninitialized urandom read (16 bytes read)
> [    1.294077] random: udevadm: uninitialized urandom read (16 bytes read)
> [    1.307606] input: Power Button as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
> [    1.307695] ACPI: Power Button [PWRB]
> [    1.307795] input: Power Button as
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    1.307881] ACPI: Power Button [PWRF]
> [    1.310186] wmi: Mapper loaded
> [    1.314358] (NULL device *): hwmon_device_register() is deprecated.
> Please convert the driver to use hwmon_device_register_with_info().
> [    1.314573] thermal LNXTHERM:00: registered as thermal_zone0
> [    1.314642] ACPI: Thermal Zone [TZ00] (28 C)
> [    1.314994] thermal LNXTHERM:01: registered as thermal_zone1
> [    1.315065] ACPI: Thermal Zone [TZ01] (30 C)
> [    1.315564] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [    1.315633] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM
> control
> [    1.315863] i801_smbus 0000:00:1f.3: SPD Write Disable is set
> [    1.315954] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
> [    1.316158] ACPI: bus type USB registered
> [    1.316251] usbcore: registered new interface driver usbfs
> [    1.316338] usbcore: registered new interface driver hub
> [    1.316435] usbcore: registered new device driver usb
> [    1.316904] SCSI subsystem initialized
> [    1.317125] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    1.317672] ehci-pci: EHCI PCI platform driver
> [    1.317826] ehci-pci 0000:00:1a.0: EHCI Host Controller
> [    1.317899] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus
> number 1
> [    1.317984] ehci-pci 0000:00:1a.0: debug port 2
> [    1.319584] AVX2 version of gcm_enc/dec engaged.
> [    1.319677] AES CTR mode by8 optimization enabled
> [    1.321940] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
> [    1.321963] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7e1c000
> [    1.322068] libata version 3.00 loaded.
> [    1.326542] r8169 0000:02:00.0 eth0: RTL8168g/8111g at
> 0xffffbf5200659000, d4:3d:7e:da:35:2c, XID 0c000800 IRQ 26
> [    1.326635] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes,
> tx checksumming: ko]
> [    1.337659] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    1.338019] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.338092] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    1.338166] usb usb1: Product: EHCI Host Controller
> [    1.338224] usb usb1: Manufacturer: Linux 4.12.0-0.bpo.2-amd64 ehci_hcd
> [    1.338285] usb usb1: SerialNumber: 0000:00:1a.0
> [    1.338541] hub 1-0:1.0: USB hub found
> [    1.338637] hub 1-0:1.0: 2 ports detected
> [    1.339102] ehci-pci 0000:00:1d.0: EHCI Host Controller
> [    1.339164] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus
> number 2
> [    1.339247] ehci-pci 0000:00:1d.0: debug port 2
> [    1.343208] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
> [    1.343219] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7e1b000
> [    1.357714] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    1.357831] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.357896] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    1.357975] usb usb2: Product: EHCI Host Controller
> [    1.358036] usb usb2: Manufacturer: Linux 4.12.0-0.bpo.2-amd64 ehci_hcd
> [    1.358100] usb usb2: SerialNumber: 0000:00:1d.0
> [    1.358381] hub 2-0:1.0: USB hub found
> [    1.358445] hub 2-0:1.0: 2 ports detected
> [    1.358817] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    1.358890] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus
> number 3
> [    1.360064] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version
> 0x100 quirks 0x00009810
> [    1.360155] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
> [    1.360267] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [    1.360335] usb usb3: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    1.360417] usb usb3: Product: xHCI Host Controller
> [    1.360480] usb usb3: Manufacturer: Linux 4.12.0-0.bpo.2-amd64 xhci-hcd
> [    1.360547] usb usb3: SerialNumber: 0000:00:14.0
> [    1.360805] hub 3-0:1.0: USB hub found
> [    1.360885] hub 3-0:1.0: 14 ports detected
> [    1.363154] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    1.363222] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus
> number 4
> [    1.363342] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [    1.363409] usb usb4: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    1.363491] usb usb4: Product: xHCI Host Controller
> [    1.363553] usb usb4: Manufacturer: Linux 4.12.0-0.bpo.2-amd64 xhci-hcd
> [    1.363620] usb usb4: SerialNumber: 0000:00:14.0
> [    1.363889] hub 4-0:1.0: USB hub found
> [    1.363966] hub 4-0:1.0: 6 ports detected
> [    1.364588] ahci 0000:00:1f.2: version 3.0
> [    1.364841] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps
> 0x3d impl SATA mode
> [    1.364928] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part
> ems apst
> [    1.411354] scsi host0: ahci
> [    1.411801] scsi host1: ahci
> [    1.412207] scsi host2: ahci
> [    1.412623] scsi host3: ahci
> [    1.412938] scsi host4: ahci
> [    1.413205] scsi host5: ahci
> [    1.413342] ata1: SATA max UDMA/133 abar m2048@0xf7e1a000 port 0xf7e1a100
> irq 28
> [    1.413452] ata2: DUMMY
> [    1.413524] ata3: SATA max UDMA/133 abar m2048@0xf7e1a000 port 0xf7e1a200
> irq 28
> [    1.413630] ata4: SATA max UDMA/133 abar m2048@0xf7e1a000 port 0xf7e1a280
> irq 28
> [    1.413750] ata5: SATA max UDMA/133 abar m2048@0xf7e1a000 port 0xf7e1a300
> irq 28
> [    1.413854] ata6: SATA max UDMA/133 abar m2048@0xf7e1a000 port 0xf7e1a380
> irq 28
> [    1.414496] [drm] Memory usable by graphics device = 2048M
> [    1.414581] [drm] Replacing VGA console driver
> [    1.415471] Console: switching to colour dummy device 80x25
> [    1.422280] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    1.422288] [drm] Driver supports precise vblank timestamp query.
> [    1.425041] i915 0000:00:02.0: vgaarb: changed VGA decodes:
> olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    1.432259] [drm] Initialized i915 1.6.0 20170403 for 0000:00:02.0 on
> minor 0
> [    1.434877] ACPI: Video Device [GFX0] (multi-head: yes  rom: no post: no)
> [    1.435786] acpi device:62: registered as cooling_device13
> [    1.435914] input: Video Bus as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
> [    1.533225] fbcon: inteldrmfb (fb0) is primary device
> [    1.603498] Console: switching to colour frame buffer device 128x48
> [    1.623924] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [    1.665764] usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    1.685762] usb 2-1: new high-speed USB device number 2 using ehci-pci
> [    1.689949] usb 4-1: new SuperSpeed USB device number 2 using xhci_hcd
> [    1.711288] usb 4-1: New USB device found, idVendor=174c, idProduct=5106
> [    1.711354] usb 4-1: New USB device strings: Mfr=2, Product=3,
> SerialNumber=1
> [    1.711409] usb 4-1: Product: AS2105
> [    1.711439] usb 4-1: Manufacturer: ASMedia
> [    1.711473] usb 4-1: SerialNumber:             Z300MKYZ
> [    1.715264] usb-storage 4-1:1.0: USB Mass Storage device detected
> [    1.715546] scsi host6: usb-storage 4-1:1.0
> [    1.715698] usbcore: registered new interface driver usb-storage
> [    1.716317] usbcore: registered new interface driver uas
> [    1.729508] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.729594] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.729651] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.729749] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.729804] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.731284] ata5.00: ATA-10: ST4000VN000-2AH166, SC60, max UDMA/133
> [    1.731354] ata5.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth
> 31/32), AA
> [    1.731449] ata1.00: supports DRM functions and may not be fully
> accessible
> [    1.731502] ata3.00: ATA-10: ST4000VN000-2AH166, SC60, max UDMA/133
> [    1.732683] ata3.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth
> 31/32), AA
> [    1.733926] ata4.00: ATA-10: ST4000VN000-2AH166, SC60, max UDMA/133
> [    1.736150] ata4.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth
> 31/32), AA
> [    1.738467] ata6.00: ATA-10: ST4000VN000-2AH166, SC60, max UDMA/133
> [    1.739563] ata6.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth
> 31/32), AA
> [    1.740692] ata1.00: NCQ Send/Recv Log not supported
> [    1.741558] ata1.00: ATA-9: Samsung SSD 850 EVO 250GB, EMT01B6Q, max
> UDMA/133
> [    1.742391] ata1.00: 488397168 sectors, multi 1: LBA48 NCQ (depth 31/32),
> AA
> [    1.743634] ata1.00: supports DRM functions and may not be fully
> accessible
> [    1.744370] ata5.00: configured for UDMA/133
> [    1.745099] ata3.00: configured for UDMA/133
> [    1.745895] ata4.00: configured for UDMA/133
> [    1.746745] ata1.00: NCQ Send/Recv Log not supported
> [    1.747468] ata6.00: configured for UDMA/133
> [    1.748115] ata1.00: configured for UDMA/133
> [    1.748795] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD 850 1B6Q
> PQ: 0 ANSI: 5
> [    1.786119] scsi 2:0:0:0: Direct-Access     ATA      ST4000VN000-2AH1
> SC60 PQ: 0 ANSI: 5
> [    1.814182] usb 1-1: New USB device found, idVendor=8087, idProduct=8008
> [    1.814749] usb 1-1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    1.815524] hub 1-1:1.0: USB hub found
> [    1.816122] hub 1-1:1.0: 6 ports detected
> [    1.822099] scsi 3:0:0:0: Direct-Access     ATA      ST4000VN000-2AH1
> SC60 PQ: 0 ANSI: 5
> [    1.829747] usb 3-5: new high-speed USB device number 2 using xhci_hcd
> [    1.838146] usb 2-1: New USB device found, idVendor=8087, idProduct=8000
> [    1.838804] usb 2-1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    1.839788] hub 2-1:1.0: USB hub found
> [    1.840521] hub 2-1:1.0: 8 ports detected
> [    1.858252] scsi 4:0:0:0: Direct-Access     ATA      ST4000VN000-2AH1
> SC60 PQ: 0 ANSI: 5
> [    1.902245] scsi 5:0:0:0: Direct-Access     ATA      ST4000VN000-2AH1
> SC60 PQ: 0 ANSI: 5
> [    1.945262] sd 2:0:0:0: [sdb] 7814037168 512-byte logical blocks: (4.00
> TB/3.64 TiB)
> [    1.945276] sd 3:0:0:0: [sdc] 7814037168 512-byte logical blocks: (4.00
> TB/3.64 TiB)
> [    1.945279] sd 3:0:0:0: [sdc] 4096-byte physical blocks
> [    1.945287] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250
> GB/233 GiB)
> [    1.945298] sd 3:0:0:0: [sdc] Write Protect is off
> [    1.945301] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    1.945306] sd 0:0:0:0: [sda] Write Protect is off
> [    1.945308] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.945328] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [    1.945337] sd 4:0:0:0: [sdd] 7814037168 512-byte logical blocks: (4.00
> TB/3.64 TiB)
> [    1.945338] sd 4:0:0:0: [sdd] 4096-byte physical blocks
> [    1.945354] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [    1.945361] sd 4:0:0:0: [sdd] Write Protect is off
> [    1.945364] sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> [    1.945408] sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [    1.945417] sd 5:0:0:0: [sde] 7814037168 512-byte logical blocks: (4.00
> TB/3.64 TiB)
> [    1.945419] sd 5:0:0:0: [sde] 4096-byte physical blocks
> [    1.945442] sd 5:0:0:0: [sde] Write Protect is off
> [    1.945445] sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
> [    1.945483] sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [    1.947552]  sda: sda1 sda2 sda3
> [    1.948134] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.954787] sd 2:0:0:0: [sdb] 4096-byte physical blocks
> [    1.955246] sd 2:0:0:0: [sdb] Write Protect is off
> [    1.955686] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    1.955691] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [    1.969990] usb 3-5: New USB device found, idVendor=1a40, idProduct=0101
> [    1.970491] usb 3-5: New USB device strings: Mfr=0, Product=1,
> SerialNumber=0
> [    1.970983] usb 3-5: Product: USB 2.0 Hub
> [    1.971849] hub 3-5:1.0: USB hub found
> [    1.972346] hub 3-5:1.0: 4 ports detected
> [    1.998772]  sdc: sdc1
> [    1.999946] sd 3:0:0:0: [sdc] Attached SCSI disk
> [    2.001103]  sdd: sdd1
> [    2.001145]  sde: sde1
> [    2.001596] sd 5:0:0:0: [sde] Attached SCSI disk
> [    2.003237] sd 4:0:0:0: [sdd] Attached SCSI disk
> [    2.015202]  sdb: sdb1
> [    2.016264] sd 2:0:0:0: [sdb] Attached SCSI disk
> [    2.027569] random: fast init done
> [    2.045728] tsc: Refined TSC clocksource calibration: 3399.997 MHz
> [    2.046176] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:
> 0x31024bd20a6, max_idle_ns: 440795346804 ns
> [    2.089713] usb 4-2: new SuperSpeed USB device number 3 using xhci_hcd
> [    2.110323] usb 4-2: New USB device found, idVendor=174c, idProduct=55aa
> [    2.110822] usb 4-2: New USB device strings: Mfr=2, Product=3,
> SerialNumber=1
> [    2.111314] usb 4-2: Product: ICY BOX IB-366StU3+B
> [    2.111767] usb 4-2: Manufacturer: ICY BOX
> [    2.112200] usb 4-2: SerialNumber: 123456789012
> [    2.113206] usb 4-2: UAS is blacklisted for this device, using
> usb-storage instead
> [    2.113713] usb-storage 4-2:1.0: USB Mass Storage device detected
> [    2.114291] usb-storage 4-2:1.0: Quirks match for vid 174c pid 55aa:
> 400000
> [    2.114783] scsi host7: usb-storage 4-2:1.0
> [    2.209692] raid6: sse2x1   gen() 11397 MB/s
> [    2.229697] usb 3-6: new full-speed USB device number 3 using xhci_hcd
> [    2.277703] raid6: sse2x1   xor()  8990 MB/s
> [    2.345708] raid6: sse2x2   gen() 15314 MB/s
> [    2.371613] usb 3-6: New USB device found, idVendor=03eb, idProduct=204b
> [    2.372063] usb 3-6: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    2.372516] usb 3-6: Product: CUL868
> [    2.372957] usb 3-6: Manufacturer: busware.de
> [    2.413712] raid6: sse2x2   xor() 10270 MB/s
> [    2.469722] usb 3-5.1: new full-speed USB device number 4 using xhci_hcd
> [    2.481716] raid6: sse2x4   gen() 17531 MB/s
> [    2.549718] raid6: sse2x4   xor() 12342 MB/s
> [    2.591436] usb 3-5.1: New USB device found, idVendor=10c4,
> idProduct=ea60
> [    2.591876] usb 3-5.1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [    2.592313] usb 3-5.1: Product: CP2104 USB to UART Bridge Controller
> [    2.592751] usb 3-5.1: Manufacturer: Silicon Labs
> [    2.593185] usb 3-5.1: SerialNumber: 0079E5E9
> [    2.617720] raid6: avx2x1   gen() 23365 MB/s
> [    2.685725] raid6: avx2x1   xor() 17266 MB/s
> [    2.709733] usb 3-14: new low-speed USB device number 5 using xhci_hcd
> [    2.753730] raid6: avx2x2   gen() 27424 MB/s
> [    2.821735] raid6: avx2x2   xor() 18620 MB/s
> [    2.868017] usb 3-14: New USB device found, idVendor=04f2, idProduct=0402
> [    2.868440] usb 3-14: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    2.868856] usb 3-14: Product: USB Keyboard
> [    2.869270] usb 3-14: Manufacturer: Chicony
> [    2.871799] hidraw: raw HID events driver (C) Jiri Kosina
> [    2.889732] raid6: avx2x4   gen() 30856 MB/s
> [    2.896436] usbcore: registered new interface driver usbhid
> [    2.897230] usbhid: USB HID core driver
> [    2.898575] input: Chicony USB Keyboard as /devices/pci0000:00/0000:00:14.0/usb3/3-14/3-14:1.0/0003:04F2:0402.0001/input/input3
> [    2.949749] usb 3-5.2: new full-speed USB device number 6 using xhci_hcd
> [    2.957742] raid6: avx2x4   xor() 21374 MB/s
> [    2.957862] hid-generic 0003:04F2:0402.0001: input,hidraw0: USB HID v1.11
> Keyboard [Chicony USB Keyboard] on usb-0000:00:14.0-14/input0
> [    2.957967] input: Chicony USB Keyboard as /devices/pci0000:00/0000:00:14.0/usb3/3-14/3-14:1.1/0003:04F2:0402.0002/input/input4
> [    2.960146] raid6: using algorithm avx2x4 gen() 30856 MB/s
> [    2.960631] raid6: .... xor() 21374 MB/s, rmw enabled
> [    2.961113] raid6: using avx2x2 recovery algorithm
> [    2.961747] xor: automatically using best checksumming function   avx
> 
> [    2.961856] scsi 6:0:0:0: Direct-Access     ST4000VN 000-1H4168 SC43 PQ:
> 0 ANSI: 5
> [    2.962460] sd 6:0:0:0: [sdf] Very big device. Trying to use READ
> CAPACITY(16).
> [    2.962580] sd 6:0:0:0: [sdf] 7814037168 512-byte logical blocks: (4.00
> TB/3.64 TiB)
> [    2.962779] sd 6:0:0:0: [sdf] Write Protect is off
> [    2.962779] sd 6:0:0:0: [sdf] Mode Sense: 23 00 00 00
> [    2.962979] sd 6:0:0:0: [sdf] No Caching mode page found
> [    2.962979] sd 6:0:0:0: [sdf] Assuming drive cache: write through
> [    2.963235] sd 6:0:0:0: [sdf] Very big device. Trying to use READ
> CAPACITY(16).
> [    2.966280] async_tx: api initialized (async)
> [    2.967778] md/raid:md1: device sdd1 operational as raid disk 2
> [    2.968298] md/raid:md1: device sde1 operational as raid disk 0
> [    2.968808] md/raid:md1: device sdc1 operational as raid disk 3
> [    2.969311] md/raid:md1: device sdb1 operational as raid disk 1
> [    2.970023] md/raid:md1: raid level 5 active with 4 out of 4 devices,
> algorithm 2
> [    2.990152]  sdf: sdf1
> [    2.991515] sd 6:0:0:0: [sdf] Very big device. Trying to use READ
> CAPACITY(16).
> [    2.993377] sd 6:0:0:0: [sdf] Attached SCSI disk
> [    2.995952] md1: detected capacity change from 0 to 12001954234368
> [    3.017896] hid-generic 0003:04F2:0402.0002: input,hiddev0,hidraw1: USB
> HID v1.11 Device [Chicony USB Keyboard] on usb-0000:00:14.0-14/input1
> [    3.070027] clocksource: Switched to clocksource tsc
> [    3.072781] usb 3-5.2: New USB device found, idVendor=10c4,
> idProduct=ea60
> [    3.073691] usb 3-5.2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [    3.074607] usb 3-5.2: Product: CP2104 USB to UART Bridge Controller
> [    3.075512] usb 3-5.2: Manufacturer: Silicon Labs
> [    3.076421] usb 3-5.2: SerialNumber: 0079E4D7
> [    3.083055] device-mapper: uevent: version 1.0.3
> [    3.083671] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised:
> dm-devel@redhat.com
> [    3.134293] scsi 7:0:0:0: Direct-Access     ICY BOX  IB-366StU3+B 0
> PQ: 0 ANSI: 6
> [    3.135256] sd 7:0:0:0: [sdg] 15628053168 512-byte logical blocks: (8.00
> TB/7.28 TiB)
> [    3.135907] sd 7:0:0:0: [sdg] 4096-byte physical blocks
> [    3.136683] sd 7:0:0:0: [sdg] Write Protect is off
> [    3.137212] sd 7:0:0:0: [sdg] Mode Sense: 43 00 00 00
> [    3.137409] sd 7:0:0:0: [sdg] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [    3.138893] random: crng init done
> [    3.166444]  sdg: sdg1
> [    3.167846] sd 7:0:0:0: [sdg] Attached SCSI disk
> [    3.241972] VFIO - User Level meta-driver version: 0.3
> [    3.259027] Btrfs loaded, crc32c=crc32c-intel
> [    3.355038] BTRFS: device fsid 630137c3-6dd8-416c-b730-f47f99f2701d devid
> 1 transid 4833 /dev/sdg1
> [    3.355966] BTRFS: device label backup devid 1 transid 1611 /dev/sdf1
> [    3.356572] BTRFS: device fsid 9208425d-8927-4ca1-83f6-a946adb13588 devid
> 1 transid 2013825 /dev/sda2
> [   34.320773] BTRFS info (device sda2): disk space caching is enabled
> [   34.323048] BTRFS info (device sda2): bdev /dev/sda2 errs: wr 0, rd 0,
> flush 0, corrupt 14, gen 0
> [   34.374291] BTRFS info (device sda2): detected SSD devices, enabling SSD
> mode
> [   34.533779] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   34.539611] systemd[1]: systemd 232 running in system mode. (+PAM +AUDIT
> +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT
> +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
> [   34.541571] systemd[1]: Detected architecture x86-64.
> [   34.542921] systemd[1]: Set hostname to <fatblock>.
> [   34.619773] systemd[1]: Created slice User and Session Slice.
> [   34.620240] systemd[1]: Listening on Journal Audit Socket.
> [   34.620677] systemd[1]: Listening on /dev/initctl Compatibility Named
> Pipe.
> [   34.621425] systemd[1]: Listening on LVM2 poll daemon socket.
> [   34.622267] systemd[1]: Listening on udev Control Socket.
> [   34.623169] systemd[1]: Started Forward Password Requests to Wall
> Directory Watch.
> [   34.624114] systemd[1]: Listening on RPCbind Server Activation Socket.
> [   34.638473] BTRFS info (device sda2): disk space caching is enabled
> [   34.641356] loop: module loaded
> [   34.684689] systemd-journald[719]: Received request to flush runtime
> journal from PID 1
> [   34.711403] parport_pc 00:06: reported by Plug and Play ACPI
> [   34.712019] parport0: PC-style at 0x378, irq 5 [PCSPP]
> [   34.724858] EDAC ie31200: No ECC support
> [   34.730477] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [   34.731976] cdc_acm 3-6:1.0: ttyACM0: USB ACM device
> [   34.732909] usbcore: registered new interface driver cdc_acm
> [   34.733613] cdc_acm: USB Abstract Control Model driver for USB modems and
> ISDN adapters
> [   34.734798] usbcore: registered new interface driver usbserial
> [   34.734837] snd_hda_intel 0000:00:03.0: bound 0000:00:02.0 (ops
> i915_audio_component_bind_ops [i915])
> [   34.736233] usbcore: registered new interface driver usbserial_generic
> [   34.737052] usbserial: USB Serial support registered for generic
> [   34.739205] dvb_core: loading out-of-tree module taints kernel.
> [   34.740314] usbcore: registered new interface driver cp210x
> [   34.741348] usbserial: USB Serial support registered for cp210x
> [   34.741383] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [   34.741436] sd 2:0:0:0: Attached scsi generic sg1 type 0
> [   34.741462] sd 3:0:0:0: Attached scsi generic sg2 type 0
> [   34.741489] sd 4:0:0:0: Attached scsi generic sg3 type 0
> [   34.741515] sd 5:0:0:0: Attached scsi generic sg4 type 0
> [   34.741786] sd 6:0:0:0: Attached scsi generic sg5 type 0
> [   34.741817] sd 7:0:0:0: Attached scsi generic sg6 type 0
> [   34.747092] cp210x 3-5.1:1.0: cp210x converter detected
> [   34.748047] RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters, 655360
> ms ovfl timer
> [   34.748756] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
> [   34.749336] usb 3-5.1: cp210x converter now attached to ttyUSB0
> [   34.749358] cp210x 3-5.2:1.0: cp210x converter detected
> [   34.750412] RAPL PMU: hw unit of domain package 2^-14 Joules
> [   34.750876] RAPL PMU: hw unit of domain dram 2^-14 Joules
> [   34.751056] usb 3-5.2: cp210x converter now attached to ttyUSB1
> [   34.751850] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
> [   34.771571] input: PC Speaker as /devices/platform/pcspkr/input/input5
> [   34.772236] ACPI Warning: SystemIO range
> 0x0000000000001828-0x000000000000182F conflicts with OpRegion
> 0x0000000000001800-0x000000000000187F (\PMIO) (20170303/utaddress-247)
> [   34.773623] ACPI: If an ACPI driver is available for this device, you
> should use it instead of the native driver
> [   34.774281] ACPI Warning: SystemIO range
> 0x0000000000001C40-0x0000000000001C4F conflicts with OpRegion
> 0x0000000000001C00-0x0000000000001FFF (\GPR) (20170303/utaddress-247)
> [   34.775529] ACPI: If an ACPI driver is available for this device, you
> should use it instead of the native driver
> [   34.776640] ACPI Warning: SystemIO range
> 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion
> 0x0000000000001C00-0x0000000000001C3F (\GPRL) (20170303/utaddress-247)
> [   34.778244] ACPI Warning: SystemIO range
> 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion
> 0x0000000000001C00-0x0000000000001FFF (\GPR) (20170303/utaddress-247)
> [   34.779834] ACPI: If an ACPI driver is available for this device, you
> should use it instead of the native driver
> [   34.780890] ACPI Warning: SystemIO range
> 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion
> 0x0000000000001C00-0x0000000000001C3F (\GPRL) (20170303/utaddress-247)
> [   34.783028] ACPI Warning: SystemIO range
> 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion
> 0x0000000000001C00-0x0000000000001FFF (\GPR) (20170303/utaddress-247)
> [   34.785246] ACPI: If an ACPI driver is available for this device, you
> should use it instead of the native driver
> [   34.786390] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [   34.800550] input: HDA Intel HDMI HDMI/DP,pcm=3 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input6
> [   34.801094] snd_hda_codec_realtek hdaudioC1D0: autoconfig for ALC892:
> line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
> [   34.801096] snd_hda_codec_realtek hdaudioC1D0:    speaker_outs=0
> (0x0/0x0/0x0/0x0/0x0)
> [   34.801097] snd_hda_codec_realtek hdaudioC1D0:    hp_outs=1
> (0x1b/0x0/0x0/0x0/0x0)
> [   34.801097] snd_hda_codec_realtek hdaudioC1D0:    mono: mono_out=0x0
> [   34.801098] snd_hda_codec_realtek hdaudioC1D0:    dig-out=0x1e/0x0
> [   34.801099] snd_hda_codec_realtek hdaudioC1D0:    inputs:
> [   34.801100] snd_hda_codec_realtek hdaudioC1D0:      Front Mic=0x19
> [   34.801101] snd_hda_codec_realtek hdaudioC1D0:      Rear Mic=0x18
> [   34.801102] snd_hda_codec_realtek hdaudioC1D0:      Line=0x1a
> [   34.809322] input: HDA Intel HDMI HDMI/DP,pcm=7 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input7
> [   34.809419] Digital Devices PCIE bridge driver 0.9.32, Copyright (C)
> 2010-17 Digital Devices GmbH
> [   34.809626] ddbridge 0000:03:00.0: device name: Digital Devices Cine S2
> V6.5 DVB adapter
> [   34.809657] ddbridge 0000:03:00.0: HW 0001000d REGMAP 00010004
> [   34.809675] ddbridge 0000:03:00.0: link 0 vendor dd01 device 0003
> subvendor dd01 subdevice 0021
> [   34.813864] input: HDA Intel HDMI HDMI/DP,pcm=8 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input8
> [   34.814675] input: HDA Intel PCH Front Mic as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
> [   34.814703] input: HDA Intel PCH Rear Mic as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input12
> [   34.814731] input: HDA Intel PCH Line as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input13
> [   34.814757] input: HDA Intel PCH Line Out Front as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input14
> [   34.814785] input: HDA Intel PCH Line Out Surround as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input15
> [   34.814812] input: HDA Intel PCH Line Out CLFE as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input16
> [   34.814840] input: HDA Intel PCH Line Out Side as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input17
> [   34.814850] input: HDA Intel HDMI HDMI/DP,pcm=9 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input9
> [   34.814867] input: HDA Intel PCH Front Headphone as
> /devices/pci0000:00/0000:00:1b.0/sound/card1/input18
> [   34.814938] input: HDA Intel HDMI HDMI/DP,pcm=10 as
> /devices/pci0000:00/0000:00:03.0/sound/card0/input10
> [   34.830278] intel_rapl: Found RAPL domain package
> [   34.830279] intel_rapl: Found RAPL domain core
> [   34.830280] intel_rapl: Found RAPL domain uncore
> [   34.830280] intel_rapl: Found RAPL domain dram
> [   34.831535] ppdev: user-space parallel port driver
> [   34.842490] iTCO_vendor_support: vendor-support=0
> [   34.844431] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> [   34.844466] iTCO_wdt: Found a Lynx Point TCO device (Version=2,
> TCOBASE=0x1860)
> [   34.844528] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [   35.576751] EXT4-fs (dm-0): mounted filesystem with ordered data mode.
> Opts: user_xattr
> [   35.593313] EXT4-fs (dm-1): mounted filesystem with ordered data mode.
> Opts: user_xattr
> [   36.289534] ddbridge 0000:03:00.0: Port 0: Link 0, Link Port 0 (TAB 1):
> DUAL DVB-S2
> [   36.290028] ddbridge 0000:03:00.0: init link 0, input 0, regs 00000200
> [   36.290515] ddbridge 0000:03:00.0: init link 0, input 0, handler 8
> [   36.290991] ddbridge 0000:03:00.0: init link 0, io 0, dma 0, dmaregs
> 00000300 bufregs 00002000
> [   36.291459] ddbridge 0000:03:00.0: init link 0, input 1, regs 00000210
> [   36.291927] ddbridge 0000:03:00.0: init link 0, input 1, handler 9
> [   36.292007] nct6775: Found NCT6779D or compatible chip at 0x4e:0xa00
> [   36.293048] ddbridge 0000:03:00.0: init link 0, io 1, dma 1, dmaregs
> 00000310 bufregs 00002100
> [   36.293525] ddbridge 0000:03:00.0: init link 0, output 0, regs 00000280
> [   36.293993] ddbridge 0000:03:00.0: init link 0, io 0, dma 0, dmaregs
> 00000380 bufregs 00002800
> [   36.295540] ddbridge 0000:03:00.0: Port 1: Link 0, Link Port 1 (TAB 2):
> NO MODULE
> [   36.296563] ddbridge 0000:03:00.0: Port 2: Link 0, Link Port 2 (TAB 3):
> NO MODULE
> [   36.297557] ddbridge 0000:03:00.0: Port 3: Link 0, Link Port 3 (TAB 4):
> NO MODULE
> [   36.297661] ddbridge 0000:03:00.0: 0 netstream channels
> [   36.297662] DVB: registering new adapter (DDBridge)
> [   36.297663] DVB: registering new adapter (DDBridge)
> [   36.309773] r8169 0000:02:00.0: firmware: direct-loading firmware
> rtl_nic/rtl8168g-2.fw
> [   36.354101] r8169 0000:02:00.0 eth0: link down
> [   36.354101] r8169 0000:02:00.0 eth0: link down
> [   36.354164] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   36.483584] stv090x_attach: Attaching STV0900 demodulator(1) Cut=0x30
> [   36.484389] STV0900 version 0x30
> [   36.489245] LNBx2x attached on addr=a
> [   36.492113] stv6110x_attach: Attaching STV6110x
> [   36.492945] ddbridge 0000:03:00.0: attach tuner input 0 adr 60
> [   36.493767] ddbridge 0000:03:00.0: DVB: registering adapter 0 frontend 0
> (STV090x Multistandard)...
> [   36.535580] stv090x_attach: Attaching STV0900 demodulator(2) Cut=0x30
> [   36.536389] STV0900 version 0x30
> [   36.537478] LNBx2x attached on addr=8
> [   36.538280] stv6110x_attach: Attaching STV6110x
> [   36.539069] ddbridge 0000:03:00.0: attach tuner input 1 adr 63
> [   36.539990] ddbridge 0000:03:00.0: DVB: registering adapter 1 frontend 0
> (STV090x Multistandard)...
> [   36.576840] 8021q: 802.1Q VLAN Support v1.8
> [   36.587148] IPv6: ADDRCONF(NETDEV_UP): eth0.20: link is not ready
> [   36.596388] bridge: filtering via arp/ip/ip6tables is no longer available
> by default. Update your scripts to load br_netfilter if you need this.
> [   36.600029] vlan20: port 1(eth0.20) entered blocking state
> [   36.600662] vlan20: port 1(eth0.20) entered disabled state
> [   36.601324] device eth0.20 entered promiscuous mode
> [   36.601956] device eth0 entered promiscuous mode
> [   36.604725] IPv6: ADDRCONF(NETDEV_UP): vlan20: link is not ready
> [   36.615671] IPv6: ADDRCONF(NETDEV_UP): eth0.40: link is not ready
> [   36.620475] br1: port 1(eth0.40) entered blocking state
> [   36.621212] br1: port 1(eth0.40) entered disabled state
> [   36.622055] device eth0.40 entered promiscuous mode
> [   36.624417] IPv6: ADDRCONF(NETDEV_UP): br1: link is not ready
> [   36.634231] br0: port 1(eth0) entered blocking state
> [   36.634782] br0: port 1(eth0) entered disabled state
> [   36.636961] IPv6: ADDRCONF(NETDEV_UP): br0: link is not ready
> [   38.864930] r8169 0000:02:00.0 eth0: link up
> [   38.866719] br0: port 1(eth0) entered blocking state
> [   38.868297] br0: port 1(eth0) entered forwarding state
> [   38.870096] vlan20: port 1(eth0.20) entered blocking state
> [   38.871651] vlan20: port 1(eth0.20) entered listening state
> [   38.873390] br1: port 1(eth0.40) entered blocking state
> [   38.874878] br1: port 1(eth0.40) entered listening state
> [   38.876390] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
> [   53.984506] br1: port 1(eth0.40) entered learning state
> [   53.986476] vlan20: port 1(eth0.20) entered learning state
> [   69.089310] vlan20: port 1(eth0.20) entered forwarding state
> [   69.093249] vlan20: topology change detected, propagating
> [   69.095242] br1: port 1(eth0.40) entered forwarding state
> [   69.097249] br1: topology change detected, propagating
> [   69.099302] IPv6: ADDRCONF(NETDEV_CHANGE): vlan20: link becomes ready
> [   69.101362] IPv6: ADDRCONF(NETDEV_CHANGE): br1: link becomes ready
> [  126.759572] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [  126.774129] Ebtables v2.0 registered
> [ 1893.789841] Bluetooth: Core ver 2.22
> [ 1893.789873] NET: Registered protocol family 31
> [ 1893.789885] Bluetooth: HCI device and connection manager initialized
> [ 1893.789903] Bluetooth: HCI socket layer initialized
> [ 1893.789916] Bluetooth: L2CAP socket layer initialized
> [ 1893.789932] Bluetooth: SCO socket layer initialized
> [ 2012.818753] BTRFS info (device sdf1): disk space caching is enabled
> [ 2012.818833] BTRFS info (device sdf1): has skinny extents
> [ 6526.725676] BUG: unable to handle kernel NULL pointer dereference at
> (null)

No "list_del corruption, blablabla" is shown here, so I guess it's the
entry that is NULL, but that's against the list_empty() check above
this list_del().

No idea what's it doing.

Thanks,

-liubo
> [ 6526.725703] IP: __list_del_entry_valid+0x0/0x90
> [ 6526.725714] PGD 0
> [ 6526.725715] P4D 0
> 
> [ 6526.725732] Oops: 0000 [#1] SMP
> [ 6526.725741] Modules linked in: bluetooth ecdh_generic rfkill msr
> ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter
> binfmt_misc cpufreq_userspace cpufreq_powersave cpufreq_conservative bridge
> 8021q garp mrp stp llc stv6110x(O) lnbp21(O) stv090x(O) nct6775 hwmon_vid
> ext4 crc16 jbd2 fscrypto ecb mbcache iTCO_wdt iTCO_vendor_support ppdev
> intel_rapl x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ddbridge(O) intel_cstate
> snd_hda_codec_realtek snd_hda_codec_hdmi cxd2099(O) intel_uncore lpc_ich
> snd_hda_codec_generic pcspkr intel_rapl_perf dvb_core(O) sg mfd_core cp210x
> usbserial snd_hda_intel cdc_acm snd_hda_codec shpchp snd_hda_core snd_hwdep
> snd_pcm snd_timer snd ie31200_edac soundcore mei_me mei battery parport_pc
> parport tpm_infineon
> [ 6526.725896]  evdev intel_smartconnect eeprom coretemp loop ip_tables
> x_tables autofs4 btrfs raid10 raid1 raid0 multipath linear vfio_pci
> irqbypass vfio_virqfd vfio_iommu_type1 vfio dm_mod raid456 async_raid6_recov
> async_memcpy async_pq async_xor async_tx xor hid_generic usbhid hid raid6_pq
> libcrc32c crc32c_generic md_mod sd_mod uas usb_storage crc32c_intel mxm_wmi
> ahci libahci i915 aesni_intel aes_x86_64 crypto_simd cryptd i2c_algo_bit
> glue_helper xhci_pci ehci_pci libata drm_kms_helper xhci_hcd ehci_hcd
> scsi_mod i2c_i801 r8169 mii usbcore drm usb_common fan thermal wmi video
> button
> [ 6526.726013] CPU: 0 PID: 5763 Comm: rsync Tainted: G           O
> 4.12.0-0.bpo.2-amd64 #1 Debian 4.12.13-1~bpo9+1
> [ 6526.726034] Hardware name: MSI MS-7823/H87M-G43 (MS-7823), BIOS V1.9
> 05/30/2015
> [ 6526.726049] task: ffff9dae191d6080 task.stack: ffffbf52032a4000
> [ 6526.726063] RIP: 0010:__list_del_entry_valid+0x0/0x90
> [ 6526.726074] RSP: 0018:ffffbf52032a77e0 EFLAGS: 00010206
> [ 6526.726087] RAX: 0000000000000093 RBX: 0000000000000015 RCX:
> ffff9dae191d6080
> [ 6526.726102] RDX: 0000000000000000 RSI: 0000000000000200 RDI:
> 0000000000000000
> [ 6526.726117] RBP: ffffffffc0783bc8 R08: 0000000000000008 R09:
> ffffffff88715fc0
> [ 6526.726132] R10: ffffffff88715f80 R11: 0000000000000000 R12:
> ffffffffc0783720
> [ 6526.726147] R13: ffffffffc0783bb8 R14: 0000000000000008 R15:
> ffffffffc0783bd8
> [ 6526.726162] FS:  00007f9c6ac05e80(0000) GS:ffff9dae9ea00000(0000)
> knlGS:0000000000000000
> [ 6526.726178] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 6526.726191] CR2: 0000000000000000 CR3: 00000000991d8000 CR4:
> 00000000001406f0
> [ 6526.726206] Call Trace:
> [ 6526.726233]  ? find_workspace+0x1de/0x240 [btrfs]
> [ 6526.726254]  ? btrfs_get_token_64+0x103/0x120 [btrfs]
> [ 6526.726274]  ? btrfs_decompress+0x2a/0x70 [btrfs]
> [ 6526.726294]  ? uncompress_inline.isra.59+0xdf/0x139 [btrfs]
> [ 6526.726315]  ? btrfs_get_extent+0x875/0xbf0 [btrfs]
> [ 6526.726899]  ? __set_extent_bit+0x3fb/0x590 [btrfs]
> [ 6526.727463]  ? __do_readpage+0x1a9/0x800 [btrfs]
> [ 6526.728026]  ? btrfs_releasepage+0x20/0x20 [btrfs]
> [ 6526.728588]  ? __extent_readpages.constprop.51+0x2ea/0x320 [btrfs]
> [ 6526.729171]  ? btrfs_releasepage+0x20/0x20 [btrfs]
> [ 6526.729754]  ? extent_readpages+0x1de/0x200 [btrfs]
> [ 6526.730334]  ? btrfs_releasepage+0x20/0x20 [btrfs]
> [ 6526.730887]  ? __alloc_pages_nodemask+0xe1/0x240
> [ 6526.731459]  ? alloc_pages_current+0x91/0x140
> [ 6526.732025]  ? __do_page_cache_readahead+0x1fe/0x2d0
> [ 6526.732590]  ? ondemand_readahead+0x171/0x290
> [ 6526.733151]  ? ondemand_readahead+0x171/0x290
> [ 6526.733705]  ? pagecache_get_page+0x30/0x220
> [ 6526.734257]  ? generic_file_read_iter+0x81c/0x950
> [ 6526.734832]  ? cp_new_stat+0x150/0x180
> [ 6526.735390]  ? new_sync_read+0xd7/0x120
> [ 6526.735946]  ? vfs_read+0x91/0x130
> [ 6526.736482]  ? SyS_read+0x52/0xc0
> [ 6526.737010]  ? system_call_fast_compare_end+0xc/0x97
> [ 6526.737527] Code: e8 1c 7a e1 ff 0f 0b 48 89 f2 48 89 c1 48 89 fe 48 c7
> c7 78 10 43 88 e8 05 7a e1 ff 0f 0b 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00
> <48> 8b 07 48 b9 00 01 00 00 00 00 ad de 48 8b 57 08 48 39 c8 74
> [ 6526.738592] RIP: __list_del_entry_valid+0x0/0x90 RSP: ffffbf52032a77e0
> [ 6526.739113] CR2: 0000000000000000
> [ 6526.739639] ---[ end trace cdae7e7173d5079a ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
