Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33718 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258AbcDYMnw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 08:43:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aufrh-0006kV-HK
	for linux-btrfs@vger.kernel.org; Mon, 25 Apr 2016 14:43:49 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Apr 2016 14:43:49 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Apr 2016 14:43:49 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Add device while rebalancing
Date: Mon, 25 Apr 2016 12:43:30 +0000 (UTC)
Message-ID: <pan$193a9$b381fd2b$1c0f329f$7b14e34b@cox.net>
References: <CAHaPQf0-qh0sLpUotSdESi8W6dnMOBQPXVJvBP8f2sEj2MC9EA@mail.gmail.com>
	<pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net>
	<571DFCF2.6050604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Mon, 25 Apr 2016 07:18:10 -0400 as
excerpted:

> On 2016-04-23 01:38, Duncan wrote:
>>
>> And again with snapshotting operations.  Making a snapshot is normally
>> nearly instantaneous, but there's a scaling issue if you have too many
>> per filesystem (try to keep it under 2000 snapshots per filesystem
>> total, if possible, and definitely keep it under 10K or some operations
>> will slow down substantially), and deleting snapshots is more work, so
>> while you should ordinarily automatically thin down snapshots if you're
>> automatically making them quite frequently (say daily or more
>> frequently), you may want to put the snapshot deletion, at least, on
>> hold while you scrub or balance or device delete or replace.

> I would actually recommend putting all snapshot operations on hold, as
> well as most writes to the filesystem, while doing a balance or device
> deletion.  The more writes you have while doing those, the longer they
> take, and the less likely that you end up with a good on-disk layout of
> the data.

The thing with snapshot writing is that all snapshot creation effectively 
does is a bit of metadata writing.  What snapshots primarily do is lock 
existing extents in place (down within their chunk, with the higher chunk 
level being the scope at which balance works), that would otherwise be 
COWed elsewhere with the existing extent deleted on change, or simply 
deleted on on file delete.  A snapshot simply adds a reference to the 
current version, so that deletion, either directly or from the COW, never 
happens, and to do that simply requires a relatively small metadata write.

So while I agree in general that more writes means balances taking 
longer, snapshot creation writes are pretty tiny in the scheme of things, 
and won't affect the balance much, compared to larger writes you'll very 
possibly still be doing unless you really do suspend pretty much all 
write operations to that filesystem during the balance.

But as I said, snapshot deletions are an entirely different story, as 
then all those previously locked in place extents are potentially freed, 
and the filesystem must do a lot of work to figure out which ones it can 
actually free and free them, vs. ones that still have other references 
which therefore cannot yet be freed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

