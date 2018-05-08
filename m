Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:2612 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755853AbeEHXio (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 19:38:44 -0400
Date: Wed, 9 May 2018 09:38:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH 0/76] vfs: 'views' for filesystems with more than
 one root
Message-ID: <20180508233840.GM10363@dastard>
References: <20180508180436.716-1-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180508180436.716-1-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2018 at 11:03:20AM -0700, Mark Fasheh wrote:
> Hi,
> 
> The VFS's super_block covers a variety of filesystem functionality. In
> particular we have a single structure representing both I/O and
> namespace domains.
> 
> There are requirements to de-couple this functionality. For example,
> filesystems with more than one root (such as btrfs subvolumes) can
> have multiple inode namespaces. This starts to confuse userspace when
> it notices multiple inodes with the same inode/device tuple on a
> filesystem.

Devil's Advocate - I'm not looking at the code, I'm commenting on
architectural issues I see here.

The XFS subvolume work I've been doing explicitly uses a superblock
per subvolume. That's because subvolumes are designed to be
completely independent of the backing storage - they know nothing
about the underlying storage except to share a BDI for writeback
purposes and write to whatever block device the remapping layer
gives them at IO time.  Hence XFS subvolumes have (at this point)
their own unique s_dev, on-disk format configuration, journal, space
accounting, etc. i.e. They are fully independent filesystems in
their own right, and as such we do not have multiple inode
namespaces per superblock.

So this doesn't sound like a "subvolume problem" - it's a "how do we
sanely support multiple independent namespaces per superblock"
problem. AFAICT, this same problem exists with bind mounts and mount
namespaces - they are effectively multiple roots on a single
superblock, but it's done at the vfsmount level and so the
superblock knows nothing about them.

So this kinda feel like there's still a impedence mismatch between
btrfs subvolumes being mounted as subtrees on the underlying root
vfsmount rather than being created as truly independent vfs
namespaces that share a superblock. To put that as a question: why
aren't btrfs subvolumes vfsmounts in their own right, and the unique
information subvolume information get stored in (or obtained from)
the vfsmount?

> In addition, it's currently impossible for a filesystem subvolume to
> have a different security context from it's parent. If we could allow
> for subvolumes to optionally specify their own security context, we
> could use them as containers directly instead of having to go through
> an overlay.

Again, XFS subvolumes don't have this problem. So really we need to
frame this discussion in terms of supporting multiple namespaces
within a superblock sanely, not subvolumes.

> I ran into this particular problem with respect to Btrfs some years
> ago and sent out a very naive set of patches which were (rightfully)
> not incorporated:
> 
> https://marc.info/?l=linux-btrfs&m=130074451403261&w=2
> https://marc.info/?l=linux-btrfs&m=130532890824992&w=2
> 
> During the discussion, one question did come up - why can't
> filesystems like Btrfs use a superblock per subvolume? There's a
> couple of problems with that:
> 
> - It's common for a single Btrfs filesystem to have thousands of
>   subvolumes. So keeping a superblock for each subvol in memory would
>   get prohibively expensive - imagine having 8000 copies of struct
>   super_block for a file system just because we wanted some separation
>   of say, s_dev.

That's no different to using individual overlay mounts for the
thousands of containers that are on the system. This doesn't seem to
be a major problem...

> - Writeback would also have to walk all of these superblocks -
>   again not very good for system performance.

Background writeback is backing device focussed, not superblock
focussed. It will only iterate the superblocks that have dirty
inodes on the bdi writeback lists, not all the superblocks on the
bdi. IOWs, this isn't a major problem except for sync() operations
that iterate superblocks.....

> - Anyone wanting to lock down I/O on a filesystem would have to
> freeze all the superblocks. This goes for most things related to
> I/O really - we simply can't afford to have the kernel walking
> thousands of superblocks to sync a single fs.

Not with XFS subvolumes. Freezing the underlying parent filesystem
will effectively stop all IO from the mounted subvolumes by freezing
remapping calls before IO. Sure, those subvolumes aren't in a
consistent state, but we don't freeze userspace so none of the
application data is ever in a consistent state when filesystems are
frozen.

So, again, I'm not sure there's /subvolume/ problem here. There's
definitely a "freeze heirarchy" problem, but that already exists and
it's something we talked about at LSFMM because we need to solve it
for reliable hibernation.

> It's far more efficient then to pull those fields we need for a
> subvolume namespace into their own structure.

I'm not convinced yet - it still feels like it's the wrong layer to
be solving the multiple namespace per superblock problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
