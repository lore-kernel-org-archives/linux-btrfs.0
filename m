Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45235 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751305AbdEPCFQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 22:05:16 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dARrF-00087L-Lc
        for linux-btrfs@vger.kernel.org; Tue, 16 May 2017 04:05:05 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Btrfs/SSD
Date: Tue, 16 May 2017 03:58:41 +0200
Message-ID: <20170516035841.310cd1e7@jupiter.sol.kaishome.de>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
        <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
        <20170512203644.26e068e5@jupiter.sol.kaishome.de>
        <beb7f0b0-b84a-dfa1-12c2-256fe967af1d@gmail.com>
        <20170515214938.097b4c0b@jupiter.sol.kaishome.de>
        <20170515200505.GB5285@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 15 May 2017 22:05:05 +0200
schrieb Tomasz Torcz <tomek@pipebreaker.pl>:

> On Mon, May 15, 2017 at 09:49:38PM +0200, Kai Krakow wrote:
> >   
> > > It's worth noting also that on average, COW filesystems like BTRFS
> > > (or log-structured-filesystems will not benefit as much as
> > > traditional filesystems from SSD caching unless the caching is
> > > built into the filesystem itself, since they don't do in-place
> > > rewrites (so any new write by definition has to drop other data
> > > from the cache).  
> > 
> > Yes, I considered that, too. And when I tried, there was almost no
> > perceivable performance difference between bcache-writearound and
> > bcache-writeback. But the latency of performance improvement was
> > much longer in writearound mode, so I sticked to writeback mode.
> > Also, writing random data is faster because bcache will defer it to
> > background and do writeback in sector order. Sequential access is
> > passed around bcache anyway, harddisks are already good at that.  
> 
>   Let me add my 2 cents.  bcache-writearound does not cache writes
> on SSD, so there are less writes overall to flash.  It is said
> to prolong the life of the flash drive.
>   I've recently switched from bcache-writeback to bcache-writearound,
> because my SSD caching drive is at the edge of it's lifetime. I'm
> using bcache in following configuration:
> http://enotty.pipebreaker.pl/dżogstaff/2016.05.25-opcja2.svg My SSD
> is Samsung SSD 850 EVO 120GB, which I bought exactly 2 years ago.
> 
>   Now, according to
> http://www.samsung.com/semiconductor/minisite/ssd/product/consumer/850evo.html
> 120GB and 250GB warranty only covers 75 TBW (terabytes written).

According to your chart, all your data is written twice to bcache. It
may have been better to buy two drives, one per mirror. I don't think
that SSD firmwares do deduplication - so data is really written twice.

They may do compression but that won't be streaming compression but
per-block compression, so it won't help here as a deduplicator. Also,
due to internal structure, compression would probably work similar to
how zswap works: By combining compressed blocks into "buddy blocks", so
only compression above 2:1 will merge compressed blocks into single
blocks. For most of your data, this won't be true. So effectively, this
has no overall effect. For this reason, I doubt that any firmware takes
the chance for compression, effects are just too low vs. the management
overhead and complexity that adds to the already complicated FTL layer.


> My
> drive has  # smartctl -a /dev/sda  | grep LBA 241
> Total_LBAs_Written      0x0032   099   099   000    Old_age
> Always       -       136025596053

Doesn't say this "99%" remaining? The threshold is far from being
reached...

I'm curious, what is Wear_Leveling_Count reporting?

> which multiplied by 512 bytes gives 69.6 TB. Close to 75TB? Well…
> 
> [35354.697513] sd 0:0:0:0: [sda] tag#19 FAILED Result:
> hostbyte=DID_OK driverbyte=DRIVER_SENSE [35354.697516] sd 0:0:0:0:
> [sda] tag#19 Sense Key : Medium Error [current] [35354.697518] sd
> 0:0:0:0: [sda] tag#19 Add. Sense: Unrecovered read error - auto
> reallocate failed [35354.697522] sd 0:0:0:0: [sda] tag#19 CDB:
> Read(10) 28 00 0c 30 82 9f 00 00 48 00 [35354.697524]
> blk_update_request: I/O error, dev sda, sector 204505785
> 
> Above started appearing recently.  So, I was really suprised that:
> - this drive is only rated for 120 TBW
> - I went through this limit in only 2 years
> 
>   The workload is lightly utilised home server / media center.

I think, bcache is a real SSD killer for drives around 120GB size or
below... I had similar life usage with my previous small SSD just after
one year. But I never had a sense error because I took it out of
service early. And I switched to writearound, too.

I think the write-pattern of bcache cannot be handled well by the FTL.
It behaves like a log-structured file system, with new writes only
appended, and sometimes a garbage collection is done by freeing
complete erase blocks. Maybe it could work better, if btrfs could pass
information about freed blocks down to bcache. Btrfs has a lot of these
due to COW nature.

I wonder if this would already be supported if turning on discard in
btrfs? Does anyone know?


-- 
Regards,
Kai

Replies to list-only preferred.


