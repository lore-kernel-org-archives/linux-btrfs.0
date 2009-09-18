From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Updated performance results
Date: Fri, 18 Sep 2009 16:14:09 -0400
Message-ID: <20090918201409.GF21798@think>
References: <4AAAC2B6.8040105@austin.ibm.com>
 <20090914135130.GE8839@think>
 <4AAEB89C.3040100@austin.ibm.com>
 <20090916005225.GG23965@think>
 <4AB280AD.5080306@hp.com>
 <4AB28245.2000704@austin.ibm.com>
 <20090917185220.GA18165@think>
 <20090917201714.GE18165@think>
 <20090917204331.GG18165@think>
 <4AB2B25B.5070706@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <eric.whitney@hp.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AB2B25B.5070706@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 17, 2009 at 05:04:11PM -0500, Steven Pratt wrote:
> Chris Mason wrote:
> >On Thu, Sep 17, 2009 at 04:17:14PM -0400, Chris Mason wrote:
> >>[ crashes on runs involving unmounts ]
> >>
> >>The run is still going here, but it has survived longer than before.
> >>I'm trying with Yan Zheng's patch:
> >>
> >>From: Yan Zheng <zheng.yan@oracle.com>
> >>Date: Fri, 11 Sep 2009 16:11:19 -0400
> >>Subject: [PATCH] Btrfs: improve async block group caching
> >
> >Quick update, I got through a full run of Steve's test with this
> >applied.  I'll start  a few more ;)
> Seems to work for me too!  Got through all the random write tests
> with no problems. Will kick off full run overnight.

Thanks again.

I've updated the btrfs-unstable tree to include Yan Zheng's fix.  I've
also included two more buffered writeback speedups, and I expect these
to make a difference on the multi-threaded tests.

I took a look at 1MB O_DIRECT writes, and the latencies of sending off
checksumming to the checksum threads seem to be the biggest problem.  I
get full tput at 8MB O_DIRECT writes, so for now I'm going to leave this
one alone.

-chris

