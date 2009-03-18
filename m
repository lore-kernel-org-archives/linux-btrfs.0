From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs experimental branch updates
Date: Tue, 17 Mar 2009 21:18:02 -0400
Message-ID: <1237339082.31273.49.camel@think.oraclecorp.com>
References: <1236959774.17095.3.camel@think.oraclecorp.com>
	 <49BAE39F.8050102@austin.ibm.com>
	 <1236994421.17095.7.camel@think.oraclecorp.com>
	 <49BD12E4.4070505@austin.ibm.com>
	 <1237253089.31273.4.camel@think.oraclecorp.com>
	 <49C00EB8.6050200@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49C00EB8.6050200@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-03-17 at 15:57 -0500, Steven Pratt wrote:
> Chris Mason wrote:
> > On Sun, 2009-03-15 at 09:38 -0500, Steven Pratt wrote:
> >   
> >>> Thanks for running this, but the main performance fixes for your test
> >>> are still in testing locally.  One thing that makes a huge difference on
> >>> the random write run is to mount -o ssd.
> >>>
> >>>   
> >>>       
> >> Tried a run with -o ssd on the raid system. It made some minor 
> >> improvements in random write performance. Helps more on odirect, but 
> >> mainly at the 16thread count. Single and 128 threads it doesn't make 
> >> much difference.
> >>
> >> Results syncing now to history boxacle
> >> http://btrfs.boxacle.net/repository/raid/history/History.html
> >>     
> >
> > Well, still completely different from my test rig ;)  For the random
> > write run, yours runs at 580 trans/sec for btrfs and mine is going along
> > at 8000 trans/sec.
> >   
> That is odd.  However, I think I have found 1 factor.  In rerunning with 
> blktrace and sysrq an interesting thing happened.  The results got a lot 
> faster.  What I did was just run the 128 thread odirect random write 
> test.  Instead of 2.8MB/sec, I got 17MB/sec. Still far below the 100+ of 
> ext4 and JFS, but one heck of a difference.  Here is what I think is 
> going on.  We make use of a flag in FFSB to reuse the existing fileset 
> if the fileset meets the setup criteria exactly.  For the test I am 
> running that is 1024 100MB files.  Since all of the random write test 
> are doing overwrites within the file, the file sizes do not change and 
> therefore the fileset is valid for reuse.  

Oh! In that case you're stuck waiting to cache the extents already used
in a block group.  At least I hope that's what sysrq-w will show us.
The first mods to a block group after a mount are slow while we read in
the free extents.

-chris


