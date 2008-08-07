From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs v0.16 released
Date: Thu, 07 Aug 2008 06:34:02 -0400
Message-ID: <1218105242.15342.184.camel@think.oraclecorp.com>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
	 <1218100139.8625.7.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1218100139.8625.7.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-08-07 at 11:08 +0200, Peter Zijlstra wrote:
> On Tue, 2008-08-05 at 15:01 -0400, Chris Mason wrote:
> 
> > * Fine grained btree locking.  The large fs_mutex is finally gone.
> > There is still some work to do on the locking during extent allocation,
> > but the code is much more scalable than it was.
> 
> Cool - will try to find a cycle to stare at the code ;-)
> 

I was able to get it mostly lockdep complaint by using mutex_lock_nested
based on the level of the btree I was locking.  My allocation mutex is a
little of a problem for lockdep though.

> > * Helper threads for checksumming and other background tasks.  Most CPU
> > intensive operations have been pushed off to helper threads to take
> > advantage of SMP machines.  Streaming read and write throughput now
> > scale to disk speed even with checksumming on.
> 
> Can this lead to the same Priority Inversion issues as seen with
> kjournald?
> 

Yes, although in general only the helper threads end up actually doing
the IO for writes.  Unfortunately, they are almost but not quite an
elevator.  It is tempting to try sorting the bios on the helper queues
etc.  But I haven't done that because it gets into starvation and other
fun.

I haven't done any real single cpu testing, it may make sense in those
workloads to checksum and submit directly in the calling context.  But
real single cpu boxes are harder to come by these days.

-chris


