From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Kernel BUG on mounting BtrFS / after reboot
Date: Thu, 18 Feb 2010 15:48:43 -0500
Message-ID: <20100218204843.GW10559@think>
References: <loom.20100212T220341-877@post.gmane.org>
 <20100217141813.GH29430@think>
 <loom.20100218T013258-629@post.gmane.org>
 <20100218150238.GL10559@think>
 <loom.20100218T183230-637@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alex Elsayed <eternaleye@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20100218T183230-637@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2010 at 05:38:22PM +0000, Alex Elsayed wrote:
> Chris Mason <chris.mason <at> oracle.com> writes:
> 
> > 
> > Ugh ok.  The first thing I'd like to do is give you a patch to
> > completely disable the tree log replay and give you the chance to backup
> > critical data.
> > 
> > Do you already have a backup of the critical things on this drive?  The
> > problem you're hitting is that tree-logging code is trying to replay an
> > fsync of a file, but it can't find the file to replay.  This could be a
> > small and localized corruption or it could be a larger problem.  We'll
> > have to fix things one at a time to figure it out.
> > 
> > The easiest way to move forward would be to save a complete copy of the
> > FS with dd, but that's probably not very easy given the size.
> > 
> > -chris
> 
> Well, I ran badblocks on the drive, and it was happily silent, so that's a good 
> sign. I alo attached btrfsck output upthread, which says that there are 44 
> inodes with errors. Unfortunately, I don't really have a drive big enough to 
> back up to. I may be able to borrow one from a friend, though.

I think the btrfsck output is missing.  It sounds like we'll survive if
we just skip this part of the log replay.  I'll cook a patch based on
the btrfsck output.

-chris
