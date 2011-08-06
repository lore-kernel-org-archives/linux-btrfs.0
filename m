From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 00/12 v5] Btrfs: improve write ahead log with sub transaction
Date: Sat, 6 Aug 2011 17:37:35 +0800
Message-ID: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've fixed a bug and rebased this to the latest for-linus branch,
and with applying my previous posted patch:

	[PATCH] Btrfs: fix an oops of log replay

, I also test this sub transaction patchset with
a) sysbench 0.4.12 tool and
b) Chris's synctest tool in both _crash_ and _uncrash_ cases, and it works well.

Please test this and feel free to notice me if there are any problems.
Hope that it can get through with no bugs and be ready for merge this time :)

===
I've been working to try to improve the write-ahead log's performance,
and I found that the bottleneck addresses in the checksum items,
especially when we want to make a random write on a large file, e.g a 4G file.

Then a idea for this suggested by Chris is to use sub transaction ids and just
to log the part of inode that had changed since either the last log commit or
the last transaction commit.  And as we also push the sub transid into the btree
blocks, we'll get much faster tree walks.  As a result, we abandon the original
brute force approach, which is "to delete all items of the inode in log",
to making sure we get the most uptodate copies of everything, and instead
we manage to "find and merge", i.e. finding extents in the log tree and merging
in the new extents from the file.

This patchset puts the above idea into code, and although the code is now more
complex, it brings us a great deal of performance improvement:

in my sysbench "write + fsync" test:

        451.01Kb/sec -> 4.3621Mb/sec

In v2, thanks to Chris, we worked together to solve 2 bugs, and after that it
works as expected.
In v3, thanks to Josef, we simplify several code.
In v4, rebase to the latest for-linus branch, Chris hit two problems, and we
solve them.

Since there are some vital changes in recent rc, like "kill trans_mutex" and
"use cur_trans", as David asked, I rebase the patchset to the latest for-linus
branch.

More tests are welcome!


Liu Bo (12):
  Revert "Btrfs: do not flush csum items of unchanged file data during
    treelog"
  Btrfs: introduce sub transaction stuff
  Btrfs: update block generation if should_cow_block fails
  Btrfs: modify btrfs_drop_extents API
  Btrfs: introduce first sub trans
  Btrfs: still update inode trans stuff when size remains unchanged
  Btrfs: improve log with sub transaction
  Btrfs: add checksum check for log
  Btrfs: fix a bug of log check
  Btrfs: kick off useless code
  Btrfs: do not iput inode when inode is still in log
  Btrfs: use the right generation number to read log_root_tree

 fs/btrfs/btrfs_inode.h |   12 ++-
 fs/btrfs/ctree.c       |   87 +++++++++++++------
 fs/btrfs/ctree.h       |    5 +-
 fs/btrfs/disk-io.c     |   23 ++++--
 fs/btrfs/extent-tree.c |   10 ++-
 fs/btrfs/file.c        |   22 ++---
 fs/btrfs/inode.c       |   39 ++++++---
 fs/btrfs/ioctl.c       |    6 +-
 fs/btrfs/relocation.c  |    6 +-
 fs/btrfs/transaction.c |   13 ++-
 fs/btrfs/transaction.h |   19 ++++-
 fs/btrfs/tree-defrag.c |    2 +-
 fs/btrfs/tree-log.c    |  225 ++++++++++++++++++++++++++++++++----------------
 13 files changed, 312 insertions(+), 157 deletions(-)

