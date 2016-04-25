Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37343 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbcDYNCj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 09:02:39 -0400
Received: by mail-ig0-f170.google.com with SMTP id g8so72988896igr.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Apr 2016 06:02:39 -0700 (PDT)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id e101sm11385705iod.29.2016.04.25.06.02.37
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 25 Apr 2016 06:02:38 -0700 (PDT)
Subject: Re: Add device while rebalancing
To: linux-btrfs@vger.kernel.org
References: <CAHaPQf0-qh0sLpUotSdESi8W6dnMOBQPXVJvBP8f2sEj2MC9EA@mail.gmail.com>
 <pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net> <571DFCF2.6050604@gmail.com>
 <pan$193a9$b381fd2b$1c0f329f$7b14e34b@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <571E154C.9060604@gmail.com>
Date: Mon, 25 Apr 2016 09:02:04 -0400
MIME-Version: 1.0
In-Reply-To: <pan$193a9$b381fd2b$1c0f329f$7b14e34b@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-25 08:43, Duncan wrote:
> Austin S. Hemmelgarn posted on Mon, 25 Apr 2016 07:18:10 -0400 as
> excerpted:
>
>> On 2016-04-23 01:38, Duncan wrote:
>>>
>>> And again with snapshotting operations.  Making a snapshot is normally
>>> nearly instantaneous, but there's a scaling issue if you have too many
>>> per filesystem (try to keep it under 2000 snapshots per filesystem
>>> total, if possible, and definitely keep it under 10K or some operations
>>> will slow down substantially), and deleting snapshots is more work, so
>>> while you should ordinarily automatically thin down snapshots if you're
>>> automatically making them quite frequently (say daily or more
>>> frequently), you may want to put the snapshot deletion, at least, on
>>> hold while you scrub or balance or device delete or replace.
>
>> I would actually recommend putting all snapshot operations on hold, as
>> well as most writes to the filesystem, while doing a balance or device
>> deletion.  The more writes you have while doing those, the longer they
>> take, and the less likely that you end up with a good on-disk layout of
>> the data.
>
> The thing with snapshot writing is that all snapshot creation effectively
> does is a bit of metadata writing.  What snapshots primarily do is lock
> existing extents in place (down within their chunk, with the higher chunk
> level being the scope at which balance works), that would otherwise be
> COWed elsewhere with the existing extent deleted on change, or simply
> deleted on on file delete.  A snapshot simply adds a reference to the
> current version, so that deletion, either directly or from the COW, never
> happens, and to do that simply requires a relatively small metadata write.
Unless I'm mistaken about the internals of BTRFS (which might be the 
case), creating a snapshot has to update reference counts on every 
single extent in every single file in the snapshot.  For something small 
this isn't much, but if you are snapshotting something big (say, 
snapshotting an entire system with all the data in one subvolume), it 
can amount to multiple MB of writes, and it gets even worse if you have 
no shared extents to begin with (which is still pretty typical).  On 
some of the systems I work with at work, snapshotting a terabyte of data 
can end up resulting in 10-20 MB of writes to disk (in this case, that 
figure came from a partition containing mostly small files that were 
just big enough that they didn't fit in-line in the metadata blocks).

This is of course still significantly faster than copying everything, 
but it's not free either.
>
> So while I agree in general that more writes means balances taking
> longer, snapshot creation writes are pretty tiny in the scheme of things,
> and won't affect the balance much, compared to larger writes you'll very
> possibly still be doing unless you really do suspend pretty much all
> write operations to that filesystem during the balance.
In general, yes, except that there's the case of running with mostly 
full metadata chunks, where it might result in a further chunk 
allocation, which in turn can throw off the balanced layout.  Balance 
always allocates new chunks, and doesn't write into existing ones, so if 
you're writing enough to allocate a new chunk while a balance is happening:
1. That chunk may or may not get considered by the balance code (I'm not 
100% certain about this, but I believe it will be ignored by any balance 
running at the time it gets allocated).
2. You run the risk of ending up with a chunk with almost nothing in it 
which could be packed into another existing chunk.
Snapshots are not likely to trigger this, but it is still possible, 
especially if you're taking lots of snapshots in a short period of time.
>
> But as I said, snapshot deletions are an entirely different story, as
> then all those previously locked in place extents are potentially freed,
> and the filesystem must do a lot of work to figure out which ones it can
> actually free and free them, vs. ones that still have other references
> which therefore cannot yet be freed.
Most of the issue here with balance is that you end up potentially doing 
an amount of unnecessary work which is unquantifiable before it's done.

