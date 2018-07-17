Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52194 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729208AbeGQHwE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 03:52:04 -0400
Subject: Re: Healthy amount of free space?
To: Wolf <wolf@wolfsden.cz>, linux-btrfs@vger.kernel.org
References: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1dd72720-1beb-a5e6-5bd4-88d6af5f02bd@suse.com>
Date: Tue, 17 Jul 2018 10:20:49 +0300
MIME-Version: 1.0
In-Reply-To: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.07.2018 23:58, Wolf wrote:
> Greetings,
> I would like to ask what what is healthy amount of free space to keep on
> each device for btrfs to be happy?
> 
> This is how my disk array currently looks like
> 
>     [root@dennas ~]# btrfs fi usage /raid
>     Overall:
>         Device size:                  29.11TiB
>         Device allocated:             21.26TiB
>         Device unallocated:            7.85TiB
>         Device missing:                  0.00B
>         Used:                         21.18TiB
>         Free (estimated):              3.96TiB      (min: 3.96TiB)
>         Data ratio:                       2.00
>         Metadata ratio:                   2.00
>         Global reserve:              512.00MiB      (used: 0.00B)
> 
>     Data,RAID1: Size:10.61TiB, Used:10.58TiB
>        /dev/mapper/data1       1.75TiB
>        /dev/mapper/data2       1.75TiB
>        /dev/mapper/data3     856.00GiB
>        /dev/mapper/data4     856.00GiB
>        /dev/mapper/data5       1.75TiB
>        /dev/mapper/data6       1.75TiB
>        /dev/mapper/data7       6.29TiB
>        /dev/mapper/data8       6.29TiB
> 
>     Metadata,RAID1: Size:15.00GiB, Used:13.00GiB
>        /dev/mapper/data1       2.00GiB
>        /dev/mapper/data2       3.00GiB
>        /dev/mapper/data3       1.00GiB
>        /dev/mapper/data4       1.00GiB
>        /dev/mapper/data5       3.00GiB
>        /dev/mapper/data6       1.00GiB
>        /dev/mapper/data7       9.00GiB
>        /dev/mapper/data8      10.00GiB
> 
>     System,RAID1: Size:64.00MiB, Used:1.50MiB
>        /dev/mapper/data2      32.00MiB
>        /dev/mapper/data6      32.00MiB
>        /dev/mapper/data7      32.00MiB
>        /dev/mapper/data8      32.00MiB
> 
>     Unallocated:
>        /dev/mapper/data1    1004.52GiB
>        /dev/mapper/data2    1004.49GiB
>        /dev/mapper/data3    1006.01GiB
>        /dev/mapper/data4    1006.01GiB
>        /dev/mapper/data5    1004.52GiB
>        /dev/mapper/data6    1004.49GiB
>        /dev/mapper/data7    1005.00GiB
>        /dev/mapper/data8    1005.00GiB
> 
> Btrfs does quite good job of evenly using space on all devices. No, how
> low can I let that go? In other words, with how much space
> free/unallocated remaining space should I consider adding new disk?

Btrfs will start running into problems when you run out of unallocated
space. So the best advice will be monitor your device unallocated, once
it gets really low - like 2-3 gb I will suggest you run balance which
will try to free up unallocated space by rewriting data more compactly
into sparsely populated block groups. If after running balance you
haven't really freed any space then you should consider adding a new
drive and running balance to even out the spread of data/metadata.

> 
> Thanks for advice :)
> 
> W.
> 
