From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs-delalloc - threaded?
Date: Tue, 22 Nov 2011 09:47:44 -0500
Message-ID: <20111122144744.GI28259@shiny>
References: <CALjZLS5iA1TVJCVWSpE+Xg5hG_E1c+LVrFz2EJK2b=Xc7MQw_Q@mail.gmail.com>
 <slrnjcncff.cqt.stephane.chazelas@spam.is.invalid>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <slrnjcncff.cqt.stephane.chazelas@spam.is.invalid>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 22, 2011 at 02:30:07PM +0000, Stephane CHAZELAS wrote:
> 2011-09-6, 11:21(-05), Andrew Carlson:
> > I was doing some testing with writing out data to a BTFS filesystem
> > with the compress-force option.  With 1 program running, I saw
> > btfs-delalloc taking about 1 CPU worth of time, much as could be
> > expected.  I then started up 2 programs at the same time, writing data
> > to the BTRFS volume.  btrfs-delalloc still only used 1 CPU worth of
> > time.  Is btrfs-delalloc threaded, to where it can use more than 1 CPU
> > worth of time?  Is there a threshold where it would start using more
> > CPU?
> [...]
> 
> Hiya,
> 
> I observe the same here. The bottleneck when writing data
> sequencially seems to be that btrfs-delalloc using 100% of the
> time of one CPU.

The compression is spread out to multiple CPUs.  Using zlib on my 4 cpu
box, I get 4 delalloc threads working on two concurrent dds.

The thread hand off is based on the amount of work queued up to each
thread, and you're probably just below the threshold where it kicks off
another one.  Are you using lzo or zlib? 

What is the workload you're using?  We can make the compression code
more aggressive at fanning out.

-chris
