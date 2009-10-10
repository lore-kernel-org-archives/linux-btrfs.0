From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Re: Clone range ioctl
Date: Sat, 10 Oct 2009 16:26:34 -0300
Message-ID: <20091010192634.GE11559@blitiri.com.ar>
References: <20090926194617.GW7592@blitiri.com.ar> <20090929165122.GB2650@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090929165122.GB2650@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 29, 2009 at 12:51:22PM -0400, Chris Mason wrote:
> On Sat, Sep 26, 2009 at 04:46:20PM -0300, Alberto Bertogli wrote:
> > 
> > Hi!
> > 
> > Out of curiosity for btrfs, I'm modifying a project of mine
> > (http://blitiri.com.ar/p/libjio) to use the clone range ioctl, and I've got a
> > couple of questions. I thought this would be the place to ask them, I hope you
> > don't mind:
> > 
> > - Once the ioctl() returns successfully, is data supposed to be on the disk,
> >   or should I sync it manually (fdatasync()/sync_file_range())? From a quick
> >   peek at the code it seems the former, but it'd be nice to get confirmation.
> 
> Yes, when the ioctl is done the file is on disk.  This is more of an
> accident of the implementation than a requirement, but it isn't going to
> change.
> 
> > - I've hit a couple of bugs (2.6.31's fs/btrfs/file.c:528, for example);
> >   should I take a look and report them, or this code is not expected to work
> >   yet?
> 
> I think this one was fixed by Sage, if you pull from the btrfs-unstable
> git tree's master branch it should be resolved.

Just did, and the two bugs that I was hitting are now fixed.

Thanks a lot,
		Alberto

