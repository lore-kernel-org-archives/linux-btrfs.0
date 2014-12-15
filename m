Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:36422 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaLOEur (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Dec 2014 23:50:47 -0500
Received: by mail-wg0-f41.google.com with SMTP id y19so13555720wgg.14
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Dec 2014 20:50:45 -0800 (PST)
Received: from [192.168.0.234] (5-14-209-78.residential.rdsnet.ro. [5.14.209.78])
        by mx.google.com with ESMTPSA id wv8sm11499470wjc.44.2014.12.14.20.50.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Dec 2014 20:50:44 -0800 (PST)
Message-ID: <548E68A3.8040608@gmail.com>
Date: Mon, 15 Dec 2014 06:50:43 +0200
From: Nick Dimov <dimovnike@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs receive being very slow
Content-Type: multipart/mixed;
 boundary="------------000800010504090806060708"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000800010504090806060708
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello everyone!

First, thanks for amazing work on btrfs filesystem!

Now the problem:
I use a ssd as my system drive (/dev/sda2) and use daily snapshots on
it. Then, from time to time, i sync those on HDD (/dev/sdb4) by using
btrfs send / receive like this:

ionice -c3 btrfs send -p /ssd/previously_synced_snapshot /ssd/snapshot-X
| pv | btrfs receive /hdd/snapshots

I use pv to measure speed and i get ridiculos speeds like 5-200kiB/s! 
(rarely it goes over 1miB). However if i replace the btrfs receive with
cat >/dev/null - the speed is 400-500MiB/s (almost full SSD speed) so I
understand that the problem is the fs on the HDD... Do you have any idea
of how to trace this problem down?

Note: I had quota enabled on that hdd before and disable id since it was
making problems.

Any help is appreciated. Thanks!

here is some more information:
$ uname -a
Linux nick-G55VW 3.16.0-28-generic #37-Ubuntu SMP Mon Dec 8 17:15:28 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux

$ btrfs --version
Btrfs v3.14.1

$ sudo btrfs fi show
Label: none  uuid: 5f0ca1d2-b2c4-499e-a7df-efb2590b6502
    Total devices 1 FS bytes used 169.68GiB
    devid    1 size 300.00GiB used 300.00GiB path /dev/sda2

Label: 'hdd'  uuid: 35423c57-13e0-44e9-bacb-6f467ec4b885
    Total devices 1 FS bytes used 310.47GiB
    devid    1 size 447.44GiB used 447.44GiB path /dev/sdb4

Btrfs v3.14.1


btrfs fi df / # i create a readonly snapshot of this on every boot to
/mnt/snapshots (on the same SSD)
Data, single: total=289.99GiB, used=163.22GiB
System, single: total=4.00MiB, used=48.00KiB
Metadata, single: total=10.01GiB, used=6.46GiB
unknown, single: total=512.00MiB, used=0.00

btrfs fi df /home/ # i create a readonly snapshot on every GUI login
Data, single: total=289.99GiB, used=163.22GiB
System, single: total=4.00MiB, used=48.00KiB
Metadata, single: total=10.01GiB, used=6.46GiB
unknown, single: total=512.00MiB, used=0.00

btrfs fi df /mnt/snapshots # when syncing to HDD this is the source
Data, single: total=289.99GiB, used=163.22GiB
System, single: total=4.00MiB, used=48.00KiB
Metadata, single: total=10.01GiB, used=6.46GiB
unknown, single: total=512.00MiB, used=0.00

btrfs fi df /mnt/snapshots_hdd/@snapshots/ # the destination on the HDD
for syncing with btrfs receive
Data, single: total=436.41GiB, used=302.74GiB
System, single: total=32.00MiB, used=48.00KiB
Metadata, single: total=11.00GiB, used=7.47GiB
unknown, single: total=512.00MiB, used=12.00KiB



--------------000800010504090806060708
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-28-generic (buildd@komainu) (gcc version 4.9.1 (Ubuntu 4.9.1-16ubuntu6) ) #37-Ubuntu SMP Mon Dec 8 17:15:28 UTC 2014 (Ubuntu 3.16.0-28.37-generic 3.16.7-ckt1)
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.16.0-28-generic root=UUID=5f0ca1d2-b2c4-499e-a7df-efb2590b6502 ro rootflags=subvol=@ quiet splash intel_pstate=disable
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dd6f5fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dd6f6000-0x00000000dd6f7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dd6f8000-0x00000000dd704fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dd705000-0x00000000ddd05fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ddd06000-0x00000000ddd08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ddd09000-0x00000000ddd1ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddd20000-0x00000000ddd25fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ddd26000-0x00000000ddd27fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddd28000-0x00000000ddd31fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ddd32000-0x00000000ddec4fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddec5000-0x00000000ddec8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ddec9000-0x00000000ddf12fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddf13000-0x00000000ddf37fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ddf38000-0x00000000ddf3afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddf3b000-0x00000000ddf3cfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ddf3d000-0x00000000ddf53fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddf54000-0x00000000ddf59fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ddf5a000-0x00000000ddf61fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddf62000-0x00000000ddf62fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ddf63000-0x00000000ddf71fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddf72000-0x00000000ddf72fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ddf73000-0x00000000ddf7dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddf7e000-0x00000000ddf82fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ddf83000-0x00000000ddfaefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddfaf000-0x00000000ddfaffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ddfb0000-0x00000000ddfbffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddfc0000-0x00000000ddfe7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ddfe8000-0x00000000ddffbfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddffc000-0x00000000ddffcfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ddffd000-0x00000000ddffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ddffe000-0x00000000ddffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000de000000-0x00000000de001fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de002000-0x00000000de006fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000de007000-0x00000000de01afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de01b000-0x00000000de5e2fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000de5e3000-0x00000000de862fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000de863000-0x00000000de867fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000de868000-0x00000000de868fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de869000-0x00000000de8abfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000de8ac000-0x00000000decbefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000decbf000-0x00000000deff3fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000deff4000-0x00000000deffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021f3fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: ASUSTeK COMPUTER INC. G55VW/G55VW, BIOS G55VW.217 11/05/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x21f400 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FF0000000 write-back
[    0.000000]   2 base 210000000 mask FF8000000 write-back
[    0.000000]   3 base 218000000 mask FFC000000 write-back
[    0.000000]   4 base 21C000000 mask FFE000000 write-back
[    0.000000]   5 base 21E000000 mask FFF000000 write-back
[    0.000000]   6 base 21F000000 mask FFFC00000 write-back
[    0.000000]   7 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   8 base 0DFC00000 mask FFFC00000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 8GB, type WB
[    0.000000] reg 1, base: 8GB, range: 256MB, type WB
[    0.000000] reg 2, base: 8448MB, range: 128MB, type WB
[    0.000000] reg 3, base: 8576MB, range: 64MB, type WB
[    0.000000] reg 4, base: 8640MB, range: 32MB, type WB
[    0.000000] reg 5, base: 8672MB, range: 16MB, type WB
[    0.000000] reg 6, base: 8688MB, range: 4MB, type WB
[    0.000000] reg 7, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 8, base: 3580MB, range: 4MB, type UC
[    0.000000] total RAM covered: 8176M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 512MB, type WB
[    0.000000] reg 3, base: 3580MB, range: 4MB, type UC
[    0.000000] reg 4, base: 4GB, range: 4GB, type WB
[    0.000000] reg 5, base: 8GB, range: 512MB, type WB
[    0.000000] reg 6, base: 8692MB, range: 4MB, type UC
[    0.000000] reg 7, base: 8696MB, range: 8MB, type UC
[    0.000000] e820: update [mem 0xdfc00000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdf000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd830-0x000fd83f] mapped at [ffff8800000fd830]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fd2000, 0x01fd2fff] PGTABLE
[    0.000000] BRK [0x01fd3000, 0x01fd3fff] PGTABLE
[    0.000000] BRK [0x01fd4000, 0x01fd4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21f200000-0x21f3fffff]
[    0.000000]  [mem 0x21f200000-0x21f3fffff] page 2M
[    0.000000] BRK [0x01fd5000, 0x01fd5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21c000000-0x21f1fffff]
[    0.000000]  [mem 0x21c000000-0x21f1fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x21bffffff]
[    0.000000]  [mem 0x200000000-0x21bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdd6f5fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdd5fffff] page 2M
[    0.000000]  [mem 0xdd600000-0xdd6f5fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdd6f8000-0xdd704fff]
[    0.000000]  [mem 0xdd6f8000-0xdd704fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xddd09000-0xddd1ffff]
[    0.000000]  [mem 0xddd09000-0xddd1ffff] page 4k
[    0.000000] BRK [0x01fd6000, 0x01fd6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xddd26000-0xddd27fff]
[    0.000000]  [mem 0xddd26000-0xddd27fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xddd32000-0xddec4fff]
[    0.000000]  [mem 0xddd32000-0xddec4fff] page 4k
[    0.000000] BRK [0x01fd7000, 0x01fd7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xddec9000-0xddf12fff]
[    0.000000]  [mem 0xddec9000-0xddf12fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xddf38000-0xddf3afff]
[    0.000000]  [mem 0xddf38000-0xddf3afff] page 4k
[    0.000000] init_memory_mapping: [mem 0xddf3d000-0xddf53fff]
[    0.000000]  [mem 0xddf3d000-0xddf53fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xddf5a000-0xddf61fff]
[    0.000000]  [mem 0xddf5a000-0xddf61fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xddf63000-0xddf71fff]
[    0.000000]  [mem 0xddf63000-0xddf71fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xddf73000-0xddf7dfff]
[    0.000000]  [mem 0xddf73000-0xddf7dfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xddf83000-0xddfaefff]
[    0.000000]  [mem 0xddf83000-0xddfaefff] page 4k
[    0.000000] init_memory_mapping: [mem 0xddfb0000-0xddfbffff]
[    0.000000]  [mem 0xddfb0000-0xddfbffff] page 4k
[    0.000000] init_memory_mapping: [mem 0xddfe8000-0xddffbfff]
[    0.000000]  [mem 0xddfe8000-0xddffbfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xddffd000-0xddffdfff]
[    0.000000]  [mem 0xddffd000-0xddffdfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xde000000-0xde001fff]
[    0.000000]  [mem 0xde000000-0xde001fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xde007000-0xde01afff]
[    0.000000]  [mem 0xde007000-0xde01afff] page 4k
[    0.000000] init_memory_mapping: [mem 0xde868000-0xde868fff]
[    0.000000]  [mem 0xde868000-0xde868fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xde8ac000-0xdecbefff]
[    0.000000]  [mem 0xde8ac000-0xde9fffff] page 4k
[    0.000000]  [mem 0xdea00000-0xdebfffff] page 2M
[    0.000000]  [mem 0xdec00000-0xdecbefff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdeff4000-0xdeffffff]
[    0.000000]  [mem 0xdeff4000-0xdeffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x356ce000-0x36b5efff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 _ASUS_)
[    0.000000] ACPI: XSDT 0x00000000DE839078 000074 (v01 _ASUS_ Notebook 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DE849E20 00010C (v05 _ASUS_ Notebook 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000DE839188 010C93 (v02 _ASUS_ Notebook 00000013 INTL 20091112)
[    0.000000] ACPI: FACS 0x00000000DE860080 000040
[    0.000000] ACPI: APIC 0x00000000DE849F30 000092 (v03 _ASUS_ Notebook 01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000DE849FC8 000044 (v01 _ASUS_ Notebook 01072009 AMI  00010013)
[    0.000000] ACPI: ECDT 0x00000000DE84A010 0000C1 (v01 _ASUS_ Notebook 01072009 AMI. 00000005)
[    0.000000] ACPI: MCFG 0x00000000DE84A0D8 00003C (v01 _ASUS_ Notebook 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000DE84A118 000038 (v01 _ASUS_ Notebook 01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000DE84A150 00066E (v01 AhciR1 AhciTab1 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000DE84A7C0 00049E (v01 AhciR2 AhciTab2 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000DE84AC60 00094C (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000DE84B5B0 000A92 (v01 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021f3fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x21f3fffff]
[    0.000000]   NODE_DATA [mem 0x21f3ef000-0x21f3f3fff]
[    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD -> [ffff880216a00000-ffff88021e9fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21f3fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xdd6f5fff]
[    0.000000]   node   0: [mem 0xdd6f8000-0xdd704fff]
[    0.000000]   node   0: [mem 0xddd09000-0xddd1ffff]
[    0.000000]   node   0: [mem 0xddd26000-0xddd27fff]
[    0.000000]   node   0: [mem 0xddd32000-0xddec4fff]
[    0.000000]   node   0: [mem 0xddec9000-0xddf12fff]
[    0.000000]   node   0: [mem 0xddf38000-0xddf3afff]
[    0.000000]   node   0: [mem 0xddf3d000-0xddf53fff]
[    0.000000]   node   0: [mem 0xddf5a000-0xddf61fff]
[    0.000000]   node   0: [mem 0xddf63000-0xddf71fff]
[    0.000000]   node   0: [mem 0xddf73000-0xddf7dfff]
[    0.000000]   node   0: [mem 0xddf83000-0xddfaefff]
[    0.000000]   node   0: [mem 0xddfb0000-0xddfbffff]
[    0.000000]   node   0: [mem 0xddfe8000-0xddffbfff]
[    0.000000]   node   0: [mem 0xddffd000-0xddffdfff]
[    0.000000]   node   0: [mem 0xde000000-0xde001fff]
[    0.000000]   node   0: [mem 0xde007000-0xde01afff]
[    0.000000]   node   0: [mem 0xde868000-0xde868fff]
[    0.000000]   node   0: [mem 0xde8ac000-0xdecbefff]
[    0.000000]   node   0: [mem 0xdeff4000-0xdeffffff]
[    0.000000]   node   0: [mem 0x100000000-0x21f3fffff]
[    0.000000] On node 0 totalpages: 2085208
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14135 pages used for memmap
[    0.000000]   DMA32 zone: 904636 pages, LIFO batch:31
[    0.000000]   Normal zone: 18384 pages used for memmap
[    0.000000]   Normal zone: 1176576 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd6f6000-0xdd6f7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd705000-0xddd05fff]
[    0.000000] PM: Registered nosave memory: [mem 0xddd06000-0xddd08fff]
[    0.000000] PM: Registered nosave memory: [mem 0xddd20000-0xddd25fff]
[    0.000000] PM: Registered nosave memory: [mem 0xddd28000-0xddd31fff]
[    0.000000] PM: Registered nosave memory: [mem 0xddec5000-0xddec8fff]
[    0.000000] PM: Registered nosave memory: [mem 0xddf13000-0xddf37fff]
[    0.000000] PM: Registered nosave memory: [mem 0xddf3b000-0xddf3cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xddf54000-0xddf59fff]
[    0.000000] PM: Registered nosave memory: [mem 0xddf62000-0xddf62fff]
[    0.000000] PM: Registered nosave memory: [mem 0xddf72000-0xddf72fff]
[    0.000000] PM: Registered nosave memory: [mem 0xddf7e000-0xddf82fff]
[    0.000000] PM: Registered nosave memory: [mem 0xddfaf000-0xddfaffff]
[    0.000000] PM: Registered nosave memory: [mem 0xddfc0000-0xddfe7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xddffc000-0xddffcfff]
[    0.000000] PM: Registered nosave memory: [mem 0xddffe000-0xddffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xde002000-0xde006fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde01b000-0xde5e2fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde5e3000-0xde862fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde863000-0xde867fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde869000-0xde8abfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdecbf000-0xdeff3fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf000000-0xf7ffffff]
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
[    0.000000] e820: [mem 0xdf000000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88021f000000 s83328 r8192 d23168 u262144
[    0.000000] pcpu-alloc: s83328 r8192 d23168 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2052604
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.16.0-28-generic root=UUID=5f0ca1d2-b2c4-499e-a7df-efb2590b6502 ro rootflags=subvol=@ quiet splash intel_pstate=disable
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8105112K/8340832K available (7740K kernel code, 1200K rwdata, 3608K rodata, 1356K init, 1308K bss, 235720K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:16640 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2394.580 MHz processor
[    0.000035] Calibrating delay loop (skipped), value calculated using timer frequency.. 4789.16 BogoMIPS (lpj=9578320)
[    0.000037] pid_max: default: 32768 minimum: 301
[    0.000044] ACPI: Core revision 20140424
[    0.012535] ACPI: All ACPI Tables successfully acquired
[    0.013309] Security Framework initialized
[    0.013325] AppArmor: AppArmor initialized
[    0.013326] Yama: becoming mindful.
[    0.013829] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.015843] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.016758] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.016767] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.016971] Initializing cgroup subsys memory
[    0.016992] Initializing cgroup subsys devices
[    0.016998] Initializing cgroup subsys freezer
[    0.017001] Initializing cgroup subsys net_cls
[    0.017004] Initializing cgroup subsys blkio
[    0.017007] Initializing cgroup subsys perf_event
[    0.017009] Initializing cgroup subsys net_prio
[    0.017015] Initializing cgroup subsys hugetlb
[    0.017036] CPU: Physical Processor ID: 0
[    0.017037] CPU: Processor Core ID: 0
[    0.017041] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.017414] mce: CPU supports 9 MCE banks
[    0.017426] CPU0: Thermal monitoring enabled (TM1)
[    0.017435] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
tlb_flushall_shift: 2
[    0.017557] Freeing SMP alternatives memory: 32K (ffffffff81e81000 - ffffffff81e89000)
[    0.018794] ftrace: allocating 29301 entries in 115 pages
[    0.033094] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.072812] smpboot: CPU0: Intel(R) Core(TM) i7-3630QM CPU @ 2.40GHz (fam: 06, model: 3a, stepping: 09)
[    0.072820] TSC deadline timer enabled
[    0.072839] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.072859] ... version:                3
[    0.072859] ... bit width:              48
[    0.072860] ... generic registers:      4
[    0.072861] ... value mask:             0000ffffffffffff
[    0.072862] ... max period:             0000ffffffffffff
[    0.072863] ... fixed-purpose events:   3
[    0.072864] ... event mask:             000000070000000f
[    0.074593] x86: Booting SMP configuration:
[    0.074595] .... node  #0, CPUs:      #1
[    0.088110] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.088190]  #2 #3 #4 #5 #6 #7
[    0.169942] x86: Booted up 1 node, 8 CPUs
[    0.169945] smpboot: Total of 8 processors activated (38313.28 BogoMIPS)
[    0.177459] devtmpfs: initialized
[    0.180019] evm: security.selinux
[    0.180021] evm: security.SMACK64
[    0.180022] evm: security.SMACK64EXEC
[    0.180022] evm: security.SMACK64TRANSMUTE
[    0.180023] evm: security.SMACK64MMAP
[    0.180024] evm: security.ima
[    0.180025] evm: security.capability
[    0.180084] PM: Registering ACPI NVS region [mem 0xdd705000-0xddd05fff] (6295552 bytes)
[    0.180159] PM: Registering ACPI NVS region [mem 0xde5e3000-0xde862fff] (2621440 bytes)
[    0.180191] PM: Registering ACPI NVS region [mem 0xde869000-0xde8abfff] (274432 bytes)
[    0.181029] pinctrl core: initialized pinctrl subsystem
[    0.181095] regulator-dummy: no parameters
[    0.181129] RTC time:  3:27:40, date: 12/15/14
[    0.181177] NET: Registered protocol family 16
[    0.181334] cpuidle: using governor ladder
[    0.181337] cpuidle: using governor menu
[    0.181395] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.181396] ACPI: bus type PCI registered
[    0.181398] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.181469] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.181471] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.181552] PCI: Using configuration type 1 for base access
[    0.185655] ACPI: Added _OSI(Module Device)
[    0.185657] ACPI: Added _OSI(Processor Device)
[    0.185658] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.185659] ACPI: Added _OSI(Processor Aggregator Device)
[    0.187455] ACPI : EC: EC description table is found, configuring boot EC
[    0.189304] ACPI: Executed 1 blocks of module-level executable AML code
[    0.193367] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.193706] ACPI: Dynamic OEM Table Load:
[    0.193714] ACPI: SSDT 0xFFFF880213369000 000853 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.197530] ACPI: Dynamic OEM Table Load:
[    0.197537] ACPI: SSDT 0xFFFF8802137F1000 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.201387] ACPI: Dynamic OEM Table Load:
[    0.201391] ACPI: SSDT 0xFFFF8802133A0000 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.206416] ACPI: Interpreter enabled
[    0.206423] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
[    0.206428] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    0.206442] ACPI: (supports S0 S3 S4 S5)
[    0.206444] ACPI: Using IOAPIC for interrupt routing
[    0.206468] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.212054] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.212059] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.212274] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.212399] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.212955] PCI host bridge to bus 0000:00
[    0.212958] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.212960] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.212961] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.212963] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.212965] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.212966] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.212968] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.212969] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.212971] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.212972] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.212974] pci_bus 0000:00: root bus resource [mem 0xdfc00000-0xfeafffff]
[    0.212981] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    0.213066] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
[    0.213098] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.213136] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.213198] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.213222] pci 0000:00:14.0: reg 0x10: [mem 0xf7300000-0xf730ffff 64bit]
[    0.213297] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.213339] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.213379] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.213405] pci 0000:00:16.0: reg 0x10: [mem 0xf731b000-0xf731b00f 64bit]
[    0.213482] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.213568] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.213591] pci 0000:00:1a.0: reg 0x10: [mem 0xf7318000-0xf73183ff]
[    0.213683] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.213725] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.213765] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.213782] pci 0000:00:1b.0: reg 0x10: [mem 0xf7310000-0xf7313fff 64bit]
[    0.213858] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.213906] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.213943] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.214028] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.214072] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.214109] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
[    0.214193] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.214274] pci 0000:00:1c.3: [8086:1e16] type 01 class 0x060400
[    0.214358] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.214402] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.214443] pci 0000:00:1c.4: [8086:1e18] type 01 class 0x060400
[    0.214579] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.214633] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.214677] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.214698] pci 0000:00:1d.0: reg 0x10: [mem 0xf7317000-0xf73173ff]
[    0.214790] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.214833] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.214870] pci 0000:00:1f.0: [8086:1e57] type 00 class 0x060100
[    0.215044] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    0.215064] pci 0000:00:1f.2: reg 0x10: [io  0xf070-0xf077]
[    0.215072] pci 0000:00:1f.2: reg 0x14: [io  0xf060-0xf063]
[    0.215081] pci 0000:00:1f.2: reg 0x18: [io  0xf050-0xf057]
[    0.215089] pci 0000:00:1f.2: reg 0x1c: [io  0xf040-0xf043]
[    0.215097] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[    0.215106] pci 0000:00:1f.2: reg 0x24: [mem 0xf7316000-0xf73167ff]
[    0.520512] pci 0000:00:1f.2: PME# supported from D3hot
[    0.520584] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.520600] pci 0000:00:1f.3: reg 0x10: [mem 0xf7315000-0xf73150ff 64bit]
[    0.520622] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[    0.520747] pci 0000:01:00.0: [10de:0fd4] type 00 class 0x030000
[    0.520757] pci 0000:01:00.0: reg 0x10: [mem 0xf6000000-0xf6ffffff]
[    0.520767] pci 0000:01:00.0: reg 0x14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.520777] pci 0000:01:00.0: reg 0x1c: [mem 0xf0000000-0xf1ffffff 64bit pref]
[    0.520784] pci 0000:01:00.0: reg 0x24: [io  0xe000-0xe07f]
[    0.520790] pci 0000:01:00.0: reg 0x30: [mem 0xf7000000-0xf707ffff pref]
[    0.520873] pci 0000:01:00.1: [10de:0e1b] type 00 class 0x040300
[    0.520883] pci 0000:01:00.1: reg 0x10: [mem 0xf7080000-0xf7083fff]
[    0.528537] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.528542] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.528547] pci 0000:00:01.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.528561] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
[    0.528620] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.528720] pci 0000:03:00.0: [168c:0032] type 00 class 0x028000
[    0.528751] pci 0000:03:00.0: reg 0x10: [mem 0xf7200000-0xf727ffff 64bit]
[    0.528816] pci 0000:03:00.0: reg 0x30: [mem 0xf7280000-0xf728ffff pref]
[    0.528902] pci 0000:03:00.0: supports D1 D2
[    0.528904] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.528936] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.536553] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.536574] pci 0000:00:1c.1:   bridge window [mem 0xf7200000-0xf72fffff]
[    0.536667] pci 0000:04:00.0: [1969:1083] type 00 class 0x020000
[    0.536699] pci 0000:04:00.0: reg 0x10: [mem 0xf7100000-0xf713ffff 64bit]
[    0.536714] pci 0000:04:00.0: reg 0x18: [io  0xd000-0xd07f]
[    0.536851] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.536884] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.544569] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.544585] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.544589] pci 0000:00:1c.3:   bridge window [mem 0xf7100000-0xf71fffff]
[    0.544695] acpiphp: Slot [1] registered
[    0.544702] pci 0000:00:1c.4: PCI bridge to [bus 05]
[    0.544750] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.545213] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12)
[    0.545260] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 12)
[    0.545305] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 12)
[    0.545348] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 12)
[    0.545392] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 12) *0, disabled.
[    0.545435] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 12) *0, disabled.
[    0.545477] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 *4 5 6 7 10 12)
[    0.545519] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 12)
[    0.545649] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.545711] ACPI : EC: GPE = 0x19, I/O: command/status = 0x66, data = 0x62
[    0.545802] vgaarb: setting as boot device: PCI:0000:01:00.0
[    0.545804] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.545805] vgaarb: loaded
[    0.545807] vgaarb: bridge control possible 0000:01:00.0
[    0.546020] SCSI subsystem initialized
[    0.546073] libata version 3.00 loaded.
[    0.546097] ACPI: bus type USB registered
[    0.546113] usbcore: registered new interface driver usbfs
[    0.546120] usbcore: registered new interface driver hub
[    0.546140] usbcore: registered new device driver usb
[    0.546293] PCI: Using ACPI for IRQ routing
[    0.547827] PCI: pci_cache_line_size set to 64 bytes
[    0.547883] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.547885] e820: reserve RAM buffer [mem 0xdd6f6000-0xdfffffff]
[    0.547890] e820: reserve RAM buffer [mem 0xdd705000-0xdfffffff]
[    0.547895] e820: reserve RAM buffer [mem 0xddd20000-0xdfffffff]
[    0.547900] e820: reserve RAM buffer [mem 0xddd28000-0xdfffffff]
[    0.547905] e820: reserve RAM buffer [mem 0xddec5000-0xdfffffff]
[    0.547910] e820: reserve RAM buffer [mem 0xddf13000-0xdfffffff]
[    0.547914] e820: reserve RAM buffer [mem 0xddf3b000-0xdfffffff]
[    0.547919] e820: reserve RAM buffer [mem 0xddf54000-0xdfffffff]
[    0.547923] e820: reserve RAM buffer [mem 0xddf62000-0xdfffffff]
[    0.547927] e820: reserve RAM buffer [mem 0xddf72000-0xdfffffff]
[    0.547931] e820: reserve RAM buffer [mem 0xddf7e000-0xdfffffff]
[    0.547935] e820: reserve RAM buffer [mem 0xddfaf000-0xdfffffff]
[    0.547938] e820: reserve RAM buffer [mem 0xddfc0000-0xdfffffff]
[    0.547941] e820: reserve RAM buffer [mem 0xddffc000-0xdfffffff]
[    0.547944] e820: reserve RAM buffer [mem 0xddffe000-0xdfffffff]
[    0.547947] e820: reserve RAM buffer [mem 0xde002000-0xdfffffff]
[    0.547950] e820: reserve RAM buffer [mem 0xde01b000-0xdfffffff]
[    0.547952] e820: reserve RAM buffer [mem 0xde869000-0xdfffffff]
[    0.547954] e820: reserve RAM buffer [mem 0xdecbf000-0xdfffffff]
[    0.547956] e820: reserve RAM buffer [mem 0xdf000000-0xdfffffff]
[    0.547957] e820: reserve RAM buffer [mem 0x21f400000-0x21fffffff]
[    0.548061] NetLabel: Initializing
[    0.548062] NetLabel:  domain hash size = 128
[    0.548063] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.548073] NetLabel:  unlabeled traffic allowed by default
[    0.548141] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.548146] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.550187] Switched to clocksource hpet
[    0.555190] AppArmor: AppArmor Filesystem Enabled
[    0.555220] pnp: PnP ACPI init
[    0.555234] ACPI: bus type PNP registered
[    0.555314] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.555317] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.555434] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.555436] system 00:01: [io  0x1000-0x100f] has been reserved
[    0.555438] system 00:01: [io  0xffff] has been reserved
[    0.555440] system 00:01: [io  0xffff] has been reserved
[    0.555441] system 00:01: [io  0x0400-0x0453] could not be reserved
[    0.555443] system 00:01: [io  0x0458-0x047f] has been reserved
[    0.555445] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.555446] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.555449] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.555478] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.555528] system 00:03: [io  0x0454-0x0457] has been reserved
[    0.555530] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.555579] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    0.555582] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.555617] system 00:05: [io  0x0240-0x0259] has been reserved
[    0.555619] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.555675] pnp 00:06: Plug and Play ACPI device, IDs ETD0101 SYN0a00 SYN0002 PNP0f03 PNP0f13 PNP0f12 (active)
[    0.555713] pnp 00:07: Plug and Play ACPI device, IDs ATK3001 PNP030b (active)
[    0.555861] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.555863] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.555865] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.555867] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.555869] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.555870] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.555872] system 00:08: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.555874] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.555876] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.555878] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.555880] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.555991] pnp: PnP ACPI: found 9 devices
[    0.555992] ACPI: bus type PNP unregistered
[    0.562414] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 05] add_size 1000
[    0.562417] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 05] add_size 200000
[    0.562419] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff] to [bus 05] add_size 200000
[    0.562423] pci 0000:00:1c.4: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.562425] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.562426] pci 0000:00:1c.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.562432] pci 0000:00:1c.4: BAR 14: assigned [mem 0xdfc00000-0xdfdfffff]
[    0.562440] pci 0000:00:1c.4: BAR 15: assigned [mem 0xdfe00000-0xdfffffff 64bit pref]
[    0.562443] pci 0000:00:1c.4: BAR 13: assigned [io  0x2000-0x2fff]
[    0.562445] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.562447] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.562450] pci 0000:00:01.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.562452] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
[    0.562455] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.562467] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.562472] pci 0000:00:1c.1:   bridge window [mem 0xf7200000-0xf72fffff]
[    0.562481] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.562484] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.562490] pci 0000:00:1c.3:   bridge window [mem 0xf7100000-0xf71fffff]
[    0.562498] pci 0000:00:1c.4: PCI bridge to [bus 05]
[    0.562502] pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
[    0.562507] pci 0000:00:1c.4:   bridge window [mem 0xdfc00000-0xdfdfffff]
[    0.562512] pci 0000:00:1c.4:   bridge window [mem 0xdfe00000-0xdfffffff 64bit pref]
[    0.562522] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.562523] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.562525] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.562527] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.562528] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.562529] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.562531] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.562533] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.562534] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.562536] pci_bus 0000:00: resource 13 [mem 0xdfc00000-0xfeafffff]
[    0.562537] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.562539] pci_bus 0000:01: resource 1 [mem 0xf6000000-0xf70fffff]
[    0.562540] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xf1ffffff 64bit pref]
[    0.562542] pci_bus 0000:03: resource 1 [mem 0xf7200000-0xf72fffff]
[    0.562544] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.562545] pci_bus 0000:04: resource 1 [mem 0xf7100000-0xf71fffff]
[    0.562547] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.562548] pci_bus 0000:05: resource 1 [mem 0xdfc00000-0xdfdfffff]
[    0.562550] pci_bus 0000:05: resource 2 [mem 0xdfe00000-0xdfffffff 64bit pref]
[    0.562578] NET: Registered protocol family 2
[    0.562747] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.562888] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.562993] TCP: Hash tables configured (established 65536 bind 65536)
[    0.563007] TCP: reno registered
[    0.563017] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.563042] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.563100] NET: Registered protocol family 1
[    0.606350] pci 0000:01:00.0: Video device with shadowed ROM
[    0.606367] PCI: CLS 64 bytes, default 64
[    0.606413] Trying to unpack rootfs image as initramfs...
[    0.927141] Freeing initrd memory: 21060K (ffff8800356ce000 - ffff880036b5f000)
[    0.927173] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.927175] software IO TLB [mem 0xd96f6000-0xdd6f6000] (64MB) mapped at [ffff8800d96f6000-ffff8800dd6f5fff]
[    0.927545] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.927595] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x12
[    0.927602] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x12
[    0.927607] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x12
[    0.927615] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x12
[    0.927622] microcode: CPU4 sig=0x306a9, pf=0x10, revision=0x12
[    0.927629] microcode: CPU5 sig=0x306a9, pf=0x10, revision=0x12
[    0.927637] microcode: CPU6 sig=0x306a9, pf=0x10, revision=0x12
[    0.927645] microcode: CPU7 sig=0x306a9, pf=0x10, revision=0x12
[    0.927693] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.927716] Scanning for low memory corruption every 60 seconds
[    0.928030] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.928051] Initialise system trusted keyring
[    0.928073] audit: initializing netlink subsys (disabled)
[    0.928086] audit: type=2000 audit(1418614060.612:1): initialized
[    0.928457] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.929767] zpool: loaded
[    0.929770] zbud: loaded
[    0.929931] VFS: Disk quotas dquot_6.5.2
[    0.929961] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.930365] fuse init (API version 7.23)
[    0.930443] msgmni has been set to 15871
[    0.930494] Key type big_key registered
[    0.930883] Key type asymmetric registered
[    0.930887] Asymmetric key parser 'x509' registered
[    0.930919] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.930973] io scheduler noop registered
[    0.930976] io scheduler deadline registered (default)
[    0.931018] io scheduler cfq registered
[    0.931188] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.931688] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.931703] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.931761] intel_idle: MWAIT substates: 0x21120
[    0.931762] intel_idle: v0.4 model 0x3A
[    0.931763] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.932121] ACPI: AC Adapter [AC0] (on-line)
[    0.932213] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.966582] ACPI: Lid Switch [LID]
[    0.966619] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.966622] ACPI: Sleep Button [SLPB]
[    0.966654] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.966655] ACPI: Power Button [PWRF]
[    0.967361] thermal LNXTHERM:00: registered as thermal_zone0
[    0.967363] ACPI: Thermal Zone [THRM] (55 C)
[    0.967393] GHES: HEST is not enabled!
[    0.967479] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.969428] Linux agpgart interface v0.103
[    0.970978] brd: module loaded
[    0.971886] loop: module loaded
[    0.972113] libphy: Fixed MDIO Bus: probed
[    0.972117] tun: Universal TUN/TAP device driver, 1.6
[    0.972118] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.972177] PPP generic driver version 2.4.2
[    0.972232] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.972237] ehci-pci: EHCI PCI platform driver
[    0.972344] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.972350] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.972366] ehci-pci 0000:00:1a.0: debug port 2
[    0.976313] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.976335] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7318000
[    0.980151] ACPI: Battery Slot [BAT0] (battery present)
[    0.986576] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.986618] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.986620] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.986621] usb usb1: Product: EHCI Host Controller
[    0.986623] usb usb1: Manufacturer: Linux 3.16.0-28-generic ehci_hcd
[    0.986624] usb usb1: SerialNumber: 0000:00:1a.0
[    0.986764] hub 1-0:1.0: USB hub found
[    0.986770] hub 1-0:1.0: 2 ports detected
[    0.986938] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.986943] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.986954] ehci-pci 0000:00:1d.0: debug port 2
[    0.990858] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.990874] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7317000
[    1.002585] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.002620] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.002622] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.002624] usb usb2: Product: EHCI Host Controller
[    1.002625] usb usb2: Manufacturer: Linux 3.16.0-28-generic ehci_hcd
[    1.002627] usb usb2: SerialNumber: 0000:00:1d.0
[    1.002756] hub 2-0:1.0: USB hub found
[    1.002761] hub 2-0:1.0: 2 ports detected
[    1.002843] ehci-platform: EHCI generic platform driver
[    1.002853] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.002858] ohci-pci: OHCI PCI platform driver
[    1.002868] ohci-platform: OHCI generic platform driver
[    1.002877] uhci_hcd: USB Universal Host Controller Interface driver
[    1.002982] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.002987] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    1.003080] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.003097] xhci_hcd 0000:00:14.0: irq 41 for MSI/MSI-X
[    1.003153] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.003155] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.003157] usb usb3: Product: xHCI Host Controller
[    1.003158] usb usb3: Manufacturer: Linux 3.16.0-28-generic xhci_hcd
[    1.003159] usb usb3: SerialNumber: 0000:00:14.0
[    1.003283] hub 3-0:1.0: USB hub found
[    1.003292] hub 3-0:1.0: 4 ports detected
[    1.003389] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.003392] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    1.003434] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    1.003436] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.003437] usb usb4: Product: xHCI Host Controller
[    1.003439] usb usb4: Manufacturer: Linux 3.16.0-28-generic xhci_hcd
[    1.003440] usb usb4: SerialNumber: 0000:00:14.0
[    1.003596] hub 4-0:1.0: USB hub found
[    1.003607] hub 4-0:1.0: 4 ports detected
[    1.003768] i8042: PNP: PS/2 Controller [PNP030b:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.005621] i8042: Detected active multiplexing controller, rev 1.1
[    1.006548] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.006552] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.006590] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.006610] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.006629] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.006792] mousedev: PS/2 mouse device common for all mice
[    1.007042] rtc_cmos 00:02: RTC can wake from S4
[    1.007161] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.007188] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.007244] device-mapper: uevent: version 1.0.3
[    1.007305] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    1.007319] ledtrig-cpu: registered to indicate activity on CPUs
[    1.007411] TCP: cubic registered
[    1.007506] NET: Registered protocol family 10
[    1.007748] NET: Registered protocol family 17
[    1.007757] Key type dns_resolver registered
[    1.008170] Loading compiled-in X.509 certificates
[    1.009045] Loaded X.509 cert 'Magrathea: Glacier signing key: 43ed39104431917875d27b2c778133bb61684ed9'
[    1.009059] registered taskstats version 1
[    1.011320] Key type trusted registered
[    1.013225] Key type encrypted registered
[    1.015356] AppArmor: AppArmor sha1 policy hashing enabled
[    1.015361] ima: No TPM chip found, activating TPM-bypass!
[    1.015378] evm: HMAC attrs: 0x1
[    1.015880]   Magic number: 10:405:462
[    1.015997] rtc_cmos 00:02: setting system clock to 2014-12-15 03:27:41 UTC (1418614061)
[    1.017223] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.017224] EDD information not available.
[    1.017335] PM: Hibernation image not present or could not be loaded.
[    1.018019] Freeing unused kernel memory: 1356K (ffffffff81d2e000 - ffffffff81e81000)
[    1.018020] Write protecting the kernel read-only data: 12288k
[    1.018915] Freeing unused kernel memory: 440K (ffff880001792000 - ffff880001800000)
[    1.019714] Freeing unused kernel memory: 488K (ffff880001b86000 - ffff880001c00000)
[    1.027446] systemd-udevd[143]: starting version 208
[    1.027790] random: systemd-udevd urandom read with 10 bits of entropy available
[    1.042585] ahci 0000:00:1f.2: version 3.0
[    1.042703] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    1.044480] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.058687] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x7 impl SATA mode
[    1.058697] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    1.072074] atl1c 0000:04:00.0: version 1.0.1.1-NAPI
[    1.075141] scsi0 : ahci
[    1.075288] scsi1 : ahci
[    1.075381] scsi2 : ahci
[    1.075465] scsi3 : ahci
[    1.075546] scsi4 : ahci
[    1.075627] scsi5 : ahci
[    1.075661] ata1: SATA max UDMA/133 abar m2048@0xf7316000 port 0xf7316100 irq 42
[    1.075663] ata2: SATA max UDMA/133 abar m2048@0xf7316000 port 0xf7316180 irq 42
[    1.075664] ata3: SATA max UDMA/133 abar m2048@0xf7316000 port 0xf7316200 irq 42
[    1.075665] ata4: DUMMY
[    1.075666] ata5: DUMMY
[    1.075667] ata6: DUMMY
[    1.298953] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.395004] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.395037] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.395056] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.397185] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.397217] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    1.397219] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.397419] ata1.00: supports DRM functions and may not be fully accessible
[    1.397488] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[    1.397490] ata1.00: ATA-9: Samsung SSD 840 EVO 500GB mSATA, EXT42B6Q, max UDMA/133
[    1.397491] ata1.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[    1.397930] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.397954] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    1.397956] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.398163] ata1.00: supports DRM functions and may not be fully accessible
[    1.398358] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.398387] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[    1.398435] ata1.00: configured for UDMA/133
[    1.398623] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD 840  2B6Q PQ: 0 ANSI: 5
[    1.398960] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.399023] sd 0:0:0:0: [sda] Write Protect is off
[    1.399025] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.399032] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.399034] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.399393]  sda: sda1 sda2
[    1.399792] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.400308] ata3.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    1.400315] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.400686] ata3.00: ATAPI: Slimtype DVD A  DS8A9SH, EAA2, max UDMA/100
[    1.405007] ata2.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    1.405016] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.409926] ata3.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    1.409935] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.410356] ata3.00: configured for UDMA/100
[    1.414837] ata2.00: ATA-8: ST750LX003-1AC154, SM12, max UDMA/133
[    1.414844] ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.425367] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.425495] ata2.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    1.425502] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.426174] ata2.00: configured for UDMA/133
[    1.426399] scsi 1:0:0:0: Direct-Access     ATA      ST750LX003-1AC15 SM12 PQ: 0 ANSI: 5
[    1.426719] sd 1:0:0:0: [sdb] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    1.426723] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    1.426760] sd 1:0:0:0: [sdb] Write Protect is off
[    1.426762] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.426772] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.426776] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.427255]  sdb: sdb1 sdb2 sdb3 sdb4
[    1.427718] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.430364] scsi 2:0:0:0: CD-ROM            Slimtype DVD A  DS8A9SH   EAA2 PQ: 0 ANSI: 5
[    1.435313] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.435319] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.435557] hub 1-1:1.0: USB hub found
[    1.435661] hub 1-1:1.0: 6 ports detected
[    1.448479] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.448484] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.448672] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.448768] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    1.527033] raid6: sse2x1    8621 MB/s
[    1.547114] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.595079] raid6: sse2x2   11218 MB/s
[    1.663143] raid6: sse2x4   13321 MB/s
[    1.663144] raid6: using algorithm sse2x4 (13321 MB/s)
[    1.663145] raid6: using ssse3x2 recovery algorithm
[    1.664173] xor: automatically using best checksumming function:
[    1.679472] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.679474] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.679792] hub 2-1:1.0: USB hub found
[    1.679846] hub 2-1:1.0: 8 ports detected
[    1.703171]    avx       : 25081.000 MB/sec
[    1.712071] Btrfs loaded
[    1.801298] BTRFS: device fsid 5f0ca1d2-b2c4-499e-a7df-efb2590b6502 devid 1 transid 166020 /dev/sda2
[    1.813093] BTRFS: device label hdd devid 1 transid 163358 /dev/sdb4
[    1.817046] BTRFS info (device sda2): disk space caching is enabled
[    1.847364] usb 3-3: new high-speed USB device number 2 using xhci_hcd
[    1.896186] BTRFS: detected SSD devices, enabling SSD mode
[    1.927377] tsc: Refined TSC clocksource calibration: 2394.560 MHz
[    1.980887] usb 3-3: New USB device found, idVendor=2109, idProduct=2812
[    1.980890] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.980892] usb 3-3: Product: USB2.0 Hub             
[    1.980893] usb 3-3: Manufacturer: VIA Labs, Inc.         
[    1.981278] hub 3-3:1.0: USB hub found
[    1.981386] hub 3-3:1.0: 4 ports detected
[    1.986524] psmouse serio4: elantech: assuming hardware version 3 (with firmware version 0x450f00)
[    1.987742] init: plymouth-upstart-bridge main process (256) terminated with status 1
[    1.987753] init: plymouth-upstart-bridge main process ended, respawning
[    1.989087] init: plymouth-upstart-bridge main process (272) terminated with status 1
[    1.989095] init: plymouth-upstart-bridge main process ended, respawning
[    1.990287] init: plymouth-upstart-bridge main process (275) terminated with status 1
[    1.990294] init: plymouth-upstart-bridge main process ended, respawning
[    2.001433] psmouse serio4: elantech: Synaptics capabilities query result 0x69, 0x17, 0x0b.
[    2.068510] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio4/input/input11
[    2.103863] usb 4-3: new SuperSpeed USB device number 2 using xhci_hcd
[    2.355451] usb 4-3: New USB device found, idVendor=2109, idProduct=0812
[    2.355459] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.355462] usb 4-3: Product: USB3.0 Hub             
[    2.355466] usb 4-3: Manufacturer: VIA Labs, Inc.         
[    2.355824] hub 4-3:1.0: USB hub found
[    2.355961] hub 4-3:1.0: 4 ports detected
[    2.427859] usb 1-1.1: new full-speed USB device number 3 using ehci-pci
[    2.469023] random: nonblocking pool is initialized
[    2.522079] usb 1-1.1: New USB device found, idVendor=13d3, idProduct=3362
[    2.522086] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.522090] usb 1-1.1: Product: Bluetooth USB Host Controller
[    2.522093] usb 1-1.1: Manufacturer: Atheros Communications
[    2.522096] usb 1-1.1: SerialNumber: Alaska Day 2006
[    2.592132] usb 1-1.3: new high-speed USB device number 4 using ehci-pci
[    2.791343] usb 1-1.3: New USB device found, idVendor=1bcf, idProduct=2885
[    2.791350] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.791354] usb 1-1.3: Product: ASUS USB2.0 Webcam
[    2.791366] usb 1-1.3: Manufacturer: 04G626000610B831U0000VH
[    2.928440] Switched to clocksource tsc
[    3.048591] usb 3-3.1: new high-speed USB device number 3 using xhci_hcd
[    3.151225] usb 3-3.1: New USB device found, idVendor=2109, idProduct=2812
[    3.151228] usb 3-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.151230] usb 3-3.1: Product: USB2.0 Hub             
[    3.151231] usb 3-3.1: Manufacturer: VIA Labs, Inc.         
[    3.151803] hub 3-3.1:1.0: USB hub found
[    3.152188] hub 3-3.1:1.0: 4 ports detected
[    3.244689] usb 3-3.4: new high-speed USB device number 4 using xhci_hcd
[    3.255007] BTRFS info (device sda2): disk space caching is enabled
[    3.280279] EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
[    3.346283] usb 3-3.4: New USB device found, idVendor=2109, idProduct=2812
[    3.346286] usb 3-3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.346288] usb 3-3.4: Product: USB2.0 Hub             
[    3.346290] usb 3-3.4: Manufacturer: VIA Labs, Inc.         
[    3.346629] hub 3-3.4:1.0: USB hub found
[    3.346736] hub 3-3.4:1.0: 4 ports detected
[    3.383164] BTRFS info (device sdb4): disk space caching is enabled
[    3.429820] usb 4-3.1: new SuperSpeed USB device number 3 using xhci_hcd
[    3.680507] usb 4-3.1: New USB device found, idVendor=2109, idProduct=0812
[    3.680510] usb 4-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.680511] usb 4-3.1: Product: USB3.0 Hub             
[    3.680513] usb 4-3.1: Manufacturer: VIA Labs, Inc.         
[    3.680873] hub 4-3.1:1.0: USB hub found
[    3.681042] hub 4-3.1:1.0: 4 ports detected
[    3.753886] usb 4-3.4: new SuperSpeed USB device number 4 using xhci_hcd
[    4.005920] usb 4-3.4: New USB device found, idVendor=2109, idProduct=0812
[    4.005927] usb 4-3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.005931] usb 4-3.4: Product: USB3.0 Hub             
[    4.005934] usb 4-3.4: Manufacturer: VIA Labs, Inc.         
[    4.006540] hub 4-3.4:1.0: USB hub found
[    4.006809] hub 4-3.4:1.0: 4 ports detected
[    4.093549] usb 3-3.1.2: new high-speed USB device number 5 using xhci_hcd
[    4.193665] usb 3-3.1.2: New USB device found, idVendor=050d, idProduct=0307
[    4.193669] usb 3-3.1.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.194006] hub 3-3.1.2:1.0: USB hub found
[    4.194136] hub 3-3.1.2:1.0: 7 ports detected
[    4.379350] usb 4-3.4.3: new SuperSpeed USB device number 5 using xhci_hcd
[    4.400286] usb 4-3.4.3: New USB device found, idVendor=0b95, idProduct=1790
[    4.400293] usb 4-3.4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.400297] usb 4-3.4.3: Product: AX88179
[    4.400300] usb 4-3.4.3: Manufacturer: ASIX Elec. Corp.
[    4.400302] usb 4-3.4.3: SerialNumber: 008CAE4CFD30B9
[    4.489621] usb 3-3.1.2.3: new full-speed USB device number 6 using xhci_hcd
[    4.578549] usb 3-3.1.2.3: New USB device found, idVendor=067b, idProduct=2303
[    4.578556] usb 3-3.1.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.578560] usb 3-3.1.2.3: Product: USB-Serial Controller D
[    4.578563] usb 3-3.1.2.3: Manufacturer: Prolific Technology Inc. 
[    4.665768] usb 3-3.1.2.6: new full-speed USB device number 7 using xhci_hcd
[    4.755701] usb 3-3.1.2.6: New USB device found, idVendor=03eb, idProduct=2104
[    4.755709] usb 3-3.1.2.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.755712] usb 3-3.1.2.6: Product: AVRISP mkII
[    4.755715] usb 3-3.1.2.6: Manufacturer: ATMEL
[    4.755718] usb 3-3.1.2.6: SerialNumber: 000200000769
[    4.841883] usb 3-3.1.2.7: new full-speed USB device number 8 using xhci_hcd
[    4.847351] systemd-udevd[571]: starting version 208
[    4.867298] FS-Cache: Loaded
[    4.871931] lp: driver loaded but no devices found
[    4.874049] RPC: Registered named UNIX socket transport module.
[    4.874052] RPC: Registered udp transport module.
[    4.874053] RPC: Registered tcp transport module.
[    4.874054] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.875654] ppdev: user-space parallel port driver
[    4.882601] FS-Cache: Netfs 'nfs' registered for caching
[    4.885804] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    4.887875] mei_me 0000:00:16.0: irq 43 for MSI/MSI-X
[    4.898222] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    4.899191] ACPI: Video Device [GFX0] (multi-head: yes  rom: yes  post: no)
[    4.905559] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000044f (\GPIS) (20140424/utaddress-258)
[    4.905566] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000047f (\PMIO) (20140424/utaddress-258)
[    4.905570] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.905574] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\GPIO) (20140424/utaddress-258)
[    4.905578] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GP01) (20140424/utaddress-258)
[    4.905581] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.905582] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\GPIO) (20140424/utaddress-258)
[    4.905586] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GP01) (20140424/utaddress-258)
[    4.905589] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.905590] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000057f (\GPIO) (20140424/utaddress-258)
[    4.905593] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GP01) (20140424/utaddress-258)
[    4.905596] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.905598] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    4.907639] wmi: Mapper loaded
[    4.913843] [drm] Initialized drm 1.1.0 20060810
[    4.921394] cfg80211: Calling CRDA to update world regulatory domain
[    4.931523] usb 3-3.1.2.7: New USB device found, idVendor=03eb, idProduct=2104
[    4.931527] usb 3-3.1.2.7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.931529] usb 3-3.1.2.7: Product: AVRISP mkII
[    4.931531] usb 3-3.1.2.7: Manufacturer: ATMEL
[    4.931533] usb 3-3.1.2.7: SerialNumber: 000200084737
[    4.934893] nvidia: module license 'NVIDIA' taints kernel.
[    4.934896] Disabling lock debugging due to kernel taint
[    4.938278] nvidia: module verification failed: signature and/or  required key missing - tainting kernel
[    4.942761] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=none
[    4.942919] [drm] Initialized nvidia-drm 0.0.0 20130102 for 0000:01:00.0 on minor 0
[    4.942925] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  331.113  Mon Dec  1 21:08:13 PST 2014
[    4.950770] ath: phy0: Disable PLL PowerSave
[    4.953988] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[    4.954139] snd_hda_intel 0000:01:00.1: Disabling MSI
[    4.954144] snd_hda_intel 0000:01:00.1: Handle VGA-switcheroo audio client
[    4.960969] ath: EEPROM regdomain: 0x60
[    4.960972] ath: EEPROM indicates we should expect a direct regpair map
[    4.960974] ath: Country alpha2 being used: 00
[    4.960975] ath: Regpair used: 0x60
[    4.962285] AVX version of gcm_enc/dec engaged.
[    4.965947] Bluetooth: Core ver 2.19
[    4.965964] NET: Registered protocol family 31
[    4.965966] Bluetooth: HCI device and connection manager initialized
[    4.965972] Bluetooth: HCI socket layer initialized
[    4.965974] Bluetooth: L2CAP socket layer initialized
[    4.965982] Bluetooth: SCO socket layer initialized
[    4.971067] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.971071] Bluetooth: BNEP filters: protocol multicast
[    4.971078] Bluetooth: BNEP socket layer initialized
[    4.971839] sound hdaudioC0D0: autoconfig: line_outs=2 (0x24/0x33/0x0/0x0/0x0) type:speaker
[    4.971842] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    4.971845] sound hdaudioC0D0:    hp_outs=1 (0x25/0x0/0x0/0x0/0x0)
[    4.971847] sound hdaudioC0D0:    mono: mono_out=0x0
[    4.971849] sound hdaudioC0D0:    dig-out=0x2d/0x0
[    4.971850] sound hdaudioC0D0:    inputs:
[    4.971853] sound hdaudioC0D0:      Mic=0x2b
[    4.971855] sound hdaudioC0D0:      Internal Mic=0x29
[    4.975222] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    4.975580] ieee80211 phy0: Atheros AR9485 Rev:1 mem=0xffffc90005180000, irq=17
[    4.977599] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    4.977665] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    4.979647] Bluetooth: RFCOMM TTY layer initialized
[    4.979656] Bluetooth: RFCOMM socket layer initialized
[    4.979661] Bluetooth: RFCOMM ver 1.11
[    4.994046] audit: type=1400 audit(1418614065.470:2): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/cups/backend/cups-pdf" pid=879 comm="apparmor_parser"
[    4.994052] audit: type=1400 audit(1418614065.470:3): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/sbin/cupsd" pid=879 comm="apparmor_parser"
[    4.994056] audit: type=1400 audit(1418614065.470:4): apparmor="STATUS" operation="profile_load" profile="unconfined" name="third_party" pid=879 comm="apparmor_parser"
[    4.998298] acpi device:07: registered as cooling_device8
[    4.998380] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:02/LNXVIDEO:00/input/input14
[    5.021612] intel_rapl: Found RAPL domain package
[    5.021613] intel_rapl: Found RAPL domain core
[    5.025945] usbcore: registered new interface driver btusb
[    5.027437] usbcore: registered new interface driver ath3k
[    5.028157] media: Linux media interface: v0.10
[    5.031507] Linux video capture interface: v2.00
[    5.038225] audit: type=1400 audit(1418614065.514:5): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/sbin/dhclient" pid=979 comm="apparmor_parser"
[    5.038233] audit: type=1400 audit(1418614065.514:6): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=979 comm="apparmor_parser"
[    5.038238] audit: type=1400 audit(1418614065.514:7): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/connman/scripts/dhclient-script" pid=979 comm="apparmor_parser"
[    5.040042] uvcvideo: Found UVC 1.00 device ASUS USB2.0 Webcam (1bcf:2885)
[    5.040541] audit: type=1400 audit(1418614065.514:8): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/sbin/ntpd" pid=990 comm="apparmor_parser"
[    5.057682] input: ASUS USB2.0 Webcam as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input15
[    5.057758] usbcore: registered new interface driver uvcvideo
[    5.057758] USB Video Class driver (1.1.1)
[    5.058824] asus_wmi: ASUS WMI generic driver loaded
[    5.059798] asus_wmi: Initialization: 0x1
[    5.059821] asus_wmi: BIOS WMI version: 7.9
[    5.059860] asus_wmi: SFUN value: 0x6a0877
[    5.060766] input: Asus WMI hotkeys as /devices/platform/asus-nb-wmi/input/input16
[    5.067001] cfg80211: World regulatory domain updated:
[    5.067004] cfg80211:  DFS Master region: unset
[    5.067005] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    5.067008] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.067010] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.067012] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.067014] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.067015] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    5.132016] init: failsafe main process (1082) killed by TERM signal
[    5.155970] init: Failed to obtain startpar-bridge instance: Unknown parameter: INSTANCE
[    5.179663] asus_wmi: Backlight controlled by ACPI video driver
[    5.197911] init: samba-ad-dc main process (1178) terminated with status 1
[    5.201531] audit: type=1400 audit(1418614065.674:9): apparmor="STATUS" operation="profile_load" profile="unconfined" name="docker-default" pid=1279 comm="apparmor_parser"
[    5.203533] audit: type=1400 audit(1418614065.678:10): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/lightdm/lightdm-guest-session" pid=1279 comm="apparmor_parser"
[    5.354632] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
[    5.354702] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input18
[    5.517657] systemd-logind[1559]: Watching system buttons on /dev/input/event2 (Power Button)
[    5.517732] systemd-logind[1559]: Watching system buttons on /dev/input/event7 (Video Bus)
[    5.518283] systemd-logind[1559]: Watching system buttons on /dev/input/event0 (Lid Switch)
[    5.518353] systemd-logind[1559]: Watching system buttons on /dev/input/event1 (Sleep Button)
[    5.518367] systemd-logind[1559]: New seat seat0.
[    5.538078] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    5.543083] atl1c 0000:04:00.0: irq 45 for MSI/MSI-X
[    5.559003] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.053425] usbcore: registered new interface driver usbserial
[    6.053440] usbcore: registered new interface driver usbserial_generic
[    6.053453] usbserial: USB Serial support registered for generic
[    6.054452] usbcore: registered new interface driver pl2303
[    6.054464] usbserial: USB Serial support registered for pl2303
[    6.054481] pl2303 3-3.1.2.3:1.0: pl2303 converter detected
[    6.055438] usb 3-3.1.2.3: pl2303 converter now attached to ttyUSB0
[    6.393149] ax88179_178a 4-3.4.3:1.0 eth1: register 'ax88179_178a' at usb-0000:00:14.0-3.4.3, ASIX AX88179 USB 3.0 Gigabit Ethernet, 8c:ae:4c:fd:30:b9
[    6.393199] usbcore: registered new interface driver ax88179_178a
[    6.648447] nvidia 0000:01:00.0: irq 46 for MSI/MSI-X
[    6.652648] ACPI Warning: \_SB_.PCI0.PEG0.GFX0._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140424/nsarguments-95)
[    6.652680] ACPI Warning: \_SB_.PCI0.PEG0.GFX0._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140424/nsarguments-95)
[    6.652693] ACPI Warning: \_SB_.PCI0.PEG0.GFX0._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140424/nsarguments-95)
[    6.652704] ACPI Warning: \_SB_.PCI0.PEG0.GFX0._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140424/nsarguments-95)
[    6.652715] ACPI Warning: \_SB_.PCI0.PEG0.GFX0._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140424/nsarguments-95)
[    6.652733] ACPI Warning: \_SB_.PCI0.PEG0.GFX0._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140424/nsarguments-95)
[    6.652744] ACPI Warning: \_SB_.PCI0.PEG0.GFX0._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140424/nsarguments-95)
[    6.652755] ACPI Warning: \_SB_.PCI0.PEG0.GFX0._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140424/nsarguments-95)
[    6.652769] ACPI Warning: \_SB_.PCI0.PEG0.GFX0._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140424/nsarguments-95)
[    6.652794] ACPI Warning: \_SB_.PCI0.PEG0.GFX0._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140424/nsarguments-95)
[    6.713973] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[    6.970950] vboxdrv: Found 8 processor cores.
[    6.971201] vboxdrv: fAsync=0 offMin=0x19e offMax=0x112f5
[    6.971275] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[    6.971276] vboxdrv: Successfully loaded version 4.3.12 (interface 0x001a0007).
[    7.177863] vboxpci: IOMMU not found (not registered)
[    7.587789] systemd-logind[1559]: Failed to start unit user@1000.service: Unknown unit: user@1000.service
[    7.587793] systemd-logind[1559]: Failed to start user service: Unknown unit: user@1000.service
[    7.590504] systemd-logind[1559]: New session c1 of user nick.
[    7.627545] systemd-logind[1559]: New session c2 of user nick.
[    7.676566] wlan0: authenticate with 00:26:5a:fd:46:38
[    7.690535] wlan0: send auth to 00:26:5a:fd:46:38 (try 1/3)
[    7.692474] wlan0: authenticated
[    7.696292] wlan0: associate with 00:26:5a:fd:46:38 (try 1/3)
[    7.699665] wlan0: RX AssocResp from 00:26:5a:fd:46:38 (capab=0x431 status=0 aid=4)
[    7.699707] wlan0: associated
[    7.699716] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[    7.710129] wlan0: deauthenticating from 00:26:5a:fd:46:38 by local choice (Reason: 2=PREV_AUTH_NOT_VALID)
[    7.718040] cfg80211: Calling CRDA to update world regulatory domain
[    7.718257] wlan0: authenticate with 00:26:5a:fd:46:38
[    7.725344] wlan0: send auth to 00:26:5a:fd:46:38 (try 1/3)
[    7.725461] cfg80211: World regulatory domain updated:
[    7.725463] cfg80211:  DFS Master region: unset
[    7.725464] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    7.725466] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    7.725467] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    7.725468] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm), (N/A)
[    7.725469] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    7.725470] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm), (N/A)
[    7.727306] wlan0: authenticated
[    7.728306] wlan0: associate with 00:26:5a:fd:46:38 (try 1/3)
[    7.732142] wlan0: RX AssocResp from 00:26:5a:fd:46:38 (capab=0x431 status=0 aid=4)
[    7.732193] wlan0: associated
[    8.277857] ACPI Warning: \_SB_.PCI0.PEG0.GFX0._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20140424/nsarguments-95)
[    8.997429] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.007411] aufs 3.x-rcN-20140707
[    9.014503] Bridge firewalling registered
[    9.015371] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready
[    9.019492] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    9.233008] audit_printk_skb: 87 callbacks suppressed
[    9.233011] audit: type=1400 audit(1418614069.702:40): apparmor="STATUS" operation="profile_replace" profile="unconfined" name="docker-default" pid=3146 comm="apparmor_parser"
[    9.306518] ax88179_178a 4-3.4.3:1.0 eth1: ax88179 - Link status is: 1
[    9.307866] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   10.280160] init: plymouth-upstart-bridge main process ended, respawning
[   10.300956] systemd-logind[1559]: Failed to start unit user@111.service: Unknown unit: user@111.service
[   10.300962] systemd-logind[1559]: Failed to start user service: Unknown unit: user@111.service
[   10.303802] systemd-logind[1559]: New session c3 of user lightdm.
[   10.303818] systemd-logind[1559]: Linked /tmp/.X11-unix/X0 to /run/user/111/X11-display.
[   17.760179] systemd-logind[1559]: New session c4 of user nick.
[   17.760194] systemd-logind[1559]: Linked /tmp/.X11-unix/X0 to /run/user/1000/X11-display.
[  757.376971] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[  757.390339] JFS: nTxBlock = 8192, nTxLock = 65536
[  757.408509] ntfs: driver 2.1.30 [Flags: R/O MODULE].
[  757.435693] QNX4 filesystem 0.2.3 registered.
[ 1267.670048] psmouse serio4: Touchpad at isa0060/serio4/input0 lost sync at byte 6
[ 1267.696553] psmouse serio4: Touchpad at isa0060/serio4/input0 - driver resynced.
[ 1699.991594] psmouse serio4: Touchpad at isa0060/serio4/input0 lost sync at byte 6
[ 1700.025489] psmouse serio4: Touchpad at isa0060/serio4/input0 - driver resynced.
[ 3416.141836] ax88179_178a 4-3.4.3:1.0 eth1: kevent 2 may have been dropped
[ 3416.141946] ax88179_178a 4-3.4.3:1.0 eth1: kevent 2 may have been dropped
[ 3416.141956] ax88179_178a 4-3.4.3:1.0 eth1: kevent 2 may have been dropped
[ 3416.141965] ax88179_178a 4-3.4.3:1.0 eth1: kevent 2 may have been dropped
[ 3416.141973] ax88179_178a 4-3.4.3:1.0 eth1: kevent 2 may have been dropped
[ 3416.141984] ax88179_178a 4-3.4.3:1.0 eth1: kevent 2 may have been dropped
[ 3416.141992] ax88179_178a 4-3.4.3:1.0 eth1: kevent 2 may have been dropped
[ 3416.142000] ax88179_178a 4-3.4.3:1.0 eth1: kevent 2 may have been dropped
[ 3416.142010] ax88179_178a 4-3.4.3:1.0 eth1: kevent 2 may have been dropped
[ 3416.142019] ax88179_178a 4-3.4.3:1.0 eth1: kevent 2 may have been dropped


--------------000800010504090806060708--
