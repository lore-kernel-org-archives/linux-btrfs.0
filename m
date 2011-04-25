From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 0/7] Btrfs: New inode number allocator
Date: Mon, 25 Apr 2011 16:57:47 +0800
Message-ID: <4DB5378B.2070904@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs stores the highest objectid of the fs tree, and it always
returns (highest+1) inode number when we create a file, so inode numbers
won't be reclaimed when we delete files, so we'll run out of inode numbers
as we keep create/delete files in 32bits machines.

This patchset aims to fix this, and it works similar to free space caching
for block groups.

I've run xfstests, and I also tested it with snapshot, balance etc.

More testing is appreciated!

Changelog v2:

- Rebased against latest btrfs-unstable tree
- Fixed several small bugs.

---
 fs/btrfs/btrfs_inode.h      |    9 +
 fs/btrfs/compression.c      |    5 +-
 fs/btrfs/ctree.h            |   29 +-
 fs/btrfs/disk-io.c          |   19 +
 fs/btrfs/export.c           |   25 +-
 fs/btrfs/extent-tree.c      |   50 ++-
 fs/btrfs/extent_io.c        |    4 +-
 fs/btrfs/file-item.c        |    5 +-
 fs/btrfs/file.c             |   27 +-
 fs/btrfs/free-space-cache.c |  968 ++++++++++++++++++++++++++-----------------
 fs/btrfs/free-space-cache.h |   48 ++-
 fs/btrfs/inode-map.c        |  428 +++++++++++++++++++-
 fs/btrfs/inode-map.h        |   13 +
 fs/btrfs/inode.c            |  282 +++++++------
 fs/btrfs/ioctl.c            |   22 +-
 fs/btrfs/relocation.c       |   27 +-
 fs/btrfs/transaction.c      |   13 +-
 fs/btrfs/tree-log.c         |   54 ++--
 fs/btrfs/xattr.c            |    8 +-
 19 files changed, 1402 insertions(+), 634 deletions(-)
