From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: SSD Optimizations
Date: Sat, 13 Mar 2010 17:43:59 +0100
Message-ID: <20100313174359.ec81c8b7.skraw@ithnet.com>
References: <4B97F7CE.4030405@bobich.net>
	<4B9829B1.1020706@bobich.net>
	<20100311073853.GA26129@attic.humilis.net>
	<201003111159.58081.hka@qbs.com.pl>
	<20100311123103.34246e95.skraw@ithnet.com>
	<20100311143905.GA20569@attic.humilis.net>
	<20100311183506.adce61ee.skraw@ithnet.com>
	<20100311180017.GK6509@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: sander@humilis.net, Hubert Kario <hka@qbs.com.pl>,
	linux-btrfs@vger.kernel.org, Gordan Bobic <gordan@bobich.net>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100311180017.GK6509@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Mar 2010 13:00:17 -0500
Chris Mason <chris.mason@oracle.com> wrote:

> On Thu, Mar 11, 2010 at 06:35:06PM +0100, Stephan von Krawczynski wrote:
> > On Thu, 11 Mar 2010 15:39:05 +0100
> > Sander <sander@humilis.net> wrote:
> > 
> > > Stephan von Krawczynski wrote (ao):
> > > > Honestly I would just drop the idea of an SSD option simply because the
> > > > vendors implement all kinds of neat strategies in their devices. So in the end
> > > > you cannot really tell if the option does something constructive and not
> > > > destructive in combination with a SSD controller.
> > > 
> > > My understanding of the ssd mount option is also that the fs doens't try
> > > to do all kinds of smart (and potential expensive) things which make
> > > sense for rotating media to reduce seeks and the like.
> > > 
> > > 	Sander
> > 
> > Such an optimization sounds valid on first sight. But re-think closely: how
> > does the fs really know about seeks needed during some operation?
> 
> Well the FS makes a few assumptions (in the nonssd case).  First it
> assumes the storage is not a memory device.  If things would fit in
> memory we wouldn't need filesytems in the first place.

Ok, here is the bad news. This assumption everything from right to completely
wrong, and you cannot really tell the mainstream answer.
Two examples from opposite parts of the technology world:
- History: way back in the 80's there was a 3rd party hardware for C=1541
(floppy drive for C=64) that read in the complete floppy and served all
incoming requests from the ram buffer. So your assumption can already be wrong
for a trivial floppy drive from ancient times.
- Nowadays: being a linux installation today chances are that the matrix has
you. Quite a lot of installations are virtualized. So your storage is a virtual
one either, which means it is likely being a fs buffer from the host system,
i.e. RAM.
And sorry to say: "if things would fit in memory" you probably still need a fs
simply because there is no actual way to organize data (be it executable or
not) in RAM without a fs layer. You can't save data without an abstract file
data type. To have one accessible you need a fs.
Btw the other way round is as interesting: there is currently no fs for linux
that knows how to execute in place. Meaning if you really had only RAM and you
have a fs to organize your data it would be just logical to have ways to _not_
load data (in other parts of the RAM), but to use it in its original storage
(RAM-)space. 

> Then it assumes that adjacent blocks are cheap to read and blocks that
> are far away are expensive to read.  Given expensive raid controllers,
> cache, and everything else, you're correct that sometimes this
> assumption is wrong.

As already mentioned this assumption may be completely wrong even without a
raid controller, being within a virtual environment. Even far away blocks can
be one byte away in the next fs buffer of the underlying host fs (assuming
your device is in fact a file on the host;-).

>  But, on average seeking hurts.  Really a lot.

Yes, seeking hurts. But there is no way to know if there is seeking at all.
On the other hand, if your storage is a netblock device seeking on the server
is probably your smallest problem, compared to the network latency in between.
 
> We try to organize files such that files that are likely to be read
> together are found together on disk.  Btrfs is fairly good at this
> during file creation and not as good as ext*/xfs as files over
> overwritten and modified again and again (due to cow).

You are basically saying that btrfs perfectly organizes write-once devices ;-)

> If you turn mount -o ssd on for your drive and do a test, you might not
> notice much difference right away.  ssds tend to be pretty good right
> out of the box.  Over time it tends to help, but it is a very hard thing
> to benchmark in general.

Honestly, this sounds like "I give up" to me ;-)
You just said that generally it is "very hard to benchmark". Which means
"nobody can see or feel it in real world" in non-tech language.

Please understand that I am the last one critizing your and others' brillant
work and the time you spend for btrfs. Only I do believe that if you spent one
hour on some fs like glusterfs for every 10 hours you spend on btrfs you would
be both king and queen for the linux HA community :-)
(but probably unemployed, so I can't really beat you for it)
 
> -chris

-- 
Regards,
Stephan

