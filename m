Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbcEPP1L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 11:27:11 -0400
Date: Mon, 16 May 2016 17:26:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About in-band dedupe for v4.7
Message-ID: <20160516152608.GE511@suse.cz>
Reply-To: dsterba@suse.cz
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160510221119.GD7633@wotan.suse.de>
 <23ec14b4-deb3-4294-348c-1f0e4a7db169@cn.fujitsu.com>
 <20160511025211.GF7633@wotan.suse.de>
 <20160511173659.GI29353@suse.cz>
 <20160512205426.GL7633@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160512205426.GL7633@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 12, 2016 at 01:54:26PM -0700, Mark Fasheh wrote:
> On Wed, May 11, 2016 at 07:36:59PM +0200, David Sterba wrote:
> > On Tue, May 10, 2016 at 07:52:11PM -0700, Mark Fasheh wrote:
> > > Taking your history with qgroups out of this btw, my opinion does not
> > > change.
> > > 
> > > With respect to in-memory only dedupe, it is my honest opinion that such a
> > > limited feature is not worth the extra maintenance work. In particular
> > > there's about 800 lines of code in the userspace patches which I'm sure
> > > you'd want merged, because how could we test this then?
> > 
> > I like the in-memory dedup backend. It's lightweight, only a heuristic,
> > does not need any IO or persistent storage. OTOH I consider it a subpart
> > of the in-band deduplication that does all the persistency etc. So I
> > treat the ioctl interface from a broader aspect.
> 
> Those are all nice qualities, but what do they all get us?
> 
> For example, my 'large' duperemove test involves about 750 gigabytes of
> general purpose data - quite literally /home off my workstation.

Home directory is IMO a typicial anti-usecase for in-band deduplication.

> After the run I'm usually seeing between 65-75 gigabytes saved for a total
> of only 10% duplicated data. I would expect this to be fairly 'average' -
> /home on my machine has the usual stuff - documents, source code, media,
> etc.
> 
> So if you were writing your whole fs out you could expect about the same
> from inline dedupe - 10%-ish. Let's be generous and go with that number
> though as a general 'this is how much dedupe we get'.
> 
> What the memory backend is doing then is providing a cache of sha256/block
> calculations. This cache is very expensive to fill, and every written block
> must go through it. On top of that, the cache does not persist between
> mounts, and has items regularly removed from it when we run low on memory.
> All of this will drive down the amount of duplicated data we can find.
> 
> So our best case savings is probably way below 10% - let's be _really_ nice
> and say 5%.
> 
> Now ask yourself the question - would you accept a write cache which is
> expensive to fill and would only have a hit rate of less than 5%?

I'd ask myself a diffrent question: would I turn on a write cache if the
utilization is that low? No.

The in-memory cache is not going to be on by default, it's going to help
in spefific scenarios, as described in other replies.

> Oh and there's 800 lines of userspace we'd merge to manage this cache too,
> kernel ioctls which would have to be finalized, etc.

Most of the userspace code is going to be shared with the generic dedup.
I haven't reviewed the userspace because the ioctl interfaces are not
settled so the code can change, but now it should be enough to test the
feature.

> > A usecase I find interesting is to keep the in-memory dedup cache and
> > then flush it to disk on demand, compared to automatically synced dedup
> > (eg. at commit time).
> 
> What's the benefit here? We're still going to be hashing blocks on the way
> in, and if we're not deduping them at write time then we're just have to
> remove the extents and dedupe them later.
> 
> 
> > > A couple examples sore points in my review so far:
> > > 
> > > - Internally you're using a mutex (instead of a spinlock) to lock out queries
> > >  to the in-memory hash, which I can see becoming a performance problem in the
> > >  write path.
> > > 
> > > - Also, we're doing SHA256 in the write path which I expect will
> > >  slow it down even more dramatically. Given that all the work done gets
> > >  thrown out every time we fill the hash (or remount), I just don't see much
> > >  benefit to the user with this.
> > 
> > I had some ideas to use faster hashes and do sha256 when it's going to
> > be stored on disk, but there were some concerns. The objection against
> > speed and performance hit at write time is valid. But we'll need to
> > verify that in real performance tests, which haven't happend yet up to
> > my knowledge.
> 
> This is the type of thing that IMHO absolutely must be provided with each
> code drop of the feature. Dedupe is nice but _nobody_ will use it if it's
> slow. I know this from experience. I personally feel that btrfs has had
> enough of 'cute' and 'almost working' features. If we want inline dedupe we
> should do it correctly and with the right metrics from the beginning.

That's why this feature is on slow-merge track and I'm glad that so many
people are interested. And I hope it's not just because Qu asked to
merge it. I'm pushing back on the interface side, so far I think the
feature will address real usecases.

To evaluate the feature we have to put into some more visible git tree,
not only to see how it plays together with other changes, but because
the number of people who would apply the patches from mailinglist is
low. Leaving out the patchset from a for-next is easy if we encounter
problems.

> This is slightly unrelated to our discussion but my other unsolicited
> opinion: As a kernel developer and maintainer of a file system for well over
> a decade I will say that balancing the number of out of tree patches is
> necessary but we should never be accepting of large features just because
> 'they've been out for a long time'. Again I mention this because other parts
> of the discussion felt like they were going in that direction.

The amount of attention is higher if a patchset goes from out-of-tree to
some staging level, which would be the for-next when it's going via my
trees. But this does not say anything about the timeframe of merge. The
people involved usually know where it stands but this might not be
obvious to everybody as the discussion could happen on IRC or in private
mails. Changelogs of patchset revisions usually track the progress.
