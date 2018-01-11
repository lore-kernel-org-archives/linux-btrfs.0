Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:56400 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932431AbeAKT5A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 14:57:00 -0500
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: waxhead@dirtcellar.net, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <8a80ff4a-07ef-f442-0730-9be659177c7c@dirtcellar.net>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <1fbdda56-3788-a9ea-f05f-d540032694ef@mendix.com>
Date: Thu, 11 Jan 2018 20:56:56 +0100
MIME-Version: 1.0
In-Reply-To: <8a80ff4a-07ef-f442-0730-9be659177c7c@dirtcellar.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/10/2018 10:37 PM, waxhead wrote:
> As just a regular user I would think that the first thing you would need
> is an analyze that can tell you if it is a good idea to balance or not
> in the first place.

Tooling to create that is available. Btrfs allows you to read a lot of
different data to analyze, and then you can experiment with your own
algorithms to find out which blockgroup you're going to feed to balance
next.

There's two language options...
* C -> in this case you're extending btrfs-progs to build new tools
* Python -> python-btrfs has everything in it to quickly throw together
things like this, and examples are available with the source.

For example:
- balance_least_used.py -> balance starting from the least used chunk
and work up towards a max of X% used.
- show_free_space_fragmentation.py -> find out which chunks have badly
fragmented free space. Remember: if you have a 1GiB chunk with usage
50%, that doesn't tell you if it has only a handful of extents, filling
up the first 500MiB, with the rest empty, or if it's thousands of
alternating pieces of 4KiB used space and 4KiB free space. ;-] [0]

In the same way you can program something new, like a balance algorithm
that cleans up blocks with high free space fragmentation first.

Or, another thing you could do is first count the number of extents in a
block group and add it to the algorithm. Balance of a block group with a
few extents is much faster than thousands of extents with a lot of
reflinks, like highly deduped data.

Or... look at generation of metadata to find out which parts of data on
your disk have been touched recently, and which weren't... Too many fun
things to play around with. \:D/

As always, first thing to do is make sure you're on 4.14 or otherwise
use nossd, otherwise you might keep shoveling data around forever.

And if your filesystem has been treated badly by <4.14 kernel in ssd
mode for a long time, then first get that cleaned up:

https://www.spinics.net/lists/linux-btrfs/msg70622.html

> Scrub seems like a great place to start - e.g. scrub could auto-analyze
> and report back need to balance. I also think that scrub should
> optionally autobalance if needed.
> 
> Balance may not be needed, but if one can determine that balancing would
> speed up things a bit I don't see why this as an option can't be
> scheduled automatically. Ideally there should be a "scrub and polish"
> option that would scrub, balance and perhaps even defragment in one go.
> 
> In fact, the way I see it btrfs should idealy by itself keep track on
> each data/metadata chunk and it should know , when was this chunk last
> affected by a scrub, balance, defrag etc and perform the required
> operations by itself based on a configuration or similar. Some may
> disagree for good reasons , but for me this is my wishlist for a
> filesystem :) e.g. a pool that just works and only annoys you with the
> need of replacing a bad disk every now and then :)

I don't think these kind of things will ever end up in kernel code.

[0] There's a version in the devel branch in git that also works without
free space tree, taking a slower detour via the extent tree.

-- 
Hans van Kranenburg
