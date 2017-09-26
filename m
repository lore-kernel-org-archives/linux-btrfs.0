Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:56614 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965209AbdIZTwu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 15:52:50 -0400
Received: by mail-it0-f54.google.com with SMTP id g18so4152670itg.5
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 12:52:50 -0700 (PDT)
Subject: Re: Give up on bcache?
To: Ferry Toth <ftoth@telfort.nl>, linux-btrfs@vger.kernel.org
References: <oqe0fo$keo$1@blaine.gmane.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b545953d-7fbe-c451-0213-9c1fbec72a3b@gmail.com>
Date: Tue, 26 Sep 2017 15:52:44 -0400
MIME-Version: 1.0
In-Reply-To: <oqe0fo$keo$1@blaine.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-26 12:50, Ferry Toth wrote:
> Looking at the Phoronix benchmark here:
> 
> https://www.phoronix.com/scan.php?page=article&item=linux414-bcache-
> raid&num=2
> 
> I think it might be idle hopes to think bcache can be used as a ssd cache
> for btrfs to significantly improve performance.. True, the benchmark is
> using ext.
It's a benchmark.  They're inherently synthetic and workload specific, 
and therefore should not be trusted to represent things accurately for 
arbitrary use cases.
> 
> But the most important one (where btrfs always shows to be a little slow)
> would be the SQLLite test. And with ext at least performance _degrades_
> except for the Writeback mode, and even there is nowhere near what the
> SSD is capable of.
And what makes you think it will be?  You're using it as a hot-data 
cache, not a dedicated write-back cache, and you have the overhead from 
bcache itself too.  Just some simple math based on examining the bcache 
code suggests you can't get better than about 98% of the SSD's 
performance if you're lucky, and I'd guess it's more like 80% most of 
the time.
> 
> I think with btrfs it will be even worse and that it is a fundamental
> problem: caching is complex and the cache can not how how the data on the
> fs is used.
Actually, the improvement from using bcache with BTRFS is higher 
proportionate to the baseline of not using it by a small margin than it 
is when used with ext4.  BTRFS does a lot more with the disk, so you 
have a lot more time spent accessing the disk, and thus more time that 
can be reduced by improving disk performance.  While the CoW nature of 
BTRFS does somewhat mitigate the performance improvement from using 
bcache, it does not completely negate it.
> 
> I think the original idea of hot data tracking has a much better chance
> to significantly improve performance. This of course as the SSD's and
> HDD's then will be equal citizens and btrfs itself gets to decide on
> which drive the data is best stored.
First, the user needs to decide, not BTRFS (at least, by default, BTRFS 
should not be involved in the decision).  Second, tiered storage (that's 
what that's properly called) is mostly orthogonal to caching (though 
bcache and dm-cache behave like tiered storage once the cache is warmed).
> 
> With this implemented right, it would also finally silence the never
> ending discussion why not btrfs and why zfs, ext, xfs etc. Which would be
> a plus by its own right.
Even with this, there would still be plenty of reasons to pick one of 
those filesystems over BTRFS.  There would however be one more reason to 
pick BTRFS over ext or XFS (but necessarily not ZFS, it already has 
caching built in).

