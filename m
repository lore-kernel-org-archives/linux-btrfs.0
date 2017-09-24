Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52253 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752194AbdIXNk4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 09:40:56 -0400
Subject: Re: Btrfs performance with small blocksize on SSD
To: "Fuhrmann, Carsten" <carsten.fuhrmann@rwth-aachen.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <3321b3c199da4d378bbfa3dbac3c4059@rwth-aachen.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f05a6500-19d6-fc7c-7461-905417c855b7@gmx.com>
Date: Sun, 24 Sep 2017 21:40:46 +0800
MIME-Version: 1.0
In-Reply-To: <3321b3c199da4d378bbfa3dbac3c4059@rwth-aachen.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月24日 21:24, Fuhrmann, Carsten wrote:
> Hello,
> 
> i run a few performance tests comparing mdadm, hardware raid and the btrfs raid. I noticed that the performance for small blocksizes (2k) is very bad on SSD in general and on HDD for sequential writing.

2K is smaller than the minimal btrfs sectorsize (4K for x86 family).

It's common that unaligned access will impact performance, but we need 
more info about your test cases, including:
1) How write is done?
    Buffered? DIO? O_SYNC? fdatasync?
    I can't read Germany so I'm not sure what the result means. (Although
    I can guess Y axle is latency, but I don't know the meaning of X axle.
    And how many files are involved, how large of these files and etc.

2) Data/meta/sys profiles
    All RADI1?

3) Mkfs profile
    Like nodesize if not default, and any incompat features enabled.

> I wonder about that result, because you say on the wiki that btrfs is very effective for small files.

It can be space effective or performance effective.

If *ignoring* meta profile, btrfs is space-effectient since it inline 
the data into metadata, avoiding padding it to sectorsize so it can save 
some space.

And such behavior can also be somewhat performance effective, by 
avoiding extra seeking for data, since when reading out the metadata we 
have already read out the inlined data.

But such efficiency come with cost.

One obvious one is when we need to convert inline data into regular one.
It may cause extra tree balancing and increase latency.

Would you please try retest with "-o max_inline=0" mount option to 
disable inline data (which makes btrfs behavior like ext*/xfs) to see if 
it's related?

Thanks,
Qu

> 
> I attached my results from raid 1 random write HDD (rH1), SSD (rS1) and from sequential write HDD (sH1), SSD (sS1)
> 
> Hopefully you have an explanation for that.
> 
> raid@raid-PowerEdge-T630:~$ uname -a
> Linux raid-PowerEdge-T630 4.10.0-33-generic #37~16.04.1-Ubuntu SMP Fri Aug 11 14:07:24 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
> raid@raid-PowerEdge-T630:~$ btrfs --version
> btrfs-progs v4.4
> 
> 
> best regards
> 
> Carsten
> 
