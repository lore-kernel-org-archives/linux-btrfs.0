Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbcELUy2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 16:54:28 -0400
Date: Thu, 12 May 2016 13:54:26 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About in-band dedupe for v4.7
Message-ID: <20160512205426.GL7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160510221119.GD7633@wotan.suse.de>
 <23ec14b4-deb3-4294-348c-1f0e4a7db169@cn.fujitsu.com>
 <20160511025211.GF7633@wotan.suse.de>
 <20160511173659.GI29353@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160511173659.GI29353@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 11, 2016 at 07:36:59PM +0200, David Sterba wrote:
> On Tue, May 10, 2016 at 07:52:11PM -0700, Mark Fasheh wrote:
> > Taking your history with qgroups out of this btw, my opinion does not
> > change.
> > 
> > With respect to in-memory only dedupe, it is my honest opinion that such a
> > limited feature is not worth the extra maintenance work. In particular
> > there's about 800 lines of code in the userspace patches which I'm sure
> > you'd want merged, because how could we test this then?
> 
> I like the in-memory dedup backend. It's lightweight, only a heuristic,
> does not need any IO or persistent storage. OTOH I consider it a subpart
> of the in-band deduplication that does all the persistency etc. So I
> treat the ioctl interface from a broader aspect.

Those are all nice qualities, but what do they all get us?

For example, my 'large' duperemove test involves about 750 gigabytes of
general purpose data - quite literally /home off my workstation.

After the run I'm usually seeing between 65-75 gigabytes saved for a total
of only 10% duplicated data. I would expect this to be fairly 'average' -
/home on my machine has the usual stuff - documents, source code, media,
etc.

So if you were writing your whole fs out you could expect about the same
from inline dedupe - 10%-ish. Let's be generous and go with that number
though as a general 'this is how much dedupe we get'.

What the memory backend is doing then is providing a cache of sha256/block
calculations. This cache is very expensive to fill, and every written block
must go through it. On top of that, the cache does not persist between
mounts, and has items regularly removed from it when we run low on memory.
All of this will drive down the amount of duplicated data we can find.

So our best case savings is probably way below 10% - let's be _really_ nice
and say 5%.

Now ask yourself the question - would you accept a write cache which is
expensive to fill and would only have a hit rate of less than 5%?

Oh and there's 800 lines of userspace we'd merge to manage this cache too,
kernel ioctls which would have to be finalized, etc.


> A usecase I find interesting is to keep the in-memory dedup cache and
> then flush it to disk on demand, compared to automatically synced dedup
> (eg. at commit time).

What's the benefit here? We're still going to be hashing blocks on the way
in, and if we're not deduping them at write time then we're just have to
remove the extents and dedupe them later.


> > A couple examples sore points in my review so far:
> > 
> > - Internally you're using a mutex (instead of a spinlock) to lock out queries
> >  to the in-memory hash, which I can see becoming a performance problem in the
> >  write path.
> > 
> > - Also, we're doing SHA256 in the write path which I expect will
> >  slow it down even more dramatically. Given that all the work done gets
> >  thrown out every time we fill the hash (or remount), I just don't see much
> >  benefit to the user with this.
> 
> I had some ideas to use faster hashes and do sha256 when it's going to
> be stored on disk, but there were some concerns. The objection against
> speed and performance hit at write time is valid. But we'll need to
> verify that in real performance tests, which haven't happend yet up to
> my knowledge.

This is the type of thing that IMHO absolutely must be provided with each
code drop of the feature. Dedupe is nice but _nobody_ will use it if it's
slow. I know this from experience. I personally feel that btrfs has had
enough of 'cute' and 'almost working' features. If we want inline dedupe we
should do it correctly and with the right metrics from the beginning.


This is slightly unrelated to our discussion but my other unsolicited
opinion: As a kernel developer and maintainer of a file system for well over
a decade I will say that balancing the number of out of tree patches is
necessary but we should never be accepting of large features just because
'they've been out for a long time'. Again I mention this because other parts
of the discussion felt like they were going in that direction.

Thanks,
	--Mark

--
Mark Fasheh
