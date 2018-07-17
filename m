Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34362 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728475AbeGQIsK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 04:48:10 -0400
Subject: Re: Healthy amount of free space?
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Wolf <wolf@wolfsden.cz>, linux-btrfs@vger.kernel.org
References: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz>
 <1dd72720-1beb-a5e6-5bd4-88d6af5f02bd@suse.com> <2197534.TZSffJRfLT@merkaba>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9ea19b13-3c46-666f-fa79-f40bd1ae7658@suse.com>
Date: Tue, 17 Jul 2018 11:16:42 +0300
MIME-Version: 1.0
In-Reply-To: <2197534.TZSffJRfLT@merkaba>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.07.2018 11:02, Martin Steigerwald wrote:
> Hi Nikolay.
> 
> Nikolay Borisov - 17.07.18, 09:20:
>> On 16.07.2018 23:58, Wolf wrote:
>>> Greetings,
>>> I would like to ask what what is healthy amount of free space to
>>> keep on each device for btrfs to be happy?
>>>
>>> This is how my disk array currently looks like
>>>
>>>     [root@dennas ~]# btrfs fi usage /raid
>>>     
>>>     Overall:
>>>         Device size:                  29.11TiB
>>>         Device allocated:             21.26TiB
>>>         Device unallocated:            7.85TiB
>>>         Device missing:                  0.00B
>>>         Used:                         21.18TiB
>>>         Free (estimated):              3.96TiB      (min: 3.96TiB)
>>>         Data ratio:                       2.00
>>>         Metadata ratio:                   2.00
>>>         Global reserve:              512.00MiB      (used: 0.00B)
> […]
>>> Btrfs does quite good job of evenly using space on all devices. No,
>>> how low can I let that go? In other words, with how much space
>>> free/unallocated remaining space should I consider adding new disk?
>>
>> Btrfs will start running into problems when you run out of unallocated
>> space. So the best advice will be monitor your device unallocated,
>> once it gets really low - like 2-3 gb I will suggest you run balance
>> which will try to free up unallocated space by rewriting data more
>> compactly into sparsely populated block groups. If after running
>> balance you haven't really freed any space then you should consider
>> adding a new drive and running balance to even out the spread of
>> data/metadata.
> 
> What are these issues exactly?

For example if you have plenty of data space but your metadata is full
then you will be getting ENOSPC.

> 
> I have
> 
> % btrfs fi us -T /home
> Overall:
>     Device size:                 340.00GiB
>     Device allocated:            340.00GiB
>     Device unallocated:            2.00MiB
>     Device missing:                  0.00B
>     Used:                        308.37GiB
>     Free (estimated):             14.65GiB      (min: 14.65GiB)
>     Data ratio:                       2.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
>                           Data      Metadata System              
> Id Path                   RAID1     RAID1    RAID1    Unallocated
> -- ---------------------- --------- -------- -------- -----------
>  1 /dev/mapper/msata-home 165.89GiB  4.08GiB 32.00MiB     1.00MiB
>  2 /dev/mapper/sata-home  165.89GiB  4.08GiB 32.00MiB     1.00MiB
> -- ---------------------- --------- -------- -------- -----------
>    Total                  165.89GiB  4.08GiB 32.00MiB     2.00MiB
>    Used                   151.24GiB  2.95GiB 48.00KiB

You already have only 33% of your metadata full so if your workload
turned out to actually be making more metadata-heavy changed i.e
snapshots you could exhaust this and get ENOSPC, despite having around
14gb of free data space. Furthermore this data space is spread around
multiple data chunks, depending on how populated they are a balance
could be able to free up unallocated space which later could be
re-purposed for metadata (again, depending on what you are doing).

> 
> on a RAID-1 filesystem one, part of the time two Plasma desktops + 
> KDEPIM and Akonadi + Baloo desktop search + you name it write to like 
> mad.
> 

<snip>

> 
> Thanks,
> 
