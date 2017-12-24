Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:49069 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbdLXMbm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Dec 2017 07:31:42 -0500
Received: from mac02.local (d.probackup.nl [81.28.80.241])
        (Authenticated sender: linux-ide@crashplan.pro)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 88148FB88B
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Dec 2017 13:31:40 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Ceriel Jacobs <linux-ide@crashplan.pro>
Subject: Project idea: reduce boot time/RAM usage: option to disable/delay
 raid6_pq and xor kmod
Message-ID: <6f082a1d-ed15-2583-fabf-9aa7c80baef0@crashplan.pro>
Date: Sun, 24 Dec 2017 13:31:40 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

dmesg snippet (on Intel E3815 CPU):
[    0.499794] efivars: duplicate variable: Events-...
[    0.560048] raid6: sse2x1   gen()   932 MB/s
[    0.616732] raid6: sse2x1   xor()  1488 MB/s
[    0.673362] raid6: sse2x2   gen()  1665 MB/s
[    0.730014] raid6: sse2x2   xor()  1777 MB/s
[    0.786688] raid6: sse2x4   gen()  2635 MB/s
[    0.843352] raid6: sse2x4   xor()  1732 MB/s
[    0.843355] raid6: using algorithm sse2x4 gen() 2635 MB/s
[    0.843356] raid6: .... xor() 1732 MB/s, rmw enabled
[    0.843358] raid6: using ssse3x2 recovery algorithm
[    0.846998] xor: measuring software checksum speed
[    0.880025]    prefetch64-sse:  4605.600 MB/sec
[    0.913372]    generic_sse:  4176.000 MB/sec
[    0.913375] xor: using function: prefetch64-sse (4605.600 MB/sec)
[    0.952233] Btrfs loaded, crc32c=crc32c-intel
[    0.957669] SCSI subsystem initialized

# lsmod | grep btrfs
btrfs                1323008  3
xor                    24576  1 btrfs
zstd_decompress        94208  1 btrfs
zstd_compress         188416  1 btrfs
raid6_pq              122880  1 btrfs

# modinfo btrfs | grep 'filename:\|depends:'
filename:       /lib/modules/4.14.8-1-ARCH/kernel/fs/btrfs/btrfs.ko.xz
depends:        zstd_compress,zstd_decompress,raid6_pq,xor

---
This system doesn't use raid5 neither raid6 nor any RAID at all.

The wish is that btrfs can be loaded at run-time with/without loading 
kernel modules raid6_pq neither xor.

Saving:
1. ± 0.4 seconds of boot time (10% of boot until root)
2. ± 150k of RAM
3. ± 75k of disk space

For other cases, I can imagine a root system that doesn't need btrfs 
raid, and user data volumes that do use raid6_pq. In such delay cases it 
is welcome that btrfs-noraid can be loaded first, and the raid modules 
and benchmarking during/after init.

New kernel command-line parameters?
a.) disable, like:
     - btrfs=noraid6_pq
     - btrfs=noraid (=no xor at all)
b.) delay raid6_pq and xor module loading, for cases where root mount 
doesn't need raid6_pq and/or xor.

A new entry at https://btrfs.wiki.kernel.org/index.php/Project_ideas is 
welcome.
