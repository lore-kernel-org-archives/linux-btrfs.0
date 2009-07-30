From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates for 2.6.31-rc
Date: Thu, 30 Jul 2009 13:56:39 -0400
Message-ID: <20090730175639.GF5021@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751757AbZG3R4x@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

We've added two small incrementals for the btrfs async block group
caching.  One fixes a race between the caching thread and transaction
commit.  We haven't seen this one triggered in testing, but it still is
a valid fix.

The second patch makes sure the caching threads don't stall
transaction commits.

Linus, both of these are in the master branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

Chris Mason (1) commits (+14/-2):
    Btrfs: be more polite in the async caching threads

Yan Zheng (1) commits (+14/-10):
    Btrfs: preserve commit_root for async caching

Total: (2) commits

 fs/btrfs/ctree.h       |    4 +---
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/extent-tree.c |   11 ++++++-----
 fs/btrfs/transaction.c |   22 +++++++++++++++++++---
 fs/btrfs/transaction.h |    1 +
 5 files changed, 28 insertions(+), 12 deletions(-)
