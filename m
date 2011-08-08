From: Sage Weil <sage@newdream.net>
Subject: Re: Btrfs slowdown
Date: Mon, 8 Aug 2011 14:58:29 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1108081456290.6895@cobra.newdream.net>
References: <CAO47_-9BLKWUGDEuzaLqHSq9tZkAUaO8FMQEy1pPk9A2Hb+5AQ@mail.gmail.com>
 <1311623446-sup-8105@shiny> <CAO47_--KOyMdS-OP06cLpD+qTQ+gqGcw_DCPUrLOeypt5j_G4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	ceph-devel <ceph-devel@vger.kernel.org>
To: Christian Brunner <chb@muc.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAO47_--KOyMdS-OP06cLpD+qTQ+gqGcw_DCPUrLOeypt5j_G4g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Christian,

Are you still seeing this slowness?

sage


On Wed, 27 Jul 2011, Christian Brunner wrote:
> 2011/7/25 Chris Mason <chris.mason@oracle.com>:
> > Excerpts from Christian Brunner's message of 2011-07-25 03:54:47 -0400:
> >> Hi,
> >>
> >> we are running a ceph cluster with btrfs as it's base filesystem
> >> (kernel 3.0). At the beginning everything worked very well, but after
> >> a few days (2-3) things are getting very slow.
> >>
> >> When I look at the object store servers I see heavy disk-i/o on the
> >> btrfs filesystems (disk utilization is between 60% and 100%). I also
> >> did some tracing on the Cepp-Object-Store-Daemon, but I'm quite
> >> certain, that the majority of the disk I/O is not caused by ceph or
> >> any other userland process.
> >>
> >> When reboot the system(s) the problems go away for another 2-3 days,
> >> but after that, it starts again. I'm not sure if the problem is
> >> related to the kernel warning I've reported last week. At least there
> >> is no temporal relationship between the warning and the slowdown.
> >>
> >> Any hints on how to trace this would be welcome.
> >
> > The easiest way to trace this is with latencytop.
> >
> > Apply this patch:
> >
> > http://oss.oracle.com/~mason/latencytop.patch
> >
> > And then use latencytop -c for a few minutes while the system is slow.
> > Send the output here and hopefully we'll be able to figure it out.
> 
> I've now installed latencytop. Attached are two output files: The
> first is from yesterday and was created aproxematly half an hour after
> the boot. The second on is from today, uptime is 19h. The load on the
> system is already rising. Disk utilization is approximately at 50%.
> 
> Thanks for your help.
> 
> Christian
> 
