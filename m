From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 00/10] Btrfs: backref walking rewrite
Date: Wed,  4 Jan 2012 18:35:38 +0100
Message-ID: <cover.1325692560.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch series is a major rewrite of the backref walking code. The patch
series Arne sent some weeks ago for quota groups had a very interesting
function, find_all_roots. I took this from him together with the bits needed
for find_all_roots to work and replaced a major part of the code in backref.c
with it.

It can be pulled from
	git://git.jan-o-sch.net/btrfs-unstable for-chris
There's also a gitweb for that repo on
	http://git.jan-o-sch.net/?p=btrfs-unstable

My old backref code had several problems:
- it relied on a consistent state of the trees in memory
- it ignored delayed refs
- it only featured rudimentary locking
- it could miss some references depending on the tree layout

The biggest advantage is, that we're now able to do reliable backref resolving,
even on busy file systems. So we've got benefits for:
- the existing "btrfs inspect-internal" commands
- aforementioned qgroups (patches on the list)
- "btrfs send" (currently in development)
- snapshot-aware defrag
- ... possibly more to come

Splitting the needed bits out of Arne's code was a quite intrusive operation. In
case this goes into 3.3, any of us will soon make a rebased version of the
qgroup patch set. Things corrected/changed in Arne's code along the way:
- don't assume INODE_ITEMs and the corresponding EXTENT_DATA items are in the
  same leaf (use the correct EXTENT_DATA_KEY for tree searches)
- don't assume all EXTENT_DATA items with the same backref for the same inode
  are in the same leaf (__resolve_indirect_refs can now add more refs)
- added missing key and level to prelim lists for shared block refs
- delayed ref sequence locking ability without wasting sequence numbers
- waitqueue instead of busy waiting for more delayed refs

As this touches a critical part of the file system, I also did some speed
benchmarks. It turns out that dbench shows no performance decrease on my
hardware. I can do more tests if desired.

By the way: this patch series fixes xfstest 278 (to be published soon) :-)

-Jan

---
Changelog v1->v2:
- nested locking is now allowed implicitly, not only when path->nested is set
- force-pushed new version to mentioned git repo
---
Arne Jansen (6):
  Btrfs: generic data structure to build unique lists
  Btrfs: mark delayed refs as for cow
  Btrfs: always save ref_root in delayed refs
  Btrfs: add nested locking mode for paths
  Btrfs: add sequence numbers to delayed refs
  Btrfs: put back delayed refs that are too new

Jan Schmidt (4):
  Btrfs: added helper btrfs_next_item()
  Btrfs: add waitqueue instead of doing busy waiting for more delayed
    refs
  Btrfs: added btrfs_find_all_roots()
  Btrfs: new backref walking code

 fs/btrfs/Makefile      |    2 +-
 fs/btrfs/backref.c     | 1131 +++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/backref.h     |    5 +
 fs/btrfs/ctree.c       |   42 +-
 fs/btrfs/ctree.h       |   24 +-
 fs/btrfs/delayed-ref.c |  153 +++++--
 fs/btrfs/delayed-ref.h |  104 ++++-
 fs/btrfs/disk-io.c     |    3 +-
 fs/btrfs/extent-tree.c |  187 ++++++--
 fs/btrfs/extent_io.c   |    1 +
 fs/btrfs/extent_io.h   |    2 +
 fs/btrfs/file.c        |   10 +-
 fs/btrfs/inode.c       |    2 +-
 fs/btrfs/ioctl.c       |   13 +-
 fs/btrfs/locking.c     |   53 +++-
 fs/btrfs/relocation.c  |   18 +-
 fs/btrfs/scrub.c       |    7 +-
 fs/btrfs/transaction.c |    9 +-
 fs/btrfs/tree-log.c    |    2 +-
 fs/btrfs/ulist.c       |  220 ++++++++++
 fs/btrfs/ulist.h       |   68 +++
 21 files changed, 1638 insertions(+), 418 deletions(-)
 create mode 100644 fs/btrfs/ulist.c
 create mode 100644 fs/btrfs/ulist.h

-- 
1.7.3.4

