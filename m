From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 00/11 v2] Btrfs: improve write ahead log with sub transaction
Date: Thu, 26 May 2011 16:19:15 +0800
Message-ID: <1306397966-7834-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <josef@redhat.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

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
complex, it brings us a great deal of performance improvement.

Beside the improvement of log, patch 8 fixes a small but critical bug of log code
with sub transaction.

Here I have some test results to show, I use sysbench to do "random write + fsync".

===
sysbench --test=fileio --num-threads=1 --file-num=2 --file-block-size=4K --file-total-size=8G --file-test-mode=rndwr --file-io-mode=sync --file-extra-flags=  [prepare, run]
===

Sysbench args:
  - Number of threads: 1
  - Extra file open flags: 0
  - 2 files, 4Gb each
  - Block size 4Kb
  - Number of random requests for random IO: 10000
  - Read/Write ratio for combined random IO test: 1.50
  - Periodic FSYNC enabled, calling fsync() each 100 requests.
  - Calling fsync() at the end of test, Enabled.
  - Using synchronous I/O mode
  - Doing random write test

Sysbench results:
===
   Operations performed:  0 Read, 10000 Write, 200 Other = 10200 Total
   Read 0b  Written 39.062Mb  Total transferred 39.062Mb
===
a) without patch:  (*SPEED* : 451.01Kb/sec)
   112.75 Requests/sec executed

b) with patch:     (*SPEED* : 4.3621Mb/sec)
   1116.71 Requests/sec executed

v1->v2: fix a EEXIST by logged_trans and a mismatch by log root generation

Liu Bo (11):
  Btrfs: introduce sub transaction stuff
  Btrfs: update block generation if should_cow_block fails
  Btrfs: modify btrfs_drop_extents API
  Btrfs: introduce first sub trans
  Btrfs: still update inode trans stuff when size remains unchanged
  Btrfs: improve log with sub transaction
  Btrfs: add checksum check for log
  Btrfs: fix a bug of log check
  Btrfs: kick off useless code
  Btrfs: deal with EEXIST after iput
  Btrfs: use the right generation number to read log_root_tree

 fs/btrfs/btrfs_inode.h |   12 ++-
 fs/btrfs/ctree.c       |   69 +++++++++----
 fs/btrfs/ctree.h       |    5 +-
 fs/btrfs/disk-io.c     |   12 +-
 fs/btrfs/extent-tree.c |   10 +-
 fs/btrfs/file.c        |   22 ++---
 fs/btrfs/inode.c       |   33 ++++---
 fs/btrfs/ioctl.c       |    6 +-
 fs/btrfs/relocation.c  |    6 +-
 fs/btrfs/transaction.c |   13 ++-
 fs/btrfs/transaction.h |   19 +++-
 fs/btrfs/tree-defrag.c |    2 +-
 fs/btrfs/tree-log.c    |  267 +++++++++++++++++++++++++++++++++++-------------
 13 files changed, 330 insertions(+), 146 deletions(-)

