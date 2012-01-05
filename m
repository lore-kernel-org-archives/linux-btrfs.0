From: Dave Chinner <david@fromorbit.com>
Subject: Re: [3.2-rc7] slowdown, warning + oops creating lots of files
Date: Thu, 5 Jan 2012 22:43:40 +1100
Message-ID: <20120105114340.GF24466@dastard>
References: <20120104214445.GE17026@dastard>
 <20120104221105.GF17026@dastard>
 <4F04D178.2070006@csamuel.org>
 <20120104230122.GA24466@dastard>
 <4F050996.1060206@cn.fujitsu.com>
 <20120105022630.GD24466@dastard>
 <4F05F5E3.70600@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F05F5E3.70600@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 05, 2012 at 02:11:31PM -0500, Liu Bo wrote:
> On 01/04/2012 09:26 PM, Dave Chinner wrote:
> > On Wed, Jan 04, 2012 at 09:23:18PM -0500, Liu Bo wrote:
> >> On 01/04/2012 06:01 PM, Dave Chinner wrote:
> >>> On Thu, Jan 05, 2012 at 09:23:52AM +1100, Chris Samuel wrote:
> >>>> On 05/01/12 09:11, Dave Chinner wrote:
> >>>>
> >>>>> Looks to be reproducable.
> >>>> Does this happen with rc6 ?
> >>> I haven't tried. All I'm doing is running some benchmarks to get
> >>> numbers for a talk I'm giving about improvements in XFS metadata
> >>> scalability, so I wanted to update my last set of numbers from
> >>> 2.6.39.
> >>>
> >>> As it was, these benchmarks also failed on btrfs with oopsen and
> >>> corruptions back in 2.6.39 time frame.  e.g. same VM, same
> >>> test, different crashes, similar slowdowns as reported here:
> >>> http://comments.gmane.org/gmane.comp.file-systems.btrfs/11062
> >>>
> >>> Given that there is now a history of this simple test uncovering
> >>> problems, perhaps this is a test that should be run more regularly
> >>> by btrfs developers?
> >>>
> >>>> If not then it might be easy to track down as there are only
> >>>> 2 modifications between rc6 and rc7..
> >>> They don't look like they'd be responsible for fixing an extent tree
> >>> corruption, and I don't really have the time to do an open-ended
> >>> bisect to find where the problem fix arose.
> >>>
> >>> As it is, 3rd attempt failed at 22m inodes, without the warning this
> >>> time:
> > 
> > .....
> > 
> >>> It's hard to tell exactly what path gets to that BUG_ON(), so much
> >>> code is inlined by the compiler into run_clustered_refs() that I
> >>> can't tell exactly how it got to the BUG_ON() triggered in
> >>> alloc_reserved_tree_block().
> >>>
> >> This seems to be an oops led by ENOSPC.
> > 
> > At the time of the oops, this is the space used on the filesystem:
> > 
> > $ df -h /mnt/scratch
> > Filesystem      Size  Used Avail Use% Mounted on
> > /dev/vdc         17T   31G   17T   1% /mnt/scratch
> > 
> > It's less than 0.2% full, so I think ENOSPC can be ruled out here.
> > 
> 
> This bug has done something with our block reservation allocator, not the real disk space.
> 
> Can you try the below one and see what happens?

Still crashes, still has severe slowdowns.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
