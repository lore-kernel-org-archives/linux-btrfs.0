From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [3.2-rc7] slowdown, warning + oops creating lots of files
Date: Thu, 5 Jan 2012 16:02:55 -0500
Message-ID: <20120105210255.GE30372@shiny>
References: <20120104214445.GE17026@dastard>
 <20120104221105.GF17026@dastard>
 <4F04D178.2070006@csamuel.org>
 <20120104230122.GA24466@dastard>
 <20120105184657.GC30372@shiny>
 <20120105194500.GD30372@shiny>
 <20120105201216.GG24466@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120105201216.GG24466@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 06, 2012 at 07:12:16AM +1100, Dave Chinner wrote:
> On Thu, Jan 05, 2012 at 02:45:00PM -0500, Chris Mason wrote:
> > On Thu, Jan 05, 2012 at 01:46:57PM -0500, Chris Mason wrote:
> > > On Thu, Jan 05, 2012 at 10:01:22AM +1100, Dave Chinner wrote:
> > > > On Thu, Jan 05, 2012 at 09:23:52AM +1100, Chris Samuel wrote:
> > > > > On 05/01/12 09:11, Dave Chinner wrote:
> > > > > 
> > > > > > Looks to be reproducable.
> > > > > 
> > > > > Does this happen with rc6 ?
> > > > 
> > > > I haven't tried. All I'm doing is running some benchmarks to get
> > > > numbers for a talk I'm giving about improvements in XFS metadata
> > > > scalability, so I wanted to update my last set of numbers from
> > > > 2.6.39.
> > > > 
> > > > As it was, these benchmarks also failed on btrfs with oopsen and
> > > > corruptions back in 2.6.39 time frame.  e.g. same VM, same
> > > > test, different crashes, similar slowdowns as reported here:
> > > > http://comments.gmane.org/gmane.comp.file-systems.btrfs/11062
> > > > 
> > > > Given that there is now a history of this simple test uncovering
> > > > problems, perhaps this is a test that should be run more regularly
> > > > by btrfs developers?
> > > 
> > > Unfortunately, this one works for me.  I'll try it again and see if I
> > > can push harder.  If not, I'll see if I can trade beer for some
> > > diagnostic runs.
> > 
> > Aha, if I try it just on the ssd instead of on my full array it triggers
> > at 88M files.  Great.
> 
> Good to know.  The error that is generating the BUG on my machine is
> -28 (ENOSPC).  Given there's 17TB free on my filesystem....

Yeah, same thing here.  I'm testing a fix now, it's pretty dumb.  We're
not allocating more metadata chunks from the drive because of where the
allocation is happening, so it is just a check for "do we need a new
chunk" in the right place.

I'll make sure it can fill my ssd and then send to you.

-chris

