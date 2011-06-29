From: "A. James Lewis" <james@fsck.co.uk>
Subject: Re: Mis-Design of Btrfs?
Date: Wed, 29 Jun 2011 11:47:49 +0100
Message-ID: <1309344469.22470.129.camel@cheyenne>
References: <20110623105337.GD3753@ethz.ch>
	 <20110627164637.377314e2@notabene.brown>  <4E0AF091.9030301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0AF091.9030301@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2011-06-29 at 10:29 +0100, Ric Wheeler wrote:
> On 06/27/2011 07:46 AM, NeilBrown wrote:
> > On Thu, 23 Jun 2011 12:53:37 +0200 Nico Schottelius
> > <nico-lkml-20110623@schottelius.org>  wrote:
> >
> >> Good morning devs,
> >>
> >> I'm wondering whether the raid- and volume-management-builtin of btrfs is
> >> actually a sane idea or not.
> >> Currently we do have md/device-mapper support for raid
> >> already, btrfs lacks raid5 support and re-implements stuff that
> >> has already been done.
> >>
> >> I'm aware of the fact that it is very useful to know on which devices
> >> we are in a filesystem. But I'm wondering, whether it wouldn't be
> >> smarter to generalise the information exposure through the VFS layer
> >> instead of replicating functionality:
> >>
> >> Physical:   USB-HD   SSD   USB-Flash          | Exposes information to
> >> Raid:       Raid1, Raid5, Raid10, etc.        | higher levels
> >> Crypto:     Luks                              |
> >> LVM:        Groups/Volumes                    |
> >> FS:         xfs/jfs/reiser/ext3               v
> >>
> >> Thus a filesystem like ext3 could be aware that it is running
> >> on a USB HD, enable -o sync be default or have the filesystem
> >> to rewrite blocks when running on crypto or optimise for an SSD, ...
> > I would certainly agree that exposing information to higher levels is a good
> > idea.  To some extent we do.  But it isn't always as easy as it might sound.
> > Choosing exactly what information to expose is the challenge.  If you lack
> > sufficient foresight you might expose something which turns out to be
> > very specific to just one device, so all those upper levels which make use of
> > the information find they are really special-casing one specific device,
> > which isn't a good idea.
> >
> >
> > However it doesn't follow that RAID5 should not be implemented in BTRFS.
> > The levels that you have drawn are just one perspective.  While that has
> > value, it may not be universal.
> > I could easily argue that the LVM layer is a mistake and that filesystems
> > should provide that functionality directly.
> > I could almost argue the same for crypto.
> > RAID1 can make a lot of sense to be tightly integrated with the FS.
> > RAID5 ... I'm less convinced, but then I have a vested interest there so that
> > isn't an objective assessment.
> >
> > Part of "the way Linux works" is that s/he who writes the code gets to make
> > the design decisions.   The BTRFS developers might create something truly
> > awesome, or might end up having to support a RAID feature that they
> > subsequently think is a bad idea.  But it really is their decision to make.
> >
> > NeilBrown
> >
> 
> One more thing to add here is that I think that we still have a chance to 
> increase the sharing between btrfs and the MD stack if we can get those changes 
> made. No one likes to duplicate code, but we will need a richer interface 
> between the block and file system layer to help close that gap.
> 
> Ric
> 
Is there a possibility that one could have a 3 disk RAID5 array, and
then add a 4th disk and then do a balance, growing the RAID5 onto 4
disks and gaining the space still with RAID5?  It seems that to be
consistent, BTRFS would have to do this.

If this is the case, then I think that the BTRFS implementation of RAID5
would have to be quite different to the MD implementation.

James.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


