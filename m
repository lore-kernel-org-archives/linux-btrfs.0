Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34972 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbbIWOj2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 10:39:28 -0400
Received: by oiww128 with SMTP id w128so24790812oiw.2
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 07:39:27 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 23 Sep 2015 16:39:27 +0200
Message-ID: <CAMH1C+r4yYU8hYfcZpFRyN1UWY8OPTs5Md7MdE=bm2RW9udREQ@mail.gmail.com>
Subject: Btrfs check dont repair
From: =?UTF-8?B?VmFja8OhxZkgRnJhbnRpxaFlaw==?= <vackarf@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

i have problem with my btrfs, can you help me, please? Its on my
notebook. Sometimes it exhausted battery during sleep and died. But
everytime FS was ok. But ones mount fail.

Do you have any idea how repair it?

Sorry for my english. :)

Frantisek Vackar
========================================
[root@rak ~]# btrfs check --repair /dev/sdb2
enabling repair mode
Checking filesystem on /dev/sdb2
UUID: 754a3186-c0ae-4680-ab28-864c8bdad8b5
checking extents
bad key ordering 0 1
bad block 3242450944
Errors found in extent allocation tree or chunk allocation
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
bad key ordering 0 1
Trying to rebuild inode:705555
root 5 inode 705555 errors 2001, no inode item, link count wrong
        unresolved ref dir 403566 index 0 namelen 10 name .directory
filetype 1 errors 6, no dir index, no inode ref
Trying to rebuild inode:705569
root 5 inode 705569 errors 2001, no inode item, link count wrong
        unresolved ref dir 339745 index 0 namelen 18 name
15-03-20-Botanicka filetype 2 errors 6, no dir index, no inode ref
=====MANY SIMILAR LINES=====
Trying to rebuild inode:718060
root 5 inode 718060 errors 2001, no inode item, link count wrong
        unresolved ref dir 430527 index 0 namelen 10 name Win 7.vbox
filetype 1 errors 6, no dir index, no inode ref
found 1350650234080 bytes used err is 1
total csum bytes: 0
total tree bytes: 466538496
total fs tree bytes: 17154048
total extent tree bytes: 448659456
btree space waste bytes: 94077759
file data blocks allocated: 3997077504
 referenced 3996086272
btrfs-progs v4.1.2

[root@rak ~]# mount /mnt/hdd-root/
mount: wrong fs type, bad option, bad superblock on /dev/sdb2,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

[root@rak ~]# dmesg | tail
[ 1434.004203] ath5k: ath5k_hw_get_isr: ISR: 0x00000080 IMR: 0x00000000
[ 1674.004209] ath5k: ath5k_hw_get_isr: ISR: 0x00000080 IMR: 0x00000000
[ 2154.007675] ath5k: ath5k_hw_get_isr: ISR: 0x00000080 IMR: 0x00000000
[ 4074.005033] ath5k: ath5k_hw_get_isr: ISR: 0x00000080 IMR: 0x00000000
[ 4096.970037] BTRFS info (device sdb2): disk space caching is enabled
[ 4108.444472] BTRFS critical (device sdb2): corrupt leaf, bad key
order: block=3242455040,root=1, slot=0
[ 4108.444649] BTRFS critical (device sdb2): corrupt leaf, bad key
order: block=3242455040,root=1, slot=0
[ 4108.444681] BTRFS error (device sdb2): Error removing orphan entry,
stopping orphan cleanup
[ 4108.444684] BTRFS error (device sdb2): could not do orphan cleanup -22
[ 4111.047323] BTRFS: open_ctree failed

[root@rak ~]# uname -a
Linux rak 4.1.2-2-ARCH #1 SMP PREEMPT Wed Jul 15 08:30:32 UTC 2015
x86_64 GNU/Linux

[root@rak ~]# btrfs fi show /dev/sdb2
Label: 'data'  uuid: 754a3186-c0ae-4680-ab28-864c8bdad8b5
        Total devices 1 FS bytes used 1.23TiB
        devid    1 size 1.72TiB used 1.24TiB path /dev/sdb2

btrfs-progs v4.2

[root@rak ~]# btrfs --version
btrfs-progs v4.2

[root@rak ~]#   btrfs fi show
Label: 'data'  uuid: 754a3186-c0ae-4680-ab28-864c8bdad8b5
        Total devices 1 FS bytes used 1.23TiB
        devid    1 size 1.72TiB used 1.24TiB path /dev/sdb2

btrfs-progs v4.2
