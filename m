From: Chris Mason <chris.mason@oracle.com>
Subject: Re: experimental branch rebased
Date: Fri, 27 Feb 2009 11:25:32 -0500
Message-ID: <1235751932.12383.11.camel@think.oraclecorp.com>
References: <1235663145.4631.11.camel@think.oraclecorp.com>
	 <49A71D95.8030707@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49A71D95.8030707@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-02-26 at 16:54 -0600, Steven Pratt wrote:
> Chris Mason wrote:
> > Hello everyone,
> >
> > I've rebased the experimental branch again with my latest performance
> > fixes.
> >
> > I took out the delayed unlink code, it wasn't making a big enough
> > difference in any benchmarks to justify the complexity.
> >
> > I changed the delayed backref code to do delayed processing for all
> > extents.  In general it is much faster and uses less stack.
> >
> > I pulled Josef's enospc work into the master branch and asked Linus to
> > pull it.
> >
> > I'm going to hammer on the experimental branch for a few days and ask
> > Steve to give it another run.
> >   
> Done.  Results for RAID are updated in history tree   
> http://btrfs.boxacle.net/repository/raid/history/History.html
> 
> This gives back a few of the performance improvements made on the tree 
> from the 24th (mail server and random write).
> 

Thanks for doing this.  I'm a little confused by the output though,
somehow our configs are giving opposite results ;)

When I run the rand-write workload with 128 threads here, btrfs gets
6236 ops/sec, and ext4 only gets 1509 ops/sec.

My box only has 5 drives, so there is probably a difference in btrfs'
ability to keep all the drives in the array busy.

So, I'll do some more experiments here.

-chris


