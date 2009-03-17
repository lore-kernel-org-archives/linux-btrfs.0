From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs experimental branch updates
Date: Mon, 16 Mar 2009 21:24:49 -0400
Message-ID: <1237253089.31273.4.camel@think.oraclecorp.com>
References: <1236959774.17095.3.camel@think.oraclecorp.com>
	 <49BAE39F.8050102@austin.ibm.com>
	 <1236994421.17095.7.camel@think.oraclecorp.com>
	 <49BD12E4.4070505@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49BD12E4.4070505@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-03-15 at 09:38 -0500, Steven Pratt wrote:
> > Thanks for running this, but the main performance fixes for your test
> > are still in testing locally.  One thing that makes a huge difference on
> > the random write run is to mount -o ssd.
> >
> >   
> Tried a run with -o ssd on the raid system. It made some minor 
> improvements in random write performance. Helps more on odirect, but 
> mainly at the 16thread count. Single and 128 threads it doesn't make 
> much difference.
> 
> Results syncing now to history boxacle
> http://btrfs.boxacle.net/repository/raid/history/History.html

Well, still completely different from my test rig ;)  For the random
write run, yours runs at 580 trans/sec for btrfs and mine is going along
at 8000 trans/sec.

The part that confuses me is that you seem to have some big gaps where
just a single CPU is stuck in IO wait, and not much CPU time is in use.

Do you happen to have the blktrace logs for any of the btrfs runs?  I'd
be interested in a script that did sysrq-w every 5s and captured the
output.

-chris




