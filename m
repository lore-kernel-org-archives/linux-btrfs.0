From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 00/16] Btrfs: fixes and cleanups for 3.1
Date: Thu, 14 Jul 2011 11:15:37 +0800
Message-ID: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The first 4 patches are bug-fixes, and the remaining are small
cleanups that have sit in my git tree for some time.

The first 3 patches have been sent to the list before.

We save some bytes after this patchset:

   text    data     bss     dec     hex filename
 426387    3854    1024  431265   694a1 fs/btrfs/btrfs.o.orig
 425651    3854    1024  430529   691c1 fs/btrfs/btrfs.o

I've run xfstests for testing.

===

Li Zefan (12):
      Btrfs: copy string correctly in INO_LOOKUP ioctl
      Btrfs: fix space leak when skipping small extents during trimming
      Btrfs: fix space leak when trimming free extents
      Btrfs: check the nodatasum flag when writing compressed files
      Btrfs: use wait_event()
      Btrfs: remove a BUG_ON() in btrfs_commit_transaction()
      Btrfs: remove remaining ref-cache code
      Btrfs: make acl functions really no-op if acl is not enabled
      Btrfs: remove redundant code for dir item lookup
      Btrfs: clean up search_extent_mapping()
      Btrfs: clean up code for extent_map lookup
      Btrfs: clean up code for merging extent maps

Xiao Guangrong (4):
      Btrfs: remove unused members from struct extent_state
      Btrfs: clean up for insert_state()
      Btrfs: clean up for wait_extent_bit()
      Btrfs: clean up for find_first_extent_bit()

 fs/btrfs/Makefile           |    4 +-
 fs/btrfs/acl.c              |   17 -----
 fs/btrfs/compression.c      |   14 +++-
 fs/btrfs/ctree.h            |   15 ++++-
 fs/btrfs/dir-item.c         |   30 +--------
 fs/btrfs/extent_io.c        |   80 ++++++++--------------
 fs/btrfs/extent_io.h        |    2 -
 fs/btrfs/extent_map.c       |  155 ++++++++++++++-----------------------------
 fs/btrfs/free-space-cache.c |   43 +++++++-----
 fs/btrfs/ioctl.c            |    3 +-
 fs/btrfs/ref-cache.c        |   68 -------------------
 fs/btrfs/ref-cache.h        |   52 --------------
 fs/btrfs/transaction.c      |   65 +++----------------
 13 files changed, 142 insertions(+), 406 deletions(-)
 delete mode 100644 fs/btrfs/ref-cache.c
 delete mode 100644 fs/btrfs/ref-cache.h

