From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 00/21] [RFC] Btrfs: restriper
Date: Tue, 23 Aug 2011 23:01:41 +0300
Message-ID: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch series adds an initial implementation of restriper (it's a
clever name for relocation framework that allows to do selective profile
changing and selective balancing with some goodies like pausing/resuming
and reporting progress to the user.
 
Profile changing is global (per-FS) so far, per-subvolume profiles
require some discussion and can be implemented in future.  This is a RFC
so some features/problems are not yet implemented/resolved.  The current
TODO list is as follows:

1) do pause/cancel via trans commit instead of waiting for the current
chunk to be fully relocated

2) fix problems with left-over chunks (the ones we were being relocating
to when the crash occured, this is going to become a bigger problem when
item 1 is done

3) fix remount problems (get rid of deadlocks that occur on remount
while relocating, stop restriper on remounts)

4) issue a discard on removed chunks - 1 GiB+ discards can be a big deal

There is also a couple of problems related to profile changing and
resuming that I'm working on right now.  But the basic infrastructure is
all there and is ready for reviewing.

This patchset deprecates Hugo's "Balance management" patch series.
Originally this was supposed to be just a profile changing thing merged
with those patches, but the merge turned out to be a complete rewrite.
The filters part was rewritten to be per-chunk-type and the management
part was thrown away because we now store an item to disk, there is the
difference between pausing and cancelling, locking is different, etc.
I'm happy to integrate any ideas that got dropped as a result of this.

Thanks to Arne who did an early review and Chris for overall guidance.
Any comments/suggestions are appreciated.  The series is on top of
3.1-rc3, available at:

git://github.com/idryomov/btrfs-unstable.git restriper-rfc

Thanks,

		Ilya


Ilya Dryomov (21):
  Btrfs: get rid of *_alloc_profile fields
  Btrfs: introduce masks for chunk type and profile
  Btrfs: add BTRFS_AVAIL_ALLOC_BIT_SINGLE bit
  Btrfs: make avail_*_alloc_bits fields dynamic
  Btrfs: add basic restriper infrastructure
  Btrfs: implement online profile changing
  Btrfs: add basic infrastructure for selective balancing
  Btrfs: soft profile changing mode (aka soft convert)
  Btrfs: profiles filter
  Btrfs: usage filter
  Btrfs: devid filter
  Btrfs: devid subset filter
  Btrfs: virtual address space subset filter
  Btrfs: save restripe parameters to disk
  Btrfs: recover restripe on mount
  Btrfs: allow for cancelling restriper
  Btrfs: allow for pausing restriper
  Btrfs: allow for resuming restriper after it was paused
  Btrfs: add skip_restripe mount option
  Btrfs: get rid of btrfs_balance() function
  Btrfs: add restripe progress reporting

 fs/btrfs/ctree.h       |  156 ++++++++++-
 fs/btrfs/disk-io.c     |   15 +-
 fs/btrfs/extent-tree.c |  118 ++++++--
 fs/btrfs/ioctl.c       |  214 ++++++++++++-
 fs/btrfs/ioctl.h       |   44 +++
 fs/btrfs/super.c       |    8 +-
 fs/btrfs/volumes.c     |  780 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.h     |   57 ++++-
 8 files changed, 1304 insertions(+), 88 deletions(-)

-- 
1.7.5.4

