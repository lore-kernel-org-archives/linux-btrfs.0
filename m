From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH 0/6] Btrfs commit fixes, async subvol operations
Date: Mon, 25 Oct 2010 12:41:46 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1010251239080.7660@cobra.newdream.net>
References: <1288033662-21464-1-git-send-email-sage@newdream.net>
 <20101025192932.GG18818@think>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101025192932.GG18818@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 25 Oct 2010, Chris Mason wrote:
> These all look good to me and I'm pulling them in.

Great, thanks!

> > The last item is a change to SNAP_DESTROY to allow deletion of a 
> > snapshot when the user owns the subvol's root inode and the parent 
> > directory permissions are such that we would have allowed an rmdir(2).  
> > Goffredo Baroncelli posted a similar patch that replicates the rmdir(2) 
> > semantics completely (except for the empty directory check) by 
> > duplicating some VFS code.  Whether we want weaker semantics, duplicated 
> > code, or some new EXPORT_SYMBOLS is up to you I think.  Note that this 
> > is distinct from a similar patch (also from Goffredo) that allows 
> > rmdir(2) to remove an empty subvol; my goal is to allow a non-empty 
> > subvol to be deleted by a non-root user.  As long as I can do that, my 
> > daemon doesn't have to run as root and I'm a happy camper.  :)
> 
> Someone at the storage workshop mentioned that this subvol deletion
> trick is slightly stronger than rm -rf, to make it include the same
> level of permission checks would require testing all the directories in
> the tree for permissions.

I think that was me :)
 
> For now, could you please make a mount -o user_subvol_rm_allowed option?
> (or something similar with a better name).

Sure.  

Do you have a preference as far as what checks are implemented?  My patch 
implemented a simplified approximation of may_rmdir(); Goffredo's 
duplicated the vfs checks.  I guess I'm leaning toward the latter...

Thanks!
sage
