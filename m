From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 00/21] Btrfs: restriper
Date: Fri,  6 Jan 2012 16:30:48 +0200
Message-ID: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is a respin of restriper patch series which adds an initial
implementation of restriper (it's a clever name for relocation framework
that allows to do selective profile changing and selective balancing
with some goodies like pausing/resuming and reporting progress to the
user).  See userspace cover patch for usage examples.

Changes from posted RFC include minor fixes to address received feedback
and some minor fixes of my own: improved inline comments, pause and
cancelling enhancements to eliminate race conditions, a better
validation of user input, some error reporting and error handling fixes.
Also I did s/restripe/balance to not introduce yet another term into
btrfs.  So nothing major, but the diff got quite large because of the
rename and some code movements.

The series is on top of 3.1 + for-linus, available at:

git://github.com/idryomov/btrfs-unstable.git restriper

Thanks,

		Ilya


Ilya Dryomov (21):
  Btrfs: get rid of *_alloc_profile fields
  Btrfs: introduce masks for chunk type and profile
  Btrfs: add BTRFS_AVAIL_ALLOC_BIT_SINGLE bit
  Btrfs: make avail_*_alloc_bits fields dynamic
  Btrfs: add basic restriper infrastructure
  Btrfs: add basic infrastructure for selective balancing
  Btrfs: profiles filter
  Btrfs: usage filter
  Btrfs: devid filter
  Btrfs: devid subset filter
  Btrfs: virtual address space subset filter
  Btrfs: do not reduce profile in do_chunk_alloc()
  Btrfs: implement online profile changing
  Btrfs: soft profile changing mode (aka soft convert)
  Btrfs: save balance parameters to disk
  Btrfs: recover balance on mount
  Btrfs: add skip_balance mount option
  Btrfs: allow for pausing restriper
  Btrfs: allow for cancelling restriper
  Btrfs: allow for resuming restriper after it was paused
  Btrfs: add balance progress reporting

 fs/btrfs/ctree.h       |  205 ++++++++++++-
 fs/btrfs/disk-io.c     |   18 +-
 fs/btrfs/extent-tree.c |  128 ++++++--
 fs/btrfs/ioctl.c       |  193 +++++++++++-
 fs/btrfs/ioctl.h       |   55 ++++
 fs/btrfs/super.c       |   11 +-
 fs/btrfs/volumes.c     |  803 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.h     |   50 +++-
 8 files changed, 1365 insertions(+), 98 deletions(-)

-- 
1.7.6.3

