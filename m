Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36310 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdAQMZp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 07:25:45 -0500
Received: by mail-io0-f178.google.com with SMTP id j13so112988644iod.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 04:25:45 -0800 (PST)
Subject: Re: Unocorrectable errors with RAID1
To: "Janos Toth F." <toth.f.janos@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <87o9z7dzvd.fsf@grothesque.org>
 <85a62769-0607-4be5-3c5b-5091bebea07e@gmail.com>
 <87fukjdna0.fsf@grothesque.org>
 <ab77b777-27d6-9943-adb2-b70b62a5ecb0@gmail.com>
 <CANznX5Gt0BkP=KdkPi27hhvLb1uGUgkjP3xWB7mdyw58zbG6jw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b461903e-a4a8-0700-c8c8-dd0aa467f279@gmail.com>
Date: Tue, 17 Jan 2017 07:25:38 -0500
MIME-Version: 1.0
In-Reply-To: <CANznX5Gt0BkP=KdkPi27hhvLb1uGUgkjP3xWB7mdyw58zbG6jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-16 23:50, Janos Toth F. wrote:
>> BTRFS uses a 2 level allocation system.  At the higher level, you have
>> chunks.  These are just big blocks of space on the disk that get used for
>> only one type of lower level allocation (Data, Metadata, or System).  Data
>> chunks are normally 1GB, Metadata 256MB, and System depends on the size of
>> the FS when it was created.  Within these chunks, BTRFS then allocates
>> individual blocks just like any other filesystem.
>
> This always seems to confuse me when I try to get an abstract idea
> about de-/fragmentation of Btrfs.
> Can meta-/data be fragmented on both levels? And if so, can defrag
> and/or balance "cure" both levels of fragmentation (if any)?
> But how? May be several defrag and balance runs, repeated until
> returns diminish (or at least you consider them meaningless and/or
> unnecessary)?
Defrag operates only at the block level.  It won't allocate chunks 
unless it has to, and it won't remove chunks unless they become empty 
from it moving things around (although that's not likely to happen most 
of the time).  Balance functionally operates at both levels, but it 
doesn't really do any defragmentation.  Balance _may_ merge extents 
sometimes, but I'm not sure of this.  It will compact allocations and 
therefore functionally defragment free space within chunks (though not 
necessarily at the chunk-level itself).

Defrag run with the same options _should_ have no net effect after the 
first run, the two exceptions being if the filesystem is close to full 
or if the data set is being modified live while the defrag is happening. 
  Balance run with the same options will eventually hit a point where it 
doesn't do anything (or only touches one chunk of each type but doesn't 
actually give any benefit).  If you're just using the usage filters or 
doing a full balance, this point is the second run.  If you're using 
other filters, it's functionally not possible to determine when that 
point will be without low-level knowledge of the chunk layout.

For an idle filesystem, if you run defrag then a full balance, that will 
get you a near optimal layout.  Running them in the reverse order will 
get you a different layout that may be less optimal than running defrag 
first because defrag may move data in such a way that new chunks get 
allocated.  Repeated runs of defrag and balance will in more than 95% of 
cases provide no extra benefit.
>
>
>> What balancing does is send everything back through the allocator, which in
>> turn back-fills chunks that are only partially full, and removes ones that
>> are now empty.
>
> Does't this have a potential chance of introducing (additional)
> extent-level fragmentation?
In theory, yes.  IIRC, extents can't cross a chunk boundary.  Beyond 
that packing constraint, balance shouldn't fragment things further.
>
>> FWIW, while there isn't a daemon yet that does this, it's a perfect thing
>> for a cronjob.  The general maintenance regimen that I use for most of my
>> filesystems is:
>> * Run 'btrfs balance start -dusage=20 -musage=20' daily.  This will complete
>> really fast on most filesystems, and keeps the slack-space relatively
>> under-control (and has the nice bonus that it helps defragment free space.
>> * Run a full scrub on all filesystems weekly.  This catches silent
>> corruption of the data, and will fix it if possible.
>> * Run a full defrag on all filesystems monthly.  This should be run before
>> the balance (reasons are complicated and require more explanation than you
>> probably care for).  I would run this at least weekly though on HDD's, as
>> they tend to be more negatively impacted by fragmentation.
>
> I wonder if one should always run a full balance instead of a full
> scrub, since balance should also read (and thus theoretically verify)
> the meta-/data (does it though? I would expect it to check the
> chekcsums, but who knows...? may be it's "optimized" to skip that
> step?) and also perform the "consolidation" of the chunk level.
Scrub uses fewer resources than balance.  Balance has to read _and_ 
re-write all data in the FS regardless of the state of the data.  Scrub 
only needs to read the data if it's good, and if it's bad it only (for 
raid1) has to re-write the replica that's bad, not both of them.  In 
fact, the only practical reason to run balance on a regular basis at all 
is to compact allocations and defragment free space.  This is why I only 
have it balance chunks that are less than 1/5 full.
>
> I wish there was some more "integrated" solution for this: a
> balance-like operation which consolidates the chunks and also
> de-fragments the file extents at the same time while passively
> uncovers (and fixes if necessary and possible) any checksum mismatches
> / data errors, so that balance and defrag can't work against
> each-other and the overall work is minimized (compared to several full
> runs or many different commands).
More than 90% of the time, the performance difference between the 
absolute optimal layout and the one generated by just running defrag 
then balancing is so small that it's insignificant.  The closer to the 
optimal layout you get, the lower the returns for optimizing further 
(and this applies to any filesystem in fact).  In essence, it's a bit 
like the traveling salesman problem, any arbitrary solution probably 
isn't optimal, but it's generally close enough to not matter.

As far as scrub fitting into all of this, I'd personally rather have a 
daemon that slowly (less than 1% bandwidth usage) scrubs the FS over 
time in the background and logs and fixes errors it encounters (similar 
to how filesystem scrubbing works in many clustered filesystems) instead 
of always having to manually invoke it and jump through hoops to keep 
the bandwidth usage reasonable.
