From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Wed, 29 Jun 2011 03:40:21 -0400
Message-ID: <20110629074021.GA26086@infradead.org>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
 <1309275199-10801-5-git-send-email-josef@redhat.com>
 <20110629065306.GC1026@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110629065306.GC1026@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 29, 2011 at 04:53:07PM +1000, Dave Chinner wrote:
> On Tue, Jun 28, 2011 at 11:33:19AM -0400, Josef Bacik wrote:
> > This is a test to make sure seek_data/seek_hole is acting like it does on
> > Solaris.  It will check to see if the fs supports finding a hole or not and will
> > adjust as necessary.
> 
> So I just looked at this with an eye to validating an XFS
> implementation, and I came up with this list of stuff that the test
> does not cover that I'd need to test in some way:
> 
> 	- files with clean unwritten extents. Are they a hole or
> 	  data? What's SEEK_DATA supposed to return on layout like
> 	  hole-unwritten-data? i.e. needs to add fallocate to the
> 	  picture...
>
> 	- files with dirty unwritten extents (i.e. dirty in memory,
> 	  not on disk). They are most definitely data, and most
> 	  filesystems will need a separate lookup path to detect
> 	  dirty unwritten ranges because the state is kept
> 	  separately (page cache vs extent cache).  Plenty of scope
> 	  for filesystem specific bugs here so needs a roubust test.

The discussion leading up to the resurrection of SEEK_HOLE/SEEK_DATA
was pretty much about that point.  The conclusion based on the Sun
documentation and common sense was that SEEK_DATA may only consider
unwritten extents as hole if the filesystem has a way to distinguish
plain unwritten extents and those that have been dirtied.  Else it
should be considered data.

Testing for making sure dirty preallocated areas aren't wrongly
reported sounds relatively easy, the rest falls into implementation
details, which imho is fine.  Not reporting preallocated extents
as holes just is a quality of implementation issue and not a bug.

