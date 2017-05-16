Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60482 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdEPRI1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:08:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dAfxI-0003M9-2G
        for linux-btrfs@vger.kernel.org; Tue, 16 May 2017 19:08:16 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Btrfs/SSD
Date: Tue, 16 May 2017 19:08:11 +0200
Message-ID: <20170516190811.37b98756@jupiter.sol.kaishome.de>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
        <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
        <20170512203644.26e068e5@jupiter.sol.kaishome.de>
        <beb7f0b0-b84a-dfa1-12c2-256fe967af1d@gmail.com>
        <20170515214938.097b4c0b@jupiter.sol.kaishome.de>
        <20170515200505.GB5285@mother.pipebreaker.pl>
        <20170516035841.310cd1e7@jupiter.sol.kaishome.de>
        <20170516122120.GC5285@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 16 May 2017 14:21:20 +0200
schrieb Tomasz Torcz <tomek@pipebreaker.pl>:

> On Tue, May 16, 2017 at 03:58:41AM +0200, Kai Krakow wrote:
> > Am Mon, 15 May 2017 22:05:05 +0200
> > schrieb Tomasz Torcz <tomek@pipebreaker.pl>:
> >   
>  [...]  
> > > 
> > >   Let me add my 2 cents.  bcache-writearound does not cache writes
> > > on SSD, so there are less writes overall to flash.  It is said
> > > to prolong the life of the flash drive.
> > >   I've recently switched from bcache-writeback to
> > > bcache-writearound, because my SSD caching drive is at the edge
> > > of it's lifetime. I'm using bcache in following configuration:
> > > http://enotty.pipebreaker.pl/dżogstaff/2016.05.25-opcja2.svg My
> > > SSD is Samsung SSD 850 EVO 120GB, which I bought exactly 2 years
> > > ago.
> > > 
> > >   Now, according to
> > > http://www.samsung.com/semiconductor/minisite/ssd/product/consumer/850evo.html
> > > 120GB and 250GB warranty only covers 75 TBW (terabytes written).  
> > 
> > According to your chart, all your data is written twice to bcache.
> > It may have been better to buy two drives, one per mirror. I don't
> > think that SSD firmwares do deduplication - so data is really
> > written twice.  
> 
>   I'm aware of that, but 50 GB (I've got 100GB caching partition)
> is still plenty to cache my ~, some media files, two small VMs.
> On the other hand I don't want to overspend. This is just a home
> server.
>   Nb. I'm still waiting for btrfs native SSD caching, which was
> planned for 3.6 kernel 5 years ago :)
> ( https://oss.oracle.com/~mason/presentation/btrfs-jls-12/btrfs.html#/planned-3.6
> )
> 
> > 
> >   
> > > My
> > > drive has  # smartctl -a /dev/sda  | grep LBA 241
> > > Total_LBAs_Written      0x0032   099   099   000    Old_age
> > > Always       -       136025596053  
> > 
> > Doesn't say this "99%" remaining? The threshold is far from being
> > reached...
> > 
> > I'm curious, what is Wear_Leveling_Count reporting?  
> 
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE 9 Power_On_Hours          0x0032
> 096   096   000    Old_age   Always       -       18227 12
> Power_Cycle_Count       0x0032   099   099   000    Old_age
> Always       -       29 177 Wear_Leveling_Count     0x0013   001
> 001   000    Pre-fail  Always       -       4916
> 
>  Is this 001 mean 1%? If so, SMART contradicts datasheets. And I
> don't think I shoud see read errors for 1% wear.

It more means 1% left, that is 99% wear... Most of these are counters
from 100 down to zero, with THRESH being the threshold point below or at
which it is considered failed or failing.

Only a few values work the other way around (like temperature).

Be careful with interpreting raw values: they may be very manufacturer
specific and not normalized.

According to Total_LBAs_Written, the manufacturer thinks the drive
could still take 100x more (only 1% used). But your wear level is almost
100% (value = 001). I think that value isn't really designed around the
flash cell lifetime, but intermediate components like caches.

So you need to read most values "backwards": It's not a used counter,
but a "what's left" counter.

What does it tell you about reserved blocks usage? Note that it's sort
of double negation here: value 100 used means 100% unused or 0%
used... ;-) Or just insert a "minus" in front of those values and think
of them counting up to zero. So on a time axis it's at -100% of the
total lifetime scale and 0 is the fail point (or whatever "thresh"
says).


-- 
Regards,
Kai

Replies to list-only preferred.


