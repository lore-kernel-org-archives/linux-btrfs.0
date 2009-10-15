From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Wed, 14 Oct 2009 20:06:37 -0400
Message-ID: <20091015000637.GA3004@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

The master branch of btrfs-unstable:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Has an assortment of bug fixes and performance improvements.  We've
updated the btrfs fsync code to make sure we don't trigger log commits
when the file hasn't changed, and also tuned the log commit writeback.
This makes a pretty big different for rpm and yum.

Also, Christoph Hellwig spent some time testing btrfs discard support
with his qemu code, so I've included his patches to enable that.

Chris Mason (5) commits (+139/-27):
    Btrfs: avoid tree log commit when there are no changes (+71/-16)
    Btrfs: streamline tree-log btree block writeout (+53/-4)
    Btrfs: only write one super copy during fsync (+1/-1)
    Btrfs: always pin metadata in discard mode (+8/-0)
    Btrfs: fix btrfs acl #ifdef checks (+6/-6)

Christoph Hellwig (2) commits (+10/-7):
    Btrfs: enable discard support (+0/-6)
    Btrfs: add -o discard option (+10/-1)

Josef Bacik (1) commits (+24/-3):
    Btrfs: fix possible ENOSPC problems with truncate

Zheng Yan (1) commits (+6/-5):
    Btrfs: properly wait log writers during log sync

Total: (9) commits

 fs/btrfs/acl.c         |    6 +++---
 fs/btrfs/btrfs_inode.h |    6 ++++++
 fs/btrfs/ctree.h       |    4 +++-
 fs/btrfs/disk-io.c     |    2 ++
 fs/btrfs/extent-tree.c |   17 +++++++++++------
 fs/btrfs/file.c        |   41 ++++++++++++++++++++++++++---------------
 fs/btrfs/inode.c       |   33 +++++++++++++++++++++++++++++----
 fs/btrfs/super.c       |    9 +++++++--
 fs/btrfs/transaction.c |   45 ++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/transaction.h |    5 +++++
 fs/btrfs/tree-log.c    |   48 +++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/tree-log.h    |    3 +++
 fs/btrfs/xattr.c       |    2 +-
 13 files changed, 179 insertions(+), 42 deletions(-)
