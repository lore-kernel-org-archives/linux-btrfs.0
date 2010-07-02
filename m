From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Copy/move btrfs volume
Date: Thu, 1 Jul 2010 21:29:33 -0400
Message-ID: <20100702012933.GB15319@think>
References: <i0hqkk$r4h$1@dough.gmane.org>
 <AANLkTin1O6Oa7oq4nFMfNhv4N5FWCko7bcuTMoR5Xkob@mail.gmail.com>
 <i0huf7$98a$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i0huf7$98a$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 01, 2010 at 11:33:59AM +0000, Lubos Kolouch wrote:
> Daniel J Blueman, Thu, 01 Jul 2010 12:26:10 +0100:
> >> What is the correct way to do this?
> > 
> > The only way to do this preserving duplication is to use hardlinks
> > between duplicated files (which reference counts the inode), and use
> > 'rsync -H'.
> > 
> > Dan
> 
> But when the files are on different snaphots, does rsync see them as 
> hardlinked?
> 
> A scenario - I have raid5 of say, 1TB HDDs. It contains many snapshots.
> Then, few years later, new machine is bought and there are, say, 5TB 
> discs.
> 
> So I need to transfer the btrfs volume to the new machine. 
> 
> But how to do it so that it looks the *same*, ie. the same snapshots?
> I could of course write a custom script to create the subvolume, rsync 
> the files, create snapshot, rsync files, etc,
> 
> but it would be nice if the btrfs toolset supports this by default...

This is definitely something I'm looking to add.  The btrfs-progs git
tree has some code that allows userland to walk the btrees and detect
the duplicate files.  But this is just a building block needed for the
full backup program.

Instead of hard links, it is possible to use reflinks with cp, which
uses the cloning ioctl.

-chris
