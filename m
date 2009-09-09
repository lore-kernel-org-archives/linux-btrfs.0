From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs csum failed on git .pack file
Date: Wed, 9 Sep 2009 07:19:55 -0400
Message-ID: <20090909111955.GA3473@think>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de>
 <20090908200041.GF18599@kernel.dk>
 <20090908202211.GA1901@phenom2.trippelsdorf.de>
 <20090908203214.GH18599@kernel.dk>
 <20090909065533.GA2861@phenom2.trippelsdorf.de>
 <20090909070141.GL18599@kernel.dk>
 <6278d2220909090118o6cdadb38ic38f2991d4fd1e10@mail.gmail.com>
 <20090909082636.GP18599@kernel.dk>
 <6278d2220909090137k68d23db8p169c3a83d37d2a95@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-btrfs@vger.kernel.org
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6278d2220909090137k68d23db8p169c3a83d37d2a95@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 09, 2009 at 09:37:42AM +0100, Daniel J Blueman wrote:
> >>
> >> http://www.ocztechnologyforum.com/forum/showthread.php?t=57516
> >
> > The issue is pretty much moot at this point, since OCZ support were not
> > really interested in providing any sort of real technical support to
> > find out what really caused this issue. My main worry was reliability of
> > these cheaper SSD drives, and that worry is still not resolved. If you
> > read the blog entries, I do comment on the apparently scary basic bugs
> > taht are still being fixed on the Indilinx controllers. I do expect some
> > basic level of data integrity from a consumer product and at least some
> > interest in resolving weird corruption issues if things go wrong. Since
> > OCZ cannot provide anything like that, I have a hard time recommending
> > these drives for anything but very casual use. Fast, cheap, reliable.
> > Pick any two.
> >
> > My drive was running 1.10 at the time of the problem.
> 
> It looks like we need a small tool which performs patterned block I/O
> to the device, updating a checksum as it goes, and performing
> integrity sweeps at intervals, lower level than fsx. It must be
> trusted or not.
> 
> I had a problem like this with nVidia CK804/MCP55 chipsets corrupting
> data under a triple-edge case workload.

Well, just use git ;)  Apply a bunch of patches (say the mm tree) with
guilt and repack in a loop.

-chris

