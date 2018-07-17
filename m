Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36305 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729688AbeGQS2p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 14:28:45 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Wolf <wolf@wolfsden.cz>, linux-btrfs@vger.kernel.org
Subject: Re: Healthy amount of free space?
Date: Tue, 17 Jul 2018 19:54:57 +0200
Message-ID: <1736761.B5nO4FXixV@merkaba>
In-Reply-To: <9ea19b13-3c46-666f-fa79-f40bd1ae7658@suse.com>
References: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz> <2197534.TZSffJRfLT@merkaba> <9ea19b13-3c46-666f-fa79-f40bd1ae7658@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nikolay Borisov - 17.07.18, 10:16:
> On 17.07.2018 11:02, Martin Steigerwald wrote:
> > Nikolay Borisov - 17.07.18, 09:20:
> >> On 16.07.2018 23:58, Wolf wrote:
> >>> Greetings,
> >>> I would like to ask what what is healthy amount of free space to
> >>> keep on each device for btrfs to be happy?
> >>> 
> >>> This is how my disk array currently looks like
> >>> 
> >>>     [root@dennas ~]# btrfs fi usage /raid
> >>>     
> >>>     Overall:
> >>>         Device size:                  29.11TiB
> >>>         Device allocated:             21.26TiB
> >>>         Device unallocated:            7.85TiB
> >>>         Device missing:                  0.00B
> >>>         Used:                         21.18TiB
> >>>         Free (estimated):              3.96TiB      (min: 3.96TiB)
> >>>         Data ratio:                       2.00
> >>>         Metadata ratio:                   2.00
> >>>         Global reserve:              512.00MiB      (used: 0.00B)
> > 
> > […]
> > 
> >>> Btrfs does quite good job of evenly using space on all devices.
> >>> No,
> >>> how low can I let that go? In other words, with how much space
> >>> free/unallocated remaining space should I consider adding new
> >>> disk?
> >> 
> >> Btrfs will start running into problems when you run out of
> >> unallocated space. So the best advice will be monitor your device
> >> unallocated, once it gets really low - like 2-3 gb I will suggest
> >> you run balance which will try to free up unallocated space by
> >> rewriting data more compactly into sparsely populated block
> >> groups. If after running balance you haven't really freed any
> >> space then you should consider adding a new drive and running
> >> balance to even out the spread of data/metadata.
> > 
> > What are these issues exactly?
> 
> For example if you have plenty of data space but your metadata is full
> then you will be getting ENOSPC.

Of that one I am aware.

This just did not happen so far.

I did not yet add it explicitly to the training slides, but I just make 
myself a note to do that.

Anything else?

> > I have
> > 
> > % btrfs fi us -T /home
> > 
> > Overall:
> >     Device size:                 340.00GiB
> >     Device allocated:            340.00GiB
> >     Device unallocated:            2.00MiB
> >     Device missing:                  0.00B
> >     Used:                        308.37GiB
> >     Free (estimated):             14.65GiB      (min: 14.65GiB)
> >     Data ratio:                       2.00
> >     Metadata ratio:                   2.00
> >     Global reserve:              512.00MiB      (used: 0.00B)
> >     
> >                           Data      Metadata System
> > 
> > Id Path                   RAID1     RAID1    RAID1    Unallocated
> > -- ---------------------- --------- -------- -------- -----------
> > 
> >  1 /dev/mapper/msata-home 165.89GiB  4.08GiB 32.00MiB     1.00MiB
> >  2 /dev/mapper/sata-home  165.89GiB  4.08GiB 32.00MiB     1.00MiB
> > 
> > -- ---------------------- --------- -------- -------- -----------
> > 
> >    Total                  165.89GiB  4.08GiB 32.00MiB     2.00MiB
> >    Used                   151.24GiB  2.95GiB 48.00KiB
>
> You already have only 33% of your metadata full so if your workload
> turned out to actually be making more metadata-heavy changed i.e
> snapshots you could exhaust this and get ENOSPC, despite having around
> 14gb of free data space. Furthermore this data space is spread around
> multiple data chunks, depending on how populated they are a balance
> could be able to free up unallocated space which later could be
> re-purposed for metadata (again, depending on what you are doing).

The filesystem above IMO is not fit for snapshots. It would fill up 
rather quickly, I think even when I balance metadata. Actually I tried 
this and as I remember it took at most a day until it was full.

If I read above figures currently at maximum I could gain one additional 
GiB by balancing metadata. That would not make a huge difference.

I bet I am already running this filesystem beyond recommendation, as I 
bet many would argue it is to full already for regular usage… I do not 
see the benefit of squeezing the last free space out of it just to fit 
in another GiB.

So I still do not get the point why it would make sense to balance it at 
this point in time. Especially as this 1 GiB I could regain is not even 
needed. And I do not see the point of balancing it weekly. I would 
regain about 1 GiB of metadata space every now and then, but the cost 
would be a lot of additional I/O to the SSD. They still take it very 
nicely so far, but I think, right now, there is simply no point in 
balancing, at least not regularly, unless…

there would be an performance gain. Whenever I balanced a complete 
filesystem with data and metadata I however saw a cross drop in 
performance, like doubling the boot time for example (no scientific 
measurement, just my personal observation). I admit I did not do this 
for a long time and the balancing might have gotten better during the 
last few years of kernel development, but I am not yet convinced of 
that.

So is balancing this filesystem likely to improve the performance of it? 
And if so, why?

What it could improve, I think, is allocating new data, cause BTRFS due 
to the balancing might have freed some chunks, so in case lots of new 
data is written it does not have to search inside existing chunks which 
are likely to fragment their free space over time.

I just like to understand this better. Right now I am quite confused at 
what recommendations to give about balancing.

I bet SLES developers had a good reason for going with weekly balancing. 
Right now I just don´t get it. And as you work at SUSE, I thought I just 
ask about it.

I am aware of some earlier threads, but I did not read everything that 
has been discussed so far. In case there is a good summary, feel free to 
point me to it.

I bet a page in BTRFS wiki about performance aspects would be a nice 
idea. I would even create one, if I still can access the wiki.

> > on a RAID-1 filesystem one, part of the time two Plasma desktops +
> > KDEPIM and Akonadi + Baloo desktop search + you name it write to
> > like
> > mad.

Thanks,
-- 
Martin


