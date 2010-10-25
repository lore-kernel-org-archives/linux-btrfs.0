From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/6] Btrfs commit fixes, async subvol operations
Date: Mon, 25 Oct 2010 15:29:32 -0400
Message-ID: <20101025192932.GG18818@think>
References: <1288033662-21464-1-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288033662-21464-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 25, 2010 at 12:07:36PM -0700, Sage Weil wrote:
> Hi Chris,
> 
> This is the extent of my current queue of Btrfs snapshot/subvol/commit 
> stuff. Most of these were posted several months ago.  Can be sent 
> upstream during this merge window?  Not having this functionality is 
> becoming a bit of a roadblock for our efforts to keep the Ceph data in a 
> consistent state.
> 
> These patches are also available from
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/sage/btrfs.git snap_ioctls
> 
> The first patch is strictly a bug fix for a deadlock in 
> btrfs_commit_transaction().
> 
> The next few patches are a repost (with a few minor revisions) of the 
> async snapshot/subvolume ioctls I originally posted last spring.  They 
> include:
> 
>  - Some async commit helper functions
>  - Start and wait sync ioctls, for initiating and waiting for a sync
>  - An ioctl to start a snapshot creation asynchronously, such that you 
>    don't have to wait for the full commit to disk.  The interface is cleaned
>    up a bit from the original version.
> 
> There is also a patch that changes the SNAP_DESTROY ioctl to not do a 
> commit before returning.  The rationale here is there is no obvious 
> reason (to me at least) why the snapshot removal should be on disk 
> before returning; rm(2) and unlink(2) certainly don't do that.  If the 
> user disagrees, they can call sync(2).  If you would prefer, I also have 
> a patch that introduces a new SNAP_DESTROY_ASYNC ioctl that doesn't 
> change any existing behavior.

These all look good to me and I'm pulling them in.

> 
> The last item is a change to SNAP_DESTROY to allow deletion of a 
> snapshot when the user owns the subvol's root inode and the parent 
> directory permissions are such that we would have allowed an rmdir(2).  
> Goffredo Baroncelli posted a similar patch that replicates the rmdir(2) 
> semantics completely (except for the empty directory check) by 
> duplicating some VFS code.  Whether we want weaker semantics, duplicated 
> code, or some new EXPORT_SYMBOLS is up to you I think.  Note that this 
> is distinct from a similar patch (also from Goffredo) that allows 
> rmdir(2) to remove an empty subvol; my goal is to allow a non-empty 
> subvol to be deleted by a non-root user.  As long as I can do that, my 
> daemon doesn't have to run as root and I'm a happy camper.  :)

Someone at the storage workshop mentioned that this subvol deletion
trick is slightly stronger than rm -rf, to make it include the same
level of permission checks would require testing all the directories in
the tree for permissions.

For now, could you please make a mount -o user_subvol_rm_allowed option?
(or something similar with a better name).

Thanks!

-chris
