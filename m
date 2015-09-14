Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3246 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751530AbbINGZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 02:25:32 -0400
Subject: Re: unable to mount multi disk volume with recovery mode
To: Ivan Petrovic <ivan@ipplus.rs>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CAEyaVk+QnDb5sbfMtV_pGbkwA4BB9ODpVv-_hdMJWjuPbGG+Xg@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55F66855.4010000@cn.fujitsu.com>
Date: Mon, 14 Sep 2015 14:25:25 +0800
MIME-Version: 1.0
In-Reply-To: <CAEyaVk+QnDb5sbfMtV_pGbkwA4BB9ODpVv-_hdMJWjuPbGG+Xg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Ivan,

Ivan Petrovic wrote on 2015/09/04 22:45 +0200:
> Hello,
>
> I had 3 HDDs in single mode and one died.

Unfortunately, single mode means no duplication.
And degrade mount only works for RAID level with 
duplication(DUP,RAID1/5/6/10).

So you lost all your data.

Thanks,
Qu

> I have put a replacement but
> I can't figure out how to mount recovery or degraded filesystem. First
> and third partitions was sdb and sdc and I'm trying to replace second
> with new hdd /dev/sdd
>
> ivan@ipplus-dev:~$ uname -a
> Linux ipplus-dev 3.13.0-63-generic #103-Ubuntu SMP Fri Aug 14 21:42:59
> UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> ivan@ipplus-dev:~$ btrfs --version
> Btrfs v3.12
>
> ivan@ipplus-dev:~$ sudo btrfs device scan
> Scanning for Btrfs filesystems
>
> ivan@ipplus-dev:~$ sudo btrfs fi show
> Label: none  uuid: be4138ff-0dd9-48ed-9408-9dd679d4cc0b
> Total devices 1 FS bytes used 109.43GiB
> devid    1 size 111.79GiB used 111.79GiB path /dev/sda1
>
> Label: none  uuid: 0c1f52fd-e403-4e07-ad2d-edf3d9da039d
> Total devices 3 FS bytes used 4.50TiB
> devid    1 size 1.82TiB used 1.82TiB path /dev/sdb
> devid    3 size 1.82TiB used 900.00GiB path /dev/sdc
> *** Some devices missing
>
> Btrfs v3.12
> ivan@ipplus-dev:~$
>
> Now I try to mount first partition in recovery but third partition
> showing open_ctree failed in dmesg.
>
> ivan@ipplus-dev:~$ sudo mount -o recovery,ro -t btrfs /dev/sdb /mnt/ambis/
> mount: wrong fs type, bad option, bad superblock on /dev/sdb,
>         missing codepage or helper program, or other error
>         Некада се корисне информације могу наћи у syslog - покушајте са
>         dmesg | tail  или нечим сличним
>
> ivan@ipplus-dev:~$ dmesg | tail
> [   55.865624] type=1400 audit(1441394241.545:64): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/lib/cups/backend/cups-pdf" pid=5569 comm="apparmor_parser"
> [   55.865628] type=1400 audit(1441394241.545:65): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/sbin/cupsd" pid=5569 comm="apparmor_parser"
> [   55.865896] type=1400 audit(1441394241.545:66): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/sbin/cupsd" pid=5569 comm="apparmor_parser"
> [   92.429625] btrfs: device fsid 0c1f52fd-e403-4e07-ad2d-edf3d9da039d
> devid 1 transid 34755 /dev/sdb
> [   92.429906] btrfs: device fsid 0c1f52fd-e403-4e07-ad2d-edf3d9da039d
> devid 3 transid 34755 /dev/sdc
> [  182.527543] btrfs: device fsid 0c1f52fd-e403-4e07-ad2d-edf3d9da039d
> devid 1 transid 34755 /dev/sdb
> [  182.528283] btrfs: enabling auto recovery
> [  182.528287] btrfs: disk space caching is enabled
> [  182.529404] btrfs: failed to read the system array on sdc
> [  182.545306] btrfs: open_ctree failed
>
> Degraded mount showing the same
>
> ivan@ipplus-dev:~$ sudo mount -o degraded -t btrfs /dev/sdb /mnt/ambis/
> mount: wrong fs type, bad option, bad superblock on /dev/sdb,
>         missing codepage or helper program, or other error
>         Некада се корисне информације могу наћи у syslog - покушајте са
>         dmesg | tail  или нечим сличним
>
> ivan@ipplus-dev:~$ dmesg | tail
> [  182.529404] btrfs: failed to read the system array on sdc
> [  182.545306] btrfs: open_ctree failed
> [  437.838712] btrfs: device fsid 0c1f52fd-e403-4e07-ad2d-edf3d9da039d
> devid 1 transid 34755 /dev/sdb
> [  437.839023] btrfs: device fsid 0c1f52fd-e403-4e07-ad2d-edf3d9da039d
> devid 3 transid 34755 /dev/sdc
> [  655.529281] systemd-hostnamed[6532]: Warning: nss-myhostname is not
> installed. Changing the local hostname might make it unresolveable.
> Please install nss-myhostname!
> [  850.636389] btrfs: device fsid 0c1f52fd-e403-4e07-ad2d-edf3d9da039d
> devid 1 transid 34755 /dev/sdb
> [  850.637131] btrfs: allowing degraded mounts
> [  850.637135] btrfs: disk space caching is enabled
> [  858.980371] Btrfs: too many missing devices, writeable mount is not allowed
> [  859.007281] btrfs: open_ctree failed
>
>
> What I need to replace missing drive with new
>
> dmesg.log
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.13.0-63-generic (buildd@lgw01-18) (gcc
> version 4.8.2 (Ubuntu 4.8.2-19ubuntu1) ) #103-Ubuntu SMP Fri Aug 14
> 21:42:59 UTC 2015 (Ubuntu 3.13.0-63.103-generic 3.13.11-ckt25)
> [    0.000000] Command line:
> BOOT_IMAGE=/boot/vmlinuz-3.13.0-63-generic
> root=UUID=be4138ff-0dd9-48ed-9408-9dd679d4cc0b ro quiet splash
> vt.handoff=7
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000cc3c0fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000cc3c1000-0x00000000ccac1fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ccac2000-0x00000000ccad2fff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000ccad3000-0x00000000ccbf9fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000ccbfa000-0x00000000cd80dfff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000cd80e000-0x00000000cd80efff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000cd80f000-0x00000000cd851fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000cd852000-0x00000000cdc77fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000cdc78000-0x00000000cdff3fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000cdff4000-0x00000000cdffffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000cf000000-0x00000000df1fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fdfffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.7 present.
> [    0.000000] DMI: System manufacturer System Product Name/P8Z77-M,
> BIOS 1806 01/03/2013
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x41fe00 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CFFFF write-protect
> [    0.000000]   D0000-E7FFF uncachable
> [    0.000000]   E8000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask C00000000 write-back
> [    0.000000]   1 base 400000000 mask FE0000000 write-back
> [    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
> [    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
> [    0.000000]   4 base 0CF000000 mask FFF000000 uncachable
> [    0.000000]   5 base 41FE00000 mask FFFE00000 uncachable
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] original variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 16GB, type WB
> [    0.000000] reg 1, base: 16GB, range: 512MB, type WB
> [    0.000000] reg 2, base: 3584MB, range: 512MB, type UC
> [    0.000000] reg 3, base: 3328MB, range: 256MB, type UC
> [    0.000000] reg 4, base: 3312MB, range: 16MB, type UC
> [    0.000000] reg 5, base: 16894MB, range: 2MB, type UC
> [    0.000000] total RAM covered: 16110M
> [    0.000000] Found optimal setting for mtrr clean up
> [    0.000000]  gran_size: 64K chunk_size: 32M num_reg: 8   lose cover RAM: 0G
> [    0.000000] New variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
> [    0.000000] reg 1, base: 2GB, range: 1GB, type WB
> [    0.000000] reg 2, base: 3GB, range: 256MB, type WB
> [    0.000000] reg 3, base: 3312MB, range: 16MB, type UC
> [    0.000000] reg 4, base: 4GB, range: 4GB, type WB
> [    0.000000] reg 5, base: 8GB, range: 8GB, type WB
> [    0.000000] reg 6, base: 16GB, range: 512MB, type WB
> [    0.000000] reg 7, base: 16894MB, range: 2MB, type UC
> [    0.000000] e820: update [mem 0xcf000000-0xffffffff] usable ==> reserved
> [    0.000000] e820: last_pfn = 0xce000 max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000fd810-0x000fd81f]
> mapped at [ffff8800000fd810]
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
> [    0.000000] reserving inaccessible SNB gfx pages
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x01fe2000, 0x01fe2fff] PGTABLE
> [    0.000000] BRK [0x01fe3000, 0x01fe3fff] PGTABLE
> [    0.000000] BRK [0x01fe4000, 0x01fe4fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x41fc00000-0x41fdfffff]
> [    0.000000]  [mem 0x41fc00000-0x41fdfffff] page 2M
> [    0.000000] BRK [0x01fe5000, 0x01fe5fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x41c000000-0x41fbfffff]
> [    0.000000]  [mem 0x41c000000-0x41fbfffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
> [    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
> [    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x40200000-0xcc3c0fff]
> [    0.000000]  [mem 0x40200000-0xcc1fffff] page 2M
> [    0.000000]  [mem 0xcc200000-0xcc3c0fff] page 4k
> [    0.000000] BRK [0x01fe6000, 0x01fe6fff] PGTABLE
> [    0.000000] BRK [0x01fe7000, 0x01fe7fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0xcd80e000-0xcd80efff]
> [    0.000000]  [mem 0xcd80e000-0xcd80efff] page 4k
> [    0.000000] init_memory_mapping: [mem 0xcd852000-0xcdc77fff]
> [    0.000000]  [mem 0xcd852000-0xcd9fffff] page 4k
> [    0.000000]  [mem 0xcda00000-0xcdbfffff] page 2M
> [    0.000000]  [mem 0xcdc00000-0xcdc77fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0xcdff4000-0xcdffffff]
> [    0.000000]  [mem 0xcdff4000-0xcdffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
> [    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
> [    0.000000] RAMDISK: [mem 0x34af2000-0x36570fff]
> [    0.000000] ACPI: RSDP 00000000000f0490 000024 (v02 ALASKA)
> [    0.000000] ACPI: XSDT 00000000ccac5080 000074 (v01 ALASKA    A M I
> 01072009 AMI  00010013)
> [    0.000000] ACPI: FACP 00000000ccad0328 00010C (v05 ALASKA    A M I
> 01072009 AMI  00010013)
> [    0.000000] ACPI: DSDT 00000000ccac5188 00B19E (v02 ALASKA    A M I
> 00000022 INTL 20051117)
> [    0.000000] ACPI: FACS 00000000ccbf8080 000040
> [    0.000000] ACPI: APIC 00000000ccad0438 000092 (v03 ALASKA    A M I
> 01072009 AMI  00010013)
> [    0.000000] ACPI: FPDT 00000000ccad04d0 000044 (v01 ALASKA    A M I
> 01072009 AMI  00010013)
> [    0.000000] ACPI: MCFG 00000000ccad0518 00003C (v01 ALASKA    A M I
> 01072009 MSFT 00000097)
> [    0.000000] ACPI: SSDT 00000000ccad0558 0007CA (v01 Intel_ AoacTabl
> 00001000 INTL 20091112)
> [    0.000000] ACPI: HPET 00000000ccad0d28 000038 (v01 ALASKA    A M I
> 01072009 AMI. 00000005)
> [    0.000000] ACPI: SSDT 00000000ccad0d60 00036D (v01 SataRe SataTabl
> 00001000 INTL 20091112)
> [    0.000000] ACPI: DMAR 00000000ccad24e8 0000B8 (v01 INTEL      SNB
> 00000001 INTL 00000001)
> [    0.000000] ACPI: SSDT 00000000ccad1128 000926 (v01  PmRef  Cpu0Ist
> 00003000 INTL 20051117)
> [    0.000000] ACPI: SSDT 00000000ccad1a50 000A92 (v01  PmRef    CpuPm
> 00003000 INTL 20051117)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041fdfffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x41fdfffff]
> [    0.000000]   NODE_DATA [mem 0x41fdea000-0x41fdeefff]
> [    0.000000]  [ffffea0000000000-ffffea00107fffff] PMD ->
> [ffff88040f800000-ffff88041f3fffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x41fdfffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
> [    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
> [    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
> [    0.000000]   node   0: [mem 0x40200000-0xcc3c0fff]
> [    0.000000]   node   0: [mem 0xcd80e000-0xcd80efff]
> [    0.000000]   node   0: [mem 0xcd852000-0xcdc77fff]
> [    0.000000]   node   0: [mem 0xcdff4000-0xcdffffff]
> [    0.000000]   node   0: [mem 0x100000000-0x41fdfffff]
> [    0.000000] On node 0 totalpages: 4112784
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 156 pages reserved
> [    0.000000]   DMA zone: 3996 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 13008 pages used for memmap
> [    0.000000]   DMA32 zone: 832500 pages, LIFO batch:31
> [    0.000000]   Normal zone: 51192 pages used for memmap
> [    0.000000]   Normal zone: 3276288 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
> [    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
> [    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x40000000-0x401fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xcc3c1000-0xccac1fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xccac2000-0xccad2fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xccad3000-0xccbf9fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xccbfa000-0xcd80dfff]
> [    0.000000] PM: Registered nosave memory: [mem 0xcd80f000-0xcd851fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xcdc78000-0xcdff3fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xce000000-0xceffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xcf000000-0xdf1fffff]
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
> [    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256
> nr_cpu_ids:8 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88041fa00000 s81536
> r8192 d20864 u262144
> [    0.000000] pcpu-alloc: s81536 r8192 d20864 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
> Total pages: 4048364
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line:
> BOOT_IMAGE=/boot/vmlinuz-3.13.0-63-generic
> root=UUID=be4138ff-0dd9-48ed-9408-9dd679d4cc0b ro quiet splash
> vt.handoff=7
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] Memory: 16081784K/16451136K available (7395K kernel
> code, 1146K rwdata, 3416K rodata, 1336K init, 1448K bss, 369352K
> reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
> [    0.000000] Offload RCU callbacks from all CPUs
> [    0.000000] Offload RCU callbacks from CPUs: 0-7.
> [    0.000000] NR_IRQS:16640 nr_irqs:744 16
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] allocated 66060288 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't
> want memory cgroups
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.004000] tsc: Detected 2808.402 MHz processor
> [    0.000002] Calibrating delay loop (skipped), value calculated
> using timer frequency.. 5616.80 BogoMIPS (lpj=11233608)
> [    0.000005] pid_max: default: 32768 minimum: 301
> [    0.000027] Security Framework initialized
> [    0.000043] AppArmor: AppArmor initialized
> [    0.000044] Yama: becoming mindful.
> [    0.000997] Dentry cache hash table entries: 2097152 (order: 12,
> 16777216 bytes)
> [    0.003802] Inode-cache hash table entries: 1048576 (order: 11,
> 8388608 bytes)
> [    0.005017] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.005034] Mountpoint-cache hash table entries: 32768 (order: 6,
> 262144 bytes)
> [    0.005230] Initializing cgroup subsys memory
> [    0.005235] Initializing cgroup subsys devices
> [    0.005236] Initializing cgroup subsys freezer
> [    0.005237] Initializing cgroup subsys blkio
> [    0.005239] Initializing cgroup subsys perf_event
> [    0.005240] Initializing cgroup subsys hugetlb
> [    0.005258] CPU: Physical Processor ID: 0
> [    0.005259] CPU: Processor Core ID: 0
> [    0.005263] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.005263] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.005265] mce: CPU supports 9 MCE banks
> [    0.005277] CPU0: Thermal monitoring enabled (TM1)
> [    0.005282] process: using mwait in idle threads
> [    0.005285] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
> [    0.005285] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
> [    0.005285] tlb_flushall_shift: 5
> [    0.005378] Freeing SMP alternatives memory: 32K (ffffffff81e6e000
> - ffffffff81e76000)
> [    0.006648] ACPI: Core revision 20131115
> [    0.011392] ACPI: All ACPI Tables successfully acquired
> [    0.013607] ftrace: allocating 28590 entries in 112 pages
> [    0.025852] dmar: Host address width 36
> [    0.025854] dmar: DRHD base: 0x000000fed90000 flags: 0x0
> [    0.025860] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap
> c0000020e60262 ecap f0101a
> [    0.025862] dmar: DRHD base: 0x000000fed91000 flags: 0x1
> [    0.025866] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap
> c9008020660262 ecap f0105a
> [    0.025867] dmar: RMRR base: 0x000000cca44000 end: 0x000000cca55fff
> [    0.025868] dmar: RMRR base: 0x000000cf000000 end: 0x000000df1fffff
> [    0.025938] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
> [    0.025939] HPET id 0 under DRHD base 0xfed91000
> [    0.026096] Enabled IRQ remapping in x2apic mode
> [    0.026097] Enabling x2apic
> [    0.026098] Enabled x2apic
> [    0.026102] Switched APIC routing to cluster x2apic.
> [    0.026510] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.066235] smpboot: CPU0: Intel(R) Core(TM) i7-2600S CPU @ 2.80GHz
> (fam: 06, model: 2a, stepping: 07)
> [    0.066241] TSC deadline timer enabled
> [    0.066249] Performance Events: PEBS fmt1+, 16-deep LBR,
> SandyBridge events, full-width counters, Intel PMU driver.
> [    0.066256] ... version:                3
> [    0.066256] ... bit width:              48
> [    0.066257] ... generic registers:      4
> [    0.066258] ... value mask:             0000ffffffffffff
> [    0.066259] ... max period:             0000ffffffffffff
> [    0.066260] ... fixed-purpose events:   3
> [    0.066261] ... event mask:             000000070000000f
> [    0.067661] x86: Booting SMP configuration:
> [    0.080783] NMI watchdog: enabled on all CPUs, permanently consumes
> one hw-PMU counter.
> [    0.067662] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
> [    0.159568] x86: Booted up 1 node, 8 CPUs
> [    0.159572] smpboot: Total of 8 processors activated (44934.43 BogoMIPS)
> [    0.167180] devtmpfs: initialized
> [    0.169776] EVM: security.selinux
> [    0.169777] EVM: security.SMACK64
> [    0.169778] EVM: security.ima
> [    0.169779] EVM: security.capability
> [    0.169815] PM: Registering ACPI NVS region [mem
> 0xccad3000-0xccbf9fff] (1208320 bytes)
> [    0.169831] PM: Registering ACPI NVS region [mem
> 0xcd80f000-0xcd851fff] (274432 bytes)
> [    0.170500] pinctrl core: initialized pinctrl subsystem
> [    0.170547] regulator-dummy: no parameters
> [    0.170576] RTC time: 19:16:25, date: 09/04/15
> [    0.170603] NET: Registered protocol family 16
> [    0.170688] cpuidle: using governor ladder
> [    0.170689] cpuidle: using governor menu
> [    0.170718] ACPI FADT declares the system doesn't support PCIe
> ASPM, so disable it
> [    0.170720] ACPI: bus type PCI registered
> [    0.170721] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.170766] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
> 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.170768] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> [    0.176760] PCI: Using configuration type 1 for base access
> [    0.177601] bio: create slab <bio-0> at 0
> [    0.177722] ACPI: Added _OSI(Module Device)
> [    0.177723] ACPI: Added _OSI(Processor Device)
> [    0.177724] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.177725] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.180282] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.183313] ACPI: SSDT 00000000cca6f018 00083B (v01  PmRef  Cpu0Cst
> 00003001 INTL 20051117)
> [    0.183607] ACPI: Dynamic OEM Table Load:
> [    0.183609] ACPI: SSDT           (null) 00083B (v01  PmRef  Cpu0Cst
> 00003001 INTL 20051117)
> [    0.187225] ACPI: SSDT 00000000cca70a98 000303 (v01  PmRef    ApIst
> 00003000 INTL 20051117)
> [    0.187539] ACPI: Dynamic OEM Table Load:
> [    0.187541] ACPI: SSDT           (null) 000303 (v01  PmRef    ApIst
> 00003000 INTL 20051117)
> [    0.191098] ACPI: SSDT 00000000cca71c18 000119 (v01  PmRef    ApCst
> 00003000 INTL 20051117)
> [    0.191384] ACPI: Dynamic OEM Table Load:
> [    0.191385] ACPI: SSDT           (null) 000119 (v01  PmRef    ApCst
> 00003000 INTL 20051117)
> [    0.195990] ACPI: Interpreter enabled
> [    0.195995] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
> State [\_S1_] (20131115/hwxface-580)
> [    0.195999] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
> State [\_S2_] (20131115/hwxface-580)
> [    0.196010] ACPI: (supports S0 S3 S4 S5)
> [    0.196011] ACPI: Using IOAPIC for interrupt routing
> [    0.196034] PCI: Using host bridge windows from ACPI; if necessary,
> use "pci=nocrs" and report a bug
> [    0.196166] ACPI: No dock devices found.
> [    0.201183] ACPI: Power Resource [FN00] (off)
> [    0.201245] ACPI: Power Resource [FN01] (off)
> [    0.201304] ACPI: Power Resource [FN02] (off)
> [    0.201362] ACPI: Power Resource [FN03] (off)
> [    0.201422] ACPI: Power Resource [FN04] (off)
> [    0.201930] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
> [    0.201935] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
> ClockPM Segments MSI]
> [    0.202106] acpi PNP0A08:00: _OSC: platform does not support
> [PCIeHotplug PME]
> [    0.202211] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
> [    0.202212] acpi PNP0A08:00: FADT indicates ASPM is unsupported,
> using BIOS configuration
> [    0.202703] PCI host bridge to bus 0000:00
> [    0.202705] pci_bus 0000:00: root bus resource [bus 00-3e]
> [    0.202707] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.202709] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.202710] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.202712] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
> [    0.202713] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
> [    0.202714] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
> [    0.202716] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
> [    0.202717] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
> [    0.202718] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
> [    0.202720] pci_bus 0000:00: root bus resource [mem 0xdf200000-0xfeafffff]
> [    0.202726] pci 0000:00:00.0: [8086:0100] type 00 class 0x060000
> [    0.202802] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
> [    0.202828] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    0.202868] pci 0000:00:01.0: System wakeup disabled by ACPI
> [    0.202896] pci 0000:00:02.0: [8086:0102] type 00 class 0x030000
> [    0.202905] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
> [    0.202910] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff
> 64bit pref]
> [    0.202914] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
> [    0.203002] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
> [    0.203027] pci 0000:00:14.0: reg 0x10: [mem 0xf7c00000-0xf7c0ffff 64bit]
> [    0.203096] pci 0000:00:14.0: PME# supported from D3hot D3cold
> [    0.203139] pci 0000:00:14.0: System wakeup disabled by ACPI
> [    0.203166] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
> [    0.203188] pci 0000:00:16.0: reg 0x10: [mem 0xf7c1a000-0xf7c1a00f 64bit]
> [    0.203259] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    0.203336] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
> [    0.203357] pci 0000:00:1a.0: reg 0x10: [mem 0xf7c18000-0xf7c183ff]
> [    0.203444] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    0.203499] pci 0000:00:1a.0: System wakeup disabled by ACPI
> [    0.203527] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
> [    0.203541] pci 0000:00:1b.0: reg 0x10: [mem 0xf7c10000-0xf7c13fff 64bit]
> [    0.203606] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.203652] pci 0000:00:1b.0: System wakeup disabled by ACPI
> [    0.203680] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
> [    0.203808] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.203864] pci 0000:00:1c.0: System wakeup disabled by ACPI
> [    0.203892] pci 0000:00:1c.5: [8086:1e1a] type 01 class 0x060400
> [    0.203968] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
> [    0.204015] pci 0000:00:1c.5: System wakeup disabled by ACPI
> [    0.204039] pci 0000:00:1c.6: [8086:244e] type 01 class 0x060401
> [    0.204115] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
> [    0.204162] pci 0000:00:1c.6: System wakeup disabled by ACPI
> [    0.204190] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
> [    0.204210] pci 0000:00:1d.0: reg 0x10: [mem 0xf7c17000-0xf7c173ff]
> [    0.204298] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    0.204352] pci 0000:00:1d.0: System wakeup disabled by ACPI
> [    0.204379] pci 0000:00:1f.0: [8086:1e44] type 00 class 0x060100
> [    0.204542] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
> [    0.204559] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
> [    0.204566] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
> [    0.204573] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
> [    0.204580] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
> [    0.204587] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
> [    0.204594] pci 0000:00:1f.2: reg 0x24: [mem 0xf7c16000-0xf7c167ff]
> [    0.204637] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.204698] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
> [    0.204712] pci 0000:00:1f.3: reg 0x10: [mem 0xf7c15000-0xf7c150ff 64bit]
> [    0.204732] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
> [    0.204829] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.204911] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.205001] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
> [    0.205021] pci 0000:03:00.0: reg 0x10: [io  0xe000-0xe0ff]
> [    0.205054] pci 0000:03:00.0: reg 0x18: [mem 0xf0004000-0xf0004fff
> 64bit pref]
> [    0.205075] pci 0000:03:00.0: reg 0x20: [mem 0xf0000000-0xf0003fff
> 64bit pref]
> [    0.205167] pci 0000:03:00.0: supports D1 D2
> [    0.205168] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.205203] pci 0000:03:00.0: System wakeup disabled by ACPI
> [    0.215059] pci 0000:00:1c.5: PCI bridge to [bus 03]
> [    0.215065] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
> [    0.215074] pci 0000:00:1c.5:   bridge window [mem
> 0xf0000000-0xf00fffff 64bit pref]
> [    0.215158] pci 0000:04:00.0: [1b21:1080] type 01 class 0x060401
> [    0.215278] pci 0000:04:00.0: System wakeup disabled by ACPI
> [    0.215296] pci 0000:00:1c.6: PCI bridge to [bus 04-05] (subtractive decode)
> [    0.215306] pci 0000:00:1c.6:   bridge window [io  0x0000-0x0cf7]
> (subtractive decode)
> [    0.215307] pci 0000:00:1c.6:   bridge window [io  0x0d00-0xffff]
> (subtractive decode)
> [    0.215309] pci 0000:00:1c.6:   bridge window [mem
> 0x000a0000-0x000bffff] (subtractive decode)
> [    0.215310] pci 0000:00:1c.6:   bridge window [mem
> 0x000d0000-0x000d3fff] (subtractive decode)
> [    0.215312] pci 0000:00:1c.6:   bridge window [mem
> 0x000d4000-0x000d7fff] (subtractive decode)
> [    0.215313] pci 0000:00:1c.6:   bridge window [mem
> 0x000d8000-0x000dbfff] (subtractive decode)
> [    0.215314] pci 0000:00:1c.6:   bridge window [mem
> 0x000dc000-0x000dffff] (subtractive decode)
> [    0.215316] pci 0000:00:1c.6:   bridge window [mem
> 0x000e0000-0x000e3fff] (subtractive decode)
> [    0.215317] pci 0000:00:1c.6:   bridge window [mem
> 0x000e4000-0x000e7fff] (subtractive decode)
> [    0.215319] pci 0000:00:1c.6:   bridge window [mem
> 0xdf200000-0xfeafffff] (subtractive decode)
> [    0.215431] pci 0000:04:00.0: PCI bridge to [bus 05] (subtractive decode)
> [    0.215452] pci 0000:04:00.0:   bridge window [??? 0x00000000 flags
> 0x0] (subtractive decode)
> [    0.215455] pci 0000:04:00.0:   bridge window [??? 0x00000000 flags
> 0x0] (subtractive decode)
> [    0.215456] pci 0000:04:00.0:   bridge window [??? 0x00000000 flags
> 0x0] (subtractive decode)
> [    0.215458] pci 0000:04:00.0:   bridge window [??? 0x00000000 flags
> 0x0] (subtractive decode)
> [    0.215459] pci 0000:04:00.0:   bridge window [io  0x0000-0x0cf7]
> (subtractive decode)
> [    0.215461] pci 0000:04:00.0:   bridge window [io  0x0d00-0xffff]
> (subtractive decode)
> [    0.215462] pci 0000:04:00.0:   bridge window [mem
> 0x000a0000-0x000bffff] (subtractive decode)
> [    0.215463] pci 0000:04:00.0:   bridge window [mem
> 0x000d0000-0x000d3fff] (subtractive decode)
> [    0.215465] pci 0000:04:00.0:   bridge window [mem
> 0x000d4000-0x000d7fff] (subtractive decode)
> [    0.215466] pci 0000:04:00.0:   bridge window [mem
> 0x000d8000-0x000dbfff] (subtractive decode)
> [    0.215467] pci 0000:04:00.0:   bridge window [mem
> 0x000dc000-0x000dffff] (subtractive decode)
> [    0.215469] pci 0000:04:00.0:   bridge window [mem
> 0x000e0000-0x000e3fff] (subtractive decode)
> [    0.215470] pci 0000:04:00.0:   bridge window [mem
> 0x000e4000-0x000e7fff] (subtractive decode)
> [    0.215472] pci 0000:04:00.0:   bridge window [mem
> 0xdf200000-0xfeafffff] (subtractive decode)
> [    0.215914] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
> [    0.215955] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 10 11 12 14 15)
> [    0.215995] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
> [    0.216034] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
> [    0.216073] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12
> 14 15) *0, disabled.
> [    0.216112] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12
> 14 15) *0, disabled.
> [    0.216152] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 14 15)
> [    0.216191] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
> [    0.216393] ACPI: Enabled 4 GPEs in block 00 to 3F
> [    0.216398] ACPI: \_SB_.PCI0: notify handler is installed
> [    0.216444] Found 1 acpi root devices
> [    0.216516] vgaarb: setting as boot device: PCI:0000:00:02.0
> [    0.216518] vgaarb: device added:
> PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.216520] vgaarb: loaded
> [    0.216521] vgaarb: bridge control possible 0000:00:02.0
> [    0.216635] SCSI subsystem initialized
> [    0.216671] libata version 3.00 loaded.
> [    0.216685] ACPI: bus type USB registered
> [    0.216696] usbcore: registered new interface driver usbfs
> [    0.216703] usbcore: registered new interface driver hub
> [    0.216728] usbcore: registered new device driver usb
> [    0.216804] PCI: Using ACPI for IRQ routing
> [    0.218291] PCI: pci_cache_line_size set to 64 bytes
> [    0.218332] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
> [    0.218334] e820: reserve RAM buffer [mem 0xcc3c1000-0xcfffffff]
> [    0.218335] e820: reserve RAM buffer [mem 0xcd80f000-0xcfffffff]
> [    0.218337] e820: reserve RAM buffer [mem 0xcdc78000-0xcfffffff]
> [    0.218338] e820: reserve RAM buffer [mem 0xce000000-0xcfffffff]
> [    0.218339] e820: reserve RAM buffer [mem 0x41fe00000-0x41fffffff]
> [    0.218398] NetLabel: Initializing
> [    0.218400] NetLabel:  domain hash size = 128
> [    0.218400] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.218411] NetLabel:  unlabeled traffic allowed by default
> [    0.218453] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    0.218457] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    0.220486] Switched to clocksource hpet
> [    0.223959] AppArmor: AppArmor Filesystem Enabled
> [    0.223976] pnp: PnP ACPI init
> [    0.223986] ACPI: bus type PNP registered
> [    0.224043] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
> [    0.224045] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.224056] pnp 00:01: [dma 4]
> [    0.224066] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.224082] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
> [    0.224152] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.224179] system 00:04: [io  0x0680-0x069f] has been reserved
> [    0.224181] system 00:04: [io  0x1000-0x100f] has been reserved
> [    0.224182] system 00:04: [io  0xffff] has been reserved
> [    0.224184] system 00:04: [io  0xffff] has been reserved
> [    0.224186] system 00:04: [io  0x0400-0x0453] could not be reserved
> [    0.224187] system 00:04: [io  0x0458-0x047f] has been reserved
> [    0.224189] system 00:04: [io  0x0500-0x057f] has been reserved
> [    0.224190] system 00:04: [io  0x164e-0x164f] has been reserved
> [    0.224192] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.224217] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.224250] system 00:06: [io  0x0454-0x0457] has been reserved
> [    0.224252] system 00:06: Plug and Play ACPI device, IDs INT3f0d
> PNP0c02 (active)
> [    0.224311] system 00:07: [io  0x0290-0x029f] has been reserved
> [    0.224313] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.224350] system 00:08: [io  0x04d0-0x04d1] has been reserved
> [    0.224352] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.224373] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.224543] pnp 00:0a: [dma 0 disabled]
> [    0.224579] pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.224772] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.224774] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
> [    0.224775] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.224777] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.224779] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.224780] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    0.224782] system 00:0b: [mem 0xfed90000-0xfed93fff] could not be reserved
> [    0.224784] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    0.224787] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
> [    0.224788] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
> [    0.224790] system 00:0b: [mem 0xdf200000-0xdf200fff] has been reserved
> [    0.224792] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.224913] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
> [    0.224915] system 00:0c: [mem 0x40000000-0x401fffff] has been reserved
> [    0.224917] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.224935] pnp: PnP ACPI: found 13 devices
> [    0.224936] ACPI: bus type PNP unregistered
> [    0.230714] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.230719] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.230736] pci 0000:00:1c.5: PCI bridge to [bus 03]
> [    0.230739] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
> [    0.230745] pci 0000:00:1c.5:   bridge window [mem
> 0xf0000000-0xf00fffff 64bit pref]
> [    0.230751] pci 0000:04:00.0: PCI bridge to [bus 05]
> [    0.230770] pci 0000:00:1c.6: PCI bridge to [bus 04-05]
> [    0.230781] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.230782] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.230784] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.230785] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
> [    0.230786] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
> [    0.230788] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
> [    0.230789] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
> [    0.230791] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
> [    0.230792] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
> [    0.230793] pci_bus 0000:00: resource 13 [mem 0xdf200000-0xfeafffff]
> [    0.230795] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
> [    0.230796] pci_bus 0000:03: resource 2 [mem 0xf0000000-0xf00fffff
> 64bit pref]
> [    0.230798] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
> [    0.230799] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
> [    0.230801] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.230802] pci_bus 0000:04: resource 7 [mem 0x000d0000-0x000d3fff]
> [    0.230803] pci_bus 0000:04: resource 8 [mem 0x000d4000-0x000d7fff]
> [    0.230805] pci_bus 0000:04: resource 9 [mem 0x000d8000-0x000dbfff]
> [    0.230806] pci_bus 0000:04: resource 10 [mem 0x000dc000-0x000dffff]
> [    0.230807] pci_bus 0000:04: resource 11 [mem 0x000e0000-0x000e3fff]
> [    0.230809] pci_bus 0000:04: resource 12 [mem 0x000e4000-0x000e7fff]
> [    0.230810] pci_bus 0000:04: resource 13 [mem 0xdf200000-0xfeafffff]
> [    0.230812] pci_bus 0000:05: resource 8 [io  0x0000-0x0cf7]
> [    0.230813] pci_bus 0000:05: resource 9 [io  0x0d00-0xffff]
> [    0.230814] pci_bus 0000:05: resource 10 [mem 0x000a0000-0x000bffff]
> [    0.230816] pci_bus 0000:05: resource 11 [mem 0x000d0000-0x000d3fff]
> [    0.230817] pci_bus 0000:05: resource 12 [mem 0x000d4000-0x000d7fff]
> [    0.230818] pci_bus 0000:05: resource 13 [mem 0x000d8000-0x000dbfff]
> [    0.230820] pci_bus 0000:05: resource 14 [mem 0x000dc000-0x000dffff]
> [    0.230821] pci_bus 0000:05: resource 15 [mem 0x000e0000-0x000e3fff]
> [    0.230822] pci_bus 0000:05: resource 16 [mem 0x000e4000-0x000e7fff]
> [    0.230824] pci_bus 0000:05: resource 17 [mem 0xdf200000-0xfeafffff]
> [    0.230847] NET: Registered protocol family 2
> [    0.231050] TCP established hash table entries: 131072 (order: 8,
> 1048576 bytes)
> [    0.231262] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.231372] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.231388] TCP: reno registered
> [    0.231404] UDP hash table entries: 8192 (order: 6, 262144 bytes)
> [    0.231455] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
> [    0.231528] NET: Registered protocol family 1
> [    0.231950] pci 0000:00:02.0: BIOS left Intel GPU interrupts
> enabled; disabling
> [    0.231962] pci 0000:00:02.0: Video device with shadowed ROM
> [    0.272637] PCI: CLS 64 bytes, default 64
> [    0.272677] Trying to unpack rootfs image as initramfs...
> [    0.639760] Freeing initrd memory: 27132K (ffff880034af2000 -
> ffff880036571000)
> [    0.639770] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.639772] software IO TLB [mem 0xc83c1000-0xcc3c1000] (64MB)
> mapped at [ffff8800c83c1000-ffff8800cc3c0fff]
> [    0.640032] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x28
> [    0.640038] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x28
> [    0.640042] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x28
> [    0.640047] microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x28
> [    0.640052] microcode: CPU4 sig=0x206a7, pf=0x2, revision=0x28
> [    0.640057] microcode: CPU5 sig=0x206a7, pf=0x2, revision=0x28
> [    0.640062] microcode: CPU6 sig=0x206a7, pf=0x2, revision=0x28
> [    0.640068] microcode: CPU7 sig=0x206a7, pf=0x2, revision=0x28
> [    0.640111] microcode: Microcode Update Driver: v2.00
> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    0.640113] Scanning for low memory corruption every 60 seconds
> [    0.640318] Initialise system trusted keyring
> [    0.640353] audit: initializing netlink socket (disabled)
> [    0.640361] type=2000 audit(1441394185.628:1): initialized
> [    0.663041] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.663962] zbud: loaded
> [    0.664079] VFS: Disk quotas dquot_6.5.2
> [    0.664112] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.664409] fuse init (API version 7.22)
> [    0.664460] msgmni has been set to 31462
> [    0.664497] Key type big_key registered
> [    0.664816] Key type asymmetric registered
> [    0.664817] Asymmetric key parser 'x509' registered
> [    0.664837] Block layer SCSI generic (bsg) driver version 0.4
> loaded (major 252)
> [    0.664876] io scheduler noop registered
> [    0.664878] io scheduler deadline registered (default)
> [    0.664894] io scheduler cfq registered
> [    0.665052] pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
> [    0.665306] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.665316] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.665341] vesafb: mode is 1920x1080x32, linelength=7680, pages=0
> [    0.665342] vesafb: scrolling: redraw
> [    0.665344] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> [    0.671899] vesafb: framebuffer at 0xe0000000, mapped to
> 0xffffc90005c00000, using 8128k, total 8128k
> [    0.675924] Console: switching to colour frame buffer device 240x67
> [    0.679867] fb0: VESA VGA frame buffer device
> [    0.679886] intel_idle: MWAIT substates: 0x1120
> [    0.679887] intel_idle: v0.4 model 0x2A
> [    0.679888] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    0.680013] ipmi message handler version 39.2
> [    0.680073] input: Power Button as
> /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
> [    0.680077] ACPI: Power Button [PWRB]
> [    0.680101] input: Power Button as
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    0.680103] ACPI: Power Button [PWRF]
> [    0.680151] ACPI: Fan [FAN0] (off)
> [    0.680170] ACPI: Fan [FAN1] (off)
> [    0.680188] ACPI: Fan [FAN2] (off)
> [    0.680206] ACPI: Fan [FAN3] (off)
> [    0.680223] ACPI: Fan [FAN4] (off)
> [    0.685211] thermal LNXTHERM:00: registered as thermal_zone0
> [    0.685213] ACPI: Thermal Zone [TZ00] (28 C)
> [    0.685382] thermal LNXTHERM:01: registered as thermal_zone1
> [    0.685383] ACPI: Thermal Zone [TZ01] (30 C)
> [    0.685399] GHES: HEST is not enabled!
> [    0.685455] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
> [    0.705899] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200)
> is a 16550A
> [    0.706931] Linux agpgart interface v0.103
> [    0.707845] brd: module loaded
> [    0.708325] loop: module loaded
> [    0.708572] libphy: Fixed MDIO Bus: probed
> [    0.708632] tun: Universal TUN/TAP device driver, 1.6
> [    0.708633] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    0.708660] PPP generic driver version 2.4.2
> [    0.708687] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.708690] ehci-pci: EHCI PCI platform driver
> [    0.708778] ehci-pci 0000:00:1a.0: EHCI Host Controller
> [    0.708783] ehci-pci 0000:00:1a.0: new USB bus registered, assigned
> bus number 1
> [    0.708795] ehci-pci 0000:00:1a.0: debug port 2
> [    0.712705] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
> [    0.712724] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7c18000
> [    0.720985] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    0.721014] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.721016] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.721017] usb usb1: Product: EHCI Host Controller
> [    0.721019] usb usb1: Manufacturer: Linux 3.13.0-63-generic ehci_hcd
> [    0.721020] usb usb1: SerialNumber: 0000:00:1a.0
> [    0.721094] hub 1-0:1.0: USB hub found
> [    0.721099] hub 1-0:1.0: 2 ports detected
> [    0.721249] ehci-pci 0000:00:1d.0: EHCI Host Controller
> [    0.721254] ehci-pci 0000:00:1d.0: new USB bus registered, assigned
> bus number 2
> [    0.721265] ehci-pci 0000:00:1d.0: debug port 2
> [    0.725168] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
> [    0.725184] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7c17000
> [    0.737005] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    0.737028] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.737030] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.737032] usb usb2: Product: EHCI Host Controller
> [    0.737033] usb usb2: Manufacturer: Linux 3.13.0-63-generic ehci_hcd
> [    0.737034] usb usb2: SerialNumber: 0000:00:1d.0
> [    0.737100] hub 2-0:1.0: USB hub found
> [    0.737104] hub 2-0:1.0: 2 ports detected
> [    0.737178] ehci-platform: EHCI generic platform driver
> [    0.737183] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.737184] ohci-pci: OHCI PCI platform driver
> [    0.737190] ohci-platform: OHCI generic platform driver
> [    0.737193] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.737280] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    0.737283] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
> bus number 3
> [    0.737367] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
> [    0.737386] xhci_hcd 0000:00:14.0: irq 43 for MSI/MSI-X
> [    0.737432] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.737434] usb usb3: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.737435] usb usb3: Product: xHCI Host Controller
> [    0.737437] usb usb3: Manufacturer: Linux 3.13.0-63-generic xhci_hcd
> [    0.737438] usb usb3: SerialNumber: 0000:00:14.0
> [    0.737528] hub 3-0:1.0: USB hub found
> [    0.737538] hub 3-0:1.0: 4 ports detected
> [    0.737769] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    0.737771] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
> bus number 4
> [    0.737798] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [    0.737799] usb usb4: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    0.737801] usb usb4: Product: xHCI Host Controller
> [    0.737802] usb usb4: Manufacturer: Linux 3.13.0-63-generic xhci_hcd
> [    0.737803] usb usb4: SerialNumber: 0000:00:14.0
> [    0.737892] hub 4-0:1.0: USB hub found
> [    0.737899] hub 4-0:1.0: 4 ports detected
> [    0.745047] i8042: PNP: No PS/2 controller found. Probing ports directly.
> [    0.747212] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.747218] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.747367] mousedev: PS/2 mouse device common for all mice
> [    0.747628] rtc_cmos 00:05: RTC can wake from S4
> [    0.747796] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> [    0.747826] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes
> nvram, hpet irqs
> [    0.747871] device-mapper: uevent: version 1.0.3
> [    0.747951] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30)
> initialised: dm-devel@redhat.com
> [    0.747955] ledtrig-cpu: registered to indicate activity on CPUs
> [    0.748029] TCP: cubic registered
> [    0.748081] NET: Registered protocol family 10
> [    0.748186] NET: Registered protocol family 17
> [    0.748196] Key type dns_resolver registered
> [    0.748500] Loading compiled-in X.509 certificates
> [    0.749294] Loaded X.509 cert 'Magrathea: Glacier signing key:
> e253281fe265ee3ceafcaa3f292e212b95f0359a'
> [    0.749303] registered taskstats version 1
> [    0.751162] Key type trusted registered
> [    0.754598] Key type encrypted registered
> [    0.754602] AppArmor: AppArmor sha1 policy hashing enabled
> [    0.754603] IMA: No TPM chip found, activating TPM-bypass!
> [    0.754845] regulator-dummy: disabling
> [    0.754972]   Magic number: 15:54:293
> [    0.754986] tty tty26: hash matches
> [    0.755076] rtc_cmos 00:05: setting system clock to 2015-09-04
> 19:16:26 UTC (1441394186)
> [    0.756081] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    0.756083] EDD information not available.
> [    0.756122] PM: Hibernation image not present or could not be loaded.
> [    0.756775] Freeing unused kernel memory: 1336K (ffffffff81d20000 -
> ffffffff81e6e000)
> [    0.756784] Write protecting the kernel read-only data: 12288k
> [    0.758453] Freeing unused kernel memory: 784K (ffff88000173c000 -
> ffff880001800000)
> [    0.759791] Freeing unused kernel memory: 680K (ffff880001b56000 -
> ffff880001c00000)
> [    0.768238] systemd-udevd[145]: starting version 204
> [    0.776249] wmi: Mapper loaded
> [    0.780961] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [    0.780972] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have
> ASPM control
> [    0.781239] r8169 0000:03:00.0: irq 44 for MSI/MSI-X
> [    0.781451] r8169 0000:03:00.0 eth0: RTL8168f/8111f at
> 0xffffc900018b6000, 08:60:6e:d8:8b:26, XID 08000800 IRQ 44
> [    0.781454] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200
> bytes, tx checksumming: ko]
> [    0.783054] [drm] Initialized drm 1.1.0 20060810
> [    0.787621] ahci 0000:00:1f.2: version 3.0
> [    0.787766] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
> [    0.801102] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6
> Gbps 0x2f impl SATA mode
> [    0.801105] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum
> part ems apst
> [    0.833472] scsi0 : ahci
> [    0.833606] scsi1 : ahci
> [    0.833711] scsi2 : ahci
> [    0.833865] scsi3 : ahci
> [    0.833968] scsi4 : ahci
> [    0.834115] scsi5 : ahci
> [    0.834152] ata1: SATA max UDMA/133 abar m2048@0xf7c16000 port
> 0xf7c16100 irq 45
> [    0.834155] ata2: SATA max UDMA/133 abar m2048@0xf7c16000 port
> 0xf7c16180 irq 45
> [    0.834156] ata3: SATA max UDMA/133 abar m2048@0xf7c16000 port
> 0xf7c16200 irq 45
> [    0.834158] ata4: SATA max UDMA/133 abar m2048@0xf7c16000 port
> 0xf7c16280 irq 45
> [    0.834159] ata5: DUMMY
> [    0.834161] ata6: SATA max UDMA/133 abar m2048@0xf7c16000 port
> 0xf7c16380 irq 45
> [    0.834954] [drm] Memory usable by graphics device = 2048M
> [    0.834957] checking generic (e0000000 7f0000) vs hw (e0000000 10000000)
> [    0.834958] fb: conflicting fb hw usage inteldrmfb vs VESA VGA -
> removing generic driver
> [    0.834969] Console: switching to colour dummy device 80x25
> [    0.881165] i915 0000:00:02.0: irq 46 for MSI/MSI-X
> [    0.881171] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    0.881172] [drm] Driver supports precise vblank timestamp query.
> [    0.881235] vgaarb: device changed decodes:
> PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    0.894509] [drm] Wrong MCH_SSKPD value: 0x16040307
> [    0.894511] [drm] This can cause pipe underruns and display issues.
> [    0.894512] [drm] Please upgrade your BIOS to fix this.
> [    0.963573] fbcon: inteldrmfb (fb0) is primary device
> [    1.033300] usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    1.153439] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.153458] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.153474] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.153489] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.153514] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.153800] ACPI Error: [DSSP] Namespace lookup failure,
> AE_NOT_FOUND (20131115/psargs-359)
> [    1.153804] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT2._GTF] (Node ffff880409829a78), AE_NOT_FOUND
> (20131115/psparse-536)
> [    1.153851] ACPI Error: [DSSP] Namespace lookup failure,
> AE_NOT_FOUND (20131115/psargs-359)
> [    1.153865] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT3._GTF] (Node ffff880409829af0), AE_NOT_FOUND
> (20131115/psparse-536)
> [    1.153934] ACPI Error: [DSSP] Namespace lookup failure,
> AE_NOT_FOUND (20131115/psargs-359)
> [    1.153937] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT1._GTF] (Node ffff880409829a00), AE_NOT_FOUND
> (20131115/psparse-536)
> [    1.153950] ata3.00: ATA-9: WDC WD20EFRX-68EUZN0, 80.00A80, max UDMA/133
> [    1.153951] ata3.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
> 31/32), AA
> [    1.154017] ata4.00: ATA-9: WDC WD20EFRX-68EUZN0, 82.00A82, max UDMA/133
> [    1.154018] ata4.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
> 31/32), AA
> [    1.154049] ata2.00: ATA-9: WDC WD20EFRX-68AX9N0, 80.00A80, max UDMA/133
> [    1.154050] ata2.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
> 31/32), AA
> [    1.154324] ACPI Error: [DSSP] Namespace lookup failure,
> AE_NOT_FOUND (20131115/psargs-359)
> [    1.154326] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT2._GTF] (Node ffff880409829a78), AE_NOT_FOUND
> (20131115/psparse-536)
> [    1.154421] ata3.00: configured for UDMA/133
> [    1.154464] ACPI Error: [DSSP] Namespace lookup failure,
> AE_NOT_FOUND (20131115/psargs-359)
> [    1.154466] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT3._GTF] (Node ffff880409829af0), AE_NOT_FOUND
> (20131115/psparse-536)
> [    1.154578] ata4.00: configured for UDMA/133
> [    1.155343] ACPI Error: [DSSP] Namespace lookup failure,
> AE_NOT_FOUND (20131115/psargs-359)
> [    1.155346] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff880409829988), AE_NOT_FOUND
> (20131115/psparse-536)
> [    1.155363] ata1.00: supports DRM functions and may not be fully accessible
> [    1.155398] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
> [    1.155399] ata1.00: ATA-9: Samsung SSD 840 EVO 120GB, EXT0BB6Q, max UDMA/133
> [    1.155400] ata1.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
> [    1.155457] ACPI Error: [DSSP] Namespace lookup failure,
> AE_NOT_FOUND (20131115/psargs-359)
> [    1.155460] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT1._GTF] (Node ffff880409829a00), AE_NOT_FOUND
> (20131115/psparse-536)
> [    1.155568] ACPI Error: [DSSP] Namespace lookup failure,
> AE_NOT_FOUND (20131115/psargs-359)
> [    1.155571] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff880409829988), AE_NOT_FOUND
> (20131115/psparse-536)
> [    1.155577] ata2.00: configured for UDMA/133
> [    1.155591] ata1.00: supports DRM functions and may not be fully accessible
> [    1.155632] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
> [    1.155634] ata1.00: configured for UDMA/133
> [    1.155755] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD
> 840  EXT0 PQ: 0 ANSI: 5
> [    1.155881] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks:
> (120 GB/111 GiB)
> [    1.155885] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    1.156076] scsi 1:0:0:0: Direct-Access     ATA      WDC
> WD20EFRX-68A 80.0 PQ: 0 ANSI: 5
> [    1.156168] sd 0:0:0:0: [sda] Write Protect is off
> [    1.156170] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.156229] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    1.156234] sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks:
> (2.00 TB/1.81 TiB)
> [    1.156236] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    1.156236] sd 1:0:0:0: [sdb] 4096-byte physical blocks
> [    1.156328] sd 1:0:0:0: [sdb] Write Protect is off
> [    1.156330] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    1.156337] scsi 2:0:0:0: Direct-Access     ATA      WDC
> WD20EFRX-68E 80.0 PQ: 0 ANSI: 5
> [    1.156366] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    1.156438] sd 2:0:0:0: [sdc] 3907029168 512-byte logical blocks:
> (2.00 TB/1.81 TiB)
> [    1.156439] sd 2:0:0:0: [sdc] 4096-byte physical blocks
> [    1.156477] sd 2:0:0:0: Attached scsi generic sg2 type 0
> [    1.156522] sd 2:0:0:0: [sdc] Write Protect is off
> [    1.156524] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    1.156559] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    1.156573] scsi 3:0:0:0: Direct-Access     ATA      WDC
> WD20EFRX-68E 82.0 PQ: 0 ANSI: 5
> [    1.156632]  sda: sda1
> [    1.156698] sd 3:0:0:0: [sdd] 3907029168 512-byte logical blocks:
> (2.00 TB/1.81 TiB)
> [    1.156700] sd 3:0:0:0: [sdd] 4096-byte physical blocks
> [    1.156701] sd 3:0:0:0: Attached scsi generic sg3 type 0
> [    1.156742] sd 3:0:0:0: [sdd] Write Protect is off
> [    1.156744] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> [    1.156776] sd 3:0:0:0: [sdd] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    1.156883] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.161454] Console: switching to colour frame buffer device 240x67
> [    1.161570] ACPI Error: [DSSP] Namespace lookup failure,
> AE_NOT_FOUND (20131115/psargs-359)
> [    1.161572] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT5._GTF] (Node ffff880409829be0), AE_NOT_FOUND
> (20131115/psparse-536)
> [    1.161574] ata6.00: ATAPI: HL-DT-ST BD-RE  BH10LS30, 1.02, max UDMA/133
> [    1.164877] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [    1.164878] i915 0000:00:02.0: registered panic notifier
> [    1.165707] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
> [    1.165709] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    1.165860] hub 1-1:1.0: USB hub found
> [    1.165956] hub 1-1:1.0: 6 ports detected
> [    1.169533] ACPI Error: [DSSP] Namespace lookup failure,
> AE_NOT_FOUND (20131115/psargs-359)
> [    1.169537] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0.SAT0.SPT5._GTF] (Node ffff880409829be0), AE_NOT_FOUND
> (20131115/psparse-536)
> [    1.169543] ata6.00: configured for UDMA/133
> [    1.169873] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [    1.170697] acpi device:48: registered as cooling_device13
> [    1.170757] input: Video Bus as
> /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input5
> [    1.170806] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [    1.172595]  sdd: unknown partition table
> [    1.172685] sd 3:0:0:0: [sdd] Attached SCSI disk
> [    1.182810]  sdb: unknown partition table
> [    1.183164] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    1.183353] scsi 5:0:0:0: CD-ROM            HL-DT-ST BD-RE
> BH10LS30  1.02 PQ: 0 ANSI: 5
> [    1.192418] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw
> xa/form2 cdda tray
> [    1.192423] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    1.192584] sr 5:0:0:0: Attached scsi CD-ROM sr0
> [    1.192637] sr 5:0:0:0: Attached scsi generic sg4 type 5
> [    1.281564] usb 2-1: new high-speed USB device number 2 using ehci-pci
> [    1.414120] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
> [    1.414124] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    1.414402] hub 2-1:1.0: USB hub found
> [    1.414457] hub 2-1:1.0: 8 ports detected
> [    1.637922] tsc: Refined TSC clocksource calibration: 2808.247 MHz
> [    1.685961] usb 2-1.6: new high-speed USB device number 3 using ehci-pci
> [    1.778476] usb 2-1.6: New USB device found, idVendor=0424, idProduct=2514
> [    1.778481] usb 2-1.6: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [    1.778762] hub 2-1.6:1.0: USB hub found
> [    1.778853] hub 2-1.6:1.0: 4 ports detected
> [    1.784297]  sdc: unknown partition table
> [    1.784644] sd 2:0:0:0: [sdc] Attached SCSI disk
> [    1.850125] usb 2-1.7: new high-speed USB device number 4 using ehci-pci
> [    1.942887] usb 2-1.7: New USB device found, idVendor=1a40, idProduct=0101
> [    1.942892] usb 2-1.7: New USB device strings: Mfr=0, Product=1,
> SerialNumber=0
> [    1.942895] usb 2-1.7: Product: USB 2.0 Hub [MTT]
> [    1.943117] hub 2-1.7:1.0: USB hub found
> [    1.943216] hub 2-1.7:1.0: 4 ports detected
> [    2.014276] usb 2-1.8: new high-speed USB device number 5 using ehci-pci
> [    2.109154] usb 2-1.8: New USB device found, idVendor=03f0, idProduct=3217
> [    2.109158] usb 2-1.8: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [    2.109159] usb 2-1.8: Product: HP LaserJet 3050
> [    2.109161] usb 2-1.8: Manufacturer: Hewlett-Packard
> [    2.109162] usb 2-1.8: SerialNumber: 00CNCJ258213
> [    2.182441] usb 2-1.6.2: new high-speed USB device number 6 using ehci-pci
> [    2.210457] raid6: sse2x1    8458 MB/s
> [    2.278518] raid6: sse2x2   10948 MB/s
> [    2.346585] raid6: sse2x4   12604 MB/s
> [    2.346587] raid6: using algorithm sse2x4 (12604 MB/s)
> [    2.346588] raid6: using ssse3x2 recovery algorithm
> [    2.347603] xor: automatically using best checksumming function:
> [    2.386623]    avx       : 25103.000 MB/sec
> [    2.396320] bio: create slab <bio-1> at 1
> [    2.396510] Btrfs loaded
> [    2.407711] random: nonblocking pool is initialized
> [    2.450547] btrfs: device fsid be4138ff-0dd9-48ed-9408-9dd679d4cc0b
> devid 1 transid 329588 /dev/sda1
> [    2.480216] btrfs: device fsid 0c1f52fd-e403-4e07-ad2d-edf3d9da039d
> devid 1 transid 34755 /dev/sdb
> [    2.480289] usb 2-1.6.2: New USB device found, idVendor=03f0, idProduct=e307
> [    2.480291] usb 2-1.6.2: New USB device strings: Mfr=3, Product=1,
> SerialNumber=0
> [    2.480293] usb 2-1.6.2: Product: HP Webcam HD 3300
> [    2.480295] usb 2-1.6.2: Manufacturer: Hewlett Packard
> [    2.488765] hidraw: raw HID events driver (C) Jiri Kosina
> [    2.491927] usbcore: registered new interface driver usbhid
> [    2.491928] usbhid: USB HID core driver
> [    2.493325] hid-generic 0003:03F0:E307.0001: hiddev0,hidraw0: USB
> HID v1.11 Device [Hewlett Packard HP Webcam HD 3300] on
> usb-0000:00:1d.0-1.6.2/input4
> [    2.519360] btrfs: device fsid 0c1f52fd-e403-4e07-ad2d-edf3d9da039d
> devid 3 transid 34755 /dev/sdc
> [    2.558816] usb 2-1.7.1: new low-speed USB device number 7 using ehci-pci
> [    2.639160] Switched to clocksource tsc
> [    2.656706] usb 2-1.7.1: New USB device found, idVendor=046d, idProduct=c046
> [    2.656711] usb 2-1.7.1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    2.656714] usb 2-1.7.1: Product: USB Optical Mouse
> [    2.656717] usb 2-1.7.1: Manufacturer: Logitech
> [    2.660756] input: Logitech USB Optical Mouse as
> /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/2-1.7.1/2-1.7.1:1.0/input/input6
> [    2.661031] hid-generic 0003:046D:C046.0002: input,hidraw1: USB HID
> v1.10 Mouse [Logitech USB Optical Mouse] on
> usb-0000:00:1d.0-1.7.1/input0
> [    2.730985] usb 2-1.7.2: new full-speed USB device number 8 using ehci-pci
> [    2.827404] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [    2.829501] usb 2-1.7.2: New USB device found, idVendor=08e6, idProduct=3437
> [    2.829505] usb 2-1.7.2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    2.829508] usb 2-1.7.2: Product: USB SmartCard Reader
> [    2.829511] usb 2-1.7.2: Manufacturer: Gemplus
> [    2.899156] usb 2-1.7.3: new full-speed USB device number 9 using ehci-pci
> [    2.994892] usb 2-1.7.3: New USB device found, idVendor=046d, idProduct=c52b
> [    2.994897] usb 2-1.7.3: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    2.994900] usb 2-1.7.3: Product: USB Receiver
> [    2.994902] usb 2-1.7.3: Manufacturer: Logitech
> [    3.002708] logitech-djreceiver 0003:046D:C52B.0005:
> hiddev0,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on
> usb-0000:00:1d.0-1.7.3/input2
> [    3.006437] input: Logitech Unifying Device. Wireless PID:4011 as
> /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/2-1.7.3/2-1.7.3:1.2/0003:046D:C52B.0005/input/input7
> [    3.006497] logitech-djdevice 0003:046D:C52B.0006: input,hidraw3:
> USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:4011]
> on usb-0000:00:1d.0-1.7.3:1
> [    3.071321] usb 2-1.7.4: new low-speed USB device number 10 using ehci-pci
> [    3.181473] usb 2-1.7.4: New USB device found, idVendor=04f2, idProduct=1060
> [    3.181478] usb 2-1.7.4: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    3.181480] usb 2-1.7.4: Product: USB Keyboard
> [    3.181483] usb 2-1.7.4: Manufacturer: CHICONY
> [    3.190664] input: CHICONY USB Keyboard as
> /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/2-1.7.4/2-1.7.4:1.0/input/input8
> [    3.190784] hid-generic 0003:04F2:1060.0007: input,hidraw4: USB HID
> v1.11 Keyboard [CHICONY USB Keyboard] on usb-0000:00:1d.0-1.7.4/input0
> [    3.204244] input: CHICONY USB Keyboard as
> /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/2-1.7.4/2-1.7.4:1.1/input/input9
> [    3.204527] hid-generic 0003:04F2:1060.0008: input,hiddev0,hidraw5:
> USB HID v1.11 Device [CHICONY USB Keyboard] on
> usb-0000:00:1d.0-1.7.4/input1
> [    7.529942] btrfs: device fsid be4138ff-0dd9-48ed-9408-9dd679d4cc0b
> devid 1 transid 329588
> /dev/disk/by-uuid/be4138ff-0dd9-48ed-9408-9dd679d4cc0b
> [    7.530202] btrfs: disk space caching is enabled
> [    7.544732] Btrfs detected SSD devices, enabling SSD mode
> [   10.074534] btrfs: disk space caching is enabled
> [   11.090076] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   11.112338] systemd-udevd[460]: starting version 204
> [   11.134547] lp: driver loaded but no devices found
> [   11.140748] ppdev: user-space parallel port driver
> [   11.160810] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [   11.168309] mei_me 0000:00:16.0: irq 47 for MSI/MSI-X
> [   11.172703] ACPI Warning: 0x0000000000000428-0x000000000000042f
> SystemIO conflicts with Region \PMIO 1 (20131115/utaddress-251)
> [   11.172711] ACPI: If an ACPI driver is available for this device,
> you should use it instead of the native driver
> [   11.172715] ACPI Warning: 0x0000000000000530-0x000000000000053f
> SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
> [   11.172720] ACPI Warning: 0x0000000000000530-0x000000000000053f
> SystemIO conflicts with Region \_SB_.PCI0.LPCB.GPBX 2
> (20131115/utaddress-251)
> [   11.172723] ACPI: If an ACPI driver is available for this device,
> you should use it instead of the native driver
> [   11.172725] ACPI Warning: 0x0000000000000500-0x000000000000052f
> SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
> [   11.172728] ACPI Warning: 0x0000000000000500-0x000000000000052f
> SystemIO conflicts with Region \_SB_.PCI0.LPCB.GPBX 2
> (20131115/utaddress-251)
> [   11.172732] ACPI: If an ACPI driver is available for this device,
> you should use it instead of the native driver
> [   11.172733] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [   11.186137] btrfs: device fsid 0c1f52fd-e403-4e07-ad2d-edf3d9da039d
> devid 3 transid 34755 /dev/sdc
> [   11.189275] btrfs: device fsid 0c1f52fd-e403-4e07-ad2d-edf3d9da039d
> devid 1 transid 34755 /dev/sdb
> [   11.193477] btrfs: device fsid 0c1f52fd-e403-4e07-ad2d-edf3d9da039d
> devid 3 transid 34755 /dev/sdc
> [   11.198249] btrfs: device fsid 0c1f52fd-e403-4e07-ad2d-edf3d9da039d
> devid 1 transid 34755 /dev/sdb
> [   11.205094] WARNING! power/level is deprecated; use power/control instead
> [   11.223521] systemd-udevd[486]: renamed network interface eth0 to eth1
> [   11.230527] type=1400 audit(1441394196.958:2): apparmor="STATUS"
> operation="profile_load" profile="unconfined" name="/sbin/dhclient"
> pid=710 comm="apparmor_parser"
> [   11.230533] type=1400 audit(1441394196.958:3): apparmor="STATUS"
> operation="profile_load" profile="unconfined"
> name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=710
> comm="apparmor_parser"
> [   11.230536] type=1400 audit(1441394196.958:4): apparmor="STATUS"
> operation="profile_load" profile="unconfined"
> name="/usr/lib/connman/scripts/dhclient-script" pid=710
> comm="apparmor_parser"
> [   11.230881] type=1400 audit(1441394196.958:5): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=710
> comm="apparmor_parser"
> [   11.230885] type=1400 audit(1441394196.958:6): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/lib/connman/scripts/dhclient-script" pid=710
> comm="apparmor_parser"
> [   11.231065] type=1400 audit(1441394196.958:7): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/lib/connman/scripts/dhclient-script" pid=710
> comm="apparmor_parser"
> [   11.236836] btrfs: device fsid be4138ff-0dd9-48ed-9408-9dd679d4cc0b
> devid 1 transid 329588 /dev/sda1
> [   11.243628] btrfs: device fsid be4138ff-0dd9-48ed-9408-9dd679d4cc0b
> devid 1 transid 329588 /dev/sda1
> [   11.244198] Linux video capture interface: v2.00
> [   11.255290] uvcvideo: Found UVC 1.00 device HP Webcam HD 3300 (03f0:e307)
> [   11.257894] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
> [   11.267304] input: HP Webcam HD 3300 as
> /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6.2/2-1.6.2:1.0/input/input10
> [   11.267485] usbcore: registered new interface driver uvcvideo
> [   11.267487] USB Video Class driver (1.1.1)
> [   11.292706] SKU: Nid=0x1d sku_cfg=0x4016c629
> [   11.292709] SKU: port_connectivity=0x1
> [   11.292710] SKU: enable_pcbeep=0x1
> [   11.292711] SKU: check_sum=0x00000006
> [   11.292712] SKU: customization=0x000000c6
> [   11.292712] SKU: external_amp=0x5
> [   11.292713] SKU: platform_type=0x0
> [   11.292714] SKU: swap=0x0
> [   11.292715] SKU: override=0x1
> [   11.293346] autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
> [   11.293348]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [   11.293349]    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
> [   11.293350]    mono: mono_out=0x0
> [   11.293351]    dig-out=0x11/0x1e
> [   11.293351]    inputs:
> [   11.293353]      Front Mic=0x19
> [   11.293354]      Rear Mic=0x18
> [   11.293355]      Line=0x1a
> [   11.293356] realtek: No valid SSID, checking pincfg 0x4016c629 for NID 0x1d
> [   11.293357] realtek: Enabling init ASM_ID=0xc629 CODEC_ID=10ec0887
> [   11.300526] asus_wmi: ASUS WMI generic driver loaded
> [   11.303937] asus_wmi: Initialization: 0x0
> [   11.303963] asus_wmi: BIOS WMI version: 0.9
> [   11.304009] asus_wmi: SFUN value: 0x0
> [   11.304375] input: Eee PC WMI hotkeys as
> /devices/platform/eeepc-wmi/input/input11
> [   11.306312] asus_wmi: Backlight controlled by ACPI video driver
> [   11.328366] input: HDA Intel PCH HDMI/DP,pcm=3 as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
> [   11.328495] input: HDA Intel PCH Front Headphone as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
> [   11.328611] input: HDA Intel PCH Line Out as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
> [   11.328832] usbcore: registered new interface driver snd-usb-audio
> [   11.329014] input: HDA Intel PCH Line as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
> [   11.329138] input: HDA Intel PCH Rear Mic as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
> [   11.329254] input: HDA Intel PCH Front Mic as
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
> [   11.361634] init: Failed to obtain startpar-bridge instance:
> Unknown parameter: INSTANCE
> [   12.340581] usblp 2-1.8:1.0: usblp3: USB Bidirectional printer dev
> 5 if 0 alt 1 proto 2 vid 0x03F0 pid 0x3217
> [   12.340603] usbcore: registered new interface driver usblp
> [   25.613739] FS-Cache: Loaded
> [   25.622135] RPC: Registered named UNIX socket transport module.
> [   25.622138] RPC: Registered udp transport module.
> [   25.622139] RPC: Registered tcp transport module.
> [   25.622140] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [   25.640074] FS-Cache: Netfs 'nfs' registered for caching
> [   25.659220] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [   25.671325] init: failsafe main process (945) killed by TERM signal
> [   25.723593] Bluetooth: Core ver 2.17
> [   25.723608] NET: Registered protocol family 31
> [   25.723610] Bluetooth: HCI device and connection manager initialized
> [   25.723617] Bluetooth: HCI socket layer initialized
> [   25.723620] Bluetooth: L2CAP socket layer initialized
> [   25.723625] Bluetooth: SCO socket layer initialized
> [   25.725710] init: samba-ad-dc main process (1008) terminated with status 1
> [   25.728247] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   25.728250] Bluetooth: BNEP filters: protocol multicast
> [   25.728257] Bluetooth: BNEP socket layer initialized
> [   25.730151] Bluetooth: RFCOMM TTY layer initialized
> [   25.730158] Bluetooth: RFCOMM socket layer initialized
> [   25.730163] Bluetooth: RFCOMM ver 1.11
> [   25.767409] type=1400 audit(1441394211.482:8): apparmor="STATUS"
> operation="profile_load" profile="unconfined"
> name="/usr/lib/cups/backend/cups-pdf" pid=1115 comm="apparmor_parser"
> [   25.767415] type=1400 audit(1441394211.482:9): apparmor="STATUS"
> operation="profile_load" profile="unconfined" name="/usr/sbin/cupsd"
> pid=1115 comm="apparmor_parser"
> [   25.767758] type=1400 audit(1441394211.482:10): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/sbin/cupsd" pid=1115 comm="apparmor_parser"
> [   25.781927] init: cups main process (1139) killed by HUP signal
> [   25.781935] init: cups main process ended, respawning
> [   25.807506] type=1400 audit(1441394211.522:11): apparmor="STATUS"
> operation="profile_replace" profile="unconfined" name="/sbin/dhclient"
> pid=1196 comm="apparmor_parser"
> [   25.807514] type=1400 audit(1441394211.522:12): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1196
> comm="apparmor_parser"
> [   25.807517] type=1400 audit(1441394211.522:13): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/lib/connman/scripts/dhclient-script" pid=1196
> comm="apparmor_parser"
> [   25.807840] type=1400 audit(1441394211.522:14): apparmor="STATUS"
> operation="profile_load" profile="unconfined"
> name="/usr/sbin/cups-browsed" pid=1200 comm="apparmor_parser"
> [   25.807856] type=1400 audit(1441394211.522:15): apparmor="STATUS"
> operation="profile_load" profile="unconfined" name="/usr/sbin/mysqld"
> pid=1202 comm="apparmor_parser"
> [   25.807863] type=1400 audit(1441394211.522:16): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1196
> comm="apparmor_parser"
> [   25.807866] type=1400 audit(1441394211.522:17): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/lib/connman/scripts/dhclient-script" pid=1196
> comm="apparmor_parser"
> [   25.936705] r8169 0000:03:00.0 eth1: link down
> [   25.936746] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
> [   25.936770] r8169 0000:03:00.0 eth1: link down
> [   25.936893] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
> [   26.143965] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
> recovery directory
> [   26.143978] NFSD: starting 90-second grace period (net ffffffff81cdab80)
> [   26.333122] vboxdrv: module verification failed: signature and/or
> required key missing - tainting kernel
> [   26.335909] vboxdrv: Found 8 processor cores.
> [   26.336152] vboxdrv: fAsync=0 offMin=0x1f6 offMax=0x3a76
> [   26.336213] vboxdrv: TSC mode is 'synchronous', kernel timer mode
> is 'normal'.
> [   26.336214] vboxdrv: Successfully loaded version 4.3.10_Ubuntu
> (interface 0x001a0007).
> [   26.356040] vboxpci: IOMMU not found (not registered)
> [   26.425381] init: plymouth-upstart-bridge main process ended, respawning
> [   26.429145] init: plymouth-upstart-bridge main process (1733)
> terminated with status 1
> [   26.429154] init: plymouth-upstart-bridge main process ended, respawning
> [   28.093691] r8169 0000:03:00.0 eth1: link up
> [   28.093698] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> [   29.210730] init: plexmediaserver main process (2323) terminated
> with status 2
> [   29.210745] init: plexmediaserver main process ended, respawning
> [   29.222150] init: plexmediaserver main process (2349) terminated
> with status 2
> [   29.222167] init: plexmediaserver main process ended, respawning
> [   29.227101] init: plexmediaserver main process (2375) terminated
> with status 2
> [   29.227110] init: plexmediaserver main process ended, respawning
> [   29.231627] init: plexmediaserver main process (2381) terminated
> with status 2
> [   29.231635] init: plexmediaserver main process ended, respawning
> [   29.241439] init: plexmediaserver main process (2387) terminated
> with status 2
> [   29.241453] init: plexmediaserver main process ended, respawning
> [   29.247316] init: plexmediaserver main process (2401) terminated
> with status 2
> [   29.247324] init: plexmediaserver main process ended, respawning
> [   29.251046] init: plexmediaserver main process (2407) terminated
> with status 2
> [   29.251053] init: plexmediaserver main process ended, respawning
> [   29.254974] init: plexmediaserver main process (2410) terminated
> with status 2
> [   29.254991] init: plexmediaserver main process ended, respawning
> [   29.258536] init: plexmediaserver main process (2413) terminated
> with status 2
> [   29.258544] init: plexmediaserver main process ended, respawning
> [   29.262168] init: plexmediaserver main process (2416) terminated
> with status 2
> [   29.262176] init: plexmediaserver main process ended, respawning
> [   29.265842] init: plexmediaserver main process (2419) terminated
> with status 2
> [   29.265850] init: plexmediaserver respawning too fast, stopped
> [   46.534732] init: plymouth-stop pre-start process (5500) terminated
> with status 1
> [   55.865621] audit_printk_skb: 138 callbacks suppressed
> [   55.865624] type=1400 audit(1441394241.545:64): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/lib/cups/backend/cups-pdf" pid=5569 comm="apparmor_parser"
> [   55.865628] type=1400 audit(1441394241.545:65): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/sbin/cupsd" pid=5569 comm="apparmor_parser"
> [   55.865896] type=1400 audit(1441394241.545:66): apparmor="STATUS"
> operation="profile_replace" profile="unconfined"
> name="/usr/sbin/cupsd" pid=5569 comm="apparmor_parser"
>
>
> Thanks,
>
