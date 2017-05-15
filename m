Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46905 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S966556AbdEOTtr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 15:49:47 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dALzv-0008H9-9h
        for linux-btrfs@vger.kernel.org; Mon, 15 May 2017 21:49:39 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Btrfs/SSD
Date: Mon, 15 May 2017 21:49:38 +0200
Message-ID: <20170515214938.097b4c0b@jupiter.sol.kaishome.de>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
        <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
        <20170512203644.26e068e5@jupiter.sol.kaishome.de>
        <beb7f0b0-b84a-dfa1-12c2-256fe967af1d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 15 May 2017 08:03:48 -0400
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> > That's why I don't trust any of my data to them. But I still want
> > the benefit of their speed. So I use SSDs mostly as frontend caches
> > to HDDs. This gives me big storage with fast access. Indeed, I'm
> > using bcache successfully for this. A warm cache is almost as fast
> > as native SSD (at least it feels almost that fast, it will be
> > slower if you threw benchmarks at it).  
> That's to be expected though, most benchmarks don't replicate actual 
> usage patterns for client systems, and using SSD's for caching with 
> bcache or dm-cache for most server workloads except a file server
> will usually get you a performance hit.

You mean "performance boost"? Almost every read-most server workload
should benefit... I file server may be the exact opposite...

Also, I think dm-cache and bcache work very differently and are not
directly comparable. Their benefit depends much on the applied workload.

If I remember right, dm-cache is more about keeping "hot data" in the
flash storage while bcache is more about reducing seeking. So dm-cache
optimizes for bigger throughput of SSDs while bcache optimizes for
almost-zero seek overhead of SSDs. Depending on your underlying
storage, one or the other may even give zero benefit or worsen
performance. Which is what I'd call a "performance hit"... I didn't
ever try dm-cache, tho. For reasons I don't remember exactly, I didn't
like something about how it's implemented, I think it was related to
crash recovery. I don't know if that still holds true with modern
kernels. It may have changed but I never looked back to revise that
decision.


> It's worth noting also that on average, COW filesystems like BTRFS
> (or log-structured-filesystems will not benefit as much as
> traditional filesystems from SSD caching unless the caching is built
> into the filesystem itself, since they don't do in-place rewrites (so
> any new write by definition has to drop other data from the cache).

Yes, I considered that, too. And when I tried, there was almost no
perceivable performance difference between bcache-writearound and
bcache-writeback. But the latency of performance improvement was much
longer in writearound mode, so I sticked to writeback mode. Also,
writing random data is faster because bcache will defer it to
background and do writeback in sector order. Sequential access is
passed around bcache anyway, harddisks are already good at that.

But of course, the COW nature of btrfs will lower the hit rate I can
on writes. That's why I see no benefit in using bcache-writethrough
with btrfs.


-- 
Regards,
Kai

Replies to list-only preferred.

