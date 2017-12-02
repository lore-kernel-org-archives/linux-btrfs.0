Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:46483 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751960AbdLBQ2O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 2 Dec 2017 11:28:14 -0500
Date: Sat, 2 Dec 2017 17:28:12 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: exclusive subvolume space missing
Message-ID: <20171202162812.GA5324@polanet.pl>
References: <20171201161555.GA11892@polanet.pl>
 <20171201213614.GE29898@carfax.org.uk>
 <20171202005338.GA20205@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20171202005338.GA20205@polanet.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 01 Dec 2017 18:57:08 -0800, Duncan wrote:

> OK, is this supposed to be raid1 or single data, because the above shows
> metadata as all raid1, while some data is single tho most is raid1, and
> while old mkfs used to create unused single chunks on raid1 that had to
> be removed manually via balance, those single data chunks aren't unused.

It is supposed to be RAID1, the single data were leftovers from my previous
attempts to gain some space by converting into single profile. Which
miserably failed BTW (would it be smarter with "soft" option?),
but I've already managed to clear this.

> Assuming the intent is raid1, I'd recommend doing...
>
> btrfs balance start -dconvert=raid1,soft /

Yes, this was the way to go. It also reclaimed the 8 GB. I assume the
failing -dconvert=single somehow locked that 8 GB, so this issue should
be addressed in btrfs-tools to report such locked out region. You've
already noted that the single profile data occupied much less itself.

So this was the first issue, the second is running overhead, that
accumulates over time. Since yesterday, when I had 19 GB free, I've lost
4 GB already. The scenario you've described is very probable:

> btrfs balance start -dusage=N /
[...]
> allocated value toward usage.  I too run relatively small btrfs raid1s
> and would suggest trying N=5, 20, 40, 70, until the spread between

There were no effects above N=10 (both dusage and musage).

> consuming your space either, as I'd suspect they might if the problem were
> for instance atime updates, so while noatime is certainly recommended and

I use noatime by default since years, so not the source of problem here.

> The other possibility that comes to mind here has to do with btrfs COW
> write patterns...

> Suppose you start with a 100 MiB file (I'm adjusting the sizes down from
[...]
> Now make various small changes to the file, say under 16 KiB each.  These
> will each be COWed elsewhere as one might expect. by default 16 KiB at
> a time I believe (might be 4 KiB, as it was back when the default leaf

I got ~500 small files (100-500 kB) updated partially in regular
intervals:

# du -Lc **/*.rrd | tail -n1
105M    total

> But here's the kicker.  Even without a snapshot locking that original 100
> MiB extent in place, if even one of the original 16 KiB blocks isn't
> rewritten, that entire 100 MiB extent will remain locked in place, as the
> original 16 KiB blocks that have been changed and thus COWed elsewhere
> aren't freed one at a time, the full 100 MiB extent only gets freed, all
> at once, once no references to it remain, which means once that last
> block of the extent gets rewritten.
>
> So perhaps you have a pattern where files of several MiB get mostly
> rewritten, taking more space for the rewrites due to COW, but one or
> more blocks remain as originally written, locking the original extent
> in place at its full size, thus taking twice the space of the original
> file.
>
> Of course worst-case is rewrite the file minus a block, then rewrite
> that minus a block, then rewrite... in which case the total space
> usage will end up being several times the size of the original file!
>
> Luckily few people have this sort of usage pattern, but if you do...
>
> It would certainly explain the space eating...

Did anyone investigated how is that related to RRD rewrites? I don't use
rrdcached, never thought that 100 MB of data might trash entire
filesystem...

best regards,
-- 
Tomasz Pala <gotar@pld-linux.org>
