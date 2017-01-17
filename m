Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:33033 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdAQEuW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jan 2017 23:50:22 -0500
Received: by mail-yw0-f172.google.com with SMTP id l75so80499570ywb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jan 2017 20:50:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ab77b777-27d6-9943-adb2-b70b62a5ecb0@gmail.com>
References: <87o9z7dzvd.fsf@grothesque.org> <85a62769-0607-4be5-3c5b-5091bebea07e@gmail.com>
 <87fukjdna0.fsf@grothesque.org> <ab77b777-27d6-9943-adb2-b70b62a5ecb0@gmail.com>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Tue, 17 Jan 2017 05:50:05 +0100
Message-ID: <CANznX5Gt0BkP=KdkPi27hhvLb1uGUgkjP3xWB7mdyw58zbG6jw@mail.gmail.com>
Subject: Re: Unocorrectable errors with RAID1
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> BTRFS uses a 2 level allocation system.  At the higher level, you have
> chunks.  These are just big blocks of space on the disk that get used for
> only one type of lower level allocation (Data, Metadata, or System).  Data
> chunks are normally 1GB, Metadata 256MB, and System depends on the size of
> the FS when it was created.  Within these chunks, BTRFS then allocates
> individual blocks just like any other filesystem.

This always seems to confuse me when I try to get an abstract idea
about de-/fragmentation of Btrfs.
Can meta-/data be fragmented on both levels? And if so, can defrag
and/or balance "cure" both levels of fragmentation (if any)?
But how? May be several defrag and balance runs, repeated until
returns diminish (or at least you consider them meaningless and/or
unnecessary)?


> What balancing does is send everything back through the allocator, which in
> turn back-fills chunks that are only partially full, and removes ones that
> are now empty.

Does't this have a potential chance of introducing (additional)
extent-level fragmentation?

> FWIW, while there isn't a daemon yet that does this, it's a perfect thing
> for a cronjob.  The general maintenance regimen that I use for most of my
> filesystems is:
> * Run 'btrfs balance start -dusage=20 -musage=20' daily.  This will complete
> really fast on most filesystems, and keeps the slack-space relatively
> under-control (and has the nice bonus that it helps defragment free space.
> * Run a full scrub on all filesystems weekly.  This catches silent
> corruption of the data, and will fix it if possible.
> * Run a full defrag on all filesystems monthly.  This should be run before
> the balance (reasons are complicated and require more explanation than you
> probably care for).  I would run this at least weekly though on HDD's, as
> they tend to be more negatively impacted by fragmentation.

I wonder if one should always run a full balance instead of a full
scrub, since balance should also read (and thus theoretically verify)
the meta-/data (does it though? I would expect it to check the
chekcsums, but who knows...? may be it's "optimized" to skip that
step?) and also perform the "consolidation" of the chunk level.

I wish there was some more "integrated" solution for this: a
balance-like operation which consolidates the chunks and also
de-fragments the file extents at the same time while passively
uncovers (and fixes if necessary and possible) any checksum mismatches
/ data errors, so that balance and defrag can't work against
each-other and the overall work is minimized (compared to several full
runs or many different commands).
