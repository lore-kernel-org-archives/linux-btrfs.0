From: Chris Mason <chris.mason@oracle.com>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 13:00:17 -0500
Message-ID: <20100311180017.GK6509@think>
References: <4B97F7CE.4030405@bobich.net>
 <4B9829B1.1020706@bobich.net>
 <20100311073853.GA26129@attic.humilis.net>
 <201003111159.58081.hka@qbs.com.pl>
 <20100311123103.34246e95.skraw@ithnet.com>
 <20100311143905.GA20569@attic.humilis.net>
 <20100311183506.adce61ee.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sander@humilis.net, Hubert Kario <hka@qbs.com.pl>,
	linux-btrfs@vger.kernel.org, Gordan Bobic <gordan@bobich.net>
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100311183506.adce61ee.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 11, 2010 at 06:35:06PM +0100, Stephan von Krawczynski wrote:
> On Thu, 11 Mar 2010 15:39:05 +0100
> Sander <sander@humilis.net> wrote:
> 
> > Stephan von Krawczynski wrote (ao):
> > > Honestly I would just drop the idea of an SSD option simply because the
> > > vendors implement all kinds of neat strategies in their devices. So in the end
> > > you cannot really tell if the option does something constructive and not
> > > destructive in combination with a SSD controller.
> > 
> > My understanding of the ssd mount option is also that the fs doens't try
> > to do all kinds of smart (and potential expensive) things which make
> > sense for rotating media to reduce seeks and the like.
> > 
> > 	Sander
> 
> Such an optimization sounds valid on first sight. But re-think closely: how
> does the fs really know about seeks needed during some operation?

Well the FS makes a few assumptions (in the nonssd case).  First it
assumes the storage is not a memory device.  If things would fit in
memory we wouldn't need filesytems in the first place.

Then it assumes that adjacent blocks are cheap to read and blocks that
are far away are expensive to read.  Given expensive raid controllers,
cache, and everything else, you're correct that sometimes this
assumption is wrong.  But, on average seeking hurts.  Really a lot.

We try to organize files such that files that are likely to be read
together are found together on disk.  Btrfs is fairly good at this
during file creation and not as good as ext*/xfs as files over
overwritten and modified again and again (due to cow).

If you turn mount -o ssd on for your drive and do a test, you might not
notice much difference right away.  ssds tend to be pretty good right
out of the box.  Over time it tends to help, but it is a very hard thing
to benchmark in general.

-chris
