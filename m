Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:63354 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751260AbcILVct (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 17:32:49 -0400
Received: from sandl.hnstr58.local ([88.67.15.65]) by smtp.web.de (mrweb101)
 with ESMTPSA (Nemesis) id 0Lky6L-1b97d51Og1-00amtr for
 <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 23:32:46 +0200
From: Heinz Werner Kramski-Grote <kramski@web.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Unable to repair "bad key order": Cyclic bad block flip-flop
Date: Mon, 12 Sep 2016 23:32:45 +0200
Message-ID: <43346744.qsAlqUvZgk@sandl.hnstr58.local>
In-Reply-To: <4818221.8fBhXcTYy5@sandl.hnstr58.local>
References: <4818221.8fBhXcTYy5@sandl.hnstr58.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 12. September 2016, 23:27:28 CEST schrieb Heinz Werner Kramski-
Grote:
> Due to bad RAM (now fixed), my (single disk) root partition got corrupted
> and no longer mounts with "corrupt leaf, bad key order":
> 
>     root@archiso ~ # mount /dev/sdh2 /mnt
>     mount: wrong fs type, bad option, bad superblock on /dev/sdh2,
>         missing codepage or helper program, or other error
> 
>         In some cases useful info is found in syslog - try
>         dmesg | tail or so.
> 
>     root@archiso ~ # dmesg | grep -i btrfs
>     [    8.513028] Btrfs loaded, crc32c=crc32c-generic
>     [    8.513033] BTRFS: selftest: sectorsize: 4096  nodesize: 4096
>     [    8.513035] BTRFS: selftest: sectorsize: 4096  nodesize: 8192
>     [    8.513037] BTRFS: selftest: sectorsize: 4096  nodesize: 16384
>     [    8.513039] BTRFS: selftest: sectorsize: 4096  nodesize: 32768
>     [    8.513041] BTRFS: selftest: sectorsize: 4096  nodesize: 65536
>     [    8.514927] BTRFS: device label btrfs devid 1 transid 36706 /dev/sdh2
> [    8.515047] BTRFS: device label data01 devid 1 transid 645 /dev/sdg1 [ 
> 546.218691] BTRFS info (device sdh2): disk space caching is enabled [ 
> 546.218697] BTRFS info (device sdh2): has skinny extents
>     [  546.225228] BTRFS critical (device sdh2): corrupt leaf, bad key
> order: block=75182981120,root=1, slot=0
>     [  546.225303] BTRFS error (device sdh2): failed to recover balance: -5
>     [  546.253399] BTRFS: open_ctree failed
> 
> Trying to repair the FS gets into a loop of two alternating bad blocks but
> never succeeds:
> 
>     root@archiso ~ # btrfs check --repair /dev/sdh2
>     enabling repair mode
>     Checking filesystem on /dev/sdh2
>     UUID: e961bc76-09bb-4616-9263-dab61b8d0ef6
>     checking extents
>     bad key ordering 0 1
>     bad block 75182981120
>     Errors found in extent allocation tree or chunk allocation
>     bad key ordering 0 1
> 
>     root@archiso ~ # btrfs check --repair /dev/sdh2
>     enabling repair mode
>     Checking filesystem on /dev/sdh2
>     UUID: e961bc76-09bb-4616-9263-dab61b8d0ef6
>     checking extents
>     bad key ordering 0 1
>     bad block 75183144960
>     Errors found in extent allocation tree or chunk allocation
>     bad key ordering 0 1
> 
>     root@archiso ~ # btrfs check --repair /dev/sdh2
>     enabling repair mode
>     Checking filesystem on /dev/sdh2
>     UUID: e961bc76-09bb-4616-9263-dab61b8d0ef6
>     checking extents
>     bad key ordering 0 1
>     bad block 75182981120
>     Errors found in extent allocation tree or chunk allocation
>     bad key ordering 0 1
> 
>     root@archiso ~ # btrfs check --repair /dev/sdh2
>     enabling repair mode
>     Checking filesystem on /dev/sdh2
>     UUID: e961bc76-09bb-4616-9263-dab61b8d0ef6
>     checking extents
>     bad key ordering 0 1
>     bad block 75183144960
>     Errors found in extent allocation tree or chunk allocation
>     bad key ordering 0 1
> 
>     [etc...]
> 
> According to smartctl, the disk itself (a quite new Samsung SSD) is healthy.
> 
> This is not a critical machine, but I would prefer to solve this issue over
> a new install. (I'm quite new to btrfs, though)
> 
> TIA
>    Heinz

Sorry, forgot system info:

root@archiso ~ # uname -a
Linux archiso 4.7.2-1-ARCH #1 SMP PREEMPT Sat Aug 20 23:02:56 CEST 2016 x86_64 
GNU/Linux

root@archiso ~ # btrfs --version
btrfs-progs v4.7

root@archiso ~ # btrfs fi show

Label: 'data01'  uuid: 8c7e958c-5462-44a8-bfe2-f55ee3a01c2f
        Total devices 1 FS bytes used 168.57GiB
        devid    1 size 1.82TiB used 171.04GiB path /dev/sdg1

Label: 'btrfs'  uuid: e961bc76-09bb-4616-9263-dab61b8d0ef6
        Total devices 1 FS bytes used 111.63GiB
        devid    1 size 457.76GiB used 121.02GiB path /dev/sdh2

Heinz
