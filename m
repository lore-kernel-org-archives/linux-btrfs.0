Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 185-6-29-55-rev.logitus.pl ([185.6.29.55]:56620 "EHLO
        mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752773AbdEPMVc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 08:21:32 -0400
Date: Tue, 16 May 2017 14:21:20 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs/SSD
Message-ID: <20170516122120.GC5285@mother.pipebreaker.pl>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
 <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
 <20170512203644.26e068e5@jupiter.sol.kaishome.de>
 <beb7f0b0-b84a-dfa1-12c2-256fe967af1d@gmail.com>
 <20170515214938.097b4c0b@jupiter.sol.kaishome.de>
 <20170515200505.GB5285@mother.pipebreaker.pl>
 <20170516035841.310cd1e7@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170516035841.310cd1e7@jupiter.sol.kaishome.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 16, 2017 at 03:58:41AM +0200, Kai Krakow wrote:
> Am Mon, 15 May 2017 22:05:05 +0200
> schrieb Tomasz Torcz <tomek@pipebreaker.pl>:
> 
> > > Yes, I considered that, too. And when I tried, there was almost no
> > > perceivable performance difference between bcache-writearound and
> > > bcache-writeback. But the latency of performance improvement was
> > > much longer in writearound mode, so I sticked to writeback mode.
> > > Also, writing random data is faster because bcache will defer it to
> > > background and do writeback in sector order. Sequential access is
> > > passed around bcache anyway, harddisks are already good at that.  
> > 
> >   Let me add my 2 cents.  bcache-writearound does not cache writes
> > on SSD, so there are less writes overall to flash.  It is said
> > to prolong the life of the flash drive.
> >   I've recently switched from bcache-writeback to bcache-writearound,
> > because my SSD caching drive is at the edge of it's lifetime. I'm
> > using bcache in following configuration:
> > http://enotty.pipebreaker.pl/dżogstaff/2016.05.25-opcja2.svg My SSD
> > is Samsung SSD 850 EVO 120GB, which I bought exactly 2 years ago.
> > 
> >   Now, according to
> > http://www.samsung.com/semiconductor/minisite/ssd/product/consumer/850evo.html
> > 120GB and 250GB warranty only covers 75 TBW (terabytes written).
> 
> According to your chart, all your data is written twice to bcache. It
> may have been better to buy two drives, one per mirror. I don't think
> that SSD firmwares do deduplication - so data is really written twice.

  I'm aware of that, but 50 GB (I've got 100GB caching partition)
is still plenty to cache my ~, some media files, two small VMs.
On the other hand I don't want to overspend. This is just a home
server.
  Nb. I'm still waiting for btrfs native SSD caching, which was
planned for 3.6 kernel 5 years ago :)
( https://oss.oracle.com/~mason/presentation/btrfs-jls-12/btrfs.html#/planned-3.6 )

> 
> 
> > My
> > drive has  # smartctl -a /dev/sda  | grep LBA 241
> > Total_LBAs_Written      0x0032   099   099   000    Old_age
> > Always       -       136025596053
> 
> Doesn't say this "99%" remaining? The threshold is far from being
> reached...
> 
> I'm curious, what is Wear_Leveling_Count reporting?

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  9 Power_On_Hours          0x0032   096   096   000    Old_age   Always       -       18227
 12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always       -       29
177 Wear_Leveling_Count     0x0013   001   001   000    Pre-fail  Always       -       4916

 Is this 001 mean 1%? If so, SMART contradicts datasheets. And I
don't think I shoud see read errors for 1% wear.
 

> > which multiplied by 512 bytes gives 69.6 TB. Close to 75TB? Well…
> > 

-- 
Tomasz Torcz       ,,(...) today's high-end is tomorrow's embedded processor.''
xmpp: zdzichubg@chrome.pl                      -- Mitchell Blank on LKML

