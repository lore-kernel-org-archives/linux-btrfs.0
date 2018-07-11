Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:21469 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732275AbeGKAtQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 20:49:16 -0400
Subject: Re: btrfs check lowmem, take 2
To: Marc MERLIN <marc@merlins.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        <linux-btrfs@vger.kernel.org>
CC: Su Yue <Damenly_Su@gmx.com>
References: <20180710180915.onnxuak7vb7uywyn@merlins.org>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <9afce26c-0a3f-3389-ba0f-597b26a8cd7e@cn.fujitsu.com>
Date: Wed, 11 Jul 2018 08:53:58 +0800
MIME-Version: 1.0
In-Reply-To: <20180710180915.onnxuak7vb7uywyn@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/11/2018 02:09 AM, Marc MERLIN wrote:
> Thanks to Su and Qu, I was able to get my filesystem to a point that
> it's mountable.
> I then deleted loads of snapshots and I'm down to 26.
> 
> IT now looks like this:
> gargamel:~# btrfs fi show /mnt/mnt
> Label: 'dshelf2'  uuid: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
> 	Total devices 1 FS bytes used 12.30TiB
> 	devid    1 size 14.55TiB used 13.81TiB path /dev/mapper/dshelf2
> 
> gargamel:~# btrfs fi df /mnt/mnt
> Data, single: total=13.57TiB, used=12.19TiB
> System, DUP: total=32.00MiB, used=1.55MiB
> Metadata, DUP: total=124.50GiB, used=115.62GiB
> Metadata, single: total=216.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> 
> Problems
> 1) btrfs check --repair _still_ takes all 32GB of RAM and crashes the
> server, despite my deleting lots of snapshots.
> Is it because I have too many files then?
> 
Yes. Original check first gather all infomation about extent tree and
your files in RAM, then process one by one.
But deleting still counts, it does speed lowmem check up.

> 2) I tried Su's master git branch for btrfs-progs to try and see how 
Oh..No... My master branch is still 4.14. The true mater branch is
David's here:
https://github.com/kdave/btrfs-progs
But the master branch has a known bug which I fixed yesterday, please 
see the mail.

Thanks,
Su
> normal check would go, and I'm stuck on this:
> gargamel:/var/local/src/btrfs-progs.sy# time ./btrfsck --mode=lowmem --repair /dev/mapper/dshelf2
> enabling repair mode
> WARNING: low-memory mode repair support is only partial
> Checking filesystem on /dev/mapper/dshelf2
> UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
> root 18446744073709551607 has a root item with a more recent gen (143376) compared to the found root node (139061)
> ERROR: failed to repair root items: Invalid argument

Thanks to the failure, the old version didn't do any things wrong.

> 
> real	75m8.046s
> user	0m14.591s
> sys	0m52.431s
> 
> I understand what the message means, I just need to switch to the newer root
> but honestly I'm not quite sure how to do this from the btrfs-check man page.
> 
> This didn't work:
> time ./btrfsck --mode=lowmem --repair --chunk-root=18446744073709551607  /dev/mapper/dshelf2
> enabling repair mode
> WARNING: low-memory mode repair support is only partial
> WARNING: chunk_root_bytenr 18446744073709551607 is unaligned to 4096, ignore it
> 
> How do I address the error above?

> Thanks
> Marc
> 


