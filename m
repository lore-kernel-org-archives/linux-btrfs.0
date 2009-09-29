From: Chris Mason <chris.mason@oracle.com>
Subject: Re: yum upgrade on btrfs very slow
Date: Tue, 29 Sep 2009 09:25:38 -0400
Message-ID: <20090929132538.GN6405@think>
References: <20090928121827.GA15930@mother.pipebreaker.pl>
 <20090928133543.GB6405@think>
 <20090929061822.GB15930@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Torcz <tomek@pipebreaker.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090929061822.GB15930@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 29, 2009 at 08:18:22AM +0200, Tomasz Torcz wrote:
> On Mon, Sep 28, 2009 at 09:35:43AM -0400, Chris Mason wrote:
> > On Mon, Sep 28, 2009 at 02:18:27PM +0200, Tomasz Torcz wrote:
> > > 
> > >   Hi,
> > > 
> > >  I'm using btrfs as rootfs on my Fedora 12 (rawhide) test system.
> > > Every yum activity is very slow, like 15 minutes for installation of 11
> > > packages 25MB in size. Kernel is 2.6.31.1-48.fc12.x86_64, btrfs-progs-0.19-7.fc12.x86_64.
> > > Hardware is pentium 4 3.0 GHz (Hyperthreading, 64 bit), with single IDE disk 
> > > on Intel ICH controller.
> > 
> > You're doing quite a lot of reads, and some writes.  Could you please
> > capture the output of sysrq-w at 5s intervals during the upgrade?
> 
>   It got quite big (over 100 KiB, over 1 MiB after unpacking), so I
> put it at http://pipebreaker.pl/dump/sysrq-w_every_5_sec.txt.bz2

Ok, you've got 158 sysrq-w runs in here, and 119 of them involve fsync.
This is good because it is what Josef expected the problem to be.

The first thing I would try is mount -o ssd.  I think what is happening
is that we are seeking around while fsyncing files.  mount -o ssd isn't
really the right long term answer but it will tell us if I've got it
right.

If that works, I'd try the code in the master branch of btrfs-unstable.
This has a change that makes the allocator a little smarter, even
without mount -o ssd.

If you're comparing w/ext3 and wondering why btrfs is sooooooo much
slower it might be because btrfs has barriers on by default and ext3
doesn't.  You could mount -o nobarrier for btrfs or mount -o barrier=1
for ext3 for a proper comparison.

(Assuming your dmesg doesn't have messages from btrfs about disabling
barriers).

-chris

