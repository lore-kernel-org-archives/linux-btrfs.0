From: Chris Mason <chris.mason@oracle.com>
Subject: Integration branch pushed out to btrfs-unstable
Date: Mon, 23 May 2011 15:54:33 -0400
Message-ID: <1306179381-sup-443@shiny>
Content-Type: text/plain; charset=UTF-8
Cc: Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
	"Arne Jansen" <sensille@gmx.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've pushed out my current kernel git tree to a new branch called
integration-test.  This is meant for integration testing only and should
not be run by anyone who doesn't love crashes.

I've pulled together a lot of important work from a lot of different
people.  It includes:

The new inode number allocator
Delayed inode and directory item updates
Scrub, chunk allocator fixes
Races in device addition and removal
Josef's performance fixes
A large series of cleanups and fixes

Most of the integration work was just pushing the cleanups into the new
code bits.  I still want to integrate Hugo Mills' balance progress
ioctls (really nice).  But it was a lot of work to get this all working
together and I wanted to let everyone retest the result.

Miao, I didn't include your patch to delay inode item insertion because
I was worried about interactions with the caching thread of the new
inode number allocator.  I did have to make a small change to make sure
the inode-map cache didn't go through the delayed item routines.

Li, one thing I haven't done yet is a lot of benchmarking on the
performance hit from waiting for the cache to fill on large existing
filesystems.  Was there any particular reason you didn't setup the
caching to pre-cache the from root->highest_objectid to
BTRFS_LAST_FREE_OBJECTID?

diffstat for my current tree:

-chris

]# git diff --stat v2.6.39...HEAD
 fs/btrfs/Makefile           |    2 +-
 fs/btrfs/acl.c              |    2 +-
 fs/btrfs/btrfs_inode.h      |   14 +
 fs/btrfs/compression.c      |   47 +-
 fs/btrfs/compression.h      |    2 +-
 fs/btrfs/ctree.c            |   51 +-
 fs/btrfs/ctree.h            |  199 ++---
 fs/btrfs/delayed-inode.c    | 1695 ++++++++++++++++++++++++++++++++++++
 fs/btrfs/delayed-inode.h    |  141 +++
 fs/btrfs/delayed-ref.c      |  114 ---
 fs/btrfs/delayed-ref.h      |    6 -
 fs/btrfs/dir-item.c         |   39 +-
 fs/btrfs/disk-io.c          |  202 +++---
 fs/btrfs/disk-io.h          |   19 +-
 fs/btrfs/export.c           |   25 +-
 fs/btrfs/extent-tree.c      | 2014 ++++---------------------------------------
 fs/btrfs/extent_io.c        |  327 ++------
 fs/btrfs/extent_io.h        |   40 +-
 fs/btrfs/extent_map.c       |    8 +-
 fs/btrfs/extent_map.h       |    4 +-
 fs/btrfs/file-item.c        |   38 +-
 fs/btrfs/file.c             |   45 +-
 fs/btrfs/free-space-cache.c |  993 +++++++++++++---------
 fs/btrfs/free-space-cache.h |   48 +-
 fs/btrfs/inode-item.c       |    2 -
 fs/btrfs/inode-map.c        |  428 +++++++++-
 fs/btrfs/inode-map.h        |   13 +
 fs/btrfs/inode.c            |  688 ++++++---------
 fs/btrfs/ioctl.c            |  176 ++++-
 fs/btrfs/ioctl.h            |   76 ++
 fs/btrfs/locking.c          |   25 -
 fs/btrfs/locking.h          |    2 -
 fs/btrfs/ref-cache.c        |  164 ----
 fs/btrfs/ref-cache.h        |   24 -
 fs/btrfs/relocation.c       |   67 +-
 fs/btrfs/root-tree.c        |   61 +--
 fs/btrfs/scrub.c            | 1368 +++++++++++++++++++++++++++++
 fs/btrfs/super.c            |   44 +-
 fs/btrfs/sysfs.c            |   77 --
 fs/btrfs/transaction.c      |  196 ++---
 fs/btrfs/transaction.h      |    5 +-
 fs/btrfs/tree-defrag.c      |    2 +-
 fs/btrfs/tree-log.c         |  208 +++--
 fs/btrfs/tree-log.h         |    1 -
 fs/btrfs/version.sh         |   43 -
 fs/btrfs/volumes.c          |  657 ++++++---------
 fs/btrfs/volumes.h          |   27 +-
 fs/btrfs/xattr.c            |   12 +-
 48 files changed, 5902 insertions(+), 4539 deletions(-)
