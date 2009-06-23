From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: Phoronix article slaming BTRFS
Date: Tue, 23 Jun 2009 18:19:35 +0200
Message-ID: <20090623181935.2b01c17d.skraw@ithnet.com>
References: <loom.20090623T024010-331@post.gmane.org>
	<20090623144123.GB19276@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Mike Ramsey <MikeJRamsey@comcast.net>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090623144123.GB19276@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 23 Jun 2009 10:41:23 -0400
Chris Mason <chris.mason@oracle.com> wrote:

> On Tue, Jun 23, 2009 at 02:51:41AM +0000, Mike Ramsey wrote:
> > I ran across this article "Testing Out The SSD Mode In Btrfs". 
> > http://www.phoronix.com/scan.php?page=article&item=btrfs_ssd_mode&num=1
> > 
> > At first I was disappointed.  It gave a very disappointing set of benchmarks.
> > However, a close reading revealed this:
> > 
> > "With the OCZ Vertex SATA 2.0 SSD, which we used for this testing today, had its
> > write caching always enabled. When attempting to disable the write cache through
> > hdparm it would remain enabled regardless and when using sdparm it would report
> > change_mode_page: failed setting page: Caching (SBC)."
> > 
> > This invalidates the benchmark! Disabling the write cache would yield a 2X
> > improvement.  
> 
> Hmmm, I'm not sure I follow.  I'm guessing the write cache is critical
> on the vertex drives because they are using it to queue up writes into
> large enough units to fill an entire erasure block at once.  If they
> took the time to put 64MB of the stuff in there, it probably does
> something good ;)
> 
> Jens Axboe tried to reproduce the phoronix results on his ocz drive, and
> generally found that each run was slower than the last regardless of
> which mount options were used.  This isn't entirely surprising, but it
> did make it very difficult to nail down good or bad performance.
> 
> -chris

Can someone explain to a quite naive person like me why one should be
interested in SSDs that perform worse than Intel? Why shouldn't I just buy the
best-performing product? This is a moving market, and it is obvious that the
bad performers will be left behind...
If you really care to fiddle with ssd options then use a real bad hw for
testing the performance - take an ide interface and connect a CF card.
This is a common setup for embedded usage and frequently used. Everything in
between CF and Intel will just be dead before your fs options will become
really stable. So why loose time with it?

-- 
Regards,
Stephan

