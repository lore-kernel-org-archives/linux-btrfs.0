From: Chris Mason <chris.mason@oracle.com>
Subject: Re: More random write performance data
Date: Thu, 09 Apr 2009 18:21:22 -0400
Message-ID: <1239315682.11893.3.camel@think.oraclecorp.com>
References: <49DD1949.1060503@austin.ibm.com>
	 <1239232172.31826.1.camel@think.oraclecorp.com>
	 <49DE6B8A.1010801@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49DE6B8A.1010801@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-04-09 at 16:41 -0500, Steven Pratt wrote:
> Chris Mason wrote:
> > On Wed, 2009-04-08 at 16:38 -0500, Steven Pratt wrote:
> >   
> >> Given the anomalies we were seeing on random write workloads, I decided 
> >> to simplify the test and do single threaded odirect random write.  This 
> >> should eliminate the locking issue as well as any pdflush bursty 
> >> behavior.  What I got was not quite what I expected.
> >>
> >> The most interesting graph is probably #12,  DM write throughput.  We 
> >> see a baseline of ~7MB/sec with spikes every 30 seconds.  I assume the 
> >> spike are meta data related as the io is being done from user space at a 
> >> steady constant rate.  The really odd thing is that for the entire 
> >> almost 2 hour duration, the amplitude of the spike continues to climb, 
> >> meaning the amount of meta data need to be flushed to disk is ever 
> >> increasing.
> >>
> >> http://btrfs.boxacle.net/repository/raid/longrun/btrfs-longrun-1thread/btrfs1.ffsb.random_writes__threads_0001.09-04-08_13.05.54/analysis/iostat-processed.001/chart.html
> >>
> >> Looking at graph #8 DM IO/sec, we see that there is even a pattern 
> >> within the pattern of spikes.  It # of IOs in each spike appears to 
> >> change at each interval and repeats over a set of 7, 30 second intervals.
> >>
> >> Also, we see that we average 12MB/sec of data written out, for 5MB/sec 
> >> of benchmark throughput.
> >>
> >> I have queued up a run without checksums and cow to see how much this 
> >> overhead is reduced.
> >>     
> >
> > Really interesting, thanks Steve.
> >
> > I'll have to run it at home next week, but I think the high metadata
> > writeback is related to updating backrefs on the extent allocation tree.
> >   
> Well, looks like you are correct.  Using nodatacow has virtually 
> eliminated the extra writes.  I is also responsible for a whopping 40x 
> increase in multi threaded random write performance! (2.5MB/sec -> 
> 95MB/sec).  See complete details in the new history graphs which I have 
> updated with a new baseline, a run with no csums, and a run with no 
> csums and no cow.
> 
> http://btrfs.boxacle.net/repository/raid/history/History.html
> 

Whoa.  So, we're on the right track, its good to know the btree locking
is scaling well enough for the main btree as well.

> nocow make massive differences on the random write workloads, while no 
> csums help the heavily threaded sequential workloads (sequential read 
> and create).

Ok, thanks again.

-chris


