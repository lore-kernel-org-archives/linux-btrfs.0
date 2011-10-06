From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v0 00/18] btfs: Subvolume Quota Groups
Date: Thu,  6 Oct 2011 17:54:10 +0200
Message-ID: <cover.1317915010.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a first draft of a subvolume quota implementation. It is possible
to limit subvolumes and any group of subvolumes and also to track the amount
of space that will get freed when deleting snapshots.

The current version is functionally incomplete, with the main missing feature
being the initial scan and rescan of an existing filesystem.

I put some effort into writing an introduction into the concepts and
implementation which can be found at

http://sensille.com/qgroups.pdf

The purpose of getting it out in this early stage is to get as much input
as possible, in regard to concepts, implementation and testing.
The accompanying user mode parts will take some additional days to gather.

Thanks,
Arne

Arne Jansen (18):
  btrfs: mark delayed refs as for cow
  btrfs: always save ref_root in delayed refs
  btrfs: add nested locking mode for paths
  btrfs: qgroup on-disk format
  btrfs: add helper for tree enumeration
  btrfs: check the root passed to btrfs_end_transaction
  btrfs: generic data structure to build unique lists
  btrfs: added helper to create new trees
  btrfs: qgroup state and initialization
  btrfs: Test code to change the order of delayed-ref processing
  btrfs: add sequence numbers to delayed refs
  btrfs: put back delayed refs that are too new
  btrfs: qgroup implementation and prototypes
  btrfs: quota tree support and startup
  btrfs: hooks for qgroup to record delayed refs
  btrfs: hooks to reserve qgroup space
  btrfs: add qgroup ioctls
  btrfs: add qgroup inheritance

 fs/btrfs/Makefile      |    3 +-
 fs/btrfs/ctree.c       |  114 +++-
 fs/btrfs/ctree.h       |  224 +++++-
 fs/btrfs/delayed-ref.c |  188 ++++--
 fs/btrfs/delayed-ref.h |   48 +-
 fs/btrfs/disk-io.c     |  130 +++-
 fs/btrfs/disk-io.h     |    3 +
 fs/btrfs/extent-tree.c |  185 ++++-
 fs/btrfs/extent_io.c   |    1 +
 fs/btrfs/extent_io.h   |    2 +
 fs/btrfs/file.c        |   10 +-
 fs/btrfs/inode.c       |    2 +-
 fs/btrfs/ioctl.c       |  247 +++++-
 fs/btrfs/ioctl.h       |   62 ++-
 fs/btrfs/locking.c     |   51 ++-
 fs/btrfs/locking.h     |    2 +-
 fs/btrfs/qgroup.c      | 2151 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/relocation.c  |   18 +-
 fs/btrfs/transaction.c |   45 +-
 fs/btrfs/transaction.h |    8 +
 fs/btrfs/tree-log.c    |    2 +-
 fs/btrfs/ulist.c       |  122 +++
 fs/btrfs/ulist.h       |   59 ++
 23 files changed, 3501 insertions(+), 176 deletions(-)
 create mode 100644 fs/btrfs/qgroup.c
 create mode 100644 fs/btrfs/ulist.c
 create mode 100644 fs/btrfs/ulist.h

-- 
1.7.3.4

