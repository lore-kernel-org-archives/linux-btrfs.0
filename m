Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17471 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752704AbdFVEJA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Jun 2017 00:09:00 -0400
Subject: Re: How to fix errors that check --mode lomem finds, but --mode
 normal doesn't?
To: Marc MERLIN <marc@merlins.org>
CC: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20170620143916.GA22987@merlins.org>
 <20170620152354.GD7140@carfax.org.uk> <20170620152648.GB22987@merlins.org>
 <20170620153601.GE7140@carfax.org.uk> <20170620154429.GC22987@merlins.org>
 <20170620231202.GB5303@merlins.org>
 <CAJCQCtQMWKJwWjeM4zEb-W7-tjsZyfCo37YyT2xYi0fNTEzcUQ@mail.gmail.com>
 <20170621034352.GE5303@merlins.org> <20170621151339.GK5303@merlins.org>
 <13856431-9ee5-c13e-f2a8-860394f9aae4@cn.fujitsu.com>
 <20170622025330.GX5303@merlins.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <1402929e-18ad-56f2-263f-282cd2a20a91@cn.fujitsu.com>
Date: Thu, 22 Jun 2017 12:08:50 +0800
MIME-Version: 1.0
In-Reply-To: <20170622025330.GX5303@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/22/2017 10:53 AM, Marc MERLIN wrote:
> Ok, first it finished (almost 24H)
> 
> (...)
> ERROR: root 3862 EXTENT_DATA[18170706 135168] interrupt
> ERROR: root 3862 EXTENT_DATA[18170706 1048576] interrupt
> ERROR: root 3864 EXTENT_DATA[109336 4096] interrupt
> ERROR: errors found in fs roots
> found 5544779108352 bytes used, error(s) found
> total csum bytes: 5344523140
> total tree bytes: 71323041792
> total fs tree bytes: 59288403968
> total extent tree bytes: 5378260992
> btree space waste bytes: 10912166856
> file data blocks allocated: 7830914256896
>   referenced 6244104495104
> 
> Thanks for your reply Qu
> 
> On Thu, Jun 22, 2017 at 10:22:57AM +0800, Qu Wenruo wrote:
>>> gargamel:~# btrfs check -p --mode lowmem  /dev/mapper/dshelf2
>>> Checking filesystem on /dev/mapper/dshelf2
>>> UUID: 85441c59-ad11-4b25-b1fe-974f9e4acede
>>> ERROR: extent[3886187384832, 81920] referencer count mismatch (root:
>>> 11930, owner: 375444, offset: 1851654144) wanted: 1, have: 4
>>
>> This means that in extent tree, btrfs says there is only one referring
>> to this extent, but lowmem mode find 4.
>>
>> It would provide great help if you could dump extent tree for it.
>> # btrfs-debug-tree <dev> | grep -C 10 3886187384832
>   
>                  extent data backref root 11712 objectid 375444 offset 1851572224 count 1
>                  extent data backref root 11276 objectid 375444 offset 1851572224 count 1
>                  extent data backref root 11058 objectid 375444 offset 1851572224 count 1
>                  extent data backref root 11494 objectid 375444 offset 1851572224 count 1
>          item 37 key (3886187352064 EXTENT_ITEM 32768) itemoff 11381 itemsize 140
>                  extent refs 4 gen 32382 flags DATA
>                  extent data backref root 11712 objectid 375444 offset 1851596800 count 1
>                  extent data backref root 11276 objectid 375444 offset 1851596800 count 1
>                  extent data backref root 11058 objectid 375444 offset 1851596800 count 1
>                  extent data backref root 11494 objectid 375444 offset 1851596800 count 1
>          item 38 key (3886187384832 EXTENT_ITEM 81920) itemoff 11212 itemsize 169
>                  extent refs 16 gen 32382 flags DATA
>                  extent data backref root 11712 objectid 375444 offset 1851654144 count 4
>                  extent data backref root 11276 objectid 375444 offset 1851654144 count 4
>                  extent data backref root 11058 objectid 375444 offset 1851654144 count 3
>                  extent data backref root 11494 objectid 375444 offset 1851654144 count 4
>                  extent data backref root 11930 objectid 375444 offset 1851654144 count 1
>          item 39 key (3886187466752 EXTENT_ITEM 16384) itemoff 11043 itemsize 169
>                  extent refs 5 gen 32382 flags DATA
>                  extent data backref root 11712 objectid 375444 offset 1851744256 count 1
>                  extent data backref root 11276 objectid 375444 offset 1851744256 count 1

Well, there is only the output from extent tree.

I was also expecting output from subvolue (11930) tree.

It could be done by
# btrfs-debug-tree -t 11930 | grep -C 10 3886187384832

But please pay attention that, this dump may contain filenames, feel 
free to mask the filenames.

> 
>   
>>> ERROR: errors found in extent allocation tree or chunk allocation
>>> cache and super generation don't match, space cache will be invalidated
>>> ERROR: root 3857 EXTENT_DATA[108864 4096] interrupt
>>
>> This means that, for root 3857, inode 108864, file offset 4096, there is
>> a gap before that extent.
>> In NO_HOLES mode it's allowed, but if NO_HOLES incompat flag is not set,
>> this should be a problem.
>>
>> I wonder if this is a problem caused by inlined compressed file extent.
>>
>> This can also be dumped by the following command.
>> # btrfs-debug-tree -t 3857 <dev> | grep -C 10 108864
> 
> This one is much bigger (192KB), I've bzipped and attached it.

Thanks for this one.
And it is caused by inlined compressed extent.

Lu Fengqi will send patch fixing it.

Thanks,
Qu

> 
> Thanks for having a look, I appreciate it.
> 
> Marc
> 


