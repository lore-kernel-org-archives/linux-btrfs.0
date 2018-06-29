Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from einhorn-mail.in-berlin.de ([217.197.80.20]:51259 "EHLO
        einhorn-mail.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933826AbeF2LTC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 07:19:02 -0400
Received: from authenticated.user (localhost [127.0.0.1]) by einhorn.in-berlin.de  with ESMTP id w5TB4hZw024362
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 13:04:43 +0200
To: linux-btrfs@vger.kernel.org
From: marble <marble@hamburg.ccc.de>
Subject: btrfs suddenly think's it's raid6
Message-ID: <80f0c6f7-ede1-e522-551c-ec2446bb79ea@hamburg.ccc.de>
Date: Fri, 29 Jun 2018 13:04:42 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------5AD05FC204FC61ECD4F06CFD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------5AD05FC204FC61ECD4F06CFD
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,
I have an external HDD. The HDD contains no partition.
I use the whole HDD as a LUKS container. Inside that LUKS is a btrfs.
It's used to store some media files.
The HDD was hooked up to a Raspberry Pi running up-to-date Arch Linux
to play music from the drive.

After disconnecting the drive from the Pi and connecting it to my laptop
again, I couldn't mount it anymore. If I read the dmesg right, it now
thinks that it's part of a raid6.

btrfs check --repair also didn't help.

```
marble@archlinux ~ % uname -a
Linux archlinux 4.17.2-1-ARCH #1 SMP PREEMPT Sat Jun 16 11:08:59 UTC
2018 x86_64 GNU/Linux

marble@archlinux ~ % btrfs --version
btrfs-progs v4.16.1

marble@archlinux ~ % sudo cryptsetup open /dev/sda black
[sudo] password for marble:
Enter passphrase for /dev/sda:

marble@archlinux ~ % mkdir /tmp/black
marble@archlinux ~ % sudo mount /dev/mapper/black /tmp/black
mount: /tmp/black: can't read superblock on /dev/mapper/black.

marble@archlinux ~ % sudo btrfs fi show
Label: 'black'  uuid: 9fea91c7-7b0b-4ef9-a83b-e24ccf2586b5
        Total devices 1 FS bytes used 143.38GiB
        devid    1 size 465.76GiB used 172.02GiB path /dev/mapper/black

marble@archlinux ~ % sudo btrfs check --repair /dev/mapper/black
enabling repair mode
Checking filesystem on /dev/mapper/black
UUID: 9fea91c7-7b0b-4ef9-a83b-e24ccf2586b5
Fixed 0 roots.
checking extents
checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
checksum verify failed on 1082114048 found 1A9EFC07 wanted 204A6979
checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
bytenr mismatch, want=1082114048, have=9385453728028469028
owner ref check failed [1082114048 16384]
repair deleting extent record: key [1082114048,168,16384]
adding new tree backref on start 1082114048 len 16384 parent 0 root 5
Repaired extent references for 1082114048
ref mismatch on [59038556160 4096] extent item 1, found 0
checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
checksum verify failed on 1082114048 found 1A9EFC07 wanted 204A6979
checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
bytenr mismatch, want=1082114048, have=9385453728028469028
incorrect local backref count on 59038556160 root 5 owner 334393 offset
0 found 0 wanted 1 back 0x56348aee5de0
backref disk bytenr does not match extent record, bytenr=59038556160,
ref bytenr=0
backpointer mismatch on [59038556160 4096]
owner ref check failed [59038556160 4096]
checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
checksum verify failed on 1082114048 found 1A9EFC07 wanted 204A6979
checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
bytenr mismatch, want=1082114048, have=9385453728028469028
failed to repair damaged filesystem, aborting

marble@archlinux ~ % dmesg > /tmp/dmesg.log
```

Any clues?

Best regards,
marble

--------------5AD05FC204FC61ECD4F06CFD
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Linux version 4.17.2-1-ARCH (builduser@heftig-9574) (gcc version 8.1.1 20180531 (GCC)) #1 SMP PREEMPT Sat Jun 16 11:08:59 UTC 2018
[    0.000000] Command line: initrd=\initramfs-linux.img cryptdevice=PARTLABEL=root:root_luks root=/dev/mapper/root_luks quiet rw
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000008bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008c000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b50dcfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b50dd000-0x00000000b50ddfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000b50de000-0x00000000b50defff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b50df000-0x00000000bea16fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bea17000-0x00000000bff2dfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bff2e000-0x00000000bff99fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bff9a000-0x00000000bfffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bffff000-0x00000000bfffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c0000000-0x00000000c7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000c8600000-0x00000000cc7fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe010000-0x00000000fe010fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000004327fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0xb14fb018-0xb150b057] usable ==> usable
[    0.000000] e820: update [mem 0xb14fb018-0xb150b057] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000058000-0x0000000000058fff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000059000-0x000000000008bfff] usable
[    0.000000] reserve setup_data: [mem 0x000000000008c000-0x00000000000fffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000b14fb017] usable
[    0.000000] reserve setup_data: [mem 0x00000000b14fb018-0x00000000b150b057] usable
[    0.000000] reserve setup_data: [mem 0x00000000b150b058-0x00000000b50dcfff] usable
[    0.000000] reserve setup_data: [mem 0x00000000b50dd000-0x00000000b50ddfff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000b50de000-0x00000000b50defff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000b50df000-0x00000000bea16fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000bea17000-0x00000000bff2dfff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000bff2e000-0x00000000bff99fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000bff9a000-0x00000000bfffefff] ACPI data
[    0.000000] reserve setup_data: [mem 0x00000000bffff000-0x00000000bfffffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000c0000000-0x00000000c7ffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000c8600000-0x00000000cc7fffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fe010000-0x00000000fe010fff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x00000004327fffff] usable
[    0.000000] efi: EFI v2.50 by Lenovo
[    0.000000] efi:  SMBIOS=0xbf113000  SMBIOS 3.0=0xbf110000  ACPI=0xbfffe000  ACPI 2.0=0xbfffe014  MPS=0xbf47a000  ESRT=0xbebae000  MEMATTR=0xb983b018  TPMEventLog=0xb5211018 
[    0.000000] SMBIOS 3.0.0 present.
[    0.000000] DMI: LENOVO 20HN002UGE/20HN002UGE, BIOS R0IET38W (1.16 ) 05/31/2017
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x432800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   1 base 00D0000000 mask 7FF0000000 uncachable
[    0.000000]   2 base 00CC000000 mask 7FFC000000 uncachable
[    0.000000]   3 base 00CA000000 mask 7FFE000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.000000] e820: last_pfn = 0xc0000 max_arch_pfn = 0x400000000
[    0.000000] esrt: Reserving ESRT space from 0x00000000bebae000 to 0x00000000bebae088.
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [        (ptrval)] 64000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x3ea660000, 0x3ea660fff] PGTABLE
[    0.000000] BRK [0x3ea661000, 0x3ea661fff] PGTABLE
[    0.000000] BRK [0x3ea662000, 0x3ea662fff] PGTABLE
[    0.000000] BRK [0x3ea663000, 0x3ea663fff] PGTABLE
[    0.000000] BRK [0x3ea664000, 0x3ea664fff] PGTABLE
[    0.000000] BRK [0x3ea665000, 0x3ea665fff] PGTABLE
[    0.000000] BRK [0x3ea666000, 0x3ea666fff] PGTABLE
[    0.000000] BRK [0x3ea667000, 0x3ea667fff] PGTABLE
[    0.000000] BRK [0x3ea668000, 0x3ea668fff] PGTABLE
[    0.000000] Secure boot disabled
[    0.000000] RAMDISK: [mem 0x7f5c0000-0x7fffefff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000BFFFE014 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000BFFC3188 000104 (v01 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: FACP 0x00000000BFFF5000 0000F4 (v05 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: DSDT 0x00000000BFFD0000 020402 (v02 LENOVO SKL      00000000 INTL 20160527)
[    0.000000] ACPI: FACS 0x00000000BFF3D000 000040
[    0.000000] ACPI: SSDT 0x00000000BFFFC000 0003CC (v02 LENOVO Tpm2Tabl 00001000 INTL 20160527)
[    0.000000] ACPI: TPM2 0x00000000BFFFB000 000034 (v03 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: UEFI 0x00000000BFF53000 000042 (v01 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: SSDT 0x00000000BFFF7000 003252 (v02 LENOVO SaSsdt   00003000 INTL 20160527)
[    0.000000] ACPI: SSDT 0x00000000BFFF6000 0005B6 (v02 LENOVO PerfTune 00001000 INTL 20160527)
[    0.000000] ACPI: HPET 0x00000000BFFF4000 000038 (v01 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: APIC 0x00000000BFFF3000 0000BC (v03 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: MCFG 0x00000000BFFF2000 00003C (v01 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: ECDT 0x00000000BFFF1000 000053 (v01 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: SSDT 0x00000000BFFCF000 00021C (v01 LENOVO Rmv_Batt 00001000 INTL 20160527)
[    0.000000] ACPI: SSDT 0x00000000BFFCD000 0016AD (v02 LENOVO ProjSsdt 00000010 INTL 20160527)
[    0.000000] ACPI: BOOT 0x00000000BFFCC000 000028 (v01 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: BATB 0x00000000BFFCB000 00004A (v02 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: SLIC 0x00000000BFFCA000 000176 (v01 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: SSDT 0x00000000BFFC9000 000EDE (v02 LENOVO CpuSsdt  00003000 INTL 20160527)
[    0.000000] ACPI: SSDT 0x00000000BFFC8000 00050D (v02 LENOVO CtdpB    00001000 INTL 20160527)
[    0.000000] ACPI: SSDT 0x00000000BFFC7000 000600 (v02 LENOVO UsbCTabl 00001000 INTL 20160527)
[    0.000000] ACPI: WSMT 0x00000000BFFC6000 000028 (v01 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: SSDT 0x00000000BFFC5000 000141 (v02 LENOVO HdaDsp   00000000 INTL 20160527)
[    0.000000] ACPI: SSDT 0x00000000BFFC4000 0004C5 (v02 LENOVO TbtTypeC 00000000 INTL 20160527)
[    0.000000] ACPI: DBGP 0x00000000BFFFD000 000034 (v01 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: DBG2 0x00000000BFFC2000 000054 (v00 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: MSDM 0x00000000BFFC1000 000055 (v03 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: DMAR 0x00000000BFFC0000 0000A8 (v01 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: ASF! 0x00000000BFFBF000 0000A0 (v32 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: FPDT 0x00000000BFFBE000 000044 (v01 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: UEFI 0x00000000BFF3B000 00013E (v01 LENOVO TP-R0I   00001160 PTEC 00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000004327fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x4327fc000-0x4327fffff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x00000004327fffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
[    0.000000]   node   0: [mem 0x0000000000059000-0x000000000008bfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000b50dcfff]
[    0.000000]   node   0: [mem 0x00000000b50df000-0x00000000bea16fff]
[    0.000000]   node   0: [mem 0x00000000bffff000-0x00000000bfffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x00000004327fffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x00000004327fffff]
[    0.000000] On node 0 totalpages: 4133280
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 71 pages reserved
[    0.000000]   DMA zone: 3978 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12137 pages used for memmap
[    0.000000]   DMA32 zone: 776726 pages, LIFO batch:31
[    0.000000]   Normal zone: 52384 pages used for memmap
[    0.000000]   Normal zone: 3352576 pages, LIFO batch:31
[    0.000000] Reserved but unavailable: 101 pages
[    0.000000] Reserving Intel graphics memory at [mem 0xca800000-0xcc7fffff]
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
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0008c000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xb14fb000-0xb14fbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xb150b000-0xb150bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xb50dd000-0xb50ddfff]
[    0.000000] PM: Registered nosave memory: [mem 0xb50de000-0xb50defff]
[    0.000000] PM: Registered nosave memory: [mem 0xbea17000-0xbff2dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbff2e000-0xbff99fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbff9a000-0xbfffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xc7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc8000000-0xc85fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc8600000-0xcc7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcc800000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xf3ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf4000000-0xfe00ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe010000-0xfe010fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe011000-0xffffffff]
[    0.000000] e820: [mem 0xcc800000-0xefffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370452778343963 ns
[    0.000000] random: get_random_bytes called from start_kernel+0x95/0x535 with crng_init=0
[    0.000000] setup_percpu: NR_CPUS:320 nr_cpumask_bits:320 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] percpu: Embedded 46 pages/cpu @        (ptrval) s151552 r8192 d28672 u524288
[    0.000000] pcpu-alloc: s151552 r8192 d28672 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 4068624
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: initrd=\initramfs-linux.img cryptdevice=PARTLABEL=root:root_luks root=/dev/mapper/root_luks quiet rw
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 16088616K/16533120K available (10252K kernel code, 1290K rwdata, 3488K rodata, 1476K init, 608K bss, 444504K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Kernel/User page tables isolation: enabled
[    0.000000] ftrace: allocating 32647 entries in 128 pages
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=320 to nr_cpu_ids=4.
[    0.000000] 	RCU priority boosting: priority 1 delay 500 ms.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS: 20736, nr_irqs: 1024, preallocated irqs: 16
[    0.000000] 	Offload RCU callbacks from CPUs: (none).
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] ACPI: Core revision 20180313
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 79635855245 ns
[    0.000000] hpet clockevent registered
[    0.003333] APIC: Switch to symmetric I/O mode setup
[    0.003333] DMAR: Host address width 39
[    0.003333] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.003333] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660462 ecap 19e2ff0505e
[    0.003333] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.003333] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008c40660462 ecap f050da
[    0.003333] DMAR: RMRR base: 0x000000bf4af000 end: 0x000000bf4cefff
[    0.003333] DMAR: RMRR base: 0x000000ca000000 end: 0x000000cc7fffff
[    0.003333] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.003333] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.003333] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.003333] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.003333] x2apic enabled
[    0.003333] Switched APIC routing to cluster x2apic.
[    0.006666] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.023333] tsc: Detected 2900.000 MHz processor
[    0.023333] tsc: Detected 2904.000 MHz TSC
[    0.023333] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x29dc05e54fc, max_idle_ns: 440795291716 ns
[    0.023333] Calibrating delay loop (skipped), value calculated using timer frequency.. 5810.00 BogoMIPS (lpj=9680000)
[    0.023333] pid_max: default: 32768 minimum: 301
[    0.023333] Security Framework initialized
[    0.023333] Yama: becoming mindful.
[    0.027621] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.029345] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.029407] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.029458] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.029710] CPU: Physical Processor ID: 0
[    0.029711] CPU: Processor Core ID: 0
[    0.029723] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.029724] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.029740] mce: CPU supports 8 MCE banks
[    0.029753] CPU0: Thermal monitoring enabled (TM1)
[    0.029775] process: using mwait in idle threads
[    0.029778] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.029779] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.029780] Spectre V2 : Mitigation: Full generic retpoline
[    0.029781] Spectre V2 : Spectre v2 mitigation: Filling RSB on context switch
[    0.029782] Speculative Store Bypass: Vulnerable
[    0.035347] Freeing SMP alternatives memory: 28K
[    0.040645] TSC deadline timer enabled
[    0.040649] smpboot: CPU0: Intel(R) Core(TM) i7-7500U CPU @ 2.70GHz (family: 0x6, model: 0x8e, stepping: 0x9)
[    0.056714] Performance Events: PEBS fmt3+, Skylake events, 32-deep LBR, full-width counters, Intel PMU driver.
[    0.056756] ... version:                4
[    0.056756] ... bit width:              48
[    0.056757] ... generic registers:      4
[    0.056758] ... value mask:             0000ffffffffffff
[    0.056759] ... max period:             00007fffffffffff
[    0.056760] ... fixed-purpose events:   3
[    0.056761] ... event mask:             000000070000000f
[    0.060033] Hierarchical SRCU implementation.
[    0.070214] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
[    0.073366] smp: Bringing up secondary CPUs ...
[    0.096708] x86: Booting SMP configuration:
[    0.096710] .... node  #0, CPUs:      #1 #2 #3
[    0.144024] smp: Brought up 1 node, 4 CPUs
[    0.144024] smpboot: Max logical packages: 1
[    0.144024] smpboot: Total of 4 processors activated (23241.00 BogoMIPS)
[    0.147202] devtmpfs: initialized
[    0.147202] x86/mm: Memory block size: 128MB
[    0.148381] PM: Registering ACPI NVS region [mem 0xb50dd000-0xb50ddfff] (4096 bytes)
[    0.148381] PM: Registering ACPI NVS region [mem 0xbff2e000-0xbff99fff] (442368 bytes)
[    0.148381] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370867519511994 ns
[    0.148381] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.148381] pinctrl core: initialized pinctrl subsystem
[    0.148381] RTC time: 12:50:28, date: 06/29/18
[    0.148381] NET: Registered protocol family 16
[    0.148381] cpuidle: using governor ladder
[    0.148381] cpuidle: using governor menu
[    0.148381] Simple Boot Flag at 0x47 set to 0x1
[    0.150024] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.150025] ACPI: bus type PCI registered
[    0.150027] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.150251] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.150258] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.150258] PCI: Using configuration type 1 for base access
[    0.151310] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.151310] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.151310] ACPI: Added _OSI(Module Device)
[    0.151310] ACPI: Added _OSI(Processor Device)
[    0.151310] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.151310] ACPI: Added _OSI(Processor Aggregator Device)
[    0.151310] ACPI: Added _OSI(Linux-Dell-Video)
[    0.151310] ACPI: EC: EC started
[    0.151310] ACPI: EC: interrupt blocked
[    0.151310] ACPI: \: Used as first EC
[    0.151310] ACPI: \: GPE=0x16, EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.151310] ACPI: \: Used as boot ECDT EC to handle transactions
[    0.221706] ACPI: 11 ACPI AML tables successfully acquired and loaded
[    0.233471] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.246233] ACPI: Dynamic OEM Table Load:
[    0.246256] ACPI: SSDT 0xFFFF8EBD5FED8000 0006F6 (v02 PmRef  Cpu0Ist  00003000 INTL 20160527)
[    0.247219] ACPI: \_PR_.CPU0: _OSC native thermal LVT Acked
[    0.248990] ACPI: Dynamic OEM Table Load:
[    0.249001] ACPI: SSDT 0xFFFF8EBD5F93BC00 0003FF (v02 PmRef  Cpu0Cst  00003001 INTL 20160527)
[    0.249799] ACPI: Dynamic OEM Table Load:
[    0.249807] ACPI: SSDT 0xFFFF8EBD5F9E4A00 000115 (v02 PmRef  Cpu0Hwp  00003000 INTL 20160527)
[    0.250371] ACPI: Dynamic OEM Table Load:
[    0.250379] ACPI: SSDT 0xFFFF8EBD5F9E5000 0001A4 (v02 PmRef  HwpLvt   00003000 INTL 20160527)
[    0.251574] ACPI: Dynamic OEM Table Load:
[    0.251586] ACPI: SSDT 0xFFFF8EBD5FEDE000 00065C (v02 PmRef  ApIst    00003000 INTL 20160527)
[    0.252878] ACPI: Dynamic OEM Table Load:
[    0.252887] ACPI: SSDT 0xFFFF8EBD5F9E4600 000197 (v02 PmRef  ApHwp    00003000 INTL 20160527)
[    0.253656] ACPI: Dynamic OEM Table Load:
[    0.253665] ACPI: SSDT 0xFFFF8EBD5F9E5C00 00018A (v02 PmRef  ApCst    00003000 INTL 20160527)
[    0.256409] ACPI: Interpreter enabled
[    0.256483] ACPI: (supports S0 S3 S4 S5)
[    0.256485] ACPI: Using IOAPIC for interrupt routing
[    0.256544] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.257499] ACPI: Enabled 7 GPEs in block 00 to 7F
[    0.263270] ACPI: Power Resource [PUBS] (on)
[    0.263666] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
[    0.289999] ACPI: Power Resource [WRST] (on)
[    0.289999] ACPI: Power Resource [WRST] (on)
[    0.313096] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.313105] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.313378] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME AER PCIeCapability]
[    0.313380] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.313383] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.313384] acpi PNP0A08:00: _OSC: platform willing to grant []
[    0.313386] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.317252] PCI host bridge to bus 0000:00
[    0.317255] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.317257] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.317259] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.317261] pci_bus 0000:00: root bus resource [mem 0xcc800000-0xefffffff window]
[    0.317263] pci_bus 0000:00: root bus resource [mem 0xfd000000-0xfe7fffff window]
[    0.317265] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.317279] pci 0000:00:00.0: [8086:5904] type 00 class 0x060000
[    0.318636] pci 0000:00:02.0: [8086:5916] type 00 class 0x030000
[    0.318653] pci 0000:00:02.0: reg 0x10: [mem 0xe0000000-0xe0ffffff 64bit]
[    0.318662] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.318669] pci 0000:00:02.0: reg 0x20: [io  0xe000-0xe03f]
[    0.318690] pci 0000:00:02.0: BAR 2: assigned to efifb
[    0.319999] pci 0000:00:14.0: [8086:9d2f] type 00 class 0x0c0330
[    0.319999] pci 0000:00:14.0: reg 0x10: [mem 0xe1320000-0xe132ffff 64bit]
[    0.319999] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.319999] pci 0000:00:14.2: [8086:9d31] type 00 class 0x118000
[    0.319999] pci 0000:00:14.2: reg 0x10: [mem 0xe1348000-0xe1348fff 64bit]
[    0.319999] pci 0000:00:16.0: [8086:9d3a] type 00 class 0x078000
[    0.319999] pci 0000:00:16.0: reg 0x10: [mem 0xe1349000-0xe1349fff 64bit]
[    0.319999] pci 0000:00:16.0: PME# supported from D3hot
[    0.321338] pci 0000:00:1c.0: [8086:9d10] type 01 class 0x060400
[    0.321443] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.322881] pci 0000:00:1c.2: [8086:9d12] type 01 class 0x060400
[    0.322987] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.324426] pci 0000:00:1c.4: [8086:9d14] type 01 class 0x060400
[    0.324531] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.325967] pci 0000:00:1f.0: [8086:9d58] type 00 class 0x060100
[    0.327491] pci 0000:00:1f.2: [8086:9d21] type 00 class 0x058000
[    0.327509] pci 0000:00:1f.2: reg 0x10: [mem 0xe1344000-0xe1347fff]
[    0.328956] pci 0000:00:1f.3: [8086:9d71] type 00 class 0x040300
[    0.328991] pci 0000:00:1f.3: reg 0x10: [mem 0xe1340000-0xe1343fff 64bit]
[    0.329031] pci 0000:00:1f.3: reg 0x20: [mem 0xe1330000-0xe133ffff 64bit]
[    0.329099] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.330541] pci 0000:00:1f.4: [8086:9d23] type 00 class 0x0c0500
[    0.330597] pci 0000:00:1f.4: reg 0x10: [mem 0xe134a000-0xe134a0ff 64bit]
[    0.330649] pci 0000:00:1f.4: reg 0x20: [io  0xefa0-0xefbf]
[    0.332115] pci 0000:00:1f.6: [8086:15d8] type 00 class 0x020000
[    0.332145] pci 0000:00:1f.6: reg 0x10: [mem 0xe1300000-0xe131ffff]
[    0.332270] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
[    0.333824] pci 0000:02:00.0: [10ec:522a] type 00 class 0xff0000
[    0.333855] pci 0000:02:00.0: reg 0x10: [mem 0xe1200000-0xe1200fff]
[    0.333996] pci 0000:02:00.0: supports D1 D2
[    0.333998] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.334216] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.334222] pci 0000:00:1c.0:   bridge window [mem 0xe1200000-0xe12fffff]
[    0.334685] pci 0000:03:00.0: [8086:24fd] type 00 class 0x028000
[    0.334788] pci 0000:03:00.0: reg 0x10: [mem 0xe1100000-0xe1101fff 64bit]
[    0.335347] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.335988] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.335994] pci 0000:00:1c.2:   bridge window [mem 0xe1100000-0xe11fffff]
[    0.336114] pci 0000:04:00.0: [144d:a804] type 00 class 0x010802
[    0.336149] pci 0000:04:00.0: reg 0x10: [mem 0xe1000000-0xe1003fff 64bit]
[    0.336433] pci 0000:00:1c.4: PCI bridge to [bus 04]
[    0.336439] pci 0000:00:1c.4:   bridge window [mem 0xe1000000-0xe10fffff]
[    0.342864] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.342981] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.343094] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.343207] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.343318] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.343430] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.343541] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.343653] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.344466] ACPI: EC: interrupt unblocked
[    0.344514] ACPI: EC: event unblocked
[    0.344534] ACPI: \_SB_.PCI0.LPCB.EC__: GPE=0x16, EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.344536] ACPI: \_SB_.PCI0.LPCB.EC__: Used as boot DSDT EC to handle transactions and events
[    0.344649] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.344649] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.344649] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.344649] vgaarb: loaded
[    0.344649] pps_core: LinuxPPS API ver. 1 registered
[    0.344649] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.344649] PTP clock support registered
[    0.344649] EDAC MC: Ver: 3.0.0
[    0.344649] Registered efivars operations
[    0.373391] PCI: Using ACPI for IRQ routing
[    0.379999] PCI: pci_cache_line_size set to 64 bytes
[    0.379999] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    0.379999] e820: reserve RAM buffer [mem 0x0008c000-0x0008ffff]
[    0.379999] e820: reserve RAM buffer [mem 0xb14fb018-0xb3ffffff]
[    0.379999] e820: reserve RAM buffer [mem 0xb50dd000-0xb7ffffff]
[    0.379999] e820: reserve RAM buffer [mem 0xbea17000-0xbfffffff]
[    0.379999] e820: reserve RAM buffer [mem 0x432800000-0x433ffffff]
[    0.380002] NetLabel: Initializing
[    0.380002] NetLabel:  domain hash size = 128
[    0.380002] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.380002] NetLabel:  unlabeled traffic allowed by default
[    0.380086] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.380095] hpet0: 8 comparators, 64-bit 24.000000 MHz counter
[    0.383357] clocksource: Switched to clocksource tsc-early
[    0.397888] VFS: Disk quotas dquot_6.6.0
[    0.397908] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.397988] pnp: PnP ACPI init
[    0.398253] system 00:00: [mem 0xfd000000-0xfdabffff] has been reserved
[    0.398256] system 00:00: [mem 0xfdad0000-0xfdadffff] has been reserved
[    0.398259] system 00:00: [mem 0xfdb00000-0xfdffffff] has been reserved
[    0.398261] system 00:00: [mem 0xfe000000-0xfe01ffff] could not be reserved
[    0.398263] system 00:00: [mem 0xfe036000-0xfe03bfff] has been reserved
[    0.398266] system 00:00: [mem 0xfe03d000-0xfe3fffff] has been reserved
[    0.398268] system 00:00: [mem 0xfe410000-0xfe7fffff] has been reserved
[    0.398275] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.398808] system 00:01: [io  0xff00-0xfffe] has been reserved
[    0.398814] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.399887] system 00:02: [io  0x0680-0x069f] has been reserved
[    0.399890] system 00:02: [io  0xffff] has been reserved
[    0.399892] system 00:02: [io  0xffff] has been reserved
[    0.399894] system 00:02: [io  0xffff] has been reserved
[    0.399896] system 00:02: [io  0x1800-0x18fe] has been reserved
[    0.399899] system 00:02: [io  0x164e-0x164f] has been reserved
[    0.399904] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.400088] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.400145] system 00:04: [io  0x1854-0x1857] has been reserved
[    0.400151] system 00:04: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.400180] pnp 00:05: Plug and Play ACPI device, IDs LEN0071 PNP0303 (active)
[    0.400205] pnp 00:06: Plug and Play ACPI device, IDs LEN2046 PNP0f13 (active)
[    0.400369] system 00:07: [io  0x1800-0x189f] could not be reserved
[    0.400372] system 00:07: [io  0x0800-0x087f] has been reserved
[    0.400375] system 00:07: [io  0x0880-0x08ff] has been reserved
[    0.400377] system 00:07: [io  0x0900-0x097f] has been reserved
[    0.400379] system 00:07: [io  0x0980-0x09ff] has been reserved
[    0.400381] system 00:07: [io  0x0a00-0x0a7f] has been reserved
[    0.400384] system 00:07: [io  0x0a80-0x0aff] has been reserved
[    0.400386] system 00:07: [io  0x0b00-0x0b7f] has been reserved
[    0.400388] system 00:07: [io  0x0b80-0x0bff] has been reserved
[    0.400390] system 00:07: [io  0x15e0-0x15ef] has been reserved
[    0.400393] system 00:07: [io  0x1600-0x167f] could not be reserved
[    0.400395] system 00:07: [io  0x1640-0x165f] could not be reserved
[    0.400398] system 00:07: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.400400] system 00:07: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.400403] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.400405] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.400408] system 00:07: [mem 0xfeb00000-0xfebfffff] has been reserved
[    0.400410] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.400412] system 00:07: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.400415] system 00:07: [mem 0xeffe0000-0xefffffff] has been reserved
[    0.400420] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.402763] system 00:08: [mem 0xfdaf0000-0xfdafffff] has been reserved
[    0.402766] system 00:08: [mem 0xfdae0000-0xfdaeffff] has been reserved
[    0.402768] system 00:08: [mem 0xfdac0000-0xfdacffff] has been reserved
[    0.402773] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.403785] system 00:09: [mem 0xfed10000-0xfed17fff] could not be reserved
[    0.403788] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.403790] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.403792] system 00:09: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.403795] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.403797] system 00:09: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.403799] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.403802] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[    0.403804] system 00:09: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.403807] system 00:09: [mem 0xeffe0000-0xefffffff] has been reserved
[    0.403812] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.404419] system 00:0a: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.404421] system 00:0a: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.404423] system 00:0a: [mem 0x000c8000-0x000cbfff] could not be reserved
[    0.404426] system 00:0a: [mem 0x000d0000-0x000d3fff] could not be reserved
[    0.404428] system 00:0a: [mem 0x000d8000-0x000dbfff] could not be reserved
[    0.404430] system 00:0a: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.404432] system 00:0a: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.404434] system 00:0a: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.404437] system 00:0a: [mem 0x00100000-0xcc7fffff] could not be reserved
[    0.404439] system 00:0a: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.404442] system 00:0a: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.404447] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.404646] pnp: PnP ACPI: found 11 devices
[    0.410791] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.410841] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.410856] pci 0000:00:1c.0:   bridge window [mem 0xe1200000-0xe12fffff]
[    0.410872] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.410885] pci 0000:00:1c.2:   bridge window [mem 0xe1100000-0xe11fffff]
[    0.410902] pci 0000:00:1c.4: PCI bridge to [bus 04]
[    0.410914] pci 0000:00:1c.4:   bridge window [mem 0xe1000000-0xe10fffff]
[    0.410933] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.410937] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.410941] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.410945] pci_bus 0000:00: resource 7 [mem 0xcc800000-0xefffffff window]
[    0.410949] pci_bus 0000:00: resource 8 [mem 0xfd000000-0xfe7fffff window]
[    0.410953] pci_bus 0000:02: resource 1 [mem 0xe1200000-0xe12fffff]
[    0.410958] pci_bus 0000:03: resource 1 [mem 0xe1100000-0xe11fffff]
[    0.410962] pci_bus 0000:04: resource 1 [mem 0xe1000000-0xe10fffff]
[    0.411679] NET: Registered protocol family 2
[    0.411939] tcp_listen_portaddr_hash hash table entries: 8192 (order: 5, 131072 bytes)
[    0.412014] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.412281] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.412491] TCP: Hash tables configured (established 131072 bind 65536)
[    0.412535] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.412623] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.412712] NET: Registered protocol family 1
[    0.412731] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.413590] PCI: CLS 0 bytes, default 64
[    0.413635] Unpacking initramfs...
[    0.652327] Freeing initrd memory: 10492K
[    0.652383] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.652387] software IO TLB [mem 0xb9c7f000-0xbdc7f000] (64MB) mapped at [        (ptrval)-        (ptrval)]
[    0.652424] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x29dc05e54fc, max_idle_ns: 440795291716 ns
[    0.652450] clocksource: Switched to clocksource tsc
[    0.652600] Scanning for low memory corruption every 60 seconds
[    0.653301] Initialise system trusted keyrings
[    0.653313] Key type blacklist registered
[    0.653400] workingset: timestamp_bits=41 max_order=22 bucket_order=0
[    0.654984] zbud: loaded
[    0.655462] pstore: using lz4hc compression
[    0.656772] Key type asymmetric registered
[    0.656774] Asymmetric key parser 'x509' registered
[    0.656810] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 245)
[    0.656847] io scheduler noop registered
[    0.656849] io scheduler deadline registered
[    0.656900] io scheduler cfq registered (default)
[    0.656901] io scheduler mq-deadline registered
[    0.656902] io scheduler kyber registered
[    0.656910] io scheduler bfq registered
[    0.657970] efifb: probing for efifb
[    0.657987] efifb: framebuffer at 0xd0000000, using 8100k, total 8100k
[    0.657989] efifb: mode is 1920x1080x32, linelength=7680, pages=1
[    0.657990] efifb: scrolling: redraw
[    0.657992] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.663971] Console: switching to colour frame buffer device 240x67
[    0.669542] fb0: EFI VGA frame buffer device
[    0.669554] intel_idle: MWAIT substates: 0x11142120
[    0.669555] intel_idle: v0.4.1 model 0x8E
[    0.669824] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.669916] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    0.669931] ACPI: Sleep Button [SLPB]
[    0.669977] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.669984] ACPI: Lid Switch [LID]
[    0.670048] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.670057] ACPI: Power Button [PWRF]
[    0.674511] thermal LNXTHERM:00: registered as thermal_zone0
[    0.674513] ACPI: Thermal Zone [THM0] (55 C)
[    0.674824] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.696190] serial8250: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.698172] nvme nvme0: pci function 0000:04:00.0
[    0.698263] intel_pstate: Intel P-state driver initializing
[    0.698456] intel_pstate: HWP enabled
[    0.698769] ledtrig-cpu: registered to indicate activity on CPUs
[    0.698822] intel_pmc_core:  initialized
[    0.699073] NET: Registered protocol family 10
[    0.703313] Segment Routing with IPv6
[    0.703331] NET: Registered protocol family 17
[    0.703671] RAS: Correctable Errors collector initialized.
[    0.703740] microcode: sig=0x806e9, pf=0x80, revision=0x5e
[    0.703825] microcode: Microcode Update Driver: v2.2.
[    0.703834] sched_clock: Marking stable (703821209, 0)->(686117070, 17704139)
[    0.704063] registered taskstats version 1
[    0.704073] Loading compiled-in X.509 certificates
[    0.704086] zswap: loaded using pool lzo/zbud
[    0.706880] Key type big_key registered
[    0.707873]   Magic number: 6:240:836
[    0.707935] hctosys: unable to open rtc device (rtc0)
[    0.848200] Freeing unused kernel memory: 1476K
[    0.848201] Write protecting the kernel read-only data: 16384k
[    0.848978] Freeing unused kernel memory: 2016K
[    0.849742] Freeing unused kernel memory: 608K
[    0.929257]  nvme0n1: p1 p2
[    0.955848] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.958103] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.958142] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.962568] rtsx_pci 0000:02:00.0: enabling device (0000 -> 0002)
[    0.965256] cryptd: max_cpu_qlen set to 1000
[    0.965389] ACPI: bus type USB registered
[    0.965423] usbcore: registered new interface driver usbfs
[    0.965433] usbcore: registered new interface driver hub
[    0.965799] usbcore: registered new device driver usb
[    0.970999] AVX2 version of gcm_enc/dec engaged.
[    0.971000] AES CTR mode by8 optimization enabled
[    0.971192] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.971200] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    0.972303] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00109810
[    0.972308] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.972507] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 4.17
[    0.972509] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.972510] usb usb1: Product: xHCI Host Controller
[    0.972511] usb usb1: Manufacturer: Linux 4.17.2-1-ARCH xhci-hcd
[    0.972513] usb usb1: SerialNumber: 0000:00:14.0
[    0.972636] hub 1-0:1.0: USB hub found
[    0.972654] hub 1-0:1.0: 12 ports detected
[    0.974760] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.974764] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    0.974768] xhci_hcd 0000:00:14.0: Host supports USB 3.0  SuperSpeed
[    0.974806] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 4.17
[    0.974807] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.974827] usb usb2: Product: xHCI Host Controller
[    0.974828] usb usb2: Manufacturer: Linux 4.17.2-1-ARCH xhci-hcd
[    0.974829] usb usb2: SerialNumber: 0000:00:14.0
[    0.974927] hub 2-0:1.0: USB hub found
[    0.974939] hub 2-0:1.0: 6 ports detected
[    0.975224] usb: port power management may be unreliable
[    0.980190] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.990095] device-mapper: uevent: version 1.0.3
[    0.990151] device-mapper: ioctl: 4.39.0-ioctl (2018-04-03) initialised: dm-devel@redhat.com
[    1.303615] usb 2-1: new SuperSpeed USB device number 2 using xhci_hcd
[    1.323962] usb 2-1: New USB device found, idVendor=1f75, idProduct=0621, bcdDevice= 0.36
[    1.323966] usb 2-1: New USB device strings: Mfr=4, Product=5, SerialNumber=6
[    1.323968] usb 2-1: SerialNumber: 20180426
[    1.333565] SCSI subsystem initialized
[    1.335663] usb-storage 2-1:1.0: USB Mass Storage device detected
[    1.335826] scsi host0: usb-storage 2-1:1.0
[    1.335981] usbcore: registered new interface driver usb-storage
[    1.443510] usb 1-3: new high-speed USB device number 2 using xhci_hcd
[    1.590543] usb 1-3: New USB device found, idVendor=2cb7, idProduct=0002, bcdDevice=17.29
[    1.590547] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.590549] usb 1-3: Product: L831-EAU-00
[    1.590551] usb 1-3: Manufacturer: FIBOCOM
[    1.590553] usb 1-3: SerialNumber: 004999010640000
[    1.593084] random: fast init done
[    1.716625] mmc0: cannot verify signal voltage switch
[    1.730178] usb 1-5: new full-speed USB device number 3 using xhci_hcd
[    1.837166] mmc0: new ultra high speed SDR104 SDHC card at address 0007
[    1.838641] mmcblk0: mmc0:0007 SD16G 14.5 GiB 
[    1.844892]  mmcblk0: p1 p2 p3 p4 p5
[    1.879798] usb 1-5: New USB device found, idVendor=058f, idProduct=9540, bcdDevice= 1.20
[    1.879802] usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.879804] usb 1-5: Product: EMV Smartcard Reader
[    1.879806] usb 1-5: Manufacturer: Generic
[    2.003434] usb 1-7: new full-speed USB device number 4 using xhci_hcd
[    2.144889] usb 1-7: New USB device found, idVendor=8087, idProduct=0a2b, bcdDevice= 0.10
[    2.144892] usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.270183] usb 1-8: new high-speed USB device number 5 using xhci_hcd
[    2.348420] scsi 0:0:0:0: Direct-Access     Hitachi  HTS545050B9A300       PQ: 0 ANSI: 6
[    2.352651] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/466 GiB)
[    2.353470] sd 0:0:0:0: [sda] Write Protect is off
[    2.353473] sd 0:0:0:0: [sda] Mode Sense: 3b 00 00 00
[    2.354372] sd 0:0:0:0: [sda] No Caching mode page found
[    2.354410] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    2.359895] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.420363] usb 1-8: New USB device found, idVendor=04f2, idProduct=b5ab, bcdDevice= 0.10
[    2.420366] usb 1-8: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.420369] usb 1-8: Product: Integrated Camera
[    2.420371] usb 1-8: Manufacturer: SunplusIT Inc
[    2.543529] usb 1-9: new full-speed USB device number 6 using xhci_hcd
[    2.685567] usb 1-9: New USB device found, idVendor=138a, idProduct=0097, bcdDevice= 1.64
[    2.685571] usb 1-9: New USB device strings: Mfr=0, Product=0, SerialNumber=1
[    2.685574] usb 1-9: SerialNumber: 883180895429
[   12.586831] NET: Registered protocol family 38
[   12.866686] random: cryptsetup: uninitialized urandom read (2 bytes read)
[   12.917048] random: crng init done
[   12.922022] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[   13.031044] systemd[1]: RTC configured in localtime, applying delta of 120 minutes to system time.
[   13.059174] systemd[1]: systemd 238 running in system mode. (+PAM -AUDIT -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN +PCRE2 default-hierarchy=hybrid)
[   13.073794] systemd[1]: Detected architecture x86-64.
[   13.171676] systemd[1]: Reached target Swap.
[   13.175475] systemd[1]: Listening on Journal Socket.
[   13.175526] systemd[1]: Listening on LVM2 metadata daemon socket.
[   13.177376] systemd[1]: Mounting Temporary Directory (/tmp)...
[   13.177464] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[   13.177662] systemd[1]: Created slice system-getty.slice.
[   13.177964] systemd[1]: Created slice Virtual Machine and Container Slice.
[   13.178050] systemd[1]: Listening on LVM2 poll daemon socket.
[   13.188912] EXT4-fs (dm-0): re-mounted. Opts: data=ordered
[   13.197512] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   13.243244] systemd-journald[295]: Received request to flush runtime journal from PID 1
[   13.332731] acpi PNP0C14:02: duplicate WMI GUID 05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:01)
[   13.332843] acpi PNP0C14:03: duplicate WMI GUID 05901221-D566-11D1-B2F0-00A0C9062910 (first instance was on PNP0C14:01)
[   13.357318] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   13.360664] rtc_cmos 00:03: RTC can wake from S4
[   13.361139] rtc_cmos 00:03: registered as rtc0
[   13.361155] rtc_cmos 00:03: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[   13.372829] mei_me 0000:00:16.0: enabling device (0000 -> 0002)
[   13.374296] Linux agpgart interface v0.103
[   13.377542] tpm_tis MSFT0101:00: 2.0 TPM (device-id 0x1B, rev-id 16)
[   13.386791] ACPI: Battery Slot [BAT0] (battery present)
[   13.395031] Non-volatile memory driver v1.3
[   13.401986] thinkpad_acpi: ThinkPad ACPI Extras v0.26
[   13.401988] thinkpad_acpi: http://ibm-acpi.sf.net/
[   13.401988] thinkpad_acpi: ThinkPad BIOS R0IET38W (1.16 ), EC unknown
[   13.401989] thinkpad_acpi: Lenovo ThinkPad X270, model 20HN002UGE
[   13.406722] ACPI: Battery Slot [BAT1] (battery present)
[   13.407082] ACPI: AC Adapter [AC] (off-line)
[   13.411070] thinkpad_acpi: radio switch found; radios are enabled
[   13.411284] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   13.411285] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   13.415656] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[   13.417103] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
[   13.435515] usbcore: registered new interface driver uas
[   13.438544] usbcore: registered new interface driver cdc_ncm
[   13.438976] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[   13.447906] usbcore: registered new interface driver cdc_wdm
[   13.448719] i801_smbus 0000:00:1f.4: enabling device (0000 -> 0003)
[   13.448875] cdc_acm 1-3:1.2: ttyACM0: USB ACM device
[   13.450823] usbcore: registered new interface driver cdc_acm
[   13.450824] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   13.462706] i801_smbus 0000:00:1f.4: SPD Write Disable is set
[   13.462751] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[   13.465171] thinkpad_acpi: battery 2 registered (start 0, stop 100)
[   13.471381] input: PC Speaker as /devices/platform/pcspkr/input/input8
[   13.472900] thinkpad_acpi: battery 1 registered (start 0, stop 100)
[   13.472904] battery: new extension: ThinkPad Battery Extension
[   13.472946] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input7
[   13.496865] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[   13.496866] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[   13.497134] e1000e 0000:00:1f.6: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   13.501322] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 655360 ms ovfl timer
[   13.501323] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[   13.501324] RAPL PMU: hw unit of domain package 2^-14 Joules
[   13.501324] RAPL PMU: hw unit of domain dram 2^-14 Joules
[   13.501324] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[   13.501325] RAPL PMU: hw unit of domain psys 2^-14 Joules
[   13.502177] media: Linux media interface: v0.10
[   13.509674] Bluetooth: Core ver 2.22
[   13.509724] NET: Registered protocol family 31
[   13.509725] Bluetooth: HCI device and connection manager initialized
[   13.509729] Bluetooth: HCI socket layer initialized
[   13.509731] Bluetooth: L2CAP socket layer initialized
[   13.509737] Bluetooth: SCO socket layer initialized
[   13.512747] cdc_mbim 1-3:1.0: setting rx_max = 16384
[   13.513413] cdc_mbim 1-3:1.0: cdc-wdm0: USB WDM device
[   13.513580] cdc_mbim 1-3:1.0 wwan0: register 'cdc_mbim' at usb-0000:00:14.0-3, CDC MBIM, 0a:bf:76:51:80:00
[   13.513612] usbcore: registered new interface driver cdc_mbim
[   13.519406] intel_rapl: Found RAPL domain package
[   13.519408] intel_rapl: Found RAPL domain core
[   13.519409] intel_rapl: Found RAPL domain uncore
[   13.519410] intel_rapl: Found RAPL domain dram
[   13.558010] usbcore: registered new interface driver btusb
[   13.559085] Bluetooth: hci0: Firmware revision 0.1 build 226 week 17 2018
[   13.560947] Linux video capture interface: v2.00
[   13.563631] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[   13.574643] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   13.575622] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[   13.575624] cfg80211: failed to load regulatory.db
[   13.606850] Intel(R) Wireless WiFi driver for Linux
[   13.606851] Copyright(c) 2003- 2015 Intel Corporation
[   13.607832] iwlwifi 0000:03:00.0: enabling device (0000 -> 0002)
[   13.618688] iwlwifi 0000:03:00.0: loaded firmware version 36.e91976c0.0 op_mode iwlmvm
[   13.622482] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b5ab)
[   13.631404] iTCO_vendor_support: vendor-support=0
[   13.632313] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   13.632515] iTCO_wdt: Found a Intel PCH TCO device (Version=4, TCOBASE=0x0400)
[   13.632615] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   13.639087] cdc_mbim 1-3:1.0 wwp0s20f0u3: renamed from wwan0
[   13.643434] uvcvideo 1-8:1.0: Entity type for entity Extension 4 was not initialized!
[   13.643437] uvcvideo 1-8:1.0: Entity type for entity Extension 3 was not initialized!
[   13.643438] uvcvideo 1-8:1.0: Entity type for entity Processing 2 was not initialized!
[   13.643439] uvcvideo 1-8:1.0: Entity type for entity Camera 1 was not initialized!
[   13.644032] input: Integrated Camera: Integrated C as /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/input/input10
[   13.644980] usbcore: registered new interface driver uvcvideo
[   13.644981] USB Video Class driver (1.1.1)
[   13.692179] iwlwifi 0000:03:00.0: Detected Intel(R) Dual Band Wireless AC 8265, REV=0x230
[   13.755464] iwlwifi 0000:03:00.0: base HW address: f8:59:71:95:70:ae
[   13.779552] e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): registered PHC clock
[   13.834359] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[   13.834786] thermal thermal_zone3: failed to read out thermal zone (-61)
[   13.836268] iwlwifi 0000:03:00.0 wlp3s0: renamed from wlan0
[   13.860097] e1000e 0000:00:1f.6 eth0: (PCI Express:2.5GT/s:Width x1) 54:e1:ad:1d:ca:a7
[   13.860108] e1000e 0000:00:1f.6 eth0: Intel(R) PRO/1000 Network Connection
[   13.860167] e1000e 0000:00:1f.6 eth0: MAC: 12, PHY: 12, PBA No: 1000FF-0FF
[   13.862922] checking generic (d0000000 7e9000) vs hw (d0000000 10000000)
[   13.862925] fb: switching to inteldrmfb from EFI VGA
[   13.862956] Console: switching to colour dummy device 80x25
[   13.864155] [drm] Replacing VGA console driver
[   13.865814] e1000e 0000:00:1f.6 enp0s31f6: renamed from eth0
[   13.867177] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   13.867179] [drm] Driver supports precise vblank timestamp query.
[   13.868023] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   13.869528] [drm] Finished loading DMC firmware i915/kbl_dmc_ver1_04.bin (v1.4)
[   13.881061] [drm] Initialized i915 1.6.0 20180308 for 0000:00:02.0 on minor 0
[   13.886420] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   13.888734] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input11
[   13.890989] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
[   14.007438] fbcon: inteldrmfb (fb0) is primary device
[   14.025128] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC298: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[   14.025129] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   14.025130] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=2 (0x17/0x21/0x0/0x0/0x0)
[   14.025131] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[   14.025132] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[   14.025133] snd_hda_codec_realtek hdaudioC0D0:      Mic=0x18
[   14.025134] snd_hda_codec_realtek hdaudioC0D0:      Dock Mic=0x19
[   14.025134] snd_hda_codec_realtek hdaudioC0D0:      Internal Mic=0x12
[   14.078766] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1f.3/sound/card0/input12
[   14.080258] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1f.3/sound/card0/input13
[   14.080295] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1f.3/sound/card0/input14
[   14.080329] input: HDA Intel PCH Dock Headphone as /devices/pci0000:00/0000:00:1f.3/sound/card0/input15
[   14.080373] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1f.3/sound/card0/input16
[   14.080445] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input17
[   14.080492] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input18
[   14.080640] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input19
[   14.080678] input: HDA Intel PCH HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input20
[   14.080713] input: HDA Intel PCH HDMI/DP,pcm=10 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input21
[   14.271154] psmouse serio1: synaptics: queried max coordinates: x [..5712], y [..4780]
[   14.302525] psmouse serio1: synaptics: queried min coordinates: x [1232..], y [1074..]
[   14.302533] psmouse serio1: synaptics: Your touchpad (PNP: LEN2046 PNP0f13) says it can support a different bus. If i2c-hid and hid-rmi are not used, you might want to try setting psmouse.synaptics_intertouch to 1 and report this to linux-input@vger.kernel.org.
[   14.364947] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.2, id: 0x1e2b1, caps: 0xf407a3/0x943300/0x12e800/0x410000, board id: 3075, fw id: 2477413
[   14.364957] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[   14.404864] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input9
[   14.409516] mousedev: PS/2 mouse device common for all mice
[   15.050034] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   15.076773] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   15.076774] Bluetooth: BNEP filters: protocol multicast
[   15.076776] Bluetooth: BNEP socket layer initialized
[   15.209030] Console: switching to colour frame buffer device 240x67
[   15.231440] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   15.257140] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input22
[   15.292153] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[   15.303922] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
[   15.311526] IPv6: ADDRCONF(NETDEV_UP): br0: link is not ready
[   15.311855] br0: port 1(enp0s31f6) entered blocking state
[   15.311865] br0: port 1(enp0s31f6) entered disabled state
[   15.311923] device enp0s31f6 entered promiscuous mode
[   18.952808] wlp3s0: authenticate with bc:05:43:ef:65:46
[   18.967486] wlp3s0: send auth to bc:05:43:ef:65:46 (try 1/3)
[   18.977986] wlp3s0: authenticated
[   18.980075] wlp3s0: associate with bc:05:43:ef:65:46 (try 1/3)
[   18.988422] wlp3s0: RX AssocResp from bc:05:43:ef:65:46 (capab=0x411 status=0 aid=1)
[   18.991567] wlp3s0: associated
[   19.017418] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
[   19.025334] wlp3s0: Limiting TX power to 20 (23 - 3) dBm as advertised by bc:05:43:ef:65:46
[   21.228443] Bluetooth: RFCOMM TTY layer initialized
[   21.228451] Bluetooth: RFCOMM socket layer initialized
[   21.228459] Bluetooth: RFCOMM ver 1.11
[   22.211582] fuse init (API version 7.26)
[  103.770021] raid6: sse2x1   gen()  9909 MB/s
[  103.826709] raid6: sse2x1   xor()  8583 MB/s
[  103.883325] raid6: sse2x2   gen() 15448 MB/s
[  103.939989] raid6: sse2x2   xor() 10342 MB/s
[  103.996659] raid6: sse2x4   gen() 17274 MB/s
[  104.053325] raid6: sse2x4   xor() 10757 MB/s
[  104.109993] raid6: avx2x1   gen() 24628 MB/s
[  104.166660] raid6: avx2x1   xor() 17521 MB/s
[  104.223321] raid6: avx2x2   gen() 30986 MB/s
[  104.279993] raid6: avx2x2   xor() 18794 MB/s
[  104.336660] raid6: avx2x4   gen() 31577 MB/s
[  104.395439] raid6: avx2x4   xor() 18891 MB/s
[  104.395442] raid6: using algorithm avx2x4 gen() 31577 MB/s
[  104.395443] raid6: .... xor() 18891 MB/s, rmw enabled
[  104.395448] raid6: using avx2x2 recovery algorithm
[  104.399023] xor: automatically using best checksumming function   avx       
[  104.472689] Btrfs loaded, crc32c=crc32c-intel
[  104.495752] BTRFS: device label black devid 1 transid 351 /dev/dm-1
[  123.843842] BTRFS info (device dm-1): disk space caching is enabled
[  123.843846] BTRFS info (device dm-1): has skinny extents
[  124.544439] BTRFS error (device dm-1): bad tree block start 9385453728028469028 1082114048
[  124.555229] BTRFS error (device dm-1): bad tree block start 2365503423870651471 1082114048
[  124.555275] BTRFS warning (device dm-1): failed to read fs tree: -5
[  124.564446] BTRFS error (device dm-1): open_ctree failed

--------------5AD05FC204FC61ECD4F06CFD--
