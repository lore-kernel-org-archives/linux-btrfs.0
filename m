From: Sage Weil <sage@newdream.net>
Subject: [PATCH 0/6] Btrfs commit fixes, async subvol operations
Date: Mon, 25 Oct 2010 12:07:36 -0700
Message-ID: <1288033662-21464-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

This is the extent of my current queue of Btrfs snapshot/subvol/commit 
stuff. Most of these were posted several months ago.  Can be sent 
upstream during this merge window?  Not having this functionality is 
becoming a bit of a roadblock for our efforts to keep the Ceph data in a 
consistent state.

These patches are also available from

	git://git.kernel.org/pub/scm/linux/kernel/git/sage/btrfs.git snap_ioctls

The first patch is strictly a bug fix for a deadlock in 
btrfs_commit_transaction().

The next few patches are a repost (with a few minor revisions) of the 
async snapshot/subvolume ioctls I originally posted last spring.  They 
include:

 - Some async commit helper functions
 - Start and wait sync ioctls, for initiating and waiting for a sync
 - An ioctl to start a snapshot creation asynchronously, such that you 
   don't have to wait for the full commit to disk.  The interface is cleaned
   up a bit from the original version.

There is also a patch that changes the SNAP_DESTROY ioctl to not do a 
commit before returning.  The rationale here is there is no obvious 
reason (to me at least) why the snapshot removal should be on disk 
before returning; rm(2) and unlink(2) certainly don't do that.  If the 
user disagrees, they can call sync(2).  If you would prefer, I also have 
a patch that introduces a new SNAP_DESTROY_ASYNC ioctl that doesn't 
change any existing behavior.

The last item is a change to SNAP_DESTROY to allow deletion of a 
snapshot when the user owns the subvol's root inode and the parent 
directory permissions are such that we would have allowed an rmdir(2).  
Goffredo Baroncelli posted a similar patch that replicates the rmdir(2) 
semantics completely (except for the empty directory check) by 
duplicating some VFS code.  Whether we want weaker semantics, duplicated 
code, or some new EXPORT_SYMBOLS is up to you I think.  Note that this 
is distinct from a similar patch (also from Goffredo) that allows 
rmdir(2) to remove an empty subvol; my goal is to allow a non-empty 
subvol to be deleted by a non-root user.  As long as I can do that, my 
daemon doesn't have to run as root and I'm a happy camper.  :)

If anybody has any questions or issues with any of this, please let me 
know so I can revise the patches accordingly.

Thanks!
sage

---


Sage Weil (6):
  Btrfs: fix deadlock in btrfs_commit_transaction
  Btrfs: async transaction commit
  Btrfs: add START_SYNC, WAIT_SYNC ioctls
  Btrfs: add SNAP_CREATE_ASYNC ioctl
  Btrfs: make SNAP_DESTROY async
  Btrfs: allow subvol deletion by owner

 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/disk-io.c     |    1 +
 fs/btrfs/ioctl.c       |  152 +++++++++++++++++++++++++++++++++++-----
 fs/btrfs/ioctl.h       |    9 +++
 fs/btrfs/transaction.c |  183 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/transaction.h |    4 +
 security/security.c    |    1 +
 7 files changed, 326 insertions(+), 25 deletions(-)

