From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Fri, 26 Aug 2011 11:35:28 +1000
Message-ID: <20110826013528.GW3162@dastard>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
 <1309275199-10801-5-git-send-email-josef@redhat.com>
 <20110825060632.GA9933@infradead.org>
 <20110825064039.GO3162@dastard>
 <0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, viro@ZenIV.linux.org.uk, dchinner@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 25, 2011 at 12:51:56AM -0600, Andreas Dilger wrote:
> On 2011-08-25, at 12:40 AM, Dave Chinner wrote:
> > On Thu, Aug 25, 2011 at 02:06:32AM -0400, Christoph Hellwig wrote:
> >> On Tue, Jun 28, 2011 at 11:33:19AM -0400, Josef Bacik wrote:
> >>> This is a test to make sure seek_data/seek_hole is acting like it does on
> >>> Solaris.  It will check to see if the fs supports finding a hole or not and will adjust as necessary.
> >> 
> >> Can you resend this with any updates that happened in the meantime?
> >> 
> >> Dave also still had some comments about semantics, so it might be worth
> >> to incorporate that as well.
> > 
> > The main questions I had when looking at this was how we should
> > handle unwritten extents - the only answer I got was along the lines
> > of "we'll deal with that once filesystems have implemented
> > something". That's a bit of a chicken-and-egg situation, and doesn't
> > help me decide what is the best thing to do. I don't want to have to
> > re-implement this code when it's decided i did the wrong thing
> > initially.
> 
> Let's first clarify what you mean by an unwritten extent?  Do you mean a
> preallocated extent that returns 0 when read,

Exactly that.

> or do you mean a delayed
> allocation extent that was written by the application that is still in
> memory but not yet written to disk?

That's not an unwritten extent - that's a delayed allocation extent ;)

> Unfortunately, ZFS has no concept of preallocated extents, so we can't
> look to it for precedent, but it definitely has delayed allocation.
> Possibly if UFS on Solaris has SEEK_HOLE and also preallocated extents
> (I have no idea) it could be tested?
> 
> > The most basic question I really want answered is this:
> > 
> > 	- is preallocated space a HOLE, or is it DATA?
> > 
> > Whatever the answer, I think it should be consistently
> > presented by all filesystems that support preallocation, and it
> > should be encoded into the generic SEEK_HOLE/SEEK_DATA tests....
> 
> My thought would be that a preallocated extent is still a HOLE, because
> it doesn't contain data that an application actually cares about.  On
> the other hand, a delalloc extent is DATA because it has something that
> an application cares about.

OK, that's the way I'd expect to treat both preallocated and
delalloc space.

> > Answering that question then helps answer the more complex questions
> > I had, like:
> > 
> > 	- what does SEEK_DATA return when you have a file layout
> > 	  like "hole-prealloc-data"?
> 
> I would think only the "data" part, since that is what the definition
> of "SEEK_DATA" is IMHO.

Agreed, that's the way I'd interpret it, too. So perhaps we need to
ensure that this interpretation is actually tested by this test?

How about some definitions to work by:

Data: a range of the file that contains valid data, regardless of
whether it exists in memory or on disk. The valid data can be
preceeded and/or followed by an arbitrary number of zero bytes
dependent on the underlying implementation of hole detection.

Hole: a range of the file that contains no data or is made up
entirely of  NULL (zero) data. Holes include preallocated ranges of
files that have not had actual data written to them.

Does that make sense? It has sufficient flexibility in it for the
existing generic "non-implementation", allows for filesystems to
define their own hole detection boundaries (e.g. filesystem block
size), and effectively defines how preallocated ranges from
fallocate() should be treated (i.e. as holes). If we can agree on
those definitions, I think that we should document them in both the
kernel and the man page that defines SEEK_HOLE/SEEK_DATA so everyone
is on the same page...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
