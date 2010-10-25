From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/6] Btrfs commit fixes, async subvol operations
Date: Mon, 25 Oct 2010 15:58:42 -0400
Message-ID: <20101025195842.GI18818@think>
References: <1288033662-21464-1-git-send-email-sage@newdream.net>
 <20101025192932.GG18818@think>
 <Pine.LNX.4.64.1010251239080.7660@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1010251239080.7660@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 25, 2010 at 12:41:46PM -0700, Sage Weil wrote:
> On Mon, 25 Oct 2010, Chris Mason wrote:
> > These all look good to me and I'm pulling them in.
> 
> Great, thanks!
> 
> > > The last item is a change to SNAP_DESTROY to allow deletion of a 
> > > snapshot when the user owns the subvol's root inode and the parent 
> > > directory permissions are such that we would have allowed an rmdir(2).  
> > > Goffredo Baroncelli posted a similar patch that replicates the rmdir(2) 
> > > semantics completely (except for the empty directory check) by 
> > > duplicating some VFS code.  Whether we want weaker semantics, duplicated 
> > > code, or some new EXPORT_SYMBOLS is up to you I think.  Note that this 
> > > is distinct from a similar patch (also from Goffredo) that allows 
> > > rmdir(2) to remove an empty subvol; my goal is to allow a non-empty 
> > > subvol to be deleted by a non-root user.  As long as I can do that, my 
> > > daemon doesn't have to run as root and I'm a happy camper.  :)
> > 
> > Someone at the storage workshop mentioned that this subvol deletion
> > trick is slightly stronger than rm -rf, to make it include the same
> > level of permission checks would require testing all the directories in
> > the tree for permissions.
> 
> I think that was me :)

Grin, two different people then ;)

>  
> > For now, could you please make a mount -o user_subvol_rm_allowed option?
> > (or something similar with a better name).
> 
> Sure.  
> 
> Do you have a preference as far as what checks are implemented?  My patch 
> implemented a simplified approximation of may_rmdir(); Goffredo's 
> duplicated the vfs checks.  I guess I'm leaning toward the latter...

Yes, lets duplicate the vfs checks.  Christoph just sat bolt upright in
whatever ski lift he's currently riding.

We should also make sure they do the subvol rm against the root of the
subvol (if that check isn't already done), none of the magic to resolve
the subvol based on any file inside it.  I don't want people to
accidentally think they are deleting a subdir and have it go higher up
into the directory tree.

Oh, and it shouldn't work on the root of the FS either ;)

-chris
