Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:38418 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752781AbeEUNm5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 09:42:57 -0400
Received: by mail-ot0-f182.google.com with SMTP id n3-v6so16875571ota.5
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 06:42:57 -0700 (PDT)
MIME-Version: 1.0
References: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
 <20180518162051.GS6649@twin.jikos.cz> <99d57070-a1df-45ef-8f7e-df832bd7ad92@linuxsystems.it>
 <de7adf73-ba0b-9154-e3d1-b4e468ad3c96@gmail.com> <161bea23-f1ea-4f01-b3ea-2c5e706102a7@linuxsystems.it>
 <07cf6f9b-7d67-93b9-2a6f-6d031ccf5468@gmail.com> <b8ac31e3-7c9b-44a7-a286-08f1642e25c6@linuxsystems.it>
 <ebc2865d-2784-0be7-79e2-fe56b624baa5@gmail.com>
In-Reply-To: <ebc2865d-2784-0be7-79e2-fe56b624baa5@gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 21 May 2018 16:42:20 +0300
Message-ID: <CAGqmi769vc7W=3WYeqss3_mit2tCNkjyAHVsq-Lhq+j-5XAr_Q@mail.gmail.com>
Subject: Re: Any chance to get snapshot-aware defragmentation?
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: darkbasic@linuxsystems.it, David Sterba <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

пн, 21 мая 2018 г. в 16:16, Austin S. Hemmelgarn <ahferroin7@gmail.com>:

> On 2018-05-19 04:54, Niccolò Belli wrote:
> > On venerdì 18 maggio 2018 20:33:53 CEST, Austin S. Hemmelgarn wrote:
> >> With a bit of work, it's possible to handle things sanely.  You can
> >> deduplicate data from snapshots, even if they are read-only (you need
> >> to pass the `-A` option to duperemove and run it as root), so it's
> >> perfectly reasonable to only defrag the main subvolume, and then
> >> deduplicate the snapshots against that (so that they end up all being
> >> reflinks to the main subvolume).  Of course, this won't work if you're
> >> short on space, but if you're dealing with snapshots, you should have
> >> enough space that this will work (because even without defrag, it's
> >> fully possible for something to cause the snapshots to suddenly take
> >> up a lot more space).
> >
> > Been there, tried that. Unfortunately even if I skip the defreg a simple
> >
> > duperemove -drhA --dedupe-options=noblock --hashfile=rootfs.hash rootfs
> >
> > is going to eat more space than it was previously available (probably
> > due to autodefrag?).
> It's not autodefrag (that doesn't trigger on use of the EXTENT_SAME
> ioctl).  There's two things involved here:

> * BTRFS has somewhat odd and inefficient handling of partial extents.
> When part of an extent becomes unused (because of a CLONE ioctl, or an
> EXTENT_SAME ioctl, or something similar), that part stays allocated
> until the whole extent would be unused.
> * You're using the default deduplication block size (128k), which is
> larger than your filesystem block size (which is at most 64k, most
> likely 16k, but might be 4k if it's an old filesystem), so deduplicating
> can split extents.

That's a metadata node leaf != fs block size.
btrfs fs block size == machine page size currently.

> Because of this, if a duplicate region happens to overlap the front of
> an already shared extent, and the end of said shared extent isn't
> aligned with the deduplication block size, the EXTENT_SAME call will
> deduplicate the first part, creating a new shared extent, but not the
> tail end of the existing shared region, and all of that original shared
> region will stick around, taking up extra space that it wasn't before.

> Additionally, if only part of an extent is duplicated, then that area of
> the extent will stay allocated, because the rest of the extent is still
> referenced (so you won't necessarily see any actual space savings).

> You can mitigate this by telling duperemove to use the same block size
> as your filesystem using the `-b` option.   Note that using a smaller
> block size will also slow down the deduplication process and greatly
> increase the size of the hash file.

duperemove -b control "how hash data", not more or less and only support
4KiB..1MiB

And size of block for dedup will change efficiency of deduplication,
when count of hash-block pairs, will change hash file size and time
complexity.

Let's assume that: 'A' - 1KiB of data 'AAAA' - 4KiB with repeated pattern.

So, example, you have 2 of 2x4KiB blocks:
1: 'AAAABBBB'
2: 'BBBBAAAA'

With -b 8KiB hash of first block not same as second.
But with -b 4KiB duperemove will see both 'AAAA' and 'BBBB'
And then that blocks will be deduped.

Even, duperemove have 2 modes of deduping:
1. By extents
2. By blocks

Thanks.

--
Have a nice day,
Timofey.
