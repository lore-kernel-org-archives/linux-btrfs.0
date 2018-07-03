Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:33727 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752251AbeGCLaC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 07:30:02 -0400
Subject: Re: how to best segment a big block device in resizeable btrfs
 filesystems?
To: Paul Jones <paul@pauljones.id.au>, Marc MERLIN <marc@merlins.org>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
 <20180702140527.wfbq5jenm67fvvjg@merlins.org>
 <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
 <20180702151853.mwlrinipbihq46zu@merlins.org>
 <ee8ff481-0aac-54ec-b496-f28feab2227b@gmx.com>
 <20180703041550.GH5567@merlins.org>
 <MEXPR01MB1208F79F27CD83BBAB2AE3D29E420@MEXPR01MB1208.ausprd01.prod.outlook.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <22beb493-0fd3-3bd1-fe1d-fddd6885f3df@gmx.com>
Date: Tue, 3 Jul 2018 19:29:48 +0800
MIME-Version: 1.0
In-Reply-To: <MEXPR01MB1208F79F27CD83BBAB2AE3D29E420@MEXPR01MB1208.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月03日 17:55, Paul Jones wrote:
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org <linux-btrfs-
>> owner@vger.kernel.org> On Behalf Of Marc MERLIN
>> Sent: Tuesday, 3 July 2018 2:16 PM
>> To: Qu Wenruo <quwenruo.btrfs@gmx.com>
>> Cc: Su Yue <suy.fnst@cn.fujitsu.com>; linux-btrfs@vger.kernel.org
>> Subject: Re: how to best segment a big block device in resizeable btrfs
>> filesystems?
>>
>> On Tue, Jul 03, 2018 at 09:37:47AM +0800, Qu Wenruo wrote:
>>>> If I do this, I would have
>>>> software raid 5 < dmcrypt < bcache < lvm < btrfs That's a lot of
>>>> layers, and that's also starting to make me nervous :)
>>>
>>> If you could keep the number of snapshots to minimal (less than 10)
>>> for each btrfs (and the number of send source is less than 5), one big
>>> btrfs may work in that case.
>>
>> Well, we kind of discussed this already. If btrfs falls over if you reach
>> 100 snapshots or so, and it sure seems to in my case, I won't be much better
>> off.
>> Having btrfs check --repair fail because 32GB of RAM is not enough, and it's
>> unable to use swap, is a big deal in my case. You also confirmed that btrfs
>> check lowmem does not scale to filesystems like mine, so this translates into
>> "if regular btrfs check repair can't fit in 32GB, I am completely out of luck if
>> anything happens to the filesystem"
> 
> Just out of curiosity I had a look at my backup filesystem.
> vm-server /media/backup # btrfs fi us /media/backup/
> Overall:
>     Device size:                   5.46TiB
>     Device allocated:              3.42TiB
>     Device unallocated:            2.04TiB
>     Device missing:                  0.00B
>     Used:                          1.80TiB
>     Free (estimated):              1.83TiB      (min: 1.83TiB)
>     Data ratio:                       2.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,RAID1: Size:1.69TiB, Used:906.26GiB

It doesn't affect how fast check run at all.
Unless --check-data-csum is specified.

And even --check-data-csum is specified, most read will still be
sequential, and deduped/reflink won't affect the csum verification speed.

>    /dev/mapper/a-backup--a         1.69TiB
>    /dev/mapper/b-backup--b         1.69TiB
> 
> Metadata,RAID1: Size:19.00GiB, Used:16.90GiB

This is the main factor contributing to btrfs check time.
Just consider it as the minimal amount of data btrfs check needs to read.

>    /dev/mapper/a-backup--a        19.00GiB
>    /dev/mapper/b-backup--b        19.00GiB
> 
> System,RAID1: Size:64.00MiB, Used:336.00KiB
>    /dev/mapper/a-backup--a        64.00MiB
>    /dev/mapper/b-backup--b        64.00MiB
> 
> Unallocated:
>    /dev/mapper/a-backup--a         1.02TiB
>    /dev/mapper/b-backup--b         1.02TiB
> 
> compress=zstd,space_cache=v2
> 202 snapshots, heavily de-duplicated
> 551G / 361,000 files in latest snapshot

No wonder it's so slow for lowmem mode.

> 
> Btrfs check normal mode took 12 mins and 11.5G ram
> Lowmem mode I stopped after 4 hours, max memory usage was around 3.9G

For lowmem, btrfs check will use 25% of your total memory as cache to
speed up it a little. (but as you can see, it's still slow)
Maybe we could add some option to modify how many bytes we could use for
lowmem mode.

Thanks,
Qu

> 
