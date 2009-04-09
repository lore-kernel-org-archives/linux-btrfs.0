From: Josef Bacik <josef@redhat.com>
Subject: Re: Btrfs TODO
Date: Thu, 9 Apr 2009 14:35:25 -0400
Message-ID: <20090409183524.GF20769@unused.rdu.redhat.com>
References: <20090409162418.GC20769@unused.rdu.redhat.com> <49DE3ED0.4070206@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49DE3ED0.4070206@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 09, 2009 at 02:30:40PM -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Josef Bacik wrote:
> > Hello,
> >
> > Trying to put together a list of TODO items for btrfs so we can update
> the wiki
> > page fully.  So far these things are on the list
> >
> > * Proper ENOSPC handling
> > * O_DIRECT support (without checksumming)
> > * AIO support
> > * Subvolume quotas and inherited space usage information
> > * Snapshot removal
> > * QA Suite for automated regression testing
> > * Reserved space for online fsck and the ability to add storage so that a
> > * background extent allocation check can proceed
> > * Additional ioctls to set per-inode attributes (nodatacow, nodatasum,
> etc)
> >
> > So I think all of those are still true.  Things that I know are being
> worked on
> > are
> >
> > * async block group cacheing - me
> > * locking changes - Chris
> > * backref stuff - Yan
> >
> > Som other things off the top of my head are
> >
> > * a better way to cache block groups in general, for this I was
> thinking of a
> > 	bitmap or something like that per block group of free space
> > * space balancing.  this will likely need to wait on proper ENOSPC
> handling
> > * grub support :)
> 
> I'm doing some work in the area of more robust error handling. My patch
> set is a little stale now but I'm going to spend some time this week
> bringing it back to life.
>

Ahh yeah thats a good thing.  At some point I'd like to turn on all of the
"inject faults" crap and make sure we handle ENOMEM and such properly and such.
Thanks,

Josef 
