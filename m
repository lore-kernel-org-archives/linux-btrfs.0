From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Honest timeline for btrfsck
Date: Tue, 17 Jan 2012 20:13:57 -0500
Message-ID: <20120118011357.GO3658@shiny>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
 <1312404713-sup-6548@shiny>
 <loom.20110818T030824-742@post.gmane.org>
 <1313700115-sup-2457@shiny>
 <jf42r4$fua$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: David Summers <btrfs@summers5913.freeserve.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jf42r4$fua$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2012 at 03:07:16PM +0000, David Summers wrote:
> On 18/08/11 21:50, Chris Mason wrote:
> >Excerpts from Yalonda Gishtaka's message of 2011-08-17 21:09:37 -0400:
> >>Chris Mason<chris.mason<at>  oracle.com>  writes:
> >>
> >>>
> >>>Aside from making sure the kernel code is stable, btrfsck is all I'm
> >>>working on right now.  I do expect a release in the next two weeks that
> >>>can recover your data (and many others).
> >>>
> >>>Thanks,
> >>>Chris
> >>>--
> >>
> >>
> >>Chris,
> >>
> >>We're all on the edge of our seats.  Can you provide an updated ETA on the
> >>release of the first functional btrfsck tool?  No pressure or anything ;)
> >
> >Hi everyone,
> >
> >I've been working non-stop on this.  Currently fsck has four parts:
> >
> >1) mount -o recovery mode.  I've posted smaller forms of these patches
> >in the past that bypass log tree replay.  The new versions have code to
> >create stub roots for trees that can't be read (like the extent
> >allocation tree) and will allow the mount to proceed.
> >
> >2) fsck that scans for older roots.  This takes advantage of older
> >copies of metadata to look for consistent tree roots on disk.  The
> >downside is that it is currently very slow.  I'm trying to speed it up
> >by limiting the search to only the metadata block groups and a few other
> >tricks.
> >
> >3) fsck that fixes the extent allocation tree and the chunk tree.  This
> >is where I've been spending most of my time.  The problem is that it
> >tends to recover some filesystems and badly break others.  While I'm
> >fixing up the corner cases that work poorly, I'm adding an undo log to
> >the fsck code so that you can get the FS back into its original state if
> >you don't like the result of the fsck.
> >
> >4) The rest of the corruptions can be dealt with fairly well from the
> >kernel.  I have a series of patches to make the extent allocation tree
> >less strict about reference counts and other rules, basically allowing
> >the FS to limp along instead of crash.
> >
> >These four things together are basically my minimal set of features
> >required for fedora and our own internal projects at Oracle to start
> >treating us as production filesystem.
> >
> >There are always bugs to fix, and I have #1 and #2 mostly ready.  I had
> >hoped to get #1 out the door before I left on vacation and I still might
> >post it tonight.
> >
> 
> Just checking my reading on where we are is correct.
> 
> 1&2 have been done?
> 
> Whats the progress on 3&4 - is Chris the only one working on these,
> or are others active?

People have already started picking up #4, fujitsu had some patches in
this direction that we'll keep developing with.

I stepped back to add some directory metadata fixups as well to the
basic fsck tool.  I had thought I could easily do it all from the
kernel, but sometimes the userland side really is easier.

-chris

