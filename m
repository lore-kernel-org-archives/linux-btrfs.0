Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:1373 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933733AbeEIGlI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 02:41:08 -0400
Date: Wed, 9 May 2018 16:41:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH 0/76] vfs: 'views' for filesystems with more than
 one root
Message-ID: <20180509064103.GP10363@dastard>
References: <20180508180436.716-1-mfasheh@suse.de>
 <20180508233840.GM10363@dastard>
 <e6698201-a4a6-2146-d4c9-9e26c18ad828@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e6698201-a4a6-2146-d4c9-9e26c18ad828@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2018 at 10:06:44PM -0400, Jeff Mahoney wrote:
> On 5/8/18 7:38 PM, Dave Chinner wrote:
> > On Tue, May 08, 2018 at 11:03:20AM -0700, Mark Fasheh wrote:
> >> Hi,
> >>
> >> The VFS's super_block covers a variety of filesystem functionality. In
> >> particular we have a single structure representing both I/O and
> >> namespace domains.
> >>
> >> There are requirements to de-couple this functionality. For example,
> >> filesystems with more than one root (such as btrfs subvolumes) can
> >> have multiple inode namespaces. This starts to confuse userspace when
> >> it notices multiple inodes with the same inode/device tuple on a
> >> filesystem.
> > 
> > Devil's Advocate - I'm not looking at the code, I'm commenting on
> > architectural issues I see here.
> > 
> > The XFS subvolume work I've been doing explicitly uses a superblock
> > per subvolume. That's because subvolumes are designed to be
> > completely independent of the backing storage - they know nothing
> > about the underlying storage except to share a BDI for writeback
> > purposes and write to whatever block device the remapping layer
> > gives them at IO time.  Hence XFS subvolumes have (at this point)
> > their own unique s_dev, on-disk format configuration, journal, space
> > accounting, etc. i.e. They are fully independent filesystems in
> > their own right, and as such we do not have multiple inode
> > namespaces per superblock.
> 
> That's a fundamental difference between how your XFS subvolumes work and
> how btrfs subvolumes do.

Yup, you've just proved my point: this is not a "subvolume problem";
but rather a "multiple namespace per root" problem.

> There is no independence among btrfs
> subvolumes.  When a snapshot is created, it has a few new blocks but
> otherwise shares the metadata of the source subvolume.  The metadata
> trees are shared across all of the subvolumes and there are several
> internal trees used to manage all of it.

I don't need btrfs 101 stuff explained to me. :/

> a single transaction engine.  There are housekeeping and maintenance
> tasks that operate across the entire file system internally.  I
> understand that there are several problems you need to solve at the VFS
> layer to get your version of subvolumes up and running, but trying to
> shoehorn one into the other is bound to fail.

Actually, the VFS has provided everything I need for XFS subvolumes
so far without requiring any sort of modifications. That's the
perspective I'm approaching this from - if the VFS can do what we
need for XFS subvolumes, as well as overlay (which are effectively
VFS-based COW subvolumes), then lets see if we can make that work
for btrfs too.

> > So this doesn't sound like a "subvolume problem" - it's a "how do we
> > sanely support multiple independent namespaces per superblock"
> > problem. AFAICT, this same problem exists with bind mounts and mount
> > namespaces - they are effectively multiple roots on a single
> > superblock, but it's done at the vfsmount level and so the
> > superblock knows nothing about them.
> 
> In this case, you're talking about the user-visible file system
> hierarchy namespace that has no bearing on the underlying file system
> outside of per-mount flags.

Except that it tracks and provides infrastructure that allows user
visible  "multiple namespace per root" constructs. Subvolumes - as a
user visible namespace construct - are little different to bind
mounts in behaviour and functionality. 

How the underlying filesystem implements subvolumes is really up to
the filesystem, but we should be trying to implement a clean model
for "multiple namespaces on a single root" at the VFS so we have
consistent behaviour across all filesystems that implement similar
functionality.

FWIW, bind mounts and overlay also have similar inode number
namespace problems to what Mark describes for btrfs subvolumes.
e.g. overlay recently introduce the "xino" mount option to separate
the user presented inode number namespace for overlay inode from the
underlying parent filesystem inodes. How is that different to btrfs
subvolumes needing to present different inode number namespaces from
the underlying parent?

This sort of "namespace shifting" is needed for several different
pieces of information the kernel reports to userspace. The VFS
replacement for shiftfs is an example of this. So is inode number
remapping. I'm sure there's more.

My point is that if we are talking about infrastructure to remap
what userspace sees from different mountpoint views into a
filesystem, then it should be done above the filesystem layers in
the VFS so all filesystems behave the same way. And in this case,
the vfsmount maps exactly to the "fs_view" that Mark has proposed we
add to the superblock.....

> It makes sense for that to be above the
> superblock because the file system doesn't care about them.  We're
> interested in the inode namespace, which for every other file system can
> be described using an inode and a superblock pair, but btrfs has another
> layer in the middle: inode -> btrfs_root -> superblock. 

Which seems to me to be irrelevant if there's a vfsmount per
subvolume that can hold per-subvolume information.

> > So this kinda feel like there's still a impedence mismatch between
> > btrfs subvolumes being mounted as subtrees on the underlying root
> > vfsmount rather than being created as truly independent vfs
> > namespaces that share a superblock. To put that as a question: why
> > aren't btrfs subvolumes vfsmounts in their own right, and the unique
> > information subvolume information get stored in (or obtained from)
> > the vfsmount?
> 
> Those are two separate problems.   Using a vfsmount to export the
> btrfs_root is on my roadmap.  I have a WIP patch set that automounts the
> subvolumes when stepping into a new one, but it's to fix a longstanding
> UX wart.

IMO that's more than a UX wart - th elack of vfsmounts for internal
subvolume mount point traversals could be considered the root cause
of the issues we are discussing here. Extending the mounted
namespace should trigger vfs mounts, not be hidden deep inside the
filesystem. Hence I'd suggest this needs changing before anything
else....

> >> During the discussion, one question did come up - why can't
> >> filesystems like Btrfs use a superblock per subvolume? There's a
> >> couple of problems with that:
> >>
> >> - It's common for a single Btrfs filesystem to have thousands of
> >>   subvolumes. So keeping a superblock for each subvol in memory would
> >>   get prohibively expensive - imagine having 8000 copies of struct
> >>   super_block for a file system just because we wanted some separation
> >>   of say, s_dev.
> > 
> > That's no different to using individual overlay mounts for the
> > thousands of containers that are on the system. This doesn't seem to
> > be a major problem...
> 
> Overlay mounts are indepedent of one another and don't need coordination
> among them.  The memory usage is relatively unimportant.  The important
> part is having a bunch of superblocks that all correspond to the same
> resources and coordinating them at the VFS level.  Your assumptions
> below follow how your XFS subvolumes work, where there's a clear
> hierarchy between the subvolumes and the master filesystem with a
> mapping layer between them.  Btrfs subvolumes have no such hierarchy.
> Everything is shared. 

Yup, that's the impedence mismatch between the VFS infrastructure
and btrfs that I was talking about. What I'm trying to communicate
is that I think the proposal is attacking the impedence mismatch
from the wrong direction.

i.e. The proposal is to modify btrfs code to propagate stuff that
btrfs needs to know to deal with it's internal "everything is
shared" problems up into the VFS where it's probably not useful to
anything other than btrfs. We already have the necessary construct
in the VFS - I think we should be trying to use the information held
by the generic VFS infrastructure to solve the solve the specific
btrfs issue at hand....

> So while we could use a writeback hierarchy to
> merge all of the inode lists before doing writeback on the 'master'
> superblock, we'd gain nothing by it.  Handling anything involving
> s_umount with a superblock per subvolume would be a nightmare.
> Ultimately, it would be a ton of effort that amounts to working around
> the VFS instead of with it.

I'm not suggesting that btrfs needs to use a superblock per
subvolume. Please don't confuse my statements along the lines of
"this doesn't seem to be a problem for others" with "you must change
btrfs to do this". I'm just saying that the problems arising from
using a superblock per subvolume are not as dire as is being
implied.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
