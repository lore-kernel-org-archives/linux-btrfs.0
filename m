Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29820 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbbDIIKr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 04:10:47 -0400
Date: Thu, 9 Apr 2015 16:10:31 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Paul Harvey <csirac2@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS corruption w/kernel 3.13 while using docker -s btrfs
Message-ID: <20150409081028.GA8979@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <537844F2.1040507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537844F2.1040507@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Sun, May 18, 2014 at 03:28:18PM +1000, Paul Harvey wrote:
> This is a "Damnit! I held the power button in and now it won't mount!" story, but I'm sharing what I found to learn what I can. And in case it's useful for btrfs development.
> 
> Also curious if my usage of Docker (an LXC thing, http://docker.io) has exacerbated things. I ask because it seems some btrfs mount options are breaking docker:
> https://github.com/dotcloud/docker/issues/5429#issuecomment-42443919 - however, I'm not using space_cache or inode_cache myself.
> 
> Notes:
> - I've taken a dd copy of the btrfs partition so that I can perform anything extra people would like to see.
> - The following output is taken from the same machine, same partition layout but a fresh/working Debian testing install on a different disk. It should be reporting the same as it did before the corruption (it was definitely Linux 3.13).
> - /dev/sda is a new disk, /dev/sdb3 is the corrupted btrfs partition.
> - I have a single btrfs partition which contains the rootfs. I use subvolumes to separately snapshot /home, /vms, etc.
> - mount options were: noatime,autodefrag,discard,compress=lzo
> 
> $ uname -a
> Linux weatherwax 3.13-1-amd64 #1 SMP Debian 3.13.10-1 (2014-04-15)
> x86_64 GNU/Linux
> $ sudo btrfs version
> Btrfs v3.14.1
> $ sudo btrfs fi show /dev/sdb3
> Label: 'weatherwax 0'  uuid: 721926c3-147a-44a0-8c82-62534dd6ee94
>          Total devices 1 FS bytes used 246.14GiB
>          devid    1 size 357.63GiB used 313.06GiB path /dev/sdb3
> 
> Btrfs v3.14.1
> $ dmesg # see attached dmesg.txt, includes connecting corrupted disk via USB
> $ sudo mount -o recovery,ro /dev/sdb3 /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/sdb3,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
>         dmesg | tail  or so
> [ 1297.632057] btrfs: device label weatherwax 0 devid 1 transid 504075 /dev/sdb3
> [ 1297.633042] btrfs: enabling auto recovery
> [ 1297.633045] btrfs: disk space caching is enabled
> [ 1297.830793] btrfs bad tree block start 0 632081858560
> [ 1297.831012] btrfs bad tree block start 0 632081858560
> [ 1297.831016] btrfs: failed to read log tree
> [ 1297.892241] btrfs: open_ctree failed

This shows that your trees are good except log tree, as if btrfs uses
backup trees for recovery it'll zero log tree and clear free space cache ,
I recommend you to use btrfs-zero-log.

Thanks,

-liubo

> $ sudo btrfs-find-root /dev/sdb3
> Super think's the tree root is at 632081670144, chunk root 386274426880
> Went past the fs size, exiting
> $ sudo btrfs-image -c9 -t4 /dev/sdb3 /mnt/sdb3.img
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> read block failed check_tree_block
> Couldn't setup log root tree
> Open ctree failed
> create failed (Success)
> $ du /mnt/sdb3.img
> 0       /mnt/sdb3.img
> $ sudo btrfs rescue chunk-recover /dev/sdb3 # Takes a few hours at
> 30MiB/sec, reports 326 (IIRC) good chunks, no bad or orphaned chunks.
> $ sudo btrfs restore -i /dev/sdb3 /mnt # recovers ~3.2GB of /var from
> the old rootfs, nothing useful. A lot of "failed to inflate: -6"
> $ sudo btrfs restore -l /dev/sdb3
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> read block failed check_tree_block
> Couldn't setup log root tree
>   tree key (EXTENT_TREE ROOT_ITEM 0) 632081240064 level 3
>   tree key (DEV_TREE ROOT_ITEM 0) 631709724672 level 1
>   tree key (FS_TREE ROOT_ITEM 0) 632081072128 level 3
>   tree key (CSUM_TREE ROOT_ITEM 0) 632079880192 level 3
>   tree key (UUID_TREE ROOT_ITEM 0) 632070057984 level 0
>   tree key (262 ROOT_ITEM 0) 632079863808 level 3
>   tree key (263 ROOT_ITEM 0) 530849677312 level 2
>   tree key (264 ROOT_ITEM 0) 632081104896 level 3
>   tree key (265 ROOT_ITEM 0) 632070590464 level 3
>   tree key (577 ROOT_ITEM 0) 633083752448 level 2
> # ... ~80 more lines of similar output
> $ sudo btrfsck /dev/sdb3 # exits quickly, < 2s
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> read block failed check_tree_block
> Couldn't setup log root tree
> Checking filesystem on /dev/sdb3
> UUID: 721926c3-147a-44a0-8c82-62534dd6ee94
> checking extents
> btrfsck[5378]: segfault at 1d8 ip 00000000004176d4 sp 00007fff50ed58a0 error 4 in btrfsck[400000+57000] # from dmesg
> $ sudo btrfsck --backup /dev/sdb3 # same output as above, exits just as quickly
> btrfsck[5384]: segfault at 1d8 ip 00000000004176d4 sp 00007fff1bf37df0 error 4 in btrfsck[400000+57000] # from dmesg
> $ sudo btrfsck --repair -s 1 /dev/sdb3
> using SB copy 1, bytenr 274877906944
> Checking filesystem on /dev/sdb3
> UUID: 721926c3-147a-44a0-8c82-62534dd6ee94
> checking extents
> checking free space cache
> checking fs roots
> root 5 inode 374153 errors 400, nbytes wrong
> root 5 inode 374156 errors 400, nbytes wrong
> root 5 inode 374157 errors 400, nbytes wrong
> root 5 inode 374159 errors 400, nbytes wrong
> root 5 inode 374160 errors 400, nbytes wrong
> root 5 inode 374162 errors 400, nbytes wrong
> root 5 inode 374163 errors 400, nbytes wrong
> found 142401001787 bytes used err is 1
> total csum bytes: 254703028
> total tree bytes: 2354339840
> total fs tree bytes: 1903390720
> total extent tree bytes: 145313792
> btree space waste bytes: 541129559
> file data blocks allocated: 1952295919616
>   referenced 257779679232
> Btrfs v3.14.1
> $ sudo mount -o recovery,ro /dev/sdb3 /media/usb1/
> [ 5005.342936] btrfs: device label weatherwax 0 devid 1 transid 504075 /dev/sdb3
> [ 5005.343763] btrfs: enabling auto recovery
> [ 5005.343767] btrfs: disk space caching is enabled
> [ 5005.541425] btrfs bad tree block start 0 632081858560
> [ 5005.541641] btrfs bad tree block start 0 632081858560
> [ 5005.541646] btrfs: failed to read log tree
> [ 5005.604631] btrfs: open_ctree failed
> $ sudo btrfs restore -i -r 262 /dev/sdb3 /mnt/home/ # This ends up recovering most of the subvol I want to recover.
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> read block failed check_tree_block
> Couldn't setup log root tree
> failed to inflate: -6
> $ sudo btrfs restore -i -r 263 /dev/sdb3 /mnt/vms/ # This recovers a fair chunk of another subvol, not all...
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> Check tree block failed, want=632081858560, have=0
> read block failed check_tree_block
> Couldn't setup log root tree
> failed to inflate: -6
> failed to inflate: -6
> failed to inflate: -8
> failed to inflate: -6
> failed to inflate: -6
> failed to inflate: -6
> failed to inflate: -6
> failed to inflate: -8
> failed to inflate: -6
> *** Error in `btrfs': double free or corruption (out): 0x0000000002279f50 ***
> btrfs: malloc.c:2368: sysmalloc: Assertion `(old_top == (((mbinptr) (((char *) &((av)->bins[((1) - 1) * 2])) - __builtin_offsetof (struct
> malloc_chunk, fd)))) && old_size == 0) || ((unsigned long) (old_size) >= (unsigned long)((((__builtin_offsetof (struct malloc_chunk,
> fd_nextsize))+((2 * (sizeof(size_t))) - 1)) & ~((2 * (sizeof(size_t))) - 1))) && ((old_top)->size & 0x1) && ((unsigned long)old_end &
> pagemask) == 0)' failed.
> 
> A timeline, starting around midday yesterday:
> - I had some work to do and the VPN was slow, so on my laptop I upgraded docker from ~0.8.1 to 0.11.1.
> - The upgrade stomped on my "-s btrfs" switch in /etc/default/docker which meant I was accidentally using docker with aufs for a while.
> - I fixed this then purged all the containers and images (i.e. btrfs subvolumes).
> - I did "docker pull debian:testing" which would have created a few new btrfs subvolumes.
> - I ran some "docker build"s and at some point I had two builds going at once (two docker processes each creating btrfs subvolumes/snapshots at the same time).
> - At some point one docker build was completed and the other was stalled trying to create a snapshot.
> - Minutes later I noticed that my other applications were freezing up. The UI was still responsive and I could use the terminal.
> - I looked at syslog and dmesg output in a terminal. There were no messages, ominous or otherwise coinciding with the disk i/o freezing up.
> - I held in the power button.
> - The reboot didn't boot. I ended up with the dreaded busybox shell, unable to mount btrfs rootfs...
> - Removed disk and took a dd copy of sda3.
> 
> Other research...
> Certain BTRFS mount options break docker -s btrfs:
> - https://github.com/dotcloud/docker/issues/5429#issuecomment-42443919
> 
> The "AUFS on btrfs" thing has a few mentions in docker issues, perhaps it's nothing to do with btrfs though:
> - https://github.com/dotcloud/docker/issues/829 - continued at...
> - https://github.com/dotcloud/docker/issues/1075 - continued at...
> - https://github.com/dotcloud/docker/issues/2961
> - https://github.com/dotcloud/docker/issues/2056 # just another datapoint.
> 
> Cheers
> 
> --
> Paul Harvey
> 
> 

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.13-1-amd64 (debian-kernel@lists.debian.org) (gcc version 4.8.2 (Debian 4.8.2-16) ) #1 SMP Debian 3.13.10-1 (2014-04-15)
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.13-1-amd64 root=UUID=3d64a40f-70bb-4d8e-b8b8-8491b0e48b87 ro quiet
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000cd41cfff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000cd41d000-0x00000000dae9efff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000df9fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041e5fffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000041e600000-0x000000041effffff] reserved
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.7 present.
> [    0.000000] DMI: LENOVO 2306CTO/2306CTO, BIOS G2ET91WW (2.51 ) 01/14/2013
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x41e600 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
> [    0.000000]   1 base 000000000 mask F80000000 write-back
> [    0.000000]   2 base 080000000 mask FC0000000 write-back
> [    0.000000]   3 base 0C0000000 mask FE0000000 write-back
> [    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
> [    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
> [    0.000000]   6 base 100000000 mask F00000000 write-back
> [    0.000000]   7 base 200000000 mask E00000000 write-back
> [    0.000000]   8 base 400000000 mask FE0000000 write-back
> [    0.000000]   9 base 41F000000 mask FFF000000 uncachable
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820: last_pfn = 0xcd41d max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000f0100-0x000f010f] mapped at [ffff8800000f0100]
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x01a9a000, 0x01a9afff] PGTABLE
> [    0.000000] BRK [0x01a9b000, 0x01a9bfff] PGTABLE
> [    0.000000] BRK [0x01a9c000, 0x01a9cfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x41e400000-0x41e5fffff]
> [    0.000000]  [mem 0x41e400000-0x41e5fffff] page 2M
> [    0.000000] BRK [0x01a9d000, 0x01a9dfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x41c000000-0x41e3fffff]
> [    0.000000]  [mem 0x41c000000-0x41e3fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
> [    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
> [    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
> [    0.000000]  [mem 0x40000000-0x40003fff] page 4k
> [    0.000000] BRK [0x01a9e000, 0x01a9efff] PGTABLE
> [    0.000000] BRK [0x01a9f000, 0x01a9ffff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x40005000-0xcd41cfff]
> [    0.000000]  [mem 0x40005000-0x401fffff] page 4k
> [    0.000000]  [mem 0x40200000-0xcd3fffff] page 2M
> [    0.000000]  [mem 0xcd400000-0xcd41cfff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
> [    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
> [    0.000000] RAMDISK: [mem 0x3646c000-0x3722dfff]
> [    0.000000] ACPI: RSDP 00000000000f0120 000024 (v02 LENOVO)
> [    0.000000] ACPI: XSDT 00000000daffe170 0000BC (v01 LENOVO TP-G2    00002510 PTL  00000002)
> [    0.000000] ACPI: FACP 00000000dafe7000 00010C (v05 LENOVO TP-G2    00002510 PTL  00000002)
> [    0.000000] ACPI: DSDT 00000000dafe9000 010E11 (v01 LENOVO TP-G2    00002510 INTL 20061109)
> [    0.000000] ACPI: FACS 00000000daf5a000 000040
> [    0.000000] ACPI: TCPA 00000000daffd000 000032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
> [    0.000000] ACPI: SSDT 00000000daffc000 000408 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
> [    0.000000] ACPI: SSDT 00000000daffb000 000033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
> [    0.000000] ACPI: SSDT 00000000daffa000 0007A8 (v01 LENOVO SataAhci 00001000 INTL 20061109)
> [    0.000000] ACPI: HPET 00000000dafe5000 000038 (v01 LENOVO TP-G2    00002510 PTL  00000002)
> [    0.000000] ACPI: APIC 00000000dafe4000 000098 (v01 LENOVO TP-G2    00002510 PTL  00000002)
> [    0.000000] ACPI: MCFG 00000000dafe3000 00003C (v01 LENOVO TP-G2    00002510 PTL  00000002)
> [    0.000000] ACPI: ECDT 00000000dafe2000 000052 (v01 LENOVO TP-G2    00002510 PTL  00000002)
> [    0.000000] ACPI: FPDT 00000000dafe1000 000064 (v01 LENOVO TP-G2    00002510 PTL  00000002)
> [    0.000000] ACPI: ASF! 00000000dafe8000 0000A5 (v32 LENOVO TP-G2    00002510 PTL  00000002)
> [    0.000000] ACPI: UEFI 00000000dafe0000 00003E (v01 LENOVO TP-G2    00002510 PTL  00000002)
> [    0.000000] ACPI: UEFI 00000000dafdf000 000042 (v01 PTL      COMBUF 00000001 PTL  00000001)
> [    0.000000] ACPI: MSDM 00000000dafde000 000055 (v03 LENOVO TP-G2    00002510 PTL  00000002)
> [    0.000000] ACPI: SSDT 00000000dafdd000 000C79 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
> [    0.000000] ACPI: SSDT 00000000dafdc000 000A83 (v01  PmRef    CpuPm 00003000 INTL 20061109)
> [    0.000000] ACPI: DMAR 00000000dafdb000 0000B8 (v01 INTEL      SNB  00000001 INTL 00000001)
> [    0.000000] ACPI: UEFI 00000000dafda000 0002A6 (v01 LENOVO TP-G2    00002510 PTL  00000002)
> [    0.000000] ACPI: DBG2 00000000dafd9000 0000E9 (v00 LENOVO TP-G2    00002510 PTL  00000002)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041e5fffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x41e5fffff]
> [    0.000000]   NODE_DATA [mem 0x41e5ec000-0x41e5f0fff]
> [    0.000000]  [ffffea0000000000-ffffea000e7fffff] PMD -> [ffff88040e000000-ffff88041bdfffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x41e5fffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
> [    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
> [    0.000000]   node   0: [mem 0x20200000-0x40003fff]
> [    0.000000]   node   0: [mem 0x40005000-0xcd41cfff]
> [    0.000000]   node   0: [mem 0x100000000-0x41e5fffff]
> [    0.000000] On node 0 totalpages: 4110264
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3996 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 11432 pages used for memmap
> [    0.000000]   DMA32 zone: 836124 pages, LIFO batch:31
> [    0.000000]   Normal zone: 44709 pages used for memmap
> [    0.000000]   Normal zone: 3270144 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
> [    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
> [    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xcd41d000-0xdae9efff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdae9f000-0xdaf9efff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdaf9f000-0xdaffefff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdafff000-0xdf9fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed07fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed08fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed09000-0xfed0ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffbfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffffffff]
> [    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88041e200000 s85824 r8192 d20672 u262144
> [    0.000000] pcpu-alloc: s85824 r8192 d20672 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4054046
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.13-1-amd64 root=UUID=3d64a40f-70bb-4d8e-b8b8-8491b0e48b87 ro quiet
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] Memory: 16121392K/16441056K available (4811K kernel code, 693K rwdata, 1620K rodata, 984K init, 952K bss, 319664K reserved)
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=8.
> [    0.000000] NR_IRQS:33024 nr_irqs:744 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.004000] tsc: Detected 2793.535 MHz processor
> [    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5587.07 BogoMIPS (lpj=11174140)
> [    0.000004] pid_max: default: 32768 minimum: 301
> [    0.000022] Security Framework initialized
> [    0.000025] AppArmor: AppArmor disabled by boot time parameter
> [    0.000026] Yama: disabled by default; enable with sysctl kernel.yama.*
> [    0.000768] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> [    0.004242] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> [    0.005827] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.005842] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.006023] Initializing cgroup subsys memory
> [    0.006027] Initializing cgroup subsys devices
> [    0.006029] Initializing cgroup subsys freezer
> [    0.006030] Initializing cgroup subsys blkio
> [    0.006031] Initializing cgroup subsys perf_event
> [    0.006050] CPU: Physical Processor ID: 0
> [    0.006051] CPU: Processor Core ID: 0
> [    0.006055] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.006055] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.006373] mce: CPU supports 7 MCE banks
> [    0.006383] CPU0: Thermal monitoring enabled (TM1)
> [    0.006390] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
> [    0.006390] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
> [    0.006390] tlb_flushall_shift: 2
> [    0.006476] Freeing SMP alternatives memory: 20K (ffffffff819a5000 - ffffffff819aa000)
> [    0.007366] ACPI: Core revision 20131115
> [    0.012511] ACPI: All ACPI Tables successfully acquired
> [    0.109376] dmar: Host address width 36
> [    0.109378] dmar: DRHD base: 0x000000fed90000 flags: 0x0
> [    0.109383] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
> [    0.109384] dmar: DRHD base: 0x000000fed91000 flags: 0x1
> [    0.109387] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
> [    0.109388] dmar: RMRR base: 0x000000da2ba000 end: 0x000000da2d0fff
> [    0.109389] dmar: RMRR base: 0x000000db800000 end: 0x000000df9fffff
> [    0.109462] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
> [    0.109463] HPET id 0 under DRHD base 0xfed91000
> [    0.109591] Enabled IRQ remapping in x2apic mode
> [    0.109593] Enabling x2apic
> [    0.109594] Enabled x2apic
> [    0.109601] Switched APIC routing to cluster x2apic.
> [    0.110046] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.149777] smpboot: CPU0: Intel(R) Core(TM) i5-3360M CPU @ 2.80GHz (fam: 06, model: 3a, stepping: 09)
> [    0.149786] TSC deadline timer enabled
> [    0.149795] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
> [    0.149802] ... version:                3
> [    0.149802] ... bit width:              48
> [    0.149803] ... generic registers:      4
> [    0.149804] ... value mask:             0000ffffffffffff
> [    0.149804] ... max period:             0000ffffffffffff
> [    0.149805] ... fixed-purpose events:   3
> [    0.149806] ... event mask:             000000070000000f
> [    0.150041] x86: Booting SMP configuration:
> [    0.163473] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    0.150042] .... node  #0, CPUs:      #1 #2 #3
> [    0.190362] x86: Booted up 1 node, 4 CPUs
> [    0.190365] smpboot: Total of 4 processors activated (22348.28 BogoMIPS)
> [    0.193089] devtmpfs: initialized
> [    0.195760] PM: Registering ACPI NVS region [mem 0xdae9f000-0xdaf9efff] (1048576 bytes)
> [    0.195909] NET: Registered protocol family 16
> [    0.195976] cpuidle: using governor ladder
> [    0.195977] cpuidle: using governor menu
> [    0.195995] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    0.195997] ACPI: bus type PCI registered
> [    0.195998] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.196181] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.196184] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> [    0.200631] PCI: Using configuration type 1 for base access
> [    0.201166] bio: create slab <bio-0> at 0
> [    0.201257] ACPI: Added _OSI(Module Device)
> [    0.201258] ACPI: Added _OSI(Processor Device)
> [    0.201259] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.201260] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.202380] ACPI : EC: EC description table is found, configuring boot EC
> [    0.205961] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.241595] ACPI: SSDT 00000000dae3a018 000A01 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
> [    0.241881] ACPI: Dynamic OEM Table Load:
> [    0.241883] ACPI: SSDT           (null) 000A01 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
> [    0.253262] ACPI: SSDT 00000000dae3ba98 000303 (v01  PmRef    ApIst 00003000 INTL 20061109)
> [    0.253572] ACPI: Dynamic OEM Table Load:
> [    0.253573] ACPI: SSDT           (null) 000303 (v01  PmRef    ApIst 00003000 INTL 20061109)
> [    0.262585] ACPI: SSDT 00000000dae39d98 000119 (v01  PmRef    ApCst 00003000 INTL 20061109)
> [    0.262863] ACPI: Dynamic OEM Table Load:
> [    0.262864] ACPI: SSDT           (null) 000119 (v01  PmRef    ApCst 00003000 INTL 20061109)
> [    0.275029] ACPI: Interpreter enabled
> [    0.275033] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
> [    0.275037] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
> [    0.275047] ACPI: (supports S0 S3 S4 S5)
> [    0.275049] ACPI: Using IOAPIC for interrupt routing
> [    0.275066] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.275860] ACPI: ACPI Dock Station Driver: 3 docks/bays found
> [    0.289546] ACPI: Power Resource [PUBS] (on)
> [    0.293871] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.293946] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11)
> [    0.294018] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 9 10 11)
> [    0.294089] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.294161] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.294232] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 9 10 11)
> [    0.294302] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 *10 11)
> [    0.294373] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
> [    0.294408] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
> [    0.294412] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.294500] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
> [    0.294542] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
> [    0.294544] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
> [    0.294546] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
> [    0.294547] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
> [    0.294680] PCI host bridge to bus 0000:00
> [    0.294682] pci_bus 0000:00: root bus resource [bus 00-3f]
> [    0.294684] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.294685] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.294686] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.294688] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff]
> [    0.294689] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
> [    0.294695] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
> [    0.294761] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
> [    0.294770] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
> [    0.294776] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
> [    0.294780] pci 0000:00:02.0: reg 0x20: [io  0x5000-0x503f]
> [    0.294857] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
> [    0.294878] pci 0000:00:14.0: reg 0x10: [mem 0xf2520000-0xf252ffff 64bit]
> [    0.294946] pci 0000:00:14.0: PME# supported from D3hot D3cold
> [    0.294974] pci 0000:00:14.0: System wakeup disabled by ACPI
> [    0.295006] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
> [    0.295028] pci 0000:00:16.0: reg 0x10: [mem 0xf2535000-0xf253500f 64bit]
> [    0.295101] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    0.295156] pci 0000:00:16.3: [8086:1e3d] type 00 class 0x070002
> [    0.295173] pci 0000:00:16.3: reg 0x10: [io  0x50b0-0x50b7]
> [    0.295183] pci 0000:00:16.3: reg 0x14: [mem 0xf253c000-0xf253cfff]
> [    0.295305] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
> [    0.295322] pci 0000:00:19.0: reg 0x10: [mem 0xf2500000-0xf251ffff]
> [    0.295330] pci 0000:00:19.0: reg 0x14: [mem 0xf253b000-0xf253bfff]
> [    0.295338] pci 0000:00:19.0: reg 0x18: [io  0x5080-0x509f]
> [    0.295398] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
> [    0.295425] pci 0000:00:19.0: System wakeup disabled by ACPI
> [    0.295457] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
> [    0.295477] pci 0000:00:1a.0: reg 0x10: [mem 0xf253a000-0xf253a3ff]
> [    0.295564] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    0.295594] pci 0000:00:1a.0: System wakeup disabled by ACPI
> [    0.295625] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
> [    0.295639] pci 0000:00:1b.0: reg 0x10: [mem 0xf2530000-0xf2533fff 64bit]
> [    0.295703] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.295736] pci 0000:00:1b.0: System wakeup disabled by ACPI
> [    0.295767] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
> [    0.295897] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.295968] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
> [    0.296096] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.296169] pci 0000:00:1c.2: [8086:1e14] type 01 class 0x060400
> [    0.296297] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.296338] pci 0000:00:1c.2: System wakeup disabled by ACPI
> [    0.296373] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
> [    0.296392] pci 0000:00:1d.0: reg 0x10: [mem 0xf2539000-0xf25393ff]
> [    0.296479] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    0.296509] pci 0000:00:1d.0: System wakeup disabled by ACPI
> [    0.296539] pci 0000:00:1f.0: [8086:1e55] type 00 class 0x060100
> [    0.296686] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
> [    0.296703] pci 0000:00:1f.2: reg 0x10: [io  0x50a8-0x50af]
> [    0.296711] pci 0000:00:1f.2: reg 0x14: [io  0x50bc-0x50bf]
> [    0.296718] pci 0000:00:1f.2: reg 0x18: [io  0x50a0-0x50a7]
> [    0.296726] pci 0000:00:1f.2: reg 0x1c: [io  0x50b8-0x50bb]
> [    0.296733] pci 0000:00:1f.2: reg 0x20: [io  0x5060-0x507f]
> [    0.296740] pci 0000:00:1f.2: reg 0x24: [mem 0xf2538000-0xf25387ff]
> [    0.296782] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.296830] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
> [    0.296844] pci 0000:00:1f.3: reg 0x10: [mem 0xf2534000-0xf25340ff 64bit]
> [    0.296864] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
> [    0.297208] pci 0000:02:00.0: [1180:e822] type 00 class 0x088001
> [    0.297227] pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
> [    0.297254] pci 0000:02:00.0: reg 0x10: [mem 0xf1d00000-0xf1d000ff]
> [    0.297457] pci 0000:02:00.0: supports D1 D2
> [    0.297458] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.305267] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.305275] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
> [    0.305280] pci 0000:00:1c.0:   bridge window [mem 0xf1d00000-0xf24fffff]
> [    0.305288] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
> [    0.305513] pci 0000:03:00.0: [8086:0085] type 00 class 0x028000
> [    0.305662] pci 0000:03:00.0: reg 0x10: [mem 0xf1c00000-0xf1c01fff 64bit]
> [    0.306371] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> [    0.317352] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.317361] pci 0000:00:1c.1:   bridge window [mem 0xf1c00000-0xf1cfffff]
> [    0.317463] acpiphp: Slot [1] registered
> [    0.317472] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
> [    0.317478] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
> [    0.317482] pci 0000:00:1c.2:   bridge window [mem 0xf1400000-0xf1bfffff]
> [    0.317491] pci 0000:00:1c.2:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
> [    0.318431] ACPI: Enabled 4 GPEs in block 00 to 3F
> [    0.318440] ACPI: \_SB_.PCI0: notify handler is installed
> [    0.318474] Found 1 acpi root devices
> [    0.318524] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
> [    0.318591] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.318593] vgaarb: loaded
> [    0.318594] vgaarb: bridge control possible 0000:00:02.0
> [    0.318622] PCI: Using ACPI for IRQ routing
> [    0.320307] PCI: pci_cache_line_size set to 64 bytes
> [    0.320677] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
> [    0.320678] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
> [    0.320679] e820: reserve RAM buffer [mem 0xcd41d000-0xcfffffff]
> [    0.320680] e820: reserve RAM buffer [mem 0x41e600000-0x41fffffff]
> [    0.320759] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    0.320762] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    0.322791] Switched to clocksource hpet
> [    0.323949] pnp: PnP ACPI init
> [    0.323958] ACPI: bus type PNP registered
> [    0.324273] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
> [    0.324275] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
> [    0.324277] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
> [    0.324278] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
> [    0.324280] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
> [    0.324281] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
> [    0.324282] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
> [    0.324284] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
> [    0.324285] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
> [    0.324287] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
> [    0.324288] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
> [    0.324290] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
> [    0.324291] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
> [    0.324293] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
> [    0.324295] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
> [    0.324296] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
> [    0.324298] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
> [    0.324300] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.324378] system 00:01: [io  0x0400-0x047f] could not be reserved
> [    0.324380] system 00:01: [io  0x0500-0x057f] has been reserved
> [    0.324381] system 00:01: [io  0x0800-0x080f] has been reserved
> [    0.324383] system 00:01: [io  0x15e0-0x15ef] has been reserved
> [    0.324385] system 00:01: [io  0x1600-0x167f] has been reserved
> [    0.324386] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.324388] system 00:01: [mem 0xfffff000-0xffffffff] has been reserved
> [    0.324390] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.324392] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
> [    0.324393] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.324395] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.324397] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
> [    0.324399] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.324440] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.324447] pnp 00:03: [dma 4]
> [    0.324458] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.324473] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.324499] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.324522] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.324547] pnp 00:07: Plug and Play ACPI device, IDs LEN0071 PNP0303 (active)
> [    0.324569] pnp 00:08: Plug and Play ACPI device, IDs LEN0020 PNP0f13 (active)
> [    0.324604] pnp 00:09: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
> [    0.325019] pnp: PnP ACPI: found 10 devices
> [    0.325021] ACPI: bus type PNP unregistered
> [    0.331047] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.331052] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
> [    0.331059] pci 0000:00:1c.0:   bridge window [mem 0xf1d00000-0xf24fffff]
> [    0.331063] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
> [    0.331071] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.331078] pci 0000:00:1c.1:   bridge window [mem 0xf1c00000-0xf1cfffff]
> [    0.331090] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
> [    0.331093] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
> [    0.331099] pci 0000:00:1c.2:   bridge window [mem 0xf1400000-0xf1bfffff]
> [    0.331104] pci 0000:00:1c.2:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
> [    0.331113] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.331114] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.331116] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.331117] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff]
> [    0.331118] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
> [    0.331120] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
> [    0.331121] pci_bus 0000:02: resource 1 [mem 0xf1d00000-0xf24fffff]
> [    0.331122] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
> [    0.331124] pci_bus 0000:03: resource 1 [mem 0xf1c00000-0xf1cfffff]
> [    0.331125] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
> [    0.331127] pci_bus 0000:04: resource 1 [mem 0xf1400000-0xf1bfffff]
> [    0.331128] pci_bus 0000:04: resource 2 [mem 0xf0c00000-0xf13fffff 64bit pref]
> [    0.331180] NET: Registered protocol family 2
> [    0.331371] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.331567] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.331670] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.331688] TCP: reno registered
> [    0.331702] UDP hash table entries: 8192 (order: 6, 262144 bytes)
> [    0.331747] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
> [    0.331849] NET: Registered protocol family 1
> [    0.331860] pci 0000:00:02.0: Boot video device
> [    0.332445] PCI: CLS 64 bytes, default 64
> [    0.332483] Unpacking initramfs...
> [    0.538228] Freeing initrd memory: 14088K (ffff88003646c000 - ffff88003722e000)
> [    0.538237] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.538239] software IO TLB [mem 0xc941d000-0xcd41d000] (64MB) mapped at [ffff8800c941d000-ffff8800cd41cfff]
> [    0.538415] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x16
> [    0.538420] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x16
> [    0.538428] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x16
> [    0.538435] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x16
> [    0.538485] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    0.538707] audit: initializing netlink socket (disabled)
> [    0.538718] type=2000 audit(1400375135.440:1): initialized
> [    0.550056] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.550732] VFS: Disk quotas dquot_6.5.2
> [    0.550753] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.550813] msgmni has been set to 31514
> [    0.551059] alg: No test for stdrng (krng)
> [    0.551091] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    0.551126] io scheduler noop registered
> [    0.551127] io scheduler deadline registered
> [    0.551142] io scheduler cfq registered (default)
> [    0.551538] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.551548] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.551570] intel_idle: MWAIT substates: 0x21120
> [    0.551571] intel_idle: v0.4 model 0x3A
> [    0.551572] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    0.551670] GHES: HEST is not enabled!
> [    0.551710] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.572271] 0000:00:16.3: ttyS0 at I/O 0x50b0 (irq = 19, base_baud = 115200) is a 16550A
> [    0.572385] Linux agpgart interface v0.103
> [    0.572446] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    0.574267] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.574271] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.574356] mousedev: PS/2 mouse device common for all mice
> [    0.574394] rtc_cmos 00:06: RTC can wake from S4
> [    0.574526] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
> [    0.574562] rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    0.574570] Intel P-state driver initializing.
> [    0.574578] Intel pstate controlling: cpu 0
> [    0.574591] Intel pstate controlling: cpu 1
> [    0.574601] Intel pstate controlling: cpu 2
> [    0.574609] Intel pstate controlling: cpu 3
> [    0.574627] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
> [    0.574628] AMD IOMMUv2 functionality not available on this system
> [    0.574715] TCP: cubic registered
> [    0.574779] NET: Registered protocol family 10
> [    0.574928] mip6: Mobile IPv6
> [    0.574929] NET: Registered protocol family 17
> [    0.574931] mpls_gso: MPLS GSO support
> [    0.575125] registered taskstats version 1
> [    0.575946] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [    0.576065] rtc_cmos 00:06: setting system clock to 2014-05-18 01:05:36 UTC (1400375136)
> [    0.576098] PM: Hibernation image not present or could not be loaded.
> [    0.576577] Freeing unused kernel memory: 984K (ffffffff818af000 - ffffffff819a5000)
> [    0.576579] Write protecting the kernel read-only data: 8192k
> [    0.578821] Freeing unused kernel memory: 1324K (ffff8800014b5000 - ffff880001600000)
> [    0.579581] Freeing unused kernel memory: 428K (ffff880001795000 - ffff880001800000)
> [    0.588054] systemd-udevd[67]: starting version 204
> [    0.609858] thermal LNXTHERM:00: registered as thermal_zone0
> [    0.609861] ACPI: Thermal Zone [THM0] (59 C)
> [    0.610577] pps_core: LinuxPPS API ver. 1 registered
> [    0.610579] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    0.610776] PTP clock support registered
> [    0.611009] ACPI: bus type USB registered
> [    0.611025] usbcore: registered new interface driver usbfs
> [    0.611031] usbcore: registered new interface driver hub
> [    0.611211] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
> [    0.611213] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
> [    0.611362] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [    0.611389] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
> [    0.614478] sdhci: Secure Digital Host Controller Interface driver
> [    0.614481] sdhci: Copyright(c) Pierre Ossman
> [    0.614642] sdhci-pci 0000:02:00.0: SDHCI controller found [1180:e822] (rev 7)
> [    0.615256] usbcore: registered new device driver usb
> [    0.615360] mmc0: SDHCI controller on PCI [0000:02:00.0] using DMA
> [    0.615672] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.615801] ehci-pci: EHCI PCI platform driver
> [    0.622656] SCSI subsystem initialized
> [    0.623787] libata version 3.00 loaded.
> [    0.808170] e1000e 0000:00:19.0 eth0: registered PHC clock
> [    0.808172] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 3c:97:0e:70:23:9b
> [    0.808174] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
> [    0.808221] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF
> [    0.808388] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    0.808395] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
> [    0.808513] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
> [    0.808555] xhci_hcd 0000:00:14.0: irq 43 for MSI/MSI-X
> [    0.808668] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.808670] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.808672] usb usb1: Product: xHCI Host Controller
> [    0.808673] usb usb1: Manufacturer: Linux 3.13-1-amd64 xhci_hcd
> [    0.808675] usb usb1: SerialNumber: 0000:00:14.0
> [    0.808788] hub 1-0:1.0: USB hub found
> [    0.808799] hub 1-0:1.0: 4 ports detected
> [    0.809121] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    0.809125] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
> [    0.809213] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
> [    0.809214] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.809215] usb usb2: Product: xHCI Host Controller
> [    0.809216] usb usb2: Manufacturer: Linux 3.13-1-amd64 xhci_hcd
> [    0.809217] usb usb2: SerialNumber: 0000:00:14.0
> [    0.809295] hub 2-0:1.0: USB hub found
> [    0.809313] hub 2-0:1.0: 4 ports detected
> [    0.843536] ehci-pci 0000:00:1a.0: EHCI Host Controller
> [    0.843540] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 3
> [    0.843554] ehci-pci 0000:00:1a.0: debug port 2
> [    0.847464] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
> [    0.847469] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf253a000
> [    0.859504] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    0.859657] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.859660] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.859661] usb usb3: Product: EHCI Host Controller
> [    0.859662] usb usb3: Manufacturer: Linux 3.13-1-amd64 ehci_hcd
> [    0.859664] usb usb3: SerialNumber: 0000:00:1a.0
> [    0.859803] hub 3-0:1.0: USB hub found
> [    0.859810] hub 3-0:1.0: 3 ports detected
> [    0.860022] ehci-pci 0000:00:1d.0: EHCI Host Controller
> [    0.860026] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
> [    0.860040] ehci-pci 0000:00:1d.0: debug port 2
> [    0.863933] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
> [    0.863947] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf2539000
> [    0.875524] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    0.875582] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.875586] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.875590] usb usb4: Product: EHCI Host Controller
> [    0.875592] usb usb4: Manufacturer: Linux 3.13-1-amd64 ehci_hcd
> [    0.875595] usb usb4: SerialNumber: 0000:00:1d.0
> [    0.875834] hub 4-0:1.0: USB hub found
> [    0.875840] hub 4-0:1.0: 3 ports detected
> [    0.875935] ahci 0000:00:1f.2: version 3.0
> [    0.876045] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
> [    0.876074] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
> [    0.891577] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x13 impl SATA mode
> [    0.891584] ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio slum part ems sxs apst 
> [    0.907987] scsi0 : ahci
> [    0.908087] scsi1 : ahci
> [    0.908155] scsi2 : ahci
> [    0.908219] scsi3 : ahci
> [    0.908283] scsi4 : ahci
> [    0.908332] scsi5 : ahci
> [    0.908357] ata1: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538100 irq 44
> [    0.908359] ata2: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538180 irq 44
> [    0.908360] ata3: DUMMY
> [    0.908361] ata4: DUMMY
> [    0.908363] ata5: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538300 irq 44
> [    0.908363] ata6: DUMMY
> [    1.119858] usb 1-4: new high-speed USB device number 2 using xhci_hcd
> [    1.141293] usb 1-4: New USB device found, idVendor=0bdb, idProduct=1926
> [    1.141296] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    1.141298] usb 1-4: Product: H5321 gw
> [    1.141299] usb 1-4: Manufacturer: Lenovo
> [    1.141301] usb 1-4: SerialNumber: CD1EA50AF80E50M0
> [    1.227997] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.228985] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    1.228990] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    1.229962] ata1.00: ATA-8: HGST HTS725050A7E630, GH2ZB550, max UDMA/133
> [    1.229967] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    1.231047] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    1.231052] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    1.231986] ata1.00: configured for UDMA/133
> [    1.232154] scsi 0:0:0:0: Direct-Access     ATA      HGST HTS725050A7 GH2Z PQ: 0 ANSI: 5
> [    1.288113] usb 3-1: new high-speed USB device number 2 using ehci-pci
> [    1.421014] usb 3-1: New USB device found, idVendor=8087, idProduct=0024
> [    1.421019] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    1.421500] hub 3-1:1.0: USB hub found
> [    1.421698] hub 3-1:1.0: 6 ports detected
> [    1.536350] tsc: Refined TSC clocksource calibration: 2793.663 MHz
> [    1.536400] usb 4-1: new high-speed USB device number 2 using ehci-pci
> [    1.552389] ata2: SATA link down (SStatus 0 SControl 300)
> [    1.668969] usb 4-1: New USB device found, idVendor=8087, idProduct=0024
> [    1.668974] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    1.669257] hub 4-1:1.0: USB hub found
> [    1.669419] hub 4-1:1.0: 8 ports detected
> [    1.740986] usb 3-1.4: new full-speed USB device number 3 using ehci-pci
> [    1.839378] usb 3-1.4: New USB device found, idVendor=0a5c, idProduct=21e6
> [    1.839398] usb 3-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    1.839400] usb 3-1.4: Product: BCM20702A0
> [    1.839403] usb 3-1.4: Manufacturer: Broadcom Corp
> [    1.839405] usb 3-1.4: SerialNumber: 7CE9D3EA594F
> [    1.880804] ata5: SATA link down (SStatus 0 SControl 300)
> [    1.887675] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> [    1.887682] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [    1.887811] sd 0:0:0:0: [sda] Write Protect is off
> [    1.887816] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.887861] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.913031] usb 3-1.6: new high-speed USB device number 4 using ehci-pci
> [    1.954431]  sda: sda1 sda2
> [    1.955434] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.957311] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    2.013419] usb 3-1.6: New USB device found, idVendor=04f2, idProduct=b2ea
> [    2.013425] usb 3-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.013427] usb 3-1.6: Product: Integrated Camera
> [    2.013430] usb 3-1.6: Manufacturer: Chicony Electronics Co., Ltd.
> [    2.257200] raid6: sse2x1    6148 MB/s
> [    2.325281] raid6: sse2x2    9421 MB/s
> [    2.393368] raid6: sse2x4   13350 MB/s
> [    2.393369] raid6: using algorithm sse2x4 (13350 MB/s)
> [    2.393370] raid6: using ssse3x2 recovery algorithm
> [    2.393557] xor: automatically using best checksumming function:
> [    2.433412]    avx       : 26864.000 MB/sec
> [    2.435143] bio: create slab <bio-1> at 1
> [    2.435305] Btrfs loaded
> [    2.446675] btrfs: device fsid 3d64a40f-70bb-4d8e-b8b8-8491b0e48b87 devid 1 transid 39198 /dev/sda1
> [    2.448799] btrfs: device fsid 3d64a40f-70bb-4d8e-b8b8-8491b0e48b87 devid 1 transid 39198 /dev/disk/by-uuid/3d64a40f-70bb-4d8e-b8b8-8491b0e48b87
> [    2.449071] btrfs: disk space caching is enabled
> [    2.537901] Switched to clocksource tsc
> [    4.051737] random: nonblocking pool is initialized
> [    6.878902] systemd-udevd[410]: starting version 204
> [    8.839880] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
> [    8.888716] mei_me 0000:00:16.0: irq 45 for MSI/MSI-X
> [    8.917027] [drm] Initialized drm 1.1.0 20060810
> [    9.009941] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1 (20131115/utaddress-251)
> [    9.009947] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    9.009953] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20131115/utaddress-251)
> [    9.009955] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    9.009956] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20131115/utaddress-251)
> [    9.009958] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    9.009959] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [    9.120747] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
> [    9.120893] ACPI: Lid Switch [LID]
> [    9.120938] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
> [    9.120943] ACPI: Sleep Button [SLPB]
> [    9.120995] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
> [    9.120998] ACPI: Power Button [PWRF]
> [    9.136020] cfg80211: Calling CRDA to update world regulatory domain
> [    9.262099] ACPI: AC Adapter [AC] (on-line)
> [    9.346182] [drm] Memory usable by graphics device = 2048M
> [    9.386199] i915 0000:00:02.0: irq 46 for MSI/MSI-X
> [    9.386209] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    9.386210] [drm] Driver supports precise vblank timestamp query.
> [    9.386264] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    9.411136] Intel(R) Wireless WiFi driver for Linux, in-tree:
> [    9.411138] Copyright(c) 2003-2013 Intel Corporation
> [    9.411282] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
> [    9.411456] iwlwifi 0000:03:00.0: irq 47 for MSI/MSI-X
> [    9.482836] tpm_tis 00:09: 1.2 TPM (device-id 0x0, rev-id 78)
> [    9.489681] ACPI: Battery Slot [BAT0] (battery present)
> [    9.510221] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
> [    9.527649] fbcon: inteldrmfb (fb0) is primary device
> [    9.734948] iwlwifi 0000:03:00.0: firmware: direct-loading firmware iwlwifi-6000g2a-6.ucode
> [    9.735142] iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1 op_mode iwldvm
> [    9.766080] Non-volatile memory driver v1.3
> [    9.836541] thinkpad_acpi: ThinkPad ACPI Extras v0.25
> [    9.836541] thinkpad_acpi: http://ibm-acpi.sf.net/
> [    9.836542] thinkpad_acpi: ThinkPad BIOS G2ET91WW (2.51 ), EC unknown
> [    9.836542] thinkpad_acpi: Lenovo ThinkPad X230, model 2306CTO
> [    9.836884] thinkpad_acpi: Unsupported brightness interface, please contact ibm-acpi-devel@lists.sourceforge.net
> [    9.837008] thinkpad_acpi: radio switch found; radios are enabled
> [    9.837079] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
> [    9.837079] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
> [    9.838160] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
> [    9.838741] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
> [    9.838999] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
> [    9.841354] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input5
> [    9.917285] wmi: Mapper loaded
> [   10.025571] input: PC Speaker as /devices/platform/pcspkr/input/input6
> [   10.370193] Console: switching to colour frame buffer device 170x48
> [   10.373054] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [   10.373056] i915 0000:00:02.0: registered panic notifier
> [   10.442807] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
> [   10.442813] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
> [   10.442816] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> [   10.442820] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, REV=0xB0
> [   10.442970] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [   10.443094] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> [   10.450249] iTCO_vendor_support: vendor-support=0
> [   10.477845] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
> [   10.477894] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
> [   10.478008] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [   10.484783] acpi device:01: registered as cooling_device4
> [   10.484853] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input8
> [   10.484958] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [   10.485125] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
> [   10.587008] cdc_wdm 1-4:1.5: cdc-wdm0: USB WDM device
> [   10.587043] cdc_wdm 1-4:1.8: cdc-wdm1: USB WDM device
> [   10.587057] usbcore: registered new interface driver cdc_wdm
> [   10.588714] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> [   10.632687] btrfs: device fsid 3d64a40f-70bb-4d8e-b8b8-8491b0e48b87 devid 1 transid 39198 /dev/sda1
> [   10.676491] cdc_acm 1-4:1.1: ttyACM0: USB ACM device
> [   10.678334] cdc_acm 1-4:1.3: ttyACM1: USB ACM device
> [   10.686458] cdc_acm 1-4:1.9: ttyACM2: USB ACM device
> [   10.694389] usbcore: registered new interface driver cdc_acm
> [   10.694392] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
> [   10.711660] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
> [   10.828208] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input16
> [   10.828331] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input15
> [   10.828405] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
> [   10.828467] input: HDA Intel PCH Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
> [   10.828526] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
> [   10.828585] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
> [   10.828642] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> [   10.841380] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
> [   10.844222] alg: No test for crc32 (crc32-pclmul)
> [   10.911569] media: Linux media interface: v0.10
> [   10.924247] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
> [   11.011571] Linux video capture interface: v2.00
> [   11.047452] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b2ea)
> [   11.049597] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.6/3-1.6:1.0/input/input17
> [   11.049670] usbcore: registered new interface driver uvcvideo
> [   11.049671] USB Video Class driver (1.1.1)
> [   11.109023] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd002a3/0x940300/0x123800, board id: 1611, fw id: 1099905
> [   11.109035] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
> [   11.127048] cdc_ncm 1-4:1.6: MAC-Address: 02:15:e0:ec:01:00
> [   11.127193] cdc_ncm 1-4:1.6 wwan0: register 'cdc_ncm' at usb-0000:00:14.0-4, Mobile Broadband Network Device, 02:15:e0:ec:01:00
> [   11.127214] usbcore: registered new interface driver cdc_ncm
> [   11.133101] usbcore: registered new interface driver cdc_mbim
> [   11.144620] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
> [   11.188097] btrfs: device fsid 3d64a40f-70bb-4d8e-b8b8-8491b0e48b87 devid 1 transid 39198 /dev/sda1
> [   11.323218] Bluetooth: Core ver 2.17
> [   11.323236] NET: Registered protocol family 31
> [   11.323237] Bluetooth: HCI device and connection manager initialized
> [   11.323244] Bluetooth: HCI socket layer initialized
> [   11.323245] Bluetooth: L2CAP socket layer initialized
> [   11.323251] Bluetooth: SCO socket layer initialized
> [   11.376680] usbcore: registered new interface driver btusb
> [   12.503535] Adding 4200992k swap on /dev/sda2.  Priority:-1 extents:1 across:4200992k 
> [   12.575263] btrfs: use lzo compression
> [   12.575266] btrfs: disk space caching is enabled
> [   13.164944] loop: module loaded
> [   13.270612] fuse init (API version 7.22)
> [   13.392930] btrfs: device fsid 3d64a40f-70bb-4d8e-b8b8-8491b0e48b87 devid 1 transid 39198 /dev/sda1
> [   13.431578] btrfs: device fsid 3d64a40f-70bb-4d8e-b8b8-8491b0e48b87 devid 1 transid 39198 /dev/sda1
> [   13.648040] btrfs: device fsid 3d64a40f-70bb-4d8e-b8b8-8491b0e48b87 devid 1 transid 39198 /dev/sda1
> [   13.754744] btrfs: device fsid 3d64a40f-70bb-4d8e-b8b8-8491b0e48b87 devid 1 transid 39198 /dev/sda1
> [   14.010029] psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
> [   15.240512] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [   15.241655] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [   15.309713] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
> [   15.508913] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input18
> [   15.511517] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> [   15.518387] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [   15.609890] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   16.156699] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
> [   16.258729] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
> [   16.258978] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   18.956161] wlan0: authenticate with 2c:b0:5d:a6:7d:2e
> [   18.961759] wlan0: send auth to 2c:b0:5d:a6:7d:2e (try 1/3)
> [   18.963919] wlan0: authenticated
> [   18.966013] wlan0: associate with 2c:b0:5d:a6:7d:2e (try 1/3)
> [   18.969667] wlan0: RX AssocResp from 2c:b0:5d:a6:7d:2e (capab=0x411 status=0 aid=2)
> [   18.988891] wlan0: associated
> [   18.988955] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   21.603298] RPC: Registered named UNIX socket transport module.
> [   21.603302] RPC: Registered udp transport module.
> [   21.603304] RPC: Registered tcp transport module.
> [   21.603305] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [   21.637697] FS-Cache: Loaded
> [   21.717526] FS-Cache: Netfs 'nfs' registered for caching
> [   21.761694] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [   23.185458] thinkpad_ec: thinkpad_ec_request_row: arg0 rejected: (0x01:0x00)->0x00
> [   23.185462] thinkpad_ec: thinkpad_ec_read_row: failed requesting row: (0x01:0x00)->0xfffffffb
> [   23.186404] thinkpad_ec: initial ec test failed
> [   23.986280] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input19
> [   28.977176] Bridge firewalling registered
> [   28.977734] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready
> [   29.210080] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   29.334977] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [   41.817000] systemd-logind[3212]: New seat seat0.
> [   41.834248] systemd-logind[3212]: Watching system buttons on /dev/input/event3 (Power Button)
> [   41.834359] systemd-logind[3212]: Watching system buttons on /dev/input/event6 (Video Bus)
> [   41.834542] systemd-logind[3212]: Watching system buttons on /dev/input/event1 (Lid Switch)
> [   41.834621] systemd-logind[3212]: Watching system buttons on /dev/input/event2 (Sleep Button)
> [   41.834680] systemd-logind[3212]: Watching system buttons on /dev/input/event4 (ThinkPad Extra Buttons)
> [   41.835393] systemd-logind[3212]: New session 1 of user csirac.
> [   41.835501] systemd-logind[3212]: Linked /tmp/.X11-unix/X0 to /run/user/1000/X11-display.
> [ 1262.367602] usb 1-1: new high-speed USB device number 3 using xhci_hcd
> [ 1262.384794] usb 1-1: New USB device found, idVendor=152d, idProduct=2338
> [ 1262.384800] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=5
> [ 1262.384802] usb 1-1: Product: USB to ATA/ATAPI bridge
> [ 1262.384805] usb 1-1: Manufacturer: JMicron
> [ 1262.384807] usb 1-1: SerialNumber: 11218EAD1161
> [ 1262.436465] usb-storage 1-1:1.0: USB Mass Storage device detected
> [ 1262.436558] scsi6 : usb-storage 1-1:1.0
> [ 1262.436640] usbcore: registered new interface driver usb-storage
> [ 1263.437562] scsi 6:0:0:0: Direct-Access     Samsung  SSD 840 PRO Seri      PQ: 0 ANSI: 2 CCS
> [ 1263.438017] sd 6:0:0:0: Attached scsi generic sg1 type 0
> [ 1263.438642] sd 6:0:0:0: [sdb] 1000215216 512-byte logical blocks: (512 GB/476 GiB)
> [ 1263.438958] sd 6:0:0:0: [sdb] Write Protect is off
> [ 1263.438964] sd 6:0:0:0: [sdb] Mode Sense: 28 00 00 00
> [ 1263.439320] sd 6:0:0:0: [sdb] No Caching mode page found
> [ 1263.439324] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [ 1263.440458] sd 6:0:0:0: [sdb] No Caching mode page found
> [ 1263.440463] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [ 1263.446242]  sdb: sdb1 sdb2 sdb3
> [ 1263.447312] sd 6:0:0:0: [sdb] No Caching mode page found
> [ 1263.447316] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [ 1263.447318] sd 6:0:0:0: [sdb] Attached SCSI disk
> [ 1263.555672] btrfs: device label weatherwax 0 devid 1 transid 504075 /dev/sdb3
> [ 1263.558031] btrfs: device label weatherwax 0 devid 1 transid 504075 /dev/sdb3
