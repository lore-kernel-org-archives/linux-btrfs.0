Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59279 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754597AbeGJB1f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2018 21:27:35 -0400
Subject: Re: Fwd: Re: So, does btrfs check lowmem take days? weeks?
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>, Marc MERLIN <marc@merlins.org>
References: <20180709174818.wq2d4awmgasxgwad@merlins.org>
 <ca6355da-86fc-6007-44ff-171ddb692c6f@cn.fujitsu.com>
Message-ID: <c8c68d2c-99ff-8cb3-56f6-918d15ddf42c@cn.fujitsu.com>
Date: Tue, 10 Jul 2018 09:33:58 +0800
MIME-Version: 1.0
In-Reply-To: <ca6355da-86fc-6007-44ff-171ddb692c6f@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Forgot to CC Marc.

On 07/10/2018 09:33 AM, Su Yue wrote:
> [FWD to linux-btrfs]
> Thanks to Marc's patient of running and tests btrfsck lowmem mode
> in recent days.
> The FS has a large extent tree but luckily few are corrupted, they are
> all fixed by special version. Reloc trees were cleaned too.
> So the FS can be mounted with RW.
> 
> However, the remaining errors of extent data in file trees are 
> unresloved, they are all about holes.
> Since I'm not familiar with kernel code, not sure how serious those 
> errors are and what result could be during write/read those wrong
> items.
> 
> Marc also has some questions in the part forwarded, replies are
> always welcome.
> 
> Error messages are showed in the last.
> 
> 
> -------- Forwarded Message --------
> Subject: Re: So, does btrfs check lowmem take days? weeks?
> Date: Mon, 9 Jul 2018 10:48:18 -0700
> From: Marc MERLIN <marc@merlins.org>
> To: Su Yue <Damenly_Su@gmx.com>
> CC: quwenruo.btrfs@gmx.com, Su Yue <suy.fnst@cn.fujitsu.com>
> 
> Success!
> Well done Su, this is a huge improvement to the lowmem code. It went 
> from days to less than 3 hours.
> 
> I'll paste the logs below.
> 
> Questions:
> 1) I assume I first need to delete a lot of snapshots. What is the limit 
> in your opinion?
> 100? 150? other?
> 
> 2) my filesystem is somewhat misbalanced. Which balance options do you 
> think are safe to use?
> 
> 3) Should I start a scrub now (takes about 1 day) or anything else to
> check that the filesystem is hopefully not damaged anymore?
> 
> 4) should btrfs check reset the corrupt counter?
> bdev /dev/mapper/dshelf2 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
> for now, should I reset it manually?
> 
> Thanks,
> Marc
> 
> 
> gargamel:/var/local/src/btrfs-progs.sy# ./btrfsck --mode=lowmem -q 
> --repair /dev/mapper/dshelf2
> enabling repair mode
> WARNING: low-memory mode repair support is only partial
> Checking filesystem on /dev/mapper/dshelf2
> UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
> Created new chunk [18460145811456 1073741824]
> Add one extent data backref [84302495744 69632]
> Add one extent data backref [84302495744 69632]
> Add one extent data backref [125712527360 12214272]
> Add one extent data backref [125730848768 5111808]
> Add one extent data backref [125730848768 5111808]
> Add one extent data backref [125736914944 6037504]
> Add one extent data backref [125736914944 6037504]
> Add one extent data backref [129952120832 20242432]
> Add one extent data backref [129952120832 20242432]
> Add one extent data backref [134925357056 11829248]
> Add one extent data backref [134925357056 11829248]
> Add one extent data backref [147895111680 12345344]
> Add one extent data backref [147895111680 12345344]
> Add one extent data backref [150850146304 17522688]
> Add one extent data backref [156909494272 55320576]
> Add one extent data backref [156909494272 55320576]
> good luck!
> found 0 bytes used, no error found
> total csum bytes: 0
> total tree bytes: 0
> total fs tree bytes: 0
> total extent tree bytes: 0
> btree space waste bytes: 0
> file data blocks allocated: 0
>   referenced 0
> gargamel:/var/local/src/btrfs-progs.sy# ./btrfsck --mode=lowmem -q 
> /dev/mapper/dshelf2
> Checking filesystem on /dev/mapper/dshelf2
> UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
> good luck!
> found 251650048 bytes used, no error found
> total csum bytes: 0
> total tree bytes: 0
> total fs tree bytes: 0
> total extent tree bytes: 0
> btree space waste bytes: 0
> file data blocks allocated: 0
>   referenced 0
> gargamel:/var/local/src/btrfs-progs.sy# ./btrfsck -c /dev/mapper/dshelf2
> Checking filesystem on /dev/mapper/dshelf2
> UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
> found 0 bytes used, no error found
> total csum bytes: 0
> total tree bytes: 0
> total fs tree bytes: 0
> total extent tree bytes: 0
> btree space waste bytes: 0
> file data blocks allocated: 0
>   referenced 0
> gargamel:/var/local/src/btrfs-progs.sy# mount /dev/mapper/dshelf2 /mnt/mnt
> [671283.314558] BTRFS info (device dm-2): disk space caching is enabled
> [671283.334226] BTRFS info (device dm-2): has skinny extents
> [671285.191740] BTRFS info (device dm-2): bdev /dev/mapper/dshelf2 errs: 
> wr 0, rd 0, flush 0, corrupt 2, gen 0
> [671395.371313] BTRFS info (device dm-2): enabling ssd optimizations
> [671400.884013] BTRFS info (device dm-2): checking UUID tree
> (hung about 2-3mn but worked eventually)
> 
> gargamel:/mnt/mnt# btrfs fi show .
> Label: 'dshelf2'  uuid: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
>          Total devices 1 FS bytes used 12.59TiB
>          devid    1 size 14.55TiB used 13.81TiB path /dev/mapper/dshelf2
> 
> gargamel:/mnt/mnt# btrfs fi df .
> Data, single: total=13.57TiB, used=12.48TiB
> System, DUP: total=32.00MiB, used=1.55MiB
> Metadata, DUP: total=124.50GiB, used=116.92GiB
> Metadata, single: total=216.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=42.62MiB
> 
> gargamel:/mnt/mnt# btrfs subvolume list . | wc -l
> 270
> 
> 


