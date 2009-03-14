From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs experimental branch updates
Date: Fri, 13 Mar 2009 21:33:41 -0400
Message-ID: <1236994421.17095.7.camel@think.oraclecorp.com>
References: <1236959774.17095.3.camel@think.oraclecorp.com>
	 <49BAE39F.8050102@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49BAE39F.8050102@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-03-13 at 17:52 -0500, Steven Pratt wrote:
> Chris Mason wrote:
> > Hello everyone,
> >
> > I've rebased the experimental branch to include most of the
> > optimizations I've been working on.
> >
> > The two major changes are doing all extent tree operations in delayed
> > processing queues and removing many of the blocking points with btree
> > locks held.
> >
> > In addition to smoothing out IO performance, these changes really cut
> > down on the amount of stack btrfs is using, which is especially
> > important for kernels with 4k stacks enabled (fedora).
> >
> >   
> Well, no drastic changes.  On Raid, creates got better, but random write 
> got worse. Mail server was mixed. For single disk, pretty much the same 
> story, although CPU savings is noticeable on write, although at the 
> expense of performance.
> 

Thanks for running this, but the main performance fixes for your test
are still in testing locally.  One thing that makes a huge difference on
the random write run is to mount -o ssd.

-chris


