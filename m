From: Josef Bacik <josef@redhat.com>
Subject: [GIT PULL] Btrfs updates for 3.1
Date: Fri, 01 Jul 2011 16:39:45 -0400
Message-ID: <4E0E3091.9060704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey Chris,

Since I'm going on vacation next week I wanted to get everything ready for you
in case you get bored with fsck and want to put together a 3.1 tree :).  If you
can pull

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git for-chris

It is based on your for-linus branch.  Here is the shortlog and diffstat

Josef Bacik (7):
      Btrfs: try to only do one btrfs_search_slot in do_setxattr
      Btrfs: do transaction space reservation before joining the transaction
      Btrfs: serialize flushers in reserve_metadata_bytes
      Btrfs: use the normal checksumming infrastructure for free space cache
      Btrfs: fix how we merge extent states and deal with cached states
      Btrfs: use a worker thread to do caching
      Btrfs: don't panic if we get an error while balancing

 fs/btrfs/ctree.h            |   10 ++-
 fs/btrfs/dir-item.c         |    9 +--
 fs/btrfs/disk-io.c          |    6 ++
 fs/btrfs/extent-tree.c      |  136 +++++++++++++++++------------------
 fs/btrfs/extent_io.c        |   23 +++---
 fs/btrfs/free-space-cache.c |  169 +++++++++++++++----------------------------
 fs/btrfs/transaction.c      |   36 +++++-----
 fs/btrfs/volumes.c          |    3 +-
 fs/btrfs/xattr.c            |   54 +++++++-------
 9 files changed, 196 insertions(+), 250 deletions(-)

Thanks,

Josef
