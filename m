From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v3 0/8] Btrfs: scrub: print path to corrupted files and trigger nodatasum fixup
Date: Thu,  7 Jul 2011 17:48:25 +0200
Message-ID: <cover.1310053204.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch set introduces two new features for scrub. They share the backref
iteration code which is the reason they made it into the same patch set.

The first feature adds printk statements in case scrub finds an error which list
all affected files. You will need patch 1, 2 and 3 for that.

The second feature adds the trigger which enables us to correct i/o errors in
case the affected extent does not have a checksum (nodatasum), eventually. You
will need patch 1, 4, 5 and 6 for that.

I tried to apply all patches to the current cmason/for-linus branch and to
Arne's current for-chris branch. They do apply with no errors (some offsets
possible).

Please review.

Next I'm starting to make up my mind how to implement on-the-fly error
correction correctly. This will enable us to rewrite good data whenever we
encounter a bad copy. I have some preliminary patches already, the stress in the
first sentence is on "correctly". The second feature mentioned in this patch
series will then automatically use that code, too.

Changelog v1->v2:
- Various cleanup, sensible error codes as suggested by David Sterba

Changelog v2->v3:
- evaluation and iteration of shared refs
- support for in-tree refs (v2 iterated inline refs only)
- never call an interator function without releasing the path
- iterate_irefs now returns -ENOENT in case no refs are found
- some stupid bugs removed where release_path was called too early
- ioctls added to provide new functions to user mode
- bugfixes for cases where search_slot found the very end of a leaf
- bugfix: use right fs root for readpage instead of fs_root->fs_info
- based on current cmason/for-linus

A patch series to use the new ioctls from usermode will follow shortly. Please
try it and report errors (or confirm there are none, of course).

-Jan

Jan Schmidt (8):
  added helper functions to iterate backrefs
  scrub: added unverified_errors
  scrub: print paths of corrupted files
  scrub: bugfix: mirror_num off by one
  add mirror_num to extent_read_full_page
  scrub: use int for mirror_num, not u64
  scrub: add fixup code for errors on nodatasum files
  new ioctls to do logical->inode and inode->path resolving

 fs/btrfs/Makefile    |    3 +-
 fs/btrfs/backref.c   |  748 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/backref.h   |   62 +++++
 fs/btrfs/disk-io.c   |    2 +-
 fs/btrfs/extent_io.c |    6 +-
 fs/btrfs/extent_io.h |    3 +-
 fs/btrfs/inode.c     |    2 +-
 fs/btrfs/ioctl.c     |  134 +++++++++
 fs/btrfs/ioctl.h     |   29 ++
 fs/btrfs/scrub.c     |  412 +++++++++++++++++++++++++---
 10 files changed, 1362 insertions(+), 39 deletions(-)
 create mode 100644 fs/btrfs/backref.c
 create mode 100644 fs/btrfs/backref.h

-- 
1.7.3.4

