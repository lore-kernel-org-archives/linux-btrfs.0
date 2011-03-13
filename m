From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fixes for 2.6.38
Date: Sun, 13 Mar 2011 10:34:03 -0400
Message-ID: <1300026223-sup-1330@think>
Content-Type: text/plain; charset=UTF-8
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"Linus Torvalds" <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

We've been working on a few important Btrfs regressions for the last two
weeks, and this pull request has the result.  Many thanks to Mitch
Harder and Xin Zhong for nailing down the btrfs_file_write looping.

Linus, please pull the master branch of the btrfs unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

These commits keep btrfs_file_write from looping forever when things go
wrong with copy_from_user, and they also make sure not to produce
partially up to date pages if copy_from_user gives us a short return.

Hammering on btrfs fiemap found another bug where we returned
overlapping extents, which made for incorrect results with the cp
program (destination files larger than the original).

This pull also has a commit to tweak our forced delalloc writeback while
we are trying to reclaim space.  With a number of writers determined to
fill the FS, we used to end up stuck in shrink_delalloc forever.

Chris Mason (4) commits (+131/-60):
    Btrfs: make sure not to return overlapping extents to fiemap (+27/-6)
    Btrfs: deal with short returns from copy_from_user (+13/-0)
    Btrfs: fix regressions in copy_from_user handling (+59/-42)
    Btrfs: break out of shrink_delalloc earlier (+32/-12)

Miao Xie (1) commits (+3/-2):
    btrfs: fix not enough reserved space

Daniel J Blueman (1) commits (+1/-0):
    btrfs: fix dip leak

Total: (6) commits (+135/-62)

 fs/btrfs/ctree.h       |    9 ++++
 fs/btrfs/extent-tree.c |   35 ++++++++++-----
 fs/btrfs/extent_io.c   |   33 +++++++++++---
 fs/btrfs/file.c        |  114 ++++++++++++++++++++++++++++++------------------
 fs/btrfs/inode.c       |    6 ++-
 5 files changed, 135 insertions(+), 62 deletions(-)
