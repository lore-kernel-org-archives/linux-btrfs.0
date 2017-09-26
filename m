Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39395 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1031322AbdIZWqY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 18:46:24 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dwycF-0008Mk-Pz
        for linux-btrfs@vger.kernel.org; Wed, 27 Sep 2017 00:46:11 +0200
To: linux-btrfs@vger.kernel.org
From: Ferry Toth <ftoth@telfort.nl>
Subject: Re: Give up on bcache?
Date: Tue, 26 Sep 2017 22:46:00 +0000 (UTC)
Message-ID: <oqelb8$2e0$1@blaine.gmane.org>
References: <oqe0fo$keo$1@blaine.gmane.org>
        <b545953d-7fbe-c451-0213-9c1fbec72a3b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Op Tue, 26 Sep 2017 15:52:44 -0400, schreef Austin S. Hemmelgarn:

> On 2017-09-26 12:50, Ferry Toth wrote:
>> Looking at the Phoronix benchmark here:
>> 
>> https://www.phoronix.com/scan.php?page=article&item=linux414-bcache-
>> raid&num=2
>> 
>> I think it might be idle hopes to think bcache can be used as a ssd
>> cache for btrfs to significantly improve performance.. True, the
>> benchmark is using ext.
> It's a benchmark.  They're inherently synthetic and workload specific,
> and therefore should not be trusted to represent things accurately for
> arbitrary use cases.

So what. A decent benchmark tries to measure a specific aspect of the fs.

I think you agree that applications doing lots of fsyncs (databases, 
dpkg) are slow on btrfs especially on hdd's, whatever way you measure 
that (it feels slow, it measures slow, it really is slow).

On a ssd the problem is less.

So if you can fix that by using a ssd cache or a hybrid solution, how 
would you like to compare that? It _feels_ faster?

>> But the most important one (where btrfs always shows to be a little
>> slow)
>> would be the SQLLite test. And with ext at least performance _degrades_
>> except for the Writeback mode, and even there is nowhere near what the
>> SSD is capable of.
> And what makes you think it will be?  You're using it as a hot-data
> cache, not a dedicated write-back cache, and you have the overhead from
> bcache itself too.  Just some simple math based on examining the bcache
> code suggests you can't get better than about 98% of the SSD's
> performance if you're lucky, and I'd guess it's more like 80% most of
> the time.
>> 
>> I think with btrfs it will be even worse and that it is a fundamental
>> problem: caching is complex and the cache can not how how the data on
>> the fs is used.
> Actually, the improvement from using bcache with BTRFS is higher
> proportionate to the baseline of not using it by a small margin than it
> is when used with ext4.  BTRFS does a lot more with the disk, so you
> have a lot more time spent accessing the disk, and thus more time that
> can be reduced by improving disk performance.  While the CoW nature of
> BTRFS does somewhat mitigate the performance improvement from using
> bcache, it does not completely negate it.

I would like to reverse this, how much degradation do you suffer from 
btrfs on a ssd as baseline compared to btrfs on a mixed ssd/hdd system.

IMHO you are hoping to get ssd performance at hdd cost.  

>> I think the original idea of hot data tracking has a much better chance
>> to significantly improve performance. This of course as the SSD's and
>> HDD's then will be equal citizens and btrfs itself gets to decide on
>> which drive the data is best stored.
> First, the user needs to decide, not BTRFS (at least, by default, BTRFS
> should not be involved in the decision).  Second, tiered storage (that's
> what that's properly called) is mostly orthogonal to caching (though
> bcache and dm-cache behave like tiered storage once the cache is
> warmed).

So, on your desktop you really are going to seach for all sqllite, mysql 
and psql files, dpkg files etc. and move them to the ssd? You can already 
do that. Go ahead! 

The big win would be if the file system does that automatically for you.

>> With this implemented right, it would also finally silence the never
>> ending discussion why not btrfs and why zfs, ext, xfs etc. Which would
>> be a plus by its own right.
> Even with this, there would still be plenty of reasons to pick one of
> those filesystems over BTRFS.  There would however be one more reason to
> pick BTRFS over ext or XFS (but necessarily not ZFS, it already has
> caching built in).

Exactly, one more advantage of btrfs and one less of zfs.

